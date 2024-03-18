TOP:=SDC_v7p1_ROrangeext
TEST:=test_SDCtsens_RINtsweep_9p1_ROrangeext
CACE_TEST:=dccurrent_vdd

CACE_FILE:=$(abspath ./cace/SDC.txt)
CACE_RESULT_FILE:=$(abspath ./cace/SDC_results.txt)

# Tool configuration
PDK:=sky130A
PYTHON=python
NGSPICE_RCFILE=$(realpath ./.spiceinit)
XSCHEM_RCFILE=$(realpath ./xschemrc)

XSCHEM=SPICE_USERINIT_DIR=$(dir $(NGSPICE_RCFILE)) xschem --rcfile $(XSCHEM_RCFILE)
CACE_GUI=SPICE_USERINIT_DIR=$(dir $(NGSPICE_RCFILE)) cace-gui
CACE_CLI=SPICE_USERINIT_DIR=$(dir $(NGSPICE_RCFILE)) cace

all:
	@echo $(NGSPICE_RCFILE)
	@echo $(dir $(NGSPICE_RCFILE))


.PHONY: xschem
xschem:
	cd xschem && $(XSCHEM) $(TOP).sch


.PHONY: xschem-tb
xschem-tb:
	cd xschem && $(XSCHEM) $(TEST).sch


.PHONY: cace-tb
cace-tb:
	cd cace && $(XSCHEM) $(CACE_TEST).sch


.PHONY: cace-gui
cace-gui:
	$(CACE_GUI)


.PHONY: cace-gui-results
cace-gui-results:
	$(CACE_GUI) $(CACE_RESULT_FILE)


# -source	 	restrict characterization to specific netlist source. schematic capture, layout extracted, or full R-C parasitic extracted
#               If not specified, then characterization is run on the full R-C parasitic extracted layout netlist if available, and the schematic captured netlist if not (option "best").
# -param=<parameter_name>"	runs simulations on only the named electrical or physical parameter.
# -force		forces new regeneration of all netlists.
# -json			generates an output file in JSON format.
# -keep			retains files generated for characterization.
# -noplot		will not generate any graphs.
# -debug		generates additional diagnostic output.
# -sequential	runs simulations sequentially.
# -nosim		does not re-run simulations if the output file exists. (Warning---does not check if simulations are out of date).
# -summary		prints a summary of results at the end.

.PHONY: cace-cli
cace-cli:
	$(CACE_CLI) $(CACE_FILE) $(CACE_RESULT_FILE) -source=schematic -force -keep -debug -sequential -summary


.PHONY: cace-syntax
cace-syntax:
	$(PYTHON) -m cace.common.cace_read cace/SDC.txt
