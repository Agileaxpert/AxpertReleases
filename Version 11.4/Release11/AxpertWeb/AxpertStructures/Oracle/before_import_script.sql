<<

CREATE TABLE ax_userconfigdata (
   page VARCHAR2(100),
   struct VARCHAR2(100),
   keyname VARCHAR2(100),
   username VARCHAR2(100),
   value CLOB
)

>>

<<

UPDATE AXDIRECTSQL SET SQLTEXT='SELECT touser, fromuser, taskname, eventdatetime, displaytitle, displaycontent , tasktype , rectype, msgtype , taskstatus, cstatus FROM
(select touser, fromuser, taskname, eventdatetime, displaytitle, displaycontent , tasktype , rectype, msgtype , taskstatus, cstatus,ROW_NUMBER() over(ORDER BY edatetime desc) rno,edatetime 
from vw_pegv2_alltasks where case when cstatus=''Active'' then lower(touser) else lower(username) end = lower( :username)) 
WHERE rno BETWEEN 1 AND 100
order by edatetime desc 
' WHERE SQLNAME='ds_homepage_activelist'

>>