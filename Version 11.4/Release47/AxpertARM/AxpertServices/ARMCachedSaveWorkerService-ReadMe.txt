TASK-5506 -- Enhancement: ARMCachedSaveworkservice has been enhanced to handle multiple transactions from multiple transids. 


1. Cached Save from Multi-Frame Template:
  On Save/Submit, the MultiFrameDataPushToQueue web service (server-side method) is invoked. It prepares the required JSON format and pushes the data to the queue.
  Note: This is a product feature. 

2. Custom Template / HTML Page: Make required JSON manually in a custom template or HTML page and call the AxInterface function to push the data to the queue.
Axinterface.js:
---------------
AxPushtoQueueAPI(jsonData, successCB = () => { }, errorCB = () => { })

Json Format:
------------
jsonData =
{
  "_parameters": [
    {
      "ARMSessionId": "",
      "project": "goldendump114",
      "username": "admin",
      "appsessionkey": "",
      "sessionid": "",
      "trace": "true",
      "transaction1": {
        "transid": "forma",
        "afiles": "",
        "recordid": "0",
        "changedrows": {},
        "recdata": [
          {
            "axp_recid1": [
              {
                "rowno": "001",
                "text": "0",
                "columns": {
                  "flda": "test",
                  "fldb": "admin",
                  "fldc": "",
                  "fldd": "",
                  "fldNum": "",
                  "fldpwd": ""
                }
              }
            ]
          }
        ]
      },
      "transaction2": {
        "transid": "forma",
        "afiles": "",
        "trace": "true",
        "recordid": "0",
        "changedrows": {},
        "recdata": [
          {
            "axp_recid1": [
              {
                "rowno": "001",
                "text": "0",
                "columns": {
                  "flda": "test2",
                  "fldb": "malakonda",
                  "fldc": "",
                  "fldd": "",
                  "fldNum": "",
                  "fldpwd": ""
                }
              }
            ]
          }
        ]
      },
      "transaction3": {
        "transid": "formb",
        "afiles": "",
        "trace": "true",
        "recordid": "0",
        "changedrows": {
          "dc2": "*"
        },
        "recdata": [
          {
            "axp_recid1": [
              {
                "rowno": "001",
                "text": "0",
                "columns": {
                  "flda": "A1",
                  "fldb": "a",
                  "fldc": "3.00"
                }
              }
            ]
          },
          {
            "axp_recid2": [
              {
                "rowno": "001",
                "text": "0",
                "columns": {
                  "fldd": "a",
                  "flde": "A1"
                }
              },
              {
                "rowno": "002",
                "text": "",
                "columns": {
                  "fldd": "b",
                  "flde": "A1"
                }
              }
            ]
          }
        ]
      },
      "transaction4": {
        "transid": "formc",
        "afiles": "",
        "trace": "true",
        "recordid": "0",
        "changedrows": {
          "dc2": "*"
        },
        "recdata": [
          {
            "axp_recid1": [
              {
                "rowno": "001",
                "text": "0",
                "columns": {
                  "flda": "C1",
                  "fldb": "cc",
                  "fldc": ""
                }
              }
            ]
          },
          {
            "axp_recid2": [
              {
                "rowno": "001",
                "text": "0",
                "columns": {
                  "fldd": "c",
                  "flde": "44.00",
                  "fldf": "01/04/2026"
                }
              },
              {
                "rowno": "002",
                "text": "",
                "columns": {
                  "fldd": "d",
                  "flde": "4.00",
                  "fldf": ""
                }
              }
            ]
          }
        ]
      }
    }
  ]
}

3. Push data to queue using API(externally calling ARM APIS's) or Postman:
   a. Generate ARMSessionId using Signin API:
     ex.: 
      Url: http://localhost/ARM_API/Axauth/api/v1/Signin
      Payload: {
    "appname":"accesscode",
    "UserName": "username",
    "password": "password", 
    "Language": "English",
    "SessionId": "123456",
    "Globalvars": true, 
    "ClearPreviousSession": true 
   }
   b. Push Data to Queue using ARMPushToQueue API: Use the generated ARMSessionId to push data into the queue.
    Ex.: 
      URL: http://localhost/ARM_API/ARM_APIs/api/v1/ARMPushToQueue  
      Payload: {
    "queuename": "CachedSaveQueue",
    "queuedata": "{\"_parameters\":[{\"ARMSessionId\":\"ARM-goldendump114-3838bf69-c17f-4582-af3b-890d7c956a16\",\"project\":\"goldendump114\",\"username\":\"admin\",\"sessionid\":\"\",\"trace\":\"true\",\"transaction1\":{\"transid\":\"forma\",\"afiles\":\"\",\"recordid\":\"0\",\"changedrows\":{},\"recdata\":[{\"axp_recid1\":[{\"rowno\":\"001\",\"text\":\"0\",\"columns\":{\"flda\":\"test\",\"fldb\":\"admin\",\"fldc\":\"\",\"fldd\":\"\",\"fldNum\":\"\",\"fldpwd\":\"\"}}]}]},\"transaction2\":{\"transid\":\"forma\",\"afiles\":\"\",\"trace\":\"true\",\"recordid\":\"0\",\"changedrows\":{},\"recdata\":[{\"axp_recid1\":[{\"rowno\":\"001\",\"text\":\"0\",\"columns\":{\"flda\":\"test2\",\"fldb\":\"malakonda\",\"fldc\":\"\",\"fldd\":\"\",\"fldNum\":\"\",\"fldpwd\":\"\"}}]}]},\"transaction3\":{\"transid\":\"formb\",\"afiles\":\"\",\"trace\":\"true\",\"recordid\":\"0\",\"changedrows\":{\"dc2\":\"*\"},\"recdata\":[{\"axp_recid1\":[{\"rowno\":\"001\",\"text\":\"0\",\"columns\":{\"flda\":\"A1\",\"fldb\":\"a\",\"fldc\":\"3.00\"}}]},{\"axp_recid2\":[{\"rowno\":\"001\",\"text\":\"0\",\"columns\":{\"fldd\":\"a\",\"flde\":\"A1\"}},{\"rowno\":\"002\",\"text\":\"\",\"columns\":{\"fldd\":\"b\",\"flde\":\"A1\"}}]}]},\"transaction4\":{\"transid\":\"formc\",\"afiles\":\"\",\"trace\":\"true\",\"recordid\":\"0\",\"changedrows\":{\"dc2\":\"*\"},\"recdata\":[{\"axp_recid1\":[{\"rowno\":\"001\",\"text\":\"0\",\"columns\":{\"flda\":\"C1\",\"fldb\":\"cc\",\"fldc\":\"\"}}]},{\"axp_recid2\":[{\"rowno\":\"001\",\"text\":\"0\",\"columns\":{\"fldd\":\"c\",\"flde\":\"44.00\",\"fldf\":\"01/04/2026\"}},{\"rowno\":\"002\",\"text\":\"\",\"columns\":{\"fldd\":\"d\",\"flde\":\"4.00\",\"fldf\":\"\"}}]}]}}]}"
}
  Note: The ARMSessionId generated from the Signin API must be included inside the queuedata JSON. Ensure the ARMSessionId is valid at the time of calling ARMPushToQueue. 




