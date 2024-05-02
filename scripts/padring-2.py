# Copyright 2024 Chip USM - UTFSM
# Developed by: Aquiles Viza
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import sys
from pathlib import Path
import yaml
import pya

from pprint import pprint

from pya import Cell, DCellInstArray, DPoint, DTrans, DVector, DCplxTrans, Layout

import os

usage_help = """
Usage: klayout -r padring.py -rd padring_file=<YAML_DESCRIPTION> gds_file=<DESTINATION_GDS>
"""


def klayout_clean_layout():
    app: pya.Application = pya.Application.instance()
    layout_view: pya.LayoutView = app.main_window().current_view()
    if layout_view is None:
        return

    cell_view: pya.CellView = layout_view.active_cellview()
    cell = cell_view.cell

    if cell is None:
        return

    layout = cell.layout()

    for idx in layout.each_top_cell():
        # print(f"{idx} - {layout.cell(idx).name}")
        layout.cell(idx).prune_subcells(-1)

        if layout.cell(idx).name == "TOP":
            continue

        layout.delete_cell(idx)


def klayout_get_cell(cell_name):

    print(" 1 ")
    app: pya.Application = pya.Application.instance()
    app.set_config("grid-micron", "0.005")

    print(" 2 ")

    layout_view: pya.LayoutView = app.main_window().current_view()
    if layout_view is None:
        print(" 2.5 ")
        print("Layout View not instanciated")
        tech = "gf180mcu"
        mode = 0
        app.main_window().create_layout(tech, mode)

        layout_view = app.main_window().current_view()

    print(" 3 ")

    cell_view: pya.CellView = layout_view.active_cellview()
    cell = cell_view.cell

    if cell is None:
        print(" 3.5 ")
        print("Cell not instanciated")
        cell_view.layout().dbu = 0.005
        cell_view.layout().create_cell(cell_name)
        cell_view.set_cell_name(cell_name)

    else:
        cell_view.layout().rename_cell(cell.cell_index(), cell_name)

    print(" 4 ")

    return cell


def klayout_set_visual_configuration():
    app: pya.Application = pya.Application.instance()
    layout_view = app.main_window().current_view()

    layout_view.add_missing_layers()
    layout_view.zoom_fit()


class Padring:
    def __init__(self, top_cell: Cell, cell_sources: list[str | Path]):
        """
        TODO: Eventually we could use a toml, yaml file to describe the padring.
        TODO: Add into the yaml file a list of source gds
        TODO: Add into the yaml file the gap between pad cells
        TODO: Add into the yaml file pad sizing information, to tell if padring closes before placement
        """
        # Dimensions

        # Observational measure
        self.gap: DVector = DVector(0.16, 0)

        # Padring cell stuff

        self.cell: Cell = top_cell

        # Loading cell

        for cell_source in cell_sources:
            cell_source = Path(cell_source)
            if not cell_source.exists():
                raise ValueError(f"Source {cell_source} don't exists")

            top_cell.layout().read(cell_source)

        # This could be filled with an argument.
        # Maybe from an external file.
        self.mapping: dict[str, Cell] = dict()

        # Sections are stored as lists that contains:
        # - cell names
        # - cell aliases
        # - section names
        # Avoid recursion doing verifications while inserting and reading sections

        # Holds ordered subsets of cell names
        # Before adding any entry, all the content should be resolved to gds cellnames
        self.sections: dict[str, list[str]] = dict()

        # Almost Always, the corner is an exception.
        # All cells have the same height. (Except corner)
        # All cells has a little "gap" to the left when see bbox (Except Corner)
        # All cells have base (0, 0) on bottom left corner plus the gap.

    def generate(self, content: dict[str, dict]):
        if "aliases" in content.keys():
            aliases: dict[str, str] = content["aliases"]
            pprint(aliases)

            for alias, cellname in aliases.items():
                self.register_alias(alias, cellname)

        # TODO: register_sections should create lists only, not entire cells.
        if "sections" in content.keys():
            sections: dict[str, list[str]] = content["sections"]

            for section, cells in sections.items():
                self.register_section(section, cells)

        sides = content["sides"]

        bottom = self.resolve_content(sides["bottom"])
        right = self.resolve_content(sides["right"])
        top = self.resolve_content(sides["top"])
        left = self.resolve_content(sides["left"])

        self.draw(bottom, right, top, left)

    def get_cell(self, cellalias: str | None = None) -> Cell:
        """Get an alias from cell mapping dictionary. By default gives padring cell"""
        if cellalias is None:
            return self.cell

        if cellalias in self.mapping.keys():
            return self.mapping[cellalias]
        
        if self.cell.layout().cell(cellalias):
            return self.cell.layout().cell(cellalias)

        raise ValueError(f"{cellalias} is not a cell")
    
    def resolve_name(self, name: str) -> list[str]:
        if name in self.sections:
            return self.sections[name]
        
        if name in self.mapping:
            return [self.mapping[name].name]

        if self.cell.layout().cell(name):
            return [name]

        raise ValueError(f"name {name} doesn't corresponds to a cell, alias nor section")
    
    def resolve_content(self, contents: list[str]) -> list[str]:
        translated_content = list()

        for content in contents:
            translated_content += self.resolve_name(content)
        
        return translated_content

    def register_section(self, name: str, section_content: list[str]):
        print(f"Adding section '{name}': {section_content}")

        # The cellnames should be resolved before registering the section
        translated_sections = list()

        # Verifications to avoid recursion
        if self.cell.layout().cell(name):
            raise ValueError("Section name is equivalent to a cell name")
        
        if name in self.mapping.keys():
            raise ValueError(f"Section name already exists or it's an alias")

        for cell in section_content:
            if cell == name:
                # This section contains self reference
                raise ValueError("Section is referencing itself")


        for element in section_content:
            translated_sections += self.resolve_name(element)
        
        self.sections[name] = translated_sections

        return
        section_cell: Cell = self.cell.layout().create_cell(name)

        base = DPoint()

        for padname in cells:
            pad: Cell = self.get_cell(padname)

            section_cell.insert(DCellInstArray(pad, DTrans(base)))
            base += DVector(pad.dbbox().right, 0) - self.gap

        self.mapping[name] = section_cell

    def register_alias(self, name, cellname):
        """
        Defines a string that represents a subsection of any side.
        """
        if self.cell.layout().cell(name):
            print(f"Alias {name} exists as cell")
            return

        if name in self.mapping.keys():
            print(f"Alias {name} already registered")

        cell = self.cell.layout().cell(cellname)
        if not cell:
            raise ValueError(f"Cell {cellname} doesn't exists")

        self.mapping[name] = cell

    def delete_cell(self, cellname):
        """TODO: This should be done externally"""
        cell = self.cell.layout().cell(cellname)
        if not cell:
            raise ValueError(f"cell {cellname} don't exists")

        cell.prune_subcells(-1)
        self.cell.layout().delete_cell(cell.cell_index())

    def generate_side(self, side_content, name: str):
        padring_side_name = f"padring_side_{name}"

        padring_side = self.cell.layout().cell(padring_side_name)
        if padring_side:
            return padring_side

        padring_side = self.cell.layout().create_cell(padring_side_name)

        base = DPoint()

        # Add Corner
        corner = self.get_cell("cor")

        padring_side.insert(DCellInstArray(corner, DTrans(base)))
        base += DVector(corner.dbbox().right, 0) - self.gap

        # Add pads, fillers and breaks
        for padname in side_content:
            pad = self.get_cell(padname)

            padring_side.insert(DCellInstArray(pad, DTrans(base)))
            base += DVector(pad.dbbox().right, 0) - self.gap

        return padring_side

    def draw(self, bottom_pads, right_pads, top_pads, left_pads):
        """Pads should be described in anti clockwise manner starting from bottom."""
        self.padring_base = DVector()

        if bottom_pads:
            self._put_side(self.generate_side(bottom_pads, "bottom"), 0)
        if right_pads:
            self._put_side(self.generate_side(right_pads, "right"), 90)
        if top_pads:
            self._put_side(self.generate_side(top_pads, "top"), 180)
        if left_pads:
            self._put_side(self.generate_side(left_pads, "left"), 270)

        self.padring_base = DVector()

    def _put_side(self, side_cell: Cell, rotation: float):
        side_box = side_cell.dbbox()
        self.cell.insert(
            DCellInstArray(side_cell, DCplxTrans(1, rotation, False, self.padring_base))
        )
        self.padring_base += (
            side_box.p2 + DVector(side_box.height(), -side_box.height()) - 2 * self.gap
        ) * DCplxTrans(1, rotation, False, DVector())


def main(padring_file: str):

    with open(padring_file) as f:
        content = yaml.load(f, Loader=yaml.CLoader)

    padring_name = "PADRING"
    if "name" in content.keys():
        padring_name = content["name"]

    klayout_clean_layout()

    cell = klayout_get_cell(padring_name)

    # We can have multiple gds sources to pads.
    # TODO: Allow yaml file contain this references with environment variables.
    cell_sources = {
        f"{os.environ['PDK_ROOT']}/gf180mcuD/libs.ref/gf180mcu_fd_io/gds/gf180mcu_fd_io.gds"
    }

    padring_gen = Padring(cell, cell_sources)

    padring_gen.generate(content)

    klayout_set_visual_configuration()

    exit()


if __name__ == "__main__":
    # name-main:    Handles klayout parameters -rb
    # main:         Creates/reads a gds and turn yaml into dict()
    # Padring:      Turns dict() into a padring layout

    # TODO: How to pass arguments like this on macro development?

    """
    Use python or klayout to run this
    """

    global padring_file

    try:
        padring_file = Path(padring_file).resolve()

        if not padring_file.exists():
            raise ValueError("padring file doesn't exist")

    except ValueError as e:
        print(type(e))
        print(usage_help)
        exit(-1)

    except NameError as e:
        print("Parameter missing")
        print(usage_help)
        exit(-1)

    main(padring_file)
