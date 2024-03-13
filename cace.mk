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


define HELP_ENTRIES +=

CACE related rules
  cace-gui

endef


define PARAMETER_ENTRY +=

CACE variables

endef


LOG_CACE:=$(LOG_DIR)/$(TIMESTAMP_TIME)_$(TOP)_cace

CACE_DIR:=$(MODULE_DIR)/cace


CACE:=cd $(MODULE_DIR) && SPICE_USERINIT_DIR=$(NGSPICE_RCDIR) cace
CACE_GUI:=cd $(MODULE_DIR) && SPICE_USERINIT_DIR=$(NGSPICE_RCDIR) cace-gui

CACE_TBS:=$(wildcard $(MODULE_DIR)/cace/*.sch)
CACE_TEST:=UNDEFINED
ifeq (UNDEFINED,$(CACE_TEST))
CACE_TB:=$(word 1,$(CACE_TBS))
else
CACE_TB:=$(filter %/$(CACE_TEST).sch,$(CACE_TBS))
endif
CACE_HTML:=$(CACE_DIR)/$(TOP)_results.html

# CACE FILE points to the description that allow cace.py to perform simulations
# That file can have syntax errors, so we have to validate that before running anything
CACE_FILE:=$(CACE_DIR)/$(TOP).txt
CACE_FILE_RESULTS:=$(CACE_DIR)/$(TOP)_results.txt

# REDFLAG_FILE_WITH_BAD_SYNTAX:=$(shell $(PYTHON) -m cace.common.cace_read $(CACE_FILE))
# REDFLAG_FILE_RESULTS_WITH_BAD_SYNTAX:=$(shell $(PYTHON) -m cace.common.cace_read $(CACE_FILE_RESULTS))

.PHONY: cace-validation
cace-validation:
ifeq (,$(wildcard $(TOP)))
	$(call ERROR_MESSAGE, [cace] there's no TOP defined)
endif
	$(call INFO_MESSAGE, [cace] description file:              $(wildcard $(CACE_FILE)))
	$(call INFO_MESSAGE, [cace] description file with results: $(wildcard $(CACE_FILE_RESULTS)))
	$(call INFO_MESSAGE, [cace] results in html:               $(wildcard $(CACE_HTML)))
	$(call INFO_MESSAGE, [cace] cace tests:                    $(foreach tb,$(CACE_TBS),$(basename $(notdir $(tb)))))
	$(call INFO_MESSAGE, [cace] cace test spice:               $(wildcard $(basename $(CACE_TB)).spice))

# ifeq (,$(wildcard $(CACE_FILE)))
# 	$(call ERROR_MESSAGE, [cace] there's no cace description for the module $(TOP))
# endif


# ifneq (CACE file has no syntax issues.,$(REDFLAG_FILE_WITH_BAD_SYNTAX))
# 	$(call ERROR_MESSAGE, [cace] CACE description has syntax errors)
# endif
# ifneq (CACE file has no syntax issues.,$(REDFLAG_FILE_RESULTS_WITH_BAD_SYNTAX))
# 	$(call WARNING_MESSAGE, [cace] CACE description with results has syntax errors)
# endif


.PHONY: cace-gui
cace-gui:
	$(CACE_GUI) $(CACE_FILE) \
		|& tee $(LOG_CACE)_gui_run.log


.PHONY: cace-cli
cace-cli: cace-validation
	$(CACE) $(CACE_FILE) $(CACE_FILE_RESULTS) \
		-debug \
		|& tee $(LOG_CACE)_cli_run.log


.PHONY: cace-tb
cace-tb: cace-validation
ifeq (,$(CACE_TEST))
	$(call ERROR_MESSAGE, CACE_TEST variable is not set)
endif
	$(XSCHEM) --netlist_path $(TB_DIR) $(CACE_TB) \
		|& tee $(LOG_CACE)_tb_$(basename $(notdir $(CACE_TB))).log
