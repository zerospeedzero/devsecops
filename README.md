# Skill enablement for IBM Instana and Turbonomic 

## References for IBM AIOPs products
More reference documentation and links as below

1. Source code of Robot Shop : https://github.com/instana/robot-shop 
2. Instana documentation : https://www.instana.com/docs/
3. SaaS free demo of Instana : https://play-with.instana.io
4. 14 days free trial of Instana : https://www.instana.com/trial/
5. Turbonomic website : https://www.turbonomic.com/

## Hand-on Lab environment
### Pre-requisite of attending this hand-on labs   

1. Workstation OS: Windows 10, Mac or Linux  
2. Browser : Firefox or Chrome  
3. Network : Internet Connection  
4. Workstation privilege : Change browser setting for proxy (provided in Lab)  

### Lab environment description 

1. One RedHat OpenShift Cluster is provisioned for the lab exercises. Each student will be assigned with one OpenShift project which will contain all the Robot Shop microservices and he/she will perform the execises within his/her project.  
2. OpenShift project naming convention : ns-{1-25}  each student will have its own project respectively. e.g. ns-6  
3. Turbonomic platform is deployed under turbonomic project on the same OCP cluster.  
4. An Instana backend server is deployed within an virtual server.
5. Access link and account name with password will be provided.    

## Labs for Instana and Turbonomic
### Lab 1 : Deploy and start Robot Shop microservice  
1. Login to  Openshift Web console and input the IBMID provided in the Lab  
Open browser with URL : https://console-openshift-console.ibmcloud-roks-l9coij25-4b4a324f027aea19c5cbc0c3275c4656-0000.hkg02.containers.appdomain.cloud/  (username/password will be provided in lab)  
![Alt text](./pic/ibmlogin.png?raw=true) 

2. Dasboard of RedHat OpenShift will be shown as below (Be reminded you are now logged in as OCP cluster admin and you get privilege to perform cluster level destructive actions. Just focus on your own OCP project please)  
![Alt text](./pic/ocpproject.png?raw=true) 

3. Start the OpenShift web terminate by click the >_ button on the top right concer of the OCP Web GUI.    
![Alt text](./pic/webterminal.png?raw=true)  

4. Switch to OpenShift project to contain all microservices under Robot Shop for each student. Execute the command 'oc project ns{1-20}'. Ensure you switch to an correct project and don't fix up with other students. e.g.    
```bash
oc project ns-6
oc project
```
![Alt text](./pic/createproject.png?raw=true)  

5. Execute the following steps to deploy all microservices under Robot Shop.    
```bash
oc project ns-6
cd robot-shop
pwd
./install.sh 
```
![Alt text](./pic/createappservice.png?raw=true)  

6. Ensure all of them are in Running status  
```bash
oc get pod  
```
![Alt text](./pic/allpodsrunning.png?raw=true)  
Or check the deployment status on OCP Web GUI
![Alt text](./pic/deployment.png?raw=true) 

7. Expose the web service as route for external Web Access    
```bash
oc get svc
oc expose svc web  
oc get route  
```
![Alt text](./pic/exposeroute.png?raw=true)  

8. Open an browser and input the URL (returned from the oc get route command)  
![Alt text](./pic/robotshopfront.png?raw=true)  
9. Register your username with password and it will login automatically   
![Alt text](./pic/register.png?raw=true)  

10. Generate traffic for browsing catalogues for Artifical Intelligence and Robot, Rating and adding shop cart     
![Alt text](./pic/webtrans.png?raw=true) 
![Alt text](./pic/rating.png?raw=true)
![Alt text](./pic/checkout.png?raw=true)

11. Login to Instana Web GUI https://instana.ibmdemo.local using admin account         
![Alt text](./pic/instanalogin.png?raw=true) 

12. Create Application Perspective. Click "Application" icon on left toolbar         
![Alt text](./pic/applications.png?raw=true) 

13. Create Application. Click "Add" button and then click "New Application Perspective"           
![Alt text](./pic/newapplicationperspective.png?raw=true) 
14. Click "Switch to Advanced Mode"             
![Alt text](./pic/switch.png?raw=true) 

15. Provide the following information for the application. 
```bash
a. Name : <application name>
e.g. ns-6
b. Filter : <OpenShift namespace>
e.g. Kubernetes->Namespace->ns-6
c. Store Calls of Downstream Services : "All downstream services"
d. Select the Default Dashboard View : "All Calls"
```
![Alt text](./pic/applicationsettings.png?raw=true) 

16: Wait for 3 minutes and generate some traffic on Robot - Shop applications. You should be able to inspect the Application in Instana  

![Alt text](./pic/example1.png?raw=true) 
![Alt text](./pic/example2.png?raw=true) 
![Alt text](./pic/example3.png?raw=true) 
![Alt text](./pic/example4.png?raw=true) 
![Alt text](./pic/example5.png?raw=true) 
![Alt text](./pic/example6.png?raw=true) 
![Alt text](./pic/example7.png?raw=true) 





