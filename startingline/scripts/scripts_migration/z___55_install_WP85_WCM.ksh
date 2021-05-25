#!/usr/bin/ksh

#-------------------------------------------------------------------------------------------------------------
# Install WAS ND, WP, WCM 85
#-------------------------------------------------------------------------------------------------------------

#/backup/portal/wcmv85/WCM_85/SETUP/sample-responsefiles/aix/was85-server-install_larry.xml
cat > /tmp/WP85_WCM_install.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<agent-input>
    <!-- Listing of repositories -->
    <server>
        <repository location='/backup/portal/wcmv85/WCM_85/WP85_WCM/repository.config'/>
        <repository location='/backup/portal/wcmv85/WCM_85/WP85_Server/repository.config'/>
    </server>
    <!-- Listing of products and fixes to be installed -->
    <install modify='false'>
        <offering id='com.ibm.websphere.PORTAL.SERVER.v85' profile='IBM WebSphere Portal Server V8.5' features='ce.install,portal.binary,portal.profile' installFixes='none'/>
        <offering id='com.ibm.websphere.PORTAL.WCM.v85' profile='IBM WebSphere Portal Server V8.5' features='enable.upsell' installFixes='none'/>
    </install>
    <!-- Change all Application Server install paths to your desired value.            -->
    <profile id='IBM WebSphere Application Server V8.5' installLocation='/optware/IBM_85/WebSphere/AppServer'>
        <data key='eclipseLocation' value='/optware/IBM_85/WebSphere/AppServer'/>
        <data key='user.import.profile' value='false'/>
        <data key='cic.selector.nl' value='en, fr, it, zh, ro, ru, zh_TW, de, ja, pl, es, cs, hu, ko, pt_BR'/>
    </profile>
    <!-- Choose a directory to cache Installation Manager artifacts                     -->
    <preference name='com.ibm.cic.common.core.preferences.eclipseCache' value='/optware/IBM_85/IMShared'/>
    <!-- Leave everything below here unchanged -->
    <preference name='com.ibm.cic.common.core.preferences.connectTimeout' value='30'/>
    <preference name='com.ibm.cic.common.core.preferences.readTimeout' value='45'/>
    <preference name='com.ibm.cic.common.core.preferences.downloadAutoRetryCount' value='0'/>
    <preference name='offering.service.repositories.areUsed' value='false'/>
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
# Install WAS_ND_8.5 no profile, IBMJAVA_v70
#-------------------------------------------------------------------------------------------------------------
cd /optware/IBM_85/InstallationManager/eclipse/tools
./imcl \
    -acceptLicense \
    input /tmp/WP85_WCM_install.xml \
    -dataLocation  /optware/IBM_85/tmp/InstallationManager_logs \
    -log /tmp/WP85_WCM_silent_install_log.xml

cd /optware/IBM_85/WebSphere/AppServer/bin
./versionInfo.sh



: << 'COMMENTEND'
    input /backup/portal/wcmv85/WCM_85/SETUP/sample-responsefiles/aix/was85-server-install_larry.xml \
COMMENTEND
