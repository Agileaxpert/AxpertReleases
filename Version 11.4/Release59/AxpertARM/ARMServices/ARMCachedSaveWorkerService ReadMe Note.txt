TSK-0819 -- Enhancement: Separate Application Pools for ASBTStructRest.
Since multiple projects use the Import functionality and save large volumes of form data, the CachedSaveWorkerServices are used to process these operations. As a result, the concerned ARMScript application pool may experience heavy traffic, leading to increased CPU and memory utilization.
To address this issue, the product has been enhanced to support configuring separate application pools for the ASBTStructRest DLL for different projects.
A separate configuration node can now be added under the APPConfig section in AppSettings.json using the following format:
"AccessCodeName_ASBTStructRest_URL": "http://localhost/ASBTStructRestSite/"
Ex.: "AppConfig": {
  "pgbase114_ASBTStructRest_URL": "http://localhost/ASBTStructRestSite/"
}
Here, pgbase114 represents the AccessCode of the concerned project.
Note: For the ASBRestDll's application pool, configuring a 'Private Memory Limit' under the Application Pool Recycling settings is not required.