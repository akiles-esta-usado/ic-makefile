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

# Files, directories and Aliases
################################

MAGIC_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_magic_$(TOP).log
MAGIC_LVS_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_magic_lvs_$(TOP).log
MAGIC_PEX_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_magic_pex_$(TOP).log

MAGIC=magic -rcfile $(MAGIC_RCFILE) -noconsole
MAGIC_BATCH=$(MAGIC) -nowindow -dnull

define MAGIC_ROUTINE_LOAD =
gds rescale false

gds flatten yes

gds flatglob pmos*
gds flatglob via*
gds flatglob compass*
gds flatglob rectangle*

gds read $(TOP_GDS)
#getcell $(TOP_GDS_CELL)
load $(TOP_GDS_CELL)
box 0 0 0 0

puts "layout loaded :)"
endef

define MAGIC_ROUTINE_LVS =
drc off
gds drccheck off
$(MAGIC_ROUTINE_LOAD)
readspice $(TOP_NETLIST_LVS_NOPREFIX)

extract
ext2spice lvs
ext2spice -o "$(TOP_GDS_DIR)/$(TOP_GDS_CELL)_extracted.spice"

puts "Created netlist file $(TOP_GDS_DIR)/$(TOP_GDS_CELL)_extracted.spice"
quit -noprompt
endef

define MAGIC_ROUTINE_PEX =
drc off
gds drccheck off
$(MAGIC_ROUTINE_LOAD)
readspice $(TOP_NETLIST_LVS_NOPREFIX)

flatten $(TOP_GDS_CELL)_pex
load $(TOP_GDS_CELL)_pex
box values 0 0 0 0

extract all
ext2sim labels on
ext2sim
extresist tolerance 10
extresist all
ext2spice lvs
ext2spice extresist on
ext2spice cthresh 0
ext2spice -o "$(TOP_GDS_DIR)/$(TOP_GDS_CELL)_pex.spice"

puts "Created pex file $(TOP_GDS_DIR)/$(TOP_GDS_CELL)_pex.spice"

quit -noprompt
endef

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

.PHONY: magic-validation
magic-validation:
ifeq (,$(wildcard $(TOP_GDS)))
	$(call ERROR_MESSAGE, [magic] GDS file $(TOP_GDS) doesn't exist$)
endif
	$(call INFO_MESSAGE, [magic] directory:         $(TOP_GDS_DIR))
	$(call INFO_MESSAGE, [magic] GDS:               $(TOP_GDS))
	$(call INFO_MESSAGE, [magic] extracted netlist: $(wildcard $(TOP_GDS_DIR)/$(TOP)_extracted.spice))
	$(call INFO_MESSAGE, [magic] extracted pex:     $(wildcard $(TOP_GDS_DIR)/$(TOP)_pex.spice))
	$(call INFO_MESSAGE, [magic] rcfile:            $(MAGIC_RCFILE))


.PHONY: magic-edit
magic-edit: magic-validation
	cd $(TOP_GDS_DIR) && $(MAGIC) <<EOF |& tee $(MAGIC_LOG)
	$(MAGIC_ROUTINE_LOAD)
	EOF


# Working on the TOP_DIR for simplicity, maybe we can change a internal variable to write all there.
.PHONY: magic-lvs-extraction
magic-lvs-extraction: magic-validation
	cd $(TOP_GDS_DIR) && $(MAGIC_BATCH) <<EOF |& tee $(MAGIC_LVS_LOG)
	$(MAGIC_ROUTINE_LVS)
	EOF
	

.PHONY: magic-pex-extraction
magic-pex-extraction: magic-validation
	cd $(TOP_GDS_DIR) && $(MAGIC_BATCH) <<EOF |& tee $(MAGIC_PEX_LOG)
	$(MAGIC_ROUTINE_PEX)
	EOF
