AxRedisWrite API:
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

AxInterface function to call this api from product:
Function: AxRedisReadAPI(AccessCode, InMemoryKey, InMemorySubKey, IsBinary, successCB = () => { }, errorCB = () => { })
        Ex.:1. AxRedisReadAPI('pgbase114','pgbase114-testuser','','true')
            2. AxRedisReadAPI('pgbase114','pgbase114-testuser','user1','true')


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
