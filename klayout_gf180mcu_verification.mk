# --help -h                           Print this help message.
# --layout=<layout_path>              The input GDS file path.
# --netlist=<netlist_path>            The input netlist file path.
# --variant=<combined_options>        Select combined options of metal_top, mim_option, and metal_level. Allowed values (A, B, C, D).
# --thr=<thr>                         The number of threads used in run.
# --run_dir=<run_dir_path>            Run directory to save all the results [default: pwd]
# --topcell=<topcell_name>            Topcell name to use.
# --run_mode=<run_mode>               Select klayout mode Allowed modes (flat , deep, tiling). [default: deep]
# --lvs_sub=<sub_name>                Substrate name used in your design.
# --verbose                           Detailed rule execution log for debugging.
# --schematic_simplify                Enable schematic simplification in input netlist.

## Operations in extracted netlist
# --no_net_names                      In extracted netlist discard net names, only enumerated nets.
# --spice_comments                    In extracted netlist enable netlist comments. Useful at least to know pins
# --scale                             In extracted netlist enable scale of 1e6.
# --net_only                          In extracted netlist enable netlist object creation only. ?
# --top_lvl_pins                      In extracted netlist enable top level pins only.
# --combine                           In extracted netlist enable netlist combine only.
# --purge                             In extracted netlist enable netlist purge all only.
# --purge_nets                        In extracted netlist enable netlist purge nets only.


.PHONY: klayout-lvs-help
klayout-lvs-help:
	python $(KLAYOUT_HOME)/lvs/run_lvs.py --help


# Since the netlist could not exists on first run
# It's recommended use TOP.spice instead of SCH_NETLIST_NOPREFIX
KLAYOUT_SCRIPT_LVS:=$(PYTHON) $(KLAYOUT_HOME)/lvs/run_lvs.py \
	--variant=D \
	--run_mode=flat \
	--verbose \
	--lvs_sub=$(GND_NAME) \
	--run_dir=$(REPORT_DIR) \
	--layout=$(GDS) \
	--netlist=$(SCH_NETLIST_NOPREFIX) \
	--topcell=$(GDS_CELL) \
	--top_lvl_pins \
	--schematic_simplify \
	--combine


.PHONY: klayout-lvs-only
klayout-lvs-only: klayout-validation xschem-netlist-lvs-noprefix-fixed
ifeq (VSS,$(GND_NAME))
	$(call WARNING_MESSAGE, GND_NAME is on the default value)
	$(call WARNING_MESSAGE, netlist might not match)
endif
	$(RM) $(REPORT_DIR)/*.lvsdb

	$(KLAYOUT_SCRIPT_LVS) \
		|& tee $(LOG_KLAYOUT)_lvs.log || true

	mv $(REPORT_DIR)/*.cir $(LAYOUT_NETLIST_KLAYOUT)


KLAYOUT_SCRIPT_DRC_PDK:=python $(KLAYOUT_HOME)/drc/run_drc.py \
	--variant=D \
	--path $(GDS) \
	--topcell=$(GDS_CELL) \
	--run_dir=$(REPORT_DIR) \
	--run_mode=flat \
	--antenna \
	--density \
	--thr=$(NPROCS) \
	--verbose


.PHONY: klayout-drc-efabless
klayout-drc-efabless: klayout-validation
	$(KLAYOUT_SCRIPT_DRC_PDK) \
		|& tee $(LOG_KLAYOUT)_drc_efabless.log || true


# -rd input
# -rd topcell
# -rd report
# -rd table_name
# -rd conn_drc
# -rd split_deep
# -rd wedge
# -rd ball
# -rd gold
# -rd mim_option
# -rd offgrid
# -rd thr
# -rd verbose
# -rd run_mode
# -rd metal_top
# -rd metal_level
# -rd feol
# -rd beol
# -rd slow_via
KLAYOUT_SCRIPT_DRC_PRECHECK:=$(KLAYOUT) -b \
	-r $(KLAYOUT_HOME)/drc/gf180mcuD_mr.drc \
	-rd mim_option=B \
	-rd run_mode=flat \
	-rd verbose=true \
	-rd input=$(GDS) \
	-rd topcell=$(GDS_CELL) \
	-rd thr=$(NPROCS) \
	-rd conn_drc=true \
	-rd split_deep=true \
	-rd wedge=true \
	-rd ball=true \
	-rd gold=true \
	-rd offgrid=true


.PHONY: klayout-drc-precheck
klayout-drc-precheck:
	$(KLAYOUT_SCRIPT_DRC_PRECHECK) \
		-rd report=$(REPORT_DIR)/precheck_beol_$(TOP).lyrdb \
		-rd beol=true \
		-rd feol=false \
		|& tee $(LOG_KLAYOUT)_drc_precheck_beol.log || true

	$(KLAYOUT_SCRIPT_DRC_PRECHECK) \
		-rd report=$(REPORT_DIR)/precheck_feol_$(TOP).lyrdb \
		-rd beol=false \
		-rd feol=true \
		|& tee $(LOG_KLAYOUT)_drc_precheck_feol.log || true


.PHONY: klayout-drc-only
klayout-drc-only: klayout-validation
	$(RM) $(REPORT_DIR)/*.lyrdb

	$(MAKE) klayout-drc-efabless
	$(MAKE) klayout-drc-precheck
