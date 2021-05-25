#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    5. WCM Federation
# Author:
#    Larry Sui
# Date:
#    2011-09-11
#
############################################################################################


#############################################################################################
# WCM Additional Node Federation
#############################################################################################

email_notify \
  "Begin WCM Additional Node Federation ..." \
  "Begin WCM Additional Node Federation ..." \
  $_EMAILLIST \
  $_START

# Modify ${_WSDIR}/IBM/WebSphere/PortalServer/wps.properties
if [ ! -f ${_WSDIR}/IBM/WebSphere/PortalServer/wps.properties_original ]
then
  cp ${_WSDIR}/IBM/WebSphere/PortalServer/wps.properties ${_WSDIR}/IBM/WebSphere/PortalServer/wps.properties_original
fi

echo "\n\n\
# a420018: added for creating wp_profile\n\
ProfileName=wp_profile\"\n\
ProfileDirectory=/optware/IBM/WebSphere/wp_profile" >> ${_WSDIR}/IBM/WebSphere/PortalServer/wps.properties

while read a;
do
  echo "$a" | sed \
    -e "s/com.ibm.SOAP.loginUserid=.*/com.ibm.SOAP.loginUserid=${_ADMINLDAPUSERNAME}/" \
    -e "s/com.ibm.SOAP.loginPassword=.*/com.ibm.SOAP.loginPassword=${_ADMINLDAPPASSWORD}/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/properties/soap.client.props  > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/properties/soap.client.props

# validate-database
# Database domains username/password changes will failed this task
${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh validate-database 

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh validate-database Failed..... " \
    "ConfigEngine.sh validate-database Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

${_WSDIR}/IBM/WebSphere/wp_profile/bin/addNode.sh ${_DMGRHOSTNAME}.${_DOMAINNAME} ${_WASSOAPPORT}
# a420018: restart the Dmg01

if [[ $? != 0 ]] then
  email_notify \
    "WCM Additional Node Federation Failed..... " \
    "WCM Additional Node Federation Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "WCM Additional Node Federation Completed." \
  "WCM Additional Node Federation Completed." \
  $_EMAILLIST \
  $_START

# ${_WSDIR}/IBM/WebSphere/wp_profile/bin/startNode.sh

echo "a420018: ----finish startNode.sh"
