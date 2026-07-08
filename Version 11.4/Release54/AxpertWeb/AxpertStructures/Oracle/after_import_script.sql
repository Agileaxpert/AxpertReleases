<<
CREATE OR REPLACE FUNCTION fn_get_axpertcomps_name (
    pinput IN varchar2
) RETURN CLOB 
IS
    v_result CLOB;
BEGIN
    IF pinput IS NULL OR LENGTH(pinput) <= 2 THEN
        RETURN NULL;
    END IF;

   SELECT
	listagg(rtrim(SUBSTR(split_value, INSTR(split_value, '-(')+ 2), ')'), ',') WITHIN GROUP(
	ORDER BY 1) INTO v_result
FROM
	(
	SELECT
		DISTINCT TRIM(REGEXP_SUBSTR( pinput, '[^,]+', 1, LEVEL)) AS split_value
	FROM
		dual
	CONNECT BY
		REGEXP_SUBSTR ( pinput,
		'[^,]+',
		1,
		LEVEL) IS NOT NULL);

    RETURN v_result;
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
   v_addpagination varchar2(1);
v_dimensions varchar2(1);
BEGIN

    SELECT sqltext,coalesce(pagination,'T') pagination,applydimensions
      INTO v_adssql,v_addpagination,v_dimensions
      FROM axdirectsql
     WHERE sqlname = padsname;


    v_adssql := ('select --ax_select_columns 
from(
'||v_adssql||'
)wpc
'||case when v_dimensions='T' then ' --ax_permission_filter
' end||
'--ax_ui_filter_withwhere
'||
'--ax_groupby
'||
'--ax_orderby
'||
case when v_addpagination='T' then '--ax_pagination
'end);
    
    
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
update axdirectsql set sqlsrc ='For developers',sqlsrccnd =2 where sqlsrc ='Internal'
>>

<<
update axdirectsql set sqlsrc='For developers',sqlsrccnd=2  where sqlname in('axcalendarsource','ds_homepage_banner',
'ds_homepage_events',
'ds_homepage_kpicards')
>>

<<
update axdirectsql set sqlsrc='Internal',sqlsrccnd=1  where sqlname in(
'axi_actorlist',
'axi_adscolumnlist',
'axi_adsdropdowntokens',
'axi_adsfilteroperators',
'axi_adslist',
'axi_analyticslist',
'axi_apinameslist',
'axi_cardlist',
'axi_dimensionlist',
'axi_fieldlist',
'axi_fieldvaluelist',
'axi_fieldvalueswithkeysuffixlist',
'axi_firesql',
'axi_formnotifylist',
'Axi_getmetadata',
'axi_iviewlist',
'axi_jobnameslist',
'axi_keyfieldlist',
'axi_keyvalueswithfieldnameslist',
'Axi_metadata_struct_obj',
'axi_pagelist',
'axi_peglist',
'axi_pegnotifylist',
'axi_printformlist',
'axi_rolelist',
'axi_rulenameslist',
'axi_schedulenotifylist',
'axi_servernamelist',
'axi_setfieldlist',
'axi_smartlist_ads_metadata',
'axi_tstructlist',
'axi_tstructprops_insupd',
'axi_usergrouplist',
'axi_userlist',
'axi_userpwd',
'axi_viewlist',
'ds_getsmartlists','Text_Field_Intelligence','ds_smartlist_filters','ds_smartlist_ads_metadata')
>>

<<
update axdirectsql set sqlsrc ='Internal',sqlsrccnd =1 where sqlsrc ='Metadata'
>>

<<
update axdirectsql set sqlsrc ='For users',sqlsrccnd =3 where sqlsrc ='Application'
>>

<<
CREATE OR REPLACE TYPE fn_permissions_apptstructsobj AS OBJECT (
    transid VARCHAR2(50)
);
>>

<<
CREATE OR REPLACE TYPE fn_permissions_apptstructstab AS TABLE OF fn_permissions_apptstructsobj;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_apptstructs (
    pusername IN VARCHAR2,
    puserrole IN VARCHAR2,
    ptype     IN VARCHAR2 DEFAULT 'Tstruct'
) RETURN fn_permissions_apptstructstab PIPELINED 
AS 
BEGIN
    FOR r IN ( 
        SELECT formtransid FROM axpermissions
        WHERE axusername = pusername AND comptype = 'Form'
        UNION
        SELECT formtransid FROM axpermissions
        WHERE comptype = 'Form'
          AND axuserrole IN (
              SELECT trim(regexp_substr(puserrole, '[^,]+', 1, level))
              FROM dual
              CONNECT BY regexp_substr(puserrole, '[^,]+', 1, level) IS NOT NULL
          )
    ) LOOP
        PIPE ROW(fn_permissions_apptstructsobj(r.formtransid));
    END LOOP;

    RETURN;
END;
>>

<<
CREATE OR REPLACE TYPE mobile_axactivemsg_obj AS OBJECT (
    msgtype        VARCHAR2(30),  
    fromuser   VARCHAR2(30),
    touser VARCHAR2(500),
    TASKTYPE VARCHAR2(30),
    displaytitle   VARCHAR2(500), 
    displaycontent NCLOB,         
    requestpayload NCLOB          
);
>>

<<
CREATE OR REPLACE TYPE mobile_axactivemsg_tbl AS TABLE OF mobile_axactivemsg_obj;
>>

<<
CREATE OR REPLACE FUNCTION fn_mobile_axactivemsg(
    pmsgtypes IN VARCHAR2, 
    pdelimiter IN VARCHAR2 DEFAULT ','
)
RETURN mobile_axactivemsg_tbl PIPELINED 
IS
BEGIN
    FOR r IN (
        SELECT 
            msgtype,fromuser,touser,tasktype,          
            displaytitle, 
            displaycontent, 
            requestpayload 
        FROM axactivemessages 
        WHERE msgtype IN (
            SELECT REGEXP_SUBSTR(pmsgtypes, '[^' || pdelimiter || ']+', 1, LEVEL)
            FROM DUAL
            CONNECT BY LEVEL <= REGEXP_COUNT(pmsgtypes, '[^' || pdelimiter || ']+')
        )
    ) LOOP
        PIPE ROW(mobile_axactivemsg_obj(
            r.msgtype,r.fromuser,r.touser,r.tasktype,            
            r.displaytitle, 
            r.displaycontent, 
            r.requestpayload
        ));
    END LOOP;
    RETURN;
END;
>>

<<
INSERT
	INTO
	AXDIRECTSQL (AXDIRECTSQLID,
	CANCEL,
	SOURCEID,
	MAPNAME,
	USERNAME,
	MODIFIEDON,
	CREATEDBY,
	CREATEDON,
	WKID,
	APP_LEVEL,
	APP_DESC,
	APP_SLEVEL,
	CANCELREMARKS,
	WFROLES,
	SQLNAME,
	DDLDATATYPE,
	SQLTEXT,
	PARAMCAL,
	SQLPARAMS,
	ACCESSSTRING,
	GROUPNAME,
	SQLSRC,
	SQLSRCCND,
	SQLQUERYCOLS,
	ENCRYPTEDFLDS,
	CACHEDATA,
	CACHEINTERVAL,
	SMARTLISTCND,
	ADSDESC,
	PAGINATION,
	APPLYDIMENSIONS)
VALUES (1886880000001,
'F',
0,
NULL,
'admin',
TIMESTAMP '2026-06-30 15:49:27.000000',
'admin',
TIMESTAMP '2026-06-30 10:54:49.000000',
NULL,
1,
1,
NULL,
NULL,
NULL,
'ds_mobile_axactivemsg',
NULL,
TO_CLOB('SELECT * FROM TABLE(fn_mobile_axactivemsg( :pmsgtypes))'),
'pmsgtypes',
'pmsgtypes~Character~',
'ALL',
NULL,
'Internal',
1,
'msgtype,fromuser,touser,tasktype,displaytitle,displaycontent,requestpayload',
NULL,
'F',
'6 Hr',
NULL,
NULL,
'F',
'F')
>>