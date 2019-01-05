#!/bin/bash
# This script will let users quickly change the 'maxconnections' of all installed masternodes

INSTALLDIR='/var/tmp/nodevalet'
INFODIR='/var/tmp/nvtemp'
PROJECT=`cat $INFODIR/vpscoin.info`
MNS=`cat $INFODIR/vpsnumber.info`
LOGFILE='/var/tmp/nodevalet/logs/maintenance.log'

# read first argument to string $NEWMAX
NEWMAX=$1

# if NEWMAX(value only)=0 give instructions and echo them
if [ -z $NEWMAX ]
then clear
        echo -e "\n Your masternodes need to connect to other masternodes in"
        echo -e " order to function properly. Please enter a number of max"
        echo -e " connections you'd like to set (between 25 and 255)  : \n"
fi

while :; do
if [ -z $NEWMAX ] ; then read -p "  --> " NEWMAX ; fi
[[ $NEWMAX =~ ^[0-9]+$ ]] || { printf "${lightred}";echo -e " --> Try harder, that's not even a number."; NEWMAX=""; continue; }
if (($NEWMAX >= 25 && $NEWMAX <= 256)); then break
else echo -e "\n --> That number is too high or too low, try again. \n"
NEWMAX=""
fi
done

# set mnode daemon name from project.env
MNODE_DAEMON=`grep ^MNODE_DAEMON $INSTALLDIR/nodemaster/config/${PROJECT}/${PROJECT}.env`
echo -e "$MNODE_DAEMON" > $INSTALLDIR/temp/MNODE_DAEMON
sed -i "s/MNODE_DAEMON=\${MNODE_DAEMON:-\/usr\/local\/bin\///" $INSTALLDIR/temp/MNODE_DAEMON  2>&1
cat $INSTALLDIR/temp/MNODE_DAEMON | tr -d '[}]' > $INSTALLDIR/temp/MNODE_DAEMON1
MNODE_DAEMON=$(<$INSTALLDIR/temp/MNODE_DAEMON1)
cat $INSTALLDIR/temp/MNODE_DAEMON1 > $INSTALLDIR/temp/MNODE_DAEMON ; rm -f $INSTALLDIR/temp/MNODE_DAEMON1

for ((i=1;i<=$MNS;i++));
do

echo -e "\n `date +%m.%d.%Y_%H:%M:%S` : Setting maxconnections=$NEWMAX in masternode ${PROJECT}_n${i}"
sed -i "s/^maxconnections=.*/maxconnections=$NEWMAX/" /etc/masternodes/${PROJECT}_n$i.conf

done
echo -e "\n"
echo -e " User has manually set masternode maxconnections to $NEWMAX \n" | tee -a "$LOGFILE"

