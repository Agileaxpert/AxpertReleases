Following enhancement for AXIS APIs is released in this release:
1) TSK-0020 Handle Tstruct Attachments in AxPut micro services

Note:
Retest signin API as Global variables case sensitive issue to bind values is fixed.

Release note:
1) TSK-0020 Handle Tstruct Attachments in AxPut micro services

* The AxGet and AxPut APIs are enhanced to support attachments.
* Following attachment types are supported:
 - Image type attachment
 - AXPFile_ prefixed File uploads (Both grid and non grid)
 - Header attachments.
* An attachment can be deleted using "delete" : true flag in attachment object.
* Postman collection is shared in this release.

Sample Attachment object:
--------------------------
Create/edit attachment:
{
	"FileName": "attach2.png",                    
	"AttachmentType": "HEADERATTACHMENTS", //IMAGE, AXPFILE, HEADERATTACHMENTS
	"DataFormat": "BASE64",
	"FileData": "Base 64 string of the attachment"
}

Delete attachment:
{
	"FileName": "attach2.png",
	"Delete": true
}


Passing Header attachments in Axput input JSON:
----------------------------------------------------
* A new node "Attachments" is added as part of recordwise nodes in AxPut API.
* Multiple files can be passed for header attachments.
Sample JSON - Create/Edit attachment:
{
    "ARMSessionId": "{{session}}",
    "Trace": true,
    "ValidateOnly": false,
    "MilliSecsInTimeStamp": false,
    "Data": [
        {
            "transid": "ates1",
            "Action": "create",
            "SubmitData": {
                "dc1": {
                    "row1": {
                        "caption": "test21"                        
                    }
                }
            },
            "Attachments": [
                {
                    "FileName": "attach1.png",                
                    "AttachmentType": "HEADERATTACHMENTS",
                    "DataFormat": "BASE64",
                    "FileData": "Base 64 string of the attachment"
                },
                {
                    "FileName": "attach2.png",                    
                    "AttachmentType": "HEADERATTACHMENTS",
                    "DataFormat": "BASE64",
                    "FileData": "Base 64 string of the attachment"
                }
            ]
        }
    ]
}

Sample JSON - Delete attachment:
{
    "ARMSessionId": "{{session}}",
    "Trace": true,
    "ValidateOnly": false,
    "MilliSecsInTimeStamp": false,
     "Data": [
        {
            "Action": "edit",
            "transid": "ates1",
            "keyfield": "recordid",
            "keyvalue": "100000000006746",
            "SubmitData": {
                "dc1": {
                    "row1": {
                        "axp_recid": "100000000006746",
                        "axrow_action": "edit",
                        "caption": "test17"
                    }
                }
            },
            "Attachments": [
                {
                    "FileName": "attach2.png",
                    "Delete": true
                }
            ]
        }
    ]
}

Passing Image type fields in Axput input JSON:
----------------------------------------------------
* Here the Attachment object is serialized. profilepic  is a image type field.
* Only one file can be passed for image type fields.
Sample JSON - Create/Edit Image::
{
    "ARMSessionId": "{{session}}",    
    "Trace": true,
    "ValidateOnly": false,
    "MilliSecsInTimeStamp": false,
    "Data": [
        {
            "transid": "ates1",
            "Action": "create",
            "SubmitData": {
                "dc1": {
                    "row1": {
                        "caption": "test21",
                        "profilepic": "{\"FileName\":\"profilepic.dll\",\"AttachmentType\":\"IMAGE\",\"DataFormat\":\"BASE64\",\"FileData\":\"Image file in base64 format\"}"
                    }
                }
            }
        }
    ]
}

Sample JSON - Delete Image::
{
    "ARMSessionId": "{{session}}",    
    "Trace": true,
    "ValidateOnly": false,
    "MilliSecsInTimeStamp": false,
    "Data": [
        {
            "Action": "edit",
            "transid": "ates1",
            "keyfield": "recordid",
            "keyvalue": "100000000006746",
            "SubmitData": {
                "dc1": {
                    "row1": {
                        "axp_recid": "100000000006746",
                        "axrow_action": "edit",
                        "caption": "test21",
                        "profilepic": "{\"Delete\":true}"
                    }
                }
            }
        }
    ]
}


Passing AXPFILE_ prefixed File uploads in Axput input JSON:
----------------------------------------------------
* Here the Attachment object is serialized.
* Multiple files can be passed for header attachments.

Sample JSON - Create/edit attachments:
{
    "ARMSessionId": "{{session}}",    
    "Trace": true,
    "ValidateOnly": false,
    "MilliSecsInTimeStamp": false,
    "Data": [
        {
            "transid": "ates1",
            "Action": "create",
            "SubmitData": {
                "dc1": {
                    "row1": {
                        "caption": "test21",
                        "axpfile_pic1": "[{\"FileName\":\"pic1.png\",\"AttachmentType\":\"AXPFILE\",\"DataFormat\":\"BASE64\",\"FileData\":\"File in base64 format\"},{\"FileName\":\"pic2.png\",\"AttachmentType\":\"AXPFILE\",\"DataFormat\":\"BASE64\",\"FileData\":\"File in base64 format\"}]"
                    }
                }
            }
        }
    ]
}

Sample JSON - Delete attachments:
{
    "ARMSessionId": "{{session}}",
    "AxSessionId": null,
    "Project": null,
    "UserName": null,
    "Trace": true,
    "ValidateOnly": false,
    "MilliSecsInTimeStamp": false,
    "Data": [
        {
            "Action": "edit",
            "transid": "ates1",
            "keyfield": "recordid",
            "keyvalue": "100000000006746",
            "SubmitData": {
                "dc1": {
                    "row1": {
                        "axp_recid": "100000000006746",
                        "axrow_action": "edit",
                        "caption": "test17",
                        "profilepic": "{\"Delete\":true}",
                        "axpfile_pic1": "[{\"FileName\": \"270420261211106365388pic1.png\",\"Delete\":true}]"
                    }
                },
                "dc2": {
                    "row1": {
                        "axp_recid": "100000000006747",
                        "axrow_action": "edit",
                        "caption2": "test122",
                        "axpfile_gridpic1": "[{\"FileName\": \"pic1.png\",\"Delete\":true}]"
                    }
                }
            }
        }
    ]
}
