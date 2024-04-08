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

LOG_NETGEN=$(LOG_DIR)/$(TIMESTAMP_TIME)_netgen_$(TOP).log

NETGEN=netgen -batch lvs

NETGEN_LVS_REPORT_MAGIC=$(REPORT_DIR)/lvs_magic_comp.out
NETGEN_LVS_REPORT_KLAYOUT=$(REPORT_DIR)/lvs_klayout_comp.out

NETGEN_LVS_WITH_MAGIC=$(NETGEN) \
		"$(LAYOUT_NETLIST_MAGIC) $(GDS_CELL)_clean" \
		"$(SCH_NETLIST_PREFIX) $(GDS_CELL)" \
		$(NETGEN_RCFILE)

NETGEN_LVS_WITH_KLAYOUT=$(NETGEN) \
		"$(LAYOUT_NETLIST_KLAYOUT) $(GDS_CELL)" \
		"$(SCH_NETLIST_NOPREFIX) $(GDS_CELL)" \
		$(NETGEN_RCFILE)

define HELP_ENTRIES += 

Netgen related rules:
  netgen-validation:  Evaluates relevant file existence. It's used by other rules.
  netgen-lvs-magic:   Perform LVS with schematic netlist and extracted circuit netlist
  netgen-lvs-klayout: Perform LVS with schematic netlist and extracted circuit netlist

  Required variables:
	GDS:                  Layout file
	GDS_CELL:             Cellname in layout file
	GDS_DIR:              Directory for layout related information
	LAYOUT_NETLIST_KLAYOUT:    Netlist extracted with klayout
	LAYOUT_NETLIST_MAGIC:      Netlist extracted with magic
	SCH_NETLIST_PREFIX:   Schematic extraction with prefix. Required in lvs with magic extraction
	SCH_NETLIST_NOPREFIX: Schematic extraction without prefix. Required by klayout
	NETGEN_RCFILE:            Configuration file for netgen

endef


# Rules
#######

.PHONY: netgen-validation
netgen-validation:
ifeq (,$(wildcard $(GDS)))
	$(call ERROR_MESSAGE, [netgen] GDS file $(GDS) doesn't exist$)
endif	
	$(call INFO_MESSAGE, [netgen] directory:                 $(wildcard $(GDS_DIR)))
	$(call INFO_MESSAGE, [netgen] GDS:                       $(wildcard $(GDS)))
	$(call INFO_MESSAGE, [netgen] xschem netlist w/prefix:   $(wildcard $(SCH_NETLIST_PREFIX)))
	$(call INFO_MESSAGE, [netgen] xschem netlist wo/prefix:  $(wildcard $(SCH_NETLIST_NOPREFIX)))
	$(call INFO_MESSAGE, [netgen] magic extracted netlist:   $(wildcard $(LAYOUT_NETLIST_MAGIC)))
	$(call INFO_MESSAGE, [netgen] klayout extracted netlist: $(wildcard $(LAYOUT_NETLIST_KLAYOUT)))
	$(call INFO_MESSAGE, [netgen] rc file:                   $(wildcard $(NETGEN_RCFILE)))
	$(call INFO_MESSAGE, [netgen] lvs report magic:          $(wildcard $(NETGEN_LVS_REPORT_KLAYOUT)))
	$(call INFO_MESSAGE, [netgen] lvs report klayout:        $(wildcard $(NETGEN_LVS_REPORT_MAGIC)))


.PHONY: netgen-lvs-magic
netgen-lvs-magic: netgen-validation xschem-netlist-lvs-prefix magic-lvs-extraction
	cd $(GDS_DIR) && $(NETGEN_LVS_WITH_MAGIC) |& tee $(LOG_NETGEN) || true
	mv $(GDS_DIR)/comp.out $(NETGEN_LVS_REPORT_MAGIC)
	@echo Created $(NETGEN_LVS_REPORT_MAGIC)
	grep "Netlist" $(NETGEN_LVS_REPORT_MAGIC)


.PHONY: netgen-lvs-klayout
netgen-lvs-klayout: netgen-validation xschem-netlist-lvs-noprefix
ifeq (,$(LAYOUT_NETLIST_KLAYOUT))
	$(call ERROR_MESSAGE, There's no klayout extracted netlist. run `klayout-lvs`)
endif
	sed -i '/C.*cap_mim_2f0_m4m5_noshield/s/W/c_width/' $(LAYOUT_NETLIST_KLAYOUT)
	sed -i '/C.*cap_mim_2f0_m4m5_noshield/s/L/c_length/' $(LAYOUT_NETLIST_KLAYOUT)
	sed -i '/R.*ppoly/s/W/r_width/' $(LAYOUT_NETLIST_KLAYOUT)
	sed -i '/R.*ppoly/s/L/r_length/' $(LAYOUT_NETLIST_KLAYOUT)

	cd $(GDS_DIR) && $(NETGEN_LVS_WITH_KLAYOUT) |& tee $(LOG_NETGEN) || true
	mv $(GDS_DIR)/comp.out $(NETGEN_LVS_REPORT_KLAYOUT)
	@echo Created $(NETGEN_LVS_REPORT_KLAYOUT)
	grep "Netlist" $(NETGEN_LVS_REPORT_KLAYOUT)
