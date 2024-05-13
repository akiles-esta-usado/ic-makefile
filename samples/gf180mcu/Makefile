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
_IC_MAKEFILE=$(realpath ../../)
include $(_IC_MAKEFILE)/base.mk


# User controllable variables

TOP=UNDEFINED
TEST=UNDEFINED
RTL=UNDEFINED

MODULE_SOURCE_DIR=$(realpath .)

MODULE_CONFIG_FILES=$(word 1, $(MODULE_SOURCE_DIR))
_FIRST_TOP_MODULE_DIR=$(word 1, $(MODULE_SOURCE_DIR))

# Tool configuration files

PDK=gf180mcuD
PYTHON=python

## XSCHEM
XSCHEM_RCFILE=$(realpath $(MODULE_CONFIG_FILES)/xschemrc)

## MAGIC
MAGIC_RCFILE=$(realpath $(MODULE_CONFIG_FILES)/magicrc)

## NETGEN
NETGEN_RCFILE=$(realpath $(PDK_ROOT)/$(PDK)/libs.tech/netgen/setup.tcl)

## NGSPICE
NGSPICE_RCDIR=$(realpath $(MODULE_CONFIG_FILES))

## EBC
EBC_DIR=$(realpath $(_IC_MAKEFILE)/extra_be_checks)
EBC_UPRJ_ROOT=$(realpath $(MODULE_CONFIG_FILES))
EBC_CONFIG=$(realpath $(MODULE_CONFIG_FILES)/lvs_config.json)

## KLAYOUT
KLAYOUT_HOME=$(PDK_ROOT)/$(PDK)/libs.tech/klayout
KLAYOUT_RCFILE=$(realpath $(MODULE_CONFIG_FILES)/klayoutrc)

# Documentation

define PARAMETER_ENTRY +=

Makefile variables:
  TOP: Indicates the top module, from a list of modules
  TEST: Each TOP could have multiple tests

  ex: make TOP=inv_sample TEST=test_2

endef


define HELP_ENTRIES +=
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

MODULES= $(foreach \
	module, \
	$(MODULE_SOURCE_DIR), \
	$(shell find $(module) -maxdepth 1 -mindepth 1 -type d -print) \
)

ifeq (UNDEFINED,$(TOP))

$(call WARNING_MESSAGE,TOP not defined. Using default values)
SCH=0_top.sch

else # ifeq (UNDEFINED,$(TOP))

# TOP defined: Define directories

MODULE_DIR=$(filter %/$(TOP),$(MODULES))
ifneq (,$(word 2,$(MODULE_DIR)))
$(call ERROR_MESSAGE,Multiple modules found $(MODULE_DIR))
endif

OUTPUT_DIR:=$(abspath $(MODULE_DIR)/output)

GDS_DIR:=$(abspath        $(MODULE_DIR)/layout)
REPORT_DIR:=$(abspath     $(OUTPUT_DIR)/reports)
EXTRACTION_DIR:=$(abspath $(OUTPUT_DIR)/extraction)
CODEMODELS_DIR:=$(abspath $(OUTPUT_DIR)/code_models)

SCH_DIR:=$(abspath $(EXTRACTION_DIR)/schematic)
TB_DIR:=$(abspath  $(EXTRACTION_DIR)/test)

# TOP defined: Enforce module structure

ifneq (,$(MODULE_DIR))
$(call INFO_MESSAGE,Module "$(TOP)" in directory $(MODULE_DIR))
$(shell mkdir -p $(OUTPUT_DIR))
$(shell mkdir -p $(REPORT_DIR))
$(shell mkdir -p $(EXTRACTION_DIR)/schematic)
$(shell mkdir -p $(EXTRACTION_DIR)/layout_clean)
$(shell mkdir -p $(EXTRACTION_DIR)/layout_pex)
$(shell mkdir -p $(TB_DIR))
endif

# TOP defined: Files

SCH:=$(wildcard $(MODULE_DIR)/symbol/$(TOP).sch)
SYM:=$(wildcard $(MODULE_DIR)/symbol/$(TOP).sym)
GDS:=$(wildcard $(MODULE_DIR)/layout/$(TOP).gds)
GDS_CELL:=$(basename $(notdir $(GDS)))
TBS:=$(wildcard $(MODULE_DIR)/test/*.sch)
ifeq (UNDEFINED,$(TEST))
TB:=$(word 1,$(TBS))
else
TB:=$(filter %/$(TEST).sch,$(TBS))
endif
VERILOGS:=\
	$(wildcard $(MODULE_DIR)/verilog/*.v) \
	$(wildcard $(MODULE_DIR)/verilog/*.sv)
ifeq (UNDEFINED,$(RTL))
VERILOG:=$(word 1,$(VERILOGS))
else
VERILOG=$(filter %/$(RTL).v,$(VERILOGS))
endif

# TOP defined: Extracted netlists

TB_NETLIST:=$(TB_DIR)/$(basename $(notdir $(TB))).spice

SCH_NETLIST_PREFIX:=$(SCH_DIR)/$(TOP)_prefix.spice
SCH_NETLIST_NOPREFIX:=$(SCH_DIR)/$(TOP)_noprefix.spice

LAYOUT_NETLIST_KLAYOUT:=$(EXTRACTION_DIR)/layout_clean/$(TOP).cir
LAYOUT_NETLIST_MAGIC:=$(EXTRACTION_DIR)/layout_clean/$(TOP)_clean.spice
LAYOUT_NETLIST_PEX:=$(EXTRACTION_DIR)/layout_pex/$(TOP)_pex.spice

endif # ifeq (UNDEFINED,$(TOP))

CLEANABLE:= \
	$(foreach module,$(MODULES),$(wildcard $(module)/output/reports/drc_run_*.log)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/output/reports/*.drc)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/layout/*.ext)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/layout/*.sim)) \
	$(foreach module,$(MODULES),$(wildcard $(module)/layout/*.nodes))

FULL_CLEANABLE:= $(CLEANABLE) \
	$(foreach module,$(MODULES),$(wildcard $(module)/output))

# Logs

LOG_DIR=$(abspath ./logs/$(TIMESTAMP_DAY))
ifeq (,$(wildcard $(LOG_DIR)))
$(shell mkdir -p $(LOG_DIR))
endif

# Include modules

include $(_IC_MAKEFILE)/xschem.mk
include $(_IC_MAKEFILE)/klayout.mk
include $(_IC_MAKEFILE)/magic.mk
include $(_IC_MAKEFILE)/netgen.mk
include $(_IC_MAKEFILE)/ngspice.mk
include $(_IC_MAKEFILE)/extra_be_checks.mk

# Some variables are created on included makefiles
MAKE=make TOP=$(TOP) TEST=$(TEST) GND_NAME=$(GND_NAME)


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


.PHONY: create-validation
create-validation:
ifeq (UNDEFINED,$(TOP))
	$(call ERROR_MESSAGE, TOP not defined and couldn't create anything)
endif
	mkdir -p $(_FIRST_TOP_MODULE_DIR)/$(TOP)/symbol
	mkdir -p $(_FIRST_TOP_MODULE_DIR)/$(TOP)/layout
	mkdir -p $(_FIRST_TOP_MODULE_DIR)/$(TOP)/test


.PHONY: create-schematic
create-schematic: create-validation
ifneq (,$(wildcard $(_FIRST_TOP_MODULE_DIR)/$(TOP)/symbol/$(TOP).sch))
	$(call ERROR_MESSAGE, schematic already exists)
else
	xschem --rcfile $(XSCHEM_RCFILE) \
	--no_x \
	--quit \
	--command "xschem clear; xschem saveas $(_FIRST_TOP_MODULE_DIR)/$(TOP)/symbol/$(TOP).sch"
endif


.PHONY: create-testbench
create-testbench: create-validation
ifdef TEST
	$(call ERROR_MESSAGE, TEST parameter not defined)
else ifneq (,$(wildcard $(_FIRST_TOP_MODULE_DIR)/$(TOP)/test/$(TEST).sch))
	$(call ERROR_MESSAGE, testbench already exists)
else
	xschem --rcfile $(XSCHEM_RCFILE) \
	--no_x \
	--quit \
	--command "xschem clear; xschem saveas $(_FIRST_TOP_MODULE_DIR)/$(TOP)/test/$(TEST).sch
endif


ifneq (,$(wildcard $(_FIRST_TOP_MODULE_DIR)/$(TOP)/test/$(TOP)-test.sch))
	$(call WARNING_MESSAGE, schematic already exists)
else
	xschem --rcfile $(XSCHEM_RCFILE) \
	--no_x \
	--quit \
	--command "xschem clear; xschem saveas $(_FIRST_TOP_MODULE_DIR)/$(TOP)/symbol/$(TOP).sch"
endif


.PHONY: create-layout
create-layout: create-validation
ifneq (,$(wildcard $(_FIRST_TOP_MODULE_DIR)/$(TOP)/layout/$(TOP).gds))
	$(call WARNING_MESSAGE, layout already exists)
else
	klayout -t -e -zz \
		-r $(_IC_MAKEFILE)/scripts/empty-gds.py \
		-rd filepath=$(_FIRST_TOP_MODULE_DIR)/$(TOP)/layout/$(TOP).gds
endif


.PHONY: create-module
create-module:
	$(MAKE) create-schematic
	$(MAKE) create-layout

# == VALIDATE SAMPLE DRC EVALUATION ========================================== #

.PHONY: validate-sample-klayout-drc-deep
validate-sample-klayout-drc-deep:
	make TOP=bjt                   DRC_FLAT=N klayout-drc # Density/227
	make TOP=bjt_fast              DRC_FLAT=N klayout-drc # Density/54
	make TOP=mim_capacitor         DRC_FLAT=N klayout-drc # 0
	make TOP=inv_sample            DRC_FLAT=N klayout-drc # Density/18
	make TOP=nmos5f                DRC_FLAT=N klayout-drc # Density/25
	make TOP=pmos1f                DRC_FLAT=N klayout-drc # Density/6
	make TOP=pmos5f                DRC_FLAT=N klayout-drc # Density/24
	make TOP=resistor_core         DRC_FLAT=N klayout-drc # Density/7
	make TOP=resistor_ppolyf_u_1k  DRC_FLAT=N klayout-drc # Density/6


.PHONY: validate-sample-klayout-drc-flat
validate-sample-klayout-drc-flat:
	make TOP=bjt                   DRC_FLAT=Y klayout-drc # Density/40
	make TOP=bjt_fast              DRC_FLAT=Y klayout-drc # Density/10
	make TOP=mim_capacitor         DRC_FLAT=Y klayout-drc # 0
	make TOP=inv_sample            DRC_FLAT=Y klayout-drc # Density/7
	make TOP=nmos5f                DRC_FLAT=Y klayout-drc # Density/9
	make TOP=pmos1f                DRC_FLAT=Y klayout-drc # Density/5
	make TOP=pmos5f                DRC_FLAT=Y klayout-drc # Density/9
	make TOP=resistor_core         DRC_FLAT=Y klayout-drc # Density/4
	make TOP=resistor_ppolyf_u_1k  DRC_FLAT=Y klayout-drc # Density/3


.PHONY: validate-sample-magic-drc
validate-sample-magic-drc:
	# Evaluate magic drc on drc manager
	make TOP=bjt           			magic # 20 (P-diffusion and N-ohmic must be over N-well or deep N-well)
	make TOP=bjt_fast      			magic # 5  (P-diffusion and N-ohmic must be over N-well or deep N-well)
	make TOP=mim_capacitor 			magic # 0
	make TOP=inv_sample    			magic # 0
	make TOP=nmos5f        			magic # 0
	make TOP=pmos1f        			magic # 0
	make TOP=pmos5f        			magic # 0
	make TOP=resistor_core 			magic # 0
	make TOP=resistor_ppolyf_u_1k   magic # 2: (PRES/LRES/HRES.7)


# == VALIDATE SAMPLE EXTRACTION ============================================== #

.PHONY: validate-sample-klayout-lvs-deep
validate-sample-klayout-lvs-deep:
	make TOP=bjt                   GND_NAME=C   LVS_FLAT=N klayout-lvs-only # ?  Netlist don't match (C == S)
	make TOP=bjt_fast              GND_NAME=vss LVS_FLAT=N klayout-lvs-only # Netlist match
	make TOP=mim_capacitor                      LVS_FLAT=N klayout-lvs-only # Netlist match
	make TOP=resistor_core         GND_NAME=B   LVS_FLAT=N klayout-lvs-only # Netlist match
	make TOP=resistor_ppolyf_u_1k  GND_NAME=B   LVS_FLAT=N klayout-lvs-only # Netlist match
	make TOP=inv_sample            GND_NAME=vss LVS_FLAT=N klayout-lvs-only # Netlist match
	make TOP=nmos5f                GND_NAME=S   LVS_FLAT=N klayout-lvs-only # Netlist match
	make TOP=pmos1f                GND_NAME=D   LVS_FLAT=N klayout-lvs-only # Netlist match
	make TOP=pmos5f                GND_NAME=D   LVS_FLAT=N klayout-lvs-only # Netlist match


.PHONY: validate-sample-klayout-lvs-flat
validate-sample-klayout-lvs-flat:
	make TOP=bjt                   GND_NAME=C   LVS_FLAT=Y klayout-lvs-only # Netlist don't match (C == S)
	make TOP=bjt_fast              GND_NAME=C   LVS_FLAT=Y klayout-lvs-only # Netlist match
	make TOP=mim_capacitor                      LVS_FLAT=Y klayout-lvs-only # Netlist match
	make TOP=resistor_core         GND_NAME=B   LVS_FLAT=Y klayout-lvs-only # Netlist match
	make TOP=resistor_ppolyf_u_1k  GND_NAME=B   LVS_FLAT=Y klayout-lvs-only # Netlist match
	make TOP=inv_sample            GND_NAME=vss LVS_FLAT=Y klayout-lvs-only # Netlist match
	make TOP=nmos5f                GND_NAME=S   LVS_FLAT=Y klayout-lvs-only # Netlist match
	make TOP=pmos1f                GND_NAME=D   LVS_FLAT=Y klayout-lvs-only # Netlist match
	make TOP=pmos5f                GND_NAME=D   LVS_FLAT=Y klayout-lvs-only # Netlist match


.PHONY: evaluate-magic-extraction-samples
evaluate-magic-extraction-samples:
	# Magic Validation
	make TOP=bjt                   magic-lvs-extraction subckt-count # 1
	make TOP=bjt_fast              magic-lvs-extraction subckt-count # 1
	make TOP=mim_capacitor         magic-lvs-extraction subckt-count # 1
	make TOP=resistor_core         magic-lvs-extraction subckt-count # 1
	make TOP=resistor_ppolyf_u_1k  magic-lvs-extraction subckt-count # 1
	make TOP=inv_sample            magic-lvs-extraction subckt-count # 1
	make TOP=nmos5f                magic-lvs-extraction subckt-count # 1
	make TOP=pmos1f                magic-lvs-extraction subckt-count # 1
	make TOP=pmos5f                magic-lvs-extraction subckt-count # 1
	make TOP=ota                   magic-lvs-extraction subckt-count # 1

	# On BJT
	## - Ports "S" and "C" are electrically shorted.
	## - Warning:  Ports "S" and "C" are electrically shorted.
	## - Device has multiple lengths:  scaling all widths to length 444

	# On BJT-FAST
	## - Warning:  Ports "C" and "S" are electrically shorted.

	make TOP=bjt           			netgen-lvs-script GND_NAME=vss # ? Top level cell failed pin matching
	make TOP=bjt_fast      			netgen-lvs-script GND_NAME=S   # ? Top level cell failed pin matching.
	make TOP=mim_capacitor 			netgen-lvs-script GND_NAME=vss # Circuits match uniquely.
	make TOP=resistor_core 			netgen-lvs-script GND_NAME=vss # Circuits match uniquely.
	make TOP=resistor_ppolyf_u_1k   netgen-lvs-script GND_NAME=B   # Circuits match uniquely.
	make TOP=inv_sample    			netgen-lvs-script GND_NAME=vss # Circuits match uniquely.
	make TOP=nmos5f        			netgen-lvs-script GND_NAME=vss # Circuits match uniquely.
	make TOP=pmos1f        			netgen-lvs-script GND_NAME=vss # Circuits match uniquely.
	make TOP=pmos5f        			netgen-lvs-script GND_NAME=vss # Circuits match uniquely.
	make TOP=ota         			netgen-lvs-script GND_NAME=vss # Circuits match uniquely.

	make TOP=bjt                   GND_NAME=S   klayout-compare-magic-extraction # Extractions are too different
	make TOP=bjt_fast              GND_NAME=C   klayout-compare-magic-extraction # PNP is inverted
	make TOP=mim_capacitor         GND_NAME=vss klayout-compare-magic-extraction # Congratulations! Netlists match.
	make TOP=resistor_core         GND_NAME=vss klayout-compare-magic-extraction # Congratulations! Netlists match.
	make TOP=resistor_ppolyf_u_1k  GND_NAME=vss klayout-compare-magic-extraction # Congratulations! Netlists match.
	make TOP=inv_sample            GND_NAME=vss klayout-compare-magic-extraction # Congratulations! Netlists match.
	make TOP=nmos5f                GND_NAME=S   klayout-compare-magic-extraction # Congratulations! Netlists match.
	make TOP=pmos1f                GND_NAME=vss klayout-compare-magic-extraction # Congratulations! Netlists match.
	make TOP=pmos5f                GND_NAME=vss klayout-compare-magic-extraction # Congratulations! Netlists match.
	make TOP=ota                   GND_NAME=vss klayout-compare-magic-extraction # Congratulations! Netlists match.

.PHONY: validate-sample-magic-klayout-compatibility
validate-sample-magic-klayout-compatibility:
	make TOP=bjt           			netgen-lvs-klayout # ? Top level cell failed pin matching.
	make TOP=bjt_fast               netgen-lvs-klayout # ? Top level cell failed pin matching.
	make TOP=mim_capacitor 			netgen-lvs-klayout # ? Top level cell failed pin matching.
	make TOP=inv_sample    			netgen-lvs-klayout # ? Circuits match uniquely. 
	make TOP=nmos5f        			netgen-lvs-klayout # ? Circuits match uniquely. 
	make TOP=pmos1f        			netgen-lvs-klayout # ? Circuits match uniquely. 
	make TOP=pmos5f        			netgen-lvs-klayout # ? Circuits match uniquely. 
	make TOP=resistor_core 			netgen-lvs-klayout # ? Circuits match uniquely. Property errors were found.
	make TOP=resistor_ppolyf_u_1k   netgen-lvs-klayout # ? Circuits match uniquely. Property errors were found.

	# PROBLEM: It seems that klayout and magic uses different order on mimcap pads.
	# If I invert IN1 and IN2, lvs works only for one (netgen magic, netgen klayout)


# == STANDARD CELL EXTRACTION ANALYSIS ======================================= #

PDK_SC_GDS=$(wildcard $(PDK_ROOT)/$(PDK)/libs.ref/gf180mcu_fd_sc_mcu7t5v0/gds/gf180mcu_fd_sc_mcu7t5v0.gds)
PDK_SC_SPICE=$(wildcard $(PDK_ROOT)/$(PDK)/libs.ref/gf180mcu_fd_sc_mcu7t5v0/spice/gf180mcu_fd_sc_mcu7t5v0.spice)


gf180mcu-sc-klayout:
	make GDS=$(PDK_SC_GDS) klayout


gf180mcu-extract-sc:
	make GDS=$(PDK_SC_GDS) GDS_DIR=. klayout-extract-topcells
	rm -rf ./\(UNNAMED\)/


extract-sc-netlist:
ifeq (,$(wildcard $(TOP)))
	$(call ERROR_MESSAGE, TOP not defined)
endif
	mkdir -p $(TOP)/spice
	cp $(PDK_SC_SPICE) $(TOP)/spice
	make TOP=$(TOP) SCH_NETLIST_NOPREFIX=$(TOP)/spice/gf180mcu_fd_sc_mcu7t5v0.spice magic-lvs-extraction


compare-sc-netlist:
ifeq (,$(wildcard $(TOP)))
	$(call ERROR_MESSAGE, TOP not defined)
endif
	netgen -batch lvs \
		"$(TOP)/output/extraction/layout_clean/$(TOP)_clean.spice $(TOP)_clean" \
		"$(TOP)/spice/gf180mcu_fd_sc_mcu7t5v0.spice $(TOP)" \
		$(PDK_ROOT)/$(PDK)/libs.tech/netgen/setup.tcl \
		$(TOP)/output/reports/netlist-extraction-comparison.rpt


evaluate-extract-standard-cell-netlist:
	make full-clean
	make TOP=gf180mcu_fd_sc_mcu7t5v0__addf_1            extract-sc-netlist subckt-count # 1
	make TOP=gf180mcu_fd_sc_mcu7t5v0__addf_2            extract-sc-netlist subckt-count #
	make TOP=gf180mcu_fd_sc_mcu7t5v0__addf_4            extract-sc-netlist subckt-count # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__addh_1            extract-sc-netlist subckt-count # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__addh_2            extract-sc-netlist subckt-count # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__addh_4            extract-sc-netlist subckt-count # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and2_1            extract-sc-netlist subckt-count # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and2_2            extract-sc-netlist subckt-count # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and2_4            extract-sc-netlist subckt-count # 1
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and3_1            extract-sc-netlist subckt-count # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and3_2            extract-sc-netlist subckt-count # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and3_4            extract-sc-netlist subckt-count # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and4_1            extract-sc-netlist subckt-count # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and4_2            extract-sc-netlist subckt-count # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and4_4            extract-sc-netlist subckt-count # 1

	make TOP=gf180mcu_fd_sc_mcu7t5v0__addf_1            compare-sc-netlist # Circuits match uniquely.
	make TOP=gf180mcu_fd_sc_mcu7t5v0__addf_2            compare-sc-netlist # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__addf_4            compare-sc-netlist # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__addh_1            compare-sc-netlist # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__addh_2            compare-sc-netlist # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__addh_4            compare-sc-netlist # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and2_1            compare-sc-netlist # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and2_2            compare-sc-netlist # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and2_4            compare-sc-netlist # Circuits match uniquely.
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and3_1            compare-sc-netlist # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and3_2            compare-sc-netlist # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and3_4            compare-sc-netlist # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and4_1            compare-sc-netlist # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and4_2            compare-sc-netlist # 
	make TOP=gf180mcu_fd_sc_mcu7t5v0__and4_4            compare-sc-netlist # Circuits match uniquely.


# == INPUT/OUTPUT PAD EXTRACTION ANALYSIS ==================================== #

PDK_IO_GDS=$(wildcard $(PDK_ROOT)/$(PDK)/libs.ref/gf180mcu_fd_io/gds/gf180mcu_fd_io.gds)
PDK_IO_SPICE=$(wildcard $(PDK_ROOT)/$(PDK)/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice)

gf180mcu-io-klayout:
	make GDS=$(PDK_IO_GDS) klayout


gf180mcu-extract-io:
	make GDS=$(PDK_IO_GDS) GDS_DIR=. klayout-extract-topcells
	rm -rf ./\(UNNAMED\)/


# Comparing magic extracted netlist with the expected spice.
extract-pad-netlist:
ifeq (,$(wildcard $(TOP)))
	$(call ERROR_MESSAGE, TOP not defined)
endif
	mkdir -p $(TOP)/spice
	cp $(PDK_IO_SPICE) $(TOP)/spice
	make TOP=$(TOP) SCH_NETLIST_NOPREFIX=$(TOP)/spice/gf180mcu_fd_io.spice magic-lvs-extraction


compare-pad-netlist:
ifeq (,$(wildcard $(TOP)))
	$(call ERROR_MESSAGE, TOP not defined)
endif
	netgen -batch lvs \
		"$(TOP)/output/extraction/layout_clean/$(TOP)_clean.spice $(TOP)_clean" \
		"$(TOP)/spice/gf180mcu_fd_io.spice $(TOP)" \
		$(PDK_ROOT)/$(PDK)/libs.tech/netgen/setup.tcl \
		$(TOP)/output/reports/netlist-extraction-comparison.rpt


evaluate-extract-pad-netlist:
	make full-clean
	make TOP=gf180mcu_fd_io__asig_5p0   extract-pad-netlist subckt-count # 1
	make TOP=gf180mcu_fd_io__bi_24t     extract-pad-netlist subckt-count # 1
	make TOP=gf180mcu_fd_io__bi_t       extract-pad-netlist subckt-count # 1
	make TOP=gf180mcu_fd_io__brk2       extract-pad-netlist subckt-count # 1
	make TOP=gf180mcu_fd_io__brk5       extract-pad-netlist subckt-count # 1
	make TOP=gf180mcu_fd_io__cor        extract-pad-netlist subckt-count # 1
	make TOP=gf180mcu_fd_io__dvdd       extract-pad-netlist subckt-count # 1
	make TOP=gf180mcu_fd_io__dvss       extract-pad-netlist subckt-count # 1
	make TOP=gf180mcu_fd_io__fill1      extract-pad-netlist subckt-count # 1
	make TOP=gf180mcu_fd_io__fill5      extract-pad-netlist subckt-count # 1
	make TOP=gf180mcu_fd_io__fill10     extract-pad-netlist subckt-count # 1
	make TOP=gf180mcu_fd_io__fillnc     extract-pad-netlist subckt-count # 1
	make TOP=gf180mcu_fd_io__in_c       extract-pad-netlist subckt-count # 1
	make TOP=gf180mcu_fd_io__in_s       extract-pad-netlist subckt-count # 1

	make TOP=gf180mcu_fd_io__asig_5p0   compare-pad-netlist # Circuits match uniquely.
	make TOP=gf180mcu_fd_io__bi_24t     compare-pad-netlist # Circuits match uniquely. Property errors were found.
	make TOP=gf180mcu_fd_io__bi_t       compare-pad-netlist # Circuits match uniquely. Property errors were found.
	make TOP=gf180mcu_fd_io__brk2       compare-pad-netlist # No devices
	make TOP=gf180mcu_fd_io__brk5       compare-pad-netlist # No devices
	make TOP=gf180mcu_fd_io__cor        compare-pad-netlist # Circuits match uniquely.
	make TOP=gf180mcu_fd_io__dvdd       compare-pad-netlist # Circuits match uniquely.
	make TOP=gf180mcu_fd_io__dvss       compare-pad-netlist # Circuits match uniquely.
	make TOP=gf180mcu_fd_io__fill1      compare-pad-netlist # No devices
	make TOP=gf180mcu_fd_io__fill5      compare-pad-netlist # Circuits match uniquely.
	make TOP=gf180mcu_fd_io__fill10     compare-pad-netlist # Circuits match uniquely.
	make TOP=gf180mcu_fd_io__fillnc     compare-pad-netlist # No devices
	make TOP=gf180mcu_fd_io__in_c       compare-pad-netlist # Circuits match uniquely. Property errors were found.
	make TOP=gf180mcu_fd_io__in_s       compare-pad-netlist # Circuits match uniquely. Property errors were found.


