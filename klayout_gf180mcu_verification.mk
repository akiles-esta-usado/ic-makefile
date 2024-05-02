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


# DRC RULES
###########

# --help -h                           Print this help message.
# --path=<file_path>                  The input GDS file path.
# --variant=<combined_options>        Select combined options of metal_top, mim_option, and metal_level. Allowed values (A, B, C, D, E, F).
#                                     variant=A: Select  metal_top=30K  mim_option=A  metal_level=3LM
#                                     variant=B: Select  metal_top=11K  mim_option=B  metal_level=4LM
#                                     variant=C: Select  metal_top=9K   mim_option=B  metal_level=5LM
#                                     variant=D: Select  metal_top=11K  mim_option=B  metal_level=5LM
#                                     variant=E: Select  metal_top=9K   mim_option=B  metal_level=6LM
#                                     variant=F: Select  metal_top=9K   mim_option=A  metal_level=6LM
# --topcell=<topcell_name>            Topcell name to use.
# --table=<table_name>                Table name to use to run the rule deck.
# --mp=<num_cores>                    Run the rule deck in parts in parallel to speed up the run. [default: 1]
# --run_dir=<run_dir_path>            Run directory to save all the results [default: pwd]
# --thr=<thr>                         The number of threads used in run.
# --run_mode=<run_mode>               Select klayout mode Allowed modes (flat , deep). [default: flat]
# --verbose                           Detailed rule execution log for debugging.
# --no_feol                           Turn off FEOL rules from running.
# --no_beol                           Turn off BEOL rules from running.
# --no_connectivity                   Turn off connectivity rules.
# --density                           Turn on Density rules.
# --density_only                      Turn on Density rules only.
# --antenna                           Turn on Antenna checks.
# --antenna_only                      Turn on Antenna checks only.
# --split_deep                        Spliting some long run rules to be run in deep mode permanently.
# --no_offgrid                        Turn off OFFGRID checking rules.
# --macro_gen                         Generating the full rule deck without run.
# --slow_via                          Turn on SLOW_VIA option for MT30.8 rule.

# feol, beol, connectivity, density, antenna, offgrid

KLAYOUT_DRC_SCRIPT_EFABLESS=python $(KLAYOUT_HOME)/drc/run_drc.py \
	--variant=D \
	--run_mode=$(KLAYOUT_DRC_RUN_MODE) \
	--verbose \
	--thr=$(NPROCS) \
	--run_dir=$(REPORT_DIR) \
	--topcell=$(CELL) \
	--path $(GDS)

# == Rules - DRC Building Blocks == #

# See https://open-source-silicon.slack.com/archives/C016HUV935L/p1710737146725369

.PHONY: klayout-drc-beol
klayout-drc-beol: klayout-validation
	$(KLAYOUT_DRC_SCRIPT_EFABLESS) \
		--no_feol \
		--no_offgrid \
		|| true
	mv $(REPORT_DIR)/$(GDS_CELL)_main.lyrdb $(REPORT_DIR)/$(KLAYOUT_REPORT_PREFIX)_beol.lyrdb


.PHONY: klayout-drc-feol
klayout-drc-feol: klayout-validation
	$(KLAYOUT_DRC_SCRIPT_EFABLESS) \
		--no_beol \
		--no_offgrid \
		|| true
	mv $(REPORT_DIR)/$(GDS_CELL)_main.lyrdb $(REPORT_DIR)/$(KLAYOUT_REPORT_PREFIX)_feol.lyrdb


.PHONY: klayout-drc-density
klayout-drc-density: klayout-validation
	$(KLAYOUT_DRC_SCRIPT_EFABLESS) \
		--density_only \
		--no_connectivity \
		--no_offgrid \
		|| true
	mv $(REPORT_DIR)/$(GDS_CELL)_density.lyrdb $(REPORT_DIR)/$(KLAYOUT_REPORT_PREFIX)_density.lyrdb


.PHONY: klayout-drc-antenna
klayout-drc-antenna: klayout-validation
	$(KLAYOUT_DRC_SCRIPT_EFABLESS) \
		--antenna_only \
		--no_offgrid \
		|| true
	mv $(REPORT_DIR)/$(GDS_CELL)_antenna.lyrdb $(REPORT_DIR)/$(KLAYOUT_REPORT_PREFIX)_antenna.lyrdb


.PHONY: klayout-drc-offgrid
klayout-drc-offgrid: klayout-validation
	$(KLAYOUT_DRC_SCRIPT_EFABLESS) \
		--table=geom \
		|| true
	mv $(REPORT_DIR)/$(GDS_CELL)_geom.lyrdb $(REPORT_DIR)/$(KLAYOUT_REPORT_PREFIX)_offgrid.lyrdb

# == Rules - DRC Interface == #

.PHONY: klayout-drc-only
klayout-drc-only: klayout-validation
	rm $(ALL_LYRDB) || true
	$(MAKE) klayout-drc-beol klayout-drc-feol klayout-drc-density klayout-drc-antenna klayout-drc-offgrid


.PHONY: klayout-drc-full
klayout-drc-full: klayout-validation
	rm $(ALL_LYRDB) || true
	$(MAKE) DRC_FLAT=Y klayout-drc-beol klayout-drc-feol klayout-drc-density klayout-drc-antenna
	$(MAKE) DRC_FLAT=N klayout-drc-offgrid
