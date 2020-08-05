#!/bin/bash

# Set common variables
. /var/tmp/nodevalet/maintenance/vars.sh

nano -c $LOGFILE

echo -e "\n"
echo -e " $(date +%m.%d.%Y_%H:%M:%S) : mlogedit.sh was run to modify the Maintenance Log.\n" | tee -a "$LOGFILE"

echo -e " Your edits to the Maintenance Log have been logged. \n"
