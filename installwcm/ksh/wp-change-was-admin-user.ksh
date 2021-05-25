
#####################################################################################################
# wp-change-was-admin-user
#####################################################################################################

email_notify \
  "Start ConfigEngine.sh wp-change-was-admin-user ... " \
  "Start ConfigEngine.sh wp-change-was-admin-user ... " \
  $_EMAILLIST \
  $_START

while read a;
do
  echo "$a" | sed \
    -e "s/newAdminId=.*/newAdminId=${_ADMINLDAPUSERNAME}/" \
    -e "s/newAdminPw=.*/newAdminPw=${_ADMINLDAPPASSWORD}/" \
    -e "s/newAdminGroupId=.*/newAdminGroupId=${_ADMINLDAPADMINGROUP}/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties  > /tmp/mytmpfile.properties
mv /tmp/mytmpfile.properties ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties

# a420018: Following working
#    -e 's/newAdminId=.*/newAdminId=cn=Larry Sui,OU=TM Enter,OU=Accounts Users,DC=corp,DC=advancestores,DC=com/' \
# a420018: Following not working, as wpsbindqa could not be find from the WAS Admin Console
#    -e 's/newAdminId=.*/newAdminId=cn=wpsbindqa,OU=Service,OU=Accounts Resources,DC=corp,DC=advancestores,DC=com/' \

${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh wp-change-was-admin-user

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh ConfigEngine.sh wp-change-was-admin-user Failed." \
    "ConfigEngine.sh ConfigEngine.sh wp-change-was-admin-user Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "ConfigEngine.sh wp-change-was-admin-user Completed. " \
  "ConfigEngine.sh wp-change-was-admin-user Completed. " \
  $_EMAILLIST \
  $_START

