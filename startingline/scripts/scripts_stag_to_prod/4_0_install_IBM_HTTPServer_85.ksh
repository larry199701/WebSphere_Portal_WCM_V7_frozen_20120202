#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    Install Installation Manager
#    Install and Patch IBM HTTPServer v85
#############################################################################################

#./1_install_InstallationManager.ksh
#./2_install_InstallationManager_fix.ksh


cat > /tmp/IBM_HTTPServer_install_qa.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<agent-input clean="true" temporary="true">

<server>
    <repository location='/backup/portal/wcmv85/WCM_85/WAS_V855_SUPPL/'/>
</server>

<install modify='false'>
<offering id='com.ibm.websphere.IHS.v85' 
    profile='IBM HTTP Server V8.5' 
    features='core.feature,arch.32bit' installFixes='none'/>
</install>

<profile id='IBM HTTP Server V8.5' installLocation='/optware/IBM85/HTTPServer'>
    <data key='eclipseLocation' value='/optware/IBM85/HTTPServer'/>
    <data key='user.import.profile' value='false'/>
    <data key='user.ihs.http.server.service.name' value='none'/> 
    <data key='user.ihs.httpPort' value='80'/>
    <data key='user.ihs.installHttpService' value='false'/>
    <data key='cic.selector.nl' value='en'/>
</profile>

</agent-input>
EOF

cd /optware/IIM/InstallationManager/eclipse/tools
./imcl \
    -acceptLicense \
    -input /tmp/IBM_HTTPServer_install_qa.xml \
    -log /tmp/IBM_HTTPServer_install_log.xml 

<< 'COMMENTEND'
COMMENTEND
