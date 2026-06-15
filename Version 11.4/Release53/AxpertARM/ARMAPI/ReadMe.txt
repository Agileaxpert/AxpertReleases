Following tickets are handled in the following release:

1) TSK-0164 Axput - Create db routines for AxGet and AxPut 
* Now, AxPut and AxGet API supports all 3 DBS - Postgres, MS SQL and Oracle.
* DB specific scripts are released with this release and it has to be imported  after applying patches.
* Test AxPut with attachments for all DB types.

2) TASK-5382 Axpert Flutter Apk Issue - If OTP enabled While login throwing error.
* Fixed this.

3) TASK-5383 Axpert Flutter Apk Issue - If OTP enabled unable to login. 
* Fixed as this is Duplicate issue of TASK-5382.

4) TSK-0265	 AxRefreshSession API
* AxRefreshSession API is used to extend a ARM session. After signin, this API can be called to extend the session back to original session expiry time.

API cURL:
postman request POST 'http://localhost/ARM_SIte/ARM_APIs/api/v1/AxRefreshSession' \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Bearer e...' \
  --body '{
    "ARMSessionId": "ARM-..."
}' \
  --auth-bearer-token 'e..'
  