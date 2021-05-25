#!/usr/bin/ksh

#-------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------
# Installation Manager and fix Installation
#     Larry Sui
#     November 2015
#-------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------

# Modify file: /backup/portal/wcmv85/WCM_85/SETUP/IIM/aix/install.xml
: << 'COMMENTEND'

COMMENTEND

#-------------------------------------------------------------------------------------------------------------
# Install InstallationManager
# "/home/wasadm/etc/.ibm/registry/InstallationManager.dat"
#-------------------------------------------------------------------------------------------------------------
cd /backup/portal/wcmv85/WCM_85/SETUP/IIM/aix
./userinstc \
    -dataLocation /optware/IIM/var_ibm_InstallationManager_data \
    -log /tmp/InstallationManager_1_7_installation.log \
    -acceptLicense

#-------------------------------------------------------------------------------------------------------------
# Verify InstallationManager version
#-------------------------------------------------------------------------------------------------------------
cd /optware/IIM/InstallationManager/eclipse/tools
./imcl -version

