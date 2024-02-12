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

# If this variable is not set correctly. LVS will never succeed
# This variable is case sensitive, VSS != vss
GND_NAME:=VSS

define PARAMETER_ENTRY +=

Klayout variables:
  GND_NAME: Indicate the substrate potential (lowest) on a specific layout

  ex: make GND_NAME=B

endef

# Files, directories and Aliases
################################

LOG_KLAYOUT=$(LOG_DIR)/$(TIMESTAMP_TIME)_klayout_$(TOP).log
LOG_KLAYOUT_LVS=$(LOG_DIR)/$(TIMESTAMP_TIME)_klayout_lvs_$(TOP).log
LOG_KLAYOUT_DRC_EFABLES=$(LOG_DIR)/$(TIMESTAMP_TIME)_klayout_drc_efabless_$(TOP).log
LOG_KLAYOUT_DRC_PRECHECK=$(LOG_DIR)/$(TIMESTAMP_TIME)_klayout_drc_precheck_$(TOP).log


ALL_LYRDB:=$(filter %.lyrdb,$(wildcard $(REPORT_DIR)/*))
ALL_LVSDB:=$(filter %.lvsdb,$(wildcard $(REPORT_DIR)/*))


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
  name that the bulk has on the layout. (See parameters entry)
    $$ make TOP=resistor GND_NAME=B klayout-lvs

endef


# Rules
#######

.PHONY: klayout-validation
klayout-validation:
ifeq (,$(wildcard $(GDS)))
	$(call ERROR_MESSAGE, [klayout] GDS file $(GDS) doesn't exist$)
endif	
	$(call INFO_MESSAGE, [klayout] GDS:               $(GDS))
	$(call INFO_MESSAGE, [klayout] directory:         $(GDS_DIR))

ifeq (,$(wildcard $(SCH_NETLIST_NOPREFIX)))
	$(call WARNING_MESSAGE, [klayout] Schematic netlist doesn't exist$)
else
	$(call INFO_MESSAGE, [klayout] schematic netlist: $(SCH_NETLIST_NOPREFIX))
endif
	$(call INFO_MESSAGE, [klayout] gds netlist:       $(wildcard $(LAYOUT_NETLIST_KLAYOUT)))
	$(call INFO_MESSAGE, [klayout] DRC reports:       $(ALL_LYRDB))
	$(call INFO_MESSAGE, [klayout] LVS reports:       $(ALL_LVSDB))


# Visualization
###############

.PHONY: klayout-view
klayout-view: klayout-validation
	$(KLAYOUT) -ne $(GDS) |& tee $(LOG_KLAYOUT)


.PHONY: klayout-edit
klayout-edit: klayout-validation
	$(KLAYOUT) -e $(GDS) |& tee $(LOG_KLAYOUT)


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
ifeq (,$(ALL_LVSDB))
	$(call ERROR_MESSAGE, [klayout] There's no LVS report for $(TOP))
else
	$(KLAYOUT) -e $(GDS) $(foreach file,$(ALL_LVSDB),-mn $(file))
endif


.PHONY: klayout-lvs-only
klayout-lvs-only: klayout-validation xschem-netlist-lvs-noprefix-fixed
	$(RM) $(REPORT_DIR)/*.lvsdb

	# Since the netlist could not exists on first run
	# It's recommended use TOP.spice instead of SCH_NETLIST_NOPREFIX
	python $(KLAYOUT_HOME)/lvs/run_lvs.py \
		--variant=D \
		--run_mode=flat \
		--verbose \
		--lvs_sub=$(GND_NAME) \
		--run_dir=$(REPORT_DIR) \
		--layout=$(GDS) \
		--netlist=$(SCH_NETLIST_NOPREFIX) \
		--top_lvl_pins \
		--schematic_simplify \
		--combine |& tee $(LOG_KLAYOUT_LVS) || true

	mv $(REPORT_DIR)/*.cir $(LAYOUT_NETLIST_KLAYOUT)



.PHONY: klayout-lvs
klayout-lvs: klayout-lvs-only
	make TOP=$(TOP) klayout-lvs-view


# DRC RULES
###########

.PHONY: klayout-drc-view
klayout-drc-view: klayout-validation
ifeq (,$(ALL_LYRDB))
	$(call ERROR_MESSAGE, [klayout] There's no DRC report for $(TOP))
else
	$(KLAYOUT) -e $(GDS) $(foreach file,$(ALL_LYRDB),-m $(file))
endif


.PHONY: klayout-drc-only
klayout-drc-only: klayout-validation
	$(RM) $(REPORT_DIR)/*.lyrdb

	python $(KLAYOUT_HOME)/drc/run_drc.py \
		--path $(GDS) \
		--variant=D \
		--topcell=$(GDS_CELL) \
		--run_dir=$(REPORT_DIR) \
		--run_mode=flat \
		--antenna \
		--density \
		--thr=$(NPROCS) \
		--verbose |& tee $(LOG_KLAYOUT_DRC_EFABLES) || true

	$(KLAYOUT) -b -r $(KLAYOUT_HOME)/drc/gf180mcuD_mr.drc \
		-rd input=$(GDS) \
		-rd topcell=$(GDS_CELL) \
		-rd report=$(REPORT_DIR)/precheck_$(TOP).lyrdb \
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
		-rd beol=true |& tee $(LOG_KLAYOUT_DRC_PRECHECK) || true


.PHONY: klayout-drc
klayout-drc: klayout-drc-only
	make TOP=$(TOP) klayout-drc-view


.PHONY: klayout-eval
klayout-eval: klayout-drc-only klayout-lvs-only