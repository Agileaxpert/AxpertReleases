<<
DROP TYPE AXPDEF_PERMISSION_GETCND_OBJ
>>

<<
DROP TYPE AXPDEF_PERMISSION_GETCND
>>

<<
DROP TYPE AXPDEF_PERMISSION_MDATA_OBJ
>>

<<
DROP TYPE AXPDEF_PERMISSION_MDATA
>>


<<
CREATE OR REPLACE TYPE "AXPDEF_PERMISSION_GETCND"                                          AS OBJECT (
    fullcontrol VARCHAR2(1),
    userrole VARCHAR2(250),
    allowcreate VARCHAR2(10),
    view_access VARCHAR2(250),
    view_includedc VARCHAR2(4000),
    view_excludedc VARCHAR2(4000),
    view_includeflds VARCHAR2(4000),
    view_excludeflds VARCHAR2(4000),
    edit_access VARCHAR2(250),
    edit_includedc VARCHAR2(4000),
    edit_excludedc VARCHAR2(4000),
    edit_includeflds VARCHAR2(4000),
    edit_excludeflds VARCHAR2(4000),
    maskedflds VARCHAR2(4000),
    filtercnd NCLOB,
    recordid NUMBER,
    encryptedflds varchar2(4000),
   PERMISSIONTYPE varchar2(10)
    );
>>

<<

CREATE OR REPLACE TYPE "AXPDEF_PERMISSION_GETCND_OBJ"                                          AS TABLE OF AXPDEF_PERMISSION_GETCND;

>>

<<

CREATE OR REPLACE TYPE "AXPDEF_PERMISSION_MDATA"                                          AS OBJECT (
    transid VARCHAR2(250),
    fullcontrol VARCHAR2(1),
    userrole VARCHAR2(250),
    allowcreate VARCHAR2(3),
    view_access VARCHAR2(250),
    view_includedc VARCHAR2(4000),
    view_excludedc VARCHAR2(4000),
    view_includeflds VARCHAR2(4000),
    view_excludeflds VARCHAR2(4000),
    edit_access VARCHAR2(250),
    edit_includedc VARCHAR2(4000),
    edit_excludedc VARCHAR2(4000),
    edit_includeflds VARCHAR2(4000),
    edit_excludeflds VARCHAR2(4000),
    maskedflds VARCHAR2(4000),
    filtercnd NCLOB,
    encryptedflds varchar2(4000),
    permissiontype varchar2(10)
    );

>>

<<

CREATE OR REPLACE TYPE "AXPDEF_PERMISSION_MDATA_OBJ"                                          AS TABLE OF AXPDEF_PERMISSION_MDATA;

>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getpermission(
    pmode          IN VARCHAR2,
    ptransid       IN VARCHAR2,
    pusername      IN VARCHAR2,
    proles         IN VARCHAR2 DEFAULT 'All'
) RETURN AXPDEF_PERMISSION_MDATA_OBJ PIPELINED
AS    
    v_menuaccess_count NUMBER;
    v_permission_exists_count NUMBER;
    v_sql_roles VARCHAR2(4000);
    v_sql_permission_check VARCHAR2(4000);
    v_transid_loop VARCHAR2(250);
    v_fullcontrol VARCHAR2(1);
    v_userrole VARCHAR2(250);
    v_allowcreate VARCHAR2(1);
    v_view_access VARCHAR2(250);
    v_view_includedc VARCHAR2(4000);
    v_view_excludedc VARCHAR2(4000);
    v_view_includeflds VARCHAR2(4000);
    v_view_excludeflds VARCHAR2(4000);
    v_edit_access VARCHAR2(250);
    v_edit_includedc VARCHAR2(4000);
    v_edit_excludedc VARCHAR2(4000);
    v_edit_includeflds VARCHAR2(4000);
    v_edit_excludeflds VARCHAR2(4000);
    v_maskedflds VARCHAR2(4000);
    v_filtercnd CLOB;
    v_viewctrl VARCHAR2(10);
    v_editctrl VARCHAR2(10);
    v_viewlist VARCHAR2(4000);
    v_editlist VARCHAR2(4000);
	v_encryptedflds VARCHAR2(4000);
BEGIN
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
            SELECT 1 AS cnt FROM axusergroups a
            JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
            JOIN axuseraccess a2 ON b.roles_id = a2.rname AND a2.stype = 't'
            JOIN axuserlevelgroups u ON a.groupname = u.usergroup AND u.username = pusername
            WHERE a2.sname = v_transid_loop AND proles = 'All');



        IF v_menuaccess_count > 0 THEN            
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

            PIPE ROW (AXPDEF_PERMISSION_MDATA(
                v_transid_loop, v_fullcontrol, v_userrole, v_allowcreate, v_view_access,
                v_view_includedc, v_view_excludedc, v_view_includeflds, v_view_excludeflds,
                v_edit_access, v_edit_includedc, v_edit_excludedc, v_edit_includeflds, v_edit_excludeflds,
                v_maskedflds, v_filtercnd,v_encryptedflds,null));

        END if;

    END LOOP;

    RETURN;

END;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getcnd(
    pmode         IN VARCHAR2,
    ptransid      IN VARCHAR2,
    pkeyfld       IN VARCHAR2,
    pkeyvalue     IN VARCHAR2,
    pusername     IN VARCHAR2,
    proles        IN VARCHAR2 DEFAULT 'All'
) RETURN AXPDEF_PERMISSION_GETCND_OBJ PIPELINED
AS
    v_keyfld_normalized   VARCHAR2(1);
    v_keyfld_srctbl       VARCHAR2(100);
    v_keyfld_srcfld       VARCHAR2(100);
    v_keyfld_mandatory    VARCHAR2(1);
    v_keyfld_cnt numeric;
    v_transid_primetable    VARCHAR2(100);
    v_transid_primetableid  VARCHAR2(100);
    v_keyfld_cnd          VARCHAR2(500);
    v_keyfld_joins        VARCHAR2(500);
    v_sql_permission_cnd  VARCHAR2(4000);
    v_sql_roles           VARCHAR2(4000);
    v_sql_permission_check VARCHAR2(4000);
    v_fullcontrol_sql     VARCHAR2(4000);
    v_menuaccess_count      NUMBER;
    v_permission_exists_count NUMBER;
    sql_permission_cnd_result NUMBER; 
    v_fullcontrol_recid   NUMBER;
    v_fullcontrol         VARCHAR2(1);
    v_userrole            VARCHAR2(250);
    v_allowcreate         VARCHAR2(1);
    v_view_access         VARCHAR2(250);
    v_view_includedc      VARCHAR2(4000);
    v_view_excludedc      VARCHAR2(4000);
    v_view_includeflds    VARCHAR2(4000);
    v_excludeflds         VARCHAR2(4000); 
    v_edit_access         VARCHAR2(250);
    v_edit_includedc      VARCHAR2(4000);
    v_edit_excludedc      VARCHAR2(4000);
    v_edit_includeflds    VARCHAR2(4000);
    v_edit_excludeflds    VARCHAR2(4000);
    v_maskedflds          VARCHAR2(4000);
    v_filtercnd           CLOB;
    v_recordid            NUMBER;
    v_viewctrl            VARCHAR2(10);
    v_editctrl            VARCHAR2(10);
    v_viewlist            VARCHAR2(4000);
    v_editlist            VARCHAR2(4000);
	v_encryptedflds VARCHAR2(4000);
BEGIN

	SELECT count(1)INTO v_keyfld_cnt FROM axpflds WHERE tstruct = ptransid AND fname = pkeyfld;

    IF v_keyfld_cnt > 0 then
	    SELECT srckey, srctf, srcfld, allowempty INTO v_keyfld_normalized, v_keyfld_srctbl, v_keyfld_srcfld, v_keyfld_mandatory
	    FROM axpflds WHERE tstruct = ptransid AND fname = pkeyfld;
	END IF;


    SELECT tablename INTO v_transid_primetable FROM axpdc WHERE tstruct = ptransid AND dname = 'dc1';
    v_transid_primetableid := CASE WHEN LOWER(pkeyfld) = 'recordid' THEN v_transid_primetable || 'id' ELSE pkeyfld END;
    v_keyfld_cnd := CASE WHEN v_keyfld_normalized = 'T' THEN v_keyfld_srctbl || '.' || v_keyfld_srcfld
                         ELSE v_transid_primetable || '.' || v_transid_primetableid END || '=' || pkeyvalue || ' AND ';
    v_keyfld_joins := NULL;


   IF v_keyfld_normalized = 'T' THEN
        v_keyfld_joins := CASE WHEN v_keyfld_mandatory = 'T' THEN ' JOIN ' ELSE ' LEFT JOIN ' END
                          || v_keyfld_srctbl || ' ' || pkeyfld || ' ON '
                          || v_transid_primetable || '.' || pkeyfld || '=' || v_keyfld_srctbl || '.' || v_keyfld_srctbl || 'id';
    END IF;

   SELECT COUNT(*) INTO v_menuaccess_count 
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
    );



        v_fullcontrol_sql := 'SELECT ' || v_transid_primetable || 'id FROM ' || v_transid_primetable || ' ' ||
                             COALESCE(v_keyfld_joins, '') || ' WHERE ' || REPLACE(v_keyfld_cnd, ' AND ', '');



        EXECUTE IMMEDIATE v_fullcontrol_sql INTO v_fullcontrol_recid;

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

    RETURN; 

END;
>>

