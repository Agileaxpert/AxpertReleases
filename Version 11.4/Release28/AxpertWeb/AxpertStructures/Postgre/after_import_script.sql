<<
DROP FUNCTION fn_permissions_getpermission(varchar, varchar, varchar, varchar);
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getpermission(pmode character varying, ptransid character varying, pusername character varying, proles character varying DEFAULT 'All'::character varying)
RETURNS TABLE(transid character varying, fullcontrol character varying, userrole character varying, allowcreate character varying, view_access character varying, view_includedc character varying, view_excludedc character varying, view_includeflds character varying, view_excludeflds character varying, edit_access character varying, edit_includedc character varying, edit_excludedc character varying, edit_includeflds character varying, edit_excludeflds character varying, maskedflds character varying, filtercnd text, encryptedflds character varying, permissiontype character varying)
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
rolesql text;
v_permissionsql text;
v_permissionexists numeric;
v_menuaccess numeric;
rec_transid record;
begin

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
)a;

if proles='All' then 
rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||rec_transid.transid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''';

v_permissionsql := 'select count(*) from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||rec_transid.transid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''';

else

rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||rec_transid.transid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (b.axuserrole))';

v_permissionsql :='select count(*) from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||rec_transid.transid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (b.axuserrole))';

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
filtercnd := null;
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
		view_access := case when rec.editctrl='0' then null else case when rec.viewctrl='4' then 'None' else null end end;
		edit_access := case when rec.editctrl='4' then 'None' else null end;
		view_includeflds := case when rec.viewctrl='0' then view_includeflds else concat(view_includeflds,',',edit_includeflds) end;		
		view_includedc :=case when rec.viewctrl='0' then view_includedc else  concat(view_includedc,',',edit_includedc) end;
		allowcreate := rec.allowcreate;
		filtercnd := rec.cnd;
		fullcontrol:= null;
		select string_agg(fname,',') into encryptedflds  from axpflds  where tstruct=rec_transid.transid and encrypted='T' and exists (select 1 from unnest(string_to_array(view_includeflds,',')) val where val = fname);
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
DROP FUNCTION fn_permissions_getcnd(varchar, varchar, varchar, varchar, varchar, varchar);
>>

<<

CREATE OR REPLACE FUNCTION fn_permissions_getcnd(pmode character varying, ptransid character varying, pkeyfld character varying, pkeyvalue character varying, pusername character varying, proles character varying DEFAULT 'All'::character varying)
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
begin

select srckey,srctf,srcfld,allowempty into v_keyfld_normalized,v_keyfld_srctbl,v_keyfld_srcfld,v_keyfld_mandatory
from axpflds where tstruct = ptransid and fname = pkeyfld;

select tablename into v_transid_primetable from axpdc where tstruct=ptransid and dname='dc1';

v_transid_primetableid := case when lower(pkeyfld)='recordid' then v_transid_primetable||'id' else pkeyfld end;

v_keyfld_cnd := case when v_keyfld_normalized='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else  v_transid_primetable||'.'||v_transid_primetableid end ||'='||pkeyvalue||' and ';

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
)a;


if proles='All' then 
rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||ptransid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''';


v_permissionsql := 'select count(*) from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||ptransid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''';

else

rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||ptransid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (b.axuserrole))';

v_permissionsql:=  'select count(*) from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||ptransid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (b.axuserrole))';

end if;

execute v_permissionsql into  v_permissionexists;

if v_menuaccess > 0 and v_permissionexists = 0 then 

v_fullcontrolsql := concat('select ',v_transid_primetable,'id',' from ',v_transid_primetable,' ',v_keyfld_joins,' where ',replace(v_keyfld_cnd,' and ',''));
execute v_fullcontrolsql into v_fullcontrolrecid;
fullcontrol:= 'T';
recordid := v_fullcontrolrecid;
select string_agg(fname,',') into encryptedflds  from axpflds where tstruct=ptransid and encrypted='T';
return next;

else

for rec in execute rolesql
loop

	sql_permission_cnd := concat('select count(*),',v_transid_primetable,'id',' from ',v_transid_primetable,' ',v_keyfld_joins,' where ',v_keyfld_cnd,replace(rec.cnd,'{primarytable.}',v_transid_primetable||'.'),'group by ',v_transid_primetable,'id');

	execute sql_permission_cnd into sql_permission_cnd_result,v_recordid;

	
	
	if sql_permission_cnd_result > 0 then
		

		userrole := rec.axuserrole;
		select string_agg(dname,',') into view_includedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array( rec.view_includedflds,',')) val where val = dname);
		select string_agg(dname,',') into view_excludedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array( rec.view_excludedflds,',')) val where val = dname);		 
		select string_agg(fname,',') into view_includeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.view_includedflds,',')) val where val = fname);
		select string_agg(fname,',') into view_excludeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.view_excludedflds,',')) val where val = fname);
		select string_agg(dname,',') into edit_includedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array( rec.edit_includedflds,',')) val where val = dname);
		select string_agg(dname,',') into edit_excludedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array( rec.edit_excludedflds,',')) val where val = dname);		 
		select string_agg(fname,',') into edit_includeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.edit_includedflds,',')) val where val = fname);
		select string_agg(fname,',') into edit_excludeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.edit_excludedflds,',')) val where val = fname);
		maskedflds := rec.fieldmaskstr;
		filtercnd := rec.cnd;
		recordid :=v_recordid;
		view_access := case when rec.editctrl='0' then null else case when rec.viewctrl='4' then 'None' else null end end;
		edit_access := case when rec.editctrl='4' then 'None' else null end;	
		allowcreate := rec.allowcreate;
		view_includeflds := case when rec.viewctrl='0' then view_includeflds else concat(view_includeflds,',',edit_includeflds) end;		
		view_includedc :=case when rec.viewctrl='0' then view_includedc else  concat(view_includedc,',',edit_includedc) end;		
		select string_agg(fname,',') into encryptedflds  from axpflds  where tstruct=ptransid and encrypted='T' and exists (select 1 from unnest(string_to_array(view_includeflds,',')) val where val = fname);
		return next;

	end if;



end loop;

end if;
 
return;
	
END; 
$function$
;
>>

