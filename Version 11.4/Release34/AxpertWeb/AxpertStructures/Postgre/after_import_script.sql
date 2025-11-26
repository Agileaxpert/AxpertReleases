<<
update executeapidef set apitype='General',apitypecnd=3 where apicategory !='Drop Down';
>>

<<
update executeapidef set apitype='Bind API to Dropdown field from Axpert',isdropdown='T',apitypecnd=1 where apicategory ='Drop Down' and apiresponsetype='Axpert';
>>

<<
update executeapidef set apitype='Bind API to Dropdown field from External',isdropdown='T',apitypecnd=2 where apicategory ='Drop Down' and apiresponsetype='External';
>>


<<
alter table axpertlog add calldetails varchar(2000);
>>