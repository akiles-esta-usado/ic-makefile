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

XSCHEM_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_xschem_$(TOP).log
XSCHEM_NETLIST_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_xschem_netlist_$(TOP).log
XSCHEM_NETLIST_PREFIX_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_xschem_netlist_prefix_$(TOP).log
XSCHEM_NETLIST_NOPREFIX_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_xschem_netlist_noprefix_$(TOP).log

TOP_SCH_DIR:=$(abspath $(dir $(TOP_SCH)))

# https://xschem.sourceforge.io/stefan/xschem_man/developer_info.html
#--preinit 'set lvs_netlist 1; set spiceprefix 0'
ifeq (,$(XSCHEM_BINARY))
XSCHEM_BINARY=xschem
endif

XSCHEM=$(XSCHEM_BINARY) --rcfile $(XSCHEM_RCFILE) \
	--netlist \
	--netlist_path $(dir $(TOP_SCH)) \
	--netlist_filename $(TOP).spice

XSCHEM_BATCH=$(XSCHEM) \
	--no_x \
	--quit

define HELP_ENTRIES +=

Xschem related rules:
  xschem-validation:            Evaluate file existence. Is used by other rules.
  xschem-sch:                   Open schematic asociated with TOP 
  xschem-tb:                    Open testbench asociated with TOP 
  xschem-sym:                   Open schematic symbol
  xschem-netlist:               Generates a plain netlist executable by ngspice
  xschem-netlist-lvs-prefix:    Generates an lvs netlist usable by magic
  xschem-netlist-lvs-noprefix:  Generates an lvs netlist usable by klayout
                                Applies the "fix-parameters" rule
  xschem-netlist-lvs-noprefix-fixed: Klayout LVS requires some patches over
                                the netlist generated with xschem
                                This functions is applied by noprefix rule

  Required variables:
    TOP_SCH:                  Schematic
    TOP_TB:                   Testbench
    TOP_SYM:                  Symbol
    TOP_SCH_DIR:              Directory for schematic related information
    TOP_NETLIST_SCH:          Netlist extracted with xschem. Used by spice simulator
    TOP_NETLIST_LVS_PREFIX:   Schematic extraction with prefix. Required in lvs with magic extraction
    TOP_NETLIST_LVS_NOPREFIX: Schematic extraction without prefix. Required by klayout
    XSCHEM_RCFILE:            Configuration file for xschem

endef

# Rules
#######

.PHONY: xschem-validation
xschem-validation:
ifeq (,$(TOP_SCH))
	$(call ERROR_MESSAGE, [xschem] There's no schematic for $(TOP))
endif

	$(call INFO_MESSAGE, [xschem] rcfile:               $(XSCHEM_RCFILE))
	$(call INFO_MESSAGE, [xschem] directory:            $(TOP_SCH_DIR))
	$(call INFO_MESSAGE, [xschem] schematic:            $(TOP_SCH))

ifeq (,$(TOP_TB))
	$(call WARNING_MESSAGE, [xschem] There's no testbench for $(TOP))
else
	$(call INFO_MESSAGE, [xschem] testbench:            $(TOP_TB))
endif

	$(call INFO_MESSAGE, [xschem] netlist:              $(TOP_NETLIST_SCH))
	$(call INFO_MESSAGE, [xschem] netlist lvs noprefix: $(TOP_NETLIST_LVS_NOPREFIX))
	$(call INFO_MESSAGE, [xschem] netlist lvs prefix:   $(TOP_NETLIST_LVS_PREFIX))


.PHONY: xschem-sch
xschem-sch: xschem-validation
ifeq (,$(TOP))
	$(XSCHEM) 0_top.sch |& tee $(XSCHEM_LOG)
else
	$(XSCHEM) $(TOP_SCH) |& tee $(XSCHEM_LOG)
endif


.PHONY: xschem-tb
xschem-tb: xschem-validation
	$(XSCHEM) $(TOP_TB) |& tee $(XSCHEM_LOG)


.PHONY: xschem-sym
xschem-sym: xschem-validation
	$(XSCHEM) $(TOP_SYM) |& tee $(XSCHEM_LOG)


.PHONY: xschem-netlist
xschem-netlist: xschem-validation
	$(XSCHEM_BATCH) \
		$(TOP_SCH) |& tee $(XSCHEM_NETLIST_LOG)


# Used in Magic
.PHONY: xschem-netlist-lvs-prefix
xschem-netlist-lvs-prefix: xschem-validation
	$(XSCHEM_BATCH) \
		--preinit 'set lvs_netlist 1' \
		--netlist_filename $(TOP_NETLIST_LVS_PREFIX) \
		$(TOP_SCH) |& tee $(XSCHEM_NETLIST_PREFIX_LOG)


# Used in Klayout
.PHONY: xschem-netlist-lvs-noprefix
xschem-netlist-lvs-noprefix: xschem-validation
	$(XSCHEM_BATCH) \
		--preinit 'set lvs_netlist 1; set spiceprefix 0' \
		--netlist_filename $(TOP_NETLIST_LVS_NOPREFIX) \
		$(TOP_SCH) |& tee $(XSCHEM_NETLIST_NOPREFIX_LOG)


.PHONY: xschem-netlist-lvs-noprefix-fixed
xschem-netlist-lvs-noprefix-fixed: xschem-validation xschem-netlist-lvs-noprefix
	sed -i '/C.*cap_mim_2f0_m4m5_noshield/s/c_width/W/' $(TOP_NETLIST_LVS_NOPREFIX)
	sed -i '/C.*cap_mim_2f0_m4m5_noshield/s/c_length/L/' $(TOP_NETLIST_LVS_NOPREFIX)
	sed -i '/R.*ppoly/s/r_width/W/' $(TOP_NETLIST_LVS_NOPREFIX)
	sed -i '/R.*ppoly/s/r_length/L/' $(TOP_NETLIST_LVS_NOPREFIX)
