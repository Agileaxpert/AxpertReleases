Product Enhancement:
-----------------------
1)TASK-4763 ARM - Create microservices for existing ARM
* ARM application is converted into microservices for improved performance, scalability and less release impact due to changes in other modules.
* The ARM url is changed to multiple Microservice URLs based on the functionality/modules.
* Appsettings.ini should be placed/replaced in the main root ARM folder. It should not be placed inside the microservice application folders. 
* New HTTP Get api ValidateAppSettings is released to validate appsettings of ARM from browser level.

Curl for ValidateAppSettings HTTPGET API:
curl --location 'http://localhost/ARM_site2/ARM_APIs/api/v1/ValidateAppSettings?appname=pgbase114' \
--data ''

IIS Configuration:
------------------
* Either  Manual IIS configuration for this app is avaiable in the document 
ARM_Microservices_IIS_Manual_Hosting_Guide.docx
(or)
* Batch file for "One click IIS installation for ARM Microservices" is avaiable in the release folder. Go through "ARM_Microservices_IIS_Hosting_Via_BATCH_Installer_Guide.docx" for more details.

* Sample postman collection for the APIs is available in "ARM Microservice APIs.postman_collection.json" file.

Note to solutions team:
------------------
Anyone using the ARM apis like SendSignalR, ARMPushToQueue, ExecuteAPIs,  from external apps / DB routines should change the ARM URL with the respective microservice URLs. 


AXIS/ARM API fixes:
------------------
1) TASK-4861 AxPut - Peg edit
* Basic Peg edit in Axput API is added as part of this release. 
2) TASK-4860 AxList API - Proper error message should return by API incase of params missing 	
* AxList API is modified to throw exact error in scenarios like ADS param missing in input json.
3) TASK-4833 Axis - AxDelete and AxCancel API 
* New AxDelete and AxCancel APIs are released as part of this release.

Curl for AxDelete:
curl --location 'http://localhost/ARM_site2/AxTstructData/api/v1/AxDelete' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <your token>' \
--data '{
    "ARMSessionId": "<your ARM sessionid>",
    "trace": true,
    "transid": "tst23", 
    "keyfield": "recordid",
    "keyvalue": "100000000005322"
}
'

Curl for AxCancel:
curl --location 'http://localhost/ARM_site2/AxTstructData/api/v1/AxCancel' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <your token>' \
--data '{
    "ARMSessionId": "<your ARM sessionid>",
    "trace": true,
    "transid": "tst23", 
    "keyfield": "recordid",
    "keyvalue": "100000000005330",
    "Remarks": "Cancelled by admin"
}
'

4) TASK-4870 Create a AxPlugins Project using AxExtend DLL to create custom plugins
* A new dotnet core sample API project is created in following GITHUB Link.
* GITHUB URL : https://github.com/Agileaxpert/Axpert/tree/main/AxPlugins
* Refer to 'AxExtend DLL.docx' and 'AxPlugins.docx' for detailed info.

5)TASK-4901 AxList API - Dimensions based filtering is added to Data Listing page
* Dimensions based filtering is added to the AxList API (Data listing page and Analytics Charts. Note: Proper functionality release note will be provided in next release.)
  


