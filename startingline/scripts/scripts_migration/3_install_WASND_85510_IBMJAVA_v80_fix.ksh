#!/usr/bin/ksh

stopdm;stopwp;stopnode

# if need to use new IIM, upgrade the current IIM, do not use the new IIM directly
cd /optware/IIM/InstallationManager/eclipse/tools/

./imcl listInstalledPackages


#./imcl listAvailablePackages -repositories /backup/portal/wcmv85/WCM_85/fixes/8.5.5-WS-WAS-FP0000010
./imcl listAvailablePackages -repositories /backup/portal/wcmv85/WCM_85/fixes/8.0.3.0-WS-IBMWASJAVA

: << 'COMMENTEND'
# Upgrade the WASND first
./imcl install com.ibm.websphere.ND.v85_8.5.5010.20160721_0036 \
    -repositories /backup/portal/wcmv85/WCM_85/fixes/8.5.5-WS-WAS-FP0000010 \
    -installationDirectory /optware/IBM85/WebSphere/AppServer/ \
    -dL /optware/IIM/var_ibm_InstallationManager_data -sP \
    -acceptLicense
COMMENTEND

#Upgrade Java8 later:
./imcl install com.ibm.websphere.IBMJAVA.v80_8.0.3000.20160720_1754 \
    -repositories /backup/portal/wcmv85/WCM_85/fixes/8.0.3.0-WS-IBMWASJAVA \
    -installationDirectory /optware/IBM85/WebSphere/AppServer/ \
    -dL /optware/IIM/var_ibm_InstallationManager_data -sP \
    -acceptLicense 



cd /optware/IBM85/WebSphere/AppServer/bin/
./versionInfo.sh







: << 'COMMENTEND'

cat > /tmp/WAS8555_IBMJAVA8_fix_install.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<agent-input>
    <server>
        <repository location='/backup/portal/wcmv85/WCM_85/fixes/8.5.5-WS-WAS-FP0000010/repository.config'/>
        <repository location='/backup/portal/wcmv85/WCM_85/fixes/8.0.3.0-WS-IBMWASJAVA/repository.config'/>
    </server>
    <install modify='false'>
        <offering id='com.ibm.websphere.ND.v85' profile='IBM WebSphere Application Server V8.5'  version='8.5.8.5.5010.20160721_0036' features='core.feature'/>
        <offering id='com.ibm.websphere.IBMJAVA.v80' profile='IBM WebSphere Application Server V8.5' installFixes='none'/>
    </install>
    <profile id='IBM WebSphere Application Server V8.5' installLocation='/optware/IBM85/WebSphere/AppServer'>
        <data key='eclipseLocation' value='/optware/IBM85/WebSphere/AppServer'/>
        <data key='user.import.profile' value='false'/>
        <data key='cic.selector.nl' value='en, fr, it, zh, ro, ru, zh_TW, de, ja, pl, es, cs, hu, ko, pt_BR'/>
    </profile>
    <preference name='com.ibm.cic.common.core.preferences.eclipseCache' value='/optware/IBM85/IMShared'/>
    <preference name='com.ibm.cic.common.core.preferences.connectTimeout' value='30'/>
    <preference name='com.ibm.cic.common.core.preferences.readTimeout' value='30'/>
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
</agent-input>
EOF

#-------------------------------------------------------------------------------------------------------------
# Install WAS_ND_85 fix 
# after stop the process
#-------------------------------------------------------------------------------------------------------------

cd /optware/IBM/WebSphere/AppServer/profiles/Dmgr01/bin
./stopManager.sh -username wasadmqa -password 86Vn739i



cd /optware/IIM/InstallationManager/eclipse/tools
./imcl \
    -acceptLicense \
    input /tmp/WAS8555_IBMJAVA8_fix_install.xml \
    -dataLocation /optware/IIM/var_ibm_InstallationManager_data \
    -showVerboseProgress \
    -log /tmp/was_IBMJDK_fix_update_log.xml | \
    tee -a /tmp/WAS8555_IBMJAVA8_fix_install.log

#-------------------------------------------------------------------------------------------------------------
# Verify WAS_ND_85, IBMJDK version
#-------------------------------------------------------------------------------------------------------------
cd /optware/IBM85/WebSphere/AppServer/bin
./versionInfo.sh

COMMENTEND

