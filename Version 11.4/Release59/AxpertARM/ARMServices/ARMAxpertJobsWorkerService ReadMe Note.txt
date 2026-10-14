TSK-0818 -- Enhancement: Separate Application Pools for ASBScriptRest.
Since multiple scheduled jobs for different projects are executed through the AxpertJobsWorkerServices, the concerned ARMScript application pool may experience heavy traffic. Consequently, CPU and memory utilization of the application pool can increase significantly.
To address this issue, the product has been enhanced to support configuring separate application pools for the ASBScriptRest DLL for different projects.
A separate configuration node can now be added under the APPConfig section in AppSettings.json using the following format:
"AccessCodeName_ASBScriptRest_URL": "http://localhost/ASBScriptRestSite/"
Ex.:  "AppConfig": {
  "pgbase114_ASBScriptRest_URL": "http://localhost/ASBScriptRestSite/"
}
Here, pgbase114 represents the AccessCode of the concerned project.
Note: For the ASBRestDll's application pool, configuring a 'Private Memory Limit' under the Application Pool Recycling settings is not required.

TKT-1230 -AxiERP - Axpert jobs is not firing as per the schedule

TKT-1284 -QA- Axpert jobs - Scripts defined in job definition is not getting executed while running the jobs

TKT-1295 -QA- Axpert jobs, we need an enhancement to schedule a Job to execute Yearly once

TSK-0792 -QA- AxpertJobs and AXNotify services not writing trace file
Note: A `trace` flag has been added to the `appsettings.json` file. By default, tracing is disabled.
When Webservice tracing is required, change the value to `"true"` and restart the service for the change to take effect.
Ex. : "AppConfig": {
   "trace": "false"
 }