Following changes are released in this release:
1) TASK-4450 Remove unused nodes in appsettings.json of ARM
* Following nodes are removed in appsettings.json:
"AppConfig": {

"RMQPassword": ",
"RMQPort": ",
"RMQUser": ","
" "QueueName": "RapidSaveQueue",
 "URL": "http://localhost/axpertwebscripts/ASBTStructrest.dll/datasnap/rest/TASBTstruct/savedata",
 "METHOD": "POST","
"Client": "Axpert"
},
"EmailConfiguration": {
  "From": "agilebiz.support@agile-labs.com",
  "SmtpServer": "smtp.office365.com",
  "Port": 587,
  "Username": "agilebiz.support@agile-labs.com",
  "Password": "Agile@12345",
  "URL": "http://20.244.123.19/ARMTest/ARMNotify"
}"
"ParallelTasksCount": 25,
"Islogging": true,
"ARMConfigFilePath": "C:\\CodeFinal\\AgileConnect_Latest\\ARMConfigs.Json",
"ARM_PrivateKey": "ghsYrE8v89JBFtaoe0YbEePL",
"AxpertWeb_URL_hcmdev": "http://localhost:56647/",
 "AxpertWebScripts_URL": "http://localhost/AxpertWebScripts",
jsonData: "D:\\Deepti\\AgileConnect\\data.Json",
  "geoData": "D:\\Deepti\\AgileConnect\\geo.json",
  "OTPLength": 6,
  "OTPMaximumattempt": 3,
  "OPENAIAPIKEY": "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",
"SingalRIPList": [
  "http://localhost",
  "https://localhost:44318",
  "http://localhost:56647",
  "http://10.62.1.11"
]"
"LoggingConfig": {
  "IsLoggingEnabled": true,
  "AllowedApis": [
    "ARMSignIn",
    "ARMGETMenu",
    "ARMExecuteAPI"
  ]
}"
  "ARMAXPERTAI": "I need a list of fields that could be included in a '$formtype$' form. Expected output format sample: [{\"fieldId \" : \"vaccDate\", \"fieldName\" : \"Vaccination Date\", \"fieldType\" : \"Date\", \"fieldLength \" : \"20\"}]"


Following nodes are only used in appsettings json:
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "Jwt": {
    "Key": "ARM-JWTKEY-12evbayut23y4ejhsd621362qgad",
    "KId": "ARM-INTERNAL-170B360CEC1906992A328RS256",
    "Issuer": "Axpert - ARM",
    "Audience": "Axpert - ARM",
    "ExpiryMinutes": 300
  },
  "SSO-JWT-AUTH": {
    "Issuer": [ "https://sso-stg.transperfect.com", "Issuer2" ],
    "Audience": [ "GHCM", "GCHM2" ],
    "JWKSFilePath": "SecureData\\JWKS\\E2E_JWKS.json"
  },
  "AppConfig": {
    "RMQIP": "amqp://guest:guest@localhost:5672",
    "SSO-JWT-AUTH": false
  }
}

Remove old appsettings.json and replace it with new and change "RMQIP" based on your server.
2) TASK-4459 Remove roles in Tstruct Structdef caching keys. Internal fix. Struct def cache in redis will not have role names in key (search for transid in redis after AxGet or AxPut)