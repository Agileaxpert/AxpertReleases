For Front end developers:
-------------------------
1) New flag 'refreshCache' (boolean type, valid values are true/false) has been added as part of Entity-Common -> getDataFromDataSource method.
2) Default value is false (boolean type)
3) To reload data from DB, Frontend Developers can add button (page/card level) and pass the 'refreshCache' flag value as true.


For Cache: (Enable caching by default)
----------------------
update axdirectsql set cachedata = 'T'
update axdirectsql set cacheinterval = '6 Hr'


For ARM Promotion:
-------------------
1) Apply on top of dev_release7. No change in appsettings.json


Release notes changes:
1) Refresh cache key details in datasource API
2) Refresh cache key details in Cards API
3) View filters
