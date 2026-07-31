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

IF (lower(trim(v_adssql)) like 'select%' or lower(trim(v_adssql)) like 'with%') and v_addpagination='T' THEN

    v_adssql := ('select --ax_select_columns 
from(
'||v_adssql||'
)wpc
'||'--ax_ui_filter_withwhere
'||case when v_dimensions='T' then ' --ax_permission_filter
' end||
'--ax_groupby
'||
'--ax_orderby
'||
'--ax_pagination
');
    
    
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
 ELSE
 
 return v_adssql;

END IF;
    
END;
>>

<<
delete from axpstructconfigproval c
where exists(
select * from axpstructconfigprops b join axpstructconfigproval a 
on a.axpstructconfigpropsid = a.axpstructconfigpropsid 
where b.configprops ='Landing Structure'
and a.configvalues ='html templates'
and c.axpstructconfigprovalid=a.axpstructconfigprovalid )
>>

<<
CREATE OR REPLACE FORCE VIEW VW_AXPERTINBOX  AS 
  SELECT touser, processname, taskname, taskid, tasktype, edatetime, eventdatetime,
       fromuser, fromrole, displayicon, displaytitle, displaymcontent, displaycontent,
       displaybuttons, keyfield, keyvalue, transid, priorindex, indexno, subindexno,
       approvereasons, defapptext, returnreasons, defrettext, rejectreasons, defregtext,
       recordid, approvalcomments, rejectcomments, returncomments, rectype, msgtype,
       returnable, initiator, initiator_approval, displaysubtitle, amendment, allowsend,
       allowsendflg, cmsg_appcheck, cmsg_return, cmsg_reject, showbuttons, hlink,
       hlink_transid, hlink_params, taskstatus, statusreason, statustext, cancelremarks,
       cancelledby, cancelledon, cancel, username, cstatus
FROM (
    SELECT a.touser,
           a.processname,
           a.taskname,
           a.taskid,
           a.tasktype,
           a.eventdatetime AS edatetime,
           to_char(to_timestamp(SUBSTR(a.eventdatetime,1,14), 'YYYYMMDDHH24MISS'), 'dd/mm/yyyy hh24:mi:ss') AS eventdatetime,
           a.fromuser,
           a.fromrole,
           a.displayicon,
           a.displaytitle,
           TO_CHAR(a.displaymcontent) AS displaymcontent,
           TO_CHAR(a.displaycontent) AS displaycontent,
           a.displaybuttons,
           a.keyfield,
           a.keyvalue,
           a.transid,
           a.priorindex,
           a.indexno,
           a.subindexno,
           TO_CHAR(a.approvereasons) AS approvereasons,
           TO_CHAR(a.defapptext) AS defapptext,
           TO_CHAR(a.returnreasons) AS returnreasons,
           TO_CHAR(a.defrettext) AS defrettext,
           TO_CHAR(a.rejectreasons) AS rejectreasons,
           TO_CHAR(a.defregtext) AS defregtext,
           aa.recordid,
           TO_CHAR(a.approvalcomments) AS approvalcomments,
           TO_CHAR(a.rejectcomments) AS rejectcomments,
           TO_CHAR(a.returncomments) AS returncomments,
           'PEG' AS rectype,
           'NA' AS msgtype,
           a.returnable,
           a.initiator,
           a.initiator_approval,
           a.displaysubtitle,
           p.amendment,
           a.allowsend,
           a.allowsendflg,
           TO_CHAR(b.cmsg_appcheck) AS cmsg_appcheck,
           TO_CHAR(b.cmsg_return) AS cmsg_return,
           TO_CHAR(b.cmsg_reject) AS cmsg_reject,
           b.showbuttons,
           CAST(NULL AS VARCHAR2(4000)) AS hlink,
           CAST(NULL AS VARCHAR2(4000)) AS hlink_transid,
           CAST(NULL AS VARCHAR2(4000)) AS hlink_params,
           'Pending' AS taskstatus,
           CAST(NULL AS VARCHAR2(4000)) AS statusreason,
           CAST(NULL AS VARCHAR2(4000)) AS statustext,
           CAST(NULL AS VARCHAR2(4000)) AS cancelremarks,
           CAST(NULL AS VARCHAR2(4000)) AS cancelledby,
           CAST(NULL AS VARCHAR2(4000)) AS cancelledon,
           CAST(NULL AS VARCHAR2(4000)) AS cancel,
           CAST(NULL AS VARCHAR2(4000)) AS username,
           'Active' AS cstatus,
           ROW_NUMBER() OVER (PARTITION BY a.taskid ORDER BY a.eventdatetime DESC) as rn
    FROM axactivetasks a
    JOIN axprocessdefv2 b 
      ON a.processname = b.processname 
     AND a.taskname = b.taskname
    JOIN axpdef_peg_processmaster p 
      ON a.processname = p.caption
    LEFT JOIN axactivetasks aa 
      ON a.processname = aa.processname 
     AND a.keyvalue = aa.keyvalue 
     AND a.transid = aa.transid 
     AND aa.tasktype = 'Make' 
     AND aa.recordid IS NOT NULL
    WHERE NOT EXISTS (
        SELECT 1
        FROM axactivetaskstatus b_1
        WHERE a.taskid = b_1.taskid
    ) 
    AND a.removeflg = 'F'
)
WHERE rn = 1
UNION ALL
SELECT a.touser,
       a.processname,
       a.taskname,
       a.taskid,
       a.tasktype,
       a.eventdatetime AS edatetime,
       to_char(to_timestamp(SUBSTR(a.eventdatetime,1,14), 'YYYYMMDDHH24MISS'), 'dd/mm/yyyy hh24:mi:ss') AS eventdatetime,
       a.fromuser,
       a.fromrole,
       a.displayicon,
       a.displaytitle,
       TO_CHAR(a.displaymcontent) AS displaymcontent,
       TO_CHAR(a.displaycontent) AS displaycontent,
       a.displaybuttons,
       a.keyfield,
       a.keyvalue,
       a.transid,
       a.priorindex,
       a.indexno,
       a.subindexno,
       TO_CHAR(a.approvereasons) AS approvereasons,
       TO_CHAR(a.defapptext) AS defapptext,
       TO_CHAR(a.returnreasons) AS returnreasons,
       TO_CHAR(a.defrettext) AS defrettext,
       TO_CHAR(a.rejectreasons) AS rejectreasons,
       TO_CHAR(a.defregtext) AS defregtext,
       a.recordid,
       TO_CHAR(a.approvalcomments) AS approvalcomments,
       TO_CHAR(a.rejectcomments) AS rejectcomments,
       TO_CHAR(a.returncomments) AS returncomments,
       'PEG' AS rectype,
       'NA' AS msgtype,
       a.returnable,
       a.initiator,
       a.initiator_approval,
       a.displaysubtitle,
       CAST(NULL AS VARCHAR2(4000)) AS amendment,
       a.allowsend,
       a.allowsendflg,
       CAST(NULL AS VARCHAR2(4000)) AS cmsg_appcheck,
       CAST(NULL AS VARCHAR2(4000)) AS cmsg_return,
       CAST(NULL AS VARCHAR2(4000)) AS cmsg_reject,
       CAST(NULL AS VARCHAR2(4000)) AS showbuttons,
       CAST(NULL AS VARCHAR2(4000)) AS hlink,
       CAST(NULL AS VARCHAR2(4000)) AS hlink_transid,
       CAST(NULL AS VARCHAR2(4000)) AS hlink_params,
       pr_pegv2_transcurstatus(a.transid, a.keyvalue, a.processname) AS taskstatus,
       TO_CHAR(b.statusreason) AS statusreason,
       TO_CHAR(b.statustext) AS statustext,
       TO_CHAR(b.cancelremarks) AS cancelremarks,
       b.cancelledby,
       CAST(b.cancelledon AS VARCHAR2(4000)) AS cancelledon,
       b.cancel,
       CASE
            WHEN a.indexno = 1 THEN a.fromuser
            ELSE a.touser
       END AS username,
       'Completed' AS cstatus
FROM axactivetasks a
JOIN axactivetaskstatus b ON a.taskid = b.taskid
UNION ALL
SELECT axactivemessages.touser,
       axactivemessages.processname,
       axactivemessages.taskname,
       axactivemessages.taskid,
       axactivemessages.tasktype,
       axactivemessages.eventdatetime AS edatetime,
       to_char(to_timestamp(SUBSTR(axactivemessages.eventdatetime,1,14), 'YYYYMMDDHH24MISS'), 'dd/mm/yyyy hh24:mi:ss') AS eventdatetime,
       axactivemessages.fromuser,
       CAST(NULL AS VARCHAR2(4000)) AS fromrole,
       axactivemessages.displayicon,
       axactivemessages.displaytitle,
       CAST(NULL AS VARCHAR2(4000)) AS displaymcontent,
       TO_CHAR(axactivemessages.displaycontent) AS displaycontent,
       CAST(NULL AS VARCHAR2(4000)) AS displaybuttons,
       axactivemessages.keyfield,
       axactivemessages.keyvalue,
       axactivemessages.transid,
       CASE WHEN axactivemessages.taskid IS NULL THEN NULL ELSE 0 END AS priorindex, 
       axactivemessages.indexno,
       CASE WHEN axactivemessages.taskid IS NULL THEN NULL ELSE 0 END AS subindexno,
       CAST(NULL AS VARCHAR2(4000)) AS approvereasons,
       CAST(NULL AS VARCHAR2(4000)) AS defapptext,
       CAST(NULL AS VARCHAR2(4000)) AS returnreasons,
       CAST(NULL AS VARCHAR2(4000)) AS defrettext,
       CAST(NULL AS VARCHAR2(4000)) AS rejectreasons,
       CAST(NULL AS VARCHAR2(4000)) AS defregtext,
       CASE WHEN axactivemessages.taskid IS NULL THEN NULL ELSE 0 END AS recordid,
       CAST(NULL AS VARCHAR2(4000)) AS approvalcomments,
       CAST(NULL AS VARCHAR2(4000)) AS rejectcomments,
       CAST(NULL AS VARCHAR2(4000)) AS returncomments,
       'MSG' AS rectype,
       axactivemessages.msgtype,
       'F' AS returnable,
       CAST(NULL AS VARCHAR2(4000)) AS initiator,
       CAST(NULL AS VARCHAR2(4000)) AS initiator_approval,
       CAST(NULL AS VARCHAR2(4000)) AS displaysubtitle,
       p.amendment,
       'F' AS allowsend,
       'F' AS allowsendflg,
       CAST(NULL AS VARCHAR2(4000)) AS cmsg_appcheck,
       CAST(NULL AS VARCHAR2(4000)) AS cmsg_return,
       CAST(NULL AS VARCHAR2(4000)) AS cmsg_reject,
       CAST(NULL AS VARCHAR2(4000)) AS showbuttons,
       axactivemessages.hlink,
       axactivemessages.hlink_transid,
       axactivemessages.hlink_params,
       'Completed' AS taskstatus,
       CAST(NULL AS VARCHAR2(4000)) AS statusreason,
       CAST(NULL AS VARCHAR2(4000)) AS statustext,
       CAST(NULL AS VARCHAR2(4000)) AS cancelremarks,
       CAST(NULL AS VARCHAR2(4000)) AS cancelledby,
       CAST(NULL AS VARCHAR2(4000)) AS cancelledon,
       CAST(NULL AS VARCHAR2(4000)) AS cancel,
       CAST(NULL AS VARCHAR2(4000)) AS username,
       'Completed' AS cstatus
FROM axactivemessages
LEFT JOIN axpdef_peg_processmaster p ON axactivemessages.processname = p.caption
WHERE NOT EXISTS (
    SELECT 1
    FROM axactivetaskstatus b
    WHERE axactivemessages.taskid = b.taskid
) 
AND axactivemessages.transid NOT IN ('tassk', 'ticke', 'send', 'retun', 'taskc', 'close', 'drop', 'infor', 'stupd', 'Taskm');
>>

<<
delete from axdirectsql a where sqlname in(
'DS_PendingApprovals',
'REQUESTEDBYME',
'DS_Escalations',
'DS_Reminders',
'DS_Completed',
'DS_AxpertInbox'
)
>>

<<
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND, SQLQUERYCOLS, ENCRYPTEDFLDS, CACHEDATA, CACHEINTERVAL, SMARTLISTCND, ADSDESC, PAGINATION, APPLYDIMENSIONS) VALUES(1968550000050, 'F', 0, NULL, 'admin', TIMESTAMP '2026-07-14 00:00:00.000000', 'admin', TIMESTAMP '2026-06-19 00:00:00.000000', NULL, 1, 1, NULL, NULL, NULL, 'DS_PendingApprovals', NULL, 'SELECT *
FROM vw_axpertinbox v
WHERE
    v.rectype = ''PEG''
    AND v.cstatus = ''Active''
    AND v.taskstatus = ''Pending''
    AND
    (
        COALESCE(TRIM(:uname),'''') = ''''
        OR v.touser = :uname
    )
    AND
    (
        COALESCE(TRIM(:searchtext), '''') = ''''
        OR
        LOWER
        (
            COALESCE(v.taskname,'''') || '' '' ||
            COALESCE(v.taskid,'''') || '' '' ||
            COALESCE(v.displaycontent,'''') || '' '' ||
            COALESCE(v.displaytitle,'''') || '' '' ||
            COALESCE(v.fromuser,'''') || '' '' ||
            COALESCE(v.processname,'''') || '' '' ||
            COALESCE(v.eventdatetime,'''') || '' '' ||
            COALESCE(v.taskstatus,'''')
        )
        LIKE LOWER(''%'' || TRIM(:searchtext) || ''%'')
    )
ORDER BY v.edatetime DESC
-- ax_pagination
', 'uname,searchtext', 'uname~Character~,searchtext~Character~', 'ALL', NULL, 'For users', 3, NULL, NULL, 'F', '6 Hr', NULL, NULL, NULL, NULL)
>>

<<
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND, SQLQUERYCOLS, ENCRYPTEDFLDS, CACHEDATA, CACHEINTERVAL, SMARTLISTCND, ADSDESC, PAGINATION, APPLYDIMENSIONS) VALUES(1968880000005, 'F', 0, NULL, 'admin', TIMESTAMP '2026-07-21 15:14:41.000000', 'admin', TIMESTAMP '2026-06-19 00:00:00.000000', NULL, 1, 1, NULL, NULL, NULL, 'DS_Completed', NULL, 'SELECT * FROM vw_axpertinbox v
WHERE (COALESCE(TRIM(:uname),'''') = '''' OR v.touser = :uname)
AND (COALESCE(v.taskstatus,'''') IN(''Completed'') OR v.cstatus = ''Completed'')
AND (COALESCE(TRIM(:searchtext), '''') = '''' OR LOWER(
        COALESCE(v.taskname,'''') || '' '' ||
        COALESCE(v.taskid,'''') || '' '' ||
        COALESCE(v.displaycontent,'''') || '' '' ||
        COALESCE(v.displaytitle,'''') || '' '' ||
        COALESCE(v.fromuser,'''') || '' '' ||
        COALESCE(v.processname,'''') || '' '' ||
        COALESCE(v.eventdatetime,'''') || '' '' ||
        COALESCE(v.taskstatus,'''') || '' '' ||
        COALESCE(v.msgtype,'''')) LIKE LOWER(''%'' || TRIM(:searchtext) || ''%''))
ORDER BY v.edatetime DESC
-- ax_pagination

', 'uname,searchtext', 'uname~Character~,searchtext~Character~', 'ALL', NULL, 'For users', 3, 'NA', NULL, 'F', '6 Hr', NULL, NULL, NULL, NULL)
>>

<<
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND, SQLQUERYCOLS, ENCRYPTEDFLDS, CACHEDATA, CACHEINTERVAL, SMARTLISTCND, ADSDESC, PAGINATION, APPLYDIMENSIONS) VALUES(1703110000019, 'F', 0, NULL, 'admin', TIMESTAMP '2026-07-14 00:00:00.000000', 'admin', TIMESTAMP '2026-07-14 00:00:00.000000', NULL, 1, 1, NULL, NULL, NULL, 'REQUESTEDBYME', NULL, 'SELECT *
FROM vw_axpertinbox v
WHERE
    v.rectype = ''PEG''
    AND v.fromuser = :uname
    AND
    (
        COALESCE(TRIM(:searchtext), '''') = ''''
        OR LOWER
        (
            COALESCE(v.taskname,'''') || '' '' ||
            COALESCE(v.taskid,'''') || '' '' ||
            COALESCE(v.displaycontent,'''') || '' '' ||
            COALESCE(v.displaytitle,'''') || '' '' ||
            COALESCE(v.fromuser,'''') || '' '' ||
            COALESCE(v.processname,'''') || '' '' ||
            COALESCE(v.eventdatetime,'''') || '' '' ||
            COALESCE(v.taskstatus,'''')
        )
        LIKE LOWER(''%'' || TRIM(:searchtext) || ''%'')
    )
ORDER BY v.edatetime desc
-- ax_pagination', 'uname,searchtext', 'uname~Character~,searchtext~Character~', 'ALL', NULL, 'For users', 3, NULL, NULL, 'F', '6 Hr', NULL, NULL, NULL, NULL)
>>

<<
INSERT INTO
	AXPAGES (NAME,
	CAPTION,
	PROPS,
	BLOBNO,
	IMG,
	VISIBLE,
	"TYPE",
	PARENT,
	ORDNO,
	LEVELNO,
	UPDATEDON,
	CREATEDON,
	IMPORTEDON,
	CREATEDBY,
	UPDATEDBY,
	IMPORTEDBY,
	READONLY,
	UPDUSERNAME,
	CATEGORY,
	PAGETYPE,
	INTVIEW,
	WEBENABLE,
	SHORTCUT,
	ICON,
	WEBSUBTYPE,
	WORKFLOW,
	OLDAPPURL)
VALUES('HP1784890416201',
'Inbox',
'htmlPages.aspx?load=1784890416201',
1,
NULL,
'T',
'p',
NULL,
(SELECT max(ordno)+1 FROM axpages),
0,
'24/07/2026 4:21:16 PM',
'24/07/2026 4:21:16 PM',
NULL,
'admin',
'admin',
NULL,
NULL,
NULL,
NULL,
'web',
NULL,
NULL,
NULL,
NULL,
'htmlpage',
NULL,
NULL)
>>

<<
INSERT INTO HTMLSECTIONS (HTMLSECTIONSID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, PAGENO, CAPTION, AXPFILE_HPIMAGES, AXPFILEPATH_HPIMAGES, ADDTOMENU, ISACORETRANS, MENUPOSITION, MENULIST, PARAMS, TEMPLATE) VALUES(1982220000002, 'F', 0, NULL, 'admin', TIMESTAMP '2026-07-24 16:21:16.000000', 'admin', TIMESTAMP '2026-07-24 16:21:16.000000', NULL, 1, 1, NULL, NULL, NULL, '1784890416201', 'Inbox', NULL, 'D:\qabiz\Axpert11.4Base\AxpertWeb\deforacle112\HTMLPages\images\*', NULL, 'No', 'Default', NULL, NULL, NULL)
>>

