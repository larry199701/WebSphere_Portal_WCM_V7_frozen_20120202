#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    Install Installation Manager
#    Install and Patch IBM HTTPServer v7 
#############################################################################################

#cd /optware/IIM/InstallationManager/eclipse/tools
#./imcl listAvailablePackages -repositories /backup/portal/wcmv85/WCM_85/WAS_V855_SUPPL

cat > /tmp/IBM_WCT_install.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<agent-input clean="true" temporary="true">

<server>
    <repository location='/backup/portal/wcmv85/WCM_85/WAS_V855_SUPPL/'/>
</server>

<install modify='false'>
<offering id='com.ibm.websphere.WCT.v85'
    profile='WebSphere Customization Toolbox V8.5'
    features='core.feature,pct' installFixes='none'/>
</install>

<profile id='WebSphere Customization Toolbox V8.5' installLocation='/optware/IBM/WebSphere/Toolbox'>
    <data key='eclipseLocation' value='/optware/IBM/WebSphere/Toolbox'/>
    <data key='user.import.profile' value='false'/>
    <data key='user.select.64bit.image,com.ibm.websphere.WCT.v85' value='false'/>
    <data key='cic.selector.nl' value='en'/>
</profile>

</agent-input>
EOF

cd /optware/IIM/InstallationManager/eclipse/tools
./imcl \
    -acceptLicense \
    -input /tmp/IBM_WCT_install.xml \
    -log /tmp/IBM_WCT_install_log.xml 

<< 'COMMENTEND'
COMMENTEND
