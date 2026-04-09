Following point is fixed in this release:
1) TASK-5593 -- AxPut API - MDMap feature is added

2) TASK-5121 Transaction data should capture Timestamp in the format [yyyy-MM-dd HH:mm:ss.SSS] Customer - Paybooks Technologies

Note: Following flag 'millisecsintimestamp' (boolean) is added in AxPut, AxGet, AxDelete, AxCancel API input json to accept/return timestamp data with milliseconds.

"millisecsintimestamp": true

Sample JSONs:
AxGet:
{
    "ARMSessionId": "{{session}}",
    "action": "view",
    "trace": true,
    "transid": "tst23",
    "keyfield": "recordid",
    "keyvalue": "100000000006215",
    "AxpertWSFormat": false,
    "AxClient_DateFormat": "dd-MMM-yyyy",
    "MilliSecsInTimeStamp" : true
}

AxPut:
{
    "ARMSessionId": "{{session}}",
    "trace": false,
    "validateonly": false,
    "axclient_dateformat": "yyyy-MM-dd",
    "millisecsintimestamp": true,
    "data": [...]
}

AxDelete:
{
    "ARMSessionId": "{{session}}",
    "trace": true,
    "transid": "tst23", //cg2gs //cg2gt
    "keyfield": "recordid",
    "keyvalue": "100000000006322",
    "millisecsintimestamp": true
}

AxCancel:
{
    "ARMSessionId": "{{session}}",
    "trace": true,
    "transid": "tst23", //cg2gs //cg2gt
    "keyfield": "recordid",
    "keyvalue": "100000000006339",
    "Remarks": "Cancelled by admin",
    "millisecsintimestamp": true
}