AxRedisDelete API:
---------------------
http://localhost/ARM_API/AxUtils/api/v1/AxRedisDelete

Payload:
{
    "AccessCode": "pgbase114",
    "InMemoryKey": "pgbase114-statuskey-2"
}

Response: 
{
    "success": true,
    "message": "Key 'pgbase114-statuskey-2' deleted successfully."
}
resposne2:
{
    "success": false,
    "message": "Key 'pgbase114-statuskey-2' not found."
}

Payload2:
{
    "AccessCode": "pgbase114",
    "InMemoryKey": "pgbase114-statuskey-*"
}
Response: 
{
    "success": true,
    "message": "1 key(s) deleted successfully."
}

Payload3:
{
    "AccessCode": "pgbase114",
    "InMemoryKey": "pgbase114-*"
}
Response: 
{
    "success": true,
    "message": "2 key(s) deleted successfully."
}

AxInterface function to call this api from product:
Function: AxRedisDeleteAPI(AccessCode, InMemoryKey, successCB = () => { }, errorCB = () => { })
        Ex.: 1. AxRedisDeleteAPI('pgbase114','pgbase114-testuser-1')
             2. AxRedisDeleteAPI('pgbase114','pgbase114-testuser-*')

----------

AxRedisRead API:
-------------------
API URL: http://localhost/ARM_API/AxUtils/api/v1/AxRedisRead

PayLoad:
{
    "AccessCode": "pgbase114",
    "InMemoryKey": "pgbase114-htmldata",
     "InMemorySubKey":"", //This is optional and any hashed key used to read this has to be passed 
    "IsBinary": "true" //data stored as binary format this should pass as true or false for string format data
}

Response success: 
{
    "success": true,
    "message": "String key",
    "result": "[{\"stype\":\"Iview\",\"structname\":\"ivpramex\",\"context\":\"\",\"sfield\":\"\",\"icolumn\":\"\",\"sbutton\":\"\",\"hlink\":\"\",\"props\":\"FetchSize\",\"propsval\":\"25\",\"propvalue2\":\"\",\"applyon\":\"ALL\"},{\"stype\":\"Iview\",\"structname\":\"ivpramex\",\"context\":\"\",\"sfield\":\"\",\"icolumn\":\"\",\"sbutton\":\"\",\"hlink\":\"\",\"props\":\"Preview file in Reports instead of download\",\"propsval\":\"false\",\"propvalue2\":\"\",\"applyon\":\"ALL\"}]"
}

Response 2: 
{
    "success": false,
    "message": "Key 'goldendump114~axpertdb-ivpramex-axivconfigstruct-default-ALL-q' not found",
    "result": null
}

PayLoad2:
{
    "AccessCode": "pgbase114",
    "InMemoryKey": "pgbase114-*",
     "InMemorySubKey":"", //This is optional and any hashed key used to read this has to be passed 
    "IsBinary": "true" //data stored as binary format this should pass as true or false for string format data
}

Response success: 
{
    "success": true,
    "message": "3 key(s) found",
    "result": "{\r\n  \"pgbase114-statuskey-test-♣\": {\r\n    \"agile\": \"Agile labs bangalore\"\r\n  },\r\n  \"pgbase114-statuskey-2-♣\": {\r\n    \"agile\": \"Agile labs bangalore\"\r\n  },\r\n  \"pgbase114-statuskey-1-♣\": {\r\n    \"agile\": \"Agile labs bangalore\"\r\n  }\r\n}"
}
AxInterface function to call this api from product:
Function: AxRedisReadAPI(AccessCode, InMemoryKey, InMemorySubKey, IsBinary, successCB = () => { }, errorCB = () => { })
        Ex.:1. AxRedisReadAPI('pgbase114','pgbase114-testuser','','true')
            2. AxRedisReadAPI('pgbase114','pgbase114-testuser','user1','true')

--------------

AxRedisWrite API:
---------------------
http://localhost/ARM_API/AxUtils/api/v1/AxRedisWrite

Payload:
{
    "AccessCode": "goldendump114",
    "InMemoryKey": "goldendump114-companylist",
    "InMemorySubKey": "agile", //This is optional and any hashed key used to read this has to be passed 
    "InMemoryValue": "Agile labs Bangalore",
    "IsBinary": "true" //data stored as binary format this should pass as true or false for string format data
    "KeyExpiryInMins":"15" // If this is not pass will key be expired automatically in 10 mins. 
}

Response: 
{
    "success": true,
    "message": "Hash field created successfully",
    "result": null
}

AxInterface function to call this api from product:
Function: AxRedisWriteAPI(AccessCode, InMemoryKey, InMemorySubKey, InMemoryValue, IsBinary,KeyExpiryInMins, successCB = () => { }, errorCB = () => { })
        Ex.: 1. AxRedisWriteAPI('pgbase114','pgbase114-testuser','','test value','true','10')
             2. AxRedisWriteAPI('pgbase114','pgbase114-testuser','user1','test value','true','10')




