<<
ALTER TABLE axusers ADD staysignedin varchar(1);
>>

<<
ALTER TABLE axusers ADD signinexpiry numeric(2);
>>

<<
update axusers set staysignedin='F',signinexpiry=14 where (staysignedin is null or length(staysignedin) = 0);
>>

<<
CREATE OR REPLACE VIEW vw_username_role_menu_access
AS SELECT a2.username,
    a3.groupname,
    a5.rname,
    a5.sname,
    a5.stype,
        CASE a5.stype
            WHEN 't'::text THEN t.caption
            WHEN 'i'::text THEN i.caption
            WHEN 'p'::text THEN p.caption
            ELSE NULL::character varying
        END AS caption
   FROM axusergroups a3
     JOIN axusergroupsdetail a4 ON a3.axusergroupsid = a4.axusergroupsid
     JOIN axuseraccess a5 ON a4.roles_id::text = a5.rname::text
     LEFT JOIN axuserlevelgroups a2 ON a2.usergroup::text = a3.groupname::text AND a2.usergroup::text <> 'default'::text
     LEFT JOIN tstructs t ON a5.sname::text = t.name::text AND t.blobno = 1::numeric
     LEFT JOIN iviews i ON a5.sname::text = i.name::text
     LEFT JOIN axpages p ON a5.sname::text = p.name::text AND p.pagetype::text = 'web'::text
UNION ALL
 SELECT DISTINCT a2.username,
    'default'::text AS groupname,
    'default'::text AS rname,
    t.name AS sname,
    't'::text AS stype,
    t.caption
   FROM tstructs t
     LEFT JOIN axuserlevelgroups a2 ON a2.usergroup::text = 'default'::text
  WHERE t.blobno = 1::numeric
UNION ALL
 SELECT DISTINCT a2.username,
    'default'::text AS groupname,
    'default'::text AS rname,
    i.name AS sname,
    'i'::text AS stype,
    i.caption
   FROM iviews i
     LEFT JOIN axuserlevelgroups a2 ON a2.usergroup::text = 'default'::text
UNION ALL
 SELECT DISTINCT a2.username,
    'default'::text AS groupname,
    'default'::text AS rname,
    p.name AS sname,
    'p'::text AS stype,
    p.caption
   FROM axpages p
     LEFT JOIN axuserlevelgroups a2 ON a2.usergroup::text = 'default'::text
  WHERE p.pagetype::text = 'web'::text;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_axupscript()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
v_sqlary text[] DEFAULT  ARRAY[]::text[];
v_sql text;
begin

for rec in
select fname from axpflds where tstruct = 'a__ua' and dcname='dc4' and fname not in('sqltext1','cnd1')
loop




v_sql := 'select ''exists(select 1 from unnest(string_to_array('||replace(rec.fname,'axug_','{primarytable.}axg_')||','''','''')) val where val in(''''''||replace( concat(:'||rec.fname||','',All''),'','','''''','''''')||''''''))'' cnd from(select '''||rec.fname||''' gname,unnest(string_to_array(:'||rec.fname||','','')) gval from dual)a group by gname having sum(case when gval=''All'' then 1 else 0 end) = 0';


v_sqlary := array_append(v_sqlary,v_sql);

end loop;

return case when array_length(v_sqlary,1)>0 then  'select string_agg(cnd,'' and '') from ( '||array_to_string(v_sqlary,' union all ')||')b' else 'select null from dual' end;
 
END; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_apptstructs(pusername varchar,puserrole varchar,ptype varchar default 'Tstruct')
RETURNS TABLE (
  transid varchar
)
AS $$
BEGIN
    RETURN QUERY
select formtransid from axpermissions a
where axusername = pusername and comptype='Form'
union
SELECT formtransid FROM axpermissions
WHERE axuserrole = ANY(string_to_array(puserrole, ','))
and comptype='Form';
 
 
END;
$$ LANGUAGE plpgsql;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_create_grpcol(ptransid character varying, ptable character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare
v_altersql text; 
r record;
begin
	
for r in select grpname from axgroupingmst 
LOOP 
        BEGIN
            v_altersql := 'ALTER TABLE ' || ptable || ' ADD axg_' || r.grpname || ' varchar(4000) default ''All''';
            EXECUTE v_altersql;
        EXCEPTION WHEN OTHERS THEN
            null;
        END;
    END LOOP;

return 'T';
 
end;

$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_grpmaster(pgrpname character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_altersql text; 
    r record;
BEGIN
    FOR r IN SELECT a.ftransid, d.tablename 
             FROM axgrouptstructs a 
             JOIN axpdc d ON a.ftransid = d.tstruct AND d.dcno = 1 
    LOOP 
        BEGIN
            v_altersql := 'ALTER TABLE ' || r.tablename || ' ADD axg_' || pgrpname || ' varchar(4000) default ''All''';
            EXECUTE v_altersql;
        EXCEPTION WHEN OTHERS THEN
            null;
        END;
    END LOOP;
 
    RETURN 'T';
END;
$function$
;
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

	sql_permission_cnd := concat('select count(*),',v_transid_primetable,'id',' from ',v_transid_primetable,' ',v_keyfld_joins,' where ',v_keyfld_cnd,case when length(array_to_string(v_final_conditions,' and ')) > 3 then concat(replace(array_to_string(v_final_conditions,' and '),'{primarytable.}',v_transid_primetable||'.')) end,' group by ',v_transid_primetable,'id');

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
CREATE OR REPLACE FUNCTION fn_permissions_getpermission(pmode character varying, ptransid character varying, pusername character varying, proles character varying DEFAULT 'All'::character varying, pglobalvars character varying DEFAULT 'NA'::character varying)
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
		select string_agg(fname,',') into encryptedflds  from axpflds  where tstruct=rec_transid.transid and encrypted='T' and exists (select 1 from unnest(string_to_array(view_includeflds,',')) val where val = fname);
		fullcontrol:= null;
		permissiontype := rec.permissiontype;
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
update axpermissions set viewcnd='Grant view access only for selected fields' where viewcnd ='Include selected fields';
>>

<<
update axpermissions set viewcnd='Grant view access to all fields excluding selected fields' where viewcnd ='Exclude selected fields';
>>

<<
update axpermissions set viewcnd='No view access' where viewcnd ='None';
>>

<<
update axpermissions set editcnd='Grant edit access only for selected fields' where editcnd ='Include selected fields';
>>

<<
update axpermissions set editcnd='Grant edit access to all fields excluding selected fields' where editcnd ='Exclude selected fields';
>>

<<
update axpermissions set editcnd='No edit access' where editcnd ='None';
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
  select string_agg(dname,',') into view_includedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array( rec.view_includedflds,',')) val where val = dname);
  select string_agg(dname,',') into view_excludedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array( rec.view_excludedflds,',')) val where val = dname);   
  select string_agg(fname,',') into view_includeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.view_includedflds,',')) val where val = fname);
  select string_agg(fname,',') into view_excludeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.view_excludedflds,',')) val where val = fname);
  select string_agg(dname,',') into edit_includedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array( rec.edit_includedflds,',')) val where val = dname);
  select string_agg(dname,',') into edit_excludedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array( rec.edit_excludedflds,',')) val where val = dname);   
  select string_agg(fname,',') into edit_includeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.edit_includedflds,',')) val where val = fname);
  select string_agg(fname,',') into edit_excludeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.edit_excludedflds,',')) val where val = fname);
  maskedflds := rec.fieldmaskstr;
  filtercnd := v_final_conditions;
  recordid :=v_recordid;
  view_access := case when rec.editctrl='0' then null else case when rec.viewctrl='4' then 'None' else null end end;
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

