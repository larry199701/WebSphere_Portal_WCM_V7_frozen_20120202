#! /usr/bin/ksh

#############################################################################################
#
# Tasks:
#    7. Create a webserver definition:
# Author:
#    Larry Sui
# Date:
#    2011-09-11
#
############################################################################################

_WEBSERVERHOSTNAME=$1

if [[ $# != 1 ]] then
  echo Usage: "installweb.ksh webserver_hostname"
  exit 1
fi

#_CURDIR=/backup/portal/wcmv7/a420018/install
#. ${_CURDIR}/installwcm/ksh/email_notify_function.ksh
#. ${_CURDIR}/installwcm/properties/installwcmpdwpappqa01.properties


#############################################################################################
# 7. Create a webserver definition:
#############################################################################################

email_notify \
  "Start to Create webserver_${_WEBSERVERHOSTNAME}... " \
  "Start to Create webserver_${_WEBSERVERHOSTNAME}... " \
  $_EMAILLIST \
  $_START

${_WSDIR}/IBM/WebSphere/wp_profile/bin/wsadmin.sh \
  -lang jython \
  -conntype SOAP \
  -host ${_DMGRHOSTNAME} \
  -port ${_WASSOAPPORT} \
  -c "AdminTask.createUnmanagedNode('[-nodeName webserver_${_WEBSERVERHOSTNAME}_node \
    -hostName ${_WEBSERVERHOSTNAME} \
    -nodeOperatingSystem aix]')"

if [[ $? != 0 ]] then
  email_notify \
    "createUnmanagedNode: webserver_${_WEBSERVERHOSTNAME}_node Failed." \
    "createUnmanagedNode: webserver_${_WEBSERVERHOSTNAME}_node Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

${_WSDIR}/IBM/WebSphere/wp_profile/bin/wsadmin.sh \
  -lang jython \
  -conntype SOAP \
  -host ${_DMGRHOSTNAME} \
  -port ${_WASSOAPPORT} \
  -c "AdminTask.createWebServer('webserver_${_WEBSERVERHOSTNAME}_node', '[-name webserver_${_WEBSERVERHOSTNAME} \
    -templateName IHS \
    -serverConfig [-webPort 443 \
      -serviceName \
      -webInstallRoot /optware/IBM/HTTPServer \
      -webProtocol HTTP \
      -configurationFile \
      -errorLogfile \
      -accessLogfile \
      -pluginInstallRoot /optware/IBM/HTTPServer/Plugins \
      -webAppMapping ALL] \
    -remoteServerConfig [-adminPort 8008 \
      -adminUserID ihsadmin \
      -adminPasswd ihsadmin \
      -adminProtocol HTTP]]')"

if [[ $? != 0 ]] then
  email_notify \
    "AdminTask.createWebServer: webserver_${_WEBSERVERHOSTNAME} Failed." \
    "AdminTask.createWebServer: webserver_${_WEBSERVERHOSTNAME} Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "Create webserver_${_WEBSERVERHOSTNAME} completed. " \
  "Create webserver_${_WEBSERVERHOSTNAME} completed. " \
  $_EMAILLIST \
  $_START

