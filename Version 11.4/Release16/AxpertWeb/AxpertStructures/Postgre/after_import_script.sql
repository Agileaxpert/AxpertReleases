<<

UPDATE axdirectsql SET sqltext='select	title,subdetails subtitle,modifiedon ,''ta__na(recordid=''||axpdef_news_eventsid||'')'' link, ''images/news/$APP_NAME$/'' || img.recordid || ''.'' || img.ftype image
from axpdef_news_events a left join a__naeventimg img on img.recordid = a.axpdef_news_eventsid
where active=''T''
and  (current_date >= effectfrom and (effecto >= current_date or effecto is null))
group by title,subdetails ,modifiedon ,''ta__na(recordid=''||axpdef_news_eventsid||'')'' , ''images/news/$APP_NAME$/'' || img.recordid || ''.'' || img.ftype,a.effectfrom
order by effectfrom'
where sqlname='ds_homepage_events';

>>