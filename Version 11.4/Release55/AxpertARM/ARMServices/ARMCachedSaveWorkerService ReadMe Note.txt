TSK-0457 -QA- Enhancement: CachedSaveWorkerService Transaction Status Tracking:
CachedSaveWorkerService will update a Redis key with the total number of transactions and the number of processed transactions during execution. Using this Redis key, the application can display the current processing/saving progress in real time until the entire process is completed.

1. CachedSave Payload Change: A new node, statuskey, must be added to the CachedSave payload.
Example: "statuskey": "pgbase114-statuskey"
Sample Payload:
{
  "_parameters": [
    {
      "ARMSessionId": "",
      "isaxput": "false",
      "project": "pgbase114",
      "username": "admin",
      "sessionid": "",
      "trace": "true",
      "statuskey": "pgbase114-statuskey",
      "transaction1": {
        "transid": "IMPDD",
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
                  "ename": "EMP05",
                  "dropform": "",
                  "droplist": "DEV",
                  "dropsql": "EMP-202500005",
                  "dropapi": "QA"
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
                  "gname": "EMP05",
                  "formdrop": "EMP-202500002",
                  "formdrop_id": "1489550000000",
                  "formdrop_oldid": "1489550000000",
                  "listdrop": "DEV",
                  "sqldrop": "EMP-202500005",
                  "apidrop": "QA"
                }
              }
            ]
          }
        ]
      }
    }
  ]
}


2. AxRedisReadAPI Usage:
The AxRedisReadAPI should be called by passing the same statuskey to retrieve the current processing status.
Sample Payload:
{
  "AccessCode": "pgbase114",
  "InMemoryKey": "pgbase114-statuskey",
  "InMemorySubKey": "",
  "IsBinary": "false"
}