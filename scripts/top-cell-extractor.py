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

from pathlib import Path

from pprint import pprint

import pya
from pya import Cell, DCellInstArray, DPoint, DTrans, DVector, DCplxTrans, Layout

usage_help = """
Usage: klayout -r top-cell-extractor.py -rd layout=<LAYOUT_FILE> output_dir=<DESTINATION_DIR>
"""


def main(layout_file: Path, output_dir: Path):
    layout = pya.Layout()

    layout.read(layout_file)

    for idx in layout.each_top_cell():
        cell_name = layout.cell(idx).name
        print(f"{idx} - {cell_name}")

        if layout.cell(idx).name == "TOP":
            continue

        dir = Path(output_dir / cell_name / "layout")
        dir.mkdir(parents=True)

        layout.cell(idx).write(f"{str(dir / cell_name)}.gds")


if __name__ == "__main__":
    """
    Use python or klayout to run this
    """

    global output_dir
    global layout

    try:
        output_dir = Path(output_dir).resolve()

        if not output_dir.exists():
            raise ValueError("Layout directory doesn't exist")

        layout = Path(layout).resolve()

        if not layout.exists():
            raise ValueError("Output directory doesn't exist")

    except ValueError as e:
        print(type(e))
        print(usage_help)
        exit(-1)

    except NameError as e:
        print(e)
        print("Parameter missing")
        print(usage_help)
        exit(-1)

    main(layout_file=layout, output_dir=output_dir)
