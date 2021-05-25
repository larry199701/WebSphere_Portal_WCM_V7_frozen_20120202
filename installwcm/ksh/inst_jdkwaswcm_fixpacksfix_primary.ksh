

###############################################################################################
# Install JDK and WAS fixpacks...
###############################################################################################
email_notify \
  "Start to Install JDK and WAS fixpacks...." \
  "Start to Install JDK and WAS fixpacks...." \
  $_EMAILLIST \
  $_START

which unzip 2>/dev/null 1>/dev/null

if [[ $? = 0 ]] then
  _UNZIP=unzip
else
  _UNZIP=/usr/local/bin/unzip
fi

rm -rf /tmp/UPDI7
rm -f /tmp/responsefile.updiinstaller.txt
mkdir /tmp/UPDI7

email_notify \
  "Start to Install UPDI7...." \
  "Start to Install UPDI7...." \
  $_EMAILLIST \
  $_START

echo "a420018:-------unzip the UPDI7 file to /tmp/UPDI7"
${_UNZIP} -o -d /tmp/UPDI7 /backup/portal/wcmv7/fixpacks/was7/7.0.0.19-WS-UPDI-AixPPC64.zip
cat > /tmp/responsefile.updiinstaller.txt <<EOF
-OPT silentInstallLicenseAcceptance="true"
-OPT allowNonRootSilentInstall="true"
-OPT disableOSPrereqChecking="true"
-OPT disableEarlyPrereqChecking="true"
-OPT installLocation="${_WSDIR}/IBM/WebSphere/UpdateInstaller"
EOF

echo "a420018:-------install the UPDI7"
/tmp/UPDI7/UpdateInstaller/install -options /tmp/responsefile.updiinstaller.txt -silent

if [[ $? != 0 ]] then
  email_notify \
    "Install UPDI7 Failed..... " \
    "Install UPDI7 Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "Install UPDI7 completed." \
  "Install UPDI7 completed." \
  $_EMAILLIST \
  $_START

email_notify \
  "Start Install JDK/WAS FP0000013.pak...." \
  "Start Install JDK/WAS FP0000013.pak...." \
  $_EMAILLIST \
  $_START

cp /backup/portal/wcmv7/fixpacks/was7/7.0.0-WS-WASSDK-AixPPC64-FP0000013.pak ${_WSDIR}/IBM/WebSphere/UpdateInstaller/maintenance
cp /backup/portal/wcmv7/fixpacks/was7/7.0.0-WS-WAS-AixPPC64-FP0000013.pak ${_WSDIR}/IBM/WebSphere/UpdateInstaller/maintenance

cat > /tmp/install_pak.txt <<EOF
-W maintenance.package="\
${_WSDIR}/IBM/WebSphere/UpdateInstaller/maintenance/7.0.0-WS-WASSDK-AixPPC64-FP0000013.pak;\
${_WSDIR}/IBM/WebSphere/UpdateInstaller/maintenance/7.0.0-WS-WAS-AixPPC64-FP0000013.pak"
-W product.location="${_WSDIR}/IBM/WebSphere/AppServer"
-W update.type="install"
EOF

#kill all java processes
#kill -9 `ps -ef | grep "pdwpappqa01Node01 WebSphere_Portal" | awk '{print $2}'`

while read a;
do
echo "$a" | sed \
    -e "s/com.ibm.SOAP.loginUserid=.*/com.ibm.SOAP.loginUserid=${_WASTEMPUSERNAME}/" \
    -e "s/com.ibm.SOAP.loginPassword=.*/com.ibm.SOAP.loginPassword=${_WASTEMPPASSWORD}/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/properties/soap.client.props  > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/properties/soap.client.props

${_WSDIR}/IBM/WebSphere/wp_profile/bin/stopServer.sh WebSphere_Portal
${_WSDIR}/IBM/WebSphere/wp_profile/bin/stopServer.sh server1

echo "a420018:-------install 7.0.0-WS-WASSDK-AixPPC64-FP0000013.pak and 7.0.0-WS-WAS-AixPPC64-FP0000013.pak"
echo "a420018:-------${_WSDIR}/IBM/WebSphere/UpdateInstaller/logs/tmp/updatetrace.log"
${_WSDIR}/IBM/WebSphere/UpdateInstaller/update.sh -options /tmp/install_pak.txt -silent

if [[ $? != 0 ]] then
  email_notify \
    "Install JDK/WAS FP0000013.pak Failed..... " \
    "Install JDK/WAS FP0000013.pak Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "Install JDK/WAS FP0000013.pak completed." \
  "Install JDK/WAS FP0000013.pak completed." \
  $_EMAILLIST \
  $_START

email_notify \
  "Start HealthCheck/Install WCM fixpacks..." \
  "Start HealthCheck/Install WCM fixpacks..." \
  $_EMAILLIST \
  $_START

################################################################################
# healthChecker ##########
################################################################################

# Modify ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties
if [ ! -f ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties_original ]
then
  cp ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties_original
fi

while read a;
do
  echo "$a" | sed \
    -e "s/PortalAdminId=.*/PortalAdminId=${_WASTEMPUSERNAME}/" \
    -e "s/PortalAdminPwd=.*/PortalAdminPwd=${_WASTEMPPASSWORD}/" \
    -e "s/WasUserid=.*/WasUserid=${_WASTEMPUSERNAME}/" \
    -e "s/WasPassword=.*/WasPassword=${_WASTEMPPASSWORD}/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties  > /tmp/mytmpfile.properties
mv /tmp/mytmpfile.properties ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties

echo "a420018:-------begin healthChecker..."
#### healthChecker
# DMGRServer:/startManager.sh
rm -rf /tmp/WP-UPDI7
rm -f ${_WSDIR}/IBM/WebSphere/PortalServer/installer/wp.config/config/includes/upgrade_health_check.xml
${_UNZIP} -o -d /tmp/WP-UPDI7 /backup/portal/wcmv7/fixpacks/wcm7/7.0-WP-UpdateInstaller-Universal.zip
${_UNZIP} -o -d ${_WSDIR}/IBM/WebSphere/PortalServer /tmp/WP-UPDI7/healthChecker.zip
${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh -DRequiredWAS=7.0.0.11 action-health-check-validation

if [[ $? != 0 ]] then
  email_notify \
    "action-health-check-validation Failed..... " \
    "action-health-check-validation Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "action-health-check-validation successed. Install WCM fixpacks..." \
  "action-health-check-validation successed. Install WCM fixpacks..." \
  $_EMAILLIST \
  $_START

echo "a420018:-------end healthChecker..."

################################################################################
#### install WP_PTF_7001
################################################################################

# running inside the same shell
. ${_WSDIR}/IBM/WebSphere/wp_profile/bin/setupCmdLine.sh

# Disable nodeagent Automatic Synchronization

# Modify ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties
if [ ! -f ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties_original ]
then
  cp ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties_original
fi

while read a;
do
echo "$a" | sed \
    -e "s/PortalAdminId=.*/PortalAdminId=${_WASTEMPUSERNAME}/" \
    -e "s/PortalAdminPwd=.*/PortalAdminPwd=${_WASTEMPPASSWORD}/" \
    -e "s/WasUserid=.*/WasUserid=${_WASTEMPUSERNAME}/" \
    -e "s/WasPassword=.*/WasPassword=${_WASTEMPPASSWORD}/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties  > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties
# cp fixpacks WP_PTF_7001

echo "a420018:------- unzip fixpacks ..."
rm -rf ${_WSDIR}/IBM/WebSphere/PortalServer/update/fixpacks
mkdir -p ${_WSDIR}/IBM/WebSphere/PortalServer/update/fixpacks
${_UNZIP} -o -d ${_WSDIR}/IBM/WebSphere/PortalServer/update /backup/portal/wcmv7/fixpacks/wcm7/7.0-WP-UpdateInstaller-Universal.zip
cp /backup/portal/wcmv7/fixpacks/wcm7/WP_PTF_7001.ptflist ${_WSDIR}/IBM/WebSphere/PortalServer/update/fixpacks
${_UNZIP} -o -d ${_WSDIR}/IBM/WebSphere/PortalServer/update/fixpacks /backup/portal/wcmv7/fixpacks/wcm7/7.0.0-WP-Multi-FP001.zip

echo "a420018:-------install WP_PTF_7001 ..."
${_WSDIR}/IBM/WebSphere/PortalServer/update/updatePortal.sh -install \
  -installDir "${_WSDIR}/IBM/WebSphere/PortalServer" \
  -fixpack \
  -fixpackDir "${_WSDIR}/IBM/WebSphere/PortalServer/update/fixpacks" \
  -fixpackID WP_PTF_7001

if [[ $? != 0 ]] then
  email_notify \
    "install WCM fixpack WP_PTF_7001 Failed... " \
    "install WCM fixpack WP_PTF_7001 Failed... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "install WCM fixpack WP_PTF_7001 successed, install WCM fix PM46623..." \
  "install WCM fixpack WP_PTF_7001 successed, install WCM fix PM46623..." \
  $_EMAILLIST \
  $_START

################################################################################
### install fixes PM46623 
################################################################################
echo "a420018:------- unzip fixes ..."
mkdir -p ${_WSDIR}/IBM/WebSphere/PortalServer/update/fixes
${_UNZIP} -o -d ${_WSDIR}/IBM/WebSphere/PortalServer/update/fixes /backup/portal/wcmv7/fixpacks/wcm7/7.0.0.1-WP-WCM-Combined-CFPM46623-CF008.zip

# Modify ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties
if [ ! -f ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties_original ]
then
  cp ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties_original
fi

while read a;
do
echo "$a" | sed \
    -e "s/PortalAdminId=.*/PortalAdminId=${_WASTEMPUSERNAME}/" \
    -e "s/PortalAdminPwd=.*/PortalAdminPwd=${_WASTEMPPASSWORD}/" \
    -e "s/WasUserid=.*/WasUserid=${_WASTEMPUSERNAME}/" \
    -e "s/WasPassword=.*/WasPassword=${_WASTEMPPASSWORD}/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties  > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties

${_WSDIR}/IBM/WebSphere/wp_profile/bin/stopServer.sh WebSphere_Portal
${_WSDIR}/IBM/WebSphere/wp_profile/bin/stopServer.sh server1

. ${_WSDIR}/IBM/WebSphere/wp_profile/bin/setupCmdLine.sh

echo "a420018:-------PM46623 ..."

${_WSDIR}/IBM/WebSphere/PortalServer/update/updatePortal.sh -install \
  -installDir "${_WSDIR}/IBM/WebSphere/PortalServer" \
  -fix \
  -fixDir "${_WSDIR}/IBM/WebSphere/PortalServer/update/fixes" \
  -fixes PM46623

if [[ $? != 0 ]] then
  email_notify \
    "install WCM fix PM46623 Failed... " \
    "install WCM fix PM46623 Failed... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "installfix WCM PM46623 successed." \
  "installfix WCM PM46623 successed." \
  $_EMAILLIST \
  $_START
