import java.lang.System as sys 
lineSeparator = sys.getProperty('line.separator') 

#--------------------------------------------------------------------------- 
# print Cell Name
#---------------------------------------------------------------------------
#print AdminControl.getCell()
cells = AdminConfig.list('Cell').split(lineSeparator)
cellName = AdminConfig.showAttribute(cells[0], 'name')
print cellName

#---------------------------------------------------------------------------
# print Cluster Names
#---------------------------------------------------------------------------
clusterIds = AdminConfig.list('ServerCluster').split(lineSeparator)

for clusterId in clusterIds:
    clusterName = AdminConfig.showAttribute(clusterId, 'name')
    print clusterName
    print 
    appNames = AdminApp.list('WebSphere:cell=' + cellName + ',cluster=' + clusterName).split(lineSeparator)

    for appName in appNames:
        print ""
        print "------------"
        print appName
        deployment = AdminConfig.getid("/Deployment:"+appName+"/")
        if (len(deployment) == 0):
            print "debug--------: No deployment "+appName
            sys.exit()

        modules = AdminApp.listModules(appName).split(lineSeparator)

        for module in modules:
            print module

#            moduleName = AdminConfig.showAttribute(module, 'uri')




'''

        print deployment
        depObjects = AdminConfig.showAttribute(deployment, 'deployedObject')
        print depObjects



#        modules = AdminConfig.showAttribute(depObjects, 'modules').split(lineSeparator)
#        modules = AdminConfig.showAttribute(depObjectRef, 'modules')

#        print modules



        opt = '-cluster ' + clusterName
        moduleIds = AdminApp.listModules(appName, opt).split(lineSeparator)
        print moduleIds


            print moduleName
#             print moduleId
#print AdminApp.listModules('ivtApp').split(lineSeparator)
'''











