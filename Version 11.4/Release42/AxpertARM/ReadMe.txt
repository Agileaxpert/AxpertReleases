Following ticket is fixed in this release:

1) TASK-4595 Postgres DB - Support ODBC connections, support axprops -> searchpath Customer - Paybooks Technologies
* Added support for Postgres with ODBC connections (Same config as axpert web)
* Added support to configure search path as per application need in case of ODBC. Search path has to be configured in Axprops.xml of the ARM scripts folder and Axpert Scripts folder.

Sample Axprops.xml:
<axprops getfrom="" setto=""><lastlogin>pgbase114</lastlogin><oradatestring>dd/mm/yyyy hh24:mi:ss</oradatestring><crlocation></crlocation><lastusername>admin</lastusername><login>local</login><skin>Black</skin><lastlang>ENGLISH</lastlang><axhelp>true</axhelp><pgbase114odbc>pgbase114</pgbase114odbc></axprops>

Here, app-specific searchpath has to be added like <pgbase114odbc>pgbase114</pgbase114odbc>.

Following tickets are fixed in this release:

1) TASK-4481 ARM enhancement: Create a new AppSettingsValidater class and new API ValidateAppSettings

API Details:
 curl --location 'http://localhost:5000/api/v1/ValidateAppSettings' \
--header 'Content-Type: application/json' \
--data '{
    "appname": "orclbase114"
}'

Output:
This API will return validation messages and errors with following checks:

1) Appsettings json - Exits or not - Done
2) Appsettings ini - Exits or not - Done
3) Appsettings.ini - Valid JSON or not - Done
4) Project node in appconnection - exists or not
5) Project node in appsettings - exists or not
6) ARMScripts url, arm url - exists or not
7) Axprops.xml in script URL - exists or not.
8) Axapps.xml in script URL - exists or not.
9) Project name inside Axapps.xml in script URL - exists or not.
10) Servicekey json - exists or not.
11) Redis, LicDomain, RMQ connection - valid or not.

2) TASK-4540 Appsettings.json clearnup - Remove clientsso, JWT expirymins, RMQ. Read from appsettings.ini
ClientSSO -  Code cleanup:

Removed following nodes from appsettings.json:
"Jwt": {
 "ExpiryMinutes" : 300
},
"SSO-JWT-AUTH" : { .... Client SSO details .... },
"AppConfig": {
 "RMQIP": "amqp://guest:guest@localhost:5672", 
 "SSO-JWT-AUTH": false
}

Now, RMQIP and Expiry mins will be loaded from appsettings.ini

 
3)TASK-4541 ARMSigninDetails API enhancement - Add SSO details to the API

New SSO node is added to the ARMSigninDetails API. This will be used by mobile team.

curl --location 'http://localhost:5000/api/v1/ARMSigninDetails' \
--header 'Content-Type: application/json' \
--data '{
    "appname": "pgbase114"
}'

Sample Output:
{
    "result": {
        "success": true,
        "message": "success",
        "data": {
            "applogo": "",
            "appcolor": "#000000",
            "modifiedontime": "",
            "enablecitizenusers": false,
            "enablegeofencing": false,
            "enablegeotagging": false,
            "enablefingerprint": false,
            "enablefacialrecognition": false,
            "enableforceLogin": false,
            "days": "",
            "sso": {
                "windows": {
                    "ssoType": "windows",
                    "ssoWinDomain": "agilelabs.local",
                    "onlysso": "false"
                },
                "office365": {
                    "ssoType": "office365",
                    "of365clientkey": "9672b1c7-f388-49d5-9186-fc082692eca1",
                    "of365secretkey": "ad30ca08-d65f-4114-868b-f9145337d7cf",
                    "of365redirecturl": "https://malakonda/aw11.4/",
                    "onlysso": "false"
                },
                "saml": {
                    "ssoType": "saml",
                    "SamlPartnerIdP": "https://login.microsoftonline.com/0b1513a2-8f4d-4478-ab27-28da7a534984/saml2?prompt=login",
                    "SamlIdentifier": "SAML_Malakonda",
                    "SamlCertificate": "SAML_Malakonda.cer",
                    "SamlRedirectUrl": "https://malakonda/aw11.4/",
                    "onlysso": "false"
                }
            }
        }
    }
}
