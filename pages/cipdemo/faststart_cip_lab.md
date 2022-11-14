---
title: FastStart 2019 Lab - CIP 
toc: false
sidebar: labs_sidebar
folder: pots/cipdemo
permalink: /cip-demo-lab.html
summary: Deeper dive into the Cloud Integration Platform
applies_to: [developer,administrator,consumer]
---

# Mastering the Cloud Integration Platform
===============

## Overview

During the CIP Bootcamp, you had the opportunity to get some hands on with the CIP Platform.  This exercise here is to provide you some more hands on with the platform and build your skills with the platform with the goal of creating a demo environment everyone is able to build and use on their own.

This lab guide will lay out the scenario for you, along with the requirements of what you are to complete.  This guide is different than other labs, such that it will (for the most part) not be a step by step walkthrough of what to complete, rather will give you a list of requirements to complete, and it is up to you and your team to deliver on those.

This lab will be a team effort.  It is highly suggested that you form your teams of folks who can cover the entire I&D Portfolio - especially: App Connect Enterprise (using Toolkit), API Connect, Messaging (MQ and ES).  Its helpful also to have someone who knows `kubectl` and `docker` commands and has some background with ICP. 

Lab Overview
-------------------------------------------

You will be building a demo environment that supports the "AcmeMart" demo scenario.  There are several components that make up this demo, but the key areas in scope for this lab are as follows:

* 	Two App Connect Enterprise flows that interact with IBM Cloud based APIs
*  AcmeMart Node.js based APIs
*  On-premises based MQ and ES based assets
*  API Facades for RESTful assets to be created in API Connect

All assets created are to be implemented on the given CIP environment provided for you.  All pre-requisites and utilities should be on the environments provided.  If there are other utilities and tools you would like to use to support you during this exercise, you may do so at your own risk.


Lab Environment Overview 
-------------------------------------------

You have been provided a pre-installed environment of the Cloud Integration Platform with the base charts for CIP already deployed and configured.  This includes specifically:

* ICP Main Portal running on `https://10.0.0.1:8443`
* CIP Platform Navigator running on: `https://10.0.0.5/icip1-navigator1`

You should be able to access all portals from the Platform Navigator, but if you need to access the URL directly, they are provided below:

* App Connect Enterprise Manager Portal running on `https://ace.10.0.0.5.nip.io/ace-ace`
* API Connect API Manager Portal on `https://mgmt.10.0.0.5.nip.io/manager`
* MQ Portal on `https://10.0.0.5:31694/ibmmq/console/`
* Event Streams on `https://10.0.0.5:32208/gettingstarted?integration=1.0.0`

**Note**: there are some known certificate issues with the various portals on this environment. These are fairly easy to workaround, and will be fixed in a later release of this demo environment.

2. The environment you are using is the same environment used with the CIP Bootcamp.  It consists of 9 different nodes.  8 of which are ICP Nodes and one is a developer image that you will be using to access the ICP User Interfaces.  You can access this VM directly using the Skytap interface to use the X-Windows based components. The biggest difference with this environment vs what you used at the bootcamp is that all of the base CIP Charts are already installed and configured. 

3. **VERY IMPORTANT** It is very important you do not suspend your lab environment.  We have seen cases when the environment goes into suspend mode, the Rook-Ceph shared storage gets corrupted.  Also it is a good practice that you shut down ICP before powering down your enviroment.  A script has been included to handle that for you that will be explained in the coming sections.  When you power down your environment, you can safely use the `power off` option as the shared storage can interfere with the normal graceful shutdown method.  So far using power off hasn't caused any problems that we are aware of.  If you find that your API Connect environments are not coming up properly, it suggested that you run the `./icpStopStart.sh stop` script (you may need to run it more than once).  When it stops, go ahead and run the `./icpStopStart.sh start`.  As indicated previously, this may take ~30 minutes or so to come up.  

3. You are also able to SSH into your environment.  You can find out the exact address to SSH to in your Skytap Environment window under `networking` and `published services`.  The Published Services set up for you will be for the SSH Port (22) under the `CIP Master` node.  The published service will look something like `services-uscentral.skytap.com:10000`.  Your environment will have a different port on it.  You can then SSH to to the machine from your local machine.  

4. Additionally, you can access the machine direct via the Skytap UI.  This is functional, but can be cumbersome to work with as its not easy to copy and paste into and out of Skytap, especially for the non X-Windows based environments. 
 
5. Password-less SSH has also been enabled between the Master node and the other nodes in the environment.  **note** a table with the environment configuration is provided below.  Credentials for each machine are `root`/`Passw0rd!`.   

| VM        | Hostname  | IP Address | # of CPU | RAM    | Disk Space (LOCAL) | Shared Storage | Additional Notes |
|-----------|-----------|------------|----------|--------|--------------------|----------------|------------------|
| Master    | master    | 10.0.0.1   | 12       | 32 GB  | 400 GB             | N/A            |                  |
| Proxy     | proxy     | 10.0.0.5   | 4        | 8 GB   | 20 GB              | N/A            |                  |
| Worker 1  | worker-1  | 10.0.0.2   | 8        | 16 GB  | 400 GB             | Monitor  | Ceph Master      |
| Worker 2  | worker-2  | 10.0.0.3   | 8        | 16 GB  | 400 GB             | 			  | 		           |
| Worker 3  | worker-3  | 10.0.0.4   | 8        | 16 GB  | 400 GB             | 			  | 		            |
| Worker 4  | worker-4  | 10.0.0.7   | 8        | 16 GB  | 400 GB             |                |                  |
| Worker 5  | worker-5  | 10.0.0.8   | 8        | 16 GB  | 400 GB             | Ceph OSD1               |                  |
| Worker 6  | worker-6  | 10.0.0.9   | 8        | 16 GB  | 400 GB             | Ceph OSD2               |                  |
| Developer | developer | 10.0.0.6   |          |        |                    |                |                  |


6. If it is not done already, power up your Environment.  It could take about 5 minutes for all nodes to start up.  The master node takes the longest to come up, so if you can see the login prompt from the Skytap UI on the master node, then you are good to go. 

7. SSH into the Master Node or use the Skytap UI.  In the home directory of root (`/root`) there is a script called `icpStopStart.sh`.  Run this script by typing in `./icpStopStart.sh start` Note that it takes around 30 minutes for the ICP Services to come up completely.

8. You can tell if the start of ICP is complete by checking using one of these two methods:
	- Click on the Developer Machine, and it will take you directly to the Developer Machine running X-Windows.  Should you need to Authenticate, you can use the credentials of `student`/`Passw0rd!`. Bring up the Firefox browser.  Navigate to the main ICP UI by going to `https://10.0.0.1:8443`.  The credentials again are `admin/admin`.  If you can log in and see the main ICP Dashboard, you are good to go.  
	- Alternatively, you can SSH to the Master node.  Execute a `cloudctl login` from the command line.  If all there services are up, it will prompt you for credentials (use `admin`/`admin`) and setup your kubernetes environment.
8. The best place to do your Kubernetes CLI work is from the Master node.  Again, Before you can execute any of the `kubectl` commands you will need to execute a `cloudctl login`. 
9. Next step is to find The Platform Navigator UI can be use to create and manage instances of all of the components that make up the Cloud Integration Platform. 
10. You can access the Platform Navigator using the browser on the developer machine.  The URL for the navigator was set up in this environment as: `https://10.0.0.5/icip1-navigator1`.  You might be asked to authenticate into ICP again, but once you do that you should now see the Platform Navigator page.
11. The Platform Navigator is designed for you to easily keep track of your integration toolset.  Here you can see all of the various APIC, Event Streams, MQ and ACE instances you have running.  You can also add new instances using the Platform Navigator.


### Key Concepts - Troubleshooting / Recovery

There are times where things may not be going right, so your best bet is to use `kubectl` commands to uncover more information about what is going on.  If you post queries in Slack about trouble with the lab, we will be asking you to execute a series of these, depending upon what you were doing, and what error occured.  A list of useful commands are provided below:

 - `kubectl get pods -n <some-namespace>` This command shows all of the pods in a given name space.  Here you will see if any pods are up, down, errored or otherwise in transition.
 - `kubectl describe pods <some-pod> -n <some-namespace>` This will provide verbose information about a given pod.  You can use the `describe` command for other objects.
 - `kubectl logs <some-object> -n <some-namespace>` This command will work with other objects as well.  You can also tail the logs by using the `-f` switch at the end.
 
 Logging is also done inside of ICP using the ELK stack.  You can access the logging inside of ICP and use Elastic Search commands to drill into things.  For example, if you were to bring up Kibana and enter in a search like `kubernetes.namespace:<your namespace>`.  Using this along with the `kubectl` commands gives you a lot of power to dig into root cause.
 

Lab Requirements 
-------------------------------------------

## ACE Integration Assets 

1. Your integration assets are found in this repository: `https://github.com/ibm-cloudintegration/techguides`.  You can find the specific files you need in the `/techguides/pages/cipdemo` directory.  
    >**hint:** clone this on your Developer machine so you don't have to copy the files over.
2. Below is a description of each of the files in archive that you should take note of (disregard the others).

| File                           | Description                                                                                      |
|--------------------------------|--------------------------------------------------------------------------------------------------|
| faststartflows.zip             | ACE Project Interchange export of integration flows|
| inventoryproject.generated.bar | generated bar file for the Inventory API.  You will be deploying this as is into the environment|
| orderproject.generated.bar     | original bar file for order API. Disregard this, you will be generating a new bar file to deploy|

  >keep the project interchange zip file handy, you will be loading that up into the toolkit in a later section. 


## AcmeMart Microservices

You will need to download the AcmeMart microservices and deploy the containers on ICP.  


1. Access the `master` node via SSH session.  Make a new directory in the root home directory, call it whatever you like.  Change directories into that.
2. Once in that new directory, clone this repository here on the `master` node:  `https://github.com/asimX/FS-CIP-Microservices`.  The reason we do this on the master node because we need to load the docker images into ICP.  You might need to authenticate using your github.com account.  If you don't have one, you can sign up for your free one here at `github.com`
3. Go into the FS-CIP-Microservices directory.  Also, now is a good time to make sure you are logged into your ICP environment - execute a `cloudctl login` using the `admin`/`admin` credentials.  Make sure you are in the `default` name space.
4. Execute docker login into the ICP.
   >`docker login mycluster.icp:8500`  
   >**username:** admin  
   >**password:** admin
5. Run this command:  `docker build . -t acmemartutilityapi`.  The image and its dependencies will be downloaded.
6. In the ICP UI, starting from the top left hamburger icon select `Manage` -> `Namespaces`.  Create a new namespace and call it `acmemartapi`.  Using the `ibm-anyuid-hostpath-psp` security policy is fine for this one.
7. Tag your new image by running this command:  `docker tag acmemartutilityapi mycluster.icp:8500/acmemartapi/acmemartutilityapi:v1.0.0`
8. Push the docker image out to your ICP instance by issuing this command `docker push mycluster.icp:8500/acmemartapi/acmemartutilityapi:v1.0.0`.
10. Next step is to deploy the microservices into ICP.  Create a new Deployment in ICP using the UI via Hamburger Icon in top left. Go to `Workloads -> Deployments`.  Click `+Create Deployment`.
11. In the `General` tab.  Give it a name of `acmemart`.  Select the new namespace created previous via the dropdown (`acmemartapi`). Leave Replicas at `1`.
12. Go to `Container Settings`.  Set the name to `acmemartutility`.  Set the `Image` value to `mycluster.icp:8500/acmemartapi/acmemartutilityapi:v1.0.0`

	![](./images/cipdemo/deployment2.gif)

12. In the same tab, scroll down to where the TCP ports are.  We need to open up a few ports on this image such that it can interact with all components.  Set the ports to the following

	- TCP - 3000
	- TCP - 9093
	- TCP - 443

13. Click `Create`.  The new pod should be created very quickly.  You click on your release and view the results in the UI. 
    >**Note** you will not see a `Launch` button like you see in the screenshot until you complete the Service in the next section.

	![](./images/cipdemo/deployment_done.gif)
	
14. Once you see the Pod up, the next step is to bind a Network service that can be associated with the Pod.
15. From the Hamburger menu on top left go to `Network Services` -> `Services`.
16. Create a New Service.  Call it `acmemartapp`.
17. Select the proper namespace - `acmemartapi`
18. Under `Type` select from the dropdown `NodePort`

	![](./images/cipdemo/service3.gif)

19. Under the `Labels` tab set the Label to `app` and value to `acmemart`.
20. Under the `Ports` tab. Create 3 ports per the chart below:

    | Protocol  | Name         | Port | Target Port |
    |-----------|--------------|------|-------------|
    | TCP       | app          | 3000 | 3000        |
    | TCP       | eventstreams | 9093 | 9093        |
    | TCP       | kafka        | 443  | 443         |


21. Ports should look like the following when done:

	![](./images/cipdemo/serviceports.gif)

22. Under the `Selectors` tab.  Set the `Selector` to `app` and the Value to `acmemart`.
23. Click Create and the service should create quickly. 
24. You will know the Service was generated properly when you return back to your deployment, and you see the `Launch` button in the upper right hand corner.  

	![](./images/cipdemo/service_deployment_done_launch.gif)

25. Click the Launch button and from the dropdown, select the `app` button and it should launch the main portal for the AcmeMartUtils. If so, then your microservices for the demo has deployed successfully. 
26. The AcmeMart microservices comes with its own swagger based developer documentation.  From the main App screen, click on the `Developer Docs`.

	![](./images/cipdemo/acmemart.gif)

27. There are 3 categories of APIs here.  Click on the `Utility` apis.  From the list Select, the `GET /Utilities/ping` option
28. Find the `try it out` button.  Click it.  It should return back the date/time.

	![](./images/cipdemo/pingtest.gif)

## Modify the Order ACE Flow

Import the project interchange provided in the `faststartflows.zip` file.  You can find this file in the `/home/student/techguides/pages/cipdemo` folder

You can start up the Ace toolkit using `sudo`. e.g. `sudo ./ace toolkit` 

Modify the `Order` flow by adding the following additional operations. 

After the App Connect REST operation you will be adding three operations.  One that will strip the HTTP Headers, another that will put to a MQ queue, and third that will put to a Queue that will be transfered to EventStreams (simulated).    

Here is what the flow will look like.  Instructions to follow
 
 ![](./images/cipdemo/ace1.png)

1. Add `Http Header` operation from the ACE palette and then under properties set it to Delete http header.

 ![](./images/cipdemo/ace2.png)
   
2. Add 2 `MQ Output` nodes. 
3. At the first `MQ Output`, go to Basic and type the queue name: `NEWORDER.ES` (case sensitive). The messages will sent to Event Streams (simulated).
4. Click on MQ Connection and select MQ client connection properties 
	- Type Destination queue manager name: `QMGR.DEV` (case sensitive)
	- Type Queue Manager host name: `10.0.0.1`
	- Type channel name: `ACE.TO.ES`	
	- Type Listener: `31200`
	>**Note** You check the listener port, on Helm Repositores -->  mq `console-https`

  ![](./images/cipdemo/ace2-2.png)

 MQ Node (NEWORDER.ES):
	 
  ![](./images/cipdemo/ace2-3.png)

5. For the second `MQ Output` click `MQ Connection` and select `Local queue manager` (ACE Server will create a local queue manager for you). 
6. Type Destination queue manager name: `acemqserver` (case sensitive).

  ![](./images/cipdemo/ace3.png)

7. Click `Basic`. Type Queue name: `NEWORDER.MQ`. 
8. `Save your flow`.
9. Create a BAR (Broker Archive) file. Give it the Name: `orders` and click `Finish`.

## Connecting ACE to a remote MQ on ICP
 
1. Open MQ Console on `mq` Helm Repositories
2. Click `mq-console-https 31694/TCP`
3. Click Queue Manager name: `QMGR.DEV`
4. Click  Properties
5. Find `Communication Properties` `CHLAUTH` option and Select `DISABLE` and `Save` & `Close`

  ![](./images/cipdemo/ace3-1.png)

6. Click Add Widget
	- Select Queues to add on MQ Console
	- Click on sign (+) to Create a local Queue: `NEWORDER.ES`
7. Add a new Widget 
	- Select `Channel` to add on MQ Console
	- Create a channel using `Server Connection` on channels window: `ACE.TO.ES`

  ![](./images/cipdemo/ace3-3.png)
 
  ![](./images/cipdemo/ace3-4.png)

## Work with MQ authorization 

1. Open a terminal window on Developer machine.

	- Execute `sudo cloudctl login`
	- Type root password = `Passw0rd!`
	- Select `acemq` nameserver
	- Type user: `admin` and password: `admin`
	- Execute `kubectl get pods`
	- Find mq pod
	- Execute `kubectl exec -it mq-ibm-mq-0 -- /bin/bash`. You will be root user on mq server on ICP . 
	
2. You need to configure security in order to allow ACE send a message to QMGR.DEV (remote MQ) . 

	- Insert aceuser as part of mqm group
	- `sudo useradd -m aceuser`
	- `sudo usermod -a -G mqm aceuser`
	- Execute `runmqsc QMGR.DEV` to open MQ Configuration
	- Type `SET CHLAUTH(ACE.TO.ES) TYPE(BLOCKUSER) ACTION(REPLACE) USERLIST('nobody') `
	- Type `ALTER AUTHINFO(SYSTEM.DEFAULT.AUTHINFO.IDPWOS) AUTHTYPE(IDPWOS) CHCKCLNT(OPTIONAL)`
	- Type `ALTER QMGR CHLAUTH(DISABLED)`
	- Type `Refresh Security`
	- Type exit 


## Deploy the bar files

Deploy the `inventoryproject.generated.bar` as provided to the CIP environment.

>**Hint** each will need to be done separately.  Also create unique hostnames for each flow in the `NodePort IP` setting when configuring the Helm Release. e.g. `orders.10.0.0.5.nip.io` and `inventory.10.0.0.5.nip.io`

1. Access the ACE Dashboard via `Workloads` -> `Helm Releases`  find the `ace-ace` release and launch from there.  You can also access it via the Platform Navigator.
2. Via the ACE Dashboard you can load your bar files and deploy your integration servers from there.
3. Next, Deploy the new `Order` Flow.  The process to deploy this is similar to `Inventory` but you need to add in the MQ Settings.  Some guidance is provided below:
	- For the Queue manager settings (**Warning** these are case sensitive)
queue manager name is `acemqserver`
	- Under the heading `MQSC file for Queue Manager:`
	
```
   DEFINE QL(NEWORDER.MQ)
```   

4. Leave the remaining settings as defaults and then click `Install` at the bottom. 
5. Your chart will now install. You can view the progress of the install via Helm Releases as prompted or use kubectl. You can reciew the changes inside the ACE Management UI.
6. Be sure to test using cURL for each flow before moving on.  
7. Use the following value as input for the inventory API `key` query parameter : `AJ1-05.jpg` 
8. Once you have confirmed the functionality for both `order` and `inventory` message flows, export the swagger for each from the ACE Management Portal.  Save it to the file system on the developer machine, you will be using this in the next section
9. Once Deployed, your ACE Management UI should display both `inventory` and `order` APIs running

 ![](./images/cipdemo/appconnect.gif)

10. If you Drill into the `order` API you should see something that resembles the following (yours will be a little different)

 ![](./images/cipdemo/appconn_order_api.gif)

11. And here is `inventory`:

 ![](./images/cipdemo/appconn_inventory_api.gif)

12. Test both APIs using `cURL`.  The input for the `orders` flow is the `order.json` file that was pulled down from the `techguides` github pull. 

If you want to review that the MQ portions are working properly, execute the following:

Open a Terminal Window on Developer Machine:

- Execute `sudo cloudctl login`
- Type userid: `admin` / password: `admin`
- Set the namespace context to `acemq`
- Execute `kubectl get pods`
- Find the acemqserver pod and copy the full name to the clipboard ( **Note** - ACE created a Queue Manager and there is no MQ Console available ) 
- Execute `kubectl exec (use your actual pod name here) acemqserver-ib-92e8-01 dspmq` .You will see acemqserver (Queue Manager running)
- To Browse a message in a queue: `kubectl exec -it acemqserver-ib-92e8-0 /opt/mqm/samp/bin/amqsbcg NEWORDER.MQ`

You can use MQ Console to check if the message is in NEWORDER.ES queue, using:

- Open MQ Console on `mq` Helm Repositories
- Click  `mq-console-https 31694/TCP`
- Check the message in `NEWORDER.ES` queue on `Queues on QMGR.DEV'. 

## Create API Facades

**Note** at the time of the writing of this lab, there is an issue with API Connect that must be resolved before continuing, but fortunately is easily fixed.

1. Open the main Admin console for APIC by opening a new browser tab on the Developer machine to `https://mgmt.10.0.0.5.nip.io/admin`
2. login with the credentials of `admin`/`7Ir0n-hide`.  T
3. 

Create APIs for each of the inventory, order and AcmeMart APIs.

>**Note** the Swagger for the two ACE flows can be imported as APIs using the `From Existing Open API Service` option in API Connect.  The AcmeMart swagger can be downloaded from the main developer page and then imported, but use the `New Open API` option instead.

**For the AcmeMartUtilityAPI** you will need to modify your invoke URL to look like the following:  

`http://(yourapp ip):(your port)$(request.path)$(request.search)`

Where `yourapp ip` and `your port` is the port that ICP has put your Utility App. 

![](./images/cipdemo/invoke.gif)

Test your APIs in the test tool inside of API Connect.  For the `AcmeMartUtilityAPI`, the quickest way to do this is open up the Assembly view of the AcmeMart and select the `/Utilities/Ping` API.  It requires no arguments.

Before:

![](./images/cipdemo/test_acmemart_api1.gif)

After:

![](./images/cipdemo/test_acmemart_api2.gif)

Testing the `Inventory` API can be done in the Assembly view by using the following value as input for `key`: `AJ1-05.jpg`

![](./images/cipdemo/store_inventory_assembly_test.gif)

The orders flow can't be (easily) tested inside of the Assembly test view as it requires a json payload.  We will test this using the flow below.

## Test the entire flow

We will be using cURL to test the entire flow of the assets deployed today.  This is going to simulate what the mobile app would be doing at demo runtime by executing a series of steps in sequence.

These are samples only - you will need to update client id and secret references accordingly

>**Note** you will need to recreate your client id and secret.  There is no portal deployed on this system, but you can re-create the client id and secret for the `Sandbox Test App` inside of API Connect.


### PING - MAKE SURE THE SERVER IS ALIVE

```
`curl -k -X GET \
  https://apigw.10.0.0.5.nip.io/admin-admin/sandbox/api/Utilities/ping \
  -H 'cache-control: no-cache' \
  -H 'x-ibm-client-id: 5fa14472d2aa8f1ff5389ad20c1eed03' \
  -H 'x-ibm-client-secret: ca0986b82a21e3af67bc19ef72b7bf99'
```

Example Output:
```
{"ping":"Tue Jan 15 2019 22:08:20 GMT+0000 (UTC)"}
```

### CHECK INVENTORY - SUPPLY IT THE NAME OF THE IMAGE UPLOADED

replace client id and secret with yours

```
curl -k -X GET \
  'https://apigw.10.0.0.5.nip.io/admin-admin/sandbox/storeinventory/v1/retrieve?key=AJ1-05.jpg' \
  -H 'cache-control: no-cache' \
  -H 'x-ibm-client-id: 5fa14472d2aa8f1ff5389ad20c1eed03' \
  -H 'x-ibm-client-secret: ca0986b82a21e3af67bc19ef72b7bf99'
```

Example Output:
```
{"Inventory":[{"color":"ultramarine color","location":"In Store","pictureFile":"AJ1-05","productDescription":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean egestas nec mauris non cursus. Donec non justo lacinia, imperdiet nibh quis, laoreet ante. Sed quis luctus ligula. Donec urna libero, malesuada eu nibh vitae, facilisis pharetra quam. Donec ullamcorper porttitor bibendum. Nulla nec arcu nec metus auctor efficitur. Ut at magna condimentum, semper augue id, finibus tortor.\\n\\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean egestas nec mauris non cursus. Donec non justo lacinia, imperdiet nibh quis, laoreet ante. Sed quis luctus ligula. Donec urna libero, malesuada eu nibh vitae, facilisis pharetra quam. Donec ullamcorper porttitor bibendum. Nulla nec arcu nec metus auctor efficitur. Ut at magna condimentum, semper augue id, finibus tortor.\\n\\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean egestas nec mauris non cursus. Donec non justo lacinia, imperdiet nibh quis, laoreet ante. Sed quis luctus ligula. Donec urna libero, malesuada eu nibh vitae, facilisis pharetra quam. Donec ullamcorper porttitor bibendum. Nulla nec arcu nec metus auctor efficitur. Ut at magna condimentum, semper augue id, finibus tortor.\\n\\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean egestas nec mauris non cursus. Donec non justo lacinia, imperdiet nibh quis, laoreet ante. Sed quis luctus ligula. Donec urna libero, malesuada eu nibh vitae, facilisis pharetra quam. Donec ullamcorper porttitor bibendum. Nulla nec arcu nec metus auctor efficitur. Ut at magna condimentum, semper augue id, finibus tortor.\\n\\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean egestas nec mauris non cursus. Donec non justo lacinia, imperdiet nibh quis, laoreet ante. Sed quis luctus ligula. Donec urna libero, malesuada eu nibh vitae, facilisis pharetra quam. Donec ullamcorper porttitor bibendum. Nulla nec arcu nec metus auctor efficitur. Ut at magna condimentum, semper augue id, finibus tortor.","productID":"AJ1-05","productName":"Blue & White","qtyOnHand":"1050","rating":"2","type":"AirJordan1","typeDescription":"Air Jordan 1 (Extra Crispy)","unitPrice":"105.99"}]}
```

### ORDER A PRODUCT - USE THE PRODUCT ID SELECTED FROM THE CHECK INVENTORY CALL

replace client and id and secret with yours

```
curl -k -X POST \
  https://apigw.10.0.0.5.nip.io/admin-admin/sandbox/orders/v1/create \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'x-ibm-client-id: 5fa14472d2aa8f1ff5389ad20c1eed03' \
  -H 'x-ibm-client-secret: ca0986b82a21e3af67bc19ef72b7bf99' \
  -d '    {
    "accountid": "A-10000",
     "order": {
       "orderDate": "2018-11-28 17:05:39 +0000",
       "contractId": "00000100",
       "orderDetails": [
        {
           "lineItemNumber": 1,
           "productId": "AJ1-05",
           "quantity": "20"
         }
       ]
     }
    }
'
```

Example Output:
```
{"accountid":"A-10000","orderid":"6981359"}
```

### CHECK EVENTS - USER THE ORDER ID FROM THE PREVIOUS CALL

Currently for this lab, events are being written to both Event Streams on your ICP and in the Cloud.  We're still working through some of the challenges with the ES on-premesis but we can still show events for the demo that are running on the IBM Cloud.  Execute this command to get a feel for what those look like.

```
curl -X GET \
  'https://am-utilityapi.eu-gb.mybluemix.net/api/Events/findOne?filter=%7B%22where%22%3A%20%7B%22purchaseOrder%22%3A%20%225688471%22%7D%7D' \
  -H 'cache-control: no-cache' \
  -H 'x-ibm-client-id: af0a85e4-92fe-4b87-8545-f536fbf811a3' \
  -H 'x-ibm-client-secret: M6hQ5nR0kT2jO6mU5gA3dS3yN7uT8vY7eG3jH4xN1pS7vM7hN3'
```
Example Output:
```
{"id":"f58d732c494dc8ce9c1d2dbdba8817dd","purchaseOrder":"5688471","shipTo":{"name":"Test Account","street":"1060 West Addison","city":"Chicago","state":"IL","zip":"60680"},"billTo":{"name":"Test Account","street":"1060 West Addison","city":"Chicago","state":"IL","zip":"60680"},"item":{"partNum":"AJ1-03","productName":"Red, Black & Green","quantity":"1","price":"103.99","shipDate":"2019-01-08T19:46:28.314Z"},"status_code":500,"last_update":"2019-01-08T19:56:01.479Z","history":[{"type":"initial","timestamp":"2019-01-08T19:46:29.350Z","topic":"kafka-nodejs-console-sample-topic","partition":0,"offset":334,"key":null},{"type":"update","timestamp":"2019-01-08T19:48:03.328Z","topic":"acmemart_update_order","partition":0,"offset":151,"key":[75,101,121]},{"type":"update","timestamp":"2019-01-08T19:50:01.362Z","topic":"acmemart_update_order","partition":0,"offset":153,"key":[75,101,121]},{"type":"update","timestamp":"2019-01-08T19:52:01.403Z","topic":"acmemart_update_order","partition":0,"offset":155,"key":[75,101,121]},{"type":"update","timestamp":"2019-01-08T19:54:01.438Z","topic":"acmemart_update_order","partition":0,"offset":157,"key":[75,101,121]},{"type":"update","timestamp":"2019-01-08T19:56:01.479Z","topic":"acmemart_update_order","partition":0,"offset":159,"key":[75,101,121]}]}
```

### Conclusion
You have put together the main building blocks for the combined CIP Demonstration.  The only things left are to plug in the mobile app to make these api calls, and make a minor change to the microservices to use the on-premises based event streams versus the cloud.  There is also a Watson Assistant (aka Conversations) bit that will be added as well. Keep an eye out for further sessions, as all of these items will be covered in a forthcoming remote enablement session later in this quarter. 

 
**End of Lab**
