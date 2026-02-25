<<
update axusers set staysignedin='F',signinexpiry=14
>>

<<
ALTER TABLE AXUSERACCESS MODIFY RNAME VARCHAR2(50)
>>

<<
CREATE TABLE axgrouptstructs (
	formcap varchar2(500) NULL,
	ftransid varchar2(10) NULL
);
>>

<<
CREATE OR REPLACE TYPE SYS_ODCINCLOBLIST AS TABLE OF NCLOB;
>>

<<
CREATE OR REPLACE TYPE aximeta_obj AS OBJECT
(
    structtype VARCHAR2(50),
    caption    VARCHAR2(4000),
    transid    VARCHAR2(200)
);
>>

<<
CREATE OR REPLACE TYPE aximeta_tab AS TABLE OF aximeta_obj;
>>

<<
CREATE OR REPLACE TYPE axi_struct_meta_obj AS OBJECT
(
    objtype    VARCHAR2(50),
    objcaption VARCHAR2(4000),
    objname    VARCHAR2(200),
    dcname     VARCHAR2(200),
    asgrid     VARCHAR2(50)
);
>>

<<
CREATE OR REPLACE TYPE axi_struct_meta_tab AS TABLE OF axi_struct_meta_obj;
>>

<<
CREATE OR REPLACE FUNCTION fn_axi_metadata
(
    pstructtype VARCHAR2,
    pusername   VARCHAR2
)
RETURN aximeta_tab PIPELINED
AS
    v_sql   CLOB;
    rc      SYS_REFCURSOR;

    v_structtype VARCHAR2(50);
    v_caption    VARCHAR2(4000);
    v_transid    VARCHAR2(200);

BEGIN

    IF pstructtype = 'tstructs' THEN

        v_sql := '
        select ''tstruct'',caption || ''-('' || name || '')'',name
        from axusergroups a3 
        join axusergroupsdetail a4 on a3.axusergroupsid = a4.axusergroupsid
        join axuseraccess a5 on a4.roles_id = a5.rname
        join tstructs t on a5.sname = t.name
        join axuserlevelgroups ag on a3.groupname = ag.usergroup
        where t.blobno =1 and ag.username = :1
        union all
        select ''tstruct'',caption || ''-('' || name || '')'',name
        from tstructs t
        join axuserlevelgroups ag on ag.usergroup =''default''
        where t.blobno =1 and ag.username = :2
        union all
        SELECT ''tstruct'',caption || ''-('' || name || '')'',name
        from tstructs t
        JOIN axuserlevelgroups u on u.USERNAME = :3
        join axusergroups a ON a.groupname = u.usergroup
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
        where b.ROLES_ID =''default'' and t.blobno =1 ';

    ELSIF pstructtype = 'iviews' THEN

        v_sql := '
        select ''iview'',caption || ''-('' || name || '')'',name
        from axusergroups a3
        join axusergroupsdetail a4 on a3.axusergroupsid = a4.axusergroupsid
        join axuseraccess a5 on a4.roles_id = a5.rname
        join iviews t on a5.sname = t.name
        join axuserlevelgroups ag on a3.groupname = ag.usergroup
        where t.blobno =1 and ag.username = :1
        union all
        select ''iview'',caption || ''-('' || name || '')'',name
        from iviews t
        join axuserlevelgroups ag on ag.usergroup =''default''
        where t.blobno =1 and ag.username = :2
        union all
        SELECT ''iview'',caption || ''-('' || name || '')'',name
        from iviews t
        JOIN axuserlevelgroups u on u.USERNAME = :3
        join axusergroups a ON a.groupname = u.usergroup
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
        where b.ROLES_ID =''default'' and t.blobno =1 ';

    ELSIF pstructtype = 'pages' THEN

        v_sql := 
        'select ''page'',caption || ''-('' || name || '')'',name
        from axusergroups a3
        join axusergroupsdetail a4 on a3.axusergroupsid = a4.axusergroupsid
        join axuseraccess a5 on a4.roles_id = a5.rname
        join axpages p on a5.sname = p.name and p.pagetype =''web''
        join axuserlevelgroups ag on a3.groupname = ag.usergroup
        where ag.username = :1
        union all
        select ''page'',caption || ''-('' || name || '')'',name
        from axpages t
        join axuserlevelgroups ag on ag.usergroup =''default''
        where t.pagetype =''web'' and ag.username = :2
        union all
        SELECT ''page'',caption || ''-('' || name || '')'',name
        from axpages t
        JOIN axuserlevelgroups u on u.USERNAME = :3
        join axusergroups a ON a.groupname = u.usergroup
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
        where b.ROLES_ID =''default'' and t.pagetype =''web''';

    ELSIF pstructtype = 'ads' THEN

        v_sql := 'select ''ADS'', sqlname, sqlname from axdirectsql';

    ELSE

        v_sql := '
select ''tstruct'',caption || ''-('' || name || '')'',name
        from axusergroups a3 
        join axusergroupsdetail a4 on a3.axusergroupsid = a4.axusergroupsid
        join axuseraccess a5 on a4.roles_id = a5.rname
        join tstructs t on a5.sname = t.name
        join axuserlevelgroups ag on a3.groupname = ag.usergroup
        where t.blobno =1 and ag.username = :1
        union all
        select ''tstruct'',caption || ''-('' || name || '')'',name
        from tstructs t
        join axuserlevelgroups ag on ag.usergroup =''default''
        where t.blobno =1 and ag.username = :2
        union all
        SELECT ''tstruct'',caption || ''-('' || name || '')'',name
        from tstructs t
        JOIN axuserlevelgroups u on u.USERNAME = :3
        join axusergroups a ON a.groupname = u.usergroup
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
        where b.ROLES_ID =''default'' and t.blobno =1 
union all
 select ''iview'',caption || ''-('' || name || '')'',name
        from axusergroups a3
        join axusergroupsdetail a4 on a3.axusergroupsid = a4.axusergroupsid
        join axuseraccess a5 on a4.roles_id = a5.rname
        join iviews t on a5.sname = t.name
        join axuserlevelgroups ag on a3.groupname = ag.usergroup
        where t.blobno =1 and ag.username = :4
        union all
        select ''iview'',caption || ''-('' || name || '')'',name
        from iviews t
        join axuserlevelgroups ag on ag.usergroup =''default''
        where t.blobno =1 and ag.username = :5
        union all
        SELECT ''iview'',caption || ''-('' || name || '')'',name
        from iviews t
        JOIN axuserlevelgroups u on u.USERNAME = :6
        join axusergroups a ON a.groupname = u.usergroup
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
        where b.ROLES_ID =''default'' and t.blobno =1 
union all
select ''page'',caption || ''-('' || name || '')'',name
        from axusergroups a3
        join axusergroupsdetail a4 on a3.axusergroupsid = a4.axusergroupsid
        join axuseraccess a5 on a4.roles_id = a5.rname
        join axpages p on a5.sname = p.name and p.pagetype =''web''
        join axuserlevelgroups ag on a3.groupname = ag.usergroup
        where ag.username = :7
        union all
        select ''page'',caption || ''-('' || name || '')'',name
        from axpages t
        join axuserlevelgroups ag on ag.usergroup =''default''
        where t.pagetype =''web'' and ag.username = :8
        union all
        SELECT ''page'',caption || ''-('' || name || '')'',name
        from axpages t
        JOIN axuserlevelgroups u on u.USERNAME = :9
        join axusergroups a ON a.groupname = u.usergroup
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
        where b.ROLES_ID =''default'' and t.pagetype =''web''
union all
select ''ADS'', sqlname, sqlname from axdirectsql';

    END IF;


    IF pstructtype = 'ads' OR pstructtype IS NULL THEN
        OPEN rc FOR v_sql;
    ELSIF pstructtype IN('tstructs','iviews','pages') then
        OPEN rc FOR v_sql USING pusername,pusername,pusername;
    ELSE
    	OPEN rc FOR v_sql USING pusername,pusername,pusername,pusername,pusername,pusername,pusername,pusername,pusername;
    END IF;
 
    LOOP
        FETCH rc INTO v_structtype, v_caption, v_transid;
        EXIT WHEN rc%NOTFOUND;

        PIPE ROW (aximeta_obj(v_structtype, v_caption, v_transid));
    END LOOP;

    CLOSE rc;

    RETURN;
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_axi_struct_metadata
(
    pstructtype VARCHAR2,
    ptransid    VARCHAR2,
    pobjtype    VARCHAR2
)
RETURN axi_struct_meta_tab PIPELINED
AS
    v_sql   CLOB;
    rc      SYS_REFCURSOR;

    v_objtype    VARCHAR2(50);
    v_objcaption VARCHAR2(4000);
    v_objname    VARCHAR2(200);
    v_dcname     VARCHAR2(200);
    v_asgrid     VARCHAR2(50);

BEGIN

    IF pstructtype = 'tstruct' THEN

        IF pobjtype = 'fields' THEN
            v_sql := 'select ''Field'', caption||''(''||fname||'')'', fname, dcname, asgrid
                        from axpflds where tstruct = :1';

        ELSIF pobjtype = 'genmaps' THEN
            v_sql := 'select ''Genmap'', caption||''(''||gname||'')'', gname, null, null
                        from axpgenmaps where tstruct = :1';

        ELSIF pobjtype = 'mdmaps' THEN
            v_sql := 'select ''MDmap'', caption||''(''||mname||'')'', mname, null, null
                        from axpmdmaps where tstruct = :1';
        END IF;

    ELSIF pstructtype = 'iview' THEN

        IF pobjtype = 'columns' THEN
            v_sql := 'select ''Column'', f_caption||''(''||f_name||'')'', f_name, null, null
                        from iviewcols where iname = :1';

        ELSIF pobjtype = 'params' THEN
            v_sql := 'select ''Param'', pcaption||''(''||pname||'')'', pname, null, null
                        from iviewparams where iname = :1';
        END IF;

    END IF;

    OPEN rc FOR v_sql USING ptransid;

    LOOP
        FETCH rc INTO v_objtype, v_objcaption, v_objname, v_dcname, v_asgrid;
        EXIT WHEN rc%NOTFOUND;

        PIPE ROW (axi_struct_meta_obj(v_objtype, v_objcaption, v_objname, v_dcname, v_asgrid));
    END LOOP;

    CLOSE rc;
    RETURN;
   
   EXCEPTION WHEN OTHERS THEN null;

END;
>>

<<
CREATE OR REPLACE PROCEDURE pr_permissions_create_grpcol (
    ptransid IN VARCHAR2,
    ptable   IN VARCHAR2
)
IS
    v_altersql VARCHAR2(4000);
BEGIN
    FOR r_grp IN (SELECT grpname FROM axgroupingmst) LOOP
        v_altersql :=
            'ALTER TABLE ' || ptable ||
            ' ADD axg_' || r_grp.grpname || ' VARCHAR2(4000)';
 
        EXECUTE IMMEDIATE v_altersql;
    END LOOP;
 
 
END;
>>
 
<<

CREATE OR REPLACE PROCEDURE pr_permissions_grpmaster(
    p_grpname IN VARCHAR2    
)
AUTHID CURRENT_USER
IS
  v_altersql VARCHAR2(4000);
BEGIN  
  FOR r_loop IN (
      SELECT a.ftransid, d.tablename
      FROM axgrouptstructs a
      JOIN axpdc d ON a.ftransid = d.tstruct AND d.dcno = 1
  )
  LOOP
      BEGIN 
          v_altersql := 'ALTER TABLE ' || r_loop.tablename || ' ADD axg_' || p_grpname || ' VARCHAR2(4000)';
          
          EXECUTE IMMEDIATE v_altersql;
          
      EXCEPTION 
          WHEN OTHERS THEN
              DBMS_OUTPUT.PUT_LINE('Error processing table ' || r_loop.tablename || ': ' || SQLERRM);
      END; 
  END LOOP;

EXCEPTION 
    WHEN OTHERS THEN NULL;
END;
>>

<<
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND, SQLQUERYCOLS, ENCRYPTEDFLDS, CACHEDATA, CACHEINTERVAL, SMARTLISTCND, ADSDESC) VALUES(1296550000000, 'F', 0, NULL, 'admin', TIMESTAMP '2026-02-17 19:28:09.000000', 'admin', TIMESTAMP '2026-02-17 19:28:09.000000', NULL, 1, 1, NULL, NULL, NULL, 'ds_smartlist_ads_metadata', NULL, 'select a.sqlname,b.fldname,b.fldcaption,b.fdatatype, b.normalized ,b.sourcetable ,b.sourcefld ,hyp_structtype,b.hyp_transid, b.tbl_hyperlink,
case when smartlistcnd like ''%Dynamic select columns%'' then ''T'' else ''F'' end dynamiccolumns,
case when smartlistcnd like ''%Filter%'' then coalesce(b.filter,''No'') else ''F'' end filters,
case when smartlistcnd like ''%Pagination%'' then ''T'' else ''F'' end pagination,
case when smartlistcnd like ''%Sorting%'' then ''T'' else ''F'' end sorting
from axdirectsql a left join axdirectsql_metadata b on a.axdirectsqlid =b.axdirectsqlid 
where sqlname = :adsname
order by b.axdirectsql_metadatarow ', 'adsname', 'adsname~Character~', 'ALL', NULL, 'Metadata', 0, NULL, NULL, 'F', '6 Hr', NULL, NULL)
>>

<<
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND, SQLQUERYCOLS, ENCRYPTEDFLDS, CACHEDATA, CACHEINTERVAL, SMARTLISTCND, ADSDESC) VALUES(1296220000000, 'F', 0, NULL, 'admin', TIMESTAMP '2026-02-17 19:24:44.000000', 'admin', TIMESTAMP '2026-02-17 19:22:04.000000', NULL, 1, 1, NULL, NULL, NULL, 'ds_smartlist_filters', NULL, 'SELECT * from TABLE(fn_axpanalytics_filterdata( :ptransid, :psrctxt))', 'ptransid,psrctxt', 'ptransid~Character~,psrctxt~Character~', 'ALL', NULL, 'Metadata', 0, 'column_value', NULL, 'F', '6 Hr', NULL, NULL)
>>

<<
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND, SQLQUERYCOLS, ENCRYPTEDFLDS, CACHEDATA, CACHEINTERVAL, SMARTLISTCND, ADSDESC) VALUES(1296110000000, 'F', 0, NULL, 'admin', TIMESTAMP '2026-02-17 19:19:17.000000', 'admin', TIMESTAMP '2026-02-17 19:19:17.000000', NULL, 1, 1, NULL, NULL, NULL, 'ds_getsmartlists', NULL, 'select sqlname from axdirectsql a where sqlsrc=''Application''', NULL, NULL, 'ALL', NULL, 'Metadata', 0, 'sqlname', NULL, 'F', '6 Hr', NULL, NULL)
>>

<<
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND, SQLQUERYCOLS, ENCRYPTEDFLDS, CACHEDATA, CACHEINTERVAL, SMARTLISTCND, ADSDESC) VALUES(1295990000000, 'F', 0, NULL, 'admin', TIMESTAMP '2026-02-17 19:18:52.000000', 'admin', TIMESTAMP '2026-02-17 19:17:32.000000', NULL, 1, 1, NULL, NULL, NULL, 'Axi_metadata_struct_obj', NULL, 'SELECT * from TABLE(fn_axi_struct_metadata( :pstructtype, :ptransid , :pobjtype ))', 'pstructtype,ptransid,pobjtype', 'pstructtype~Character~,ptransid~Character~,pobjtype~Character~', 'ALL', NULL, 'Metadata', 0, 'objtype,objcaption,objname,dcname,asgrid', NULL, 'F', '6 Hr', NULL, NULL)
>>

<<
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND, SQLQUERYCOLS, ENCRYPTEDFLDS, CACHEDATA, CACHEINTERVAL, SMARTLISTCND, ADSDESC) VALUES(1295660000000, 'F', 0, NULL, 'admin', TIMESTAMP '2026-02-17 19:03:21.000000', 'admin', TIMESTAMP '2026-02-17 19:03:21.000000', NULL, 1, 1, NULL, NULL, NULL, 'Axi_getmetadata', NULL, 'SELECT * FROM TABLE(fn_axi_metadata( :pstructtype , :pusername ))', 'pstructtype,pusername', 'pstructtype~Character~,pusername~Character~', 'ALL', NULL, 'Metadata', 0, 'structtype,caption,transid', NULL, 'F', '6 Hr', NULL, NULL)
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
'axcalendarsource')
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
'axcalendarsource')
>>

<<
CREATE OR REPLACE  VIEW "VW_USERNAME_ROLE_MENU_ACCESS" ("USERNAME", "GROUPNAME", "RNAME", "SNAME", "STYPE", "CAPTION") AS 
  SELECT a2.username,
       a3.groupname,
       a5.rname,
       a5.sname,
       a5.stype,
       CASE a5.stype
         WHEN 't' THEN t.caption
         WHEN 'i' THEN i.caption
         WHEN 'p' THEN p.caption
         ELSE NULL
       END AS caption
  FROM axusergroups a3
  JOIN axusergroupsdetail a4
    ON a3.axusergroupsid = a4.axusergroupsid
  JOIN axuseraccess a5
    ON a4.roles_id = a5.rname
  LEFT JOIN axuserlevelgroups a2
    ON a2.usergroup = a3.groupname
   AND a2.usergroup <> 'default'
  LEFT JOIN tstructs t
    ON a5.sname = t.name
  LEFT JOIN iviews i
    ON a5.sname = i.name
  LEFT JOIN axpages p
    ON a5.sname = p.name
UNION ALL
SELECT DISTINCT a2.username,
       'default' AS groupname,
       'default' AS rname,
       t.name    AS sname,
       't'       AS stype,
       t.caption
  FROM tstructs t
  LEFT JOIN axuserlevelgroups a2
    ON a2.usergroup = 'default'
UNION ALL
SELECT DISTINCT a2.username,
       'default' AS groupname,
       'default' AS rname,
       i.name    AS sname,
       'i'       AS stype,
       i.caption
  FROM iviews i
  LEFT JOIN axuserlevelgroups a2
    ON a2.usergroup = 'default'
UNION ALL
SELECT DISTINCT a2.username,
       'default' AS groupname,
       'default' AS rname,
       p.name    AS sname,
       'p'       AS stype,
       p.caption
  FROM axpages p
  LEFT JOIN axuserlevelgroups a2
    ON a2.usergroup = 'default'

 ;
>>


<<
CREATE OR REPLACE  VIEW "VW_ROLE_MENUACCESS" ("GROUPNAME", "CAPTION") AS 
  SELECT groupname,LISTAGG(caption,',') WITHIN GROUP(ORDER BY caption)||'...' caption
 from
 (SELECT DISTINCT groupname,caption,sum(LENGTH(caption)) over(PARTITION BY groupname ORDER BY caption ) ccnt   
 FROM vw_username_role_menu_access WHERE STYPE in('t','i')
GROUP BY groupname,caption
ORDER BY 1 desc,2)a
WHERE ccnt < 150
GROUP BY groupname
 ;
>>
 
<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_metadata(ptransid varchar2, psubentity varchar2 DEFAULT 'F',planguage varchar2 DEFAULT 'English')
 RETURN  axpdef_axpanalytics_mdata
IS
recdata_consoliate_array axpdef_axpanalytics_mdata := axpdef_axpanalytics_mdata();
recdata_dc1_array axpdef_axpanalytics_mdata := axpdef_axpanalytics_mdata();
recdata_subentity_array axpdef_axpanalytics_mdata := axpdef_axpanalytics_mdata();
temp_recdata_subentity_array axpdef_axpanalytics_mdata := axpdef_axpanalytics_mdata();
v_primarydctable varchar2(3000);
v_subentitytable varchar2(3000);
v_sql clob;
v_subentitysql clob;
BEGIN  


select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';

-- Construct and execute SQL query for primary data.
v_sql :=' select axpdef_axpanalytics_mdata_obj(transid, formcap, fname , fcap, cdatatype, dt,modeofentry , fhide,
	  props,srckey ,srctf ,srcfld ,srctrans ,allowempty,filtercnd,grpfld,aggfld,subentity, datacnd, entityrelfld,
	allowduplicate,tablename,dcname,fordno,dccaption,griddc,listingfld,encrypted,masking,lastcharmask,
	firstcharmask,maskchar,maskroles,customdecimal)
	 from (
select axpflds.tstruct transid,coalesce(lf.compcaption,t.caption) formcap, fname ,coalesce(l.compcaption,axpflds.caption) fcap,customdatatype cdatatype,datatype dt,modeofentry ,hidden fhide,
	null as props,srckey ,srctf ,srcfld ,srctrans ,axpflds.allowempty,
	case when modeofentry =''select'' then case when srckey =''T'' then ''Dropdown'' else ''Text'' end else ''Text'' end filtercnd,
	case when (modeofentry =''select'' or datatype=''c'') then ''T'' else ''F'' end grpfld,
	case when datatype =''n'' then ''T'' else ''F'' end aggfld,''F'' subentity,1 datacnd,null entityrelfld,allowduplicate,axpflds.tablename,
	dcname,ordno fordno,d.caption dccaption,d.asgrid griddc,case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,encrypted,masking,lastcharmask,firstcharmask,maskchar,maskroles,customdecimal
	from axpflds join tstructs t on axpflds.tstruct = t.name and t.blobno=1
	join axpdc d on axpflds.tstruct = d.tstruct and axpflds.dcname = d.dname
    left join axlanguage l on substr(l.sname,2)= t.name and lower(l.dispname)='''||lower(planguage)||''' and axpflds.fname = l.compname 		
	left join axlanguage lf on substr(lf.sname,2)= t.name and lower(lf.dispname)='''||lower(planguage)||''' and lf.compname=''x__headtext''
	where axpflds.tstruct=:1  and savevalue =''T''	
	union all
	select a.name,coalesce(lf.compcaption,t.caption) ,key,coalesce(l.compcaption,title),	''button'',null,null,''F'',	script|| ''~''|| icon,''F'',null,null,null,null,null,null,null,''F'' subentity,1,null,null
	,null,null,ordno,null,''F'',''F'',null encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
	from axtoolbar a join tstructs t on a.name = t.name and t.blobno=1
	left join axlanguage l on substr(l.sname,2)= t.name and lower(l.dispname)='''||lower(planguage)||''' and a.key = l.compname
	left join axlanguage lf on substr(lf.sname,2)= t.name and lower(lf.dispname)='''||lower(planguage)||''' and lf.compname=''x__headtext'' 
	where visible = ''true'' and script is not null and a.name= :2
	union all
	select distinct t.name transid,coalesce(lf.compcaption,t.caption) formcap, ''app_desc'' ,''Workflow status'' fcap,null cdatatype,''c'' dt,
	null modeofentry,''F'' fhide,null props,''F'' srckey ,null srctf ,null srcfld ,null srctrans ,''T'' allowempty,''Text'' filtercnd,
	''F'' grpfld,''F'' aggfld,''F'' subentity,1 datacnd,null entityrelfld,''T'' allowduplicate,d.tablename,
	d.dname,1000 fordno,d.caption dccaption,d.asgrid griddc,case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,
	''F'' encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
	from axattachworkflow a join tstructs t on a.transid = t.name  and t.blobno=1		
	join axpdc d on a.transid = d.tstruct and d.dname =''dc1''		
	left join axlanguage lf on substr(lf.sname,2)= t.name and lower(lf.dispname)='''||lower(planguage)||''' and lf.compname=''x__headtext''
	where t.name=:3  	
    ) x'; 

   execute immediate v_sql bulk collect into recdata_dc1_array using ptransid,ptransid,ptransid;


  if psubentity ='T' then		


    FOR rec IN (
        select distinct a.dstruct ,a.rtype,dprimarytable
		from axentityrelations a 
		join axpdc dc on a.dstruct = dc.tstruct 
		where  mstruct = ptransid )
   	loop	



	   	v_subentitysql :=  'select  axpdef_axpanalytics_mdata_obj( transid,formcap, fname ,fcap,cdatatype,dt,modeofentry ,fhide,
		 props,srckey ,srctf ,srcfld ,srctrans ,allowempty, filtercnd,grpfld,aggfld,subentity,datacnd,entityrelfld,allowduplicate,
		tablename,dcname,fordno,dccaption,griddc,listingfld,encrypted,masking,lastcharmask,firstcharmask,maskchar,maskroles,customdecimal)
		 from (
        select axpflds.tstruct transid,coalesce(lf.compcaption,t.caption) formcap, fname ,coalesce(l.compcaption,axpflds.caption) fcap,customdatatype cdatatype,datatype dt,modeofentry,
		hidden fhide,null props,srckey ,srctf ,srcfld ,srctrans ,axpflds.allowempty,
		case when modeofentry =''select'' then case when srckey =''T'' then ''Dropdown'' else ''Text'' end else ''Text'' end filtercnd,
		case when modeofentry =''select'' then ''T'' else ''F'' end grpfld,
		case when datatype =''n'' then ''T'' else ''F'' end aggfld,''T'' subentity,2 datacnd,
		r.mfield entityrelfld,
		allowduplicate,axpflds.tablename,axpflds.dcname,axpflds.ordno fordno,d.caption dccaption,d.asgrid griddc,
		case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,encrypted,masking,lastcharmask,firstcharmask,maskchar,maskroles,customdecimal
		from axpflds join tstructs t on axpflds.tstruct = t.name  and t.blobno=1 join axpdc d on axpflds.tstruct = d.tstruct and axpflds.dcname = d.dname
		left join axentityrelations r on axpflds.tstruct = r.dstruct and axpflds.fname = r.dfield and r.mstruct=:1 
		left join axlanguage l on substr(l.sname,2)= t.name and lower(l.dispname)='''||lower(planguage)||''' and axpflds.fname = l.compname 
		left join axlanguage lf on substr(lf.sname,2)= t.name and lower(lf.dispname)='''||lower(planguage)||''' and lf.compname=''x__headtext''		
		where axpflds.tstruct=:2 and savevalue =''T'' 
		 union all select '''||rec.dstruct||''',null,''sourceid'',''sourceid'',''Simple Text'',''c'',''accept'',''T'',
		null,''F'',null,null,null,''T'',''F'',''F'',''F'',''T'',2,''recordid'',''T'','''||rec.dprimarytable||''',null,1000,null,''F'',''F'',
		null encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
		 from dual where ''gm''='''||rec.rtype||'''
		UNION ALL
		select distinct t.name transid,coalesce(lf.compcaption,t.caption) formcap, ''app_desc'',''Workflow status'' fcap,null cdatatype,''c'' dt,null modeofentry,
		''F'' fhide,null props,''F'' srckey ,null srctf ,null srcfld ,null srctrans ,''T'' allowempty,
		''Text'' filtercnd,''F'' grpfld,''F'' aggfld,''T'' subentity,2 datacnd,
		null entityrelfld,''T'' allowduplicate,d.tablename,d.dname,1000 fordno,d.caption dccaption,d.asgrid griddc,
		case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,''F'' encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
		from axattachworkflow a join tstructs t on a.transid = t.name 	 and t.blobno=1	
		join axpdc d on a.transid = d.tstruct and d.dname =''dc1''			 
		left join axlanguage lf on substr(lf.sname,2)= t.name and lower(lf.dispname)='''||lower(planguage)||''' and lf.compname=''x__headtext''		
		where t.name=:3 ) x' ;

       execute immediate v_subentitysql bulk collect into temp_recdata_subentity_array using  ptransid,rec.dstruct,rec.dstruct;

        recdata_subentity_array := recdata_subentity_array multiset union all temp_recdata_subentity_array; 

   end loop;    

   end if;

   recdata_consoliate_array := recdata_dc1_array multiset union all recdata_subentity_array;

    RETURN recdata_consoliate_array;



END;
>>


<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_listdata(ptransid varchar2, pflds clob DEFAULT 'All', ppagesize numeric DEFAULT 25, ppageno numeric DEFAULT 1, pfilter clob DEFAULT 'NA', pusername varchar2 DEFAULT 'admin', papplydac varchar2 DEFAULT 'T', puserrole varchar2 DEFAULT 'All',pconstraints clob DEFAULT NULL)
RETURN SYS_ODCINCLOBLIST

 
IS 
 
v_sql clob;
v_sql1 clob;
v_primarydctable  varchar2(3000);
v_fldnamesary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_join  varchar2(4000);
v_fldname_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_col  varchar2(3000);
v_fldname_normalized  varchar2(3000);
v_fldname_srctbl  varchar2(3000); 
v_fldname_srcfld  varchar2(3000);
v_fldname_allowempty  varchar2(3000);  
v_fldname_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_dctablename varchar2(3000);
v_fldname_dcflds clob;
v_fldname_transidcnd number;
v_fldname_dctables SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_normalizedtables SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_allflds  clob;
v_filter_srcfld varchar2(4000);
v_filter_srctxt  clob;
v_filter_join  varchar2(3000);
v_filter_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_dcjoin varchar2(3000);
v_filter_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_cnd  clob;
v_filter_cndary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_col varchar2(3000);
v_filter_normalized varchar2(3000);
v_filter_sourcetbl varchar2(3000);
v_filter_sourcefld varchar2(3000);
v_filter_datatype varchar2(3000);
v_filter_listedfld varchar2(3000);
v_filter_tablename varchar2(3000);
v_filter_joinreq number;
t_temp_field_list clob;
v_filter_dcjoinuniq clob;
v_final_sqls SYS_ODCINCLOBLIST := SYS_ODCINCLOBLIST();
v_pegenabled NUMERIC;
v_dac_cnd clob;
 begin
 
 
	select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';	

	select count(1) into v_fldname_transidcnd from axpflds where tstruct = ptransid and dcname ='dc1' and lower(fname)='transid';


	SELECT count(1) INTO v_pegenabled FROM AXPROCESSDEFV2 WHERE TRANSID = ptransid;


		if pflds = 'All' then 

            select tablename||'='||listagg(str,'|')WITHIN GROUP(order by  dcname ,ordno)   into  v_allflds From(	
			select tablename,fname||'~'||srckey||'~'||srctf||'~'||srcfld||'~'||allowempty str,
             dcname ,ordno			
			 from axpflds where tstruct=ptransid and 
			dcname ='dc1' and asgrid ='F' and hidden ='F' 
			and savevalue='T' and tablename = v_primarydctable and datatype not in('i','t') AND lower(fname)!='transid'
			union all
			SELECT DISTINCT  d.tablename,'app_desc~F~~~T' str,d.dname,1 from axpdc d JOIN AXATTACHWORKFLOW a ON d.tstruct =a.transid 
			where d.tstruct=ptransid and d.dname='dc1'
			order by dcname ,ordno)a GROUP BY tablename;

		end if;

t_temp_field_list := case when pflds='All' then v_allflds else pflds end;

FOR rec2 IN (select column_value as dcdtls from table(string_to_array(t_temp_field_list,'^')) )
LOOP
	v_fldname_dctablename := split_part(rec2.dcdtls,'=',1);
	v_fldname_dcflds := split_part(rec2.dcdtls,'=',2);
	
	if v_fldname_dctablename!=v_primarydctable THEN
		v_fldname_dcjoinsary.Extend;
		v_fldname_dcjoinsary(v_fldname_dcjoinsary.COUNT):= ('left join '||v_fldname_dctablename||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_fldname_dctablename||'.'||v_primarydctable||'id');				    									
	end if;
		v_fldname_dctables.Extend;
		v_fldname_dctables(v_fldname_dctables.COUNT):= v_fldname_dctablename;
					
 	FOR rec1 in  (select column_value as fldname from table(string_to_array(v_fldname_dcflds,'|')))
loop		    	
					v_fldname_col := split_part(rec1.fldname,'~',1);
					v_fldname_normalized := split_part(rec1.fldname,'~',2);
					v_fldname_srctbl := split_part(rec1.fldname,'~',3);
					v_fldname_srcfld := split_part(rec1.fldname,'~',4);					
					v_fldname_allowempty := split_part(rec1.fldname,'~',5);
					
					if v_fldname_normalized ='F' and lower(v_fldname_col)!='app_desc' then 
                         v_fldnamesary.EXTEND;
                         v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_dctablename||'.'||v_fldname_col);
					elsif v_fldname_normalized ='F' and lower(v_fldname_col)='app_desc' then						
						v_fldnamesary.EXTEND;						
						v_fldnamesary(v_fldnamesary.COUNT) := 'case when length('||v_fldname_dctablename||'.wkid)>2 then case '||v_fldname_dctablename||'.app_desc when 0 then  ''Created''
					  when  1 then ''Approved''
					  when  2 then ''Review''
					  when  3 then ''Return''
					  when  4 then ''Approve''
					  when  5 then ''Rejected''
					  when  9 then ''Orphan'' end else null end app_desc';
					elsif v_fldname_normalized ='T' then
                         v_fldnamesary.EXTEND;
						 v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_col||'.'||v_fldname_srcfld||' '||v_fldname_col);
                         v_fldname_joinsary.EXTEND;
						 v_fldname_joinsary(v_fldname_joinsary.count) := (CASE WHEN v_fldname_allowempty='F' THEN ' join ' ELSE ' left join ' end||v_fldname_srctbl||' '||v_fldname_col||' on '||v_fldname_dctablename||'.'||v_fldname_col||' = '||v_fldname_col||'.'||v_fldname_srctbl||'id');
					end if;
			    end loop;
END LOOP;

		   	v_sql := (' select '||''''||ptransid||''' transid,'||v_primarydctable||'.'||v_primarydctable||'id recordid,'||v_primarydctable||'.username modifiedby,'
		   			||v_primarydctable||'.modifiedon,'||v_primarydctable||'.createdon,'||v_primarydctable||'.createdby,'||
		   			 v_primarydctable||'.cancel,'||v_primarydctable||'.cancelremarks,'||array_to_string(v_fldnamesary,',')||
		   			',null axpeg_processname,null axpeg_keyvalue,null axpeg_status,null axpeg_statustext from ' 
		   			||v_primarydctable||' '||array_to_string(v_fldname_dcjoinsary,' ')||' '||array_to_string(v_fldname_joinsary,' '));
					

		   		
		   				   			
---------DAC filters
			   if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_primarydctable||'.');											   					   			   										
			   end if;	

		if pfilter ='NA' then  

				IF ppagesize > 0 then
		       		 	v_sql1 :='select * from(                        
		                        select a.*,row_number() over(order by modifiedon desc) rno,'||ppageno||' as  pageno  
		                           from ( '||v_sql||' where 1=1 '||
		                           CASE WHEN v_fldname_transidcnd>0 THEN ' and '||v_primarydctable||'.transid='''||ptransid||''''end||
		                           case when papplydac ='T' AND LENGTH(v_dac_cnd)  > 2 THEN (' and ('||v_dac_cnd||')') end||                           
		                           '--axp_filter  
									)a  order by modifiedon desc             
		                                ) b  where rno between '||(ppagesize*(ppageno-1)+1)||' and '||(ppagesize*ppageno);
		       ELSE 
		        		v_sql1 :='select * from(                        
		                        select a.*,0 rno,1 as  pageno  
		                           from ( '||v_sql||' where 1=1 '||
		                           CASE WHEN v_fldname_transidcnd>0 THEN ' and '||v_primarydctable||'.transid='''||ptransid||''''end||
		                           case when papplydac ='T' AND LENGTH(v_dac_cnd)  > 2 THEN (' and ('||v_dac_cnd||')') end||                           
		                           '--axp_filter  
									)a  order by modifiedon desc) b';
				END IF;
		       
		else
			FOR rec IN
    			(select column_value as ifilter from table(string_to_array(pfilter,'^')) )
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
					
			    if  v_filter_listedfld='F' then 
								    	
			    	select count(1) into v_filter_joinreq FROM (select distinct column_value from   table(v_fldname_dctables))a where lower(a.column_value)=lower(v_filter_tablename);
			    	
			    	if v_filter_joinreq = 0  then  
				    	v_filter_dcjoin := ' join '||v_filter_tablename||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_filter_tablename||'.'||v_primarydctable||'id';
				    	v_filter_dcjoinsary.EXTEND;
	                   	v_filter_dcjoinsary(v_filter_dcjoinsary.COUNT) := v_filter_dcjoin;
			    	end if;
			    				    		  	
                   	if v_filter_normalized='T' then  	
 		           		v_filter_join := (' join '||v_filter_sourcetbl||' '||v_filter_col||' on '||v_filter_tablename||'.'||v_filter_col||' = '||v_filter_col||'.'||v_filter_sourcetbl||'id');
        	    	   	v_filter_joinsary.EXTEND;
            	       	v_filter_joinsary(v_filter_joinsary.COUNT) := v_filter_join;
                  	end if;
                    
				END IF;
				    if v_filter_normalized='F' then                    
                   		v_filter_cnd := case when v_filter_datatype='c' then 'lower(' END ||(v_filter_tablename||'.'||v_filter_col||case when v_filter_datatype='c' then ')' end||' '||v_filter_srctxt) ;
                    else 
                    	v_filter_cnd := case when v_filter_datatype='c' then 'lower(' END||(v_filter_col||'.'||v_filter_sourcefld||case when v_filter_datatype='c' then ')' end||' '||v_filter_srctxt) ;
                    end if; 

                    v_filter_cndary.EXTEND;
                    v_filter_cndary(v_filter_cndary.COUNT) := v_filter_cnd;

			    end loop;
					SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_filter_dcjoinuniq from(select distinct column_value from   table(v_filter_dcjoinsary));
			   		
				IF ppagesize > 0 then
                	 v_sql1 := 'select * from(                        
                        select a.*,row_number() over(order by modifiedon desc) rno,'||ppageno||' as  pageno  
                           from ( '||v_sql||' '||v_filter_dcjoinuniq||' '||array_to_string(v_filter_joinsary,' ')||' where 1=1 '							
							||CASE WHEN v_fldname_transidcnd>0 THEN ' and '||v_primarydctable||'.transid='''||ptransid||''' and ' ELSE ' and ' end
                           ||array_to_string(v_filter_cndary,' and ')
                           ||CASE WHEN papplydac ='T' and length(v_dac_cnd) > 2 THEN (' and ('||v_dac_cnd||')') END ||' 
							--axp_filter
							)a  order by modifiedon desc             
                                ) b  where rno between '||(ppagesize*(ppageno-1)+1)||' and '||(ppagesize*ppageno) ;
				ELSE
					 v_sql1 := 'select * from(select a.*,0 rno,1 as  pageno  
                           from ( '||v_sql||' '||v_filter_dcjoinuniq||' '||array_to_string(v_filter_joinsary,' ')||' where 1=1 '							
							||CASE WHEN v_fldname_transidcnd>0 THEN ' and '||v_primarydctable||'.transid='''||ptransid||''' and ' ELSE ' and ' end
                           ||array_to_string(v_filter_cndary,' and ')
                           ||CASE WHEN papplydac ='T' and length(v_dac_cnd) > 2 THEN (' and ('||v_dac_cnd||')') END ||' 
							--axp_filter
							)a  order by modifiedon desc) b';
				END IF;
		end if;


		   
	v_final_sqls.EXTEND;
	v_final_sqls(v_final_sqls.COUNT) := (v_sql1);

return v_final_sqls;



 END;
>>
 
<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_se_listdata(pentity_transid varchar2, pflds_keyval clob, ppagesize numeric DEFAULT 50, ppageno numeric DEFAULT 1)
RETURN SYS_ODCINCLOBLIST
is 
    
v_sql clob;
v_sql1 clob; 
v_fldname_table varchar2(300);
v_fldname_transid  varchar2(3000);
v_fldname_col  varchar2(3000);
v_fldname_normalized  varchar2(3000);
v_fldname_srctbl  varchar2(3000);
v_fldname_srcfld  varchar2(3000);
v_fldname_allowempty  varchar2(3000); 
v_fldname_transidcnd number;
v_allflds  clob;
v_fldnamesary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_join  varchar2(4000);
v_fldname_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_tblflds clob;
v_emptyary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_pflds_transid  varchar2(3000); 
v_pflds_flds  clob;
v_pflds_keyvalue  varchar2(3000);
v_pflds_keytable varchar2(200);
v_keyvalue_fname  varchar2(3000);
v_keyvalue_fvalue  varchar2(3000);
v_keyvalue_fname_srckey varchar2(10);
v_keyvalue_fname_srctbl varchar2(50);
v_keyvalue_fname_srcfld varchar2(50);
v_final_sqls SYS_ODCINCLOBLIST := SYS_ODCINCLOBLIST();
v_fldname_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_primarydctable varchar2(3000);
v_fields_list clob;
v_filter_dcjoinuniq clob;
v_fldname_joinsuniq clob;
begin	


	FOR rec in  (select column_value as fldkeyvals from  table(string_to_array(pflds_keyval,'++')))    	 
    loop

	    	v_pflds_transid := split_part(rec.fldkeyvals,'=',1);
	    	v_pflds_flds := split_part(rec.fldkeyvals,'=',2);
	    	v_pflds_keyvalue := split_part(rec.fldkeyvals,'=',3);
	    	v_pflds_keytable := split_part(v_pflds_keyvalue,'~',3) ;  
	    	v_keyvalue_fname := split_part(v_pflds_keyvalue,'~',1);
			v_keyvalue_fvalue := split_part(v_pflds_keyvalue,'~',2);		
			v_keyvalue_fname_srckey := split_part(v_pflds_keyvalue,'~',4) ;
			v_keyvalue_fname_srctbl := split_part(v_pflds_keyvalue,'~',5) ;
			v_keyvalue_fname_srcfld := split_part(v_pflds_keyvalue,'~',6) ;	
	    
	    	select tablename into v_primarydctable from axpdc where tstruct =v_pflds_transid and dname ='dc1';
	    
	    	select count(1) into v_fldname_transidcnd from axpflds where tstruct = v_pflds_transid and dcname ='dc1' and lower(fname)='transid';
	    
	    	if  lower(v_pflds_keytable) = lower(v_primarydctable) and v_pflds_flds ='All' then
	    		select tablename||'!~'||listagg(str,'|') within group ( order by dcname ,ordno)  into  v_allflds From(
				select tablename,(fname||'~'||srckey||'~'||srctf||'~'||srcfld||'~'||allowempty) str,
                dcname,ordno
				from axpflds where tstruct=v_pflds_transid and 
				dcname ='dc1' and asgrid ='F' and hidden ='F' and savevalue='T' AND datatype not in('i','t') AND lower(fname)!='transid' )a GROUP BY tablename;		    	
			ELSIF lower(v_pflds_keytable) != lower(v_primarydctable) and v_pflds_flds ='All' THEN
				select tablename||'!~'||listagg(str,'|') within group ( order by dcname ,ordno)||'^'||
				v_pflds_keytable||'!~'||split_part(split_part(v_pflds_keyvalue,'~',1),'.',2)||'~'||
				split_part(v_pflds_keyvalue,'~',4)||'~'||split_part(v_pflds_keyvalue,'~',5)||'~'||
				split_part(v_pflds_keyvalue,'~',6)||'~'||split_part(v_pflds_keyvalue,'~',7)
				into  v_allflds From(
				select tablename,(fname||'~'||srckey||'~'||srctf||'~'||srcfld||'~'||allowempty) str,
                dcname,ordno
				from axpflds where tstruct=v_pflds_transid and 
				dcname ='dc1' and asgrid ='F' and hidden ='F' and savevalue='T' AND datatype not in('i','t'))a GROUP BY tablename;	
	    	end if;
			
	    	v_fields_list := case when v_pflds_flds='All' then v_allflds else v_pflds_flds end;

	    for rec1 in (select column_value as tblflds from table(string_to_array(v_fields_list,'^'))) 
	    	loop
			    v_fldname_table := 	split_part(rec1.tblflds,'!~',1);
		    	v_fldname_tblflds := 	split_part(rec1.tblflds,'!~',2);  	
		    
		    if 	lower(v_fldname_table)!=lower(v_primarydctable) then								
				v_fldname_dcjoinsary.EXTEND;
	            v_fldname_dcjoinsary(v_fldname_dcjoinsary.COUNT) := ('left join '||v_fldname_table||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_fldname_table||'.'||v_primarydctable||'id');
			end if;
		
		
			IF	lower(v_fldname_table)!=lower(v_pflds_keytable) then								
				v_fldname_dcjoinsary.EXTEND;
				v_fldname_dcjoinsary(v_fldname_dcjoinsary.COUNT) := ('left join '||v_pflds_keytable||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_pflds_keytable||'.'||v_primarydctable||'id');
			end if;
		
			IF	v_keyvalue_fname_srckey='T' then 				
				v_fldname_joinsary .EXTEND;
				v_fldname_joinsary (v_fldname_joinsary.COUNT):= (' join ' ||v_keyvalue_fname_srctbl||' on '||v_keyvalue_fname||' = '||v_keyvalue_fname_srctbl||'.'||v_keyvalue_fname_srctbl||'id');
			end if;
		    	                
			    FOR rec2 in			    	
    				(select column_value as fldname from table(string_to_array(v_fldname_tblflds,'|'))) 
						loop		    									
							v_fldname_col := split_part(rec2.fldname,'~',1);
							v_fldname_normalized := split_part(rec2.fldname,'~',2);
							v_fldname_srctbl := split_part(rec2.fldname,'~',3);
							v_fldname_srcfld := split_part(rec2.fldname,'~',4);														
							v_fldname_allowempty := split_part(rec2.fldname,'~',5);
												

							if v_fldname_normalized ='F' and lower(v_fldname_col)!='app_desc' then 
                             v_fldnamesary.EXTEND;
                             v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_table||'.'||v_fldname_col);
                            elsif v_fldname_normalized ='F' and lower(v_fldname_col)='app_desc' then						
								v_fldnamesary.EXTEND;						
								v_fldnamesary(v_fldnamesary.COUNT) := 'case when length('||v_fldname_table||'.wkid)>2 then case '||v_fldname_table||'.app_desc when 0 then  ''Created''
								  when  1 then ''Approved''
								  when  2 then ''Review''
								  when  3 then ''Return''
								  when  4 then ''Approve''
								  when  5 then ''Rejected''
								  when  9 then ''Orphan'' end else null end app_desc';
							elsif v_fldname_normalized ='T' then	
                             v_fldnamesary.EXTEND;
                             v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_col||'.'||v_fldname_srcfld||' '||v_fldname_col);	

                             v_fldname_joinsary.EXTEND;
                             v_fldname_joinsary(v_fldname_joinsary.COUNT) := (case when v_fldname_allowempty='F' then ' join ' else ' left join ' end||v_fldname_srctbl||' '||v_fldname_col||' on '||v_fldname_table||'.'||v_fldname_col||' = '||v_fldname_col||'.'||v_fldname_srctbl||'id');

							 end if;	

			    		end loop;
	    	end loop;
	    
	    	
	    	SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_filter_dcjoinuniq from(select distinct column_value from   table(v_fldname_dcjoinsary));
			SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_fldname_joinsuniq from(select distinct column_value from   table(v_fldname_joinsary));
		
		 
				v_sql := (' select '||''''||v_pflds_transid||''' transid,'||v_primarydctable||'.'||v_primarydctable||'id recordid,'||v_primarydctable||'.username modifiedby,'||v_primarydctable||'.modifiedon,'||v_primarydctable||'.createdon,'||v_primarydctable||'.createdby,'||
				v_primarydctable||'.cancel,'||v_primarydctable||'.cancelremarks,'||array_to_string(v_fldnamesary,',')
		   			 ||' from '
		   			 ||v_primarydctable||' '||v_filter_dcjoinuniq||' '||v_fldname_joinsuniq
		   			 ||' where 1=1 '
                     ||case when v_fldname_transidcnd>0 then ' and '||v_primarydctable||'.transid='||''''||v_pflds_transid||''' and ' ELSE ' and ' END
                     ||case when v_keyvalue_fname_srckey='T'  then v_keyvalue_fname_srctbl||'.'||v_keyvalue_fname_srcfld else v_keyvalue_fname end ||'='||v_keyvalue_fvalue
                     ||'				
					--axp_filter');

		   				v_fldnamesary:= v_emptyary;
		   				v_fldname_joinsary:= v_emptyary;	  
		   				v_fldname_dcjoinsary:=v_emptyary; 
		   				
		IF ppagesize > 0 then
       v_sql1 :='select * from(                        
                        select a.*,row_number() over(order by modifiedon desc) rno,'||ppageno||' as  pageno  
                           from ( '||v_sql||' )a where rownum <='||(ppagesize*ppageno)||' order by modifiedon desc             
                                ) b  where rno between '||(ppagesize*(ppageno-1)+1)||' and '||(ppagesize*ppageno);
		ELSE
		v_sql1 :='select * from(select a.*,0 rno,1 as  pageno from ( '||v_sql||' )a  order by modifiedon ) b' ;
		
		
		END IF;
	

	v_final_sqls.EXTEND;
	v_final_sqls(v_final_sqls.COUNT) := (v_sql1);
    END LOOP;

   	

RETURN v_final_sqls;
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_chartdata(psource in varchar2, pentity_transid in varchar2, pcondition in varchar2, pcriteria in varchar2,pfilter clob DEFAULT 'NA', pusername varchar2 DEFAULT 'admin', papplydac varchar2 DEFAULT 'T', puserrole varchar2 DEFAULT 'All',pconstraints clob DEFAULT NULL )
RETURN  SYS_ODCINCLOBLIST
IS   
v_primarydctable varchar2(3000);
v_subentitytable varchar2(3000);
v_transid varchar2(3000);
v_grpfld varchar2(3000);
v_aggfld varchar2(3000);
v_aggfnc varchar2(3000);
v_srckey varchar2(3000);
v_srctbl varchar2(3000); 
v_srcfld varchar2(3000);
v_aempty varchar2(3000);
v_tablename varchar2(100);
v_sql clob;
v_normalizedjoin varchar2(3000);
v_keyname varchar2(3000);
v_keyfld_fname varchar2(3000);
v_keyfld_fval varchar2(3000);  
v_keyfld_srckey varchar2(10);
v_keyfld_srctbl varchar2(50);
v_keyfld_srcfld varchar2(50);
v_final_sqls SYS_ODCINCLOBLIST := SYS_ODCINCLOBLIST();
v_fldname_transidcnd number;
v_sql1 clob;
v_filter_srcfld varchar2(200);
v_filter_srctxt clob;
v_filter_join varchar2(2000);
v_filter_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_cnd clob;
v_filter_cndary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_joinreq numeric;
v_filter_dcjoin varchar2(3000);
v_filter_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_dcjoinuniq clob;
v_filter_col varchar2(2000);
v_filter_normalized varchar2(20); 
v_filter_sourcetbl varchar2(200);
v_filter_sourcefld varchar2(200);
v_filter_datatype varchar2(20);
v_filter_listedfld varchar2(20);
v_filter_tablename varchar2(200);
v_emptyary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_jointables SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dac_cnd clob;
begin

	
	select tablename into v_primarydctable from axpdc where tstruct = pentity_transid and dname ='dc1';
	
	v_jointables.extend();
	v_jointables(v_jointables.COUNT) := v_primarydctable;


-------------Permission filter
	   if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_primarydctable||'.');											   					   			   										
			   end if;		   			
		   			
	
	
	if pcondition ='Custom' THEN
		select count(1) into v_fldname_transidcnd from axpflds where tstruct = pentity_transid and dcname ='dc1' and lower(fname)='transid';
	    FOR rec IN
    	    (select column_value as criteria from table(string_to_array(pcriteria,'^')) )
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
				v_normalizedjoin := case when v_srckey='T' then (' left join '||v_srctbl||' b on '||v_primarydctable||'.'||v_grpfld||' = b.'||v_srctbl||'id ') else ' ' end;
				v_keyname := case when length(v_grpfld) > 0 then case when v_srckey='T' then ('b.'||v_srcfld) else (v_primarydctable||'.'||v_grpfld) end else 'null' end;			
			
				v_jointables.extend();
				v_jointables(v_jointables.COUNT) := case when v_srckey='T' then v_srctbl end;	
	
				

	
                	if lower(v_tablename)=lower(v_primarydctable) then
		                v_sql := ('select '||' '||v_keyname||' keyname,'||case when lower(trim(v_aggfnc)) in ('sum','avg') then 'round('||v_aggfnc||'('||v_aggfld||'),2)'else v_aggfnc||'('||v_aggfld||')' END||' keyvalue,'||'''Custom'''||' '||'cnd,'''||replace(rec.criteria,'''','')||''' criteria from '||
						v_primarydctable||' '||v_normalizedjoin);	
						v_jointables.extend();
						v_jointables(v_jointables.COUNT) := v_tablename;
                	ELSE
                	 	v_sql := ('select '||' '||v_keyname||' keyname,'||case when lower(trim(v_aggfnc)) in ('sum','avg') then 'round('||v_aggfnc||'('||v_aggfld||'),2)'else v_aggfnc||'('||v_aggfld||')' end||' keyvalue,'||'''Custom'''||' '||'cnd,'''||replace(rec.criteria,'''','')||''' criteria from '||
						v_primarydctable||' join '||v_tablename||' on '||v_primarydctable||'.'||v_primarydctable||'.id='||v_tablename||'.'||v_primarydctable||'id '||v_normalizedjoin);
						v_jointables.extend();
						v_jointables(v_jointables.COUNT) := v_tablename;
                	END IF;
               
                
                if pfilter ='NA' then 

        v_sql1 := v_sql||'where 1=1 '||
        		CASE WHEN v_fldname_transidcnd > 0 THEN ' and '||v_primarydctable||'.transid='''||pentity_transid||'''' end||
        		case when papplydac ='T' and length(v_dac_cnd)>2 then (' and ('||v_dac_cnd||')') end||
        		'
				  --axp_filter
				'||case when length(v_grpfld) > 0 then (' group by '||v_keyname) else '' END;
		else
			FOR rec_filters IN
    			(select column_value as ifilter from table(string_to_array(pfilter,'^')) )
			    loop		    	
			    	v_filter_srcfld := split_part(rec_filters.ifilter,'|',1); -- tstfm~empcode~F~~
			    	v_filter_srctxt := split_part(rec_filters.ifilter,'|',2);--   = 'EMP-001'
			    	v_filter_col := split_part(v_filter_srcfld,'~',1);
				    v_filter_normalized := split_part(v_filter_srcfld,'~',2);
 				    v_filter_sourcetbl := split_part(v_filter_srcfld,'~',3);
 				    v_filter_sourcefld := split_part(v_filter_srcfld,'~',4);
					v_filter_datatype := split_part(v_filter_srcfld,'~',5);
					v_filter_listedfld :=split_part(v_filter_srcfld,'~',6);
					v_filter_tablename:=split_part(v_filter_srcfld,'~',7);
					
			    if  v_filter_listedfld='F' then 
								    	
			    	v_filter_joinreq := case when lower(v_tablename)=lower(v_filter_tablename) then 1 else 0 end;
			    	
			    	if v_filter_joinreq = 0  then  
				    	v_filter_dcjoin := ' join '||v_filter_tablename||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_filter_tablename||'.'||v_primarydctable||'id';
				    	v_filter_dcjoinsary.EXTEND;
	                   	v_filter_dcjoinsary(v_filter_dcjoinsary.COUNT) := v_filter_dcjoin;
			    	end if;
			    				    		  	
                   	if v_filter_normalized='T' then  	
 		           		v_filter_join := (' join '||v_filter_sourcetbl||' '||v_filter_col||' on '||v_filter_tablename||'.'||v_filter_col||' = '||v_filter_col||'.'||v_filter_sourcetbl||'id');
        	    	   	v_filter_joinsary.EXTEND;
            	       	v_filter_joinsary(v_filter_joinsary.COUNT) := v_filter_join;
                  	end if;
                    
				END IF;
				if v_filter_normalized='F' then                    
                	v_filter_cnd := case when v_filter_datatype='c' then 'lower(' END ||(v_filter_tablename||'.'||v_filter_col||case when v_filter_datatype='c' then ')' end||' '||v_filter_srctxt) ;
                else 
                  	v_filter_cnd := case when v_filter_datatype='c' then 'lower(' END||(v_filter_col||'.'||v_filter_sourcefld||case when v_filter_datatype='c' then ')' end||' '||v_filter_srctxt) ;
                end if; 

                    v_filter_cndary.EXTEND;
                    v_filter_cndary(v_filter_cndary.COUNT) := v_filter_cnd;

			    end loop;
					
			   		SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_filter_dcjoinuniq from(select distinct column_value from   table(v_filter_dcjoinsary));
			   		
                	 v_sql1 := v_sql||' '||v_filter_dcjoinuniq||' ' ||array_to_string(v_filter_joinsary,' ')||' where 1=1 '||
                           CASE WHEN v_fldname_transidcnd>0 THEN ' and '||v_primarydctable||'.transid='''||pentity_transid||'''' ELSE ' and 'END
                           ||array_to_string(v_filter_cndary,' and ')
                           ||case when papplydac ='T' and length(v_dac_cnd)>2 then (' and ('||v_dac_cnd||')') end||
                           '
							--axp_filter 
							'||case when length(v_grpfld) > 0 then (' group by '||v_keyname) else '' end;
				end if;


	                    v_final_sqls.EXTEND;
                         v_final_sqls(v_final_sqls.COUNT) := (v_sql1);
				
			
			v_filter_cndary:= v_emptyary;
			v_jointables :=v_emptyary;
			
		end loop;


   elsif pcondition = 'General' AND psource ='Entity'  then 

		if psource ='Entity' then    

			select count(1) into v_fldname_transidcnd from axpflds where tstruct = pentity_transid and dcname ='dc1' and lower(fname)='transid';
			
			v_sql:=	 ('select count(*) totrec,
				sum(case when EXTRACT(YEAR FROM createdon) = EXTRACT(YEAR FROM SYSDATE) then 1 else 0 end) cyear,
	            sum(case when EXTRACT(MONTH FROM createdon) = EXTRACT(MONTH FROM SYSDATE) then 1 else 0 end) cmonth,
	            sum(case when TO_NUMBER(TO_CHAR(createdon, ''IW'')) = TO_NUMBER(TO_CHAR(SYSDATE, ''IW''))  then 1 else 0 end) cweek,
	            sum(case when trunc('||v_primarydctable||'.createdon) = to_date(sysdate) - 1 then 1 else 0 end) cyesterday,
	            sum(case when trunc('||v_primarydctable||'.createdon) = to_date(sysdate) then 1 else 0 end) ctoday,''General'' cnd,null criteria 
				from '||v_primarydctable);				
	

			-------------------Permission filter
			if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_primarydctable||'.');											   					   			   										
			end if;		   			
	  
				
								
			
		if pfilter ='NA' then 

        v_sql1 := v_sql||' where 1=1 '||
        		CASE WHEN v_fldname_transidcnd > 0 THEN ' and '||v_primarydctable||'.transid='''||pentity_transid||'''' end||
        		case when papplydac ='T' and length(v_dac_cnd)>2 then (' and ('||v_dac_cnd||')') end||
        		'
				  --axp_filter
				'||case when length(v_grpfld) > 0 then (' group by '||v_keyname) else '' END;
		else
			FOR rec_filters IN
    			(select column_value as ifilter from table(string_to_array(pfilter,'^')) )
			    loop		    	
			    	v_filter_srcfld := split_part(rec_filters.ifilter,'|',1); -- tstfm~empcode~F~~
			    	v_filter_srctxt := split_part(rec_filters.ifilter,'|',2);--   = 'EMP-001'
			    	v_filter_col := split_part(v_filter_srcfld,'~',1);
				    v_filter_normalized := split_part(v_filter_srcfld,'~',2);
 				    v_filter_sourcetbl := split_part(v_filter_srcfld,'~',3);
 				    v_filter_sourcefld := split_part(v_filter_srcfld,'~',4);
					v_filter_datatype := split_part(v_filter_srcfld,'~',5);
					v_filter_listedfld :=split_part(v_filter_srcfld,'~',6);
					v_filter_tablename:=split_part(v_filter_srcfld,'~',7);
					
			    if  v_filter_listedfld='F' then 
								    	
			    	v_filter_joinreq := case when lower(v_tablename)=lower(v_filter_tablename) then 1 else 0 end;
			    	
			    	if v_filter_joinreq = 0  then  
				    	v_filter_dcjoin := ' join '||v_filter_tablename||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_filter_tablename||'.'||v_primarydctable||'id';
				    	v_filter_dcjoinsary.EXTEND;
	                   	v_filter_dcjoinsary(v_filter_dcjoinsary.COUNT) := v_filter_dcjoin;
			    	end if;
			    				    		  	
                   	if v_filter_normalized='T' then  	
 		           		v_filter_join := (' join '||v_filter_sourcetbl||' '||v_filter_col||' on '||v_filter_tablename||'.'||v_filter_col||' = '||v_filter_col||'.'||v_filter_sourcetbl||'id');
        	    	   	v_filter_joinsary.EXTEND;
            	       	v_filter_joinsary(v_filter_joinsary.COUNT) := v_filter_join;
                  	end if;
                    
				END IF;
				if v_filter_normalized='F' then                    
                	v_filter_cnd := case when v_filter_datatype='c' then 'lower(' END ||(v_filter_tablename||'.'||v_filter_col||case when v_filter_datatype='c' then ')' end||' '||v_filter_srctxt) ;
                else 
                  	v_filter_cnd := case when v_filter_datatype='c' then 'lower(' END||(v_filter_col||'.'||v_filter_sourcefld||case when v_filter_datatype='c' then ')' end||' '||v_filter_srctxt) ;
                end if; 

                    v_filter_cndary.EXTEND;
                    v_filter_cndary(v_filter_cndary.COUNT) := v_filter_cnd;

			    end loop;
					
			   		SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_filter_dcjoinuniq from(select distinct column_value from   table(v_filter_dcjoinsary));
			   		
                	 v_sql1 := v_sql||' '||v_filter_dcjoinuniq||' ' ||array_to_string(v_filter_joinsary,' ')||' where 1=1 '||
                           CASE WHEN v_fldname_transidcnd>0 THEN ' and '||v_primarydctable||'.transid='''||pentity_transid||'''' ELSE ' and 'END
                           ||array_to_string(v_filter_cndary,' and ')
                           ||case when papplydac ='T' and length(v_dac_cnd)>2 then (' and ('||v_dac_cnd||')') end||
                           '
							--axp_filter 
							'||case when length(v_grpfld) > 0 then (' group by '||v_keyname) else '' end;
				end if;
										
						
					else 
							v_sql1 := (v_sql||' where 1=1 '||
									case when v_fldname_transidcnd > 0 then ' and transid='''||pentity_transid||'''' END||
							' 
							--axp_filter
							');								
				   end if;
			
						     v_final_sqls.EXTEND;
	                         v_final_sqls(v_final_sqls.COUNT) := (v_sql1);


		elsif psource= 'Subentity' AND pcondition='General' then 		
		    FOR rec IN
	    	    (select column_value as criteria from table(string_to_array(pcriteria,'^'))) 
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
			
				
				if lower(v_tablename)=lower(v_subentitytable) then
			
				v_sql :=  ('select '||''''||v_transid||'''transid'||',count(*) totrec,''General'' cnd,'''||replace(rec.criteria,'''','')||''' criteria  
							from '||v_subentitytable||
							case when v_keyfld_srckey='T' then ' join '||v_keyfld_srctbl||' on '||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id = '||v_tablename||'.'||v_keyfld_fname end
                             ||' where 1=1 '
                             ||CASE WHEN v_fldname_transidcnd > 0 THEN ' and '||v_tablename||'.transid='''||v_transid||''' and ' ELSE ' and ' end
                             ||case when v_keyfld_srckey='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else v_keyfld_fname END||'='||v_keyfld_fval
                             ||'
								--axp_filter');				
				ELSE
				
				v_sql :=  ('select '||''''||v_transid||'''transid'||',count(*) totrec,''General'' cnd,'''||replace(rec.criteria,'''','')||''' criteria  from '
							||v_tablename||' a join '
							||v_subentitytable||' b on a.' ||v_subentitytable||'id=b.'||v_subentitytable||'id '
							||case when v_keyfld_srckey='T' then ' join '||v_keyfld_srctbl||' on '||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id = a.'||v_keyfld_fname end
							||' where 1=1 '
							||CASE WHEN v_fldname_transidcnd > 0 THEN 'and b.transid='''||v_transid||''' and ' ELSE ' and ' end 
							||case when v_keyfld_srckey='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else v_keyfld_fname END||'='||v_keyfld_fval
							||'
								--axp_filter'); 
                            
				END IF;
			                                                  
                          
               		 v_final_sqls.EXTEND;
                         v_final_sqls(v_final_sqls.COUNT) := (v_sql);
                

			end loop;	
	
		end if;

   return v_final_sqls;

END;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_axupscript
RETURN VARCHAR2
IS
    CURSOR c_axpflds IS
        SELECT fname
        FROM axpflds
        WHERE tstruct = 'a__ua'
          AND dcname = 'dc3'
          AND fname NOT IN ('sqltext1', 'cnd1');

    v_generated_sql_part VARCHAR2(4000);    
    v_all_sql_union    VARCHAR2(32000) := NULL;    
    v_sql_count        NUMBER := 0;    
    v_final_result     VARCHAR2(32000);
BEGIN
    
    FOR rec_loop IN c_axpflds
    LOOP
            BEGIN            
              
	            v_generated_sql_part := 'select ''EXISTS (   SELECT 1   FROM DUAL where REGEXP_SUBSTR('||REPLACE(rec_loop.fname,'axug_','{primarytable.}axg_')||', ''''[^,]+'''', 1, LEVEL) in(''''''||replace(:' || rec_loop.fname || ','','','''''','''''')||'''''') CONNECT BY LEVEL <= REGEXP_COUNT('||REPLACE(rec_loop.fname,'axug_','{primarytable.}axg_')||', '''','''') + 1 )'' cnd from dual where exists(select 1 from table(string_to_array(:'||rec_loop.fname||','','')) having sum(case when column_value=''All'' then 1 else 0 end)=0)';
            
	           IF v_sql_count > 0 THEN
                v_all_sql_union := v_all_sql_union || ' UNION ALL ';
            END IF;
            
            v_all_sql_union := v_all_sql_union || '(' || v_generated_sql_part || ')';
            v_sql_count := v_sql_count + 1;

        END;
    END LOOP; 

    IF v_sql_count = 0 THEN
        v_final_result := 'SELECT NULL FROM DUAL';
    ELSE        
        v_final_result := 'SELECT LISTAGG(cnd, '' AND '') WITHIN GROUP (ORDER BY ROWNUM) FROM (' || v_all_sql_union || ') b';
    END IF;

    RETURN v_final_result;

EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_create_grpcol(
    ptransid IN VARCHAR2,
    ptable IN VARCHAR2
)
RETURN VARCHAR2
IS
    v_altersql VARCHAR2(4000);
BEGIN
    FOR r_grp IN (SELECT grpname FROM axgroupingmst) LOOP
        v_altersql := 'ALTER TABLE ' || ptable || ' ADD axg_' || r_grp.grpname || ' VARCHAR2(4000)';


        EXECUTE IMMEDIATE v_altersql;
    END LOOP;


    RETURN 'T';


END;
>>

<<
DROP TYPE AXPDEF_PERMISSION_GETADSCND
>>

<< 
DROP TYPE AXPDEF_PERMISSION_GETADS_OBJ
>>
 
<< 
CREATE OR REPLACE TYPE AXPDEF_PERMISSION_GETADSCND                                          AS OBJECT (
    fullcontrol VARCHAR2(1),
    userrole VARCHAR2(255),
    view_access VARCHAR2(10),
    view_includeflds clob,
    view_excludeflds clob,
    maskedflds clob,
    filtercnd CLOB,
    permissiontype    VARCHAR2(50)
);
>>

<< 
CREATE OR REPLACE TYPE AXPDEF_PERMISSION_GETADS_OBJ AS TABLE OF AXPDEF_PERMISSION_GETADSCND;
>>

<<
CREATE OR REPLACE TYPE fn_perm_getdcrecid_rec AS OBJECT (
    dcname   VARCHAR2(4000),
    rowno    NUMBER,
    recordid NUMBER
);
>>

<< 
CREATE OR REPLACE TYPE fn_perm_getdcrecid_tab AS TABLE OF fn_perm_getdcrecid_rec;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getadscnd(
    ptransid    IN VARCHAR2,
    padsname    IN VARCHAR2,
    pusername   IN VARCHAR2,
    proles      IN VARCHAR2 DEFAULT 'All',
    pkeyfield   IN VARCHAR2 DEFAULT NULL,
    pkeyvalue   IN VARCHAR2 DEFAULT NULL
) RETURN AXPDEF_PERMISSION_GETADS_OBJ PIPELINED
AS
    v_rolesql        CLOB;
    v_permissionsql  CLOB;
    v_permissionexists NUMBER;
                  v_cur   SYS_REFCURSOR;
            v_axuserrole        VARCHAR2(200);
            v_view_includeflds  CLOB;
            v_view_excludeflds  CLOB;
            v_fieldmaskstr      CLOB;
            v_cnd               NCLOB;
            v_viewctrl          VARCHAR2(50);
            v_permissiontype    VARCHAR2(50);
        
    
BEGIN
    IF proles = 'All' THEN
        v_rolesql := '
            SELECT a.axuserrole,
                   CASE WHEN viewctrl = ''1'' THEN viewlist END AS view_includedflds,
                   CASE WHEN viewctrl = ''2'' THEN viewlist END AS view_excludedflds,
                   a.fieldmaskstr,
                   b.cnd1 cnd,
                   viewctrl,
                   ''Role'' AS permissiontype
              FROM AxPermissions a
              JOIN axuserlevelgroups a2 ON a2.axusergroup = a.axuserrole
              JOIN axusers u ON a2.axusersid = u.axusersid
              --LEFT JOIN axuserpermissions b ON a.axuserrole = b.axuserrole AND b.AXUSERSID = u.AXUSERSID 
left join axusergrouping b on u.axusersid = b.axusersid
             WHERE u.username = '''||pusername||'''
               AND a.formtransid = '''||padsname||'''
            UNION ALL
            SELECT a.axuserrole,
                   CASE WHEN viewctrl = ''1'' THEN viewlist END,
                   CASE WHEN viewctrl = ''2'' THEN viewlist END,
                   a.fieldmaskstr,
                   b.cnd,
                   viewctrl,
                   ''User'' 
              FROM AxPermissions a
              LEFT JOIN axuserdpermissions b ON a.AxPermissionsid = b.AxPermissionsid
             WHERE a.axusername = '''||pusername||'''
               AND a.formtransid = '''||padsname||'''';

        v_permissionsql := '
            SELECT COUNT(1) 
              FROM (
                SELECT 1
                  FROM AxPermissions a
                  JOIN axuserlevelgroups a2 ON a2.axusergroup = a.axuserrole
                  JOIN axusers u ON a2.axusersid = u.axusersid
                  --LEFT JOIN axuserpermissions b ON a.axuserrole = b.axuserrole AND b.AXUSERSID = u.AXUSERSID 
left join axusergrouping b on u.axusersid = b.axusersid
                 WHERE u.username = '''||pusername||'''
                   AND a.formtransid = '''||padsname||'''
                UNION ALL
                SELECT 1
                  FROM AxPermissions a
                  LEFT JOIN axuserdpermissions b ON a.AxPermissionsid = b.AxPermissionsid
                 WHERE a.axusername = '''||pusername||'''
                   AND a.formtransid = '''||padsname||''')';
    ELSE
        v_rolesql := '
            SELECT a.axuserrole,
                   CASE WHEN viewctrl = ''1'' THEN viewlist END,
                   CASE WHEN viewctrl = ''2'' THEN viewlist END,
                   a.fieldmaskstr,
                   b.cnd,
                   viewctrl,
                   ''Role''
              FROM AxPermissions a
              JOIN axuserlevelgroups a2 ON a2.axusergroup = a.axuserrole
              JOIN axusers u ON a2.axusersid = u.axusersid
              left join (
select a2.usergroup ,b.cnd1 cnd from axusers a join axuserlevelgroups a2 on a2.axusersid = a.axusersid left join axusergrouping b on a.axusersid =b.axusersid  where a.username = '''||pusername||''')b on a.axuserrole=b.usergroup
             WHERE u.username = '''||pusername||'''
               AND a.formtransid = '''||padsname||'''
               AND EXISTS (
                   SELECT 1
                     FROM (
                         SELECT REGEXP_SUBSTR('''||proles||''', ''[^,]+'', 1, LEVEL) val
                           FROM dual
                        CONNECT BY REGEXP_SUBSTR('''||proles||''', ''[^,]+'', 1, LEVEL) IS NOT NULL
                     ) t
                    WHERE t.val = a.axuserrole
               )
            UNION ALL
            SELECT a.axuserrole,
                   CASE WHEN viewctrl = ''1'' THEN viewlist END,
                   CASE WHEN viewctrl = ''2'' THEN viewlist END,
                   a.fieldmaskstr,
                   b.cnd,
                   viewctrl,
                   ''User''
              FROM AxPermissions a
              LEFT JOIN axuserdpermissions b ON a.AxPermissionsid = b.AxPermissionsid
             WHERE a.axusername = '''||pusername||'''
               AND a.formtransid = '''||padsname||'''';

        v_permissionsql := '
            SELECT COUNT(1)
              FROM (
                SELECT 1
                  FROM AxPermissions a
                  JOIN axuserlevelgroups a2 ON a2.axusergroup = a.axuserrole
                  JOIN axusers u ON a2.axusersid = u.axusersid
                  left join (
select a2.usergroup ,b.cnd1 cnd from axusers a join axuserlevelgroups a2 on a2.axusersid = a.axusersid left join axusergrouping b on a.axusersid =b.axusersid  where a.username = '''||pusername||''')b on a.axuserrole=b.usergroup
                 WHERE u.username = '''||pusername||'''
                   AND a.formtransid = '''||padsname||'''
                   AND EXISTS (
                       SELECT 1
                         FROM (
                             SELECT REGEXP_SUBSTR('''||proles||''', ''[^,]+'', 1, LEVEL) val
                               FROM dual
                            CONNECT BY REGEXP_SUBSTR('''||proles||''', ''[^,]+'', 1, LEVEL) IS NOT NULL
                         ) t
                        WHERE t.val = a.axuserrole
                   )
                UNION ALL
                SELECT 1
                  FROM AxPermissions a
                  LEFT JOIN axuserdpermissions b ON a.AxPermissionsid = b.AxPermissionsid
                 WHERE a.axusername = '''||pusername||'''
                   AND a.formtransid = '''||padsname||''')';
    END IF;

    -- Execute permission check
    EXECUTE IMMEDIATE v_permissionsql INTO v_permissionexists;

    IF v_permissionexists = 0 THEN
        PIPE ROW(AXPDEF_PERMISSION_GETADSCND(
            'T', NULL, NULL, NULL, NULL, NULL, NULL, NULL
        ));
        RETURN;
    ELSE
      
            OPEN v_cur FOR v_rolesql;

            LOOP
                FETCH v_cur
                INTO v_axuserrole,
                     v_view_includeflds,
                     v_view_excludeflds,
                     v_fieldmaskstr,
                     v_cnd,
                     v_viewctrl,
                     v_permissiontype;
                EXIT WHEN v_cur%NOTFOUND;

                PIPE ROW(AXPDEF_PERMISSION_GETADSCND(
                    NULL,
                    v_axuserrole,
                    CASE WHEN v_viewctrl = '4' THEN 'None' ELSE NULL END,
                    v_view_includeflds,
                    v_view_excludeflds,
                    v_fieldmaskstr,
                    v_cnd,
                    v_permissiontype
                ));
            END LOOP;

            CLOSE v_cur;
    END IF;
 
    RETURN;
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getadssql (
    ptransid   VARCHAR2,
    padsname   VARCHAR2,
    pcond      CLOB
) RETURN CLOB
IS
    v_adssql        CLOB;
    v_filtersql     CLOB;
    v_primarydctable VARCHAR2(2000);
    v_filtercnd     CLOB;
BEGIN

    SELECT sqltext
      INTO v_adssql
      FROM axdirectsql
     WHERE sqlname = padsname;


    IF pcond <> 'NA' THEN
    SELECT tablename INTO v_primarydctable from    
    (SELECT tablename FROM axpdc WHERE tstruct = ptransid AND dname = 'dc1');

        v_filtercnd := ' and (' || REPLACE(pcond, '{primarytable.}', v_primarydctable || '.') || ')';

        
        v_filtersql := REPLACE(v_adssql, '--ax_permission_filter', v_filtercnd);
    END IF;

    
    RETURN CASE
               WHEN pcond = 'NA' THEN v_adssql
               WHEN  pcond <> 'NA' AND v_primarydctable IS NOT NULL then v_filtersql
               ELSE v_adssql
           END;
        

END;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getdcrecid(
    ptransid   IN VARCHAR2,
    precordid  IN NUMBER,
    pdcstring  IN VARCHAR2
)
RETURN fn_perm_getdcrecid_tab PIPELINED
AS
    v_dcname          VARCHAR2(4000);
    v_rowstring       VARCHAR2(4000);
    v_dctable         VARCHAR2(4000);
    v_primarydctable  VARCHAR2(4000);
    v_sql             VARCHAR2(32767);

    v_dcname_out      VARCHAR2(4000);
    v_rowno_out       NUMBER;
    v_recordid_out    NUMBER;

    rc                SYS_REFCURSOR; 
BEGIN
  
    SELECT tablename
      INTO v_primarydctable 
      FROM axpdc
     WHERE tstruct = ptransid
       AND dname   = 'dc1';

    FOR v_rec IN (
        SELECT REGEXP_SUBSTR(pdcstring, '[^|]+', 1, LEVEL) AS str
          FROM dual
        CONNECT BY REGEXP_SUBSTR(pdcstring, '[^|]+', 1, LEVEL) IS NOT NULL
    )
    LOOP
     
        v_dcname    := SUBSTR(v_rec.str, 1, INSTR(v_rec.str, '~') - 1);
        v_rowstring := SUBSTR(v_rec.str, INSTR(v_rec.str, '~') + 1);

      
        SELECT tablename
          INTO v_dctable
          FROM axpdc
         WHERE tstruct = ptransid
           AND dname   = v_dcname;

        IF v_rowstring = '0' THEN
            
            v_sql :=
                   'SELECT ''' || v_dcname || ''' dcname, '
                || v_rowstring || ' rowno, '
                || v_dctable   || 'id recordid '
                || 'FROM '     || v_dctable
                || ' WHERE '   || v_primarydctable || 'id = :precordid';

            OPEN rc FOR v_sql USING precordid;
        ELSE
          
            v_sql :=
                   'SELECT ''' || v_dcname || ''' dcname, '
                || v_dctable   || 'row rowno, '
                || v_dctable   || 'id recordid '
                || 'FROM '     || v_dctable
                || ' WHERE '   || v_primarydctable || 'id = :precordid'
                || '   AND '   || v_dctable || 'row IN (' || v_rowstring || ')';

            OPEN rc FOR v_sql USING precordid;
        END IF;

        
        LOOP
            FETCH rc INTO v_dcname_out, v_rowno_out, v_recordid_out;
            EXIT WHEN rc%NOTFOUND;

            PIPE ROW (
                fn_perm_getdcrecid_rec(
                    v_dcname_out,
                    v_rowno_out,
                    v_recordid_out
                )
            );
        END LOOP;

        CLOSE rc;
    END LOOP;

    RETURN;
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_usercriteria(precid IN NUMBER)
 RETURN VARCHAR2
 IS
    v_sql    VARCHAR2(4000);
    v_flds   VARCHAR2(4000);
    v_result VARCHAR2(4000);
BEGIN

    SELECT LISTAGG(
               '''' || apf.caption || '=''||' || apf.fname || '||''~''',
               '||'
           ) WITHIN GROUP (ORDER BY apf.caption)
    INTO v_flds
    FROM axpflds apf
    WHERE apf.tstruct = 'a_dup'
      AND apf.dcname = 'dc1'
      AND apf.savevalue = 'T'
      AND apf.fname NOT IN ('axuserrole', 'sqltext', 'cnd');

    IF LENGTH(v_flds) > 2 THEN
        
        v_sql := 'SELECT ' || v_flds || ' FROM axuserdpermissions WHERE sourcerecid = ' || TO_CHAR(precid);

        EXECUTE IMMEDIATE v_sql INTO v_result;
    END IF;

 
    RETURN v_result;
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_permission_fldaddjson(
    p_dccaption   IN VARCHAR2,  
    p_grpname      IN VARCHAR2,  
    p_grpcaption   IN VARCHAR2,
    pcnd IN varchar2
) RETURN VARCHAR2 
IS
    v_json_string VARCHAR2(4000); 
BEGIN
	
	IF pcnd = 'uc_dim' THEN 
    v_json_string := '{"saveValue" : "T", ' ||
                     '"dcName" : "dc3", ' ||
                     '"dcNo" : 3, ' ||
                     '"dcCaption" : "' || p_dccaption || '", ' ||
                     '"asgrid" : "F", ' ||
                     '"source" : "select from sql", ' ||
                     '"MOE" : "select from sql", ' ||
                     '"name" : "axug_' || p_grpname || '", ' ||
                     '"caption" : "' || p_grpcaption || '", ' ||
                     '"fieldType" : "CheckList", ' ||
                     '"dataType" : "Character", ' ||
                     '"width" : 4000, ' ||
                     '"allowEmpty" : "T", ' ||
                     '"allowDuplicate" : "T", ' ||
                     '"SqlText" : "select grpvalue from axgrouping where grpnamedb=''' || p_grpname || ''' order by 1", ' ||
                     '"hidden" : "F", ' ||
                     '"saveNormalized" : "F", ' ||
                     '"firstcolvalue" : "grpvalue", ' ||
                     '"firstcoldtype" : "c", ' ||
                     '"tablename" : "axgrouping",'||
					 '"fldPosition":"Before field",'||
				     '"position":"cnd1-(cnd1)"}';
	ELSIF pcnd = 'uc_up' THEN
	v_json_string :=  '{"saveValue" : "T", "dcName" : "dc4", "dcNo" : 4, "dcCaption" : "' || p_dccaption || '", "asgrid" : "T", "source" : "select from sql", "MOE" : "select from sql", "name" : "axup_' || p_grpname || '", "caption" : "' || p_grpcaption || '", "fieldType" : "Multi Select", "dataType" : "Character", "width" : 500, "allowEmpty" : "T", "allowDuplicate" : "T", "SqlText" : "select mslist, groupby, grouporder, selected from (select grpvalue as mslist, ''' || p_grpcaption || ''' as groupby, 1 as grouporder, ''false'' as selected, 2 as ord from axgrouping where grpnamedb = ''' || p_grpname || ''' union all select ''All'' as mslist, ''' ||p_grpcaption || ''' as groupby, 1 as grouporder, ''false'' as selected, 1 as ord from dual) a order by ord ", "hidden" : "F", "saveNomralized" : "F", "firstcolvalue" : "mslist", "firstcoldtype" : "c", "tablename" : "axgrouping", "fldPosition" : "Before field", "position" : "cnd-(cnd)"}';
 ELSIF pcnd = 'ps' THEN
 v_json_string :=  '{"saveValue" : "T", "dcName" : "dc2", "dcNo" : 2, "dcCaption" : "'|| p_dccaption ||'", "asgrid" : "F", "source" : "select from sql", "MOE" : "select from sql", "name" : "axug_'|| p_grpname ||'", "caption" : "'|| p_grpcaption ||'", "fieldType" : "CheckList", "dataType" : "Character", "width" : 500, "allowEmpty" : "T", "allowDuplicate" : "T", "SqlText" : "select grpvalue from axgrouping where grpnamedb='''|| p_grpname ||''' order by 1", "hidden" : "F", "saveNomralized" : "F", "firstcolvalue" : "grpvalue", "firstcoldtype" : "c", "tablename" : "axgrouping","fldPosition":"Before field","position":"cnd-(cnd)"}';
END IF; 

	

    RETURN v_json_string;

EXCEPTION WHEN OTHERS THEN RETURN null;
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_permisssion_field_masks(
    p_fieldmasks IN VARCHAR2,
    p_comptype   IN VARCHAR2
)
RETURN VARCHAR2
IS    
    v_mskprop VARCHAR2(4000);
BEGIN

	WITH field_masks_split_by_tilde AS (SELECT TRIM(REGEXP_SUBSTR(p_fieldmasks, '[^~]+', 1, LEVEL)) AS field_mask_pair_string
FROM DUAL WHERE LENGTH(p_fieldmasks) > 2
CONNECT BY LEVEL <= REGEXP_COUNT(p_fieldmasks, '~') + 1),field_masks_parsed AS (
SELECT TRIM(REGEXP_SUBSTR(field_mask_pair_string, '[^|]+', 1, 1)) AS fldname,
TRIM(REGEXP_SUBSTR(field_mask_pair_string, '[^|]+', 1, 2)) AS maskprop
FROM field_masks_split_by_tilde)
SELECT CAST(a.mskprop AS VARCHAR2(4000))
INTO v_mskprop
FROM (
SELECT LISTAGG(RTRIM(SUBSTR(fmp.fldname, INSTR(fmp.fldname, '-(') + 2), ')') || '=' || fmp.maskprop,',') WITHIN GROUP (ORDER BY 1) AS mskprop
FROM field_masks_parsed fmp WHERE 'Form' = p_comptype
UNION ALL        
SELECT LISTAGG(fmp.fldname || '=' || fmp.maskprop, ',') WITHIN GROUP (ORDER BY 1) AS mskprop
FROM field_masks_parsed fmp WHERE 'ADS' = p_comptype ) a
WHERE a.mskprop IS NOT NULL;

     
    RETURN v_mskprop;

EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
>>

<<
DROP FUNCTION FN_PERMISSIONS_GETCND;
>>

<<
DROP FUNCTION FN_PERMISSIONS_GETPERMISSION;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getcnd(
    pmode         IN VARCHAR2,
    ptransid      IN VARCHAR2,
    pkeyfld       IN VARCHAR2,
    pkeyvalue     IN VARCHAR2,
    pusername     IN VARCHAR2,
    proles        IN VARCHAR2 DEFAULT 'All',
    pglobalvars   IN VARCHAR2 DEFAULT 'NA'
) RETURN AXPDEF_PERMISSION_GETCND_OBJ PIPELINED
AS
	rc  SYS_REFCURSOR;
    -- Variables to hold data for keyfield and keyvalue
    v_keyfld_normalized   VARCHAR2(1);
    v_keyfld_srctbl       VARCHAR2(100);
    v_keyfld_srcfld       VARCHAR2(100); 
    v_keyfld_mandatory    VARCHAR2(1);
    v_keyfld_cnt 		  number;
   	v_keyfld_cnd          VARCHAR2(4000);
    v_keyfld_joins        VARCHAR2(4000);

    -- Variables for dynamic SQL construction
    v_transid_primetable    VARCHAR2(100);
    v_transid_primetableid  VARCHAR2(100);    
    v_sql_permission_cnd  clob;
    v_sql_permission_dtls           CLOB; 
    v_sql_permission_exists CLOB;
    v_sql_fullcontrol     CLOB;

    -- Variables for counts and results
    v_menuaccess_count      NUMBER;
    v_permissionexists_count NUMBER;
    v_sql_permission_cnd_result NUMBER; 
    v_fullcontrol_recid   NUMBER;

    -- Variables to hold row data before piping
    v_fullcontrol         VARCHAR2(1);
    v_userrole            VARCHAR2(250);
    v_allowcreate         VARCHAR2(10);
    v_view_access         VARCHAR2(250);
    v_view_includedc      VARCHAR2(4000);
    v_view_excludedc      VARCHAR2(4000);
    v_view_includeflds    clob;
    v_excludeflds         VARCHAR2(4000); -- Use v_excludeflds for clarity
    v_edit_access         VARCHAR2(250);
    v_edit_includedc      VARCHAR2(4000);
    v_edit_excludedc      VARCHAR2(4000);
    v_edit_includeflds    clob;
    v_edit_excludeflds    clob;
    v_maskedflds          VARCHAR2(4000);
    v_filtercnd           NCLOB;
    v_recordid            NUMBER;
    v_viewctrl            VARCHAR2(10); -- To store rec.viewctrl
    v_editctrl            VARCHAR2(10); -- To store rec.editctrl
    --v_viewlist            VARCHAR2(4000); -- To store rec.viewlist
    --v_editlist            VARCHAR2(4000); -- To store rec.editlist
    v_encryptedflds clob;

   
    v_view_includedflds    CLOB;
    v_view_excludedflds    CLOB;
    v_edit_includedflds    CLOB;
    v_edit_excludedflds    CLOB;
    v_fieldmaskstr         CLOB;
    v_cnd                  NCLOB;        
   	v_permissiontype	varchar2(10);
   
BEGIN
	
	
	SELECT count(1)INTO v_keyfld_cnt FROM axpflds WHERE tstruct = ptransid AND fname = pkeyfld;
	
    IF v_keyfld_cnt > 0 then
	    SELECT srckey, srctf, srcfld, allowempty INTO v_keyfld_normalized, v_keyfld_srctbl, v_keyfld_srcfld, v_keyfld_mandatory
	    FROM axpflds WHERE tstruct = ptransid AND fname = pkeyfld;
	END IF;

    -- 2. Get primary table name from axpdc
    SELECT tablename
    INTO v_transid_primetable
    FROM axpdc
    WHERE tstruct = ptransid AND dname = 'dc1';

    -- 3. Determine the primary table ID field
    v_transid_primetableid := CASE WHEN LOWER(pkeyfld) = 'recordid' THEN v_transid_primetable || 'id' ELSE pkeyfld END;

    -- 4. Construct the key field condition (v_keyfld_cnd)
    v_keyfld_cnd := CASE WHEN v_keyfld_normalized = 'T'
                         THEN v_keyfld_srctbl || '.' || v_keyfld_srcfld
                         ELSE v_transid_primetable || '.' || v_transid_primetableid
                    END || '=' || pkeyvalue;

    -- 5. Construct the key field joins (v_keyfld_joins)
    v_keyfld_joins := NULL; -- Initialize to NULL
    IF v_keyfld_normalized = 'T' THEN
        v_keyfld_joins := CASE WHEN v_keyfld_mandatory = 'T' THEN ' JOIN ' ELSE ' LEFT JOIN ' END
                          || v_keyfld_srctbl || ' ' || pkeyfld || ' ON '
                          || v_transid_primetable || '.' || pkeyfld || '=' || v_keyfld_srctbl || '.' || v_keyfld_srctbl || 'id';
    END IF;

    -- 6. Calculate v_menuaccess_count (same logic as previous function)
    SELECT COUNT(*)
    INTO v_menuaccess_count
    FROM (
        SELECT 1 AS cnt FROM axusergroups a
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
        JOIN axuseraccess a2 ON b.roles_id = a2.rname AND a2.stype = 't'
        WHERE a2.sname = ptransid
          AND EXISTS (SELECT 1 FROM TABLE(string_to_array(proles, ',')) val WHERE val.COLUMN_VALUE = a.groupname)
        UNION ALL
        SELECT 1 FROM DUAL WHERE proles LIKE '%default%'
        UNION ALL
        SELECT 1 FROM axuserlevelgroups WHERE username = pusername AND usergroup = 'default'
        UNION ALL
        SELECT 1 AS cnt FROM axusergroups a
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
        JOIN axuseraccess a2 ON b.roles_id = a2.rname AND a2.stype = 't'
        JOIN axuserlevelgroups u ON a.groupname = u.usergroup AND u.username = pusername
        WHERE a2.sname = ptransid AND proles = 'All'
        UNION ALL
        SELECT 1 AS cnt FROM axusergroups a
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid        
        JOIN axuserlevelgroups u ON a.groupname = u.usergroup 
        where b.ROLES_ID ='default' AND u.USERNAME = pusername
    );

  
     if proles='All' then 

v_sql_permission_dtls := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl,''Role'' permissiontype
from AxPermissions a 
join axuserlevelgroups a2 on a2.axusergroup = a.axuserrole 
join axusers u on a2.axusersid = u.axusersid  
left join axusergrouping b on u.axusersid = b.axusersid
--left join (select b.axuserrole,b.cnd from axusers a join axuserpermissions b on a.axusersid =b.axusersid where a.username = '''||pusername||''')b on a.axuserrole=b.axuserrole  
where a.formtransid='''||ptransid||''' and u.username = '''||pusername||''' 
union all 
select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd cnd,viewctrl,allowcreate,editctrl,''User'' permissiontype 
from AxPermissions a 
left join axuserdpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||ptransid||'''';

v_sql_permission_exists :='select count(cnt)  from(select 1 cnt
from AxPermissions a 
join axuserlevelgroups a2 on a2.axusergroup = a.axuserrole 
join axusers u on a2.axusersid = u.axusersid  
--left join axuserpermissions b on a.axuserrole = b.axuserrole  
left join axusergrouping b on u.axusersid = b.axusersid
where a.formtransid='''||ptransid||''' and u.username = '''||pusername||''' 
union all 
select 1 cnt 
from AxPermissions a 
left join axuserdpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||ptransid||''')a';

else

v_sql_permission_dtls := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl,''Role'' permissiontype 
from AxPermissions a 
--left join (select b.axuserrole,b.cnd from axusers a join axuserpermissions b on a.axusersid =b.axusersid where a.username = '''||pusername||''')b on a.axuserrole=b.axuserrole
left join (
select a2.usergroup ,b.cnd1 cnd from axusers a join axuserlevelgroups a2 on a2.axusersid = a.axusersid left join axusergrouping b on a.axusersid =b.axusersid  where a.username = '''||pusername||''')b on a.axuserrole=b.usergroup
where exists (select 1 from table(string_to_array('''||proles||''','','')) where column_value in (a.axuserrole))
and a.formtransid='''||ptransid||'''   
union all
select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd cnd,viewctrl,allowcreate,editctrl,''User'' permissiontype 
from AxPermissions a left join axuserDpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||ptransid||'''';

v_sql_permission_exists := 'select count(cnt) from(select 1 cnt
from AxPermissions a left join axuserpermissions b on a.axuserrole = b.axuserrole 
left join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
left join (
select a2.usergroup ,b.cnd1 cnd from axusers a join axuserlevelgroups a2 on a2.axusersid = a.axusersid left join axusergrouping b on a.axusersid =b.axusersid  where a.username = '''||pusername||''')b on a.axuserrole=b.usergroup
where exists (select 1 from table(string_to_array('''||proles||''','','')) where column_value in (a.axuserrole))
and a.formtransid='''||ptransid||'''   
union all
select 1 cnt
from AxPermissions a left join axuserDpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||ptransid||''')a';

end if;
   
EXECUTE immediate v_sql_permission_exists into  v_permissionexists_count;

    IF v_menuaccess_count > 0 AND v_permissionexists_count = 0  THEN
        
        v_sql_fullcontrol := 'SELECT ' || v_transid_primetable || 'id FROM ' || v_transid_primetable || ' ' ||
                             COALESCE(v_keyfld_joins, '') || ' WHERE ' || REPLACE(v_keyfld_cnd, ' AND ', '');
                                                       

        EXECUTE IMMEDIATE v_sql_fullcontrol INTO v_fullcontrol_recid;

        v_fullcontrol := 'T';
        v_recordid := v_fullcontrol_recid;
        v_userrole := NULL;
        v_allowcreate := NULL;
        v_view_access := NULL;
        v_view_includedc := NULL;
        v_view_excludedc := NULL;
        v_view_includeflds := NULL;
        v_excludeflds := NULL;
        v_edit_access := NULL;
        v_edit_includedc := NULL;
        v_edit_excludedc := NULL;
        v_edit_includeflds := NULL;
        v_edit_excludeflds := NULL;
        v_maskedflds := NULL;
        v_filtercnd := NULL; 
       select listagg(fname,',') WITHIN group(order by ordno) INTO v_encryptedflds from axpflds where tstruct=ptransid AND encrypted='T';

        PIPE ROW (AXPDEF_PERMISSION_GETCND(
            v_fullcontrol, v_userrole, v_allowcreate, v_view_access,
            v_view_includedc, v_view_excludedc, v_view_includeflds, v_excludeflds,
            v_edit_access, v_edit_includedc, v_edit_excludedc, v_edit_includeflds, v_edit_excludeflds,
            v_maskedflds, v_filtercnd, v_recordid,v_encryptedflds,null));
     
	ELSE 

		OPEN rc FOR v_sql_permission_dtls;

    LOOP
      FETCH rc INTO  
		v_userrole,
        v_view_includedflds,
        v_view_excludedflds,
        v_edit_includedflds,
        v_edit_excludedflds,
        v_fieldmaskstr,
        v_cnd,
        v_viewctrl,
        v_allowcreate,
        v_editctrl,
        v_permissiontype;
        
       EXIT WHEN rc%NOTFOUND;

     v_sql_permission_cnd := ('select count(*),'||v_transid_primetable||'id'||' from '||v_transid_primetable||' '||v_keyfld_joins||' where '||v_keyfld_cnd||case when length(v_cnd) > 3 then ' and '||replace(v_cnd,'{primarytable.}',v_transid_primetable||'.') end||' group by '||v_transid_primetable||'id');

    	   
	execute IMMEDIATE v_sql_permission_cnd into v_sql_permission_cnd_result,v_recordid;

	IF v_sql_permission_cnd_result > 0 then
     
      IF v_viewctrl = '0' THEN        
        NULL;
      ELSE        
        v_view_includeflds := CASE WHEN v_view_includedflds IS NULL THEN v_edit_includedflds
                                 WHEN v_edit_includedflds IS NULL THEN v_view_includedflds
                                 ELSE v_view_includedflds || ',' || v_edit_includedflds END;
      END IF;
    
     
      IF v_editctrl = '0' THEN
         v_view_access := NULL;
      ELSIF v_viewctrl = '4' THEN
           v_view_access := 'None';
      ELSE
           v_view_access := NULL;      
      END IF;

      IF v_editctrl = '4' THEN
        v_edit_access := 'None';
      ELSE
        v_edit_access := NULL;
      END IF;
      
       SELECT LISTAGG(dname, ',') WITHIN GROUP (ORDER BY dname) INTO  v_view_includedc
FROM axpdc WHERE tstruct = ptransid
  AND (v_view_includeflds IS NOT NULL  and INSTR(',' || v_view_includeflds || ',',',' || dname || ',') > 0);
           
 
            SELECT LISTAGG(fname, ',') WITHIN GROUP (ORDER BY fname) INTO  v_view_includeflds
FROM axpflds WHERE tstruct = ptransid AND savevalue = 'T' 
  AND (v_view_includeflds IS NOT NULL  and INSTR(',' || v_view_includeflds || ',',',' || fname || ',') > 0);
           
 
      SELECT LISTAGG(dname, ',') WITHIN GROUP (ORDER BY dname) INTO  v_view_excludedc
FROM axpdc WHERE tstruct = ptransid
  AND (v_view_excludedflds IS NOT NULL  and INSTR(',' || v_view_excludedflds || ',',',' || dname || ',') > 0);
 
           
 SELECT LISTAGG(fname, ',') WITHIN GROUP (ORDER BY fname) INTO  v_excludeflds
FROM axpflds WHERE tstruct = ptransid AND savevalue = 'T' 
  AND (v_view_excludedflds IS NOT NULL  and INSTR(',' || v_view_excludedflds || ',',',' || fname || ',') > 0);
 
         SELECT LISTAGG(dname, ',') WITHIN GROUP (ORDER BY dname) INTO  v_edit_includedc
FROM axpdc WHERE tstruct = ptransid
  AND (v_edit_includedflds IS NOT NULL  and INSTR(',' || v_edit_includedflds || ',',',' || dname || ',') > 0);
               
   SELECT LISTAGG(fname, ',') WITHIN GROUP (ORDER BY fname) INTO  v_edit_includeflds
FROM axpflds WHERE tstruct = ptransid AND savevalue = 'T' 
  AND (v_edit_includedflds IS NOT NULL  and INSTR(',' || v_edit_includedflds || ',',',' || fname || ',') > 0);   
   
          SELECT LISTAGG(dname, ',') WITHIN GROUP (ORDER BY dname) INTO  v_edit_excludedc
FROM axpdc WHERE tstruct = ptransid
  AND (v_edit_excludedflds IS NOT NULL  and INSTR(',' || v_edit_excludedflds || ',',',' || dname || ',') > 0);
                        
   SELECT LISTAGG(fname, ',') WITHIN GROUP (ORDER BY fname) INTO  v_edit_excludeflds
FROM axpflds WHERE tstruct = ptransid AND savevalue = 'T' 
  AND (v_edit_excludedflds IS NOT NULL  and INSTR(',' || v_edit_excludedflds || ',',',' || fname || ',') > 0);   
                       
      
    SELECT LISTAGG(fname, ',') WITHIN GROUP (ORDER BY fname) INTO  v_encryptedflds
FROM axpflds WHERE tstruct = ptransid AND encrypted = 'T' 
  AND (v_view_includeflds IS NOT NULL  and INSTR(',' || v_view_includeflds || ',',',' || fname || ',') > 0);   

           
      v_fullcontrol := NULL; 
      v_maskedflds:=v_fieldmaskstr;
      v_filtercnd:=v_cnd;

     PIPE ROW (AXPDEF_PERMISSION_GETCND(
                v_fullcontrol, v_userrole, v_allowcreate, v_view_access,
                v_view_includedc, v_view_excludedc, v_view_includeflds, v_excludeflds,
                v_edit_access, v_edit_includedc, v_edit_excludedc, v_edit_includeflds, v_edit_excludeflds,
                v_maskedflds, v_filtercnd,v_recordid,v_encryptedflds,v_permissiontype));
               END IF;
  END LOOP;
 CLOSE rc;
	 	END if;	
	-- EXCEPTION WHEN OTHERS THEN null;
	 
    RETURN; -- End of function
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getpermission(
    pmode          IN VARCHAR2,
    ptransid       IN VARCHAR2,
    pusername      IN VARCHAR2,
    proles         IN VARCHAR2 DEFAULT 'All',
    pglobalvars    IN VARCHAR2 DEFAULT 'NA'
) RETURN AXPDEF_PERMISSION_MDATA_OBJ PIPELINED
AS    
	rc  SYS_REFCURSOR;
    -- Declare local variables
    v_menuaccess_count NUMBER(10);    
    v_sql_roles VARCHAR2(4000);
   -- v_sql_permission_check VARCHAR2(4000);
   	rolesql clob;
   	v_permissionsql clob;
   	v_permissionexists number(10);
    
    -- Variables to hold results before piping
    v_transid_loop VARCHAR2(250);
    v_fullcontrol VARCHAR2(1);
    v_userrole VARCHAR2(250);
    v_allowcreate VARCHAR2(10);
    v_view_access VARCHAR2(250);
    v_view_includedc VARCHAR2(4000);
    v_view_excludedc VARCHAR2(4000);
    v_view_includeflds clob;
    v_view_excludeflds clob; 
    v_edit_access VARCHAR2(250);
    v_edit_includedc VARCHAR2(4000);
    v_edit_excludedc VARCHAR2(4000);
    v_edit_includeflds clob;
    v_edit_excludeflds clob;
    v_maskedflds clob;
    v_filtercnd NCLOB;
    v_viewctrl VARCHAR2(1);
    v_editctrl VARCHAR2(1);
    --v_viewlist VARCHAR2(4000);
    --v_editlist VARCHAR2(4000);
   	v_encryptedflds clob;
  	v_permissiontype varchar2(10);
    	
    v_view_includedflds    clob;
    v_view_excludedflds    clob;
    v_edit_includedflds    clob;
    v_edit_excludedflds    clob;
    v_fieldmaskstr         clob;
    v_cnd                  NCLOB;              
   


BEGIN
    -- Loop through each transid in the comma-separated string
    FOR rec_transid IN (SELECT COLUMN_VALUE AS transid FROM TABLE(string_to_array(ptransid, ','))) LOOP
        v_transid_loop := rec_transid.transid; 

        
        SELECT COUNT(*)
        INTO v_menuaccess_count
        FROM (
            SELECT 1 AS cnt
            FROM axusergroups a
            JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
            JOIN axuseraccess a2 ON b.roles_id = a2.rname AND a2.stype = 't'
            WHERE a2.sname = v_transid_loop
              AND EXISTS (SELECT 1 FROM TABLE(string_to_array(proles, ',')) val WHERE val.COLUMN_VALUE = a.groupname)
            UNION ALL
            SELECT 1 FROM DUAL WHERE proles LIKE '%default%'
            UNION ALL
            SELECT 1 FROM axuserlevelgroups WHERE username = pusername AND usergroup = 'default'
            UNION ALL
            SELECT 1 AS cnt
            FROM axusergroups a
            JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
            JOIN axuseraccess a2 ON b.roles_id = a2.rname AND a2.stype = 't'
            JOIN axuserlevelgroups u ON a.groupname = u.usergroup AND u.username = pusername
            WHERE a2.sname = v_transid_loop AND proles = 'All'
               UNION ALL
        SELECT 1 AS cnt FROM axusergroups a
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid        
        JOIN axuserlevelgroups u ON a.groupname = u.usergroup 
        where b.ROLES_ID ='default' AND u.USERNAME = pusername
        );

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
where a.formtransid='''||rec_transid.transid||''' and u.username = '''||pusername||''' 
union all 
select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd cnd,viewctrl,allowcreate,editctrl,''User'' permissiontype 
from AxPermissions a 
left join axuserdpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||rec_transid.transid||'''';

v_permissionsql :='select count(cnt)  from(select 1 cnt
from AxPermissions a 
join axuserlevelgroups a2 on a2.axusergroup = a.axuserrole 
join axusers u on a2.axusersid = u.axusersid  
--left join axuserpermissions b on a.axuserrole = b.axuserrole  
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
--left join (select b.axuserrole,b.cnd from axusers a join axuserpermissions b on a.axusersid =b.axusersid where a.username = '''||pusername||''')b on a.axuserrole=b.axuserrole
left join (
select a2.usergroup ,b.cnd1 cnd from axusers a join axuserlevelgroups a2 on a2.axusersid = a.axusersid left join axusergrouping b on a.axusersid =b.axusersid  where a.username = '''||pusername||''')b on a.axuserrole=b.usergroup
where exists (select 1 from table(string_to_array('''||proles||''','','')) where column_value in (a.axuserrole))
and a.formtransid='''||rec_transid.transid||'''   
union all
select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd cnd,viewctrl,allowcreate,editctrl,''User'' permissiontype 
from AxPermissions a left join axuserDpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||rec_transid.transid||'''';

v_permissionsql := 'select count(cnt) from(select 1 cnt
from AxPermissions a left join axuserpermissions b on a.axuserrole = b.axuserrole 
left join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
left join (
select a2.usergroup ,b.cnd1 cnd from axusers a join axuserlevelgroups a2 on a2.axusersid = a.axusersid left join axusergrouping b on a.axusersid =b.axusersid  where a.username = '''||pusername||''')b on a.axuserrole=b.usergroup
where exists (select 1 from table(string_to_array('''||proles||''','','')) where column_value in (a.axuserrole))
and a.formtransid='''||rec_transid.transid||'''   
union all
select 1 cnt
from AxPermissions a left join axuserDpermissions b on a.AxPermissionsid = b.AxPermissionsid 
where a.axusername = '''||pusername||''' and a.formtransid='''||rec_transid.transid||''')a';

end if;

EXECUTE immediate v_permissionsql into  v_permissionexists;

        IF v_menuaccess_count > 0 AND v_permissionexists = 0 
        THEN            
            v_fullcontrol := 'T';
            v_userrole := NULL;
            v_view_includedc := NULL;
            v_view_excludedc := NULL;
            v_view_includeflds := NULL;
            v_view_excludeflds := NULL;
            v_edit_includedc := NULL;
            v_edit_excludedc := NULL;
            v_edit_includeflds := NULL;
            v_edit_excludeflds := NULL; 
            v_maskedflds := NULL;
            v_view_access := NULL;
            v_edit_access := NULL;
            v_allowcreate := NULL;
            v_filtercnd := NULL;
           	SELECT LISTAGG(fname, ',') WITHIN GROUP (ORDER BY fname) INTO v_encryptedflds FROM axpflds WHERE tstruct = v_transid_loop AND encrypted = 'T';           	

            -- Pipe the row
            PIPE ROW (AXPDEF_PERMISSION_MDATA(
                v_transid_loop, v_fullcontrol, v_userrole, v_allowcreate, v_view_access,
                v_view_includedc, v_view_excludedc, v_view_includeflds, v_view_excludeflds,
                v_edit_access, v_edit_includedc, v_edit_excludedc, v_edit_includeflds, v_edit_excludeflds,
                v_maskedflds, v_filtercnd,v_encryptedflds,null));
               
ELSE
	OPEN rc FOR rolesql;

    LOOP
      FETCH rc INTO  
		v_userrole,
        v_view_includedflds,
        v_view_excludedflds,
        v_edit_includedflds,
        v_edit_excludedflds,
        v_fieldmaskstr,
        v_cnd,
        v_viewctrl,
        v_allowcreate,
        v_editctrl,
        v_permissiontype;
        
       EXIT WHEN rc%NOTFOUND;

     
     
      IF v_viewctrl = '0' THEN        
        NULL;
      ELSE        
        v_view_includeflds := CASE WHEN v_view_includedflds IS NULL THEN v_edit_includedflds
                                 WHEN v_edit_includedflds IS NULL THEN v_view_includedflds
                                 ELSE v_view_includedflds || ',' || v_edit_includedflds END;
	  END IF;
    
     
      IF v_editctrl = '0' THEN
         v_view_access := NULL;
      ELSIF v_viewctrl = '4' THEN
           v_view_access := 'None';
      ELSE
           v_view_access := NULL;      
      END IF;

      IF v_editctrl = '4' THEN
        v_edit_access := 'None';
      ELSE
        v_edit_access := NULL;
      END IF;
     
     
     
           SELECT LISTAGG(dname, ',') WITHIN GROUP (ORDER BY dname) INTO  v_view_includedc
FROM axpdc WHERE tstruct = rec_transid.transid
  AND (v_view_includeflds IS NOT NULL  and INSTR(',' || v_view_includeflds || ',',',' || dname || ',') > 0);
           
 
            SELECT LISTAGG(fname, ',') WITHIN GROUP (ORDER BY fname) INTO  v_view_includeflds
FROM axpflds WHERE tstruct = rec_transid.transid AND savevalue = 'T' 
  AND (v_view_includeflds IS NOT NULL  and INSTR(',' || v_view_includeflds || ',',',' || fname || ',') > 0);
           
 
      SELECT LISTAGG(dname, ',') WITHIN GROUP (ORDER BY dname) INTO  v_view_excludedc
FROM axpdc WHERE tstruct = rec_transid.transid
  AND (v_view_excludedflds IS NOT NULL  and INSTR(',' || v_view_excludedflds || ',',',' || dname || ',') > 0);
 
           
 SELECT LISTAGG(fname, ',') WITHIN GROUP (ORDER BY fname) INTO  v_view_excludeflds
FROM axpflds WHERE tstruct = rec_transid.transid AND savevalue = 'T' 
  AND (v_view_excludedflds IS NOT NULL  and INSTR(',' || v_view_excludedflds || ',',',' || fname || ',') > 0);
 
         SELECT LISTAGG(dname, ',') WITHIN GROUP (ORDER BY dname) INTO  v_edit_includedc
FROM axpdc WHERE tstruct = rec_transid.transid
  AND (v_edit_includedflds IS NOT NULL  and INSTR(',' || v_edit_includedflds || ',',',' || dname || ',') > 0);
               
   SELECT LISTAGG(fname, ',') WITHIN GROUP (ORDER BY fname) INTO  v_edit_includeflds
FROM axpflds WHERE tstruct = rec_transid.transid AND savevalue = 'T' 
  AND (v_edit_includedflds IS NOT NULL  and INSTR(',' || v_edit_includedflds || ',',',' || fname || ',') > 0);   
   
          SELECT LISTAGG(dname, ',') WITHIN GROUP (ORDER BY dname) INTO  v_edit_excludedc
FROM axpdc WHERE tstruct = rec_transid.transid
  AND (v_edit_excludedflds IS NOT NULL  and INSTR(',' || v_edit_excludedflds || ',',',' || dname || ',') > 0);
                        
   SELECT LISTAGG(fname, ',') WITHIN GROUP (ORDER BY fname) INTO  v_edit_excludeflds
FROM axpflds WHERE tstruct = rec_transid.transid AND savevalue = 'T' 
  AND (v_edit_excludedflds IS NOT NULL  and INSTR(',' || v_edit_excludedflds || ',',',' || fname || ',') > 0);   
                       
      
    SELECT LISTAGG(fname, ',') WITHIN GROUP (ORDER BY fname) INTO  v_encryptedflds
FROM axpflds WHERE tstruct = rec_transid.transid AND encrypted = 'T' 
  AND (v_view_includeflds IS NOT NULL  and INSTR(',' || v_view_includeflds || ',',',' || fname || ',') > 0);   
 
                 
      v_fullcontrol := NULL; 
      v_maskedflds:=v_fieldmaskstr;
      v_filtercnd:=v_cnd;

     PIPE ROW (AXPDEF_PERMISSION_MDATA( 
                v_transid_loop, v_fullcontrol, v_userrole, v_allowcreate, v_view_access,
                v_view_includedc, v_view_excludedc, v_view_includeflds, v_view_excludeflds,
                v_edit_access, v_edit_includedc, v_edit_excludedc, v_edit_includeflds, v_edit_excludeflds,
                v_maskedflds, v_filtercnd,v_encryptedflds,v_permissiontype));

      

    END LOOP;

    CLOSE rc;
               
 	END if;

  END LOOP;

        
     


    RETURN; 
END;
>>
