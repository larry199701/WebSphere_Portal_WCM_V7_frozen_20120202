############################################################################################
# 3. create ${_IHSDIR}/IBM/HTTPServer/bin/20111012_portal_https_KeyDb.kdb
############################################################################################

mkdir -p ${_IHSDIR}/IBM/HTTPServer/certs

_KDBPW=secportal#1

# create a .kdb file
${_IHSDIR}/IBM/HTTPServer/bin/gsk7cmd \
  -keydb \
  -create \
  -db ${_IHSDIR}/IBM/HTTPServer/certs/20111116_portalqa_https_KeyDb.kdb \
  -pw ${_KDBPW} \
  -type cms \
  -expire 3650 \
  -stash

# create a self-signed certificate:
${_IHSDIR}/IBM/HTTPServer/bin/gsk7cmd \
  -cert \
  -create \
  -db ${_IHSDIR}/IBM/HTTPServer/certs/20111116_portalqa_https_KeyDb.kdb \
  -pw ${_KDBPW} \
  -size 2048 \
  -dn "CN=portalqa.advancestores.com,O=AAP,OU='IBM HTTP Server',L=Roanoke,ST=VA,C=US" \
  -label portalqa_self_signed \
  -default_cert yes
  -expire 3650

# create new pair of certificate request:
${_IHSDIR}/IBM/HTTPServer/bin/gsk7cmd \
  -certreq \
  -create \
  -db ${_IHSDIR}/IBM/HTTPServer/certs/20111116_portalqa_https_KeyDb.kdb \
  -pw ${_KDBPW} \
  -label portalqa_advancestores_com \
  -dn "CN=portalqa.advancestores.com,O=AAP,OU='IBM HTTP Server',L=Roanoke,ST=VA,C=US" \
  -size 2048 \
  -file ${_IHSDIR}/IBM/HTTPServer/certs/20111116_portalqa_advancestores_com.arm

# inport the CA certificate: entrustRoot.crt
${_IHSDIR}/IBM/HTTPServer/bin/gsk7cmd \
  -cert \
  -add \
  -db ${_IHSDIR}/IBM/HTTPServer/certs/20111116_portalqa_https_KeyDb.kdb \
  -pw ${_KDBPW} \
  -label entrustRoot_crt \
  -format ascii \
  -trust enable \
  -file ${_IHSDIR}/IBM/HTTPServer/certs/20111116_entrustRoot.crt

# inport the CA entrustRootChain.crt
${_IHSDIR}/IBM/HTTPServer/bin/gsk7cmd \
  -cert \
  -add \
  -db ${_IHSDIR}/IBM/HTTPServer/certs/20111116_portalqa_https_KeyDb.kdb \
  -pw ${_KDBPW} \
  -label entrustRootChain_crt \
  -format ascii \
  -trust enable \
  -file ${_IHSDIR}/IBM/HTTPServer/certs/20111116_entrustRootChain.crt

#Receive the CA-signed certificate into a key database
${_IHSDIR}/IBM/HTTPServer/bin/gsk7cmd \
  -cert \
  -receive \
  -file ${_IHSDIR}/IBM/HTTPServer/certs/20111116_entrustCert_portalqa_advancestores_com.crt \
  -db ${_IHSDIR}/IBM/HTTPServer/certs/20111116_portalqa_https_KeyDb.kdb \
  -pw ${_KDBPW} \
  -format ascii \
  -default_cert yes




# create KeyDb.kdb
java com.ibm.gsk.ikeyman.ikeycmd \
  -keydb \
  -create \
  -db ${_IHSDIR}/IBM/HTTPServer/certs/20111112_portalqa_https_KeyDb.kdb \
  -pw secportal#1 \
  -type cms \
  -expire 3650 \
  -stash

# create a self-signed certificate
java com.ibm.gsk.ikeyman.ikeycmd \
  -cert \
  -create \
  -db ${_IHSDIR}/IBM/HTTPServer/certs/20111112_portalqa_https_KeyDb.kdb \
  -pw secportal#1 \
  -size 2048 \
  -dn "CN=portaldev.advancestores.com,O=AAP,OU=IBM HTTP Server,L=Roanoke,ST=VA,C=US" \
  -label portaldev_self_signed \
  -default_cert yes

## create a csr
#java com.ibm.gsk.ikeyman.ikeycmd -certreq -create -db ${_IHSDIR}/IBM/HTTPServer/certs/20111112_portalqa_https_KeyDb.kdb -pw secportal#1 -size 2048 -dn
"CN=portalqa.advancestores.com,O=AAP,OU=IBM HTTP Server,L=Roanoke,ST=VA,C=US" -file ${_IHSDIR}/IBM/HTTPServer/certs/20111112_portalqa_advancestores_com.
arm -label portalqa_advancestores_com -type cms


##Storing a CA certificate
#java com.ibm.gsk.ikeyman.ikeycmd -cert -add -db your_install_directory\bin\HODServerKeyDb.kdb -pw <password> -label <label> -format <ascii | binary> -trust <enable |disable> -file <file>

## Receiving a CA-signed certificate
#java com.ibm.gsk.ikeyman.ikeycmd -cert -receive -file <filename> -db your_install_directory\bin\HODServerKeyDb.kdb -pw <password> -format <ascii | binary> -default_cert <yes | no>

## list certificate requests:
#java com.ibm.gsk.ikeyman.ikeycmd -certreq -list -db ${_IHSDIR}/IBM/HTTPServer/certs/20111019_portal_https_KeyDb.kdb -pw secportal#1

## list certificate
#java com.ibm.gsk.ikeyman.ikeycmd -cert -list CA -db ${_IHSDIR}/IBM/HTTPServer/certs/20111019_portal_https_KeyDb.kdb -pw secportal#1 -type cms

## list self-signed certificates:
#java com.ibm.gsk.ikeyman.ikeycmd -cert -list personal -db ${_IHSDIR}/IBM/HTTPServer/bin/testKeyDb.kdb -pw test#2 -type cms

## change password
#java com.ibm.gsk.ikeyman.ikeycmd -keydb -changepw -db ${_IHSDIR}/IBM/HTTPServer/bin/testKeyDb.kdb -pw test#1 -new_pw test#2 -expire 3650 -stash

## list self-signed certificates:
#java com.ibm.gsk.ikeyman.ikeycmd -cert -list personal -db ${_IHSDIR}/IBM/HTTPServer/bin/testKeyDb.kdb -pw test#2 -type cms

## getdefault
#java com.ibm.gsk.ikeyman.ikeycmd -cert -getdefault -db ${_IHSDIR}/IBM/HTTPServer/certs/20111019_portal_https_KeyDb.kdb -pw secportal#1

## delete a self-signed certificate:
#java com.ibm.gsk.ikeyman.ikeycmd -cert -delete -db ${_IHSDIR}/IBM/HTTPServer/bin/testKeyDb.kdb -pw test#2 -label gm_pihms_com1


