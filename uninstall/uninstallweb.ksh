#! /usr/bin/ksh

#############################################################################################
#
# Task: 
#    Uninstall IBM HTTPServer V7
#    1. Prepare uninstall: Environment checking...
#    2. Shutting Down the IHS Servers ...
#    3. Uninstall the IBM HTTPServer v7
# Author:
#    Larry Sui
# Date:
#    2012-01-10
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

echo The current hostname is: ${_HOSTNAME}, The intended hostname is:  ${_INTENDEDHOSTNAME}

if [[ ${_HOSTNAME} != $1 ]] then
  echo Usage: uninstallweb.ksh ${_HOSTNAME}
  exit 1
fi

. ${_CURDIR}/uninstallweb/ksh/email_notify_function.ksh
. ${_CURDIR}/uninstallweb/properties/uninstallwebpdwpwebprd01.properties

echo The current directory is: ${_CURDIR}

if [[ "${_INTENDEDDIR}" != "${_CURDIR}" ]] then
  echo Usage: Current directory is ${_CURDIR}. Please goto "${_INTENDEDDIR}" directory.
  exit 1
fi

echo "Are you sure to uninstall IBM HTTP Server v7 to ${_HOSTNAME} ?    (y/n)";
read  yn;

if [[ $yn != "y" ]]; then
  exit 0
fi

echo The uninstall will takes 3 minutes
echo " ";
echo Starting Datetime:  `date`
echo du -gs ${_IHSDIR}/IBM   0.38 GB
echo topas

############################################################################################
#    2. Shutting Down the IHS Servers ...
############################################################################################

_START=`date +%s`

echo Shutting Down the http server ...

/optware/IBM/HTTPServer/bin/apachectl stop
/optware/IBM/HTTPServer/bin/adminctl stop

echo http servers has been stopped.
echo " "
echo " "
echo uninstalling ihs ...

############################################################################################
#    3. Uninstall the IBM HTTPServer v7
############################################################################################

email_notify \
  "Stat to uninstall ihs......" \
  "Stat to uninstall ihs......" \
  $_EMAILLIST \
  $_START

/optware/IBM/HTTPServer/uninstall/uninstall -silent
rm -rf /optware/IBM
# review file: /usr/lib/objrepos/vpd.properties
echo uninstall the IHS V7 completed

email_notify \
  "Uninstall ihs Completed." \
  "Uninstall ihs Completed." \
  $_EMAILLIST \
  $_START

