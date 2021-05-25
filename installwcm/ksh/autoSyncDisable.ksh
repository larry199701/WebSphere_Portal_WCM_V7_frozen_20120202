#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    8. autoSyncDisable
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


###############################################################################################
# autoSyncDisable.py
###############################################################################################
 
email_notify \
  "Start wsadmin.sh autoSyncDisable.py..." \
  "Start wsadmin.sh autoSyncDisable.py..." \
  $_EMAILLIST \
  $_START

cat > /tmp/autoSyncDisable.py <<EOF
# get a handle to the nodeagent
nodeagent = AdminConfig.getid('/Node:${_INTENDEDHOSTNAME}Node01/Server:nodeagent/')

# get a handle to the ConfigSynchronizationService
syncservice = AdminConfig.list('ConfigSynchronizationService', nodeagent)

# disable Automatic synchronization
#AdminConfig.modify(syncservice,'[[autoSynchEnabled "true"]]')
AdminConfig.modify(syncservice,'[[autoSynchEnabled "false"]]')

AdminConfig.save()

AdminControl.invoke(AdminControl.queryNames('WebSphere:type=ConfigRepository,name=repository,process=nodeagent,cell=${_DMGRHOSTNAME}Cell01,node=${_INTENDEDHOSTNAME}Node01,*'), 'refreshRepositoryEpoch')

AdminControl.invoke(AdminControl.completeObjectName('type=NodeSync,node=${_INTENDEDHOSTNAME}Node01,*'), 'sync')
EOF

echo "a420018:-------autoSyncDisable.py..."
${_WSDIR}/IBM/WebSphere/wp_profile/bin/wsadmin.sh \
  -lang jython \
  -conntype SOAP \
  -host ${_DMGRHOSTNAME} \
  -port ${_WASSOAPPORT} \
  -f  /tmp/autoSyncDisable.py

if [[ $? != 0 ]] then
  email_notify \
    "wsadmin.sh autoSyncDisable.py Failed." \
    "wsadmin.sh autoSyncDisable.py Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "wsadmin.sh autoSyncDisable.py successed." \
  "wsadmin.sh autoSyncDisable.py successed." \
  $_EMAILLIST \
  $_START


