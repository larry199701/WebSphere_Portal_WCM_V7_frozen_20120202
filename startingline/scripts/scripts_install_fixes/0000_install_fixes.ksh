#!/usr/bin/ksh

#---------------------------------------------------------------------------------------------------------------------------------------------------------
# Installation Instruction
#
# Two steps:
#       1. Upgrade CF12 to the product file.
#       2. To apply the changes to each profile
#---------------------------------------------------------------------------------------------------------------------------------------------------------


# Installation
cd /optware/IIM/InstallationManager/eclipse/tools


: << 'COMMENTEND'
# Reviewing Packages
./imcl listInstalledPackages

./imcl listAvailablePackages \
    -repositories /backups/portal/wcmv85/download/fix/20170922/com.ibm.cic.agent.offering_1.8.7000.20170706_2137 \
    -showPlatforms -features -long

./imcl listAvailablePackages \
    -repositories /backups/portal/wcmv85/download/fix/20170922/8.0.4.5-WS-IBMWASJAVA-AIX \
    -showPlatforms -features -long

./imcl listAvailablePackages \
    -repositories /backups/portal/wcmv85/download/fix/20170922/8.5.5-WS-WAS-FP012 \
    -showPlatforms -features -long

./imcl listAvailablePackages \
    -repositories /backups/portal/wcmv85/download/fix/20170922/8.5-9.0-WP-WCM-Combined-CFPI73835-Server-CF14/WP8500CF14_Server \
    -showPlatforms -features -long

./imcl listAvailablePackages \
    -repositories /backup/portal/wcmv85/download/fixes_tools/fixes_20170921/8.5.5-WS-WASSupplements-FP012 \
    -showPlatforms -features -long


# Install Packages
./imcl install com.ibm.cic.agent \
    -repositories /backup/portal/wcmv85/download/fixes_tools/fixes_20170921/com.ibm.cic.agent.offering_1.8.7000.20170706_2137 \
    -preferences offering.service.repositories.areUsed=false

./imcl install com.ibm.websphere.ND.v85 \
    -repositories /backup/portal/wcmv85/download/fixes_tools/fixes_20170921/8.5.5-WS-WAS-FP012 \
    -installationDirectory /optware/IBM85/WebSphere/AppServer \
    -acceptLicense \
    -log /tmp/8.5.5-WS-WAS-FP012_install.xml

./imcl install com.ibm.websphere.IBMJAVA.v80 \
    -repositories /backup/portal/wcmv85/download/fixes_tools/fixes_20170921/8.0.4.5-WS-IBMWASJAVA-AIX \
    -installationDirectory /optware/IBM85/WebSphere/AppServer \
    -dL /optware/IIM/var_ibm_InstallationManager_data -sVP \
    -acceptLicense \
    -log /tmp/Java_8.0.5.0_install.xml

./imcl install com.ibm.websphere.IHS.v85 \
    -repositories /backup/portal/wcmv85/download/fixes_tools/fixes_20170921/8.5.5-WS-WASSupplements-FP012 \
    -installationDirectory /optware/IBM/HTTPServer \
    -dL /optware/IIM/var_ibm_InstallationManager_data -sVP \
    -acceptLicense \
    -log /tmp/8.5.5-IHS_install.xml

COMMENTEND

./imcl install com.ibm.websphere.PLG.v85 \
    -repositories /backup/portal/wcmv85/download/fixes_tools/fixes_20170921/8.5.5-WS-WASSupplements-FP012 \
    -installationDirectory /optware/IBM/WebSphere/Plugins \
    -dL /optware/IIM/var_ibm_InstallationManager_data -sVP \
    -acceptLicense \
    -log /tmp/8.5.5-PLG_install.xml

: << 'COMMENTEND'
COMMENTEND
