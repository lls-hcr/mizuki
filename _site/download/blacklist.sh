#!/bin/sh
#
# shalla_update.sh, v 0.3.1 20080403
# done by kapivie at sil.at under FreeBSD
# without any warranty
# updated by Len Tucker to create and use diff
# files to reduce load and increase speed.
# Added Checks for required elements
# Added output info for status of script
# Modified by Chris Kronberg: included loop; added some more
# checks; reduced the diff files to the necessary content.
#
#--------------------------------------------------
# little script (for crond)
# to fetch and modify new list from shallalist.de
#--------------------------------------------------
#
# *check* paths and squidGuard-owner on your system
# try i.e. "which squid" to find out the path for squid
# try "ps aux | grep squid" to find out the owner for squidGuard
#     *needs wget*
#

squidGuardpath="/usr/bin/squidGuard"
squidpath="/usr/sbin/squid"
tarpath="/bin/tar"
chownpath="/bin/chown"

dbhome="/var/lib/squidguard/db"
squidGuardowner="proxy:proxy"
blacklists="http://dsi.ut-capitole.fr/blacklists/download/blacklists.tar.gz"
wgetlogdir="/var/log/squidguard"

##########################################

workdir="/var/lib/squidguard/tmp"
if [ ! -d $workdir ]; then
  mkdir -p $workdir
fi

if [ ! -f $tarpath ]
 then echo "Could not locate tar."
      exit 1
fi

if [ ! -f $chownpath ]
 then echo "Could not locate chown."
      exit 1
fi 

if [ ! -d  $dbhome ]
 then echo "Could not locate squid db directory."
      exit 1
fi

# check that everything is clean before we start.
if [ -f  $workdir/blacklists.tar.gz ]; then
   echo "Old blacklist file found in ${workdir}. Deleted!"
   rm $workdir/blacklists.tar.gz
fi

if [ -d $workdir/BL ]; then
   echo "Old blacklist directory found in ${workdir}. Deleted!"
   rm -rf $workdir/blacklists
fi

# copy actual shalla's blacklist
# thanks for the " || exit 1 " hint to Rich Wales
# (-b run in background does not work correctly) -o log to $wgetlog

rm $wgetlogdir/blacklists-wget.log

echo "Updating Squid Blacklists -" $(date -u)

echo "Retrieving blacklists.tar.gz"

wget $blacklists -a $wgetlogdir/blacklists-wget.log -O $workdir/blacklists.tar.gz || { echo "Unable to download blacklists.tar.gz" && exit 1 ; }

echo "Done!"

echo "Unzippping blacklists.tar.gz"

$tarpath xzf $workdir/blacklists.tar.gz -C $workdir || { echo "Unable to extract $workdir/blacklists.tar.gz" && exit 1 ; }

echo "Done!"

# Create diff files for all categories
# Note: There is no reason to use all categories unless this is exactly
#       what you intend to block. Make sure that only the categories you
#       are going to block with squidGuard are listed below.

CATEGORIES="blacklists/adult blacklists/malware blacklists/phishing blacklists/porn" 

echo "Creating diff files."

cp -R $workdir/blacklists/adult $dbhome
cp -R $workdir/blacklists/malware $dbhome
cp -R $workdir/blacklists/phishing $dbhome
cp -R $workdir/blacklists/porn $dbhome

echo "Done!"

echo "Setting file permisions."
$chownpath -R $squidGuardowner $dbhome
chmod 755 $dbhome
cd $dbhome
find . -type f -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;

echo "Done!"

echo "Updating squid db files. This will take some time, please be patient."
$squidGuardpath -C all

echo "Done!"

echo "Reconfiguring squid."
$squidpath -k reconfigure

echo "Done!"

echo "Clean up downloaded file and directories."
rm $workdir/blacklists.tar.gz
rm -rf $workdir/blacklists

echo "Completed! -" $(date -u)

exit 0
