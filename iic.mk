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

LOG_IIC=$(LOG_DIR)/$(TIMESTAMP_TIME)_IIC_$(TOP).log

IIC_DIR=$(abspath $(_IC_MAKEFILE)/submodules/osic-multitool)

IIC_OUT_DIR=$(OUTPUT_DIR)/iic

IIC_LVS_REPORT_MAGIC=$(REPORT_DIR)/lvs_magic_comp.out
IIC_LVS_REPORT_KLAYOUT=$(REPORT_DIR)/lvs_klayout_comp.out


define HELP_ENTRIES += 

IIC related rules:
  IIC-validation:  Evaluates relevant file existence. It's used by other rules.
  IIC-lvs-magic:   Perform LVS with schematic netlist and extracted circuit netlist
  IIC-lvs-klayout: Perform LVS with schematic netlist and extracted circuit netlist

  Required variables:
	GDS:                  Layout file
	GDS_CELL:             Cellname in layout file
	GDS_DIR:              Directory for layout related information
	LAYOUT_NETLIST_KLAYOUT:    Netlist extracted with klayout
	LAYOUT_NETLIST_MAGIC:      Netlist extracted with magic
	SCH_NETLIST_PREFIX:   Schematic extraction with prefix. Required in lvs with magic extraction
	SCH_NETLIST_NOPREFIX: Schematic extraction without prefix. Required by klayout
	IIC_RCFILE:            Configuration file for IIC

endef


# Rules
#######

.PHONY: iic-validation
iic-validation:
ifeq (,$(wildcard $(IIC_DIR)))
	$(call ERROR_MESSAGE, [iic] Submodule not initialized)
endif
	$(call INFO_MESSAGE, [iic] directory:                 $(wildcard $(IIC_DIR)))
	sed -i "s/gf180mcuC/gf180mcuD/" $(IIC_DIR)/iic-drc.sh
	mkdir -p $(IIC_OUT_DIR)



.PHONY: iic-drc
iic-drc: iic-validation
	$(IIC_DIR)/iic-drc.sh
	$(IIC_DIR)/iic-drc.sh \
		-d \
		-w $(IIC_OUT_DIR) \
		-m \
		$(GDS)

.PHONY: iic-lvs
iic-lvs: iic-validation
	$(IIC_DIR)/iic-lvs.sh
# $(IIC_DIR)/iic-lvs.sh \
# 	-d \
# 	-w $(IIC_OUT_DIR) \
# 	-m \
# 	$(GDS)
