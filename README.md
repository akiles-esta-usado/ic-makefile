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
│   ├── inv_sample.ext
│   ├── inv_sample.gds
│   ├── inv_sample_pex.ext
│   ├── inv_sample_pex.nodes
│   ├── inv_sample_pex.res.ext
│   ├── inv_sample_pex.sim
│   ├── nfet$1.ext
│   └── pfet.ext
└── output
    ├── extraction
    │   ├── layout_clean                    Layout clean extraction
    │   │   ├── inv_sample.cir
    │   │   └── inv_sample_extracted.spice
    │   ├── layout_pex                      Layout parasitic extraction
    │   │   └── inv_sample_pex.spice
    │   ├── schematic                       Schematic extractions with xschem
    │   │   ├── inv_sample.spice
    │   │   ├── inv_sample_noprefix.spice
    │   │   └── inv_sample_prefix.spice
    │   └── test                            Testbench extractions and simulated data
    │       ├── inv_sample_test.spice
    │       └── rawspice.raw
    └── reports
        ├── inv_sample_antenna.lyrdb     DRC file from klayout
        ├── inv_sample_density.lyrdb     DRC file from klayout
        ├── precheck_inv_sample.lyrdb    DRC file from klayout
        ├── inv_sample_main.lyrdb        DRC file from klayout
        ├── inv_sample.lvsdb             LVS file from klayout
        ├── lvs_klayout_comp.out         LVS file from netgen
        └── lvs_magic_comp.out           LVS file from netgen
~~~