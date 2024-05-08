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

# == Variables == #

LOG_KLAYOUT=$(LOG_DIR)/$(TIMESTAMP_TIME)_$(TOP)_klayout

# Sometimes, drc/lvs should be performed on FLAT run mode.
LVS_FLAT=
DRC_FLAT=

# If this variable is not set correctly. LVS will never succeed
# This variable is case sensitive, VSS != vss
GND_NAME:=VSS

LVS_CELL:=$(GDS_CELL)
DRC_CELL:=$(GDS_CELL)

ifneq (,$(wildcard $(KLAYOUT_RCFILE)))
KLAYOUT=klayout -c $(KLAYOUT_RCFILE) -t
else
$(call WARNING_MESSAGE, klayoutrc not found)
KLAYOUT=klayout -t
endif

# By default use deep. Use FLAT only if
# - Value is different than ""
# - Value is not N
KLAYOUT_DRC_RUN_MODE=deep
ifneq (,$(DRC_FLAT))
ifneq (N,$(DRC_FLAT))
KLAYOUT_DRC_RUN_MODE=flat
endif
endif

KLAYOUT_LVS_RUN_MODE=deep
ifneq (,$(LVS_FLAT))
ifneq (N,$(LVS_FLAT))
KLAYOUT_LVS_RUN_MODE=flat
endif
endif

KLAYOUT_DRC_REPORT_PREFIX=$(REPORT_DIR)/drc_efabless_$(GDS_CELL)_$(KLAYOUT_DRC_RUN_MODE)

ALL_LYRDB:=$(filter %.lyrdb,$(wildcard $(REPORT_DIR)/*))
ALL_LVSDB:=$(filter %.lvsdb,$(wildcard $(REPORT_DIR)/*))

PADRING_FILE:=$(wildcard $(GDS_DIR)/*.yaml) \
	$(wildcard $(GDS_DIR)/*.yml)


# == Variables - Documentation == #

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

define PARAMETER_ENTRY +=

Klayout variables:
  GND_NAME: Indicate the substrate potential (lowest) on a specific layout

  ex: make GND_NAME=B

endef


# == Rules == #

.PHONY: klayout-validation
klayout-validation:
ifeq (,$(wildcard $(GDS)))
	$(call ERROR_MESSAGE, [klayout] GDS file $(GDS) doesn't exist)
endif	
	$(call INFO_MESSAGE, [klayout] GDS:               $(wildcard $(GDS)))
	$(call INFO_MESSAGE, [klayout] directory:         $(wildcard $(GDS_DIR)))

ifeq (,$(wildcard $(SCH_NETLIST_NOPREFIX)))
	$(call WARNING_MESSAGE, [klayout] Schematic netlist doesn't exist)
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

# == Rules - Validation == #

.PHONY: klayout-lvs-view
klayout-lvs-view: klayout-validation
ifeq (,$(ALL_LVSDB))
	$(call ERROR_MESSAGE, [klayout] There's no LVS report for $(TOP))
else
	$(KLAYOUT) -e $(GDS) $(foreach file,$(ALL_LVSDB),-mn $(file))
endif


.PHONY: klayout-drc-view
klayout-drc-view: klayout-validation
ifeq (,$(ALL_LYRDB))
	$(call ERROR_MESSAGE, [klayout] There's no DRC report for $(TOP))
else
	$(KLAYOUT) -e $(GDS) $(foreach file,$(ALL_LYRDB),-m $(file))
endif


.PHONY: klayout-lvs
klayout-lvs: klayout-lvs-only
	make TOP=$(TOP) klayout-lvs-view


.PHONY: klayout-drc
klayout-drc: klayout-drc-only
	$(MAKE) klayout-drc-view


# == Rules - Including PDK specific LVS/DRC rules == #

# As a common interface each file should define
# - klayout-lvs-only
# - klayout-drc-only

ifeq (sky130A,$(PDK))
include $(_IC_MAKEFILE)/klayout_sky130_verification.mk
else ifeq (gf180mcuD,$(PDK))
include $(_IC_MAKEFILE)/klayout_gf180mcu_verification.mk
endif


# == Rules - Padring functions == #

.PHONY: klayout-padring
klayout-padring: klayout-validation
	$(KLAYOUT) -t -e -rr $(_IC_MAKEFILE)/scripts/padring.py \
		-rd padring_file=$(PADRING_FILE) \
		$(GDS)


.PHONY: klayout-padring-2
klayout-padring-2: klayout-validation
	$(KLAYOUT) -t -e -rr $(_IC_MAKEFILE)/scripts/padring-2.py \
		-rd padring_file=$(PADRING_FILE) \
		$(GDS)


.PHONY: klayout-extract-topcells
klayout-extract-topcells: klayout-validation
	$(KLAYOUT) -zz \
		-r $(_IC_MAKEFILE)/scripts/top-cell-extractor.py \
		-rd layout=$(GDS) \
		-rd output_dir=$(GDS_DIR)

# == Update make variable == #

MAKE=$(MAKE) \
	DRC_FLAT=$(DRC_FLAT) \
	LVS_FLAT=$(LVS_FLAT)