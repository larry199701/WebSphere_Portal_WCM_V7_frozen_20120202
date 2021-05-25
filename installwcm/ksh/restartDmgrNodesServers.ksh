#! /usr/bin/ksh


email_notify \
  "restartDmgrNodesServers.ksh ... " \
  "restartDmgrNodesServers.ksh ... " \
  $_EMAILLIST \
  $_START


_INTENDEDHOSTNAME=$1
_HOSTNAME=`uname -n`
_CURDIR=`pwd`


###############################################################################################################################
: << 'COMMENTEND'
if [[ $# != 1 ]] then
  echo Please pass intended hostname as an argument.
  exit 1
fi
. ${_CURDIR}/installwcm/properties/installwcm${_INTENDEDHOSTNAME}.properties
COMMENTEND
###############################################################################################################################


cat > /tmp/restartNodesServers.py <<EOF

print "refreshRepositoryEpoch..."
AdminControl.invoke(AdminControl.queryNames('WebSphere:type=ConfigRepository,name=repository,process=nodeagent,cell=${_DMGRHOSTNAME}Cell01,node=${_INTENDEDHOSTNAME}Node01,*'), 'refreshRepositoryEpoch')

print "refreshRepositoryEpoch completed, syncNode..."
AdminControl.invoke(AdminControl.queryNames('WebSphere:type=CellSync,name=cellSync,process=dmgr,cell=${_DMGRHOSTNAME}Cell01,node=${_DMGRHOSTNAME}Dmgr01,*'),'syncNode','${_INTENDEDHOSTNAME}Node01')

print "syncNode completed, restartNode..."
AdminControl.invoke(AdminControl.queryNames('WebSphere:type=NodeAgent,cell=${_DMGRHOSTNAME}Cell01,node=${_INTENDEDHOSTNAME}Node01,*'),'restart','true true')

print "wait 5 minutes after restartNode..."
sleep(300)

print "restartNode completed, restart  WebSphere_Portal/server1 ..."
AdminControl.invoke(AdminControl.queryNames('WebSphere:type=Server,name=server1,*'),'restart')
AdminControl.invoke(AdminControl.queryNames('WebSphere:type=Server,name=WebSphere_Portal,*'),'restart')

print "wait 4 minutes after restart WebSphere_Portal/server1 ..."
sleep(240)

EOF

# restart the Deployment Manager
echo restart the Deployment Manager...
${_WSDIR}/IBM/WebSphere/wp_profile/bin/wsadmin.sh -lang jython -conntype SOAP -host ${_DMGRHOSTNAME} -port ${_WASSOAPPORT} \
  -c "AdminControl.invoke(AdminControl.queryNames ('WebSphere:type=Server,cell=${_DMGRHOSTNAME}Cell01,name=dmgr,*'), 'restart')"

echo wait for 3 minutes to connect to the Deployment Manager...
sleep 180

# restart the Node Agent and Servers
${_WSDIR}/IBM/WebSphere/wp_profile/bin/wsadmin.sh -lang jython -conntype SOAP -host ${_DMGRHOSTNAME} -port ${_WASSOAPPORT} -f  /tmp/restartNodesServers.py

rm -f /tmp/restartNodesServers.py

email_notify \
  "Completed restartDmgrNodesServers.ksh ... " \
  "Completed restartDmgrNodesServers.ksh ... " \
  $_EMAILLIST \
  $_START
