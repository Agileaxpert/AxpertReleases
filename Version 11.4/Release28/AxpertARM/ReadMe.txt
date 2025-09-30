TASK-2038 -- Merge GetDataFromDataSource API with AxList API
Notes:
ARM API Changes:
1) ARM GetDataFromDataSource API is withdrawn. AxList API can be used instead of this with changes in input JSON with new ADS = true/false flag. 
	a. Additional flag 'ADS' is introduced to execute the API as datasource.
		- ADS = true will execute API with datasource permission
		- ADS = false (default value) will execute API with user permission from config studio
        b. Encrypted data has been handled to decrypt and provide the output. Please note, AxpertDataSource definition screen has been enhanced to accept the Encrypted column names those are present in SQL statements. If these columns are defined, then AxList API will return the decrypted value of these columns. 
	
Axpert Web Changes:
1) EntityCommon.getDataFromDataSource method is deprecated. 
2) Use EntityCommon.getDataFromAxList method (for Entity/EntityForm) or AxInterface.GetDataFromAxList (For custom html plugins) instead
3) API output Data format has been changed and data_json node is removed. 

AxList API samples:
A fully functional example of use cases of AxList API in Axpert is demonstrated here using a HTML plugin.

GitHub Link: https://github.com/Agileaxpert/Axpert/tree/main/Axpert%20Samples/Axpert%20APIs/AxList%20API


TASK-0041 -- Cross platform - Sign In API: Cross platform Sigin API is modified to handled the application variable types. There was a mismatch in variable names and variable types.