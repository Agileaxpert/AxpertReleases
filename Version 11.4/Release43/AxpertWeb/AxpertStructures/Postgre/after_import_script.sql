<<
update axusers set staysignedin='F',signinexpiry=14;
>>

<<
ALTER TABLE axuseraccess ALTER COLUMN rname TYPE varchar(50) USING rname::varchar(50);
>>

<<
CREATE TABLE axgrouptstructs (
	formcap varchar(500) NULL,
	ftransid varchar(10) NULL
);
>>

<<
ALTER TABLE axgrouptstructs DROP CONSTRAINT aglaxgrouptstructsid;
>>

<<
CREATE TABLE axuserdpermissions (
	axuserdpermissionsid numeric(16) NOT NULL,
	axpermissionsid numeric(16) NULL,
	cnd varchar(4000) NULL,
	CONSTRAINT aglaxuserdpermissionsid PRIMARY KEY (axuserdpermissionsid)
);
>>

<<
DROP FUNCTION fn_axi_metadata(varchar, varchar);
>>

<<
DROP FUNCTION fn_axi_struct_metadata(varchar, varchar, varchar);
>>


<<
CREATE OR REPLACE FUNCTION fn_axi_metadata(pstructtype character varying, pusername character varying)
 RETURNS TABLE(structtype text, caption text, transid character varying)
 LANGUAGE plpgsql
AS $function$
declare 
declare v_sql varchar;
begin
	if pstructtype='tstructs' then
		v_sql = 'select ''tstruct'',caption || ''-('' || name || '')'' cap,name
	from axusergroups a3 join axusergroupsdetail a4 on a3.axusergroupsid = a4.axusergroupsid
	join axuseraccess a5 on a4.roles_id = a5.rname
	join tstructs t on a5.sname = t.name
	join axuserlevelgroups ag on a3.groupname = ag.usergroup 
	where t.blobno =1 and ag.username =$1
	union all
	select ''tstruct'',caption || ''-('' || name || '')'' cap,name
	from tstructs t 
	join axuserlevelgroups ag on ag.usergroup =''default''
	where t.blobno =1 and ag.username =$1
	union all
	      SELECT ''tstruct'',caption || ''-('' || name || '')'' cap,name from tstructs t 
	      JOIN axuserlevelgroups u on u.USERNAME = $1
	    join axusergroups a ON a.groupname = u.usergroup 
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid        
        where b.ROLES_ID =''default'' and t.blobno =1';        
	elsif pstructtype='iviews' then
		v_sql = 'select ''iview'',caption || ''-('' || name || '')'' cap,name
	from axusergroups a3 join axusergroupsdetail a4 on a3.axusergroupsid = a4.axusergroupsid
	join axuseraccess a5 on a4.roles_id = a5.rname
	join iviews t on a5.sname = t.name
	join axuserlevelgroups ag on a3.groupname = ag.usergroup 
	where t.blobno =1 and ag.username =$1
	union all
	select ''iview'',caption || ''-('' || name || '')'' cap,name
	from iviews t 
	join axuserlevelgroups ag on ag.usergroup =''default''
	where t.blobno =1 and ag.username =$1
	union all
	      SELECT ''iview'',caption || ''-('' || name || '')'' cap,name from iviews t 
	      JOIN axuserlevelgroups u on u.USERNAME = $1
	    join axusergroups a ON a.groupname = u.usergroup 
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid        
        where b.ROLES_ID =''default'' and t.blobno =1';
elsif pstructtype='pages' then 
	v_sql = 'select ''page'',caption || ''-('' || name || '')'' cap,name
	from axusergroups a3 join axusergroupsdetail a4 on a3.axusergroupsid = a4.axusergroupsid
	join axuseraccess a5 on a4.roles_id = a5.rname
	join axpages p on a5.sname = p.name and p.pagetype =''web''
	join axuserlevelgroups ag on a3.groupname = ag.usergroup 
	where ag.username =$1
	union all
	select ''page'',caption || ''-('' || name || '')'' cap,name
	from axpages t 
	join axuserlevelgroups ag on ag.usergroup =''default''
	where t.pagetype =''web'' and ag.username =$1
	union all
	      SELECT ''page'',caption || ''-('' || name || '')'' cap,name from axpages t 
	      JOIN axuserlevelgroups u on u.USERNAME = $1
	    join axusergroups a ON a.groupname = u.usergroup 
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid        
        where b.ROLES_ID =''default'' and t.pagetype =''web''';   
elsif pstructtype='ads' then  
v_sql = 'select ''ADS'',sqlname::text,sqlname from axdirectsql';
else
v_sql = 'select ''tstruct'',caption || ''-('' || name || '')'' cap,name
	from axusergroups a3 join axusergroupsdetail a4 on a3.axusergroupsid = a4.axusergroupsid
	join axuseraccess a5 on a4.roles_id = a5.rname
	join tstructs t on a5.sname = t.name
	join axuserlevelgroups ag on a3.groupname = ag.usergroup 
	where t.blobno =1 and ag.username =$1
	union all
	select ''tstruct'',caption || ''-('' || name || '')'' cap,name
	from tstructs t 
	join axuserlevelgroups ag on ag.usergroup =''default''
	where t.blobno =1 and ag.username =$1
	union all
	      SELECT ''tstruct'',caption || ''-('' || name || '')'' cap,name from tstructs t 
	      JOIN axuserlevelgroups u on u.USERNAME = $1
	    join axusergroups a ON a.groupname = u.usergroup 
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid        
        where b.ROLES_ID =''default'' and t.blobno =1
union all 	
select ''iview'',caption || ''-('' || name || '')'' cap,name
	from axusergroups a3 join axusergroupsdetail a4 on a3.axusergroupsid = a4.axusergroupsid
	join axuseraccess a5 on a4.roles_id = a5.rname
	join iviews t on a5.sname = t.name
	join axuserlevelgroups ag on a3.groupname = ag.usergroup 
	where t.blobno =1 and ag.username =$1
	union all
	select ''iview'',caption || ''-('' || name || '')'' cap,name
	from iviews t 
	join axuserlevelgroups ag on ag.usergroup =''default''
	where t.blobno =1 and ag.username =$1
	union all
	      SELECT ''iview'',caption || ''-('' || name || '')'' cap,name from iviews t 
	      JOIN axuserlevelgroups u on u.USERNAME = $1
	    join axusergroups a ON a.groupname = u.usergroup 
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid        
        where b.ROLES_ID =''default'' and t.blobno =1
union all
select ''page'',caption || ''-('' || name || '')'' cap,name
	from axusergroups a3 join axusergroupsdetail a4 on a3.axusergroupsid = a4.axusergroupsid
	join axuseraccess a5 on a4.roles_id = a5.rname
	join axpages p on a5.sname = p.name and p.pagetype =''web''
	join axuserlevelgroups ag on a3.groupname = ag.usergroup 
	where ag.username =$1
	union all
	select ''page'',caption || ''-('' || name || '')'' cap,name
	from axpages t 
	join axuserlevelgroups ag on ag.usergroup =''default''
	where t.pagetype =''web'' and ag.username =$1
	union all
	      SELECT ''page'',caption || ''-('' || name || '')'' cap,name from axpages t 
	      JOIN axuserlevelgroups u on u.USERNAME = $1
	    join axusergroups a ON a.groupname = u.usergroup 
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid        
        where b.ROLES_ID =''default'' and t.pagetype =''web''
union all
select ''ADS'',sqlname::text,sqlname from axdirectsql';
end if;

return query execute v_sql using pusername;

END; 
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_axi_struct_metadata(pstructtype character varying, ptransid character varying, pobjtype character varying)
 RETURNS TABLE(objtype character varying, objcaption text, objname character varying, dcname character varying, asgrid character varying)
 LANGUAGE plpgsql
AS $function$
declare 
declare v_sql varchar;
begin
	if pstructtype='tstruct' then
		if pobjtype = 'fields' then 
		v_sql = 'select ''Field''::varchar,caption||''(''||fname||'')'',fname,dcname,asgrid from axpflds where tstruct =$1';
		elsif pobjtype = 'genmaps' then 
		v_sql = 'select ''Genmap''::varchar,caption||''(''||gname||'')'',gname,null::varchar,null::varchar from axpgenmaps where tstruct =$1';
		elsif pobjtype = 'mdmaps' then 
		v_sql = 'select ''MDmap''::varchar,caption||''(''||mname||'')'',mname,null::varchar,null::varchar from axpmdmaps where tstruct =$1';		
		end if;
	elsif pstructtype='iview' then
		if pobjtype = 'columns' then
		v_sql = 'select ''Column''::varchar,f_caption||''(''||f_name||'')'',f_name,null::varchar,null::varchar from iviewcols where iname =$1';		
		elsif pobjtype = 'params' then
		v_sql = 'select ''Param''::varchar,pcaption||''(''||pname||'')'',pname,null::varchar,null::varchar from iviewparams where iname =$1';		
		end if;	
end if;

return query execute v_sql using ptransid;

END; 
$function$
;
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd, sqlquerycols, adsdesc, encryptedflds, cachedata, cacheinterval, smartlistcnd) VALUES(1457330000000, 'F', 0, NULL, 'admin', '2026-02-17', 'admin', '2025-12-23', NULL, 1, 1, NULL, NULL, NULL, 'ds_getsmartlists', NULL, 'select sqlname from axdirectsql a where sqlsrc=''Application''', NULL, NULL, 'ALL', NULL, 'Metadata', 5, NULL, NULL, NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd, sqlquerycols, adsdesc, encryptedflds, cachedata, cacheinterval, smartlistcnd) VALUES(1487110000002, 'F', 0, NULL, 'admin', '2026-02-12', 'admin', '2026-02-12', NULL, 1, 1, NULL, NULL, NULL, 'Axi_getmetadata', NULL, 'SELECT * from fn_axi_metadata( :pstructtype , :pusername )', 'pstructtype,pusername', 'pstructtype~Character~,pusername~Character~', 'ALL', NULL, 'Metadata', 0, 'structtype,caption,transid', NULL, NULL, 'F', '6 Hr', NULL);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd, sqlquerycols, adsdesc, encryptedflds, cachedata, cacheinterval, smartlistcnd) VALUES(1487220000000, 'F', 0, NULL, 'admin', '2026-02-12', 'admin', '2026-02-12', NULL, 1, 1, NULL, NULL, NULL, 'Axi_metadata_struct_obj', NULL, 'SELECT * from fn_axi_struct_metadata( :pstructtype, :ptransid , :pobjtype )', 'pstructtype,ptransid,pobjtype', 'pstructtype~Character~,ptransid~Character~,pobjtype~Character~', 'ALL', NULL, 'Metadata', 0, 'objtype,objcaption,objname,dcname,asgrid', NULL, NULL, 'F', '6 Hr', NULL);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd, sqlquerycols, adsdesc, encryptedflds, cachedata, cacheinterval, smartlistcnd) VALUES(1647330000001, 'F', 0, NULL, 'abinash', '2026-02-04', 'abinash', '2026-02-04', NULL, 1, 1, NULL, NULL, NULL, 'ds_smartlist_filters', NULL, 'SELECT * from fn_axpanalytics_filterdata( :ptransid, :psrctxt)', 'ptransid,psrctxt', 'ptransid~Character~,psrctxt~Character~', 'ALL', NULL, 'Metadata', 0, NULL, NULL, NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd, sqlquerycols, adsdesc, encryptedflds, cachedata, cacheinterval, smartlistcnd) VALUES(1471440000000, 'F', 0, NULL, 'admin', '2026-02-04', 'admin', '2026-01-30', NULL, 1, 1, NULL, NULL, NULL, 'ds_smartlist_ads_metadata', NULL, 'select a.sqlname,b.fldname,b.fldcaption,b.fdatatype, b."normalized" ,b.sourcetable ,b.sourcefld ,hyp_structtype,b.hyp_transid, b.tbl_hyperlink,
case when smartlistcnd like ''%Dynamic select columns%'' then ''T'' else ''F'' end dynamiccolumns,
case when smartlistcnd like ''%Filter%'' then coalesce(b.filter,''No'') else ''F'' end filters,
case when smartlistcnd like ''%Pagination%'' then ''T'' else ''F'' end pagination,
case when smartlistcnd like ''%Sorting%'' then ''T'' else ''F'' end sorting
from axdirectsql a left join axdirectsql_metadata b on a.axdirectsqlid =b.axdirectsqlid 
where sqlname = :adsname
order by b.axdirectsql_metadatarow ', 'adsname', 'adsname~Character~', 'ALL', NULL, 'Metadata', 0, NULL, NULL, NULL, NULL, NULL, NULL);
>>

<<
update axdirectsql set sqlsrc='Metadata' 
where sqlname in('Text_Field_Intelligence','ds_getsmartlists','Axi_getmetadata','Axi_metadata_struct_obj','ds_smartlist_filters',
'ds_smartlist_ads_metadata');
>>

<<
update axdirectsql set sqlsrc='Internal' 
where sqlname in('ds_homepage_recentactivities',
'ds_homepage_quicklinks',
'ds_homepage_kpicards',
'ds_homepage_events',
'ds_homepage_banner',
'ds_homepage_activelist',
'axcalendarsource');
>>

<<
update axdirectsql set sqlsrc='Application' 
where sqlname NOT in('Text_Field_Intelligence','ds_getsmartlists','Axi_getmetadata','Axi_metadata_struct_obj','ds_smartlist_filters',
'ds_smartlist_ads_metadata','ds_homepage_recentactivities',
'ds_homepage_quicklinks',
'ds_homepage_kpicards',
'ds_homepage_events',
'ds_homepage_banner',
'ds_homepage_activelist',
'axcalendarsource');
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
     LEFT JOIN axpages p ON a5.sname::text = p.name::text
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
     LEFT JOIN axuserlevelgroups a2 ON a2.usergroup::text = 'default'::text;
>>

<<
CREATE OR REPLACE VIEW axp_appsearch
AS SELECT DISTINCT a.searchtext,
    a.params::text ||
        CASE
            WHEN a.params IS NOT NULL AND lower(a.params::text) !~~ '%~act%'::text THEN '~act=load'::text
            ELSE NULL::text
        END AS params,
    a.hltype,
    a.structname,
    a.username,
    a.oldappurl
   FROM ( SELECT s.slno,
            s.searchtext,
            s.params,
            s.hltype,
            s.structname,
            lg.username,
            s.oldappurl
           FROM axp_appsearch_data_new s,
            axuseraccess a_1,
            axusergroups g,
            axusergroupsdetail g1,
            axuserlevelgroups lg
          WHERE a_1.sname::text = s.structname::text AND g.axusergroupsid = g1.axusergroupsid AND g.groupname::text = lg.usergroup::text AND a_1.rname::text = g1.roles_id::text AND s.structname::text <> 'axurg'::text AND (a_1.stype::text = ANY (ARRAY['t'::character varying::text, 'i'::character varying::text]))
          GROUP BY s.searchtext, s.params, s.hltype, s.structname, lg.username, s.slno, s.oldappurl
        UNION
         SELECT b.slno,
            b.searchtext,
            b.params,
            b.hltype,
            b.structname,
            lg.username,
            b.oldappurl
           FROM axuserlevelgroups lg,
            ( SELECT DISTINCT s.searchtext,
                    s.params,
                    s.hltype,
                    s.structname,
                    0 AS slno,
                    s.oldappurl
                   FROM axp_appsearch_data_new s
                     LEFT JOIN axuseraccess a_1 ON s.structname::text = a_1.sname::text AND (a_1.stype::text = ANY (ARRAY['t'::character varying::text, 'i'::character varying::text]))) b
          WHERE lg.usergroup::text = 'default'::text AND b.structname::text <> 'axurg'::text
  ORDER BY 1, 6) a;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_metadata(ptransid character varying, psubentity character varying DEFAULT 'F'::character varying, planguage character varying DEFAULT 'English'::character varying)
 RETURNS SETOF axpdef_axpanalytics_mdata
 LANGUAGE plpgsql
AS $function$
declare
r axpdef_axpanalytics_mdata%rowtype;
rec record;
v_subentitytable varchar;
v_sql text;
v_subentitysql text;
v_primarydctable varchar;
begin
 

	select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';

	select concat('select axpflds.tstruct transid,coalesce(lf.compcaption,t.caption) formcap, fname ,coalesce(l.compcaption,axpflds.caption) fcap,customdatatype cdatatype,"datatype" dt,modeofentry,
	hidden fhide,cast(null as varchar) props,srckey ,srctf ,srcfld ,srctrans ,axpflds.allowempty,
	case when modeofentry =''select'' then case when srckey =''T'' then ''Dropdown'' else ''Text'' end else ''Text'' end::varchar filtercnd,
	case when (modeofentry =''select'' or datatype=''c'') then ''T'' else ''F'' end::varchar grpfld,
	case when "datatype" =''n'' then ''T'' else ''F'' end::varchar aggfld,''F'' subentity,1 datacnd,null entityrelfld,allowduplicate,axpflds.tablename,
	dcname,ordno,d.caption dccaption,d.asgrid,case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,encrypted,masking,lastcharmask,firstcharmask,maskchar,maskroles,customdecimal
	from axpflds join tstructs t on axpflds.tstruct = t.name and t.blobno=1
	join axpdc d on axpflds.tstruct = d.tstruct and axpflds.dcname = d.dname
	left join axlanguage l on substring(l.sname FROM 2)= t.name and lower(l.dispname)=''',lower(planguage),''' and axpflds.fname = l.compname
	left join axlanguage lf on substring(lf.sname FROM 2)= t.name and lower(lf.dispname)=''',lower(planguage),''' and lf.compname=''x__headtext'' 		
	where axpflds.tstruct=','''',ptransid,''' and savevalue =''T'' 
	union all
	select a.name,coalesce(lf.compcaption,t.caption),key,coalesce(l.compcaption,title),	''button'',null,null,''F'',	concat(script, ''~'', icon),''F'',null,null,null,null,null,null,null,''F'' subentity,1,null,
	null,null,null,ordno,null,''F'',''F'',null encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
	from axtoolbar a join tstructs t on a.name = t.name and t.blobno=1
	left join axlanguage l on substring(l.sname FROM 2)= t.name and lower(l.dispname)=''',lower(planguage),''' and a.key = l.compname
	left join axlanguage lf on substring(lf.sname FROM 2)= t.name and lower(lf.dispname)=''',lower(planguage),''' and lf.compname=''x__headtext''
	where visible = ''true'' and script is not null and a.name= ','''',ptransid,'''','
	union all 
	select distinct t.name transid,coalesce(lf.compcaption,t.caption) formcap, ''app_desc'' ,''Workflow status'' fcap,
	null cdatatype,''c'' dt,null modeofentry,
	''F'' fhide,null props,''F'' srckey ,null srctf ,null srcfld ,null srctrans ,''T'' allowempty,
	''Text'' filtercnd,
	''F'' grpfld,
	''F'' aggfld,''F'' subentity,1 datacnd,null entityrelfld,''T'' allowduplicate,d.tablename,
	dname,1000,d.caption dccaption,d.asgrid,case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,
	''F'' encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
	from axattachworkflow a join tstructs t on a.transid = t.name and t.blobno=1 		
	join axpdc d on a.transid = d.tstruct and d.dname =''dc1''
	left join axlanguage lf on substring(lf.sname FROM 2)= t.name and lower(lf.dispname)=''',lower(planguage),''' and lf.compname=''x__headtext'' 		
	where t.name=','''',ptransid,'''') into v_sql;

	for r in execute v_sql
		loop	    	
			RETURN NEXT r;
		END LOOP;	
	

if psubentity ='T' then		

    FOR rec IN
        select distinct a.dstruct,a.rtype,dprimarytable  from axentityrelations a 		
		where rtype in('md','custom','gm') and mstruct = ptransid 
   	loop		
	


select concat('select distinct axpflds.tstruct transid,coalesce(lf.compcaption,t.caption) formcap, fname ,coalesce(l.compcaption,axpflds.caption) fcap,customdatatype cdatatype,"datatype" dt,modeofentry ,hidden fhide,
		cast(null as varchar) props,srckey ,srctf ,srcfld ,srctrans ,axpflds.allowempty,
		case when modeofentry =''select'' then case when srckey =''T'' then ''Dropdown'' else ''Text'' end else ''Text'' end::varchar filtercnd,
		case when modeofentry =''select'' then ''T'' else ''F'' end::varchar grpfld,
		case when "datatype" =''n'' then ''T'' else ''F'' end::varchar aggfld,''T'' subentity,2 datacnd,
		r.mfield entityrelfld,
		allowduplicate,axpflds.tablename,dcname,ordno,d.caption,d.asgrid,case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,
		encrypted,masking,lastcharmask,firstcharmask,maskchar,maskroles,customdecimal	
		from axpflds join tstructs t on axpflds.tstruct = t.name and t.blobno=1 join axpdc d on axpflds.tstruct = d.tstruct and axpflds.dcname = d.dname
		left join axentityrelations r on axpflds.tstruct = r.dstruct and axpflds.fname = r.dfield and r.mstruct=''',ptransid,'''
		left join axlanguage l on substring(l.sname FROM 2)=''',rec.dstruct,''' and lower(l.dispname)=''',lower(planguage),''' and axpflds.fname = l.compname
		left join axlanguage lf on substring(lf.sname FROM 2)= t.name and lower(lf.dispname)=''',lower(planguage),''' and lf.compname=''x__headtext''		
		where axpflds.tstruct=','''',rec.dstruct,''' and savevalue =''T'' 
		union all 
		select ','''',rec.dstruct,''',null,''sourceid'',''sourceid'',''Simple Text'',''c'',''accept'',''T'',
		null,''F'',null,null,null,''F'',null,''F'',''F'',''T'',2,''recordid'',''T'',','''',rec.dprimarytable,'''',',null,1000,null,''F'',''F'',
		null encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
		from dual where ''gm''=','''',rec.rtype,''' 
		union all
		','select distinct t.name transid,coalesce(lf.compcaption,t.caption) formcap, ''app_desc'' ,''Workflow status'' fcap,null cdatatype,''c'' dt,null modeofentry ,''F'' fhide,
		null props,''F'' srckey ,null srctf ,null srcfld ,null srctrans ,''T'' allowempty,
		''Text'' filtercnd,''F'' grpfld,''F'' ,''T'' subentity,2 datacnd,
		null entityrelfld,''T'' allowduplicate,d.tablename,d.dname,1000,d.caption,d.asgrid,
		''T'' listingfld,''F'' encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal	
		from axattachworkflow a join tstructs t on a.transid = t.name  and t.blobno=1		
		join axpdc d on a.transid = d.tstruct and d.dname =''dc1''		
		left join axlanguage lf on substring(lf.sname FROM 2)= t.name and lower(lf.dispname)=''',lower(planguage),''' and lf.compname=''x__headtext''		
		where t.name=','''',rec.dstruct,'''') into v_subentitysql;


	   	

	    for r in execute v_subentitysql
      		loop	    	
        		RETURN NEXT r;	
        	END LOOP;


    END LOOP;


end if;

END; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_listdata(ptransid character varying, pflds text DEFAULT 'All'::text, ppagesize numeric DEFAULT 25, ppageno numeric DEFAULT 1, pfilter text DEFAULT 'NA'::text, puser character varying DEFAULT 'admin'::character varying, papplydac character varying DEFAULT 'T'::character varying, puserrole character varying DEFAULT 'All'::character varying, pconstraints text DEFAULT NULL::text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
rec1 record;
rec2 record;
v_sql text;
v_sql1 text;
v_primarydctable varchar;
v_fldnamesary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_col varchar;
v_fldname_normalized varchar;
v_fldname_srctbl varchar;
v_fldname_srcfld varchar;
v_fldname_allowempty varchar;
v_fldname_dcjoinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_dctablename varchar;
v_fldname_dcflds text;
v_fldname_dctables varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_normalizedtables varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_transidcnd numeric;
v_allflds varchar;
v_filter_srcfld varchar;
v_filter_srctxt varchar;
v_filter_join varchar;
v_filter_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_cnd varchar;
v_filter_cndary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_joinreq numeric;
v_filter_dcjoinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_col varchar;
v_filter_normalized varchar;
v_filter_sourcetbl varchar;
v_filter_sourcefld varchar;
v_filter_datatype varchar;
v_filter_listedfld varchar;
v_filter_tablename varchar;
v_fldname_tables varchar[] DEFAULT  ARRAY[]::varchar[];
v_dac_cnd varchar;
 

begin

	select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';



	select count(1) into v_fldname_transidcnd from axpflds where tstruct = ptransid and dcname ='dc1' and lower(fname)='transid';

		if pflds = 'All' then 		
			select concat(tablename,'=',string_agg(str,'|'))  into v_allflds From(
			select tablename, concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~',allowempty) str,dcname,ordno
			from axpflds where tstruct=ptransid and dcname='dc1' and 
			asgrid ='F' and hidden ='F' and savevalue='T' and tablename = v_primarydctable and datatype not in('i','t')
			union all
			select distinct a.tablename,'app_desc~F~~~T' str,a.dname,1 from axpdc a 
			join AXATTACHWORKFLOW d ON a.tstruct =d.transid 
			where a.tstruct=ptransid and a.dname='dc1'
			order by dcname ,ordno)a group by a.tablename;		 
		end if;
						
		FOR rec1 IN
    		select unnest(string_to_array(case when pflds='All' then v_allflds else pflds end,'^')) dcdtls
    		loop	
    			v_fldname_dctablename := split_part(rec1.dcdtls,'=',1);
				v_fldname_dcflds := split_part(rec1.dcdtls,'=',2);
			
			if v_fldname_dctablename!=v_primarydctable then
						v_fldname_dcjoinsary := array_append(v_fldname_dcjoinsary,concat('left join ',v_fldname_dctablename,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_fldname_dctablename,'.',v_primarydctable,'id') );						
					end if;
					v_fldname_dctables := array_append(v_fldname_dctables,v_fldname_dctablename);

			FOR rec2 IN
    		select unnest(string_to_array(v_fldname_dcflds,'|')) fldname    		    	       			
				loop		    	
					v_fldname_col := split_part(rec2.fldname,'~',1);
					v_fldname_normalized := split_part(rec2.fldname,'~',2);
					v_fldname_srctbl := split_part(rec2.fldname,'~',3);
					v_fldname_srcfld := split_part(rec2.fldname,'~',4);	
					v_fldname_allowempty := split_part(rec2.fldname,'~',5);
			    
				
					
					if v_fldname_normalized ='F' and lower(v_fldname_col)!='app_desc' then 						
						v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_dctablename,'.',v_fldname_col)::varchar);
					elsif v_fldname_normalized ='F' and lower(v_fldname_col)='app_desc' then						
						v_fldnamesary:= array_append(v_fldnamesary,concat('case when length(',v_primarydctable,'.wkid)>2 then case ',v_primarydctable,'.app_desc when 0 then  ''Created''
  when  1 then ''Approved''
  when  2 then ''Review''
  when  3 then ''Return''
  when  4 then ''Approve''
  when  5 then ''Rejected''
  when  9 then ''Orphan'' end else null end app_desc'));
					elsif v_fldname_normalized ='T' then	
						v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_col,'.',v_fldname_srcfld,' ',v_fldname_col)::varchar);	
						v_fldname_joinsary := array_append(v_fldname_joinsary,concat(case when v_fldname_allowempty='F' then ' join ' else ' left join ' end,v_fldname_srctbl,' ',v_fldname_col,' on ',v_fldname_dctablename,'.',v_fldname_col,' = ',v_fldname_col,'.',v_fldname_srctbl,'id')::Varchar);
						v_fldname_normalizedtables := array_append(v_fldname_normalizedtables,lower(v_fldname_srctbl));
					end if;
								
			    end loop;
		   
			   end loop;
		   	v_sql := concat(' select ','''',ptransid,''' transid,',v_primarydctable,'.',v_primarydctable,'id recordid,',v_primarydctable,'.username modifiedby,',v_primarydctable,'.modifiedon,',v_primarydctable,'.createdon,',v_primarydctable,'.createdby,',
		   			 v_primarydctable,'.cancel,',v_primarydctable,'.cancelremarks,',array_to_string(v_fldnamesary,','),
					',null axpeg_processname,null axpeg_keyvalue,null axpeg_status,null axpeg_statustext from ',
					v_primarydctable,' ',array_to_string(v_fldname_dcjoinsary,' '),' ',array_to_string(v_fldname_joinsary,' ')
					 );
 

		   			
---------DAC filters
			   if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_primarydctable||'.');											   					   			   										
			   end if;		   			
		   			
			
		if coalesce(pfilter,'NA') ='NA' then 

			if ppagesize > 0 then 
				v_sql1 := concat('select b.* from(select a.*,row_number() over(order by modifiedon desc)::Numeric rno,
				case when mod(row_number() over(order by modifiedon desc),',ppagesize,')=0 then row_number() over(order by modifiedon desc)/',ppagesize,' else row_number() over(order by modifiedon desc)/',ppagesize,'+1 end::numeric pageno from 
				(',concat(v_sql,' where 1=1 ',case when v_fldname_transidcnd>0 then ' and '||v_primarydctable||'.transid='||''''||ptransid||'''' end,
				case when papplydac ='T' and length(v_dac_cnd) > 2 then concat(' and (',v_dac_cnd,')') end),'
				--axp_filter
				',')a order by modifiedon desc limit ',ppagesize*ppageno,' )b ',case when ppageno=0 then '' else concat('where pageno=',ppageno) end);
			else 
				v_sql1 :=concat('select b.* from(select a.*,0 rno,1 pageno from 
				(',concat(v_sql,' where 1=1 ',case when v_fldname_transidcnd>0 then ' and '||v_primarydctable||'.transid='||''''||ptransid||'''' end,
				case when papplydac ='T' and length(v_dac_cnd) > 2 then concat(' and (',v_dac_cnd,')') end),'
				--axp_filter
				',')a order by modifiedon desc)b ');
			end if;
	
		else 
			FOR rec IN
    			select unnest(string_to_array(pfilter,'^')) ifilter
			    loop		    	
			    	v_filter_srcfld := split_part(rec.ifilter,'|',1);
			    	v_filter_srctxt := split_part(rec.ifilter,'|',2);
			    	v_filter_col := split_part(v_filter_srcfld,'~',1);
				    v_filter_normalized := split_part(v_filter_srcfld,'~',2);
 				    v_filter_sourcetbl := split_part(v_filter_srcfld,'~',3);
 				    v_filter_sourcefld := split_part(v_filter_srcfld,'~',4);
					   v_filter_datatype := split_part(v_filter_srcfld,'~',5);
					v_filter_listedfld :=split_part(v_filter_srcfld,'~',6);
				v_filter_tablename:=split_part(v_filter_srcfld,'~',7);
					
		
			    				    	
			    	if  v_filter_listedfld = 'F' then
			    	
					select count(1) into v_filter_joinreq from (select distinct unnest(v_fldname_dctables)tbls )a where lower(a.tbls)=lower(v_filter_tablename);			    		
					
			    	if v_filter_joinreq = 0  then 
				    	v_filter_dcjoinsary := array_append(v_filter_dcjoinsary,concat(' join ',v_filter_tablename,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_filter_tablename,'.',v_primarydctable,'id') );
				    	v_fldname_tables := array_append(v_fldname_tables,v_filter_tablename);
			    	end if;
			    
			    	
			    
		    		select case when v_filter_normalized='T' 
					then concat(' join ',v_filter_sourcetbl,' ',v_filter_col,' on ',v_filter_tablename,'.',v_filter_col,' = ',v_filter_col,'.',v_filter_sourcetbl,'id')
					end into v_filter_join from dual where v_filter_normalized='T';
					
					 
					v_filter_joinsary :=array_append(v_filter_joinsary,v_filter_join);				
					
				
					end if;
			
									
					select case when v_filter_normalized='F' 
					then concat(case when v_filter_datatype='c' then 'lower(' end,v_filter_tablename,'.',v_filter_col,case when v_filter_datatype='c' then ')' end,' ',v_filter_srctxt) 
					else concat(case when v_filter_datatype='c' then 'lower(' end,v_filter_col,'.',v_filter_sourcefld,case when v_filter_datatype='c' then ')' end,' ',v_filter_srctxt) 
					end into v_filter_cnd;
		    	
					v_filter_cndary := array_append(v_filter_cndary,v_filter_cnd);				
			
									
			    end loop;
			   
			   	v_filter_dcjoinsary := ARRAY(SELECT DISTINCT UNNEST(v_filter_dcjoinsary));				   					   
			   
			   	if ppagesize > 0 then 
						v_sql1 := concat('select b.* from(select a.*,row_number() over(order by modifiedon desc)::Numeric rno,
						case when mod(row_number() over(order by modifiedon desc),',ppagesize,')=0 then row_number() over(order by modifiedon desc)/',ppagesize,' else row_number() over(order by modifiedon desc)/',ppagesize,'+1 end::numeric pageno from 
						(',v_sql,concat(array_to_string(v_filter_dcjoinsary,' '),array_to_string(v_filter_joinsary,' '),' where 1=1 '
						,case when v_fldname_transidcnd>0 then concat(' and ',v_primarydctable,'.transid=','''',ptransid,''' and ') else ' and ' end,
						array_to_string(v_filter_cndary,' and '),case when papplydac ='T' and length(v_dac_cnd) > 2 then concat(' and (',v_dac_cnd,')') end),'
						--axp_filter
						',')a order by modifiedon desc limit ',ppagesize*ppageno,' )b ',case when ppageno=0 then '' else concat('where pageno=',ppageno) end);	
				else 	
						v_sql1 := concat('select b.* from(select a.*,0 rno,1 pageno from 
						(',v_sql,concat(array_to_string(v_filter_dcjoinsary,' '),array_to_string(v_filter_joinsary,' '),' where 1=1 '
						,case when v_fldname_transidcnd>0 then concat(' and ',v_primarydctable,'.transid=','''',ptransid,''' and ') else ' and ' end,
						array_to_string(v_filter_cndary,' and '),case when papplydac ='T' and length(v_dac_cnd) > 2 then concat(' and (',v_dac_cnd,')') end),'
						--axp_filter
						)a order by modifiedon desc)b ');		
			
				end if;			    						
		end if;

return v_sql1;

END; $function$
;
>>

<<
DROP FUNCTION fn_axpanalytics_chartdata(varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, text);
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_chartdata(psource character varying, pentity_transid character varying, pcondition character varying, pcriteria character varying, pfilter character varying DEFAULT 'NA'::character varying, pusername character varying DEFAULT 'admin'::character varying, papplydac character varying DEFAULT 'T'::character varying, puserrole character varying DEFAULT 'All'::character varying, pconstraints text DEFAULT NULL::text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
rec record;
rec_filters record;
dacrec record;
v_primarydctable varchar;
v_subentitytable varchar;
v_transid varchar;
v_grpfld varchar;
v_aggfld varchar;
v_aggfnc varchar;
v_srckey varchar;
v_srctbl varchar;
v_srcfld varchar;
v_aempty varchar;
v_tablename varchar;
v_sql text;
v_normalizedjoin varchar;
v_keyname varchar;
v_keyname_coalesce varchar;
v_entitycond varchar;
v_keyfld_fname varchar;
v_keyfld_fval varchar;
v_keyfld_srckey varchar;
v_keyfld_srctbl varchar;
v_keyfld_srcfld varchar;
v_final_sqls text[] DEFAULT  ARRAY[]::text[];
v_fldname_transidcnd numeric;
v_sql1 text;
v_jointables varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_srcfld varchar;
v_filter_srctxt varchar;
v_filter_join varchar;
v_filter_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_cnd varchar;
v_filter_cndary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_joinreq numeric;
v_filter_dcjoinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_col varchar;
v_filter_normalized varchar;
v_filter_sourcetbl varchar;
v_filter_sourcefld varchar;
v_filter_datatype varchar;
v_filter_listedfld varchar;
v_filter_tablename varchar;
v_emptyary varchar[] DEFAULT  ARRAY[]::varchar[];
v_dac_cnd varchar;

begin
	
	select tablename into v_primarydctable from axpdc where tstruct = pentity_transid and dname ='dc1';	

	v_jointables := array_append(v_jointables,v_primarydctable);


-------------Permission filter
	   if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_primarydctable||'.');											   					   			   										
			   end if;		   			
		   			
	
	if pcondition ='Custom' then
	
		select count(1) into v_fldname_transidcnd from axpflds where tstruct = pentity_transid and dcname ='dc1' and lower(fname)='transid';


		if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_primarydctable||'.');											   					   			   										
			   end if;		   			
	
	    FOR rec IN
    	    select unnest(string_to_array(pcriteria,'^')) criteria 
		    loop		    			    
			    v_transid := split_part(rec.criteria,'~',1);
		    	v_grpfld := split_part(rec.criteria,'~',2);
				v_aggfld := case when split_part(rec.criteria,'~',3)='count' then '1' else split_part(rec.criteria,'~',3) end;
				v_aggfnc := split_part(rec.criteria,'~',4);
				v_srckey := split_part(rec.criteria,'~',5);
				v_srctbl := split_part(rec.criteria,'~',6);
				v_srcfld := split_part(rec.criteria,'~',7);
				v_aempty := split_part(rec.criteria,'~',8);
				v_tablename := split_part(rec.criteria,'~',9);
				v_keyfld_fname := split_part(rec.criteria,'~',10);
				v_keyfld_fval := split_part(rec.criteria,'~',11);
				
				v_jointables := case when v_srckey='T' then array_append(v_jointables,v_srctbl) end;
				v_normalizedjoin := case when v_srckey='T' then concat(' left join ',v_srctbl,' b on ',v_primarydctable,'.',v_grpfld,' = b.',v_srctbl,'id ') else ' ' end;
				v_keyname := case when length(v_grpfld) > 0 then case when v_srckey='T' then concat('b.',v_srcfld) else concat(v_primarydctable,'.',v_grpfld) end else 'null' end;			
				v_keyname_coalesce := 'coalesce(trim('||v_keyname||'), '''')';							
				
					if lower(v_tablename)=lower(v_primarydctable) then
						select concat('select ',v_keyname_coalesce,' keyname,',case when lower(trim(v_aggfnc)) in ('sum','avg') then 'round('||v_aggfnc||'('||v_aggfld||'),2)'else v_aggfnc||'('||v_aggfld||')' end,
						'keyvalue,''Custom''::varchar cnd,','''',rec.criteria,'''::varchar',' criteria from ',v_tablename,' ',v_normalizedjoin)
						into v_sql;
						v_jointables := array_append(v_jointables,v_tablename);		   			   									
					else
						select concat('select ',
						concat(' ',v_keyname,' keyname,',case when lower(trim(v_aggfnc)) in ('sum','avg') then 'round('||v_aggfnc||'('||v_aggfld||'),2)'else v_aggfnc||'('||v_aggfld||')' end,
						' keyvalue,''Custom''::varchar cnd,','''',rec.criteria,'''::varchar',' criteria from ',
						concat(v_primarydctable,'  join ',v_tablename,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_tablename,'.',v_primarydctable,'id '),
						v_normalizedjoin))a
						into v_sql;
						v_jointables := array_append(v_jointables,v_tablename);
						
					end if;																											
			
						
			
				if coalesce(pfilter,'NA') ='NA' then 

			v_sql1 := concat(v_sql,' ',' where 1=1 ',
						case when v_fldname_transidcnd > 0 then concat(' and ',v_primarydctable,'.transid=''',pentity_transid,'''') end,
						case when papplydac ='T' and length(v_dac_cnd)>2 then concat(' and (',v_dac_cnd,')') end,'
						--axp_filter
						',
						case when length(v_grpfld) > 0 then concat(' group by ',v_keyname_coalesce) else '' end);
	
		else 
			FOR rec_filters IN
    			select unnest(string_to_array(pfilter,'^')) ifilter
			    loop		    	
			    	v_filter_srcfld := split_part(rec_filters.ifilter,'|',1);
			    	v_filter_srctxt := split_part(rec_filters.ifilter,'|',2);
			    	v_filter_col := split_part(v_filter_srcfld,'~',1);
				    v_filter_normalized := split_part(v_filter_srcfld,'~',2);
 				    v_filter_sourcetbl := split_part(v_filter_srcfld,'~',3);
 				    v_filter_sourcefld := split_part(v_filter_srcfld,'~',4);
					v_filter_datatype := split_part(v_filter_srcfld,'~',5);
					v_filter_listedfld :=split_part(v_filter_srcfld,'~',6);
					v_filter_tablename:=split_part(v_filter_srcfld,'~',7);
					
		
			    				    	
			    	if  v_filter_listedfld = 'F' then
			    	
					v_filter_joinreq := case when lower(v_tablename)=lower(v_filter_tablename) then 1 else 0 end; 			    		
					
			    	if v_filter_joinreq = 0  then 
				    	v_filter_dcjoinsary := array_append(v_filter_dcjoinsary,concat(' join ',v_filter_tablename,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_filter_tablename,'.',v_primarydctable,'id') );
			    	end if;
			    
			    	
			    
		    		select case when v_filter_normalized='T' 
					then concat(' join ',v_filter_sourcetbl,' ',v_filter_col,' on ',v_filter_tablename,'.',v_filter_col,' = ',v_filter_col,'.',v_filter_sourcetbl,'id')
					end into v_filter_join from dual where v_filter_normalized='T';
					
					 
					v_filter_joinsary :=array_append(v_filter_joinsary,v_filter_join);				
					
				
					end if;
			
									
					select case when v_filter_normalized='F' 
					then concat(case when v_filter_datatype='c' then 'lower(' end,v_filter_tablename,'.',v_filter_col,case when v_filter_datatype='c' then ')' end,' ',v_filter_srctxt) 
					else concat(case when v_filter_datatype='c' then 'lower(' end,v_filter_col,'.',v_filter_sourcefld,case when v_filter_datatype='c' then ')' end,' ',v_filter_srctxt) 
					end into v_filter_cnd;
		    	
					v_filter_cndary := array_append(v_filter_cndary,v_filter_cnd);				
			
									
			    end loop;
			   
			   	v_filter_dcjoinsary := ARRAY(SELECT DISTINCT UNNEST(v_filter_dcjoinsary));		
		
				v_sql1 := concat(v_sql,array_to_string(v_filter_dcjoinsary,' '),array_to_string(v_filter_joinsary,' '),'
						  where 1=1 ',
						case when v_fldname_transidcnd > 0 then concat(' and ',v_primarydctable,'.transid=''',pentity_transid,'''') else ' and ' end,array_to_string(v_filter_cndary,' and '),
						case when papplydac ='T' then concat(' and (',v_dac_cnd,')') end,'
						--axp_filter
						',
						case when length(v_grpfld) > 0 then concat(' group by ',v_keyname_coalesce) else '' end);					    						
		end if;

			v_final_sqls := array_append(v_final_sqls,v_sql1);
			v_filter_cndary:= v_emptyary;
			v_jointables :=v_emptyary;
	    	END LOOP;
	   
   elsif pcondition = 'General' then 
		if psource ='Entity' then    
						
			select count(1) into v_fldname_transidcnd from axpflds where tstruct = pentity_transid and dcname ='dc1' and lower(fname)='transid';


			if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_primarydctable||'.');											   					   			   										
			   end if;		   			

			select concat('select count(*) totrec,
			sum(case when date_part(''year'' ,',v_primarydctable,'.createdon) = date_part(''year'',current_date) then 1 else 0 end) cyear,
			sum(case when date_part(''month'' ,',v_primarydctable,'.createdon) = date_part(''month'',current_date) then 1 else 0 end) cmonth,
			sum(case when date_part(''week'' ,',v_primarydctable,'.createdon) = date_part(''week'',current_date) then 1 else 0 end) cweek,
			sum(case when ',v_primarydctable,'.createdon::Date = current_date - 1 then 1 else 0 end) cyesterday,
			sum(case when ',v_primarydctable,'.createdon::Date = current_date then 1 else 0 end) ctoday,''General''::varchar cnd,null::varchar criteria
			from ',v_primarydctable,' where 1=1 ',
			case when v_fldname_transidcnd > 0 then concat(' and transid=''',pentity_transid,'''') end,
			case when papplydac ='T' and length(v_dac_cnd)>2 then concat(' and (',v_dac_cnd,')') end) into v_sql;		


		
			
		v_final_sqls := array_append(v_final_sqls,v_sql);

		
				
		elsif psource= 'Subentity' then 		
		    FOR rec IN
	    	    select unnest(string_to_array(pcriteria,'^')) criteria
		    loop		    			    
	      		v_transid := split_part(rec.criteria,'~',1);
	      		v_tablename := split_part(rec.criteria,'~',9);
				v_keyfld_fname := split_part(rec.criteria,'~',10);
				v_keyfld_fval := split_part(rec.criteria,'~',11);
				v_keyfld_srckey := split_part(rec.criteria,'~',5);
				v_keyfld_srctbl := split_part(rec.criteria,'~',6);
				v_keyfld_srcfld := split_part(rec.criteria,'~',7);

				select tablename into v_subentitytable from axpdc where tstruct = v_transid and dname ='dc1';				
			
				select count(1) into v_fldname_transidcnd from axpflds where tstruct = v_transid and dcname ='dc1' and lower(fname)='transid';


				if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_tablename||'.');											   					   			   										
			   end if;		   			
			
				if lower(v_tablename)=lower(v_subentitytable) then
			
				 v_sql := concat('select ','''',v_transid,'''transid',',count(*) totrec,''General''::varchar cnd,','''',replace(rec.criteria,'''',''),'''  criteria from '
								,v_tablename
								,case when v_keyfld_srckey='T' then ' join '||v_keyfld_srctbl||' on '||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id = '||v_tablename||'.'||v_keyfld_fname end
								,' where 1=1 ',
				 case when v_fldname_transidcnd > 0 then concat(' and ',v_tablename,'.transid=''',v_transid,''' and ') else ' and ' end
				 ,case when v_keyfld_srckey='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else v_keyfld_fname end,'=',v_keyfld_fval				 
					);				
				
				else 
				
				v_sql := concat('select ','''',v_transid,'''transid',',count(*) totrec,''General''::varchar cnd,','''',replace(rec.criteria,'''',''),'''  criteria from '
								,v_tablename,' a join ',v_subentitytable,' b on a.',v_subentitytable,'id=b.',v_subentitytable,'id '
								,case when v_keyfld_srckey='T' then ' join '||v_keyfld_srctbl||' on '||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id = a.'||v_keyfld_fname end
								,' where 1=1 ',
				case when v_fldname_transidcnd > 0 then concat(' and b.transid=''',v_transid,''' and ') else ' and ' end
				 ,case when v_keyfld_srckey='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else v_keyfld_fname end,'=',v_keyfld_fval				 
				);
				
					
				end if;
			
				v_final_sqls := array_append(v_final_sqls,v_sql);			
			
			END LOOP;	
		
		end if;
	end if;

 
   return array_to_string(v_final_sqls,'^^^') ;

END;
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_se_listdata(pentity_transid character varying, pflds_keyval text, ppagesize numeric DEFAULT 50, ppageno numeric DEFAULT 1)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
rec record;
rec1 record;
rec2 record;
v_sql text;
v_sql1 text;
v_fldname_table varchar;
v_fldname_col varchar;
v_fldname_normalized varchar;
v_fldname_srctbl varchar;
v_fldname_srcfld varchar;
v_fldname_allowempty varchar;
v_fldname_transidcnd numeric;
v_allflds varchar;
v_fldnamesary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_join varchar;
v_fldname_tblflds text;
v_fldname_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_emptyary varchar[] DEFAULT  ARRAY[]::varchar[];
v_pflds_transid varchar;
v_pflds_flds varchar;
v_pflds_keyvalue varchar;
v_pflds_keytable varchar;
v_keyvalue_fname varchar;
v_keyvalue_fvalue varchar;
v_keyvalue_fname_srckey varchar;
v_keyvalue_fname_srctbl varchar;
v_keyvalue_fname_srcfld varchar;
v_final_sqls text[] DEFAULT  ARRAY[]::text[];
v_primarydctable varchar;
v_fldname_dcjoinsary varchar[] DEFAULT  ARRAY[]::varchar[];

begin	

	
	FOR rec in select unnest(string_to_array(pflds_keyval,'++')) fldkeyvals ---- multiple transid split   	 
    loop
	    	
	    	v_pflds_transid := split_part(rec.fldkeyvals,'=',1) ;	    	
	    	v_pflds_flds := split_part(rec.fldkeyvals,'=',2) ;--tablename=~fldname~normalized~source_table~source_fld~mandatory|fldname2~normalized~source_table~source_fld~mandatory^tablename2=~fldname~normalized~srctbl~srcfld~mandatory
	    	v_pflds_keyvalue := split_part(rec.fldkeyvals,'=',3) ;
	    	v_pflds_keytable := split_part(v_pflds_keyvalue,'~',3) ;  	    
			v_keyvalue_fname := split_part(v_pflds_keyvalue,'~',1);
			v_keyvalue_fvalue := split_part(v_pflds_keyvalue,'~',2);		
			v_keyvalue_fname_srckey := split_part(v_pflds_keyvalue,'~',4) ;
			v_keyvalue_fname_srctbl := split_part(v_pflds_keyvalue,'~',5) ;
			v_keyvalue_fname_srcfld := split_part(v_pflds_keyvalue,'~',6) ;		
						
	    	

	    	select tablename into v_primarydctable from axpdc where tstruct =v_pflds_transid and dname ='dc1';
	    
	    	select count(1) into v_fldname_transidcnd from axpflds where tstruct = v_pflds_transid and dcname ='dc1' and lower(fname)='transid';
	    	    	    
	    
	    	if lower(v_pflds_keytable) = lower(v_primarydctable) and v_pflds_flds ='All' then
		    	select concat(tablename ,'!~',string_agg(str,'|'))  into v_allflds From(
				select tablename,concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~',allowempty) str
				from axpflds where tstruct=v_pflds_transid and 
				dcname ='dc1' and 
				asgrid ='F' and hidden ='F' and savevalue='T' and datatype not in('i','t') and lower(fname)!='transid'
				order by dcname ,ordno)a group by a.tablename;
			elsif lower(v_pflds_keytable) != lower(v_primarydctable) and v_pflds_flds ='All' then
				select concat(tablename ,'!~',string_agg(str,'|'),'^',v_pflds_keytable,'!~',split_part(split_part(v_pflds_keyvalue,'~',1),'.',2),'~',split_part(v_pflds_keyvalue,'~',4),'~',split_part(v_pflds_keyvalue,'~',5),'~',split_part(v_pflds_keyvalue,'~',6),'~',split_part(v_pflds_keyvalue,'~',7))  into v_allflds From(
				select tablename,concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~',allowempty) str
				from axpflds where tstruct=v_pflds_transid and 
				dcname ='dc1' and 
				asgrid ='F' and hidden ='F' and savevalue='T' and datatype not in('i','t')
				order by dcname ,ordno)a group by a.tablename;				
		    end if;
	    
	    for rec1 in select unnest(string_to_array(case when v_pflds_flds='All' then v_allflds else v_pflds_flds end,'^')) tblflds --single transid & single table split --tablename=~fldname~normalized~source_table~source_fld~mandatory|fldname2~normalized~source_table~source_fld~mandatory 
	    	loop		    			    			    			     
		    		v_fldname_table := 	split_part(rec1.tblflds,'!~',1);
		    		v_fldname_tblflds := 	split_part(rec1.tblflds,'!~',2);
		    		
		    	if lower(v_fldname_table)!=lower(v_primarydctable) then
					v_fldname_dcjoinsary := array_append(v_fldname_dcjoinsary,concat('left join ',v_fldname_table,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_fldname_table,'.',v_primarydctable,'id') );		    							
				end if;
		    
				if lower(v_fldname_table)!=lower(v_pflds_keytable) then
					v_fldname_dcjoinsary := array_append(v_fldname_dcjoinsary,concat('left join ',v_pflds_keytable,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_pflds_keytable,'.',v_primarydctable,'id') );		    							
				end if;
				
					if v_keyvalue_fname_srckey='T' then 
							v_fldname_joinsary := array_append(v_fldname_joinsary,concat(' join ' ,v_keyvalue_fname_srctbl,' ',' on ',v_keyvalue_fname,' = ',v_keyvalue_fname_srctbl,'.',v_keyvalue_fname_srctbl,'id')::Varchar);
					
							end if;
							
		
		    			    	
			    FOR rec2 in			    	
    				select unnest(string_to_array(v_fldname_tblflds,'|')) fldname--tablename=~fldname~normalized~source_table~source_fld~mandatory
						loop							
							v_fldname_col := split_part(rec2.fldname,'~',1);
							v_fldname_normalized := split_part(rec2.fldname,'~',2);
							v_fldname_srctbl := split_part(rec2.fldname,'~',3);
							v_fldname_srcfld := split_part(rec2.fldname,'~',4);														
							v_fldname_allowempty := split_part(rec2.fldname,'~',5);
								
						
							
							
							
							if v_fldname_normalized ='F' and lower(v_fldname_col)!='app_desc' then 
								v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_table,'.',v_fldname_col)::varchar);
							elsif v_fldname_normalized ='F' and lower(v_fldname_col)='app_desc' then						
								v_fldnamesary:= array_append(v_fldnamesary,concat('case when length(',v_fldname_table,'.wkid)>2 then case ',v_fldname_table,'.app_desc when 0 then  ''Created''
												  when  1 then ''Approved''
												  when  2 then ''Review''
												  when  3 then ''Return''
												  when  4 then ''Approve''
												  when  5 then ''Rejected''
												  when  9 then ''Orphan'' end else null end app_desc'));
							elsif v_fldname_normalized ='T' then	
								v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_col,'.',v_fldname_srcfld,' ',v_fldname_col)::varchar);	
								
								v_fldname_joinsary := array_append(v_fldname_joinsary,concat(case when v_fldname_allowempty='F' then ' join ' else ' left join ' end,v_fldname_srctbl,' ',v_fldname_col,' on ',v_fldname_table,'.',v_fldname_col,' = ',v_fldname_col,'.',v_fldname_srctbl,'id')::Varchar);
							end if;								
												
						

						

			    		end loop;
		   end loop;
		  
		  v_fldname_dcjoinsary := ARRAY(SELECT DISTINCT UNNEST(v_fldname_dcjoinsary));	
		  v_fldname_joinsary := ARRAY(SELECT DISTINCT UNNEST(v_fldname_joinsary));
		
		   
		   	v_sql := concat(' select ','''',v_pflds_transid,''' transid,',v_primarydctable,'.',v_primarydctable,'id recordid,',v_primarydctable,'.username modifiedby,',v_primarydctable,'.modifiedon,',v_primarydctable,'.createdon,',v_primarydctable,'.createdby,',
						v_primarydctable,'.cancel,',v_primarydctable,'.cancelremarks,',array_to_string(v_fldnamesary,','),
						',null axpeg_processname,null axpeg_keyvalue,null axpeg_status,null axpeg_statustext from ',v_primarydctable,' ',array_to_string(v_fldname_dcjoinsary,' '),' ',array_to_string(v_fldname_joinsary,' '),
		   				' where 1=1',case when v_fldname_transidcnd>0 then concat(' and ',v_primarydctable,'.transid=','''',v_pflds_transid,''' and ') else ' and ' end ,
						case when v_keyvalue_fname_srckey='T'  then v_keyvalue_fname_srctbl||'.'||v_keyvalue_fname_srcfld else v_keyvalue_fname end ,'=',v_keyvalue_fvalue,'
						--axp_filter
						');

		   				v_fldnamesary:= v_emptyary;
		   				v_fldname_joinsary:= v_emptyary;	   				
		   				v_fldname_dcjoinsary:= v_emptyary;	   				
	 
	    
	    if ppagesize>0 then 
	   		v_sql1 := concat('select * from(select a.*,row_number() over(order by modifiedon desc)::Numeric rno,
			case when mod(row_number() over(order by modifiedon desc),',ppagesize,')=0 then row_number() over(order by modifiedon desc)/',ppagesize,' else row_number() over(order by modifiedon desc)/',ppagesize,'+1 end::numeric pageno from 
			(',v_sql,')a order by modifiedon desc limit ',ppagesize*ppageno,' )b ',case when ppageno=0 then '' else concat('where pageno=',ppageno) end);
		else
			v_sql1 := concat('select * from(select a.*,0 rno,1 pageno from (',v_sql,')a order by modifiedon desc)b ');
		end if;
		
		
		
v_final_sqls := array_append(v_final_sqls,v_sql1);

    END LOOP;
  
return array_to_string(v_final_sqls,'^^^') ;
   	
END;
$function$
;
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




v_sql := 'select ''exists(select 1 from unnest(string_to_array('||replace(rec.fname,'axug_','{primarytable.}axg_')||','''','''')) val where val in(''''''||replace( :'||rec.fname||','','','''''','''''')||''''''))'' cnd from(select '''||rec.fname||''' gname,unnest(string_to_array(:'||rec.fname||','','')) gval from dual)a group by gname having sum(case when gval=''All'' then 1 else 0 end) = 0';


v_sqlary := array_append(v_sqlary,v_sql);

end loop;

return case when array_length(v_sqlary,1)>0 then  'select string_agg(cnd,'' and '') from ( '||array_to_string(v_sqlary,' union all ')||')b' else 'select null from dual' end;
 
END; $function$
;
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
	

for r in select grpname from axgroupingmst loop 

	v_altersql :='alter table '||ptable||' add axg_'||r.grpname||' varchar(4000)';
	execute v_altersql;

end loop;

return 'T';

exception when others then return 'F';
 
end;

$function$
;
>>

<<
DROP FUNCTION fn_permissions_getadscnd;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getadscnd(ptransid character varying, padsname character varying, pusername character varying, proles character varying DEFAULT 'All'::character varying, pkeyfield character varying DEFAULT NULL::character varying, pkeyvalue character varying DEFAULT NULL::character varying)
 RETURNS TABLE(fullcontrol character varying, userrole character varying, view_access character varying, view_includeflds character varying, view_excludeflds character varying, maskedflds character varying, filtercnd text, permissiontype character varying)
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
rolesql text;
v_permissionsql text;
v_permissionexists numeric;
begin


if proles='All' then 
	rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
	case when viewctrl=''2'' then viewlist else null end view_excludedflds,a.fieldmaskstr,b.cnd1 cnd,viewctrl,''Role'' permissiontype  
	from AxPermissions a 
	join axuserlevelgroups a2 on a2.axusergroup = a.axuserrole 
	join axusers u on a2.axusersid = u.axusersid    
	--left join axuserpermissions b on a.axuserrole = b.axuserrole 
left join axusergrouping b on u.axusersid = b.axusersid
	where u.username = '''||pusername||''' and a.formtransid='''||padsname||'''
union all
select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
	case when viewctrl=''2'' then viewlist else null end view_excludedflds,a.fieldmaskstr,b.cnd,viewctrl,''User'' permissiontype  
	from AxPermissions a 
	left join axuserdpermissions b on a.AxPermissionsid = b.AxPermissionsid 
	where a.axusername = '''||pusername||''' and a.formtransid='''||padsname||'''';
	
	
	v_permissionsql := 'select count(cnt) from(select 1 cnt
	from AxPermissions a 
	join axuserlevelgroups a2 on a2.axusergroup = a.axuserrole 
	join axusers u on a2.axusersid = u.axusersid    
	--left join axuserpermissions b on a.axuserrole = b.axuserrole 
left join axusergrouping b on u.axusersid = b.axusersid
	where u.username = '''||pusername||''' and a.formtransid='''||padsname||'''
union all
select 1 cnt 
	from AxPermissions a 
	left join axuserdpermissions b on a.AxPermissionsid = b.AxPermissionsid 
	where a.axusername = '''||pusername||''' and a.formtransid='''||padsname||''')a';

else

	rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
	case when viewctrl=''2'' then viewlist else null end view_excludedflds,
	a.fieldmaskstr,b.cnd,viewctrl,''Role'' permissiontype  
	from AxPermissions a 
	join axuserlevelgroups a2 on a2.axusergroup = a.axuserrole 
	join axusers u on a2.axusersid = u.axusersid
	--left join axuserpermissions b on a.axuserrole = b.axuserrole 
left join (
select a2.usergroup ,b.cnd1 cnd from axusers a join axuserlevelgroups a2 on a2.axusersid = a.axusersid left join axusergrouping b on a.axusersid =b.axusersid  where a.username = '''||pusername||''')b on a.axuserrole=b.usergroup
	where u.username = '''||pusername||''' and a.formtransid='''||padsname||'''
	and exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (a.axuserrole))
union all
select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
	case when viewctrl=''2'' then viewlist else null end view_excludedflds,
	a.fieldmaskstr,b.cnd,viewctrl,''User'' permissiontype  from AxPermissions a 
	left join axuserdpermissions b on a.AxPermissionsid = b.AxPermissionsid 
	where a.axusername = '''||pusername||''' and a.formtransid='''||padsname||'''';
	
	v_permissionsql:= 'select count(cnt) from(select 1 cnt
	from AxPermissions a 
	join axuserlevelgroups a2 on a2.axusergroup = a.axuserrole 
	join axusers u on a2.axusersid = u.axusersid
	--left join axuserpermissions b on a.axuserrole = b.axuserrole 
left join (
select a2.usergroup ,b.cnd1 cnd from axusers a join axuserlevelgroups a2 on a2.axusersid = a.axusersid left join axusergrouping b on a.axusersid =b.axusersid  where a.username = '''||pusername||''')b on a.axuserrole=b.usergroup
	where u.username = '''||pusername||''' and a.formtransid='''||padsname||'''
	and exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (a.axuserrole))
union all
select 1  from AxPermissions a 
	left join axuserdpermissions b on a.AxPermissionsid = b.AxPermissionsid 
	where a.axusername = '''||pusername||''' and a.formtransid='''||padsname||''')a';

end if;

execute v_permissionsql into  v_permissionexists;

if v_permissionexists = 0 then 

	fullcontrol:= 'T';
	return next;

else

	for rec in execute rolesql
	loop
	
			userrole := rec.axuserrole;
			view_includeflds := rec.view_includedflds;
			view_excludeflds := rec.view_excludedflds;
			maskedflds := rec.fieldmaskstr;
			filtercnd := rec.cnd;		
			view_access := case when rec.viewctrl='4' then 'None' else null end;		
			permissiontype := rec.permissiontype;
			return next;
	
	
	end loop;

end if;
 
return;
	
END; 
$function$
;
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
v_addfilter varchar;
v_addcolselection varchar;
v_addpagination varchar;
v_addsoring varchar;
v_grouping varchar;
begin




select sqltext,case when smartlistcnd like '%Dynamic select columns%' then 'T' else 'F' end dynamiccolumns,
case when smartlistcnd like '%Filter%' then 'T' else 'F' end filters,
case when smartlistcnd like '%Pagination%' then 'T' else 'F' end pagination,
case when smartlistcnd like '%Sorting%' then 'T' else 'F' end sorting,
case when smartlistcnd like '%Grouping%' then 'T' else 'F' end aggregations
into v_adssql,v_addcolselection,v_addfilter,v_addpagination,v_addsoring,v_grouping from axdirectsql 
where sqlname = padsname;

if pcond !='NA' then 

select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';


v_filtercnd := concat(' and (',replace(pcond,'{primarytable.}',v_primarydctable||'.'),')');
	
v_filtersql := replace(v_adssql,'--ax_permission_filter',v_filtercnd);


end if;


v_adssql := concat(case when v_addcolselection='T' 
then 'select --ax_select_columns 
from('else 'select * from(' end
,v_adssql,')wpc
',case when v_addfilter='T' then '--ax_ui_filter_withwhere
'end,
case when v_grouping='T' then '--ax_groupby
'end,
case when v_addsoring='T' then '--ax_orderby
'end,
case when v_addpagination='T' then '--ax_pagination
'end);


return case when pcond ='NA' then  v_adssql else v_filtersql end;
	
	
END; 
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getdcrecid(ptransid character varying, precordid numeric, pdcstring character varying)
 RETURNS TABLE(dcname character varying, rowno numeric, recordid numeric)
 LANGUAGE plpgsql
AS $function$
declare 
v_rec record;
v_rec1 record;
v_sql text;
v_dcname varchar;
v_rowstring varchar;
v_dctable varchar;
v_primarydctable varchar;
begin


select tablename into v_primarydctable from axpdc where tstruct=ptransid and dname='dc1';

for v_rec in select unnest(string_to_array(pdcstring,'|')) str from dual
Loop
	v_dcname := split_part(v_rec.str,'~',1);
	v_rowstring := split_part(v_rec.str,'~',2);

	select tablename into v_dctable from axpdc where tstruct=ptransid and dname=v_dcname;

	if v_rowstring = '0' then 
		v_sql := 'select '''||v_dcname||''' dcname,'||v_rowstring||' rowno,'||v_dctable||'id recordid from '||v_dctable||' where '||v_primarydctable||'id::numeric='||precordid;
	else 
		v_sql := 'select '''||v_dcname||''' dcname,'||v_dctable||'row rowno,'||v_dctable||'id recordid from '||v_dctable||' where '||v_primarydctable||'id::numeric='||precordid||' and '||v_dctable||'row in(select unnest(string_to_array('''||v_rowstring||''','',''))::numeric)';
	end if;

		for v_rec1 in execute v_sql 
		Loop 		
			dcname :=v_rec1.dcname;
			rowno :=v_rec1.rowno;
			recordid :=v_rec1.recordid;		
			return next;
		end loop; 
	

		 		
end loop;

return;


	
END; 
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getsqls(pmode character varying, ptransid character varying, pkeyfld character varying, pkeyvalue character varying, pcond text, pincdc character varying, pexcdc character varying, pincflds text, pexcflds text)
 RETURNS TABLE(dcno character varying, dcsql text)
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
rec1 record;
rec2 record;
--rolesql text;
v_transid_primetable varchar(100);
v_transid_primetableid varchar(100);
v_keyfld_normalized varchar(1);
v_keyfld_srctbl varchar(100);
v_keyfld_srcfld varchar(100);
v_keyfld_mandatory varchar(1);
v_keyfld_joins varchar(500);
v_keyfld_cnd varchar(500);
v_primarydctable varchar;
v_allflds text;
v_fldname_dctablename varchar;
v_fldname_dcflds text;
v_fldname_dcjoinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_dctables varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_col varchar;
v_fldname_normalized varchar;
v_fldname_srctbl varchar;
v_fldname_srcfld varchar;
v_fldname_allowempty varchar;
v_fldnamesary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_normalizedtables varchar[] DEFAULT  ARRAY[]::varchar[];
v_sql text;
v_onlydcselect numeric;
v_emptyary varchar[] DEFAULT  ARRAY[]::varchar[];
v_alldcs varchar;
begin

select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';

select srckey,srctf,srcfld,allowempty into v_keyfld_normalized,v_keyfld_srctbl,v_keyfld_srcfld,v_keyfld_mandatory
from axpflds where tstruct = ptransid and fname = pkeyfld;

select tablename into v_transid_primetable from axpdc where tstruct=ptransid and dname='dc1';

v_transid_primetableid := case when lower(pkeyfld)='recordid' then v_transid_primetable||'id' else pkeyfld end;

v_keyfld_cnd := case when v_keyfld_normalized='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else  v_transid_primetable||'.'||v_transid_primetableid end ||'='||pkeyvalue;

if v_keyfld_normalized='T' then 
	v_keyfld_joins := case when v_keyfld_mandatory='T' then ' join ' else ' left join ' end
					  ||v_keyfld_srctbl||' '||pkeyfld||' on '||v_transid_primetable||'.'||pkeyfld||'='||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id';		
	
end if;



	if pincdc is null then 	
		select string_agg(dname,',') into v_alldcs from axpdc where tstruct = ptransid
		and not exists(select 1 from unnest(string_to_array( pexcdc,',')) val where val = dname);	
	else		
		with a as(select unnest(string_to_array('dc1,dc2,dc3',','))  fname from dual)
		select fname into v_alldcs  from a where not exists(select 1 from unnest(string_to_array(pexcdc,',')) val where val = a.fname);
	end if;



for rec in select unnest(string_to_array(v_alldcs,',')) dcname 
loop

	select count(1) into v_onlydcselect
	from axpflds where tstruct= ptransid and dcname=rec.dcname and savevalue='T' 
	and exists (select 1 from unnest(string_to_array( pincflds,',')) val where val = fname);

	if v_onlydcselect > 0 then
		select concat(tablename,'=',string_agg(str,'|'))  into v_allflds From(
		select tablename, concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~',allowempty) str
		from axpflds where tstruct=ptransid and dcname=rec.dcname and savevalue='T' 
		and exists (select 1 from unnest(string_to_array( pincflds,',')) val where val = fname)
		and not exists(select 1 from unnest(string_to_array( pexcflds,',')) val where val = fname) 		
		order by dcname ,ordno)a group by a.tablename;
	else
		select concat(tablename,'=',string_agg(str,'|'))  into v_allflds From(
		select tablename, concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~',allowempty) str
		from axpflds where tstruct=ptransid and dcname=rec.dcname and savevalue='T' 
		and not exists(select 1 from unnest(string_to_array( pexcflds,',')) val where val = fname) 		
		order by dcname ,ordno)a group by a.tablename;
	end if; 
	
	FOR rec1 IN
    		select unnest(string_to_array(v_allflds,'^')) dcdtls
    		loop	
    			v_fldname_dctablename := split_part(rec1.dcdtls,'=',1);
				v_fldname_dcflds := split_part(rec1.dcdtls,'=',2);
			
			if v_fldname_dctablename!=v_primarydctable then
						v_fldname_dcjoinsary := array_append(v_fldname_dcjoinsary,concat('left join ',v_fldname_dctablename,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_fldname_dctablename,'.',v_primarydctable,'id') );						
					end if;
					v_fldname_dctables := array_append(v_fldname_dctables,v_fldname_dctablename);

			FOR rec2 IN
    		select unnest(string_to_array(v_fldname_dcflds,'|')) fldname    		    	       			
				loop		    	
					v_fldname_col := split_part(rec2.fldname,'~',1);
					v_fldname_normalized := split_part(rec2.fldname,'~',2);
					v_fldname_srctbl := split_part(rec2.fldname,'~',3);
					v_fldname_srcfld := split_part(rec2.fldname,'~',4);	
					v_fldname_allowempty := split_part(rec2.fldname,'~',5);
			    
				
					
					if v_fldname_normalized ='F' then 
						v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_dctablename,'.',v_fldname_col)::varchar);
					elsif v_fldname_normalized ='T' then	
						v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_col,'.',v_fldname_srcfld,' ',v_fldname_col)::varchar);	
						v_fldname_joinsary := array_append(v_fldname_joinsary,concat(case when v_fldname_allowempty='F' then ' join ' else ' left join ' end,v_fldname_srctbl,' ',v_fldname_col,' on ',v_fldname_dctablename,'.',v_fldname_col,' = ',v_fldname_col,'.',v_fldname_srctbl,'id')::Varchar);
						v_fldname_normalizedtables := array_append(v_fldname_normalizedtables,lower(v_fldname_srctbl));
					end if;
								
			    end loop;
		   
			   end loop;
		   	v_sql := concat(' select ',v_primarydctable,'.',v_primarydctable,'id recordid,',array_to_string(v_fldnamesary,','),' from ',v_primarydctable,' ',
		   			 array_to_string(v_fldname_dcjoinsary,' '),' ',array_to_string(v_fldname_joinsary,' '),' where ',v_keyfld_cnd);--,' and ',pcond);


			dcno := rec.dcname;
			dcsql := v_sql;
			return next;
			v_fldnamesary:= v_emptyary;
		   				v_fldname_joinsary:= v_emptyary;	   				
		   				v_fldname_dcjoinsary:= v_emptyary;	

end loop; 

 
return;
	
END; 
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
            v_altersql := 'ALTER TABLE ' || r.tablename || ' ADD axg_' || pgrpname || ' varchar(4000)';
            EXECUTE v_altersql;
        EXCEPTION WHEN OTHERS THEN
            null;
        END;
    END LOOP;
 
    RETURN 'T';
END;
$function$;
>>

<<
DROP FUNCTION fn_permissions_getpermission(varchar, varchar, varchar, varchar);
>>

<<
DROP FUNCTION fn_permissions_getcnd(varchar, varchar, varchar, varchar, varchar, varchar);
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
v_final_conditions varchar[] DEFAULT  ARRAY[]::varchar[];
rec_glovars record;
rec_glovars_varname varchar;
rec_glovars_varvalue varchar;
rec_dbconditions record;
v_dimensionsexists numeric;
begin

select  case when length(cnd1)>2 then 1 else 0 end into v_dimensionsexists from axusergrouping a 
	join axusers b on a.axusersid = b.axusersid 
	join axgrouptstructs a2 on a2.ftransid=ptransid
	where b.username  = fn_permissions_getpermission.pusername;

if v_dimensionsexists = 1 then

for rec_glovars in(select unnest(string_to_array(pglobalvars,'~~')) glovars )
loop
rec_glovars_varname := split_part(rec_glovars.glovars,'=',1);
rec_glovars_varvalue := split_part(rec_glovars.glovars,'=',2);



	for rec_dbconditions in(select unnest(string_to_array(cnd1 ,'and')) cnd1 from axusergrouping a 
	join axusers b on a.axusersid = b.axusersid 
	join axgrouptstructs a2 on a2.ftransid=ptransid
	where b.username  = fn_permissions_getpermission.pusername) 
		loop
		    IF rec_dbconditions.cnd1 LIKE '%'||rec_glovars_varname||'%' THEN
			v_final_conditions := array_append(v_final_conditions,concat('{primarytable.}',rec_glovars.glovars));
			else
			v_final_conditions := array_append(v_final_conditions,rec_dbconditions.cnd1);
			end if;
		end loop;
end loop;

else 

for rec_glovars in(select unnest(string_to_array(pglobalvars,'~~')) glovars )
loop
rec_glovars_varname := split_part(rec_glovars.glovars,'=',1);
rec_glovars_varvalue := split_part(rec_glovars.glovars,'=',2);

v_final_conditions := array_append(v_final_conditions,concat('{primarytable.}',rec_glovars.glovars));

end loop;

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
filtercnd := array_to_string(v_final_conditions,' and ');
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
		--filtercnd := rec.cnd;
filtercnd := array_to_string(v_final_conditions,' and ');
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
begin

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

select  case when length(cnd1)>2 then 1 else 0 end into v_dimensionsexists from axusergrouping a 
	join axusers b on a.axusersid = b.axusersid 
	join axgrouptstructs a2 on a2.ftransid=ptransid
	where b.username  = fn_permissions_getcnd.pusername;


if v_dimensionsexists = 1 then

for rec_glovars in(select unnest(string_to_array(pglobalvars,'~~')) glovars )
loop
rec_glovars_varname := split_part(rec_glovars.glovars,'=',1);
rec_glovars_varvalue := split_part(rec_glovars.glovars,'=',2);

	for rec_dbconditions in(select unnest(string_to_array(cnd1 ,'and')) cnd1 from axusergrouping a 
	join axusers b on a.axusersid = b.axusersid 
	join axgrouptstructs a2 on a2.ftransid=ptransid
	where b.username  = fn_permissions_getcnd.pusername) 
		loop
		    IF rec_dbconditions.cnd1 LIKE '%'||rec_glovars_varname||'%' THEN
			v_final_conditions := array_append(v_final_conditions,concat('{primarytable.}',rec_glovars.glovars));
			else
			v_final_conditions := array_append(v_final_conditions,rec_dbconditions.cnd1);
			end if;
		end loop;
end loop;

else 

for rec_glovars in(select unnest(string_to_array(pglobalvars,'~~')) glovars )
loop
rec_glovars_varname := split_part(rec_glovars.glovars,'=',1);
rec_glovars_varvalue := split_part(rec_glovars.glovars,'=',2);

v_final_conditions := array_append(v_final_conditions,concat('{primarytable.}',rec_glovars.glovars));

end loop;

end if;

if v_menuaccess > 0 and v_permissionexists = 0 then  

v_fullcontrolsql := concat('select ',v_transid_primetable,'id',' from ',v_transid_primetable,' ',v_keyfld_joins,' where ',replace(v_keyfld_cnd,' and ',''));
execute v_fullcontrolsql into v_fullcontrolrecid;
fullcontrol:= 'T';
recordid := v_fullcontrolrecid;
select string_agg(fname,',') into encryptedflds  from axpflds where tstruct=ptransid and encrypted='T';
filtercnd := array_to_string(v_final_conditions,' and ');
return next;

else

for rec in execute rolesql
loop

	sql_permission_cnd := concat('select count(*),',v_transid_primetable,'id',' from ',v_transid_primetable,' ',v_keyfld_joins,' where ',v_keyfld_cnd,case when length(rec.cnd) > 3 then ' and '||replace(rec.cnd,'{primarytable.}',v_transid_primetable||'.') end,' group by ',v_transid_primetable,'id');

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
		filtercnd := array_to_string(v_final_conditions,' and ');
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
 
return;
	
END; 
$function$
;
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



if v_menuaccess > 0 and v_permissionexists = 0 then  

v_fullcontrolsql := concat('select ',v_transid_primetable,'id',' from ',v_transid_primetable,' ',v_keyfld_joins,' where ',replace(v_keyfld_cnd,' and ',''));
execute v_fullcontrolsql into v_fullcontrolrecid;
fullcontrol:= 'T';
recordid := v_fullcontrolrecid;
select string_agg(fname,',') into encryptedflds  from axpflds where tstruct=ptransid and encrypted='T';
filtercnd := case when v_applypermissions > 0 then array_to_string(v_final_conditions,' and ') else null end;
return next;

else

for rec in execute rolesql
loop

	sql_permission_cnd := concat('select count(*),',v_transid_primetable,'id',' from ',v_transid_primetable,' ',v_keyfld_joins,' where ',v_keyfld_cnd,case when length(rec.cnd) > 3 then ' and '||replace(rec.cnd,'{primarytable.}',v_transid_primetable||'.') end,' group by ',v_transid_primetable,'id');

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
		filtercnd := array_to_string(v_final_conditions,' and ');
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
 
return;
	
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
		--filtercnd := rec.cnd;
filtercnd := array_to_string(v_final_conditions,' and ');
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