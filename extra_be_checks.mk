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

EBC_SOFT_CHECK_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_ebc_soft_check_$(TOP).log
EBC_HIER_CHECK_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_ebc_hier_check$(TOP).log
EBC_FULL_LVS_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_ebc_lvs_$(TOP).log
EBC_CVC_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_ebc_cvc_$(TOP).log
EBC_OEB_LOG=$(LOG_DIR)/$(TIMESTAMP_TIME)_ebc_oeb_$(TOP).log


EBC_BASE=$(realpath ../extra_be_checks)
EBC_WORKDIR=$(TOP_GDS_DIR)/ebc
EBC_LOGS=$(EBC_WORKDIR)/logs
EBC_SIGNOFF=$(EBC_WORKDIR)/signoff

EBC_CONFIG=$(realpath ./lvs_config.json)

ENVIRON= \
	LVS_ROOT=$(EBC_BASE) \
	WORK_ROOT=$(EBC_WORKDIR) \
	LOG_ROOT=$(EBC_LOGS) \
	SIGNOFF_ROOT=$(EBC_SIGNOFF)

EBC_SOFT_CHECK=$(ENVIRON) $(EBC_BASE)/run_scheck
EBC_HIER_CHECK=$(ENVIRON) $(EBC_BASE)/run_hier_check
EBC_FULL_LVS=$(ENVIRON) $(EBC_BASE)/run_full_lvs
EBC_CVC=$(ENVIRON) $(EBC_BASE)/run_cvc
EBC_OEB=$(ENVIRON) $(EBC_BASE)/run_oeb_check


define HELP_ENTRIES +=

Extra Be Checks related rules:

endef

# Rules
#######

.PHONY: ebc-validation
ebc-validation:
ifeq (,$(EBC_BASE))
	$(call ERROR_MESSAGE, [extra-be-checks] There's no EBC installation)
endif
ifeq (,$(wildcard $(TOP_GDS)))
	$(call ERROR_MESSAGE, [extra-be-checks] GDS file $(TOP_GDS) doesn't exist)
endif
ifeq (,$(EBC_CONFIG))
	$(call ERROR_MESSAGE, [extra-be-checks] There is no config file)
endif
	$(shell mkdir -p $(EBC_WORKDIR))
	$(shell mkdir -p $(EBC_LOGS))
	$(shell mkdir -p $(EBC_SIGNOFF))

	$(call INFO_MESSAGE, [extra-be-checks] installation dir:  $(EBC_BASE))
	$(call INFO_MESSAGE, [extra-be-checks] work dir:          $(EBC_WORKDIR))
	$(call INFO_MESSAGE, [extra-be-checks] GDS:               $(TOP_GDS))

.PHONY: ebc-softcheck
ebc-softcheck: ebc-validation
	$(EBC_SOFT_CHECK) $(EBC_CONFIG) $(TOP_GDS_CELL) $(TOP_GDS) \
	|& tee $(EBC_SOFT_CHECK_LOG)
