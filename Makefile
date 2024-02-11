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

# This is a REFERENCE FILE
# You have to create a specific one for your project

all: print-vars
_IC_MAKEFILE=.
include $(_IC_MAKEFILE)/base.mk

# User parameters
#################

PDK=gf180mcuD

# TOP Indicates the top module, from a list of modules
TOP=UNDEFINED

TIMESTAMP_DAY=$(shell date +%Y-%m-%d)
TIMESTAMP_TIME=$(shell date +%H-%M-%S)

# TOP is a directory that contains relevant files that share the same name.
# - TOP/TOP.sch
# - TOP/TOP.sym
# - TOP/TOP-test.sch
# - TOP/TOP.gds

# Getting Files
###############

## 1. Get all files ##

ALL_MODULES= \
	$(realpath ./inv_sample)

ALL_FILES:= \
	$(wildcard ./inv_sample/*)

## 2. Filter by type #

ALL_SCH:=$(filter %.sch,$(ALL_FILES))

ALL_GDS:=$(filter %.gds,$(ALL_FILES))

ALL_NETLIST:= \
	$(filter %.spice,$(ALL_FILES)) \
	$(filter %.cdl,$(ALL_FILES)) \
	$(filter %.cir,$(ALL_FILES))


## 3. Filter by subtype ##

# Schematics
SCH:=$(filter-out %-test.sch,$(ALL_SCH))
ALL_SYM:=$(filter %.sym,$(ALL_FILES))

# Testbenches
TB:=$(filter %-test.sch,$(ALL_SCH))

# Parasitix extraction (pex)
PEX:=$(filter %.pex,$(ALL_FILES))

# Layout (gds)
GDS:=$(filter %.gds,$(ALL_GDS))

# Garbage
CLEANABLE:= \
	$(filter %.log,$(ALL_FILES)) \
	$(filter %comp.out,$(ALL_FILES)) \
	$(filter %.ext,$(ALL_FILES)) \
	$(filter %.sim,$(ALL_FILES)) \
	$(filter %.nodes,$(ALL_FILES)) \
	$(filter %.drc,$(ALL_FILES))
# $(filter %.lyrdb,$(ALL_FILES))
# $(filter %.lvsdb,$(ALL_FILES))

## 3. Files related with the TOP

ifeq (,$(TOP))
# TOP is undefined

# NEVER define TOP in this section. Empty TOP is useful as an indicator
$(warning $(COLOR_YELLOW)TOP not defined, using default values$(COLOR_END))
TOP_SCH=0_top.sch

else # ifeq (,$(TOP))

# TOP is defined
TOP_SCH:=$(realpath $(filter %/$(TOP).sch,$(SCH)))
TOP_TB:=$(realpath $(filter %/$(TOP)-test.sch,$(TB)))
TOP_SYM:=$(realpath $(filter %/$(TOP).sym,$(ALL_SYM)))

TOP_GDS:=$(realpath $(filter %/$(TOP).gds,$(GDS)))
TOP_GDS_CELL:=$(basename $(notdir $(TOP_GDS)))

TOP_GDS_DIR:=$(abspath $(dir $(TOP_GDS)))
TOP_SCH_DIR:=$(abspath $(dir $(TOP_SCH)))

GDS_REPORT_DIR:=$(TOP_GDS_DIR)/reports
ifeq (,$(GDS_REPORT_DIR))
mkdir -p $(GDS_REPORT_DIR)
endif

# Extracted from schematics (xschem)
TOP_NETLIST_SCH:=$(realpath $(filter %/$(TOP).spice,$(ALL_NETLIST)))
TOP_NETLIST_LVS_NOPREFIX:=$(TOP_SCH_DIR)/$(TOP)_noprefix.spice
TOP_NETLIST_LVS_PREFIX:=$(TOP_SCH_DIR)/$(TOP)_prefix.spice

# Extracted from layout
# (klayout)
TOP_EXTRACTED_KLAYOUT:=$(realpath $(filter %/$(TOP).cir,$(wildcard $(TOP_GDS_DIR)/*)))
# (magic)
TOP_EXTRACTED_MAGIC:=$(realpath $(filter %/$(TOP)_extracted.spice,$(wildcard $(TOP_GDS_DIR)/*)))
TOP_EXTRACTED_PEX:=$(realpath $(filter %/$(TOP)_pex.spice,$(wildcard $(TOP_GDS_DIR)/*)))

endif # ifeq (,$(TOP))

# Relevant directories
##################

LOG_DIR=$(abspath logs)/$(TIMESTAMP_DAY)
ifeq (,$(wildcard $(LOG_DIR)))
$(shell mkdir -p $(LOG_DIR))
endif

XSCHEM_RCFILE=$(realpath ./xschemrc)
MAGIC_RCFILE=$(realpath ./magicrc)
NETGEN_RCFILE=$(realpath $(PDK_ROOT)/$(PDK)/libs.tech/netgen/setup.tcl)

# Rules
#######

define HELP_ENTRIES =
Help message for Makefile
  to execute any command, the syntax is

    $$ make TOP=<component> <command>

  for example:

    $$ make TOP=resistor klayout-drc
    $$ make TOP=ldo-top xschem
	$$ make TOP=ldo-top print-TOP_GDS_DIR

  clean:          Removes intermediate files.
  print-%:        For every variable, prints it's value
  print-vars:     Shows some variable values
  help:           Shows this help
  xschem:         Alias for xschem-sch
  klayout:        Alias for klayout-edit
  magic:          Alias for magic-edit
  create-module:  Generates empty files that conforms a basic module

endef


include $(_IC_MAKEFILE)/xschem.mk
include $(_IC_MAKEFILE)/klayout.mk
include $(_IC_MAKEFILE)/magic.mk
include $(_IC_MAKEFILE)/netgen.mk
include $(_IC_MAKEFILE)/ngspice.mk
include $(_IC_MAKEFILE)/extra_be_checks.mk


.PHONY: help
help:
	$(call INFO_MESSAGE, $(HELP_ENTRIES))


.PHONY: clean
clean:
	$(RM) $(CLEANABLE)


# https://www.cmcrossroads.com/article/printing-value-makefile-variable
# https://stackoverflow.com/questions/16467718/how-to-print-out-a-variable-in-makefile
print-% : ; $(info $*: $(flavor $*) variable - $($*)) @true


.PHONY: print-vars
print-vars : \
	print-TOP \
	print-TOP_SCH \
	print-TOP_TB \
	print-TOP_SYM \
	print-TOP_GDS \
	print-TOP_GDS_CELL \
 	print-TOP_NETLIST_SCH \
	print-TOP_NETLIST_GDS \
	print-TOP_NETLIST_PEX


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
	mkdir -p $(TOP)
ifneq (,$(wildcard $(TOP)/$(TOP).sch))
	$(call WARNING_MESSAGE, schematic already exists)
else
	xschem --rcfile $(XSCHEM_RCFILE) \
	--no_x \
	--quit \
	--command "xschem clear; xschem saveas $(TOP)/$(TOP).sch"
endif

ifneq (,$(wildcard $(TOP)/$(TOP)-test.sch))
	$(call WARNING_MESSAGE, schematic testbench already exists)
else
	xschem --rcfile $(XSCHEM_RCFILE) \
	--no_x \
	--quit \
	--command "xschem clear; xschem saveas $(TOP)/$(TOP)-test.sch"
endif

ifneq (,$(wildcard $(TOP)/$(TOP).gds))
	$(call WARNING_MESSAGE, layout already exists)
else
	klayout -t -e -zz -r $(_IC_MAKEFILE)/empty-gds.py -rd filepath=$(TOP)/$(TOP).gds
endif


.PHONY: extensive-test
extensive-test:
	make TOP=$(TOP) klayout-drc-only     |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_extensive_test_$(TOP).log
	make TOP=$(TOP) GND_NAME=$(GND_NAME) klayout-lvs-only \
	                                     |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_extensive_test_$(TOP).log
	make TOP=$(TOP) netgen-lvs-klayout   |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_extensive_test_$(TOP).log
	make TOP=$(TOP) netgen-lvs-magic     |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_extensive_test_$(TOP).log
	make TOP=$(TOP) magic-pex-extraction |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_extensive_test_$(TOP).log

.PHONY: drc
drc:
	$(MAKE) TOP=$(TOP) klayout-drc

lvs:
	$(MAKE) TOP=$(TOP) GND_NAME=$(GND_NAME) klayout-lvs-only  |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_lvs_$(TOP).log
	$(MAKE) TOP=$(TOP) netgen-lvs-magic                       |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_lvs_$(TOP).log
	$(MAKE) TOP=$(TOP) netgen-lvs-klayout                     |& tee -a $(LOG_DIR)/$(TIMESTAMP_TIME)_lvs_$(TOP).log

pex:
	$(MAKE) TOP=$(TOP) magic-pex-extraction