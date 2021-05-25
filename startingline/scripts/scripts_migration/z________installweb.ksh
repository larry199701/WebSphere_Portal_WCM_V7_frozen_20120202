#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    Install and Patch IBM HTTPServer v7 
#    1.0 Prepare install: Environment checking...
#    1.1 Prepare install: create /tmp/responsefile.txt file
#    2. Installing IBM HTTPServer v7
#    3. Install HTTPServer v7 UPDI7 and fixpacks
#    4. create or cp   ${_IHSDIR}/IBM/HTTPServer/certs files
#    5. modify the httpd.conf file:
#    6. start the http servers:
# Author: 
#    Larry Sui
# Date: 
#    2012-01-13
#
############################################################################################

############################################################################################
#    1.0 Prepare install: Environment checking...
############################################################################################

_HOSTNAME=`uname -n`
_INTENDEDHOSTNAME=$1
_CURDIR=`pwd`

if [[ $# != 1 ]] then
  echo Please pass intended hostname as an argument.
  exit 1
fi

echo The current hostname is: ${_HOSTNAME}, The intended hostname is:  ${_INTENDEDHOSTNAME}

if [[ ${_HOSTNAME} != $1 ]] then
  echo Usage: installweb.ksh ${_HOSTNAME}
  exit 1
fi

. ${_CURDIR}/installweb/ksh/email_notify_function.ksh
. ${_CURDIR}/installweb/properties/installweb${_INTENDEDHOSTNAME}.properties

echo The current directory is: ${_CURDIR}

if [[ "${_INTENDEDDIR}" != "${_CURDIR}" ]] then
  echo Usage: Current directory is ${_CURDIR}. Please goto "${_INTENDEDDIR}" directory.
  exit 1
fi

echo "Are you sure to install IBM HTTP Server v7 to ${_HOSTNAME} ?    (y/n)";
read  yn;

if [[ $yn != "y" ]]; then
  exit 0
fi

echo The install will takes 15 minutes
echo " ";
echo `date`
echo log: /ihslogs/,  ${_IHSDIR}/IBM/HTTPServer/logs/install/log.txt
echo du -gs ${_IHSDIR}/IBM   0.38 GB
echo topas

_START=`date +%s`

############################################################################################
#    1.1 Prepare install: create /tmp/responsefile.txt file
############################################################################################

echo "-OPT silentInstallLicenseAcceptance=\"true\" \n\
-OPT allowNonRootSilentInstall=\"true\" \n\
-OPT disableOSPrereqChecking=\"true\" \n\
-OPT installLocation=\"${_IHSDIR}/IBM/HTTPServer\" \n\
-OPT httpPort=\"80\" \n\
-OPT adminPort=\"8008\" \n\
-OPT createAdminAuth=\"true\" \n\
-OPT adminAuthUser=\"ihsadmin\" \n\
-OPT adminAuthPassword=\"ihsadmin\" \n\
-OPT adminAuthPasswordConfirm=\"ihsadmin\" \n\
-OPT runSetupAdmin=\"true\" \n\
-OPT createAdminUserGroup=\"true\" \n\
-OPT setupAdminUser=\"ihsadmin\" \n\
-OPT setupAdminGroup=\"ihsadmin\" \n\
-OPT installPlugin=\"true\" \n\
-OPT webserverDefinition=\"webserver_${_INTENDEDHOSTNAME}\" \n\
-OPT washostname=\"${_WASHOSTNAME}\" " > /tmp/responsefile.txt

############################################################################################
#    2. Installing IBM HTTPServer v7
############################################################################################

echo ${_EMAILLIST}
email_notify \
  "Installing IBM HTTPServer v7 to ${_INTENDEDHOSTNAME} ..." \
  "Installing IBM HTTPServer v7 to ${_INTENDEDHOSTNAME} ..." \
  $_EMAILLIST \
  $_START

/backup/portal/wcmv7/C1G2RML/IHS/install \
  -options "/tmp/responsefile.txt" \
  -silent

if [[ $? != 0 ]] then
  email_notify \
    "IBM HTTPServer v7 Install to ${_INTENDEDHOSTNAME} Failed..... " \
    "IBM HTTPServer v7 Install to ${_INTENDEDHOSTNAME} Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "IBM HTTPServer v7 Install to ${_INTENDEDHOSTNAME} Completed" \
  "IBM HTTPServer v7 Install to ${_INTENDEDHOSTNAME} Completed" \
  $_EMAILLIST \
  $_START




################################################################################
#    3. Install HTTPServer v7 UPDI7 and fixpacks
################################################################################

#### Install UpdateInstaller #########################

which unzip 2>/dev/null 1>/dev/null

if [[ $? = 0 ]] then
  _UNZIP=unzip
else
  _UNZIP=/usr/local/bin/unzip
fi

rm -rf /tmp/UPDI7
rm -f /tmp/responsefile.updiinstaller.txt
mkdir /tmp/UPDI7

${_UNZIP} -o -d /tmp/UPDI7 /backup/portal/wcmv7/fixpacks/uddi7/7.0.0.21-WS-UPDI-AixPPC64.zip
cat > /tmp/responsefile.updiinstaller.txt <<EOF
-OPT silentInstallLicenseAcceptance="true"
-OPT allowNonRootSilentInstall="true"
-OPT disableOSPrereqChecking="true"
-OPT disableEarlyPrereqChecking="true"
-OPT installLocation="${_IHSDIR}/IBM/HTTPServer/UpdateInstaller"
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
  "Install UpdateInstaller completed. Apply fixpacks ..." \
  "Install UpdateInstaller completed. Apply fixpacks ..." \
  $_EMAILLIST \
  $_START

rm -rf /tmp/UPDI7
rm -f /tmp/responsefile.updiinstaller.txt

#### Apply 7.0.0-WS-IHS-AixPPC64-FP0000019.pak and plg7/7.0.0-WS-PLG-AixPPC64-FP0000019.pak #########################

cp /backup/portal/wcmv7/fixpacks/ihs7/7.0.0-WS-IHS-AixPPC64-FP0000019.pak ${_IHSDIR}/IBM/HTTPServer/UpdateInstaller/maintenance
cp /backup/portal/wcmv7/fixpacks/plg7/7.0.0-WS-PLG-AixPPC64-FP0000019.pak ${_IHSDIR}/IBM/HTTPServer/UpdateInstaller/maintenance

${_IHSDIR}/IBM/HTTPServer/UpdateInstaller/update.sh \
  -W maintenance.package="${_IHSDIR}/IBM/HTTPServer/UpdateInstaller/maintenance/7.0.0-WS-IHS-AixPPC64-FP0000019.pak" \
  -W product.location="${_IHSDIR}/IBM/HTTPServer" \
  -W update.type="install" \
  -silent

#rm -f /tmp/install_pak.txt
#cat > /tmp/install_pak.txt <<EOF
#-W maintenance.package="${_IHSDIR}/IBM/HTTPServer/UpdateInstaller/maintenance/7.0.0-WS-IHS-AixPPC64-FP0000019.pak"
#-W product.location="${_IHSDIR}/IBM/HTTPServer"
#-W update.type="install"
#EOF
#${_IHSDIR}/IBM/HTTPServer/UpdateInstaller/update.sh \
#  -options /tmp/install_pak.txt \
#  -silent

if [[ $? != 0 ]] then
  email_notify \
    "Apply 7.0.0-WS-IHS-AixPPC64-FP0000019.pak Failed..... " \
    "Apply 7.0.0-WS-IHS-AixPPC64-FP0000019.pak Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "Apply 7.0.0-WS-IHS-AixPPC64-FP0000019.pak successed." \
  "Apply 7.0.0-WS-IHS-AixPPC64-FP0000019.pak successed." \
  $_EMAILLIST \
  $_START

${_IHSDIR}/IBM/HTTPServer/UpdateInstaller/update.sh \
  -W maintenance.package="${_IHSDIR}/IBM/HTTPServer/UpdateInstaller/maintenance/7.0.0-WS-PLG-AixPPC64-FP0000019.pak" \
  -W product.location="${_IHSDIR}/IBM/HTTPServer/Plugins" \
  -W update.type="install" \
  -silent

if [[ $? != 0 ]] then
  email_notify \
    "Apply 7.0.0-WS-PLG-AixPPC64-FP0000019.pak Failed..... " \
    "Apply 7.0.0-WS-PLG-AixPPC64-FP0000019.pak Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "Apply 7.0.0-WS-PLG-AixPPC64-FP0000019.pak successed." \
  "Apply 7.0.0-WS-PLG-AixPPC64-FP0000019.pak successed." \
  $_EMAILLIST \
  $_START
############################################################################################
#    4. create or cp   ${_IHSDIR}/IBM/HTTPServer/certs files
############################################################################################

cp -R /backup/portal/wcmv7/a420018/install/installweb/certs /${_IHSDIR}/IBM/HTTPServer/
# /backup/portal/wcmv7/a420018/install/installweb/ksh/20120110_installcertificate_scripts.ksh

############################################################################################
#    5. modify the httpd.conf file:
############################################################################################

echo " \n\
 \n\
 \n\
 \n\
 \n\
LoadModule ibm_ssl_module modules/mod_ibm_ssl.so \n\
Listen 443 \n\
<VirtualHost *:443> \n\
  DocumentRoot "${_IHSDIR}/IBM/HTTPServer/htdocs" \n\
  SSLEnable \n\
  SSLProtocolDisable SSLv2 \n\
  KeyFile "${_IHSDIR}/IBM/HTTPServer/certs/20120216_portalprd_https_KeyDb.kdb" \n\
  SSLStashfile "${_IHSDIR}/IBM/HTTPServer/certs/20120216_portalprd_https_KeyDb.sth" \n\

  # Per request from Dave Jone--Perficient
  AllowEncodedSlashes NoDecode \n\
</VirtualHost> \n\
SSLDisable " >> ${_IHSDIR}/IBM/HTTPServer/conf/httpd.conf

############################################################################################
#    6. start the http servers:
############################################################################################
${_IHSDIR}/IBM/HTTPServer/bin/apachectl start
${_IHSDIR}/IBM/HTTPServer/bin/adminctl start

email_notify \
  "IBM HTTPServer creating completed" \
  "IBM HTTPServer creating completed" \
  $_EMAILLIST \
  $_START


# ./installweb.ksh pdwpwebprd01 2>&1 | tee installweb_pdwpwebprd01___________pdwpwebqa01_1.log
