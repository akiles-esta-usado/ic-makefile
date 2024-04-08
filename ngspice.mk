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

LOG_NGSPICE=$(LOG_DIR)/$(TIMESTAMP_TIME)_ngspice_$(TOP).log

NGSPICE=SPICE_USERINIT_DIR=$(NGSPICE_RCDIR) ngspice \
	-a \
	--define=num_threads=$(NPROCS)

GCC=gcc -Wall -Wpedantic -g

# This allows using by default the tb name on the raw name.
# TODO: See how to define with xschem the name of the raw file.
# -r $(basename $(notdir $(TB_NETLIST))).raw

define HELP_ENTRIES +=

Ngspice related Rules:
  ngspice-sim:  Extracts netlist and performs simulation. This rules works when simulation results on a .raw file

endef


# Rules
#######

.PHONY: ngspice-validation
ngspice-validation:
ifeq (,$(TEST))
	$(call WARNING_MESSAGE, [ngspice] TEST not selected)
endif

ifeq (,$(TB))
	$(call ERROR_MESSAGE, [ngspice] There aren't testbenchs)
endif

	$(call INFO_MESSAGE, [ngspice] Testbench:            $(wildcard $(TB)))
	$(call INFO_MESSAGE, [ngspice] Directory:            $(wildcard $(TB_DIR)))
	$(call INFO_MESSAGE, [ngspice] Testbench netlist:    $(wildcard $(TB_NETLIST)))
	$(call INFO_MESSAGE, [ngspice] All testbenchs:       $(wildcard $(TBS)))
	$(call INFO_MESSAGE, [ngspice] All verilog files:    $(wildcard $(VERILOGS)))


.PHONY: ngspice-sim
ngspice-sim: ngspice-validation xschem-test-netlist
	cd $(TB_DIR) && $(NGSPICE) $(TB_NETLIST) |& tee $(LOG_NGSPICE)


.PHONY: ngspice-compile-verilog
ngspice-compile-verilog: ngspice-validation
	mkdir -p $(CODEMODELS_DIR)
	cd $(CODEMODELS_DIR) && $(NGSPICE) vlnggen $(VERILOG) |& tee $(LOG_NGSPICE)


.PHONY: ngspice-compile-codemodel
ngspice-compile-codemodel: ngspice-validation
	mkdir -p $(CODEMODELS_DIR)
	$(foreach model,$(CODE_MODELS),echo hola)
	#cd $(CODEMODELS_DIR) && $(NGSPICE) vlnggen $(VERILOG) |& tee $(LOG_NGSPICE)