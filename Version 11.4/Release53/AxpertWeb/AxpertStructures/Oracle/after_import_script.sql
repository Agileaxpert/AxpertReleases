<<
delete from axdirectsql a  where sqlname in('ds_homepage_quicklinks','ds_homepage_recentactivities')
>>


<<
delete from axp_cards ac where card_datasource in('ds_homepage_quicklinks','ds_homepage_recentactivities')
>>


<<
CREATE OR REPLACE TRIGGER trg_axpdef_peg_processmaster
AFTER INSERT ON axpdef_peg_processmaster
FOR EACH ROW
DECLARE
    v_processtable VARCHAR2(128); 
    v_sql          VARCHAR2(32767);
    v_table_exists NUMBER;
    
    PRAGMA AUTONOMOUS_TRANSACTION; 
BEGIN
    v_processtable := :new.PROCESSTABLE; 
    IF v_processtable IS NOT NULL THEN
        SELECT COUNT(*)
        INTO v_table_exists
        FROM user_tables
        WHERE table_name = UPPER(v_processtable);

        IF v_table_exists = 0 THEN
            v_sql := 'CREATE TABLE ' || DBMS_ASSERT.ENQUOTE_NAME(v_processtable, FALSE) || ' ('
                  || '  eventdatetime VARCHAR2(30), '
                  || '  taskid        VARCHAR2(15), '
                  || '  transid       VARCHAR2(8), '
                  || '  processname   VARCHAR2(500), '
                  || '  taskname      VARCHAR2(500), '
                  || '  keyvalue      VARCHAR2(500), '
                  || '  taskstatus    VARCHAR2(15), '
                  || '  tasktype      VARCHAR2(15), '
                  || '  username      VARCHAR2(50), '
                  || '  nexttask      VARCHAR2(1000), '
                  || '  displayicon   VARCHAR2(500), '
                  || '  displaytitle  NCLOB, '
                  || '  indexno       NUMBER(3), '
                  || '  keyfield      VARCHAR2(200), '
                  || '  recordid      NUMBER(38), '
                  || '  TimelineTitle VARCHAR2(4000) '
                  || ')';

            EXECUTE IMMEDIATE v_sql;
            
            COMMIT; 
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
>>


<<
CREATE OR REPLACE TRIGGER trg_axprocessdefv2
BEFORE INSERT OR UPDATE ON axprocessdefv2 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare 
    v_rem_esc_sfrom varchar2(4000);
    v_rem_esc_taskparam varchar2(4000);
     
BEGIN 
     
    select listagg(sfrom,',') WITHIN GROUP (ORDER BY 1),
    listagg(rtrim(substr(sfrom,INSTR(sfrom,'-(')+2),')'),',') 
    WITHIN GROUP (ORDER BY 1)
  into v_rem_esc_sfrom,  v_rem_esc_taskparam 
  from 
    (SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.rem_esc_startfrom, '[^,]+', 1, LEVEL)) AS sfrom
  from dual   
  CONNECT BY REGEXP_SUBSTR (:NEW.rem_esc_startfrom,'[^,]+',1,LEVEL) IS NOT NULL );
   
   

        IF INSERTING AND LENGTH(nvl(v_rem_esc_sfrom,'N')) > 2 
        THEN
  
  :new.taskparamsui := :new.taskparamsui||','||v_rem_esc_sfrom;
  :new.taskparams := :new.taskparams||','||v_rem_esc_taskparam;
  
  
  end if;
   
  IF UPDATING AND LENGTH(nvl(v_rem_esc_sfrom,'N')) > 2 
  THEN
  
  :new.taskparamsui := :new.taskparamsui||','||v_rem_esc_sfrom;
  :new.taskparams :=:new.taskparams||','||v_rem_esc_taskparam;
    
  end if;
 
  IF updating AND :OLD.indexno = :NEW.indexno-1 THEN
   :NEW.indexno := :NEW.indexno - 1;
  
  END IF;
 
 
  
end;
>>

<<
CREATE SEQUENCE SEQ_AXDB_RECORDID INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER
>>

<<
DROP TYPE AXPDEF_PERMISSION_GETCND_OBJ
>>

<<
DROP TYPE AXPDEF_PERMISSION_GETCND
>>

<<
CREATE OR REPLACE TYPE "AXPDEF_PERMISSION_GETCND" AS OBJECT (
    fullcontrol VARCHAR2(1),
    userrole VARCHAR2(250),
    allowcreate VARCHAR2(10),
    view_access VARCHAR2(250),
    view_includedc VARCHAR2(4000),
    view_excludedc VARCHAR2(4000),
    view_includeflds clob,
    view_excludeflds clob,
    edit_access VARCHAR2(250),
    edit_includedc VARCHAR2(4000),
    edit_excludedc VARCHAR2(4000),
    edit_includeflds clob,
    edit_excludeflds clob,
    maskedflds clob,
    filtercnd NCLOB,
    recordid NUMBER,
    encryptedflds clob,
   PERMISSIONTYPE varchar2(10)
    );
>>

<<
CREATE OR REPLACE
TYPE "AXPDEF_PERMISSION_GETCND_OBJ" AS TABLE OF AXPDEF_PERMISSION_GETCND
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
    v_excludeflds         VARCHAR2(4000); 
    v_edit_access         VARCHAR2(250);
    v_edit_includedc      VARCHAR2(4000);
    v_edit_excludedc      VARCHAR2(4000);
    v_edit_includeflds    clob;
    v_edit_excludeflds    clob;
    v_maskedflds          VARCHAR2(4000);
    v_filtercnd           NCLOB;
    v_recordid            NUMBER;
    v_viewctrl            VARCHAR2(10); 
    v_editctrl            VARCHAR2(10); 
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


    SELECT tablename
    INTO v_transid_primetable
    FROM axpdc
    WHERE tstruct = ptransid AND dname = 'dc1';


    v_transid_primetableid := CASE WHEN LOWER(pkeyfld) = 'recordid' THEN v_transid_primetable || 'id' ELSE pkeyfld END;


    v_keyfld_cnd := CASE WHEN v_keyfld_normalized = 'T'
                         THEN v_keyfld_srctbl || '.' || v_keyfld_srcfld
                         ELSE v_transid_primetable || '.' || v_transid_primetableid
                    END || '=' || pkeyvalue;


    v_keyfld_joins := NULL; 
    IF v_keyfld_normalized = 'T' THEN
        v_keyfld_joins := CASE WHEN v_keyfld_mandatory = 'T' THEN ' JOIN ' ELSE ' LEFT JOIN ' END
                          || v_keyfld_srctbl || ' ' || pkeyfld || ' ON '
                          || v_transid_primetable || '.' || pkeyfld || '=' || v_keyfld_srctbl || '.' || v_keyfld_srctbl || 'id';
    END IF;


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

	 
    RETURN;
END;
>>

<<
DROP TYPE AXPDEF_PERMISSION_MDATA_OBJ
>>

<<
DROP TYPE AXPDEF_PERMISSION_MDATA
>>

<<
CREATE OR REPLACE TYPE "AXPDEF_PERMISSION_MDATA" AS OBJECT (
    transid VARCHAR2(250),
    fullcontrol VARCHAR2(1),
    userrole VARCHAR2(250),
    allowcreate VARCHAR2(3),
    view_access VARCHAR2(250),
    view_includedc VARCHAR2(4000),
    view_excludedc VARCHAR2(4000),
    view_includeflds clob,
    view_excludeflds clob,
    edit_access VARCHAR2(250),
    edit_includedc VARCHAR2(4000),
    edit_excludedc VARCHAR2(4000),
    edit_includeflds clob,
    edit_excludeflds clob,
    maskedflds clob,
    filtercnd NCLOB,
    encryptedflds clob,
    permissiontype varchar2(10),viewctrl varchar2(10),editctrl varchar2(10)
    );
>>

<<
CREATE OR REPLACE TYPE "AXPDEF_PERMISSION_MDATA_OBJ"                                          
   AS TABLE OF AXPDEF_PERMISSION_MDATA
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
           	SELECT LISTAGG(fname, ',') WITHIN GROUP (ORDER BY fname) INTO v_encryptedflds FROM axpflds 
           WHERE tstruct = v_transid_loop AND encrypted = 'T';        
          	

            -- Pipe the row
            PIPE ROW (AXPDEF_PERMISSION_MDATA(
                v_transid_loop, v_fullcontrol, v_userrole, v_allowcreate, v_view_access,
                v_view_includedc, v_view_excludedc, v_view_includeflds, v_view_excludeflds,
                v_edit_access, v_edit_includedc, v_edit_excludedc, v_edit_includeflds, v_edit_excludeflds,
                v_maskedflds, v_filtercnd,v_encryptedflds,NULL,'0','0'));
               
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
                v_maskedflds, v_filtercnd,v_encryptedflds,v_permissiontype,v_viewctrl,v_editctrl));


    END LOOP;

    CLOSE rc;
               
 	END if;

  END LOOP;

    RETURN; 
END;
>>

<<
DROP TYPE FN_AXDBGET_TABLE
>>

<<
DROP TYPE FN_AXDBGET_ROW
>>

<<
CREATE OR REPLACE TYPE "FN_AXDBGET_ROW" AS OBJECT (
  transid   VARCHAR2(200),
  dcno      VARCHAR2(200),
  griddc    VARCHAR2(10),
  sqltext   CLOB
)
>>

<<
CREATE OR REPLACE TYPE "FN_AXDBGET_TABLE" AS TABLE OF fn_axdbget_row
>>


<<
CREATE OR REPLACE FUNCTION FN_AXDBPUT_GETRECID(
    psiteno    IN NUMBER,
    pnoofrows  IN NUMBER
)
RETURN SYS.ODCIVARCHAR2LIST
AS
    v_list    SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
    v_seq_num NUMBER;
    v_final   VARCHAR2(30);
   	v_pad_length  NUMBER;
	v_pad_sitelength NUMBER;
BEGIN
    v_list.EXTEND(pnoofrows);

    FOR i IN 1 .. pnoofrows LOOP
    
        v_seq_num := seq_axdb_recordid.NEXTVAL;
       	v_pad_length := 12;
       	v_pad_sitelength := 3;
       
       	v_final := rpad(psiteno,v_pad_sitelength,'0') || LPAD(v_seq_num, v_pad_length, '0');
       
        v_list(i) := v_final;
    END LOOP;

    RETURN v_list;
END;
>>
 
<<
CREATE OR REPLACE FUNCTION fn_axdbget(ptransid varchar2,precordid NUMERIC DEFAULT 0)
RETURN fn_axdbget_table PIPELINED
IS 
 
v_sql clob;
v_sql1 clob;
v_primarydctable  varchar2(3000);
v_fldnamesary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_join  varchar2(3000);
v_fldname_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_col  varchar2(3000);
v_fldname_normalized  varchar2(3000);
v_fldname_srctbl  varchar2(3000);
v_fldname_srcfld  varchar2(3000); 
v_fldname_allowempty  varchar2(3000); 
v_fldname_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_dctablename varchar2(3000);
v_fldname_dcflds varchar2(4000);
v_fldname_transidcnd number;
v_fldname_dctables SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_normalizedtables SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_allflds  varchar2(4000);
t_temp_field_list clob;
v_final_sqls SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dcdefaultcols     VARCHAR2(4000);
v_fldnames_str      VARCHAR2(32767);
v_emptyary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_griddc_orderby varchar2(200);
 BEGIN 
 
 
 select lower(tablename) into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1'; 


            
   FOR rec in(    SELECT LISTAGG(dname, ',') WITHIN GROUP (ORDER BY dname) AS dname,
           asgrid,
           LOWER(tablename) AS tablename
      FROM axpdc
     WHERE tstruct = ptransid
     GROUP BY asgrid, LOWER(tablename)
     ORDER BY 1)
     loop
      select tablename||'='||listagg(str,'|')WITHIN GROUP(order by  dcname ,ordno)   into  v_allflds From( 
   select tablename,fname||'~'||srckey||'~'||srctf||'~'||srcfld||'~'||allowempty str,
             dcname ,ordno   
    from axpflds where tstruct=ptransid and lower(tablename)=rec.tablename
    AND savevalue='T' and datatype !='i' 
   UNION ALL
   select tablename,fname||' '||fname||'_sourceid'||'~'||'F'||'~'||srctf||'~'||srcfld||'~'||allowempty str,
             dcname ,ordno   
    from axpflds where tstruct=ptransid and lower(tablename)=rec.tablename
    AND savevalue='T' and datatype !='i' AND srckey='T'
    ORDER BY dcname,ordno)GROUP BY tablename;
   
   IF length(v_allflds) > 1 THEN 
  IF rec.tablename = v_primarydctable THEN
       v_dcdefaultcols := v_primarydctable || '.'|| v_primarydctable || 'id,'
                         || v_primarydctable || '.cancel,'|| v_primarydctable || '.sourceid,'|| v_primarydctable || '.mapname,'
                         || v_primarydctable || '.username,'|| v_primarydctable || '.modifiedon,'|| v_primarydctable || '.createdby,'
                         || v_primarydctable || '.createdon,'|| v_primarydctable || '.wkid,'|| v_primarydctable || '.app_level,'
                         || v_primarydctable || '.app_desc,'|| v_primarydctable || '.app_slevel,'|| v_primarydctable || '.cancelremarks,'
                         || v_primarydctable || '.wfroles';
     ELSIF rec.asgrid = 'F' and rec.tablename != v_primarydctable THEN
         v_dcdefaultcols := rec.tablename ||'.'|| v_primarydctable||'id,'||rec.tablename||'.'||rec.tablename||'id';
       ELSIF rec.asgrid = 'T' and rec.tablename != v_primarydctable THEN 
         v_dcdefaultcols := rec.tablename ||'.'|| v_primarydctable||'id,'||rec.tablename||'.'||rec.tablename||'id,'||rec.tablename||'.'||rec.tablename||'row';    
         v_griddc_orderby := (' order by '||rec.tablename||'row');
     END IF;
      
      
      
  FOR rec1 in  (select column_value as fldname from table(string_to_array( split_part(v_allflds,'=',2),'|')))
loop       
     v_fldname_col := split_part(rec1.fldname,'~',1);
     v_fldname_normalized := split_part(rec1.fldname,'~',2);
     v_fldname_srctbl := split_part(rec1.fldname,'~',3);
     v_fldname_srcfld := split_part(rec1.fldname,'~',4);     
     v_fldname_allowempty := split_part(rec1.fldname,'~',5);
     
     if v_fldname_normalized ='F'  then
                         v_fldnamesary.EXTEND;
                         v_fldnamesary(v_fldnamesary.COUNT) := (rec.tablename||'.'||v_fldname_col);     
     elsif v_fldname_normalized ='T' then
                         v_fldnamesary.EXTEND;
       v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_col||'.'||v_fldname_srcfld||' '||v_fldname_col);
                         v_fldname_joinsary.EXTEND;
       v_fldname_joinsary(v_fldname_joinsary.count) := (CASE WHEN v_fldname_allowempty='F' THEN ' join ' ELSE ' left join ' end||v_fldname_srctbl||' '||v_fldname_col||' on '||rec.tablename||'.'||v_fldname_col||' = '||v_fldname_col||'.'||v_fldname_srctbl||'id');
     end if;
       end loop;
      
            
                v_sql := (' select '||v_dcdefaultcols||','||array_to_string(v_fldnamesary,',')||' from '||rec.tablename 
        ||' '||array_to_string(v_fldname_joinsary,' ')||' where '||rec.tablename||'.'||v_primarydctable||'id = :recordid '||v_griddc_orderby);
     
              
              
 
        PIPE ROW(
        fn_axdbget_row(
          transid => ptransid,
          dcno    => rec.dname,
          griddc  => rec.asgrid,
          sqltext => v_sql
        )
      );
     
     v_fldnamesary:= v_emptyary;
 v_fldname_joinsary:= v_emptyary;   
 v_griddc_orderby := NULL;     
END IF;
     
END LOOP;
   
 
return;
 END;
>>
 