<<

CREATE TABLE ax_userconfigdata (
    page VARCHAR(100),
    struct VARCHAR(100),
    keyname VARCHAR(100),
    username VARCHAR(100),
    value TEXT
);
 
>>

<<

UPDATE axdirectsql SET sqltext='select touser, fromuser, taskname, eventdatetime, displaytitle, displaycontent , tasktype , rectype, msgtype , taskstatus, cstatus 
from vw_pegv2_alltasks where case when cstatus=''Active'' then lower(touser) else lower(username) end = lower( :username)
order by edatetime desc LIMIT 100'where sqlname='ds_homepage_activelist';

>>