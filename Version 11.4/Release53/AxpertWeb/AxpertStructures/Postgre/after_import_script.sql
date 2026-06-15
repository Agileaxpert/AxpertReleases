<<
delete from axdirectsql a  where sqlname in('ds_homepage_quicklinks','ds_homepage_recentactivities');
>>

<<
delete from axp_cards ac where card_datasource in('ds_homepage_quicklinks','ds_homepage_recentactivities');
>>

<<
CREATE OR REPLACE FUNCTION trg_peg_processmaster()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
   	
    begin

execute 'create table '||new.processtable||' (eventdatetime varchar(30),taskid varchar(15),transid varchar(8),processname varchar(500),taskname varchar(500),keyvalue varchar(500),taskstatus varchar(15),tasktype varchar(15),username varchar(50),nexttask varchar(1000),displayicon varchar(500),displaytitle text,indexno numeric,keyfield varchar(200),recordid numeric,TimelineTitle varchar(4000))'; 	    
		

		return new;

end; 
$function$
;
>>


<<
create trigger trg_peg_processmaster after
insert
    on
    axpdef_peg_processmaster for each row execute function trg_peg_processmaster()
>>


<<
CREATE OR REPLACE FUNCTION fn_axprocessdefv2_index_update(pprocessname character varying, pindexno numeric, dbevent character varying, recordid numeric, poldindexno numeric)
 RETURNS void
 LANGUAGE plpgsql
AS $function$ 
declare
v_axprocessdefv2id numeric;
begin
 
if dbevent = 'Insert' then 
 select axprocessdefv2id into v_axprocessdefv2id from axprocessdefv2 where processname = pprocessname and indexno = pindexno and axprocessdefv2id!=recordid;
 if v_axprocessdefv2id is not null then
    update axprocessdefv2 set indexno = indexno+1 where processname=pprocessname and indexno>pindexno and  axprocessdefv2id != v_axprocessdefv2id and axprocessdefv2id != recordid;
 end if;
end if;


if dbevent = 'Update' then
 update axprocessdefv2 set indexno = indexno+1 where processname=pprocessname and indexno>=pindexno and indexno < poldindexno and  axprocessdefv2id != recordid;
end if;

if dbevent = 'Delete' then
 update axprocessdefv2 set indexno = indexno-1 where processname=pprocessname and indexno>pindexno and  axprocessdefv2id != recordid;
end if;

exception when others then 
 null ;

end;

$function$
;
>> 


<<
CREATE SEQUENCE seq_axdb_recordid
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
>>

<<
DROP FUNCTION fn_permissions_getcnd(varchar, varchar, varchar, varchar, varchar, varchar, varchar);
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getcnd(pmode character varying, ptransid character varying, pkeyfld character varying, pkeyvalue character varying, pusername character varying, proles character varying DEFAULT 'All'::character varying, pglobalvars character varying DEFAULT 'NA'::character varying)
 RETURNS TABLE(fullcontrol character varying, userrole character varying, allowcreate character varying, view_access character varying, view_includedc character varying, view_excludedc character varying, view_includeflds character varying, view_excludeflds character varying, edit_access character varying, edit_includedc character varying, edit_excludedc character varying, edit_includeflds character varying, edit_excludeflds character varying, maskedflds character varying, filtercnd text, recordid numeric, encryptedflds character varying, permissiontype character varying)
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
rolesql text;
v_transid_primetable varchar(100);
v_transid_primetableid varchar(100);
v_keyfld_normalized varchar(1);
v_keyfld_srctbl varchar(100);
v_keyfld_srcfld varchar(100);
v_keyfld_mandatory varchar(1);
v_keyfld_joins varchar(500);
v_keyfld_cnd varchar(500);
sql_permission_cnd text;
sql_permission_cnd_result numeric;
v_dcfldslist text;
v_recordid numeric;
v_permissionsql text;
v_permissionexists numeric;
v_menuaccess numeric;
v_fullcontrolsql text;
v_fullcontrolrecid numeric;
v_final_conditions varchar[] DEFAULT  ARRAY[]::varchar[];
rec_glovars record;
rec_glovars_varname varchar;
rec_glovars_varvalue varchar;
rec_dbconditions record;
v_dimensionsexists numeric;
v_applypermissions numeric;
v_condition varchar;
v_usercondition text;
begin


select count(*) into v_applypermissions from axgrouptstructs where ftransid = ptransid;

select srckey,srctf,srcfld,allowempty into v_keyfld_normalized,v_keyfld_srctbl,v_keyfld_srcfld,v_keyfld_mandatory
from axpflds where tstruct = ptransid and fname = pkeyfld;

select tablename into v_transid_primetable from axpdc where tstruct=ptransid and dname='dc1';

v_transid_primetableid := case when lower(pkeyfld)='recordid' then v_transid_primetable||'id' else pkeyfld end;

v_keyfld_cnd := case when v_keyfld_normalized='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else  v_transid_primetable||'.'||v_transid_primetableid end ||'='||pkeyvalue;

if v_keyfld_normalized='T' then 
	v_keyfld_joins := case when v_keyfld_mandatory='T' then ' join ' else ' left join ' end
					  ||v_keyfld_srctbl||' '||pkeyfld||' on '||v_transid_primetable||'.'||pkeyfld||'='||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id';		
	
end if;

select sum(cnt) into v_menuaccess from 
(select 1 cnt from axusergroups a join axusergroupsdetail b on a.axusergroupsid = b.axusergroupsid
join axuseraccess a2 on b.roles_id = a2.rname and stype ='t' 
where a2.sname = ptransid
and exists(select 1 from unnest(string_to_array(proles,',')) val where val = a.groupname)
union all
select 1 from dual where proles like '%default%'
union all
select 1 from axuserlevelgroups where username = pusername and usergroup='default'
union all
select 1 cnt from axusergroups a join axusergroupsdetail b on a.axusergroupsid = b.axusergroupsid
join axuseraccess a2 on b.roles_id = a2.rname and stype ='t'
join axuserlevelgroups u on a.groupname = u.usergroup and u.username = pusername 
where a2.sname = ptransid and proles = 'All'
   UNION ALL
        SELECT 1 AS cnt FROM axusergroups a
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid        
        JOIN axuserlevelgroups u ON a.groupname = u.usergroup 
        where b.ROLES_ID ='default' AND u.USERNAME = pusername 
)a;


if proles='All' then 
rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd1 cnd,viewctrl,allowcreate,editctrl,''Role'' permissiontype 
from AxPermissions a 
join axuserlevelgroups a2 on a2.axusergroup = a.axuserrole 
join axusers u on a2.axusersid = u.axusersid    
--left join (select b.axuserrole,b.cnd from axusers a join axuserpermissions b on a.axusersid =b.axusersid where a.username = '''||pusername||''')b on a.axuserrole=b.axuserrole 
left join axusergrouping b on u.axusersid = b.axusersid
where a.formtransid='''||ptransid||''' and u.username = '''||pusername||'''
union all
select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl ,''User'' permissiontype
from AxPermissions a
left join axuserDpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||ptransid||'''';


v_permissionsql := 'select count(cnt) from(select 1 cnt
from AxPermissions a 
join axuserlevelgroups a2 on a2.axusergroup = a.axuserrole 
join axusers u on a2.axusersid = u.axusersid    
--left join axuserpermissions b on a.axuserrole = b.axuserrole 
left join axusergrouping b on u.axusersid = b.axusersid
where a.formtransid='''||ptransid||''' and u.username = '''||pusername||'''
union all
select 1 cnt
from AxPermissions a
left join axuserDpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||ptransid||''')a';

else

rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl,''Role'' permissiontype 
from AxPermissions a 
--left join (select b.axuserrole,b.cnd from axusers a join axuserpermissions b on a.axusersid =b.axusersid where a.username = '''||pusername||''')b on a.axuserrole=b.axuserrole
left join (
select a2.usergroup ,b.cnd1 cnd from axusers a join axuserlevelgroups a2 on a2.axusersid = a.axusersid left join axusergrouping b on a.axusersid =b.axusersid  where a.username = '''||pusername||''')b on a.axuserrole=b.usergroup
where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (a.axuserrole))
and a.formtransid='''||ptransid||''' 
union all
select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl,''User'' permissiontype 
from AxPermissions a 
left join axuserdpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||ptransid||'''';

v_permissionsql:=  'select count(cnt) from (select 1 cnt
from AxPermissions a 
--left join axuserpermissions b on a.axuserrole = b.axuserrole 
left join (
select a2.usergroup ,b.cnd1 cnd,a.axusersid from axusers a join axuserlevelgroups a2 on a2.axusersid = a.axusersid left join axusergrouping b on a.axusersid =b.axusersid  where a.username = '''||pusername||''')b on a.axuserrole=b.usergroup
left join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (a.axuserrole))
and a.formtransid='''||ptransid||''' 
union all
select 1 cnt
from AxPermissions a 
left join axuserdpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||ptransid||''')a';

end if;

execute v_permissionsql into  v_permissionexists;


if v_applypermissions > 0 then

select  case when length(cnd1)>2 then 1 else 0 end,cnd1 into v_dimensionsexists,v_usercondition from axusergrouping a 
	join axusers b on a.axusersid = b.axusersid 
	join axgrouptstructs a2 on a2.ftransid=ptransid
	where b.username  = fn_permissions_getcnd.pusername;


if pglobalvars !='NA' then

FOR rec_glovars IN
    SELECT unnest(string_to_array(pglobalvars,'~~')) glovars
LOOP

    rec_glovars_varname  := split_part(rec_glovars.glovars,'=',1);
    rec_glovars_varvalue := split_part(rec_glovars.glovars,'=',2);

   v_condition := concat('{primarytable.}',rec_glovars_varname,' in (',rec_glovars_varvalue,',''All'')');

        v_final_conditions := array_append(v_final_conditions,concat(' and ', v_condition));

END LOOP;

else 


v_condition :=  concat(' and ',v_usercondition);
v_final_conditions := case when  v_dimensionsexists = 1 then array_append(v_final_conditions, v_condition) end;

end if;

end if;



if v_menuaccess > 0 and v_permissionexists = 0 then  

v_fullcontrolsql  := concat('select ',v_transid_primetable,'id',' from ',v_transid_primetable,' ',v_keyfld_joins,' where ',replace(v_keyfld_cnd,' and ',''),replace(array_to_string(v_final_conditions,' '),'{primarytable.}',v_transid_primetable||'.'));
execute v_fullcontrolsql into v_fullcontrolrecid;
fullcontrol:= case when v_fullcontrolrecid > 0 then 'T' else 'F' end;
edit_access:= case when v_fullcontrolrecid > 0 then 'T' else 'None' end;
view_access:= case when v_fullcontrolrecid > 0 then 'T' else 'None' end;
recordid := v_fullcontrolrecid;
select string_agg(fname,',') into encryptedflds  from axpflds where tstruct=ptransid and encrypted='T';
filtercnd := case when pglobalvars !='NA' then array_to_string(v_final_conditions,' ') else v_usercondition end;
return next;

else

for rec in execute rolesql
loop

	sql_permission_cnd := concat('select count(*),',v_transid_primetable,'id',' from ',v_transid_primetable,' ',v_keyfld_joins,' where ',v_keyfld_cnd,case when length(array_to_string(v_final_conditions,' and ')) > 3 then concat(replace(array_to_string(v_final_conditions,' '),'{primarytable.}',v_transid_primetable||'.')) end,' group by ',v_transid_primetable,'id');

	execute sql_permission_cnd into sql_permission_cnd_result,v_recordid;

	
	
	if sql_permission_cnd_result > 0 then	
		userrole := rec.axuserrole;
		select string_agg(dname,',') into view_includedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array(rec.view_includedflds,',')) val where val = dname);
		select string_agg(dname,',') into view_excludedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array(rec.view_excludedflds,',')) val where val = dname);		 
		select string_agg(fname,',') into view_includeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.view_includedflds,',')) val where val = fname);
		select string_agg(fname,',') into view_excludeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.view_excludedflds,',')) val where val = fname);
		select string_agg(dname,',') into edit_includedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array(rec.edit_includedflds,',')) val where val = dname);
		select string_agg(dname,',') into edit_excludedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array(rec.edit_excludedflds,',')) val where val = dname);		 
		select string_agg(fname,',') into edit_includeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.edit_includedflds,',')) val where val = fname);
		select string_agg(fname,',') into edit_excludeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.edit_excludedflds,',')) val where val = fname);
		maskedflds := rec.fieldmaskstr;
		filtercnd := v_final_conditions;
		recordid :=v_recordid;
		view_access := case when rec.viewctrl='4' then 'None' else null end;
		edit_access := case when rec.editctrl='4' then 'None' else null end;	
		allowcreate := rec.allowcreate;
		view_includeflds := case when rec.viewctrl='0' then view_includeflds else concat(view_includeflds,',',edit_includeflds) end;		
		view_includedc :=case when rec.viewctrl='0' then view_includedc else  concat(view_includedc,',',edit_includedc) end;
		select string_agg(fname,',') into encryptedflds  from axpflds  where tstruct=ptransid and encrypted='T' and exists (select 1 from unnest(string_to_array(view_includeflds,',')) val where val = fname);		
		permissiontype := rec.permissiontype;
		return next;

	end if;



end loop;


end if;

return ;
	
END; 
$function$
;
>>

<<
DROP FUNCTION fn_permissions_getpermission(varchar, varchar, varchar, varchar, varchar);
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getpermission(pmode character varying, ptransid character varying, pusername character varying, proles character varying DEFAULT 'All'::character varying, pglobalvars character varying DEFAULT 'NA'::character varying)
 RETURNS TABLE(transid character varying, fullcontrol character varying, userrole character varying, allowcreate character varying, view_access character varying, view_includedc character varying, view_excludedc character varying, view_includeflds character varying, view_excludeflds character varying, edit_access character varying, edit_includedc character varying, edit_excludedc character varying, edit_includeflds character varying, edit_excludeflds character varying, maskedflds character varying, filtercnd text, encryptedflds character varying, permissiontype character varying, viewctrl character varying, editctrl character varying)
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
rolesql text;
v_permissionsql text;
v_permissionexists numeric;
v_menuaccess numeric;
rec_transid record;
v_final_conditions text[] DEFAULT  ARRAY[]::text[];
rec_glovars record;
rec_glovars_varname varchar;
rec_glovars_varvalue varchar;
rec_dbconditions record;
v_dimensionsexists numeric;
v_applypermissions numeric;
v_matched varchar;
v_condition varchar;
v_used_vars varchar[] DEFAULT  ARRAY[]::varchar[];
v_usercondition text;
begin
 

select count(*) into v_applypermissions from axgrouptstructs where ftransid = ptransid;

if v_applypermissions > 0 then

select  case when length(cnd1)>2 then 1 else 0 end,cnd1 into v_dimensionsexists,v_usercondition from axusergrouping a 
	join axusers b on a.axusersid = b.axusersid 
	join axgrouptstructs a2 on a2.ftransid=ptransid
	where b.username  = fn_permissions_getpermission.pusername;


if pglobalvars !='NA' then

FOR rec_glovars IN
    SELECT unnest(string_to_array(pglobalvars,'~~')) glovars
LOOP

    rec_glovars_varname  := split_part(rec_glovars.glovars,'=',1);
    rec_glovars_varvalue := split_part(rec_glovars.glovars,'=',2);

   v_condition := concat('{primarytable.}',rec_glovars_varname,' in (',rec_glovars_varvalue,',''All'')');

        v_final_conditions := array_append(v_final_conditions, v_condition);

END LOOP;

else 


v_condition := v_usercondition;
v_final_conditions :=array_append(v_final_conditions, v_condition);

end if;

end if;

for rec_transid in(select unnest(string_to_array(ptransid,',')) transid) loop

select sum(cnt) into v_menuaccess from 
(select 1 cnt from axusergroups a join axusergroupsdetail b on a.axusergroupsid = b.axusergroupsid
join axuseraccess a2 on b.roles_id = a2.rname and stype ='t' 
where a2.sname = rec_transid.transid
and exists(select 1 from unnest(string_to_array(proles,',')) val where val = a.groupname)
union all
select 1 from dual where proles like '%default%'
union all
select 1 from axuserlevelgroups where username = pusername and usergroup='default'
union all
select 1 cnt from axusergroups a join axusergroupsdetail b on a.axusergroupsid = b.axusergroupsid
join axuseraccess a2 on b.roles_id = a2.rname and stype ='t'
join axuserlevelgroups u on a.groupname = u.usergroup and u.username = pusername 
where a2.sname = ptransid and proles = 'All'
   UNION ALL
        SELECT 1 AS cnt FROM axusergroups a
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid        
        JOIN axuserlevelgroups u ON a.groupname = u.usergroup 
        where b.ROLES_ID ='default' AND u.USERNAME = pusername
)a;

if proles='All' then 
rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd1 cnd,viewctrl,allowcreate,editctrl,''Role'' permissiontype 
from AxPermissions a 
join axuserlevelgroups a2 on a2.axusergroup = a.axuserrole 
join axusers u on a2.axusersid = u.axusersid  
left join axusergrouping b on u.axusersid = b.axusersid
where a.formtransid='''||rec_transid.transid||''' and u.username = '''||pusername||''' 
union all 
select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl,''User'' permissiontype 
from AxPermissions a 
left join axuserdpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||rec_transid.transid||'''';

v_permissionsql := 'select count(cnt) from(select 1 cnt
from AxPermissions a 
join axuserlevelgroups a2 on a2.axusergroup = a.axuserrole 
join axusers u on a2.axusersid = u.axusersid  
left join axusergrouping b on u.axusersid = b.axusersid
where a.formtransid='''||rec_transid.transid||''' and u.username = '''||pusername||''' 
union all 
select 1 cnt 
from AxPermissions a 
left join axuserdpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||rec_transid.transid||''')a';

else

rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl,''Role'' permissiontype 
from AxPermissions a 
left join (
select a2.usergroup ,b.cnd1 cnd from axusers a join axuserlevelgroups a2 on a2.axusersid = a.axusersid left join axusergrouping b on a.axusersid =b.axusersid  where a.username = '''||pusername||''')b on a.axuserrole=b.usergroup
where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (a.axuserrole))
and a.formtransid='''||rec_transid.transid||'''   
union all
select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl,''User'' permissiontype 
from AxPermissions a left join axuserDpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||rec_transid.transid||'''';

v_permissionsql :='select count(cnt) from(select 1 cnt
from AxPermissions a 
left join (
select a2.usergroup ,b.cnd1 cnd,a.axusersid from axusers a join axuserlevelgroups a2 on a2.axusersid = a.axusersid left join axusergrouping b on a.axusersid =b.axusersid  where a.username = '''||pusername||''')b on a.axuserrole=b.usergroup
left join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (a.axuserrole))
and a.formtransid='''||rec_transid.transid||'''   
union all
select 1 cnt
from AxPermissions a left join axuserDpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||rec_transid.transid||''')a'; 

end if;

execute v_permissionsql into  v_permissionexists;



if v_menuaccess > 0 and v_permissionexists = 0 then 

fullcontrol:= 'T';
transid := rec_transid.transid;
userrole := null;
view_includedc  :=null;
view_excludedc  :=null;		 
view_includeflds:=null;
view_excludeflds :=null;
edit_includedc :=null;
edit_excludedc :=null;		 
edit_includeflds :=null;
edit_excludeflds :=null;
maskedflds := null;				
view_access := null;
edit_access := null;
view_includeflds := null;		
view_includedc :=null;
allowcreate := null;
filtercnd := case when v_applypermissions > 0 then array_to_string(v_final_conditions,' and ') else null end;
viewctrl := '0';
editctrl :='0';
select string_agg(fname,',') into encryptedflds  from axpflds where tstruct=rec_transid.transid and encrypted='T';	
	
return next;

else

for rec in execute rolesql
loop	
		transid := rec_transid.transid;
		userrole := rec.axuserrole;
		select string_agg(dname,',') into view_includedc  from axpdc where tstruct=rec_transid.transid and exists (select 1 from unnest(string_to_array( rec.view_includedflds,',')) val where val = dname);
		select string_agg(dname,',') into view_excludedc  from axpdc where tstruct=rec_transid.transid and exists (select 1 from unnest(string_to_array( rec.view_excludedflds,',')) val where val = dname);		 
		select string_agg(fname,',') into view_includeflds  from axpflds where tstruct=rec_transid.transid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.view_includedflds,',')) val where val = fname);
		select string_agg(fname,',') into view_excludeflds  from axpflds where tstruct=rec_transid.transid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.view_excludedflds,',')) val where val = fname);
		select string_agg(dname,',') into edit_includedc  from axpdc where tstruct=rec_transid.transid and exists (select 1 from unnest(string_to_array( rec.edit_includedflds,',')) val where val = dname);
		select string_agg(dname,',') into edit_excludedc  from axpdc where tstruct=rec_transid.transid and exists (select 1 from unnest(string_to_array( rec.edit_excludedflds,',')) val where val = dname);		 
		select string_agg(fname,',') into edit_includeflds  from axpflds where tstruct=rec_transid.transid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.edit_includedflds,',')) val where val = fname);
		select string_agg(fname,',') into edit_excludeflds  from axpflds where tstruct=rec_transid.transid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.edit_excludedflds,',')) val where val = fname);
		maskedflds := rec.fieldmaskstr;				
		view_access := case when rec.viewctrl='4' then 'None' else null end;
		edit_access := case when rec.editctrl='4' then 'None' else null end;
		view_includeflds := case when rec.viewctrl='0' then view_includeflds else concat(view_includeflds,',',edit_includeflds) end;		
		view_includedc :=case when rec.viewctrl='0' then view_includedc else  concat(view_includedc,',',edit_includedc) end;
		allowcreate := rec.allowcreate;
filtercnd := array_to_string(v_final_conditions,' and ');
		select string_agg(fname,',') into encryptedflds  from axpflds  where tstruct=rec_transid.transid and encrypted='T' and exists (select 1 from unnest(string_to_array(view_includeflds,',')) val where val = fname);
		fullcontrol:= null;
		permissiontype := rec.permissiontype;
viewctrl := rec.viewctrl;
editctrl :=rec.editctrl;
		return next;

end loop;

end if;

end loop;
 
return;
	
END; 
$function$
;
>>


<<
DROP FUNCTION fn_axdbget(varchar, numeric);
>>

<<
CREATE OR REPLACE FUNCTION fn_axdbget(ptransid character varying, precordid numeric DEFAULT 0)
 RETURNS TABLE(transid character varying, dcno character varying, griddc character varying, sqltext text)
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
rec2 record;
v_sql text;
v_primarydctable varchar;
v_fldnamesary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_col varchar;
v_fldname_normalized varchar;
v_fldname_srctbl varchar;
v_fldname_srcfld varchar;
v_fldname_allowempty varchar;
v_fldname_dctablename varchar;
v_fldname_dcflds text;
v_fldname_normalizedtables varchar[] DEFAULT  ARRAY[]::varchar[];
v_emptyary varchar[] DEFAULT  ARRAY[]::varchar[];
v_allflds varchar;
v_dcdefaultcols varchar;
v_griddc_orderby varchar;

 

begin


	select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';
	



for rec in select string_agg(dname,',' order by dname) dname, asgrid ,lower(tablename) tablename 
from axpdc where tstruct = ptransid 
group by asgrid ,lower(tablename)
order by 1 
loop
		
	 		
			select concat(tablename,'=',string_agg(str,'|'))  into v_allflds From(
			select tablename, concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~',allowempty) str,dcname,ordno
			from axpflds where tstruct=ptransid and savevalue='T' and lower(tablename) = rec.tablename and datatype !='i'
			union all
			select tablename, concat(fname,' ',fname,'_sourceid','~','F','~',srctf,'~',srcfld,'~',allowempty) str,dcname,ordno
			from axpflds where tstruct=ptransid and savevalue='T' and lower(tablename) = rec.tablename and datatype !='i'
			and srckey='T'
			order by dcname ,ordno)a group by a.tablename;		
		
if length(v_allflds) > 1 then

	if rec.tablename = v_primarydctable then 		
		select string_agg(fnames,',') into v_dcdefaultcols 
		from 
		(select concat(v_primarydctable,'.',unnest(string_to_array(v_primarydctable||'id,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles',',')))fnames)a;
	end if;
	

	if rec.asgrid = 'F' and rec.tablename != v_primarydctable then		
		v_dcdefaultcols = concat(rec.tablename,'.',v_primarydctable||'id,',rec.tablename,'.',rec.tablename||'id');
	elsif rec.asgrid = 'T' and rec.tablename != v_primarydctable then
		v_dcdefaultcols =  concat(rec.tablename,'.',v_primarydctable||'id,',rec.tablename,'.',rec.tablename||'id,',rec.tablename,'.',rec.tablename||'row');
		v_griddc_orderby = concat(' order by ',rec.tablename||'row');
	end if;

				FOR rec2 IN
    		select unnest(string_to_array(split_part(unnest(string_to_array(v_allflds,'^')),'=',2),'|')) fldname    		    	       			
				loop		    	
					v_fldname_col := split_part(rec2.fldname,'~',1);
					v_fldname_normalized := split_part(rec2.fldname,'~',2);
					v_fldname_srctbl := split_part(rec2.fldname,'~',3);
					v_fldname_srcfld := split_part(rec2.fldname,'~',4);	
					v_fldname_allowempty := split_part(rec2.fldname,'~',5);
			    
				
					
					if v_fldname_normalized ='F' then 						
						v_fldnamesary := array_append(v_fldnamesary,concat(rec.tablename,'.',v_fldname_col)::varchar);					
					elsif v_fldname_normalized ='T' then	
						v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_col,'.',v_fldname_srcfld,' ',v_fldname_col)::varchar);	
						v_fldname_joinsary := array_append(v_fldname_joinsary,concat(case when v_fldname_allowempty='F' then ' join ' else ' left join ' end,v_fldname_srctbl,' ',v_fldname_col,' on ',rec.tablename,'.',v_fldname_col,' = ',v_fldname_col,'.',v_fldname_srctbl,'id')::Varchar);
						v_fldname_normalizedtables := array_append(v_fldname_normalizedtables,lower(v_fldname_srctbl));
					end if;
								
			    end loop;
		   
		
	transid = ptransid;
	dcno = rec.dname;
	griddc = rec.asgrid;
	sqltext = concat('select ',v_dcdefaultcols,',',array_to_string(v_fldnamesary,','),' from ',rec.tablename,' ',array_to_string(v_fldname_joinsary,' '),' where ',rec.tablename,'.',v_primarydctable||'id= :recordid',v_griddc_orderby);

	v_fldnamesary:= v_emptyary;
	v_fldname_joinsary:= v_emptyary;
	v_griddc_orderby := null;

	return next;
end if;

end loop;
		   	
 

		   			

		  END; $function$
;
>>

<<
DROP FUNCTION fn_axdbput_getrecid(int4, int4);
>>

<<
CREATE OR REPLACE FUNCTION fn_axdbput_getrecid(psiteno integer, pnoofrows integer)
 RETURNS TABLE(recordid character varying)
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_seq_num     bigint;
    v_pad_length  int;
	v_pad_sitelength int;
    v_final       varchar;
BEGIN
 	v_pad_length := 12;
	v_pad_sitelength := 3;
	

    FOR i IN 1 .. pnoofrows LOOP

        v_seq_num := nextval('seq_axdb_recordid');

        v_final := rpad(psiteno  ::varchar, v_pad_sitelength, '0')|| lpad(v_seq_num::varchar, v_pad_length, '0');

        recordid := v_final;
        RETURN NEXT;
    END LOOP;

END;
$function$
;
>>
