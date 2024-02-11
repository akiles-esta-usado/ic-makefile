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

NETGEN_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_netgen_$(TOP).log

NETGEN=netgen -batch lvs

NETGEN_LVS_WITH_MAGIC=$(NETGEN) \
		"$(TOP_NETLIST_LVS_PREFIX) $(TOP_GDS_CELL)" \
		"$(TOP_EXTRACTED_MAGIC) $(TOP_GDS_CELL)" \
		$(NETGEN_RCFILE)

NETGEN_LVS_WITH_KLAYOUT=$(NETGEN) \
		"$(TOP_NETLIST_LVS_NOPREFIX) $(TOP_GDS_CELL)" \
		"$(TOP_EXTRACTED_KLAYOUT) $(TOP_GDS_CELL)" \
		$(NETGEN_RCFILE)

define HELP_ENTRIES += 

Netgen related rules:
  netgen-validation:  Evaluates relevant file existence. It's used by other rules.
  netgen-lvs-magic:   Perform LVS with schematic netlist and extracted circuit netlist
  netgen-lvs-klayout: Perform LVS with schematic netlist and extracted circuit netlist

  Required variables:
	TOP_GDS:                  Layout file
	TOP_GDS_CELL:             Cellname in layout file
	TOP_GDS_DIR:              Directory for layout related information
	TOP_EXTRACTED_KLAYOUT:    Netlist extracted with klayout
	TOP_EXTRACTED_MAGIC:      Netlist extracted with magic
	TOP_NETLIST_LVS_PREFIX:   Schematic extraction with prefix. Required in lvs with magic extraction
	TOP_NETLIST_LVS_NOPREFIX: Schematic extraction without prefix. Required by klayout
	NETGEN_RCFILE:            Configuration file for netgen

endef


# Rules
#######

.PHONY: netgen-validation
netgen-validation:
ifeq (,$(wildcard $(TOP_GDS)))
	$(call ERROR_MESSAGE, [netgen] GDS file $(TOP_GDS) doesn't exist$)
endif	
	$(call INFO_MESSAGE, [netgen] directory:                 $(TOP_GDS_DIR))
	$(call INFO_MESSAGE, [netgen] GDS:                       $(TOP_GDS))
	$(call INFO_MESSAGE, [netgen] xschem netlist w/prefix:   $(TOP_NETLIST_LVS_PREFIX))
	$(call INFO_MESSAGE, [netgen] xschem netlist wo/prefix:  $(TOP_NETLIST_LVS_NOPREFIX))
	$(call INFO_MESSAGE, [netgen] magic extracted netlist:   $(TOP_EXTRACTED_MAGIC))
	$(call INFO_MESSAGE, [netgen] klayout extracted netlist: $(TOP_EXTRACTED_KLAYOUT))
	$(call INFO_MESSAGE, [netgen] rc file:                   $(NETGEN_RCFILE))


.PHONY: netgen-lvs-magic
netgen-lvs-magic: netgen-validation magic-lvs-extraction xschem-netlist-lvs-prefix
	cd $(TOP_GDS_DIR) && $(NETGEN_LVS_WITH_MAGIC) |& tee $(NETGEN_LOG) || true
	mv $(TOP_GDS_DIR)/comp.out $(GDS_REPORT_DIR)/lvs_magic_comp.out
	grep "Netlist" $(GDS_REPORT_DIR)/lvs_magic_comp.out

.PHONY: netgen-lvs-klayout
netgen-lvs-klayout: netgen-validation xschem-netlist-lvs-noprefix
ifeq (,$(TOP_EXTRACTED_KLAYOUT))
	$(call ERROR_MESSAGE, There's no klayout extracted netlist. run `klayout-lvs`)
endif
	sed -i '/C.*cap_mim_2f0_m4m5_noshield/s/W/c_width/' $(TOP_EXTRACTED_KLAYOUT)
	sed -i '/C.*cap_mim_2f0_m4m5_noshield/s/L/c_length/' $(TOP_EXTRACTED_KLAYOUT)
	sed -i '/R.*ppoly/s/W/r_width/' $(TOP_EXTRACTED_KLAYOUT)
	sed -i '/R.*ppoly/s/L/r_length/' $(TOP_EXTRACTED_KLAYOUT)

	cd $(TOP_GDS_DIR) && $(NETGEN_LVS_WITH_KLAYOUT) |& tee $(NETGEN_LOG) || true
	mv $(TOP_GDS_DIR)/comp.out $(GDS_REPORT_DIR)/lvs_klayout_comp.out
	grep "Netlist" $(GDS_REPORT_DIR)/lvs_klayout_comp.out
