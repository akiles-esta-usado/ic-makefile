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

.ONESHELL:

# == Variables == #

# ---------------------------------------------------------------------------- #
LOG_MAGIC=$(LOG_DIR)/$(TIMESTAMP_TIME)_magic_$(TOP).log
LOG_MAGIC_LVS=$(LOG_DIR)/$(TIMESTAMP_TIME)_magic_lvs_$(TOP).log
LOG_MAGIC_PEX=$(LOG_DIR)/$(TIMESTAMP_TIME)_magic_pex_$(TOP).log

MAGIC=magic -rcfile $(MAGIC_RCFILE) -noconsole
MAGIC_BATCH=$(MAGIC) -nowindow -dnull

MAG_DIR=$(abspath $(MODULE_DIR)/mag)
MAG=$(abspath $(MAG_DIR)/$(TOP).mag)

MAGIC_REPORT_DRC=$(REPORT_DIR)/magic_drc.log

# ---------------------------------------------------------------------------- #
# Both Magic and Klayout could define a substrate naming.
# For PEX extraction this value should be 0.
MAGIC_ROUTINE__SET_SUB=set SUB 0
ifneq (,$(GND_NAME))
MAGIC_ROUTINE__SET_SUB=set SUB $(GND_NAME)
endif

# ---------------------------------------------------------------------------- #
# https://open-source-silicon.slack.com/archives/C04MJUYP99V/p1711644686080599
# From Tim Edwards:
# - cthresh:    won't make the simulation faster, but 0.1 could avoid "trivially small parasitics"
# - rthresh:    Never use. Generates lumped resistance and those are not handled by the tools.
# - extresists: Produces parasitic resistance.
# - extresist tolerance: Might reduce parasitic resistance count, but should be set for each case.
# - set SUB 0: Always use it when doing PEX extraction.
#
# Origintal tolerance set to "all"
PEX_TOLERANCE:=

MAGIC_ROUTINE_PEX__TOLERANCE=tolerance 10
ifneq (,$(PEX_TOLERANCE))
ifeq (all,$(PEX_TOLERANCE))
MAGIC_ROUTINE_PEX__TOLERANCE=all
else
MAGIC_ROUTINE_PEX__TOLERANCE=tolerance $(PEX_TOLERANCE)
endif
endif

# ---------------------------------------------------------------------------- #
# LVS Extraction could be done on a flatted design.
MAGIC_FORCE_FLAT:=

MAGIC_ROUTINE_LVS__RENAME_OR_FLAT=cellname rename $(GDS_CELL) $(GDS_CELL)_clean
ifneq (,$(MAGIC_FORCE_FLAT))
define MAGIC_ROUTINE_LVS__RENAME_OR_FLAT =
flatten $(GDS_CELL)_clean
load $(GDS_CELL)_clean
endef
endif

# ---------------------------------------------------------------------------- #
# Cells with _FLAT suffix got flattened
define FLATGLOB +=

gds flatglob *_FLAT*
endef


ifeq (sky130A,$(PDK)) # === SKY130 Specific configurations =====================

define FLATGLOB =
gds flatglob *sky130_fd_pr__*
gds flatglob *res_poly*
gds flatglob mim_cap*
endef

# TODO: Fix when readspice changes the TOP CELL.
define MAGIC_ROUTINE_LOAD__READSPICE_ALWAYS =
readspice $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
endef


else ifeq (gf180mcuD,$(PDK)) # === GF180 Specific configurations ===============

define FLATGLOB =

# Each pattern should be the most specific as posible
# This can erase complete subcircuits if care is not taken

# Fet patterns
gds flatglob pfet
gds flatglob pfet$$\[0-9\]*
gds flatglob nfet
gds flatglob nfet$$\[0-9\]*

# Passive Devices patterns
gds flatglob ppolyf_u_high_Rs_resistor
gds flatglob ppolyf_u_high_Rs_resistor$$\[\0-9\]*
gds flatglob ppolyf_u_resistor
gds flatglob ppolyf_u_resistor$$\[\0-9\]*

gds flatglob cap_mim*
gds flatglob cap_mim$$\[\0-9\]*

gds flatglob \[np\]*_bjt*
gds flatglob \[np\]*_\[_xp0-9\]*

# Building Devices
gds flatglob via*
gds flatglob via-*
gds flatglob via_*
gds flatglob via_dev$$\[0-9\]*
gds flatglob gf180mcu.via_stack
gds flatglob res_dev
gds flatglob res_dev$$\[0-9\]*
# gds flatglob polyf_res_inst_d09b0e8d

# IO Devices
gds flatglob *_CDNS_*
gds flatglob *comp018green_*
gds flatglob *_metal_stack
gds flatglob *GF_NI_*
gds flatglob *_METAL_RAIL*
gds flatglob moscap_corner*
gds flatglob Bondpad_*
gds flatglob pmos_6p0_esd*
gds flatglob GR_NMOS*
gds flatglob POLY_.*FILL*
gds flatglob POLY_SUB_FILL*
gds flatglob nmos_clamp_20_50_4*
gds flatglob ESD_CLAMP_COR
gds flatglob moscap_routing
gds flatglob power_via_cor_*
gds flatglob POWER_RAIL_COR*
gds flatglob top_rout*

# Life-savers: Test how to make this work
# gds flatglob \[_a-zA-Z\]*$$\[0-9\]+
# gds flatglob compass*
# gds flatglob rectangle*
# gds flatglob np_*_*
# gds flatglob pn_*_*
# gds flatglob nmoscap_*
# gds flatglob *nmos_*_*[A-Z]*
# gds flatglob *pmos_*_*[A-Z]*
# gds flatglob *mim_*_*[A-Z]*
# gds flatglob *ppolyf_*_*[A-Z]*
# gds flatglob *diode_nd2ps_*
# gds flatglob *diode_pd2nw_*
# gds flatglob *cap_nmos_*
# gds flatglob *nfet_*
# gds flatglob *pfet_*


endef

define MAGIC_ROUTINE_LOAD__READSPICE_ALWAYS =
readspice $(PDK_ROOT)/$(PDK)/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
endef

endif # === SKY130 Specific configurations =====================

# == Variables - Magic routine definitions == #

# ---------------------------------------------------------------------------- #
#gds rescale false
define MAGIC_ROUTINE_LOAD =
gds ordering on
gds flatten yes
gds noduplicates true
drc euclidean on

$(FLATGLOB)

if {"$(PDK)" == "sky130A"} {
	gds read $(PDK_ROOT)/$(PDK)/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds
} elseif {"$(PDK)" == "gf180mcuD"} {
	gds read $(PDK_ROOT)/$(PDK)/libs.ref/gf180mcu_fd_io/gds/gf180mcu_ef_io.gds
	gds read $(PDK_ROOT)/$(PDK)/libs.ref/gf180mcu_fd_io/gds/gf180mcu_fd_io.gds
}

gds read $(GDS)
load $(TOP)
select cell $(TOP)
select top cell

$(MAGIC_ROUTINE_LOAD__READSPICE_ALWAYS)

if {[file exists $(SCH_NETLIST_NOPREFIX)]} {
	readspice $(SCH_NETLIST_NOPREFIX)
}

load $(TOP)
select cell $(TOP)
select top cell
expand

if {[file exists "$(LEF)"]} {
	lef read $(LEF)
}

load $(TOP)
select cell $(TOP)
select top cell
expand

puts "layout loaded :)"
endef

# ---------------------------------------------------------------------------- #
define MAGIC_ROUTINE_DRC =
$(MAGIC_ROUTINE_LOAD)
drc style drc(full)
drc check

# Redirect output to report file. Logs will die :c
# puts "Magic DRC report will be on $(MAGIC_REPORT_DRC)"
# close stdout
# open $(MAGIC_REPORT_DRC) w

drc listall why

# close stdout
quit -noprompt
endef

# ---------------------------------------------------------------------------- #
define MAGIC_ROUTINE_LVS =
drc off
gds drccheck off
$(MAGIC_ROUTINE__SET_SUB)
$(MAGIC_ROUTINE_LOAD)

$(MAGIC_ROUTINE_LVS__RENAME_OR_FLAT)

extract path extfiles
extract all
ext2spice lvs
ext2spice -p extfiles -o "$(LAYOUT_NETLIST_MAGIC)"

puts "Created netlist file $(LAYOUT_NETLIST_MAGIC)"
quit -noprompt
endef

# ---------------------------------------------------------------------------- #
define MAGIC_ROUTINE_PEX =
drc off
gds drccheck off
$(MAGIC_ROUTINE__SET_SUB)
$(MAGIC_ROUTINE_LOAD)

flatten $(GDS_CELL)_pex
load $(GDS_CELL)_pex
select top cell

extract path extfiles
extract all
ext2sim labels on
ext2sim
extresist $(MAGIC_ROUTINE_PEX__TOLERANCE)
extresist
ext2spice lvs
ext2spice cthresh 0.1
ext2spice extresist on
ext2spice -p extfiles -o "$(LAYOUT_NETLIST_PEX)"

puts "Created pex file $(LAYOUT_NETLIST_PEX)"

quit -noprompt
endef

# == Variables - Documentation == #

define HELP_ENTRIES +=

Magic related rules:
  magic-validation:      Evaluates relevant file existence. It's used by other rules.
  magic-edit:            Open $(TOP).gds on magic
  magic-lvs-extraction:  Extracts the netlist without parasitics
  magic-pex-extraction:  Extracts the netlist with resistive and capacitive parasitics

  IMPORTANT!!!
  Sometimes, magic needs manually adding some `flatglob` patterns on `MAGIC_ROUTINE_LOAD`
  This is done to flatten some devices that magic is not capable of recognize in different hierarchies.

endef

# Rules
#######

# Almost all magic commands require load the gds and pin ordering with a spice extracted from schematic
.PHONY: magic-validation
magic-validation: xschem-netlist-lvs-noprefix
ifeq (,$(wildcard $(GDS)))
	$(call ERROR_MESSAGE, [magic] GDS file $(GDS) doesn't exist$)
endif
	$(call INFO_MESSAGE, [magic] GDS:               $(wildcard $(GDS)))
	$(call INFO_MESSAGE, [magic] directory:         $(wildcard $(GDS_DIR)))
	$(call INFO_MESSAGE, [magic] extracted netlist: $(wildcard $(LAYOUT_NETLIST_MAGIC)))
	$(call INFO_MESSAGE, [magic] extracted pex:     $(wildcard $(LAYOUT_NETLIST_PEX)))
	$(call INFO_MESSAGE, [magic] rcfile:            $(wildcard $(MAGIC_RCFILE)))
ifeq (,$(wildcard $(MAG_DIR)))
	$(shell mkdir -p $(MAG_DIR))
endif


.PHONY: magic-edit
magic-edit: magic-validation
	cd $(GDS_DIR) && $(MAGIC) <<EOF |& tee $(LOG_MAGIC)
	$(MAGIC_ROUTINE_LOAD)
	drc euclidean on
	drc style drc(full)
	EOF


.PHONY: magic-drc
magic-drc:
	cd $(GDS_DIR) && $(MAGIC_BATCH) <<EOF |& tee $(LOG_MAGIC)
	$(MAGIC_ROUTINE_DRC)
	EOF


# Working on the TOP_DIR for simplicity, maybe we can change a internal variable to write all there.
.PHONY: magic-lvs-extraction
magic-lvs-extraction: magic-validation
	cd $(GDS_DIR) && $(MAGIC_BATCH) <<EOF |& tee $(LOG_MAGIC_LVS)
	$(MAGIC_ROUTINE_LVS)
	EOF


.PHONY: magic-pex-extraction
magic-pex-extraction: magic-validation
	cd $(GDS_DIR) && $(MAGIC_BATCH) <<EOF |& tee $(LOG_MAGIC_PEX)
	$(MAGIC_ROUTINE_PEX)
	EOF


# PEASE READ THIS: https://github.com/mattvenn/magic_challenge/tree/main/mag/tcl

.PHONY: magic-read-tcl
magic-read-tcl:
	cd $(MAG_DIR) && $(MAGIC_BATCH) <<EOF |& tee $(LOG_MAGIC_PEX)
		source $(TOP).tcl
	EOF


.PHONY: magic-mag
magic-mag:
	cd $(MAG_DIR) && $(MAGIC) $(MAG)


.PHONY: magic-generate-mag-from-tcl
magic-generate-mag-from-tcl:
	cd $(MAG_DIR) && $(MAGIC_BATCH) <<EOF
		source $(TOP).tcl
		save $(TOP)
		puts "Stored mag $(MAG_DIR)/$(TOP).mag"
	EOF


.PHONY: magic-generate-gds-from-tcl
magic-generate-gds-from-tcl:
	cd $(MAG_DIR) && $(MAGIC_BATCH) <<EOF
		source $(TOP).tcl
		gds write $(MODULE_DIR)/layout/$(TOP).gds
		puts "Stored gds $(MODULE_DIR)/layout/$(TOP).gds"
	EOF


.PHONY: magic-generate-gds-from-mag
magic-generate-gds-from-mag:
	cd $(MAG_DIR) && $(MAGIC_BATCH) $(MAG) <<EOF
		gds write $(MODULE_DIR)/layout/$(TOP).gds
		puts "Stored gds $(MODULE_DIR)/layout/$(TOP).gds"
	EOF
