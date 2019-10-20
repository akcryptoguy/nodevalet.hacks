#!/bin/bash

INSTALLDIR='/var/tmp/nodevalet'
INFODIR='/var/tmp/nvtemp'
PROJECT=$(cat $INFODIR/vpscoin.info)
MNS=$(cat $INFODIR/vpsnumber.info)
LOGFILE='/var/tmp/nodevalet/logs/maintenance.log'

nano -c $LOGFILE

echo -e "\n"
echo -e "`date +%m.%d.%Y_%H:%M:%S` : mlogedit.sh was run to modify the Maintenance Log.\n" | tee -a "$LOGFILE"

echo -e " Your edits to the Maintenance Log have been logged. \n"
