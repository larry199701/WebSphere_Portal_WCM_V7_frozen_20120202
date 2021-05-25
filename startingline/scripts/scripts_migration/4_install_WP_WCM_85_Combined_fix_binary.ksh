#!/usr/bin/ksh

cat > /tmp/WP85CFUpdate-Server-binary_fix_install.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<agent-input>
        <server>
                <repository location='/backup/portal/wcmv85/WCM_85/fixes/8.5-WP-WCM-Combined-CFPI50956-Server-CF09/WP8500CF09_Server/repository.config'/>
        </server>
        <install modify='false'>
                <offering id='com.ibm.websphere.PORTAL.SERVER.v85' profile='IBM WebSphere Portal Server V8.5' features='ce.install,portal.binary' installFixes='none'/>
        </install>
        <preference name='com.ibm.cic.common.core.preferences.eclipseCache' value='/optware/IBM85/IMShared'/>
        <!-- Leave everything below here unchanged -->
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
#-------------------------------------------------------------------------------------------------------------
cd /optware/IBM85/WebSphere/AppServer/profiles/cw_profile/bin
./stopServer.sh server1 -username wpsadmqa -password wpsadmin

cd /optware/IIM/InstallationManager/eclipse/tools
./imcl \
    -acceptLicense \
    input /tmp/WP85CFUpdate-Server-binary_fix_install.xml \
    -dataLocation /optware/IIM/var_ibm_InstallationManager_data \
    -showVerboseProgress \
    -log /tmp/WP85CFUpdate-Server-binary_fix_install_log.xml | \
    tee -a /tmp/WP85CFUpdate-Server-binary_fix_install.log

cd /optware/IBM85/WebSphere/AppServer/profiles/cw_profile/bin
./startServer.sh server1


#-------------------------------------------------------------------------------------------------------------
# Verify WAS_ND_85, IBMJDK version
#-------------------------------------------------------------------------------------------------------------
cd /optware/IBM85/WebSphere/AppServer/bin
./versionInfo.sh

cd /optware/IBM85/WebSphere/PortalServer/bin
./WPVersionInfo.sh






: << 'COMMENTEND'
/optware/IBM85/WebSphere/AppServer/profiles/cw_profile/properties/portdef.props
https://pdwpappdev02.advancestores.com:10202/ibm/wizard/Wizard
COMMENTEND
