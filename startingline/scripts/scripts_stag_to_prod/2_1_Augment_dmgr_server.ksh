#!/usr/bin/ksh

#-------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------
# Augment Deployment Manager 8.5
#     Larry Sui 
#     February 2017 
#-------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------------------------------------
# 1. ./stopManager.sh
# 2. copy sdwpappdev01:/optware/IBM85/WebSphere/PortalServer/filesForDmgr/filesForDmgr.zip to sdwpnddev01:/backups/portal/wcmv85/download
# 3. extract filesForDmgr.zip to sdwpnddev01:/optware/IBM85/WebSphere/AppServer/
# 4. ./startManager.sh
#-------------------------------------------------------------------------------------------------------------
# 

# 5. Augment Dmgr
/optware/IBM85/WebSphere/AppServer/bin/manageprofiles.sh \
	-augment \
	-templatePath /optware/IBM85/WebSphere/AppServer/profileTemplates/management.portal.augment \
	-profileName Dmgr01

# 6. ./stopManager.sh
# 7. ./startManager.sh


