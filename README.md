# DevSecOps workshop for customer 

## References for IBM DevSecOps and AIOPs products
More reference documentation and links as below

1. GitLab Ultimate for IBM Cloud Paks : https://www.ibm.com/hk-en/products/gitlab-ultimate
2. Source code of Robot Shop : https://github.com/instana/robot-shop 
3. Instana documentation : https://www.instana.com/docs/
4. SaaS free demo of Instana : https://play-with.instana.io
5. 14 days free trial of Instana : https://www.instana.com/trial/
6. Turbonomic website : https://www.turbonomic.com/

## Hand-on Lab environment
### Pre-requisite of attending this hand-on labs   

1. Workstation OS: Windows, Mac or Linux  
2. Browser : Firefox or Chrome  
3. Network : Internet Connection  
4. Workstation privilege : Change browser setting for proxy (provided in Lab) or local host file
5. IBMID (register it from https://cloud.ibm.com and send your email to chenggck@hk1.ibm.com)  

### Lab environment description 

1. One RedHat OpenShift Cluster is provisioned for the lab exercises. Each student will be assigned with one OpenShift project which will contain all the Robot Shop microservices and he/she will perform the execises within his/her project.  
2. OpenShift project naming convention : ns-{1-25}  each student will have its own project respectively. e.g. ns-6  
3. Turbonomic platform is deployed under turbonomic project on the same OCP cluster.  
4. An Instana backend server is deployed within an virtual server.
5. Access link and account name with password will be provided.    

![Alt text](./pic/enviornment.png?raw=true) 
(Watson AIOps is not included in this workshop)

## Labs for GitLab and Instana and Turbonomic
### Lab 1 : Deploy and start Robot Shop microservice  
1. Login to  Openshift Web console and input the IBMID provided in the Lab  
Open browser with URL : https://console-openshift-console.itzroks-060000f2ee-fbolfc-4b4a324f027aea19c5cbc0c3275c4656-0000.hkg02.containers.appdomain.cloud/ (Your IBMID registered in IBM Cloud https://cloud.ibm.com e.g temp2222temp@gmail.com in this lab example)  
![Alt text](./pic/ibmlogin.png?raw=true) 

2. Dasboard of RedHat OpenShift will be shown as below (Be reminded you are now logged in as OCP cluster admin and you get privilege to perform any cluster level destructive actions including destroy the whole lab. Just focus on your own OCP project please)  
![Alt text](./pic/ocpproject.png?raw=true) 

3. Start the OpenShift web terminal by click the >_ button on the top right concer of the OCP Web GUI. It may take one or several minutes for the terminal to show up.   
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
git clone https://github.com/zerospeedzero/devsecops.git
cd devsecops
./install.sh 
```
![Alt text](./pic/createappservice.png?raw=true)  

6. Ensure all of them are in Running status (it may takes around 5 minutes to download the docker images from container registry - located in gitlab and docker.io. Take an 5 minute coffee break) 
```bash
oc get pod
watch 'oc get pod'   
```
![Alt text](./pic/allpodsrunning.png?raw=true)  
Also, you is able to check the deployment status of those services via OCP Web GUI. Click "Workload"->"Deployment" and select project in combobox at the center top.  (Ensure in you are in the project e.g. ns-6)
![Alt text](./pic/deployment.png?raw=true) 

### Lab 2 : Access to Instana server and create application perspective  

1. Ensure to you have configured the browser proxy settings according to the parameters provided by the Lab. Otherwise, you are not able to access to the Instana backend server via browser (since the server is located on privated on-premise environment which require proxy server to access)

2. Login to Instana Web GUI https://instana.ibmdemo.local using admin@instana.local account with its password.         
![Alt text](./pic/instanalogin.png?raw=true) 

3. Create Application Perspective by clicking "Application" icon on left toolbar         
![Alt text](./pic/applications.png?raw=true) 

4. Click "+ Add" button located at right bottem concer and then click "+ ADD" blue button at right bottom. It will prompt an dialog "New Application Perspective". Click it.   
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
oc set env deploy/web INSTANA_EUM_REPORTING_URL="http://161.202.37.163:2999" INSTANA_EUM_KEY=<inem.key>
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

7. Open an browser and input the URL (returned from the oc get route command as the second token). You should be access to access the Robot Shop application. Ensure it is http protocol.
![Alt text](./pic/robotshopfront.png?raw=true)  
8. Register your username with password (dummy email account and password) and it will login automatically   
![Alt text](./pic/register.png?raw=true)  

9. Generate traffic for browsing catalogues for "Artifical Intelligence" and then "Ewooid". Also, click "Robot" and then "Exceptional Medical Machine" or just randamly click these pages under Categories.     
![Alt text](./pic/webtrans.png?raw=true) 
10. Give rating on any product and add one of the product into shopping cart (The purpose is to generate traffic for different microservice)  
![Alt text](./pic/rating.png?raw=true)
11. Click "Cart" link and check "Checkout" button. 
![Alt text](./pic/checkout.png?raw=true)

12. Click "Cart" link and check "Checkout" button. Optional, you may try other links like shipping and payment for traffic generation.
![Alt text](./pic/checkout.png?raw=true)

13. Go back to the website monitoring (second icon on the left toolbar). Then, click your project name. You will see EUM data on the dashboard. Optional, if time allowed, you may drill down the end-to-end transaction result on this page later.
![Alt text](./pic/websitedashboard.png?raw=true)
### Lab 4 : Application perspective monitoring  
1. Click "Application perspective" icon on the left toolbar and then your application name created in previous lab. You should be able to inspect the Application in Instana  
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

### Lab 6 : Tailer Catalog microservice using GitLab 
1. Login to GitLab server (https://gitlab.itzroks-060000f2ee-fbolfc-4b4a324f027aea19c5cbc0c3275c4656-0000.hkg02.containers.appdomain.cloud) using your account. e.g. ns-6
![Alt text](./pic/gitlablogin.png?raw=true)

2. Change the password (you may use the same current password)
![Alt text](./pic/gitlabchangepassword.png?raw=true)

3. Click "Create a project"
![Alt text](./pic/createnewproject.png?raw=true)

4. Click "Create from template"
![Alt text](./pic/createblankproject.png?raw=true)

5. Click "Use template" button next to "NodeJS Express".
![Alt text](./pic/createcataloguebutton.png?raw=true)

6. Input the project name e.g. ns-6 and make the visibility level as "Public". Then click "Create project" button
![Alt text](./pic/clonegitlink.png?raw=true)

7. Initial source code of nodejs express are created based on the template
![Alt text](./pic/nodejsexpresstemplate.png?raw=true)

8. Disable Auto DevOps enabled by click the button "Auto DevOps enabled" and uncheck "Default to Auto DevOps pipeline" checkbox
![Alt text](./pic/disabledevops1.png?raw=true)
![Alt text](./pic/disabledevops2.png?raw=true)

9. Include Instana package in package.json file. Click file "package.json" and click "Edit" button. Once the instana package is included. Click "Commit" button
```bash
"@instana/collector": "^1.132.2",
``` 
![Alt text](./pic/includeinstanapackage.png?raw=true)

10. Include "require('@instana/collector')();" at the top of bin/www file. Click edit and paste this statement and then click "Commit" button  
![Alt text](./pic/requirestatement.png?raw=true)
```bash
require('@instana/collector')();
```
11. Click "CI/CD" -> "Editor" and then click "Create new CI/CD pipeline"
![Alt text](./pic/cicdpipeline.png?raw=true)

12. Replace the content of .gitlab-ci.yml file with the following content and then click "Commit changes"
```base
# This file is a template, and might need editing before it works on your project.
# To contribute improvements to CI/CD templates, please follow the Development guide at:
# https://docs.gitlab.com/ee/development/cicd/templates.html
# This specific template is located at:
# https://gitlab.com/gitlab-org/gitlab/-/blob/master/lib/gitlab/ci/templates/Getting-Started.gitlab-ci.yml

# This is a sample GitLab CI/CD configuration file that should run without any modifications.
# It demonstrates a basic 3 stage CI/CD pipeline. Instead of real tests or scripts,
# it uses echo commands to simulate the pipeline execution.
#
# A pipeline is composed of independent jobs that run scripts, grouped into stages.
# Stages run in sequential order, but jobs within stages run in parallel.
#
# For more information, see: https://docs.gitlab.com/ee/ci/yaml/index.html#stages

variables:
  DOCKER_DRIVER: overlay2
  ROLLOUT_RESOURCE_TYPE: deployment
  DOCKER_TLS_CERTDIR: ""  # https://gitlab.com/gitlab-org/gitlab-runner/issues/4501

# stages for CICD pipeline
stages:
  - build
  - test
  - deploy
  - dast
  - performance
  
include:
  # build stage
  - template: Jobs/Build.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab/blob/master/lib/gitlab/ci/templates/Jobs/Build.gitlab-ci.yml
  # test stage
  - template: Jobs/Code-Quality.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab/blob/master/lib/gitlab/ci/templates/Jobs/Code-Quality.gitlab-ci.yml
  - template: Security/Container-Scanning.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab/blob/master/lib/gitlab/ci/templates/Security/Container-Scanning.gitlab-ci.yml
  - template: Security/SAST.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab/blob/master/lib/gitlab/ci/templates/Security/SAST.gitlab-ci.yml
  - template: Security/License-Scanning.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab/blob/master/lib/gitlab/ci/templates/Security/License-Scanning.gitlab-ci.yml
  - template: Security/Secret-Detection.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab/blob/master/lib/gitlab/ci/templates/Security/Secret-Detection.gitlab-ci.yml
  # - template: Jobs/Test.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab/blob/master/lib/gitlab/ci/templates/Jobs/Test.gitlab-ci.yml
  - template: Security/Dependency-Scanning.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab/blob/master/lib/gitlab/ci/templates/Security/Dependency-Scanning.gitlab-ci.yml
  # DAST
  - template: Security/DAST.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab/blob/master/lib/gitlab/ci/templates/Security/DAST.gitlab-ci.yml
  # Performance test 
  - template: Jobs/Browser-Performance-Testing.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab/blob/master/lib/gitlab/ci/templates/Jobs/Browser-Performance-Testing.gitlab-ci.yml

  # deploy stage

deploy-job:      # This job runs in the deploy stage.
  stage: deploy  # It only runs when *both* jobs in the test stage complete successfully.
  image: ocpcli:latest
  script:
    - echo "Deploying application..."
    - /usr/src/app/deploy.sh ${CI_PROJECT_NAME} ${CI_REGISTRY_IMAGE} ${CI_COMMIT_BRANCH} ${CI_PIPELINE_URL}
    - echo "Application successfully deployed."
```
13. Click "CI/CD" -> "Pipelines" to inspect existing pipeline is running  
![Alt text](./pic/pipelinelist.png?raw=true)

14. Click Pipeline number (e.g. #35") to check the results of the pipeline 
![Alt text](./pic/pipelineresult1.png?raw=true)
![Alt text](./pic/pipelineresult2.png?raw=true)
![Alt text](./pic/pipelineresult3.png?raw=true)
![Alt text](./pic/pipelineresult4.png?raw=true)

15. On the OpenShift terminal, execute 'oc get route' and copy the route url for ns-{1..20} and paste it (second token ns-{1..20}) to browser (http protocol). Please refresh it for several times to generate traffic to this new deploy microservice
![Alt text](./pic/nodejsexpress1.png?raw=true)
![Alt text](./pic/nodejsexpress2.png?raw=true)


16. Go to Instana Dashboard for your application perspective (e.g. ns-6). Enable last hour interval and click "Live" button. You will find ns-6 microservice is automatically detected by Instana on the topology but it is not connected with other microservices need they are not dependent.
![Alt text](./pic/instanadashboard1.png?raw=true)

17. Go OpenShift terminal and execute the following command to make ns-{1..20} as dummy payment gateway  
```bash
oc set env deploy/payment PAYMENT_GATEWAY="http://ns-{1..20}:5000"
e.g.
oc set env deploy/payment PAYMENT_GATEWAY="http://ns-6:5000"
```
![Alt text](./pic/setdummypaymentgateway.png?raw=true)

18. Wait for 5 minutes, the new topology will be discovered and refresh for active monitoring.
![Alt text](./pic/newtopology.png?raw=true)

### Lab 7 : Trigger CICD pipeline with source code checkin 
1. On the OpenShift terminal, clone the source locally  
```bash
git clone https://gitlab.itzroks-060000f2ee-fbolfc-4b4a324f027aea19c5cbc0c3275c4656-0000.hkg02.containers.appdomain.cloud/ns-{1..20}/ns-{1..20}.git
e.g.
git clone https://gitlab.itzroks-060000f2ee-fbolfc-4b4a324f027aea19c5cbc0c3275c4656-0000.hkg02.containers.appdomain.cloud/ns-6/ns-6.git
```
![Alt text](./pic/gitclone1.png?raw=true) 

2. Edit the source code for express server by vi ns-{1..20}/views/index.pug and add the string " in DevSecOps workshop" after the Welcome statement as below. Save the file and quit.     
![Alt text](./pic/gitclone2.png?raw=true) 

3. Change the current directory to /home/user/ns{1..20} and add and commit the source code and the push the change back to GitLab Server. You need to input your username (e.g. ns-6) and its password.  
```bash
cd /home/user/ns-{1..20}
pwd
git config --global user.name ns-{1..20}
git config --global user.email "ns-{1..20}@test.com"
git add .
git commit -m "Include workshop message"
git push origin master 
```     
![Alt text](./pic/gitclone3.png?raw=true) 

4. Go back to your GitLab URL https://gitlab.itzroks-060000f2ee-fbolfc-4b4a324f027aea19c5cbc0c3275c4656-0000.hkg02.containers.appdomain.cloud/. Choose your ns-{1..20} project and click "CI/CD"->"Pipelines". You will notice an Pipeline execution is triggered when the source code is checked in. 
![Alt text](./pic/gitclone4.png?raw=true) 

5. Click the latest pipeline and check all the stages are completed successfully.
![Alt text](./pic/gitclone5.png?raw=true) 

6. On the OpenShift terminal, execute 'oc get route' and copy the route url for ns-{1..20} and paste it to browser (http protocol). Notice the express service is changed to use the new version of the express server. 
![Alt text](./pic/nodejsexpress1.png?raw=true)
![Alt text](./pic/nodejsexpress3.png?raw=true)

7. Go back to Instana Dashboard. Click your application perspective (e.g. ns-6). Then, click "Dependencies". Locate to the ns-{1..20} (e.g. ns-6) and right click it and then select "Dashboard" You will notice that there is an pipeline integration marker on the dashbaord to show new version of microservice is applied and its GitLab pipeline url. Also, you will notice there is no service interruption in this version upgrade since OpenShift deployment rollingUpdate strategy is used. 
![Alt text](./pic/instana1.png?raw=true)
![Alt text](./pic/instana2.png?raw=true)
![Alt text](./pic/instana3.png?raw=true)
![Alt text](./pic/instana4.png?raw=true)

8. On the Instana Dashboard, click Time range button at the right top. Click "Releases"
![Alt text](./pic/release1.png?raw=true)

9. Copy the URL of the pipeline by mousing selecting the text in above screen on the first release. Then, open another browser tab and place the URL on the box.
![Alt text](./pic/release2.png?raw=true)

10. Click the commit hash (e.g. a22835c), it will show the change for this commit.
![Alt text](./pic/release3.png?raw=true)

### Lab 8 : Assure application performance by Turbonomic
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
# End of the Labs