Following points are fixed in this release:

1) TASK-3631 -  Refresh of filed using sql (localized) Customer - Paybooks Technologies
* Fixed
2) TASK-3630 Validation in 3rd dc Customer - Paybooks Technologies
* Fixed
3) TASK-3629 Data - Invalid date Customer - Paybooks Technologies
* Dates after 1900 will only be accepted.
4) TASK-3628 Timestamp validation when data passed as date Customer - Paybooks Technologies
* Date can be passed in timestamp field. Timestamp will be saved as 00:00:00
5) TASK-3684 Enhancements needed in AxList API Customer - Paybooks Technologies
Note:
AxList API is enhanced with following new features:
Paybooks enhancements:
1) "select_columns" via --ax_select_columns keyword is introduced to handle dynamic select columns .
2) "aggregations" via --ax_aggregations keyword is introduced to add dynamic aggregate functions.
3) "groupby_columns" via --ax_groupby keyword is introduced to handle dynamic group by columns .
4) "NOT CONTAINS" and "NOT EQUALS" conditions are added to TEXT datatype in dynamic filters.
5) "IN" & "NOT IN" conditions are added to DROPDOWN datatype in dynamic filters. Default value if condtion node is empty means, IN clause will be added.

Sample SQL with new keywords:
select --ax_select_columns --ax_aggregations 
from axusers
--ax_groupby

Sample JSON:
{
    "ARMSessionId": "{{session}}",
    "action": "view",
    "Project": "pgbase114",
    "ADSNames": [
        "ds_groupby_test"
    ],
    "trace": true,
    "getallrecordscount": false,
    "CachePermissions": false,    
    "pageno": 1,
    "pagesize": 10,
    "keyfield": "username",
    "keyvalue": "ALL",
    "AxClient_dateformat" : "MM/dd/yyyy", //optional
    "select_columns" : ["username","sqlsrc"],
    "aggregations" : {"total_sqlname": "count(*)"},
    "groupby_columns" : ["username","sqlsrc"],
    "sorting": [
        {
            "fldname": "sqlsrc",
            "sort_order": "asc"
        }
    ],
    "filters": [
        {
            "fldname": "sqlname",
            "datatype": "TEXT",
            "value": "test",
            "condition": "NOT EQUALS" //NOT EQUALS //NOT CONTAINS // STARTSWITH // ENDSWITH // CONTAINS // EQUALS
        },   
        {
            "fldname": "app_desc",
            "datatype": "NUMERIC",
            "from": "0",
            "to": "3"
        },
        {
            "fldname": "createdby",
            "datatype": "DROPDOWN",
            "condition": "IN",  // NOT IN
            "value": [
                "admin",
                "mohan",
                "lakshmi"
            ]
        },
        {
            "fldname": "modifiedon",
            "datatype": "DATE",
            "from": "12/31/2021",
            "to": "12/31/2026"
        },
        {
            "fldname": "modifiedon",
            "datatype": "TIMESTAMP",
            "from": "12/31/2021 00:00:00",
            "to": "12/31/2026 23:59:59"
        }
    ]
}

6) TASK-4161 AxPut - Metadata and Axpert key validation Customer - Paybooks Technologies
* The input json will accept only fields from tstruct, it will throw error if any other fields are passed
* While editing, axp_recird and axrow_action node are mandatory

7) TASK-4162 ARM Signin API changes Customer - Paybooks Technologies
* Proper errors in case of DB connection loss will be displayed
* Global variables will be overwritten with "InternalResources" node from appsettings.ini
* Lic logic is replaced with ALC DLL. Licensing has to be tested.

8) TASK-4163 Axput - FieldChanged validation not working Customer - Paybooks Technologies
* Now FieldChanged can be used in expressions/validate expressions/validate

9) TASK-4164 Signin and Signout API - Logging Customer - Paybooks Technologies
* Signin and signout API will be logged in AxAudit and AxpertLog tables.

10) TASK-4165 AxList - Error in pagination Customer - Paybooks Technologies
* If pagination is enabled via --ax_pagination keyword,
* default pageno = 1 and pagesize = 100.
* If all data is needed, pass pagesize = 0.

11)TASK-4166 ARM - Session handling enhancement
* Internal product enhancement, session handling logics are enhanced. Test session validity.

12) TASK-4205 Cards data not loading after latest ARM AXIS release
13) TASK-3031 Apply filter issue Customer - BDF
14) TASK-2966 Filter option in listing page: Normalize fields are not showing the results Customer - MPCO
15) TASK-2765 Dashboard/Cards Grouping Configuration is not working as expected. Customer - BDF
16) TASK-3257 When there is no data, the Grid DC should remain visible on the data page. Customer - BDF
* Fixed. Now Grid DC will show msg as "No Data found" in data pages if there are no rows
17) TASK-4262 Paybooks - Duplicate rows in non grid DC if I try to create new record in non grid DC ( Non grid DC already has a record) Customer - Paybooks Technologies
