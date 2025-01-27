#!/bin/bash

# folder in which the model will be initialized
cd ..
mkdir -p vhlle-smash
cd vhlle-smash
BASEDIR=`pwd`
echo "installation directory is $BASEDIR"

# initialize hybrid folder structure (optional)
mkdir -p hybrid
cd hybrid/
mkdir -p hydro.in
mkdir -p hydro.out
mkdir -p sampler.in
mkdir -p sampler.out
mkdir -p smash.in
mkdir -p smash.out
mkdir -p scripts
mkdir -p jobs
mkdir -p hydrologs
cd ../

# get vHLLE
git clone https://github.com/yukarpenko/vhlle.git
cd vhlle/
git checkout stable_ebe
make -j4
cd ../

# download EoS tables
git clone https://github.com/yukarpenko/vhlle_params.git
#mv vhlle_params/eos hybrid/
cd hybrid
ln -s ../vhlle_params/eos eos
ln -s ../vhlle_params/ic ic
cd ..

# install pythia
wget https://pythia.org/download/pythia83/pythia8309.tgz
tar xf pythia8309.tgz && rm pythia8309.tgz
cd pythia8309/
./configure --cxx-common='-std=c++17 -O3 -fPIC'
make -j4
cd ../

# install eigen
wget https://gitlab.com/libeigen/eigen/-/archive/3.3.9/eigen-3.3.9.tar.gz
tar -xf eigen-3.3.9.tar.gz && rm eigen-3.3.9.tar.gz

# install SMASH
git clone https://github.com/smash-transport/smash.git
cd smash/
# checkout to version SMASH 2.2 (optional, you may of course use newer version,
# but sometimes there are some bugs which make it incompatible with hadron sampler)
git checkout SMASH-3.0
mkdir build
cd build/
cmake .. -DCMAKE_PREFIX_PATH=$BASEDIR/eigen-3.3.9/ -DPythia_CONFIG_EXECUTABLE=$BASEDIR/pythia8309/bin/pythia8-config
make -j4
cd ../../

# install smash-hadron-sampler
git clone https://github.com/smash-transport/smash-hadron-sampler.git
cd smash-hadron-sampler/
git checkout SMASH-hadron-sampler-3.0
export SMASH_DIR=$BASEDIR/smash
cp -r $SMASH_DIR/cmake ./
mkdir build
cd build/
cmake .. -DCMAKE_PREFIX_PATH=$BASEDIR/eigen-3.3.9/ -DPythia_CONFIG_EXECUTABLE=$BASEDIR/pythia8309/bin/pythia8-config
make
cd ../../

echo "Initialization of the hybrid model is finished"
