#!/bin/bash

# Define directory names
ROOT=`pwd`
BIN=$ROOT/bin
CLIM=$ROOT/data/bc/t30/clim
ANOM=$ROOT/data/bc/t30/anom

# Check model executable exists
if [ ! -f $BIN/speedy ]; then
    echo "No executable found in bin ($BIN)"
    echo "Have you run ./build.sh yet?"
fi


date
echo "Preparing run directories"



# Now create many SPEEDY runs
for irun in `seq 1 128`; do

    RUNDIR=$ROOT/scratch/run_`printf '%05d' $irun`

    # Make and move to run directory
    rm -rf $RUNDIR
    mkdir -p $RUNDIR
    cd $RUNDIR

    # Copy executable
    cp $BIN/speedy .

    # Link input files
    cp $CLIM/surface.nc .
    cp $CLIM/sea_surface_temperature.nc .
    cp $CLIM/sea_ice.nc .
    cp $CLIM/land.nc .
    cp $CLIM/snow.nc .
    cp $CLIM/soil.nc .
    cp $ANOM/sea_surface_temperature_anomaly.nc .

    # Copy namelist file to run directory
    cp $ROOT/namelist.nml.TEMPLATE $RUNDIR/namelist.nml

    # Overwrite namelist entries
    sed -i "s|__SED_RANDOM_SEED__|$irun|g" namelist.nml


    # Return to root directory
    cd $ROOT

done # --- End of loop over ensemble runs




date 
echo "Initiating SPEEDY runs"


# Now create many SPEEDY runs
for irun in `seq 1 128`; do

    RUNDIR=$ROOT/scratch/run_`printf '%05d' $irun`

    cd  $RUNDIR

    ./speedy >& output.txt & #| tee output.txt >& log &


    # Return to root directory
    cd $ROOT

done # --- End of loop over ensemble runs



wait

echo "Finished running all SPEEDY simulations "
date
