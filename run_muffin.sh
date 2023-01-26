#!/bin/bash

# copy this file to muffin/hybrid/scripts and run it from there using . run_muffin.sh

# number of events generated from freezeout hypersurface
afterburner_events=500

# title of run
prefix=test_run

cd ..

mkdir -p hydrologs/$prefix
mkdir -p hydro.out/$prefix
mkdir -p sampler.out/$prefix
mkdir -p smash.out/$prefix

# create job file that run the codes
job_file=jobs/$prefix.job
echo "#!/bin/bash" > $job_file
echo "cd `pwd`" >> $job_file
echo "time ../vhlle/hlle_visc -params hydro.in/$prefix -outputDir hydro.out/$prefix/ > hydrologs/$prefix/o.log 2> hydrologs/$prefix/e.log" >> $job_file
echo "cat hydro.out/$prefix/freezeout_p.dat hydro.out/$prefix/freezeout_t.dat hydro.out/$prefix/freezeout_f.dat > hydro.out/$prefix/freezeout.dat" >> $job_file
echo "time ../smash-hadron-sampler/build/sampler events 1 -params sampler.in/$prefix -surface hydro.out/$prefix/freezeout.dat -output sampler.out/$prefix/ >> hydrologs/$prefix/o.log 2>> hydrologs/$prefix/e.log" >> $job_file
echo "mv sampler.out/$prefix/particle_lists.oscar sampler.out/$prefix/particle_lists_0" >> $job_file
echo "time ../smash/build/smash -i smash.in/$prefix.yaml -o smash.out/$prefix/ -f >> hydrologs/$prefix/o.log 2>> hydrologs/$prefix/e.log" >> $job_file
# if you don't need the freezeout hypersurface, you can delete the output from hydro,
# because it leaves quite large files (especially when running event-by-event)
echo "rm -r hydro.out/$prefix" >> $job_file

# create input file for hydro
hydro_in=hydro.in/$prefix
echo "nevents 1" > $hydro_in
echo "snn   7.7" >> $hydro_in
echo "b_min  0.0" >> $hydro_in
echo "b_max  12.0" >> $hydro_in
echo "projA  197" >> $hydro_in
echo "targA  197" >> $hydro_in
echo "projZ  79" >> $hydro_in
echo "targZ  79" >> $hydro_in
echo "" >> $hydro_in
echo "eosType       1" >> $hydro_in
echo "eosTypeHadron 1" >> $hydro_in
echo "" >> $hydro_in
echo "etaS      0.0" >> $hydro_in
echo "zetaS     0.0" >> $hydro_in
echo "e_crit    0.5" >> $hydro_in
echo "" >> $hydro_in
echo "nx        121" >> $hydro_in
echo "ny        121" >> $hydro_in
echo "nz        161" >> $hydro_in
echo "xmin     -18.0" >> $hydro_in
echo "xmax      18.0" >> $hydro_in
echo "ymin     -18.0" >> $hydro_in
echo "ymax      18.0" >> $hydro_in
echo "etamin     -1.5" >> $hydro_in
echo "etamax      1.5" >> $hydro_in
echo "" >> $hydro_in
echo "Rg      1.0" >> $hydro_in
echo "tau0       5.0" >> $hydro_in
echo "tauMax     30.0" >> $hydro_in
echo "dtau       0.05" >> $hydro_in
echo "frictionModel  1" >> $hydro_in
echo "formationTime  0.0" >> $hydro_in
echo "xi_fa      0.15" >> $hydro_in
echo "xi_q       30.0" >> $hydro_in
echo "xi_h       1.8" >> $hydro_in

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
