#!/usr/bin/ksh

#-------------------------------------------------------------------------------------------------------------
# WP_WCM_WASND85_IBMJAVA7 and fixes Uninstall
#     Larry Sui
#     November 2015
#-------------------------------------------------------------------------------------------------------------

cat > /tmp/WP_WCM_WASND85_IBMJAVA7_profile_uninstall.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<agent-input>
    <uninstall modify='false'>
<!--        <offering id='com.ibm.websphere.PORTAL.SERVER.v85' profile='IBM WebSphere Portal Server V8.5' features='ce.install,portal.binary,portal.profile'/>
        <offering id='com.ibm.websphere.PORTAL.WCM.v85' profile='IBM WebSphere Portal Server V8.5' features='enable.upsell'/> -->
        <offering id='8.5.5.0-WS-WASProd-IFPI15756' profile='IBM WebSphere Application Server V8.5' features='-'/>
        <offering id='8.5.5.2-WS-WAS-IFPI15581' profile='IBM WebSphere Application Server V8.5' features='-'/>
        <offering id='com.ibm.websphere.ND.v85' profile='IBM WebSphere Application Server V8.5' features='core.feature,ejbdeploy,thinclient,embeddablecontainer,com.ibm.sdk.6_64bit'/>
        <offering id='com.ibm.websphere.IBMJAVA.v70' profile='IBM WebSphere Application Server V8.5' features='com.ibm.sdk.7'/>
    </uninstall>
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

cd /optware/IBM_85prf/WebSphere/AppServer/profiles/cw_profile/bin
./stopServer.sh server1 -username wpsadmin -password wpsadmin

cd /optware/IBM_85prf/WebSphere/wp_profile/bin
./stopServer.sh WebSphere_Portal -username wpsadmin -password wpsadmin

cd /optware/IIM/InstallationManager/eclipse/tools
./imcl \
    input /tmp/WP_WCM_WASND85_IBMJAVA7_profile_uninstall.xml \
    -dataLocation /optware/IIM/var_ibm_InstallationManager_data \
    -showVerboseProgress \
    -log /tmp/WP_WCM_WASND85_IBMJAVA7_profile_uninstall.xml | \
    tee -a /tmp/WP_WCM_WASND85_IBMJAVA7_profile_uninstall.log



cd /optware/IIM/InstallationManager/eclipse/tools
./imcl listInstalledPackages \
    -dataLocation  /optware/IIM/var_ibm_InstallationManager_data







: << 'COMMENTEND'
#/backup/portal/wcmv85/WCM_85/SETUP/sample-responsefiles/aix/was85-server-uninstall_larry.xml \
cd /optware/IBM_85/WebSphere/UpdateInstaller/uninstall
./uninstall \
    -silent \
    -is:javaconsole
COMMENTEND

