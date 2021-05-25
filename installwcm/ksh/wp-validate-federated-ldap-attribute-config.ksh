#####################################################################################################
# wp-validate-federated-ldap-attribute-config
#####################################################################################################

email_notify \
  "ConfigEngine.sh wp-validate-federated-ldap-attribute-config ......" \
  "ConfigEngine.sh wp-validate-federated-ldap-attribute-config ......" \
  $_EMAILLIST \
  $_START

${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh wp-validate-federated-ldap-attribute-config

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh wp-validate-federated-ldap-attribute-config Failed." \
    "ConfigEngine.sh wp-validate-federated-ldap-attribute-config Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "ConfigEngine.sh wp-validate-federated-ldap-attribute-config completed. " \
  "ConfigEngine.sh wp-validate-federated-ldap-attribute-config completed. " \
  $_EMAILLIST \
  $_START

