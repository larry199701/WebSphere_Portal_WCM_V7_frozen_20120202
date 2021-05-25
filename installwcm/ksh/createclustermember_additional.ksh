#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    Create a New Cluster Member: WebSphere_Portal_n02s01 in PortalCluster
# Author:
#    Larry Sui
# Date:
#    2011-09-11
#
############################################################################################

#############################################################################################
#    Create a New Cluster Member: WebSphere_Portal_n02s01 in PortalCluster
#############################################################################################

#. /backup/portal/wcmv7/a420018/install/installwcm/ksh/email_notify_function.ksh
#. /backup/portal/wcmv7/a420018/install/installwcm/properties/installwcmpdwpappqa02.properties

email_notify \
  "Start to Create WebSphere_Portal_n02s01..." \
  "Start to Create WebSphere_Portal_n02s01..." \
  $_EMAILLIST \
  $_START

echo "a420018: -- change wkplc.properties ..."
while read a;
do
  echo "$a" | sed \
    -e "s/WasSoapPort=.*/WasSoapPort=${_WASSOAPPORT}/" \
    -e "s/WasRemoteHostName=.*/WasRemoteHostName=${_DMGRHOSTNAME}.${_DOMAINNAME}/" \
    -e "s/WasUserid=.*/WasUserid=${_ADMINLDAPUSERNAME}/" \
    -e "s/WasPassword=.*/WasPassword=${_ADMINLDAPPASSWORD}/" \
    -e "s/PortalAdminId=.*/PortalAdminId=${_ADMINLDAPUSERNAME}/" \
    -e "s/PortalAdminPwd=.*/PortalAdminPwd=${_ADMINLDAPPASSWORD}/" \
    -e "s/ServerName=.*/ServerName=WebSphere_Portal_n02s01/" \
    -e "s/PrimaryNode=.*/PrimaryNode=false/" \
    -e "s/ClusterName=.*/ClusterName=PortalCluster/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties  > /tmp/mytmpfile.properties
mv /tmp/mytmpfile.properties ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties

echo "a420018: -- cluster-node-config-cluster-setup-additional..."
${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh cluster-node-config-cluster-setup-additional

if [[ $? != 0 ]] then
  email_notify \
    "Create WebSphere_Portal_n02s01 Failed." \
    "Create WebSphere_Portal_n02s01 Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

echo "a420018: -- WebSphere_Portal_n02s01 Completed..."
email_notify \
  "Create WebSphere_Portal_n02s01 Completed." \
  "Create WebSphere_Portal_n02s01 Completed." \
  $_EMAILLIST \
  $_START

${_WSDIR}/IBM/WebSphere/wp_profile/bin/startServer.sh WebSphere_Portal_n02s01
# fully synchronizing, both nodes: pdwpappqa01Node01 and pdwpappqa02Node01  
		



################################################################################################################################
# propagate Keyring: /optware/IBM/WebSphere/AppServer/profiles/Dmgr01/config/cells/pdwpndqa01Cell01/nodes/webserver1_node/servers/webserver1/plugin-key.kdb to /optware/IBM/HTTPServer/Plugins/config/webserver1/plugin-key.kdb on the Web server computer.

# AdminControl.invoke('WebSphere:name=PluginCfgGenerator,process=dmgr,platform=common,node=pdwpndqa01Dmgr01,version=7.0.0.13,type=PluginCfgGenerator,mbeanIdentifier=PluginCfgGenerator,cell=pdwpndqa01Cell01,spec=1.0', 'propagateKeyring', '[/optware/IBM/WebSphere/AppServer/profiles/Dmgr01/config pdwpndqa01Cell01.webserver1_node webserver1]', '[java.lang.String java.lang.String java.lang.String java.lang.String]')

# ping webserver1: 
# AdminControl.invoke('WebSphere:name=WebServer,process=dmgr,platform=common,node=pdwpndqa01Dmgr01,version=7.0.0.13,type=WebServer,mbeanIdentifier=WebServer,cell=pdwpndqa01Cell01,spec=1.0', 'ping', '[pdwpndqa01Cell01 webserver1_node webserver1]', '[java.lang.String java.lang.String java.lang.String]') 

# generate
# AdminControl.invoke('WebSphere:name=PluginCfgGenerator,process=dmgr,platform=common,node=pdwpndqa01Dmgr01,version=7.0.0.13,type=PluginCfgGenerator,mbeanIdentifier=PluginCfgGenerator,cell=pdwpndqa01Cell01,spec=1.0', 'generate', '[/optware/IBM/WebSphere/AppServer/profiles/Dmgr01/config pdwpndqa01Cell01 webserver1_node webserver1 false]', '[java.lang.String java.lang.String java.lang.String java.lang.String java.lang.Boolean]')
 
# propagate
# AdminControl.invoke('WebSphere:name=PluginCfgGenerator,process=dmgr,platform=common,node=pdwpndqa01Dmgr01,version=7.0.0.13,type=PluginCfgGenerator,mbeanIdentifier=PluginCfgGenerator,cell=pdwpndqa01Cell01,spec=1.0', 'propagate', '[/optware/IBM/WebSphere/AppServer/profiles/Dmgr01/config pdwpndqa01Cell01 webserver1_node webserver1]', '[java.lang.String java.lang.String java.lang.String java.lang.String]') 

# disable non-secure channels

