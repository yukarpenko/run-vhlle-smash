## Running vHLLE-SMASH hybrid using Bash

## Requirements
- ROOT >= 5.34
- cmake >= 3.9
- boost filesystem >= 1.49
- the GNU Scientific Library >= 2.0

## Install
To install all necessary parts, simply run
```
. initialize_vhlle_smash.sh
```
If everything works, you should obtain final message
```
Initialization of the hybrid model has been successful
```
The installation takes around 1 hour. If there is any issue, you can simply open the script and manually enter commands line by line. One of the most common problems is if you don't have SSH key added to Github (see [this link](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)).

## Run
To run the code, run
```
. run_vhlle_smash.sh
```
This script generates input files for all three parts of the model as well as script for running the whole model, and then execute that script. In this file, you can set all the parameters for the codes.

## Input parameters
### Hydro
- `eosType` - sets the equation of state used in hydrodynamic evolution
  - `0` - [Laine](https://arxiv.org/abs/hep-ph/0603048)
  - `1` - [chiral EoS](https://arxiv.org/abs/1009.5239)
  - `2` - 1st order phase transition EoS
- `eosTypeHadron` - sets the equation of state used to compute variables at freeze-out hypersurface
  - `0` - PDG hadronic EoS
  - `1` - SMASH hadronic EoS
- `etaS` - shear viscosity
- `zetaS` - bulk viscosity
- `e_crit` - energy density of the freeze-out hypersurface [GeV/fm<sup>3</sup>]
- `nx`, `ny`, `nz` - number of cells in hydrodynamic grid
- `xmin`, `xmax`, `ymin`, `ymax`, `etamin`, `etamax` - size of simulated space [fm (except space-time rapidity)]
- `Rg` - controls the width of the deposition of nucleons into fluids
- `tau0` - starting time (cannot be zero) [fm]
- `tauMax` - force stop of hydro [fm]
- `dtau` - timestep [fm]

Recommended size of the hydrodynamic grid is 121x121x161, however, for development or running on laptop you may use 61x61x81 (and `dtau=0.1`). With this setting the code runs much faster and uses less memory.

### Hadron sampler
- `number_of_events` - number of events generated from the particlization hypersurface
- `shear` - sets whether freezeout hypersurface contains pi coefficients (so set `1` even if you set zero shear viscosity in hydro, because it write the coefficients to the freezeout file anyway, they are just zeros)
- `ecrit` - energy density of the freeze-out hypersurface [GeV/fm<sup>3</sup>] (has to be equal to the same parameter in hydro)

### Smash
The only thing you need to change here is `Nevents`, which is done automatically in the script. 

## Analysis
There are few scripts to calculate basic observables - dN/dη, p<sub>T</sub> spectra and elliptic flow, available at a repository of Jakub Cimerman:
```
git clone git@github.com:jakubcimerman/scripts.git
```
