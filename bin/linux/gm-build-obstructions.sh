#!/bin/bash

tileSearch=`echo $1 | tr '[:lower:]' '[:upper:]' | sed -e 's/[^A-Z0-9\%]//g'`

binDir="/vagrant/bin/linux/"
currentDir=`pwd`
sysEnv=`${binDir}/gm-environment.sh`

echo "Environment: ${sysEnv}"
if [ "$sysEnv" == "vbox" ]; then
	echo "Running on VirtualBox -- will persist LiDAR files."
else
	echo "Running on AWS -- will clean LiDAR files."
fi

if [ -z "$tileSearch" ]; then
	echo "Must supply tile name, e.g. NZ26"
	exit 1
else
	echo "Using tile mask $tileSearch"
fi

echo " --> Fetching matching tiles..."
IFS=$'\n'; for tileName in `psql -Ugrough-map grough-map -h 127.0.0.1 -A -t -c "SELECT tile_name FROM grid WHERE tile_name LIKE '${tileSearch}'"`
do
	echo "-----------------------"
	echo "  Processing $tileName"
	echo "-----------------------"
	"$binDir/gm-build-obstructions-tile.sh" "$tileName"
	
	if [ "$sysEnv" == "aws" ]; then
		rm -rf  /vagrant/source/eagg/*.zip 
	fi
done

cd $currentDir
