#!/usr/bin/ksh

#-------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------
# Installation Manager fix Installation
#     Larry Sui
#     November 2015
#-------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------
# Install InstallationManager fix
#-------------------------------------------------------------------------------------------------------------
export PATH=$PATH:/backup/portal/wcmv85/WCM_85/fixes/agent.installer.aix.gtk.ppc_1.8.3000.20150606_0047/jre_7.0.9000.20150514_1022/jre/bin
#cd /backup/portal/wcmv85/WCM_85/fixes/agent.installer.aix.gtk.ppc_1.8.3000.20150606_0047
cd /backup/portal/wcmv85/WCM_85/fixes/agent.installer.aix.gtk.ppc_1.8.5000.20160506_1125
./userinstc \
    -dataLocation /optware/IIM/var_ibm_InstallationManager_data \
    -installationDirectory /optware/IIM/InstallationManager/eclipse \
    -acceptLicense 

#-------------------------------------------------------------------------------------------------------------
# Verify InstallationManager version
#-------------------------------------------------------------------------------------------------------------
cd /optware/IIM/InstallationManager/eclipse/tools
./imcl -version

