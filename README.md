# IC Makefile

Set of makefile scripts that serves as a handle to use EDA tools.

A project that uses this repo should add it as a submodule and then create or edit the `Makefile` in a directory where modules exists. It should fit the specific structures that it could have.

~~~bash
# To test the scripts and the inv_sample module
$ git clone --recurse-submodules https://github.com/akiles-esta-usado/ic-makefile.git

# To register and use the repo in a project
$ git submodule add https://github.com/akiles-esta-usado/ic-makefile.git
~~~


## Directory Structure

- `Makefile`: This file is a reference for a specific makefile. Defines variables that are used by the `.mk` files and those follow certain structure.
- `*.mk`: This files is a handle to a specific tool.


## Project Structure

Each design is a module and it contains layouts, schematics and testbench. The enforced structure is the following:

~~~
inv_sample
├── symbol
│   ├── inv_sample.sch
│   └── inv_sample.sym
├── test
│   ├── inv_sample_test.sch
│   └── inv_sample_test.spice
├── layout
│   ├── inv_sample.gds
└── output
    ├── extraction
    │   ├── layout_clean                    
    │   │   ├── inv_sample.cir              Klayout clean extraction
    │   │   └── inv_sample_extracted.spice  Magic clean
    │   ├── layout_pex                      
    │   │   └── inv_sample_pex.spice        Magic parasitic extraction
    │   ├── schematic                       Schematic extractions with xschem
    │   │   ├── inv_sample.spice
    │   │   ├── inv_sample_noprefix.spice
    │   │   └── inv_sample_prefix.spice
    │   └── test                            Testbench extractions and simulated data
    │       ├── inv_sample_test.spice
    │       └── rawspice.raw
    └── reports
        ├── inv_sample_antenna.lyrdb     DRC files from klayout
        ├── inv_sample_density.lyrdb
        ├── precheck_inv_sample.lyrdb
        ├── inv_sample_main.lyrdb
        ├── inv_sample.lvsdb             LVS file from klayout
        ├── lvs_klayout_comp.out         LVS files from netgen
        └── lvs_magic_comp.out
~~~

## Usage

This commands may not be up-to-date. 

Get the help description of each tool makefile. Each makefile should extend the `HELP_ENTRIES` variable to register rules and usage.

~~~bash
$ make help
~~~

Open a specific xschem testbench

~~~bash
$ make TOP=inv_sample TEST=inv_sample_test xschem-tb
~~~

To perform Layout versus Schematic on two designs: `inv_sample` and `nmos5f`.

~~~bash
$ make TOP=inv_sample GND_NAME=vss klayout-lvs
$ make TOP=nmos5f GND_NAME=S klayout-lvs
~~~

Perform extraction with parasitics (PEX) from the layout of `inv_sample`.

~~~bash
$ make TOP=inv_sample magic-pex-extraction
~~~