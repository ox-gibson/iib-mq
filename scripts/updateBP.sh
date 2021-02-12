#!/bin/bash

mkdir -p /etc/mqm; chown -R mqm:mqm /etc/mqm/; chmod -R 755 /etc/mqm/
#Update root .bash_profile
if [ ! -f "/opt/mqm/rootupdated" ] && [ -d "/root/" ]; then
   touch /opt/mqm/rootupdated
   if ! `grep -q "LICENSE=accept" /root/.bash_profile`; then
      echo "Adding LICENSE variable for root user"; echo export LICENSE=accept>> /root/.bash_profile
   fi
   #sed -i '/^PATH/s/$/<stuff to add>/' <FILE>
   if ! `grep -q ":/usr/local/bin" /root/.bash_profile`; then
      echo "Updating PATH variable for root user"; sed -i '/^PATH/s/$/:\/usr\/local\/bin/' /root/.bash_profile
   fi
   if ! `grep -q ":/opt/mqm/bin:/opt/mqm/samp/bin" /root/.bash_profile`; then
      echo "Updating PATH with mqm directories"; sed -i '/^PATH/s/$/:\/opt\/mqm\/bin:\/opt\/mqm\/samp\/bin/' /root/.bash_profile
   fi
   if ! `grep -q "source /opt/mqm/bin/setmqenv -s" /root/.bash_profile`; then
      echo "Setting source setmqenv"; echo "source /opt/mqm/bin/setmqenv -s">> /root/.bash_profile
   fi

   #Moving the export PATH line to be the last line in the .bash_profile
   echo "Moving export PATH"
   sed -i '/export PATH/d' /root/.bash_profile
   echo export PATH>> /root/.bash_profile
   #echo "Source /root/.bash_profile"
   #source /root/.bash_profile
fi

#Update mqm .bash_profile
if [ ! -f "/opt/mqm/mqmupdated" ] && [ -d "/home/mqm/" ]; then
   touch /opt/mqm/mqmupdated
   if ! `grep -q "LICENSE=accept" /home/mqm/.bash_profile`; then
      echo "Adding LICENSE variable for mqm user"; echo export LICENSE=accept>> /home/mqm/.bash_profile
   fi
   #sed -i '/^PATH/s/$/<stuff to add>/' <FILE>
   if ! `grep -q ":/usr/local/bin" /home/mqm/.bash_profile`; then
      echo "Updating PATH with /usr/local/bin"; sed -i '/^PATH/s/$/:\/usr\/local\/bin/' /home/mqm/.bash_profile
   fi
   if ! `grep -q ":/opt/mqm/bin:/opt/mqm/samp/bin" /home/mqm/.bash_profile`; then
      echo "Updating PATH with mqm directories"; sed -i '/^PATH/s/$/:\/opt\/mqm\/bin:\/opt\/mqm\/samp\/bin/' /home/mqm/.bash_profile
   fi
   if ! `grep -q "source /opt/mqm/bin/setmqenv -s" /home/mqm/.bash_profile`; then
      echo "Setting source setmqenv"; echo "source /opt/mqm/bin/setmqenv -s">> /home/mqm/.bash_profile
   fi

   #Moving the export PATH line to be the last line in the .bash_profile
   echo "Moving export PATH"
   sed -i '/export PATH/d' /home/mqm/.bash_profile
   echo export PATH>> /home/mqm/.bash_profile
   #echo "Source /home/mqm/.bash_profile"
   #source /home/mqm/.bash_profile
fi
