AxPut Format:
-------------
1. Custom Template / HTML Page: Make required JSON manually in a custom template or HTML page and call the AxInterface function to push the data to the queue.
Axinterface.js:
---------------
AxPushtoQueueAPI(jsonData, successCB = () => { }, errorCB = () => { })

Json Format:
------------------
jsonData ={\"_parameters\":[{\"ARMSessionId\":\"\",\"ARMToken\":\"\",\"isaxput\":\"true\",\"project\":\"goldendump114\",\"username\":\"admin\",\"trace\":false,\"validateonly\":false,\"axclient_dateformat\":\"yyyy-MM-dd\",\"millisecsintimestamp\":true,\"data\":[{\"transid\":\"forma\",\"action\":\"create\",\"submitdata\":{\"dc1\":{\"row1\":{\"flda\":\"test\",\"fldb\":\"admin\",\"fldc\":\"\",\"fldd\":\"\",\"fldNum\":\"\",\"fldpwd\":\"\"}}}},{\"transid\":\"forma\",\"action\":\"create\",\"submitdata\":{\"dc1\":{\"row1\":{\"flda\":\"test2\",\"fldb\":\"malakonda\",\"fldc\":\"\",\"fldd\":\"\",\"fldNum\":\"\",\"fldpwd\":\"\"}}}},{\"transid\":\"formb\",\"action\":\"create\",\"submitdata\":{\"dc1\":{\"row1\":{\"flda\":\"A1\",\"fldb\":\"a\",\"fldc\":\"3.00\"}},\"dc2\":{\"row1\":{\"fldd\":\"a\",\"flde\":\"A1\"},\"row2\":{\"fldd\":\"b\",\"flde\":\"A1\"}}}},{\"transid\":\"formc\",\"action\":\"create\",\"submitdata\":{\"dc1\":{\"row1\":{\"flda\":\"C1\",\"fldb\":\"cc\",\"fldc\":\"\"}},\"dc2\":{\"row1\":{\"fldd\":\"c\",\"flde\":\"44.00\",\"fldf\":\"01/04/2026\"},\"row2\":{\"fldd\":\"d\",\"flde\":\"4.00\",\"fldf\":\"\"}}}}]}]}

2. Push data to queue using API(externally calling ARM APIS's) or Postman:
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
    "queuedata": "{\"_parameters\":[{\"ARMSessionId\":\"\",\"ARMToken\":\"\",\"isaxput\":\"true\",\"project\":\"goldendump114\",\"username\":\"admin\",\"trace\":false,\"validateonly\":false,\"axclient_dateformat\":\"yyyy-MM-dd\",\"millisecsintimestamp\":true,\"data\":[{\"transid\":\"forma\",\"action\":\"create\",\"submitdata\":{\"dc1\":{\"row1\":{\"flda\":\"test\",\"fldb\":\"admin\",\"fldc\":\"\",\"fldd\":\"\",\"fldNum\":\"\",\"fldpwd\":\"\"}}}},{\"transid\":\"forma\",\"action\":\"create\",\"submitdata\":{\"dc1\":{\"row1\":{\"flda\":\"test2\",\"fldb\":\"malakonda\",\"fldc\":\"\",\"fldd\":\"\",\"fldNum\":\"\",\"fldpwd\":\"\"}}}},{\"transid\":\"formb\",\"action\":\"create\",\"submitdata\":{\"dc1\":{\"row1\":{\"flda\":\"A1\",\"fldb\":\"a\",\"fldc\":\"3.00\"}},\"dc2\":{\"row1\":{\"fldd\":\"a\",\"flde\":\"A1\"},\"row2\":{\"fldd\":\"b\",\"flde\":\"A1\"}}}},{\"transid\":\"formc\",\"action\":\"create\",\"submitdata\":{\"dc1\":{\"row1\":{\"flda\":\"C1\",\"fldb\":\"cc\",\"fldc\":\"\"}},\"dc2\":{\"row1\":{\"fldd\":\"c\",\"flde\":\"44.00\",\"fldf\":\"01/04/2026\"},\"row2\":{\"fldd\":\"d\",\"flde\":\"4.00\",\"fldf\":\"\"}}}}]}]}"
}
  Note: The ARMSessionId generated from the Signin API must be included inside the queuedata JSON. Ensure the ARMSessionId is valid at the time of calling ARMPushToQueue. 

3. Multi transaction save from Mobile:
   Push Data to Queue using ARMPushToQueue API: Use the generated ARMSessionId to push data into the queue.
    Ex.: 
      URL: http://localhost/ARM_API/ARM_APIs/api/v1/ARMPushToQueue  
    Payload: {
    "queuename": "CachedSaveQueue",
    "queuedata": "{\"_parameters\":[{\"ARMSessionId\":\"ARM-goldendump114-9d70d3e5-0451-45e1-bb4b-d68f52bf8a4c\",\"ARMToken\":\"eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkFSTS1JTlRFUk5BTC0xNzBCMzYwQ0VDMTkwNjk5MkEzMjhSUzI1NiJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJzaWQiOiJBUk0tZ29sZGVuZHVtcDExNC05ZDcwZDNlNS0wNDUxLTQ1ZTEtYmI0Yi1kNjhmNTJiZjhhNGMiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IkFSTS1nb2xkZW5kdW1wMTE0LTlkNzBkM2U1LTA0NTEtNDVlMS1iYjRiLWQ2OGY1MmJmOGE0YyIsIm5iZiI6MTc3ODEzOTM4MSwiZXhwIjoxNzc4MTQxMTgxLCJpc3MiOiJBeHBlcnQgLSBBUk0iLCJhdWQiOiJBeHBlcnQgLSBBUk0ifQ.EkiCY8KoOlLgo7t7kI4viyt1lC_-5Jngw8LKrt7ikIg\",\"isaxput\":\"true\",\"mobile\":\"true\",\"axm_queueid\": \"12345678\",\"project\":\"pgbase114\",\"username\":\"admin\",\"trace\": false,\"validateonly\": false,\"axclient_dateformat\": \"yyyy-MM-dd\",\"millisecsintimestamp\": true,\"data\": [{\"transid\": \"tst23\",\"axm_recid\": \"1122333\",\"action\": \"create\",\"submitdata\": {\"dc1\": {\"row1\": {\"txtfld\": \"QWWQQWWAB7\",\"txtfld2\": \"\",\"decnum\": \"04.00\",\"wholenum\": \"0404\",\"datafld\": \"2025-12-25\",\"timefld\": \"04:04 AM\",\"timestampfld\": \"2025-12-25 12:12:12.223\",\"dropdown\": \"Item2\",\"multifld\": \"mohan\",\"richtext\": \"t t 0404A\",\"chklist\": \"Check2,Check3\",\"chkbox\": \"T\",\"radiogrp\": \"Radio2\",\"empng\": \"001\"}},\"dc2\": {\"row1\": {\"gridtxt\": \"DC2-1-04A\",\"griddecimal\": \"4.00\",\"griddate\": \"2045-12-24\",\"gridtimestampfld\": \"2025-12-25 12:12:12.224\"},\"row2\": {\"gridtxt\": \"DC2-2-04A\",\"griddecimal\": \"5.04\",\"griddate\": \"2045-12-24\",\"gridtimestampfld\": \"2025-12-25 12:12:12.225\"},\"row3\": {\"gridtxt\": \"DC2-3-04A\",\"griddecimal\": \"6.00\",\"griddate\": \"2045-12-24\",\"gridtimestampfld\": \"2025-12-25 12:12:12.226\"}},\"dc3\": {\"row1\": {\"largetext\": \"TES SS TES 04A\"}},\"dc4\": {\"row1\": {\"grid2txt\": \"DC4-1-04A\",\"grid2txt2\": \"AAA-04A\",\"grid2date\": \"2045-12-24\",\"grid2num\": \"1004\",\"empgg\": \"001\"},\"row2\": {\"grid2txt\": \"DC4-2-04A\",\"grid2txt2\": \"BBB-04A\",\"grid2date\": \"2045-12-24\",\"grid2num\": \"2004\",\"empgg\": \"002\"}},\"dc5\": {\"row1\": {\"nongrid_num\": \"104\",\"nongrid_largetext\": \"TEST -04A\"}}}},{\"transid\": \"tst23\",\"axm_recid\": \"1122333\",\"action\": \"create\",\"submitdata\": {\"dc1\": {\"row1\": {\"txtfld\": \"QWWQQWWAB8\",\"txtfld2\": \"\",\"decnum\": \"04.00\",\"wholenum\": \"0404\",\"datafld\": \"2025-12-25\",\"timefld\": \"04:04 AM\",\"timestampfld\": \"2025-12-25\",\"dropdown\": \"Item2\",\"multifld\": \"mohan\",\"richtext\": \"t t 0404A\",\"chklist\": \"Check2,Check3\",\"chkbox\": \"T\",\"radiogrp\": \"Radio2\",\"empng\": \"001\"}},\"dc2\": {\"row1\": {\"gridtxt\": \"DC2-1-04A\",\"griddecimal\": \"4.00\",\"griddate\": \"2045-12-24\"},\"row2\": {\"gridtxt\": \"DC2-2-04A\",\"griddecimal\": \"5.04\",\"griddate\": \"2045-12-24\"},\"row3\": {\"gridtxt\": \"DC2-3-04A\",\"griddecimal\": \"6.00\",\"griddate\": \"2045-12-24\"}},\"dc3\": {\"row1\": {\"largetext\": \"TES SS TES 04A\"}},\"dc4\": {\"row1\": {\"grid2txt\": \"DC4-1-04A\",\"grid2txt2\": \"AAA-04A\",\"grid2date\": \"2045-12-24\",\"grid2num\": \"1004\",\"empgg\": \"001\"},\"row2\": {\"grid2txt\": \"DC4-2-04A\",\"grid2txt2\": \"BBB-04A\",\"grid2date\": \"2045-12-24\",\"grid2num\": \"2004\",\"empgg\": \"002\"}},\"dc5\": {\"row1\": {\"nongrid_num\": \"104\",\"nongrid_largetext\": \"TEST -04A\"}}}}]}]}"
}

----------------------------
ASBRest Format:
----------------------------
1. Custom Template / HTML Page: Make required JSON manually in a custom template or HTML page and call the AxInterface function to push the data to the queue.
Axinterface.js:
---------------
AxPushtoQueueAPI(jsonData, successCB = () => { }, errorCB = () => { })

Json Format:
------------------
jsonData ={\"_parameters\": [{\"ARMSessionId\": \"\",\"isaxput\":\"false\",\"project\": \"goldendump114\",\"username\": \"admin\",\"sessionid\": \"\",\"trace\": \"true\",\"transaction1\": {\"transid\": \"forma\",\"afiles\": \"\",\"recordid\": \"0\",\"changedrows\": {},\"recdata\": [{\"axp_recid1\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"flda\": \"test\",\"fldb\": \"admin\",\"fldc\": \"\",\"fldd\": \"\",\"fldNum\": \"\",\"fldpwd\": \"\"}}]}]},\"transaction2\": {\"transid\": \"forma\",\"afiles\": \"\",\"trace\": \"true\",\"recordid\": \"0\",\"changedrows\": {},\"recdata\": [{\"axp_recid1\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"flda\": \"test2\",\"fldb\": \"malakonda\",\"fldc\": \"\",\"fldd\": \"\",\"fldNum\": \"\",\"fldpwd\": \"\"}}]}]},\"transaction3\": {\"transid\": \"formb\",\"afiles\": \"\",\"trace\": \"true\",\"recordid\": \"0\",\"changedrows\": {\"dc2\": \"*\"},\"recdata\": [{\"axp_recid1\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"flda\": \"A1\",\"fldb\": \"a\",\"fldc\": \"3.00\"}}]},{\"axp_recid2\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"fldd\": \"a\",\"flde\": \"A1\"}},{\"rowno\": \"002\",\"text\": \"\",\"columns\": {\"fldd\": \"b\",\"flde\": \"A1\"}}]}]},\"transaction4\": {\"transid\": \"formc\",\"afiles\": \"\",\"trace\": \"true\",\"recordid\": \"0\",\"changedrows\": {\"dc2\": \"*\"},\"recdata\": [{\"axp_recid1\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"flda\": \"C1\",\"fldb\": \"cc\",\"fldc\": \"\"}}]},{\"axp_recid2\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"fldd\": \"c\",\"flde\": \"44.00\",\"fldf\": \"01/04/2026\"}},{\"rowno\": \"002\",\"text\": \"\",\"columns\": {\"fldd\": \"d\",\"flde\": \"4.00\",\"fldf\": \"\"}}]}]}}

2. Push data to queue using API(externally calling ARM APIS's) or Postman:
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
    "queuedata": "{\"_parameters\": [{\"ARMSessionId\": \"\",\"isaxput\":\"false\",\"project\": \"goldendump114\",\"username\": \"admin\",\"sessionid\": \"\",\"trace\": \"true\",\"transaction1\": {\"transid\": \"forma\",\"afiles\": \"\",\"recordid\": \"0\",\"changedrows\": {},\"recdata\": [{\"axp_recid1\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"flda\": \"test\",\"fldb\": \"admin\",\"fldc\": \"\",\"fldd\": \"\",\"fldNum\": \"\",\"fldpwd\": \"\"}}]}]},\"transaction2\": {\"transid\": \"forma\",\"afiles\": \"\",\"trace\": \"true\",\"recordid\": \"0\",\"changedrows\": {},\"recdata\": [{\"axp_recid1\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"flda\": \"test2\",\"fldb\": \"malakonda\",\"fldc\": \"\",\"fldd\": \"\",\"fldNum\": \"\",\"fldpwd\": \"\"}}]}]},\"transaction3\": {\"transid\": \"formb\",\"afiles\": \"\",\"trace\": \"true\",\"recordid\": \"0\",\"changedrows\": {\"dc2\": \"*\"},\"recdata\": [{\"axp_recid1\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"flda\": \"A1\",\"fldb\": \"a\",\"fldc\": \"3.00\"}}]},{\"axp_recid2\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"fldd\": \"a\",\"flde\": \"A1\"}},{\"rowno\": \"002\",\"text\": \"\",\"columns\": {\"fldd\": \"b\",\"flde\": \"A1\"}}]}]},\"transaction4\": {\"transid\": \"formc\",\"afiles\": \"\",\"trace\": \"true\",\"recordid\": \"0\",\"changedrows\": {\"dc2\": \"*\"},\"recdata\": [{\"axp_recid1\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"flda\": \"C1\",\"fldb\": \"cc\",\"fldc\": \"\"}}]},{\"axp_recid2\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"fldd\": \"c\",\"flde\": \"44.00\",\"fldf\": \"01/04/2026\"}},{\"rowno\": \"002\",\"text\": \"\",\"columns\": {\"fldd\": \"d\",\"flde\": \"4.00\",\"fldf\": \"\"}}]}]}}"
}
  Note: The ARMSessionId generated from the Signin API must be included inside the queuedata JSON. Ensure the ARMSessionId is valid at the time of calling ARMPushToQueue.  


3. Normalised Field values:
   Ex.: Normalised field name is 'companyname' so json format as '\"companyname\": \"agilelabs\",\"companyname_id\":\"1533550000001\",\"companyname_oldid\":\"1533550000001\"'
AxPushtoQueueAPI(jsonData, successCB = () => { }, errorCB = () => { })
Json Format:
------------------
jsonData = {\"_parameters\": [{\"ARMSessionId\": \"\",\"isaxput\":\"false\",\"project\": \"pgbase114\",\"username\": \"admin\",\"sessionid\": \"\",\"trace\": \"true\",\"transaction1\": {\"transid\": \"tfnmf\",\"afiles\": \"\",\"recordid\": \"1569990000000\",\"changedrows\": {\"dc2\": \"*\"},\"recdata\": [{\"axp_recid1\": [{\"rowno\": \"001\",\"text\": \"1569990000000\",\"columns\": {\"flda\": \"test3\",\"fldb\": \"Testa\",\"fldb_id\":\"1533550000001\",\"fldb_oldid\":\"1533550000001\",\"fldc\": \"A1\",\"fldc_id\":\"1568990000006\",\"fldc_oldid\":\"1568990000006\"}}]},{\"axp_recid2\":[{\"rowno\":\"001\",\"text\":\"1569990000001\",\"columns\":{\"fldd\":\"T1\",\"flde\":\"Testa\",\"flde_id\":\"1533550000001\",\"flde_oldid\":\"1533550000001\",\"fldf\":\"A1\",\"fldf_id\":\"1568990000006\",\"fldf_oldid\":\"1568990000006\"}},{\"rowno\":\"002\",\"text\":\"1569990000002\",\"columns\":{\"fldd\":\"T2\",\"flde\":\"Testb\",\"flde_id\":\"1538010000003\",\"flde_oldid\":\"1538010000003\",\"fldf\":\"B1\",\"fldf_id\":\"1569010000005\",\"fldf_oldid\":\"1569010000005\"}}]}]}}]}

