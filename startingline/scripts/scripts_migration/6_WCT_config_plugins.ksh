#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    Install Installation Manager
#    Install and Patch IBM HTTPServer v7 
#############################################################################################

cat > /tmp/pct_responsefile_larry.txt <<EOF
configType="local_distributed"
wasExistingLocation="/optware/IBM/WebSphere/AppServer"
webServerSelected="ihs"
ihsAdminPort="8008"
#ihsAdminUserID="ihsadmin"
#ihsAdminUserGroup="ihsadmins"
webServerConfigFile1="/optware/IBM/HTTPServer/conf/httpd.conf"
webServerPortNumber="80"
webServerDefinition="webserver1"
wasMachineHostName="pdwpappqa03"
mapWebserverToApplications="true"
webServerHostName=""
webServerInstallArch=""
ihsAdminCreateUserAndGroup="true"
ihsAdminUnixUserID="ihsadmin"
ihsAdminUnixUserGroup="ihsadmins"
ihsAdminPassword="ihsadmin"
enableAdminServerSupport="true"
enableUserAndPass="true"
webServerType="IHS"
#profileName="wp_profile"
EOF

cd /optware/IBM/WebSphere/Toolbox/WCT
./wctcmd.sh -tool pct \
	-defLocPathname /optware/IBM/WebSphere/Plugins \
	-defLocName webserver1_test \
	-response /tmp/pct_responsefile_larry.txt



<< 'COMMENTEND'
./wctcmd.sh -tool pct -listDefinitionLocations
./wctcmd.sh -tool pct -removeDefinitionLocation -defLocPathname /optware/IBM/WebSphere/Plugins
COMMENTEND
