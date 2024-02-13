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

# This is a REFERENCE FILE used to create a specific one per project.

all: print_vars
_IC_MAKEFILE=.
include $(_IC_MAKEFILE)/base.mk


# User controlable variables

TOP=UNDEFINED
TEST=UNDEFINED

MODULES= \
	$(realpath ./samples/inv_sample) \
	$(realpath ./samples/buffer_sample)

# Tool configuration files

PDK=gf180mcuD
XSCHEM_RCFILE=$(realpath ./samples/xschemrc)
MAGIC_RCFILE=$(realpath ./samples/magicrc)
NETGEN_RCFILE=$(realpath $(PDK_ROOT)/$(PDK)/libs.tech/netgen/setup.tcl)
NGSPICE_RCDIR=$(realpath ./samples)
EBC_DIR=$(realpath ./extra_be_checks)
EBC_UPRJ_ROOT=$(realpath ./samples)
EBC_CONFIG=$(realpath ./samples/lvs_config.json)



define PARAMETER_ENTRY =

Makefile variables:
  TOP: Indicates the top module, from a list of modules
  TEST: Each TOP could have multiple tests

  ex: make TOP=inv_sample TEST=test_2

endef


define HELP_ENTRIES =
Help message for Makefile
  to execute any command, the syntax is

    $$ make TOP=<component> <command>

  for example:

    $$ make TOP=resistor klayout-drc
    $$ make TOP=ldo-top xschem
	$$ make TOP=ldo-top print-GDS_DIR

  clean:          Removes intermediate files.
  print-%:        For every variable, prints it's value
  print-vars:     Shows some variable values
  help:           Shows this help
  xschem:         Alias for xschem-sch
  klayout:        Alias for klayout-edit
  magic:          Alias for magic-edit
  create-module:  Generates empty files that conforms a basic module

endef

## Files related with the TOP

ifeq (UNDEFINED,$(TOP))

$(call WARNING_MESSAGE,TOP not defined. Using default values)
SCH=0_top.sch

else # ifeq (UNDEFINED,$(TOP))

MODULE_DIR=$(filter %/$(TOP),$(MODULES))

# TODO: This is going to fail when trying to create a new module :(
ifeq (,$(MODULE_DIR))
$(call ERROR_MESSAGE,Module "$(TOP)" don't exists or is not registered)
else
$(call INFO_MESSAGE,Module "$(TOP)" in directory $(MODULE_DIR))
endif

# Base files

SCH:=$(wildcard $(MODULE_DIR)/symbol/$(TOP).sch)
SYM:=$(wildcard $(MODULE_DIR)/symbol/$(TOP).sym)
GDS:=$(wildcard $(MODULE_DIR)/layout/$(TOP).gds)
TBS:=$(wildcard $(MODULE_DIR)/test/*.sch)
ifeq (UNDEFINED,$(TEST))
TB:=$(word 1,$(TBS))
else
TB:=$(filter %/$(TEST).sch,$(TBS))
endif

GDS_CELL:=$(basename $(notdir $(GDS)))

# Directories related with the module
# Decouple the directory from the file allows having different project structures

GDS_DIR:=$(realpath $(dir $(GDS)))
OUTPUT_DIR:=$(abspath $(MODULE_DIR)/output)

REPORT_DIR:=$(abspath $(OUTPUT_DIR)/reports)
EXTRACTION_DIR:=$(abspath $(OUTPUT_DIR)/extraction)

SCH_DIR:=$(abspath $(EXTRACTION_DIR)/schematic)
TB_DIR:=$(abspath $(EXTRACTION_DIR)/test)

$(shell mkdir -p $(OUTPUT_DIR))
$(shell mkdir -p $(REPORT_DIR))
$(shell mkdir -p $(EXTRACTION_DIR)/schematic)
$(shell mkdir -p $(EXTRACTION_DIR)/layout_clean)
$(shell mkdir -p $(EXTRACTION_DIR)/layout_pex)
$(shell mkdir -p $(TB_DIR))


# Schematic test netlist

TB_NETLIST:=$(TB_DIR)/$(basename $(notdir $(TB))).spice

# Schematic clean netlist

SCH_NETLIST_PREFIX:=$(SCH_DIR)/$(TOP)_prefix.spice
SCH_NETLIST_NOPREFIX:=$(SCH_DIR)/$(TOP)_noprefix.spice

# Layout clean netlist

LAYOUT_NETLIST_KLAYOUT:=$(EXTRACTION_DIR)/layout_clean/$(TOP).cir
LAYOUT_NETLIST_MAGIC:=$(EXTRACTION_DIR)/layout_clean/$(TOP)_extracted.spice

# Layout netlists with parasitics

LAYOUT_NETLIST_PEX:=$(EXTRACTION_DIR)/layout_pex/$(TOP)_pex.spice

endif # ifeq (UNDEFINED,$(TOP))

CLEANABLE:= \
	$(foreach module,$(MODULES),$(wildcard $(module)/output/reports/drc_run_*.log)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/output/reports/*.drc)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/layout/*.ext)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/layout/*.sim)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/layout/*.nodes))

FULL_CLEANABLE:= $(CLEANABLE) \
	$(foreach module,$(MODULES),$(wildcard $(module)/output/ebc)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/output/reports/*.lyrdb)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/output/reports/*.lvsdb)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/output/reports/*comp.out)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/output/extraction/*/*.spice)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/output/extraction/*/*.cir)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/output/extraction/*/*.raw))

# Logs
######

TIMESTAMP_DAY=$(shell date +%Y_%m_%d)
TIMESTAMP_TIME=$(shell date +%H_%M_%S)

LOG_DIR=$(abspath ./logs/$(TIMESTAMP_DAY))
ifeq (,$(wildcard $(LOG_DIR)))
$(shell mkdir -p $(LOG_DIR))
endif


include $(_IC_MAKEFILE)/xschem.mk
include $(_IC_MAKEFILE)/klayout.mk
include $(_IC_MAKEFILE)/magic.mk
include $(_IC_MAKEFILE)/netgen.mk
include $(_IC_MAKEFILE)/ngspice.mk
include $(_IC_MAKEFILE)/extra_be_checks.mk

# Some variables are created on included makefiles
MAKE=make TOP=$(TOP) TEST=$(TEST) GND_NAME=$(GND_NAME)


.PHONY: help
help:
	$(call INFO_MESSAGE,$(HELP_ENTRIES))
	$(call INFO2_MESSAGE,$(PARAMETER_ENTRY))

.PHONY: print_vars
print_vars : \
	print_MAKE \
	print_TOP \
	print_MODULE_DIR \
	print_SCH \
	print_SYM \
	print_TB \
	print_GDS \
	print_GDS_CELL \
	print_TBS \
	print_SCH_NETLIST \
	print_SCH_NETLIST_NOPREFIX \
	print_SCH_NETLIST_PREFIX \
 	print_LAYOUT_NETLIST_KLAYOUT \
	print_LAYOUT_NETLIST_MAGIC \
	print_LAYOUT_NETLIST_PEX


.PHONY: xschem
xschem: xschem-sch


.PHONY: klayout
klayout: klayout-edit


.PHONY: magic
magic: magic-edit


.PHONY: create-module
create-module:
ifeq (,$(TOP))
	$(call ERROR_MESSAGE, TOP not defined, couldn't create any design)
endif
	mkdir -p $(TOP)/symbol
	mkdir -p $(TOP)/layout
	mkdir -p $(TOP)/test

ifneq (,$(wildcard $(TOP)/schematic/$(TOP).sch))
	$(call WARNING_MESSAGE, schematic already exists)
else
	xschem --rcfile $(XSCHEM_RCFILE) \
	--no_x \
	--quit \
	--command "xschem clear; xschem saveas $(TOP)/symbol/$(TOP).sch"
endif

ifneq (,$(wildcard $(TOP)/layout/$(TOP).gds))
	$(call WARNING_MESSAGE, layout already exists)
else
	klayout -t -e -zz -r $(_IC_MAKEFILE)/empty-gds.py -rd filepath=$(TOP)/layout/$(TOP).gds
endif


.PHONY: extensive-test
extensive-test:
	$(MAKE) klayout-drc-only     |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_extensive_test_$(TOP).log
	$(MAKE) klayout-lvs-only     |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_extensive_test_$(TOP).log
	$(MAKE) netgen-lvs-klayout   |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_extensive_test_$(TOP).log
	$(MAKE) netgen-lvs-magic     |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_extensive_test_$(TOP).log
	$(MAKE) magic-pex-extraction |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_extensive_test_$(TOP).log


.PHONY: drc
drc:
	$(MAKE) klayout-drc


lvs:
	$(MAKE) klayout-lvs-only   |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_lvs_$(TOP).log
	$(MAKE) netgen-lvs-magic   |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_lvs_$(TOP).log
	$(MAKE) netgen-lvs-klayout |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_lvs_$(TOP).log


pex:
	$(MAKE) magic-pex-extraction
