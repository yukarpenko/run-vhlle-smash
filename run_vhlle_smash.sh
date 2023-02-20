#!/bin/bash

# execution script adapted from a script to run MUFFIN by Jakub Cimerman

# number of events generated from freezeout hypersurface
afterburner_events=50

# title of run
prefix=test_run

cd ../vhlle-smash/hybrid
echo "Starting in: `pwd`"

mkdir -p hydrologs/$prefix
mkdir -p hydro.out/$prefix
mkdir -p sampler.out/$prefix
mkdir -p smash.out/$prefix

# create job file that run the codes
job_file=jobs/$prefix.job
echo "#!/bin/bash" > $job_file
echo "cd `pwd`" >> $job_file
echo "time ../vhlle/hlle_visc -params hydro.in/$prefix -ISinput ic/glissando/sources.LHC.20-30.dat -system LHC276 -outputDir hydro.out/$prefix/ > hydrologs/$prefix/o.log 2> hydrologs/$prefix/e.log" >> $job_file
echo "time ../smash-hadron-sampler/build/sampler events 1 -params sampler.in/$prefix -surface hydro.out/$prefix/freezeout.dat -output sampler.out/$prefix/ >> hydrologs/$prefix/o.log 2>> hydrologs/$prefix/e.log" >> $job_file
echo "mv sampler.out/$prefix/particle_lists.oscar sampler.out/$prefix/particle_lists_0" >> $job_file
echo "time ../smash/build/smash -i smash.in/$prefix.yaml -o smash.out/$prefix/ -f >> hydrologs/$prefix/o.log 2>> hydrologs/$prefix/e.log" >> $job_file
# if you don't need the freezeout hypersurface, you can delete the output from hydro,
# because it leaves quite large files (especially when running event-by-event)
echo "rm -r hydro.out/$prefix" >> $job_file

# create input file for hydro
hydro_in=hydro.in/$prefix
echo "! EoS type: 0 = complex EoS, 1 = simple table (eosFile)" > $hydro_in
echo "eosType       1" >> $hydro_in
echo "eosFile         Laine_nf3.dat" >> $hydro_in
echo "eosTypeHadron 1" >> $hydro_in
echo "chiBfile        chiB.txt" >> $hydro_in
echo "chiSfile        chiS.txt" >> $hydro_in
echo "T_ch          0.149" >> $hydro_in
echo "mu_b          0.0285" >> $hydro_in
echo "mu_q         -0.001" >> $hydro_in
echo "mu_s          0.007" >> $hydro_in
echo "gammaS        0.935" >> $hydro_in
echo "gammaFactor   0.75" >> $hydro_in
echo "exclVolume    0.0" >> $hydro_in
echo "" >> $hydro_in
echo "etaS      0.15" >> $hydro_in
echo "zetaS     0.00" >> $hydro_in
echo "e_crit    0.515" >> $hydro_in
echo "" >> $hydro_in
echo "nx        161" >> $hydro_in
echo "ny        161" >> $hydro_in
echo "nz        101" >> $hydro_in
echo "xmin     -20.0" >> $hydro_in
echo "xmax      20.0" >> $hydro_in
echo "ymin     -20.0" >> $hydro_in
echo "ymax      20.0" >> $hydro_in
echo "etamin     -10.0" >> $hydro_in
echo "etamax      10.0" >> $hydro_in
echo "" >> $hydro_in
echo "! icModel: 1=Glauber, 2=input from file,  3= urqmd IC (file)" >> $hydro_in
echo "icModel    5" >> $hydro_in
echo "glauberVar 1" >> $hydro_in
echo "s0ScaleFactor  53.55" >> $hydro_in
echo "epsilon0   30" >> $hydro_in
echo "impactPar  0.0" >> $hydro_in
echo "Rg      1" >> $hydro_in
echo "Rgz     1" >> $hydro_in
echo "tau0      0.6" >> $hydro_in
echo "tauMax     25.0" >> $hydro_in
echo "dtau       0.05" >> $hydro_in

# create input file for sampler
sampler_in=sampler.in/$prefix
echo "number_of_events $afterburner_events" > $sampler_in
echo "shear            1" >> $sampler_in
echo "ecrit            0.5" >> $sampler_in

# create input file for smash
smash_in=smash.in/$prefix.yaml
echo "Version: 1.8" > $smash_in
echo "" >> $smash_in
echo "General:" >> $smash_in
echo "    Modus:          List" >> $smash_in
echo "    Time_Step_Mode: None" >> $smash_in
echo "    Delta_Time:     0.1" >> $smash_in
echo "    End_Time:       1000.0" >> $smash_in
echo "    Randomseed:     -1" >> $smash_in
echo "    Nevents:        $afterburner_events" >> $smash_in
echo "" >> $smash_in
echo "Output:" >> $smash_in
echo "    Particles:" >> $smash_in
echo "        Format:          [\"Binary\", \"Oscar2013\"]" >> $smash_in
echo "" >> $smash_in
echo "Modi:" >> $smash_in
echo "    List:" >> $smash_in
echo "        File_Directory: \"sampler.out/$prefix/\"" >> $smash_in
echo "        File_Prefix: \"particle_lists_\"" >> $smash_in
echo "        Shift_Id: 0" >> $smash_in

# run the code
. $job_file
