TKT-0296 -Axi ERP- Enhancement - API required to add a new field to a tstruct from front end using executeapi script Customer 
Note: AxAddForm and AxAddField api's are introduced in AxStructUtils micro service. 
AxAddForm:
URL:  http://localhost/ARM_API/AxStructUtils/api/v1/AxAddForm
Payload: {
    "ARMSessionId": "ARMSessionId",
    "mode": "new",
    "trace": false,
    "structName": "transid",
    "structCaption": "caption",
    "structType": "tstruct",
    "isComp": false,
    "compJSON": "{}",
    "propvalJSON": "{\"name\":\"transid\",\"caption\":\"caption\",\"schema\":\"\",\"menuaccess\":true,\"pform\":\"yes\",\"saveCtrlFld\":\"\",\"saveCtrlFldCaption\":\"\",\"saveCtrlFldsDDN\":\"\",\"dltCtrlFld\": \"\",\"dltCtrlFldCaption\":\"\",\"dltCtrlFldsDDN\":\"\",\"tracking\":false,\"trackby\":\"\",\"trackusrs\": \"\",\"trackUsrsDDN\":[],\"trackfldOption\":\"\",\"trackFlds\":\"\",\"trackFldCaps\":\"\",\"trackFldsDDN\":[],\"allowconfig\":false,\"enablecache\":false,\"enablewf\":false,\"allowattch\":false,\"enableListVW\":true,\"purpose\":\"\"}",
    "fieldJSON": "{\"dcName\":\"dc1\",\"asgrid\":\"F\",\"autogenStr\":\"||0|True|0\",\"saveValue\":\"T\",\"name\":\"field name\",\"caption\":\"field caption\",\"fieldType\":\"Simple Text\",\"dataType\":\"Character\",\"width\":\"50\",\"decimal\":\"0\",\"MOE\":\"Accept\",\"allowEmpty\":\"T\",\"allowDuplicate\":\"T\",\"fldPosition\":\"After field\"}",
    "runtimeInfo": "{\"formtype\":\"simple\"}"
}

AxAddField:
URL: http://localhost/ARM_API/AxStructUtils/api/v1/AxAddField
Payload:{
    "ARMSessionId": "ARMSessionId",
    "mode": "new",
    "trace": false,
    "structName": "transid",
    "structCaption": "form caption",
    "structType": "tstruct",
    "isComp": true,
    "compJSON": "{}",
    "fieldJSON": "{\"fldsdatatypes\":\"\",\"autogenStr\":\"||0|True|0\",\"saveValue\":\"T\",\"dcName\":\"dc1\",\"asgrid\":\"F\",\"name\":\"field name\",\"defSrcField\":\"\",\"defSrcFieldCaption\":\"\",\"caption\":\"field caption\",\"fieldType\":\"Check box\",\"dataType\":\"Character\",\"width\":\"20\",\"decimal\":\"0\",\"MOE\":\"Accept\",\"allowEmpty\":\"T\",\"allowDuplicate\":\"T\",\"fldPosition\":\"After field\"}",
    "runtimeInfo": "{}"
}

TSK-0214 -QA- API to add fields. This API can be used in tstructs and custom pages to add a field to a tstruct. It should have capability to add to any DC in the tstruct.