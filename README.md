# Skill enablement for Partner on IBM Instana

## References
1. Source code of Robot Shop : https://github.com/instana/robot-shop
2. Instana documentation : https://www.instana.com/docs/
3. SaaS free demo : https://play-with.instana.io
4. 14 days free trial : https://www.instana.com/trial/

## Setup Lab environment
1. Pre-requisite   
Workstation OS: Windows 10, Mac and Linux  
Browser : Firefox and Chrome 
Network : Internet Connection  
Workstation privilege : Change browser setting for proxy (provided in Lab)  
OpenShift namespaces : ns-{1..10}  
OpenShift Username : user{1-20}  
OpenShift user to namespace mapping : user{*x} is belongs to ns-{x}  
Users in the same projects need to co-operate to perform these lab execrises  

## Labs for skill enablement    
1. Login to  Openshift Web console  
Open browser with URL : https://console-openshift-console.apps.ocp.local  
![Alt text](./pic/ocpwebgui.png?raw=true) 

2. Login with htpasswd method with your username (e.g. user21)  
![Alt text](./pic/ocplogin.png?raw=true) 


3. Project page will be shown for that user (e.g. ns-1)  
![Alt text](./pic/ocpproject.png?raw=true) 
4. Click the project link to set the user using this project  
![Alt text](./pic/clickproject.png?raw=true) 

5. Nagaviate to other menu such as "Workloads"->"Pod" and "Networking"->"Services". There should be no Kubernetes resources defined.  

6. Start the OpenShift web terminate by click the >_ button on the top right concer of the OCP Web GUI    
![Alt text](./pic/webterminal.png?raw=true)  

7. Inside the terminal, download the Kubernetes YAML files for these labs  

```bash
git clone https://github.com/GeorgeCKCheng/robot-shop
```
![Alt text](./pic/gitclone.png?raw=true)  

8. Discuss with your teammates within the same project on who will deploy which microservices within the same project.
e.g. user21 will deploy services : cart, catalogue, dispatch, load, mongo and payment while user1 will deploy services : rabbotmq, ratings, redis, shipping, user and web. Ensure the service is on running status    
```bash
cd robot-shop
oc apply -f <microservices>
e.g. oc apply -f cart
oc get pod
```
![Alt text](./pic/cart.png?raw=true)  

9. Repeat the above step 8 for all the microservices and to ensure all of them are in Running status  
```bash
oc get pod  
```
![Alt text](./pic/allpodsrunning.png?raw=true)  
Or check the deployment status on OCP Web GUI
![Alt text](./pic/deployment.png?raw=true) 

10. Expose the web service as route for external Web Access    
```bash
oc expose svc web  
oc get route  
```
![Alt text](./pic/exposeroute.png?raw=true)  

11. Open an browser and input the URL (returned from the oc get route command)  
![Alt text](./pic/robotshopfront.png?raw=true)  
12. Register your username with password and it will login automatically   
![Alt text](./pic/register.png?raw=true)  

13. Generate traffic for browsing catalogues for Artifical Intelligence and Robot, Rating and adding shop cart     
![Alt text](./pic/webtrans.png?raw=true) 
![Alt text](./pic/rating.png?raw=true)
![Alt text](./pic/checkout.png?raw=true)

14. Login to Instana Web GUI https://instana.ibmdemo.local using admin account         
![Alt text](./pic/instanalogin.png?raw=true) 

15. Create Application Perspective. Create "Application" icon on left toolbar         
![Alt text](./pic/applications.png?raw=true) 

16. Create Application. Click "New Application Perspective" and then click "Next"           
![Alt text](./pic/newapplicationperspective.png?raw=true) 
17. Click "Switch to Advanced Mode"             
![Alt text](./pic/newapplicationperspective.png?raw=true) 

18. Provide the following information for the application
```bash
a. Name : <application name>
e.g. user21
b. Filter : <OpenShift namespace>
e.g. ns-1
c. Store Calls of Downstream Services : "All downstream services"
d. Select the Default Dashboard View : "All Calls"
```
![Alt text](./pic/applicationsettings.png?raw=true) 

19: Wait for 3 minutes and generate some traffic on Robot - Shop applications. You should be able to inspect the Application in Instana  

![Alt text](./pic/example1.png?raw=true) 
![Alt text](./pic/example2.png?raw=true) 
![Alt text](./pic/example3.png?raw=true) 
![Alt text](./pic/example4.png?raw=true) 
![Alt text](./pic/example5.png?raw=true) 
![Alt text](./pic/example6.png?raw=true) 
![Alt text](./pic/example7.png?raw=true) 





