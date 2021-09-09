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

6. Ensure all of them are in Running status (it may takes around 5 minutes to download the docker images from container registry - located in gitlab and docker.io. Take an 5 minute coffee break) 
```bash
oc get pod
watch 'oc get pod'   
```
![Alt text](./pic/allpodsrunning.png?raw=true)  
Also, you is able to check the deployment status of those services via OCP Web GUI
![Alt text](./pic/deployment.png?raw=true) 

### Lab 2 : Access to Instana server and create application perspective  

1. Ensure to you have configured the browser proxy settings according to the parameters provided by the Lab. Otherwise, you are not able to access to the Instana backend server via browser (since the server is located on privated on-premise environment which require proxy server to access)  
2. Login to Instana Web GUI https://instana.ibmdemo.local using admin@instana.local account with its password.         
![Alt text](./pic/instanalogin.png?raw=true) 

3. Create Application Perspective by clicking "Application" icon on left toolbar         
![Alt text](./pic/applications.png?raw=true) 

4. Click "+ Add" button located at right bottem concer and then click "+ New Application Perspective". It will prompt an dialog "New Application Perspective"   
![Alt text](./pic/newapplicationperspective.png?raw=true) 
5. Click "Switch to Advanced Mode" located right top concer.             
![Alt text](./pic/switch.png?raw=true) 

6. Provide the following information for the application perspective for your OpenShift project created in previous lab execrise. For example, ns-6 
```bash
a. Application Perspective Name : ns-{1-25}
e.g. ns-6
b. Define the Application Perspective using one or more tags. Click "Add filter" and choose Kubernetes, then Namespace and then input the OCP project name.
e.g. Kubernetes->Namespace->ns-6
c. Store Calls of Downstream Services : "All downstream services"
d. Select the Default Dashboard View : "All Calls"
```
e.g.
![Alt text](./pic/applicationsettings.png?raw=true)   
7. Click "Create" button and you will be return to the "Application" page of Instana. You should find the application perspective you have just created.  
![Alt text](./pic/applicationsummary.png?raw=true)  

### Lab 3 : Expose Robot Shop application for End User Monitoring  
1. On the Instana Dashboard, click "Websites & Mobile Apps" icon on the left toolbar.
![Alt text](./pic/websitemobileapps.png?raw=true)  
2. Click "+ Add Website" button
![Alt text](./pic/addwebsites.png?raw=true)  
3. Give its name as ns-{1..25}. e.g. ns-6. Click "Add Website" button
![Alt text](./pic/addwebsite.png?raw=true)  
4. Copy the inem.key value from the screen and leave other values as default. e.g. nFHBd5NPR223CQxPwagfSg
![Alt text](./pic/inemkey.png?raw=true)  

5. Access to the web terminal in previous setup. Assign the inum.key to web services so that browser will load with client side javascript to track end-to-end transaction for end user monitoring. Please ensure you are on the correct OpenShift project you use before. Check the web pod is restarted and in running state.    
```bash
oc project
oc set env deploy/web INSTANA_EUM_REPORTING_URL="http://169.56.149.162:2999" INSTANA_EUM_KEY=<inem.key>
watch 'oc get pod'
```
![Alt text](./pic/setinemkey.png?raw=true)   

6. Expose the web service as route for external Web Access    
```bash
oc project
oc get svc
oc expose svc web  
oc get route  
```
![Alt text](./pic/exposeroute.png?raw=true)  

7. Open an browser and input the URL (returned from the oc get route command as the second token). You should be access to access the Robot Shop application.
![Alt text](./pic/robotshopfront.png?raw=true)  
8. Register your username with password and it will login automatically   
![Alt text](./pic/register.png?raw=true)  

9. Generate traffic for browsing catalogues for "Artifical Intelligence" and then "Ewooid". Also, click "Robot" and then "Exceptional Medical Machine" or just randamly click these pages under Categories.     
![Alt text](./pic/webtrans.png?raw=true) 
10. Give rating on any product and add one of the product into shopping cart (The purpose is to generate traffic for different microservice)  
![Alt text](./pic/rating.png?raw=true)
11. Click "Cart" link and check "Checkout" button. 
![Alt text](./pic/checkout.png?raw=true)

12. Click "Cart" link and check "Checkout" button. Optional, you may try other links like shipping and payment for traffic generation.
![Alt text](./pic/checkout.png?raw=true)

13. Go back to the website monitoring. You will see EUM data on the dashboard. Optional, if time allowed, you may drill down the end-to-end transaction result on this page later.
![Alt text](./pic/websitedashboard.png?raw=true)
### Lab 4 : Application perspective monitoring  
1. Click "Application perspective" icon on the left toolbar and then your application created in previous lab. You should be able to inspect the Application in Instana  
![Alt text](./pic/example1.png?raw=true)  
2. Click "Dependencies" tab
![Alt text](./pic/example2.png?raw=true) 
3. Click "Services" tab  
![Alt text](./pic/example3.png?raw=true)  
4. Click "Analyze Calls" on above screen and you will get the services and API endpoint breakdown as below.
![Alt text](./pic/example4.png?raw=true) 
5. Click Service.Name "payment" and then click one of the "POST /pay/anonymous-xxx" API endpoint call instance. 
![Alt text](./pic/example5.png?raw=true) 
![Alt text](./pic/example6.png?raw=true) 
6. Try to navigate to catalogue service and to inpsect the data flow as below. Optional, if time allowed, you may drill down application observability and tracing results on this page later.
![Alt text](./pic/example7.png?raw=true) 

### Lab 5 : Assure application performance by Turbonomic
1. Back to the OpenShift console UI. Click "Project" and click "turbonomic"
![Alt text](./pic/turbonomicproject.png?raw=true) 
 
2. Click "Networking"->"Route". Then, click "Location" of the Turbonomic link. 
![Alt text](./pic/turbonomicroute.png?raw=true) 

3. Login to Turbonomic using provided account with password
![Alt text](./pic/turbologin.png?raw=true) 
4.  Click "Business Application" and then your application  
![Alt text](./pic/turbodashboard.png?raw=true) 
![Alt text](./pic/turboapp.png?raw=true) 
![Alt text](./pic/turboapp1.png?raw=true) 
# End of the page