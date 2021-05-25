#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    Install WAS, WebSphere Portal, WCM V7 and Fixpacks to the Primarynode
#    1.0 Prepare to install: environment checking...
#    1.1 Prepare to Install, create files: 
#	/tmp/WASDefaultPortsFile.props
#	/tmp/WPDefaultPortsFile.props
#	/tmp/installresponsewcm.txt:
#    2. Install WebSphere Binary, WebSphere Portal, WebSphere Content Management V7
#    3. Install JDK/WAS/WCM fixpacks
#    4. Oracle Database Configuration DbName: eppdev, Instance: eppdev1, Host:pdoradevcla-scan
#    5. After installing the primary node and configuring remote database, Create the Primary Portal profile template:
#    6. WCM Federation
#    7. Create a Cluster, webserver
#    8. Add LDAP to Federated Repositories
#    9. wp-change-was-admin-user.ksh
#    10. wp-change-portal-admin-user.ksh
# Author:
#    Larry Sui
# Date:
#    2011-11-11
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
echo "/optware/IBM/WebSphere/PortalServer/log/wpinstalllog.txt"
echo du -gs ${_WSDIR}/IBM   3.81 GB
echo The installation takes about 1 hour 15 minutes
echo topas

_START=`date +%s`

###############################################################################################################################
#    1. Prepare to Install WAS/WP/WCM: create /tmp/WASDefaultPortsFile.props, /tmp/WPDefaultPortsFile.props, /tmp/installresponsewcm.txt files:
###############################################################################################################################

echo "BOOTSTRAP_ADDRESS=10150\n\
SOAP_CONNECTOR_ADDRESS=10151\n\
ORB_LISTENER_ADDRESS=10156\n\
SAS_SSL_SERVERAUTH_LISTENER_ADDRESS=10153\n\
CSIV2_SSL_SERVERAUTH_LISTENER_ADDRESS=10154\n\
CSIV2_SSL_MUTUALAUTH_LISTENER_ADDRESS=10155\n\
WC_adminhost=10130\n\
WC_defaulthost=10129\n\
DCS_UNICAST_ADDRESS=10157\n\
WC_adminhost_secure=10132\n\
WC_defaulthost_secure=10131\n\
SIP_DEFAULTHOST=10162\n\
SIP_DEFAULTHOST_SECURE=10163\n\
SIB_ENDPOINT_ADDRESS=10158\n\
SIB_ENDPOINT_SECURE_ADDRESS=10159\n\
SIB_MQ_ENDPOINT_ADDRESS=10160\n\
SIB_MQ_ENDPOINT_SECURE_ADDRESS=10161\n\
IPC_CONNECTOR_ADDRESS=10152" > /tmp/WASDefaultPortsFile.props

echo "BOOTSTRAP_ADDRESS=10035\n\
SOAP_CONNECTOR_ADDRESS=10025\n\
ORB_LISTENER_ADDRESS=10034\n\
SAS_SSL_SERVERAUTH_LISTENER_ADDRESS=10041\n\
CSIV2_SSL_SERVERAUTH_LISTENER_ADDRESS=10036\n\
CSIV2_SSL_MUTUALAUTH_LISTENER_ADDRESS=10033\n\
WC_adminhost=10042\n\
WC_defaulthost=10039\n\
DCS_UNICAST_ADDRESS=10030\n\
WC_adminhost_secure=10032\n\
WC_defaulthost_secure=10029\n\
SIP_DEFAULTHOST=10027\n\
SIP_DEFAULTHOST_SECURE=10026\n\
IPC_CONNECTOR_ADDRESS=10037\n\
SIB_ENDPOINT_ADDRESS=10028\n\
SIB_ENDPOINT_SECURE_ADDRESS=10038\n\
SIB_MQ_ENDPOINT_ADDRESS=10040\n\
SIB_MQ_ENDPOINT_SECURE_ADDRESS=10031" > /tmp/WPDefaultPortsFile.props

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
-W adminPortBlockInput.portsFilePath=\"/tmp/WASDefaultPortsFile.props\"\n\
-W portalPortBlockInput.portsFilePath=\"/tmp/WPDefaultPortsFile.props\"" > /tmp/installresponsewcm.txt


#############################################################################################
# 2. Install WAS, WebSphere Portal, WebSphere Content Management V7
#############################################################################################

email_notify \
  "Start Installing Portal, WCM V7......" \
  "Start Installing Portal, WCM V7......" \
  $_EMAILLIST \
  $_START

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
rm -f ${_INTENDEDDIR}/WASDefaultPortsFile.props
rm -f ${_INTENDEDDIR}/WPDefaultPortsFile.props

email_notify \
  "WAS/WP/WCM Install Completed." \
  "WAS/WP/WCM Install Completed." \
  $_EMAILLIST \
  $_START
 

#############################################################################################
# 3. Install JDK/WAS/WCM fixpacks
#############################################################################################

. ${_CURDIR}/installwcm/ksh/inst_jdkwaswcm_fixpacksfix_primary.ksh

###############################################################################################
# 4. o	Configuring WebSphere Portal to use Oracle database ...  DbName: eppqa1, Instance: eppdev11, Host: pdoraqacla01
###############################################################################################

. ${_CURDIR}/installwcm/ksh/oracle_database_transfer.ksh 
#. ${_CURDIR}/installwcm/ksh/oracle_database_transfer.ksh pdoraqacla01 eppqa1 eppqa11

###########################################################################
# 5. After installing the primary node and configuring remote database, Create the Primary Portal profile template:
###########################################################################

. ${_CURDIR}/installwcm/ksh/createPortalProfileTemplate.ksh
cp ${_WSDIR}/IBM/WebSphere/PortalServer/profileTemplates/profileTemplates.zip ${_CURDIR}/installwcm/lib/profileTemplates/profileTemplates_prd01.zip

#############################################################################################
# Install IBM Support Assistant Lite for WebSphere Portal (ISALite)
#############################################################################################

. ${_CURDIR}/installwcm/ksh/inst_ISALite.ksh

#############################################################################################
# 6.  WCM Federation
#############################################################################################

. ${_CURDIR}/installwcm/ksh/federation_primarynode.ksh

#############################################################################################
# 7. Create a Cluster, webserver
#############################################################################################

. ${_CURDIR}/installwcm/ksh/createcluster.ksh
. ${_CURDIR}/installwcm/ksh/createwebserver.ksh ${_WEBHOSTNAME1}
. ${_CURDIR}/installwcm/ksh/createwebserver.ksh ${_WEBHOSTNAME2}
#. ${_CURDIR}/installwcm/ksh/autoSyncDisable.ksh
. ${_CURDIR}/installwcm/ksh/restartDmgrNodesServers.ksh ${_INTENDEDHOSTNAME}

###############################################################################################
# 8. Add LDAP to Federated Repositories
###############################################################################################

. ${_CURDIR}/installwcm/ksh/wp-create-ldap_corp.ksh
. ${_CURDIR}/installwcm/ksh/wp-create-ldap_retail.ksh
# it is strongly recommended you remove the file user registry in production
#. ${_CURDIR}/installwcm/ksh/wp-delete-repository.ksh
. ${_CURDIR}/installwcm/ksh/restartDmgrNodesServers.ksh ${_INTENDEDHOSTNAME}
. ${_CURDIR}/installwcm/ksh/wp-validate-federated-ldap-attribute-config.ksh


###############################################################################################
# 9. wp-change-was-admin-user.ksh
###############################################################################################

. ${_CURDIR}/installwcm/ksh/wp-change-was-admin-user.ksh

## restart the Deployment Manager only
echo restart the Deployment Manager only ...

${_WSDIR}/IBM/WebSphere/wp_profile/bin/wsadmin.sh -lang jython -conntype SOAP -host ${_DMGRHOSTNAME} -port ${_WASSOAPPORT} \
  -c "AdminControl.invoke(AdminControl.queryNames ('WebSphere:type=Server,cell=${_DMGRHOSTNAME}Cell01,name=dmgr,*'), 'restart')"

#echo wait for 3 minutes to connect to the Deployment Manager...
sleep 180

## after restart the dmgr, the login user / password changed to ldap

while read a;
do
  echo "$a" | sed \
    -e "s/com.ibm.SOAP.loginUserid=.*/com.ibm.SOAP.loginUserid=${_ADMINLDAPUSERNAME}/" \
    -e "s/com.ibm.SOAP.loginPassword=.*/com.ibm.SOAP.loginPassword=${_ADMINLDAPPASSWORD}/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/properties/soap.client.props  > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/properties/soap.client.props

kill -9 `ps -ef | grep "${_HOSTNAME}Node01 nodeagent" | awk '{print $2}'`
${_WSDIR}/IBM/WebSphere/wp_profile/bin/syncNode.sh ${_DMGRHOSTNAME}
${_WSDIR}/IBM/WebSphere/wp_profile/bin/startNode.sh

kill -9 `ps -ef | grep "${_HOSTNAME}Node01 WebSphere_Portal" | awk '{print $2}'`
${_WSDIR}/IBM/WebSphere/wp_profile/bin/startServer.sh WebSphere_Portal

kill -9 `ps -ef | grep "${_HOSTNAME}Node01 server1" | awk '{print $2}'`
${_WSDIR}/IBM/WebSphere/wp_profile/bin/startServer.sh server1

###############################################################################################
# 10. wp-change-portal-admin-user.ksh
###############################################################################################

. ${_CURDIR}/installwcm/ksh/wp-change-portal-admin-user.ksh
. ${_CURDIR}/installwcm/ksh/restartDmgrNodesServers.ksh ${_INTENDEDHOSTNAME}

###############################################################################################
# 11. Change to non-root user
# /optware/IBM/WebSphere/wp_profile/bin/stopServer.sh WebSphere_Portal
# /optware/IBM/WebSphere/wp_profile/bin/stopNode.sh
# cp -R /optware/IBM /optware/IBM_Backup_root
# chown -R wasadm:wsadm /optware/IBM
# chown -Rh wasadm:wsadm /optware/IBM
# find /optware/IBM/ -user root
# su - wasadm -c "/optware/IBM/WebSphere/wp_profile/bin/startNode.sh"
# su - wasadm -c "/optware/IBM/WebSphere/wp_profile/bin/startServer.sh WebSphere_Portal"
# su - wasadm -c "/optware/IBM/WebSphere/AppServer/profiles/Dmgr01/bin/startManager.sh"
###############################################################################################
