ssh wasadm@pdwpndqa01.advancestores.com \
    '/optware/IBM85/WebSphere/AppServer/profiles/Dmgr01/bin//wsadmin.sh \
    -conntype SOAP -port 8879 \
    -host pdwpndqa01.advancestores.com \
    -lang jython -c \
    "AdminControl.getNode()" \
    '

