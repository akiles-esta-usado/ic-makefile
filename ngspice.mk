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

NGSPICE_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_ngspice_$(TOP).log

NGSPICE=SPICE_USERINIT_DIR=$(PWD) ngspice -a --define=num_threads=$(NPROCS)

define HELP_ENTRIES +=

Ngspice related Rules:
  ngspice-sim:  Extracts netlist and performs simulation. This rules works when simulation results on a .raw file

endef


# Rules
#######

.PHONY: ngspice-sim
ngspice-sim: xschem-netlist
	cd $(dir $(TOP_SCH)) && $(NGSPICE) $(TOP_NETLIST_SCH) |& tee $(NGSPICE_LOG)
