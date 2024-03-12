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


LOG_KLAYOUT=$(LOG_DIR)/$(TIMESTAMP_TIME)_$(TOP)_klayout


ALL_LYRDB:=$(filter %.lyrdb,$(wildcard $(REPORT_DIR)/*))
ALL_LVSDB:=$(filter %.lvsdb,$(wildcard $(REPORT_DIR)/*))

PADRING_FILE:=$(wildcard $(GDS_DIR)/*.yaml) \
	$(wildcard $(GDS_DIR)/*.yml)

ifneq (,$(wildcard $(KLAYOUT_RCFILE)))
KLAYOUT=klayout -c $(KLAYOUT_RCFILE) -t
else
$(call WARNING_MESSAGE, klayoutrc not found)
KLAYOUT=klayout -t
endif

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
	$(call ERROR_MESSAGE, [klayout] GDS file $(GDS) doesn't exist)
endif	
	$(call INFO_MESSAGE, [klayout] GDS:               $(wildcard $(GDS)))
	$(call INFO_MESSAGE, [klayout] directory:         $(wildcard $(GDS_DIR)))

ifeq (,$(wildcard $(SCH_NETLIST_NOPREFIX)))
	$(call WARNING_MESSAGE, [klayout] Schematic netlist doesn't exist$)
else
	$(call INFO_MESSAGE, [klayout] schematic netlist: $(wildcard $(SCH_NETLIST_NOPREFIX)))
endif
	$(call INFO_MESSAGE, [klayout] klayoutrc:         $(wildcard $(KLAYOUT_RCFILE)))
	$(call INFO_MESSAGE, [klayout] padring yaml:      $(wildcard $(PADRING_FILE)))
	$(call INFO_MESSAGE, [klayout] gds netlist:       $(wildcard $(LAYOUT_NETLIST_KLAYOUT)))
	$(call INFO_MESSAGE, [klayout] DRC reports:       $(ALL_LYRDB))
	$(call INFO_MESSAGE, [klayout] LVS reports:       $(ALL_LVSDB))


.PHONY: klayout-view
klayout-view: klayout-validation
	$(KLAYOUT) -ne $(GDS) |& tee $(LOG_KLAYOUT)_view.log


.PHONY: klayout-edit
klayout-edit: klayout-validation
	$(KLAYOUT) -e $(GDS) |& tee $(LOG_KLAYOUT)_edit.log


ifeq (sky130A,$(PDK))
include $(_IC_MAKEFILE)/klayout_sky130_verification.mk
else ifeq (gf180mcuD,$(PDK))
include $(_IC_MAKEFILE)/klayout_gf180mcu_verification.mk
endif


.PHONY: klayout-lvs-view
klayout-lvs-view: klayout-validation
ifeq (,$(ALL_LVSDB))
	$(call ERROR_MESSAGE, [klayout] There's no LVS report for $(TOP))
else
	$(KLAYOUT) -e $(GDS) $(foreach file,$(ALL_LVSDB),-mn $(file))
endif


.PHONY: klayout-lvs
klayout-lvs: klayout-lvs-only
	make TOP=$(TOP) klayout-lvs-view


.PHONY: klayout-drc-view
klayout-drc-view: klayout-validation
ifeq (,$(ALL_LYRDB))
	$(call ERROR_MESSAGE, [klayout] There's no DRC report for $(TOP))
else
	$(KLAYOUT) -e $(GDS) $(foreach file,$(ALL_LYRDB),-m $(file))
endif


.PHONY: klayout-drc
klayout-drc: klayout-drc-only
	$(MAKE) klayout-drc-view


.PHONY: klayout-eval
klayout-eval: klayout-drc-only klayout-lvs-only


.PHONY: klayout-padring
klayout-padring: klayout-validation
	$(KLAYOUT) -t -e -rr $(_IC_MAKEFILE)/scripts/padring.py \
		-rd padring_file=$(PADRING_FILE) \
		$(GDS)