###############################################################################################
#  Oracle Database Configuration...  Create Configure users    DbName: eppdev, Instance: eppdev1, Host:pdoradevcla-scan
###############################################################################################


mkdir -p ${_WSDIR}/IBM/WebSphere/wp_profile/PortalServer/dbdrivers/oracle/jdbc/lib/
cp ${_INTENDEDDIR}/installwcm/lib/ojdbc6.jar ${_WSDIR}/IBM/WebSphere/wp_profile/PortalServer/dbdrivers/oracle/jdbc/lib/

# Modify ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbtype.properties
while read a;
do
  echo "$a" | sed \
    -e "s/oracle.DbDriver=.*/oracle.DbDriver=oracle.jdbc.OracleDriver/" \
    -e "s,oracle.DbLibrary=.*,oracle.DbLibrary=${_WSDIR}/IBM/WebSphere/wp_profile/PortalServer/dbdrivers/oracle/jdbc/lib/ojdbc6.jar," \
    -e "s/oracle.JdbcProviderName=.*/oracle.JdbcProviderName=wpdbJDBC_oracle/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbtype.properties > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbtype.properties

# Modify ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbdomain.properties
while read a;
do
  echo "$a" | sed \
    -e "s/feedback.DbType=.*/feedback.DbType=oracle/" \
    -e "s/likeminds.DbType=.*/likeminds.DbType=oracle/" \
    -e "s/release.DbType=.*/release.DbType=oracle/" \
    -e "s/community.DbType=.*/community.DbType=oracle/" \
    -e "s/customization.DbType=.*/customization.DbType=oracle/" \
    -e "s/jcr.DbType=.*/jcr.DbType=oracle/" \
    -e "s/feedback.DbName=.*/feedback.DbName=eppdev/" \
    -e "s/likeminds.DbName=.*/likeminds.DbName=eppdev/" \
    -e "s/release.DbName=.*/release.DbName=eppdev/" \
    -e "s/community.DbName=.*/community.DbName=eppdev/" \
    -e "s/customization.DbName=.*/customization.DbName=eppdev/" \
    -e "s/jcr.DbName=.*/jcr.DbName=eppdev/" \
    -e "s/feedback.DbSchema=.*/feedback.DbSchema=feedback/" \
    -e "s/likeminds.DbSchema=.*/likeminds.DbSchema=likeminds/" \
    -e "s/release.DbSchema=.*/release.DbSchema=release/" \
    -e "s/community.DbSchema=.*/community.DbSchema=community/" \
    -e "s/customization.DbSchema=.*/customization.DbSchema=customization/" \
    -e "s/jcr.DbSchema=.*/jcr.DbSchema=jcr/" \
    -e "s/feedback.DataSourceName=.*/feedback.DataSourceName=feedbackDTS/" \
    -e "s/likeminds.DataSourceName=.*/likeminds.DataSourceName=likemindsDTS/" \
    -e "s/release.DataSourceName=.*/release.DataSourceName=releaseDTS/" \
    -e "s/community.DataSourceName=.*/community.DataSourceName=communityDTS/" \
    -e "s/customization.DataSourceName=.*/customization.DataSourceName=customizationDTS/" \
    -e "s/jcr.DataSourceName=.*/jcr.DataSourceName=jcrDTS/" \
    -e "s/feedback.DbUrl=.*/feedback.DbUrl=jdbc:oracle:thin:@pdoradevcla-scan:1521:eppdev1/" \
    -e "s/likeminds.DbUrl=.*/likeminds.DbUrl=jdbc:oracle:thin:@pdoradevcla-scan:1521:eppdev1/" \
    -e "s/release.DbUrl=.*/release.DbUrl=jdbc:oracle:thin:@pdoradevcla-scan:1521:eppdev1/" \
    -e "s/community.DbUrl=.*/community.DbUrl=jdbc:oracle:thin:@pdoradevcla-scan:1521:eppdev1/" \
    -e "s/customization.DbUrl=.*/customization.DbUrl=jdbc:oracle:thin:@pdoradevcla-scan:1521:eppdev1/" \
    -e "s/jcr.DbUrl=.*/jcr.DbUrl=jdbc:oracle:thin:@pdoradevcla-scan:1521:eppdev1/" \
    -e "s/feedback.DbUser=.*/feedback.DbUser=feedback/" \
    -e "s/likeminds.DbUser=.*/likeminds.DbUser=likeminds/" \
    -e "s/release.DbUser=.*/release.DbUser=release/" \
    -e "s/community.DbUser=.*/community.DbUser=community/" \
    -e "s/customization.DbUser=.*/customization.DbUser=customization/" \
    -e "s/jcr.DbUser=.*/jcr.DbUser=jcr/" \
    -e "s/feedback.DbPassword=.*/feedback.DbPassword=FEEDBACK#1/" \
    -e "s/likeminds.DbPassword=.*/likeminds.DbPassword=LIKEMINDS#1/" \
    -e "s/release.DbPassword=.*/release.DbPassword=RELEASE#1/" \
    -e "s/community.DbPassword=.*/community.DbPassword=COMMUNITY#1/" \
    -e "s/customization.DbPassword=.*/customization.DbPassword=CUSTOMIZATION#1/" \
    -e "s/jcr.DbPassword=.*/jcr.DbPassword=JCR#1/" \
    -e "s/feedback.DbConfigRoleName=.*/feedback.DbConfigRoleName=feedback_role/" \
    -e "s/likeminds.DbConfigRoleName=.*/likeminds.DbConfigRoleName=likeminds_role/" \
    -e "s/release.DbConfigRoleName=.*/release.DbConfigRoleName=release_role/" \
    -e "s/community.DbConfigRoleName=.*/community.DbConfigRoleName=community_role/" \
    -e "s/customization.DbConfigRoleName=.*/customization.DbConfigRoleName=customization_role/" \
    -e "s/jcr.DbConfigRoleName=.*/jcr.DbConfigRoleName=jcr_role/" \
    -e "s/feedback.DbRuntimeUser=.*/feedback.DbRuntimeUser=/" \
    -e "s/likeminds.DbRuntimeUser=.*/likeminds.DbRuntimeUser=/" \
    -e "s/release.DbRuntimeUser=.*/release.DbRuntimeUser=/" \
    -e "s/community.DbRuntimeUser=.*/community.DbRuntimeUser=/" \
    -e "s/customization.DbRuntimeUser=.*/customization.DbRuntimeUser=/" \
    -e "s/jcr.DbRuntimeUser=.*/jcr.DbRuntimeUser=/" \
    -e "s/feedback.DbRuntimePassword=.*/feedback.DbRuntimePassword=/" \
    -e "s/likeminds.DbRuntimePassword=.*/likeminds.DbRuntimePassword=/" \
    -e "s/release.DbRuntimePassword=.*/release.DbRuntimePassword=/" \
    -e "s/community.DbRuntimePassword=.*/community.DbRuntimePassword=/" \
    -e "s/customization.DbRuntimePassword=.*/customization.DbRuntimePassword=/" \
    -e "s/jcr.DbRuntimePassword=.*/jcr.DbRuntimePassword=/" \
    -e "s/feedback.DbRuntimeRoleName=.*/feedback.DbRuntimeRoleName=/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbdomain.properties > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc_dbdomain.properties

# Modify ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties
while read a;
do
  echo "$a" | sed \
    -e "s/WasPassword=.*/WasPassword=yesiam/"
done  < ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties > /tmp/mytmpfile.props
mv /tmp/mytmpfile.props ${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/properties/wkplc.properties


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
  "ConfigEngine.sh validate-database completed, database-transfer......." \
  "ConfigEngine.sh validate-database completed, database-transfer......." \
  $_EMAILLIST \
  $_START

#${_WSDIR}/IBM/WebSphere/wp_profile/bin/stopServer.sh server1
${_WSDIR}/IBM/WebSphere/wp_profile/bin/stopServer.sh WebSphere_Portal

# ConfigEngine.sh database-transfer
${_WSDIR}/IBM/WebSphere/wp_profile/ConfigEngine/ConfigEngine.sh database-transfer

if [[ $? != 0 ]] then
  email_notify \
    "ConfigEngine.sh database-transfer Failed." \
    "ConfigEngine.sh database-transfer Failed." \
    $_EMAILLIST \
    $_START
  exit 1
fi

email_notify \
  "ConfigEngine.sh database-transfer completed. startServer.sh WebSphere_Portal..." \
  "ConfigEngine.sh database-transfer completed. startServer.sh WebSphere_Portal..." \
  $_EMAILLIST \
  $_START

