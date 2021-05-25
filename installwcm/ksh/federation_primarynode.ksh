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


###############################################################################################################################
: << 'COMMENTEND'
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
COMMENTEND
###############################################################################################################################



#############################################################################################
# 4. WCM Federation
#############################################################################################

email_notify \
  "Begin WCM Federation ..." \
  "Begin WCM Federation ..." \
  $_EMAILLIST \
  $_START

while read a;
do
echo "$a" | sed \
    -e "s/com.ibm.SOAP.loginUserid=.*/com.ibm.SOAP.loginUserid=${_WASTEMPUSERNAME}/" \
    -e "s/com.ibm.SOAP.loginPassword=.*/com.ibm.SOAP.loginPassword=${_WASTEMPPASSWORD}/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/properties/soap.client.props  > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/properties/soap.client.props

# within 5 minutes between Dmgr01 and Portal server
${_WSDIR}/IBM/WebSphere/wp_profile/bin/stopServer.sh WebSphere_Portal
${_WSDIR}/IBM/WebSphere/wp_profile/bin/stopServer.sh server1
${_WSDIR}/IBM/WebSphere/wp_profile/bin/addNode.sh ${_DMGRHOSTNAME}.${_DOMAINNAME} ${_WASSOAPPORT} -includeapps -includebuses
# a420018: restart the Dmg01

if [[ $? != 0 ]] then
  email_notify \
    "WCM Federation Failed..... " \
    "WCM Federation Failed..... " \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "WCM Federation Completed, creating a Cluster..." \
  "WCM Federation Completed, creating a Cluster..." \
  $_EMAILLIST \
  $_START



