#####################################################################################################
# Remove file based repository
#####################################################################################################


###############################################################################################################################
: << 'COMMENTEND'
. /backup/portal/wcmv7/a420018/install/installwcm/ksh/email_notify_function.ksh
. /backup/portal/wcmv7/a420018/install/installwcm/properties/installwcmpdwpappqa01.properties
_START=`date +%s`
COMMENTEND
###############################################################################################################################

email_notify \
  "Remove the default file user regiestry......" \
  "Remove the default file user regiestry......" \
  $_EMAILLIST \
  $_START


while read a;
do
echo "$a" | sed \
    -e 's/federated.delete.baseentry=.*/federated.delete.baseentry=o=defaultWIMFileBasedRealm/' \
    -e 's/federated.delete.id=.*/federated.delete.id=InternalFileRepository/'
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties  > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties


${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh wp-delete-repository

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh wp-delete-repository (file based) Failed." \
    "ConfigEngine.sh wp-delete-repository (file based) Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "ConfigEngine.sh wp-delete-repository (file based)completed." \
  "ConfigEngine.sh wp-delete-repository (file based)completed." \
  $_EMAILLIST \
  $_START

