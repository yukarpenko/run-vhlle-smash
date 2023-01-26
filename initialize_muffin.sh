#!/bin/bash
set -e
set -o pipefail

# folder in which the model will be initialized - read from command line
HOMEFOLDER=$1
cd $HOMEFOLDER
mkdir muffin
cd muffin/

# initialize hybrid folder structure (optional)
mkdir hybrid
cd hybrid/
mkdir hydro.in
mkdir hydro.out
mkdir sampler.in
mkdir sampler.out
mkdir smash.in
mkdir smash.out
mkdir scripts
mkdir jobs
mkdir hydrologs
cd ../

# install muffin
git clone git@github.com:jakubcimerman/vhlle.git
cd vhlle/
git checkout 3FH
make
cp -a tables/. ../hybrid/tables/
cd ../

# download EoS tables
git clone git@github.com:yukarpenko/vhlle_params.git
mv vhlle_params/eos hybrid/

# install pythia
wget https://pythia.org/download/pythia83/pythia8307.tgz
tar xf pythia8307.tgz && rm pythia8307.tgz
cd pythia8307/
./configure --cxx-common='-std=c++11 -O3 -fPIC'
make
cd ../

# install eigen
wget https://gitlab.com/libeigen/eigen/-/archive/3.3.9/eigen-3.3.9.tar.gz
tar -xf eigen-3.3.9.tar.gz && rm eigen-3.3.9.tar.gz

# install SMASH
git clone git@github.com:smash-transport/smash.git
cd smash/
# checkout to version SMASH 2.2 (optional, you may of course use newer version,
# but sometimes there are some bugs which make it incompatible with hadron sampler)
git checkout b089223
mkdir build
cd build/
cmake .. -DCMAKE_PREFIX_PATH=$HOMEFOLDER/muffin/eigen-3.3.9/ -DPythia_CONFIG_EXECUTABLE=$HOMEFOLDER/muffin/pythia8307/bin/pythia8-config
make
cd ../../

# install smash-hadron-sampler
git clone git@github.com:jakubcimerman/smash-hadron-sampler.git
cd smash-hadron-sampler/
export SMASH_DIR=$HOMEFOLDER/muffin/smash
cp -r $SMASH_DIR/cmake ./
mkdir build
cd build/
cmake .. -DCMAKE_PREFIX_PATH=$HOMEFOLDER/muffin/eigen-3.3.9/ -DPythia_CONFIG_EXECUTABLE=$HOMEFOLDER/muffin/pythia8307/bin/pythia8-config
make
cd ../../

echo "Initialization of the hybrid model has been successful"
