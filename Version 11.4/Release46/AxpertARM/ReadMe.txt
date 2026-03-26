This release has fix for the following points:

1) TASK-5075 AxUserPermission API and adding dimensions check in AxPut and AxGet APIs Customer - Axpert 11
* Dimensions based user access control is added to AxGet and AxPut APIs.
* New API AxUserPermission is added for View/Edit/Create access check.

Please find the CURL request for the API:

View/Edit Access:
curl --location 'http://localhost/ARM_site/AxTstructData/api/v1/AxUserPermission' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <your token>' \
--data '{
    "ARMSessionId": "<your session id>",
    "action": "view", //edit
    "trace": false,
    "transid": "tstdm",
    "keyfield": "recordid",
    "keyvalue": "1777990000000"
}'

Create Access:
curl --location 'http://localhost/ARM_site/AxTstructData/api/v1/AxUserPermission' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <your token>' \
--data '{
    "ARMSessionId": "<your session id>",
    "action": "Create",
    "trace": false,
    "transid": "tstdm"
}'

2) 	TASK-5107 Issue in ARMMobileNotification API Customer - Agile Labs Pvt Ltd Partner - Payazzure
* Fixed the issue and moved following APIs to ARMNotificationHub MicroserviceL
--ARMMobileNotification
--ARMDisableMobileNotificationForUser

Note:
* JWT node is added to appsettings.json file of ARMNotificationHub microservice. Please add the node or use the file from release.

3) TASK-5131 -PayBooks- Activating license in postgres managed service is not working
* Fix is provided for license checks when ODBC is configured for existing applications.

4) TASK-5205 -- When No change is DC system still generating Update statement for non changed DC Customer (Paybooks)
5) TASK-5232 -- AxPut - Autogenerate fields are not saving properly
6) TASK-4986 -- Enhancement: Applying user permission in Tstruct page
* Note: User permission is handled in AxPut, AxGet, AxList, AxDelete and AxCancel APIs now.

7) TASK-5322 DataPage - Count mistatch between 'Load all records' row count and right side cards total records count Customer
* Issue happens when dc1 has field named like 'customer_rate' and a grid dc dc2 has a field named 'rate' (this field name should be matching with dc1 field in 'EndsWith' condition and user selected 'customer_rate' field in field list to view the record. This has been fixed.
8) TASK-5321 DataPage - Pages getting hanged when 20000+ rows loaded via 'Load all records' button click
* Performance enhancements when large dataset is loaded is handled in this release.
* In case of large data is coming, it will be constructed in chunks in UI levels based on user scrolling.
* Export will be happening from frontend if 'Load all records' is clicked.

Impact testing:
* PLease test export for iviews and listiview when happening via worker service scenarios as well.

Note:
1) In data listing page Utilities -> View selection and View captions config is removed and Cards based view is withdrawn. Only Table view is supported by default in data listing page.

