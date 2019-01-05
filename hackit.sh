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

clear
echo -e "\n This script will now update NodeValet maintenance scripts "
echo -e " and install some new tools intended for power users only."
echo -e " These scripts are not supported or endorsed by NodeValet"
echo -e " and you install them at your own risk. \n"
  
# install additional powertools
echo -e " Downloading and installing mnedit.sh"
sudo wget -q -N https://raw.githubusercontent.com/akcryptoguy/nodevalet.hacks/master/mnedit.sh
sudo ln -s $INSTALLDIR/maintenance/mnedit.sh /usr/local/bin/mnedit 2>/dev/null
echo -e " Downloading and installing maxconnections.sh"
sudo wget -q -N https://raw.githubusercontent.com/akcryptoguy/nodevalet.hacks/master/maxconnections.sh
sudo ln -s $INSTALLDIR/maintenance/maxconnections.sh /usr/local/bin/maxconnections 2>/dev/null

# download the latest version of NodeValet maintenance scripts
echo -e " Updating autoupdate.sh"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/autoupdate.sh
echo -e " Updating checkdaemon.sh"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/checkdaemon.sh
echo -e " Updating checksync.sh"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/checksync.sh
echo -e " Updating cleardebuglog.sh"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/cleardebuglog.sh
echo -e " Updating getinfo.sh"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/getinfo.sh
echo -e " Updating killswitch.sh"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/killswitch.sh
echo -e " Updating makerun.sh"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/makerun.sh
echo -e " Updating masternodestatus.sh"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/masternodestatus.sh
echo -e " Updating rebootq.sh"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/rebootq.sh
echo -e " Updating resync.sh"
sudo wget -q -N https://raw.githubusercontent.com/nodevalet/nodevalet/master/maintenance/resync.sh

chmod 0700 *.sh

echo -e "\n With great power, comes great responsibility. Please be careful"
echo -e " and don't break your server. These should not be used haphazardly.\n"

echo -e "`date +%m.%d.%Y_%H:%M:%S` : User has run hackit.sh" >> "$LOGFILE"
echo -e "This will update NodeValet maintenance scripts and install new power tools.\n" >> "$LOGFILE"
fi

exit
