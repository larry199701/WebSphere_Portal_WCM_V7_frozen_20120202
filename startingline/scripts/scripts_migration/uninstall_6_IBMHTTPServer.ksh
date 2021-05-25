#!/usr/bin/ksh

#https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=5&ved=0ahUKEwjCko2O5NbSAhVGJCYKHVsEBgoQFgg0MAQ&url=ftp%3A%2F%2Fpublic.dhe.ibm.com%2Fsoftware%2Fwebserver%2Fappserv%2Flibrary%2Fv70%2FInstallGuide_v70_en.pdf&usg=AFQjCNEIo-tHAuyTNMI4V_S7eto2xhOOOg&bvm=bv.149397726,d.eWE&cad=rja

cd /optware/IBM/HTTPServer/uninstall
./uninstall -silent

lslpp -l | grep -i IHS

#/optware/IBM/HTTPServer/logs/uninstall/log.txt


