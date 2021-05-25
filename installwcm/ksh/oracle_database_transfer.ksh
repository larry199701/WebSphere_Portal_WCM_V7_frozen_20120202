###############################################################################################
#  Oracle Database Configuration...  Create Configure users    DbName: ${_DBNAME}, Instance: ${_DBINSTNAME}, Host:${_DBHOSTNAME}
#  ./oracle_database_transfer.ksh pdoraqacla-scan eppqa1 eppqa11
#  ./oracle_database_transfer.ksh pdoraqacla01 eppqa1 eppqa11
###############################################################################################

#_DBHOSTNAME=$1
#_DBNAME=$2
#_DBINSTNAME=$3
#_DBPASS=DBPASS#1
#_DBUSER=dbconf_usr
#_DBCONFROLE=dbconf_role

###############################################################################################################################
: << 'COMMENTEND'

_WSDIR=/optware
_INTENDEDDIR=/backup/portal/wcmv7/a420018/install
_EMAILLIST="larry.sui@advance-auto.com,sui80@yahoo.com"
_START=`date +%s`
_WASTEMPPASSWORD=yesiam

. ./email_notify_function.ksh

COMMENTEND
###############################################################################################################################

email_notify \
  "Start Oracle Database Transfer ......." \
  "Start Oracle Database Transfer ......." \
  $_EMAILLIST \
  $_START

# a420018: cp the ojdbc6.jar
rm -rf ${_WSDIR}/IBM/WebSphere/wp_profile/PortalServer/dbdrivers/oracle/jdbc/lib
mkdir -p ${_WSDIR}/IBM/WebSphere/wp_profile/PortalServer/dbdrivers/oracle/jdbc/lib/
cp ${_INTENDEDDIR}/installwcm/lib/ojdbc6.jar ${_WSDIR}/IBM/WebSphere/wp_profile/PortalServer/dbdrivers/oracle/jdbc/lib/

# a420018: Modify ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbtype.properties
if [ ! -f ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbtype.properties_original ]
then
  cp ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbtype.properties ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbtype.properties_original
fi

while read a;
do
  echo "$a" | sed \
    -e "s/oracle.DbDriver=.*/oracle.DbDriver=oracle.jdbc.OracleDriver/" \
    -e "s,oracle.DbLibrary=.*,oracle.DbLibrary=${_WSDIR}/IBM/WebSphere/wp_profile/PortalServer/dbdrivers/oracle/jdbc/lib/ojdbc6.jar," \
    -e "s/oracle.JdbcProviderName=.*/oracle.JdbcProviderName=wpdbJDBC_oracle/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbtype.properties > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbtype.properties

# a420018: Modify ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbdomain.properties
if [ ! -f ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbdomain.properties_original ]
then
  cp ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbdomain.properties ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbdomain.properties_original
fi

while read a;
do
  echo "$a" | sed \
    -e "s/feedback.DbType=.*/feedback.DbType=oracle/" \
    -e "s/likeminds.DbType=.*/likeminds.DbType=oracle/" \
    -e "s/release.DbType=.*/release.DbType=oracle/" \
    -e "s/community.DbType=.*/community.DbType=oracle/" \
    -e "s/customization.DbType=.*/customization.DbType=oracle/" \
    -e "s/jcr.DbType=.*/jcr.DbType=oracle/" \
    -e "s/feedback.DbName=.*/feedback.DbName=${_DBNAME}/" \
    -e "s/likeminds.DbName=.*/likeminds.DbName=${_DBNAME}/" \
    -e "s/release.DbName=.*/release.DbName=${_DBNAME}/" \
    -e "s/community.DbName=.*/community.DbName=${_DBNAME}/" \
    -e "s/customization.DbName=.*/customization.DbName=${_DBNAME}/" \
    -e "s/jcr.DbName=.*/jcr.DbName=${_DBNAME}/" \
    -e "s/feedback.DataSourceName=.*/feedback.DataSourceName=feedbackDTS/" \
    -e "s/likeminds.DataSourceName=.*/likeminds.DataSourceName=likemindsDTS/" \
    -e "s/release.DataSourceName=.*/release.DataSourceName=releaseDTS/" \
    -e "s/community.DataSourceName=.*/community.DataSourceName=communityDTS/" \
    -e "s/customization.DataSourceName=.*/customization.DataSourceName=customizationDTS/" \
    -e "s/jcr.DataSourceName=.*/jcr.DataSourceName=jcrDTS/" \
    -e "s/feedback.DbUrl=.*/feedback.DbUrl=jdbc:oracle:thin:@${_DBHOSTNAME}:1521:${_DBINSTNAME}/" \
    -e "s/likeminds.DbUrl=.*/likeminds.DbUrl=jdbc:oracle:thin:@${_DBHOSTNAME}:1521:${_DBINSTNAME}/" \
    -e "s/release.DbUrl=.*/release.DbUrl=jdbc:oracle:thin:@${_DBHOSTNAME}:1521:${_DBINSTNAME}/" \
    -e "s/community.DbUrl=.*/community.DbUrl=jdbc:oracle:thin:@${_DBHOSTNAME}:1521:${_DBINSTNAME}/" \
    -e "s/customization.DbUrl=.*/customization.DbUrl=jdbc:oracle:thin:@${_DBHOSTNAME}:1521:${_DBINSTNAME}/" \
    -e "s/jcr.DbUrl=.*/jcr.DbUrl=jdbc:oracle:thin:@${_DBHOSTNAME}:1521:${_DBINSTNAME}/" \
    -e "s/feedback.DbSchema=.*/feedback.DbSchema=feedback/" \
    -e "s/likeminds.DbSchema=.*/likeminds.DbSchema=likeminds/" \
    -e "s/release.DbSchema=.*/release.DbSchema=release/" \
    -e "s/community.DbSchema=.*/community.DbSchema=community/" \
    -e "s/customization.DbSchema=.*/customization.DbSchema=customization/" \
    -e "s/jcr.DbSchema=.*/jcr.DbSchema=jcr/" \
    -e "s/feedback.DbUser=.*/feedback.DbUser=${_DBUSER}/" \
    -e "s/likeminds.DbUser=.*/likeminds.DbUser=${_DBUSER}/" \
    -e "s/release.DbUser=.*/release.DbUser=${_DBUSER}/" \
    -e "s/community.DbUser=.*/community.DbUser=${_DBUSER}/" \
    -e "s/customization.DbUser=.*/customization.DbUser=${_DBUSER}/" \
    -e "s/jcr.DbUser=.*/jcr.DbUser=${_DBUSER}/" \
    -e "s/feedback.DbPassword=.*/feedback.DbPassword=${_DBPASS}/" \
    -e "s/likeminds.DbPassword=.*/likeminds.DbPassword=${_DBPASS}/" \
    -e "s/release.DbPassword=.*/release.DbPassword=${_DBPASS}/" \
    -e "s/community.DbPassword=.*/community.DbPassword=${_DBPASS}/" \
    -e "s/customization.DbPassword=.*/customization.DbPassword=${_DBPASS}/" \
    -e "s/jcr.DbPassword=.*/jcr.DbPassword=${_DBPASS}/" \
    -e "s/feedback.DbConfigRoleName=.*/feedback.DbConfigRoleName=${_DBCONFROLE}/" \
    -e "s/likeminds.DbConfigRoleName=.*/likeminds.DbConfigRoleName=${_DBCONFROLE}/" \
    -e "s/release.DbConfigRoleName=.*/release.DbConfigRoleName=${_DBCONFROLE}/" \
    -e "s/community.DbConfigRoleName=.*/community.DbConfigRoleName=${_DBCONFROLE}/" \
    -e "s/customization.DbConfigRoleName=.*/customization.DbConfigRoleName=${_DBCONFROLE}/" \
    -e "s/jcr.DbConfigRoleName=.*/jcr.DbConfigRoleName=${_DBCONFROLE}/" \
    -e "s/feedback.DbRuntimeUser=.*/feedback.DbRuntimeUser=feedback/" \
    -e "s/likeminds.DbRuntimeUser=.*/likeminds.DbRuntimeUser=likeminds/" \
    -e "s/release.DbRuntimeUser=.*/release.DbRuntimeUser=release/" \
    -e "s/community.DbRuntimeUser=.*/community.DbRuntimeUser=community/" \
    -e "s/customization.DbRuntimeUser=.*/customization.DbRuntimeUser=customization/" \
    -e "s/jcr.DbRuntimeUser=.*/jcr.DbRuntimeUser=jcr/" \
    -e "s/feedback.DbRuntimePassword=.*/feedback.DbRuntimePassword=${_DBPASS}/" \
    -e "s/likeminds.DbRuntimePassword=.*/likeminds.DbRuntimePassword=${_DBPASS}/" \
    -e "s/release.DbRuntimePassword=.*/release.DbRuntimePassword=${_DBPASS}/" \
    -e "s/community.DbRuntimePassword=.*/community.DbRuntimePassword=${_DBPASS}/" \
    -e "s/customization.DbRuntimePassword=.*/customization.DbRuntimePassword=${_DBPASS}/" \
    -e "s/jcr.DbRuntimePassword=.*/jcr.DbRuntimePassword=${_DBPASS}/" \
    -e "s/feedback.DbRuntimeRoleName=.*/feedback.DbRuntimeRoleName=feedback_role/" \
    -e "s/likeminds.DbRuntimeRoleName=.*/likeminds.DbRuntimeRoleName=likeminds_role/" \
    -e "s/release.DbRuntimeRoleName=.*/release.DbRuntimeRoleName=release_role/" \
    -e "s/community.DbRuntimeRoleName=.*/community.DbRuntimeRoleName=community_role/" \
    -e "s/customization.DbRuntimeRoleName=.*/customization.DbRuntimeRoleName=customization_role/" \
    -e "s/jcr.DbRuntimeRoleName=.*/jcr.DbRuntimeRoleName=jcr_role/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbdomain.properties > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbdomain.properties

# a420018: Modify ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties
if [ ! -f ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties_original ]
then
  cp ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties_original
fi

while read a;
do
  echo "$a" | sed \
    -e "s/WasPassword=.*/WasPassword=${_WASTEMPPASSWORD}/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties

# a420018: Remote Databse Server is available
# ConfigEngine.sh validate-database
${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh validate-database

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh validate-database Failed." \
    "ConfigEngine.sh validate-database Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "ConfigEngine.sh validate-database completed, start database-transfer......." \
  "ConfigEngine.sh validate-database completed, start database-transfer......." \
  $_EMAILLIST \
  $_START

# a420018: both WebServer_Portal and server1 have to be stopped
#${_WSDIR}/IBM/WebSphere/wp_profile/bin/stopServer.sh server1
${_WSDIR}/IBM/WebSphere/wp_profile/bin/stopServer.sh WebSphere_Portal

# ConfigEngine.sh database-transfer
${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh database-transfer
# a420018: the WebSphere_Portal server is still stopped after the database-transer

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh database-transfer Failed." \
    "ConfigEngine.sh database-transfer Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "ConfigEngine.sh database-transfer completed. " \
  "ConfigEngine.sh database-transfer completed. " \
  $_EMAILLIST \
  $_START

