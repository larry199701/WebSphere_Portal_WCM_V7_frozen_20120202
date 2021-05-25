
#####################################################################################################
# wp-change-portal-admin-user
#####################################################################################################


email_notify \
  "Start ConfigEngine.sh wp-change-portal-admin-user ... " \
  "Start ConfigEngine.sh wp-change-portal-admin-user ... " \
  $_EMAILLIST \
  $_START

while read a;
do
  echo "$a" | sed \
    -e "s/WasPassword=.*/WasPassword=${_ADMINLDAPPASSWORD}/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties  > /tmp/mytmpfile.properties
mv /tmp/mytmpfile.properties ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties

${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh wp-change-portal-admin-user

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh wp-change-portal-admin-user Failed." \
    "ConfigEngine.sh wp-change-portal-admin-user Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "ConfigEngine.sh wp-change-portal-admin-user completed. " \
  "ConfigEngine.sh wp-change-portal-admin-user completed. " \
  $_EMAILLIST \
  $_START

