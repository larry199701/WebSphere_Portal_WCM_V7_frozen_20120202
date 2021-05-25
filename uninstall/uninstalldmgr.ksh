#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    Uninstall WebSphere V7 Bineary and Deployment Manager
#    1. Prepare uninstall: Environment checking...
#    2. Shutting Down the dmgr...
#    3. Uninstall the UpdateInstaller
#    4. Delete profile: Dmgr01
#    5. Remove /optware/IBM directory
# Author: 
#    Larry Sui
# Date:
#    2011-08-25
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

echo "The current hostname is: $_HOSTNAME; \n\
   \tThe intended hostname is:  $_INTENDEDHOSTNAME; \n\
   \tThe current directory is: ${_CURDIR}"

if [[ $_HOSTNAME != $1 ]] then
  echo Usage: uninstalldmgr.ksh $_HOSTNAME
  exit 1
fi

. ${_CURDIR}/uninstalldmgr/properties/uninstalldmgr${_INTENDEDHOSTNAME}.properties
. ${_CURDIR}/uninstalldmgr/ksh/email_notify_function.ksh

if [[ "${_INTENDEDDIR}" != "${_CURDIR}" ]] then
  echo Usage: Current directory is ${_CURDIR}. Please goto "${_INTENDEDDIR}" directory.
  exit 1
fi

echo "Are you sure to uninstall the WebSphere Binary and Deployment Manager V7 from $_HOSTNAME?   (y/n)";
read  yn;

if [[ $yn != "y" ]]; then
  exit 0
fi

echo " ";
echo "The Uninstall will takes 2 minutes"
echo "\ttopas"
echo "\t/usr/lib/objrepos/vpd.properties"
echo " ";

_START=`date +%s`

email_notify \
  "Dmgr01 Uninstall Started..." \
  "Dmgr01 Uninstall Started..." \
  $_EMAILLIST \
  $_START

################################################################################
#    2. Shutting Down the dmgr...
################################################################################
# kill -9 `ps -ef | grep "dmgr" | awk '{print $2}'`

################################################################################
#    3. Uninstall the UpdateInstaller
################################################################################
echo " ";
echo "a420018---------------: Uninstall the UpdateInstaller"

${_WSDIR}/IBM/WebSphere/UpdateInstaller/uninstall/uninstall -silent
rm -rf /optware/IBM/WebSphere/UpdateInstaller/

################################################################################
#    4. Delete profile: Dmgr01
################################################################################
echo " ";
echo "a420018---------------: Delete profile: Dmgr01/02"
${_WSDIR}/IBM/WebSphere/AppServer/bin/manageprofiles.sh -delete -profileName Dmgr01 
${_WSDIR}/IBM/WebSphere/AppServer/bin/manageprofiles.sh -delete -profileName Dmgr02 

email_notify \
  "manageprofiles.sh -delete -profileName Dmgr01 completed, uninstall WAS7..... " \
  "manageprofiles.sh -delete -profileName Dmgr01 completed, uninstall WAS7..... " \
  $_EMAILLIST \
  $_START

################################################################################
#    5. Remove /optware/IBM directory
################################################################################
echo " ";
echo "a420018---------------: Remove WAS binary"
${_WSDIR}/IBM/WebSphere/AppServer/uninstall/uninstall -silent

rm -rf /optware/IBM

email_notify \
  "Uninstall WebSphere Binary and Dmgr01 Completed " \
  "Uninstall WebSphere Binary and Dmgr01 Completed " \
  $_EMAILLIST \
  $_START

