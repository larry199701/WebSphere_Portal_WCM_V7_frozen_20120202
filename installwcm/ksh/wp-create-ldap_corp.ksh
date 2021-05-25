#####################################################################################################
# Add LDAP 'corp' to Federated Repositories
#####################################################################################################


###############################################################################################################################
: << 'COMMENTEND'
. /backup/portal/wcmv7/a420018/install/installwcm/ksh/email_notify_function.ksh
. /backup/portal/wcmv7/a420018/install/installwcm/properties/installwcmpdwpappqa01.properties
_START=`date +%s`
COMMENTEND
###############################################################################################################################

email_notify \
  "Add LDAP 'corp' to Federated Repositories......" \
  "Add LDAP 'corp' to Federated Repositories......" \
  $_EMAILLIST \
  $_START


while read a;
do
echo "$a" | sed \
    -e 's/PortalAdminId=.*/PortalAdminId=iamadummy/' \
    -e 's/PortalAdminPwd=.*/PortalAdminPwd=yesiam/' \
    -e 's/WasUserid=.*/WasUserid=iamadummy/' \
    -e 's/WasPassword=.*/WasPassword=yesiam/' \
    -e 's/federated.delete.baseentry=.*/federated.delete.baseentry=DC=corp,DC=advancestores,DC=com/' \
    -e 's/federated.delete.id=.*/federated.delete.id=aapPortalLdapCorp/'
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties  > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties

# "federated.ldap.et.personaccount.searchBases=" added "OU=Service,OU=Accounts Resources,DC=corp,DC=advancestores,DC=com" for "cn=wpsbindqa"
while read a;
do
  echo "$a" | sed \
    -e 's/federated.ldap.id=.*/federated.ldap.id=aapPortalLdapCorp/' \
    -e 's/federated.ldap.port=.*/federated.ldap.port=3268/' \
    -e 's/federated.ldap.host=.*/federated.ldap.host=pdcorpdc01.corp.advancestores.com/' \
    -e "s/federated.ldap.bindDN=.*/federated.ldap.bindDN=${_ADMINLDAPUSERNAME}/" \
    -e "s/federated.ldap.bindPassword=.*/federated.ldap.bindPassword=${_ADMINLDAPPASSWORD}/" \
    -e 's/federated.ldap.ldapServerType=.*/federated.ldap.ldapServerType=AD/' \
    -e 's/federated.ldap.baseDN=.*/federated.ldap.baseDN=DC=corp,DC=advancestores,DC=com/' \
    -e 's/federated.ldap.et.group.objectClasses=.*/federated.ldap.et.group.objectClasses=group/' \
    -e 's/federated.ldap.et.group.searchBases=.*/federated.ldap.et.group.searchBases=DC=corp,DC=advancestores,DC=com/' \
    -e 's/federated.ldap.et.personaccount.searchBases=.*/federated.ldap.et.personaccount.searchBases=OU=Accounts Users,DC=corp,DC=advancestores,DC=com;OU=Accounts Contractors,DC=corp,DC=advancestores,DC=com;OU=Service,OU=Accounts Resources,DC=corp,DC=advancestores,DC=com/' \
    -e 's/federated.ldap.et.personaccount.objectClasses=.*/federated.ldap.et.personaccount.objectClasses=person/' \
    -e 's/federated.ldap.loginProperties=.*/federated.ldap.loginProperties=uid/' \
    -e 's/federated.ldap.gm.objectClass=.*/federated.ldap.gm.objectClass=group/'
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/config/helpers/wp_add_federated_ad.properties  > /tmp/mytmpfile.properties
mv /tmp/mytmpfile.properties ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/config/helpers/wp_add_federated_ad.properties

${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh validate-federated-ldap \
  -DparentProperties=${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/config/helpers/wp_add_federated_ad.properties \
  -DsaveParentProperties=true

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh validate-federated-ldap corp Failed." \
    "ConfigEngine.sh validate-federated-ldap corp Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "ConfigEngine.sh validate-federated-ldap corp completed. wp-create-ldap......" \
  "ConfigEngine.sh validate-federated-ldap corp completed. wp-create-ldap......" \
  $_EMAILLIST \
  $_START

${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh wp-create-ldap
#${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh wp-update-federated-ldap
#${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh wp-delete-repository
#./ConfigEngine.sh wp-query-repository

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh wp-create-ldap corp Failed." \
    "ConfigEngine.sh wp-create-ldap corp Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "ConfigEngine.sh wp-create-ldap corp completed. " \
  "ConfigEngine.sh wp-create-ldap corp completed. " \
  $_EMAILLIST \
  $_START

# a420018: restart Dmgr01, NodeAgent, WebSphere_Portal, server1
# a420018: if a it happen to have a user in ldap with short name same as the login name, run  ConfigEngine.sh wp-modify-realm-enable-dn-login

