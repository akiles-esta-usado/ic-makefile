# --help -h                           Print this help message.
# --variant=<combined_options>        Select combined options of metal_top, mim_option, and metal_level. Allowed values (A, B, C, D).
# --run_mode=<run_mode>               Select klayout mode Allowed modes (flat , deep, tiling). [default: deep]
# --thr=<thr>                         The number of threads used in run.
# --lvs_sub=<sub_name>                Substrate name used in your design.
# --run_dir=<run_dir_path>            Run directory to save all the results [default: pwd]
# --layout=<layout_path>              The input GDS file path.
# --netlist=<netlist_path>            The input netlist file path.
# --topcell=<topcell_name>            Topcell name to use.

# --verbose                           Detailed rule execution log for debugging.

# --combine                           In extracted netlist enable netlist combine only.
# --schematic_simplify                Enable schematic simplification in input netlist.
# --no_net_names                      In extracted netlist discard net names, only enumerated nets.
# --spice_comments                    In extracted netlist enable netlist comments. Useful at least to know pins
# --scale                             In extracted netlist enable scale of 1e6.
# --net_only                          In extracted netlist enable netlist object creation only. ?
# --top_lvl_pins                      In extracted netlist enable top level pins only.
# --purge                             In extracted netlist enable netlist purge all only.
# --purge_nets                        In extracted netlist enable netlist purge nets only.


.PHONY: klayout-lvs-help
klayout-lvs-help:
	python $(KLAYOUT_HOME)/lvs/run_lvs.py --help


# Since the netlist could not exists on first run
# It's recommended use TOP.spice instead of SCH_NETLIST_NOPREFIX
KLAYOUT_SCRIPT_LVS=$(PYTHON) $(KLAYOUT_HOME)/lvs/run_lvs.py \
	--variant=D \
	--run_mode=$(KLAYOUT_LVS_RUN_MODE) \
	--thr=$(NPROCS) \
	--lvs_sub=$(GND_NAME) \
	--run_dir=$(REPORT_DIR) \
	--layout=$(GDS) \
	--netlist=$(SCH_NETLIST_NOPREFIX) \
	--topcell=$(LVS_CELL)

# Using schematic simplify and combine seems to be required...
# combine seems to be required at least on one case.
KLAYOUT_SCRIPT_LVS+= --combine
KLAYOUT_SCRIPT_LVS+= --schematic_simplify

# Hides vss vdd and internal net names. Not so useful
# KLAYOUT_SCRIPT_LVS+= --no_net_names

# Not so useful
# KLAYOUT_SCRIPT_LVS+= --spice_comments

# What does it do?
# KLAYOUT_SCRIPT_LVS+= --scale

KLAYOUT_SCRIPT_LVS+= --net_only
KLAYOUT_SCRIPT_LVS+= --top_lvl_pins
KLAYOUT_SCRIPT_LVS+= --purge
KLAYOUT_SCRIPT_LVS+= --purge_nets

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

	echo $(LAYOUT_NETLIST_KLAYOUT)


# DRC RULES
###########

# --help -h                           Print this help message.
# --variant=<combined_options>        Select combined options of metal_top, mim_option, and metal_level. Allowed values (A, B, C, D, E, F).
#                                     variant=A: Select  metal_top=30K  mim_option=A  metal_level=3LM
#                                     variant=B: Select  metal_top=11K  mim_option=B  metal_level=4LM
#                                     variant=C: Select  metal_top=9K   mim_option=B  metal_level=5LM
#                                     variant=D: Select  metal_top=11K  mim_option=B  metal_level=5LM
#                                     variant=E: Select  metal_top=9K   mim_option=B  metal_level=6LM
#                                     variant=F: Select  metal_top=9K   mim_option=A  metal_level=6LM
# --run_mode=<run_mode>               Select klayout mode Allowed modes (flat , deep). [default: flat]
# --thr=<thr>                         The number of threads used in run.
# --run_dir=<run_dir_path>            Run directory to save all the results [default: pwd]
# --topcell=<topcell_name>            Topcell name to use.
# --path=<file_path>                  The input GDS file path.

# --verbose                           Detailed rule execution log for debugging.

# --table=<table_name>                Table name to use to run the rule deck.
# --mp=<num_cores>                    Run the rule deck in parts in parallel to speed up the run. [default: 1]
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
	mv $(REPORT_DIR)/$(GDS_CELL)_main.lyrdb $(KLAYOUT_DRC_REPORT_PREFIX)_beol.lyrdb


.PHONY: klayout-drc-feol
klayout-drc-feol: klayout-validation
	$(KLAYOUT_DRC_SCRIPT_EFABLESS) \
		--no_beol \
		--no_offgrid \
		|| true
	mv $(REPORT_DIR)/$(GDS_CELL)_main.lyrdb $(KLAYOUT_DRC_REPORT_PREFIX)_feol.lyrdb


.PHONY: klayout-drc-density
klayout-drc-density: klayout-validation
	$(KLAYOUT_DRC_SCRIPT_EFABLESS) \
		--density_only \
		--no_connectivity \
		--no_offgrid \
		|| true
	mv $(REPORT_DIR)/$(GDS_CELL)_density.lyrdb $(KLAYOUT_DRC_REPORT_PREFIX)_density.lyrdb


.PHONY: klayout-drc-antenna
klayout-drc-antenna: klayout-validation
	$(KLAYOUT_DRC_SCRIPT_EFABLESS) \
		--antenna_only \
		--no_offgrid \
		|| true
	mv $(REPORT_DIR)/$(GDS_CELL)_antenna.lyrdb $(KLAYOUT_DRC_REPORT_PREFIX)_antenna.lyrdb


.PHONY: klayout-drc-offgrid
klayout-drc-offgrid: klayout-validation
	$(KLAYOUT_DRC_SCRIPT_EFABLESS) \
		--table=geom \
		|| true
	mv $(REPORT_DIR)/$(GDS_CELL)_geom.lyrdb $(KLAYOUT_DRC_REPORT_PREFIX)_offgrid.lyrdb

# == Rules - DRC Interface == #

.PHONY: klayout-drc-only
klayout-drc-only: klayout-validation
	rm $(ALL_LYRDB) || true
	$(MAKE) klayout-drc-offgrid
	$(MAKE) klayout-drc-density
	$(MAKE) klayout-drc-antenna
	$(MAKE) klayout-drc-beol
	$(MAKE) klayout-drc-feol


.PHONY: klayout-drc-full
klayout-drc-full: klayout-validation
	rm $(ALL_LYRDB) || true
	$(MAKE) DRC_FLAT=N klayout-drc-offgrid
	$(MAKE) DRC_FLAT=Y klayout-drc-density
	$(MAKE) DRC_FLAT=Y klayout-drc-antenna
	$(MAKE) DRC_FLAT=Y klayout-drc-beol
	$(MAKE) DRC_FLAT=Y klayout-drc-feol


# TODO: Make this common to all pdks
#klayout-compare-magic-extraction: magic-lvs-extraction
klayout-compare-magic-extraction:
	sed -i '/subckt/s/_clean//' $(LAYOUT_NETLIST_MAGIC)
	sed -i '/nfet_03v3/s/^X/M/' $(LAYOUT_NETLIST_MAGIC)
	sed -i '/pfet_03v3/s/^X/M/' $(LAYOUT_NETLIST_MAGIC)
	sed -i '/ppolyf_u_1k/s/^X/R/' $(LAYOUT_NETLIST_MAGIC)
	sed -i '/ppolyf_u/s/^X/R/' $(LAYOUT_NETLIST_MAGIC)
	sed -i '/cap_mim_2f0_m4m5_noshield/s/^X/C/' $(LAYOUT_NETLIST_MAGIC)
	sed -i '/ pnp_[[:digit:]p[:digit:]x[:digit:]p[:digit:]]/s/^X/Q/' $(LAYOUT_NETLIST_MAGIC)
	sed -i '/ npn_[[:digit:]p[:digit:]x[:digit:]p[:digit:]]/s/^X/Q/' $(LAYOUT_NETLIST_MAGIC)

	$(MAKE) \
		SCH_NETLIST_NOPREFIX=$(LAYOUT_NETLIST_MAGIC) \
		klayout-lvs-only
