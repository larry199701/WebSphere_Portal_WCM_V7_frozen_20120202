
###############################################################################################
# Called by each node: pdwpappqa01Node01, pdwpappqa02Node01
# Create ${_WSDIR}/IBM/WebSphere/wp_profile/PortalServer/ISALite
###############################################################################################


###############################################################################################
# Install IBM Support Assistant Lite for WebSphere Portal (ISALite)
###############################################################################################
email_notify \
  "Start to Install ISALite for Portal...." \
  "Start to Install ISALite for Portal...." \
  $_EMAILLIST \
  $_START

cp ${_CURDIR}/installwcm/lib/ISALite-Collectors-for-Portal-6.1-and-Above-v4.1.2.201009021334-UNIX.tar.gz \
  ${_WSDIR}/IBM/WebSphere/wp_profile/PortalServer

gzip -d ${_WSDIR}/IBM/WebSphere/wp_profile/PortalServer/ISALite-Collectors-for-Portal-6.1-and-Above-v4.1.2.201009021334-UNIX.tar.gz

cd ${_WSDIR}/IBM/WebSphere/wp_profile/PortalServer; \
  tar -xvf ${_WSDIR}/IBM/WebSphere/wp_profile/PortalServer/ISALite-Collectors-for-Portal-6.1-and-Above-v4.1.2.201009021334-UNIX.tar; \
  rm -f ISALite-Collectors-for-Portal-6.1-and-Above-v4.1.2.201009021334-UNIX.tar; \
  cd ${_CURDIR}

email_notify \
  "Install ISALite for Portal completed." \
  "Install ISALite for Portal completed." \
  $_EMAILLIST \
  $_START
