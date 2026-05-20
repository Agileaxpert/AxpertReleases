FOllowing issues are fixed in this release:
------------------------------------------
1) TSK-0120 AxGet and AxPut - Support for MS SQL with attachments
	- MS SQL DB support is added for AxGet and AxPut AXIS APIs with attachments.

2) TSK-0121 ARM microservices -Avoid app pool recycle when a new application got added from AXI
	- The requirement for 'Application pool recycle' in ARM microservices layer when new app is added or any details getting modified in axpertadmin.aspx page is removed. Now IIS App pool is only needed when DB/Redis config data is changed for that user.
	
3) TKT-0054 Require Cancel Columns and Messaging for Canceled Records
	- Now 'Canceled?' and Cancel remarks column is available in data listing page and those fields can be used in Field selection and filtering
	- Cancellation data is visible in 'Data Page' similar to tstruct page.
	- Same columns are visible in connected data in 'Data Page'.

4) TASK-4654 ● Cancel entries not visible in List View – Web Version 11.4 Customer - Kotecha Partner - Better Works
	- Duplicate of ticket TKT-0054

5) TKT-0061 ! When modifying configurations such as select field, charts, and hyperlink in datalisting page the system is inserting new records into the ax_userconfigdata table instead of updating the existing record.
	- Fixed. Duplicate rows wont be created now in oracle schema. 
	- Note:
		* Solutions team has to do data correction to remove old duplicate records from ax_userconfigdata table.

6) TKT-0160 Hidden columns to be removed from Data List Page Customer - Agile Labs Pvt Ltd
	- Hidden columns wont be visible in Data Listing page now.

7) TKT-0022	 When the caption is removed for a field in Dev Studio, the field caption is displayed as "null" in the Data Listing page and Data Page during runtime
	- This issue is fixed. It will show empty caption intead of null.

8) TKT-0143 FCM access token generation code change (Firebase notification for mobile)
	- Firebase mobile notification API (<ARM_URL>/ARM_APIS/api/v1/SendFCMNotification) is modified to handle new token generation logic.

9) TKT-0225 Error gets logged in 'Event viewer" when any API fails.
	
Note:
-----
* After import scripts for MS SQL is relased in this patch.	
* In oracle schema, solutions team has to do data correction to remove old duplicate records from ax_userconfigdata table. (TKT-0061)