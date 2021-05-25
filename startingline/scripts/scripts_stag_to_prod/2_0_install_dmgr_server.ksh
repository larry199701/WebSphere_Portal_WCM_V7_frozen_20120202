#!/usr/bin/ksh

#-------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------
# Install Deployment Manager 8.5
#     Larry Sui 
#     February 2017 
#-------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------
# Install Deployment Manager 8.5 Binary
#-------------------------------------------------------------------------------------------------------------

: << 'COMMENTEND'
cd /optware/IIM/InstallationManager/eclipse/tools
./imcl install com.ibm.websphere.ND.v85 \
	-repositories /backup/portal/wcmv85/WCM_85/SETUP \
	-installationDirectory /optware/IBM85/WebSphere/AppServer \
	-sharedResourcesDirectory /optware/IIM/InstallationManager/IMShared \
	-acceptLicense \
	-showProgress \
	-log /tmp/install_dmgr_v85.xml

cd /optware/IIM/InstallationManager/eclipse/tools
./imcl install com.ibm.websphere.IBMJAVA.v70 \
        -repositories /backup/portal/wcmv85/WCM_85/SETUP \
        -installationDirectory /optware/IBM85/WebSphere/AppServer \
        -sharedResourcesDirectory /optware/IIM/InstallationManager/IMShared \
        -acceptLicense \
        -showProgress \
        -log /tmp/install_dmgr_v85.xml





cat > /tmp/portdef_Dmgr01.props <<EOF
IPC_CONNECTOR_ADDRESS=9634
DataPowerMgr_inbound_secure=5557
DCS_UNICAST_ADDRESS=9354
BOOTSTRAP_ADDRESS=9811
SOAP_CONNECTOR_ADDRESS=8881
CELL_DISCOVERY_ADDRESS=7279
ORB_LISTENER_ADDRESS=9102
CSIV2_SSL_SERVERAUTH_LISTENER_ADDRESS=9407
SAS_SSL_SERVERAUTH_LISTENER_ADDRESS=9408
CSIV2_SSL_MUTUALAUTH_LISTENER_ADDRESS=9409
WC_adminhost=9062
WC_adminhost_secure=9045
EOF

COMMENTEND

cat > /tmp/portdef_Dmgr02.props <<EOF
IPC_CONNECTOR_ADDRESS=9635
DataPowerMgr_inbound_secure=5558
DCS_UNICAST_ADDRESS=9355
BOOTSTRAP_ADDRESS=9812
SOAP_CONNECTOR_ADDRESS=8882
CELL_DISCOVERY_ADDRESS=7280
ORB_LISTENER_ADDRESS=9103
CSIV2_SSL_SERVERAUTH_LISTENER_ADDRESS=9410
SAS_SSL_SERVERAUTH_LISTENER_ADDRESS=9411
CSIV2_SSL_MUTUALAUTH_LISTENER_ADDRESS=9412
WC_adminhost=9063
WC_adminhost_secure=9046
EOF

: << 'COMMENTEND'

cd /optware/IBM85/WebSphere/AppServer/bin/
./manageprofiles.sh \
    -create \
    -profileName Dmgr01 \
    -profilePath /optware/IBM85/WebSphere/AppServer/profiles/Dmgr01 \
    -templatePath /optware/IBM85/WebSphere/AppServer/profileTemplates/management \
    -cellName pdwpndprd01Cell01 \
    -hostName pdwpndprd01.advancestores.com \
    -nodeName pdwpndprd01Dmgr01 \
    -isDefault \
    -portsFile /tmp/portdef_Dmgr01.props \
    -enableAdminSecurity true \
    -adminUserName wasadmin \
    -adminPassword wasadmin

COMMENTEND

cd /optware/IBM85/WebSphere/AppServer/bin/
./manageprofiles.sh \
    -create \
    -profileName Dmgr02 \
    -profilePath /optware/IBM85/WebSphere/AppServer/profiles/Dmgr02 \
    -templatePath /optware/IBM85/WebSphere/AppServer/profileTemplates/management \
    -cellName pdwpndprd01Cell01 \
    -hostName pdwpndprd01.advancestores.com \
    -nodeName pdwpndprd01Dmgr02 \
    -isDefault \
    -portsFile /tmp/portdef_Dmgr02.props \
    -enableAdminSecurity true \
    -adminUserName wasadmin \
    -adminPassword wasadmin





#-------------------------------------------------------------------------------------------------------------
# Verify InstallationManager version
#-------------------------------------------------------------------------------------------------------------
#cd /optware/IIM/InstallationManager/eclipse/tools
#./imcl -version

