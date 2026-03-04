This release has fix for the following points:

1) TASK-4971 -PayBooks- ODBC connection issue in Managed Postgre instances when using the complex password with special characters.
* When complex password having characters like Agile+Labs0@com<%+{ , DB is not connecting. This is fixed now.

2) TASK-4975 AxAudit column should capture hh:mi:ss:sss (Millisecond) Customer - Paybooks Technologies
* AXIS - Axput API is changed to add milliseconds to the modifiedon/createdon nodes based on a optional boolean flag named "millisecsintimestamp".
* millisecsintimestamp = false. Sets modifiedon/createdon without milliseconds
* millisecsintimestamp = true. Sets modifiedon/createdon with milliseconds.

Sample input Json of AxPut:

{....
    "validateonly": false,    
    "millisecsintimestamp": true, 
    "data": [...]
}

3) TASK-4901 AxList API - Dimensions based filtering is added to Data Listing page
* Connected data in data page is not loading in latest API and now its been fixed.


Consumer Services:
-----------------
TASK-4983 -- Enhancement: ARMAxpertJobsConsumer exe service has been converted to Worker service and avoided hangfire db for job scheduling. Accordingly, default dependency of postgre db has been avoided and Redis functionality introduced for scheduling the Jobs. Incase redis keys cleared / flushall, this worker service needs to be restarted. 
Note: Please note the following points to set this worker service.
      1. The service needs to be started with the following command in command prompt.
         Service Start command ex.:
          sc create ARMAxpertJobsWorkerService binPath= "D:\AxpertJobService\ARMAxpertJobsWorkerService.exe D:\AxpertJobService\appsettings.json"
          sc start ARMAxpertJobsWorkerService  
      2. This service wanted to stop or remove from the windows service needs to be run below command.
          Ex.: sc stop ARMAxpertJobsWorkerService
               sc delete ARMAxpertJobsWorkerService   
      3. Please follow for Linux to start this consumer service. 
          a. Create a folder for your service:
              /home/ubuntu/ARMAxpertJobsWorkerService/
          b. Create the systemd service file
              sudo nano /etc/systemd/system/ARMAxpertJobsWorkerService.service
          c. Reload system
              sudo systemctl daemon-reload
          d. Enable the service at boot
              sudo systemctl enable ARMAxpertJobsWorkerService
          e. Start the service
              sudo systemctl start ARMAxpertJobsWorkerService
          f. Check status
              sudo systemctl status ARMAxpertJobsWorkerService
          g. To STOP / RESTART the service
              sudo systemctl stop ARMAxpertJobsWorkerService
              sudo systemctl restart ARMAxpertJobsWorkerService


TASK-4984 -- Enhancement: ARMCachedSaveConsumer exe service has been converted to Worker service. 
Note: Please note the following points to set this worker service.
      1. The service needs to be started with the following command in command prompt.
         Service Start command ex.:
          sc create ARMCachedSaveWorkerService binPath= "D:\CachedSaveWorkerService\ARMCachedSaveWorkerService.exe D:\CachedSaveWorkerService\appsettings.json"
          sc start ARMCachedSaveWorkerService  
      2. This service wanted to stop or remove from the windows service needs to be run below command.
          Ex.: sc stop ARMCachedSaveWorkerService
               sc delete ARMCachedSaveWorkerService   
      3. Please follow for Linux to start this consumer service. 
          a. Create a folder for your service:
              /home/ubuntu/ARMCachedSaveWorkerService/
          b. Create the systemd service file
              sudo nano /etc/systemd/system/ARMCachedSaveWorkerService.service
          c. Reload system
              sudo systemctl daemon-reload
          d. Enable the service at boot
              sudo systemctl enable ARMCachedSaveWorkerService
          e. Start the service
              sudo systemctl start ARMCachedSaveWorkerService
          f. Check status
              sudo systemctl status ARMCachedSaveWorkerService
          g. To STOP / RESTART the service
              sudo systemctl stop ARMCachedSaveWorkerService
              sudo systemctl restart ARMCachedSaveWorkerService
