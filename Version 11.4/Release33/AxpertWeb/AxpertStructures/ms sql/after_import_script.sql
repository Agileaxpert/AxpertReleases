<<
ALTER TABLE AXDIRECTSQL ADD cachedata varchar(1) NULL;
>>

<<
ALTER TABLE AXDIRECTSQL ADD cacheinterval varchar(10) NULL;
>>

<<
ALTER TABLE .AXDIRECTSQL ADD encryptedflds varchar(4000) NULL;
>>

<<
CREATE   VIEW vw_pegv2_alltasks AS 
SELECT DISTINCT 
    a.touser,
    a.processname,
    a.taskname,
    a.taskid,
    a.tasktype,
    a.eventdatetime AS edatetime,
    FORMAT(
        TRY_CAST(
            STUFF(STUFF(STUFF(STUFF(a.eventdatetime, 13, 0, ':'), 11, 0, ':'), 9, 0, ' '), 5, 0, '-') 
        AS DATETIME2),
        'dd/MM/yyyy HH:mm:ss'
    ) AS eventdatetime,
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
    'PEG' AS rectype,
    'NA' AS msgtype,
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
    NULL AS hlink,
    NULL AS hlink_transid,
    NULL AS hlink_params,
    NULL AS taskstatus,
    NULL AS statusreason,
    NULL AS statustext,
    NULL AS cancelremarks,
    NULL AS cancelledby,
    NULL AS cancelledon,
    NULL AS cancel,
    NULL AS username,
    'Active' AS cstatus
FROM axactivetasks a
JOIN axprocessdefv2 b 
    ON a.processname = b.processname AND a.taskname = b.taskname
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
    FROM axactivetaskstatus b1 
    WHERE a.taskid = b1.taskid
)
AND a.removeflg = 'F'
UNION ALL
SELECT 
    a.touser,
    a.processname,
    a.taskname,
    a.taskid,
    a.tasktype,
    a.eventdatetime AS edatetime,
    -- Convert eventdatetime from YYYYMMDDHH24MISSmmm to formatted string
    FORMAT(
        TRY_CAST(
            STUFF(STUFF(STUFF(STUFF(a.eventdatetime, 13, 0, ':'), 11, 0, ':'), 9, 0, ' '), 5, 0, '-') 
        AS DATETIME2),
        'dd/MM/yyyy HH:mm:ss'
    ) AS eventdatetime,
    a.fromuser,
    NULL AS fromrole,
    a.displayicon,
    a.displaytitle,
    NULL AS displaymcontent,
    a.displaycontent,
    NULL AS displaybuttons,
    a.keyfield,
    a.keyvalue,
    a.transid,
    0 AS priorindex,
    a.indexno,
    0 AS subindexno,
    NULL AS approvereasons,
    NULL AS defapptext,
    NULL AS returnreasons,
    NULL AS defrettext,
    NULL AS rejectreasons,
    NULL AS defregtext,
    0 AS recordid,
    NULL AS approvalcomments,
    NULL AS rejectcomments,
    NULL AS returncomments,
    'MSG' AS rectype,
    a.msgtype,
    'F' AS returnable,
    NULL AS initiator,
    NULL AS initiator_approval,
    NULL AS displaysubtitle,
    p.amendment,
    'F' AS allowsend,
    'F' AS allowsendflg,
    NULL AS cmsg_appcheck,
    NULL AS cmsg_return,
    NULL AS cmsg_reject,
    NULL AS showbuttons,
    a.hlink,
    a.hlink_transid,
    a.hlink_params,
    NULL AS taskstatus,
    NULL AS statusreason,
    NULL AS statustext,
    NULL AS cancelremarks,
    NULL AS cancelledby,
    NULL AS cancelledon,
    NULL AS cancel,
    NULL AS username,
    'Active' AS cstatus
FROM axactivemessages a
LEFT JOIN axpdef_peg_processmaster p 
    ON a.processname = p.caption
WHERE NOT EXISTS (
    SELECT 1 
    FROM axactivetaskstatus b 
    WHERE a.taskid = b.taskid
)
UNION ALL
 SELECT 
    a.touser,
    a.processname,
    a.taskname,
    a.taskid,
    a.tasktype,
    a.eventdatetime AS edatetime,
    -- Convert eventdatetime from YYYYMMDDHH24MISSmmm format
    FORMAT(
        TRY_CAST(
            STUFF(STUFF(STUFF(STUFF(a.eventdatetime, 13, 0, ':'), 11, 0, ':'), 9, 0, ' '), 5, 0, '-') 
        AS DATETIME2),
        'dd/MM/yyyy HH:mm:ss'
    ) AS eventdatetime,
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
    'PEG' AS rectype,
    'NA' AS msgtype,
    a.returnable,
    a.initiator,
    a.initiator_approval,
    a.displaysubtitle,
    NULL AS amendment,
    a.allowsend,
    a.allowsendflg,
    NULL AS cmsg_appcheck,
    NULL AS cmsg_return,
    NULL AS cmsg_reject,
    NULL AS showbuttons,
    NULL AS hlink,
    NULL AS hlink_transid,
    NULL AS hlink_params,
    --pr_pegv2_transcurstatus(a.transid, a.keyvalue, a.processname) AS taskstatus,
    null taskstatus, 
    b.statusreason,
    b.statustext,
    b.cancelremarks,
    b.cancelledby,
    CAST(b.cancelledon AS VARCHAR) AS cancelledon,  -- Equivalent of ::character varying
    b.cancel,
    CASE
        WHEN a.indexno = 1 THEN a.fromuser  -- ::numeric not needed in SQL Server
        ELSE a.touser
    END AS username,
    'Completed' AS cstatus
FROM axactivetasks a
JOIN axactivetaskstatus b 
    ON a.taskid = b.taskid;
>>