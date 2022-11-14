---
title: 2. Running the demo
toc: true
sidebar: sfdemo
permalink: /sfdemo_step2.html
summary: In this step, you will run the demo!
---

## Objectives
1. Understand the story & background for the demo.
2. Understand the basic steps to trigger the integration flow.
3. Understand what to show.

## 2.1 Background
Salesforce.com as a clould platform is leveraged by many organizations throughout the world, both large and small.  One of the primary concerns around adoption of a clould based platform such as Salesforce, is its ability to be integrated into the enterprise.  The demonstration here shows the art of the possible of showing what an integrated enterprise looks like from the perspective of cloud, on-premise and mobile set in the context of a typical work day scenario.

The demo depicts the day in the life of a salesperson who is on the road to visit a customer.  This is a good customer for the company, where there is a pending large deal on the table and the salesperson wants to ensure everything is in order from a customer satisfaction standpoint.

The scenario is set where the salesperson is in their rental car on the way to the customer, and before they pull of out of the parking lot, they check the Salesforce One mobile app and notice that one of the customers' shipments from a very large order has been delayed.  In the past, the process of expediting customer shipments used to require multiple phone calls to different departments in different time zones and a lot of manual intervention.  To make matters worse, the custoner meeting is in 30 minutes, and this needs to be resolved ASAP.  The seller will then leverage the integrated solution using Salesforce One and IBM Cloud Integration to request a shipment upgrade, which the system processes automatically and instantly.

The demonstration script is built around how an end user could trigger multiple backend processes through their use of Salesforce.com, showing how both cloud and on-premise applications can be integrated easily.

**Hint** it is highly suggested to run through the demo steps a few times about an hour before you do your actual demo.  This will give you the best performance for your demo.  Optimally, the synchronization and real time events happen in 1 second or less.


## 2.2 Trigger the flow
1. Before running the demo, Log into Salesforce via the browser on the demo VM.  You will find the credentials for Salesforce in the **credentials.txt** on the Desktop of the Windows VM

3. Start the Salesforce One Simulator from the desktop on the VM.  Log in with your credentials as per the **credentials.txt**.  **Note** When you log into the app for the first time, it is possible that you will be required to enter in a verification code to validate your login.  If this happens, Salesforce will send a message to a gmail address attached to this user.  To access this account, in your Chrome browser go to `Bookmarks` then select the gmail account for the ibm.salesforce.demo.user, it will login automatically for you.  The new mail will be at the top.  To proceed, open this mail and then enter in the code into the Salesforce emulator to complete the login process.

2. Once you are logged into Salesforce, Navigate to the **Burlington Textiles of America** account.  The default state of the Account should be with Shipment Status of green.  Be sure to check under `Details` you will see the flag icon that is green.  Additionally, under the `Related` tab you will see the **Shipments** object.  You should see a single shipment with the Priority of `Standard` and the Status of `Started`.  **Note** only the Burlington Textiles of America Account is to be used with the demo, as it is the only account set up currently with shipments.

3. If you see something different, you will need to reset the system.  There is a script on the Desktop of the Demo VM called **reset.bat**.  This will execute a cURL statement that will return the demo data to its default state.


2. The next step is to simulate the shipment being made late.  To do so, execute the **makelate.bat** script file that is on the desktop of the demo VM.  This will change the status of the shipment #1 to `Delayed`.  Doing so will change the shipment status flag to red on the Salesforce One App.

3. Next you will want to execute the Expedition of the shipment.  Do this by finding the `Expedite Shipment` button on the lower left hand corner of the screen in the Salesforce One Emulator.  This will pop up a window.  Fill out the form and select the values from the respective drop downs:  Select the contact of `Naomi Greenly`, Shipment should be set to `1` and then the two free form boxes of Subject and Description can be set to any value that you like.  Click the `Expedite` button to complete the process.  **Note** if you do not see the message "Success - Request sent Successfully" message inside of the Lightning app, it usually means their is a timeout in the connectivity.  If this is happends, try to execute the `Expedite Shipment` again by clicking the button in the app.

4. If everything processes correctly, within about 5 seconds (the current polling interval), the Shipment status will change to `Expedited`.

## 2.3 Show the flow
1. Typically, you would walk through the previous section as the end user to explain the experience.

2. Next, you will show some plumbing.  What you will show here will depend on what your audience is interested in.  There are a few key areas of focus on that you can cover completely, or in parts that are of interest to you.  Each of the main topics are covered in their own sections below.

	* Messaging support via Streaming API and PushTopics
	* External Objects and OData 4.0 Support
	* Data Synchronization between Salesforce.com and External DB Systems
	* Exposing Applications as APIs

### Showing Messaging support via Streaming APIs and Push Topics

**Introduction:**  To capture changes to data inside of Salesforce Objects, messaging events are generated in real time using the Streaming API that can be captured and sent out externally to a Push Topic.  In this demo, once the user inside the mobile app clicked the `Expedite Shipment` tab and filled in the dialogue box with the Shipment information, a check box on the Account object was enabled which triggered the PushTopic event.  

3.  To explain how the PushTopic interaction works, in the Slide Deck there is a screenshot of the code used to trigger off the event on the Account Object (Slide #11).  Note the query defined there that is the triggered once the event happens.  This payload is then deposited on a push Topic that is being monitored by an App Connect integration.  You can find the deck [here](https://github.com/ibm-cloudintegration/techguides/blob/master/IBM%20CI%20for%20SF%20Demo.pptx).

3. Next, you can return to the Demo VM and Open up MQ Explorer and show the Subscriptions (one is an MQ subscription that moves the message to an unused `IIB.QUEUE`, the other is the JMS app that moves the message to the `ACP.QUEUE`).

4. Staying in MQ Explorer, you can show the Queues, and since the `IIB.QUEUE` is not used, you can Browse data and show Properties to show the message that came out.

5. You can then open up the App Connect Project called `2_CIforSFDemo-MQBridge` which is the `c:\demos` directory on the Demo VM.  Here can you can step through and show how App Connect polls the Queue that is linked to the topic and triggers to update the Shipment Database and the Account Object.


### External Objects and OData 4.0 Support

**Introduction:**  To support OData, App Connect uses a Project that is exposing itself as a RESTful service that leverages OData 4.0 to expose an on-premise Database table that has Shipment information stored in it.  This OData service is mapped to an External Data Source in Salesforce that points to an endpoint where the OData Service is running, in this case its on an App Connect runtime environment that is running on a Docker Container in our demo environment.  The external Data Source is then mapped to an External Object, related to the Account object, and then made visible in the Salesforce UX.

4. OData is supported by implementing an App Connect Project which is bundled as a **TIP** which is short for *Templated Integration Project*.  The value of the TIP is that it is a working integration that has been put behind a configuration "wizard" that steps through how one would implement this TIP in their environment.  This allows the integration developer to customize and deploy an integration that has best practices around design and implementation but adapt it to their environment.  When you open up the OData project, the TIP configuration wizard will start automatically.  The OData project used with this demo is in the c:\demos directory on the Demo VM and is called `1_CIforSFDemo-ODataShipments`.

7. Once you step through the configuration wizard, you can close it and show the App Connect Project, which is quite sophisticated in what it is doing, but what the TIP is doing eliminating the complexity and allowing the Developer to realize value that much quicker.  Additionally, if the Developer wishes to customize this TIP to meet their needs, they have access to a full pallete of integration activities and transformation functions available to them.  They can accomplish this customization without having to write any code.

4. Go into Salesforce and show the External Data Source and External Object.  The Exernal Data Source used with the demo is **ExtShipment**.  Click on that and you can point out the endpoint where the OData service is running and other areas of the Data Source and External Object configuration screens if you wish.  You can return to the **Account** object to show where the **Shipments** external object is present in the Account Layout.

### Data Synchronization between Salesforce.com and External DB Systems

**Introduction:**  App Connect is able to poll for changes in Real/Near Real Time on Cloud/On-Premise based systems.  This allows for richer, more accurate data to be made available to users of the integrated systems to make important business decisions versus slower, batch based integrations.  In this demonstration, App Connect is polling for changes in two different places.  First it is polling the Shipment Table on the On-premise DB for changes to a shipment status. 

5. If the Shipment Status in the **Shipment** table is set to the value of `Delayed`, the orchestration will update a checkbox on the **Account** object in Salesforce called `A_Shipment_Is_Delayed`.  This is what guides the red/green Flag of the Shipment Status on **Account**.  Additionally, the Sync Process also polls a DB Table called  **Incident** which is populated once a Shipment is Expedited via the Mobile App.  The Salesforce Lightning code makes a call to an API that is exposed that will insert a new row into the **Incident** table (more on that in the next section), and once that row is inserted, it creates a new **Case** in Salesforce based on that incident.

5. You can then open up the App Connect Project called `3_CIforSFDemo-DataSync` which is the `c:\demos` directory on the Demo Windows VM.  Here can you can step through and show how App Connect polls the **Incident** and **Shipment** DB Tables in their respective orchestrations.  

### Exposing Applications as APIs

**Introduction:**  Being able to expose back end resources as consumable APIs is the key to harnessing the power of the API Economy.  Leveraging standards such a REST, and using the powerful toolkit that App Connect Professional provides, gives the ability to quickly expose enterprise resources for other consumers to be able to use in Mobile, IoT and Web Applications.  These could mobile developers within the company, business partners or even non-affiliated mobile developers who are building apps to fit their business model.

5. As part of our demo, when we expedited the delayed shipment using the mobile application, that code invoked an API we created that is currently running on IBM's API Connect solution.  That API is running in the cloud and pointing to a back end integration to our Shipment DB that was created by App Connect and Exposed as REST.  API Connect provides the secure runtime along with API versioning/release management, analytics and Developer Portal.  A deeper dive into API Connect is beyond the scope of this demo. For more information about API Connect go [here](http://www-03.ibm.com/software/products/en/api-connect)

6.  To show how we can expose enterprise applications as APIs, you can open up the App Connect Project located on your demo VM in the `c:\demos` directory.  The Project is called `3_CIforSFDemo-API`

7. The key points to go over here are to show how App Connect can easily expose integrations created as REST and support both the JSON and XML formats simply.  Note in the Read/Write JSON activities we use JSON sample metadata that Studio interprets graphically that can be mapped to using the functions and activities in the toolkit without having to write code.
 

### (Optional) Show the Web Management Console

Launch the App Connect WMC in Chrome and navigate to the completed orchestration.  Full logging is enabled for most of the Projects (except the OData), so you can show how every step in the orchestration provides a good amount of detail on inputs and outputs.  Credentials for the WMC can be found in the **credentials.txt** file on the Desktop of the Demo VM. **Note** the newly provisioned system might require you to allow the `Adobe Flash` add on to be enabled in the browser when you log into the WMC.  Allow the access for the browser to access the functions of the WMC.
