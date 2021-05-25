#!/usr/bin/ksh

cat > /tmp/WAS8552_IBMJAVA7_fix_install.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<agent-input>
    <server>
        <repository location='/backup/portal/wcmv85/WCM_85/fixes/8.5.5-WS-WAS-FP0000007/repository.config'/>
        <repository location='/backup/portal/wcmv85/WCM_85/fixes/7.0.9.10-WS-IBMWASJAVA/repository.config'/>
    </server>
    <install modify='false'>
        <offering id='com.ibm.websphere.IBMJAVA.v70' profile='IBM WebSphere Application Server V8.5'  version='7.0.9010.20150820_1342' features='com.ibm.sdk.7'/>
        <offering id='com.ibm.websphere.ND.v85' profile='IBM WebSphere Application Server V8.5'  version='8.5.5007.20150820_2101' features='-'/>
    </install>
    <profile id='IBM WebSphere Application Server V8.5' installLocation='/optware/IBM_85prf/WebSphere/AppServer'>
        <data key='eclipseLocation' value='/optware/IBM_85prf/WebSphere/AppServer'/>
        <data key='user.import.profile' value='false'/>
        <data key='cic.selector.nl' value='en, fr, it, zh, ro, ru, zh_TW, de, ja, pl, es, cs, hu, ko, pt_BR'/>
    </profile>
    <preference name='com.ibm.cic.common.core.preferences.eclipseCache' value='/optware/IBM_85prf/IMShared'/>
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
# Install WAS_ND_85 fix 
# after stop the process
#-------------------------------------------------------------------------------------------------------------

cd /optware/IBM_85prf/WebSphere/wp_profile/bin/
./stopServer.sh WebSphere_Portal -username wpsadmin -password wpsadmin

cd /optware/IBM_85prf/WebSphere/AppServer/profiles/cw_profile/bin
./stopServer.sh server1 -username wpsadmin -password wpsadmin


cd /optware/IIM/InstallationManager/eclipse/tools
./imcl \
    -acceptLicense \
    input /tmp/WAS8552_IBMJAVA7_fix_install.xml \
    -dataLocation /optware/IIM/var_ibm_InstallationManager_data \
    -showVerboseProgress \
    -log /tmp/was_IBMJDK_fix_update_log.xml | \
    tee -a /tmp/WAS8552_IBMJAVA7_fix_install.log




#-------------------------------------------------------------------------------------------------------------
# Verify WAS_ND_85, IBMJDK version
#-------------------------------------------------------------------------------------------------------------
cd /optware/IBM_85prf/WebSphere/AppServer/bin
./versionInfo.sh






: << 'COMMENTEND'
/backup/portal/wcmv85/WCM_85/SETUP/sample-responsefiles/aix/was85-server-fix_install_larry.xml \
cd /backup/portal/wcmv85/WCM_85/7.0.0.39-WS-UPDI-AixPPC64/UpdateInstaller
./install \
    -options /backup/portal/wcmv85/WCM_85/fixes/7.0.0.39-WS-UPDI-AixPPC64/UpdateInstaller/responsefile.updiinstaller_larry.txt \
    -silent \
    -is:javaconsole
COMMENTEND
