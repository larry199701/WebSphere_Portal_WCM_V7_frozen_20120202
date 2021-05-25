#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    Install WAS, WebSphere Portal, WCM V7 and Fixpacks to the SecondaryNode
#    1.0 Prepare to install: environment checking...
#    1.1 Prepare to Install, create file /tmp/installresponsewcm.txt without wp_profile.
#    2. Install WebSphere Binary V7 without wp_profile
#    3. Create a new profile using profileTemplates.zip: wp_profile
#    4. Install WCM fixpacks
#    5. Install IBM Support Assistant Lite for WebSphere Portal (ISALite)
#    6. WCM Federation
#    7. Create second WebSphere_Portal_n02s01
# Author:
#    Larry Sui
# Date:
#    2011-09-11
#
############################################################################################

############################################################################################
#    1.0 Prepare to Install: Environment checking...
############################################################################################

_HOSTNAME=`uname -n`
_INTENDEDHOSTNAME=$1
_CURDIR=`pwd`


if [[ $# != 1 ]] then
  echo Please pass intended hostname as an argument.
  exit 1
fi    

echo The current hostname is: ${_HOSTNAME}, The intended hostname is: ${_INTENDEDHOSTNAME}

if [[ ${_HOSTNAME} != ${_INTENDEDHOSTNAME} ]] then
  echo Usage: installwcm.ksh ${_HOSTNAME}
  exit 1
fi

. ${_CURDIR}/installwcm/ksh/email_notify_function.ksh
. ${_CURDIR}/installwcm/properties/installwcm${_INTENDEDHOSTNAME}.properties

echo The current directory is: ${_CURDIR}

if [[ "${_INTENDEDDIR}" != "${_CURDIR}" ]] then
  echo Usage: Current directory is ${_CURDIR}. Please goto "${_INTENDEDDIR}" directory.
  exit 1
fi

echo "Are you sure to install WCM to ${_HOSTNAME} ?    (y/n)";
read  yn;

if [[ $yn != "y" ]]; then
  exit 0
fi

echo Starting Datetime:  `date`
echo /usr/lib/objrepos/vpd.properties
echo tail -f /tmp/wpinstalllog.txt
echo du -gs ${_WSDIR}/IBM   3.81 GB
echo The installation takes about 1 hour 15 minutes
echo topas

_START=`date +%s`


############################################################################################
#    1.1 Prepare to Install, create file /tmp/installresponsewcm.txt without wp_profile.
############################################################################################

#-W defaults.isBinaryInstall=\"true\"\n\ is for the secondary nodes...
echo "-silent\n\
-G licenseAccepted=\"true\"\n\
-W welcome.entitlement=\"wcm\"\n\
-W setupTypePanel.selectedSetupTypeId=\"full\"\n\
-W globalInstall.location=\"${_WSDIR}/IBM/WebSphere\"\n\
-W wasPanel.installChoice=\"install\"\n\
-W wasAdmin.user=\"${_WASTEMPUSERNAME}\"\n\
-W wasAdmin.password=\"${_WASTEMPPASSWORD}\"\n\
-W nodeHost.nodeName=\"${_HOSTNAME}Node01\"\n\
-W nodeHost.hostName=\"${_HOSTNAME}.${_DOMAINNAME}\"\n\
-W defaults.isBinaryInstall=\"true\"" > /tmp/installresponsewcm.txt

#############################################################################################
#    2. Install WebSphere Binary V7 without wp_profile
#############################################################################################

email_notify \
  "Start Installing Portal, WCM V7......" \
  "Start Installing Portal, WCM V7......" \
  $_EMAILLIST \
  $_START

# defaults.isBinaryInstall=true tells the installer to not create wp_profile
/backup/portal/wcmv7/A-Setup/install.sh -options /tmp/installresponsewcm.txt
  
if [[ $? != 0 ]] then
  email_notify \
    "WAS/WP/WCM Installation Failed..... " \
    "WAS/WP/WCM Installation Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

rm -f ${_INTENDEDDIR}/installresponsewcm.txt

email_notify \
  "WAS/WP/WCM Install Completed." \
  "WAS/WP/WCM Install Completed." \
  $_EMAILLIST \
  $_START
 
#############################################################################################
#    4. Install WCM fixpacks
#############################################################################################

. ${_CURDIR}/installwcm/ksh/inst_jdkwaswcm_fixpacks_additional.ksh

#############################################################################################
#    3. Create a new profile using profileTemplates.zip: wp_profile
#############################################################################################

# After installing the secondary node without profile, create a new profile: wp_profile

# Dmgr01 install take 43 minutes,
# pdwpappqa02 WCM/fixpacks/fix take 46 minutes
# pdwpappqa01 federation begin 400 minutes. All installation finish at 330 minutes
# wait 8 hour = 480 minutes = 28800 seconds after the ${_CURDIR}/installwcm/lib/profileTemplates created and DMgr01/primary node pdwpappqa01 install/federation complete.

email_notify \
  "wait 6 hour = 360 minutes = 21600 seconds after the ${_CURDIR}/installwcm/lib/profileTemplates created and DMgr01/primary node pdwpappqa01 install/federation complete." \
  "wait 6 hour = 360 minutes = 21600 seconds after the ${_CURDIR}/installwcm/lib/profileTemplates created and DMgr01/primary node pdwpappqa01 install/federation complete." \
  $_EMAILLIST \
  $_START

#sleep 28800
sleep 21600

email_notify \
  "Create a new profile: wp_profile." \
  "Create a new profile: wp_profile." \
  $_EMAILLIST \
  $_START
 
mkdir -p ${_WSDIR}/IBM/WebSphere/PortalServer/profileTemplates
cp -r ${_CURDIR}/installwcm/lib/profileTemplates ${_WSDIR}/IBM/WebSphere/PortalServer

which unzip 2>/dev/null 1>/dev/null
if [[ $? = 0 ]] then
  _UNZIP=unzip
else
  _UNZIP=/usr/local/bin/unzip
fi

echo "a420018:-------unzip the ${_WSDIR}/IBM/WebSphere/PortalServer/profileTemplates/profileTemplates.zip"
${_UNZIP} -o -d ${_WSDIR}/IBM/WebSphere/PortalServer/profileTemplates ${_WSDIR}/IBM/WebSphere/PortalServer/profileTemplates/profileTemplates.zip

chmod -R 755  ${_WSDIR}/IBM/WebSphere/PortalServer/profileTemplates

cd ${_WSDIR}/IBM/WebSphere/PortalServer/profileTemplates/;./installPortalTemplates.sh ${_WSDIR}/IBM/WebSphere/AppServer;cd ${_CURDIR}
${_WSDIR}/IBM/WebSphere/PortalServer/profileTemplates/installPortalTemplates.sh ${_WSDIR}/IBM/WebSphere/AppServer

#If you attempt to add a node to a cell and the cell name of the targeted node is the same as the cell name to which the
#node will be federated, the ADMU0027E message occurs and the node is not federated.

${_WSDIR}/IBM/WebSphere/AppServer/bin/manageprofiles.sh \
  -create \
  -templatePath ${_WSDIR}/IBM/WebSphere/PortalServer/profileTemplates/managed.portal \
  -profileName wp_profile \
  -profilePath ${_WSDIR}/IBM/WebSphere/wp_profile \
  -cellName ${_DMGRHOSTNAME}Cell01_tmp \
  -nodeName ${_INTENDEDHOSTNAME}Node01 \
  -hostName ${_INTENDEDHOSTNAME}.${_DOMAINNAME}

if [[ $? != 0 ]] then
  email_notify \
    "manageprofiles.sh create wp_profile Failed..... " \
    "manageprofiles.sh create wp_profile Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "manageprofiles.sh create wp_profile successed." \
  "manageprofiles.sh create wp_profile successed." \
  $_EMAILLIST \
  $_START

#############################################################################################
#    5. Install IBM Support Assistant Lite for WebSphere Portal (ISALite)
#############################################################################################

. ${_CURDIR}/installwcm/ksh/inst_ISALite.ksh

#############################################################################################
#    6.  WCM Federation
#############################################################################################

. ${_CURDIR}/installwcm/ksh/federation_additionalnode.ksh

echo "a420018: -- finish federation_additionalnode.ksh "
#############################################################################################
#    7.  Create second WebSphere_Portal_n02s01
#############################################################################################

echo "a420018: ----createclstermember_additional.ksh"
. ${_CURDIR}/installwcm/ksh/createclustermember_additional.ksh

#############################################################################################
# 8. tasks needed afterwards
#   8.1 disable portal server web container transport chains: HttpQueueInboundDefault;WCInboundDefault and restart the portal servers
#   8.2 two webservers: Copy to Web server key store directory;generated plug-in; propagate plug-in; restart the web servers
#############################################################################################

# fully synchronize

#############################################################################################
# 9.  Change to non-root user:
# /optware/IBM/WebSphere/wp_profile/bin/stopServer.sh WebSphere_Portal_n02s01
# /optware/IBM/WebSphere/wp_profile/bin/stopNode.sh
# cp -R /optware/IBM /optware/IBM_Backup_root
# chown -R wasadm:wsadm /optware/IBM
# chown -Rh wasadm:wsadm /optware/IBM
# find /optware/IBM/ -user root
# su - wasadm -c "/optware/IBM/WebSphere/wp_profile/bin/startNode.sh"
# su - wasadm -c "/optware/IBM/WebSphere/wp_profile/bin/startServer.sh WebSphere_Portal_n02s01"
#############################################################################################



