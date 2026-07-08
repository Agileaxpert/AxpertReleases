<<
update axdirectsql set sqlsrc ='For developers',sqlsrccnd =2 where sqlsrc ='Internal';
>>

<<
update axdirectsql set sqlsrc='For developers',sqlsrccnd=2  where sqlname in('axcalendarsource','ds_homepage_banner',
'ds_homepage_events',
'ds_homepage_kpicards','ds_homepage_activelist');
>>

<<
update axdirectsql set sqlsrc ='Internal',sqlsrccnd =1 where sqlsrc ='Metadata';
>>

<<
update axdirectsql set sqlsrc ='For users',sqlsrccnd =3 where sqlsrc ='Application';
>>

<<
update axdirectsql set sqlsrc='Internal',sqlsrccnd=1  where sqlname in('Text_Field_Intelligence');
>>

<<
CREATE FUNCTION fn_mobile_axactivemsg
(
    @pmsgtypes NVARCHAR(MAX),
    @pdelimiter NVARCHAR(10) = ','
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        m.msgtype, 
        m.fromuser, 
        m.touser, 
        m.tasktype, 
        m.displaytitle, 
        m.displaycontent, 
        m.requestpayload 
    FROM axactivemessages m 
    WHERE m.msgtype IN 
    (
        SELECT 
            LTRIM(RTRIM(Split.a.value('.', 'NVARCHAR(MAX)'))) AS [value]
        FROM  
        (
            SELECT CAST('<M>' + REPLACE(@pmsgtypes, @pdelimiter, '</M><M>') + '</M>' AS XML) AS Data
        ) AS A 
        CROSS APPLY Data.nodes ('/M') AS Split(a)
    )
);
>>

<< 
INSERT
 INTO
 AXDIRECTSQL (axdirectsqlid,
 cancel,
 sourceid,
 mapname,
 username,
 modifiedon,
 createdby,
 createdon,
 wkid,
 app_level,
 app_desc,
 app_slevel,
 cancelremarks,
 wfroles,
 sqlname,
 ddldatatype,
 sqltext,
 paramcal,
 sqlparams,
 accessstring,
 groupname,
 sqlsrc,
 sqlsrccnd,
 sqlquerycols,
 encryptedflds,
 cachedata,
 cacheinterval,
 smartlistcnd,
 adsdesc)
VALUES(1111110000000,
N'F',
0,
NULL,
N'admin',
'2026-06-30 11:58:10.000',
N'admin',
'2026-06-30 11:58:10.000',
NULL,
1,
1,
0,
NULL,
NULL,
N'ds_mobile_axactivemsg',
NULL,
N'select * From fn_mobile_axactivemsg( cast( :pmsgtypes as nvarchar(max)),:pdelimiter)',
N'pmsgtypes,pdelimiter',
N'pmsgtypes~Character~,pdelimiter~Character~',
N'ALL',
NULL,
N'Application',
0,
N'msgtype,fromuser,touser,tasktype,displaytitle,displaycontent,requestpayload',
NULL,
N'F',
N'6 Hr',
NULL,
NULL);
>>