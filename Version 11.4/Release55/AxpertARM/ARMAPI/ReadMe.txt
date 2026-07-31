Following tickets are fixed in following release:
1) TKT-0615	Implement Double Encryption with Seed for Password in ARM SignIn API (Signin API change) 
2) TKT-0614	axList API Fails to Execute MSSQL ADS Queries with Parameters (AxList API change) 
   - Issue: MSSQL - Data is filtering based on SQL param but total records are showing as  "totalrecords": "-1"
   * "totalrecords": "-1" when in ADS definition On Enable of "Add Dynamic tag" toggle button
* Note : In trace it is showing "The ORDER BY clause is invalid in views, inline functions, derived tables, subqueries, and common table expressions, unless TOP, OFFSET or FOR XML is also specified."

3) TKT-0649	AxPut API Validation Error for Valid Records (AxPutAPI change)
   - Issue1: For the Select From Form field (with Save Normalized = True), the API returns the following validation error in the response:"Validation Fail: Field 'selectffn' (Row No: 1) with value 'EMP-0004'; \"EMP-0004\" is not a valid Select Form form Normalized"
- Issue 2: For mssql - Validation is not showing in Response but data is not inserting into db and Fill fields also not saving

4) TKT-0574	The Forgot Password functionality is not working as expected in flutter apk  (New forgot password API)
5) TASK-0299	Unable to change the password  (New Change Password API)

6) TSK-0468	-> AES encryption support in Signin, AxForgotPassword and AxResetPassword APIs
* Fixed. AES encryption is enabled for following APIs 
- Signin
- AxForgotPassword 
- AxResetPassword

7) * TSK-0494	Parallel API calls are throwing errors (Random issue)
- Sometimes when APIs like AxPut (Save data) is executed in parallel (at same time), then we were getting errors randomly. This was fixed.
Note:
* Try to simulate the scenario using load testing tools.
* I have attached a custom load testing tool to test the exact same issue. Read the README.md file in visual studio code for instuctions.

1) TKT-0615	Implement Double Encryption with Seed for Password in ARM SignIn API (Signin API change) 
* Seed node is now mandatory and user has to do do double MD5hashing with seed for increased security.
Eg:
Input password = agile
PasswordHash1 = MD5(agile) = 22723bbd4217a0abf6d3e68073c7603d
Random seed = 123456 (This should be random number for increased security)
PasswordHash2 = MD5(Random seed  + PasswordHash1)  -> MD5(123456 + 22723bbd4217a0abf6d3e68073c7603d) -> 40e39203e4447a772d07710cf788eeb1

Sample JSON:
{
    "appname": "pgbase114", 
    "UserName": "mohan",  
    "password": "40e39203e4447a772d07710cf788eeb1", 
    "Language": "English",
    "Seed": "123456",
    "SessionId": "{{unique_id}}",
    "Globalvars": true, //true
    "ClearPreviousSession": true, //true,
    "trace" : true
}

2) TKT-0614	axList API Fails to Execute MSSQL ADS Queries with Parameters 
* Fixed. Now ADS with param names starting with : will work in MSSQL.

3) TKT-0649	AxPut API Validation Error for Valid Records (AxPutAPI change)
* Fixed. QA should test all cased involving Fill field from normalized/Not normalized dropdown source.

4) TKT-0574	The Forgot Password functionality is not working as expected in flutter apk  (New forgot password API)
* New AxForgotPassword API is added to AxAuth microservice.

cURL:
postman request POST 'http://localhost:5142/api/v1/AxForgotPassword' \
  --header 'Content-Type: application/json' \
  --body '{
    "appname": "pgbase114", 
    "UserName": "mohan",  
    "Email": "mohankumar.j@agile-labs.com",
    "trace" : true
}
'

Response:
{"result":{"success":true,"message":"Password updated successfully. Please check to your registered mail."}}

5) TASK-0299	Unable to change the password  (New Change Password API)
* New AxResetPassword API is added to AxAuth microservice.
cURL:

postman request POST 'http://localhost:5142/api/v1/AxResetPassword' \
  --header 'Content-Type: application/json' \
  --body '{
    "appname": "pgbase114", 
    "UserName": "mohan",  
    "OldPassword": "3c04b09227590efb53b3603c1121b172", //MD5 sting of password
    "NewPassword": "Agile@12345",
    "trace" : true
}
'

Response:
{"result":{"success":true,"message":"Password Updated Sucessfully"}}

Note:
Signin API is modified to handle the force password change flag.
Sample response:
{
    "result": {
        "success": false,
        "message": "Please change the password to continue.",
        "change_password": true,
        "Trace": "http://localhost:5142/api/v1/GetTrace/Login-mohan_19Jul2026_231822061_1f3d3d3c025e45a1ab4432d65d79fc19.html"
    }
}