<<

UPDATE AXDIRECTSQL SET SQLTEXT = TO_CLOB('SELECT DISTINCT * FROM
(SELECT  title,to_char(subdetails) subtitle,modifiedon ,''ta__na(recordid=''||to_char(axpdef_news_eventsid)||'')'' link
,CASE WHEN img.recordid IS NOT null THEN ''images/news/$APP_NAME$/'' || img.recordid || ''.'' || img.ftype ELSE NULL END image
from axpdef_news_events a LEFT join a__naeventimg img on img.recordid = a.axpdef_news_eventsid
where active=''T''
and  (current_date >= effectfrom and (effecto >= current_date or effecto is null))
order by effectfrom)') WHERE SQLNAME ='ds_homepage_events'

>>