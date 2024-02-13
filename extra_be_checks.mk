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

LOG_EBC_SOFT_CHECK=$(LOG_DIR)/$(TIMESTAMP_TIME)_ebc_soft_check_$(TOP).log
LOG_EBC_HIER_CHECK=$(LOG_DIR)/$(TIMESTAMP_TIME)_ebc_hier_check$(TOP).log
LOG_EBC_FULL_LVS=$(LOG_DIR)/$(TIMESTAMP_TIME)_ebc_lvs_$(TOP).log
LOG_EBC_CVC=$(LOG_DIR)/$(TIMESTAMP_TIME)_ebc_cvc_$(TOP).log
LOG_EBC_OEB=$(LOG_DIR)/$(TIMESTAMP_TIME)_ebc_oeb_$(TOP).log

EBC_WORKDIR=$(OUTPUT_DIR)/ebc/work
EBC_LOGS=$(OUTPUT_DIR)/ebc/logs
EBC_SIGNOFF=$(OUTPUT_DIR)/ebc/signoff


ENVIRON= \
	LVS_ROOT=$(EBC_DIR) \
	WORK_ROOT=$(EBC_WORKDIR) \
	LOG_ROOT=$(EBC_LOGS) \
	SIGNOFF_ROOT=$(EBC_SIGNOFF)

# run_softcheck [--noextract] [lvs_config_file [top_layout [layout_file]]]
EBC_SOFT_CHECK=$(ENVIRON) $(EBC_DIR)/run_scheck      $(EBC_CONFIG) $(GDS_CELL) $(GDS)

# run_hier_check top_source verilog_files top_layout layout_file [primitive_prefix [layout_prefix]]
EBC_HIER_CHECK=$(ENVIRON) $(EBC_DIR)/run_hier_check	 $(EBC_CONFIG)

# run_full_lvs [--noextract] [lvs_config_file [top_source [top_layout [layout_file]]]]
EBC_FULL_LVS=$(ENVIRON) $(EBC_DIR)/run_full_lvs      $(EBC_CONFIG) $(TOP) $(GDS_CELL) $(GDS)

# run_cvc [--noextract] [lvs_config_file [top_layout [layout_file]]]]
EBC_CVC=$(ENVIRON) $(EBC_DIR)/run_cvc                $(EBC_CONFIG) $(GDS_CELL) $(GDS)

# run_oeb_check [--noextract] [lvs_config_file [top_layout [layout_file]]]]
EBC_OEB=$(ENVIRON) $(EBC_DIR)/run_oeb_check          $(EBC_CONFIG) $(GDS_CELL) $(GDS)


define HELP_ENTRIES +=

Extra Be Checks related rules:

endef

# Rules
#######

.PHONY: ebc-validation
ebc-validation:
ifeq (,$(EBC_DIR))
	$(call ERROR_MESSAGE, [extra-be-checks] There's no EBC installation)
endif
ifeq (,$(wildcard $(GDS)))
	$(call ERROR_MESSAGE, [extra-be-checks] GDS file $(GDS) doesn't exist)
endif
ifeq (,$(EBC_CONFIG))
	$(call ERROR_MESSAGE, [extra-be-checks] There is no config file)
endif
	$(shell mkdir -p $(EBC_WORKDIR))
	$(shell mkdir -p $(EBC_LOGS))
	$(shell mkdir -p $(EBC_SIGNOFF))

	$(call INFO_MESSAGE, [extra-be-checks] installation dir:  $(EBC_DIR))
	$(call INFO_MESSAGE, [extra-be-checks] work dir:          $(EBC_WORKDIR))
	$(call INFO_MESSAGE, [extra-be-checks] GDS:               $(GDS))


.PHONY: ebc-hier
ebc-hier:
	$(EBC_HIER_CHECK) |& tee $(LOG_EBC_HIER_CHECK)


.PHONY: ebc-softcheck
ebc-softcheck: ebc-validation
	$(EBC_SOFT_CHECK) |& tee $(LOG_EBC_SOFT_CHECK)


.PHONY: ebc-lvs
ebc-lvs: ebc-validation
	$(EBC_FULL_LVS) |& tee $(LOG_EBC_SOFT_CHECK)


.PHONY: ebc-cvc
ebc-cvc: ebc-validation
	$(EBC_CVC) |& tee $(LOG_EBC_CVC)


.PHONY: ebc-oeb
ebc-oeb: ebc-validation
	$(EBC_OEB) |& tee $(LOG_EBC_OEB)
