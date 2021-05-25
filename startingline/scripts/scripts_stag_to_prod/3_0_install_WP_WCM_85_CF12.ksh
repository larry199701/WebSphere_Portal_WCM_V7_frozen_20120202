#!/usr/bin/ksh

#---------------------------------------------------------------------------------------------------------------------------------------------------------
# Installation Instruction
# http://www-10.lotus.com/ldd/portalwiki.nsf/xpDocViewer.xsp?lookupName=Combined+Cumulative+Fix+Readme+V8.5.0.0#action=openDocument&res_title=IBM_WebSphere_Portal_V8.5.0.0_combined_cumulative_fix_instructions_cluster_cf8500&content=pdcontent
# 
# Two steps: 
#	1. Upgrade CF12 to the product file.  
#	2. To apply the changes to each profile
#---------------------------------------------------------------------------------------------------------------------------------------------------------


#stopdm;stopwp;stopnode


#./imcl listInstalledPackages
#./imcl listAvailablePackages -repositories /backups/portal/wcmv85/download/fix/8.5-WP-WCM-Combined-CFPI64037-Server-CF12/WP8500CF12_Server/

cd /optware/IBM85/WebSphere/AppServer/profiles/cw_profile/bin
./stopServer.sh server1 -username wpsadmin -password wpsadmin

cd /optware/IBM85/WebSphere/wp_profile/bin
./stopServer.sh WebSphere_Portal -username wpsadmin -password wpsadmin


cd /optware/IIM/InstallationManager/eclipse/tools/

# 1. Upgrade CF12 to the product file:
./imcl install com.ibm.websphere.PORTAL.SERVER.v85_8.5.0.20160901_2151 \
    -repositories /backup/portal/wcmv85/WCM_85/fixes/8.5-WP-WCM-Combined-CFPI64037-Server-CF12/WP8500CF12_Server \
    -installationDirectory /optware/IBM85/WebSphere/PortalServer \
    -dL /optware/IIM/var_ibm_InstallationManager_data -sP \
    -acceptLicense

# 2. To apply the changes to each profile
cd /optware/IBM85/WebSphere/wp_profile/PortalServer/bin
./applyCF.sh \
	-DPortalAdminPwd=wpsadmin \
	-DWasPassword=RLu7FF9d

: << 'COMMENTEND'
COMMENTEND






