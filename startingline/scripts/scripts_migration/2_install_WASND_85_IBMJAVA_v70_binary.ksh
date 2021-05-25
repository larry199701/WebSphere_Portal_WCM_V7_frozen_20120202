#!/usr/bin/ksh

#-------------------------------------------------------------------------------------------------------------
# Install WAS ND, WP, WCM 85 binary without profile
#-------------------------------------------------------------------------------------------------------------
cat > /tmp/WASND_85_IBMJAVA_v70_WP85_WCM_binary_install.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!-- Response file for WebSphere Portal Server and WCM 85 on AIX binary only -->
<agent-input>
    <server>
        <repository location='/backup/portal/wcmv85/WCM_85/IBMJAVA7/repository.config'/>
        <repository location='/backup/portal/wcmv85/WCM_85/WAS8552/repository.config'/>
    </server>
        <install modify='false'>
        <offering id='8.5.5.0-WS-WASProd-IFPI15756' profile='IBM WebSphere Application Server V8.5' features='-'/>
        <offering id='8.5.5.2-WS-WAS-IFPI15581' profile='IBM WebSphere Application Server V8.5' features='-'/>
        <offering id='com.ibm.websphere.ND.v85' profile='IBM WebSphere Application Server V8.5' features='core.feature,ejbdeploy,thinclient,embeddablecontainer,com.ibm.sdk.6_64bit' installFixes='none'/>
        <offering id='com.ibm.websphere.IBMJAVA.v70' profile='IBM WebSphere Application Server V8.5' features='com.ibm.sdk.7' installFixes='none'/>
        </install>
    <profile id='IBM WebSphere Application Server V8.5' installLocation='/optware/IBM85/WebSphere/AppServer'>
        <data key='eclipseLocation' value='/optware/IBM85/WebSphere/AppServer'/>
        <data key='user.import.profile' value='false'/>
        <data key='cic.selector.nl' value='en, fr, it, zh, ro, ru, zh_TW, de, ja, pl, es, cs, hu, ko, pt_BR'/>
    </profile>
    <preference name='com.ibm.cic.common.core.preferences.eclipseCache' value='/optware/IBM85/IMShared'/>
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

cd /optware/IIM/InstallationManager/eclipse/tools
./imcl \
    -acceptLicense \
    input /tmp/WASND_85_IBMJAVA_v70_WP85_WCM_binary_install.xml \
    -dataLocation /optware/IIM/var_ibm_InstallationManager_data \
    -showVerboseProgress \
    -log /tmp/wasWASND_85_IBMJAVA_v70_WP85_WCM_binary_silent_install_log.xml | \
    tee -a /tmp/WASND_85_IBMJAVA_v70_WP85_WCM_binary_silent_install.log

# after binary installation: http://pdwpappdev02.advancestores.com:10207/ibm/wizard

# verify the WASND_85_IBMJAVA_v70_WP85_WCM_binary installations:
cd /optware/IIM/InstallationManager/eclipse/tools
./imcl listInstalledPackages \
    -dataLocation  /optware/IIM/var_ibm_InstallationManager_data































: << 'COMMENTEND'
cd /optware/IBM_85/InstallationManager/eclipse/tools
./imcl install com.ibm.websphere.ND.v85 com.ibm.websphere.IBMJAVA.v70 com.ibm.websphere.PORTAL.SERVER.v85 \
    -repositories /backup/portal/wcmv85/WCM_85/WP85_Server/repository.config,/backup/portal/wcmv85/WCM_85/WAS8552/repository.config,/backup/portal/wcmv85/WCM_85/IBMJAVA7/repository.config \
    -dataLocation /optware/IBM_85/tmp/InstallationManager_logs \
    -sharedResourcesDirectory /optware/IBM_85/IMShared \
    -installationDirectory /optware/IBM_85/WebSphere/AppServer \
    -acceptLicense

cd /optware/IBM_85/InstallationManager/eclipse/tools

./imcl listAvailablePackages \
    -repositories /backup/portal/wcmv85/WCM_85/IBMJAVA7/repository.config \
    -features -long

./imcl listAvailablePackages \
    -repositories /backup/portal/wcmv85/WCM_85/WAS8552/repository.config \
    -features -long

./imcl listAvailablePackages \
    -repositories /backup/portal/wcmv85/WCM_85/WP85_Server/repository.config \
    -features -long

#/backup/portal/wcmv85/WCM_85/SETUP/sample-responsefiles/aix/was85-server-install_larry.xml
cat > /tmp/WASND_85_IBMJAVA_v70_WP85_WCM_install.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<agent-input>
    <!-- Listing of repositories -->
    <server>
        <repository location='/backup/portal/wcmv85/WCM_85/IBMJAVA7/repository.config'/>
        <repository location='/backup/portal/wcmv85/WCM_85/WAS8552/repository.config'/>
        <repository location='/backup/portal/wcmv85/WCM_85/WP85_Server/repository.config'/>
        <repository location='/backup/portal/wcmv85/WCM_85/WP85_WCM/repository.config'/>
    </server>
    <!-- Listing of products and fixes to be installed -->
    <install modify='false'>
        <offering id='com.ibm.websphere.ND.v85' profile='IBM WebSphere Application Server V8.5' features='core.feature,ejbdeploy,thinclient,embeddablecontainer,com.ibm.sdk.6_64bit' installFixes='none'/>  -->
        <offering id='8.5.5.0-WS-WASProd-IFPI15756' profile='IBM WebSphere Application Server V8.5' features='-'/>  -->
        <offering id='8.5.5.2-WS-WAS-IFPI15581' profile='IBM WebSphere Application Server V8.5' features='-'/>  -->
        <offering id='com.ibm.websphere.IBMJAVA.v70' profile='IBM WebSphere Application Server V8.5' features='com.ibm.sdk.7' installFixes='none'/>  -->
        <offering id='com.ibm.websphere.PORTAL.SERVER.v85' profile='IBM WebSphere Portal Server V8.5' features='ce.install,portal.binary,portal.profile' installFixes='none'/>
<!--        <offering id='com.ibm.websphere.PORTAL.WCM.v85' profile='IBM WebSphere Portal Server V8.5' features='enable.upsell' installFixes='none'/> -->
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
    input /tmp/WASND_85_IBMJAVA_v70_WP85_WCM_install.xml \
    -dataLocation  /optware/IBM_85/tmp/InstallationManager_logs \
    -log /optware/IBM_85/tmp/was_silent_install_log.xml

cd /optware/IBM_85/WebSphere/AppServer/bin
./versionInfo.sh

./imcl install com.ibm.websphere.ND.v85 \
    -repositories /backup/portal/wcmv85/WCM_85/WAS8552/repository.config \
    -dataLocation /optware/IBM_85/tmp/InstallationManager_logs \
    -sharedResourcesDirectory /optware/IBM_85/IMShared \
    -installationDirectory /optware/IBM_85/WebSphere/AppServer \
    -acceptLicense

./imcl install com.ibm.websphere.IBMJAVA.v70 \
    -repositories /backup/portal/wcmv85/WCM_85/IBMJAVA7/repository.config \
    -dataLocation /optware/IBM_85/tmp/InstallationManager_logs \
    -sharedResourcesDirectory /optware/IBM_85/IMShared \
    -installationDirectory /optware/IBM_85/WebSphere/AppServer \
    -acceptLicense

./imcl install com.ibm.websphere.PORTAL.SERVER.v85 \
    -repositories /backup/portal/wcmv85/WCM_85/WP85_Server/repository.config \
    -dataLocation /optware/IBM_85/tmp/InstallationManager_logs \
    -sharedResourcesDirectory /optware/IBM_85/IMShared \
    -installationDirectory /optware/IBM_85/WebSphere/AppServer \
    -acceptLicense
COMMENTEND
