#!/usr/bin/ksh

#stopdm;stopwp;stopnode

: << 'COMMENTEND'

# if need to use new IIM, upgrade the current IIM, do not use the new IIM directly
#cd /backup/portal/wcmv85/WCM_85/fixes/agent.installer.aix.gtk.ppc_1.8.3000.20150606_0047
#cd /backup/portal/wcmv85/WCM_85/fixes/agent.installer.aix.gtk.ppc_1.8.5000.20160506_1125
./userinstc \
    -installationDirectory /optware/IIM/InstallationManager \
    -dataLocation /optware/IIM/var_ibm_InstallationManager_data \
    -log log_file -acceptLicense

Updated to com.ibm.cic.agent_1.8.5000.20160506_1125 in the /optware/IIM/InstallationManager/eclipse directory.

COMMENTEND

cd /optware/IIM/InstallationManager/eclipse/tools/

#./imcl listInstalledPackages
./imcl listAvailablePackages -repositories /backup/portal/wcmv85/WCM_85/fixes/8.5-WP-WCM-Combined-CFPI64037-Server-CF12/WP8500CF12_Server

: << 'COMMENTEND'
#Upgrade CF12:
./imcl install com.ibm.websphere.PORTAL.SERVER.v85_8.5.0.20160901_2151 \
    -repositories /backup/portal/wcmv85/WCM_85/fixes/8.5-WP-WCM-Combined-CFPI64037-Server-CF12/WP8500CF12_Server \
    -installationDirectory /optware/IBM85/WebSphere/PortalServer \
    -dL /optware/IIM/var_ibm_InstallationManager_data -sP \
    -acceptLicense

cd /optware/IBM85/WebSphere/AppServer/bin/
./versionInfo.sh

cd /optware/IBM85/WebSphere/PortalServer/bin/
./WPVersionInfo.sh
















cat > /tmp/WP85CFUpdate-Server-profile_fix_install.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<agent-input>
        <server>
                <repository location='/backup/portal/wcmv85/WCM_85/fixes/8.5-WP-WCM-Combined-CFPI50956-Server-CF09/WP8500CF09_Server/repository.config'/>
        </server>
        <install modify='false'>
                <offering id='com.ibm.websphere.PORTAL.SERVER.v85' profile='IBM WebSphere Portal Server V8.5' features='ce.install,portal.binary,portal.profile' installFixes='none'/>
        </install>
        <preference name='com.ibm.cic.common.core.preferences.eclipseCache' value='/optware/IBM_85prf/IMShared'/>
        <preference name='com.ibm.cic.common.core.preferences.connectTimeout' value='30'/>
        <preference name='com.ibm.cic.common.core.preferences.readTimeout' value='45'/>
        <preference name='com.ibm.cic.common.core.preferences.downloadAutoRetryCount' value='0'/>
        <preference name='offering.service.repositories.areUsed' value='true'/>
        <preference name='com.ibm.cic.common.core.preferences.ssl.nonsecureMode' value='false'/>
        <preference name='com.ibm.cic.common.core.preferences.http.disablePreemptiveAuthentication' value='false'/>
        <preference name='http.ntlm.auth.kind' value='NTLM'/>
        <preference name='http.ntlm.auth.enableIntegrated.win32' value='true'/>
        <preference name='com.ibm.cic.common.core.preferences.preserveDownloadedArtifacts' value='true'/>
        <preference name='com.ibm.cic.common.core.preferences.keepFetchedFiles' value='false'/>
        <preference name='PassportAdvantageIsEnabled' value='false'/>
        <preference name='com.ibm.cic.common.core.preferences.searchForUpdates' value='false'/>
        <preference name='com.ibm.cic.agent.ui.displayInternalVersion' value='false'/>
        <preference name='com.ibm.cic.common.sharedUI.showErrorLog' value='true'/>
        <preference name='com.ibm.cic.common.sharedUI.showWarningLog' value='true'/>
        <preference name='com.ibm.cic.common.sharedUI.showNoteLog' value='true'/>
</agent-input>
EOF

#-------------------------------------------------------------------------------------------------------------
# Install WP85CF fix 
# after stop the process
# 1. <wp_profile root>/ConfigEngine/properties/wkplc.propertie
# 2. <wp_profile root>/ConfigEngine/properties/wkplc_dbdomain.properties
# 3. <wp_profile root>/ConfigEngine/properties/wkplc_comp.properties
# 4. "ulimit - n" setting of at least 18192
# 5. non-root user owns the AppServer, PortalServer, ConfigEngine, and Portal profile directories, 755
# 6. /optware/IBM_85prf/WebSphere/wp_profile/PortalServer/bin/applyCF.sh -DPortalAdminPwd=wpsadmin -DWasPassword=wpsadmin
#-------------------------------------------------------------------------------------------------------------

cd /optware/IBM_85prf/WebSphere/wp_profile/bin/
./stopServer.sh WebSphere_Portal -username wpsadmin -password wpsadmin

cd /optware/IBM_85prf/WebSphere/AppServer/profiles/cw_profile/bin
./stopServer.sh server1 -username wpsadmin -password wpsadmin

cd /optware/IIM/InstallationManager/eclipse/tools
./imcl \
    -acceptLicense \
    input /tmp/WP85CFUpdate-Server-profile_fix_install.xml \
    -dataLocation /optware/IIM/var_ibm_InstallationManager_data \
    -showVerboseProgress \
    -log /tmp/WP85CFUpdate-Server-profile_fix_install_log.xml | \
    tee -a /tmp/WP85CFUpdate-Server-profile_fix_install.log



#-------------------------------------------------------------------------------------------------------------
# Verify WAS_ND_85, IBMJDK version
#-------------------------------------------------------------------------------------------------------------
cd /optware/IBM_85prf/WebSphere/AppServer/bin
./versionInfo.sh

cd /optware/IBM_85prf/WebSphere/PortalServer/bin
./WPVersionInfo.sh






/backup/portal/wcmv85/WCM_85/SETUP/sample-responsefiles/aix/was85-server-fix_install_larry.xml \
cd /backup/portal/wcmv85/WCM_85/7.0.0.39-WS-UPDI-AixPPC64/UpdateInstaller
./install \
    -options /backup/portal/wcmv85/WCM_85/fixes/7.0.0.39-WS-UPDI-AixPPC64/UpdateInstaller/responsefile.updiinstaller_larry.txt \
    -silent \
    -is:javaconsole
COMMENTEND
