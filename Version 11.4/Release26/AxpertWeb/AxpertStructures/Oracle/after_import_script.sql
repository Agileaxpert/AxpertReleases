<<
update axpdef_axpertprops set mob_citizenuser='F'
>>

<<
update axpdef_axpertprops set mob_geofencing='F'
>>

<<
update axpdef_axpertprops set mob_geotag='F'
>>

<<
update axpdef_axpertprops set mob_fingerauth='F'
>>

<<
update axpdef_axpertprops set mob_faceauth='F'
>>

<<
update axpdef_axpertprops set mob_forcelogin='F'
>>

<<
update axpdef_axpertprops set mob_forceloginusers='F'
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
    (SELECT tablename FROM axpdc WHERE tstruct = ptransid AND dname = 'dc1'
       UNION ALL
       SELECT NULL FROM dual);

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
ALTER TABLE axpdef_peg_usergroups MODIFY (usergroupcode VARCHAR2(200))
>>

<<
CREATE OR REPLACE TYPE AXPDEF_PERMISSION_GETADSCND AS OBJECT (
    fullcontrol VARCHAR2(1),
    userrole VARCHAR2(255),
    view_access VARCHAR2(10),
    view_includeflds VARCHAR2(4000),
    view_excludeflds VARCHAR2(4000),
    maskedflds VARCHAR2(4000),
    filtercnd CLOB 
);
>>

<< 
CREATE OR REPLACE TYPE AXPDEF_PERMISSION_GETADS_OBJ IS TABLE OF AXPDEF_PERMISSION_GETADSCND;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getadscnd(
    ptransid IN VARCHAR2,
    padsname IN VARCHAR2,
    pusername IN VARCHAR2,
    proles IN VARCHAR2 DEFAULT 'All',
    pkeyfield IN VARCHAR2 DEFAULT NULL,
    pkeyvalue IN VARCHAR2 DEFAULT NULL
) RETURN AXPDEF_PERMISSION_GETADS_OBJ PIPELINED
AS
    rolesql_str      VARCHAR2(4000);
    v_permissionsql  VARCHAR2(4000);
    v_permissionexists NUMBER;
    v_fullcontrol    VARCHAR2(1);
    v_userrole       VARCHAR2(255);
    v_view_access    VARCHAR2(10);
    v_view_includeflds VARCHAR2(4000);
    v_view_excludeflds VARCHAR2(4000);
    v_maskedflds     VARCHAR2(4000);
    v_filtercnd      CLOB;
BEGIN
            PIPE ROW(AXPDEF_PERMISSION_GETADSCND('T', NULL, NULL, NULL, NULL, NULL, NULL));
    
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
        SELECT tablename
          INTO v_primarydctable
          FROM axpdc
         WHERE tstruct = ptransid
           AND dname = 'dc1';

        v_filtercnd := ' and (' || REPLACE(pcond, '{primarytable.}', v_primarydctable || '.') || ')';

        
        v_filtersql := REPLACE(v_adssql, '--permission_filter', v_filtercnd);
    END IF;

    
    RETURN CASE
               WHEN pcond = 'NA' THEN v_adssql
               ELSE v_filtersql
           END;
END;
>>