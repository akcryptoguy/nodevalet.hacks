#!/bin/bash
# This script will automatically update scripts on NodeValet VPS
# systems and install some new tools intended only for power users

INSTALLDIR='/var/tmp/nodevalet/maintenance'
INFODIR='/var/tmp/nvtemp'
PROJECT=`cat $INFODIR/vpscoin.info`
LOGFILE='/var/tmp/nodevalet/logs/maintenance.log'

# verify that this is a NodeValet.io configured VPS
if [ -z $PROJECT ]
then clear
  echo -e "\n This is not a VPS that was configured by NodeValet and"
  echo -e " as a result, these scripts would do nothing for you. \n"
  echo -e "\n The installation will now terminate.\n"
  exit
else cd $INSTALLDIR

# install additional powertools
echo -e "\n Downloading and installing mnedit.sh\n"
sudo wget -q -N https://raw.githubusercontent.com/akcryptoguy/nodevalet.hacks/master/mnedit.sh
sudo ln -s $INSTALLDIR/maintenance/mnedit.sh /usr/local/bin/mnedit
echo -e "\n Downloading and installing maxconnections.sh\n"
sudo wget -q -N https://raw.githubusercontent.com/akcryptoguy/nodevalet.hacks/master/maxconnections.sh
sudo ln -s $INSTALLDIR/maintenance/maxconnections.sh /usr/local/bin/maxconnections

# download the latest version of NodeValet maintenance scripts
echo -e "\n Updating autoupdate.sh\n"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/autoupdate.sh
echo -e "\n Updating checkdaemon.sh\n"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/checkdaemon.sh
echo -e "\n Updating checksync.sh\n"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/checksync.sh
echo -e "\n Updating cleardebuglog.sh\n"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/cleardebuglog.sh
echo -e "\n Updating getinfo.sh\n"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/getinfo.sh
echo -e "\n Updating killswitch.sh\n"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/killswitch.sh
echo -e "\n Updating makerun.sh\n"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/makerun.sh

echo -e "\n Updating masternodestatus.sh\n"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/masternodestatus.sh
echo -e "\n Updating rebootq.sh\n"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/rebootq.sh
echo -e "\n Updating resync.sh\n"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/resync.sh


echo -e "\n With great power, comes great responsibility. Please be careful"
echo -e " and don't break your server. These should not be used haphazardly.\n"

echo -e "`date +%m.%d.%Y_%H:%M:%S` : User has run hackit.sh" | tee -a "$LOGFILE"
echo -e "This will update NodeValet maintenance scripts and install new power tools.\n" | tee -a "$LOGFILE"
fi

exit
