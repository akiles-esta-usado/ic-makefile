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

# Files, directories and Aliases
################################

KLAYOUT_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_klayout_$(TOP).log
KLAYOUT_LVS_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_klayout_lvs_$(TOP).log
KLAYOUT_DRC_EFABLES_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_klayout_drc_efabless_$(TOP).log
KLAYOUT_DRC_PRECHECK_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_klayout_drc_precheck_$(TOP).log

# If this variable is not set correctly. LVS will never succeed
# This variable is case sensitive, VSS != vss
GND_NAME:=VSS

TOP_ALL_LYRDB:=$(filter %.lyrdb,$(wildcard $(GDS_REPORT_DIR)/*))
TOP_ALL_LVSDB:=$(filter %.lvsdb,$(wildcard $(GDS_REPORT_DIR)/*))


KLAYOUT=klayout -t

define HELP_ENTRIES +=

Klayout related rules:
  klayout-validation: Evaluates relevant file existence. It's used by other rules.
  klayout-view:       Opens klayout in view mode
  klayout-edit:       Opens klayout in edit mode
  klayout-lvs:        Run klayout lvs and open the reports
  klayout-lvs-help:   Shows lvs help documentation
  klayout-lvs-view:   Opens klayout in edit mode and with lvs reports.
  klayout-lvs-only:   Runs LVS from command line
  klayout-drc:        Runs DRC and open reports on graphical interface
  klayout-drc-view:   Open DRC reports on graphical interface
  klayout-drc-only:   Runs DRC from efabless and precheck from command line
  klayout-eval:       Runs DRC and LVS

  IMPORTANT NOTE!!!
  For LVS commands, it's required to define the variable GND_NAME to the 
  name that the bulk has on the layout.
    $$ make TOP=resistor GND_NAME=B klayout-lvs

endef


# Rules
#######

.PHONY: klayout-validation
klayout-validation:
ifeq (,$(wildcard $(TOP_GDS)))
	$(call ERROR_MESSAGE, [klayout] GDS file $(TOP_GDS) doesn't exist$)
endif	
	$(call INFO_MESSAGE, [klayout] directory:         $(TOP_GDS_DIR))
	$(call INFO_MESSAGE, [klayout] GDS:               $(TOP_GDS))

ifeq (,$(wildcard $(TOP_NETLIST_SCH)))
	$(call WARNING_MESSAGE, [klayout] Schematic netlist doesn't exist$)
else
	$(call INFO_MESSAGE, [klayout] schematic netlist: $(TOP_NETLIST_SCH))
endif
	$(call INFO_MESSAGE, [klayout] gds netlist:       $(TOP_NETLIST_GDS))
	$(call INFO_MESSAGE, [klayout] schematic netlist: $(wildcard $(TOP_GDS_DIR)/$(TOP)-noprefix.spice))
	$(call INFO_MESSAGE, [klayout] DRC reports:       $(TOP_ALL_LYRDB))
	$(call INFO_MESSAGE, [klayout] LVS reports:       $(TOP_ALL_LVSDB))


# Visualization
###############

.PHONY: klayout-view
klayout-view: klayout-validation
	$(KLAYOUT) -ne $(TOP_GDS) |& tee $(KLAYOUT_LOG)


.PHONY: klayout-edit
klayout-edit: klayout-validation
	$(KLAYOUT) -e $(TOP_GDS) |& tee $(KLAYOUT_LOG)


# LVS RULES
#############

# --help -h                           Print this help message.
# --layout=<layout_path>              The input GDS file path.
# --netlist=<netlist_path>            The input netlist file path.
# --variant=<combined_options>        Select combined options of metal_top, mim_option, and metal_level. Allowed values (A, B, C, D).
# --thr=<thr>                         The number of threads used in run.
# --run_dir=<run_dir_path>            Run directory to save all the results [default: pwd]
# --topcell=<topcell_name>            Topcell name to use.
# --run_mode=<run_mode>               Select klayout mode Allowed modes (flat , deep, tiling). [default: deep]
# --lvs_sub=<sub_name>                Substrate name used in your design.
# --verbose                           Detailed rule execution log for debugging.
# --schematic_simplify                Enable schematic simplification in input netlist.

## Operations in extracted netlist
# --no_net_names                      In extracted netlist Discard net names.
# --spice_comments                    In extracted netlist Enable netlist comments.
# --scale                             In extracted netlist Enable scale of 1e6.
# --net_only                          In extracted netlist Enable netlist object creation only.
# --top_lvl_pins                      In extracted netlist Enable top level pins only.
# --combine                           In extracted netlist Enable netlist combine only.
# --purge                             In extracted netlist Enable netlist purge all only.
# --purge_nets                        In extracted netlist Enable netlist purge nets only.


.PHONY: klayout-lvs-help
klayout-lvs-help:
	python $(KLAYOUT_HOME)/lvs/run_lvs.py --help


.PHONY: klayout-lvs-view
klayout-lvs-view: klayout-validation
ifeq (,$(TOP_ALL_LVSDB))
	$(call ERROR_MESSAGE, [klayout] There's no LVS report for $(TOP))
else
	$(KLAYOUT) -e $(TOP_GDS) $(foreach file,$(TOP_ALL_LVSDB),-mn $(file))
endif


.PHONY: klayout-lvs-only
klayout-lvs-only: klayout-validation xschem-netlist-lvs-noprefix-fixed
	$(RM) $(GDS_REPORT_DIR)/*.lvsdb

	# Since the netlist could not exists on first run
	# It's recommended use TOP.spice instead of TOP_NETLIST_SCH
	python $(KLAYOUT_HOME)/lvs/run_lvs.py \
		--variant=D \
		--run_mode=flat \
		--verbose \
		--lvs_sub=$(GND_NAME) \
		--run_dir=$(GDS_REPORT_DIR) \
		--layout=$(TOP_GDS) \
		--netlist=$(TOP_GDS_DIR)/$(TOP)_noprefix.spice \
		--top_lvl_pins \
		--schematic_simplify \
		--combine |& tee $(KLAYOUT_LVS_LOG) || true

	mv $(GDS_REPORT_DIR)/*.cir $(TOP_GDS_DIR)



.PHONY: klayout-lvs
klayout-lvs: klayout-lvs-only
	make TOP=$(TOP) klayout-lvs-view


# DRC RULES
###########

.PHONY: klayout-drc-view
klayout-drc-view: klayout-validation
ifeq (,$(TOP_ALL_LYRDB))
	$(call ERROR_MESSAGE, [klayout] There's no DRC report for $(TOP))
else
	$(KLAYOUT) -e $(TOP_GDS) $(foreach file,$(TOP_ALL_LYRDB),-m $(file))
endif


.PHONY: klayout-drc-only
klayout-drc-only: klayout-validation
	$(RM) $(GDS_REPORT_DIR)/*.lyrdb

	python $(KLAYOUT_HOME)/drc/run_drc.py \
		--path $(TOP_GDS) \
		--variant=D \
		--topcell=$(TOP_GDS_CELL) \
		--run_dir=$(GDS_REPORT_DIR) \
		--run_mode=flat \
		--antenna \
		--density \
		--thr=$(NPROCS) \
		--verbose |& tee $(KLAYOUT_DRC_EFABLES_LOG) || true

	$(KLAYOUT) -b -r $(KLAYOUT_HOME)/drc/gf180mcuD_mr.drc \
		-rd input=$(TOP_GDS) \
		-rd topcell=$(TOP_GDS_CELL) \
		-rd report=$(GDS_REPORT_DIR)/precheck_$(TOP).lyrdb \
		-rd thr=$(NPROCS) \
		-rd conn_drc=true \
		-rd split_deep=true \
		-rd wedge=true \
		-rd ball=true \
		-rd gold=true \
		-rd mim_option=B \
		-rd offgrid=true \
		-rd verbose=true \
		-rd run_mode=flat \
		-rd feol=true \
		-rd beol=true |& tee $(KLAYOUT_DRC_PRECHECK_LOG) || true


.PHONY: klayout-drc
klayout-drc: klayout-drc-only
	make TOP=$(TOP) klayout-drc-view


.PHONY: klayout-eval
klayout-eval: klayout-drc-only klayout-lvs-only