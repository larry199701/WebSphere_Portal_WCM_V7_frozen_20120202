#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    Create the Primary Portal profile template
# Author:
#    Larry Sui
# Date:
#    2011-11-12
#
############################################################################################



#############################################################################################
# Create the Primary Portal profile template
#############################################################################################

email_notify \
  "Start to Create the Primary Portal profile template..." \
  "Start to Create the Primary Portal profile template..." \
  $_EMAILLIST \
  $_START

while read a;
do
  echo "$a" | sed \
    -e "s/PortalAdminId=.*/PortalAdminId=${_WASTEMPUSERNAME}/" \
    -e "s/PortalAdminPwd=.*/PortalAdminPwd=${_WASTEMPPASSWORD}/" \
    -e "s/WasUserid=.*/WasUserid=${_WASTEMPUSERNAME}/" \
    -e "s/WasPassword=.*/WasPassword=${_WASTEMPPASSWORD}/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties  > /tmp/mytmpfile.properties
mv /tmp/mytmpfile.properties ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties

while read a;
do
echo "$a" | sed \
    -e "s/com.ibm.SOAP.loginUserid=.*/com.ibm.SOAP.loginUserid=${_WASTEMPUSERNAME}/" \
    -e "s/com.ibm.SOAP.loginPassword=.*/com.ibm.SOAP.loginPassword=${_WASTEMPPASSWORD}/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/properties/soap.client.props  > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/properties/soap.client.props

# create ${_WSDIR}/IBM/WebSphere/PortalServer/profileTemplates/default.portal/configArchives/Portal.car
${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh enable-profiles

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh enable-profiles Failed." \
    "ConfigEngine.sh enable-profiles Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

# create ${_WSDIR}/IBM/WebSphere/PortalServer/profileTemplates/profileTemplates.zip
${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh package-profiles

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh package-profiles Failed." \
    "ConfigEngine.sh package-profiles Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "Create the Primary Portal profile template Completed." \
  "Create the Primary Portal profile template Completed." \
  $_EMAILLIST \
  $_START

