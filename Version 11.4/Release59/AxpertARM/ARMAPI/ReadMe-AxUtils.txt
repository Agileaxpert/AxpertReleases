TSK-0847 -- AxGetQueueStatus – ARM Microservice API: 
The `AxGetQueueStatus` API has been introduced in the ARM microservice to check the status of RabbitMQ and the corresponding consumer service (`WorkerService`) for a specified queue.
Note: This is an Open API (Anonymous) and does not require `ARMSessionId` or `Token` to be passed in the request.
This can be used from Postman or from custom HTML pages to know the status of Queue and Consumer services(WorkerServices)


API Endpoint:
http://localhost/ARM_API/AxUtils/api/v1/AxGetQueueStatus

Request Payloads:

Payload 1 – Cached Save Queue:
{
    "QueueName": "CachedSaveQueue"
}

Payload 2 – Axpert Jobs Queue:
{
    "QueueName": "ARMAxpertJobsQueue"
}
Note: Pass the required queue name in the `QueueName` parameter to check its status. For example, `CachedSaveQueue` is the queue used for the Cached Save functionality. Similarly, provide the appropriate queue name for any other consumer service whose status needs to be checked.

