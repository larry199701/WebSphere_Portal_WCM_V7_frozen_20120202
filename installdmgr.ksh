#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    Install and Patching the Deployment Manager v7
#    1.0 Prepare to Install: Environment checking...
#    1.1 Prepare to Install: create responsefiledmgr.txt file
#    2. Install WebSphere V7 Binary
#    3. Create Dmgr01 Profile
#    4. Dmgr01 Augment
#    5. Install JDK and WAS fixpacks 
#    6. Start the Dmgr01  
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

echo "The current hostname is: $_HOSTNAME; \n\
   \tThe intended hostname is:  $_INTENDEDHOSTNAME; \n\
   \tThe current directory is: ${_CURDIR}"

if [[ $_HOSTNAME != $1 ]] then
  echo Usage: installdmgr.ksh $_HOSTNAME
  exit 1
fi

. ${_CURDIR}/installdmgr/properties/installdmgr${_INTENDEDHOSTNAME}.properties
. ${_CURDIR}/installdmgr/ksh/email_notify_function.ksh

if [[ "${_INTENDEDDIR}" != "${_CURDIR}" ]] then
  echo Usage: Current directory is ${_CURDIR}. Please goto "${_INTENDEDDIR}" directory.
  exit 1
fi

echo "Are you sure to install WebSphere Binary and Deployment Manager to $_HOSTNAME ?    (y/n)";
read  yn;

if [[ $yn != "y" ]]; then
  exit 0
fi

echo "The install will takes 15 minutes"
echo "\tCurrent Time: `date`"
echo "\ttail -f /waslogs/log.txt"
echo "\tdu -gs ${_WSDIR}/IBM   3.01 GB"
echo "\ttopas"

_START=`date +%s`

############################################################################################
#    1.1 Prepare to Install: create responsefiledmgr.txt file
############################################################################################

rm /tmp/responsefiledmgr.txt

echo "-OPT silentInstallLicenseAcceptance=\"true\" \n\
-OPT if_cip_modifyexistinginstall=customizationAndMaintenance \n\
-OPT installType=\"installNew\" \n\
-OPT profileType=\"none\" \n\
-OPT feature=\"languagepack.console.all\" \n\
-OPT feature=\"languagepack.server.all\" \n\
-OPT installLocation=\"${_WSDIR}/IBM/WebSphere/AppServer\" " > /tmp/responsefiledmgr.txt

############################################################################################
#    2. Installing WebSphere v7 Binary
############################################################################################

email_notify \
  "Installing WebSphere Binary ..." \
  "Installing WebSphere Binary ..." \
  $_EMAILLIST \
  $_START

echo "a420018---------------: /backup/portal/wcmv7/A-2/aix/ppc64/CIP/WAS/install \n\
    \t-options /tmp/responsefiledmgr.txt \n\
    \t-silent"

/backup/portal/wcmv7/A-2/aix/ppc64/CIP/WAS/install \
  -options /tmp/responsefiledmgr.txt \
  -silent

if [[ $? != 0 ]] then
  email_notify \
    "WebSphere Binary Installation Failed..... " \
    "WebSphere Binary Installation Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "WebSphere Binary Install Completed, creating Dmgr01 profile..." \
  "WebSphere Binary Install Completed, creating Dmgr01 profile..." \
  $_EMAILLIST \
  $_START

rm /tmp/responsefiledmgr.txt

############################################################################################
#    3. create Dmgr01 profile
############################################################################################

echo "\tLogs user_data_root/profileRegistry/logs/manageprofiles"
echo "a420018---------------: ${_WSDIR}/IBM/WebSphere/AppServer/bin/manageprofiles.sh \n\
  \t-create \n\
  \t-profileName Dmgr01 \n\
  \t-profilePath ${_WSDIR}/IBM/WebSphere/AppServer/profiles/Dmgr01 \n\
  \t-templatePath ${_WSDIR}/IBM/WebSphere/AppServer/profileTemplates/management  \n\
  \t-cellName ${_HOSTNAME}Cell01 \n\
  \t-hostName ${_HOSTNAME}.${_DOMAINNAME} \n\
  \t-nodeName ${_HOSTNAME}Dmgr01 \n\
  \t-isDefault \n\
  \t-enableAdminSecurity true \n\
  \t-adminUserName ${_WASTEMPUSERNAME} \n\
  \t-adminPassword ${_WASTEMPPASSWORD}" 

${_WSDIR}/IBM/WebSphere/AppServer/bin/manageprofiles.sh \
  -create \
  -profileName Dmgr01 \
  -profilePath ${_WSDIR}/IBM/WebSphere/AppServer/profiles/Dmgr01 \
  -templatePath ${_WSDIR}/IBM/WebSphere/AppServer/profileTemplates/management \
  -cellName ${_HOSTNAME}Cell01 \
  -hostName ${_HOSTNAME}.${_DOMAINNAME} \
  -nodeName ${_HOSTNAME}Dmgr01 \
  -isDefault \
  -enableAdminSecurity true \
  -adminUserName ${_WASTEMPUSERNAME} \
  -adminPassword ${_WASTEMPPASSWORD}


if [[ $? != 0 ]] then
  email_notify \
    "Creating Dmgr01 profile Failed..... " \
    "Creating Dmgr01 profile Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "creating Dmgr01 profile completed, Augumenting Dmgr01..." \
  "creating Dmgr01 profile completed, Augumenting Dmgr01..." \
  $_EMAILLIST \
  $_START

############################################################################################
#    4. Augument the Dmgr01
#       .increases the HTTP connection timeouts for Dmgr01
#       .increases the SOAP connector timeout for JMX in the Dmgr01
#       .increases the JVM Maximum Heap size for the Dmgr01
#       .Enables Application Security
#       .Creates a 'wpsadmins' group in the default file repository
#       .adds the admin user to the 'wpsadmins' group
#       .increases the soap timeout in the soap.client.props file
############################################################################################

echo "\tcopy the files from filesForDmgr.zip to the Dmgr01..."
mkdir -p /tmp/installdmgr/filesForDmgr

which unzip 2>/dev/null 1>/dev/null

if [[ $? = 0 ]] then
  _UNZIP=unzip
else
  _UNZIP=/usr/local/bin/unzip
fi

${_UNZIP} -o -d /tmp/installdmgr/filesForDmgr -q ${_CURDIR}/installdmgr/lib/filesForDmgr.zip

echo "\t/tmp/installdmgr/filesForDmgr/bin/ProfileManagement/plugins/com.ibm.wp.dmgr.pmt_7.0.0"
mkdir -p ${_WSDIR}/IBM/WebSphere/AppServer/bin/ProfileManagement/plugins
cp -r /tmp/installdmgr/filesForDmgr/bin/ProfileManagement/plugins/com.ibm.wp.dmgr.pmt_7.0.0 ${_WSDIR}/IBM/WebSphere/AppServer/bin/ProfileManagement/plugins

echo "\t/tmp/installdmgr/filesForDmgr/lib/wkplc.comp.registry.jar"
cp /tmp/installdmgr/filesForDmgr/lib/wkplc.comp.registry.jar ${_WSDIR}/IBM/WebSphere/AppServer/lib

echo "\t/tmp/installdmgr/filesForDmgr/lib/wp.wire.jar"
cp /tmp/installdmgr/filesForDmgr/lib/wp.wire.jar ${_WSDIR}/IBM/WebSphere/AppServer/lib

echo "\t/tmp/installdmgr/filesForDmgr/plugins/com.ibm.patch.was.plugin.jar"
cp /tmp/installdmgr/filesForDmgr/plugins/com.ibm.patch.was.plugin.jar ${_WSDIR}/IBM/WebSphere/AppServer/plugins

echo "\t/tmp/installdmgr/filesForDmgr/plugins/com.ibm.wp.was.plugin.jar"
cp /tmp/installdmgr/filesForDmgr/plugins/com.ibm.wp.was.plugin.jar ${_WSDIR}/IBM/WebSphere/AppServer/plugins

echo "\t/tmp/installdmgr/filesForDmgr/plugins/wp.base.jar"
cp /tmp/installdmgr/filesForDmgr/plugins/wp.base.jar ${_WSDIR}/IBM/WebSphere/AppServer/plugins

echo "\t/tmp/installdmgr/filesForDmgr/profileTemplates/management.portal.augment"
cp -r /tmp/installdmgr/filesForDmgr/profileTemplates/management.portal.augment ${_WSDIR}/IBM/WebSphere/AppServer/profileTemplates

echo "\t/tmp/installdmgr/filesForDmgr/profiles/Dmgr01/config/.repository/metadata_wkplc.xml"
cp /tmp/installdmgr/filesForDmgr/profiles/Dmgr01/config/.repository/metadata_wkplc.xml ${_WSDIR}/IBM/WebSphere/AppServer/profiles/Dmgr01/config/.repository

rm -rf /tmp/installdmgr

echo "\tFiles from /tmp/installdmgr/filesForDmgr/filesForDmgr.zip are copied to the Dmgr01"
echo "\tAugument the Dmgr01..."
echo " "

echo "a420018---------------: ${_WSDIR}/IBM/WebSphere/AppServer/bin/manageprofiles.sh \n\
  \t-augment \n\
  \t-templatePath ${_WSDIR}/IBM/WebSphere/AppServer/profileTemplates/management.portal.augment \n\
  \t-profileName Dmgr01"

${_WSDIR}/IBM/WebSphere/AppServer/bin/manageprofiles.sh \
  -augment \
  -templatePath ${_WSDIR}/IBM/WebSphere/AppServer/profileTemplates/management.portal.augment \
  -profileName Dmgr01


if [[ $? != 0 ]] then
  email_notify \
    "Augumenting Dmgr01 Failed..... " \
    "Augumenting Dmgr01 Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "Augumenting Dmgr01 completed. install UpdateInstaller ..." \
  "Augumenting Dmgr01 completed. install UpdateInstaller ..." \
  $_EMAILLIST \
  $_START

################################################################################
#    5. Install JDK and WAS fixpacks 
################################################################################

#### install UpdateInstaller #########################

rm -rf /tmp/UPDI7
rm -f /tmp/responsefile.updiinstaller.txt
mkdir /tmp/UPDI7

${_UNZIP} -o -d /tmp/UPDI7 /backup/portal/wcmv7/fixpacks/was7/7.0.0.19-WS-UPDI-AixPPC64.zip
cat > /tmp/responsefile.updiinstaller.txt <<EOF
-OPT silentInstallLicenseAcceptance="true"
-OPT allowNonRootSilentInstall="true"
-OPT disableOSPrereqChecking="true"
-OPT disableEarlyPrereqChecking="true"
-OPT installLocation="${_WSDIR}/IBM/WebSphere/UpdateInstaller"
EOF

echo "a420018---------------: /tmp/UPDI7/UpdateInstaller/install \n\
  \t-options /tmp/responsefile.updiinstaller.txt \n\
  \t-silent"

/tmp/UPDI7/UpdateInstaller/install \
  -options /tmp/responsefile.updiinstaller.txt \
  -silent

if [[ $? != 0 ]] then
  email_notify \
    "UpdateInstaller installation Failed..... " \
    "UpdateInstaller installation Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "Install UpdateInstaller completed. Apply JDK/WAS FP0000013.pak ..." \
  "Install UpdateInstaller completed. Apply JDK/WAS FP0000013.pak ..." \
  $_EMAILLIST \
  $_START

rm -rf /tmp/UPDI7
rm -f /tmp/responsefile.updiinstaller.txt

#### install JDK and WAS fixpacks #########################
cp /backup/portal/wcmv7/fixpacks/was7/7.0.0-WS-WASSDK-AixPPC64-FP0000013.pak ${_WSDIR}/IBM/WebSphere/UpdateInstaller/maintenance
cp /backup/portal/wcmv7/fixpacks/was7/7.0.0-WS-WAS-AixPPC64-FP0000013.pak ${_WSDIR}/IBM/WebSphere/UpdateInstaller/maintenance

rm -f /tmp/install_pak.txt
cat > /tmp/install_pak.txt <<EOF
-W maintenance.package="\
${_WSDIR}/IBM/WebSphere/UpdateInstaller/maintenance/7.0.0-WS-WASSDK-AixPPC64-FP0000013.pak;\
${_WSDIR}/IBM/WebSphere/UpdateInstaller/maintenance/7.0.0-WS-WAS-AixPPC64-FP0000013.pak"
-W product.location="${_WSDIR}/IBM/WebSphere/AppServer"
-W update.type="install"
EOF

#kill all java processes
#kill -9 `ps -ef | grep "dmgr" | awk '{print $2}'`
${_WSDIR}/IBM/WebSphere/UpdateInstaller/update.sh \
  -options /tmp/install_pak.txt \
  -silent

if [[ $? != 0 ]] then
  email_notify \
    "Apply JDK/WAS FP0000013.pak Failed..... " \
    "Apply JDK/WAS FP0000013.pak Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

rm -f /tmp/install_pak.txt

email_notify \
  "Apply JDK/WAS FP0000013.pak successed. Start Deployment Manager ..." \
  "Apply JDK/WAS FP0000013.pak successed. Start Deployment Manager ..." \
  $_EMAILLIST \
  $_START


################################################################################
#    6. Start the Dmgr01  
################################################################################

echo "a420018---------------: ${_WSDIR}/IBM/WebSphere/AppServer/profiles/Dmgr01/bin/startManager.sh "
${_WSDIR}/IBM/WebSphere/AppServer/profiles/Dmgr01/bin/startManager.sh
if [[ $? != 0 ]] then
  email_notify \
    "startManager.sh Failed..... " \
    "startManager.sh Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "Start Deployment Manager successed ..." \
  "Start Deployment Manager successed ..." \
  $_EMAILLIST \
  $_START

# After ./ConfigEngine.sh wp-change-was-admin-user, following modification is needed:
while read a;
do
  echo "$a" | sed \
    -e "s/com.ibm.SOAP.loginUserid=.*/com.ibm.SOAP.loginUserid=${_ADMINLDAPUSERNAME}/" \
    -e "s/com.ibm.SOAP.loginPassword=.*/com.ibm.SOAP.loginPassword=${_ADMINLDAPPASSWORD}/"
done  < ${_WSDIR}/IBM/WebSphere/AppServer/profiles/Dmgr01/properties/soap.client.props  > mytmpfile.props
mv mytmpfile.props ${_WSDIR}/IBM/WebSphere/AppServer/profiles/Dmgr01/properties/soap.client.props

email_notify \
  "WAS/Dmgr01 created,Augument completed,JDK,WAS fixpacks applied.Dmgr01 is started." \
  "WAS/Dmgr01 created,Augument completed,JDK,WAS fixpacks applied.Dmgr01 is started." \
  $_EMAILLIST \
  $_START

################################################################################
#    7. Change to non-root user
#       /optware/IBM/WebSphere/AppServer/profiles/Dmgr01/bin/stopManager.sh
#       cp -R /optware/IBM /optware/IBM_Backup_root
#       chown -R wasadm:wsadm /optware/IBM
#       chown -Rh wasadm:wsadm /optware/IBM
#       cd /optware/IBM
#       find /optware/IBM -user root
#       su - wasadm -c "/optware/IBM/WebSphere/AppServer/profiles/Dmgr01/bin/startManager.sh"
################################################################################
