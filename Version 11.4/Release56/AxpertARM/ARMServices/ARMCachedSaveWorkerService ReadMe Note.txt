
TSK-0513 -- Data posting API  (used in custom pages) - Introduce Progress Update
Posting from custom pages is now done by pushing a JSON to Queue. The JSON may contain one or more transactions related to one or more tstructs.
The input JSON should have parameters CallerId & CallSequence. If these params are not found exception will not be raised. 
If CallerId and CallSequence are sent as parameters
   At the end of each transaction save
       Update to Redis -
           KeyName =CallerId+CallSequence
           KeyValue=Success or exception message
end
Additionally, at the end of each transaction save, the result should be stored in a table AxSaveAPIResult with following information
1. CallerId (if provided)
2. CallSequence (if provided)
3. Transid
4. Keyfield
5. KeyValue
6. InputJSON
7. ResultString (success or exception string)
8. RequestDatetime
9. RequestedBy
AxPUT and Save REST services should be enhanced to load and save if keyfield and keyvalue are provided (in this case the record id should be got by firing an SQL on primary table using the give keyfield & key value)

Payload changed: 1. callerid - for create redis key and save in AxSaveAPIResult table
                 2. sequenceno - for create redis key and save in AxSaveAPIResult table
                 3. returnfield - returnfield value will be a name of tstruct field. returnfield and returnfieldval nodes will get in service response and these nodes value using for save in AxSaveAPIResult table keyfield and keyvalue columns. 

Ex. Payload for Rest call:
{\"_parameters\": [{\"ARMSessionId\": \"{{session}}\",\"ARMToken\":\"{{token}}\",\"isaxput\":\"false\",\"project\": \"pgbase114\",\"username\": \"admin\",\"sessionid\": \"\",\"callerid\":\"TestCallerId3\",\"trace\": \"true\",\"transaction1\": {\"transid\": \"tfcsd\",\"afiles\": \"\",\"recordid\": \"0\",\"sequenceno\":\"1\",\"returnfield\": \"flda\",\"changedrows\": {\"dc2\": \"*\"},\"recdata\": [{\"axp_recid1\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"flda\": \"test\",\"fldb\": \"100\",\"fldc\": \"admin\",\"returnfield\": \"flda\"}}]},{\"axp_recid2\": [{\"rowno\": \"001\",\"text\": \"0\",\"columns\": {\"fldd\": \"testa\",\"flde\": \"101\"}},{\"rowno\": \"002\",\"text\": \"\",\"columns\": {\"fldd\": \"testb\",\"flde\": \"101\"}}]}]}}]}


Ex. Payload for AxPut:
{\"_parameters\":[{\"ARMSessionId\": \"{{session}}\",\"ARMToken\": \"{{token}}\",\"isaxput\":\"true\",\"mobile\":\"false\",\"project\":\"pgbase114\",\"username\":\"admin\",\"trace\": false,\"validateonly\": false,\"axclient_dateformat\": \"yyyy-MM-dd\",\"millisecsintimestamp\": true,\"callerid\":\"TestCallerIdAxPut\",\"data\": [{\"transid\": \"tst23\",\"action\": \"create\",\"sequenceno\":\"1\",\"returnfield\": \"txtfld\",\"submitdata\": {\"dc1\": {\"row1\": {\"txtfld\": \"QWWQQWWAB7\",\"txtfld2\": \"\",\"decnum\": \"04.00\",\"wholenum\": \"0404\",\"datafld\": \"2025-12-25\",\"timefld\": \"04:04 AM\",\"timestampfld\": \"2025-12-25 12:12:12.223\",\"dropdown\": \"Item2\",\"multifld\": \"mohan\",\"richtext\": \"t t 0404A\",\"chklist\": \"Check2,Check3\",\"chkbox\": \"T\",\"radiogrp\": \"Radio2\",\"empng\": \"001\"}},\"dc2\": {\"row1\": {\"gridtxt\": \"DC2-1-04A\",\"griddecimal\": \"4.00\",\"griddate\": \"2045-12-24\",\"gridtimestampfld\": \"2025-12-25 12:12:12.224\"},\"row2\": {\"gridtxt\": \"DC2-2-04A\",\"griddecimal\": \"5.04\",\"griddate\": \"2045-12-24\",\"gridtimestampfld\": \"2025-12-25 12:12:12.225\"},\"row3\": {\"gridtxt\": \"DC2-3-04A\",\"griddecimal\": \"6.00\",\"griddate\": \"2045-12-24\",\"gridtimestampfld\": \"2025-12-25 12:12:12.226\"}},\"dc3\": {\"row1\": {\"largetext\": \"TES SS TES 04A\"}},\"dc4\": {\"row1\": {\"grid2txt\": \"DC4-1-04A\",\"grid2txt2\": \"AAA-04A\",\"grid2date\": \"2045-12-24\",\"grid2num\": \"1004\",\"empgg\": \"001\"},\"row2\": {\"grid2txt\": \"DC4-2-04A\",\"grid2txt2\": \"BBB-04A\",\"grid2date\": \"2045-12-24\",\"grid2num\": \"2004\",\"empgg\": \"002\"}},\"dc5\": {\"row1\": {\"nongrid_num\": \"104\",\"nongrid_largetext\": \"TEST -04A\"}}}},{\"transid\": \"tst23\",\"action\": \"create\",\"sequenceno\":\"2\",\"returnfield\": \"txtfld\",\"submitdata\": {\"dc1\": {\"row1\": {\"txtfld\": \"QWWQQWWAB8\",\"txtfld2\": \"\",\"decnum\": \"04.00\",\"wholenum\": \"0404\",\"datafld\": \"2025-12-25\",\"timefld\": \"04:04 AM\",\"timestampfld\": \"2025-12-25\",\"dropdown\": \"Item2\",\"multifld\": \"mohan\",\"richtext\": \"t t 0404A\",\"chklist\": \"Check2,Check3\",\"chkbox\": \"T\",\"radiogrp\": \"Radio2\",\"empng\": \"001\"}},\"dc2\": {\"row1\": {\"gridtxt\": \"DC2-1-04A\",\"griddecimal\": \"4.00\",\"griddate\": \"2045-12-24\"},\"row2\": {\"gridtxt\": \"DC2-2-04A\",\"griddecimal\": \"5.04\",\"griddate\": \"2045-12-24\"},\"row3\": {\"gridtxt\": \"DC2-3-04A\",\"griddecimal\": \"6.00\",\"griddate\": \"2045-12-24\"}},\"dc3\": {\"row1\": {\"largetext\": \"TES SS TES 04A\"}},\"dc4\": {\"row1\": {\"grid2txt\": \"DC4-1-04A\",\"grid2txt2\": \"AAA-04A\",\"grid2date\": \"2045-12-24\",\"grid2num\": \"1004\",\"empgg\": \"001\"},\"row2\": {\"grid2txt\": \"DC4-2-04A\",\"grid2txt2\": \"BBB-04A\",\"grid2date\": \"2045-12-24\",\"grid2num\": \"2004\",\"empgg\": \"002\"}},\"dc5\": {\"row1\": {\"nongrid_num\": \"104\",\"nongrid_largetext\": \"TEST -04A\"}}}}]}]}


Ex. Payload for AxPut (Mobile):
{\"_parameters\":[{\"ARMSessionId\": \"{{session}}\",\"ARMToken\": \"{{token}}\",\"isaxput\":\"true\",\"mobile\":\"true\",\"axm_queueid\": \"AXM_1234567890987654321\",\"project\":\"pgbase114\",\"username\":\"admin\",\"trace\": false,\"validateonly\": false,\"axclient_dateformat\": \"yyyy-MM-dd\",\"millisecsintimestamp\": true,\"callerid\":\"TestCallerIdAxPut\",\"data\": [{\"transid\": \"tst23\",\"axm_recid\": \"axm_1122333\",\"action\": \"create\",\"sequenceno\":\"1\",\"returnfield\": \"txtfld\",\"submitdata\": {\"dc1\": {\"row1\": {\"txtfld\": \"QWWQQWWAB7\",\"txtfld2\": \"\",\"decnum\": \"04.00\",\"wholenum\": \"0404\",\"datafld\": \"2025-12-25\",\"timefld\": \"04:04 AM\",\"timestampfld\": \"2025-12-25 12:12:12.223\",\"dropdown\": \"Item2\",\"multifld\": \"mohan\",\"richtext\": \"t t 0404A\",\"chklist\": \"Check2,Check3\",\"chkbox\": \"T\",\"radiogrp\": \"Radio2\",\"empng\": \"001\"}},\"dc2\": {\"row1\": {\"gridtxt\": \"DC2-1-04A\",\"griddecimal\": \"4.00\",\"griddate\": \"2045-12-24\",\"gridtimestampfld\": \"2025-12-25 12:12:12.224\"},\"row2\": {\"gridtxt\": \"DC2-2-04A\",\"griddecimal\": \"5.04\",\"griddate\": \"2045-12-24\",\"gridtimestampfld\": \"2025-12-25 12:12:12.225\"},\"row3\": {\"gridtxt\": \"DC2-3-04A\",\"griddecimal\": \"6.00\",\"griddate\": \"2045-12-24\",\"gridtimestampfld\": \"2025-12-25 12:12:12.226\"}},\"dc3\": {\"row1\": {\"largetext\": \"TES SS TES 04A\"}},\"dc4\": {\"row1\": {\"grid2txt\": \"DC4-1-04A\",\"grid2txt2\": \"AAA-04A\",\"grid2date\": \"2045-12-24\",\"grid2num\": \"1004\",\"empgg\": \"001\"},\"row2\": {\"grid2txt\": \"DC4-2-04A\",\"grid2txt2\": \"BBB-04A\",\"grid2date\": \"2045-12-24\",\"grid2num\": \"2004\",\"empgg\": \"002\"}},\"dc5\": {\"row1\": {\"nongrid_num\": \"104\",\"nongrid_largetext\": \"TEST -04A\"}}}},{\"transid\": \"tst23\",\"axm_recid\": \"axm_1122333\",\"action\": \"create\",\"sequenceno\":\"2\",\"returnfield\": \"txtfld\",\"submitdata\": {\"dc1\": {\"row1\": {\"txtfld\": \"QWWQQWWAB8\",\"txtfld2\": \"\",\"decnum\": \"04.00\",\"wholenum\": \"0404\",\"datafld\": \"2025-12-25\",\"timefld\": \"04:04 AM\",\"timestampfld\": \"2025-12-25\",\"dropdown\": \"Item2\",\"multifld\": \"mohan\",\"richtext\": \"t t 0404A\",\"chklist\": \"Check2,Check3\",\"chkbox\": \"T\",\"radiogrp\": \"Radio2\",\"empng\": \"001\"}},\"dc2\": {\"row1\": {\"gridtxt\": \"DC2-1-04A\",\"griddecimal\": \"4.00\",\"griddate\": \"2045-12-24\"},\"row2\": {\"gridtxt\": \"DC2-2-04A\",\"griddecimal\": \"5.04\",\"griddate\": \"2045-12-24\"},\"row3\": {\"gridtxt\": \"DC2-3-04A\",\"griddecimal\": \"6.00\",\"griddate\": \"2045-12-24\"}},\"dc3\": {\"row1\": {\"largetext\": \"TES SS TES 04A\"}},\"dc4\": {\"row1\": {\"grid2txt\": \"DC4-1-04A\",\"grid2txt2\": \"AAA-04A\",\"grid2date\": \"2045-12-24\",\"grid2num\": \"1004\",\"empgg\": \"001\"},\"row2\": {\"grid2txt\": \"DC4-2-04A\",\"grid2txt2\": \"BBB-04A\",\"grid2date\": \"2045-12-24\",\"grid2num\": \"2004\",\"empgg\": \"002\"}},\"dc5\": {\"row1\": {\"nongrid_num\": \"104\",\"nongrid_largetext\": \"TEST -04A\"}}}}]}]}


DB Script:
----------
create table AxSaveAPIResult( 	
CallerId varchar(100),
CallSequence varchar(20),
Transid varchar(10),
Keyfield varchar(100),
KeyValue varchar(200),
InputJSON text,
ResultString text,
RequestDatetime timestamp,
RequestedBy varchar(100))