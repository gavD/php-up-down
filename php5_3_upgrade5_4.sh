#!/bin/bash
#
# Original for 5.3 by Ruben Barkow (rubo77) http://www.entikey.z11.de/
# release 1 PHP5.4 to 5.3 by Emil Terziev ( foxy ) Bulgaria

# Originally Posted by Bachstelze http://ubuntuforums.org/showthread.php?p=9080474#post9080474
# OK, here's how to do the Apt magic to get PHP packages from the raring repositories:

echo "Am I root?  "
if [ "$(whoami &2>/dev/null)" != "root" ] && [ "$(id -un &2>/dev/null)" != "root" ] ; then
  echo "  NO!

Error: You must be root to run this script.
Enter
sudo su
"
  exit 1
fi
echo "  OK";

#install aptitude before, if you don`t have it:
apt-get update
yes | apt-get install aptitude

# finish all apt-problems:
aptitude update
aptitude -f install

# remove all your existing PHP packages. You can list them with dpkg -l| grep php
PHPLIST=$(for i in $(dpkg -l | grep php|awk '{ print $2 }' ); do echo $i; done)
echo these pachets will be removed: $PHPLIST
# you need not to purge, if you have upgraded from raring:
yes | aptitude remove $PHPLIST

rm /etc/apt/preferences.d/php5_*

echo ''>/etc/apt/preferences.d/php5_3
for i in $PHPLIST ; do echo "Package: $i
Pin: release a=raring
Pin-Priority: 991
">>/etc/apt/preferences.d/php5_4; done

yes | aptitude update

apache2ctl restart

echo install new from precise:
yes | aptitude -t raring install $PHPLIST

# at the end retry the modul libapache2-mod-php5 in case it didn't work the first time:
aptitude -t raring install libapache2-mod-php5

apache2ctl restart
