---
title: Integrate SaaS Basic Demo 
toc: false
sidebar: labs_sidebar
folder: pots/integrate-saas
permalink: /integrate-saas.html
summary: Integration of SaaS Applications using App Connect
applies_to: [developer,administrator,consumer]
---

{{#template name="integrate-saas"}}

<!-- # Hybrid Cloud Integration Tutorial – Connect your applications -->

<!--Follow these guidelines when you're choosing a title for the tutorial:

First, search on your proposed the title and compare it against the competition. Are the matches relevant? Ideally, you should strive to publish better content than the competition, otherwise why would you expect to displace existing publications?

Readers are less likely to click on "general" titles since it doesn't clearly answer their question. Search engines are also reluctant to include similarly worded titles in the same results page. Avoid lengthy prefixes; instead, include more specific keywords earlier in the title.-->

<!-- Main intro section

In several paragraphs, explain the basic concepts and tools that are used in the tutorial and why.

What is the business value you get from doing this tutorial?

Identify the best practices and architectures on the GM site in line.

Supply the link to the Github project that contains the code used in the tutorial.-->

Cassie has just been assigned to a new project team where she has taken on a new role as an integration developer. The project has very recently gone live with SAP Hybris, and the decision was made by the project lead to use Salesforce.com as the CRM System of Record, and it is up to her to make sure that Salesforce is loaded up with data from SAP Hybris and that new Contact information entered into Salesforce is automatically synced into Hybris.  This doesn't bother Cassie very much, as she knows that App Connect is built to handle these requirements simply, without writing any code.

{{> walkthrough}}

{{/template}}



{{#template name="integrate-saas-intro"}}

<!--This is a shorter intro section that briefly explains the steps the user will complete or what the user will learn by completing the tutorial.-->

This lab is broken up into three parts.  Part one is where you will be importing an existing flow that will be generating an oauth token to be used by the back end Hybris stub service.  Part two will be the creation of the flow that will migrate SAP Hybris Addresses to Salesforce.com Contacts.  Part three is an optional flow that will have you create a synchronization flow that will automatically sync newly created Salesforce.com Contacts back into SAP Hybris.

<!-- If you need to include content for IBMers only, add the content within the ibmOnly tags. For example: -->


<!-- To see an example of how that text is rendered on the site, see the "Build the foundation of an IoT app with Node-RED and Raspberry Pi" tutorial at https://www.ibm.com/cloud/garage/tutorials/raspberry-pi-iot -->

{{/template}}



{{#template name="integrate-saas-prereqs"}}

<!--Provide a numbered list of pre-requisites.  Assume that the people taking the 
tutorials have no prior knowledge of any of the technology used. If there is an environment that can be used to run the tutorial, you must create it and point to it from the prerequisites.  Ensure that you can run through the tutorial on the environment specified. 

A few example pre-requisites are included below. Replace the steps with your own.-->

{{#roundCircleList listClass='fix-heading'}}

1. You must have an IBM Cloud account. The account is free and provides access to everything you need to develop, track, plan, and deploy apps. <a href="https://console.bluemix.net/registration/?cm_mmc=IBMBluemixGarageMethod-_-MethodSite-_-10-19-15::12-31-18-_-bm_reg" target="_blank">Sign up for a trial</a>. The account requires an IBMid. If you don't have an IBMid, you can create one when you register.

2. You must have a Salesforce.com developer account.   You can get one for free from [here](https://developer.salesforce.com/).  This will be your own permanent developer account.  Note - Make sure you have created a developer account and not a trial account.  Trial accounts to do not have access to the Saleforce API, and thus will not work with AppConnect.  For all of the integrations we will be using the base `Salesforce.com` connector

3. Once you get your Developer Account set up for Salesforce.com, you will need to add a custom field to your Contact object to support the integration scenario. Instructions on how to do this can be found [here](https://help.salesforce.com/articleView?id=adding_fields.htm&type=0).  Call this custom field `ExternalContactID`.  You can define this field as type `text`.

{{/roundCircleList}}

{{/template}}



<!--TASK 1-->

{{#template name="integrate-saas-step1"}}

<!-- Build OAuth Authentication API (leave the comment tags) -->

Estimated Completion Time:  5 minutes

The SAP Hybris system you are using has its own API secured using OAuth.  You will need to have your integration get an Oauth token before making any subsequent API Calls.  The steps below will have you create a stub API that will simulate the API that will generate an Oauth token and have that API return that token to those who request it. 

{{#roundCircleList listClass='fix-heading'}}

<!--Provide the steps for the first task in the tutorial below.  Some example steps are provided below.  These example steps show you how to use markdown formatting for bold text, inserting images, and bulleted lists.-->

1. Launch the Chrome browser. 
2. Log into the [IBM Cloud](https://console.bluemix.net?cm_mmc=IBMBluemixGarageMethod-_-MethodSite-_-10-19-15::12-31-18-_-ibm-bluemix-website).
3. If you haven't done so already, Add the App Connect service to your list of services, under Integration.  
4. Launch the App Connect service
5. Download the YAML file for the Stub.  Download this [file](https://github.ibm.com/malley/AppConnectWW/blob/master/FSOauthTokenStub.yaml) locally.  Note: if you are a business partner, and do not have access to the internal IBM Github site, you can use this alternative site [here](https://github.com/ibm-cloudintegration/techguides/blob/master/FSOauthTokenStub.yaml).  Make sure you select the `Raw` option and then copy and paste the entire contents of the file.
7. Create a new API Flow `+New -> Import Flow`.  
8. Browse for the YAML file downloaded in the step earlier.  Note:  If the file fails to import, make sure you have followed the instructions closely in the step prior.
9. Open up the Flow.  Click on each operation in the flow to see what it is doing.
19. You can now start up the Flow by clicking the `Done` button then the icon in the upper right hand corner that looks like 3 dots.  Click that and then select `Start API` you will see that the status will change to `Running`.
20. Click on the Manage section of the new flow you created.  Here you will see the information about how to use the IBM Cloud Native API Management capability.
21. Scroll down to `Sharing Outside of Bluemix Organization` and click on `Create API Key`.  
22. Click on the `API PORTAL LINK` link. You can explore your API in the portal and invoke it by clicking on `Try it`.
23. To call the API, click on `Call Operation`. If it is successful, you will see the JSON output with your token id.
24. Be sure to note the following information about your service, as you will be calling it in other portions of this lab.
* Specific items to note and keep handy for later are:
  * Route to invoke your API (you can find this in the manage section) You will also 	need to append the model name to the end of the URL - e.g. Note your URL will be different. `https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/1234567889009293939399/abcDEF0/model` 
  * Model name in this case is, `oauthtoken`.  
  * The API Key, which can be found at the bottom section of the manage screen under the `Sharing Outside of Cloud Foundry organization` heading. 

{{/roundCircleList}}

{{/template}}


<!--TASK 2-->

{{#template name="integrate-saas-step2"}}

<!-- Migrate SAP Hybris Adddresses to Salesforce-->

Estimated Completion Time:  15-20 minutes

Configure the Flow to do the initial load of SAP Hybris Contacts as Salesforce Contacts.  Now we are ready to do the initial migration of SAP Hybris Contacts over into Salesforce.

{{#roundCircleList listClass='fix-heading'}}

<!--Provide the steps for the second task in the tutorial below.-->

1. Create a new API Flow from the main landing page in Designer and go to `+New -> Flows for an API`.
2. You can rename your flow by going to the top where it shows the flow name up at the top as `Untitled Flow 1`.  Change that by clicking on the line where the flow name is.  Call this flow `Migrate Hybris Contacts`

   ![](images/tutorials/hybrid-cloud-integration-connect-your-apps/renameflow.png)
   
2. For this flow, create a model called `contactaddress`.
3. Create one new property.  Call it `numberofcontactssynced`.
4. From the `Select Operations to Add` Drop down, select the `Create Contact` option and then `Implement Flow`.
5. Click on the Cross/Plus Icon on the flow timeline after the first operation to add a `HTTP Invoke` to your flow for the call to get the Token.  Unlike the other operations, you don't need to set up different accounts to be used with the HTTP Invoke, as you will provide all of the connectivity specifics in the operation configuration (e.g. Method, Endpoint, Headers & Body).
6. Configure the `HTTP Invoke` with the following values:
	* HTTP Method: `POST`
	* URL: your URL for the exposed API in the previous step e.g. Note your URL will be different. `https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/1234567889009293939399/abcDEF0/token`
	* Request Headers (Click Edit Mappings to make changes): 
  <pre>{"Content-Type":"application/json","X-IBM-Client-ID":"yourclientidgoeshere"}</pre>
	* Be sure to replace the `X-IBM-Client-ID` with your Client ID from the `oauthtoken` service you created in part 1.
	* Body: Leave Blank
6. Next Drop in a `JSON Parser`.  Do this by clicking on the Cross/Plus on the flow timeline and then select the `Toolbox` option.  Select the `JSON Parser` from the list.
7. Configure the `JSON Parser` by pasting this value into the JSONInput: `$HTTPInvokemethod.responseBody`. 
8. You can copy and paste the above or browse using the "3 bar" icon to the right of the text field and the bring up the drop down menu for the `HTTP Invoke Method` and then select the `Response Body`.
9. Use the following JSON Sample for the Output Schema

    <pre>{
  "access_token": "cb6c155c-5c67-44d3-9aa8-fe93f909ec16",
  "client_id": "",
  "expires_in": "1986886",
  "scope": "basic",
  "token_type": "bearer"
}</pre>

10. Click `Generate Schema` to generate the JSON Schema for the response. Note how it creates a JSON schema using the sample JSON provided.
11. Add another `HTTP Invoke` after the `JSON Parser`.  This will be the Invoke operation that will retrieve all of the Contacts from SAP Hybris. You will be calling a stubbed API that is running on the IBM Cloud for this exercise. Configure the operation exactly as follows:
    * HTTP Method:  `GET`
    * URL: `https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/9369beb5578108ad97c4d09cad46e060550480ae9c171369fa74976955506891/WgPJTi/address/fetch`
    * Request Headers (Click Edit Mappings to Make Changes): 
     <pre>{"Content-Type":"application/json","Accept":"application/json","X-IBM-Client-ID":"f208e0de-f39a-454d-8065-4eb872540af7","Authorization":"Bearer "&$JSONParserParse.access_token&""}</pre>
    * Body: Leave Blank
10. Drop another `JSON Parser` Operation.  
11. Configure the `JSON Parser` by pasting the following into the JSONInput: `$HTTPInvokemethod2.responseBody`.  
12. You can copy and paste this or browse using the "3 bar" icon to the right of the text field and the bring up the drop down menu for the `HTTP Invoke Method 2` and then select the `Response Body`. 
8. Use the following JSON Sample for the `JSON Parser` #2. use this sample of the output coming from SAP Hybris and copy and paste into the `Example JSON`:

    <pre>{
      "address": {
        "addresses": [
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "Richard",
            "id": "8796095676439",
            "lastName": "Dean",
            "line1": "First St.",
            "line2": "",
            "postalCode": "10001",
            "region": {
              "isocode": "US-CA"
            },
            "town": "San Francisco"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "Mike",
            "id": "8796224651287",
            "lastName": "Alley",
            "line1": "1061 W Addison Street",
            "line2": "",
            "postalCode": "60613",
            "region": {
              "isocode": "US-IL"
            },
            "town": "Chicago"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "Herman",
            "id": "8796225339415",
            "lastName": "Munster",
            "line1": "200 West Monroe St",
            "line2": "",
            "postalCode": "60680",
            "region": {
              "isocode": "US-IL"
            },
            "town": "Chicago"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "Fred",
            "id": "8796225503255",
            "lastName": "Flintstone",
            "line1": "3501 Shields Street",
            "line2": "",
            "postalCode": "60680",
            "region": {
              "isocode": "US-IL"
            },
            "town": "Chicago"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "Jayden",
            "id": "8796257157143",
            "lastName": "Allen",
            "line1": "7931 Glenwood",
            "line2": "",
            "postalCode": "76907",
            "region": {
              "isocode": "US-TX"
            },
            "town": "Arlington"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "Boaty",
            "id": "8796260106263",
            "lastName": "McBoatface2",
            "line1": "535 E Madison",
            "line2": "",
            "postalCode": "60613",
            "region": {
              "isocode": "US-IL"
            },
            "town": "Chicago"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "test5",
            "id": "8796260270103",
            "lastName": "test5",
            "line1": "One Orchard Road",
            "line2": "",
            "postalCode": "10504",
            "region": {
              "isocode": "US-NY"
            },
            "town": "Armonk"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "test8",
            "id": "8796260302871",
            "lastName": "test8",
            "line1": "One Orchard Road",
            "line2": "",
            "postalCode": "10504",
            "region": {
              "isocode": "US-NY"
            },
            "town": "Armonk"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "test9",
            "id": "8796260335639",
            "lastName": "test9",
            "line1": "One Orchard Road",
            "line2": "",
            "postalCode": "10504",
            "region": {
              "isocode": "US-NY"
            },
            "town": "Armonk"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "test10",
            "id": "8796260368407",
            "lastName": "test10",
            "line1": "One Orchard Road",
            "line2": "",
            "postalCode": "10504",
            "region": {
              "isocode": "US-NY"
            },
            "town": "Armonk"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "NewAndy",
            "id": "8796260401175",
            "lastName": "Grohman",
            "line1": "One Orchard Road",
            "line2": "",
            "postalCode": "10504",
            "region": {
              "isocode": "US-NY"
            },
            "town": "Armonk"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "Andy2",
            "id": "8796260565015",
            "lastName": "Grohman2",
            "line1": "One Orchard Road",
            "line2": "",
            "postalCode": "10504",
            "region": {
              "isocode": "US-NY"
            },
            "town": "Armonk"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "Andy3",
            "id": "8796260597783",
            "lastName": "Grohman3",
            "line1": "One Orchard Road",
            "line2": "",
            "postalCode": "10504",
            "region": {
              "isocode": "US-NY"
            },
            "town": "Armonk"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "Andy5",
            "id": "8796260630551",
            "lastName": "Grohman5",
            "line1": "One Orchard Road",
            "line2": "",
            "postalCode": "10504",
            "region": {
              "isocode": "US-NY"
            },
            "town": "Armonk"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "Carlos",
            "id": "8796260794391",
            "lastName": "Camillion",
            "line1": "One Orchard Road",
            "line2": "",
            "postalCode": "10504",
            "region": {
              "isocode": "US-NY"
            },
            "town": "Armonk"
          },
          {
            "country": {
              "isocode": "US"
            },
            "defaultAddress": false,
            "firstName": "Ralph",
            "id": "8796261220375",
            "lastName": "McRalph",
            "line1": "200 West Monroe",
            "line2": "",
            "postalCode": "60680",
            "region": {
              "isocode": "US-IL"
            },
            "town": "Chicago"
          }
        ]
      }
    }</pre>

9. Click `Generate Schema` to generate the JSON Schema for the output.
10. Add a `ForEach` operation after the previous step. Do this by clicking on the Cross/Plus on the flow timeline and then select the `Toolbox` option.  Select the `ForEach` from the list.  Here we will iterate through each Address record returned back from SAP Hybris.
11. Configure the `ForEach` by selecting the following variable collection to iterate through:  `$JSONParserParse2.address.addresses`.  You can also manually browse again by selecting the `Addresses` object from the JSON Parser #2
12. Set the Display Name to something meaningful to represent what is being looped through.  `Address` works fine here.
13. Set the Radio Button for the collection processing to reflect `Process items in parallel in any order (optimized for best performance)`.
14. The `ForEach` will create a block in your flow.  Here you can add operations that will be executed once for each iteration of the object (e.g. Address). 
16. Add a Salesforce operation to `Update or Create Contact`. Hint: You can limit the list of operations by typing in `Salesforce` in the text box.  If you haven't yet granted the IBM Cloud access to your Salesforce account, it will ask you to authenticate.  Click `Allow` to grant access to the IBM Cloud.
17. Set the criteria for `Update where all of the following conditions are true:` to be where `ExternalContactID` is equal to the `$Foreachitem.id` value in the ForEach.  To add this, click on `Add Condition` and then enter in the criteria mentioned.  The thought process here is that we want to make sure we are updating any existing contacts that may already be in the system, based upon the `ExternalId` key.  Once this is done, you will have configured what is an `upsert` style operation, a very common method used with Salesforce Integration.  See [here](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_upsert.htm) for more information.
18. Map the following fields into the Contact object, note that the input is not coming from the JSONParse of the original call to Hybris, rather coming from the `Foreachitem` variable:

   <pre>Last Name -> $Foreachitem.lastName
   First Name -> $Foreachitem.firstName
   Mailing Street -> $Foreachitem.line1
   Mailing City -> $Foreachitem.town
   Mailing State/Province ->$substringAfter($Foreachitem.region.isocode, "-")
   Mailing Zip/Postal Code -> $Foreachitem.postalCode
   Mailing Country -> $substringAfter(Foreachitem.country.isocode, "-")
   ExternalContactId -> $Foreachitem.id</pre>

19. Lastly, modify the `Response` operation to provide a total count of all the fields loaded.  Set the value of the `Numberofcontactssynced` value to `$count($JSONParserParse2.address.addresses)`.  Use the Browse button to the right of the text bar to browse for the `addresses` object from JSONParse2.  Then you can click on the object added and then add the `count` function.  This will count up all the instances of address that were returned from Hybris and output that number.
20. You can now start up the Flow by clicking the `Done` button then the icon in the upper right hand corner that looks like 3 dots.  Click that and then select `Start API` you will see that the status will change to `Running`.
21. Click on the Manage section of the new flow you created.  Here you will see the information about how to use the IBM Cloud Native API Management capability.
22. Scroll down to `Sharing Outside of Bluemix Organization` and click on `Create API Key`.  
23. Click on the `API PORTAL LINK` link. You can explore your API in the portal and invoke it by clicking on `Try it`.
24. To call the API, click `Call Operation` if it is successful, you will see the JSON output with your token id.
25. Upon completion, if successful, some contacts will be loaded into your Salesforce account.  You will also see a numeric value in the `Numberofcontactssynced` value.  

#### This completes the initial load of contacts and also completes the main part of the lab.  There an optional step three where you can create a flow that will automatically synchronize newly created Contacts in Salesforce.com into SAP Hybris.

{{/roundCircleList}}

{{/template}}


<!--TASK 3-->

{{#template name="integrate-saas-step3"}}

<!-- Ongoing Synchronization of Salesforce Contacts to SAP Hybris -->

Estimated Completion Time: 15-20 minutes

This section will set up a new Flow that will take contacts we have in Salesforce, and take the new Contacts that are created, and have them automatically create a new Address in SAP Hybris for that Contact

{{#roundCircleList listClass='fix-heading'}}

<!--Provide the steps for the third lesson in the tutorial below.-->

1. Make sure you are still logged into App Connect
3. Click the `+NEW` icon and then select `Event Driven Flow`.
4. From the `How do you want to start the flow` list, you can browse down to `Salesforce` or use the search box to limit list.
5. We will set up a polling operation on the Contact object.
6. Select from the `Configure More Event` option from the bottom of list.
7. You can then limit the list of Objects to choose from, by typing `Contact` in the text box.  Scroll down and find the `Contact` and then select `New or Updated Contact`.  The default polling time used by AppConnect is 5 minutes.  The field to change is the `Check for new 'Contact' every (minutes)`.  Set this value to 1 minute.
8. Add a `HTTP Invoke` Operation to call the Oauth Token API created in Part 1.
6. Configure the `HTTP Invoke` with the following values:
	* HTTP Method: `POST`
	* URL: your URL for the exposed API in the previous step e.g. `https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/1234567889009293939399/abcDEF0/token`
	* Request Headers (Click Edit Mappings to make changes):
	 <pre>{"Content-Type":"application/json","X-IBM-Client-ID":"yourclientidgoeshere"}</pre>
	* Be sure to replace the `X-IBM-Client-ID` with your Client ID from part 1.
	* Body: Leave Blank
6. Next Drop in a `JSON Parser`
7. Configure the `JSON Parser` by pasting this value into the JSONInput: `$HTTPInvokemethod.responseBody` you can copy and paste this or browse using the "3 bar" icon to the right of the text field and the bring up the drop down menu for the `HTTP Invoke Method` and then select the `Response Body`.
8. Use the following JSON Sample for the Output Schema    
   
   <pre>{
  "access_token": "cb6c155c-5c67-44d3-9aa8-fe93f909ec16",
  "client_id": "",
  "expires_in": "1986886",
  "scope": "basic",
  "token_type": "bearer"
}</pre>

6. Click `Generate Schema` to generate the JSON Schema for the response.  This will Generate the schema based on the JSON sample data provided earlier.
7. Add another `HTTP Invoke` to the flow.  This will be the REST call to SAP Hybris to add the new Address based upon the Contact info coming from Salesforce.
* HTTP Method: `POST`
	* URL: `https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/9369beb5578108ad97c4d09cad46e060550480ae9c171369fa74976955506891/xhMIrE/hybrisaddress`
	* Request Headers(Click Edit Mappings to make changes):

     <pre>{"Content-Type":"application/json","Accept":"application/json","X-IBM-Client-ID":"281e72e0-4e8f-428a-8951-1f3a2c07f3aa","Authorization":"Bearer "&$JSONParserParse.access_token&""}</pre>

	* Body:

     <pre>{ "firstName":"{{|$Trigger.FirstName}}","lastName":"{{|$Trigger.LastName}}","titleCode":"mr","line1":"{{|$Trigger.MailingStreet}}","line2":"","town":"{{|$Trigger.MailingCity}}","postalCode":"{{|$Trigger.MailingPostalCode}}",    "country":{        "isocode": "US"    },    "region":{        "isocode":"US-{{|$uppercase($Trigger.MailingState)}}"    }}</pre>

7. Add a `JSON Parser` after the HTTPInvoke.  This will parse the Response in Hybris so we can sync back the created Address record back into Salesforce
	* Set the `JSONInput` to $HTTPInvokemethod2.responseBody
	* Set the Sample JSON Response to the following:

      <pre>{
        "AddressId": "894566535",
        "Success": true
      }</pre> 

	* Select `Generate Schema` to generate the Output Schema.
6. We will now write back the Address ID back into Salesforce.  For the last operation, go ahead add a Salesfore `Update or Create` operation. Point it to the `Contact` Object.  
7. Find the heading where it says `Update where all of the following conditions are true:` Click the `Add Condition` link.  Set your condition where the `ContactId` of the record we are updating to the `ContactId` of the Contact that has changed.  Hint:  the value you want to match is `$Trigger.Id`.
7. Map the following fields:
	* Last Name:  `$Trigger.LastName`
	* ExternalContactId: `$JSONParserParse2.AddressId` 
7.  You are now ready to test your flow.  Enable the flow
8. Create a new Contact in Salesforce.  Make sure the following values have data in them before saving the record in Salesforce.
	* Salutation (either Mr. or Mrs.)
	* First Name
	* Last Name
	* Mailing Street
	* Mailing City
	* Mailing Postal Code
	* Mailing Country

{{/roundCircleList}}

{{/template}}




<!-- Add additional tasks as needed. -->



<!--SUMMARY-->

{{#template name="integrate-saas-summary"}}

You have now completed all 3 steps, Congratulations! Even though it was on a smaller scale, you have accomplished what a typical SaaS integration engagement is typically run.  The first step is to always make sure you are able to migrate/load relevant data objects from the existing systems into the SaaS Application.  Once that is complete, set up a synchronization process that will keep the two systems in sync on an ongoing basis.  You did this for the SaaS App going to on-premise, if this was a real life scenario, you would also set up one syncing the on-premise application to the SaaS App on an ongoing basis.

In this Lab you’ve seen how IBM App Connect provides features for simple, guided app-to-app integration. With this lab, you covered the two primary patterns that App Connect supports:  Exposing applications as APIs and Event based integration.  The primary value of the App Connect platform can be summarized below:

* Stop wasting time on repetitive manual tasks

* Use this intuitive business tool to take back control

* Link your apps in a few simple steps

You can find a copy of the YAML solutions for this lab here.

* Step 1: [FSOauthTokenStub.yaml](https://github.com/ibm-cloudintegration/techguides/blob/master/FSOauthTokenStub.yaml)

* Step 2: [FScontactaddress.yaml](https://github.com/ibm-cloudintegration/techguides/blob/master/FScontactaddress.yaml)

* Step 3:[FSSyncContact2](https://github.com/ibm-cloudintegration/techguides/blob/master/FSSyncContact2.yaml)

###Did you enjoy this lab? Write a review on G2Crowd for your chance to receive a $20 Amazon gift card! Click [here](https://www.g2crowd.com/contributor/ibm-app-connect-vs?secure%5Bpage_id%5D=ibm-app-connect-vs&secure%5Brewards%5D=true&secure%5Btoken%5D=0c1d14d547a340427efa7fa9855907b071e866ac833b1d7d71114b079b8f9b56) to write a review.

{{> npsFeedbackQuestion }}

<!--Sample link to another tutorial

<p><img src="images/tutorials/icons/learn.svg" alt_text="Learn icon" height="32px" width="32px" style="border:0px;float:left;">&nbsp;&nbsp; To learn more about toolchains, try the 
<a href="tutorials/tutorial_toolchain_microservices">Create and use a microservices toolchain tutorial</a>.</p>

-->

{{/template}}


<!--FEEDBACK QUESTIONS

Select 2 - 3 milestones throughout the tutorial where you would like to receive input from the people taking the tutorial.  Include the feedback questions here and make a note of the step and task where the question should be placed.  Feedback questions look like this:  

 'tutorial-name-end' : {
         'image' : 'images/tutorials/icons/feedback.svg',
         'question' : 'How easy or difficult was it to create your toolchain?',
         'options' : [
           'Easy',
           'Neither easy nor difficult',
       'Difficult',
           'I couldn\'t create the toolchain',
         ]
       }, 
-->





