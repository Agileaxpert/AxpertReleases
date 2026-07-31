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
v_addpagination varchar;
v_dimensions varchar;
begin




select sqltext,coalesce(pagination,'T') pagination,applydimensions
into v_adssql,v_addpagination,v_dimensions 
from axdirectsql 
where sqlname = padsname;




IF (lower(trim(v_adssql)) like 'select%' or lower(trim(v_adssql)) like 'with%') and v_addpagination='T' THEN

v_adssql := concat('select --ax_select_columns 
from(
',v_adssql,'
)wpc
',
'--ax_ui_filter_withwhere
',case when v_dimensions='T' then ' --ax_permission_filter
' end,
'--ax_groupby
',
'--ax_orderby
',
'--ax_pagination
');

if pcond !='NA' then 

v_filtercnd := concat(' and (',replace(pcond,'{primarytable.}',''),')');
	
v_filtersql := replace(v_adssql,'--ax_permission_filter',concat(' where 1=1 ',v_filtercnd));


end if;

return case when pcond ='NA' then  v_adssql else v_filtersql end;

else

return v_adssql;

end if;	
	
END; 
$function$
;
>>

<<
delete from axpstructconfigproval c
where exists(
select * from axpstructconfigprops b join axpstructconfigproval a 
on a.axpstructconfigpropsid = a.axpstructconfigpropsid 
where b.configprops ='Landing Structure'
and a.configvalues ='html templates'
and c.axpstructconfigprovalid=a.axpstructconfigprovalid );
>>


<<
Alter table AXPROCESSDEFV2 alter column axpdef_peg_processmasterid type   NUMERIC(16,0) USING axpdef_peg_processmasterid::  NUMERIC(16,0);
>>

<<
CREATE OR REPLACE VIEW vw_pegv2_processdef_cards
AS WITH a AS (
         SELECT a_1.caption,
            c.taskname,
            regexp_split_to_table(a_1.cards::text, ','::text) AS card,
            c.axprocessdefv2id
           FROM axpdef_peg_processmaster a_1,
            axprocessdefv2 c
          WHERE a_1.axpdef_peg_processmasterid = c.axpdef_peg_processmasterid
        ), b AS (
         SELECT axprocessdefv2.processname,
            axprocessdefv2.taskname,
            regexp_split_to_table(COALESCE(axprocessdefv2.hidecards, 'NA'::character varying)::text, ','::text) AS hidecard
           FROM axprocessdefv2
        )
 SELECT a.axprocessdefv2id,
    a.caption AS processname,
    a.taskname,
    d.cardname,
    d.axp_cardsid,
    d.sql_editor_cardsql,
    d.cardtype,
    d.chartjson,
    d.pagecaption,
    d.pagename,
    d.hcaption,
    d.htype,
    d.htransid
   FROM a
     LEFT JOIN b ON a.caption::text = b.processname::text AND a.taskname::text = b.taskname::text AND a.card = b.hidecard
     JOIN axp_cards d ON a.card = d.cardname::text
  WHERE b.hidecard IS NULL;
>>

<<
delete from axdirectsql a where sqlname in(
'DS_PendingApprovals',
'REQUESTEDBYME',
'DS_Escalations',
'DS_Reminders',
'DS_Completed',
'DS_AxpertInbox'
);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqlsrc, sqlsrccnd, sqltext, paramcal, sqlparams, accessstring, groupname, sqlquerycols, cachedata, cacheinterval, encryptedflds, adsdesc, smartlistcnd, pagination, applydimensions) VALUES(1968550000010, 'F', 0, NULL, 'admin', '2026-07-14 12:33:10.000', 'admin', '2026-06-19 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'DS_PendingApprovals', NULL, 'For developers', 2, 'SELECT *
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



', 'uname,searchtext', 'uname~Character~,searchtext~Character~', 'ALL', NULL, 'NA', 'F', '6 Hr', NULL, NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqlsrc, sqlsrccnd, sqltext, paramcal, sqlparams, accessstring, groupname, sqlquerycols, cachedata, cacheinterval, encryptedflds, adsdesc, smartlistcnd, pagination, applydimensions) VALUES(1968880000005, 'F', 0, NULL, 'admin', '2026-07-24 15:31:55.000', 'admin', '2026-06-19 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'DS_Completed', NULL, 'For developers', 2, 'SELECT *
FROM vw_axpertinbox v
WHERE
(
    COALESCE(TRIM(:uname),'''') = ''''
    OR v.touser = :uname
)
AND
(
    COALESCE(v.taskstatus,'''') IN
    (
        ''Completed''
    )
    OR v.cstatus = ''Completed''
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
        COALESCE(v.taskstatus,'''') || '' '' ||
        COALESCE(v.msgtype,'''')
    )
    LIKE LOWER(''%'' || TRIM(:searchtext) || ''%'')
)
ORDER BY v.edatetime DESC
-- ax_pagination
 ', 'uname,searchtext', 'uname~Character~,searchtext~Character~', 'ALL', NULL, 'NA', 'F', '6 Hr', NULL, NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqlsrc, sqlsrccnd, sqltext, paramcal, sqlparams, accessstring, groupname, sqlquerycols, cachedata, cacheinterval, encryptedflds, adsdesc, smartlistcnd, pagination, applydimensions) VALUES(1425990000000, 'F', 0, NULL, 'admin', '2026-07-14 12:32:11.000', 'nalina', '2026-07-13 15:54:06.000', NULL, 1, 1, NULL, NULL, NULL, 'REQUESTEDBYME', NULL, 'For developers', 2, 'SELECT *
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
-- ax_pagination', 'uname,searchtext', 'uname~Character~,searchtext~Character~', 'ALL', NULL, 'NA', 'F', '6 Hr', NULL, NULL, NULL, 'T', 'F');
>>

<<
CREATE OR REPLACE VIEW vw_axpertinbox
AS SELECT DISTINCT a.touser,
    a.processname,
    a.taskname,
    a.taskid,
    a.tasktype,
    a.eventdatetime AS edatetime,
    to_char(to_timestamp(a.eventdatetime::text, 'YYYYMMDDHH24MISSSSS'::text), 'dd/mm/yyyy hh24:mi:ss'::text) AS eventdatetime,
    a.fromuser,
    a.fromrole,
    a.displayicon,
    a.displaytitle,
    a.displaymcontent,
    a.displaycontent,
    a.displaybuttons,
    a.keyfield,
    a.keyvalue,
    a.transid,
    a.priorindex,
    a.indexno,
    a.subindexno,
    a.approvereasons,
    a.defapptext,
    a.returnreasons,
    a.defrettext,
    a.rejectreasons,
    a.defregtext,
    aa.recordid,
    a.approvalcomments,
    a.rejectcomments,
    a.returncomments,
    'PEG'::text AS rectype,
    'NA'::text AS msgtype,
    a.returnable,
    a.initiator,
    a.initiator_approval,
    a.displaysubtitle,
    p.amendment,
    a.allowsend,
    a.allowsendflg,
    b.cmsg_appcheck,
    b.cmsg_return,
    b.cmsg_reject,
    b.showbuttons,
    NULL::text AS hlink,
    NULL::text AS hlink_transid,
    NULL::text AS hlink_params,
    'Pending'::text AS taskstatus,
    NULL::text AS statusreason,
    NULL::text AS statustext,
    NULL::text AS cancelremarks,
    NULL::text AS cancelledby,
    NULL::text AS cancelledon,
    NULL::text AS cancel,
    NULL::text AS username,
    'Active'::text AS cstatus
   FROM axactivetasks a
     JOIN axprocessdefv2 b ON a.processname::text = b.processname::text AND a.taskname::text = b.taskname::text
     JOIN axpdef_peg_processmaster p ON a.processname::text = p.caption::text
     LEFT JOIN axactivetasks aa ON a.processname::text = aa.processname::text AND a.keyvalue::text = aa.keyvalue::text AND a.transid::text = aa.transid::text AND aa.tasktype::text = 'Make'::text AND aa.recordid IS NOT NULL
  WHERE NOT (EXISTS ( SELECT b_1.taskid
           FROM axactivetaskstatus b_1
          WHERE a.taskid::text = b_1.taskid::text)) AND a.removeflg::text = 'F'::text
UNION ALL
 SELECT a.touser,
    a.processname,
    a.taskname,
    a.taskid,
    a.tasktype,
    a.eventdatetime AS edatetime,
    to_char(to_timestamp(a.eventdatetime::text, 'YYYYMMDDHH24MISSSSS'::text), 'dd/mm/yyyy hh24:mi:ss'::text) AS eventdatetime,
    a.fromuser,
    a.fromrole,
    a.displayicon,
    a.displaytitle,
    a.displaymcontent,
    a.displaycontent,
    a.displaybuttons,
    a.keyfield,
    a.keyvalue,
    a.transid,
    a.priorindex,
    a.indexno,
    a.subindexno,
    a.approvereasons,
    a.defapptext,
    a.returnreasons,
    a.defrettext,
    a.rejectreasons,
    a.defregtext,
    a.recordid,
    a.approvalcomments,
    a.rejectcomments,
    a.returncomments,
    'PEG'::text AS rectype,
    'NA'::text AS msgtype,
    a.returnable,
    a.initiator,
    a.initiator_approval,
    a.displaysubtitle,
    NULL::character varying AS amendment,
    a.allowsend,
    a.allowsendflg,
    NULL::text AS cmsg_appcheck,
    NULL::text AS cmsg_return,
    NULL::text AS cmsg_reject,
    NULL::character varying AS showbuttons,
    NULL::text AS hlink,
    NULL::text AS hlink_transid,
    NULL::text AS hlink_params,
    pr_pegv2_transcurstatus(a.transid, a.keyvalue, a.processname) AS taskstatus,
    b.statusreason,
    b.statustext,
    b.cancelremarks,
    b.cancelledby,
    b.cancelledon::character varying AS cancelledon,
    b.cancel,
        CASE
            WHEN a.indexno = 1::numeric THEN a.fromuser
            ELSE a.touser
        END AS username,
    'Completed'::text AS cstatus
   FROM axactivetasks a
     JOIN axactivetaskstatus b ON a.taskid::text = b.taskid::text
UNION ALL
 SELECT axactivemessages.touser,
    axactivemessages.processname,
    axactivemessages.taskname,
    axactivemessages.taskid,
    axactivemessages.tasktype,
    axactivemessages.eventdatetime AS edatetime,
    to_char(to_timestamp(axactivemessages.eventdatetime::text, 'YYYYMMDDHH24MISSSSS'::text), 'dd/mm/yyyy hh24:mi:ss'::text) AS eventdatetime,
    axactivemessages.fromuser,
    NULL::character varying AS fromrole,
    axactivemessages.displayicon,
    axactivemessages.displaytitle,
    NULL::text AS displaymcontent,
    axactivemessages.displaycontent,
    NULL::character varying AS displaybuttons,
    axactivemessages.keyfield,
    axactivemessages.keyvalue,
    axactivemessages.transid,
    0 AS priorindex,
    axactivemessages.indexno,
    0 AS subindexno,
    NULL::character varying AS approvereasons,
    NULL::character varying AS defapptext,
    NULL::character varying AS returnreasons,
    NULL::character varying AS defrettext,
    NULL::character varying AS rejectreasons,
    NULL::character varying AS defregtext,
    0 AS recordid,
    NULL::character varying AS approvalcomments,
    NULL::character varying AS rejectcomments,
    NULL::character varying AS returncomments,
    'MSG'::text AS rectype,
    axactivemessages.msgtype,
    'F'::character varying AS returnable,
    NULL::character varying AS initiator,
    NULL::character varying AS initiator_approval,
    NULL::character varying AS displaysubtitle,
    p.amendment,
    'F'::character varying AS allowsend,
    'F'::character varying AS allowsendflg,
    NULL::text AS cmsg_appcheck,
    NULL::text AS cmsg_return,
    NULL::text AS cmsg_reject,
    NULL::character varying AS showbuttons,
    axactivemessages.hlink,
    axactivemessages.hlink_transid,
    axactivemessages.hlink_params,
    'Completed'::text AS taskstatus,
    NULL::text AS statusreason,
    NULL::text AS statustext,
    NULL::text AS cancelremarks,
    NULL::text AS cancelledby,
    NULL::text AS cancelledon,
    NULL::text AS cancel,
    NULL::text AS username,
    'Completed'::text AS cstatus
   FROM axactivemessages
     LEFT JOIN axpdef_peg_processmaster p ON axactivemessages.processname::text = p.caption::text
  WHERE NOT (EXISTS ( SELECT b.taskid
           FROM axactivetaskstatus b
          WHERE axactivemessages.taskid::text = b.taskid::text)) AND (axactivemessages.transid::text <> ALL (ARRAY['tassk'::character varying::text, 'ticke'::character varying::text, 'send'::character varying::text, 'retun'::character varying::text, 'taskc'::character varying::text, 'close'::character varying::text, 'drop'::character varying::text, 'infor'::character varying::text, 'stupd'::character varying::text, 'Taskm'::character varying::text]))
UNION ALL
 SELECT axactivemessages.touser,
    axactivemessages.processname,
    axactivemessages.taskname,
    axactivemessages.taskid,
    axactivemessages.tasktype,
    axactivemessages.eventdatetime AS edatetime,
    to_char(to_timestamp(axactivemessages.eventdatetime::text, 'YYYYMMDDHH24MISSSSS'::text), 'dd/mm/yyyy hh24:mi:ss'::text) AS eventdatetime,
    axactivemessages.fromuser,
    NULL::character varying AS fromrole,
    axactivemessages.displayicon,
    axactivemessages.displaytitle,
    NULL::text AS displaymcontent,
    axactivemessages.displaycontent,
    NULL::character varying AS displaybuttons,
    axactivemessages.keyfield,
    axactivemessages.keyvalue,
    axactivemessages.transid,
    0 AS priorindex,
    axactivemessages.indexno,
    0 AS subindexno,
    NULL::character varying AS approvereasons,
    NULL::character varying AS defapptext,
    NULL::character varying AS returnreasons,
    NULL::character varying AS defrettext,
    NULL::character varying AS rejectreasons,
    NULL::character varying AS defregtext,
    0 AS recordid,
    NULL::character varying AS approvalcomments,
    NULL::character varying AS rejectcomments,
    NULL::character varying AS returncomments,
    'MSG'::text AS rectype,
        CASE
            WHEN axactivemessages.transid::text = 'tassk'::text THEN 'Task'::text
            WHEN axactivemessages.transid::text = ANY (ARRAY['ticke'::text, 'send'::text, 'retun'::text, 'taskc'::text, 'close'::text, 'drop'::text, 'infor'::text, 'stupd'::text, 'Taskm'::text]) THEN 'Ticket'::text
            ELSE NULL::text
        END AS msgtype,
    'F'::character varying AS returnable,
    NULL::character varying AS initiator,
    NULL::character varying AS initiator_approval,
    NULL::character varying AS displaysubtitle,
    'F'::character varying AS amendment,
    'F'::character varying AS allowsend,
    'F'::character varying AS allowsendflg,
    NULL::text AS cmsg_appcheck,
    NULL::text AS cmsg_return,
    NULL::text AS cmsg_reject,
    NULL::character varying AS showbuttons,
    axactivemessages.hlink,
    axactivemessages.hlink_transid,
    axactivemessages.hlink_params,
        CASE axactivemessages.transid
            WHEN 'tassk'::text THEN 'Task Assigned'::text
            WHEN 'Taskm'::text THEN 'Ticket Raised'::text
            WHEN 'send'::text THEN 'Forwarded'::text
            WHEN 'retun'::text THEN 'Returned'::text
            WHEN 'taskc'::text THEN 'Completed'::text
            WHEN 'close'::text THEN 'Closed'::text
            WHEN 'drop'::text THEN 'Dropped'::text
            WHEN 'infor'::text THEN 'Informed Delay'::text
            WHEN 'stupd'::text THEN 'Status Updated'::text
            ELSE NULL::text
        END AS taskstatus,
    NULL::text AS statusreason,
    NULL::text AS statustext,
    NULL::text AS cancelremarks,
    NULL::text AS cancelledby,
    NULL::text AS cancelledon,
    NULL::text AS cancel,
    NULL::text AS username,
    'Completed'::text AS cstatus
   FROM axactivemessages
  WHERE axactivemessages.transid::text = ANY (ARRAY['tassk'::character varying::text, 'ticke'::character varying::text, 'send'::character varying::text, 'retun'::character varying::text, 'taskc'::character varying::text, 'close'::character varying::text, 'drop'::character varying::text, 'infor'::character varying::text, 'stupd'::character varying::text, 'Taskm'::character varying::text]);
>>

<<
insert
	into
	axpages ("name",
	caption,
	props,
	blobno,
	img,
	visible,
	"type",
	parent,
	ordno,
	levelno,
	updatedon,
	createdon,
	importedon,
	createdby,
	updatedby,
	importedby,
	readonly,
	updusername,
	category,
	pagetype,
	intview,
	webenable,
	shortcut,
	icon,
	websubtype,
	workflow,
	oldappurl)
values('HP1784892186402',
'Inbox',
'htmlPages.aspx?load=1784892186402',
1,
null,
'F',
'p',
null,
(select max(ordno)+1 from axpages),
0,
'24/07/2026 4:50:04 PM',
'24/07/2026 4:50:04 PM',
null,
'admin',
'admin',
null,
null,
null,
null,
'web',
null,
null,
null,
null,
'htmlpage',
null,
null);
>>
 
<< 
INSERT INTO htmlsections (htmlsectionsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, pageno, caption, axpfile_hpimages, axpfilepath_hpimages, addtomenu, isacoretrans, menuposition, menulist, params, "template") VALUES(1592770000000, 'F', 0, NULL, 'admin', '2026-07-24', 'admin', '2026-07-24', NULL, 1, 1, NULL, NULL, NULL, '1784892186402', 'Inbox', NULL, 'D:\qabiz\Axpert11.4Base\AxpertWeb\defschema\HTMLPages\images\*', NULL, 'No', 'Default', NULL, NULL, NULL);
>>

<<
INSERT INTO sect2 (sect2id, htmlsectionsid, html_editor_htmlsrc) VALUES(1592770000001, 1592770000000, '<html xmlns="http://www.w3.org/1999/xhtml"><head runat="server">
    <title>Process Flow</title>
    <meta name="viewport" content="width=device-width, initial-scale=1a">
    <link rel="stylesheet" href="../../UI/axpertUI/style.bundle.css">
    <link rel="stylesheet" href="../../UI/axpertUI/plugins.bundle.css">
    <link rel="stylesheet" href="../../ThirdParty/jquery-confirm-master/jquery-confirm.min.css">
    

    <style>
        .v2-child-item {
            border-top: 1px solid #e5e5e5;
            margin-left: 20px;
        }

        .v2-child-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 12px;
            cursor: pointer;
            background: #fafafa;
        }

        .v2-child-body {
            display: none;
        }

        .v2-child-body.show {
            display: block;
        }

        .people-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 16px;
            cursor: pointer;
            border-bottom: 1px solid #eee;
            align-items: center;

            cursor: pointer;
            background-color: #fff;
            margin: 00;
            overflow: hidden;
        }

        .people-row:hover {
            background: #f7f9fc;
        }

        .people-scheduler {
            visibility: hidden;
            color: #4e86c7;
            cursor: pointer;
        }

        .people-row:hover .people-scheduler {
            visibility: visible;
        }
    </style>
    <!-- <style>
        #Process-stepper {

            flex: none !important;
            margin-left: 32.3333% !important;
            width: 67.6667% !important;
            max-width: 115% !important;
            background: #fff;
            position: relative;
            z-index: 10;
            top: 3px;

            /* scrollbar */
            overflow-x: auto !important;
            overflow-y: hidden !important;
            white-space: nowrap;
            height: 40px;
        }

        #horizontal-processbar {
            display: inline-flex !important;
            width: max-content !important;
            min-width: max-content !important;
            flex-wrap: nowrap !important;
        }

        body#Task_activity {
            overflow: hidden;
        }

        div#ktMenu {
            /* transform: translate(327px, 35px)!important; */
            cursor: pointer;
            padding: 8px;
            font-size: small;
            font-weight: 500;
            position: absolute;
            inset: unset !important;
            transform: none !important;
        }

        .text-hover-primary:hover {
            background: #d3d3d35c;
            transition: color .2s ease, background-color .2s ease;
            /* color: #0774fe!important; */
            /* width: -webkit-fill-available; */
            color: black !important;
        }


        .user-main {
            background: #4e86c7;
            color: #fff;
            padding: 5px 16px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            display: block;
            align-items: center;
            user-select: none;
            position: relative !important;
            z-index: 100000 !important;
            pointer-events: auto;
            font-size: 15spx;
            font-size: 15px;
            min-width: 110px;
            max-width: 160px;
            left: -10px;
        }

        .arrow {
            position: absolute;
            right: 0px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 12px;
            pointer-events: none;

        }

        .group-btn .material-icons {
            font-size: 18px;
        }



        .user-item {
            padding: 10px 14px;
            cursor: pointer;
            font-size: 14px;
        }




        /* ===============================
   INBOX USER SWITCHER — FINAL FIX
================================ */

        #topPanel {
            position: relative !important;
            overflow: visible !important;

        }

        .inbox-user-switcher {
            position: relative !important;
            display: inline-block;
            z-index: 9999;

        }


        /* Dropdown menu */
        .user-dropdown {
            position: absolute !important;
            top: calc(100% + 6px);
            left: 0;
            min-width: 200px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            display: none;
            z-index: 100001 !important;
            transform: none !important;
            inset: unset !important;
            top: 46px !important;
            left: -11px !important;
        }

        /* When opened */
        .user-dropdown.open {
            display: block !important;
        }

        /* Prevent Axpert overlays from covering it */
        .Page-Title,
        .Title-Section,
        .Tkts-toolbar-Right,
        .Tkts-toolbar-Left {
            overflow: visible !important;
        }



        .user-item:hover {
            background: #f3f6fb;
        }

        /* .pagename{
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    width: max-content;
    gap: 4px;
} */
        .icon-filters {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .icon-filter {
            display: flex;
            align-items: center;
            /* gap: 6px; */
            padding: 6px 10px;
            border-radius: 8px;
            cursor: pointer;
            background: #f3f6fb;
            color: #444;
            font-size: 12px;
            transition: all .2s ease;
            margin: 10px 0px;
        }

        .icon-filter .material-icons {
            font-size: 18px;
        }

        .icon-filter:hover {
            background: #e1e7f5;
        }

        .icon-filter.active {
            background: #4e86c7;
            color: white;
        }

        .icon-filter .count {
            font-size: 11px;
            opacity: 0.85;
        }

        .icon-all {
            color: #3b82f6;
        }

        /* Blue */
        .icon-active {
            color: #f59e0b;
        }

        /* Amber */
        .icon-completed {
            color: #22c55e;
        }

        /* Green */
        .icon-sent {
            color: #6366f1;
        }

        /* Indigo */
        .icon-pending {
            color: #f97316;
        }

        /* Orange */
        .icon-approved {
            color: #10b981;
        }

        /* Teal */
        .icon-rejected {
            color: #ef4444;
        }

        /* Red */
        .icon-returned {
            color: #8b5cf6;
        }

        /* Violet */
        .icon-filter.active .material-icons {
            color: inherit;
        }

        .icon-message {
            color: #0ea5e9;
        }

        /* Sky Blue */
        .icon-notification {
            color: #facc15;
        }

        /* Yellow */
        .inbox-user-select {
            padding: 6px 14px;
            border-radius: 6px;
            border: 1px solid #d0d5dd;
            background: #2563eb;
            color: #fff;
            font-weight: 600;
            cursor: pointer;
        }

        .inbox-user-select {
            background: #4e86c7;
            color: #fff;
            padding: 6px 36px 6px 16px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            font-size: 15px;
            border: none;
            outline: none;
            appearance: none;
            min-width: 140px;
            max-width: 200px;
            background-image: url("data:image/svg+xml;utf8,<svg fill=''white'' height=''16'' viewBox=''0 0 24 24'' width=''16'' xmlns=''http://www.w3.org/2000/svg''><path d=''M7 10l5 5 5-5z''/></svg>");
            background-repeat: no-repeat;
            background-position: right 10px center;
        }

        .inbox-user-select option {
            color: #000;
        }

        /* Make ONLY the dropdown options white */
        .inbox-user-select option {
            background: #ffffff !important;
            color: #000000 !important;
        }

        /* Highlight on hover / selected option */
        .inbox-user-select option:checked,
        .inbox-user-select option:hover {
            background: #f3f6fb !important;
            color: #000000 !important;
        }

        .filter-group {
            position: relative;
        }

        .group-btn {
            display: flex;
            align-items: center;
            gap: 6px;
            background: #f3f6fb;
            border-radius: 8px;
            padding: 6px 12px;
            border: none;
            cursor: pointer;
            font-size: 13px;
            width: 100px;
        }

        .group-btn:hover {
            background: #e1e7f5;
        }

        .group-btn .arrow {
            font-size: 16px;
            transition: .2s;
        }

        .filter-group.open .arrow {
            transform: rotate(180deg);
        }

        .group-menu {
            position: absolute;
            top: 115%;
            left: 0;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, .15);
            padding: 6px;
            display: none;
            z-index: 1000;
            min-width: 210px;
        }

        .filter-group.open .group-menu {
            display: block;
        }

        .group-menu .icon-filter {
            width: 100%;
            justify-content: flex-start;
            border-radius: 6px;
        }

        .group-menu .icon-filter:hover {
            background: #f3f6fb;
        }

        /* 
        new */

        .inbox-sub-toolbar {
            display: flex;
            align-items: center;
            gap: 40px;
            /* padding: 8px 12px; */
            /* border-bottom: 1px solid #e5e7eb; */
            /* background: #fff; */
        }

        .all-toggle {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
        }

        .filter-btn {
            border: none;
            background: transparent;
            cursor: pointer;
        }

        .active-filters {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .filter-chip {
            background: #eef2f7;
            border-radius: 14px;
            padding: 4px 10px;
            font-size: 12px;
        }

        .filter-chip span {
            cursor: pointer;
            margin-left: 6px;
        }



        .hidden {
            display: none !important;
        }

        .inbox-sub-toolbar {
            position: relative;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .filter-wrapper {
            position: relative;
            /* 🔑 anchor for popup */
        }

        .filter-panel {
            display: none;
            position: absolute;
            top: calc(100% - 12px);
            left: 220px;
            width: 330px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 10px 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
        }




        .filter-panel label {
            display: inline-block;
            width: 48%;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .filter-panel.show {
            display: block;
            position: absolute;
            z-index: 2000;
        }


        .filter-option {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 6px 0;
            cursor: pointer;
        }

        .filter-btn {
            background: none;
            border: none;
            cursor: pointer;
        }



        .filter-message-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            /* pushes X to last */
            background: #eaeef2;
            padding: 5px 16px;
            border-radius: 4px;
            margin: 0;
            font-size: 14px;
        }

        #filterMessageText {
            flex: 1;
        }


        .close-btn {
            background: transparent;
            border: 1px solid #94a3b8;
            color: #1f2937;
            width: 28px;
            height: 28px;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .all-toggle.active {
            color: #2563eb;
            font-weight: 600;
        }

        .search-box {
            position: relative;
            display: flex;
            align-items: center;
        }

        .search-input {
            flex: 1;
            padding-right: 149px;
            /* width: 178%; */
            padding-left: 5px;
        }

        .filter-icon {
            position: absolute;
            right: 10px;
            cursor: pointer;
            color: #888;
        }

        .filter-icon.active {
            color: #0d6efd;
            /* blue highlight */
        }

        .menu.menu-sub.menu-sub-dropdown.menu-rounded.menu-gray-600.menu-state-bg-light.fw-bolder.w-300px.py-3.initialized.show {
            position: absolute;
            right: 0px;
        }

        #plistContent {
            height: 90vh;
            overflow-y: auto;
        }

        #filterMessageBar {
            position: absolute;
            top: 82px;
            left: 0;
            right: 0;
            z-index: 1000;
            /* background: #eef4ff; */
            padding: 0px 16px;
            border-bottom: 1px solid #ddd;
            transform: translateY(-100%);
            transition: transform 0.3s ease;
        }

        #filterMessageBar.show {
            transform: translateY(0);
        }

        #filterMessageBar.hidden {
            transform: translateY(-100%);
        }

        .nametime {
            display: block;
            width: 80px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .content:has(#New-Landing-layout) {
            background: #f1f4f9 !important;
            height: 50vh !important;
            max-height: calc(100vh - 90px) !important;
        }

        /* ul#horizontal-processbar { */
        /* margin-top: 45px !important; */
        /* padding: 0px !important; */
        /* } */
        /* #Process-stepper {
    display: block !important;
    flex: none !important;
    margin-left: 32.3333% !important;
    width: 44.6667% !important;
    /* max-width: 82.6667% !important; 
    background: #fff;
    max-width: 68% !important;
    position: relative;
    z-index: 10;
    top: 3px;
    overflow-x: auto;
    overflow-y: hidden;
} */
        /* 
#horizontal-processbar {
    width: max-content;
    min-width: 100%;
} */
        .deep-search-highlight {
            animation: highlightFlash 1s ease-in-out 3;
            background: #fff3cd;
            border: 1px solid #ffc107;
        }

        @keyframes highlightFlash {
            0% {
                background: #fff3cd;
            }

            50% {
                background: #ffe69c;
            }

            100% {
                background: #fff3cd;
            }
        }

        .custom-header {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* button style */
        .hdr-btn {
            padding: 6px 14px;
            background: #4e86c7;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            white-space: nowrap;
            color: white;
        }

        .hdr-btn.active {
            background: #4e86c7;
            color: black;
        }

        /* fix select alignment */
        .inbox-user-switcher {
            display: flex;
            align-items: center;
        }

        /* dropdown */
        .hdr-dropdown {
            position: relative;
            width: 180px;
        }

        .dropdown-menu {
            position: absolute;
            top: 110%;
            left: 0;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
            display: none;
            min-width: 180px;
            z-index: 9999;
        }

        .dropdown-item {
            padding: 8px 12px;
            cursor: pointer;
        }

        .dropdown-item:hover {
            background: #f3f6fb;
        }

        /* show dropdown */
        .hdr-dropdown.open .dropdown-menu {
            display: block;
        }

        .dots-menu {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            padding: 0;
            border-radius: 50%;
        }

        .dots-menu .material-icons {
            font-size: 20px;
        }

        .dropdown-submenu {
            position: relative;
        }

        .dropdown-submenu .submenu {
            display: none;
            position: absolute;
            left: 100%;
            top: 0;
            min-width: 180px;
            background: #fff;
            border-radius: 6px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        }

        .dropdown-submenu:hover .submenu {
            display: block;
        }

        .submenu-toggle {
            display: flex;
            justify-content: space-between;
        }

        .accordion-header {
            padding: 8px 12px;
            background: #f3f6fb;
            cursor: pointer;
            border-bottom: 1px solid #ddd;
            font-weight: 500;
            display: flex;
            justify-content: space-between;
        }

        .accordion-body {
            padding: 8px 12px;
            background: #fff;
        }

        .task-item {
            padding: 4px 0;
            font-size: 13px;
            border-bottom: 1px dashed #eee;
        }

        .search-highlight {
            border: 2px solid #90ee90;
            /* light green */
            border-radius: 6px;
            background: #f0fff0;
        }

        /* Target the actual header element */
        .user-main {
            position: sticky !important;
            top: 0;
            z-index: 1050;
            /* Stays above task cards */
            background: white;
        }

        .submenu-toggle {
            pointer-events: none;
            /* ❌ disable click */
            cursor: default;
            /* normal cursor */
            font-weight: 600;
            /* looks like header */
        }

        .stepper-horizontal li:not(:first-child)::before {
            position: relative;
            -webkit-box-flex: 1;
            flex: 1 1 0%;
            height: 1px;
            margin: 0.5rem 0px 0px;
            content: "";
            background-color: rgba(0, 0, 0, 0.1);
            min-width: 40px;
        }


        /* v2css */
        .v2-accordion-item {
            border-bottom: 1px solid #e5e7eb;
        }

        .v2-accordion-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px 16px;
            cursor: pointer;
            background: #fff;
        }

        .v2-accordion-header.active {
            background: #eff6ff;
        }

        .v2-left {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .v2-arrow {
            font-family: ''Material Icons'';
            font-size: 18px;
        }

        .v2-title {
            font-size: 14px;
            font-weight: 600;
        }

        .v2-accordion-body {
            display: none;
            background: #fff;
        }

        .empty-state {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 40px;
            color: #888;
        }

        .v2-accordion-body.show {
            display: block;
        }

        .v2-pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
            padding: 12px;
        }

        .page-btn {
            border: none;
            background: #2563eb;
            color: #fff;
            padding: 4px 10px;
            border-radius: 4px;
            cursor: pointer;
        }

        .v2-accordion-item {
            border-bottom: 1px solid #e5e7eb;
        }

        .v2-accordion-header {
            position: sticky;
            top: 0;
            z-index: 10;

            background: #fff;

            display: flex;
            justify-content: space-between;
            align-items: center;

            padding: 14px 16px;

            cursor: pointer;

            border-bottom: 1px solid #e5e7eb;
        }

        .v2-accordion-header.active {
            background: #eff6ff;
        }

        .v2-accordion-body {
            display: none;
        }

        .v2-accordion-body.show {
            display: block;
        }

        .v2-scroll-body {

            max-height: 319px;

            overflow-y: auto;

            background: #fff;
        }

        .v2-scroll-body[data-section="people"],
        .v2-scroll-body[data-section="groups"] {
            max-height: 240px;
        }

        #body_Container {
            display: flex;
            flex-direction: column;
            min-height: 0;
        }

        #ProcessFlow_New-container,
        #ProcessFlow_Content,
        #tickets,
        #InboxAccordion {
            display: flex;
            flex-direction: column;
            flex: 1;
            min-height: 0;
        }

        #InboxAccordion {
            flex: 1;
            overflow-y: auto;
        }

        #Tickets_details_view {
            display: flex;
            flex-direction: column;
            overflow: hidden;
            max-height: 90vh;
            position: relative;
        }

        .directory-chat-panel {
            position: absolute;
            inset: 0;
            z-index: 20;
            display: flex;
            flex-direction: column;
            background: #f8fbff;
        }

        .directory-chat-panel.d-none {
            display: none !important;
        }

        #process_centerpanel {
            width: 100%;
            height: 100%;
            margin-bottom: 0;
            border: 0;
            background: transparent;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            min-height: 0;
        }

        .chat-shell {
            height: 100%;
            min-height: 0;
            display: flex;
            flex-direction: column;
            background: #f8fbff;
        }

        .chat-shell-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 16px 18px;
            background: #fff;
            border-bottom: 1px solid #dbe4f0;
        }

        .chat-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 0;
        }

        .chat-avatar {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: 700;
            font-size: 15px;
            background: #2563eb;
            flex: none;
            box-shadow: 0 10px 18px rgba(37, 99, 235, 0.14);
        }

        .chat-avatar.chat-avatar-group {
            background: #0f766e;
            box-shadow: 0 10px 18px rgba(15, 118, 110, 0.12);
        }

        .chat-name {
            font-size: 18px;
            font-weight: 700;
            line-height: 1.2;
            color: #1f2937;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .chat-subline {
            margin-top: 4px;
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            font-size: 12px;
            color: #64748b;
        }

        .chat-chip {
            display: inline-flex;
            align-items: center;
            padding: 4px 9px;
            border-radius: 999px;
            background: #eef4ff;
            color: #2563eb;
            font-size: 11px;
            font-weight: 600;
            white-space: nowrap;
        }

        .chat-actions {
            display: flex;
            align-items: center;
            gap: 8px;
            flex: none;
        }

        .chat-icon-btn {
            width: 36px;
            height: 36px;
            border: none;
            border-radius: 10px;
            background: #f3f7fb;
            color: #475569;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: default;
        }

        .chat-feed {
            flex: 1;
            min-height: 0;
            overflow-y: auto;
            padding: 18px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .chat-empty {
            flex: 1;
            min-height: 220px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: #64748b;
        }

        .chat-empty-card {
            background: #fff;
            border: 1px solid #dbe4f0;
            border-radius: 18px;
            padding: 22px 24px;
            box-shadow: 0 14px 30px rgba(15, 23, 42, 0.06);
            max-width: 360px;
        }

        .chat-empty-title {
            margin-top: 12px;
            font-size: 16px;
            font-weight: 700;
            color: #1f2937;
        }

        .chat-empty-meta {
            margin-top: 8px;
            font-size: 13px;
            line-height: 1.5;
            color: #64748b;
        }

        .chat-message {
            display: flex;
            align-items: flex-end;
            gap: 8px;
            max-width: 50%;
        }

        .chat-message.self {
            margin-left: auto;
            flex-direction: row-reverse;
        }

        .chat-avatar-sm {
            width: 32px;
            height: 32px;
            border-radius: 10px;
            background: #dbeafe;
            color: #1d4ed8;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 700;
            flex: none;
        }

        .chat-bubble {
            padding: 6px 12px;
            border-radius: 18px;
            background: #f0f0f0;
            border: none;
            box-shadow: none;
            color: #1f2937;
            line-height: 0.8;
            white-space: unset;
            font-size: 14px;
            padding: 17px;
        }

        .chat-message.self .chat-bubble {
            background: #0078d4;
            border-color: #0078d4;
            color: #fff;
            border-radius: 18px;
        }

        .chat-message-meta {
            margin-top: 2px;
            display: flex;
            justify-content: space-between;
            gap: 4px;
            font-size: 10px;
            color: #64748b;
        }

        .chat-message.self .chat-message-meta {
            color: rgba(255, 255, 255, 0.85);
        }

        .chat-composer {
            padding: 14px 16px;
            background: #fff;
            border-top: 1px solid #dbe4f0;
            display: flex;
            gap: 10px;
            align-items: flex-end;
        }

        .chat-input-wrap {
            flex: 1;
            position: relative;
        }

        .chat-input {
            width: 100%;
            min-height: 46px;
            max-height: 120px;
            resize: none;
            border: 1px solid #dbe4f0;
            border-radius: 14px;
            padding: 12px 14px;
            outline: none;
            font-size: 14px;
            line-height: 1.4;
            background: #f8fbff;
            color: #1f2937;
        }

        .chat-input:focus {
            border-color: #93c5fd;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.12);
            background: #fff;
        }

        .chat-send {
            width: 44px;
            height: 44px;
            border: none;
            border-radius: 14px;
            background: #2563eb;
            color: #fff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 10px 18px rgba(37, 99, 235, 0.18);
        }

        .chat-send:disabled {
            background: #94a3b8;
            box-shadow: none;
        }

        .directory-row {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 16px 18px;
            cursor: pointer;
            border-bottom: 1px solid #eef2f7;
            background: #fff;
            transition: background 0.15s ease, border-color 0.15s ease;
        }

        .directory-row:hover {
            background: #f8fbff;
        }

        .directory-row.selected {
            background: #eaf2ff;
            border-left: 3px solid #2563eb;
            padding-left: 15px;
        }

        .directory-row.group-member-row {
            padding-left: 44px;
            background: #fbfdff;
        }

        .directory-row.group-member-row.selected {
            padding-left: 41px;
        }

        .group-loading,
        .group-empty {
            padding: 12px 18px 12px 72px;
            font-size: 13px;
            color: #64748b;
            background: #fbfdff;
            border-bottom: 1px solid #eef2f7;
        }

        .directory-avatar {
            width: 44px;
            height: 44px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #dbeafe;
            color: #1d4ed8;
            font-weight: 700;
            flex: none;
            box-shadow: 0 8px 14px rgba(59, 130, 246, 0.08);
        }

        .directory-avatar.directory-avatar-group {
            background: #dcfce7;
            color: #166534;
            box-shadow: 0 8px 14px rgba(22, 101, 52, 0.08);
        }

        .directory-main {
            flex: 1;
            min-width: 0;
        }

        .directory-name {
            font-size: 15px;
            font-weight: 700;
            color: #0f172a;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .directory-meta {
            margin-top: 5px;
            font-size: 12px;
            color: #64748b;
            line-height: 1.45;
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .directory-badges {
            margin-top: 8px;
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .directory-badge {
            display: inline-flex;
            align-items: center;
            padding: 3px 8px;
            border-radius: 999px;
            background: #eef2ff;
            color: #4f46e5;
            font-size: 11px;
            font-weight: 600;
            white-space: nowrap;
        }

        .directory-cta {
            color: #94a3b8;
            font-size: 18px;
            margin-top: 8px;
            flex: none;
        }
    </style> -->
	
	<link type="text/css" rel="stylesheet" href="Css/AxpertInbox_1784892186402.css?v=1785216335706">
</head>


<body id="Process_Flow" class="header-fixed header-tablet-and-mobile-fixed aside-fixed overflow-hidden vh-100 min-vh-100">

    <!--begin::Content-->
    <div class="content-- d-flex flex-column flex-column-fluid">
        <!--begin::Container-->
        <div id="pf_content_container" class="">
            <!--begin::Row-->

            <div class="row overflow-hidden-- vh-100-- min-vh-100--" id="PROFLOW-overalldiv">
                <div class="Page-Title-Bar">
                    <div class="Title-Section">


                        <div class="Tkts-toolbar-Right">
                            <button id="" type="submit" class="btn btn-sm btn-icon btn-primary btn-active-primary btn-custom-border-radius d-none">
                                <span class="material-icons material-icons-style material-icons-2">add_task</span>
                            </button>
                            <button type="submit" id="" class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm tb-btn btn-sm" title="Refresh Page" onclick="axProcessObj.refreshPage();">
                                <span class="material-icons material-icons-style material-icons-2">refresh</span>
                            </button>

                            <button id="pd_timeline" class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm tb-btn btn-sm d-none" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-start" data-kt-menu-flip="top-end" data-kt-menu-attach="parent" title="Timeline">
                                <span class="material-icons material-icons-style material-icons-2">history_toggle_off</span>
                            </button>

                            <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light fw-bolder w-400px py-3" data-kt-menu="true" data-id="pd_timeline">
                                <div id="TimeLine_overall" class="content">
                                    <div class="card" id="Timeline-wrap">
                                        <h1 class="Timeline-heading">
                                            Timeline
                                        </h1>
                                        <ul class="Timel-sessions full-session d-none">
                                        </ul>
                                        <span id="nodata" class="p-5">No Timeline data available.</span>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <div class="top-panel" id="topPanel">

                            <div class="Page-Title" id="process-name">
                                <input type="checkbox" class="maincheckbox">

                                <div class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm  tb-btn btn-sm " data-kt-menu-attach="parent" data-bs-title="Hide record List" data-bs-toggle="tooltip" data-bs-placement="bottom" title="" id="collapseicon">
                                    <span class="material-icons material-icons-style material-icons-2">menu</span>
                                </div>


                                <span>My Inbox</span>



                                <div class="Tkts-toolbar-Left">
                                    <div class="d-flex gap-1">
                                        <div class="d-flex-- align-items-stretch flex-shrink-0 gap-8 filterAlignChild">
                                            <div class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm  tb-btn btn-sm d-none" data-kt-menu-attach="parent" data-bs-title="Next Record" data-bs-toggle="tooltip" data-bs-placement="bottom" id="nextrecord">
                                                <span class="material-icons material-icons-style material-icons-2">arrow_downward</span>
                                            </div>
                                            <div class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm  tb-btn btn-sm d-none" data-kt-menu-attach="parent" data-bs-title="Previous Record" data-bs-toggle="tooltip" data-bs-placement="bottom" id="previousrecord">
                                                <span class="material-icons material-icons-style material-icons-2">arrow_upward</span>
                                            </div>



                                            <div class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm  tb-btn btn-sm" data-kt-menu-placement="bottom" data-kt-menu-flip="top" data-kt-menu-attach="parent" id="filterButton" data-kt-menu-trigger="click">
                                                <span class="material-icons material-icons-style material-icons-2" data-bs-toggle="tooltip" data-bs-title="Filter">filter_list</span>
                                            </div>

                                            <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded  menu-title-gray-700 menu-icon-gray-500 menu-active-bg menu-state-color fw-semibold py-4 fs-base w-250px" data-kt-menu="true" id="ktMenu" data-kt-element="theme-mode-menu">
                                                <div class="menu-item cursor-pointer">
                                                    <a href="#" class="menu-link active" id="alllist" data-id="all">
                                                        <span class="menu-icon">
                                                            <span class="material-icons">mail</span></span>
                                                        <span class="menu-title">All</span>
                                                        <span class="menu-count">150</span>
                                                    </a>
                                                </div>
                                                <div class="menu-item cursor-pointer">
                                                    <a href="#" class="menu-link" id="Open_Task" data-id="">
                                                        <span class="menu-icon">
                                                            <span class="material-icons">mark_email_unread</span></span>

                                                        <span class="menu-title">Open Task</span>
                                                        <span class="menu-count">10</span>
                                                    </a>
                                                </div>
                                                <div class="menu-item cursor-pointer">
                                                    <a href="#" class="menu-link" id="My_Team" data-id="">
                                                        <span class="menu-icon">
                                                            <span class="material-icons">groups</span></span>

                                                        <span class="menu-title">My Team</span>
                                                        <span class="menu-count">10</span>
                                                    </a>
                                                </div>
                                                <div class="menu-item cursor-pointer">
                                                    <a href="#" class="menu-link" id="Pending_Approval" data-id="">
                                                        <span class="menu-icon">
                                                            <span class="material-icons">mark_email_read</span></span>

                                                        <span class="menu-title">Pending Approval</span>
                                                        <span class="menu-count">10</span>
                                                    </a>
                                                </div>
                                                <div class="menu-item cursor-pointer">
                                                    <a href="#" class="menu-link" id="Unread" data-id="">
                                                        <span class="menu-icon">
                                                            <span class="material-icons">unsubscribe</span></span>

                                                        <span class="menu-title">Unread</span>
                                                        <span class="menu-count">10</span>
                                                    </a>
                                                </div>
                                                <div class="menu-item cursor-pointer">
                                                    <a href="#" class="menu-link" id="Send_Items" data-id="completed">
                                                        <span class="menu-icon">
                                                            <span class="material-icons">forward_to_inbox</span></span>

                                                        <span class="menu-title">Send Items</span>
                                                        <span class="menu-count">110</span>
                                                    </a>
                                                </div>


                                            </div>

                                            <div class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm  tb-btn btn-sm selectbtn" data-kt-menu-placement="bottom" data-kt-menu-flip="top" data-kt-menu-attach="parent">
                                                <span class="material-icons material-icons-style material-icons-2" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="Select">copy</span>
                                            </div>

                                        </div>

                                    </div>
                                </div>
                            </div>



                            <!-- Actions Section -->
                            <div class="d-flex Right-Header-Section">



                                <!-- <div class="Filter-Section-wrapper">
                                    <span style="
                                  font-size: small;
                                  display: flex;
                                  align-items: center;
                                  justify-content: center;
                                  color: gray;
                                  margin: 5px;
                              ">Filter</span>
                                    <div class="hdr-dropdown main-filter">

                                        <div class="hdr-btn submenu-toggle dropdown-toggle">
                                            All
                                            <!-- <span class="material-icons arrow">expand_more</span>
                                        </div>

                                        <div class="dropdown-menu">

                                            <!-- ALL
                                            <div class="dropdown-item" data-id="ALL">All</div>

                                            <!-- MY TASKS 
                                            <div class="dropdown-item" data-id="Open Tasks">My Tasks</div>

                                            <!-- MY TEAM TASKS
                                            <div class="dropdown-submenu">
                                                <div class="dropdown-item submenu-toggle dropdown-toggle">
                                                    My Team Tasks
                                                </div>
                                                <div class="submenu">
                                                    <div class="dropdown-item" data-id="TeamAll">All</div>
                                                    <!-- dynamically append team members 
                                                    <div id="userSelect"></div>
                                                </div>
                                            </div>

                                            <!-- PENDING APPROVAL
                                            <div class="dropdown-item" data-id="Pending">My Pending Approvals</div>

                                            <!-- OTHER FILTERS 
                                            <div class="dropdown-submenu">
                                                <div class="dropdown-item submenu-toggle dropdown-toggle">
                                                    Other Filters
                                                </div>
                                                <div class="submenu">
                                                    <div class="dropdown-item" data-id="Approved">Approved</div>
                                                    <div class="dropdown-item" data-id="Rejected">Rejected</div>
                                                    <div class="dropdown-item" data-id="Returned">Returned</div>
                                                    <!-- <div class="dropdown-item" data-id="Messages">Messages</div> 
                                                    <div class="dropdown-item" data-id="Notifications">Notifications
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div> -->

                                <div class="section search-section">
                                    <div class="search-box">
                                        <input id="advTextSearch" class="search-input" placeholder="Search..">
                                        <span class="material-icons search-icon" id="deepSearchToggle">search</span>

                                        <!-- Deep search toggle -->
                                        <!-- <span id="deepSearchToggle" class="material-icons filter-icon" title="Deep Search">
                                              tune
                                                     </span> -->
                                    </div>
                                </div>
                                <div class="section actions">
                                    <div>
                                        <!-- Trigger -->
                                        <div id="pd_all_tasksNew" class="act btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm tb-btn btn-sm" onclick="axProcessObj.openBulkApprove();" data-kt-menu-placement="bottom-start" data-kt-menu-flip="top-start" data-kt-menu-attach="parent" title="Bulk Approve">
                                            <span class="material-icons material-icons-style material-icons-2">
                                                checklist
                                            </span>
                                        </div>

                                        <!-- Menu -->
                                        <div class="menu menu-sub menu-sub-dropdown menu-rounded menu-gray-600 menu-state-bg-light fw-bolder w-300px py-3" data-kt-menu="true" data-id="pd_all_tasksNew">
                                            <pd-alltasksnew></pd-alltasksnew>
                                        </div>
                                    </div>

                                    <button id="schedulerBtn" class="act btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm tb-btn btn-sm ">
                                        <span class="material-icons material-icons-style material-icons-2 initialized" data-bs-toggle="tooltip" data-bs-original-title="Scheduler" title="">calendar_month</span></button>

                                    <button id="refreshBtn" class="act btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm tb-btn btn-sm ">
                                        <span class="material-icons material-icons-style material-icons-2 initialized" data-bs-toggle="tooltip" data-bs-original-title="Refresh" title="">refresh</span></button>
                                </div>

                            </div>

                        </div>
                    </div>
                    <div class="row d-none" id="Process-stepper">
                        <div class="col-md-12" id="horizontal">
                            <ul class="stepper stepper-horizontal" id="horizontal-processbar">
                            </ul>
                        </div>
                    </div>
                </div>


                <div id="filterMessageBar" class="filter-message-bar hidden">

                    <span id="filterMessageText"></span>
                    <button id="closeFilterBar" class="close-btn">✕</button>
                </div>




                <!--begin:::Col-->
                <div class="col-xl-4 p-0 col-md-4 d-flex flex-column flex-column-fluid vh-100 min-vh-100" id="PROFLOW_Left">
                    <div class="card card-xl-stretch  flex-root h-1px  ">

                        <!--begin::Body-->
                        <div class="card-body h-300px mb-3" id="body_Container">
                            <div id="ProcessFlow_New-container">

                                <div class="tab-content" id="ProcessFlow_Content">
                                    <!-- <div class="tab-pane fade active show" role="tabpanel" id="Tickets_Pending">
                                        <div id="plistContentPending">
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" role="tabpanel" id="Tickets_Completed">
                                        <div id="plistContentCompleted">
                                        </div>
                                    </div> -->

                                    <div class="tab-pane fade active show" role="tabpanel" id="tickets">
                                        <div id="InboxAccordion" class="inbox-accordion"></div>

                                        <!-- <div id="plistContent"></div> -->
                                    </div>
                                </div>
                            </div>
                            <!--end::Body-->
                        </div>

                    </div>
                    <!--end::Table Widget 1-->
                </div>
                <!--end:::Col-->
                <!--begin:::Col-->
                <div id="PROFLOW_Right" class="p-0 col-xl-8  col-md-8 d-flex flex-column flex-column-fluid vh-100 min-vh-100">
                    <div class="card card-xl-stretch  flex-root h-1px  ">
                        <iframe data-ignore-history="true" class="d-none horizontal-iframe" id="rightIframe" src="about:blank"></iframe>
                        <!--begin::Body-->
                        <div class="card-body p-0" id="Tickets_details_view">
                            <div id="directoryChatPanel" class="directory-chat-panel d-none"></div>
                            <div class="card mb-5 mb-xl-2 h-100" id="process_centerpanel">
                                <div class="d-flex flex-column text-center h-100 justify-content-center" style="height:95%">
                                    <span class="material-icons material-icons-style material-icons-5tx mx-auto text-gray-500">add_task</span>
                                    <h3 class="fw-boldest">Select a task to load</h3>
                                    <h6 class="fst-italic text-gray-400">Nothing is selected</h6>
                                </div>
                            </div>
                            <!--end::Card body-->
                        </div>

                    </div>
                    <!--end:::Col-->
                </div>
                <div id="ProcessFlow_New_Right_Last" class="col-xl-2 col-md-2 d-flex flex-column flex-column-fluid vh-100 min-vh-100 d-block d-none">
                    <div class="card card-xl-stretch  flex-root h-1px  ">

                        <!--begin::Body-->
                        <div class="card-body h-300px ">
                            <div class="row">
                                <div class="col-xl-12 col-md-4 d-flex flex-column flex-column-fluid KPI_Section  ">
                                    <div class="card ">
                                        <div class="card-header collapsible cursor-pointer rotate " data-bs-toggle="collapse" aria-expanded="false" data-bs-target="#KPI-1">
                                            <h3 class="card-title">KPI Title</h3>
                                            <div class="card-toolbar rotate-180">
                                                <span class="material-icons material-icons-style material-icons-2">
                                                    expand_circle_down
                                                </span>
                                            </div>
                                        </div>
                                        <div class="collapse show" id="KPI-1">
                                            <div class="card-body">
                                                <figure>
                                                    <img class="img-fluid" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAw1BMVEX////DIC8mMlL/PzTnLDX99fa/AAm/ABD24+WGi5kYJ0t7gJDr7/D/Oi3/LR7/09Hzo6bmGyfnJS/rYWbajZHBDSLr2Nfk1Nf/r6z/MiTtcnbnDx4AGUPR1tu1vMDa3d/Fys7g4+Sqsbf19/gAAAC/xcipsbaNkJbXhIn67e4KIEgVJUr/6ej/GwCdpqyOmaD2u73wj5LmAADsVlsAAjtyeIl1eH6Dh40mLz8WIjUAABwiLDxHTVdfY2w2PEkAACEEFyxohIB5AAAC50lEQVR4nO3dDU/TQByA8fMFUDgR8F28l3J0Q9ThCxbUbfr9P5XtTIS1S2+DHtdbnl8II8s/Wx+2NeFyG0IAAAAAAAAAAAAAAAAAAAAAAADAIxdCG2F0+ZOJfSxByCOhRZ7lQmth5f+rXSniUXWqbBPGmqowu/YgrlGhFkofiYE2prwAAAC4rY2T5w0n72MfVZc2Nl80bD6KfVRd2ti817BFYVIoTB+F6aMwffEKTSakFUJJ7+TtRCvMsoHULs/Lb2HvKFqh1IOssZoYQrRCa7QbKKvU4Oo6J2X3z9l4r0NZPjvl7CsszqXpozB9FArx+HS77nQn1uHewBKFH+7Xba9Z4TaF/UYhhf1HIYX9RyGF/Uchhf0XrdBpfTd7E6MV5tY2VoQjrZcGKrROGVvbIxxEvNehVcLkd7DPmzMNhf1HIYX9RyGF/df3wtcLfFzpFvpeuPum4dPTlW6h74VPHjTsUjiPQgpDo9CPQgpvYamdeykXqpGY7b5sXy9NuNCpXC6xXppwobJnUkvvLuiEC6tXoFTenexJFy6FQvH5bdOX6wPJF+4dHtTtP7s+kH7h/sO6AwoppLBTFFJIYYXCsCikkMIKhWFRSGHk/aVaZ1l5sa6Fwpp/66XZ1XU3WC/tb6FQxs32l7YvJyZcKAe5U9o5bVvHEi5cEoUUUlihMCwKKaSwQmFYFFJIYYXCsCikkMJK4ELP+4DTL/S9l3u3af49M3tfDxu+zRduNcx/rv7O+bu68+8dFl7tL62WS+teLjA3kL1aYG7CO2BUk1lwLPJGn5bL/3sCAABYI3rom7BFYdsn3EWRtU/kRaFWOKhOXU59nyY1OhLH7RM/rPnZPjEcyV+R/nmvKvSZZ2Q0nrQ/znLqvZuhXuLJEsbFdHzpGfE+hu539bdaq7JwOFrtyLpy7MTU8/QZTc7+tE9cjCeT9onhuPD9IgNx5RnC91l10nhfQdJzoilvwzcBAAAAAAAAAACAyP4CTKCchAxIOYAAAAAASUVORK5CYII=">
                                                </figure>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card ">
                                        <div class="card-header collapsible cursor-pointer rotate" data-bs-toggle="collapse" aria-expanded="true" data-bs-target="#KPI-2">
                                            <h3 class="card-title">KPI Title</h3>
                                            <div class="card-toolbar rotate-180">
                                                <span class="material-icons material-icons-style material-icons-2">
                                                    expand_circle_down
                                                </span>
                                            </div>
                                        </div>
                                        <div class="collapse show" id="KPI-2">
                                            <div class="card-body">
                                                <figure>
                                                    <img class="img-fluid" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvyClOEGXUMdXM2DezoaC8GkYJ_Oo6BOSQAg&amp;usqp=CAU">
                                                </figure>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--end::Container-->
            </div>


        </div>
    </div>

    <!--end::Content-->
    <div id="waitDiv" class="page-loader rounded-2 bg-radial-gradient">
        <div class="loader-box-wrapper d-flex bg-white p-20 shadow rounded">
            <span class="loader"></span>
        </div>
    </div>

    <div class="modal fade" id="filterModal">
        <div class="modal-dialog modal-fullscreen modal-dialog-scrollable">
            <div class="modal-content">

                <!-- Modal body -->
                <div class="modal-body p-0">
                    <div class="container" id="dvModalFilter"></div>
                </div>


            </div>
        </div>
    </div>
    <div class="modal fade" id="teamModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-scrollable">
            <div class="modal-content">

                <!-- Header -->
                <div class="modal-header">
                    <h5 class="modal-title">Team Tasks</h5>
                    <button type="button" class="btn-close---" data-bs-dismiss="modal"></button>
                </div>

                <!-- Body -->
                <div class="modal-body" id="teamPopupContent">
                    <!-- Dynamic content -->
                </div>

            </div>
        </div>
    </div>

    <script type="text/javascript" src="../../UI/axpertUI/plugins.bundle.js"></script>
    <script type="text/javascript" src="../../UI/axpertUI/scripts.bundle.js"></script>
    <script type="text/javascript" src="../../ThirdParty/jquery-confirm-master/jquery-confirm.min.js"></script>
    <script type="text/javascript" src="../../Js/alerts.min.js?v=32"></script>
    <script type="text/javascript" src="../../Js/handlebars.min.js?v=2"></script>
    <script type="text/javascript" src="../../Js/common.min.js?v=158"></script>
    <script type="text/javascript" src="../../Js/helper.min.js?v=172"></script>
    <script type="text/javascript" src="../../Js/xmlToJson.min.js"></script>
    <script type="text/javascript" src="../../Js/AxProcessFlowCommon.min.js?v=1"></script>
    <script type="text/javascript" src="../HTMLPages/js/AxProcessFlow_V3.js?v=5"></script>
    <script src="../report/js/taskslst_inbox.js?v=1230202515104"></script>


    <script type="text/javascript">
        var _processName = ''AxProcessFlow'';
    </script>

    <script>
        class InboxV2 {

            constructor() {

                this.store = {
                    approvalPending: [],
                    approvalRequested: [],
                    reminders: [],
                    escalations: [],
                    completed: []

                };
                this.schedulerFromLHS = false;
                this.schedulerUserName = "";
                this.currentChildSection = "approvalPending";
                this.currentSection = "approvals";
                this.pageSize = 0;
                this.clientChunkSize = 20;
                this.clientRenderLimit = {

                    pending: 20,

                    completed: 20,
                    reminders: 20,
                    escalations: 20,
                };

                this.pagination = {
                    reminders: 1,
                    escalations: 1,
                    completed: 1
                };

                this.loading = {
                    tasks: false,
                    pending: false,
                    notifications: false,
                    completed: false,
                    reminders: true,
                    escalations: true,
                    people: false,
                    groups: false

                };
                this.visibleCount = {

                    reminders: 0,
                    escalations: 0,
                    approvalPending: 0,
                    approvalRequested: 0,

                    completed: 0
                };
                this.hasMore = {
                    tasks: true,
                    pending: true,
                    notifications: true,
                    completed: true,
                    reminders: false,
                    people: true,
                    groups: true
                };
                this.chatThreads = {};
                this.activeConversationKey = "";
                this.activeConversationItem = null;
                this.activeConversationSection = "";
                this.peopleSourceRows = [];
                this.peopleSearchText = "";
                this.groupSourceRows = [];
                this.groupSearchText = "";
                this.groupChildrenCache = {};
                this.groupChildrenLoading = {};
                this.expandedGroupKey = "";
                this.accordionDelegateBound = false;
                this.sections = [
                    {
                        key: "approvals",
                        label: "Approvals",
                        children: [
                            {
                                key: "approvalPending",
                                label: "Approvals Pending With Me",
                                ds: "DS_PendingApprovals"
                            },
                            {
                                key: "approvalRequested",
                                label: "Approvals Requested By Me",
                                ds: "REQUESTEDBYME"
                            }
                        ]
                    },
                    {
                        key: "reminders",
                        label: "Reminders",
                        ds: "DS_Reminders"
                    },
                    {
                        key: "escalations",
                        label: "Escalations",
                        ds: "DS_Escalations"
                    },
                    {
                        key: "completed",
                        label: "Completed",
                        ds: "DS_Completed"
                    }
                ];

                this.init();
            }

            async init() {

                this.cacheDom();
                //     this.showDefaultRightPanel();

                this.bindEvents();

                await Promise.all([

                    await this.loadAllDS(),

                    // this.loadSection("pending"),

                    // this.loadSection("notifications"),

                    //  this.loadSection("completed"),

                    // this.loadSection("people"),

                    // this.loadSection("groups")
                ]);

                this.buildAccordion();

                //   this.renderSection("tasks");
            }

            cacheDom() {

                this.accordionEl =
                    document.getElementById("InboxAccordion");

                this.contentEl =
                    document.getElementById("plistContent");

                this.searchEl =
                    document.getElementById("advTextSearch");

                this.refreshBtn =
                    document.getElementById("refreshBtn");

                this.rightIframe =
                    document.getElementById("rightIframe");

                this.rightPanelHostEl =
                    document.getElementById("Tickets_details_view") ||
                    document.getElementById("PROFLOW_Right");

                this.directoryChatPanelEl =
                    document.getElementById("directoryChatPanel");

                this.processCenterPanelEl =
                    document.getElementById("process_centerpanel");

                this.defaultRightPanelHtml =
                    this.processCenterPanelEl?.innerHTML || "";
            }

            bindEvents() {

                if (
                    this.searchEl &&
                    typeof this.searchEl.addEventListener === "function"
                ) {
                    this.searchEl.addEventListener(
                        "input",
                        this.debounce(async () => {
                            const sections = [
                                "tasks",
                                "pending",
                                // "notifications",
                                "completed",
                                // "people",
                                // "groups"
                            ];

                            sections.forEach(section => {
                                this.resetSectionLoadState(section);
                            });

                            await Promise.all([
                                this.loadSection("tasks"),
                                this.loadSection("pending"),
                                // this.loadSection("notifications"),
                                this.loadSection("completed"),
                                // this.loadSection("people"),
                                // this.loadSection("groups")
                            ]);
                        }, 500)
                    );
                }

                if (
                    this.refreshBtn &&
                    typeof this.refreshBtn.addEventListener === "function"
                ) {
                    this.refreshBtn.addEventListener("click", async () => {
                        // 1️⃣ Reset Chat layout states and hide the active chat containers immediately
                        if (this.directoryChatPanelEl) {
                            this.directoryChatPanelEl.classList.add("d-none");
                            this.directoryChatPanelEl.style.display = "none";
                        }

                        // Clear active chat message threads or active receiver details if tracked
                        this.activeChatId = null;
                        this.activeReceiver = null;

                        // 2️⃣ Stop any active background polling timers/intervals so they don''t fight for DOM space
                        if (this.chatRefreshInterval) {
                            clearInterval(this.chatRefreshInterval);
                            this.chatRefreshInterval = null;
                        }
                        if (this.pollingTimer) {
                            clearInterval(this.pollingTimer);
                            this.pollingTimer = null;
                        }



                        showDefaultRightPanel();


                        // 4️⃣ Remove selected/active background highlights from list elements
                        if (this.accordionEl) {
                            this.accordionEl
                                .querySelectorAll(".directory-row.selected, .task-item.selected, .active")
                                .forEach(row => row.classList.remove("selected", "active"));
                        }

                        // 5️⃣ Existing load section refreshes
                        const sections = [
                            "tasks",
                            "pending",
                            "notifications",
                            "completed",
                            "people",
                            "groups"
                        ];

                        sections.forEach(section => {
                            this.resetSectionLoadState(section);
                        });

                        await Promise.all([
                            this.loadSection("tasks"),
                            this.loadSection("pending"),
                            this.loadSection("notifications"),
                            this.loadSection("completed"),
                            this.loadSection("people"),
                            this.loadSection("groups")
                        ]);
                    });
                    if (this.directoryChatPanelEl) {
                        this.directoryChatPanelEl.classList.add("d-none");
                        this.directoryChatPanelEl.style.display = "none";
                    }
                }
            }

            resetSectionLoadState(section) {
                this.pagination[section] = 1;
                this.hasMore[section] = true;
                this.store[section] = [];
                this.visibleCount[section] = 0;

                if (this.isClientPagedSection(section)) {
                    this.clientRenderLimit[section] =
                        this.clientChunkSize;
                }

                if (section === "groups") {
                    this.groupChildrenCache = {};
                    this.groupChildrenLoading = {};
                    this.expandedGroupKey = "";
                }
            }

            async loadAllDS() {

                const searchText = this.searchEl?.value || "";

                const promises = [];

                this.sections.forEach(section => {

                    // Parent has children
                    if (section.children) {

                        section.children.forEach(child => {

                            promises.push((async () => {

                                const rows = await this.fetchDS(
                                    child.ds,
                                    searchText,
                                    1
                                );

                                this.store[child.key] =
                                    this.sortLatest(rows.rows || []);

                                this.visibleCount[child.key] =
                                    rows.totalCount ??
                                    (rows.rows || []).length;

                            })());

                        });

                    }
                    // Normal accordion
                    else if (section.ds) {

                        promises.push((async () => {

                            const rows = await this.fetchDS(
                                section.ds,
                                searchText,
                                1
                            );

                            this.store[section.key] =
                                this.sortLatest(rows.rows || []);

                            this.visibleCount[section.key] =
                                rows.totalCount ??
                                (rows.rows || []).length;

                        })());

                    }

                });

                await Promise.all(promises);

                this.buildAccordion();
            }
            fetchDS(
                dsName,
                searchText = "",
                pageNo = 1,
                extraSqlParams = {},
                requestOptions = {}
            ) {

                return new Promise((resolve, reject) => {
                    const safeExtraSqlParams =
                        extraSqlParams &&
                            typeof extraSqlParams === "object"
                            ? extraSqlParams
                            : {};
                    const safeRequestOptions =
                        requestOptions &&
                            typeof requestOptions === "object"
                            ? requestOptions
                            : {};
                    const includeDefaultSqlParams =
                        safeRequestOptions.includeDefaultSqlParams !== false;

                    const params = {

                        adsNames: [dsName],

                        props: {
                            pageno: pageNo,
                            pagesize: this.pageSize
                        },

                        sqlParams: includeDefaultSqlParams
                            ? {

                                uname:
                                    parent.mainUserName,

                                searchtext:
                                    searchText,

                                ...safeExtraSqlParams
                            }
                            : {
                                ...safeExtraSqlParams
                            }
                    };

                    parent.GetDataFromAxList(

                        params,

                        (response) => {

                            try {

                                const rawResponse =
                                    typeof response === "string"
                                        ? response
                                        : typeof response?.d === "string"
                                            ? response.d
                                            : JSON.stringify(response?.d || response);

                                const parsedResponse =
                                    JSON.parse(rawResponse);

                                const parsed =
                                    typeof parsedResponse?.d === "string"
                                        ? JSON.parse(parsedResponse.d)
                                        : parsedResponse;

                                const ds =
                                    parsed?.result?.data?.[0] || {};

                                const rows =
                                    ds.data || [];

                                const totalCount =
                                    ds.totalcount ||
                                    ds.recordcount ||
                                    ds.totalrows ||
                                    rows.length;

                                resolve({
                                    rows,
                                    totalCount
                                });

                            } catch (e) {

                                console.error(e);

                                resolve({
                                    rows: [],
                                    totalCount: 0
                                });
                            }
                        },

                        reject
                    );
                });
            }
            sortLatest(data = []) {

                return data.sort((a, b) => {

                    const d1 = new Date(
                        b.modifiedon ||
                        b.createdon ||
                        b.createddate ||
                        0
                    );

                    const d2 = new Date(
                        a.modifiedon ||
                        a.createdon ||
                        a.createddate ||
                        0
                    );

                    return d1 - d2;
                });
            }

            isClientPagedSection(section) {
                return true;
            }

            getRenderedSectionRows(section, data = []) {
                if (!this.isClientPagedSection(section)) {
                    return data;
                }

                const limit =
                    this.clientRenderLimit[section] ||
                    this.clientChunkSize;

                return data.slice(0, limit);
            }

            getRenderedSectionCount(section) {
                const data = this.store[section] || [];

                if (!this.isClientPagedSection(section)) {
                    return data.length;
                }

                return Math.min(
                    this.clientRenderLimit[section] ||
                    this.clientChunkSize,
                    data.length
                );
            }

            revealNextClientRows(section, scrollBody) {
                if (!this.isClientPagedSection(section)) {
                    return false;
                }

                const data = this.store[section] || [];
                const start = this.getRenderedSectionCount(section);

                if (start >= data.length) {
                    return false;
                }

                const nextLimit = Math.min(
                    start + this.clientChunkSize,
                    data.length
                );
                const rows = data.slice(start, nextLimit);

                this.clientRenderLimit[section] = nextLimit;

                if (scrollBody) {
                    scrollBody.insertAdjacentHTML(
                        "beforeend",
                        this.renderCards(rows, section, start)
                    );
                    this.updateSectionCount(section);
                    this.bindDirectoryAndTaskClicks();
                    this.bindAccordionScrollHandoff();
                } else {
                    this.buildAccordion();
                }

                return true;
            }

            updateSectionCount(section) {

                let countBadge =
                    this.accordionEl.querySelector(
                        `.v2-child-header[data-section="${section}"] .inbox-count`
                    );

                if (!countBadge) {

                    countBadge =
                        this.accordionEl.querySelector(
                            `.v2-accordion-header[data-section="${section}"] .inbox-count`
                        );
                }

                if (!countBadge) return;

                const total =
                    this.visibleCount[section] ??
                    this.store[section].length;

                const shown =
                    this.getRenderedSectionCount(section);

                countBadge.innerText = `${shown}/${total}`;
            }

            buildAccordion() {

                if (!this.accordionEl) return;

                let html = "";
                this.sections
                    .filter(section => !section.isChildOf)
                    .forEach(section => {

                        const expanded = this.currentSection === section.key;
                        const data = this.store[section.key] || [];

                        const renderedData =
                            this.getRenderedSectionRows(section.key, data);

                        const totalCount =
                            this.visibleCount[section.key] ?? data.length;

                        const shownCount =
                            this.isClientPagedSection(section.key)
                                ? renderedData.length
                                : data.length;
                        html += `
        <div class="v2-accordion-item">

            <div class="v2-accordion-header ${expanded ? "active" : ""}"
                 data-section="${section.key}">

                <div class="v2-left">
                    <span class="material-icons">
                        ${expanded ? "expand_less" : "expand_more"}
                    </span>

                    <span class="v2-title">
                        ${section.label}
                    </span>
                </div>
 ${!section.children
                                ? `<span class="inbox-count">
                   ${shownCount}/${totalCount}
               </span>`
                                : ""
                            }
            </div>

            <div class="v2-accordion-body ${expanded ? "show" : ""}">
        `;

                        // Child accordions
                        const children = section.children || [];

                        if (children.length) {

                            children.forEach(child => {

                                const data = this.store[child.key] || [];

                                const renderedData =
                                    this.getRenderedSectionRows(child.key, data);

                                const totalCount =
                                    this.visibleCount[child.key] ??
                                    data.length;

                                const shownCount =
                                    this.isClientPagedSection(child.key)
                                        ? renderedData.length
                                        : data.length;

                                html += `
                <div class="v2-child-item">

                    <div class="v2-child-header ${this.currentChildSection === child.key ? "active" : ""
                                    }"
                         data-section="${child.key}">

                        <div class="v2-left">

                           <span class="material-icons">
    ${this.currentChildSection === child.key
                                        ? "expand_less"
                                        : "expand_more"
                                    }
</span>

                            <span class="v2-title">
                                ${child.label}
                            </span>

                        </div>

                        <span class="inbox-count">
                            ${shownCount}/${totalCount}
                        </span>

                    </div>

                    <div class="v2-child-body ${this.currentChildSection === child.key ? "show" : ""
                                    }">

                        <div class="v2-scroll-body"
                             data-section="${child.key}">

                            ${this.renderCards(
                                        renderedData,
                                        child.key
                                    )}

                        </div>

                    </div>

                </div>
                `;
                            });

                        } else {

                            // Normal accordion (Pending, Completed...)
                            const data = this.store[section.key] || [];

                            const renderedData =
                                this.getRenderedSectionRows(section.key, data);

                            html += `
            <div class="v2-scroll-body"
                 data-section="${section.key}">

                ${this.renderCards(
                                renderedData,
                                section.key
                            )}

            </div>
            `;
                        }

                        html += `
            </div>
        </div>
        `;
                    });
                //                 this.sections.forEach(section => {

                //                     const data =
                //                         this.store[section.key] || [];
                //                     const renderedData =
                //                         this.getRenderedSectionRows(
                //                             section.key,
                //                             data
                //                         );

                //                     const expanded =
                //                         this.currentSection === section.key;
                //                     const totalCount =
                //                         this.visibleCount[section.key] ??
                //                         data.length ??
                //                         0;
                //                     const shownCount =
                //                         this.isClientPagedSection(section.key)
                //                             ? renderedData.length
                //                             : data.length;

                //                     html += `

                //             <div class="v2-accordion-item">

                //                 <div class="
                //                     v2-accordion-header
                //                     ${expanded ? "active" : ""}
                //                 "
                //                 data-section="${section.key}">

                //                     <div class="v2-left">

                //                         <span class="material-icons">
                //                             ${expanded ? "expand_less" : "expand_more"}
                //                         </span>

                //                         <span class="v2-title">
                //                             ${section.label}
                //                         </span>

                //                     </div>

                //               <span class="inbox-count">
                //    ${shownCount}/${totalCount}
                // </span>
                //                 </div>

                //               <div class="
                //     v2-accordion-body
                //     ${expanded ? "show" : ""}
                // ">

                //     <div class="v2-scroll-body"
                //          data-section="${section.key}">

                //         ${this.renderCards(
                //                         renderedData,
                //                         section.key
                //                     )}

                //     </div>

                // </div>
                //         `;
                //                 });

                this.accordionEl.innerHTML = html;

                this.bindAccordionClicks();
                this.bindDirectoryAndTaskClicks();
                this.bindScrollPagination();
                this.bindAccordionScrollHandoff();

            }
            bindAccordionClicks() {

                // Parent accordion click
                document
                    .querySelectorAll(".v2-accordion-header")
                    .forEach(el => {

                        el.onclick = (e) => {

                            e.stopPropagation();

                            const parent =
                                el.dataset.parent || el.dataset.section;

                            this.currentSection =
                                this.currentSection === parent
                                    ? ""
                                    : parent;

                            this.buildAccordion();
                        };
                    });

                // Child accordion click
                document
                    .querySelectorAll(".v2-child-header")
                    .forEach(el => {

                        el.onclick = async (e) => {

                            e.stopPropagation();

                            const section = el.dataset.section;

                            const body = el.nextElementSibling;

                            // Load only first time
                            if (!this.store[section]?.length) {

                                await this.loadSection(section);

                                body.querySelector(".v2-scroll-body").innerHTML =
                                    this.renderCards(
                                        this.store[section],
                                        section
                                    );
                            }

                            body.classList.toggle("show");

                            const icon =
                                el.querySelector(".material-icons");

                            icon.innerText =
                                body.classList.contains("show")
                                    ? "expand_less"
                                    : "expand_more";
                        };

                    });

                document.addEventListener("click", e => {

                    const icon = e.target.closest(".people-scheduler");
                    if (!icon) return;

                    e.preventDefault();
                    e.stopPropagation();

                    const row = icon.closest(".people-row");

                    this.schedulerFromLHS = true;
                    this.schedulerUserName = row.dataset.uname;

                    document.getElementById("schedulerBtn").click();
                });

            }

            ensureRightPanelHosts() {
                this.rightPanelHostEl =
                    document.getElementById("Tickets_details_view") ||
                    document.getElementById("PROFLOW_Right");

                this.rightIframe =
                    document.getElementById("rightIframe");

                this.processCenterPanelEl =
                    document.getElementById("process_centerpanel");

                this.directoryChatPanelEl =
                    document.getElementById("directoryChatPanel");

                if (
                    this.rightPanelHostEl &&
                    this.directoryChatPanelEl &&
                    !this.rightPanelHostEl.contains(
                        this.directoryChatPanelEl
                    )
                ) {
                    this.rightPanelHostEl.insertBefore(
                        this.directoryChatPanelEl,
                        this.rightPanelHostEl.firstChild
                    );
                }

                if (
                    this.rightPanelHostEl &&
                    !this.directoryChatPanelEl
                ) {
                    this.directoryChatPanelEl =
                        document.createElement("div");
                    this.directoryChatPanelEl.id =
                        "directoryChatPanel";
                    this.directoryChatPanelEl.className =
                        "directory-chat-panel d-none";

                    this.rightPanelHostEl.insertBefore(
                        this.directoryChatPanelEl,
                        this.rightPanelHostEl.firstChild
                    );
                }

                if (this.rightPanelHostEl) {
                    this.rightPanelHostEl.style.position = "relative";
                }
            }

            showProcessCenterPanel(html) {
                this.ensureRightPanelHosts();

                if (!this.processCenterPanelEl) return;

                this.showTaskPanelHost();

                this.processCenterPanelEl.innerHTML = html;
            }

            showDirectoryChatPanel(html) {
                this.ensureRightPanelHosts();

                if (!this.directoryChatPanelEl) return;

                if (this.processCenterPanelEl) {
                    this.processCenterPanelEl.style.display = "none";
                    this.processCenterPanelEl.classList.add("d-none");
                }

                if (this.rightIframe) {
                    this.rightIframe.classList.add("d-none");
                    if (this.rightIframe.getAttribute("src") !== "about:blank") {
                        this.rightIframe.setAttribute("src", "about:blank");
                    }
                }

                this.directoryChatPanelEl.innerHTML = html;
                this.directoryChatPanelEl.style.display = "flex";
                this.directoryChatPanelEl.style.position = "absolute";
                this.directoryChatPanelEl.style.inset = "0";
                this.directoryChatPanelEl.style.zIndex = "1000";
                this.directoryChatPanelEl.style.background = "#f8fbff";
                this.directoryChatPanelEl.classList.remove("d-none");

                console.log("[InboxV2] right panel: chat rendered", {
                    hasChatShell:
                        !!this.directoryChatPanelEl.querySelector(
                            ".chat-shell"
                        ),
                    panelState: this.getRightPanelDebugState()
                });
            }

            showTaskPanelHost() {
                this.ensureRightPanelHosts();

                this.hideDirectoryChatPanel();

                if (this.processCenterPanelEl) {
                    this.processCenterPanelEl.style.display = "";
                    this.processCenterPanelEl.classList.remove("d-none");
                }

                console.log("[InboxV2] right panel: task host shown", {
                    panelState: this.getRightPanelDebugState()
                });
            }

            hideDirectoryChatPanel() {
                if (!this.directoryChatPanelEl) return;

                this.directoryChatPanelEl.style.display = "none";
                this.directoryChatPanelEl.classList.add("d-none");
                this.directoryChatPanelEl.innerHTML = "";
            }

            getActiveRightPanelRoot() {
                this.ensureRightPanelHosts();

                if (
                    this.directoryChatPanelEl &&
                    !this.directoryChatPanelEl.classList.contains("d-none")
                ) {
                    return this.directoryChatPanelEl;
                }

                return this.processCenterPanelEl;
            }

            getRightPanelDebugState() {
                return {
                    currentSection: this.currentSection,
                    rightHostId: this.rightPanelHostEl?.id || "",
                    chatPanelInDom: !!this.directoryChatPanelEl?.isConnected,
                    chatPanelHidden:
                        this.directoryChatPanelEl?.classList.contains(
                            "d-none"
                        ),
                    chatPanelDisplay:
                        this.directoryChatPanelEl?.style.display || "",
                    processPanelInDom:
                        !!this.processCenterPanelEl?.isConnected,
                    processPanelHidden:
                        this.processCenterPanelEl?.classList.contains(
                            "d-none"
                        ),
                    processPanelDisplay:
                        this.processCenterPanelEl?.style.display || "",
                    iframeHidden:
                        this.rightIframe?.classList.contains("d-none")
                };
            }

            activateDirectoryRow(directoryRow) {
                const section =
                    directoryRow.dataset.section || "";
                const index =
                    Number(directoryRow.dataset.index || 0);
                const groupKey =
                    directoryRow.dataset.groupKey || "";
                const isGroupRow =
                    directoryRow.classList.contains("group-row");

                console.log("[InboxV2] switch: directory row clicked", {
                    from: this.currentSection,
                    to: section,
                    index,
                    groupKey,
                    isGroupRow,
                    panelState: this.getRightPanelDebugState()
                });

                if (isGroupRow) {
                    this.toggleGroupUsers(groupKey);
                    return;
                }

                if (section === "groupMembers") {
                    this.openGroupMemberChat(groupKey, index);
                    return;
                }

                this.openDirectoryChat(section, index);
            }

            bindDirectoryAndTaskClicks() {
                if (!this.accordionEl) return;

                if (!this.accordionDelegateBound) {
                    this.accordionDelegateBound = true;

                    window.addEventListener(
                        "click",
                        event => {
                            const source =
                                event.target instanceof Element
                                    ? event.target
                                    : event.target?.parentElement;

                            const directoryRow =
                                source?.closest?.(".directory-row");

                            if (
                                !directoryRow ||
                                !this.accordionEl?.contains(directoryRow)
                            ) {
                                return;
                            }

                            event.preventDefault();
                            event.stopPropagation();
                            event.stopImmediatePropagation();

                            this.activateDirectoryRow(directoryRow);
                            const selectedRow =
                                document.querySelector(".directory-row.selected");

                            if (selectedRow) {

                                const toUser =
                                    selectedRow.querySelector(".directory-name")
                                        ?.textContent?.trim();

                                this.loadChatHistory(toUser);
                                this.startChatPolling();
                            }
                        },
                        true
                    );

                    this.accordionEl.addEventListener(
                        "click",
                        event => {
                            const source =
                                event.target instanceof Element
                                    ? event.target
                                    : event.target?.parentElement;

                            const target =
                                source?.closest?.(".tasktitle, .directory-row");

                            if (!target || !this.accordionEl.contains(target)) {
                                return;
                            }

                            event.preventDefault();
                            event.stopPropagation();
                            event.stopImmediatePropagation();

                            if (target.classList.contains("tasktitle")) {
                                const taskLink = target;

                                const msgType = taskLink.dataset.msgtype || "NA";
                                const taskId = taskLink.dataset.taskid || "";
                                const hlinkParams = taskLink.dataset.hlinkParams || "";

                                this.activeConversationKey = "";
                                this.activeConversationItem = null;

                                if (this.chatRefreshInterval) {
                                    clearInterval(this.chatRefreshInterval);
                                    this.chatRefreshInterval = null;
                                }

                                if (this.pollingTimer) {
                                    clearInterval(this.pollingTimer);
                                    this.pollingTimer = null;
                                }

                                this.hideDirectoryChatPanel();
                                this.showTaskPanelHost();

                                if (msgType === "NA" || msgType !== "Task" || msgType !== "Ticket") {

                                    axProcessObj.openTask(
                                        taskLink,
                                        taskLink.dataset.taskname,
                                        taskLink.dataset.tasktype,
                                        taskLink.dataset.transid,
                                        taskLink.dataset.keyfield,
                                        taskLink.dataset.keyvalue,
                                        taskLink.dataset.recordid,
                                        taskId,
                                        taskLink.dataset.indexno,
                                        taskLink.dataset.hlinkTransid,
                                        hlinkParams,
                                        taskLink.dataset.processname,
                                        msgType,
                                        "LeftPanel"
                                    );

                                    axProcessObj.toggleRowBackground(taskLink);

                                } else {

                                    openTicketDetails(
                                        taskId,
                                        window.top.mainUserName,
                                        msgType,
                                        hlinkParams
                                    );

                                }



                                return;
                            }

                            this.activateDirectoryRow(target);
                        },
                        true
                    );
                }

                this.accordionEl
                    .querySelectorAll(".tasktitle")
                    .forEach(taskLink => {
                        taskLink.onclick = event => {
                            event.preventDefault();
                            event.stopPropagation();
                            event.stopImmediatePropagation();

                            const taskId =
                                taskLink.dataset.taskid || "";
                            const touser =
                                taskLink.dataset.touser || "";
                            const tasktype =
                                taskLink.dataset.tasktype || "";
                            const hlinkParams =
                                taskLink.dataset.hlinkParams || "";

                            if (
                                typeof window.openTicketDetails ===
                                "function"
                            ) {
                                console.log(
                                    "[InboxV2] switch: task detail clicked",
                                    {
                                        from: this.currentSection,
                                        to: "task",
                                        taskId,
                                        touser,
                                        tasktype,
                                        hlinkParams,
                                        panelState:
                                            this.getRightPanelDebugState()
                                    }
                                );
                                // Stop chat mode
                                this.activeConversationKey = "";
                                this.activeConversationItem = null;

                                if (this.chatRefreshInterval) {
                                    clearInterval(this.chatRefreshInterval);
                                    this.chatRefreshInterval = null;
                                }

                                if (this.pollingTimer) {
                                    clearInterval(this.pollingTimer);
                                    this.pollingTimer = null;
                                }

                                this.hideDirectoryChatPanel();
                                this.showTaskPanelHost();
                                window.openTicketDetails(
                                    taskId,
                                    touser,
                                    tasktype,
                                    hlinkParams
                                );
                            }
                        };
                    });

                this.accordionEl
                    .querySelectorAll(".directory-row")
                    .forEach(directoryRow => {
                        const activate = async event => {
                            event.preventDefault();
                            event.stopPropagation();
                            event.stopImmediatePropagation();

                            this.activateDirectoryRow(directoryRow);
                        };

                        directoryRow.onclick = activate;
                        directoryRow.onkeydown = event => {
                            if (
                                event.key === "Enter" ||
                                event.key === " "
                            ) {
                                activate(event);
                            }
                        };
                    });
            }

            // renderSection(section) {

            //     const data =
            //         this.store[section] || [];

            //     this.renderCards(data);
            // }

            renderCards(data, section, startIndex = 0) {



                if (section === "people") {
                    return this.renderPeople(data);
                }
                if (!data.length) {

                    return `
            <div class="empty-state">
                No records found
            </div>
        `;
                }

                let html = "";

                if (section === "groups") {
                    return data
                        .map((item, index) =>
                            this.renderGroupCard(item, startIndex + index)
                        )
                        .join("");
                }

                if (section === "people" || section === "groupMembers") {
                    return data
                        .map((item, index) =>
                            this.renderDirectoryCard(
                                item,
                                section,
                                startIndex + index
                            )
                        )
                        .join("");
                }

                data.forEach((item, index) => {

                    const title =
                        item.subject ||
                        item.displaytitle ||
                        item.taskname ||
                        "Untitled";

                    const content =
                        item.displaycontent ||
                        item.processname ||
                        item.description ||
                        "";

                    const date =
                        item.eventdatetime ||
                        item.modifiedon ||
                        item.createdon ||
                        "";
                    const taskId = getTaskId(item);
                    const checkboxId = taskId || item.taskid || index;


                    html += `

<div class="container listrow completed-row"
     data-status="${this.escapeHtml(item.cstatus || "")}"
     data-index="${index}">

    <div class="row">

        <div class="col-2 checkbox-wrapper">

           
            <div class="user">

                <span class="material-icons">

                    ${item.rectype === "MSG"
                            ? "notifications"
                            : "task"
                        }

                </span>

            </div>

        </div>

        <div class="col-7">

            <div>

                <a href="javascript:void(0)"

                   class="
                        tasktitle
                        ProcessFlow_New-List-Title
                        Procurement-list
                   "

                   data-taskid="${this.escapeHtml(taskId || "")}"
                   data-msgtype="${this.escapeHtml(item.msgtype || ''NA'')}"
                   data-taskname="${this.escapeHtml(item.taskname || '''')}"
    data-transid="${this.escapeHtml(item.transid || '''')}"
    data-keyfield="${this.escapeHtml(item.keyfield || '''')}"
    data-keyvalue="${this.escapeHtml(item.keyvalue || '''')}"
    data-recordid="${this.escapeHtml(item.recordid || '''')}"
    data-indexno="${this.escapeHtml(item.indexno || '''')}"
    data-hlink-transid="${this.escapeHtml(item.hlink_transid || '''')}"
    data-hlink-params="${this.escapeHtml(item.hlink_params || '''')}"
    data-processname="${this.escapeHtml(item.processname || '''')}"
                   data-touser="${this.escapeHtml(item.touser || "")}"
                   data-tasktype="${this.escapeHtml(item.tasktype || "")}"
                   data-hlink-params="${this.escapeHtml(item.hlink_params || "")}"
                   data-caption="${this.escapeHtml(title)}"

                   data-bs-toggle="tooltip"
                   data-bs-placement="bottom"
                   data-bs-title="${this.escapeHtml(title)}" >

                    ${this.escapeHtml(title)}

                </a>

            </div>

            <div class="taskcontent"

                 data-bs-toggle="tooltip"
                 data-bs-placement="bottom"
                 data-bs-title="${this.escapeHtml(content)}">

                ${content}

            </div>

            <div class="rowicons"></div>

        </div>

        <div class="timespace col-3">

            <div class="nametime"

                 data-bs-toggle="tooltip"
                 data-bs-placement="bottom"
                 data-bs-title="${this.escapeHtml(item.fromuser || "")}">

                ${this.escapeHtml(item.fromuser || " ")}

            </div>

            <div class="nametime"

                 data-bs-toggle="tooltip"
                 data-bs-placement="bottom"
                 data-bs-title="${this.escapeHtml(date)}">

                ${this.escapeHtml(date)}

            </div>

        </div>

    </div>

</div>
`;
                });



                return html;
            }

            renderPeople(data) {

                if (!data.length) {
                    return `<div class="empty-state">No associates found</div>`;
                }

                return data.map(item => `

               <div class="people-row"
               data-uname="${item.username}">

                <div class="people-name">
                ${item.username}
               </div>

            <span class="material-icons people-scheduler">
                calendar_month
            </span>

        </div>

    `).join("");

            }
            renderGroupCard(item, index) {
                const groupName = this.getGroupName(item);
                const groupKey = groupName;
                const expanded = this.expandedGroupKey === groupKey;
                const children = this.groupChildrenCache[groupKey] || [];
                const loading = !!this.groupChildrenLoading[groupKey];
                const initials = this.getInitials(groupName, "GR");

                let childHtml = "";

                if (expanded) {
                    if (loading) {
                        childHtml = `
<div class="group-loading">Loading users...</div>
`;
                    } else if (!children.length) {
                        childHtml = `
<div class="group-empty">No users found</div>
`;
                    } else {
                        childHtml = children
                            .map((child, childIndex) =>
                                this.renderGroupMemberCard(
                                    child,
                                    groupKey,
                                    childIndex
                                )
                            )
                            .join("");
                    }
                }

                return `
<div class="directory-row group-row"
     role="button"
     tabindex="0"
     data-section="groups"
     data-group-key="${this.escapeHtml(groupKey)}"
     data-index="${index}">
    <div class="directory-avatar directory-avatar-group">
        ${this.escapeHtml(initials)}
    </div>
    <div class="directory-main">
        <div class="directory-name">
            ${this.escapeHtml(groupName)}
        </div>
        <div class="directory-meta">
            User group
        </div>
    </div>
    <span class="material-icons directory-cta">${expanded ? "expand_less" : "expand_more"
                    }</span>
</div>
${childHtml}
`;
            }

            renderGroupMemberCard(item, groupKey, index) {
                const member = {
                    ...item,
                    __parentGroup: groupKey,
                    usergroups: item.usergroups || groupKey
                };
                const title = this.getDirectoryTitle(
                    member,
                    "groupMembers"
                );
                const metaText = this.getDirectoryMetaText(
                    member,
                    "groupMembers"
                );
                const badges = this.getDirectoryBadges(
                    member,
                    "groupMembers"
                );
                const initials = this.getInitials(title, "PE");
                const selected =
                    this.activeConversationKey ===
                    this.getConversationKey(member, "groupMembers");

                return `
<div class="directory-row group-member-row ${selected ? "selected" : ""}"
     role="button"
     tabindex="0"
     data-section="groupMembers"
     data-group-key="${this.escapeHtml(groupKey)}"
     data-index="${index}">
    <div class="directory-avatar">
        ${this.escapeHtml(initials)}
    </div>
    <div class="directory-main">
        <div class="directory-name">
            ${this.escapeHtml(title)}
        </div>
        ${metaText
                        ? `<div class="directory-meta">${this.escapeHtml(metaText)}</div>`
                        : ""
                    }
        ${badges.length
                        ? `<div class="directory-badges">${badges
                            .map(
                                badge =>
                                    `<span class="directory-badge">${this.escapeHtml(
                                        badge
                                    )}</span>`
                            )
                            .join("")}</div>`
                        : ""
                    }
    </div>
    <span class="material-icons directory-cta">chevron_right</span>
</div>
`;
            }

            renderDirectoryCard(item, section, index) {
                const title = this.getDirectoryTitle(item, section);
                const metaText = this.getDirectoryMetaText(item, section);
                const badges = this.getDirectoryBadges(item, section);
                const initials = this.getInitials(title, section === "groups" ? "GR" : "PE");
                const selected =
                    this.activeConversationKey ===
                    this.getConversationKey(item, section);

                return `
<div class="directory-row ${selected ? "selected" : ""}"
     role="button"
     tabindex="0"
     data-section="${this.escapeHtml(section)}"
     data-index="${index}">
    <div class="directory-avatar ${section === "groups" ? "directory-avatar-group" : ""
                    }">
        ${this.escapeHtml(initials)}
    </div>
    <div class="directory-main">
        <div class="directory-name">
            ${this.escapeHtml(title)}
        </div>
        ${metaText
                        ? `<div class="directory-meta">${this.escapeHtml(metaText)}</div>`
                        : ""
                    }
        ${badges.length
                        ? `<div class="directory-badges">${badges
                            .map(
                                badge =>
                                    `<span class="directory-badge">${this.escapeHtml(
                                        badge
                                    )}</span>`
                            )
                            .join("")}</div>`
                        : ""
                    }
    </div>
    <span class="material-icons directory-cta">chevron_right</span>
</div>
`;
            }

            async toggleGroupUsers(groupKey) {
                if (!groupKey) return;

                if (this.expandedGroupKey === groupKey) {
                    this.expandedGroupKey = "";
                    this.buildAccordion();
                    return;
                }

                this.expandedGroupKey = groupKey;
                this.currentSection = "groups";

                if (
                    Object.prototype.hasOwnProperty.call(
                        this.groupChildrenCache,
                        groupKey
                    )
                ) {
                    this.buildAccordion();
                    return;
                }

                this.groupChildrenLoading[groupKey] = true;
                this.buildAccordion();

                try {
                    const result = await this.fetchDS(
                        "DS_User_Groups",
                        this.searchEl?.value || "",
                        1,
                        {
                            ugroup: groupKey,
                            searchtext: this.searchEl?.value || ""
                        },
                        {
                            includeDefaultSqlParams: false
                        }
                    );

                    this.groupChildrenCache[groupKey] =
                        (result.rows || []).map(row => ({
                            ...row,
                            __parentGroup: groupKey,
                            usergroups: row.usergroups || groupKey
                        }));
                } finally {
                    this.groupChildrenLoading[groupKey] = false;
                    this.buildAccordion();
                }
            }

            openGroupMemberChat(groupKey, index) {
                const item =
                    this.groupChildrenCache?.[groupKey]?.[index];

                if (!item) return;

                this.ensureRightPanelHosts();

                const fromSection = this.currentSection;
                const conversationKey = this.getConversationKey(
                    item,
                    "groupMembers"
                );
                const title = this.getDirectoryTitle(
                    item,
                    "groupMembers"
                );

                this.activeConversationItem = item;
                this.activeConversationSection = "groupMembers";
                this.activeConversationKey = conversationKey;
                this.currentSection = "groups";
                this.expandedGroupKey = groupKey;

                console.log("[InboxV2] switch: opening group member chat", {
                    from: fromSection,
                    to: "groupMembers",
                    groupKey,
                    index,
                    title,
                    conversationKey,
                    panelState: this.getRightPanelDebugState()
                });

                this.showDirectoryChatPanel(
                    this.renderChatPanel(
                        item,
                        "groupMembers"
                    )
                );
                this.bindChatComposer();

                if (this.accordionEl) {
                    this.accordionEl
                        .querySelectorAll(".directory-row.selected")
                        .forEach(row => row.classList.remove("selected"));

                    const currentRows =
                        this.accordionEl.querySelectorAll(
                            ''.group-member-row[data-section="groupMembers"]''
                        );

                    currentRows[index]?.classList.add("selected");
                }

                requestAnimationFrame(() => {
                    const feed =
                        this.getActiveRightPanelRoot()?.querySelector(
                            ".chat-feed"
                        );
                    if (feed) {
                        feed.scrollTop = feed.scrollHeight;
                    }
                });
            }

            openDirectoryChat(section, index) {
                const item = this.store?.[section]?.[index];
                if (!item) return;

                this.ensureRightPanelHosts();

                const fromSection = this.currentSection;
                const conversationKey = this.getConversationKey(item, section);
                const title = this.getDirectoryTitle(item, section);
                const shouldRebuild =
                    fromSection !== section;
                this.activeConversationItem = item;
                this.activeConversationSection = section;
                this.activeConversationKey = conversationKey;
                this.currentSection = section;

                console.log("[InboxV2] switch: opening directory chat", {
                    from: fromSection,
                    to: section,
                    index,
                    title,
                    conversationKey,
                    shouldRebuild,
                    panelState: this.getRightPanelDebugState()
                });

                this.showDirectoryChatPanel(
                    this.renderChatPanel(
                        item,
                        section
                    )
                );
                this.bindChatComposer();
                const toUser =
                    item.uname ||
                    item.username ||
                    item.name;

                this.loadChatHistory(toUser);
                this.startChatPolling();
                if (!shouldRebuild && this.accordionEl) {
                    this.accordionEl
                        .querySelectorAll(".directory-row.selected")
                        .forEach(row => row.classList.remove("selected"));

                    const currentRow =
                        this.accordionEl.querySelector(
                            `.directory-row[data-section="${section}"][data-index="${index}"]`
                        );

                    currentRow?.classList.add("selected");
                }

                if (shouldRebuild) {
                    requestAnimationFrame(() => {
                        this.buildAccordion();
                    });
                }

                requestAnimationFrame(() => {
                    const feed =
                        this.getActiveRightPanelRoot()?.querySelector(".chat-feed");
                    if (feed) {
                        feed.scrollTop = feed.scrollHeight;
                    }
                });
            }

            bindAccordionScrollHandoff() {
                if (!this.accordionEl) return;

                const outer = this.accordionEl;

                this.accordionEl
                    .querySelectorAll(".v2-scroll-body")
                    .forEach(el => {
                        el.onwheel = event => {
                            const delta = event.deltaY || 0;
                            const atTop = el.scrollTop <= 0;
                            const atBottom =
                                el.scrollTop + el.clientHeight >=
                                el.scrollHeight - 1;

                            if (
                                (delta < 0 && atTop) ||
                                (delta > 0 && atBottom)
                            ) {
                                outer.scrollTop = Math.max(
                                    0,
                                    outer.scrollTop + delta
                                );
                                event.preventDefault();
                            }
                        };
                    });
            }

            //             showDefaultRightPanel() {
            //                 if (!this.processCenterPanelEl) return;

            //                 this.showProcessCenterPanel(
            //                     this.defaultRightPanelHtml || this.renderEmptyRightPanel()
            //                 );
            //             }

            //             renderEmptyRightPanel() {
            //                 return `
            // <div class="d-flex flex-column text-center h-100 justify-content-center">
            //     <span class="material-icons material-icons-style material-icons-5tx mx-auto text-gray-500">forum</span>
            //     <h3 class="fw-boldest">Nothing is selected</h3>
            // </div>
            // `;
            //             }

            renderChatPanel(item, section) {
                const title = this.getDirectoryTitle(item, section);
                const metaText = this.getDirectoryMetaText(item, section);
                const badges = this.getDirectoryBadges(item, section);
                const initials = this.getInitials(
                    title,
                    section === "groups" ? "GR" : "PE"
                );
                const threadKey = this.getConversationKey(item, section);
                const messages = this.chatThreads[threadKey] || [];

                if (!this.chatThreads[threadKey]) {
                    this.chatThreads[threadKey] = [];
                }

                return `
<div class="chat-shell" data-thread-key="${this.escapeHtml(threadKey)}">
    <div class="chat-shell-header">
        <div class="chat-profile">
            <div class="chat-avatar ${section === "groups" ? "chat-avatar-group" : ""
                    }">${this.escapeHtml(initials)}</div>
            <div class="min-w-0">
                <div class="chat-name">${this.escapeHtml(title)}</div>
                <div class="chat-subline">
                    ${section === "people" && item.reportingto
                        ? `<span class="chat-chip">Reports to ${this.escapeHtml(
                            item.reportingto
                        )}</span>`
                        : ""
                    }
                    ${section === "groups" && item.reportingto
                        ? `<span class="chat-chip">Owner ${this.escapeHtml(
                            item.reportingto
                        )}</span>`
                        : ""
                    }
                    ${badges
                        .slice(0, 3)
                        .map(
                            badge =>
                                `<span class="chat-chip">${this.escapeHtml(
                                    badge
                                )}</span>`
                        )
                        .join("")}
                </div>
            </div>
        </div>
        <div class="chat-actions" style="display: none;">
        </div>
    </div>
    <div class="chat-feed" id="chatFeed">
        ${messages.length
                        ? messages
                            .map(message => this.renderChatMessage(message, title))
                            .join("")
                        : this.renderChatEmpty(title, metaText, badges, initials, section)
                    }
    </div>
    <form class="chat-composer" id="chatComposerForm" data-thread-key="${this.escapeHtml(
                        threadKey
                    )}">
        <div class="chat-input-wrap">
            <textarea class="chat-input" id="chatInput" rows="1" placeholder="Type a message..."></textarea>
        </div>
        <button class="chat-send" type="submit" aria-label="Send">
            <span class="material-icons material-icons-style material-icons-2">send</span>
        </button>
    </form>
</div>
`;
            }

            renderChatEmpty(title, metaText, badges, initials, section) {
                return `
<div class="chat-empty">
    <div class="chat-empty-card">
        <div class="chat-avatar ${section === "groups" ? "chat-avatar-group" : ""
                    } mx-auto">${this.escapeHtml(initials)}</div>
        <div class="chat-empty-title">${this.escapeHtml(title)}</div>
        ${metaText
                        ? `<div class="chat-empty-meta">${this.escapeHtml(metaText)}</div>`
                        : ""
                    }
        ${badges.length
                        ? `<div class="chat-subline" >${badges
                            .slice(0, 3)
                            .map(
                                badge =>
                                    `<span class="chat-chip">${this.escapeHtml(
                                        badge
                                    )}</span>`
                            )
                            .join("")}</div>`
                        : ""
                    }
    </div>
</div>
`;
            }

            renderChatMessage(message, contactName) {
                const isSelf = message.sender === "me";
                const avatar = isSelf
                    ? "ME"
                    : this.getInitials(contactName, "PE");
                const label = isSelf ? "You" : contactName;
                const time = message.time || "";

                return `
<div class="chat-message ${isSelf ? "self" : ""}">
    <div class="chat-avatar-sm">${this.escapeHtml(avatar)}</div>
    <div class="chat-bubble">
        <div>${this.escapeHtml(message.text || "")}</div>
        <div class="chat-message-meta">
            <span>${this.escapeHtml(label)}</span>
            <span>${this.escapeHtml(time)}</span>
        </div>
    </div>
</div>
`;
            }

            bindChatComposer() {
                const panelRoot = this.getActiveRightPanelRoot();
                const form =
                    panelRoot?.querySelector("#chatComposerForm");
                const input =
                    panelRoot?.querySelector("#chatInput");
                const feed =
                    panelRoot?.querySelector("#chatFeed");

                if (!form || !input || !feed) return;

                form.onsubmit = event => {
                    event.preventDefault();

                    const text = input.value.trim();
                    if (!text) return;

                    const threadKey = form.dataset.threadKey || "";
                    if (!this.chatThreads[threadKey]) {
                        this.chatThreads[threadKey] = [];
                    }

                    const toUser = threadKey.split("|")[1] || "";
                    const now = new Date();
                    const eventDateTime =
                        now.getFullYear().toString() +
                        String(now.getMonth() + 1).padStart(2, "0") +
                        String(now.getDate()).padStart(2, "0") +
                        String(now.getHours()).padStart(2, "0") +
                        String(now.getMinutes()).padStart(2, "0") +
                        String(now.getSeconds()).padStart(2, "0") +
                        String(now.getMilliseconds()).padStart(3, "0");

                    parent.AxSetValue("a__sm", "fromuser", "1", "0", parent.mainUserName);
                    parent.AxSetValue("a__sm", "touser_ui", "1", "0", toUser);
                    parent.AxSetValue("a__sm", "msgtitle", "1", "0", text);
                    parent.AxSetValue("a__sm", "message", "1", "0", text);
                    parent.AxSetValue("a__sm", "eventdatetime", "1", "0", eventDateTime);

                    const resp = parent.AxSubmitData("a__sm", "0");

                    this.chatThreads[threadKey].push({
                        sender: "me",
                        text,
                        time: this.formatTime(new Date())
                    });

                    this.showDirectoryChatPanel(
                        this.renderChatPanel(
                            this.activeConversationItem,
                            this.activeConversationSection
                        )
                    );
                    this.bindChatComposer();

                    requestAnimationFrame(() => {
                        const nextFeed =
                            this.getActiveRightPanelRoot()?.querySelector("#chatFeed");
                        if (nextFeed) {
                            nextFeed.scrollTop = nextFeed.scrollHeight;
                        }
                    });
                };

                input.onkeydown = event => {
                    if (event.key === "Enter" && !event.shiftKey) {
                        event.preventDefault();
                        form.requestSubmit
                            ? form.requestSubmit()
                            : form.dispatchEvent(
                                new Event("submit", {
                                    bubbles: true,
                                    cancelable: true
                                })
                            );
                        const selectedRow =
                            document.querySelector(".directory-row.selected");

                        if (selectedRow) {

                            const toUser =
                                selectedRow.querySelector(".directory-name")
                                    ?.textContent?.trim();

                            this.loadChatHistory(toUser);
                            this.startChatPolling();
                        }
                    }
                };

                requestAnimationFrame(() => {
                    input.focus();
                });
            }

            getGroupName(item) {
                return (
                    item.usergroup ||
                    item.groupname ||
                    item.displaytitle ||
                    item.name ||
                    item.username ||
                    item.title ||
                    "Untitled"
                );
            }

            getDirectoryTitle(item, section) {
                const candidates =
                    section === "groups"
                        ? [
                            item.usergroup,
                            item.groupname,
                            item.displaytitle,
                            item.name,
                            item.username,
                            item.title
                        ]
                        : [
                            item.username,
                            item.user,
                            item.userid,
                            item.member,
                            item.membername,
                            item.displaytitle,
                            item.name,
                            item.fullname,
                            item.email,
                            item.taskname,
                            item.usergroup
                        ];

                return candidates.find(value => value) || "Untitled";
            }

            getDirectoryMetaText(item, section) {
                const meta = [];

                if (section === "people" || section === "groupMembers") {
                    if (item.reportingto) {
                        meta.push(`Reports to ${item.reportingto}`);
                    }
                    if (section === "groupMembers" && item.__parentGroup) {
                        meta.push(`Group ${item.__parentGroup}`);
                    }
                    const groups =
                        section === "groupMembers"
                            ? []
                            : this.splitList(item.usergroups);
                    if (groups.length) {
                        meta.push(
                            `${groups.length} group${groups.length === 1 ? "" : "s"
                            }`
                        );
                    }
                } else if (section === "groups") {
                    const owner =
                        item.reportingto ||
                        item.owner ||
                        item.createdby ||
                        item.lead ||
                        item.manager;
                    if (owner) {
                        meta.push(`Owner ${owner}`);
                    }
                    const members =
                        item.members ||
                        item.membercount ||
                        item.totalmembers ||
                        item.usercount;
                    if (members) {
                        const memberCount = Array.isArray(members)
                            ? members.length
                            : Number(members);
                        if (!Number.isNaN(memberCount)) {
                            meta.push(
                                `${memberCount} member${memberCount === 1 ? "" : "s"
                                }`
                            );
                        } else {
                            meta.push(String(members));
                        }
                    }
                }

                return meta.join(" | ");
            }

            getDirectoryBadges(item, section) {
                const values =
                    section === "groups"
                        ? this.splitList(item.usergroups || item.members)
                        : this.splitList(
                            item.usergroups || item.__parentGroup
                        );

                return values.slice(0, 4);
            }

            getConversationKey(item, section) {
                return [
                    section,
                    item.username,
                    item.user,
                    item.userid,
                    item.member,
                    item.membername,
                    item.email,
                    item.usergroup,
                    item.groupname,
                    item.displaytitle,
                    item.name,
                    item.taskid,
                    item.id,
                    item.__parentGroup,
                    item.reportingto
                ]
                    .filter(Boolean)
                    .join("|")
                    .toLowerCase();
            }

            splitList(value) {
                if (!value) return [];
                if (Array.isArray(value)) {
                    return value.map(item => String(item).trim()).filter(Boolean);
                }

                return String(value)
                    .split(/[;,|]/)
                    .map(item => item.trim())
                    .filter(Boolean);
            }

            getInitials(label, fallback = "PE") {
                const parts = String(label || "")
                    .trim()
                    .split(/\s+/)
                    .filter(Boolean);

                if (!parts.length) {
                    return fallback;
                }

                if (parts.length === 1) {
                    return parts[0].slice(0, 2).toUpperCase();
                }

                return parts
                    .slice(0, 2)
                    .map(word => word.charAt(0))
                    .join("")
                    .toUpperCase();
            }

            escapeHtml(value) {
                const node = document.createElement("div");
                node.textContent = String(value ?? "");
                return node.innerHTML;
            }

            formatTime(value) {
                const date = value instanceof Date ? value : new Date(value);
                if (Number.isNaN(date.getTime())) {
                    return "";
                }

                return date.toLocaleTimeString([], {
                    hour: "2-digit",
                    minute: "2-digit"
                });
            }

            bindScrollPagination() {
                document
                    .querySelectorAll(".v2-scroll-body")
                    .forEach(el => {
                        el.onscroll = async () => {
                            const section = el.dataset.section;

                            if (this.loading[section]) return;

                            // Threshold distance from bottom to trigger (in pixels)
                            const threshold = 50;
                            const reachedBottom = el.scrollTop + el.clientHeight >= el.scrollHeight - threshold;

                            if (reachedBottom) {
                                if (this.revealNextClientRows(section, el)) {
                                    return;
                                }

                                if (!this.hasMore[section]) return;

                                this.pagination[section]++;

                                console.log("Loading page", this.pagination[section], "for section", section);

                                // Execution flow transfers to custom chunk-appending inside loadSection
                                await this.loadSection(section);
                            }
                        };
                    });
            }
            bindPagination() {

                document
                    .querySelectorAll(".page-btn")
                    .forEach(btn => {

                        btn.onclick = async () => {

                            const section =
                                btn.dataset.section;

                            const type =
                                btn.dataset.type;

                            if (type === "next") {

                                this.pagination[section]++;

                            } else if (
                                type === "prev" &&
                                this.pagination[section] > 1
                            ) {

                                this.pagination[section]--;
                            }

                            await this.loadSection(section);

                            this.buildAccordion();
                        };
                    });
            }
            async loadSection(sectionKey) {
                if (this.loading[sectionKey]) return;
                if (!this.hasMore[sectionKey]) return;

                const section = this.sections.find(x => x.key === sectionKey);
                if (!section?.ds) return;

                this.loading[sectionKey] = true;

                try {
                    const pageNo = this.pagination[sectionKey] || 1;
                    const result = await this.fetchDS(
                        section.ds,
                        this.searchEl?.value || "",
                        pageNo
                    );

                    const rows = result.rows || [];
                    const totalCount = result.totalCount ?? rows.length;

                    this.visibleCount[sectionKey] = totalCount;

                    if (pageNo === 1) {
                        if (this.isClientPagedSection(sectionKey)) {
                            this.clientRenderLimit[sectionKey] =
                                this.clientChunkSize;
                        }

                        this.store[sectionKey] = rows;
                        this.buildAccordion();
                    } else {
                        const appendStart =
                            this.store[sectionKey]?.length || 0;

                        this.store[sectionKey] = [
                            ...this.store[sectionKey],
                            ...rows
                        ];

                        if (this.isClientPagedSection(sectionKey)) {
                            this.clientRenderLimit[sectionKey] =
                                this.store[sectionKey].length;
                        }

                        const scrollBody = this.accordionEl?.querySelector(
                            `.v2-scroll-body[data-section="${sectionKey}"]`
                        );

                        if (scrollBody) {
                            scrollBody.insertAdjacentHTML(
                                "beforeend",
                                this.renderCards(
                                    rows,
                                    sectionKey,
                                    appendStart
                                )
                            );
                        }

                        const countBadge = this.accordionEl?.querySelector(
                            `.v2-accordion-header[data-section="${sectionKey}"] .inbox-count`
                        );

                        if (countBadge) {
                            countBadge.innerText = `${this.getRenderedSectionCount(
                                sectionKey
                            )}/${totalCount}`;
                        }

                        this.bindDirectoryAndTaskClicks();
                        this.bindAccordionScrollHandoff();
                    }

                    this.hasMore[sectionKey] =
                        this.store[sectionKey].length < totalCount &&
                        rows.length > 0;
                } finally {
                    this.loading[sectionKey] = false;
                }
            }
            debounce(callback, delay) {

                let timer;

                return (...args) => {

                    clearTimeout(timer);

                    timer = setTimeout(() => {

                        callback.apply(this, args);

                    }, delay);
                };
            }

            async loadChatHistory(toUser) {

                try {

                    const result = await this.fetchDS(
                        "ds_chathistory",
                        "",
                        1,
                        {
                            uname: parent.mainUserName,
                            touser: toUser
                        }
                    );

                    const rows = result.rows || [];

                    rows.sort((a, b) =>
                        (a.eventdatetime || "").localeCompare(
                            b.eventdatetime || ""
                        )
                    );

                    this.renderChatHistory(rows, toUser);

                } catch (ex) {
                    console.error(ex);
                }
            }

            startChatPolling() {

                clearInterval(this.chatPoller);

                this.chatPoller = setInterval(() => {

                    if (!this.activeConversationItem) return;

                    const toUser =
                        this.activeConversationItem.uname ||
                        this.activeConversationItem.username ||
                        this.activeConversationItem.name;

                    this.loadChatHistory(toUser);
                    this.startChatPolling();

                }, 2000); // every 3 sec
            }
            //         renderChatHistory(messages, toUser) {

            //             const currentUser =
            //                 (parent.mainUserName || "").toLowerCase();

            //             const html = messages.map(msg => {

            //                 const sender =
            //                     (msg.fromuser || "").toLowerCase();

            //                 const isMine =
            //                     sender === currentUser;

            //                 return `
            //         <div class="chat-message ${isMine ? "self" : ""}">

            //             <div class="chat-avatar-sm">
            //                 ${(msg.fromuser || "?")
            //                         .substring(0, 2)
            //                         .toUpperCase()}
            //             </div>

            //             <div>
            //                 <div class="chat-bubble">
            //                     ${msg.message || ""}
            //                 </div>

            //                 <div class="chat-message-meta">
            //                     <span>
            //                         ${this.formatChatTime(
            //                             msg.eventdatetime
            //                         )}
            //                     </span>
            //                 </div>
            //             </div>

            //         </div>
            //     `;
            //             }).join("");

            //             const panel = `
            //     <div class="chat-shell">

            //         <div class="chat-shell-header">
            //             <div class="chat-profile">
            //                 <div class="chat-avatar">
            //                     ${toUser.substring(0, 2).toUpperCase()}
            //                 </div>

            //                 <div>
            //                     <div class="chat-name">
            //                         ${toUser}
            //                     </div>
            //                 </div>
            //             </div>
            //         </div>

            //         <div class="chat-feed" id="chatFeed">
            //             ${html}
            //         </div>

            //     </div>
            // `;

            //             // this.showDirectoryChatPanel(panel);

            //             setTimeout(() => {

            //                 const feed =
            //                     document.getElementById("chatFeed");

            //                 if (feed) {
            //                     feed.scrollTop =
            //                         feed.scrollHeight;
            //                 }

            //             }, 100);
            //         }

            renderChatHistory(messages, toUser) {

                // No history
                if (!messages || messages.length === 0) {

                    this.showDirectoryChatPanel(
                        this.renderChatPanel(
                            this.activeConversationItem,
                            this.activeConversationSection
                        )
                    );

                    this.bindChatComposer();
                    return;
                }

                const currentUser =
                    (parent.mainUserName || "").toLowerCase();

                const html = messages.map(msg => {

                    const sender =
                        (msg.fromuser || "").toLowerCase();

                    const isMine =
                        sender === currentUser;

                    return `
            <div class="chat-message ${isMine ? "self" : ""}">
                
                <div class="chat-avatar-sm">
                    ${(msg.fromuser || "?")
                            .substring(0, 2)
                            .toUpperCase()}
                </div>

                <div>
                    <div class="chat-bubble">
                        ${msg.message || ""}
                    </div>

                    <div class="chat-message-meta">
                        <span>
                            ${this.formatChatTime(
                                msg.eventdatetime
                            )}
                        </span>
                    </div>
                </div>

            </div>
        `;
                }).join("");

                // Update only the feed
                const feed = document.getElementById("chatFeed");

                if (feed) {
                    feed.innerHTML = html;
                    feed.scrollTop = feed.scrollHeight;
                }
            }
            formatChatTime(ts) {

                if (!ts) return "";

                const year = ts.substr(0, 4);
                const month = ts.substr(4, 2);
                const day = ts.substr(6, 2);

                const hour = ts.substr(8, 2);
                const min = ts.substr(10, 2);

                const dt = new Date(
                    `${year}-${month}-${day}T${hour}:${min}:00`
                );

                return dt.toLocaleString("en-IN", {
                    day: "2-digit",
                    month: "short",
                    hour: "2-digit",
                    minute: "2-digit"
                });
            }
        }

        window.addEventListener(
            "DOMContentLoaded",
            () => {

                window.inboxV2 =
                    new InboxV2();
            }
        );

        function getTaskId(item) {
            const pattern = /\b(?:TSK|TASK|TKT)-\d+\b|\bTask ID-\d+\b/i;
            // 1️⃣ First try hlink_params
            if (item.hlink_params) {
                const match = item.hlink_params.match(pattern);
                if (match) return match[0];
            }
            // 2️⃣ Try displaytitle
            if (item.displaytitle) {
                const match = item.displaytitle.match(pattern);
                if (match) return match[0];
            }
            // 3️⃣ Try displaycontent
            if (item.displaycontent) {
                const match = item.displaycontent.match(pattern);
                if (match) return match[0];
            }
            if (item.taskid) {
                return item.taskid
            }
            return null;
        }


    </script>



















	
	

	<script type="text/javascript" src="Js/taskslst_inbox_1784892186402.js?v=1785216335707"></script>
	<script type="text/javascript" src="Js/AxProcessFlow_V3_1784892186402.js?v=1785216335708"></script>
</body></html>
');
>>

<<
INSERT INTO sect4 (sect4id, htmlsectionsid, sect4row, filename, filetype, css_js_src) VALUES(1592770000002, 1592770000000, 1, 'AxpertInbox', 'Css', '    /*https://web.agile-labs.com/minZIP/*//*version=3.9.1*/
    #ProcessFlow_New .content,
    body {
      padding-block:0
    }
    #PROFLOW-overalldiv {
      width:100vw
    }
    #ProcessFlow_New_Right,
    #ProcessFlow_New_Right_Last {
      padding:0
    }
    #PROFLOW_Left .card-header,
    #ProcessFlow_New_Right .card-header,
    #ProcessFlow_New_Right_Last .card-header {
      background:#f8f9fa;
      min-height:auto;
      padding:5px 30px!important;
      border-radius:0!important
    }
    #PROFLOW_Left .card-title,
    #ProcessFlow_New_Right .card-title,
    #ProcessFlow_New_Right_Last .card-title {
      font-size:1.1rem;
      font-weight:700
    }
    #PROFLOW_Left {
      padding:10px 0px;
      transform:translateX(0);
      transition:transform .5s ease;
      overflow:hidden
    }
    #PROFLOW_Left.collapsed {
      transform:translateX(-100%)
    }
    #PROFLOW_Left .card-body {
      padding:1rem 2rem!important;
      border:1px solid #f3f3f3
    }
    #ProcessFlow_New_Right .card-body {
      padding:1rem 2rem!important
    }
    #ProcessFlow_New_Right_Last .card-body {
      padding:1rem 2rem!important;
      border:1px solid #f3f3f3
    }
    .ProcessFlow_New-Wrapper {
      border-bottom:1px solid #ececec
    }
    .ProcessFlow_New-List-Title {
      font-size:13px !important;
      color:#3f4254!important;
      font-weight:800 !important;
    }
    .ProcessFlow_New-List-subtitle {
      color:#535353
    }
    .ProcessFlow_New-List-Items {
      border-bottom:1px solid #ececec;
      padding-block:12px
    }
    #ProcessFlow_New_Right_Last .card-body {
      padding:6px!important
    }
    .KPI_Section {
      margin-bottom:7px
    }
    .KPI_Section_details {
      padding:12px
    }
    .Leave-Type {
      font-weight:700;
      color:#434343
    }
    .Leave-Count {
      font-size:20px;
      font-weight:700
    }
    #ProcessFlow_New-container .text-warning {
      color:#eb7900!important
    }
    #ProcessFlow_New-container .material-icons {
      font-family:"Material Icons Outlined";
      font-size:19px
    }
    .ProcessFlow_New_Details-Wrap {
      display:flex;
      justify-content:center;
      align-items:center!important
    }
    .ProcessFlow_New_Details {
      display:flex;
      flex-direction:column;
      text-align:center;
      border-right:1px solid #ececec;
      padding:17px 5px
    }
    .ProcessFlow_New-counts {
      font-size:1.5rem;
      font-weight:700
    }
    .ProcessFlow_New-title {
      font-size:14px
    }
    .ProcessFlow_New-stats {
      border:1px solid #efefef
    }
    .ProcessFlow_New-stats h4 {
      padding:10px 15px;
      border-bottom:1px solid #efefef;
      font-size:1.1rem;
      font-weight:700;
      margin-bottom:0;
      background:#fdfdfd
    }
    .ProcessFlow_New-stats h4 span {
      color:#b3b3b3;
      font-size:12px
    }
    .Ticket-Label,
    .Ticket-Value {
      font-size:1rem;
      display:block;
      color:#495057!important;
      font-weight:510;
      padding-bottom:2px
    }
    .Ticket-Value {
      font-weight:700;
      display:flex;
      align-items:end
    }
    .Ticket-Title {
      padding-top:6px;
      font-size:1.3rem;
      font-weight:700
    }
    #Tickets_details_view .card-header {
      background:0 0;
      border-bottom:0
    }
    .Ticket-details-row {
      padding:10px 0;
      border-bottom:1px dashed #dcdcdc;
      padding-left:54px
    }
    .Ticket-details-row .material-icons {
      position:relative;
      top:5px;
      margin-right:12px
    }
    .Ticket-details-row .Ticket-Value .material-icons {
      position:inherit;
      margin-left:16px
    }
    #Tickets_Desc_view .material-icons,
    #Tickets_details_view .card-header .material-icons {
      font-size:27px!important;
      width:38px!important;
      height:38px!important;
      position:relative;
      top:6px;
      margin-right:12px;
      text-align:center
    }
    .Ticket-details-row p {
      font-size:1.1rem;
      line-height:26px
    }
    #Tickets_details_view .card-body {
      border:0
    }
    .Ticket-Desc-Title {
      display:flex;
      padding:5px 0!important;
      min-height:auto;
      margin-top:25px;
      align-items:center;
      font-size:1.15rem;
      font-weight:700
    }
    .Ticket-Desc-row {
      padding-left:25px
    }
    .Ticket-details-row p {
      font-size:1.1rem;
      line-height:26px;
      font-weight:510
    }
    #Tickets_Desc_view .material-icons {
      margin-right:17px
    }
    #ProcessFlow_New_Right .card-footer {
      padding:11px 63px
    }
    .Tkts-ttobar {
      text-align:right;
      border-bottom:1px solid #f9f9f9;
      margin-top:-9px;
      padding-bottom:9px
    }
    #ProcessFlow_New-container .nav-link .material-icons {
      font-size:15px!important;
      position:relative;
      top:6px
    }
    #ProcessFlow_New-container .nav.nav-tabs {
      display:flex;
      justify-content:space-around
    }
    #PROFLOW-overalldiv .card {
      box-shadow:none
    }
    #ProcessFlow_New_Right {
      border:1px solid #f3f3f3;
      border-width:1px 0 1px 0
    }
    #ProcessFlow_New_Right_Last figure {
      text-align:center
    }
    #Tickets_Desc_view .Ticket-details-row {
      border:0
    }
    #ProcessFlow_New_Right_Last .material-icons {
      color:#939393!important
    }
    .card-footer.py-5.footer-legend {
      border-bottom:1px solid #eeeeef!important;
      padding:10!important;
      background:#f9f9fa
    }
    .footer-legend {
      display:block;
      font-size:13px;
      text-align:center;
      border-right:0;
      border-radius:0!important
    }
    .legend-list {
      display:inline-block;
      margin-right:15px;
      margin-bottom:5px
    }
    .legend-list .symbol-circle {
      margin-right:6px
    }
    .legend-list .symbol .symbol-label {
      width:8px;
      height:8px
    }
    .symbol-label.bg-make,
    div[data-tasktype=Make] .Task-process-list::before {
      background:#4b6ecc
    }
    .symbol-label.bg-approved,
    div[data-tasktype=Approve] .Task-process-list::before {
      background:#5ac686
    }
    .symbol-label.bg-checked,
    div[data-tasktype=Check] .Task-process-list::before {
      background:#3d821b
    }
    .symbol-label.bg-If {
      background:#ecab11
    }
    .symbol-label.bg-If-else {
      background:#9823e5
    }
    .symbol-label.bg-Else {
      background:#23d8e5
    }
    .more-comments {
      padding:0!important;
      display:none!important
    }
    .task-actions-sets:hover .more-comments {
      display:block!important
    }
    .task-actions-sets.d-flex:hover .more-comments {
      display:block!important;
      padding:0!important;
      position:relative;
      top:0;
      border-radius:0!important;
      margin-right:0!important;
      border-radius:6px!important
    }
    .task-actions-sets.d-flex:hover .btn.me-2 {
      margin-right:0!important
    }
    .task-actions-sets .more-comments:first-child {
      border-left:0!important
    }
    .task-actions-sets.d-flex:hover .more-comments:first-child {
      border-left:0!important
    }
    .task-actions-sets.d-flex:hover {
      border-radius:5px;
      box-shadow:0 0 14px 2px #dbdbdb
    }
    .comments-icons {
      position:relative;
      top:5px
    }
    #ProcessFlow_New_Right .stepper.stepper-horizontal {
      padding:0;
      border-bottom:1px solid #f9f9f9
    }
    ul.stepper {
      padding: 0 15px 5px 0!important;
      margin-bottom:0;
      overflow-x:scroll;
      overflow-y:hidden;
      counter-reset:section;
      display:block ruby;
      /* margin-right: 287px; */
    }
    ul.stepper li {
      height:-webkit-min-content;
      height:-moz-min-content;
      height:min-content;
    }
    ul.stepper li a {
      padding:10px 11px;
      text-align:center;
    }
    ul.stepper li a .circle {
      display:inline-block;
      width:1.75rem;
      height:1.75rem;
      margin-right:.5rem;
      line-height:1.7rem;
      color:#fff;
      text-align:center;
      background:rgba(0,0,0,.38);
      border-radius:50%
    }
    ul.stepper li a .label {
      display:inline-block;
      color:rgba(0,0,0,.38);
      font-size:12px
    }
    ul.stepper li.active a .label,
    ul.stepper li.completed a .label {
      font-weight:600;
      color:rgba(0,0,0,.87)
    }
    .stepper-horizontal {
      position:relative;
      display:-webkit-box;
      display:-ms-flexbox;
      /*! display:flex; */-webkit-box-pack:justify;
      -ms-flex-pack:justify;
      justify-content:space-between
    }
    .stepper-horizontal li {
      /* position:relative; */
      display:-webkit-box;
      display:-ms-flexbox;
      display:flex;
      /* -webkit-box-align:baseline; */
      -ms-flex-align:baseline;
      align-items:baseline;
      -webkit-transition:.5s;
      transition:.5s
    }
    .stepper-horizontal li a .label {
      margin-top:.63rem
    }
    .stepper-horizontal li:not(:last-child):after {
      position:relative;
      -webkit-box-flex:1;
      -ms-flex:1;
      flex:1;
      height:1px;
      margin:.5rem 0 0 0;
      /* content:""; */
      background-color:rgba(0,0,0,.1)
    }
    .stepper-horizontal li:not(:first-child):before {
      position:relative;
      -webkit-box-flex:1;
      -ms-flex:1;
      flex:1;
      height:1px;
      margin:.5rem 0 0 0;
      /* content:""; */
      background-color:rgba(0,0,0,.1);
      min-width:40px
    }
    .stepper-horizontal li:hover {
      /*! background-color:rgba(0,0,0,0.06) */
    }
    .stepper-horizontal>li:not(:last-of-type) {
      margin-bottom: 354!important;
    }
    .stepper-vertical {
      position:relative;
      display:-webkit-box;
      display:-ms-flexbox;
      display:flex;
      -webkit-box-orient:vertical;
      -webkit-box-direction:normal;
      -ms-flex-direction:column;
      flex-direction:column;
      -webkit-box-pack:justify;
      -ms-flex-pack:justify;
      justify-content:space-between
    }
    .stepper-vertical li {
      position:relative;
      display:-webkit-box;
      display:-ms-flexbox;
      display:flex;
      -webkit-box-flex:1;
      -ms-flex:1;
      flex:1;
      -webkit-box-orient:vertical;
      -webkit-box-direction:normal;
      -ms-flex-direction:column;
      flex-direction:column;
      -webkit-box-align:start;
      -ms-flex-align:start;
      align-items:flex-start
    }
    .stepper-vertical li a {
      position:relative;
      display:-webkit-box;
      display:-ms-flexbox;
      display:flex;
      -ms-flex-item-align:start;
      align-self:flex-start
    }
    .stepper-vertical li a .circle {
      -webkit-box-ordinal-group:2;
      -ms-flex-order:1;
      order:1
    }
    .stepper-vertical li a .label {
      -webkit-box-orient:vertical;
      -webkit-box-direction:normal;
      -ms-flex-flow:column nowrap;
      flex-flow:column nowrap;
      -webkit-box-ordinal-group:3;
      -ms-flex-order:2;
      order:2;
      margin-top:.2rem
    }
    .stepper-vertical li.completed a .label {
      font-weight:500
    }
    .stepper-vertical li .step-content {
      display:block;
      padding:.94rem;
      margin-top:0;
      margin-left:3.13rem
    }
    .stepper-vertical li .step-content p {
      font-size:.88rem
    }
    .stepper-vertical li:not(:last-child):after {
      position:absolute;
      top:3.44rem;
      left:2.19rem;
      width:1px;
      height:calc(100% - 40px);
      /* content:""; */
      background-color:rgba(0,0,0,.1)
    }
    .primary-color,
    ul.stepper li.active a .circle {
      background-color:#4285f4!important
    }
    .Page-Title-Bar {
      background:#f8f9fa;
      padding:4px 10px 4px 32px!important;
      font-size:16px;
      font-weight:700;
      margin-bottom:2px;
      justify-content:center;
      align-items:center;
      display:inline;
      position:relative
    }
    a.menu-link {
      width:max-content
    }
    .container.listrow.bg-changed {
      background-color:#89f58929 !important;
      border-left: 3px solid #25c625;
    }
    .Ticket-Details .material-icons {
      margin-right:13px
    }
    .Ticket-Details .Ticket-Value .material-icons {
      margin-right:7px!important;
      position:relative;
      top:4px
    }
    .Assigned-Date {
      margin-right:16px
    }
    .Ticket-Description {
      display:-webkit-box;
      -webkit-box-orient:vertical;
      -webkit-line-clamp:2;
      overflow:hidden;
      font-size:13px!important;
      color:#181c32!important
    }
    #Process-stepper ul.stepper li a {
      padding:0 10px
    }
    .Page-Title {
/*      width:33%;*/
      display:flex;
      align-content:center;
      justify-content:space-between;
      
    }
    #Process-stepper {
/*      width:57%;*/
      background:#fff
    }
    #Process-stepper ul.stepper li a {
      padding:0 10px
    }
    ul.stepper {
      font-size:12px;
      font-weight:400
    }
    #PROFLOW_Left .card-body {
      padding:1rem !important;
    }
    .Tkts-toolbar-Right {
      /*! margin-left: auto; */width:10%;
      text-align:right
    }
    .task-more-btns {
      padding-top:15px;
      border-top:1px solid #ebebeb;
      padding-left:50px
    }
    #PROFLOW_Left .card-body {
      overflow:auto
    }
    #PROFLOW_Left .text-warning {
      color:#eb7900!important
    }
    #ProcessFlow_New-container .nav.nav-tabs {
      display:flex;
      justify-content:space-around;
      position:fixed;
      width:23.3%;
      background:#fff;
      z-index:9
    }
    #PROFLOW_Left .card-header {
      background:#fff!important;
      max-height:46px;
      padding:0!important
    }
    #PROFLOW_Left .nav.nav-tabs.nav-line-tabs {
      width:100%;
      display:flex;
      align-items:center;
      justify-content:space-between;
      border-bottom:0
    }
    #PROFLOW_Left .nav-link {
      font-size:1.1rem;
      font-weight:700;
      margin-right:0
    }
    #PROFLOW_Left .nav-link .material-icons {
      position:relative;
      top:6px;
      font-size:17px!important
    }
    .Assigned-By,
    .Assigned-Date {
      color:#6b6f85!important
    }
    @media(max-width:768px) {
      .Ticket-Value {
        padding-left:42px!important
      }
      #Tickets_details_view .card-header {
        padding-inline:0!important
      }
      .Ticket-details-row {
        padding-left:50px!important
      }
      .task-more-btns {
        flex-wrap:wrap;
        display:flex;
        justify-content:space-around
      }
      #PROFLOW_Left .Ticket-Value {
        padding-left:0!important
      }
      ul.stepper {
        margin-right:0;
        padding-inline:15px!important
      }
      #Process-stepper {
        width:100%;
        order:3;
        margin-block:5px
      }
      .Page-Title {
        width:60%
      }
      #Process-stepper ul.stepper {
        padding-inline:0!important;
        padding-block:8px!important
      }
      #Process-stepper .stepper-horizontal li a .label {
        margin-top:0!important
      }
    }
    a.ProcessFlow_New-List-Title {
      color:#000000cf !important;
    }
    .custom-menu-item {
      display:block;
      padding:0
    }
    .custom-menu-item .custom-menu-link {
      cursor:pointer;
      display:flex;
      align-items:center;
      padding:0;
      flex:0 0 100%;
      padding:.65rem 1rem;
      transition:none;
      outline:0!important
    }
    .Timel-sessions {
      /*! margin-top: 2rem; */border-radius:12px;
      position:relative;
      height:150px!important;
      overflow:hidden;
      padding-top:25px
    }
    .Timel-sessions li {
      /*! padding-bottom: 1.5rem; */border-left:1px solid #c3c3c3;
      position:relative;
      padding-left:15px;
      margin-left:20px;
      position:relative;
      top:-5px;
      /*! margin-top: -5px; *//*! padding-top: 25px; */padding-bottom:19px
    }
    .Timel-sessions li:last-child {
      border:0;
      padding-bottom:0
    }
    .Timel-sessions li .time {
      color:#606060;
      font-weight:500;
      width:auto
    }
    @media screen and (min-width:601px) {
      .Timel-sessions li .time {
        font-size:.9rem
      }
    }
    @media screen and (max-width:600px) {
      .Timel-sessions li .time {
        margin-bottom:.3rem;
        font-size:.85rem
      }
    }
    .Timel-sessions li p {
      color:#333;
      font-family:apple-system,BlinkMacSystemFont,"San Francisco","Segoe UI",Roboto,"Helvetica Neue",sans-serif!important;
      /*! line-height: 0.5; *//*! margin-top: 0.4rem; */font-size:1.11rem!important;
      font-weight:600;
      width:80%;
      margin-bottom:0!important;
      /*! margin-top: 5px; */vertical-align:sub;
      display:table;
      position:relative;
      top:-5px
    }
    @media screen and (max-width:600px) {
      .Timel-sessions li p {
        font-size:.9rem
      }
    }
    .Timel-sessions.full-session {
      min-height:70vh!important;
      max-height:125vh!important;
      overflow:auto
    }
    #Timeline-wrap {
      padding:14px 0;
      background:#fff;
      border-radius:0!important;
      border-bottom:1px solid #ebebeb
    }
    .Timeline-heading {
      border-bottom:1px solid #eaeaee;
      padding-bottom:10px;
      font-size:16px;
      font-weight:600;
      padding-left:15px
    }
    div#TimeLine_overall {
      text-align:left
    }
    #BulkActiveList_Container .task-listing-card {
      padding-top:0!important
    }
    #BulkActiveList_Container {
      height:50vh!important;
      overflow-y:scroll/*! border: 1px solid #ececec; */
    }
    #modal_ldbApprove .card-body {
      border:1px solid #ececec!important;
      border-radius:10px
    }
    #BulkActiveList_Container .task-list-checkbox {
      left:0;
      top:20px;
      width:16px;
      height:16px
    }
    #Bulk-SelectALL-wrap {
      padding:5px;
      border-bottom:1px solid #ededed;
      position:relative;
      top:-8px;
      margin-left:5px
    }
    #BulkActiveList_Container .task-right {
      width:60%!important
    }
    #BulkActiveList_Container .task-assignedBy,
    #BulkActiveList_Container .task-date {
      font-size:14px!important;
      font-weight:600!important
    }
    #BulkActiveList_Container .task-assignedBy::before,
    #BulkActiveList_Container .task-date::before {
      margin-top:0!important
    }
    #horizontal-processbar .circle::after {
      background:0 0!important
    }
    .mandatory::after {
      content:"*";
      color:red;
      font-size:14px
    }
    #BulkActiveList_Container .task-title {
      font-weight:700!important;
      font-size:14px!important
    }
    #BulkActiveList_Container .task-process {
      border-bottom:1px solid #ececec
    }
    #BulkActiveList_Container .task-listing-icons {
      position:relative;
      top:6px
    }
    #BulkActiveList_Container .task-subtitle {
      padding-left:0!important
    }
    #BulkActiveList_Container .task-title:hover {
      color:inherit!important;
      text-decoration:none!important
    }
    .horizontal-processbar .disabled a {
      cursor:not-allowed;
      pointer-events:none
    }
    #horizontal-processbar .disabled {
      pointer-events:none!important;
      cursor:not-allowed
    }
    ul.stepper li.completed a .circle {
      background:#50cd89!important;
      color:#fff!important
    }
    .Task-process-list.Active>a {
      background:#00800012;
      color:green!important;
      font-weight:600;
      padding:5px 13px;
      display:block;
      border-radius:5px
    }
    div[data-tasktype="Else if"] .Task-process-list>a {
      background:#20b2aa;
      padding:4px 15px;
      border-radius:5px;
      color:#fff!important
    }
    .Task-process-list.status-disabled {
      /*! pointer-events: none; */cursor:not-allowed!important;
      opacity:.5
    }
    .Task-process-list.status-disabled a {
      cursor:not-allowed!important
    }
    .circle.success:after {
      background-color:#1eb588
    }
    .circle.pending::after {
      background-color:orange
    }
    ul.stepper li.pending a .circle {
      background:orange;
      color:#fff
    }
    .circle.pending .PROFLOW-steps-counts,
    .circle.success .PROFLOW-steps-counts {
      color:#fff
    }
    .step.step-active .circle {
      background-color:#006cff;
      border:1px solid #006cff!important;
      color:#fff
    }
    .step.step-completed .circle {
      color:#fff;
      background:#1bb587;
      border-color:#1bb587!important
    }
    .circle.pending {
      background:#ffbc20;
      border-color:#ffbc20!important
    }
    .circle.pending .PROFLOW-steps-counts,
    .circle.success .PROFLOW-steps-counts {
      color:#fff
    }
    .step.step-active {
      color:#1bb587
    }
    .step.step-active .circle {
      background-color:#006cff;
      border:1px solid #006cff!important;
      color:#fff
    }
    .step.step-completed .circle {
      color:#fff;
      background:#1bb587;
      border-color:#1bb587!important
    }
    .circle.pending {
      background:#ffbc20;
      border-color:#ffbc20!important
    }
    .circle.pending .PROFLOW-steps-counts,
    .circle.success .PROFLOW-steps-counts {
      color:#fff
    }
    ul.stepper li.completed a .circle {
      background:#50cd89!important;
      color:#fff!important
    }
    ul.stepper li.pending a .label {
      color:#000!important
    }
    #plistContentCompleted .text-warning {
      color:#50cd89!important
    }
    .accordion-button {
      display:flex;
      align-items:center;
      justify-content:flex-start;
      transition:background-color .3s ease;
      padding:.75rem 1.25rem;
      font-size:1rem;
      cursor:pointer
    }
    .accordion-button::after {
      display:none
    }
    .accordion-button:not(.collapsed) {
      color:#000
    }
    .accordion-button.collapsed::before {
      content:"\276D";
      margin-right:10px;
      transition:transform .3s ease;
      transform:rotate(0)
    }
    .accordion-button:not(.collapsed)::before {
      content:"\276D";
      margin-right:10px;
      transition:transform .3s ease;
      transform:rotate(90deg)
    }
    .accordion-button.show-collapse-button::before {
      display:block!important;
      transform:rotate(90deg)!important
    }
    .accordion-button.show-collapse-button.collapsed::before {
      display:block!important;
      transform:rotate(0)!important
    }
    .accordion-header.active .accordion-button.show-collapse-button::before {
      transform:rotate(0)!important;
      display:block
    }
    .accordion-header:not(.active) .accordion-button::before {
      display:none
    }
    .accordion-body {
      padding:0;
      font-size:.875rem;
      color:#555;
      background-color:#fafafa
    }
    .accordion-item {
      border:1px solid #ddd;
      border-radius:5px;
      margin-bottom:5px
    }
    .accordion-header {
      padding:0
    }
    .accordion-button {
      background-color:#f8f9fa;
      border:none;
      color:#000;
      cursor:pointer;
      font-weight:700
    }
    .accordion-button:hover {
      background-color:#e9ecef
    }
    .accordion-button:focus {
      box-shadow:none
    }
    .container.listrow.active-row,
    .container.listrow.completed-row {
      display:block;
      align-items:center;
      justify-content:space-between;
      padding:5px 10px;
      border-bottom:1px dashed #bbb4b4;
      cursor:pointer;
      background-color:#fff;
      margin:00;
      overflow:hidden
    }
   /* .listrow:hover .user:not(.selectclicked) {
      visibility:hidden
    } */
    .listrow:hover .task-checkbox:not(.selectclicked) {
      visibility:visible!important
    }
    .listrow:hover .task-checkbox {
      visibility:visible!important
    }
    .listrow.selected .user {
      visibility:hidden
    }
    .listrow.selected .task-checkbox {
      visibility:visible
    }
      /*.listrow.active-row {
     border-left:3px solid #4c93da 
    }*/
    .listrow.active-row .tasktitle {
      color:#000;
      font-size:12px;
      font-weight:700
    }
    .listrow.active-row .taskcontent {
      color:#333;
      font-size:13px;
      font-weight:600;
    }
    .listrow.active-row {
      background-color:#fff;
      /*! border-left:3px solid transparent; */box-sizing:border-box;
      transition:background-color .3s ease,box-shadow .3s ease;
      border-left-color:#4c93da
    }
    .listrow.active-row:hover {
      background-color:#0774fe1a;
      border-left-color:#4c93da;
      box-shadow:inset 3px 0 0 #4c93da;
    }
    .listrow.completed-row:hover {
      background-color:#0774fe1a;
    }
    .user {
      width:28px;
      height:28px;
      border-radius:50%;
      background-color:cornflowerblue;
      display:flex;
      align-items:center;
      justify-content:center;
      font-weight:700;
      color:#fff;
      font-size:18px;
      text-transform:uppercase;
      font-size:15px;
      /*! border:1px solid #ddd; *//*! box-shadow:0 2px 4px rgba(0,0,0,.1); */position:absolute
    }
    .checkbox-wrapper {
      align-items:center;
      justify-content:center;
      display:inline-flex;
      position:relative;
      padding-right: 0;
    }
    .task-checkbox {
      visibility:hidden;
      width:15px;
      height:15px;
      position:absolute;
      top:50%;
      left:50%;
      transform:translate(-50%,-50%)
    }
    .col-content {
      flex-grow:1;
      padding:0 10px
    }
    .taskcontent,
    .taskdatetime,
    .tasktitle {
      margin:0;
      padding:2px 0
    }
    .task-link a {
      color:#007bff;
      text-decoration:none
    }
    .task-link a:hover {
      text-decoration:underline
    }
    .taskcontent,
    .tasktitle {
      white-space:nowrap;
      overflow:hidden;
      text-overflow:ellipsis;
      display:inline-block;
      width:calc(100% - 0px);
      /*! height:25px; */
    }
    .timespace {
      align-items:center;
      justify-content:space-between;
      color:#0774fe
    }
    #PROFLOW_Right {
      transition:all .3s ease;
      /* background: aliceblue; */
      padding-block: 11px;
    }
    #collapseicon {
      cursor:pointer
    }
    .nametime {
      width:max-content;
      margin:5px;
      font-weight: 600;
      color: #838383;
      font-size: 12px;
      margin-bottom: 0 !important;
      margin-top: 0;
    }
    .listrow.completed-row .timespace {
      color:#000
    }
    .rowicons {
      display:inline-flex;
      align-items:center
    }
    ul.stepper:has(>li:not(:empty)) {
      display:-webkit-inline-box!important
    }
    ul.stepper:has(>li:empty) {
      display:none
    }
    .maincheckbox {
      display:none;
      width:15px;
      position:relative;
      left:14px
    }
    .task-checkbox.hovered {
      background:0 0;
      color:#000
    }
    #dvModalFilter .row {
      margin-bottom:15px
    }
    .col-md-3.fldCaption {
      display:flex;
      align-items:center
    }
    .form-group.form-row.fldCaption {
      display:flex;
      position:relative;
      gap:10px;
      top:-19px
    }
    .form-group.form-row.fldCaption label {
      position:relative;
      top:10px;
      left:9px;
      background:#fff;
      padding:0 8px
    }

    /*VJ Inbox customization*/

    .top-panel {
        background: var(--card);
/*        margin: 0 18px;*/
        border-radius: 10px;
        padding: 12px;
        border: 1px solid var(--border);
        display: grid;
        grid-template-columns: auto 1fr auto;
        align-items: center;
        gap: 12px;
        overflow: hidden;
    }
    /*#filterSection {
        display: flex;
        flex-wrap: wrap;
        gap: 4px;
    }*/
	#filterSection {
  display: flex;
  align-items: center;
  /* gap: 12px; */
  flex-wrap: nowrap;
}


    .filter-btn.active {
        background: #2f86ff;
        color: #fff;
        border-color: #2f86ff;
        box-shadow: 0 3px 10px rgba(47,134,255,0.25);
    }
    .filter-btn {
        display: flex;
        gap: 0;
        align-items: center;
        padding: 4px 8px;
        border-radius: 0;
        border: 1px solid #2f86ff36;
        background: #f4f7fc;
        cursor: pointer;
        font-size: 12px;
        font-weight: 600;
        color: #1f3a63;
        transition: var(--transition);
        border: 0;
        border-left: 1px solid #2f86ff78;
    }
    .top-panel .search-section {
        flex: 1 0 0;
    }
.search-input {
	padding: 4px 12px;
	border: 1px solid #ccc;
	width: 100%;
	border-radius: 0 !important;
	font-weight: 600;
	font-size: 13px;
}
.top-panel .section {
  display: flex;
  flex-wrap: nowrap;
  align-items: center;
  gap: 4px;
  border-right: 1px solid #cfcfcf;
  /* padding-right: 12px; */
  height: 25px;
  margin-left: 18px;
  z-index: 9;
  /* width: 270px; */
}
    .actions .act {
        white-space: nowrap;
        padding: 8px 10px;
        border: 1px solid #ccc !important;
        border-radius: 4px;
    }
    #topPanel .btn {
        padding: 5px 15px;
        border-radius: 0;
    }
#filterSection .count {
	min-width: 18px;
	height: 18px;
	/* background: #fff; */
	/* color: #fff; */
	text-align: center;
	border-radius: 50px;
	font-size: 13px;
	line-height: 8px;
	padding: 5px;

	font-weight: 800;
}
    #cnt-open, #Open_Task .menu-count {
/*        background: #b3261e !important;*/ color:#b3261e !important
       
    }
    #cnt-team, #My_Team .menu-count {
/*        background: blue !important;*/ color: blue !important;
    }
    #cnt-pend,#Pending_Approval .menu-count {
/*        background: #e37400 !important;*/ color: #e37400 !important;
    }
    #cnt-unread,#Unread .menu-count {
/*        background: #333 !important;*/ color: #333 !important;
    }
    #cnt-sent,#Send_Items .menu-count {
/*        background: #188038 !important;*/ color:  #188038 !important;
    }

/*two line counts*/

.filter-btn {
  flex-wrap: wrap;
  justify-content: center;
}
/*two line counts*/


    #cnt-All {
        background: #ffffff73 !important;
        
    }
    #topPanel {
        background: white;
        /* border: 1px solid #dcdcdc;
         margin-bottom: 4px;*/
        border-radius: 0;
        padding: 0 5px;       
        display: flex;
        justify-content: space-between;
        width: 100%;
    }


    .menu-count {
        min-width: 18px;
        height: 18px;
        background: #333;
        color: #fff;
        text-align: center;
        border-radius: 50px;
        font-size: 11px;
        line-height: 8px;
        padding: 5px;
        margin-left: 8px;
        font-weight: 600;

        margin-right: auto;
    }
    #PROFLOW-overalldiv #KtMenu .menu-link {
        width: 100%;
    }


    .menu-count {
        min-width: 28px;
        height: 18px;
        background: #333;
        color: #fff;
        text-align: center;
        border-radius: 50px;
        font-size: 11px;
        line-height: 8px;
        padding: 5px;
        margin-left: 8px;
        font-weight: 600;

        margin-right: auto;
    }
    #PROFLOW-overalldiv #KtMenu .menu-link {
        width: 100%;
    }
    #alllist .menu-count {
        background: #3388fe;
    }
    .taskcontent {
        font-weight: 700;
        color: #3333339e !important;
    }

    /*Left*/

    .timespace .nametime:first-child:before {
      content: ''\e7fd'';
      margin-right: 4px;
      font-family: "Material Icons Outlined";
      position: relative;
      top: 1px;
    }
    .timespace .nametime:first-child {
      color: #333;
      font-weight: 900;
      font-size: 13px;
      text-transform: capitalize;
    }
    #Tickets_details_view:has(.d-none) {
        padding: 0 !important;
    }
    .listrow.active-row:hover {
        background-color: #0774fe1a;
        border-left-color: #4c93da;
        box-shadow: inset 3px 0 0 #4c93da;
    }
    .container.listrow.bg-changed {
        background-color: #89f58929 !important;
        border-left: 3px solid #25c625;
    }
    .listrow.active-row .tasktitle {
        color: #000;
        font-size: 14px !important;
        font-weight: 800;
    }
    .listrow.active-row .tasktitle {
        color: #000;
        font-size: 14px !important;
        font-weight: 800;
    }

    .nametime {
        width: max-content;
        margin: 5px;
        font-weight: 600;
        color: #838383;
        font-size: 12px;
        margin-bottom: 0 !important;
        margin-top: 0;
    }
    .taskcontent {
        font-weight: 700 !important;
        font-size: 12px;
        color: #333;
    }
    .container.listrow.completed-row .user {
        background: #94cc94;
        color: #fff !important;
        background: #028b5b;
    }
    .container.listrow.completed-row .user span {
        color: green !important;
        color: #fff !important;
    }

    .listrow.active-row .taskcontent {
        color: #333;
        font-size: 13px;
        font-weight: 600 !important;
    }
    .tooltip .tooltip-inner {
        box-shadow: 0 0 20px 0 rgba(0,0,0,.15);
        border-radius: 0;
        font-weight: 600 !important;
        border: 1px solid #dcdcdc;
    }

    .accordion-button.collapsed::before,.accordion-button:not(.collapsed)::before {
        content: "\e315";
        font-family: "Material Icons Outlined";
    }
    .accordion-item:last-of-type .accordion-button.collapsed{border-radius: 0 !important}


#PROFLOW-overalldiv {
	width: calc(100vw + 10px);
}

.top-panel .section:last-child {
	border: 0 !important;
	padding-right: 0;
}

#collapseicon ,.Tkts-toolbar-Left,.Tkts-toolbar-Right{
	display: none;
}
.Page-Title-Bar {
	padding: 4px 10px 4px 20px !important;

}


.task-desc {
    max-height: 15em;        /* ~15 lines */
    overflow-y: auto;
    line-height: 1.4em;
}

.ticket-header {
    border-bottom: 1px solid #ddd;
    padding-bottom: 10px;
}


.ticket-view {
    padding: 15px;
    background: #ffffff;
    border-radius: 10px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    height: 100%;
}

.ticket-view h4 {
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 6px;
}

.ticket-view .fw-semibold {
    font-size: 14px;
    color: #555;
}

.task-desc-box {
    background: #f9fafb;
    border-radius: 8px;
    padding: 12px 14px;
}

.task-desc-box strong {
    font-size: 14px;
}

.task-desc-text {
    font-size: 14px;
    color: #333;
    line-height: 1.6;
}

.ticket-view .mt-2 strong,
.ticket-view .mt-3 strong {
    font-size: 14px;
}

.ticket-view a.badge {
    background: #eef2f7;
    border-radius: 16px;
    padding: 6px 12px;
    font-size: 13px;
}

.ticket-view a.badge:hover {
    background: #e2e8f0;
}

.ticket-view .mt-3 {
    background: #f1f5f9;
    border-radius: 8px;
    padding: 12px 14px;
}
.task-history {
    border-radius: 10px;
}

.history-header { cursor: pointer; }

.history-body {
    overflow: hidden;
    transition: max-height 0.35s ease;
}

.history-body.open {
    max-height: 500px; /* large enough for your data */
}

.history-item {
    background: #f5f7fa;
    border-radius: 8px;
    padding: 8px 12px;
    margin-bottom: 6px;
    font-size: 0.9rem;
}

.search-box {
    position: relative;
   
}

.search-input {
    width: 100%;
    padding: 5px 12px 5px 38px;   /* left padding makes space for icon */
    border-radius: 6px;
    outline:none;
}

.search-icon {
  position: relative;
  /* top: 50%; */
  left: -28px;
  /* transform: translateY(-50%); */
  color: #6c757d;
  pointer-events: none;
  font-size: 20px;
  cursor:pointer;
}

.section.actions {
    position: relative;
    z-index: 200;
}
body .content:has(#New-Landing-layout) {
  height: 100vh !important;
  max-height: 85.9vh !important;
}

.dropdown-toggle::after {
  display: inline-block;
  margin-left: .255em;
  vertical-align: .255em;
  content: "";
  border-top: .3em solid;
  border-right: .3em solid transparent;
  border-bottom: 0;
  border-left: .3em solid transparent;
  position: relative;
  top: 5px;
}

/*vj customize*/


#Tickets_details_view {
  background: #f9f9f9;
  background: aliceblue;
  box-shadow: 5px -5px 13px 1px #cccccc54 inset;
  height: 100vh !important;
  background: #eaeaea2b;
}
.mt-4:has(.history-header) {
  margin: 0 35px;
}

.ticket-view {
	padding: 0 0;
	background: transparent;
	border-radius: 10px;
	box-shadow: 0 4px 12px rgba(0,0,0,0.05);
	height: 100%;
}
.ticket-view h4 {
	font-size: 20px;
	font-weight: bolder;
	margin-bottom: 0;
	background: #dfeefc;
	padding: 7px 25px;
	padding-bottom: 0;
	color: #333 !important;
	padding-top: 15px;
}

.ticket-view .fw-semibold {
	font-size: 14px;
	color: #333;
	background: #dfeefc;
	margin-top: 0 !important;
	padding: 7px 25px 15px;
	padding-top: 0;
	font-weight: 600;
}
.ticket-view .mt-3 {
	/* background: #f1f5f9; */
	border-radius: 8px;
	padding: 12px 14px;
	margin: 0 35px;
	font-weight: 600;
}
.history-header {
	cursor: pointer;
	font-size: 16px;
	font-weight: bolder !important;
}




#process-name {
  /*! width: 38% !important; */
}
.d-flex.Right-Header-Section {
	width: 78%;
	display: flex !important;
	justify-content: space-between;
	align-items: center;
}
.Filter-Section-wrapper {
  display: flex;
  border-right: 1px solid #ccc !important;
  padding-right: 15px;
  min-width: 200px !important;
}
.top-panel .section.search-section {
  flex: inherit;
}
.hdr-dropdown {
	position: relative;
	width: 330px;
}

.Histroy-description-wrap {
	font-weight: 600 !important;
	display: flex;
}
.Histroy-description-Date {
	font-weight: bolder !important;
	color: green;
}

.history-item {
	background: transparent !important;
	border-radius: 0 !important;
	border-bottom: 1px dashed #a3a3a3 !important;

}

.hdr-dropdown {
	position: relative;
	width: 380px !important;
}
.Status-Btns-wrapper .action-buttons {
	margin-left: 35px;
}
strong {
	font-weight: 800;
}
#Tickets_details_view {
	height: calc(100vh - 40px) !important;
  overflow: auto;
	max-height: calc(100vh - 42px) !important;
}
.dropdown-item {
	font-weight: 600 !important;
}
#process_centerpanel,#topPanel {
	background: transparent !important;
}
.Page-Title-Bar {
	background: #4e86c7 !important;
  height: 40px;
	background: #f4f5fb !important;
	justify-content: space-between;
	display: flex;
	/*! width: 100%; */
}
.hdr-btn {
	background: transparent !important;
	color: white !important;
	border: 1px solid #ffffff70;
	border-radius: 0 !important;
}
.Page-Title span {
	color: white !important;
	color: #333 !important;
}
.Filter-Section-wrapper span {
	color: white !important;
	margin-right: 15px !important;
}




/*inline ---------------------------------------------------------------------------------------------------------------------------*/



        
        #Process-stepper {

            flex: none !important;
            margin-left: 32.3333% !important;
            width: 67.6667% !important;
            max-width: 115% !important;
            background: #fff;
            position: relative;
            z-index: 10;
            top: 3px;

            /* scrollbar */
            overflow-x: auto !important;
            overflow-y: hidden !important;
            white-space: nowrap;
            height: 40px;
        }

        #horizontal-processbar {
            display: inline-flex !important;
            width: max-content !important;
            min-width: max-content !important;
            flex-wrap: nowrap !important;
        }

        body#Task_activity {
            overflow: hidden;
        }

        div#ktMenu {
            /* transform: translate(327px, 35px)!important; */
            cursor: pointer;
            padding: 8px;
            font-size: small;
            font-weight: 500;
            position: absolute;
            inset: unset !important;
            transform: none !important;
        }

        .text-hover-primary:hover {
            background: #d3d3d35c;
            transition: color .2s ease, background-color .2s ease;
            /* color: #0774fe!important; */
            /* width: -webkit-fill-available; */
            color: black !important;
        }


        .user-main {
            background: #4e86c7;
            color: #fff;
            padding: 5px 16px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            display: block;
            align-items: center;
            user-select: none;
            position: relative !important;
            z-index: 100000 !important;
            pointer-events: auto;
            font-size: 15spx;
            font-size: 15px;
            min-width: 110px;
            max-width: 160px;
            left: -10px;
        }

        .arrow {
            position: absolute;
            right: 0px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 12px;
            pointer-events: none;

        }

        .group-btn .material-icons {
            font-size: 18px;
        }



        .user-item {
            padding: 10px 14px;
            cursor: pointer;
            font-size: 14px;
        }




        /* ===============================
   INBOX USER SWITCHER — FINAL FIX
================================ */

        #topPanel {
            position: relative !important;
            overflow: visible !important;

        }

        .inbox-user-switcher {
            position: relative !important;
            display: inline-block;
            z-index: 9999;

        }


        /* Dropdown menu */
        .user-dropdown {
            position: absolute !important;
            top: calc(100% + 6px);
            left: 0;
            min-width: 200px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            display: none;
            z-index: 100001 !important;
            transform: none !important;
            inset: unset !important;
            top: 46px !important;
            left: -11px !important;
        }

        /* When opened */
        .user-dropdown.open {
            display: block !important;
        }

        /* Prevent Axpert overlays from covering it */
        .Page-Title,
        .Title-Section,
        .Tkts-toolbar-Right,
        .Tkts-toolbar-Left {
            overflow: visible !important;
        }



        .user-item:hover {
            background: #f3f6fb;
        }

        /* .pagename{
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    width: max-content;
    gap: 4px;
} */
        .icon-filters {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .icon-filter {
            display: flex;
            align-items: center;
            /* gap: 6px; */
            padding: 6px 10px;
            border-radius: 8px;
            cursor: pointer;
            background: #f3f6fb;
            color: #444;
            font-size: 12px;
            transition: all .2s ease;
            margin: 10px 0px;
        }

        .icon-filter .material-icons {
            font-size: 18px;
        }

        .icon-filter:hover {
            background: #e1e7f5;
        }

        .icon-filter.active {
            background: #4e86c7;
            color: white;
        }

        .icon-filter .count {
            font-size: 11px;
            opacity: 0.85;
        }

        .icon-all {
            color: #3b82f6;
        }

        /* Blue */
        .icon-active {
            color: #f59e0b;
        }

        /* Amber */
        .icon-completed {
            color: #22c55e;
        }

        /* Green */
        .icon-sent {
            color: #6366f1;
        }

        /* Indigo */
        .icon-pending {
            color: #f97316;
        }

        /* Orange */
        .icon-approved {
            color: #10b981;
        }

        /* Teal */
        .icon-rejected {
            color: #ef4444;
        }

        /* Red */
        .icon-returned {
            color: #8b5cf6;
        }

        /* Violet */
        .icon-filter.active .material-icons {
            color: inherit;
        }

        .icon-message {
            color: #0ea5e9;
        }

        /* Sky Blue */
        .icon-notification {
            color: #facc15;
        }

        /* Yellow */
        .inbox-user-select {
            padding: 6px 14px;
            border-radius: 6px;
            border: 1px solid #d0d5dd;
            background: #2563eb;
            color: #fff;
            font-weight: 600;
            cursor: pointer;
        }

        .inbox-user-select {
            background: #4e86c7;
            color: #fff;
            padding: 6px 36px 6px 16px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            font-size: 15px;
            border: none;
            outline: none;
            appearance: none;
            min-width: 140px;
            max-width: 200px;
            background-image: url("data:image/svg+xml;utf8,<svg fill=''white'' height=''16'' viewBox=''0 0 24 24'' width=''16'' xmlns=''http://www.w3.org/2000/svg''><path d=''M7 10l5 5 5-5z''/></svg>");
            background-repeat: no-repeat;
            background-position: right 10px center;
        }

        .inbox-user-select option {
            color: #000;
        }

        /* Make ONLY the dropdown options white */
        .inbox-user-select option {
            background: #ffffff !important;
            color: #000000 !important;
        }

        /* Highlight on hover / selected option */
        .inbox-user-select option:checked,
        .inbox-user-select option:hover {
            background: #f3f6fb !important;
            color: #000000 !important;
        }

        .filter-group {
            position: relative;
        }

        .group-btn {
            display: flex;
            align-items: center;
            gap: 6px;
            background: #f3f6fb;
            border-radius: 8px;
            padding: 6px 12px;
            border: none;
            cursor: pointer;
            font-size: 13px;
            width: 100px;
        }

        .group-btn:hover {
            background: #e1e7f5;
        }

        .group-btn .arrow {
            font-size: 16px;
            transition: .2s;
        }

        .filter-group.open .arrow {
            transform: rotate(180deg);
        }

        .group-menu {
            position: absolute;
            top: 115%;
            left: 0;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, .15);
            padding: 6px;
            display: none;
            z-index: 1000;
            min-width: 210px;
        }

        .filter-group.open .group-menu {
            display: block;
        }

        .group-menu .icon-filter {
            width: 100%;
            justify-content: flex-start;
            border-radius: 6px;
        }

        .group-menu .icon-filter:hover {
            background: #f3f6fb;
        }

        /* 
        new */

        .inbox-sub-toolbar {
            display: flex;
            align-items: center;
            gap: 40px;
            /* padding: 8px 12px; */
            /* border-bottom: 1px solid #e5e7eb; */
            /* background: #fff; */
        }

        .all-toggle {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
        }

        .filter-btn {
            border: none;
            background: transparent;
            cursor: pointer;
        }

        .active-filters {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .filter-chip {
            background: #eef2f7;
            border-radius: 14px;
            padding: 4px 10px;
            font-size: 12px;
        }

        .filter-chip span {
            cursor: pointer;
            margin-left: 6px;
        }



        .hidden {
            display: none !important;
        }

        .inbox-sub-toolbar {
            position: relative;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .filter-wrapper {
            position: relative;
            /* 🔑 anchor for popup */
        }

        .filter-panel {
            display: none;
            position: absolute;
            top: calc(100% - 12px);
            left: 220px;
            width: 330px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 10px 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
        }




        .filter-panel label {
            display: inline-block;
            width: 48%;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .filter-panel.show {
            display: block;
            position: absolute;
            z-index: 2000;
        }


        .filter-option {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 6px 0;
            cursor: pointer;
        }

        .filter-btn {
            background: none;
            border: none;
            cursor: pointer;
        }



        .filter-message-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            /* pushes X to last */
            background: #eaeef2;
            padding: 5px 16px;
            border-radius: 4px;
            margin: 0;
            font-size: 14px;
        }

        #filterMessageText {
            flex: 1;
        }


        .close-btn {
            background: transparent;
            border: 1px solid #94a3b8;
            color: #1f2937;
            width: 28px;
            height: 28px;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .all-toggle.active {
            color: #2563eb;
            font-weight: 600;
        }

        .search-box {
            position: relative;
            display: flex;
            align-items: center;
        }

        .search-input {
            flex: 1;
            padding-right: 149px;
            /* width: 178%; */
            padding-left: 5px;
        }

        .filter-icon {
            position: absolute;
            right: 10px;
            cursor: pointer;
            color: #888;
        }

        .filter-icon.active {
            color: #0d6efd;
            /* blue highlight */
        }

        .menu.menu-sub.menu-sub-dropdown.menu-rounded.menu-gray-600.menu-state-bg-light.fw-bolder.w-300px.py-3.initialized.show {
            position: absolute;
            right: 0px;
        }

        #plistContent {
            height: 90vh;
            overflow-y: auto;
        }

        #filterMessageBar {
            position: absolute;
            top: 82px;
            left: 0;
            right: 0;
            z-index: 1000;
            /* background: #eef4ff; */
            padding: 0px 16px;
            border-bottom: 1px solid #ddd;
            transform: translateY(-100%);
            transition: transform 0.3s ease;
        }

        #filterMessageBar.show {
            transform: translateY(0);
        }

        #filterMessageBar.hidden {
            transform: translateY(-100%);
        }

        .nametime {
            display: block;
            width: 60px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .content:has(#New-Landing-layout) {
            background: #f1f4f9 !important;
            height: 50vh !important;
            max-height: calc(100vh - 90px) !important;
        }

        /* ul#horizontal-processbar { */
        /* margin-top: 45px !important; */
        /* padding: 0px !important; */
        /* } */
        /* #Process-stepper {
    display: block !important;
    flex: none !important;
    margin-left: 32.3333% !important;
    width: 44.6667% !important;
    /* max-width: 82.6667% !important; 
    background: #fff;
    max-width: 68% !important;
    position: relative;
    z-index: 10;
    top: 3px;
    overflow-x: auto;
    overflow-y: hidden;
} */
        /* 
#horizontal-processbar {
    width: max-content;
    min-width: 100%;
} */
        .deep-search-highlight {
            animation: highlightFlash 1s ease-in-out 3;
            background: #fff3cd;
            border: 1px solid #ffc107;
        }

        @keyframes highlightFlash {
            0% {
                background: #fff3cd;
            }

            50% {
                background: #ffe69c;
            }

            100% {
                background: #fff3cd;
            }
        }

        .custom-header {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* button style */
        .hdr-btn {
            padding: 6px 14px;
            background: #4e86c7;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            white-space: nowrap;
            color: white;
        }

        .hdr-btn.active {
            background: #4e86c7;
            color: black;
        }

        /* fix select alignment */
        .inbox-user-switcher {
            display: flex;
            align-items: center;
        }

        /* dropdown */
        .hdr-dropdown {
            position: relative;
            width: 180px;
        }

        .dropdown-menu {
            position: absolute;
            top: 110%;
            left: 0;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
            display: none;
            min-width: 180px;
            z-index: 9999;
        }

        .dropdown-item {
            padding: 8px 12px;
            cursor: pointer;
        }

        .dropdown-item:hover {
            background: #f3f6fb;
        }

        /* show dropdown */
        .hdr-dropdown.open .dropdown-menu {
            display: block;
        }

        .dots-menu {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            padding: 0;
            border-radius: 50%;
        }

        .dots-menu .material-icons {
            font-size: 20px;
        }

        .dropdown-submenu {
            position: relative;
        }

        .dropdown-submenu .submenu {
            display: none;
            position: absolute;
            left: 100%;
            top: 0;
            min-width: 180px;
            background: #fff;
            border-radius: 6px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        }

        .dropdown-submenu:hover .submenu {
            display: block;
        }

        .submenu-toggle {
            display: flex;
            justify-content: space-between;
        }

        .accordion-header {
            padding: 8px 12px;
            background: #f3f6fb;
            cursor: pointer;
            border-bottom: 1px solid #ddd;
            font-weight: 500;
            display: flex;
            justify-content: space-between;
        }

        .accordion-body {
            padding: 8px 12px;
            background: #fff;
        }

        .task-item {
            padding: 4px 0;
            font-size: 13px;
            border-bottom: 1px dashed #eee;
        }

        .search-highlight {
            border: 2px solid #90ee90;
            /* light green */
            border-radius: 6px;
            background: #f0fff0;
        }

        /* Target the actual header element */
        .user-main {
            position: sticky !important;
            top: 0;
            z-index: 1050;
            /* Stays above task cards */
            background: white;
        }

        .submenu-toggle {
            pointer-events: none;
            /* ❌ disable click */
            cursor: default;
            /* normal cursor */
            font-weight: 600;
            /* looks like header */
        }

        .stepper-horizontal li:not(:first-child)::before {
            position: relative;
            -webkit-box-flex: 1;
            flex: 1 1 0%;
            height: 1px;
            margin: 0.5rem 0px 0px;
            content: "";
            background-color: rgba(0, 0, 0, 0.1);
            min-width: 40px;
        }


        /* v2css */
        .v2-accordion-item {
            border-bottom: 0 !important;
        }

        .v2-accordion-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px 16px;
            cursor: pointer;
            background: #fff;
        }

        .v2-accordion-header.active {
            background: #eff6ff;
        }

        .v2-left {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .v2-arrow {
            font-family: ''Material Icons'';
            font-size: 18px;
        }

        .v2-title {
            font-size: 13px;
            font-weight: 800;
        }

        .v2-accordion-body {
            display: none;
            background: #fff;
        }
.empty-state {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 40px;
    color: #888;
}
        .v2-accordion-body.show {
            display: block;
        }

        .v2-pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
            padding: 12px;
        }

        .page-btn {
            border: none;
            background: #2563eb;
            color: #fff;
            padding: 4px 10px;
            border-radius: 4px;
            cursor: pointer;
        }

        .v2-accordion-item {
            border-bottom: 0 !important;
               /* height: calc(100vh - 500px);*/
        }

        .v2-accordion-header {
            /*! position: sticky; */
            top: 0;
            z-index: 10;

            background: #f5f5f526;

            display: flex;
            justify-content: space-between;
            align-items: center;

            padding: 8px 16px;

            cursor: pointer;

            border-bottom: 1px solid #dbe4f0;
            /*! margin-bottom: 0; */
        }

        .v2-accordion-header.active {
            background: #f4f5fb;
        }

        .v2-accordion-body {
            display: none;
        }

        .v2-accordion-body.show {
            display: block;
        }

        .v2-scroll-body {

            max-height: calc(100vh - 148px);

            overflow-y: auto;

            /*! background: whh; */
        }

        .v2-scroll-body[data-section="people"],
        .v2-scroll-body[data-section="groups"] {
            max-height: 240px;
        }

        #body_Container {
            display: flex;
            flex-direction: column;
            min-height: 0;
        }

        #ProcessFlow_New-container,
        #ProcessFlow_Content,
        #tickets,
        #InboxAccordion {
            display: flex;
            flex-direction: column;
            flex: 1;
            min-height: 0;
            background: #f8f8ff;
        }

        #InboxAccordion {
            flex: 1;
            overflow-y: auto;
        }

        #Tickets_details_view {
            display: flex;
            flex-direction: column;
            overflow: hidden;
            max-height: 90vh;
            position: relative;
        }

        .directory-chat-panel {
            position: absolute;
            inset: 0;
            z-index: 20;
            display: flex;
            flex-direction: column;
            background: #f8fbff;
        }

        .directory-chat-panel.d-none {
            display: none !important;
        }

        #process_centerpanel {
            width: 100%;
            height: 100%;
            margin-bottom: 0;
            border: 0;
            background: transparent;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            min-height: 0;
        }

        .chat-shell {
            height: 100%;
            min-height: 0;
            display: flex;
            flex-direction: column;
            background: #fff;
            box-shadow: 7px 7px 32px 5px #ccc !important;
        }

        .chat-shell-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 5px 18px;
            background: #fff;
            border-bottom: 1px solid #dbe4f0;
            background: ghostwhite;
        }

        .chat-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 0;
        }

        .chat-avatar {
            width: 26px;
            height: 26px;
            border-radius: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #a00;
            font-weight: 700;
            font-size: 13px;
            background: #fedddd;
            flex: none;
            /*! box-shadow: 0 10px 18px rgba(37, 99, 235, 0.14); */
        }

        .chat-avatar.chat-avatar-group {
            background: #0f766e;
            box-shadow: 0 10px 18px rgba(15, 118, 110, 0.12);
        }

        .chat-name {
            font-size: 15px;
            font-weight: 700;
            line-height: 1.2;
            color: #1f2937;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            text-transform: capitalize;
        }

        .chat-subline {
            margin-top: 4px;
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            font-size: 12px;
            color: #64748b;
        }

        .chat-chip {
            display: inline-flex;
            align-items: center;
            padding: 4px 9px;
            border-radius: 999px;
            background: #eef4ff;
            color: #2563eb;
            font-size: 11px;
            font-weight: 600;
            white-space: nowrap;
        }

        .chat-actions {
            display: flex;
            align-items: center;
            gap: 8px;
            flex: none;
        }

        .chat-icon-btn {
            width: 36px;
            height: 36px;
            border: none;
            border-radius: 10px;
            background: #f3f7fb;
            color: #475569;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: default;
        }

        .chat-feed {
            flex: 1;
            min-height: 0;
            overflow-y: auto;
            padding: 18px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .chat-empty {
            flex: 1;
            min-height: 220px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: #64748b;
        }

        .chat-empty-card {
            background: #fff;
            border: 1px solid #dbe4f0;
            border-radius: 18px;
            padding: 22px 24px;
            box-shadow: 0 14px 30px rgba(15, 23, 42, 0.06);
            max-width: 360px;
        }

        .chat-empty-title {
            margin-top: 12px;
            font-size: 16px;
            font-weight: 700;
            color: #1f2937;
        }

        .chat-empty-meta {
            margin-top: 8px;
            font-size: 13px;
            line-height: 1.5;
            color: #64748b;
        }

        .chat-message {
            display: flex;
            align-items: flex-end;
            gap: 8px;
            max-width: 50%;
        }

        .chat-message.self {
            margin-left: auto;
            flex-direction: row-reverse;
            /*! width: 120%; */
            /*! white-space: nowrap; */
        }

        .chat-avatar-sm {
            width: 32px;
            height: 32px;
            border-radius: 50px;
            background: #000;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 700;
            flex: none;
        }

          /*.chat-bubble {
            padding: 8px 22px;
            border-radius: 18px;
            background: #f0f0f0;
            border: none;
            box-shadow: none;
            color: #1f2937;
            line-height: 1.4;
            white-space: pre-wrap;
            font-size: 14px;
        }  */

.chat-bubble {
            padding: 8px 22px;
            
            background: #f0f0f0;
            border: none;
            box-shadow: none;
            color: #1f2937;
            line-height: 1.4;
           

       
    border-radius: 6px;
    font-weight: 600;
    white-space: normal;
    font-size: 13px;
        }

        .chat-message.self .chat-bubble {
            background: #eaedf1;
            border-color: #0078d4;
            color: #121212;
            border-radius: 6px;
            font-weight: 600;
            /*! width: 100px; */
            /*! max-height: 130px; */
            white-space: normal;
            font-size: 13px;
        }

        .chat-message-meta {
            margin-top: 2px;
            display: flex;
            justify-content: space-between;
            gap: 4px;
            font-size: 10px;
            color: #64748b;
        }

        .chat-message.self .chat-message-meta {
            color: #7e7e7e;
            font-size: 11px;
        }

        .chat-composer {
            padding: 14px 16px;
            background: #fff;
            /*! border-top: 1px solid #dbe4f0; */
            display: flex;
            gap: 10px;
            align-items: flex-end;
            margin-bottom: 0 !important;
        }

        .chat-input-wrap {
            flex: 1;
            position: relative;
        }

        .chat-input {
            width: 100%;
            min-height: 46px;
            max-height: 120px;
            resize: none;
            border: 1px solid #d0d0d0;
            border-radius: 6px;
            padding: 12px 14px;
            outline: none;
            font-size: 14px;
            line-height: 1.4;
            background: #fff;
            color: #1f2937;
            border-bottom: 2px solid #303a6978;
            font-weight: 600;
        }

        .chat-input:focus {
            border-color: #93c5fd;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.12);
            background: #fff;
        }

        .chat-send {
            width: 44px;
            height: 44px;
            border: none;
            border-radius: 14px;
            background: #000;
            color: #fff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 10px 18px rgba(37, 99, 235, 0.18);
        }

        .chat-send:disabled {
            background: #94a3b8;
            box-shadow: none;
        }

        .directory-row {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 4px 40px;
            cursor: pointer;
            border-bottom: 1px solid #eef2f7;
            background: white;
            transition: background 0.15s ease, border-color 0.15s ease;
        }

        .directory-row:hover {
            background: #f8fbff;
        }

        .directory-row.selected {
            background: #eafff4;
            border-left: 3px solid #25bdeb;
            padding: 4px 40px;
        }

        .directory-row.group-member-row {
            padding-left: 44px;
            background: #fbfdff;
        }

        .directory-row.group-member-row.selected {
            padding-left: 41px;
        }

        .group-loading,
        .group-empty {
            padding: 12px 18px 12px 72px;
            font-size: 13px;
            color: #64748b;
            background: #fbfdff;
            border-bottom: 1px solid #eef2f7;
            /*! font-weight: 600; */
        }

        .directory-avatar {
            width: 24px;
            height: 24px;
            border-radius: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #dbeafe;
            color: #1d4ed8;
            font-weight: 800;
            flex: none;
            box-shadow: 0 8px 14px rgba(59, 130, 246, 0.08);
            font-size: 10px;
            /*! padding: 3px; */
        }

        .directory-avatar.directory-avatar-group {
            background: #dcfce7;
            color: #166534;
            box-shadow: 0 8px 14px rgba(22, 101, 52, 0.08);
        }

        .directory-main {
            flex: 1;
            min-width: 0;
        }

        .directory-name {
            font-size: 13px;
            font-weight: 700;
            color: #0f172a;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .directory-meta {
            margin-top: 5px;
            font-size: 12px;
            color: #64748b;
            line-height: 1.45;
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            font-weight: 600;
        }

        .directory-badges {
            margin-top: 8px;
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .directory-badge {
            display: inline-flex;
            align-items: center;
            padding: 3px 8px;
            border-radius: 999px;
            background: #eef2ff;
            color: #4f46e5;
            font-size: 11px;
            font-weight: 600;
            white-space: nowrap;
        }

        .directory-cta {
            color: #94a3b8;
            font-size: 18px;
            margin-top: 8px;
            flex: none;
        }


/*white grey------------------------------------------------------------------------------------------------------------------------------*/

.v2-title {
	font-size: 13px;
	font-weight: 800;
}
.inbox-count {
	font-weight: 800;
	color: #676767;
}
.v2-scroll-body {
	max-height: calc(100vh - 148px);
	overflow-y: auto;
	background: #fff;
}
.v2-accordion-header.active {
	background: #f4f5fb;
}
.v2-accordion-item {
	border-bottom: 0 !important;
	/* height: calc(100vh - 500px);/*
}

.directory-avatar {
	width: 24px;
	height: 24px;
	font-weight: 800;
	font-size: 10px;
}
.directory-row {
	align-items: center;
	padding: 4px 40px;
	}
.directory-meta {
	font-weight: 600;
}
.group-empty {
	color: #ff0000a8;
	font-weight: 600;
}
.directory-row.selected {
	background: #eafff4;
	border-left: 3px solid #eafff4;
	padding: 4px 40px;
}
.directory-row.selected .directory-name {
	color: #0d700d;
}
.directory-row.selected .directory-avatar {
	background: #0a984e30;
/*	color: green !important;*/
}
.chat-shell-header {

	padding: 5px 18px;

}
.chat-avatar {
	width: 26px;
	height: 26px;
	border-radius: 50px;
	font-weight: 800;
	font-size: 13px;
	background: #000;
	 box-shadow: 0 ;}

.chat-name {
	font-size: 15px;
	font-weight: 700;
	text-transform: capitalize;
}
.chat-send .material-icons.material-icons-style.material-icons-2 {
	color: #fff !important;
}


/* dark
.v2-scroll-body .directory-row:nth-child(12n+1) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+1) .user {
  background: red !important; 
  color: white !important;
}
.v2-scroll-body .directory-row:nth-child(12n+2) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+2) .user {
  background: #c956d1 !important; 
  color: white !important;
}
.v2-scroll-body .directory-row:nth-child(12n+3) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+3) .user {
  background: orange; 
  color: white !important;
}
.v2-scroll-body .directory-row:nth-child(12n+4) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+4) .user {
  background: green; 
  color: white !important;
}
.v2-scroll-body .directory-row:nth-child(12n+5) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+5) .user {
  background: purple; 
  color: white !important;
}
.v2-scroll-body .directory-row:nth-child(12n+6) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+6) .user {
  background: coral; 
  color: white !important;
}
.v2-scroll-body .directory-row:nth-child(12n+7) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+7) .user {
  background: yellowgreen; 
  color: white !important;
}
.v2-scroll-body .directory-row:nth-child(12n+8) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+8) .user {
  background: turquoise; 
  color: white !important;
}
.v2-scroll-body .directory-row:nth-child(12n+9) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+9) .user {
  background: darkolivegreen; 
  color: white !important;
}
.v2-scroll-body .directory-row:nth-child(12n+10) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+10) .user {
  background: darkviolet; color: white !important;
}
.v2-scroll-body .directory-row:nth-child(12n+11) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+11) .user {
  background: lightcoral; 
  color: white !important;
}
.v2-scroll-body .directory-row:nth-child(12n+12) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+12) .user {
  background: lightslategrey; 
  color: white !important;
}
*/


.v2-scroll-body .directory-row:nth-child(12n+1) .directory-avatar ,.v2-scroll-body .container.listrow:nth-child(12n+1) .user {
  background: #ff000021 !important; 
  color: #b11414;
}
.v2-scroll-body .directory-row:nth-child(12n+2) .directory-avatar ,.v2-scroll-body .container.listrow:nth-child(12n+2) .user {
  background: #c956d136 !important; 
  color: #801488 !important;
}
.v2-scroll-body .directory-row:nth-child(12n+3) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+3) .user {
  background: #ffa50045; 
  color: #8e6416 !important;
}
.v2-scroll-body .directory-row:nth-child(12n+4) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+4) .user {
  background: #0080001c; 
  color: green !important;
}
.v2-scroll-body .directory-row:nth-child(12n+5) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+5) .user {
  background: #80008029; 
  color: #800080 !important;
}
.v2-scroll-body .directory-row:nth-child(12n+6) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+6) .user {
  background: #ff7f5036; 
  color: #ae390e !important;
}
.v2-scroll-body .directory-row:nth-child(12n+7) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+7) .user {
  background: #9acd3259; 
  color: #4f6f0d !important;
}
.v2-scroll-body .directory-row:nth-child(12n+8) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+8) .user {
  background: #40e0d03d; 
  color: #128175 !important;
}
.v2-scroll-body .directory-row:nth-child(12n+9) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+9) .user {
  background: #556b2f2e; 
  color: #364b11;
}
.v2-scroll-body .directory-row:nth-child(12n+10) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+10) .user {
  background: #9400d31c; color: #5d1a5d;
}
.v2-scroll-body .directory-row:nth-child(12n+11) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+11) .user {
  background: #f080803b; 
  color: #b21111 !important;
}
.v2-scroll-body .directory-row:nth-child(12n+12) .directory-avatar,.v2-scroll-body .container.listrow:nth-child(12n+12) .user {
  background: #77889940; 
  color: #294969 !important;
}

/*icon*/

.v2-scroll-body .container.listrow:nth-child(12n+1) .user span.material-icons {
  color: #b11414 !important;
}
.v2-scroll-body .container.listrow:nth-child(12n+2) .user span.material-icons { 
  color: #801488 !important;
}
.v2-scroll-body .container.listrow:nth-child(12n+3) .user span.material-icons {
  color: #8e6416 !important;
}
.v2-scroll-body .container.listrow:nth-child(12n+4) .user span.material-icons {
  color: green !important;
}
.v2-scroll-body .container.listrow:nth-child(12n+5) .user span.material-icons { 
  color: #800080 !important;
}
.v2-scroll-body .container.listrow:nth-child(12n+6) .user span.material-icons { 
  color: #ae390e !important;
}
.v2-scroll-body .container.listrow:nth-child(12n+7) .user span.material-icons {
  color: #4f6f0d !important;
}
.v2-scroll-body .container.listrow:nth-child(12n+8) .user span.material-icons { 
  color: #128175 !important;
}
.v2-scroll-body .container.listrow:nth-child(12n+9) .user span.material-icons {
  color: #364b11 !important;
}
.v2-scroll-body .container.listrow:nth-child(12n+10) .user span.material-icons {
    color: #5d1a5d !important;
}
.v2-scroll-body .container.listrow:nth-child(12n+11) .user span.material-icons {
  color: #b21111 !important;
}
.v2-scroll-body .container.listrow:nth-child(12n+12) .user span.material-icons { 
  color: #294969 !important;
}





.v2-scroll-body[data-section="people"] {
	max-height: calc(100vh - 283px);
}
.v2-scroll-body[data-section="groups"] {
	max-height: calc(100vh - 285px);
}
.v2-scroll-body[data-section="notifications"] {
	max-height: calc(100vh - 188px);
}
.v2-scroll-body[data-section="completed"] {
	max-height: calc(100vh - 284px);
}
   
.Title-Section {
	width: 100%;
}
.ticket-view h4 {
	font-size: 17px !important;
	font-weight: 700 !important;
	background: #f4f5fb !important;
}
.ticket-view .fw-semibold {
	font-size: 13px !important;
	background: #f4f5fb !important;
	border-bottom: 1px solid #e7e9f5;
}

#directoryChatPanel .chat-avatar {
	background: antiquewhite !important;
}
#directoryChatPanel .chat-avatar-sm {
	background: #90ee905e;
	color: #297129;
	font-weight: bolder !important;
}
.listrow.completed-row:hover {
	background-color: #07fea112 !important;
}
#ProcessFlow_New-container .material-icons {
	font-size: 16px !important;
}
.directory-meta {
	margin-top: 0 !important;
}

#PROFLOW_Left .card-body {
	padding: 0 !important;
}
#InboxAccordion {
	margin-bottom: 30px;
}
#Tickets_details_view {
	overflow-y: scroll !important;
}
.ticket-view {
	background: transparent !important;
	box-shadow: none !important;
}
.history-body .history-item:last-child {
	border: 0 !important;
}


/*stepper*/

#Process-stepper {
	 margin-left: 0% !important;
	width: 68% !important;
	top: 42px !important;
    position: absolute !important;
        margin-left:32.3333% !important;

}
ul.stepper li.pending a .label {
	font-weight: 600;
}');
>>

<<
INSERT INTO sect4 (sect4id, htmlsectionsid, sect4row, filename, filetype, css_js_src) VALUES(1592770000003, 1592770000000, 2, 'taskslst_inbox', 'Js', '/* Task planner â€" consolidated script with taskplanner icon, balloon tooltip, and action checks */
(function () {
  debugger;
  const plannerStyles = `
  /* core */
  #plan-popup-root { font-family: Inter, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial; padding: 9px; box-sizing: border-box; max-height: 110vh; color:#0f1724; }
  .plan-grid{ display:flex; gap:0px; align-items:flex-start; }
  .left { width: 27%; background: #fff; border-radius:14px; padding:5px; box-shadow: 0 10px 30px rgba(2,6,23,0.04); min-height:420px; max-height: 72vh; overflow:auto; }
  .right { width: 75%; background: linear-gradient(180deg,#f8fbff,#ffffff); border-radius:14px; padding:5px; box-shadow: 0 10px 30px rgba(2,6,23,0.03); min-height:420px;overflow:auto; }
  .planner-controls{ display:flex; justify-content:space-between; align-items:center; gap:8px; }
  .planner-controls h3{ margin:0; font-size:18px; font-weight:700; color:#072a6b; display:flex; align-items:center; gap:8px; }
  .small-muted{ font-size:13px; color:#475569; opacity:0.95; }
  /* chips / calendar */
  .cal-chip { padding:3px 6px; border-radius:10px; background:linear-gradient(180deg,#eef6ff,#ffffff); border:1px solid rgba(11,105,255,0.08); font-size:12px; font-weight:600; color:#05264a; cursor:grab; box-shadow:0 6px 18px rgba(11,105,255,0.03); }
  .cal-chip.dragging{ opacity:0.6; transform:scale(.995); }
  .calendar-header { display:flex; justify-content:space-between; align-items:center; gap:12px;}
  .day-view-stacked { margin-top:5.calendar-headerpx; display:grid;grid-template-columns: repeat(4, 192px); gap:12px; max-height:76vh; overflow:auto; }
  .day-card { background:linear-gradient(180deg,#fff,#fbfdff); border-radius:12px; padding:12px; border:1px solid rgba(7,42,72,0.04); box-shadow:0 8px 24px rgba(2,6,23,0.03); }
  .day-card .day-header{ display:flex; justify-content:space-between; align-items:center; gap:10px; cursor:pointer; }
  .day-tasks { margin-top:8px; display:flex; flex-direction:column; gap:8px; max-height:220px; overflow:auto; padding:6px; }
  /* planner buttons */
  .btn-plan { padding:5px 8px; border-radius:10px; border:0; background:#0b69ff; color:#fff; cursor:pointer; font-weight:600; }
  .btn-ghost {
    padding: 5px 8px;
    border-radius: 10px;
    border: 1px solid rgba(2,6,23,0.06);
    color: black;
    cursor: pointer;
    font-weight: 600;
}
.cal-chip-id {
  font-weight: 600;
  font-size: 12px;
  margin-bottom: 2px;
  line-height: 1.2;
}
.cal-chip-name {
  font-size: 11px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  line-height: 1.2;
  display:none;
}
.status-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  display: inline-block;
}
.status-pending {
  background-color: #dc3545; /* red */
}
.status-accepted {
  background-color: #198754; /* green */
}
.status-forwarded {
  background-color: #ffc107; /* yellow */
}
.status-unknown {
  background-color: #6c757d; /* gray */
}
  /* accordion / task list */
  #plan-popup-root .task-accordion { width:100%; }
  #plan-popup-root .task-accordion .accordion-item { border:0; }
  #plan-popup-root .task-accordion .accordion-button {
    padding: 5px;
    display:flex;
    align-items:center;
    gap:10px;
    border-radius:10px;
    background: linear-gradient(180deg,#fff,#fbfdff);
    border: 1px solid rgba(11,105,255,0.06);
    box-shadow: 0 6px 18px rgba(11,105,255,0.04);
    color: #05264a;
    font-weight:700;
  }
  #plan-popup-root .task-accordion .accordion-button:not(.collapsed) {
    background: linear-gradient(180deg,#eef6ff,#ffffff);
  }
  #plan-popup-root .task-accordion .accordion-button > div {
    min-width: 0; /* allows children to shrink inside flex column */
}
#plan-popup-root .task-accordion .title {
    display: block;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    font-size: 13px;
    width:170px;
    font-weight: 600;
}
  #plan-popup-root .task-accordion .chev {
    width:22px;
    height:22px;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    transition: transform .28s ease;
    flex-shrink:0;
    color:#0b69ff;
  }
  #plan-popup-root .task-accordion .accordion-button[aria-expanded="true"] .chev { transform: rotate(180deg); }
  #plan-popup-root .task-accordion .accordion-collapse .card-body {
    padding: 10px 12px;
    font-size:13px;
    color:#334155;
    line-height:1.28;
  }
  /* drag handle in header (distinct, draggable) */
  #plan-popup-root .task-accordion .drag-handle {
    width:20px;
    height:36px;
    min-width:20px;
    display:flex;
    align-items:center;
    justify-content:center;
    border-radius:8px;
    cursor:grab;
    user-select:none;
    margin-right:8px;
    color:#0b69ff;
  }
  #plan-popup-root .task-accordion .drag-handle:active { cursor:grabbing; }
  /* small responsive tweaks */
  @media (max-width: 900px){
    .plan-grid{ flex-direction:column; }
    .left{ width:100%; }
    .right{ width:100%; }
    .day-view-stacked { grid-template-columns: repeat(2, 1fr); }
  }
  .tab-header .btn-ghost {
    border-bottom: 2px solid transparent;
    font-weight: 600;
    color: #333;
    background: none;
  }
  
  .tab-header .btn-ghost.tab-active {
    border-bottom: 2px solid #0b69ff;
    color: #0b69ff;
  }
  /* move/copy popup */
.mc-popup {
  position: fixed;
  z-index: 99999;
  background: #ffffff;
  border: 1px solid rgba(2,6,23,0.08);
  padding: 6px;
  border-radius: 8px;
  box-shadow: 0 8px 30px rgba(2,6,23,0.12);
  display: flex;
  gap: 6px;
  align-items: center;
  font-size: 13px;
}
.mc-popup button {
  padding: 6px 8px;
  border-radius: 6px;
  border: 0;
  cursor: pointer;
  font-weight: 600;
}
.mc-popup button.btn-move { background: #0b69ff; color: #fff; }
.mc-popup button.btn-copy { background: #10b981; color: #fff; }
.mc-popup button.btn-cancel { background: transparent; border: 1px solid #e5e7eb; color: #111827; }
 /* Extra Large screens (1200px+) */
@media (min-width: 1200px) {
  .day-view-stacked {
    grid-template-columns: repeat(4, 1fr);
  }
}
/* Large screens (992px - 1199px) */
@media (max-width: 1199px) {
  .day-view-stacked {
    grid-template-columns: repeat(4, 1fr);
  }
}
/* Medium screens (768px - 991px) */
@media (max-width: 991px) {
  .day-view-stacked {
    grid-template-columns: repeat(2, 1fr);
  }
}
/* Small screens (mobile < 768px) */
@media (max-width: 767px) {
  .day-view-stacked {
    grid-template-columns: repeat(1, 1fr);
  }
}
 `;
  
  if (!document.querySelector(''#plan-popup-styles'')) {
    const styleTag = document.createElement(''style'');
    styleTag.setAttribute(''id'', ''plan-popup-styles'');
    styleTag.innerHTML = plannerStyles;
    document.head.appendChild(styleTag);
  }
  /* ---------- helper utilities ---------- */
  function escapeHtml(s) {
    if (s === null || s === undefined) return '''';
    return String(s).replace(/[&<>"'']/g, m => ({
      ''&'': ''&'',
      ''<'': ''&lt;'',
      ''>'': ''&gt;'',
      ''"'': ''"'',
      "''": ''&#39;''
    })[m]);
  }
  function formatDateShort(d) {
    try {
      const dt = new Date(d);
      if (!isNaN(dt.getTime())) return `${dt.getFullYear()}-${String(dt.getMonth() + 1).padStart(2, ''0'')}-${String(dt.getDate()).padStart(2, ''0'')}`;
    } catch (e) {}
    return '''';
  }
  function getRandomColor() {
    const colors = ["#e0dbfe", "#dbeafe", "#dcfce7", "#fef9c3", "#fee2e2", "#fce7f3"];
    return colors[Math.floor(Math.random() * colors.length)];
  }
  function isMeaningful(s) {
    if (s === null || s === undefined) return false;
    const t = String(s).trim();
    if (!t) return false;
    const lowered = t.toLowerCase();
    if (lowered === ''null'' || lowered === ''[null]'') return false;
    return true;
  }
  /* ---------- bootstrap / iview integration ---------- */
  window.AxAfterIviewLoad = function () {
    const toolbar = document.querySelector(".toolbarRightMenu");
    if (!toolbar || !toolbar.parentNode) {
      console.warn("Toolbar not found - can''t insert buttons");
      return;
    }
    // remove previous if present
    const existingPlansBtn = document.querySelector(".btn-plan-plans");
    if (existingPlansBtn) existingPlansBtn.remove();
    const existingPunchBtn = document.querySelector(".punch-btn");
    if (existingPunchBtn) existingPunchBtn.remove();
    const plansBtn = document.createElement("button");
    plansBtn.innerText = "SCHEDULE";
    plansBtn.className = "btn btn-primary p-3 punch-btn";
    plansBtn.style.marginRight = "8px";
    plansBtn.addEventListener("click", plansPopupHandler);
    const punchBtn = document.createElement("button");
    punchBtn.innerText = "PUNCH IN/OUT";
    punchBtn.className = "btn btn-primary p-3 punch-btn";
    punchBtn.addEventListener("click", popupHandler);
    if (toolbar.nextElementSibling) {
      toolbar.parentNode.insertBefore(plansBtn, toolbar.nextElementSibling);
      toolbar.parentNode.insertBefore(punchBtn, toolbar.nextElementSibling);
    } else {
      toolbar.parentNode.appendChild(plansBtn);
      toolbar.parentNode.appendChild(punchBtn);
    }
    const el = document.querySelector("#iconsNewOption");
    if (el) el.classList.toggle("d-none");
  };
  function popupHandler(e) {
    if (e && e.preventDefault) e.preventDefault();
    $(''#btn_btn17'').click();
  }
  // window.plansPopupHandler = function (e) {
  //   if (e && e.preventDefault) e.preventDefault();
  //   $(''#btn_btn17'').click();
  //   const pfContainer = document.getElementById("pf_content_container");
  
  //   if (pfContainer) pfContainer.classList.add("d-none");
  //   waitForModalElement(50, 3500).then(modalEl => {
  //     const modalBody = modalEl.querySelector(''.modal-body'') || modalEl;
  //     try {
        
  //       modalBody.innerHTML = '''';
  //     } catch (err) {
  //       console.warn(''clear failed'', err);
  //     }
  //     window._tm_lastSelected = null;
  //     injectPlannerUI(modalBody, modalEl);
  //     // prepare footer submit button
  //     // const footer = modalEl.querySelector(''.modal-footer'');
  //     // if (footer) {
  //     //   footer.classList.remove(''d-none'');
  //     //   const cancelBtn = footer.querySelector(''.modal-cancel'');
  //     //   const okBtn = footer.querySelector(''.modal-ok'');
  //     //   if (cancelBtn) cancelBtn.style.display = ''none'';
  //     //   if (okBtn) okBtn.style.display = ''none'';
  //     //   let submitBtn = footer.querySelector(''#plannerSubmitBtn'');
  //     //   if (!submitBtn) {
  //     //     submitBtn = document.createElement(''button'');
  //     //     submitBtn.type = "button";
  //     //     submitBtn.id = "plannerSubmitBtn";
  //     //     submitBtn.className = "btn btn-primary";
  //     //     submitBtn.textContent = "Submit";
  //     //     submitBtn.addEventListener("click", () => {
  //     //       const dayCards = document.querySelectorAll(''.day-view-stacked .day-card'');
  //     //       const jsonData = [];
  //     //       dayCards.forEach(card => {
  //     //         const tasks = card.querySelectorAll(''.cal-chip'');
  //     //         if (tasks.length === 0) return;
  //     //         const dateStr = card.getAttribute(''data-date'');
  //     //         const [yyyy, mm, dd] = dateStr.split(''-'');
  //     //         const formattedDate = `${dd}/${mm}/${yyyy}`;
  //     //         tasks.forEach(task => {
  //     //           const taskId = task.getAttribute(''data-taskid'');
  //     //           if (taskId) jsonData.push({ newdate: formattedDate, taskid: taskId });
  //     //         });
  //     //       });
  //     //       if (jsonData.length === 0) { parent.showAlertDialog(''warning'', "No tasks to save!"); return; }
  //     //       parent.AxSetValue("tasku", "SavejsonData", "1", "0", JSON.stringify(jsonData));
  //     //       parent.AxSetValue("tasku", "taskid", "1", "0", jsonData[0].taskid);
  //     //       parent.AxSetValue("tasku", "newdate", "1", "0", jsonData[0].newdate);
  //     //       parent.AxSubmitData(''tasku'', ''0'');
  //     //       parent.showAlertDialog(''success'', "Task saved successfully!");
  //     //     });
  //     //     footer.appendChild(submitBtn);
  //     //   }
  //     // }
  //   }).catch(() => {
  //     injectPlannerUI(document.body, null);
  //   });
  // }
  window.plansPopupHandler = function (e) {
    if (e && e.preventDefault) e.preventDefault();
  
    const pfContainer = document.getElementById("pf_content_container");
    if (pfContainer) pfContainer.classList.add("d-none");
  
    const modalEl = document.getElementById("filterModal");
    if (!modalEl) {
      console.error("filterModal not found");
      return;
    }
  
    // ✅ Show modal directly
    $(''#filterModal'').modal({
      backdrop: "static",
      keyboard: false
    });
    $(''#filterModal'').modal(''show'');
  
    // ✅ Inject planner AFTER modal is visible
    setTimeout(() => {
      const modalBody =
        modalEl.querySelector(".modal-body") || modalEl;
  
      modalBody.innerHTML = "";
      modalBody.style.overflow="unset"
      window._tm_lastSelected = null;
  
    injectPlannerUI(modalBody, modalEl);
    }, 120);
  
    // ✅ Restore container on close
    $(modalEl)
      .off("hidden.bs.modal.restore")
      .on("hidden.bs.modal.restore", function () {
        if (pfContainer) pfContainer.classList.remove("d-none");
      });

      setTimeout(() => {
        const modal = document.getElementById("filterModal");
        if (!modal) return;
    
        const header = modal.querySelector(".modal-header");
    
        // ✅ Create header if missing
        if (!header) {
            const modalContent = modal.querySelector(".modal-content");
            const newHeader = document.createElement("div");
            newHeader.className = "modal-header border-0 p-2";
            newHeader.style.backgroundColor = "transparent";
            newHeader.style.width = "max-content";
            newHeader.style.position = "absolute";
            newHeader.style.right = "8px";
            newHeader.style.zIndex ="99999";
            newHeader.style.top = "15px";

            modalContent.prepend(newHeader);
        }
    
        const modalHeader = modal.querySelector(".modal-header");
    
        // ✅ Avoid duplicate button
        if (!modalHeader.querySelector(".custom-close-btn")) {
    
            const closeBtn = document.createElement("button");
            closeBtn.type = "button";
            closeBtn.className = "btn-close custom-close-btn";
            closeBtn.setAttribute("aria-label", "Close");
            closeBtn.style.marginLeft = "auto";
    
            modalHeader.appendChild(closeBtn);
    
            // ✅ Attach click logic
            closeBtn.addEventListener("click", function () {
    
                const iframe = modal.querySelector("#taskFrame");
                const planner = modal.querySelector("#plan-popup-root");
    
                // 🔥 If iframe open → go back to planner
                if (iframe && iframe.style.display === "block") {
                    iframe.style.display = "none";
                    iframe.src = "";
    
                    if (planner) planner.style.display = "block";
    
                    return; // ❌ stop closing modal
                }
    
                // ✅ Otherwise close modal
                if (window.jQuery && $(modal).modal) {
                    $(modal).modal("hide");
                } else {
                    modal.style.display = "none";
                }
            });
        }
    
    }, 150); 
  };
  
  function waitForModalElement(intervalMs = 50, timeoutMs = 3000) {
    return new Promise((resolve, reject) => {
      const start = Date.now();
      const timer = setInterval(() => {
        let el = document.querySelector(''.modal.show'') || document.querySelector(''[role="dialog"].show'');
        if (!el) {
          const c = document.querySelectorAll(''.modal, [role="dialog"]'');
          for (const x of c)
            if (x.querySelector && x.querySelector(''.modal-body'')) {
              el = x;
              break;
            }
        }
        if (el) {
          clearInterval(timer);
          resolve(el);
        }
        if (Date.now() - start > timeoutMs) {
          clearInterval(timer);
          reject(new Error(''modal not found''));
        }
      }, intervalMs);
    });
  }
  function injectPlannerUI(container, modalEl) {
    try {
      const prev = container.querySelector && container.querySelector(''#plan-popup-root'');
      if (prev) prev.remove();
    } catch (e) {}
    const root = document.createElement(''div'');
    root.id = ''plan-popup-root'';
    // main header: add taskplanner icon and balloon icon with tooltip (no subtitle text)
    root.innerHTML = `
  <div class="planner-controls">
    <div style="display:flex;align-items:center;gap:8px;">
      <h3>
        <!-- Task Planner icon (clipboard/calendar) -->
      
          <rect x="8" y="3" width="8" height="2" rx="1" fill="currentColor" />
          <path d="M7 7h10v12a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2V7z" stroke="currentColor" stroke-width="1.2" fill="none"/>
        </svg>
        Task Planner
      </h3>
      <!-- balloon icon: tooltip ''Drag and drop'' -->
      <div style="margin-left:6px;">
        <span id="drag-tooltip-anchor" data-bs-toggle="tooltip" data-bs-placement="top" title="Drag and drop" style="display:inline-flex;align-items:center;justify-content:center;">
        
            <path d="M12 2c1.7 0 3 1.3 3 3 0 2-1 3.5-3 5-2-1.5-3-3-3-5 0-1.7 1.3-3 3-3z" stroke="currentColor" stroke-width="1.2" fill="none"/>
            <path d="M12 10v7" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/>
            <path d="M10 20c1 1 3 1 4 0" stroke="currentColor" stroke-width="1.2" stroke-linecap="round"/>
          </svg>
        </span>
      </div>
    </div>
<div style="display:flex;gap:10px;align-items:center;position:relative;right:230px;" id="userDropdownContainer"></div> 
    <div style="display:flex;gap:10px;align-items:center;">
   
   
    </div>
  </div>
  <div class="plan-grid">
    <div class="left">
      <h4 style="font-size:15px; ">Tasks <span id="task-count" class="small-muted" style="font-weight:600;margin-left:8px;"></span></h4>
      <div id="task-list" aria-live="polite"></div>
    </div>
    <div class="right">
    
  
    <div id="tab-content">
      <div id="calendar-tab" class="tab-pane active">
        <div class="calendar-header">
          <div style="font-weight:600; color:black;font-size:15px;">
            Calendar - <span id="calendar-month-year"></span>
          </div>
          <div style="display:flex; gap:8px; align-items:center;">
           <button id="prev-month" class="btn-ghost">◀</button>
            <button id="next-month" class="btn-ghost">▶</button>
          </div>
        </div>
        <div id="calendar-area"></div>
      </div>
  
      
    </div>
  </div>
  
`;
    if (container.prepend) container.prepend(root);
    else container.appendChild(root);
    root._modalEl = modalEl || null;
    // root.querySelector(''#close-planner'').addEventListener(''click'', () => {
    //   const proflowDiv = document.getElementById("PROFLOW-overalldiv");
    //   if (proflowDiv) {
    //     proflowDiv.classList.remove("d-none");
    //   }
    
    //   closeModalFromRoot(root);
    // });
    
      
    //  root.querySelector(''#refresh-planner'').addEventListener(''click'', () => loadTasksAndRender(root));
    // Bind refresh to reload only calendar (right panel)
    // root.querySelector(''#refresh-planner'').addEventListener(''click'', () => {
    //   try {
    //    ;
    //   } catch (e) {}
    //   loadTasksData(root, () => {
    //     try {
    //       renderCalendarArea(root);
    //     } catch (e) {}
    //     try {
    //      
    //     } catch (e) {}
    //   });
    // });
    root.querySelector(''#prev-month'').addEventListener(''click'', () => changeMonth(-1, root));
    root.querySelector(''#next-month'').addEventListener(''click'', () => changeMonth(1, root));
    // initial state
    root._plannerState = {
      year: (new Date()).getFullYear(),
      month: (new Date()).getMonth(),
      tasks: [],
      assignQueue: {},
      selectedDay: null,
      _loading: true
    };
    if (root._modalEl) {
      try {
        if (window.jQuery && window.jQuery(root._modalEl).on) {
          window.jQuery(root._modalEl).off(''hidden.bs.modal.planClean'').on(''hidden.bs.modal.planClean'', function () {
            try {
              root.remove();
            } catch (e) {}
            window.jQuery(root._modalEl).off(''hidden.bs.modal.planClean'');
          });
        }
      } catch (e) {}
    }
    // initialize bootstrap tooltip for the balloon icon
    setTimeout(() => {
      try {
        const anchor = root.querySelector(''#drag-tooltip-anchor'');
        if (anchor && window.bootstrap && typeof window.bootstrap.Tooltip === ''function'') {
          new bootstrap.Tooltip(anchor);
        }
      } catch (e) {}
    }, 120);
    //setupTabs(root);
    loadTasksAndRender(root);
  }
  function closeModalFromRoot(root) {
    const modalEl = root._modalEl;
    if (!modalEl) {
      try {
        root.remove();
      } catch (e) {};
      return;
    }
    const closeSel = ''[data-bs-dismiss="modal"], [data-dismiss="modal"], .btn-close, .close'';
    const closeBtn = modalEl.querySelector(closeSel);
    if (closeBtn) {
      try {
        closeBtn.click();
        return;
      } catch (e) {}
    }
    try {
      if (window.jQuery && window.jQuery(modalEl).modal) {
        window.jQuery(modalEl).modal(''hide'');
        return;
      }
    } catch (e) {}
    try {
      modalEl.parentNode && modalEl.parentNode.removeChild(modalEl);
    } catch (e) {}
  }
  function changeMonth(delta, root) {
    root._plannerState.month += delta;
    if (root._plannerState.month < 0) {
      root._plannerState.month = 11;
      root._plannerState.year -= 1;
    }
    if (root._plannerState.month > 11) {
      root._plannerState.month = 0;
      root._plannerState.year += 1;
    }
    renderCalendarArea(root);
  }
  /* ---------- load tasks and render ---------- */
  function loadTasksAndRender(root) {
    const username = (window.parent && window.parent.mainUserName) ? window.parent.mainUserName : (window.mainUserName || "");
    const person = username;
    const sqlParams = {
      "person": person,
      "username": username,
      "priority": ''ALL'',
      "showtasks": ''Open'',
      "ptaskid": ''ALL''
    };
    const taskList = root.querySelector(''#task-list'');
    root._plannerState._loading = true;
    if (taskList) taskList.innerHTML = "<div class=''small-muted''>Loading tasks...</div>";
    // $.ajax({
    //   type: "POST",
    //   url: "../aspx/AxPEG.aspx/GetDataFromDataSource",
    //   data: JSON.stringify({ name: "Ds_taskplanner", sqlParams: sqlParams, refreshCache: false }),
    //   contentType: "application/json; charset=utf-8",
    //   dataType: "json",
    //   async: true,
    //   success: function (result) {
    //     let raw = [];
    //     try {
    //       let d = (result && result.d) ? result.d : null;
    //       if (typeof d === ''string'') {
    //         try { d = JSON.parse(d); } catch (e) { try { d = JSON.parse(d.replace(/\\"/g, ''"'').replace(/\\n/g, '''')); } catch (e2) { } }
    //       }
    //       if (d && d.result && Array.isArray(d.result.data) && d.result.data.length > 0) {
    //         d.result.data.forEach(entry => {
    //           if (entry && entry.data_json) {
    //             try { const parsed = JSON.parse(entry.data_json); if (Array.isArray(parsed)) raw = raw.concat(parsed); } catch (e) { console.warn(''failed parse entry.data_json'', e); }
    //           } else if (Array.isArray(entry)) raw = raw.concat(entry);
    //           else if (entry && entry.data) raw = raw.concat(entry.data);
    //         });
    //       } else if (Array.isArray(d)) raw = d;
    //       else if (d && d.data_json) {
    //         try { const parsed = JSON.parse(d.data_json); if (Array.isArray(parsed)) raw = raw.concat(parsed); } catch (e) { }
    //       } else if (d && d.d && Array.isArray(d.d)) raw = d.d;
    //       else {
    //         try {
    //           const parsed = JSON.parse(JSON.stringify(result));
    //           if (parsed && parsed.d) {
    //             const maybe = typeof parsed.d === ''string'' ? JSON.parse(parsed.d) : parsed.d;
    //             if (Array.isArray(maybe)) raw = maybe;
    //           }
    //         } catch (e) { }
    //       }
    //     } catch (err) { console.error(''Parsing ds result failed'', err); }
    //     root._plannerState.tasks = (raw || []).map((t, idx) => {
    //       const pickDate = t.taskdate || t.duedate || t.scheduledDate || t.scheduled || null;
    //       let scheduledDate = null;
    //       if (pickDate) {
    //         const dt = new Date(String(pickDate));
    //         if (!isNaN(dt.getTime())) scheduledDate = `${dt.getFullYear()}-${String(dt.getMonth() + 1).padStart(2, ''0'')}-${String(dt.getDate()).padStart(2, ''0'')}`;
    //         else {
    //           const m = String(pickDate).match(/(\d{4}-\d{2}-\d{2})/);
    //           if (m) scheduledDate = m[1];
    //         }
    //       }
    //       return {
    //         raw: t,
    //         taskid: t.taskid || t.taskId || t.TaskId || t.id || t.ID || ("t_" + idx),
    //         taskname: t.taskname || t.taskName || t.name || t.title || (t.action_detail ? t.action_detail : "No title"),
    //         customername: t.customername || t.customer || t.client || t.assignedTo || "",
    //         status: t.status || t.Status || "",
    //         priority: t.priority || "",
    //         action_detail: t.action_detail || t.actionDetail || t.ActionDetail || "",
    //         action_message: t.action_message || t.actionMessage || t.ActionMessage || "",
    //         remarks: t.remarks || "",
    //         duedateRaw: t.duedate || null,
    //         duedate: (t.duedate ? formatDateShort(t.duedate) : ""),
    //         scheduledDate: scheduledDate
    //       };
    //     });
    //     // build assignQueue
    //     root._plannerState.assignQueue = {};
    //     root._plannerState.tasks.forEach(task => {
    //       if (task.scheduledDate) {
    //         root._plannerState.assignQueue[task.scheduledDate] = root._plannerState.assignQueue[task.scheduledDate] || [];
    //         root._plannerState.assignQueue[task.scheduledDate].push(task.taskid);
    //       }
    //     });
    //     const countEl = root.querySelector(''#task-count''); if (countEl) countEl.innerText = `${root._plannerState.tasks.length} total`;
    //     root._plannerState._loading = false;
    //     renderTaskList(root);
    //     renderCalendarArea(root);
    //   },
    //   error: function (error) {
    //     console.error("Ds_taskplanner error:", error);
    //     root._plannerState._loading = false;
    //     if (taskList) taskList.innerHTML = "<div class=''small-muted''>Failed to load tasks. Check console.</div>";
    //   }
    // });
    var user_name = (window.parent && window.parent.mainUserName) ?
      window.parent.mainUserName :
      (window.mainUserName || "");
    loadEmployees(root, user_name)
  }
  /* ---------- fetch tasks only (used by Refresh to update right panel only) ---------- */
  function loadTasksData(root, callback) {
    const user_name = (window.parent && window.parent.mainUserName) ? window.parent.mainUserName : (window.mainUserName || "");
    // Build same params used elsewhere
    const params = {
      adsNames: ["TASKPLANNER"],
      refreshCache: false,
      sqlParams: {
        uname: user_name
      },
      keyField: "username",
      keyValue: "",
      props: {
        ADS: true,
        CachePermissions: true,
        getallrecordscount: true,
        pageno: 1,
        pagesize: 1000,
        sorting: [{
          fldname: "employee_code",
          sort_order: "asc"
        }],
        filters: []
      }
    };
    root._plannerState._loading = true;
  
     ;
  
    try {
      parent.GetDataFromAxList(params, function success(response) {
        let parsed = {};
        try {
          parsed = JSON.parse(response);
        } catch (e) {
          parsed = {};
        }
        const employees = parsed ?.result ?.data ?. [0] ?.data || [];
        // Update state (only what''s needed for the calendar)
        root._plannerState.tasks = employees;
        const assignQueue = {};
        const unscheduled = [];
        employees.forEach(task => {
          const date = task.scheduleddate;
          if (date && date !== "null" && date !== "[null]") {
            assignQueue[date] = assignQueue[date] || [];
            assignQueue[date].push(task.taskid);
          } else {
            unscheduled.push(task);
          }
        });
        root._plannerState.assignQueue = assignQueue;
        root._plannerState.unscheduled = unscheduled;
        root._plannerState._loading = false;
        try {
          if (typeof callback === "function") callback();
        } catch (e) {}
        
      }, function error(err) {
        console.error("loadTasksData error", err);
        root._plannerState._loading = false;
        
        if (typeof callback === "function") callback();
      });
    } catch (ex) {
      console.error("Exception while calling GetDataFromAxList - loadTasksData", ex);
      root._plannerState._loading = false;
      
      if (typeof callback === "function") callback();
    }
  }
  function loadEmployees(root, user_name) {
    debugger
    let currentPage = 1;
    let pageSize = 10;
    let sorting = [{
      fldname: "employee_code",
      sort_order: "asc"
    }];
    let filters = [];
    let refreshCache = false;
    const params = {
      adsNames: ["TASKPLANNER"],
      refreshCache: refreshCache,
      sqlParams: {
        uname: user_name,
      },
      keyField: "username",
      keyValue: "",
      props: {
        ADS: true,
        CachePermissions: true,
        getallrecordscount: true,
        pageno: currentPage,
        pagesize: pageSize,
        keyfield: "",
        keyvalue: "",
        sorting: sorting,
        filters: filters,
      },
    };
    try {
      parent.GetDataFromAxList(
        params,
        function success(response) {
          let parsed = JSON.parse(response);
          let employees = parsed ?.result ?.data ?. [0] ?.data || [];
          // Convert to your task structure
          // let raw = employees.map((t, idx) => {
          //   const pickDate = t.taskdate || t.duedate || t.scheduledDate || t.scheduled || null;
          //   let scheduledDate = null;
          //   if (pickDate) {
          //     const dt = new Date(String(pickDate));
          //     if (!isNaN(dt.getTime())) {
          //       scheduledDate = `${dt.getFullYear()}-${String(dt.getMonth() + 1).padStart(2, ''0'')}-${String(dt.getDate()).padStart(2, ''0'')}`;
          //     } else {
          //       const m = String(pickDate).match(/(\d{4}-\d{2}-\d{2})/);
          //       if (m) scheduledDate = m[1];
          //     }
          //   }
          //   return {
          //     raw: t,
          //     taskid: t.taskid || t.taskId || t.TaskId || t.id || t.ID || "t_" + idx,
          //     taskname: t.taskname || t.taskName || t.name || t.title || (t.action_detail ? t.action_detail : "No title"),
          //     customername: t.customername || t.customer || t.client || t.assignedTo || "",
          //     status: t.status || t.Status || "",
          //     priority: t.priority || "",
          //     action_detail: t.action_detail || t.actionDetail || t.ActionDetail || "",
          //     action_message: t.action_message || t.actionMessage || t.ActionMessage || "",
          //     remarks: t.remarks || "",
          //     duedateRaw: t.duedate || null,
          //     duedate: t.duedate ? formatDateShort(t.duedate) : "",
          //     scheduledDate: scheduledDate,
          //   };
          // });
          // Build assignQueue
          root._plannerState.tasks = employees
          const unscheduledTasks = [];
          const assignQueue = {};
          employees.forEach((task) => {
            const date = task.scheduleddate
            if (date && date !== "null" && date !== "[null]") {
              // Assign to that date
              assignQueue[date] = assignQueue[date] || [];
              assignQueue[date].push(task.taskid);
            } else {
              // No date â†'' put in unscheduled list (left panel)
              unscheduledTasks.push(task);
            }
          });
          root._plannerState.assignQueue = assignQueue;
          root._plannerState.unscheduled = unscheduledTasks;
          const countEl = root.querySelector("#task-count");
          if (countEl) countEl.innerText = `(${root._plannerState.unscheduled.length})`;
          root._plannerState._loading = false;
          // âœ… Render updated views
          renderTaskList(root);
          renderCalendarArea(root);
          // Notify that tasks are loaded and UI is ready
window.dispatchEvent(new Event("employeesLoaded"));
          refreshCache = false;
        },
        function error(err) {
          console.error("API error", err);
          root._plannerState._loading = false;
          const taskList = root.querySelector("#task-list");
          if (taskList) taskList.innerHTML = "<div class=''small-muted''>Failed to load tasks. Check console.</div>";
        }
      );
    } catch (ex) {
      console.error("Exception while calling API", ex);
    }
   
  }
  (function () {
    window._tm_lastSelected = null;
    const MAIN_USER =
      parent?.mainUserName ||
      parent?.loggedUserName ||
      parent?.userName ||
      "";
  
    const DS_PARAMS = {
      adsNames: [''DS_TeamMember''],
      refreshCache: false,
      sqlParams: {}
    };
  
    const CSS = `
    .tm-user-dropdown-wrapper{ display:flex; justify-content:center; align-items:center; padding:6px 0; }
    .tm-user-dropdown{ font-size:13px; padding:6px 10px; border-radius:6px; border:1px solid rgba(0,0,0,0.15); background:#fff; }
    `;
    function injectStyles() {
      if (!document.getElementById(''tm-user-dropdown-styles'')) {
        const s = document.createElement(''style'');
        s.id = ''tm-user-dropdown-styles'';
        s.innerHTML = CSS;
        document.head.appendChild(s);
      }
    }
  
    function extractRows(response) {
      try {
        const p = JSON.parse(response);
        return p?.result?.data?.[0]?.data || [];
      } catch { return []; }
    }
  
    function buildDropdown(rows) {
      const wrap = document.createElement("div");
      wrap.className = "tm-user-dropdown-wrapper";
    
      const select = document.createElement("select");
      select.className = "tm-user-dropdown";
    
      // Build options
      rows.forEach(r => {
        const username = r.username || r.user_name || r.UserName || "";
        const opt = document.createElement("option");
    
        opt.value = username;
        opt.textContent = r.displayname || username;
        opt.dataset.raw = JSON.stringify(r);
    
        select.appendChild(opt);
      });
    
      // ---- APPLY FINAL SELECTION ----
      if (window._tm_lastSelected) {
        // Keep user-selected value during refresh
        select.value = window._tm_lastSelected.value;
      } else {
        // Reset only when popup reopens (employeesLoaded fired)
        select.value = MAIN_USER;
        const row = rows.find(r =>
          (r.username || r.user_name || r.UserName || "") === MAIN_USER
        );
        window._tm_lastSelected = { value: MAIN_USER, row };
      }
    
      // Update stored row reference
      const opt = select.options[select.selectedIndex];
      if (opt) {
        window._tm_lastSelected.row = JSON.parse(opt.dataset.raw);
      }
    
      // On change
      select.addEventListener("change", (e) => {
        const opt = e.target.options[e.target.selectedIndex];
        const raw = JSON.parse(opt.dataset.raw);
    
        window._tm_lastSelected = { value: opt.value, row: raw };
    
        window.dispatchEvent(new CustomEvent("teamMemberChanged", {
          detail: { value: opt.value, row: raw }
        }));
      });
    
      wrap.appendChild(select);
      return wrap;
    }
    
  
    function insertDropdown(element) {
      const container = document.getElementById("userDropdownContainer");
      if (!container) return console.warn("Dropdown container missing");
      container.innerHTML = "";
      container.appendChild(element);
    }
  
    function fetchDropdown() {
      injectStyles();
      parent.GetDataFromAxList(
        DS_PARAMS,
        (res) => insertDropdown(buildDropdown(extractRows(res))),
        () => insertDropdown(buildDropdown([]))
      );
    }
  
    window.tm_refreshUserDropdown = fetchDropdown;
    window.addEventListener("employeesLoaded", () => {
      // Reset only on popup OPEN, not refresh
      if (window._tm_lastSelected?.source !== "userChange") {
         window._tm_lastSelected = null;
      }
      setTimeout(fetchDropdown, 150);
    });
    
  
    window.addEventListener("teamMemberChanged", (e) => {
      const username = e.detail.value;
    
      // ðŸ‘‰ Mark that the user manually changed selection
      if (window._tm_lastSelected) {
        window._tm_lastSelected.source = "userChange";
      }
    
      const root = document.getElementById("plan-popup-root");
      if (root && username) {
        console.log("ðŸ"„ Reload tasks for:", username);
        loadEmployees(root, username);
      }
    });
    
  
  })();
  
  /* ---------- render left as accordion (no unscheduled/scheduled split) ---------- */
  function renderTaskList(root) {
    debugger
    const listEl = root.querySelector(''#task-list'');
    if (!listEl) return;
    // loading placeholder
    if (root._plannerState && root._plannerState._loading) {
      listEl.innerHTML = "<div class=''small-muted''>Loading tasks...</div>";
      return;
    }
    const tasks = Array.isArray(root._plannerState.unscheduled) ?
      root._plannerState.unscheduled : [];
    if (tasks.length === 0) {
      listEl.innerHTML = "<div class=''small-muted''>No tasks</div>";
      return;
    }
    listEl.innerHTML = '''';
    const accordion = document.createElement(''div'');
    accordion.className = ''task-accordion accordion'';
    accordion.id = ''taskAccordion'';
    tasks.forEach((task, idx) => {
      const safeId = `task-${String(task.taskid || idx).replace(/[^a-z0-9_-]/gi, '''')}`;
      const item = document.createElement(''div'');
      item.className = ''accordion-item'';
      // Build body sections only if meaningful
      const parts = [];
      if (isMeaningful(task.taskdescription)) {
        // Convert richtext HTML to plain text safely
        const tempDiv = document.createElement("div");
        tempDiv.innerHTML = task.taskdescription; // browser parses the HTML
        let plainText = tempDiv.textContent || tempDiv.innerText || "";
        // Clean up whitespace and line breaks
        plainText = plainText.replace(/\s+/g, " ").trim();
        // Wrap in single paragraph tag
        parts.push(`<p style="line-height:1.5;">${plainText}</p>`);
      }
      // if (isMeaningful(task.action_message)) parts.push(`<div style="margin-top:6px;"><strong>Message:</strong> ${escapeHtml(task.action_message)}</div>`);
      // if (isMeaningful(task.remarks)) parts.push(`<div style="margin-top:6px;"><strong>Remarks:</strong> ${escapeHtml(task.remarks)}</div>`);
      const bodyHtml = parts.length ? parts.join('''') : `<div class="small-muted">No details</div>`;
      item.innerHTML = `
      <h2 class="accordion-header" id="${safeId}-h">
      <button
        class="accordion-button collapsed"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#${safeId}-collapse"
        aria-expanded="false"
        aria-controls="${safeId}-collapse"
      >
        <!-- Drag handle -->
        <span
          class="drag-handle"
          title="Drag to schedule"
          aria-label="Drag handle"
          role="button"
          draggable="true"
        >
          <span class="material-icons material-symbols-outlined">drag_indicator</span>
        </span>
    
        <!-- Task details -->
        <div style="flex:1; display:flex; flex-direction:column; overflow:hidden;line-height:1.6;">
          <!-- First line: title + status dot at the end -->
          <div style="display:flex; align-items:center; justify-content:space-between; gap:6px;">
            <span
              class="title fw-semibold text-truncate"
              data-bs-toggle="tooltip"
              data-bs-placement="bottom"
              title="${escapeHtml(task.taskname)}"
              style="flex:1;"
              data-recid="${task.taskf_hdrid}"
            >
              ${escapeHtml(task.taskname)}
            </span>
    
            <span
              class="status-dot ${getStatusDotClass(task.status)}"
              title="${escapeHtml(task.status || ''Unknown'')}"
            ></span>
          </div>
    
          <!-- Second line: Task ID -->
          <div class="text-muted small">${escapeHtml(task.taskid)}</div>
        </div>
    
        <!-- Chevron -->
        
      </button>
    </h2>
    
    <div
    id="${safeId}-collapse"
    class="accordion-collapse collapse"
    aria-labelledby="${safeId}-h"
    data-bs-parent="#taskAccordion"
    >
      <div class="card-body">
        ${bodyHtml}
      </div>
    </div>
    
      `;
      // when header clicked -> open report tab
      const headerBtn = item.querySelector(''.accordion-button'');
      if (headerBtn) {
        // get collapse panel
        const collapseEl = item.querySelector(`#${safeId}-collapse`);
        if (collapseEl) {
          // 1ï¸âƒ£ When expanding (opening)
          collapseEl.addEventListener(''show.bs.collapse'', () => {
            // Highlight the active accordion
            root.querySelectorAll(".accordion-button.active").forEach(el => el.classList.remove("active"));
            const headerBtn = item.querySelector(".accordion-button");
            if (headerBtn) headerBtn.classList.add("active");
            // Show dimmer before loading
            ;
            // Open the report tab
            openTaskReport(root, task);
          });
          // 2ï¸âƒ£ When collapsing (closing)
          collapseEl.addEventListener(''hide.bs.collapse'', () => {
            // Remove highlight if you want
            const headerBtn = item.querySelector(".accordion-button");
            if (headerBtn) headerBtn.classList.remove("active");
          });
        }
      }
      // drag only from handle (left panel) â€" mark source as ''left''
// drag only from handle (left panel) â€" mark source as ''left''
const handle = item.querySelector(''.drag-handle'');
if (handle) {
  handle.addEventListener(''dragstart'', ev => {
    ev.dataTransfer.setData(''text/plain'', String(task.taskid));
    try { ev.dataTransfer.setData(''text/source'', ''left''); } catch (e) {}
    // pass fromDate (may be empty for unscheduled)
    try { ev.dataTransfer.setData(''text/fromDate'', String(task.scheduleddate || '''')); } catch (e) {}
     // â FIND THE TITLE SPAN AND GET data-recid
     const titleSpan = item.querySelector(".title[data-recid]");
     const recId = titleSpan ? titleSpan.dataset.recid : "";
 
     // â store recid in drag event
     ev.dataTransfer.setData("text/recid", recId);
    handle.classList.add(''dragging'');
    root._dragging = true;
  });
  handle.addEventListener(''dragend'', () => {
    handle.classList.remove(''dragging'');
    setTimeout(() => root._dragging = false, 20);
  });
}
      accordion.appendChild(item);
    });
    listEl.appendChild(accordion);
    // initialize bootstrap tooltips inside this root (guarded)
    try {
      const tooltipTriggers = Array.from(listEl.querySelectorAll(''[data-bs-toggle="tooltip"]''));
      if (tooltipTriggers.length && window.bootstrap && typeof window.bootstrap.Tooltip === ''function'') {
        tooltipTriggers.forEach(el => new bootstrap.Tooltip(el));
      }
    } catch (e) {
      /* ignore if bootstrap not present */
    }
  }
  /* ---------- calendar area ---------- */
  function renderCalendarArea(root) {
    const area = root.querySelector(''#calendar-area'');
    if (!area) return;
  
    // 1ï¸âƒ£ Save scroll position before clearing
    const prevContainer = area.querySelector(''.day-view-stacked'');
    const prevScroll = prevContainer
      ? { top: prevContainer.scrollTop, left: prevContainer.scrollLeft }
      : { top: area.scrollTop, left: area.scrollLeft };
  
    // 2ï¸âƒ£ Re-render everything
    area.innerHTML = '''';
    renderDayStack(root, area);
  
    // 3ï¸âƒ£ Restore scroll AFTER layout is ready
    requestAnimationFrame(() => {
      const newContainer = area.querySelector(''.day-view-stacked'');
      if (newContainer) {
        newContainer.scrollTop = prevScroll.top || 0;
        newContainer.scrollLeft = prevScroll.left || 0;
      } else {
        area.scrollTop = prevScroll.top || 0;
        area.scrollLeft = prevScroll.left || 0;
      }
    });
  }
  
  // function openTaskReport(root, task) {
  //   const tabCalendar = root.querySelector("#tab-calendar");
  //   //const tabReport = root.querySelector("#tab-report");
  //   const calendarTab = root.querySelector("#calendar-tab");
  // //  const reportTab = root.querySelector("#report-tab");
  //   //const reportFrame = root.querySelector("#report-frame");
  //  // if (!tabCalendar || !tabReport || !calendarTab || !reportTab || !reportFrame) return;
  //   // ðŸ"¹ Switch to Report tab
  //  // tabReport.classList.add("tab-active");
  //   tabCalendar.classList.remove("tab-active");
  //   calendarTab.style.display = "none";
  //   reportTab.style.display = "block";
  //   // ðŸ"¹ Load that task in tstruct.aspx
  //   if (task && task.taskid) {
  //     const taskid = encodeURIComponent(task.taskid);
  //     const taskname = encodeURIComponent(task.taskname);
  //     const recid = task.taskf_hdrid
  //     const url = `EntityForm.aspx?tstid=Taskm&recid=${recid}`;
      
  //  ///   reportFrame.src = url;
  //   } else {
  //   //  reportFrame.src = "";
  //   //  reportFrame.contentDocument ?.write("<p style=''padding:10px;''>No record found.</p>");
  //     try {
  //       
  //     } catch (e) {}
  //   }
  // }
  // function setupTabs(root) {
  //   const tabCalendar = root.querySelector("#tab-calendar");
  //   //const tabReport = root.querySelector("#tab-report");
  // //  const calendarTab = root.querySelector("#calendar-tab");
  //  // const reportTab = root.querySelector("#report-tab");
  //   //const reportFrame = root.querySelector("#report-frame");
  //  // if (!tabCalendar || !tabReport || !calendarTab || !reportTab) return;
  //   // Default tab
  //   tabCalendar.classList.add("tab-active");
  //   calendarTab.style.display = "block";
  //   reportTab.style.display = "none";
  //   // Click handlers
  //   tabCalendar.addEventListener("click", () => {
  //     tabCalendar.classList.add("tab-active");
  //   //  tabReport.classList.remove("tab-active");
  //   //  calendarTab.style.display = "block";
  //    // reportTab.style.display = "none";
  //   });
  //   // tabReport.addEventListener("click", () => {
  //   //   tabReport.classList.add("tab-active");
  //   //   tabCalendar.classList.remove("tab-active");
  //   //   calendarTab.style.display = "none";
  //   //   reportTab.style.display = "block";
  //   //   // Load first record from left panel into tstruct
  //   //   const firstTask = root._plannerState ?.tasks ?. [0];
  //   //   if (firstTask) {
  //   //     const taskid = encodeURIComponent(firstTask.taskid);
  //   //     const taskname = encodeURIComponent(firstTask.taskname);
  //   //     const recid = firstTask.taskf_hdrid
  //   //     const url = `EntityForm.aspx?tstid=Taskm&recid=${recid}`;
  //   //       reportFrame.src = url;
  //   //   } else {
  //   //     reportFrame.src = "";
  //   //     reportFrame.contentDocument ?.write("<p style=''padding:10px;''>No record found.</p>");
  //   //   }
  //   // });
  // }
  function formatDMY(date) {
    const dd = String(date.getDate()).padStart(2, ''0'');
    const mm = String(date.getMonth() + 1).padStart(2, ''0'');
    const yyyy = date.getFullYear();
    return `${dd}/${mm}/${yyyy}`;
  }
  function addDays(date, n) {
    const d = new Date(date);
    d.setDate(d.getDate() + n);
    return d;
  }
  function genTempId(prefix = ''tmp'') {
    return prefix + ''_'' + Date.now() + ''_'' + Math.floor(Math.random() * 1000000);
  }
  // function showMoveCopyPopup(x, y, onChoose) {
  //   // remove any existing popup
  //   const prev = document.querySelector(''.mc-popup'');
  //   if (prev) prev.remove();
  //   const popup = document.createElement(''div'');
  //   popup.className = ''mc-popup'';
  //   popup.style.left = `${x}px`;
  //   popup.style.top = `${y}px`;
  //   popup.innerHTML = `
  //     <button class="btn-move" data-action="move">Move</button>
  //     <button class="btn-copy" data-action="copy">Copy</button>
  //     <button class="btn-cancel" data-action="cancel">Cancel</button>
  //   `;
  //   document.body.appendChild(popup);
  //   function cleanup() {
  //     try {
  //       popup.remove();
  //     } catch (e) {}
  //     document.removeEventListener(''click'', outsideHandler);
  //   }
  //   function outsideHandler(ev) {
  //     if (!popup.contains(ev.target)) cleanup();
  //   }
  //   document.addEventListener(''click'', outsideHandler);
  //   popup.addEventListener(''click'', ev => {
  //     const btn = ev.target.closest(''button'');
  //     if (!btn) return;
  //     const action = btn.dataset.action;
  //     if (action === ''cancel'') {
  //       cleanup();
  //       return;
  //     }
  //     cleanup();
  //     if (typeof onChoose === ''function'') onChoose(action);
  //   });


  //   return popup;
  // }
  function showMoveCopyPopup(x, y, onChoose, options = {}) {
    const { disableCopy = false } = options;
  
    // remove any existing popup
    const prev = document.querySelector(''.mc-popup'');
    if (prev) prev.remove();
  
    const popup = document.createElement(''div'');
    popup.className = ''mc-popup'';
    popup.style.left = `${x}px`;
    popup.style.top = `${y}px`;
  
    popup.innerHTML = `
      <button class="btn-move" data-action="move">Move</button>
      <button class="btn-copy" data-action="copy" 
        ${disableCopy ? ''disabled style="opacity:0.5;cursor:not-allowed;"'' : ''''}>
        Copy
      </button>
      <button class="btn-cancel" data-action="cancel">Cancel</button>
    `;
  
    document.body.appendChild(popup);
  
    function cleanup() {
      try { popup.remove(); } catch (e) {}
      document.removeEventListener(''click'', outsideHandler);
    }
  
    function outsideHandler(ev) {
      if (!popup.contains(ev.target)) cleanup();
    }
  
    document.addEventListener(''click'', outsideHandler);
  
    popup.addEventListener(''click'', ev => {
      const btn = ev.target.closest(''button'');
      if (!btn) return;
  
      const action = btn.dataset.action;
  
      // 🚫 prevent disabled copy click
      if (action === ''copy'' && disableCopy) return;
  
      if (action === ''cancel'') {
        cleanup();
        return;
      }
  
      cleanup();
  
      if (typeof onChoose === ''function'') onChoose(action);
    });
  
    return popup;
  }
  function performMove(root, task, targetFullDate, opts = {}) {
    
  
    // ðŸ§  If the move came from the left, set estimateddays to 0
    if (opts.fromLeft) {
      try { task.estimateddays = 0; } catch (e) {}
    }
  
    // âœ… Check if same task already exists on target date
    const alreadyExists = root._plannerState.tasks.some(
      t => t.scheduleddate === targetFullDate && String(t.taskid) === String(task.taskid)
    );
    if (alreadyExists) {
      parent.showAlertDialog(''info'',`Task ${task.taskid} already exists on ${targetFullDate} â€" move prevented.`);
      
      return; // âŒ stop move
    }
  
    // ðŸ"¹ Remove from previous assignQueue (if any)
    try {
     // const prevDate = task.scheduleddate;
     const prevDate = opts[''fromDate'']
      if (prevDate && Array.isArray(root._plannerState.assignQueue?.[prevDate])) {
        root._plannerState.assignQueue[prevDate] =
          root._plannerState.assignQueue[prevDate].filter(id => id !== task.taskid);
      }
    } catch (e) {}
  
    // ðŸ"¹ Assign to new date
    task.scheduleddate = targetFullDate;
    root._plannerState.assignQueue[targetFullDate] =
      root._plannerState.assignQueue[targetFullDate] || [];
    if (!root._plannerState.assignQueue[targetFullDate].includes(task.taskid)) {
      root._plannerState.assignQueue[targetFullDate].push(task.taskid);
    }
  
    // ðŸ§¹ If moved from left, remove from unscheduled list
    if (opts.fromLeft) {
      try {
        if (Array.isArray(root._plannerState.unscheduled)) {
          root._plannerState.unscheduled = root._plannerState.unscheduled.filter(
            t => String(t.taskid) !== String(task.taskid)
          );
        }
  
        // Also remove old unscheduled version of the task
        root._plannerState.tasks = root._plannerState.tasks.filter(t => {
          if (String(t.taskid) === String(task.taskid)) {
            if (!t.scheduleddate || t.scheduleddate === ''null'' || t.scheduleddate === ''[null]'') {
              return false;
            }
          }
          return true;
        });
      } catch (e) {
        console.warn(''Failed to remove task from left list after move:'', e);
      }
    }
   // const recid = task.taskf_hdrid
    // ðŸ''¾ Persist to backend (Ax)
    try {
      // prevDate was captured earlier:
      const prevDate = task.scheduleddateBeforeMove || task.scheduleddate || null;
      // prefer explicit option, else fallback to previously captured prevDate
      const fromDate = (opts && opts.fromDate) ? opts.fromDate : prevDate || '''';
    
      parent.AxSetValue("tasku", "taskid", "1", "0", task.taskid);
      parent.AxSetValue("tasku", "newdate", "1", "0", targetFullDate);
      parent.AxSetValue("tasku", "moveflg", "1", "0", "T");
      parent.AxSetValue("tasku", "fromdate", "1", "0", fromDate);
      parent.AxSubmitData("tasku", "0");
    } catch (e) {
      console.warn(''persist move failed:'', e);
    }
  
    // ðŸ"„ Re-render both views
// Let UI finish rendering before hiding dimmer
setTimeout(() => {
    renderCalendarArea(root);
    renderTaskList(root);
    const container = document.getElementById(''body_Container'');
if (container) {
    container.scrollTop = root._savedScrollTop || 0;
}
    parent.ShowDimmer(false);
  }, 0);
   
  }
  function hideDimmerSafely() {
    try {
      
    } catch (e) {
      console.warn("Failed to hide dimmer", e);
    }
  }
  
  function performCopyRange(root, task, targetFullDate) {
    ;
  
    const srcStr = task.scheduleddate;
  
    // ðŸ§  If no source date, copy only to target (not same day)
    if (!srcStr) {
      const exists = root._plannerState.tasks.find(
        t => t.scheduleddate === targetFullDate && t.taskid === task.taskid
      );
      if (exists) {
        
        return;
      }
  
      const copy = { ...task };
      copy._uid = genTempId(''copy'');
      copy.origTaskId = task.taskid;
      copy.taskid = task.taskid; // keep visible ID same
      copy.scheduleddate = targetFullDate;
      copy._isCopy = true;
  
      root._plannerState.tasks.push(copy);
      root._plannerState.assignQueue[targetFullDate] =
        root._plannerState.assignQueue[targetFullDate] || [];
      root._plannerState.assignQueue[targetFullDate].push(copy._uid);
      
      // ðŸ§© Persist via parent Ax calls
      try {
        parent.AxSetValue("tasku", "taskid", "1", "0", task.taskid);
        parent.AxSetValue("tasku", "newdate", "1", "0", targetFullDate);
        parent.AxSubmitData("tasku", recid);
      } catch (err) {
        console.warn("Ax persistence failed for single copy:", err);
      }
  
      renderCalendarArea(root);
      
      return;
    }
  
    // ðŸ"… Range copy logic
    const srcDate = parseDMY(srcStr);
    const tgtDate = parseDMY(targetFullDate);
    if (!srcDate || !tgtDate) {
      
      return;
    }
  
    const start = new Date(Math.min(srcDate, tgtDate));
    const end = new Date(Math.max(srcDate, tgtDate));
    const copies = [];
  
    for (let d = new Date(start); d <= end; d = addDays(d, 1)) {
      const dayStr = formatDMY(d);
      if (dayStr === srcStr) continue; // skip source
  
      // âœ… Skip if same taskid already exists on that day
      const alreadyExists = root._plannerState.tasks.some(
        t => t.scheduleddate === dayStr && t.taskid === task.taskid
      );
      if (alreadyExists) continue;
  
      const copy = { ...task };
      copy._uid = genTempId(''copy'');
      copy.origTaskId = task.taskid;
      copy.taskid = task.taskid;
      copy.scheduleddate = dayStr;
      copy._isCopy = true;
      copies.push(copy);
    }
  
    // ðŸ§© Add to plannerState and persist each via Ax
    copies.forEach(c => {
      root._plannerState.tasks.push(c);
      root._plannerState.assignQueue[c.scheduleddate] =
        root._plannerState.assignQueue[c.scheduleddate] || [];
      root._plannerState.assignQueue[c.scheduleddate].push(c._uid);
  
      // ðŸ''¾ Persist each copied record to backend
      try {
        parent.AxSetValue("tasku", "taskid", "1", "0", c.taskid);
        parent.AxSetValue("tasku", "newdate", "1", "0", c.scheduleddate);
        parent.AxSubmitData("tasku", "0");
        console.log(` Copied task ${c.taskid} to ${c.scheduleddate}`);
      } catch (err) {
        console.warn("Ax persistence failed for copy:", err);
      }
    });
  
    renderCalendarArea(root);
    
  }
  
  function parseDMY(dateStr) {
    if (!dateStr) return null;
    const [d, m, y] = dateStr.split(''/'');
    return new Date(Number(y), Number(m) - 1, Number(d)); // months are 0-based
  }
  function renderDayStack(root, area) {
    // remove previous stack
    const prev = area.querySelector(''.day-view-stacked'');
    if (prev) prev.remove();
  
    const container = document.createElement(''div'');
    container.className = ''day-view-stacked'';
    area.appendChild(container);
  
    const date = new Date(root._plannerState.year, root._plannerState.month, 1);
    const year = date.getFullYear();
    const month = date.getMonth();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
  
    const monthLabel = root.querySelector(''#calendar-month-year'');
    if (monthLabel) {
      monthLabel.innerText = date.toLocaleString(''default'', { month: ''long'' }) + '' '' + year;
    }
  
    // ðŸ‘‡ Only one loop now (handles both months)
    const daysPerRow = 4;
    const totalCells = Math.ceil(daysInMonth / daysPerRow) * daysPerRow;
    const nextMonth = month + 1;
    const nextYear = nextMonth > 11 ? year + 1 : year;
    const nextMonthIndex = nextMonth % 12;
  
    for (let cell = 1; cell <= totalCells; cell++) {
      let displayDate, displayMonth, displayYear;
  
      if (cell <= daysInMonth) {
        // Normal days of current month
        displayDate = cell;
        displayMonth = month;
        displayYear = year;
      } else {
        // Overflow from next month
        displayDate = cell - daysInMonth;
        displayMonth = nextMonthIndex;
        displayYear = nextYear;
      }
  
      const yyyy = displayYear;
      const mm = String(displayMonth + 1).padStart(2, ''0'');
      const dd = String(displayDate).padStart(2, ''0'');
      const fullDate = `${dd}/${mm}/${yyyy}`;
  
      const dayCard = document.createElement(''div'');
      dayCard.className = ''day-card'';
      dayCard.dataset.date = fullDate;
  
      const weekday = new Date(displayYear, displayMonth, displayDate).toLocaleString(''default'', { weekday: ''short'' });
  
      // Dim overflow days
      // if (cell > daysInMonth) {
      //   dayCard.style.opacity = ''0.6'';
      //   dayCard.style.background = ''#f9f9f9'';
      // }
  
      // ðŸ"¹ Fetch tasks for this date
      const allTasks = root._plannerState.tasks || [];
      const tasksForDate = allTasks.filter(task => {
        if (!task.scheduleddate) return false;
        const startDate = parseDMY(task.scheduleddate);
        if (!startDate) return false;
  
        const duration = Number(task.estimateddays) || 0;
        const current = new Date(displayYear, displayMonth, displayDate);
        const endDate = new Date(startDate);
        endDate.setDate(startDate.getDate() + duration);
  
        return current >= startDate && current <= endDate;
      });
  
      const tasksDisplayStyle =
        tasksForDate.length === 0
          ? ''display:flex;flex-direction:column;gap:6px;min-height:56px;align-items:flex-start;opacity:0.95;''
          : ''display:flex;flex-direction:column;gap:6px;'';
  
      dayCard.innerHTML = `
        <div class="day-header" style="cursor:pointer; display:flex; justify-content:space-between; align-items:center;">
          <div class="day-title" style="font-weight:600; font-size:14px;">
            ${displayDate} ${new Date(displayYear, displayMonth, displayDate).toLocaleString(''default'', { month: ''short'' })} ${weekday}
          </div>
          <div class="day-count small-muted" style="font-size:12px; color:#666;">
            ${tasksForDate.length} ${tasksForDate.length === 1 ? ''task'' : ''tasks''}
          </div>
        </div>
        <div class="day-tasks" data-date="${fullDate}" 
          style="${tasksDisplayStyle}; height:120px; overflow-y:auto; width:100%; padding:4px; box-sizing:border-box; border:1px solid #eee; border-radius:6px;">
        </div>
      `;
  
      const tasksEl = dayCard.querySelector(''.day-tasks'');
  
      // Attach drag/drop handlers (same as before)
dayCard.addEventListener(''dragover'', ev => {
    ev.preventDefault();
    // Prevents the container from collapsing if the items are moved
    ev.currentTarget.style.minHeight = ev.currentTarget.offsetHeight + ''px'';
});     
 dayCard.addEventListener(''drop'', ev => {
    ev.preventDefault();

    // 1. CAPTURE SCROLL POSITION IMMEDIATELY
    // Using body_Container as it is the main wrapper in your inbox.js
    const scrollContainer = document.getElementById(''body_Container'');
    const savedScrollTop = scrollContainer ? scrollContainer.scrollTop : window.scrollY;

    // 2. READ DATA TRANSFER (Must be done before any timeouts)
    const draggedId = ev.dataTransfer.getData(''text/plain'');
    const fromDate  = ev.dataTransfer.getData(''text/fromDate'') || '''';
    const src       = ev.dataTransfer.getData(''text/source'') || '''';
    const recId     = ev.dataTransfer.getData(''text/recid'') || '''';

    // 3. EXECUTE LOGIC
    setTimeout(() => {
        if (!draggedId) {
            parent.ShowDimmer(false);
            return;
        }

        const task = root._plannerState.tasks.find(t => t.taskid == draggedId);
        
        // Date Validation Logic
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const [dd, mm, yyyy] = fullDate.split("/");
        const dropDate = new Date(yyyy, mm - 1, dd);
        dropDate.setHours(0, 0, 0, 0);

        const isPastDrop = dropDate < today;
        const isFromLeft = src === "left";
        const isFromPast = fromDate && new Date(fromDate.split("/").reverse().join("-")) < today;

        // Block Drops to Past
        if (isPastDrop) {
            parent.ShowDimmer(false);
            parent.showAlertDialog("warning", "Cannot move/copy to past dates.");
            return;
        }
  const restoreScroll = () => {
        setTimeout(() => {
            if (scrollContainer) {
                scrollContainer.scrollTop = savedScrollTop;
            } else {
                window.scrollTo(0, savedScrollTop);
            }
        }, 0); // ✅ runs AFTER render
    };
   const scrollContainer = document.getElementById(''body_Container'');
root._savedScrollTop = scrollContainer ? scrollContainer.scrollTop : window.scrollY;
        // Handle the Move/Copy
        if (isFromLeft) {
            performMove(root, task, fullDate, {
                fromLeft: true,
                fromDate
            });
             

        } else if (isFromPast) {
            performMove(root, task, fullDate, { fromDate });
        } else {
            showMoveCopyPopup(ev.clientX + 6, ev.clientY + 6, action => {
                if (action === ''move'') {
                    performMove(root, task, fullDate, { fromDate });
                } else if (action === ''copy'') {
                    performCopyRange(root, task, fullDate);
                } else {
                    parent.ShowDimmer(false);
                }
            });
        }

        // 4. RESTORE SCROLL POSITION
        // We wrap this in another small timeout or requestAnimationFrame 
        // to ensure it happens AFTER the DOM has finished re-rendering.
        // requestAnimationFrame(() => {
        //     if (scrollContainer) {
        //         scrollContainer.scrollTop = savedScrollTop;
        //     } else {
        //         window.scrollTo(0, savedScrollTop);
        //     }
        // });

    }, 0);
});
  
      // Render task cards inside
      tasksForDate.forEach(task => {
        const card = document.createElement(''div'');
        card.className = ''cal-chip'';
        card.draggable = true;
        card.dataset.taskid = task.taskid;
        card.dataset.recid = task.taskf_hdrid;
        card.dataset.scheduleddate = task.scheduleddate;
        card.innerHTML = `
    <div style="display:flex; justify-content:space-between; align-items:center; gap:6px;">
      <!-- LEFT SIDE: ID + Name -->
      <div style="flex:1; min-width:0;">
        <div class="cal-chip-id">${escapeHtml(task.taskid)}</div>
        <div class="cal-chip-name text-truncate">${escapeHtml(task.taskname || '''')}</div>
      </div>
      <!-- RIGHT SIDE: ACTION ICONS -->
      <div style="display:flex; align-items:center; gap:2px;">
        <span class="material-icons chip-view"
              title="View"
              style="font-size:18px; cursor:pointer;">
          visibility
        </span>
        <span class="material-icons chip-delete"
              title="Delete"
              style="font-size:18px; cursor:pointer; color:#b30000;">
          delete
        </span>
      </div>
    </div>        `;
        card.style.background = getRandomColor();
  
        card.addEventListener(''dragstart'', ev => {
          ev.dataTransfer.setData(''text/plain'', String(task.taskid));
          ev.dataTransfer.setData(''text/source'', ''calendar'');
          ev.dataTransfer.setData(''text/fromDate'', String(task.scheduleddate || ''''));
        });
/* --------------------------------------------------------
   *   ð VIEW ICON â open task report, stop drag
     -------------------------------------------------------- */
    //  const viewIcon = card.querySelector(".chip-view");

    //  viewIcon.addEventListener("click", (ev) => {
    //      ev.stopPropagation();
    //      ev.preventDefault();
     
    //      const recid = task.recid || card.dataset.recid;
     
    //      if (!recid) {
    //          alert("No record ID available for this task.");
    //          return;
    //      }
     
    //      const url = `../../aspx/tstruct.aspx?transid=Taskm`
    //          + `&act=load`
    //          + `&recordid=${encodeURIComponent(recid)}`
    //          + `&calledFrom=TaskPlanner`; // ✅ fix
     
    //      if (createPopup) {
    //      createPopup(url);
    //      } 
         
    //  });
     const viewIcon = card.querySelector(".chip-view");

viewIcon.addEventListener("click", (ev) => {
    ev.stopPropagation();
    ev.preventDefault();
    const targetDiv = document.querySelector(".d-flex.align-items-center.flex-nowrap.text-nowrap");
    if (targetDiv) {
        targetDiv.style.position = "relative";
        targetDiv.style.right = "25px";
    }
    const recid = task.recid || card.dataset.recid;

    if (!recid) {
        alert("No record ID available for this task.");
        return;
    }

    const url = `../../aspx/tstruct.aspx?transid=Taskm`
        + `&act=load`
        + `&recordid=${encodeURIComponent(recid)}`
        + `&calledFrom=TaskPlanner`;

    const modal = document.getElementById("filterModal");
    const planner = modal?.querySelector("#plan-popup-root");

    if (!modal || !planner) return;

    let iframe = modal.querySelector("#taskFrame");

    // ✅ Create iframe only once
    if (!iframe) {
        iframe = document.createElement("iframe");
        iframe.id = "taskFrame";

        Object.assign(iframe.style, {
            width: "100%",
            height: "100vh",
            border: "none",
            display: "none"
        });

        planner.parentElement.appendChild(iframe);
    }

    // 🔥 TOGGLE
    planner.style.display = "none";
    iframe.style.display = "block";
    iframe.src = url;
});
  /* --------------------------------------------------------
   *   ð DELETE ICON â remove task from date, stop drag
     -------------------------------------------------------- */
 // DELETE ICON CLICK
const deleteIcon = card.querySelector(".chip-delete");
deleteIcon.addEventListener("click", (ev) => {
  ev.stopPropagation();
  ev.preventDefault();
  openDeleteModal(() => {
      deleteTaskFromCalendar(ev,task, root);
  });
});
function deleteTaskFromCalendar(ev, task, root) {

    ev.stopPropagation();

    // 🔥 capture element immediately
    const chip = ev.target.closest("[data-taskid]");

    parent.ShowDimmer(true);

    const params2 = {
        adsNames: ["RECORDAFTERSAVE"],
        refreshCache: false,
        sqlParams: {
            taskid: String(task.taskid)
        }
    };

    parent.GetDataFromAxList(
        params2,
        (res) => {
            const recid = JSON.parse(res)?.result?.data?.[0]?.data?.[0]?.tasku1id;

            if (!recid) {
                console.error("No recid returned from ADS.");
                return;
            }

            parent.AxSetValue("tasku", "deletflg", "1", "0", "T");
            parent.AxSetValue("tasku", "taskid", "1", "0", `${task.taskid}`);
            parent.AxSetValue("tasku", "newdate", "1", "0", `${task.scheduleddate}`);

            parent.AxSubmitData("tasku", recid);

            // ✅ use stored reference (NOT ev.target again)
            if (chip) {
                chip.remove();
            }

           // 1. Update the global tasks array to clear the date for this specific task
root._plannerState.tasks = root._plannerState.tasks.map(t => {
    if (String(t.taskid) === String(task.taskid)) {
        return { ...t, scheduleddate: "" }; // Clear the date
    }
    return t;
});

// 2. Clear it from the assignQueue so the drop logic doesn''t see it
Object.keys(root._plannerState.assignQueue || {}).forEach(date => {
    root._plannerState.assignQueue[date] = root._plannerState.assignQueue[date].filter(
        id => String(id) !== String(task.taskid)
    );
});

// 3. Update the unscheduled list for the UI
root._plannerState.unscheduled = root._plannerState.unscheduled.filter(
    t => String(t.taskid) !== String(task.taskid)
);
root._plannerState.unscheduled.unshift({ ...task, scheduleddate: "" });

parent.ShowDimmer(false);
parent.showAlertDialog("success", "Task deleted successfully.");

// 4. Refresh UI
renderTaskList(root);
renderCalendarArea(root); // Crucial to refresh the calendar state
        },
        (err) => {
            console.error("Delete failed", err);
            parent.ShowDimmer(false);
            alert("Failed to delete task.");
        }
    );
}
(function addModalCSS() {
  const css = `
  .modal-overlay { position:fixed; inset:0; background:rgba(0,0,0,0.4); display:flex; align-items:center; justify-content:center; z-index:100000; }
  .modal-box { background:#fff; padding:20px 24px; border-radius:10px; width:320px; box-shadow:0 10px 30px rgba(0,0,0,0.2); font-family:Inter, sans-serif; }
  .modal-title { font-size:18px; font-weight:600; margin-bottom:10px; }
  .modal-message { font-size:15px; color:#444; margin-bottom:20px; }
  .modal-actions { display:flex; justify-content:flex-end; gap:10px; }
  .btn-cancel { background:#e5e7eb; padding:6px 14px; border-radius:6px; border:none; cursor:pointer; }
  .btn-delete { background:#ef4444; color:#fff; padding:6px 14px; border-radius:6px; border:none; cursor:pointer; }
  `;
  const style = document.createElement("style");
  style.textContent = css;
  document.head.appendChild(style);
})();
(function injectDeleteModal() {
  const modalHTML = `
  <div id="deleteModal" style="
      display:none; position:fixed; inset:0;
      background:rgba(0,0,0,0.4); 
      z-index:999999; 
      align-items:center; justify-content:center;
      font-family:Inter, sans-serif;">
      
      <div style="
          background:#fff; padding:20px; border-radius:10px; width:320px; 
          box-shadow:0 10px 25px rgba(0,0,0,0.2);">
          
          
          <div style="font-size:15px; color:#444; margin-bottom:20px;">
              Are you sure you want to delete this task?
          </div>
          <div style="display:flex; justify-content:flex-end; gap:10px;">
              <button id="modalCancel" style="
                  background:#e5e7eb; border:none; 
                  padding:6px 14px; border-radius:6px;
                  cursor:pointer;">Cancel</button>
              <button id="modalConfirm" style="
                  background:#ef4444; color:white; border:none;
                  padding:6px 14px; border-radius:6px;
                  cursor:pointer;">Delete</button>
          </div>
      </div>
  </div>
  `;
  document.body.insertAdjacentHTML("beforeend", modalHTML);
})();
function openDeleteModal(onConfirm) {
  const modal = document.getElementById("deleteModal");
  modal.style.display = "flex";
  const cancelBtn = document.getElementById("modalCancel");
  const confirmBtn = document.getElementById("modalConfirm");
  // remove old listeners
  cancelBtn.onclick = () => { modal.style.display = "none"; };
  confirmBtn.onclick = () => {
      modal.style.display = "none";
      onConfirm(); // run actual delete
  };
}
        // ---------- Hover: show details by calling GetDataFromAxList ----------
(function() {
  // helper to strip tags (customer field may contain html)
  function stripHtmlTags(html) {
    if (!html) return '''';
    try {
      // Remove all HTML tags
      html = html.replace(/<\/?[^>]+(>|$)/g, '' '');
      html = html.replace(/\s+/g, '' '').trim();
  
      // Decode HTML entities
      const txt = document.createElement(''textarea'');
      txt.innerHTML = html;
      let clean = txt.value.trim();
  
      // Remove any "Customer -" prefix (case-insensitive)
      clean = clean.replace(/^Customer\s*-\s*/i, '''');
  
      return clean;
    } catch (e) {
      return html;
    }
  }
  // Build small details table HTML from a single row object
  function buildTaskDetailTableRow(row) {
    if (!row) return ''<div class="small-muted">No details</div>'';
    const dd = row.duedate ? formatDateShort(row.duedate) : '''';
    // prefer plain text for customer
    const cust = stripHtmlTags(row.customer || row.customername || row.customer_name || '''');
    return `
      <table style="font-size:13px; border-collapse:collapse; min-width:220px;">
        <tbody>
        <tr><td style="padding:6px 8px; font-weight:600; width:90px;">Task Name</td><td style="padding:6px 8px;">${escapeHtml(row.taskname || '''')}</td></tr>
          <tr><td style="padding:6px 8px; font-weight:600; width:90px;">Assign By</td><td style="padding:6px 8px;">${escapeHtml(row.assignby || row.AssignBy || row.assign_by || '''')}</td></tr>
          <tr><td style="padding:6px 8px; font-weight:600;">Assign To</td><td style="padding:6px 8px;">${escapeHtml(row.assignto || row.AssignTo || row.assigned_to || '''')}</td></tr>
          <tr><td style="padding:6px 8px; font-weight:600;">Customer</td><td style="padding:6px 8px;">${escapeHtml(cust)}</td></tr>
          <tr><td style="padding:6px 8px; font-weight:600;">Priority</td><td style="padding:6px 8px;">${escapeHtml(row.priority || '''')}</td></tr>
          <tr><td style="padding:6px 8px; font-weight:600;">Status</td><td style="padding:6px 8px;">${escapeHtml(row.status || row.sttaus || '''')}</td></tr>
          <tr><td style="padding:6px 8px; font-weight:600;">Due</td><td style="padding:6px 8px;">${escapeHtml(dd)}</td></tr>
        </tbody>
      </table>
    `;
  }
  // create popup element
  function showTaskDetailPopup(targetEl, html) {
      
  
      const popup = document.createElement(''div'');
      popup.className = ''task-hover-popup'';
      popup.style.cssText = `
          position:fixed;
          z-index:1000000;
          background:#fff;
          border:1px solid rgba(0,0,0,0.08);
          padding:8px;
          border-radius:8px;
          box-shadow:0 8px 24px rgba(2,6,23,0.12);
          font-family: Inter, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
          font-size:13px;
          color:#0f1724;
          max-width:320px;
          pointer-events:auto;
      `;
      popup.innerHTML = html;
  
      document.body.appendChild(popup);
      popup._anchor = targetEl;
  // Keep popup open when hovered
popup.addEventListener("mouseenter", () => {
  popup._hovering = true;
});
popup.addEventListener("mouseleave", () => {
  popup._hovering = false;
  hideTaskDetailPopup();
});
      // --- CALCULATE POSITION (AFTER APPENDING POPUP) ---
      const rect = targetEl.getBoundingClientRect();
      const popupW = popup.offsetWidth;
      const popupH = popup.offsetHeight;
  
      // Horizontal center alignment
      let left = rect.left + rect.width / 2 - popupW / 2;
      left = Math.max(10, Math.min(left, window.innerWidth - popupW - 10));
  
      // Default BELOW
      let top = rect.bottom + window.scrollY + 8;
  
      const spaceAbove = rect.top;
      const spaceBelow = window.innerHeight - rect.bottom;
  
      // --- DECIDE ONCE if popup is above or below ---
      let position = "below";
      if (spaceBelow < popupH && spaceAbove > popupH) {
          position = "above";
      }
      popup.dataset.position = position;
  
      // Apply the chosen direction
      if (position === "above") {
          top = rect.top + window.scrollY - popupH - 8;
      }
  
      // Clamp inside viewport (no flipping)
      top = Math.max(window.scrollY + 10,
          Math.min(top, window.scrollY + window.innerHeight - popupH - 10));
  
      popup.style.left = `${left}px`;
      popup.style.top = `${top}px`;
  
      return popup;
  }
  
  function hideTaskDetailPopup() {
    const prev = document.querySelector(''.task-hover-popup'');
    if (prev) try { prev.remove(); } catch (e) {}
  }
  // attach hover handlers to the `card` created in your loop
 // ---- Attach popup only when hovering the Task ID (.cal-chip-id) ----
const nameEl = card.querySelector(".cal-chip-id");
if (nameEl) {
  // Mouse Enter on ID
  nameEl.addEventListener(''mouseenter'', function (ev) {

    // ❌ BLOCK while dragging
    if (root._dragging) return;
  
    // ❌ BLOCK if mouse button pressed (drag/scroll)
    if (ev.buttons !== 0) return;
  
    if (card._hoverTimer) clearTimeout(card._hoverTimer);
  
    card._hoverTimer = setTimeout(() => {
  
      // ❌ DOUBLE SAFETY
      if (root._dragging) return;
  
      // // ❌ MUST STILL BE HOVERED
      // if (!nameEl.matches('':hover'')) return;
  
      const params1 = {
        adsNames: [''Taskdetails''],
        refreshCache: false,
        sqlParams: { taskid: String(task.taskid) }
      };
  
      const loadingHtml = `<div style="padding:8px 4px;">Loading...</div>`;
      showTaskDetailPopup(nameEl, loadingHtml);
  
      try {
        parent.GetDataFromAxList(
          params1,
          (response) => {
  
           
  
            let parsed = {};
            try { parsed = JSON.parse(response); } catch (e) {}
  
            const row = parsed?.result?.data?.[0]?.data?.[0] || {};
  
            hideTaskDetailPopup();
            showTaskDetailPopup(nameEl, buildTaskDetailTableRow(row));
          },
          () => hideTaskDetailPopup()
        );
      } catch (ex) {
        hideTaskDetailPopup();
      }
  
    }, 250);
  });
  // Mouse Leave from ID
  nameEl.addEventListener("mouseleave", () => {
    if (card._hoverTimer) {
      clearTimeout(card._hoverTimer);
      card._hoverTimer = null;
    }
  
    hideTaskDetailPopup(); 
  });
}
//   card.addEventListener(''mouseleave'', function () {
//     if (card._hoverTimer) {
//         clearTimeout(card._hoverTimer);
//         card._hoverTimer = null;
//     }
//     setTimeout(() => {
//         const popup = document.querySelector(''.task-hover-popup'');
//         if (!popup) return;
//         // Do NOT hide if mouse is over popup
//         const r = popup.getBoundingClientRect();
//         let mx = 0, my = 0;

//         if (event && event.clientX !== undefined) {
//             mx = event.clientX;
//             my = event.clientY;
//         }
//         const inside =
//             mx >= r.left && mx <= r.right &&
//             my >= r.top  && my <= r.bottom;
//        // if (!inside) hideTaskDetailPopup();
//     }, 60);
// });
  // also hide popup on scroll or click elsewhere
 window.addEventListener("scroll", () => {
  const popup = document.querySelector(".task-hover-popup");
  if (!popup || !popup._anchor) return;
  const anchor = popup._anchor;
  const rect = anchor.getBoundingClientRect();
  const popupW = popup.offsetWidth;
  const popupH = popup.offsetHeight;
  let left = rect.left + rect.width / 2 - popupW / 2;
  left = Math.max(10, Math.min(left, window.innerWidth - popupW - 10));
  let top;
  if (popup.dataset.position === "above") {
      top = rect.top + window.scrollY - popupH - 8;
  } else {
      top = rect.bottom + window.scrollY + 8;
  }
  // clamp
  top = Math.max(
      window.scrollY + 10,
      Math.min(top, window.scrollY + window.innerHeight - popupH - 10)
  );
  popup.style.left = left + "px";
  popup.style.top  = top + "px";
});
  document.addEventListener(''click'', () => { hideTaskDetailPopup(); }, true);
})();
  
        tasksEl.appendChild(card);
      });
  
      container.appendChild(dayCard);
    }
  
    renderTaskList(root);

    // ✅ AUTO FOCUS TODAY
setTimeout(() => {
  const today = new Date();
  const dd = String(today.getDate()).padStart(2, ''0'');
  const mm = String(today.getMonth() + 1).padStart(2, ''0'');
  const yyyy = today.getFullYear();

  const todayStr = `${dd}/${mm}/${yyyy}`;

  const todayCard = container.querySelector(`.day-card[data-date="${todayStr}"]`);

  if (todayCard) {

    // 🔵 Add blue border highlight
    todayCard.style.border = "2px solid #0b69ff";
    todayCard.style.boxShadow = "0 0 0 2px rgba(11,105,255,0.2)";

    // 📍 Scroll into view (centered)
    todayCard.scrollIntoView({
      behavior: "smooth",
      block: "center",
      inline: "center"
    });

  }
}, 100);
  }
  
  function opentstruct(elem) {
    var taskid = elem.dataset.taskid;
    var taskname = elem.dataset.taskname;
    const recid = elem.dataset.recid
    const url = `EntityForm.aspx?tstid=Taskm&recid=${recid}`;
    if (window.parent && typeof window.parent.LoadIframe === ''function'') {
      window.parent.LoadIframe(url);
    }
  }
  /* ---------- assign/remove ---------- */
  // function assignTaskToDate(taskid, dateStr, root, opts) {
  //   const task = root._plannerState.tasks.find(t => t.taskid == taskid);
  //   if (!task) return;
  //   if (task.scheduledDate) {
  //     const prev = root._plannerState.assignQueue[task.scheduledDate] || [];
  //     root._plannerState.assignQueue[task.scheduledDate] = prev.filter(id => id !== taskid);
  //   }
  //   task.scheduledDate = dateStr;
  //   root._plannerState.assignQueue[dateStr] = root._plannerState.assignQueue[dateStr] || [];
  //   root._plannerState.assignQueue[dateStr].push(taskid);
  //   renderCalendarArea(root);
  // }
  function assignTaskToDate(taskid, dateStr, root, opts) {
    const task = root._plannerState.tasks.find(t => t.taskid == taskid);
    if (!task) return;
    // Remove from previous date
    if (task.scheduledDate) {
      const prev = root._plannerState.assignQueue[task.scheduledDate] || [];
      root._plannerState.assignQueue[task.scheduledDate] = prev.filter(id => id !== taskid);
    }
    // Assign to new date
    task.scheduledDate = dateStr;
    root._plannerState.assignQueue[dateStr] = root._plannerState.assignQueue[dateStr] || [];
    root._plannerState.assignQueue[dateStr].push(taskid);
    // âœ… Immediately save the change
    const [dd, mm, yyyy] = dateStr.split("/");
    const formattedDate = `${dd}/${mm}/${yyyy}`;
    try {
      parent.AxSetValue("tasku", "taskid", "1", "0", taskid);
      parent.AxSetValue("tasku", "newdate", "1", "0", formattedDate);
      parent.AxSubmitData("tasku", "0");
      //parent.showAlertDialog("success", "Task rescheduled successfully!");
      // const btn = document.querySelector(''#refresh-planner'');
      // btn.click();
    } catch (e) {
      console.error("Auto-save failed", e);
      parent.showAlertDialog("danger", "Failed to auto-save task update.");
    }
    // Re-render calendar UI
    renderCalendarArea(root);
  }
  function removeTaskFromDate(taskid, fromDate, root, opts) {
    if (!root._plannerState.assignQueue[fromDate]) return;
    root._plannerState.assignQueue[fromDate] = root._plannerState.assignQueue[fromDate].filter(id => id !== taskid);
    const task = root._plannerState.tasks.find(t => t.taskid == taskid);
    if (task) task.scheduledDate = opts && opts.unschedule ? null : task.scheduledDate;
    renderCalendarArea(root);
  }
  function getStatusDotClass(status) {
    switch ((status || "").toLowerCase()) {
      case "pending":
        return "status-pending"; // red
      case "accepted":
        return "status-accepted"; // green
      case "forwarded":
        return "status-forwarded"; // yellow
      default:
        return "status-unknown"; // gray
    }
  }
  // boot-up
  try {
    window.AxAfterIviewLoad();
  } catch (e) {
    /* ignore */
  }
})();
// Source file: /mnt/data/taskslst.js
// Adds a username dropdown populated from the DS call and places it centered above the calendar view name / in the header.
// Drop this file into your project (or merge the logic into your existing taskslst.js). It''s defensive: it tries several header selectors
// and several possible username fields on the returned rows. It also emits a custom event when selection changes.


window.togglePlannerView = function () {
    const modal = document.getElementById("filterModal");
    if (!modal) return;

    const iframe = modal.querySelector("#taskFrame");
    const planner = modal.querySelector("#plan-popup-root");

    if (iframe) {
        iframe.style.display = "none";
        iframe.src = ""; // reset
    }

    if (planner) {
        planner.style.display = "block";
    }
};

function hideAllTooltips() {
  try {
      // Bootstrap tooltips
      document.querySelectorAll(''[data-bs-toggle="tooltip"]'').forEach(el => {
          const instance = bootstrap.Tooltip.getInstance(el);
          if (instance) {
              instance.hide();
              instance.dispose(); // important for your dynamic UI
          }
      });

      // Remove leftover tooltip DOM
      document.querySelectorAll(''.tooltip'').forEach(t => t.remove());

  } catch (e) {
      console.warn("Tooltip cleanup failed:", e);
  }
}
// function initTaskTooltips() {
//   const tooltipTriggerList = [].slice.call(document.querySelectorAll(''[data-bs-toggle="tooltip"]''));
//   tooltipTriggerList.map(function (tooltipTriggerEl) {
//       // Dispose of old instance if it exists to prevent memory leaks
//       const oldInstance = bootstrap.Tooltip.getInstance(tooltipTriggerEl);
//       if (oldInstance) oldInstance.dispose();
      
//       return new bootstrap.Tooltip(tooltipTriggerEl, {
//           boundary: document.body,
//           trigger: ''hover'' // Explicitly set trigger to hover
//       });
//   });
// }
// ✅ GLOBAL EVENTS (ONLY ONCE)
// ✅ MODIFIED GLOBAL EVENTS
// Remove ''scroll'' if you want tooltips to stay visible while scrolling the panel
// document.addEventListener("mousedown", (e) => {
//   // Only hide if we aren''t clicking the tooltip itself
//   if (!e.target.closest(''.tooltip'')) {
//       hideAllTooltips();
//   }
// });

// Avoid ''scroll'' listener if your tasks are in a scrollable div, 
// otherwise the tooltip will vanish the moment the user moves the mouse slightly.
document.addEventListener("scroll", hideAllTooltips, true);
// document.addEventListener("dragstart", hideAllTooltips);
// document.addEventListener("scroll", hideAllTooltips, true);
/** * STRONG FIX: Tooltip Cleanup
 * Ensures custom popups are destroyed on scroll or drag to prevent "ghost" tooltips
 */
(function() {

    let isDragging = false;

    const cleanupPopups = () => {
        document.querySelectorAll(''.task-hover-popup'').forEach(popup => popup.remove());
    };

    // 🔥 DRAG START
    document.addEventListener("dragstart", () => {
        isDragging = true;
        cleanupPopups();
    }, true);

    // 🔥 DRAG END
    document.addEventListener("dragend", () => {
        isDragging = false;
    }, true);

    // -------------------------------
    // SCROLL HANDLING (same as yours)
    // -------------------------------
    window.addEventListener(''scroll'', cleanupPopups, true);

    const scrollContainer = document.getElementById("plistContent");
    if (scrollContainer) {
        scrollContainer.addEventListener(''scroll'', cleanupPopups, { passive: true });
    }

    // -------------------------------
    // 🔥 BLOCK POPUP CREATION DURING DRAG
    // -------------------------------
    document.addEventListener("mouseover", function(e) {
        if (isDragging) {
            cleanupPopups(); // ensure nothing shows
            return;
        }
    }, true);

})();');
>>

<<
INSERT INTO sect4 (sect4id, htmlsectionsid, sect4row, filename, filetype, css_js_src) VALUES(1592770000004, 1592770000000, 3, 'AxProcessFlow_V3', 'Js', 'var armToken = "",
  axProcessObj;

var LoadIframe = callParentNew("LoadIframe");
var cardsData = {},
  cardsDesign = {},
  xmlMenuData = "",
  menuJson = "";
var _horizontalFlow = true;
var _autoLoadNextTask = true;
var dtCulture = eval(callParent("glCulture"));
var processflowJson = {},
  taskdetailsJson = {};
var TaskCount = 0;
callParentNew("AxNotifyMsgId=", "");
let cardsDashboardObj = {
  dirLeft: true,
  enableMasonry: false,
  homePageType: "cards",
  isCardsDashboard: true,
  isMobile: isMobileDevice(),
};
var files = {
  css: [],
  js: [],
};

const queryString = window.location.search;
//const urlParams = new URLSearchParams(queryString);
var taskcards = "";

const myDiv = document.getElementById("body_Container");
class AxProcessFlow {
  constructor() {
    this._entity = {
      inValid: function (elem) {
        return elem == null || typeof elem == "undefined" || elem == "";
      },
      metaData: [
        {
          fldname: "DropDown",
          fldcap: "Task Status",
          fdatatype: "c",
          cdatatype: "DropDown",
          hide: "F",
        },
        {
          fldname: "DropDown",
          fldcap: "Task Type",
          fdatatype: "c",
          cdatatype: "DropDown",
          hide: "F",
        },
        {
          fldname: "DropDown",
          fldcap: "Message Type",
          fdatatype: "c",
          cdatatype: "DropDown",
          hide: "F",
        },
        {
          fldname: "DropDown",
          fldcap: "Process Name",
          fdatatype: "c",
          cdatatype: "DropDown",
          hide: "F",
        },
        {
          fldname: "DropDown",
          fldcap: "User Name",
          fdatatype: "c",
          cdatatype: "DropDown",
          hide: "F",
        },
        {
          fldname: "Date",
          fldcap: "Date",
          fdatatype: "d",
          cdatatype: "Date",
          hide: "F",
        },
        {
          fldname: "Numeric",
          fldcap: "Numeric",
          fdatatype: "n",
          cdatatype: "Numeric",
          hide: "F",
        },
        {
          fldname: "Text",
          fldcap: "Text",
          fdatatype: "t",
          cdatatype: "Text",
          hide: "F",
        },
      ],
    };

    this.tasksJson = {};
    this.filterChanged = false;
    this.pageNo = 1;
    this.pageSize = 20;
    this.count = 0;
    this.isFetching = false;
    this.lastScrollLeft = 0;
    this.lastScrollTop = 0;
    this.isDropdownClick = false;
    this.filterkey = "ALL";
    this.isInitialized = false;
    this.isAxpertFlutter = !this.isNullOrEmpty(armToken);
    this.cardParams = {};
    this.cardFlds = {};
    this.processName = "";
    this.keyField = "";
    this.keyValue = "";
    this.taskCompleted = false;
    this.taskId = "";
    this.userType = "GUEST";
    this.isTaskEditable = false;
    this.currentElem = null;
    this.taskStatus = "";
    this.currentIndex = 1;
    this.stepHtml = `
                <div class="step">
                    <div>
                        <div class="circle d-none">
                            <i class="fa fa-check"></i>
                            <span class="Emp-steps-counts">{{sno}}</span>
                        </div>
                        <div class="line"></div>
                    </div>
                    <div class="Task-process-wrapper">
                        {{groupNameHtml}}
                        {{taskCaptionHtml}}
                    </div>
                </div>`;
    this.groupNameHtml = `
                <div class="title">
                    <a href="#">{{taskgroupname}}</a>
                        <span data-groupname="{{taskgroupname}}" class="Process-flow accordion-icon rotate">
                        <span  class="material-icons material-icons-style material-icons-2">chevron_right</span>
                    </span>
                </div>`;
    this.taskCaptionHtml = `<div class="process-sub-flow" data-groupname="{{taskgroupname}}">
                <div class="Task-process-list vertical-steps status-{{taskstatus}}" data-indexno=''{{indexno}}'' onclick="axProcessObj.openTask(this, ''{{taskname}}'', ''{{tasktype}}'', ''{{transid}}'', ''{{keyfield}}'', ''{{keyvalue}}'', ''{{recordid}}'', ''{{taskid}}'', ''{{indexno}}'',''{{hlink_transid}}'',''{{hlink_params}}'',''{{processname}}'');" data-taskid="{{taskid}}" data-tasktype="{{tasktype}}" data-transid="{{transid}}" data-recordid="{{recordid}}">
                    <a href="#">{{taskname}}</a>
                </div>
            </div>`;
    this.bulkTaskRowHtml = `
            <div class="table align-middle  fs-6 gy-5 mb-0 dataTable no-footer task-listing-card">
                
                
                            <div class="d-flex flex-column task-name">
                            <div class="d-flex">
                                <input type="checkbox" value="" class="form-check-input task-list-checkbox my-auto" data-taskid="{{taskid}}" >
                                <a href="javascript:void(0)"  class="text-gray-800 fw-bolder fs-6 task-title pt-0 pb-2 px-0" title="{{displaytitle}}"><span href="javascript:void(0)"><span class="material-icons material-icons-style material-icons-1 display-icon task-listing-icons">{{displayicon}}</span>{{displaytitle}}</span></a>
                                </div><div class="task-subtitle">{{displaycontent}}</div>
                            </div>
                    
                            <div class="d-flex flex-row task-process gap-5">
                                <a href="javascript:void(0)" class="d-flex text-gray-800 task-assignedBy my-auto mb-1 gap-2" title="Assigned By"><span class="material-icons material-icons-style p-0">person</span><span class="p-0"> {{fromuser}}</span></a>
                                <a href="javascript:void(0)" title="Assigned On" class="d-flex text-gray-800 mb-1 task-date my-auto gap-2"><span class="material-icons material-icons-style p-0">today</span><span class="p-0"> {{eventdatetime}}</span></a>
                            </div>
                                        
            
            </div>`;
    this.horizontalStepHtml = `<li class="{{taskstatus}}">
                                    <a href="javascript:void(0)" onclick="axProcessObj.openTask(this, ''{{taskname}}'', ''{{tasktype}}'', ''{{transid}}'', ''{{keyfield}}'', ''{{keyvalue}}'', ''{{recordid}}'', ''{{taskid}}'', ''{{indexno}}'',''{{hlink_transid}}'',''{{hlink_params}}'',''{{processname}}'');" data-taskid="{{taskid}}" data-tasktype="{{tasktype}}" data-transid="{{transid}}" data-recordid="{{recordid}}" data-taskname="{{taskname}}" data-indexno=''{{indexno}}'' class="horizontal-steps {{taskstatus}}">
                                        <span class="circle">{{sno}}</span>
                                        <span class="label">{{taskname}}</span>
                                    </a>
                                </li>`;
    this.dataSources = [];
    this.processFlowObj = {};
    this.processProgressObj = {};
    this.getUrlParams();
    this.horizontalFlow = _horizontalFlow;
    this.autoLoadNextTask = _autoLoadNextTask;
    this.isScrollAtBottomWithinDiv = this.isScrollAtBottomWithinDiv.bind(this);
    this.fetchProcessList = this.fetchProcessList.bind(this);
    this.activeFilter = {
      type: null, // TEAM / ADVANCED / INBOX
      value: null, // TeamAll / Approved / Open Tasks
    };
    this.processVars = {
      plistTbIcons: [
        "add_task",
        "receipt_long",
        "post_add",
        "library_books",
        "free_cancellation",
        "published_with_changes",
      ],
      plistCols: {
        taskName: {
          caption: "Task Name",
          hidden: false,
        },
      },
      pStatus: {
        approve: {
          badgeColor: "badge-light-success",
          bgColor: "bg-light-success",
          borderColor: "border-light-success",
          color: "bg-success",
          iconColor: "text-success",
        },
        approved: {
          badgeColor: "badge-light-success",
          bgColor: "bg-light-success",
          borderColor: "border-light-success",
          color: "bg-success",
          iconColor: "text-success",
        },
        check: {
          badgeColor: "badge-light-custom-checked",
          bgColor: "bg-light-custom-checked",
          borderColor: "border-light-custom-checked",
          color: "bg-custom-checked",
          iconColor: "text-custom-checked",
        },
        checked: {
          badgeColor: "badge-light-custom-checked",
          bgColor: "bg-light-custom-checked",
          borderColor: "border-light-custom-checked",
          color: "bg-custom-checked",
          iconColor: "text-custom-checked",
        },
        made: {
          badgeColor: "badge-light-primary",
          bgColor: "bg-light-primary",
          borderColor: "border-light-primary",
          color: "bg-primary",
        },
        make: {
          badgeColor: "badge-light-primary",
          bgColor: "bg-light-primary",
          borderColor: "border-light-primary",
          color: "bg-primary",
        },
        rejected: {
          badgeColor: "badge-light-danger",
          bgColor: "bg-light-danger",
          borderColor: "border-light-danger",
          color: "bg-danger",
        },
        returned: {
          badgeColor: "badge-light-warning",
          bgColor: "bg-light-warning",
          borderColor: "border-light-warning",
          color: "bg-warning",
        },
      },
    };
    this.toolbarDrawerHTML = `<div class="Tkts-toolbar-Right">
                                <button id="" type="submit" class="btn btn-sm btn-icon btn-primary btn-active-primary btn-custom-border-radius d-none">
                                    <span class="material-icons material-icons-style material-icons-2">add_task</span>
                                </button>
                                <button type="submit" class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm tb-btn btn-sm" onclick="axProcessObj.taskFilter(''reset'')" id="reset">
                                    <span class="material-icons material-icons-style material-icons-2">refresh</span>
                                </button>
                                <button type="submit" id="" class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm  tb-btn btn-sm">
                                    <span class="material-icons material-icons-style material-icons-2">history_toggle_off</span>
                                </button>
                            </div>`;
    this.annHTML = `<div class="menu-item px-3">
                <a class="menu-link px-3 border-bottom" href="javascript:void(0);" data-newtstruct>
                    <span class="symbol symbol-30px symbol-circle me-5">
                        <span class="symbol-label bg-primary text-white fw-normal fs-3 material-icons"></annIcon></span>
                    </span>
                    <span class="fw-normal addCaption"></annCaption></span>
                </a>
            </div>`;
    this.allTskHTML = `<div class="custom-menu-item px-3">
                <span class="custom-menu-link px-3 border-bottom">
                    <span class="form-check form-check-custom form-check-solid me-2">
                        <input class="form-check-input h-25px w-25px menu-task" type="checkbox" checked="checked"/>
                    </span>
                    <span class="symbol symbol-30px symbol-circle me-2">
                        <span class="symbol-label bg-light-primary text-primary fw-normal fs-3 material-icons border border-light-primary"></annIcon></span>
                    </span>
                    <span class="fw-normal menu-task-text"></annCaption></span>
                </span>
            </div>`;
    this.calledFrom = "";
    this.getProcessUserType();
  }
  getProcessUserType() {
    let _this = this,
      data = {},
      url = "";
    url = "../../aspx/AxPEG.aspx/AxGetProcessUserType";
    data = { processName: this.processName };
    this.callAPI(url, data, false, (result) => {
      if (result.success) {
        let json = JSON.parse(result.response);
        if (json.d == "Error in ARM connection.") {
          showAlertDialog("error", appGlobalVarsObject.lcm[572]);
          return;
        } else if (json.d.startsWith("<!DOCTYPE HTML PUBLIC ")) {
          showAlertDialog("error", appGlobalVarsObject.lcm[572]);
          return;
        }
        let dataResult = _this.dataConvert(json, "ARM");
        dataResult.every((rowData) => {
          if (rowData.tasktype?.toUpperCase() == "APPROVE") {
            this.userType = "APPROVER";
            return false;
          }
          if (rowData.tasktype?.toUpperCase() == "MAKE") {
            this.userType = "MAKER";
            return false;
          }
          return true;
        });
      }
    });
  }
  getNextTaskInProcess() {
    var nextTask = false;
    if (!this.autoLoadNextTask) return nextTask;
    let _this = this,
      data = {},
      url = "";
    url = "../aspx/AxPEG.aspx/AxGetNextTaskInProcess";
    data = { processName: this.processName, keyValue: this.keyValue };
    this.callAPI(url, data, false, (result) => {
      if (result.success) {
        let json = JSON.parse(result.response);
        let dataResult = _this.dataConvert(json, "ARM");
        if (dataResult.length > 0) {
          let rowData = dataResult[0];
          if (this.horizontalFlow && rowData.nexttasktype != "Current Process")
            nextTask = false;
          if ("URLSearchParams" in window) {
            nextTask = true;
            var searchParams = new URLSearchParams(window.location.search);
            searchParams.set("keyfield", rowData.keyfield);
            searchParams.set("keyvalue", rowData.keyvalue);
            searchParams.set("taskid", rowData.taskid);
            searchParams.set("target", "");
            window.location.search = searchParams.toString();
          }
        } else {
          //Load homepage
          callParentNew("LoadIframe(loadhomepage)", "function");
          nextTask = true;
        }
      }
    });
    return nextTask;
  }
  showProcessTree() {
    if (
      this.isNullOrEmpty(axProcessTreeObj) ||
      this.isUndefined(axProcessTreeObj)
    ) {
      axProcessTreeObj = new AxProcessTree(this.processName);
    }
    axProcessTreeObj.showProcessTree();
  }
  reloadProcess(recordId) {
    this.taskCompleted = true;
    ShowDimmer(true);
    let _this = this;
    let url = "../aspx/AxPEG.aspx/AxGetKeyValue";
    let data = { processName: this.processName, recordId: recordId };
    this.callAPI(url, data, false, (result) => {
      if (result.success) {
        let json = JSON.parse(result.response);
        let dataResult = _this.dataConvert(json, "ARM");
        _this.refreshProcess(dataResult[0].keyvalue);
      }
    });
  }
  refreshPage() {
    window.location.href = window.location.href;
  }
  refreshProcess(keyValue) {
    this.refreshPage();
    return;
    ShowDimmer(true);
    const params = new URLSearchParams(location.search);
    params.set("keyvalue", keyValue);
    window.history.replaceState(
      {},
      "",
      `${location.pathname}?${params.toString()}`,
    );
    document.querySelector("#process_centerpanel").classList.add("d-none");
    document.querySelector("#horizontal-processbar").classList.remove("d-none");
    let $rightIframe = document.querySelector("#rightIframe");
    $rightIframe.setAttribute("src", "");
    $rightIframe.classList.remove("d-none");
    //window.location.href = window.location.href;
    //this.dataSources = [];
    //this.processFlowObj = {};
    this.keyValue = keyValue;
    //this.init();
    if (this.horizontalFlow) this.showProgress();
    else this.showVerticalProgress();
    this.fetchProcessList("ProcessList", "TaskCompletion");
    //this.showVerticalProgress();
    //this.fetchProcessKeyValues("ProcessKeyValues");
  }
  hideDefaultCenterPanel() {
    document.querySelector("#process_centerpanel").classList.add("d-none");
    document.querySelector("#horizontal-processbar").classList.remove("d-none");
  }
  fetchProcessList() {
    // 🔥 HARD LOCK FILTER (PREVENT RESET)
    if (!this.filterkey) {
      console.warn("⚠️ filterkey was empty → restoring previous");
      this.filterkey = this.lastFilterKey || "ALL";
    } else {
      this.lastFilterKey = this.filterkey;
    }
    this.isFetching = true;
    ShowDimmer(true);
    const pageNo = this.pageNo || 1;
    const pageSize = this.pageSize || 20;
    const advancedFilters = [
      "approved",
      "returned",
      "rejected",
      "notifications",
    ];
    let dsName = "DS_AxpertInbox";
    let sqlParams = {
      uname: parent.mainUserName,
      filter:
        this.filterkey !== undefined &&
        this.filterkey !== null &&
        this.filterkey !== ""
          ? this.filterkey
          : "ALL",
      searchtext: this.searchtext || "",
    };
    // =========================
    // 🔥 TEAM
    // =========================
    if (this.filterkey === "TeamAll" || this.selectedTeamUser) {
      dsName = "DS_TeamAll";
      if (this.selectedTeamUser && this.selectedTeamUser !== "TeamAll") {
        sqlParams.filter = this.selectedTeamUser;
      } else {
        sqlParams.filter = "TeamAll";
      }
    }
    // =========================
    // 🔥 ADVANCED
    // =========================
    else if (advancedFilters.includes((this.filterkey || "").toLowerCase())) {
      dsName = "DS_AdvancedFilter";
    }
    // =========================
    // 🔥 INBOX (default)
    // =========================
    else {
      dsName = "DS_AxpertInbox";
    }
    const params = {
      adsNames: [dsName],
      refreshCache: false,
      sqlParams,
      props: { pageno: pageNo, pagesize: pageSize },
    };
    console.log("🚀 DS:", dsName);
    console.log("📦 PARAMS:", sqlParams);
    parent.GetDataFromAxList(
      params,
      (response) => {
        try {
          const parsed = JSON.parse(response);
          const rows = parsed?.result?.data?.[0]?.data || [];
          if (pageNo === 1) {
            window.masterTasks = [];
            window._ALL_TASKS = [];
            const container = document.getElementById("plistContent");
            if (container) container.innerHTML = "";
          }
          if (rows.length > 0) {
            window.masterTasks = window.masterTasks.concat(rows);
            window._ALL_TASKS = window._ALL_TASKS.concat(rows);
            this.tasksJson = rows;
            this.showProcessList();
            this.pageNo++;
          } else {
            this.showNoMoreRecords();
          }
        } catch (e) {
          console.error("Inbox parse error", e);
        } finally {
          this.isFetching = false;
          ShowDimmer(false);
          // ✅ CRITICAL FIX (keeps dropdown stable)
          //   updateDropdownLabel();
        }
      },
      () => {
        this.isFetching = false;
        ShowDimmer(false);
      },
    );
  }
  //         fetchProcessList() {
  //     this.isFetching = true;
  //     ShowDimmer(true);
  //     const pageNo = this.pageNo || 1;
  //     const pageSize = this.pageSize || 20;
  //     const advancedFilters = ["pending", "approved", "returned", "rejected", "notifications"];
  //     // 🔥 detect search mode
  //     const isSearch = this.currentDS === "ds_inboxsearch";
  //     const params = {
  //         adsNames: [
  //             this.currentDS
  //                 ? this.currentDS
  //                 : advancedFilters.includes((this.filterkey || "").toLowerCase())
  //                     ? "ds_advancedfilter"
  //                     : "DS_AxpertInbox"
  //         ],
  //         refreshCache: false,
  //         // 🔥 IMPORTANT FIX HERE
  //         sqlParams: this.isSearchMode
  //             ? {
  //                 username: parent.mainUserName,
  //                 searchtext: this.searchtext
  //             }
  //             : {
  //                 uname: parent.mainUserName,
  //                 filter: this.filterkey
  //             },
  //         props: { pageno: pageNo, pagesize: pageSize }
  //     };
  //     // ✅ DEBUG (must see this in console)
  //     console.log("🚀 DS:", params.adsNames[0]);
  //     console.log("📦 PARAMS:", params.sqlParams);
  //     parent.GetDataFromAxList(params, (response) => {
  //         try {
  //             const parsed = JSON.parse(response);
  //             const rows = parsed?.result?.data?.[0]?.data || [];
  //             if (pageNo === 1) {
  //                 window.masterTasks = [];
  //                 window._ALL_TASKS = [];
  //                 const container = document.getElementById("plistContent");
  //                 if (container) container.innerHTML = "";
  //             }
  //             if (rows.length > 0) {
  //                 window.masterTasks = window.masterTasks.concat(rows);
  //                 window._ALL_TASKS = window._ALL_TASKS.concat(rows);
  //                 this.tasksJson = rows;
  //                 this.showProcessList();
  //                 this.pageNo++;
  //             } else {
  //                 this.showNoMoreRecords();
  //             }
  //         } catch (e) {
  //             console.error("Inbox parse error", e);
  //         } finally {
  //             this.isFetching = false;
  //             ShowDimmer(false);
  //         }
  //     }, (err) => {
  //         this.isFetching = false;
  //         ShowDimmer(false);
  //     });
  // }

  // fetchProcessList() {
  //     const url = "../aspx/AxPEG.aspx/AxGetAllActiveTasks";
  //     const data = {
  //         pageNo: this.pageNo,
  //         pageSize: this.pageSize,
  //         filter: this.filterkey.toLocaleLowerCase()
  //     };
  //     this.callAPI(url, data, true, (result) => {
  //         if (result.success) {
  //             const json = JSON.parse(result.response);
  //             if (json.d === "Error in ARM connection.") {
  //                 ShowDimmer(false);
  //                showAlertDialog(''error'', appGlobalVarsObject.lcm[572]);
  //                 return;
  //             } else if (json.d.startsWith(''<!DOCTYPE HTML PUBLIC '')) {
  //                 ShowDimmer(false);
  //                 showAlertDialog(''error'', appGlobalVarsObject.lcm[572]);
  //                 return;
  //             }
  //             const dataResult = this.dataConvert(json, "ARM");
  //             this.tasksJson = dataResult.result.tasks || []; // Safeguard for empty tasks
  //             if (this.tasksJson.length > 0) {
  //                 this.showProcessList(); // Append new data
  //             } else {
  //                 this.showNoMoreRecords(); // Display "No more records" message
  //             }
  //             ShowDimmer(false);
  //         } else {
  //             ShowDimmer(false);
  //             showAlertDialog("error", "Failed to fetch tasks.");
  //         }
  //     });
  // }
  filterProcessList(reset) {
    if (reset) document.querySelector("#advTextSearch").value = "";
    var searchTerm = document.querySelector("#advTextSearch").value;
    let _this = this;
    if (!_this.inValid(searchTerm)) {
      searchTerm = searchTerm.toLowerCase();
      var filteredResults = axProcessObj.dataSources["ProcessList"].list.filter(
        function (item) {
          return item.displaytitle?.toLowerCase().includes(searchTerm);
        },
      );
      document.querySelectorAll(`#plistAccordion tr`).forEach((listItems) => {
        listItems.classList.add("d-none");
        listItems.classList.add("filterApplied");
      });
      if (filteredResults.length > 0) {
        filteredResults.forEach((filteredRow) => {
          document
            .querySelectorAll(
              `.filterApplied [data-taskid="${filteredRow.taskid}"]`,
            )
            .forEach((i) => {
              i?.closest("tr")?.classList.remove("d-none");
              i?.closest("tr")?.classList.remove("filterApplied");
            });
        });
      }
    } else {
      document.querySelectorAll(`.filterApplied`).forEach((filteredRow) => {
        filteredRow.classList.remove("d-none");
        filteredRow.classList.remove("filterApplied");
      });
    }
  }
  fetchProcessKeyValues(name) {
    let _this = this;
    let url = "../aspx/AxPEG.aspx/AxGetProcessKeyValues";
    let data = { processName: this.processName };
    this.callAPI(url, data, true, (result) => {
      if (result.success) {
        let json = JSON.parse(result.response);
        let dataResult = _this.dataConvert(json, "ARM");
        let dataArray = [];
        dataResult.forEach((item) => {
          dataArray.push({ id: item.keyvalue, text: item.keyvalue });
        });
        $("select#keyvalues-select")
          .select2({
            placeHolder: "Search...",
            data: dataArray,
          })
          .on("select2:select", function (e) {
            let keyValue = e.params.data.text;
            _this.refreshProcess(keyValue);
          })
          .on("select2:open", () => {
            $(this).find(".select2-search__field").focus();
          })
          .on("select2:close", () => {
            $(".searchBoxChildContainer.search").addClass("d-none");
          });
      }
    });
  }
  callAPI(url, data, async, callBack) {
    let _this = this;
    var xhr = new XMLHttpRequest();
    xhr.open("POST", url, async);
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    if (_this.isAxpertFlutter) {
      xhr.setRequestHeader("Authorization", `Bearer ${armToken}`);
      data["armSessionId"] = armSessionId;
    }
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
          callBack({ success: true, response: this.responseText });
        } else {
          _this.catchError(this.responseText);
          callBack({ success: false, response: this.responseText });
        }
      }
    };
    xhr.send(JSON.stringify(data));
  }
  catchError(error) {
    showAlertDialog("error", error);
  }
  showSuccess(message) {
    showAlertDialog("success", message);
  }
  dataConvert(data, type) {
    if (type == "AXPERT") {
      try {
        data = JSON.parse(data.d);
        if (typeof data.result[0].result.row != "undefined") {
          return data.result[0].result.row;
        }
        if (typeof data.result[0].result != "undefined") {
          return data.result[0].result;
        }
      } catch (error) {
        this.catchError(error.message);
      }
    } else if (type == "ARM") {
      try {
        if (!this.isAxpertFlutter) data = JSON.parse(data.d);
        if (data.result && data.result.success) {
          if (!this.isUndefined(data.result.data)) {
            return data.result.data;
          }
        } else {
          if (!this.isUndefined(data.result.message)) {
            this.catchError(data.result.message);
          }
        }
      } catch (error) {
        this.catchError(error.message);
      }
    }
    return data;
  }
  generateFldId() {
    return `fid${Date.now()}${Math.floor(Math.random() * 90000) + 10000}`;
  }
  isEmpty(elem) {
    return elem == "";
  }
  isNull(elem) {
    return elem == null || elem == "null";
  }
  isNullOrEmpty(elem) {
    return elem == null || elem == "null" || elem == "";
  }
  isUndefined(elem) {
    return typeof elem == "undefined";
  }
  inValid(elem) {
    return elem == null || typeof elem == "undefined" || elem == "";
  }
  showVerticalProgress(elem) {
    let _this = this,
      data = {},
      url = "";
    url = "../aspx/AxPEG.aspx/AxGetProcess";
    data = {
      processName: this.processName,
      keyField: this.keyField,
      keyValue: this.keyValue,
    };
    let elemTaskId = elem?.dataset?.taskid || this.taskId;
    this.callAPI(url, data, true, (result) => {
      if (result.success) {
        _this.hideDefaultCenterPanel();
        ShowDimmer(false);
        let json = JSON.parse(result.response);
        let dataResult = _this.dataConvert(json, "ARM");
        this.processProgressObj = {};
        dataResult.forEach((rowData, idx) => {
          let tempTaskType = rowData.tasktype.toUpperCase();
          if (["IF", "ELSE", "ELSE IF", "END"].indexOf(tempTaskType) == -1) {
            if (this.isNullOrEmpty(rowData.taskstatus) && rowData.indexno > 1) {
              rowData.taskstatus = "disabled";
              return;
            }
            if (this.isUndefined(this.processProgressObj[rowData.taskname])) {
              this.processProgressObj[rowData.taskname] = {};
              this.processProgressObj[rowData.taskname].group_name_html = "";
              this.processProgressObj[rowData.taskname].task_caption_html = "";
            }
            if (this.isNullOrEmpty(rowData.recordid)) {
              rowData.recordid = "0";
            }
            let taskGroup = this.processProgressObj[rowData.taskname];
            taskGroup.indexno = rowData.indexno;
            //taskGroup.group_name_html = Handlebars.compile(this.groupNameHtml)(rowData);
            taskGroup.task_caption_html += Handlebars.compile(
              this.taskCaptionHtml,
            )(rowData);
          }
        });
        document.querySelector("#procflow-steps").innerHTML = "";
        //if (this.isNullOrEmpty(this.keyValue))
        //    document.querySelector(''#process-ref'').innerText = '''';
        //else
        //    document.querySelector(''#process-ref'').innerText = `Identifier : ${this.keyValue}`.toUpperCase();
        let sno = 1;
        for (let [key, value] of Object.entries(this.processProgressObj)) {
        //   document
        //     .querySelector("#procflow-steps")
        //     .insertAdjacentHTML(
        //       "beforeend",
        //       ` ${this.stepHtml.replace("{{sno}}", sno).replace("{{groupNameHtml}}", value.group_name_html).replace("{{taskCaptionHtml}}", value.task_caption_html)} `,
        //     );
        const procflowSteps = document.querySelector("#procflow-steps");

if (procflowSteps) {
    procflowSteps.insertAdjacentHTML(
        "beforeend",
        `${this.stepHtml
            .replace("{{sno}}", sno)
            .replace("{{groupNameHtml}}", value.group_name_html)
            .replace("{{taskCaptionHtml}}", value.task_caption_html)}`
    );
}
          sno++;
        }
        ShowDimmer(false);
        //let activeTask = document.querySelector(''.status-active'');
        //if (!this.isUndefined(this.taskId) && !this.isNullOrEmpty(this.taskId)) {
        //    ShowDimmer(true);
        //    document.querySelector(`.Task-process-list[data-taskid="${this.taskId}"]`).click();
        //}
        //else if (!this.isUndefined(this.transId) && !this.isNullOrEmpty(this.transId)) {
        //    ShowDimmer(true);
        //    document.querySelector(`.Task-process-list[data-transid="${this.transid}"][data-tasktype="Make"]`).click();
        //}
        //else if (this.isNull(activeTask)) {
        //    ShowDimmer(true);
        //    document.querySelector(''.Task-process-list'').click();
        //}
        //else {
        //    ShowDimmer(true);
        //    activeTask.click();
        //}
        if (this.taskCompleted) {
          this.taskCompleted = false;
          let nextTask = this.getNextTaskInProcess();
          if (!nextTask) {
            if (
              !this.inValid(
                document.querySelector(".vertical-steps.status-Active"),
              )
            ) {
              this.calledFrom = "ProgressBar";
              document.querySelector(".vertical-steps.status-Active")?.click();
              document
                .querySelector(".vertical-steps.status-Active")
                ?.scrollIntoView();
              elemTaskId = document.querySelector(
                ".vertical-steps.status-Active",
              ).dataset?.taskid;
            } else if (
              !this.inValid(document.querySelector(".vertical-steps"))
            ) {
              this.calledFrom = "ProgressBar";
              document.querySelector(".vertical-steps")?.click();
              document.querySelector(".vertical-steps")?.scrollIntoView();
              elemTaskId =
                document.querySelector(".vertical-steps").dataset?.taskid;
            }
          }
        } else if (!this.inValid(this.taskId)) {
          this.calledFrom = "ProgressBar";
          let selector = `.vertical-steps[data-taskid="${this.taskId}"]`;
          if (!this.inValid(document.querySelector(selector))) {
            document.querySelector(selector)?.click();
            document.querySelector(selector)?.scrollIntoView();
            if (this.inValid(elemTaskId))
              elemTaskId = document.querySelector(selector).dataset?.taskid;
          }
          this.target = null;
        } else if (!this.inValid(this.target)) {
          this.calledFrom = "ProgressBar";
          let selector = `.vertical-steps[data-taskname="${this.target}"]`;
          if (!this.inValid(document.querySelector(selector))) {
            document.querySelector(selector)?.click();
            document.querySelector(selector)?.scrollIntoView();
            if (this.inValid(elemTaskId))
              elemTaskId = document.querySelector(selector).dataset?.taskid;
          } else if (!this.inValid(document.querySelector(".vertical-steps"))) {
            this.calledFrom = "ProgressBar";
            document.querySelector(".vertical-steps")?.click();
            document.querySelector(".vertical-steps")?.scrollIntoView();
            if (this.inValid(elemTaskId))
              elemTaskId =
                document.querySelector(".vertical-steps").dataset?.taskid;
          }
          this.target = null;
        }
        if (!_this.inValid(elemTaskId)) {
          _this.setActiveInList(elemTaskId);
        }
        $(".accordion-icon").click(function () {
          let groupname = $(this).attr("data-groupname");
          $(this).toggleClass("rotate");
          $(`.process-sub-flow[data-groupname="${groupname}"]`).toggle();
        });
      }
    });
  }
  showHorizontalProcessFlow() {
    let sno = 1;
    const container = document.querySelector("#horizontal-processbar");
    if (container) {
      container.innerHTML = "";
    }
    this.dataSources["Process"].forEach((rowData, idx) => {
      let tempTaskType = rowData.tasktype.toUpperCase();
      if (["IF", "ELSE", "ELSE IF", "END"].indexOf(tempTaskType) == -1) {
        if (this.isNullOrEmpty(rowData.taskstatus) && rowData.indexno > 1) {
          rowData.taskstatus = "disabled";
        } else if (
          ["APPROVED", "REJECTED", "RETURNED", "CHECKED", "MADE"].indexOf(
            rowData.taskstatus?.toUpperCase(),
          )
        ) {
          rowData.taskstatus = "completed";
        }
        if (this.taskId == rowData.taskid) {
          rowData.taskstatus = "active";
        }
        if (this.isNullOrEmpty(rowData.recordid)) {
          rowData.recordid = "0";
        }
        rowData.sno = sno;
        sno++;
        const processbar = document.querySelector("#horizontal-processbar");
        // document.querySelector(''#horizontal-processbar'').insertAdjacentHTML("beforeend", ` ${Handlebars.compile(this.horizontalStepHtml)(rowData)} `);
        if (processbar) {
          processbar.insertAdjacentHTML(
            "beforeend",
            ` ${Handlebars.compile(this.horizontalStepHtml)(rowData)} `,
          );
        }
      }
    });
    //for (let [key, value] of Object.entries(this.processProgressObj)) {
    //    document.querySelector(''#procflow-steps'').insertAdjacentHTML("beforeend", ` ${this.horizontalStepHtml} `);
    //}
    ShowDimmer(false);
  }

  openTask(
    elem,
    taskName,
    taskType,
    transId,
    keyField,
    keyValue,
    recordId,
    taskId,
    indexNo,
    hLinkPage,
    hLinkParam,
    processName,
    messageType,
    calledFrom,
  ) {
    const pegIframe = document.getElementById("process_iframe");
    if (pegIframe) {
      pegIframe.classList.remove("d-none");
      // pegIframe.src = url;
    }
    const stepperContainer = document.querySelector("#Process-stepper");
    if (stepperContainer) {
      stepperContainer.classList.remove("d-none"); // ✅ SHOW parent
    }
    document.getElementById("Tickets_details_view").innerHTML = "";
    ShowDimmer(true);
    this.currentIndex = parseInt(indexNo);
    this.keyField = keyField;
    this.keyValue = keyValue || this.keyValue;
    this.taskId = taskId;
    this.processName = processName;
    this.taskType = taskType;
    if (!this.inValid(calledFrom)) this.calledFrom = calledFrom;
    callParentNew("AxNotifyMsgId=", "");
    if (
      !this.inValid(messageType) &&
      (messageType.toLowerCase() == "message" ||
        messageType.toLowerCase() == "form notification" ||
        messageType.toLowerCase() == "periodic notification")
    )
      taskType = messageType;
    switch (taskType.toUpperCase()) {
      case "MAKE":
        document.querySelector("#pd_timeline").classList.remove("d-none");
        this.showProgressNew();
        this.openTstruct(taskName, transId, keyField, keyValue, recordId);
        break;
      case "CHECK":
        document.querySelector("#pd_timeline").classList.remove("d-none");
        this.showProgressNew();
        this.openProcessTask(taskName, taskType, taskId);
        break;
      case "APPROVE":
        document.querySelector("#pd_timeline").classList.remove("d-none");
        this.showProgressNew();
        this.openProcessTask(taskName, taskType, taskId);
        break;
      case "FORM NOTIFICATION":
      case "PERIODIC NOTIFICATION":
      case "MESSAGE":
        document.querySelector("#pd_timeline").classList.add("d-none");
        this.openMessageLink(hLinkPage, hLinkParam);
        break;
      case "CACHED SAVE":
        document.querySelector("#pd_timeline").classList.add("d-none");
        this.openMessageLinkCachedSave(hLinkPage, hLinkParam, taskId);
        break;
      case "EXPORT":
        this.DownloadExportFile(hLinkParam);
        break;
      default:
        document.querySelector("#pd_timeline").classList.add("d-none");
        let _errorTitle = $(elem).text().trim();
        let _errorMessage = $(elem).closest(".row").find(".taskcontent").text();
        this.showErrorModal(_errorTitle, _errorMessage);
        ShowDimmer(false);
        break;
    }
    document
      .querySelector("#horizontal-processbar")
      ?.style.setProperty("display", "-webkit-inline-box", "important");
  }
  showErrorModal(title, message) {
    $("#dynamicErrorModal").remove();
    let modalHtml = `
            <div class="modal fade" id="dynamicErrorModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                <div class="modal-header bg-danger-- text-white--">
                    <h5 class="modal-title">${title}</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">${message}</div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
                </div>
            </div>
            </div>`;
    $("body").append(modalHtml);
    let modal = new bootstrap.Modal(
      document.getElementById("dynamicErrorModal"),
    );
    modal.show();
  }

  DownloadExportFile(eLink) {
    if (
      eLink != "" &&
      (eLink.startsWith("http:") || eLink.startsWith("https:"))
    ) {
      let fileUrl = eLink;
      let fileName = eLink.substring(eLink.lastIndexOf("/") + 1);
      const lastUnderscoreIndex = fileName.lastIndexOf("_");
      const filenameWithoutExtension = fileName.substring(
        0,
        lastUnderscoreIndex,
      );
      const fileExtension = fileName.substring(fileName.lastIndexOf("."));
      const finalFilename = filenameWithoutExtension + fileExtension;
      var anchor = document.createElement("a");
      anchor.href = fileUrl;
      anchor.download = finalFilename;
      document.body.appendChild(anchor);
      anchor.click();
      setTimeout(function () {
        setTimeout(() => {
          document.body.removeChild(anchor);
        }, 0);
      }, 500);
      ShowDimmer(false);
    } else {
      let filePath = eLink.substring(0, eLink.lastIndexOf("\\") + 1);
      let fileName = eLink.substring(eLink.lastIndexOf("\\") + 1);
      $.ajax({
        type: "POST",
        url: "../../WebService.asmx/LoadExportFileToScript",
        cache: false,
        async: false,
        contentType: "application/json;charset=utf-8",
        data: JSON.stringify({
          filePath: filePath,
          fileName: fileName,
        }),
        dataType: "json",
        success: (data) => {
          if (data.d && data.d != "") {
            var fileUrl = data.d;
            var fileName = data.d.substring(data.d.lastIndexOf("/") + 1);
            var anchor = document.createElement("a");
            anchor.href = fileUrl;
            anchor.download = fileName;
            document.body.appendChild(anchor);
            anchor.click();
            /* document.body.removeChild(anchor);*/
            setTimeout(function () {
              setTimeout(() => {
                document.body.removeChild(anchor);
              }, 0);
            }, 500);
            ShowDimmer(false);
          } else ShowDimmer(false);
        },
        error: (error) => {
          ShowDimmer(false);
        },
        failure: (error) => {
          ShowDimmer(false);
        },
      });
    }
  }
  setActiveInList(elemTaskId) {
    document
      .querySelectorAll(`[data-taskid="${elemTaskId}"]`)
      .forEach((elem) => {
        if (elem.classList.contains("Procurement-list")) {
          document
            .querySelector(".Procurement-list-wrap.active")
            ?.classList.remove("active");
          elem.closest(`.Procurement-list-wrap`)?.classList.add("active");
        }
        if (elem.classList.contains("horizontal-steps")) {
          document.querySelectorAll(".horizontal-steps").forEach((step) => {
            step.closest("li")?.classList.remove("Active");
          });
          elem.closest(`li`)?.classList.add("Active");
          //elem.scrollIntoView();
        }
      });
  }
  openRightSideCards(taskname, keyvalue) {
    ShowDimmer(true);
    /* Variables from mainpage */
    files.js.push("/../ThirdParty/lodash.min.js?v=1");
    files.js.push("/../ThirdParty/deepdash.min.js");
    files.js.push("/../Js/handlebars.min.js?v=2");
    files.js.push("/../Js/handleBarsHelpers.min.js");
    files.js.push("/../ThirdParty/Highcharts/highcharts-3d.js");
    files.js.push("/../ThirdParty/Highcharts/highcharts-more.js");
    files.js.push("/../ThirdParty/Highcharts/highcharts.js");
    files.js.push("/../ThirdParty/Highcharts/highcharts-exporting.js");
    files.js.push("/../Js/high-charts-functions.min.js?v=20");
    files.js.push("/../Js/AxInterface.min.js?v=19");
    files.js.push(
      "/../ThirdParty/DataTables-1.10.13/media/js/jquery.dataTables.js",
    );
    files.js.push(
      "/../ThirdParty/DataTables-1.10.13/media/js/dataTables.bootstrap.js",
    );
    files.js.push(
      "/../ThirdParty/DataTables-1.10.13/extensions/Extras/moment.min.js",
    );
    files.css.push("/../ThirdParty/fullcalendar/lib/main.min.css");
    files.js.push("/../ThirdParty/fullcalendar/lib/main.min.js");
    if (cardsDashboardObj.isMobile) {
      files.js.push(
        "/../ThirdParty/jquery-ui-touch-punch-master/jquery.ui.touch-punch.min.js",
      );
    }
    if (cardsDashboardObj.enableMasonry) {
      files.js.push("/../ThirdParty/masonry/masonry.pkgd.min.js");
    }
    //files.js.push(`/HTMLPages/js/axpertFlutterCustomDashboard.js?v=2`);
    if (
      document
        .getElementsByTagName("body")[0]
        .classList.contains("btextDir-rtl")
    ) {
      cardsDashboardObj.dirLeft = false;
    }
    loadAndCall({
      files: files,
      callBack: () => {
        $(function () {
          //deepdash(_);
          $.ajax({
            url: "../aspx/AxPEG.aspx/AxGetCardsData",
            type: "POST",
            cache: false,
            async: true,
            data: JSON.stringify({
              processName: axProcessObj.processName || "",
              taskName: taskname || "",
              keyValue: keyvalue || "",
            }),
            dataType: "json",
            contentType: "application/json",
            success: (data) => {
              if (data.d && data.d != "") {
                let result = JSON.parse(data.d);
                if (result?.result?.success) {
                  document
                    .querySelector("#PROFLOW_Right_Last")
                    .classList.remove("d-none");
                  var rightclassList =
                    document.querySelector("#PROFLOW_Right").classList;
                  rightclassList.remove("col-md-9", "col-xl-9");
                  rightclassList.add("col-md-7", "col-xl-7");
                } else {
                  document
                    .querySelector("#PROFLOW_Right_Last")
                    .classList.add("d-none");
                  var rightclassList =
                    document.querySelector("#PROFLOW_Right").classList;
                  rightclassList.add("col-md-9", "col-xl-9");
                  rightclassList.remove("col-md-7", "col-xl-7");
                  return;
                }
                cardsData.value = JSON.stringify(result.result.cards);
                cardsDesign.value = "";
                //xmlMenuData = result.menu;
                //taskcards = JSON.parse(result.taskcards).result[0].result.row;
                //if (taskcards != '''') {
                //    taskcards = taskcards.map(item => item.cardname);
                //}
              } else {
                showAlertDialog(
                  "error",
                  "Error while loading cards dashboard..!!",
                );
                return;
              }
              if (xmlMenuData != "") {
                xmlMenuData = xmlMenuData.replace(/&apos;/g, "''");
                var xml = parseXml(xmlMenuData);
                var xmltojson = xml2json(xml, "");
                menuJson = JSON.parse(xmltojson);
              }
              appGlobalVarsObject._CONSTANTS.menuConfiguration = $.extend(
                true,
                {},
                appGlobalVarsObject._CONSTANTS.menuConfiguration,
                {
                  menuJson: menuJson,
                },
              );
              // try {
              appGlobalVarsObject._CONSTANTS.cardsPage = $.extend(
                true,
                {},
                appGlobalVarsObject._CONSTANTS.cardsPage,
                {
                  setCards: true,
                  cards: (
                    JSON.parse(
                      cardsData.value !== ""
                        ? ReverseCheckSpecialChars(cardsData.value)
                        : "[]",
                      function (k, v) {
                        try {
                          return typeof v === "object" ||
                            isNaN(v) ||
                            v.toString().trim() === ""
                            ? v
                            : typeof v == "string" &&
                                (v.startsWith("0") || v.startsWith("-"))
                              ? parseFloat(v, 10)
                              : JSON.parse(v);
                        } catch (ex) {
                          return v;
                        }
                        //0 & - starting with does not gets parsed in json.parse
                        //json.parse is used because it porcess int, float and boolean together
                      },
                    ) || []
                  ).map((arr) =>
                    _.mapKeys(arr, (value, key) =>
                      key.toString().toLowerCase(),
                    ),
                  ),
                  design: (
                    JSON.parse(
                      cardsDesign.value !== "" ? cardsDesign.value : "[]",
                      function (k, v) {
                        try {
                          return typeof v === "object" ||
                            isNaN(v) ||
                            v.toString().trim() === ""
                            ? v
                            : typeof v == "string" &&
                                (v.startsWith("0") || v.startsWith("-"))
                              ? parseFloat(v, 10)
                              : JSON.parse(v);
                        } catch (ex) {
                          return v;
                        }
                      },
                    ) || []
                  ).map((arr) =>
                    _.mapKeys(arr, (value, key) =>
                      key.toString().toLowerCase(),
                    ),
                  ),
                  enableMasonry: cardsDashboardObj.enableMasonry,
                  staging: {
                    iframes: ".splitter-wrapper",
                    cardsFrame: {
                      div: ".cardsPageWrapper",
                      cardsDiv: ".cardsPlot",
                      cardsDesigner: ".cardsDesigner",
                      cardsDesignerToolbar: ".designer",
                      editSaveButton: ".editSaveCardDesign",
                      icon: "span.material-icons",
                      divControl: "#arrangeCards",
                    },
                  },
                },
              );
              var lcm = appGlobalVarsObject.lcm;
              var tempaxpertUIObj = $.axpertUI.init({
                isHybrid: appGlobalVarsObject._CONSTANTS.isHybrid,
                isMobile: cardsDashboardObj.isMobile,
                compressedMode: appGlobalVarsObject._CONSTANTS.compressedMode,
                dirLeft: cardsDashboardObj.dirLeft,
                axpertUserSettings: {
                  settings: appGlobalVarsObject._CONSTANTS.axpertUserSettings,
                },
                cardsPage: appGlobalVarsObject._CONSTANTS.cardsPage,
              });
              appGlobalVarsObject._CONSTANTS.cardsPage =
                tempaxpertUIObj.cardsPage;
              ShowDimmer(false);
            },
            error: (error) => {
              ShowDimmer(false);
              showAlertDialog(
                "error",
                "Error while loading cards dashboard..!!",
              );
              return;
            },
            failure: (error) => {
              ShowDimmer(false);
              showAlertDialog(
                "error",
                "Error while loading cards dashboard..!!",
              );
              return;
            },
          });
          //start cards dasboard Init
          // } catch (ex) {
          //     showAlertDialog("error", ex.Message);
          // }
        });
        //axTimeLineObj = new ProcessTimeLine();
        //axTimeLineObj.keyvalue = urlParams.get(''keyvalue'');
        //axTimeLineObj.getTimeLineData();
      },
    });
    //End cards dashboard Code
  }
  isEditableTask(taskName, keyValue) {
    var isEditable = false;
    let _this = this;
    let url = "../../aspx/AxPEG.aspx/AxGetEditableTask";
    let data = {
      processName: this.processName,
      taskName: taskName,
      keyValue: keyValue,
      indexNo: this.currentIndex,
    };
    this.callAPI(url, data, false, (result) => {
      if (result.success) {
        let json = JSON.parse(result.response);
        let dataResult = _this.dataConvert(json, "ARM");
        if (dataResult?.length > 0) {
          let rowData = dataResult[0];
          if (rowData?.editable == "T") isEditable = true;
        }
      }
    });
    return isEditable;
  }
  openTstruct(taskName, transId, keyField, keyValue, recordId) {
    ShowDimmer(true);
    let isProcess = this.userType == "APPROVER" ? "&fromprocess=true" : "";
    let isPegEdit = "";
    if (
      !this.inValid(this.keyValue) &&
      this.keyValue != "NA" &&
      (document.querySelector(
        `[data-tasktype="Make"][data-transid="${transId}"][data-recordid="0"]`,
      ) == null ||
        this.currentElem?.classList.contains("completed"))
    ) {
      var isEditable = this.isEditableTask(taskName, this.keyValue);
      isPegEdit = `&ispegedit=${isEditable.toString()}`;
      if (isEditable === false) {
        this.isTaskEditable = false;
      } else {
        this.isTaskEditable = true;
      }
    }
    let url = `../../aspx/tstruct.aspx?transid=${transId}${isProcess}${isPegEdit}`;
    if (this.isNullOrEmpty(recordId)) recordId = "0";
    if (recordId != "0") url += `&act=load&recordid=${recordId}`;
    else {
      if (keyValue != "" && keyValue != "{{keyvalue}}") {
        url += `&act=open&${keyField}=${keyValue}`;
      } else {
        url += `&act=open&${this.keyField}=${this.keyValue}`;
      }
    }
    let processPanel = document.querySelector("#process_centerpanel");
    if (processPanel) {
      processPanel.classList.add("d-none");
    }

    let horizontalBar = document.querySelector("#horizontal-processbar");
    if (horizontalBar) {
      horizontalBar.classList.remove("d-none");
    }

    let $rightIframe = document.querySelector("#rightIframe");
    if ($rightIframe) {
      $rightIframe.classList.remove("d-none");
      $rightIframe.setAttribute("src", "");
      $rightIframe.setAttribute("src", url);
    } else {
      let processIframe = document.querySelector("#process_iframe");

      if (processIframe) {
        processIframe.setAttribute("src", url);
      }
    }
    ShowDimmer(false);
  }
  openMessageLink(pageType, pageParams) {
    ShowDimmer(true);
    if (pageType == "") {
      showAlertDialog("error", "Page name should not be empty.");
      return false;
    }
    let url = "";
    pageParams = pageParams.replace("^", "&");
    if (pageType.startsWith("i")) {
      pageType = pageType.substring(1);
      url = `../aspx/ivtoivload.aspx?ivname=${pageType}&${pageParams}`;
    } else if (pageType.startsWith("t")) {
      pageType = pageType.substring(1);
      url = `../aspx/tstruct.aspx?transid=${pageType}&${pageParams}`;
    } else if (pageType.startsWith("c")) {
      //pageType = pageType.substring(2);
      url = `../aspx/${pageParams}`;
    }
    document.querySelector("#process_centerpanel").classList.add("d-none");
    document.querySelector("#horizontal-processbar").classList.add("d-none");
    let $rightIframe = document.querySelector("#rightIframe");
    $rightIframe.classList.remove("d-none");
    $rightIframe.setAttribute("src", "");
    $rightIframe.setAttribute("src", url);
    if (pageType.startsWith("c")) ShowDimmer(false);
  }
  openMessageLinkCachedSave(pageType, pageParams, taskId) {
    ShowDimmer(true);
    if (pageType == "") {
      showAlertDialog("error", "Page name should not be empty.");
      return false;
    } else if (pageType == "null") {
      ShowDimmer(false);
      return false;
    }
    let url = "";
    pageParams = pageParams.replace("^", "&");
    if (pageType.startsWith("i")) {
      pageType = pageType.substring(1);
      url = `../aspx/iview.aspx?ivname=${pageType}&${pageParams}`;
    } else if (pageType.startsWith("t")) {
      pageType = pageType.substring(1);
      callParentNew("AxNotifyMsgId=", taskId);
      url = `../aspx/tstruct.aspx?transid=${pageType}&${pageParams}`;
    } else if (pageType.startsWith("c")) {
      //pageType = pageType.substring(2);
      url = `../aspx/${pageParams}`;
    }
    document.querySelector("#process_centerpanel").classList.add("d-none");
    document.querySelector("#horizontal-processbar").classList.add("d-none");
    let $rightIframe = document.querySelector("#rightIframe");
    $rightIframe.classList.remove("d-none");
    $rightIframe.setAttribute("src", "");
    $rightIframe.setAttribute("src", url);
    if (pageType.startsWith("c")) ShowDimmer(false);
  }
  newTstruct(transId, taskName) {
    ShowDimmer(true);
    document.querySelector("#process_centerpanel").classList.add("d-none");
    document.querySelector("#horizontal-processbar").classList.remove("d-none");
    let isProcess = this.userType == "APPROVER" ? "fromprocess=true&" : "";
    let url = `../aspx/tstruct.aspx?${isProcess}transid=${transId}&act=open`;
    let $rightIframe = document.querySelector("#rightIframe");
    $rightIframe.classList.remove("d-none");
    $rightIframe.setAttribute("src", "");
    $rightIframe.setAttribute("src", url);
    this.keyValue = "NA";
    if (this.horizontalFlow) this.showProgress();
    else this.showVerticalProgress();
    axProcessObj.openRightSideCards(taskName, "NA");
    ShowDimmer(false);
  }
  openBulkApprove() {
    let _this = this;
    try {
      let _this = this,
        data = {},
        url = "";
      url = "../../aspx/AxPEG.aspx/AxGetBulkApprovalCount";
      data = {};
      this.callAPI(url, data, true, (result) => {
        if (result.success) {
          let json = JSON.parse(result.response);
          json = JSON.parse(json.d);
          let allTasks = "";
          if (json.result.data.length > 0) {
            let allTasks = "";
            json = json.result.data;
            json.forEach((item) => {
              allTasks += `<div class="d-flex custom-menu-item px-4 py-2 border-1 border-bottom">
    <div class="symbol symbol-45px">
                            <span class="symbol-label">
                                <img alt="{{processname}}" class=" w-30px" src="../images/homepageicon/{{processname}}.png"
                                    onerror="this.onerror=null;this.src=''../../images/homepageicon/default.png'';">
                            </span></div>
                <div class="d-flex align-items-center " onclick="axProcessObj.openBulkApprovePopup(''${item.processname}'')">
                            <span class="custom-menu-link px-3">
                                <span class="fw-normal fs-5 menu-task-text">${item.processname} (${item.pendingapprovals})</span>
                            </span></div>
                            </div>`;
            });
            // if (document.getElementsByTagName("pd-allTasksNew") && document.getElementsByTagName("pd-allTasksNew").length > 0)
            //     document.getElementsByTagName("pd-allTasksNew")[0].outerHTML = allTasks;
            const comp = document.getElementsByTagName("pd-alltasksnew");
            if (comp.length > 0) {
              comp[0].innerHTML = allTasks;
              const menuEl = document.querySelector(
                ''[data-kt-menu="true"][data-id="pd_all_tasksNew"]'',
              );
              if (menuEl) {
                menuEl.classList.add("show");
              }
            }
          } else {
            showAlertDialog("warning", "No records available for approvals.");
            var menuElement = document.querySelector(
              ''[data-kt-menu="true"][data-id="pd_all_tasksNew"]'',
            );
            if (menuElement) {
              menuElement.classList.remove("show");
            }
          }
        }
      });
    } catch (error) {
      showAlertDialog("error", error.message);
    }
  }
  openBulkApprovePopup(processName) {
    // iframe
    const pegIframe = document.getElementById("process_iframe");
    if (pegIframe) {
      pegIframe.classList.add("d-none");
      // pegIframe.src = url;
    }
    // stepper
    const stepper = document.getElementById("Process-stepper");
    if (stepper) {
      stepper.classList.add("d-none");
    }
    let _this = this;
    document.querySelector("body").click();
    this.processName = processName;
    let modalObj = {
      id: `ldbApprove`,
    };
    modalObj.iFrameModalBody = `
                <div class="card-body d-flex  row">
                    <div class="w-100" id="Bulk-SelectALL-wrap">
                        <div class="form-check" style="position:absolute">
                        <input class="form-check-input task-list-checkbox" type="checkbox" id="select-all-checkbox">
                        <label class="form-check-label" for="select-all-checkbox">
                            Select All
                        </label>
                        </div>
                        <h4 style="margin-left: 295px; font-weight:bold">Bulk Approvals</h4>
                    </div>
                    <div class="w-100" id="BulkActiveList_Container">
                    </div>
                    <div class="w-100 mt-3">
                        <div class="approval-controls" data-tasktype="Approve">
                            <label class="form-label col-form-label mandatory">Bulk Approval Comments</label>
                            <div class="input-group">
                                <textarea data-tasktype="Approve" class="form-control"
                                    data-tasktype="Approve" id="BULKAPPROVEComments"></textarea>
                            </div>
                        </div>
                    </div>
                    <div>
                        <button  style="float:right " class="btn btn-primary btn-sm mt-2" type="button" onclick="axProcessObj.doBulkAction(''BULKAPPROVE'',''APPROVE'');">Bulk Approve</button>
                    </div>
                </div>`;
    modalObj.size = "lg";
    modalObj.opening = _this.bulkInit;
    try {
      let myModal = new BSModal(
        `modal_${modalObj.id}`,
        "",
        modalObj.iFrameModalBody,
        (opening) => {
          _this.bulkInit();
          ShowDimmer(false);
        },
        (closing) => {},
      );
      myModal.changeSize(modalObj.size || "fullscreen");
      myModal.hideHeader();
      myModal.hideFooter();
      myModal.showFloatingClose();
    } catch (error) {
      showAlertDialog("error", error.message);
    }
  }
  fetchBulkTasks(name) {
    let _this = this;
    let url = "../../aspx/AxPEG.aspx/AxGetBulkActiveTasks";
    let data = { processName: _this.processName, taskType: "Approve" };
    this.callAPI(url, data, true, (result) => {
      if (result.success) {
        let json = JSON.parse(result.response);
        let dataResult = _this.dataConvert(json, "ARM");
        _this.dataSources[name] = dataResult;
        this.showBulkTasks();
        ShowDimmer(false);
      } else {
        ShowDimmer(false);
      }
    });
  }
  bulkInit() {
    this.fetchBulkTasks("BulkTasks");
    const selectAllCheckbox = document.getElementById("select-all-checkbox");
    selectAllCheckbox?.addEventListener("change", function () {
      const checkboxes = document.querySelectorAll(".task-list-checkbox");
      checkboxes.forEach(function (checkbox) {
        checkbox.checked = selectAllCheckbox.checked;
      });
    });
  }
  showBulkTasks() {
    document.querySelector(`#BulkActiveList_Container`).innerHTML = "";
    if (
      this.dataSources["BulkTasks"]?.length == undefined ||
      this.dataSources["BulkTasks"].length == 0
    ) {
      if (this.isUndefined(parent.axProcessObj)) {
        document
          .querySelector(`#BulkActiveList_Container`)
          .insertAdjacentHTML("beforeend", ` ${this.noRecordsRowHtml} `);
      } else {
        document
          .querySelector(`#BulkActiveList_Container`)
          .insertAdjacentHTML("beforeend", ` ${this.processedRowHtml} `);
      }
    } else {
      this.dataSources["BulkTasks"].forEach((rowData, idx) => {
        var htmlText = Handlebars.compile(this.bulkTaskRowHtml)(rowData);
        document
          .querySelector(`#BulkActiveList_Container`)
          .insertAdjacentHTML("beforeend", ` ${htmlText} `);
      });
    }
  }
  doBulkAction(action, taskType) {
    let _this = this;
    ShowDimmer(true);
    let url = "../../aspx/AxPEG.aspx/AxDoBulkAction";
    let taskReason = "";
    let taskText = document.querySelector(`#${action}Comments`).value;
    var checkboxes = document.querySelectorAll(".task-list-checkbox:checked");
    if (checkboxes.length == 0) {
      showAlertDialog("Error", "Select atleast one task for approval.");
      ShowDimmer(false);
      return false;
    }
    if (taskText == "") {
      showAlertDialog("Error", "Bulk Approval Comments cannot be left empty.");
      ShowDimmer(false);
      return false;
    }
    let taskIds = [];
    checkboxes.forEach((item) => {
      taskIds.push(item.dataset.taskid);
    });
    taskIds = taskIds.join(",");
    let data = {
      action: action,
      taskId: taskIds,
      taskType: taskType,
      statusText: taskText,
      processName: this.processName,
    };
    this.callAPI(url, data, true, (result) => {
      ShowDimmer(false);
      if (result.success) {
        let json = JSON.parse(result.response);
        if (!_this.isAxpertFlutter) {
          json = JSON.parse(json.d);
        }
        if (json.result.success) {
          _this.showSuccess(json.result.message);
          if (!_this.isUndefined(parent.axProcessObj))
            parent.window.location.reload();
          else {
            setTimeout(function () {
              axProcessObj.refreshPage();
            }, 1000);
          }
        } else {
          _this.catchError(json.result.message);
        }
      }
    });
  }
  getUrlParams() {
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    this.keyField = urlParams.get("keyfield");
    this.keyValue = urlParams.get("keyvalue") || "NA";
    this.processName = urlParams.get("processname") || _processName;
    this.taskId = urlParams.get("taskid") || "";
    this.transId = urlParams.get("transid") || "";
    this.target = urlParams.get("target") || "";
    this.add = urlParams.get("add") || "T";
    this.leftPanel = urlParams.get("left") || "T";
    this.rightPanel = urlParams.get("right") || "T";
    this.showTree = urlParams.get("tree") || "T";
    this.bulkApproval = urlParams.get("bulk") || "T";
    this.horizontal = urlParams.get("horizontal") || "T";
    //document.querySelector(''#process-name span'').innerText = this.processName;
    _autoLoadNextTask =
      urlParams.get("autoloadnexttask") == "F" ? false : _autoLoadNextTask;
  }
  // openProcessTask(taskName, taskType, taskid) {
  //     ShowDimmer(true);
  //     //let url = `../aspx/htmlPages.aspx?loadcaption=Active Lists&processname=${this.processName}&keyfield=${this.keyField}&keyvalue=${this.keyValue}&taskname=${taskName}&tasktype=${taskType}&taskid=${taskid}`;
  //     let url = `../aspx/processflow.aspx?loadcaption=Active Lists&processname=${this.processName}&keyfield=${this.keyField}&keyvalue=${this.keyValue}&taskname=${taskName}&tasktype=${taskType}&taskid=${taskid}`;
  //     document.querySelector("#process_centerpanel").classList.add("d-none");
  //     document.querySelector("#horizontal-processbar").classList.remove("d-none");
  //     let $rightIframe = document.querySelector("#rightIframe");
  //     $rightIframe.classList.remove("d-none");
  //     $rightIframe.setAttribute("src", "");
  //     $rightIframe.setAttribute("src", url);
  //     //ShowDimmer(false);
  // };
  openProcessTask(taskName, taskType, taskid) {
    debugger;
    ShowDimmer(true);

    let url = `../../aspx/processflow.aspx?loadcaption=Active Lists&processname=${this.processName}&keyfield=${this.keyField}&keyvalue=${this.keyValue}&taskname=${taskName}&tasktype=${taskType}&taskid=${taskid}`;

    //     const stepper1 = document.querySelector("#process_centerpanel");
    // if (stepper1) {
    //     stepper1.classList.add(''d-none'')
    // }
    // const stepper2 = document.querySelector("#horizontal-processbar");
    // if (stepper2) {
    //     stepper2.classList.add(''d-none'')
    // }
    // document.querySelector("#process_centerpanel").classList.add("d-none");
    // document.querySelector("#horizontal-processbar").classList.remove("d-none");
    const filterBar = document.querySelector("#filterMessageBar");
    if (filterBar) {
      filterBar.style.top = "125px!important";
    }
    const rightPanel = document.querySelector("#PROFLOW_Right");

    rightPanel.innerHTML = `
            <iframe id="process_iframe"
                src="${url}"
                style="width:100%;height:600%;border:0;display:block;position: relative;
    top: 34px;
    z-index: 10;">
            </iframe>
            <div id="Tickets_details_view"></div>
        `;
  }
  openSearch() {
    if ($(".searchBoxChildContainer.search").hasClass("d-none")) {
      $(".searchBoxChildContainer.search").removeClass("d-none");
      $("select#keyvalues-select").select2("open");
    } else {
      $(".searchBoxChildContainer.search").addClass("d-none");
      $("select#keyvalues-select").select2("close");
    }
  }
  init() {
    try {
      ShowDimmer(true);
      var headerExtras = document.createElement("div");
      headerExtras.classList.add(..."d-flex gap-4".split(" "));
      //document.getElementsByTagName("toolbarDrawer")[0].replaceWith(headerExtras);
      headerExtras.innerHTML = this.toolbarDrawerHTML;
      if (this.userType == "APPROVER")
        document
          .querySelector("#kt_drawer_bulkApprove_button")
          ?.classList.remove("d-none");
      //KTDrawer.init();
      KTMenu.init();
      if (
        this.horizontal == "F" ||
        (typeof _horizontalFlow != "undefined" && !_horizontalFlow)
      ) {
        this.horizontalFlow = false;
      }
      if (this.add == "F") {
        document.querySelector("#pd_ann").classList.add("d-none");
      }
      if (this.leftPanel == "F") {
        document.querySelector("#PROFLOW_Left").classList.add("d-none");
        document.querySelector("#PROFLOW_Right")?.classList.add("right-only");
      }
      if (this.horizontalFlow) {
        if (this.leftPanel != "F") this.fetchProcessList("ProcessList");
        //this.showProgress();
      } else {
        document.querySelector("#PROFLOW_Left").classList.remove("d-none");
        document
          .querySelector("#PROFLOW_Left .card-header")
          .classList.add("d-none");
        document
          .querySelector("#PROFLOW_Left #PROFLOW-profile-container")
          .classList.remove("d-none");
        document
          .querySelector("#PROFLOW_Left #plistAccordion")
          .classList.add("d-none");
        document
          .querySelector("#PROFLOW_Right")
          ?.classList.remove("right-only");
        this.showVerticalProgress();
      }
      if (this.rightPanel == "F") {
        document.querySelector("#PROFLOW_Right_Last")?.classList.add("d-none");
        var rightclassList = document.querySelector("#PROFLOW_Right").classList;
        rightclassList.remove("col-md-7", "col-xl-7");
        rightclassList.add("col-md-9", "col-xl-9");
      }
      if (this.bulkApproval == "F") {
        document
          .querySelector("#kt_drawer_bulkApprove_button")
          ?.classList.add("d-none");
      }
      if (this.showTree == "F") {
        document.querySelector("#proFlw_Tree_button")?.classList.add("d-none");
      }
      document
        .querySelector("#pd_all_tasksNew")
        .addEventListener("click", () => {
          if (
            document.getElementsByTagName("pd-allTasksNew") &&
            document.getElementsByTagName("pd-allTasksNew").length > 0
          )
            axProcessObj.openBulkApprove();
        });
      document.querySelectorAll("#pd_timeline").forEach((item) => {
        KTMenu.getInstance(item).on("kt.menu.dropdown.show", function (item) {
          axProcessObj.showTimeLine();
        });
      });
      //if (!this.inValid(this.target)) {
      //    ShowDimmer(true);
      //    this.showProgress();
      //}
      // changes related to activelist
      // myDiv.addEventListener(''scroll'', this.scrollListener);
      if (!this.boundScrollListener) {
        this.boundScrollListener = this.scrollListener.bind(this);
      }
      const listDiv = document.getElementById("plistContent");
      if (listDiv) {
        listDiv.removeEventListener("scroll", this.boundScrollListener);
        listDiv.addEventListener("scroll", this.boundScrollListener);
      }
      this.toggleList();
      this.toggleCheckbox();
    } catch (error) {
      this.catchError(error.message);
    }
  }
  processNewNode(drawer = false) {
    let annContent = ``;
    if (
      axProcessObj.dataSources["ProcessList"].addnewnode &&
      axProcessObj.dataSources["ProcessList"].addnewnode.length > 0
    ) {
      annContent = Object.values(
        axProcessObj.dataSources["ProcessList"].addnewnode,
      )
        .map((annode) => {
          let ann = axProcessObj.annHTML;
          !this.isUndefined(annode.transid)
            ? (ann = ann.replace(
                "data-newtstruct",
                `onclick="axProcessObj.newTstruct(''${annode.transid}'',''${annode.taskname}'')"`,
              ))
            : "";
          ann = ann.replace("</annIcon>", annode.taskicon);
          ann = ann.replace("</annCaption>", annode.taskname || "");
          return ann;
        })
        .join("");
    } else {
      let ann = axProcessObj.annHTML;
      ann = ann.replace("</annIcon>", "playlist_remove");
      ann = ann.replace("</annCaption>", "No data");
      annContent = ann;
    }
    if (drawer) {
      return annContent;
    }
    if (!this.isUndefined(document.getElementsByTagName("anncontent")[0])) {
      document.getElementsByTagName("anncontent")[0].outerHTML = annContent;
    }
    // !this.isUndefined(document.getElementsByTagName("pd-annContent")[0]) && (document.getElementsByTagName("pd-annContent")[0].outerHTML = annContent);
  }
  formatEventDate(eventDateTime) {
    const safeDateTime = eventDateTime || "";
    const eventDate = safeDateTime
      ? new Date(safeDateTime.replace(/(\d{2})\/(\d{2})\/(\d{4})/, "$3-$2-$1"))
      : null;
    // ✅ CRITICAL FIX
    if (!eventDate || isNaN(eventDate)) {
      return "";
    }
    const today = new Date();
    const todayDateOnly = new Date(
      today.getFullYear(),
      today.getMonth(),
      today.getDate(),
    );
    const eventDateOnly = new Date(
      eventDate.getFullYear(),
      eventDate.getMonth(),
      eventDate.getDate(),
    );
    const dayDifference = Math.floor(
      (todayDateOnly - eventDateOnly) / (1000 * 60 * 60 * 24),
    );
    const startOfThisWeek = new Date(todayDateOnly);
    startOfThisWeek.setDate(todayDateOnly.getDate() - todayDateOnly.getDay());
    const startOfLastWeek = new Date(startOfThisWeek);
    startOfLastWeek.setDate(startOfThisWeek.getDate() - 7);
    const timeOnly = eventDate.toLocaleTimeString([], {
      hour: "2-digit",
      minute: "2-digit",
    });
    const dayName = eventDate.toLocaleDateString("en-US", {
      weekday: "short",
    });
    const fullDate = eventDate.toLocaleDateString("en-US", {
      day: "numeric",
      month: "short",
      year: "numeric",
    });
    const monthYear = `${eventDate.getMonth()}-${eventDate.getFullYear()}`;
    const currentMonthYear = `${today.getMonth()}-${today.getFullYear()}`;
    if (dayDifference === 0) {
      return timeOnly;
    } else if (dayDifference === 1) {
      return `${dayName} ${timeOnly}`;
    } else if (eventDateOnly >= startOfThisWeek && dayDifference <= 7) {
      return `${dayName} ${timeOnly}`;
    } else if (
      eventDateOnly >= startOfLastWeek &&
      eventDateOnly < startOfThisWeek
    ) {
      return `${dayName} ${timeOnly}`;
    } else if (monthYear === currentMonthYear) {
      return fullDate;
    } else if (
      eventDate.getMonth() === (today.getMonth() - 1 + 12) % 12 &&
      eventDate.getFullYear() ===
        (today.getMonth() === 0 ? today.getFullYear() - 1 : today.getFullYear())
    ) {
      return fullDate;
    } else {
      return fullDate;
    }
  }
  // changes related to activelist
  //         formatEventDate(eventDateTime) {
  // const safeDateTime = eventDateTime || '''';
  // const eventDate = safeDateTime
  //     ? new Date(safeDateTime.replace(/(\d{2})\/(\d{2})\/(\d{4})/, "$3-$2-$1"))
  //     : null;
  //                 const today = new Date();
  //             const todayDateOnly = new Date(today.getFullYear(), today.getMonth(), today.getDate());
  //             const eventDateOnly = new Date(eventDate.getFullYear(), eventDate.getMonth(), eventDate.getDate());
  //             const dayDifference = Math.floor((todayDateOnly - eventDateOnly) / (1000 * 60 * 60 * 24));
  //             const startOfThisWeek = new Date(todayDateOnly);
  //             startOfThisWeek.setDate(todayDateOnly.getDate() - todayDateOnly.getDay()); // Sunday of this week
  //             const startOfLastWeek = new Date(startOfThisWeek);
  //             startOfLastWeek.setDate(startOfThisWeek.getDate() - 7); // Sunday of last week
  //             const timeOnly = eventDate.toLocaleTimeString([], {
  //                 hour: ''2-digit'',
  //                 minute: ''2-digit''
  //             });
  //             const dayName = eventDate.toLocaleDateString(''en-US'', {
  //                 weekday: ''short''
  //             });
  //             const fullDate = eventDate.toLocaleDateString(''en-US'', {
  //                 day: ''numeric'',
  //                 month: ''short'',
  //                 year: ''numeric''
  //             });
  //             const monthYear = `${eventDate.getMonth()}-${eventDate.getFullYear()}`;
  //             const currentMonthYear = `${today.getMonth()}-${today.getFullYear()}`;
  //             if (dayDifference === 0) {
  //                 return timeOnly;
  //             } else if (dayDifference === 1) {
  //                 return `${dayName} ${timeOnly}`;
  //             } else if (eventDateOnly >= startOfThisWeek && dayDifference <= 7) {
  //                 return `${dayName} ${timeOnly}`;
  //             } else if (eventDateOnly >= startOfLastWeek && eventDateOnly < startOfThisWeek) {
  //                 return `${dayName} ${timeOnly}`;
  //             } else if (monthYear === currentMonthYear) {
  //                 return `${eventDate.toLocaleDateString(''en-US'', { day: ''numeric'', month: ''short'', year: ''numeric'' })}`;
  //             } else if (
  //                 eventDate.getMonth() === (today.getMonth() - 1 + 12) % 12 && // Handles year boundary
  //                 eventDate.getFullYear() === (today.getMonth() === 0 ? today.getFullYear() - 1 : today.getFullYear())
  //             ) {
  //                 return `${eventDate.toLocaleDateString(''en-US'', { day: ''numeric'', month: ''short'' , year: ''numeric''})}`;
  //             } else {
  //                 return fullDate;
  //             }
  //         }
  getTimeframe(dateString) {
    const today = new Date();
    const [day, month, year] = dateString.split("/"); // Extract the day, month, and year
    const targetDate = new Date(year, month - 1, day); // Use month - 1 as months are zero-indexed
    today.setHours(0, 0, 0, 0);
    targetDate.setHours(0, 0, 0, 0);
    const diffTime = today.getTime() - targetDate.getTime();
    const diffDays = diffTime / (1000 * 60 * 60 * 24);
    if (diffDays === 0) return "Today";
    if (diffDays === 1) return "Yesterday";
    const dayOfWeek = today.getDay();
    const startOfThisWeek = new Date(today);
    startOfThisWeek.setDate(today.getDate() - dayOfWeek);
    const startOfLastWeek = new Date(startOfThisWeek);
    startOfLastWeek.setDate(startOfLastWeek.getDate() - 7);
    const endOfLastWeek = new Date(startOfLastWeek);
    endOfLastWeek.setDate(endOfLastWeek.getDate() + 6);
    if (targetDate >= startOfThisWeek) return "This Week";
    if (targetDate >= startOfLastWeek && targetDate <= endOfLastWeek)
      return "Last Week";
    const thisMonth = today.getMonth();
    const thisYear = today.getFullYear();
    const startOfThisMonth = new Date(thisYear, thisMonth, 1);
    const startOfLastMonth = new Date(thisYear, thisMonth - 1, 1);
    const endOfLastMonth = new Date(thisYear, thisMonth, 0);
    if (targetDate >= startOfThisMonth) return "This Month";
    if (targetDate >= startOfLastMonth && targetDate <= endOfLastMonth)
      return "Last Month";
    return "Previous records";
  }
  scrollListener(event) {
    const div = event.target;
    if (this.isFetching) return;
    if (this.isScrollAtBottomWithinDiv(div)) {
      this.isFetching = true;
      //  this.pageNo++;
      this.fetchProcessList("task", "scroll");
      // .finally(() => {
      //     this.isFetching = false;
      // });
    }
  }
  // scrollListener(event) {
  //     const myDiv = event.target;
  //     const currentScrollTop = myDiv.scrollTop;
  //     const currentScrollLeft = myDiv.scrollLeft;
  //     if (this.lastScrollTop !== currentScrollTop) {
  //         this.lastScrollTop = currentScrollTop;
  //         if (!this.isFetching && axProcessObj.isScrollAtBottomWithinDiv(myDiv)) {
  //             this.isFetching = true;
  //             axProcessObj.pageNo++;
  //             axProcessObj.fetchProcessList("task", "scroll");
  //             setTimeout(() => {
  //                 this.isFetching = false;
  //             }, 500);
  //         }
  //     }
  //     this.lastScrollLeft = currentScrollLeft;
  // }
  isScrollAtBottomWithinDiv(div) {
    return div.scrollTop + div.clientHeight >= div.scrollHeight - 100;
  }
  // isScrollAtBottomWithinDiv(divElement) {
  //     const distanceToBottom = divElement.scrollHeight - (divElement.scrollTop + divElement.clientHeight);
  //     return distanceToBottom <= 1;
  // }
  showProcessList() {
    const dataSource = axProcessObj.tasksJson;
    try {
      if (dataSource.length > 0) {
        const groupedData = axProcessObj.tasksJson.reduce((acc, item) => {
          const dateVal = item.eventdatetime || item.createdon || "";
          const timeframe = axProcessObj.getTimeframe(
            dateVal.split(" ")[0] || "",
          );
          if (!acc[timeframe]) {
            acc[timeframe] = [];
          }
          acc[timeframe].push(item);
          return acc;
        }, {});
        if (this.isDropdownClick) {
          const container = document.getElementById("plistContent");
          container.innerHTML = "";
        }
        Object.keys(groupedData).forEach((timeframe) => {
          const safeTimeframe = String(timeframe || "Other");
          const sectionIdSuffix = safeTimeframe
            .replace(/\s+/g, "")
            .replace(/[^\w-]/g, "");
          const existingAccordion = document.getElementById(
            `section-${sectionIdSuffix}`,
          );
          if (existingAccordion) {
            const accordionBody =
              existingAccordion.querySelector(".accordion-body");
            accordionBody.insertAdjacentHTML(
              "beforeend",
              groupedData[timeframe]
                .map((item) => this.generateTaskHTML(item))
                .join(""),
            );
          } else {
            this.createAccordionForTimeframe(
              timeframe,
              groupedData[timeframe],
              existingAccordion,
            );
          }
        });
        document
          .querySelectorAll(".tasktitle", "#nextrecord", "#previousrecord")
          .forEach((item) => {
            item.addEventListener("click", function () {
              document.querySelectorAll(".tasktitle").forEach((row) => {
                row.classList.remove("taskRowClicked");
                // const rowElement = row.closest(''.listrow'');
                // if (rowElement) {
                //     rowElement.style.backgroundColor = ''''; // Reset background color
                // }
              });
              this.classList.add("taskRowClicked");
              // const listRowElement = this.closest(''.listrow'');
              // if (listRowElement) {
              //     listRowElement.style.backgroundColor = ''rgb(239 239 236)'';
              // }
            });
          });
        if (!this.isInitialized) {
          //  const listRow = document.querySelector(''.listrow[data-index="1"]'');
          //  if (listRow) {
          //      const taskTitle = listRow.querySelector(''.tasktitle'');
          //      if (taskTitle) {
          //          taskTitle.click();
          //      }
          //     }
const nextBtn = document.getElementById("nextrecord");

if (!nextBtn) return;
          
         
            nextBtn.addEventListener("click", () => {
              this.navigateToRecord("next");
            });


          const previousrecord = document.getElementById("previousrecord")
            if (!previousrecord) return;
            previousrecord.addEventListener("click", () => {
              this.navigateToRecord("previous");
            });

            
          document
            .querySelectorAll("#alllist, #activelist, #completedlist")
            .forEach((button) => {
              button.addEventListener("click", function () {
                // Remove the ''active'' class from all buttons
                document
                  .querySelectorAll("#alllist, #activelist, #completedlist")
                  .forEach((btn) => {
                    btn.classList.remove("active");
                  });
                // Add the ''active'' class to the clicked button
                this.classList.add("active");
                // Update `axProcessObj` properties based on the clicked button
                axProcessObj.isDropdownClick = true;
                axProcessObj.filterkey = this.getAttribute("data-id"); // Extract ''all'', ''active'', ''completed''
                axProcessObj.pageNo = 1;
                axProcessObj.fetchProcessList();
              });
            });
          document
            .querySelector(''.selectbtn[data-kt-menu-attach="parent"]'')
            .addEventListener("click", function (e) {
              e.preventDefault();

              const button = e.currentTarget;
              button.classList.toggle("toggleclicked");
              // Get the checkboxes with class names maincheckbox and task-checkbox
              const mainCheckbox = document.querySelector(".maincheckbox");
              const taskCheckboxes =
                document.querySelectorAll(".task-checkbox");
              document
                .querySelectorAll(".checkbox-wrapper")
                .forEach((wrapper) => {
                  const userElement = wrapper.querySelector(".user");
                  const checkbox = wrapper.querySelector(".task-checkbox");
                  checkbox.classList.toggle("toggleclicked");
                  if (button.classList.contains("toggleclicked")) {
                    userElement.style.display = "none";
                    checkbox.style.visibility = "visible";
                    mainCheckbox.style.display = "block";
                  } else {
                    userElement.style.display = "flex";
                    checkbox.style.visibility = "hidden";
                    mainCheckbox.style.display = "none";
                  }
                });
            });
          // Add keyup and keydown event listeners
          document.addEventListener("keydown", (e) => {
            if (e.key === "ArrowDown") {
              axProcessObj.navigateToRecordWithKeyboard("next");
            } else if (e.key === "ArrowUp") {
              axProcessObj.navigateToRecordWithKeyboard("previous");
            }
          });
          document.querySelectorAll(".listrow").forEach((row) => {
            row.addEventListener("click", function () {
              // Remove ''selected'' class from all list rows
              document.querySelectorAll(".listrow").forEach((r) => {
                r.style.outline = "none";
              });
            });
          });
          document
            .querySelector(".accordion-button")
            ?.addEventListener("click", (event) => {
              const accordionButton = event.target;
              // Check if the button is not collapsed
              if (accordionButton.classList.contains("collapsed")) {
                const bodyContainer = document.getElementById("body_Container");
                const plistContainer = document.getElementById("plistContent");
                if (bodyContainer && plistContainer) {
                  const bodyHeight = bodyContainer.offsetHeight;
                  const plistHeight = plistContainer.offsetHeight;
                  const lastChild =
                    plistContainer.children[plistContainer.children.length - 1];
                  if (
                    bodyHeight > plistHeight &&
                    lastChild &&
                    !lastChild.classList.contains("no-more-records")
                  ) {
                    // Enable scrollbar by adjusting the height
                    plistContainer.style.height = `${bodyHeight}px`;
                    bodyContainer.style.overflowY = "auto"; // Ensure vertical scrollbar is enabled
                  } else {
                    // Reset overflow if the condition is not met
                    //bodyContainer.style.overflowY = ''hidden'';
                  }
                }
              }
            });
          this.initializeTooltips();
          this.initializeDatePickers();
          this.setupSelectAllTasks();
          this.isInitialized = true;
        }
      } else {
        document.querySelector("#PROFLOW_Left").classList.add("d-none");
        document.querySelector("#PROFLOW_Right").classList.add("right-only");
      }
      if (!this.inValid(this.taskId) && !this.taskCompleted) {
        this.setActiveInList(this.taskId);
      }
    } catch (error) {
      this.catchError(error.message);
    }
    this.isDropdownClick = false;
  }
  openFilters() {
    $("#filterModal").modal("show");
    document.getElementById("filterGroupName").disabled = true;
    if ($("#dvModalFilter").html() === "") {
      axProcessObj.createFilterLayout();
    }
  }
  createFilterLayout() {
    $("#dvModalFilter").html("");
    $.each(axProcessObj._entity.metaData, function (index, field) {
      if (field.hide === "T") {
        return true;
      }
      axProcessObj.generateFilterHTML(field);
      if (axProcessObj._entity.filterObj[field.fldname]) {
        axProcessObj.updateFilterLayout(
          field.fldname,
          axProcessObj._entity.filterObj[field.fldname],
        );
      }
    });
    // Initialize dropdown fields
    document
      .querySelectorAll("#dvModalFilter .filter-fld[data-type=DropDown]")
      .forEach((fld) => {
        let fldId = fld.id;
        let dataArray = [...new Set(axProcessObj._entity.fldData[fldId])];
        // Add a default option
        $(fld).append($("<option></option>").val("0").html("--Select--"));
        // Add unique values to the dropdown
        dataArray.forEach((item) => {
          if (!axProcessObj._entity.inValid(item))
            fld.insertAdjacentHTML(
              "beforeend",
              `<option value="${item}">${item}</option>`,
            );
        });
        // Initialize Select2 for the dropdown
        $(fld)
          .select2({
            multiple: true,
          })
          .on("select2:unselect select2:select", function (e) {
            let fldNamesf = $(this).attr("id");
            let fldAcValue = $(this).val();
            fldAcValue = fldAcValue.filter((num) => num !== "0");
            $(this).val(fldAcValue);
            $(this).trigger("change");
          });
      });
    // Initialize date pickers
    var glCulture = eval(callParent("glCulture"));
    var dtFormat = "d/m/Y";
    if (glCulture == "en-us") dtFormat = "m/d/Y";
    $(".flatpickr-input").flatpickr({
      dateFormat: dtFormat,
    });
  }
  convertDateFormat(dateStr) {
    const parts = dateStr.split("/"); // Split the date by ''/''
    return `${parts[2]}-${parts[1]}-${parts[0]}`; // Return in yyyy-MM-dd format
  }
  filterModelClose() {
    $("#filterGroupName").val("");
    $("#filterGroupModalWrapper").modal("hide");
    document.getElementById("filterGroupCheckbox").checked = false;
    document.getElementById("filterGroupName").disabled = true;
    $("#dvModalFilter").html("");
    $("#filterModal").modal("hide");
  }
  generateFilterHTML(field) {
    var fldtype = axProcessObj.getFieldDataType(field);
    var fldcap = field.fldcap || "";
    var fldname = field.fldname;
    let filterHTML = "";
    if (
      fldtype.toUpperCase() == "BUTTON" ||
      fldtype.toUpperCase() == "ATTACHMENTS"
    )
      return;
    if (field.fdatatype == "n") fldtype = "Numeric";
    switch (fldtype) {
      case "DropDown":
        filterHTML = `<div class="row" data-type="${fldtype}"><div class="col-md-3 fldCaption"><p class="form-group ">${fldcap}</p> </div>
                                <div class="col-md-9 fldCaption">
                                    <select class="form-control filter-fld"  data-type="${fldtype}" id="${fldname}" name="${fldtype}">
                                    <option value="All">All</option>
                                    </select>
                                </div>`;
        break;
      case "Numeric":
        filterHTML = `<div class="row filter-fld" data-type="${fldtype}" id="${fldname}" data-type="${fldtype}">
                    <div class="col-md-3 fldCaption">
                    <p class="form-group ">${fldcap}</p>
                    </div> 
                    <div class="col-md-9">
                    <div class="form-group form-row fldCaption">
                    <div class="col-md-6 col">
                    <label>From</label>           
                    <input type="number" id="${fldname}_from" class="form-control" data-type="${fldtype}"/>
                    </div>
                    <div class="col-md-6 col">
                    <label>To</label>           
                    <input type="number" id="${fldname}_to" class="form-control" data-type="${fldtype}"/>
                    </div></div></div>`;
        break;
      case "Date":
        var dateOptions = [
          "Custom",
          "Today",
          "Yesterday",
          "Tomorrow",
          "This week",
          "Last week",
          "Next week",
          "This month",
          "Last month",
          "Next month",
          "This quarter",
          "Last quarter",
          "Next quarter",
          "This year",
          "Last year",
          "Next year",
        ];
        var dateOptionsId = [
          "customOption",
          "todayOption",
          "yesterdayOption",
          "tomorrowOption",
          "this_weekOption",
          "last_weekOption",
          "next_weekOption",
          "this_monthOption",
          "last_monthOption",
          "next_monthOption",
          "this_quarterOption",
          "last_quarterOption",
          "next_quarterOption",
          "this_yearOption",
          "last_yearOption",
          "next_yearOption",
        ];
        filterHTML += `<div class="row filter-fld" data-type="${fldtype}" id="${fldname}"><div class="col-md-3 fldCaption"><p class="form-group ">${fldcap}</p></div>
                                    <div class="col-md-4 fldCaption">
                                    <select class="form-select dateFilter" type="text" id="${fldname}_dateoption" name="${fldname}" data-field="${fldname}" onchange="axProcessObj.generateAdvFilterDates(''${fldname}'');">`;
        for (var i = 0; i < dateOptions.length; i++) {
          filterHTML += `<option value=${dateOptionsId[i]}>${dateOptions[i]}</option>`;
        }
        filterHTML += `</select> 
                                    </div>
                                    <div class="col-md-5">
        <div class="form-group form-row fldCaption">
        <div class="col-md-6 col">
        <label>From</label>           
        <input id="${fldname}_from" name="${fldname}_from" value="" maxlength="10" type="date" class="form-control flatpickr-input" data-input="" onchange="axProcessObj.validateDateRange(''${fldname}'');">
        </div>
        <div class="col-md-6 col">
        <label>To</label>           
        <input id="${fldname}_to" name="${fldname}_to" value="" maxlength="10" type="date" class="form-control flatpickr-input" data-input="" onchange="axProcessObj.validateDateRange(''${fldname}'');">
        </div></div></div>   
                                    </div>`;
        break;
      default:
        filterHTML = `<div class="row" data-type="${fldtype}">
                    <div class="col-md-3 fldCaption">
                    <p class="form-group ">${fldcap}</p> 
                    </div>
                    <div class="col-md-4 fldValue"> 
                    <select class="form-select" type="text" id="${fldname}_searchoption" class="form-control">
                    <option value="STARTSWITH">Starts with</option>
                    <option value="CONTAINS">Contains</option>
                    <option value="ENDSWITH">Ends with</option>
                    </select></div>
                    <div class="col-md-5 fldValue"> <input type="text" id="${fldname}" class="form-control filter-fld" data-type="${fldtype}"/></div>
                    </div>`;
        break;
    }
    $("#dvModalFilter").append(filterHTML);
  }
  getDatesBasedonSelection(selectionvalue) {
    var fromToObj = {
      from: "",
      to: "",
    };
    var advFilterDtCulture = dtCulture == "en-us" ? "MM/DD/YYYY" : "DD/MM/YYYY";
    switch (selectionvalue) {
      case "customOption":
        break;
      case "todayOption":
        var dateObj = new Date();
        fromToObj.from = fromToObj.to =
          moment(dateObj).format(advFilterDtCulture);
        break;
      case "yesterdayOption":
        var dateObj = new Date();
        dateObj.setDate(dateObj.getDate() - 1);
        fromToObj.from = fromToObj.to =
          moment(dateObj).format(advFilterDtCulture);
        break;
      case "tomorrowOption":
        var dateObj = new Date();
        dateObj.setDate(dateObj.getDate() + 1);
        fromToObj.from = fromToObj.to =
          moment(dateObj).format(advFilterDtCulture);
        break;
      case "this_weekOption":
        var dateObj = getFirstDayOfWeek(new Date());
        fromToObj.from = moment(dateObj).format(advFilterDtCulture);
        dateObj.setDate(dateObj.getDate() + 6);
        fromToObj.to = moment(dateObj).format(advFilterDtCulture);
        break;
      case "last_weekOption":
        var dateObj = getFirstDayOfWeek(new Date());
        dateObj.setDate(dateObj.getDate() - 7);
        fromToObj.from = moment(dateObj).format(advFilterDtCulture);
        dateObj.setDate(dateObj.getDate() + 6);
        fromToObj.to = moment(dateObj).format(advFilterDtCulture);
        break;
      case "next_weekOption":
        var dateObj = getFirstDayOfWeek(new Date());
        dateObj.setDate(dateObj.getDate() + 7);
        fromToObj.from = moment(dateObj).format(advFilterDtCulture);
        dateObj.setDate(dateObj.getDate() + 6);
        fromToObj.to = moment(dateObj).format(advFilterDtCulture);
        break;
      case "this_monthOption":
        var dateObj = getFirstDayOfWeek(new Date());
        dateObj.setDate(1);
        fromToObj.from = moment(dateObj).format(advFilterDtCulture);
        dateObj.setMonth(dateObj.getMonth() + 1);
        dateObj.setDate(0);
        fromToObj.to = moment(dateObj).format(advFilterDtCulture);
        break;
      case "last_monthOption":
        var dateObj = getFirstDayOfWeek(new Date());
        dateObj.setDate(1);
        dateObj.setMonth(dateObj.getMonth() - 1);
        fromToObj.from = moment(dateObj).format(advFilterDtCulture);
        dateObj.setMonth(dateObj.getMonth() + 1);
        dateObj.setDate(0);
        fromToObj.to = moment(dateObj).format(advFilterDtCulture);
        break;
      case "next_monthOption":
        var dateObj = getFirstDayOfWeek(new Date());
        dateObj.setDate(1);
        dateObj.setMonth(dateObj.getMonth() + 1);
        fromToObj.from = moment(dateObj).format(advFilterDtCulture);
        dateObj.setMonth(dateObj.getMonth() + 1);
        dateObj.setDate(0);
        fromToObj.to = moment(dateObj).format(advFilterDtCulture);
        break;
      case "this_quarterOption":
        var dateObj = new Date();
        var thisQuarter = Math.floor((dateObj.getMonth() + 3) / 3);
        dateObj.setDate(1);
        dateObj.setMonth(thisQuarter * 3 - 3);
        fromToObj.from = moment(dateObj).format(advFilterDtCulture);
        dateObj.setMonth(dateObj.getMonth() + 3);
        dateObj.setDate(0);
        fromToObj.to = moment(dateObj).format(advFilterDtCulture);
        break;
      case "last_quarterOption":
        var dateObj = new Date();
        var thisQuarter = Math.floor((dateObj.getMonth() + 3) / 3) - 1;
        if (thisQuarter == 0) {
          thisQuarter = 4;
          dateObj.setFullYear(dateObj.getFullYear() - 1);
        }
        dateObj.setDate(1);
        dateObj.setMonth(thisQuarter * 3 - 3);
        fromToObj.from = moment(dateObj).format(advFilterDtCulture);
        dateObj.setMonth(dateObj.getMonth() + 3);
        dateObj.setDate(0);
        fromToObj.to = moment(dateObj).format(advFilterDtCulture);
        break;
      case "next_quarterOption":
        var dateObj = new Date();
        var thisQuarter = Math.floor((dateObj.getMonth() + 3) / 3) + 1;
        if (thisQuarter == 5) {
          thisQuarter = 1;
          dateObj.setFullYear(dateObj.getFullYear() + 1);
        }
        dateObj.setDate(1);
        dateObj.setMonth(thisQuarter * 3 - 3);
        fromToObj.from = moment(dateObj).format(advFilterDtCulture);
        dateObj.setMonth(dateObj.getMonth() + 3);
        dateObj.setDate(0);
        fromToObj.to = moment(dateObj).format(advFilterDtCulture);
        break;
      case "this_yearOption":
        var dateObj = new Date();
        dateObj.setDate(1);
        dateObj.setMonth(0);
        fromToObj.from = moment(dateObj).format(advFilterDtCulture);
        dateObj.setFullYear(dateObj.getFullYear() + 1);
        dateObj.setMonth(0);
        dateObj.setDate(0);
        fromToObj.to = moment(dateObj).format(advFilterDtCulture);
        break;
      case "last_yearOption":
        var dateObj = new Date();
        dateObj.setFullYear(dateObj.getFullYear() - 1);
        dateObj.setDate(1);
        dateObj.setMonth(0);
        fromToObj.from = moment(dateObj).format(advFilterDtCulture);
        dateObj.setFullYear(dateObj.getFullYear() + 1);
        dateObj.setMonth(0);
        dateObj.setDate(0);
        fromToObj.to = moment(dateObj).format(advFilterDtCulture);
        break;
      case "next_yearOption":
        var dateObj = new Date();
        dateObj.setFullYear(dateObj.getFullYear() + 1);
        dateObj.setDate(1);
        dateObj.setMonth(0);
        fromToObj.from = moment(dateObj).format(advFilterDtCulture);
        dateObj.setFullYear(dateObj.getFullYear() + 1);
        dateObj.setMonth(0);
        dateObj.setDate(0);
        fromToObj.to = moment(dateObj).format(advFilterDtCulture);
        break;
    }
    return fromToObj;
  }
  generateAdvFilterDates(dateFld) {
    var selectionvalue = document.querySelector(`#${dateFld}_dateoption`).value;
    var currentDate = new Date();
    var fromDate = document.querySelector(`#${dateFld}_from`);
    var toDate = document.querySelector(`#${dateFld}_to`);
    var fromToObj = axProcessObj.getDatesBasedonSelection(selectionvalue);
    fromDate.value = axProcessObj.convertDateFormat(fromToObj.from);
    toDate.value = axProcessObj.convertDateFormat(fromToObj.to);
    if (selectionvalue == "customOption") {
      fromDate.disabled = false;
      toDate.disabled = false;
      fromDate.classList.add("disabledDate");
      toDate.classList.add("disabledDate");
    } else {
      fromDate.disabled = true;
      toDate.disabled = true;
      fromDate.classList.remove("disabledDate");
      toDate.classList.remove("disabledDate");
    }
  }
  validateDateRange(fieldId) {
    var fromDateElement = document.getElementById(fieldId + "_from");
    var toDateElement = document.getElementById(fieldId + "_to");
    var fromDate = fromDateElement.value;
    var toDate = toDateElement.value;
    if (fromDate && toDate) {
      var fromDateObj = parseDate(fromDate);
      var toDateObj = parseDate(toDate);
      if (!fromDateObj || !toDateObj) {
        alert("Invalid date format.");
        return;
      }
      // Check if the "To" date is earlier than the "From" date
      if (toDateObj < fromDateObj) {
        alert(''The "To" date cannot be earlier than the "From" date.'');
        // Clear the "To" date
        toDateElement.value = "";
      }
    }
  }
  getFieldDataType(fldProps) {
    // Corrected: Calling _entity''s inValid method properly
    if (axProcessObj._entity.inValid(fldProps.cdatatype)) {
      if (fldProps.fdatatype == "n") return "Number";
      else if (fldProps.fdatatype == "d") return "Date";
      else if (fldProps.fdatatype == "c") return "Text";
      else if (fldProps.fdatatype == "i") return "Image";
      else if (fldProps.fdatatype == "t") return "Large Text";
      else return "Text";
    } else {
      return fldProps.cdatatype;
    }
  }
  updateFilterLayout(fieldId, filterDetails) {
    filterChanged = true;
    $("#dvModalFilter")
      .children()
      .each(function () {
        let divDataType = $(this).attr("data-type");
        let selectElement = $(this).find("div select");
        let divEleId = selectElement.attr("id");
        let divDataField = selectElement.attr("data-field");
        let inputElement = $(this).find("div input");
        let inputEleId = inputElement.attr("id");
        // let selectedOptionValue = selectElement.val();
        // let inputValue = inputElement.val();
        for (const [key, value] of Object.entries(fieldId)) {
          if (divEleId === key || divDataField === key || inputEleId === key) {
            const secondValue = value.split(",")[1];
            const dropdownElement = $(`#${divEleId}`);
            switch (divDataType) {
              case "DropDown":
                if (dropdownElement.prop("multiple")) {
                  const values = secondValue.split(";");
                  dropdownElement.val(values).trigger("change");
                } else {
                  dropdownElement.val(secondValue).trigger("change");
                }
                break;
              case "Simple Text":
                inputElement.val(secondValue);
                break;
              case "Date":
                if (divEleId === "modifiedon_dateoption") {
                  const fromDate = $("#modifiedon_from");
                  const toDate = $("#modifiedon_to");
                  const fromToObj = getDatesBasedonSelection(secondValue);
                  fromDate.val(fromToObj.from);
                  toDate.val(fromToObj.to);
                  dropdownElement.val(secondValue).trigger("change");
                  // Enable or disable date fields based on the selected option
                  if (secondValue === "customOption") {
                    fromDate.prop("disabled", false).addClass("disabledDate");
                    toDate.prop("disabled", false).addClass("disabledDate");
                  } else {
                    fromDate.prop("disabled", true).removeClass("disabledDate");
                    toDate.prop("disabled", true).removeClass("disabledDate");
                  }
                }
                break;
              case "Numeric":
              case "Auto Generate":
                inputElement.val(secondValue);
                break;
              default:
                break;
            }
            break;
          }
        }
      });
    // Handle pillText if present
    if (fieldId.pillText) {
      $("#filterGroupName").val(fieldId.pillText);
    }
  }
  navigateToRecordWithKeyboard(direction) {
    const taskTitles = Array.from(
      document.querySelectorAll(".listrow .tasktitle"),
    );
    const listContainer = document.querySelector(".list-container");
    let activeIndex = taskTitles.findIndex((item) =>
      item.classList.contains("taskRowClicked"),
    );
    if (activeIndex === -1 && taskTitles.length > 0) {
      // If no row is active, select the first row
      activeIndex = 0;
      taskTitles[activeIndex].classList.add("taskRowClicked");
      taskTitles[activeIndex].click();
      taskTitles[activeIndex].closest(".listrow").style.outline =
        "1px solid black"; // Add outline border
      // Scroll into view and adjust for header height
      setTimeout(() => {
        taskTitles[activeIndex].closest(".listrow").scrollIntoView({
          behavior: "smooth",
          block: "start",
        });
        const header = document.querySelector(".Page-Title-Bar");
        if (header) {
          const headerHeight = header.offsetHeight || 0;
          window.scrollBy(0, -headerHeight);
        }
      }, 0);
      return;
    }
    let targetIndex = direction === "next" ? activeIndex + 1 : activeIndex - 1;
    if (targetIndex >= 0 && targetIndex < taskTitles.length) {
      // Remove outline and class from the current active row
      taskTitles[activeIndex].classList.remove("taskRowClicked");
      taskTitles[activeIndex].closest(".listrow").style.outline = "none";
      // Add outline and class to the new target row
      taskTitles[targetIndex].classList.add("taskRowClicked");
      taskTitles[targetIndex].click();
      taskTitles[targetIndex].closest(".listrow").style.outline =
        "1px solid black";
      setTimeout(() => {
        taskTitles[targetIndex].closest(".listrow").scrollIntoView({
          behavior: "smooth",
          block: "start",
        });
        const header = document.querySelector(".Page-Title-Bar");
        if (header) {
          const headerHeight = header.offsetHeight || 0;
          window.scrollBy(0, -headerHeight);
        }
      }, 0);
      s;
    } else {
      const message =
        direction === "next"
          ? "No more Next records."
          : "No more Previous records.";
      showAlertDialog("info", message);
    }
  }
  getRowIcon(rowdata) {
    let iconHtml = "";
    let tooltip = "";
    if (rowdata.rectype === "PEG") {
      if (rowdata.taskstatus) {
        switch (rowdata.taskstatus.toUpperCase()) {
          case "RETURNED":
            tooltip = `<span class="badge  badge-light-danger fw-bold ">${rowdata.taskstatus.charAt(0).toUpperCase() + rowdata.taskstatus.slice(1)}</span>`;
            iconHtml = `<span class="material-icons" style="color:blueviolet" >reply</span>`;
            break;
          case "WITHDRAWN":
            tooltip = `<span class="badge  badge-light-danger fw-bold ">${rowdata.taskstatus.charAt(0).toUpperCase() + rowdata.taskstatus.slice(1)}</span>`;
            iconHtml = `<span class="material-icons" style="color:red" >cancel</span>`;
            break;
          case "APPROVED":
            tooltip = `<span class="badge  badge-light-success fw-bold ">${rowdata.taskstatus.charAt(0).toUpperCase() + rowdata.taskstatus.slice(1)}</span>`;
            iconHtml = `<span class="material-icons" style="color:#50cd89" >check_circle</span>`;
            break;
          case "REJECTED":
            tooltip = `<span class="badge  badge-light-danger fw-bold ">${rowdata.taskstatus.charAt(0).toUpperCase() + rowdata.taskstatus.slice(1)}</span>`;
            iconHtml = `<span class="material-icons" style="color:red" >cancel</span>`;
            break;
          case "CHECKED":
            tooltip = `<span class="badge  badge-light-success fw-bold ">${rowdata.taskstatus.charAt(0).toUpperCase() + rowdata.taskstatus.slice(1)}</span>`;
            iconHtml = `<span class="material-icons" style="color:#50cd89" >check_box</span>`;
            break;
          case "MADE":
            tooltip = "";
            iconHtml = `<span class="material-icons" >done</span>`;
            break;
          case "SKIPPED":
            tooltip = `<span class="badge  badge-light-danger fw-bold ">${rowdata.taskstatus.charAt(0).toUpperCase() + rowdata.taskstatus.slice(1)}</span>`;
            iconHtml = `<span class="material-icons text-primary" >skip_next</span>`;
            break;
          case "SENT":
            tooltip = `<span class="badge  badge-light-danger fw-bold ">${rowdata.taskstatus.charAt(0).toUpperCase() + rowdata.taskstatus.slice(1)}</span>`;
            iconHtml = `<span class="material-icons" >skip_next</span>`;
            break;
          default:
            tooltip = "";
            iconHtml = `<span class="material-icons" title="PEG">assignment</span>`;
        }
      } else if (rowdata.tasktype) {
        switch (rowdata.tasktype.toUpperCase()) {
          case "APPROVE":
            tooltip = ``;
            iconHtml = `<span class="material-icons" >task</span>`;
            break;
          case "CACHED SAVE":
            tooltip = ``;
            iconHtml = `<span class="material-icons" >save</span>`;
            break;
          case "CHECK":
            tooltip = ``;
            iconHtml = `<span class="material-icons" >check</span>`;
            break;
          case "MAKE":
            tooltip = ``;
            iconHtml = `<span class="material-icons" >construction</span>`;
            break;
          case "EXPORT":
            tooltip = ``;
            iconHtml = `<span class="material-icons" >import_export</span>`;
            break;
          case "REMINDERS":
            tooltip = ``;
            iconHtml = `<span class="material-icons" >notifications</span>`;
            break;
          default:
            tooltip = "";
            iconHtml = `<span class="material-icons" title="PEG">assignment</span>`;
        }
      }
    } else if (rowdata.rectype === "MSG") {
      if (rowdata.msgtype) {
        switch (rowdata.msgtype.toUpperCase()) {
          case "EXPORT EXCEL1":
            tooltip = `<span class="badge  badge-light-primary fw-bold ">Export Excel</span>`;
            iconHtml = `<span class="material-icons" >file_copy</span>`;
            break;
          case "EXPORT PDF":
            tooltip = `<span class="badge  badge-light-primary fw-bold ">${rowdata.msgtype.charAt(0).toUpperCase() + rowdata.msgtype.slice(1)}</span>`;
            iconHtml = `<span class="material-icons" >picture_as_pdf</span>`;
            break;
          case "EXPORT WORD":
            tooltip = `<span class="badge  badge-light-primary fw-bold ">${rowdata.msgtype.charAt(0).toUpperCase() + rowdata.msgtype.slice(1)}</span>`;
            iconHtml = `<span class="material-icons" >article</span>`;
            break;
          case "PERIODIC NOTIFICATION":
            tooltip = `<span class="badge  badge-light-danger fw-bold ">${rowdata.msgtype.charAt(0).toUpperCase() + rowdata.msgtype.slice(1)}</span>`;
            iconHtml = `<span class="material-icons" >alarm</span>`;
            break;
          case "FORM NOTIFICATION":
            tooltip = "";
            iconHtml = `<span class="material-icons" >notifications</span>`;
            break;
          case "CCHED SAVE":
            tooltip = `<span class="badge  badge-light-danger fw-bold ">${rowdata.msgtype.charAt(0).toUpperCase() + rowdata.msgtype.slice(1)}</span>`;
            iconHtml = `<span class="material-icons" >save</span>`;
            break;
          case "MESSAGE":
            tooltip = `<span class="badge  badge-light-success fw-bold ">${rowdata.msgtype.charAt(0).toUpperCase() + rowdata.msgtype.slice(1)}</span>`;
            iconHtml = `<span class="material-icons" >message</span>`;
            break;
          case "REMINDERS":
            tooltip = `<span class="badge  badge-light-danger fw-bold ">${rowdata.msgtype.charAt(0).toUpperCase() + rowdata.msgtype.slice(1)}</span>`;
            iconHtml = `<span class="material-icons" >notifications</span>`;
            break;
          default:
            tooltip = "";
            iconHtml = `<span class="material-icons" title="Message">message</span>`;
        }
      }
    }
    return {
      iconHtml,
      tooltip,
    };
  }

  toggleRowBackground(element) {
    const allRows = document.querySelectorAll(".listrow");
    const parentRow = element.closest(".listrow");
    allRows.forEach((row) => row.classList.remove("bg-changed"));
    if (parentRow) {
      parentRow.classList.add("bg-changed");
    }
  }
  navigateToRecord(direction) {
    const taskTitles = Array.from(
      document.querySelectorAll(".listrow .tasktitle"),
    );
    const activeIndex = taskTitles.findIndex((item) =>
      item.classList.contains("taskRowClicked"),
    );
    if (activeIndex !== -1) {
      let targetIndex =
        direction === "next" ? activeIndex + 1 : activeIndex - 1;
      if (targetIndex >= 0 && targetIndex < taskTitles.length) {
        taskTitles[targetIndex].click();
      } else {
        const myDiv = document.getElementById("body_Container");
        if (
          direction === "next" &&
          axProcessObj.isScrollAtBottomWithinDiv(myDiv)
        ) {
          if (!this.isFetching) {
            this.isFetching = true;
            axProcessObj.pageNo++;
            axProcessObj.fetchProcessList("task", "scroll");
            setTimeout(() => {
              this.isFetching = false;
              const updatedTaskTitles = Array.from(
                document.querySelectorAll(".listrow .tasktitle"),
              );
              if (updatedTaskTitles.length > taskTitles.length) {
                const newTargetIndex = updatedTaskTitles.findIndex(
                  (_, index) => index === targetIndex,
                );
                if (newTargetIndex !== -1) {
                  updatedTaskTitles[newTargetIndex].click();
                } else {
                  showAlertDialog("info", "No more Next records.");
                }
              } else {
                showAlertDialog("info", "No more Next records.");
              }
            }, 500);
          }
        } else {
          const message =
            direction === "next"
              ? "No more Next records."
              : "No more Previous records.";
          showAlertDialog("info", message);
        }
      }
    } else {
      showAlertDialog("info", "No currently selected task to navigate from.");
    }
  }
  toggleCheckbox() {
    document.querySelector(".maincheckbox").addEventListener("click", (e) => {
      const button = e.currentTarget;
      button.classList.toggle("selectclicked");
      document.querySelectorAll(".checkbox-wrapper").forEach((wrapper) => {
        const userElement = wrapper.querySelector(".user");
        const checkbox = wrapper.querySelector(".task-checkbox");
        checkbox.classList.toggle("selectclicked");
        if (button.classList.contains("selectclicked")) {
          checkbox.setAttribute("checked", true);
          userElement.style.display = "none";
          checkbox.style.visibility = "visible";
          button.style.display = "blockwindow.top";
        } else {
          checkbox.removeAttribute("checked");
          userElement.style.display = "flex";
          checkbox.style.visibility = "hidden";
          button.style.display = "none";
          document
            .querySelector(''.selectbtn[data-kt-menu-attach="parent"]'')
            .classList.remove("toggleclicked");
        }
      });
    });
  }
  toggleList() {
    document
      .getElementById("collapseicon")
      .addEventListener("click", function () {
        const leftDiv = document.getElementById("PROFLOW_Left");
        const rightDiv = document.getElementById("PROFLOW_Right");
        const nextRec = document.getElementById("nextrecord");
        const prevRec = document.getElementById("previousrecord");
        leftDiv.classList.toggle("collapsed");
        const mainCheckbox = document.querySelector(".maincheckbox");
        mainCheckbox.style.display = "none";
        let filteredRows;
        const listRows = Array.from(document.querySelectorAll(".listrow"));
        // Filter rows where taskTitle exists and does not have the ''taskRowClicked'' class
        filteredRows = listRows.filter((listRow) => {
          const taskTitle = listRow.querySelector(".tasktitle");
          return taskTitle && taskTitle.classList.contains("taskRowClicked");
        });
        if (leftDiv.classList.contains("collapsed")) {
          let row = null;
          // Find the row with data-index="1" in the filtered rows
          const targetRow = listRows.find(
            (listRow) => listRow.getAttribute("data-index") === "1",
          );
          if (targetRow && filteredRows.length == 0) {
            row = targetRow.querySelector(".tasktitle");
            if (row) {
              console.log(
                `Triggering click for taskTitle inside listRow with data-index: 1`,
              );
              row.click();
            }
          }
          leftDiv.classList.add("d-none");
          rightDiv.classList.remove("col-xl-8");
          rightDiv.classList.add("col-xl-12");
          this.setAttribute("data-bs-title", "Show record List");
          this.setAttribute("data-bs-toggle", "tooltip");
          this.setAttribute("data-bs-placement", "bottom");
          const tooltipInstance = bootstrap.Tooltip.getInstance(this);
          if (tooltipInstance) {
            tooltipInstance.dispose();
          }
          new bootstrap.Tooltip(this); // Initialize the new tooltip instance
          nextRec.classList.remove("d-none");
          prevRec.classList.remove("d-none");
        } else {
          if (filteredRows.length == 1) {
            const activeRow = filteredRows[0].querySelector(".tasktitle");
            if (activeRow) {
              console.log(`Scrolling to the taskTitle in the filtered row`);
              setTimeout(() => {
                activeRow.scrollIntoView({
                  behavior: "smooth",
                  block: "start",
                });
                const headerHeight =
                  document.getElementsByClassName(
                    "Page-Title-Bar",
                  ).offsetHeight;
                window.scrollBy(10, -headerHeight); // Adjust to avoid overlap
              }, 0);
            }
          }
          leftDiv.classList.remove("d-none");
          rightDiv.classList.remove("col-xl-12");
          rightDiv.classList.add("col-xl-8");
          this.setAttribute("data-bs-title", "Hide record List");
          this.setAttribute("data-bs-toggle", "tooltip");
          this.setAttribute("data-bs-placement", "bottom");
          const tooltipInstance = bootstrap.Tooltip.getInstance(this);
          if (tooltipInstance) {
            tooltipInstance.dispose();
          }
          new bootstrap.Tooltip(this);
          nextRec.classList.add("d-none");
          prevRec.classList.add("d-none");
        }
      });
  }
  initializeTooltips() {
    const tooltipTriggerList = document.querySelectorAll(
      ''[data-bs-toggle="tooltip"]'',
    );
    tooltipTriggerList.forEach((tooltipTriggerEl) => {
      if (!tooltipTriggerEl.getAttribute("data-bs-title")) {
        tooltipTriggerEl.removeAttribute("data-bs-title"); // Remove empty tooltips
      }
      let tooltipInstance = bootstrap.Tooltip.getInstance(tooltipTriggerEl);
      if (tooltipInstance) {
        tooltipInstance.dispose(); // Destroy old tooltip
      }
      new bootstrap.Tooltip(tooltipTriggerEl);
    });
  }
  initializeDatePickers() {
    $("#pdFilFrom, #pdFilTo").flatpickr({
      dateFormat: "d-M-Y",
      enableTime: false,
    });
  }
  setupSelectAllTasks() {
    $(document).on("click", ".all-task", (event) => {
      const isChecked = event.currentTarget.checked;
      const menuPr = document.querySelector("#pd_all_tasks");
      const menuDd = KTMenu.getInstance(menuPr);
      menuDd.element.children.forEach((child, index) => {
        const menuTask = child.querySelector(".menu-task");
        if (menuTask) {
          menuTask.checked = isChecked;
        }
      });
      $(".all-task-text").text(isChecked ? "Unselect All" : "Select All");
    });
    $(document).on("click", ".menu-task", () => {
      const totalCheckBoxes = document.querySelectorAll(".menu-task");
      const checkedCheckBoxes = document.querySelectorAll(".menu-task:checked");
      const allTasksCheckbox = document.querySelector(".all-task");
      const actionTextElement = $(".all-task-text");
      if (totalCheckBoxes.length === checkedCheckBoxes.length) {
        allTasksCheckbox.checked = true;
        actionTextElement.text("Unselect All");
      } else {
        allTasksCheckbox.checked = false;
        actionTextElement.text("Select All");
      }
    });
  }
  generateTaskHTML(item) {
    const taskId = getTaskId(item);
    const taskType = item.msgtype || "NA";
    let clickFunction = "";

    if (taskType === "NA") {
      clickFunction = `
                axProcessObj.openTask(this, ''${item.taskname}'',''${item.tasktype}'',''${item.transid}'',''${item.keyfield}'',''${item.keyvalue}'',''${item.recordid}'',''${item.taskid}'', ''${item.indexno}'',''${item.hlink_transid}'',''${item.hlink_params}'',''${item.processname}'',''${item.msgtype}'', ''LeftPanel'');axProcessObj.toggleRowBackground(this) 
                `;
    } else {
      clickFunction = `
                    openTicketDetails(''${taskId}'',''${window.top.mainUserName}'',''${taskType}'',''${item.hlink_params}'');
                `;
    }
    this.count++;
    const eventTime = axProcessObj.formatEventDate(item.eventdatetime);
    const displayTitleInitial = item.displaytitle
      ? item.displaytitle.charAt(0).toUpperCase()
      : "N/A";
    const isActive =
      item.cstatus?.toLowerCase() === "active" ? "active-row" : "completed-row";
    var userName =
      item.fromuser?.toLowerCase() === window.top.mainUserName
        ? " &nbsp; "
        : item.fromuser;
    var selectedclicked = document
      .querySelector(''.selectbtn[data-kt-menu-attach="parent"]'')
      .classList.contains("selectclicked");
    var statusIcon = this.getRowIcon(item);
    if (selectedclicked) {
      return `
                <div class="container listrow ${isActive}" data-status="${item.taskstatus}" data-index=${this.count}>
                <div class="row">
        
                    <div class="col-2 checkbox-wrapper">
                    <div>  <input type="checkbox" class="task-checkbox selectclicked" id="checkbox-${item.taskid}" checked
                                style="visibility:visible"></div>
                            <div class="user" style="display:none;">${statusIcon.iconHtml}</div>
                    </div>
                    <div class="col-7 col-content" style="${item.displaycontent ? "" : "display: flex; align-items: center; justify-content: center;"}">
                        <div> 
                            <a href="javascript:void(0)" data-tasktype="${item.msgtype}" class="tasktitle ProcessFlow_New-List-Title Procurement-list" data-taskid="${taskId}" onclick="${clickFunction}"
                                data-caption="${item.taskname}" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="${item.displaytitle ? item.displaytitle : ""}">
                                ${item.displaytitle || item.msgtype || "Untitled Task"}
                            </a>
                            </div>
                            <div class="taskcontent" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="${iitem.displaycontent || ""}">${item.displaycontent || ""}</div>
                        <div class="rowicons">${statusIcon.tooltip}</div>
                    
                    </div>
                        <div class="col-3 timespace">
                        <div class="nametime" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="${userName}">${userName}</div>
                            <div class="nametime" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="${eventTime}">${eventTime}
                            </div>
                        </div>
                    </div>
                </div>`;
    }
    return `
            <div class="container listrow ${isActive}"data-status="${item.taskstatus}" data-index=${this.count}>
            <div class="row">
                <div class="col-2 checkbox-wrapper">
                    <div><input type="checkbox" class="task-checkbox" id="checkbox-${item.taskid}"></div>
                    <div class="user">${statusIcon.iconHtml}</div>
                </div>
                <div class="col-7" style="${item.displaycontent ? "" : "display: flex; align-items: center; justify-content: center;"}">
                    <div>
                        <a href="javascript:void(0)" data-tasktype="${item.msgtype}" class="tasktitle ProcessFlow_New-List-Title Procurement-list" data-taskid="${taskId}"
                        onclick="${clickFunction}"
                        data-caption="${item.taskname}" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="${item.displaytitle ? item.displaytitle : ""}">
                            ${item.displaytitle || item.msgtype || "Untitled Task"}
                        </a>
                        </div>
                        <div class="taskcontent" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="${item.displaycontent || ""}">${item.displaycontent || ""}</div>
                        <div class="rowicons">${statusIcon.tooltip}</div>
            
                </div>
                <div class="timespace col-3">
                    <div class="nametime" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="${userName}">${userName}</div>
                    <div class="nametime" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="${eventTime}">${eventTime}</div>
                </div>
            
            </div>
        </div>`;
  }
  createAccordionForTimeframe(timeframe, tasks, existingAccordion) {
    const safeTimeframe = String(timeframe || "Other");
    const sectionIdSuffix = safeTimeframe
      .replace(/\s+/g, "")
      .replace(/[^\w-]/g, "");
    const isToday = timeframe === "Today" ? ''style="display: none;"'' : "";
    const accHTML = `
                <div class="accordion accordion-flush"  id="section-${sectionIdSuffix}">
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="heading-${timeframe}" ${isToday}>
                            <button class="accordion-button" type="button"  
                                data-bs-target="#collapse-${sectionIdSuffix}" aria-expanded="false" 
                                aria-controls="collapse-${sectionIdSuffix}" >
                                ${timeframe}
                            </button>
                        </h2>
                        <div id="collapse-${sectionIdSuffix}" class="accordion-collapse collapse show" 
                            aria-labelledby="heading-${sectionIdSuffix}" data-bs-parent="#section-${sectionIdSuffix}">
                            <div class="accordion-body">
                                ${tasks.map((task) => this.generateTaskHTML(task)).join("")}
                            </div>
                        </div>
                    </div>
                </div>`;
    // document
    //   .getElementById("plistContent")
    //   .insertAdjacentHTML("beforeend", accHTML);
    // const currentSection = document.getElementById(
    //   `section-${sectionIdSuffix}`,
    // );
    const plistContent = document.getElementById("plistContent");

if (!plistContent) return;

plistContent.insertAdjacentHTML(
    "beforeend",
    accHTML
);

const currentSection = document.getElementById(
    `section-${sectionIdSuffix}`
);

if (!currentSection) return;
    const previousSection = currentSection?.previousElementSibling;
    const previousSectioncollapseButton =
      previousSection?.querySelector(".accordion-button");
    if (previousSection && previousSectioncollapseButton != null) {
      if (previousSectioncollapseButton) {
        previousSectioncollapseButton.classList.add("show-collapse-button");
        previousSectioncollapseButton.setAttribute(
          "data-bs-toggle",
          "collapse",
        );
      } else {
        previousSectioncollapseButton.classList.remove("show-collapse-button");
        previousSectioncollapseButton.removeAttribute(
          "data-bs-toggle",
          "collapse",
        );
      }
    }
  }
  showNoMoreRecords() {
    const container = document.getElementById("plistContent");
    const existingMessage = container.querySelector(".no-more-records");
    if (!existingMessage) {
      const messageDiv = document.createElement("div");
      messageDiv.textContent = "No more records to display.";
      messageDiv.className = "no-more-records";
      messageDiv.style.color = "red";
      messageDiv.style.margin = "10px";
      messageDiv.style.padding = "10px";
      messageDiv.style.textAlign = "center";
      container.appendChild(messageDiv);
    }
    var currentSection = document.getElementById(`section-Previousrecords`);
    currentSection
      ?.querySelector(".accordion-button")
      .classList.add("show-collapse-button");
    currentSection
      ?.querySelector(".accordion-button")
      .setAttribute("data-bs-toggle", "collapse");
  }
  processListData(plst, col) {
    try {
      let returnData = "";
      // Group items by date
      const eventDate = plst.eventdatetime.split(" ")[0]; // ''12/11/2024''
      const groupedData = plst.reduce((acc, item) => {
        const timeframe = axProcessObj.getTimeframe(eventDate);
        if (!acc[timeframe]) {
          acc[timeframe] = [];
        }
        acc[timeframe].push(item);
        return acc;
      }, {});
      Object.keys(groupedData).forEach((timeframe, index) => {
        const sectionId = `section-${index}`;
        const collapseId = `collapse-${index}`;
        returnData += `
                        <div class="accordion accordion-flush" id="${sectionId}">
                            <div class="accordion-item">
                            <h2 class="accordion-header" id="heading-${index}">
                                <button class="accordion-button" type="button" data-bs-target="#${collapseId}" aria-expanded="false" aria-controls="${collapseId}">
                                ${timeframe} 
                                </button>
                            </h2>
                            <div id="${collapseId}" class="accordion-collapse collapse" aria-labelledby="heading-${index}" data-bs-parent="#${sectionId}">
                                <div class="accordion-body">
                                ${groupedData[timeframe].map((item) => `<p>Content for ${item.date}</p>`).join("")}
                                </div>
                            </div>
                            </div>
                        </div>
                        `;
      });
      return returnData;
    } catch (error) {
      console.error("Error processing task data:", error.message);
      return "<p>Error processing task data.</p>";
    }
  }
  getProStatusDetails(col, plst) {
    let _this = {
      counter: 0,
      returnProStatus: ``,
    };
    if (col.caption == "Task Name") {
      _this.counter = 1;
      _this.icon = plst.displayicon;
      _this.taskType =
        this.processVars.pStatus[plst.tasktype.toLowerCase()] || "make";
      _this.title = "";
    } else if (col.caption == "Next Step") {
      _this.counter = plst.nexttask != "" ? plst.nexttask.split(",").length : 0;
      _this.nextTask = plst.nexttask.split(",");
    }
    let i = 0;
    while (i < _this.counter) {
      if (col.caption == "Next Step") {
        _this.curTask = _this.nextTask[i].split("~");
        _this.icon = _this.curTask[0];
        _this.taskType =
          this.processVars.pStatus[_this.curTask[1].toLowerCase()] || "make";
        _this.title = _this.curTask[2];
      }
      _this.returnProStatus += `<button class="btn btn-icon btn-sm ${_this.taskType.bgColor} border ${_this.taskType.borderColor} shadow-sm flex-column me-2" ${_this.title != "" ? `title="${_this.title}"` : ""}>
                    <span class="blinker bullet bullet-dot h-8px w-8px position-relative bottom-25 start-25 animation-blinkz ${_this.taskType.color}"></span>
                    <span class="material-icons material-icons-style material-icons-3 mt-n2 ${_this.taskType.iconColor}">${_this.icon}</span>
                </button>`;
      i++;
    }
    return _this.returnProStatus;
  }
  taskFilter(type) {
    ShowDimmer(true);
    let tryFilter = {
      user: document.getElementById("pdFilUser").value || "",
      from:
        document.getElementById("pdFilFrom").value?.replaceAll("-", "/") || "",
      to: document.getElementById("pdFilTo").value?.replaceAll("-", "/") || "",
    };
    tryFilter.allTrs = document.querySelectorAll(
      "#pendingList tr, #completedList tr",
    );
    if (type == "reset") {
      document.getElementById("pdFilUser").value = "";
      document.getElementById("pdFilFrom").value = "";
      document.getElementById("pdFilTo").value = "";
      let _leftType = $("#PROFLOW_Left li a.active").attr("id");
      if (_leftType == "pending") this.fetchProcessList("ProcessList");
      else this.fetchProcessList("ProcessList", "TaskCompletion");
    } else if (
      type == "filter" &&
      (tryFilter && (tryFilter.user || tryFilter.from || tryFilter.to)) == ""
    ) {
      ShowDimmer(false);
      this.catchError("Filter parameters cannot be left empty..!!");
    } else {
      let _leftType = $("#PROFLOW_Left li a.active").attr("id");
      let _this = this,
        data = {},
        url = "";
      url = "../aspx/AxPEG.aspx/AxGetFilteredActiveTasks";
      data = {
        filterType: _leftType,
        pageNo: _pageno,
        pageSize: _pagesize,
        fromuser: tryFilter.user,
        processname: "",
        fromdate: tryFilter.from,
        todate: tryFilter.to,
        searchtext: "",
      };
      this.callAPI(url, data, true, (result) => {
        if (result.success) {
          let json = JSON.parse(result.response);
          let dataResult = _this.dataConvert(json, "ARM");
          TaskCount = dataResult.result.count;
          if (typeof _leftType != "undefined" && _leftType == "completed") {
            if (
              typeof dataResult.result.completedtasks != "undefined" &&
              dataResult.result.completedtasks.length > 0
            ) {
              completedtasksJson = dataResult.result.completedtasks;
              _this.showProcessList("completed");
            } else {
              showAlertDialog("warning", "No task available.");
            }
          } else {
            if (
              typeof dataResult.result.pendingtasks != "undefined" &&
              dataResult.result.pendingtasks.length > 0
            ) {
              pendingtasksJson = dataResult.result.pendingtasks;
              _this.showProcessList("pending");
            } else {
              showAlertDialog("warning", "No task available.");
            }
          }
          document.getElementById("pdFilUser").value = "";
          document.getElementById("pdFilFrom").value = "";
          document.getElementById("pdFilTo").value = "";
          ShowDimmer(false);
        } else {
          ShowDimmer(false);
        }
      });
    }
  }
  taskSearch(type) {
    ShowDimmer(true);
    let trySearch = {
      searchVal: document.getElementById("advTextSearch").value || "",
    };
    //trySearch.allTrs = document.querySelectorAll(''#pendingList tr, #completedList tr'');
    if (type == "reset") {
      document.getElementById("advTextSearch").value = "";
      let _leftType = $("#PROFLOW_Left li a.active").attr("id");
      if (_leftType == "pending") this.fetchProcessList("ProcessList");
      else this.fetchProcessList("ProcessList", "TaskCompletion");
    } else if (type == "search" && (trySearch && trySearch.searchVal) == "") {
      ShowDimmer(false);
      this.catchError("Search cannot be left empty..!!");
    } else {
      let _leftType = $("#PROFLOW_Left li a.active").attr("id");
      let _this = this,
        data = {},
        url = "";
      url = "../aspx/AxPEG.aspx/AxGetFilteredActiveTasks";
      data = {
        filterType: _leftType,
        pageNo: _pageno,
        pageSize: _pagesize,
        fromuser: "",
        processname: "",
        fromdate: "",
        todate: "",
        searchtext: trySearch.searchVal,
      };
      this.callAPI(url, data, true, (result) => {
        if (result.success) {
          let json = JSON.parse(result.response);
          let dataResult = _this.dataConvert(json, "ARM");
          TaskCount = dataResult.result.count;
          if (typeof _leftType != "undefined" && _leftType == "completed") {
            if (
              typeof dataResult.result.completedtasks != "undefined" &&
              dataResult.result.completedtasks.length > 0
            ) {
              completedtasksJson = dataResult.result.completedtasks;
              _this.showProcessList("completed");
            } else {
              showAlertDialog("warning", "No task available.");
            }
          } else {
            if (
              typeof dataResult.result.pendingtasks != "undefined" &&
              dataResult.result.pendingtasks.length > 0
            ) {
              pendingtasksJson = dataResult.result.pendingtasks;
              _this.showProcessList("pending");
            } else {
              showAlertDialog("warning", "No task available.");
            }
          }
          document.getElementById("advTextSearch").value = "";
          ShowDimmer(false);
        } else {
          ShowDimmer(false);
        }
      });
    }
  }
  showProgress(elem) {
    setTimeout(function () {
      axProcessObj.beforeLoad();
    }, 100);
    let _this = this,
      data = {},
      url = "";
    url = "../aspx/AxPEG.aspx/AxGetProcess";
    let elemTaskId = elem?.dataset?.taskid || this.taskId;
    if (typeof elem != "undefined")
      data = {
        processName: this.processName,
        keyField: this.keyField,
        keyValue: this.keyValue,
      };
    else {
      let _thisEle = $($(".Procurement-list")[0]);
      data = {
        processName: _thisEle.data("processname"),
        keyField: _thisEle.data("keyfield"),
        keyValue: _thisEle.data("keyvalue"),
      };
      elemTaskId = _thisEle.data("taskid");
      this.processName = _thisEle.data("processname");
    }
    this.callAPI(url, data, true, (result) => {
      if (result.success) {
        _this.hideDefaultCenterPanel();
        ShowDimmer(false);
        let json = JSON.parse(result.response);
        let dataResult = _this.dataConvert(json, "ARM");
        let sno = 1;
        const container = document.querySelector("#horizontal-processbar");
        if (container) {
          container.innerHTML = "";
        }
        dataResult.forEach((rowData, idx) => {
          let tempTaskType = rowData.tasktype.toUpperCase();
          if (["IF", "ELSE", "ELSE IF", "END"].indexOf(tempTaskType) == -1) {
            if (rowData.indexno == "1" && this.inValid(rowData.taskstatus)) {
              rowData.taskstatus = "pending";
            } else if (rowData.taskstatus == "Active") {
              rowData.taskstatus = "pending";
            }
            if (this.isNullOrEmpty(rowData.taskstatus) && rowData.indexno > 1) {
              rowData.taskstatus = "disabled";
            } else if (
              ["APPROVED", "REJECTED", "RETURNED", "CHECKED", "MADE"].indexOf(
                rowData.taskstatus?.toUpperCase(),
              ) > -1
            ) {
              rowData.taskstatus = "completed";
            }
            //if (this.taskId == rowData.taskid) {
            //    rowData.taskstatus = "active";
            //}
            if (this.isNullOrEmpty(rowData.recordid)) {
              rowData.recordid = "0";
            }
            rowData.sno = sno;
            sno++;

            const processbar = document.querySelector("#horizontal-processbar");

if (processbar) {
    processbar.insertAdjacentHTML(
        "beforeend",
        `${Handlebars.compile(this.horizontalStepHtml)(rowData)}`
    );
}
            // document
            //   .querySelector("#horizontal-processbar")
            //   .insertAdjacentHTML(
            //     "beforeend",
            //     ` ${Handlebars.compile(this.horizontalStepHtml)(rowData)} `,
            //   );
          }
        });
        if (this.taskCompleted) {
          this.taskCompleted = false;
          let nextTask = this.getNextTaskInProcess();
          if (!nextTask) {
            if (
              !this.inValid(document.querySelector(".horizontal-steps.pending"))
            ) {
              this.calledFrom = "ProgressBar";
              document.querySelector(".horizontal-steps.pending")?.click();
              document
                .querySelector(".horizontal-steps.pending")
                ?.scrollIntoView();
              elemTaskId = document.querySelector(".horizontal-steps.pending")
                .dataset?.taskid;
            } else if (
              !this.inValid(document.querySelector(".horizontal-steps"))
            ) {
              this.calledFrom = "ProgressBar";
              document.querySelector(".horizontal-steps")?.click();
              document.querySelector(".horizontal-steps")?.scrollIntoView();
              elemTaskId = document.querySelector(".horizontal-steps.pending")
                .dataset?.taskid;
            }
          }
        } else if (!this.inValid(this.taskId)) {
          this.calledFrom = "ProgressBar";
          let selector = `.horizontal-steps[data-taskid="${this.taskId}"]`;
          if (!this.inValid(document.querySelector(selector))) {
            document.querySelector(selector)?.click();
            document.querySelector(selector)?.scrollIntoView();
            if (this.inValid(elemTaskId))
              elemTaskId = document.querySelector(selector).dataset?.taskid;
          }
          this.target = null;
        } else if (!this.inValid(this.target)) {
          this.calledFrom = "ProgressBar";
          let pendingSelector = `.horizontal-steps.pending[data-taskname="${this.target}"]`;
          let selector = `.horizontal-steps[data-taskname="${this.target}"]`;
          if (!this.inValid(document.querySelector(pendingSelector))) {
            document.querySelector(selector)?.click();
            document.querySelector(pendingSelector)?.scrollIntoView();
          } else if (!this.inValid(document.querySelector(selector))) {
            document.querySelector(selector)?.click();
            document.querySelector(selector)?.scrollIntoView();
          }
          if (this.inValid(elemTaskId))
            elemTaskId = document.querySelector(selector).dataset?.taskid;
          this.target = null;
        } else {
          this.calledFrom = "ProgressBar";
          let pendingSelector = `.horizontal-steps.pending`;
          let selector = `.horizontal-steps`;
          if (!this.inValid(document.querySelector(pendingSelector))) {
            document.querySelector(selector)?.click();
            document.querySelector(pendingSelector)?.scrollIntoView();
          } else if (!this.inValid(document.querySelector(selector))) {
            document.querySelector(selector)?.click();
            document.querySelector(selector)?.scrollIntoView();
          }
          if (this.inValid(elemTaskId))
            elemTaskId = document.querySelector(selector).dataset?.taskid;
          this.target = null;
        }
        if (!_this.inValid(elemTaskId)) {
          _this.setActiveInList(elemTaskId);
        }
        setTimeout(function () {
          axProcessObj.afterLoad();
        }, 100);
      } else {
        ShowDimmer(false);
      }
    });
  }
  showProgressNew() {
    setTimeout(function () {
      axProcessObj.beforeLoad();
    }, 100);
    let _this = this,
      data = {},
      url = "";
    url = "../../aspx/AxPEG.aspx/AxPEGGetTaskDetails";
    data = {
      processName: this.processName,
      taskType: this.taskType,
      taskId: this.taskId,
      keyValue: this.keyValue,
    };
    this.callAPI(url, data, true, (result) => {
      if (result.success) {
        let json = JSON.parse(result.response);
        let dataResult = _this.dataConvert(json, "ARM");
        processflowJson = dataResult.result.processflow;
        if (processflowJson.length > 0) {
          //ShowDimmer(false);
          let dataResult = processflowJson;
          let sno = 1;
          const container = document.querySelector("#horizontal-processbar");
          if (container) {
            container.innerHTML = "";
          }
          dataResult.forEach((rowData, idx) => {
            let tempTaskType = rowData.tasktype.toUpperCase();
            if (["IF", "ELSE", "ELSE IF", "END"].indexOf(tempTaskType) == -1) {
              if (rowData.indexno == "1" && this.inValid(rowData.taskstatus)) {
                rowData.taskstatus = "pending";
              } else if (rowData.taskstatus == "Active") {
                rowData.taskstatus = "pending";
              }
              if (
                this.isNullOrEmpty(rowData.taskstatus) &&
                rowData.indexno > 1
              ) {
                rowData.taskstatus = "disabled";
              } else if (
                ["APPROVED", "REJECTED", "RETURNED", "CHECKED", "MADE"].indexOf(
                  rowData.taskstatus?.toUpperCase(),
                ) > -1
              ) {
                rowData.taskstatus = "completed";
              }
              //if (this.taskId == rowData.taskid) {
              //    rowData.taskstatus = "active";
              //}
              if (this.isNullOrEmpty(rowData.recordid)) {
                rowData.recordid = "0";
              }
              rowData.sno = sno;
              sno++;
             const processbar = document.querySelector("#horizontal-processbar");

if (!processbar) return;

processbar.insertAdjacentHTML(
    "beforeend",
    `${Handlebars.compile(this.horizontalStepHtml)(rowData)}`
);
            }
          });
          setTimeout(function () {
            axProcessObj.afterLoad();
          }, 100);
        } else {
          ShowDimmer(false);
        }
      } else {
        ShowDimmer(false);
      }
    });
  }
  beforeLoad() {}
  afterLoad() {}
  showTimeLine() {
    axTimeLineObj = new ProcessTimeLine();
    axTimeLineObj.keyvalue = this.keyValue;
    axTimeLineObj.processName = this.processName;
    if (!this.inValid(axTimeLineObj.keyvalue) && axTimeLineObj.keyvalue != "NA")
      axTimeLineObj.getTimeLineData();
  }
  showList() {
    document
      .querySelectorAll("#showList,#PROFLOW-profile-container")
      .forEach((item) => {
        item.classList.add("d-none");
      });
    document
      .querySelectorAll("#plistAccordion,#showProgress")
      .forEach((item) => {
        item.classList.remove("d-none");
      });
  }
  showDefaultList() {
    document
      .querySelectorAll("#showList,#PROFLOW-profile-container,#showProgress")
      .forEach((item) => {
        item.classList.add("d-none");
      });
    document.querySelectorAll("#plistAccordion").forEach((item) => {
      item.classList.remove("d-none");
    });
  }
  refreshCards(cardIds, cardParamsValues) {
    if (this.inValid(cardIds)) return;
    $.ajax({
      url: "../aspx/AxPEG.aspx/AxRefreshCardsData",
      type: "POST",
      cache: false,
      async: true,
      data: JSON.stringify({
        cardsIds: cardIds.join(","),
        cardsParams: cardParamsValues,
      }),
      dataType: "json",
      contentType: "application/json",
      success: (data) => {
        if (data.d && data.d != "") {
          let result = JSON.parse(data.d);
          cardsData.value = JSON.parse(cardsData.value);
          var mergedCardsData = cardsData.value.concat(result.result.cards);
          var uniqueCardsData = mergedCardsData.reduce((acc, current) => {
            const x = acc.find(
              (item) => item.axp_cardsid === current.axp_cardsid,
            );
            if (!x) {
              return acc.concat([current]);
            } else {
              x.cardsql = current.cardsql; // Update the "cardsql" property value of the matching element
              return acc;
            }
          }, []);
          cardsData.value = JSON.stringify(uniqueCardsData);
          cardsDesign.value = "";
        } else {
          showAlertDialog("error", "Error while loading cards dashboard..!!");
          return;
        }
        if (xmlMenuData != "") {
          xmlMenuData = xmlMenuData.replace(/&apos;/g, "''");
          var xml = parseXml(xmlMenuData);
          var xmltojson = xml2json(xml, "");
          menuJson = JSON.parse(xmltojson);
        }
        appGlobalVarsObject._CONSTANTS.menuConfiguration = $.extend(
          true,
          {},
          appGlobalVarsObject._CONSTANTS.menuConfiguration,
          {
            menuJson: menuJson,
          },
        );
        // try {
        appGlobalVarsObject._CONSTANTS.cardsPage = $.extend(
          true,
          {},
          appGlobalVarsObject._CONSTANTS.cardsPage,
          {
            setCards: true,
            cards: (
              JSON.parse(
                cardsData.value !== ""
                  ? ReverseCheckSpecialChars(cardsData.value)
                  : "[]",
                function (k, v) {
                  try {
                    return typeof v === "object" ||
                      isNaN(v) ||
                      v.toString().trim() === ""
                      ? v
                      : typeof v == "string" &&
                          (v.startsWith("0") || v.startsWith("-"))
                        ? parseFloat(v, 10)
                        : JSON.parse(v);
                  } catch (ex) {
                    return v;
                  }
                  //0 & - starting with does not gets parsed in json.parse
                  //json.parse is used because it porcess int, float and boolean together
                },
              ) || []
            ).map((arr) =>
              _.mapKeys(arr, (value, key) => key.toString().toLowerCase()),
            ),
            design: (
              JSON.parse(
                cardsDesign.value !== "" ? cardsDesign.value : "[]",
                function (k, v) {
                  try {
                    return typeof v === "object" ||
                      isNaN(v) ||
                      v.toString().trim() === ""
                      ? v
                      : typeof v == "string" &&
                          (v.startsWith("0") || v.startsWith("-"))
                        ? parseFloat(v, 10)
                        : JSON.parse(v);
                  } catch (ex) {
                    return v;
                  }
                },
              ) || []
            ).map((arr) =>
              _.mapKeys(arr, (value, key) => key.toString().toLowerCase()),
            ),
            enableMasonry: cardsDashboardObj.enableMasonry,
            staging: {
              iframes: ".splitter-wrapper",
              cardsFrame: {
                div: ".cardsPageWrapper",
                cardsDiv: ".cardsPlot",
                cardsDesigner: ".cardsDesigner",
                cardsDesignerToolbar: ".designer",
                editSaveButton: ".editSaveCardDesign",
                icon: "span.material-icons",
                divControl: "#arrangeCards",
              },
            },
          },
        );
        var lcm = appGlobalVarsObject.lcm;
        var tempaxpertUIObj = $.axpertUI.init({
          isHybrid: appGlobalVarsObject._CONSTANTS.isHybrid,
          isMobile: cardsDashboardObj.isMobile,
          compressedMode: appGlobalVarsObject._CONSTANTS.compressedMode,
          dirLeft: cardsDashboardObj.dirLeft,
          axpertUserSettings: {
            settings: appGlobalVarsObject._CONSTANTS.axpertUserSettings,
          },
          cardsPage: appGlobalVarsObject._CONSTANTS.cardsPage,
        });
        appGlobalVarsObject._CONSTANTS.cardsPage = tempaxpertUIObj.cardsPage;
      },
      error: (error) => {
        showAlertDialog("error", "Error while loading cards dashboard..!!");
        return;
      },
      failure: (error) => {
        showAlertDialog("error", "Error while loading cards dashboard..!!");
        return;
      },
    });
  }
}
var axProcessTreeObj;
class AxProcessTree {
  constructor(processName) {
    this.definitionFetched = false;
    this.dataSources = [];
    this.processName = processName;
    this.stepHtml = `
                <div class="step">
                    <div>
                        <div class="circle ">
                            <i class="fa fa-check"></i>
                            <span class="Emp-steps-counts">{{sno}}</span>
                        </div>
                        <div class="line"></div>
                    </div>
                    <div class="Task-process-wrapper">
                        {{groupNameHtml}}
                        {{taskCaptionHtml}}
                    </div>
                </div>`;
    this.groupNameHtml = `
                <div class="title">
                    <a href="javascript:void(0)">{{taskgroup}}</a>
                    <span data-groupname="{{taskgroup}}" class="Process-flow accordion-icon rotate">
                        <span  class="material-icons material-icons-style material-icons-2">chevron_right</span>                    
                    </span>
                </div>`;
    this.taskCaptionHtml = `<div class="process-sub-flow" data-groupname="{{taskgroup}}" data-tasktype="{{tasktype}}">`;
    this.taskCaptionHtml += `<div class="positionRel Task-process-list">`;
    this.taskCaptionHtml += `<a href="javascript:void(0)" onclick="return false;">{{taskname}}</a>`;
    this.taskCaptionHtml += `</div></div>`;
  }
  fetchProcessDefinition(name) {
    let _this = this;
    let url = "../aspx/AxPEG.aspx/AxGetProcessDefinition";
    let data = { processName: this.processName };
    this.callAPI(url, data, false, (result) => {
      if (result.success) {
        let json = JSON.parse(result.response);
        let dataResult = _this.dataConvert(json, "ARM");
        _this.dataSources[name] = dataResult;
        _this.definitionFetched = true;
      }
    });
  }
  showProcessTree() {
    try {
      let myModal = new BSModal(
        `modal_ProcessTree`,
        "",
        `<div class="PROFLOW-Info-Steps ax-data accordion arrows" id="procflow-steps"></div>`,
        (opening) => {
          ShowDimmer(true);
          if (!this.definitionFetched) {
            this.fetchProcessDefinition("Process");
          }
          this.showProcessDefinition();
          ShowDimmer(false);
        },
        (closing) => {
          //document.querySelector(''#procflow-steps'').innerHTML = "";
        },
      );
      myModal.changeSize("md");
      myModal.hideHeader();
      myModal.hideFooter();
      myModal.showFloatingClose();
    } catch (error) {
      showAlertDialog("error", error.message);
    }
  }
  showProcessDefinition() {
    if (document.querySelector("#procflow-steps").innerHTML != "") return;
    this.processFlowObj = {};
    this.dataSources["Process"].forEach((rowData, idx) => {
      if (this.isUndefined(this.processFlowObj[rowData.taskgroup])) {
        this.processFlowObj[rowData.taskgroup] = {};
        this.processFlowObj[rowData.taskgroup].group_name_html = "";
        this.processFlowObj[rowData.taskgroup].task_caption_html = "";
      }
      if (this.isNullOrEmpty(rowData.taskstatus) && rowData.indexno > 1) {
        rowData.taskstatus = "disabled";
      }
      if (this.isNullOrEmpty(rowData.recordid)) {
        rowData.recordid = "0";
      }
      let taskGroup = this.processFlowObj[rowData.taskgroup];
      taskGroup.indexno = rowData.indexno;
      taskGroup.group_name_html = Handlebars.compile(this.groupNameHtml)(
        rowData,
      );
      taskGroup.task_caption_html += Handlebars.compile(this.taskCaptionHtml)(
        rowData,
      );
    });
    document.querySelector("#procflow-steps").innerHTML = "";
    let sno = 1;
    for (let [key, value] of Object.entries(this.processFlowObj)) {
        const processbar = document.querySelector("#procflow-steps");

if (!processbar) return;

processbar.insertAdjacentHTML(
    "beforeend",
   ` ${this.stepHtml.replace("{{sno}}", sno).replace("{{groupNameHtml}}", value.group_name_html).replace("{{taskCaptionHtml}}", value.task_caption_html)} `
);
    //   document
    //     .querySelector("#procflow-steps")
    //     .insertAdjacentHTML(
    //       "beforeend",
    //       ` ${this.stepHtml.replace("{{sno}}", sno).replace("{{groupNameHtml}}", value.group_name_html).replace("{{taskCaptionHtml}}", value.task_caption_html)} `,
    //     );
      sno++;
    }
    ShowDimmer(false);
    $(".accordion-icon").click(function () {
      let groupname = $(this).attr("data-groupname");
      $(this).toggleClass("rotate");
      $(`.process-sub-flow[data-groupname="${groupname}"]`).toggle();
    });
  }
  callAPI(url, data, async, callBack) {
    let _this = this;
    var xhr = new XMLHttpRequest();
    xhr.open("POST", url, async);
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    if (_this.isAxpertFlutter) {
      xhr.setRequestHeader("Authorization", `Bearer ${armToken}`);
      data["armSessionId"] = armSessionId;
    }
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
          callBack({ success: true, response: this.responseText });
        } else {
          _this.catchError(this.responseText);
          callBack({ success: false, response: this.responseText });
        }
      }
    };
    xhr.send(JSON.stringify(data));
  }
  catchError(error) {
    showAlertDialog("error", error);
  }
  showSuccess(message) {
    showAlertDialog("success", message);
  }
  dataConvert(data, type) {
    if (type == "AXPERT") {
      try {
        data = JSON.parse(data.d);
        if (typeof data.result[0].result.row != "undefined") {
          return data.result[0].result.row;
        }
        if (typeof data.result[0].result != "undefined") {
          return data.result[0].result;
        }
      } catch (error) {
        ShowDimmer(false);
        this.catchError(error.message);
      }
    } else if (type == "ARM") {
      try {
        if (!this.isAxpertFlutter) data = JSON.parse(data.d);
        if (data.result && data.result.success) {
          if (!this.isUndefined(data.result.data)) {
            return data.result.data;
          }
        } else {
          if (!this.isUndefined(data.result.message)) {
            this.catchError(data.result.message);
          }
        }
      } catch (error) {
        ShowDimmer(false);
        this.catchError(error.message);
      }
    }
    return data;
  }
  generateFldId() {
    return `fid${Date.now()}${Math.floor(Math.random() * 90000) + 10000}`;
  }
  isEmpty(elem) {
    return elem == "";
  }
  isNull(elem) {
    return elem == null;
  }
  isNullOrEmpty(elem) {
    return elem == null || elem == "";
  }
  inValid(elem) {
    return elem == null || typeof elem == "undefined" || elem == "";
  }
  isUndefined(elem) {
    return typeof elem == "undefined";
  }
}
var axTimeLineObj;
class ProcessTimeLine {
  constructor() {
    this.keyvalue = "";
    this.processName = "";
    this.make = `<li class="make">                                   
                        <p class="T-Desc">{{taskname}}#{{keyvalue}}</p>
                <p class="T-Heading">{{taskfromuser}}</p>
                <div class="time">{{tasktime}}</div>
                    </li>`;
    this.check = `<li class="check">
                        <p class="T-Desc">{{taskname}}#{{keyvalue}} - {{taskstatus}}</p>
                        <p class="T-Heading">{{taskfromuser}}</p>                    
                <div class="time">{{tasktime}}</div>
                    </li>`;
    this.approve = `<li class="approve">
                    <p class="T-Desc">{{taskname}}#{{keyvalue}} - {{taskstatus}}</p>
                        <p class="T-Heading">{{taskfromuser}}</p>                    
                <div class="time">{{tasktime}}</div>
                    </li>`;
  }
  getTimeLineData() {
    ShowDimmer(true);
    let _this = this;
    let url = "../aspx/AxPEG.aspx/AxGetTimelineData";
    let data = { keyValue: _this.keyvalue, processName: _this.processName };
    this.callAPI(url, data, true, (result) => {
      if (result.success) {
        let json = JSON.parse(result.response);
        let dataResult = _this.dataConvert(json, "ARM");
        _this.constructTimeline(dataResult);
        ShowDimmer(false);
      } else {
        ShowDimmer(false);
      }
    });
  }
  constructTimeline(data) {
    if (this.isUndefined(data) || data.length == 0) {
      document.querySelector(".Timel-sessions").classList.add("d-none");
      document.querySelector("#nodata").classList.remove("d-none");
    } else {
      document.querySelector("#nodata").classList.add("d-none");
      document.querySelector(".Timel-sessions").classList.remove("d-none");
      var timelineData = "";
      document.querySelector(".Timel-sessions").innerHTML = "";
      data.forEach((rowData) => {
        timelineData += Handlebars.compile(
          this[rowData.tasktype.toLowerCase()],
        )(rowData);
      });
      const timelineSession = document.querySelector(".Timel-sessions");

if (timelineSession) {
    timelineSession.insertAdjacentHTML(
        "beforeend",
        timelineData
    );
}
    //   document
    //     .querySelector(".Timel-sessions")
    //     .insertAdjacentHTML("beforeend", timelineData);
    }
  }
  callAPI(url, data, async, callBack) {
    let _this = this;
    var xhr = new XMLHttpRequest();
    xhr.open("POST", url, async);
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    if (_this.isAxpertFlutter) {
      xhr.setRequestHeader("Authorization", `Bearer ${armToken}`);
      data["armSessionId"] = armSessionId;
    }
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
          callBack({ success: true, response: this.responseText });
        } else {
          _this.catchError(this.responseText);
          callBack({ success: false, response: this.responseText });
        }
      }
    };
    xhr.send(JSON.stringify(data));
  }
  catchError(error) {
    showAlertDialog("error", error);
  }
  showSuccess(message) {
    showAlertDialog("success", message);
  }
  dataConvert(data, type) {
    if (type == "AXPERT") {
      try {
        data = JSON.parse(data.d);
        if (typeof data.result[0].result.row != "undefined") {
          return data.result[0].result.row;
        }
        if (typeof data.result[0].result != "undefined") {
          return data.result[0].result;
        }
      } catch (error) {
        this.catchError(error.message);
      }
    } else if (type == "ARM") {
      try {
        if (!this.isAxpertFlutter) data = JSON.parse(data.d);
        if (data.result && data.result.success) {
          if (!this.isUndefined(data.result.data)) {
            return data.result.data;
          }
        } else {
          if (!this.isUndefined(data.result.message)) {
            this.catchError(data.result.message);
          }
        }
      } catch (error) {
        this.catchError(error.message);
      }
    }
    return data;
  }
  generateFldId() {
    return `fid${Date.now()}${Math.floor(Math.random() * 90000) + 10000}`;
  }
  isEmpty(elem) {
    return elem == "";
  }
  isNull(elem) {
    return elem == null;
  }
  isNullOrEmpty(elem) {
    return elem == null || elem == "";
  }
  isUndefined(elem) {
    return typeof elem == "undefined";
  }
  inValid(elem) {
    return elem == null || typeof elem == "undefined" || elem == "";
  }
}
// function loadInboxUsers() {
// const params = {
//     adsNames: ["DS_TeamMember"],
//     refreshCache: false,
//     sqlParams: {}
// };
// parent.GetDataFromAxList(params, function success(res) {
//     let rows = [];
//     try {
//     const parsed = JSON.parse(res);
//     rows = parsed?.result?.data?.[0]?.data || [];
//     } catch(e){}
//     if (!rows.length) return;
//     const select = document.getElementById("userSelect");
//     select.innerHTML = "";
//     const DEFAULT_USER =
//     parent.mainUserName ||
//     parent.loggedUserName ||
//     parent.userName ||
//     "";
//     // Build options
//     rows.forEach(r => {
//     const username = r.username || r.user_name || r.UserName;
//     const display  = r.displayname || username;
//     const opt = document.createElement("div");
//     opt.value = username;
//     opt.className = "dropdown-item team-user";   // 👈 keep same style
//     opt.setAttribute("data-id", username);
//     opt.textContent = display;
//     select.appendChild(opt);
//     });
//     // Set default only if exists in DS
//     const found = rows.find(r =>
//     (r.username || r.user_name || r.UserName) === DEFAULT_USER
//     );
//     currentInboxUser = found ? DEFAULT_USER : rows[0].username;
//     select.value = currentInboxUser;
// }, function error() {
//     console.error("Failed to load inbox users");
// });
// }
// document.addEventListener("DOMContentLoaded", loadInboxUsers);
// const userSelect = document.getElementById("userSelect");
// userSelect.addEventListener("change", function () {
//     const selectedUser = this.value;
//         // 2️⃣ Reset right panel UI
//     showDefaultRightPanel();
//     onInboxUserChange(selectedUser);
// });
$(document).ready(function () {
  ShowDimmer(true);
  axProcessObj = new AxProcessFlow();
  axProcessObj.init();
  $("#PROFLOW_Right").on("click", ".iview-file", function () {
    debugger;
    const fileName = $(this).data("filename");
    const fullPath = $(this).data("fullpath");
    downloadIviewFile(fileName, fullPath);
  });
});
const BUTTON_MAP = {
  1: { label: "Send", class: "btn-primary" },
  2: { label: "Return", class: "btn-warning" },
  3: { label: "Complete", class: "btn-success" },
  4: { label: "Drop", class: "btn-dark" },
  5: { label: "Close", class: "btn-danger" },
  6: { label: "Status Update", class: "btn-secondary" },
  7: { label: "Reschedule", class: "btn-info" },
  8: { label: "View Form", class: "btn-info" }
};
const TRANS_MAP = {
  Send: "send",
  Return: "retun",
  Complete: "taskc",
  Drop: "drop",
  Close: "close",
  "Status Update": "stupd",
  Reschedule: "infor",
  "View Form": "viewform"
};
window.openTicketDetails = function (taskId, userName, taskType, hlink_params) {
  // ✅ HANDLE EXPORT FIRST (EXIT EARLY)
  if (taskType && taskType.toLowerCase().includes("export")) {
    console.log("EXPORT detected");
    axProcessObj.DownloadExportFile(hlink_params);
    return; // 🚫 STOP everything else
  }
  // ✅ store current task
  window.currentTaskId = taskId;
  const stepperContainer = document.querySelector("#Process-stepper");
  if (stepperContainer) {
    stepperContainer.classList.add("d-none"); // ✅ SHOW parent
  }
  const params = {
    adsNames: ["DS_InboxHistory"],
    sqlParams: {
      uname: userName,
      ptaskid: taskId,
    },
  };
  parent.GetDataFromAxList(
    params,
    function success(response) {
      try {
        const parsed = JSON.parse(response);
        const rows = parsed?.result?.data?.[0]?.data || [];
        renderTicketDetails(rows, taskId);
      } catch (e) {
        console.error("❌ Parse error:", e);
      }
    },
    function error(err) {
      console.error("❌ DS_InboxHistory failed:", err);
    },
  );
};
function renderTicketDetails(rows) {
  if (!rows.length) {
    const container = document.getElementById("Tickets_details_view");
    const iframe = document.getElementById("process_iframe");
    if (iframe) iframe.classList.add("d-none"); // hide iframe
    container.innerHTML = `
        <div class="no-data-found text-center p-4">
            <h5>No data found</h5>
        </div>
    `;
    return;
  }
  // Sort newest → oldest
  rows.sort((a, b) => new Date(b.datetime) - new Date(a.datetime));
  const first = rows[rows.length - 1]; // created
  const latest = rows[0]; // current status
  const iframe = document.getElementById("process_iframe");
  if (iframe) {
    iframe.classList.add("d-none"); // hide
  }
  const container = document.getElementById("Tickets_details_view");
  container.innerHTML = "";
  const createdText = `Task is created by ${first.From} to ${first.to_user} on ${formatDate(first.datetime)}`;
  const statusText = buildActionText(
    latest.action,
    latest.From,
    latest.to_user,
    latest.datetime,
  );

  if(!container){
    return
  }
  container.insertAdjacentHTML(
    "beforeend",
    `
            <div class="ticket-view">
    <div class="ticket-view-header">
                <h4>${first.taskname} - ${first.taskid}</h4>
                <div class="fw-semibold mt-1 ticket-header-desc">
                    ${createdText}
                </div>
                    </div>
                ${
                  (first.customername && first.customername !== "NA") ||
                  (first.companyname && first.companyname !== "NA")
                    ? `
                    <div class="mt-1 text-muted d-flex gap-4 flex-wrap">
                    ${
                      first.customername && first.customername !== "NA"
                        ? `<div><strong>Customer:</strong> ${first.customername}</div>`
                        : ""
                    }
                    ${
                      first.companyname && first.companyname !== "NA"
                        ? `<div><strong>Company:</strong> ${first.companyname}</div>`
                        : ""
                    }
                    </div>
                `
                    : ""
                }
                
                ${renderDescription(first.taskdescription)}
                <div class="mt-3 Status-wrapper">
                    <strong>Current Status:</strong>

                <div class="Status-desc"> ${statusText} </div>
                </div>
                ${renderFiles(first.files, first.filepath)}
                <!-- 🔘 ACTION BUTTONS FIRST -->
                <div class=" Status-Btns-wrapper">
                    ${renderButtons(latest.buttons, first.taskid)}
                </div>
                <!-- 📜 TASK HISTORY BELOW -->
                <div class="mt-4 Task-History-Wrap">
                    <div class="mb-2 history-header">
                        <strong>Task History</strong>
                    </div>
                    <div class="history-body">
                    ${rows
                      .map(
                        (r, i) => `
                    <div class="history-item mb-2">
                        <div class="Histroy-description-wrap">
                        <div class="Histroy-description-Date">  ${formatDate(r.datetime)} — </div>
                    <div class="Histroy-description"> ${normalizeAction(r.action)} by ${r.From} ${r.to_user && r.to_user !== "null" ? ` to ${r.to_user}` : ""} 
                        ${renderComment(r.comments, `hist-${i}`)}</div>
                        
                        </div>
                
                        
                    </div>
                    `,
                      )
                      .join("")}
                </div>
                
                </div>
            </div>
        `,
  );
}
function renderComment(comment, id) {
  if (!comment) return "";
  const maxLen = 100;
  if (comment.length <= maxLen) {
    return `<span class="history-comment ms-3"> — ${comment}</span>`;
  }
  const shortText = comment.slice(0, maxLen);
  return `
        <span class="history-comment ms-3">
            <span id="comment-short-${id}">${shortText}...</span>
            <span id="comment-full-${id}" style="display:none;"> — ${comment}</span>
            <a href="javascript:void(0)"
            class="ms-1"
            onclick="toggleComment(''${id}'')"
            id="comment-toggle-${id}">
            Read more
            </a>
        </span>
        `;
}
function toggleComment(id) {
  const shortEl = document.getElementById(`comment-short-${id}`);
  const fullEl = document.getElementById(`comment-full-${id}`);
  const toggleEl = document.getElementById(`comment-toggle-${id}`);
  if (!shortEl || !fullEl || !toggleEl) return;
  const isHidden = fullEl.style.display === "none";
  shortEl.style.display = isHidden ? "none" : "inline";
  fullEl.style.display = isHidden ? "inline" : "none";
  toggleEl.textContent = isHidden ? "Read less" : "Read more";
}
function normalizeAction(action) {
  const map = {
    send: "Sent",
    create: "Created",
    complete: "Completed",
    return: "Returned",
    drop: "Dropped",
    close: "Closed",
  };
  return map[action.toLowerCase()] || action;
}
function renderDescription(text = "") {
  const short = text.substring(0, 300);
  return `
            <div class="mt-3">
            
                <div id="descText" class="mt-1">
                    <span id="shortDesc">${short}</span>
                    <span id="fullDesc" style="display:none">${text}</span>
                </div>
                ${
                  text.length > 300
                    ? `
                    <a href="javascript:void(0)" id="toggleDesc" onclick="toggleDesc()">Read More</a>
                `
                    : ""
                }
            </div>
        `;
}
function toggleDesc() {
  const short = document.getElementById("shortDesc");
  const full = document.getElementById("fullDesc");
  const link = document.getElementById("toggleDesc");
  if (full.style.display === "none") {
    short.style.display = "inline";
    full.style.display = "inline";
    link.innerText = "Read Less";
  } else {
    short.style.display = "inline";
    full.style.display = "none";
    link.innerText = "Read More";
  }
}

function buildHistoryAccordion(row, index) {
  const filesHtml = renderFiles(row.files, row.filepath);
  return `
        <div class="accordion mb-2">
            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button ${index === 0 ? "" : "collapsed"}"
                            type="button"
                            data-bs-toggle="collapse"
                            data-bs-target="#collapse_${index}">
                        <div>
                            <strong>${formatDate(row.datetime)}</strong>

                            ${row.from} → ${row.to_user}
                            <span class="badge bg-secondary ms-2">${row.action}</span>
                        </div>
                    </button>
                </h2>
                <div id="collapse_${index}"
                    class="accordion-collapse collapse ${index === 0 ? "show" : ""}">
                    <div class="accordion-body">
                        
                        ${filesHtml}
                        
                    </div>
                </div>
            </div>
        </div>
        `;
}
function renderFiles(files, filepath) {
  if (!files || !filepath) return "";
  // keep original UNC path for API
  const basePath = filepath;
  const links = files
    .split(",")
    .map((file) => {
      const cleanFile = file.trim();
      const fullPath = `${basePath}\\${cleanFile}`;
      return `
            <a href="javascript:void(0)"
            class="badge bg-light text-dark me-2 text-decoration-none iview-file"
            title="Download ${cleanFile}"
            data-filename="${cleanFile}"
            data-fullpath="${fullPath}">
            📎 ${cleanFile}
            </a>
        `;
    })
    .join("");
  return `
        <div class="mt-2" style="margin-left:35px">
            <strong>Files:</strong>

            ${links}
        </div>
        `;
}
function formatDate(dt) {
  const d = new Date(dt);
  return d.toLocaleDateString("en-GB", {
    day: "2-digit",
    month: "short",
    year: "numeric",
  });
}
// function extractTaskId(text) {
//     if (!text) return null;
//     const match = text.match(/TASK-\d+/i);
//     return match ? match[0] : null;
// }
// function getTaskId(item) {
//     // 1️⃣ First try hlink_params (best source)
//     if (item.hlink_params) {
//         const match = item.hlink_params.match(/taskid=([^\\^]+)/i);
//         if (match) return match[1];
//     }
//     // 2️⃣ Try displaytitle
//     if (item.displaytitle) {
//         const match = item.displaytitle.match(/TASK-\d+/i);
//         if (match) return match[0];
//     }
//     // 3️⃣ Try displaycontent
//     if (item.displaycontent) {
//         const match = item.displaycontent.match(/TASK-\d+/i);
//         if (match) return match[0];
//     }
//     return null;
// }
function getTaskId(item) {
  const pattern = /\b(?:TSK|TASK|TKT)-\d+\b|\bTask ID-\d+\b/i;
  // 1️⃣ First try hlink_params
  if (item.hlink_params) {
    const match = item.hlink_params.match(pattern);
    if (match) return match[0];
  }
  // 2️⃣ Try displaytitle
  if (item.displaytitle) {
    const match = item.displaytitle.match(pattern);
    if (match) return match[0];
  }
  // 3️⃣ Try displaycontent
  if (item.displaycontent) {
    const match = item.displaycontent.match(pattern);
    if (match) return match[0];
  }
  return null;
}
function renderButtons(buttons, taskid) {
  if (!buttons) return "";

  let codes = buttons.includes(",") ? buttons.split(",") : buttons.split("");
  codes = [...new Set(codes.map((c) => c.trim()))];

  return `
    <div class="mt-4 action-buttons p-1">
      ${codes
        .map((code) => {
          const btn = BUTTON_MAP[code];
          if (!btn) return "";

          let transid = TRANS_MAP[btn.label];

          // Special handling for View Form
          if (btn.label === "View Form") {
            if (taskid.startsWith("TASK-") || taskid.startsWith("TKT-")) {
              transid = "Taskm";
            } else if (taskid.startsWith("TSK-")) {
              transid = "tassk";
            }
          }

          const url = `../../aspx/tstruct.aspx?transid=${transid}&taskid=${taskid}&act=open`;

          return `
            <button
              class="btn btn-sm ${btn.class} me-2"
              onclick="createPopup(''${url}'')">
              ${btn.label}
            </button>
          `;
        })
        .join("")}
    </div>
  `;
}
function buildActionText(action, from, to, date) {
  let text = `Task is ${action.toLowerCase()} by ${from}`;
  if (to && to.toLowerCase() !== "null") {
    text += ` to ${to}`;
  }
  text += ` on ${formatDate(date)}`;
  return text;
}
// inbox.js
document.addEventListener("click", function (e) {
  if (e.target.closest("input, label")) return;
  // 1️⃣ FILTER BUTTONS
  const filterBtn = e.target.closest(
    "#alllist, #activelist, #completedlist, #sentlist, #pendinglist,#approvedlist,#rejectedlist,#returnedlist,#approveBtn,#messagelist,#notificationlist",
  );
  if (filterBtn) {
    this.isFilterClick = true;
    handleFilterClick(filterBtn);
    return;
  }
  // 2️⃣ SCHEDULER BUTTON
  const schedulerBtn = e.target.closest("#schedulerBtn");
  if (schedulerBtn) {
    // iframe
    const iframe = document.getElementById("process_iframe");
    if (iframe) {
      //  iframe.src = "about:blank";
      iframe.classList.add("d-none");
    }
    // stepper
    const stepper = document.getElementById("Process-stepper");
    if (stepper) {
      stepper.classList.add("d-none");
    }
    handleSchedulerClick(e);
    return;
  }
  // other click routes can go here...
});
function handleFilterClick(button) {
  document
    .querySelectorAll(
      "#alllist, #activelist, #approveBtn, #completedlist, #sentlist, #pendinglist,#approvedlist,#rejectedlist,#returnedlist,#messagelist,#notificationlist",
    )
    .forEach((b) => b.classList.remove("active"));
  button.classList.add("active");
  const newFilter = button.dataset.id;
  if (axProcessObj.filterkey === newFilter) return;
  axProcessObj.filterkey = newFilter;
  axProcessObj.pageNo = 1;
  axProcessObj.isDropdownClick = true;
  masterTasks = [];
  axProcessObj.tasksJson = [];
  axProcessObj.fetchProcessList();
}
function handleSchedulerClick(e) {
  e.preventDefault();
  e.stopPropagation();
 const userName = inboxV2.schedulerFromLHS
    ? inboxV2.schedulerUserName
    : (
        parent?.mainUserName ||
        parent?.loggedUserName ||
        parent?.userName ||
        ""
    );

window._plannerContext = {
    source: "inbox",
    username: userName,
    date: new Date()
};
  if (typeof plansPopupHandler === "function") {
    plansPopupHandler(e,userName);
      inboxV2.schedulerFromLHS = false;
    inboxV2.schedulerUserName = "";
  }
}
function showDefaultRightPanel() {
  const right = document.getElementById("Tickets_details_view");
  const iframe = document.getElementById("rightIframe");
  const pegIframe = document.getElementById("process_iframe");
  // const stepper = document.getElementById(''Process-stepper'');
  // if (pegIframe) {
  //   //  pegIframe.src = "about:blank";
  //     pegIframe.classList.add("d-none");   // ✅ hide iframe
  // }
  // if (stepper) {
  //     stepper.classList.add("d-none");     // ✅ hide stepper
  // }
  //     const pegIframe = document.getElementById(''process_iframe'')
  //  if (pegIframe) {
  //         pegIframe.src = "about:blank";
  //         pegIframe.classList.add("d-none");
  //     }
  // hide iframe (if any screen opened inside it)
  if (iframe) {
    iframe.src = "about:blank";
    iframe.classList.add("d-none");
  }
  // reset HTML to default screen
  right.innerHTML = `
            <div class="card mb-5 mb-xl-2 h-100" id="process_centerpanel">
                <div class="d-flex flex-column text-center h-100 justify-content-center" style="height:95%">
                    <span class="material-icons material-icons-style material-icons-5tx mx-auto text-gray-500">add_task</span>
                    <h3 class="fw-boldest">Select a task to load</h3>
                    <h6 class="fst-italic text-gray-400">Nothing is selected</h6>
                </div>
            </div>
        `;
}
function downloadIviewFile(fileName, fullPath) {
  const baseUrl = window.location.origin;
  $.ajax({
    url: `${baseUrl}/WebService.asmx/GetFilePathForIviewAttachment`,
    type: "POST",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    xhrFields: { withCredentials: true },
    data: JSON.stringify({
      proj: "agilespacedev",
      tid: "-",
      fldname: "-",
      filename: fullPath,
      attachtype: "fullpath",
      onlyRecordId: "",
      onlyFileName: fileName,
      isDbAttachment: "false",
      onlygetPath: true,
    }),
    success: function (response) {
      if (!response?.d) {
        alert("Unable to download file");
        return;
      }
      const url = response.d;
      const ext = (fileName.split(".").pop() || "").toLowerCase();
      // ✅ Preview types
      const previewTypes = ["jpg", "jpeg", "png", "gif", "bmp", "webp", "txt"];
      if (previewTypes.includes(ext)) {
        window.open(url, "_blank", "noopener");
        return;
      }
      const container = document.getElementById("PROFLOW_Right");
      if (!container) {
        console.error("PROFLOW_Right not found");
        return;
      }

      const link = document.createElement("a");
      link.href = url;
      link.download = fileName;
      link.rel = "noopener";
      container.appendChild(link);
      link.click();
      container.removeChild(link);
    },
    error: function (xhr) {
      console.error("API Error:", xhr.responseText);
      alert("File download failed");
    },
  });
}

//         function downloadIviewFile(fileName, fullPath) {
//             const baseUrl = window.location.origin;

//             $.ajax({
//                 url: `${baseUrl}/WebService.asmx/GetFilePathForIviewAttachment`,
//                 type: "POST",
//                 contentType: "application/json; charset=utf-8",
//                 dataType: "json",
//                 xhrFields: {
//                     withCredentials: true
//                 },
//                 data: JSON.stringify({
//                     proj: "agilespacedev",
//                     tid: "-",
//                     fldname: "-",
//                     filename: fullPath,
//                     attachtype: "fullpath",
//                     onlyRecordId: "",
//                     onlyFileName: fileName,
//                     isDbAttachment: "false",
//                     onlygetPath: true
//                 }),

//                 success: function (response) {

//                     console.log("API Success:", response);

//                     if (!response?.d) {
//                         alert("Unable to download file");
//                         return;
//                     }

//                     const url = response.d;
//                     const ext = (fileName.split(''.'').pop() || "").toLowerCase();

//                     // ✅ Preview PDF & TXT in new tab
//                     if (ext === "pdf" || ext === "txt") {
//                         window.open(url, "_blank", "noopener");
//                     }

//                     // ✅ Download other files directly (xls, xlsx, csv, doc)
//                     else {
//                         const container = document.getElementById("PROFLOW_Right");
// if (!container) {
//     console.error("PROFLOW_Right not found");
//     return;
// }

// const link = document.createElement("a");
// link.href = url;
// link.download = fileName;
// link.target = "_blank";
// link.rel = "noopener";
// container.appendChild(link);
// link.click();
// container.removeChild(link);
//                     }
//                 },

//                 error: function (xhr) {
//                     console.error("API Error:", xhr.responseText);
//                     alert("File download failed");
//                 }
//             });
//         }
function showStepper() {
  const stepper = document.querySelector("#horizontal-processbar");
  const clientPanel = document.getElementById("PROFLOW_Right"); // Targeting the client/right panel

  if (stepper && clientPanel) {
    // Move the stepper inside the client panel so it follows its width constraints
    clientPanel.prepend(stepper);
    stepper.classList.remove("d-none");
  }
}
// function AxCustomSaveRedirect() {
//     debugger;

//     const closeBtn = window.parent?.document
//         ?.querySelector(''#loadPopUpPage [data-bs-dismiss="modal"]'');

//     // Stop if close button is not found
//     if (!closeBtn) {
//         console.warn("Close button not found");
//         return;
//     }

//     try {

//         // Click close button
//         closeBtn.click();

//         // parent.document.querySelector(''#refreshBtn'')?.click()

//         const parentWin = window.parent;

//         // Reload task
//         const taskId = parentWin.currentTaskId;
//         const userName = parentWin.top.mainUserName;

//         if (taskId) {
//             parentWin.openTicketDetails(taskId, userName);
//         }

//     } catch (err) {
//         console.error("Close error:", err);
//     }
// }
');
>>

