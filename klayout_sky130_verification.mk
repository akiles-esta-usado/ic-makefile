# $input                    The input GDS file path.
# $schematic                The input netlist file path.
# $report                   The output database file path.
# $target_netlist           Output netlist path.
# $thr                      Number of cores to be used by LVS checker
# $run_mode                 Select klayout mode Allowed modes (flat , deep, tiling). [default: deep]
# $lvs_sub                  Assign the substrate name used in design.
# $spice_net_names          Discard net names in extracted netlist.
# $spice_comments           Set netlist comments in extracted netlist.
# $scale                    Set scale of 1e6 in extracted netlist.
# $verbose                  Set verbose mode.
# $schematic_simplify       Set schematic simplification in input netlist.
# $net_only                 Set netlist object creation only in extracted netlist.
# $top_lvl_pins             Set top level pins only in extracted netlist.
# $combine                  Set netlist combine only in extracted netlist.
# $purge                    Set netlist purge all only in extracted netlist.
# $purge_nets               Set netlist purge nets only in extracted netlist.
# $fuse                     m2, m3, m4. (default: m4)


.PHONY: klayout-lvs-help
klayout-lvs-help:
	python $(KLAYOUT_HOME)/lvs/run_lvs.py --help


KLAYOUT_SCRIPT_LVS:=$(KLAYOUT) -b -r $(KLAYOUT_HOME)/lvs/sky130.lvs \
	-rd run_mode=flat \
	-rd verbose \
	-rd lvs_sub=$(GND_NAME) \
	-rd report=$(REPORT_DIR)/$(TOP).lvsdb \
	-rd input=$(GDS) \
	-rd schematic=$(SCH_NETLIST_NOPREFIX) \
	-rd target_netlist=$(LAYOUT_NETLIST_KLAYOUT) \
	-rd top_lvl_pins \
	-rd schematic_simplify \
	-rd combine


.PHONY: klayout-lvs-only
klayout-lvs-only: klayout-validation xschem-netlist-lvs-noprefix-fixed
	$(call ERROR_MESSAGE, LVS on klayout not supported for sky130. use netgen instead)
ifeq (VSS,$(GND_NAME))
	$(call WARNING_MESSAGE, GND_NAME is on the default value)
	$(call WARNING_MESSAGE, netlist might not match)
endif
	$(RM) $(REPORT_DIR)/*.lvsdb

	$(KLAYOUT_SCRIPT_LVS) \
		|& tee $(LOG_KLAYOUT)_lvs.log || true

	mv $(REPORT_DIR)/*.cir $(LAYOUT_NETLIST_KLAYOUT)


# -rd input            
# -rd top_cell         
# -rd report           
# -rd thr              
# -rd feol             front-end-of-line checks
# -rd beol             back-end-of-line checks
# -rd offgrid          manufacturing grid/angle checks
# -rd seal             SEAL RING checks
# -rd floating_met     back-end-of-line checks (?)
##############################################
# Top level conditionals

# - feol		Uses seal
# - beol		Uses seal and floating met
# - offgrid		


KLAYOUT_SCRIPT_DRC_PRECHECK:=$(KLAYOUT) -b \
	-r $(KLAYOUT_HOME)/drc/sky130A_mr.drc \
	-rd input=$(GDS) \
	-rd top_cell=$(GDS_CELL) \
	-rd thr=$(NPROCS) \
	-rd floating_met=true \
	-rd seal=true


.PHONY: klayout-drc-precheck
klayout-drc-precheck:
	$(KLAYOUT_SCRIPT_DRC_PRECHECK) \
		-rd report=$(REPORT_DIR)/precheck_beol_$(TOP).lyrdb \
		-rd beol=true \
		-rd feol=false \
		-rd offgrid=false \
		|& tee $(LOG_KLAYOUT)_drc_precheck_beol.log || true

	$(KLAYOUT_SCRIPT_DRC_PRECHECK) \
		-rd report=$(REPORT_DIR)/precheck_feol_$(TOP).lyrdb \
		-rd beol=false \
		-rd feol=true \
		-rd offgrid=false \
		|& tee $(LOG_KLAYOUT)_drc_precheck_feol.log || true

	$(KLAYOUT_SCRIPT_DRC_PRECHECK) \
		-rd report=$(REPORT_DIR)/precheck_offgrid_$(TOP).lyrdb \
		-rd beol=false \
		-rd feol=false \
		-rd offgrid=true \
		|& tee $(LOG_KLAYOUT)_drc_precheck_offgrid.log || true


.PHONY: klayout-drc-only
klayout-drc-only: klayout-validation
	$(call WARNING_MESSAGE, Klayout drc on sky130 only has the manufacturing rules, not all of them.)
	$(call WARNING_MESSAGE, Magic DRC is recommended)
	$(RM) $(REPORT_DIR)/*.lyrdb

	$(MAKE) klayout-drc-precheck
