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


.PHONY: klayout-lvs-view
klayout-lvs-view: klayout-validation
ifeq (,$(ALL_LVSDB))
	$(call ERROR_MESSAGE, [klayout] There's no LVS report for $(TOP))
else
	$(KLAYOUT) -e $(GDS) $(foreach file,$(ALL_LVSDB),-mn $(file))
endif


.PHONY: klayout-lvs-only
klayout-lvs-only: klayout-validation xschem-netlist-lvs-noprefix-fixed
	$(call ERROR_MESSAGE, LVS on klayout not supported for sky130. use netgen instead)
ifeq (VSS,$(GND_NAME))
	$(call WARNING_MESSAGE, GND_NAME is on the default value)
	$(call WARNING_MESSAGE, netlist might not match)
endif
	$(RM) $(REPORT_DIR)/*.lvsdb

# $input                    The input GDS file path.
# $schematic                The input netlist file path.
# $report                   The output database file path.
# $target_netlist           Output netlist path.
# $thr                      Number of cores to be used by LVS checker
# $run_mode                 Select klayout mode Allowed modes (flat , deep, tiling). [default: deep]
# $lvs_sub                  Assign the substrate name used in design.
# $spice_net_names          Discard net names in extracted netlist.
# $spice_comments           Set netlist comments in extracted netlist.
# $scale                    Set scale of 1e6 in extracted netlist.
# $verbose                  Set verbose mode.
# $schematic_simplify       Set schematic simplification in input netlist.
# $net_only                 Set netlist object creation only in extracted netlist.
# $top_lvl_pins             Set top level pins only in extracted netlist.
# $combine                  Set netlist combine only in extracted netlist.
# $purge                    Set netlist purge all only in extracted netlist.
# $purge_nets               Set netlist purge nets only in extracted netlist.
# $fuse                     m2, m3, m4. (default: m4)

	$(KLAYOUT) -b -r $(KLAYOUT_HOME)/lvs/sky130.lvs \
		-rd input=$(GDS) \
		-rd schematic=$(SCH_NETLIST_NOPREFIX) \
		-rd report=$(REPORT_DIR)/$(TOP).lvsdb \
		-rd target_netlist=$(LAYOUT_NETLIST_KLAYOUT) \
        -rd run_mode=flat \
		-rd lvs_sub=$(GND_NAME) \
		-rd verbose \
		-rd schematic_simplify \
		-rd top_lvl_pins \
		-rd combine |& tee $(LOG_KLAYOUT_LVS) || true


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
	$(call WARNING_MESSAGE, Klayout drc on sky130 only has the manufacturing rules, not all of them.)
	$(call WARNING_MESSAGE, Magic DRC is recommended)
	$(RM) $(REPORT_DIR)/*.lyrdb

# $input
# $top_cell
# $report
# $feol
# $beol
# $offgrid
# $seal
# $floating_met
# $thr
# $(KLAYOUT_HOME)/drc/sky130A_mr.drc
	$(KLAYOUT) -b -r $(KLAYOUT_HOME)/drc/sky130A_mr.drc \
		-rd input=$(GDS) \
		-rd report=$(REPORT_DIR)/precheck_$(TOP).lyrdb \
		-rd top_cell=$(GDS_CELL) \
		-rd thr=$(NPROCS) \
		-rd feol=true \
		-rd beol=true \
		-rd offgrid=true \
		-rd floating_met=true \
		-rd seal=true


.PHONY: klayout-drc
klayout-drc: klayout-drc-only
	make TOP=$(TOP) klayout-drc-view


.PHONY: klayout-eval
klayout-eval: klayout-drc-only klayout-lvs-only