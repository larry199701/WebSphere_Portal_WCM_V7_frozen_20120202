#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    6. Create a Cluster: PortalCluster, AdminTask.addSIBusMember
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

. ${_CURDIR}/installwcm/ksh/email_notify_function.ksh
. ${_CURDIR}/installwcm/properties/installwcm${_INTENDEDHOSTNAME}.properties

_START=`date +%s`
COMMENTEND
###############################################################################################################################


#############################################################################################
# 6. Create a Cluster: PortalCluster, AdminTask.addSIBusMember
#############################################################################################

email_notify \
  "Start to Create a Cluster..." \
  "Start to Create a Cluster..." \
  $_EMAILLIST \
  $_START

# Create a Cluster
while read a;
do
  echo "$a" | sed \
    -e "s/WasSoapPort=.*/WasSoapPort=${_WASSOAPPORT}/" \
    -e "s/WasRemoteHostName=.*/WasRemoteHostName=${_DMGRHOSTNAME}.${_DOMAINNAME}/" \
    -e "s/WasUserid=.*/WasUserid=uid=${_WASTEMPUSERNAME},o=defaultWIMFileBasedRealm/" \
    -e "s/WasPassword=.*/WasPassword=${_WASTEMPPASSWORD}/" \
    -e "s/PortalAdminPwd=.*/PortalAdminPwd=${_WASTEMPPASSWORD}/" \
    -e "s/ServerName=.*/ServerName=WebSphere_Portal/" \
    -e "s/PrimaryNode=.*/PrimaryNode=true/" \
    -e "s/ClusterName=.*/ClusterName=PortalCluster/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties  > /tmp/mytmpfile.properties
mv /tmp/mytmpfile.properties ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties

${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh cluster-node-config-post-federation

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh cluster-node-config-post-federation Failed." \
    "ConfigEngine.sh cluster-node-config-post-federation Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh cluster-node-config-cluster-setup

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh cluster-node-config-cluster-setup Failed." \
    "ConfigEngine.sh cluster-node-config-cluster-setup Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

# AdminTask.addSIBusMember: PortalCluster to JCRSeedBus and AdminTask.removeSIBusMember: WebSphere_Portal from JCRSeedBus
${_WSDIR}/IBM/WebSphere/wp_profile/bin/wsadmin.sh -lang jython -conntype SOAP -host ${_DMGRHOSTNAME} -port ${_WASSOAPPORT} \
  -c "AdminTask.addSIBusMember('[-bus JCRSeedBus -cluster PortalCluster -enableAssistance true -policyName HA \
  -dataStore -createDefaultDatasource false -datasourceJndiName jdbc/wpdbDS -authAlias wpdbDSJAASAuth -createTables true -schemaName jcr ]')"

if [[ $? != 0 ]] then
  email_notify \
    "AdminTask.addSIBusMember Failed." \
    "AdminTask.addSIBusMember Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

${_WSDIR}/IBM/WebSphere/wp_profile/bin/wsadmin.sh -lang jython -conntype SOAP -host ${_DMGRHOSTNAME} -port ${_WASSOAPPORT} \
  -c "AdminTask.removeSIBusMember('[-bus JCRSeedBus -server WebSphere_Portal -node ${_HOSTNAME}Node01 ]')"

if [[ $? != 0 ]] then
  email_notify \
    "AdminTask.removeSIBusMember: WebSphere_Portal Failed." \
    "AdminTask.removeSIBusMember: WebSphere_Portal Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "Create a Cluster Completed." \
  "Create a Cluster Completed." \
  $_EMAILLIST \
  $_START

# a420018: restart Dmgr01, NodeAgent, and WebSphere_Portal servers
