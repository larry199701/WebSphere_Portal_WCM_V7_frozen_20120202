#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    Configure SPNEGO
#############################################################################################

1.	AD team has to create the AD service account, map the SPN to it, generate the keytab and send it over to Portal Admin.
2.	Copy the keytab file to the directory: /optware/IBM/WebSphere/spnego on the deployment manager as well as all the portal nodes.
3.	On one of the portal nodes connect to the dmgr using wsadmin client as below:
		cd /optware/IBM85/WebSphere/wp_profile/bin
		./wsadmin.sh -lang jython -conntype SOAP -host pdwpndqa01 -port 8879
4.	AdminTask.createKrbConfigFile("-krbPath /optware/IBM85/WebSphere/spnego/asc.conf -realm ADVANCESTORES.COM -kdcHost pdascdc01.advancestores.com -dns advancestores.com -keytabPath /optware/IBM85/WebSphere/spnego/ascqaportal_from_Mike_Bryan_20111207.keytab")
5.	This conf file needs to be moved to the same location on all the nodes.
