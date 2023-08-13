#!/bin/sh

USER="admin"
PASS=$(cat /dev/urandom | strings | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
HOME_FLDR="/usr/local/etc/syncthing"

# Enable the service
sysrc -f /etc/rc.conf syncthing_enable="YES"

syncthing generate --gui-user=$USER --gui-password=$PASS --no-default-folder --home=$HOME_FLDR
sed -i '' 's|<address>127.0.0.1:8384</address>|<address>0.0.0.0:8384</address>|g' $HOME_FLDR/config.xml
chown syncthing:syncthing $HOME_FLDR/*

mkdir /data
chown syncthing:syncthing /data

echo "Syncthing Configuration:" > /root/PLUGIN_INFO
echo "• GUI User: ${USER}" >> /root/PLUGIN_INFO
echo "• GUI Password: ${PASS}" >> /root/PLUGIN_INFO

# Start the service
service syncthing start 2>/dev/null