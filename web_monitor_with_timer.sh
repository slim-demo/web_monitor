#!/bin/sh
#
# Httpd process monitor script
#
# This script is used to monitor the number of httpd process that are running 
# and issue warnings and/or restart the httpd daemon if necessary.
#
#
while [ true ] 
do
if [ $EUID -ne 0 ]
then
  echo "Script must be run as a root user" 2>&1
  exit 1
else
  httpd_check=`ps aux | grep [h]ttpd | wc -l`
  if [ $httpd_check -lt 10 ]
  then
    echo "[LOW] Web Server OK!"
  elif [[ $httpd_check -gt 20 && $httpd_check -lt 100 ]]
  then
    echo "[HIGH] Web Server Working hard!"
  elif [ $httpd_check -gt 100 ]
  then
    echo "[CRITICAL] Web Server under heavy load, restart required"
    systemctl restart httpd.service
  else
    : # undefined case for httpd between 10 and 20 #
  fi
fi	
sleep 30
done 
