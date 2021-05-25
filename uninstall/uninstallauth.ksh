#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    Uninstall WCM and WebSphere Portal Manually
#    1. Prepare uninstall: Environment checking...
#    2. Shutting Down nodeagent  and WebSphere_Portal ...
#    3. Manually Remove the WebSphere Portal Server
# Author:
#    Larry Sui
# Date:
#    2012-01-14
#
############################################################################################

############################################################################################
#    1. Prepare uninstall: Environment checking...
############################################################################################

_HOSTNAME=`uname -n`
_INTENDEDHOSTNAME=$1
_CURDIR=`pwd`


if [[ $# != 1 ]] then
  echo Please pass intended hostname as an argument.
  exit 1
fi

echo The current hostname is: $_HOSTNAME, The intended hostname is:  $_INTENDEDHOSTNAME

if [[ $_HOSTNAME != $1 ]] then
  echo Usage: uninstalldmgr.ksh $_HOSTNAME
  exit 1
fi

. uninstallauth/properties/uninstallauth${_INTENDEDHOSTNAME}.properties

echo The current directory is: ${_CURDIR}

if [[ "${_INTENDEDDIR}" != "${_CURDIR}" ]] then
  echo Usage: Current directory is ${_CURDIR}. Please goto "${_INTENDEDDIR}" directory.
  exit 1
fi

echo "Are you sure to uninstall WebSphere Portal/WCM V7 from $_HOSTNAME?   (y/n)";
read  yn;

if [[ $yn != "y" ]]; then
  exit 0
fi




echo The Uninstall will takes 7 minutes
echo " "

_START=`date +%s`

echo Starting Datetime:  `date`
echo /usr/lib/objrepos/vpd.properties
echo tail -f /tmp/wpinstalllog.txt
echo du -gs ${_WSDIR}/IBM   3.81 GB
echo uninstall auth take about 6  minutes
echo topas

################################################################################
#    2. Shutting Down nodeagent  and WebSphere_Portal ...
################################################################################

kill -9 `ps -ef | grep "${_HOSTNAME}Node01 nodeagent" | awk '{print $2}'`
kill -9 `ps -ef | grep "${_HOSTNAME}Node01 nodeagent" | awk '{print $2}'`
kill -9 `ps -ef | grep "${_HOSTNAME}Node01 WebSphere_Portal" | awk '{print $2}'`
kill -9 `ps -ef | grep "${_HOSTNAME}Node01 server1" | awk '{print $2}'`

################################################################################
#    3. Manually Remove the WebSphere Portal Server
################################################################################

rm -rf /optware/IBM
echo "" > /usr/lib/objrepos/vpd.properties
odmdelete -o product
echo "" > /.ITLMRegistry

/backup/portal/wcmv7/A-2/aix/ppc64/CIP/WAS/installRegistryUtils/bin/installRegistryUtils.sh -cleanAll
