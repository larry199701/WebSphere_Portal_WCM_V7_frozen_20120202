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

. uninstallwcm/properties/uninstallwcm${_INTENDEDHOSTNAME}.properties

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
echo uninstall wcm take about 6  minutes
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

# remove WebSphere Application Server Manually
rm -rf /tmp/portalinstall.lockfile
#su - wasadm -c '/optware/IBM/WebSphere/AppServer/uninstall/uninstall -silent -OPT removeProfilesOnUninstall="true"'
/optware/IBM/WebSphere/AppServer/uninstall/uninstall -silent -OPT removeProfilesOnUninstall="true"
tail /optware/IBM/WebSphere/AppServer/logs/uninstall/log.txt

/backup/portal/wcmv7/A-2/aix/ppc64/CIP/WAS/installRegistryUtils/bin/installRegistryUtils.sh -cleanAll
/backup/portal/wcmv7/A-2/aix/ppc64/CIP/WAS/installRegistryUtils/bin/installRegistryUtils.sh -listProducts
/backup/portal/wcmv7/A-2/aix/ppc64/CIP/WAS/installRegistryUtils/bin/installRegistryUtils.sh -listPackages

### have to review manually: /usr/lib/objrepos/vpd.properties
### have to review manually: /.ITLMRegistry

#odmdelete -o product
#geninstall -u IBMWPScore
#geninstall -u WebSpherePortalProduct
#geninstall -u WS
lslpp -l | grep IBMWPS
lslpp -l | grep WebSpherePortalProduct
lslpp -l | grep WS


################################################################################
#    3. Uninstall ITCAM Agent
################################################################################

su - wasadm -c "/optware/IBM/ITM/bin/itmcmd agent -f stop yn"
su - wasadm -c "/optware/IBM/ITM/bin/itmcmd agent -f stop ux"
chown -R root:system /optware/IBM/ITM
/optware/IBM/ITM/bin/uninstall.sh yn aix533
/optware/IBM/ITM/bin/uninstall.sh ux aix526
/optware/IBM/ITM/bin/uninstall.sh um aix526
/optware/IBM/ITM/bin/uninstall.sh ul aix526
/optware/IBM/ITM/bin/uninstall.sh uf aix526
/optware/IBM/ITM/bin/uninstall.sh ue aix536
/optware/IBM/ITM/bin/uninstall.sh r6 aix526
/optware/IBM/ITM/bin/uninstall.sh r5 aix526
/optware/IBM/ITM/bin/uninstall.sh r4 aix526
/optware/IBM/ITM/bin/uninstall.sh r3 aix526
/optware/IBM/ITM/bin/uninstall.sh r2 aix526
/optware/IBM/ITM/bin/uninstall.sh ui aix526
/optware/IBM/ITM/bin/uninstall.sh jr aix526
/optware/IBM/ITM/bin/uninstall.sh gs aix526
/optware/IBM/ITM/bin/uninstall.sh ax aix526
/optware/IBM/ITM/bin/uninstall.sh -f

#rm -rf /optware/IBM
