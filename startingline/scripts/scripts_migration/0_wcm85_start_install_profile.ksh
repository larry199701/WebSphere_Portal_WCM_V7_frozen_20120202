#!/usr/bin/ksh



: << 'COMMENTEND'
./1_install_InstallationManager.ksh
./2_install_InstallationManager_fix.ksh
./3_install_WASND_85_IBMJAVA_v70_WP85_WCM_profile.ksh
./4_install_WASND_85_IBMJAVA_v70_fix_profile.ksh
COMMENTEND
./5_install_WP_WCM_85_Combined_fix_profile.ksh



