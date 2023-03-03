## Running vHLLE-SMASH hybrid using Bash

## Requirements
- 6.22 > ROOT >= 5.34
- cmake >= 3.9
- boost filesystem >= 1.49
- the GNU Scientific Library >= 2.0

!! in the current version, compilation of SMASH and smash-hadron-sampler will fail with ROOT >=6.22, as C++17 needs to be set in such case. The issue will be fixed in the future versions.

## Install
To install all necessary parts, cd into the repo's subdirectory and run
```
. initialize_vhlle_smash.sh
```
If no error messages are produced, and a binary for the smash-hadron-sampler is produced at

`../vhlle-smash/smash-hadron-sampler/build/sampler` ,

the installation is successful.

The installation takes around 1 hour. If there is any issue, you can simply open the script and manually enter commands line by line.

## Run
To run the code, run
```
. run_vhlle_smash.sh
```
which executes the simulation chain, vHLLE + smash-hadron-sampler + SMASH, for a default scenario of 20-30% central PbPb collisions at sqrt(s)=2.76 TeV, with averaged initial state from longitudinally-extended Monte Carlo Glauber model.
This script generates input files for all three parts of the model as well as script for execution of the codes the simulation chain, and then executes that script. Inside `run_vhlle_smash.sh`, you can set all the parameters for the codes.

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
