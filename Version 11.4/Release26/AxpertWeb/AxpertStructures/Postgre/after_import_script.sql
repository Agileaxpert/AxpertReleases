<<
update axpdef_axpertprops set mob_citizenuser='F';
>>

<<
update axpdef_axpertprops set mob_geofencing='F';
>>

<<
update axpdef_axpertprops set mob_geotag='F';
>>

<<
update axpdef_axpertprops set mob_fingerauth='F';
>>

<<
update axpdef_axpertprops set mob_faceauth='F';
>>

<<
update axpdef_axpertprops set mob_forcelogin='F';
>>

<<
update axpdef_axpertprops set mob_forceloginusers='F';
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getadssql(ptransid character varying, padsname character varying, pcond text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
v_adssql text;
v_filtersql text;
v_primarydctable varchar;
v_filtercnd text;
begin

select sqltext into v_adssql from axdirectsql where sqlname = padsname;

if pcond !='NA' then 

select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';


v_filtercnd := concat(' and (',replace(pcond,'{primarytable.}',v_primarydctable||'.'),')');
	
v_filtersql := replace(v_adssql,'--ax_permission_filter',v_filtercnd);


end if;

return case when pcond ='NA' then  v_adssql else v_filtersql end;
	
	
END; 
$function$
;
>>


<<
ALTER TABLE axpdef_peg_usergroups ALTER COLUMN usergroupcode TYPE varchar(200) USING usergroupcode::varchar(200);
>>

<<
update axdirectsql set sqltext = replace(sqltext,'--permission_filter','--ax_permission_filter') where lower(sqltext) like '%--permission_filter%';
>>
