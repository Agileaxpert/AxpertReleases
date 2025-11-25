<<
update executeapidef set apitype='General' where apicategory !='Drop Down';
>>

<<
update executeapidef set apitype='Bind API to Dropdown field from Axpert',isdropdown='T' where apicategory ='Drop Down' and apiresponsetype='Axpert'; 
>>

<<
update executeapidef set apitype='Bind API to Dropdown field from External',isdropdown='T' where apicategory ='Drop Down' and apiresponsetype='External';
>>

<<
alter table axpertlog add calldetails varchar(2000);
>>