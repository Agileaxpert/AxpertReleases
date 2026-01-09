<<
CREATE TABLE axp_struct_release_log (createdon timestamp NULL DEFAULT now(),axpversion varchar(100) NULL);
>>

<<
drop view AXP_APPSEARCH_DATA; 
>>

<<
CREATE TABLE AXP_APPSEARCH_DATA
(
  CANCEL                VARCHAR(1),
  SOURCEID              numeric,
  MAPNAME               VARCHAR(20),
  USERNAME              VARCHAR(50),
  MODIFIEDON            DATE,
  CREATEDBY             VARCHAR(50),
  CREATEDON             DATE,
  WKID                  VARCHAR(15),
  APP_LEVEL             NUMERIC(3),
  APP_DESC              NUMERIC(1),
  APP_SLEVEL            NUMERIC(3),
  CANCELREMARKS         VARCHAR(150),
  WFROLES               VARCHAR(250),
  HLTYPE                VARCHAR(10),
  STRUCTNAME            VARCHAR(50),
  SEARCHTEXT            VARCHAR(500),
  PARAMS                VARCHAR(500),
  AXP_APPSEARCH_DATAID  NUMERIC(16)
);
>>
  
<<
CREATE TABLE AXP_APPSEARCH_DATA_V2
(
  HLTYPE      VARCHAR(10),
  STRUCTNAME  VARCHAR(25),
  SEARCHTEXT  VARCHAR(200),
  PARAMS      VARCHAR(150),
  CREATEDON   DATE DEFAULT current_date,
  DOCID       VARCHAR(50)
);
>> 

<<
CREATE UNIQUE INDEX UI_AXP_APPSEARCH_DATA_V2 ON AXP_APPSEARCH_DATA_V2(HLTYPE, STRUCTNAME, PARAMS);
>>

<<
create table Axp_TransCheck(sessionid varchar(50));
>>

<<
create table axctx1 (atype varchar(10),axcontext varchar(75));
>>

<<
create unique index  ui_AXCTX1 on AXCTX1 (axcontext,atype);
>>

<<
ALTER TABLE axp_vp ALTER COLUMN vpvalue TYPE varchar(300) USING vpvalue::varchar(300);
>>

<<
ALTER TABLE axp_vp ADD masterdlselect varchar(200) NULL;
>>

<<
alter table aximpdef add aximpprimaryfield_details varchar(300);
>>

<<
alter table importdataexceptions add rapidimpid varchar(100);
>>

<<
alter table importdatadetails add rapidimpid varchar(100);
>>

<<
alter table axapijobdetails add authstr varchar(100);
>>

<<
ALTER TABLE executeapidef ADD execapiauthstring varchar(100) NULL;
>>

<<
ALTER TABLE axprocessdefv2 ADD approve_forwardto varchar(1) NULL;
>>

<<
ALTER TABLE axprocessdefv2 ADD return_to_priorindex varchar(1) NULL;
>>

<<
ALTER TABLE axprocessdefv2 ADD action_buttons varchar(50) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD assigntouser varchar(100) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD assigntouserflag varchar(5) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD displaybuttons varchar(100) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD displaysubtitle varchar(100) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD editablefieldscaption varchar(4000) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD exp_editor_applicability text null;
>>

<<
ALTER TABLE axprocessdefv2 ADD exp_editor_nexttask text null;
>>

<<
ALTER TABLE axprocessdefv2 ADD mapfield varchar(100) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD mapfield_group varchar(250) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD mapfieldcaption varchar(250) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD mobilenotify varchar(1) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD nexttask varchar(4000) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD nexttask_falsecnd varchar(250) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD nexttask_tbl varchar(4000) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD nexttask_truecnd varchar(250) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD parenttask varchar(200) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD prenotify varchar(250) null;
>>

<<
ALTER TABLE axprocessdefv2 ADD subindexno numeric(2) null;
>>

<<
alter table ax_configure_fast_prints add iview_name varchar(100);
>>

<<
alter table axactivetasks add column returnable varchar(1);
>>

<<
CREATE OR REPLACE FUNCTION pr_executescript_new(ptablename character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$ declare sqlstmt refcursor;

rec record;

temp1 varchar(1000);
begin
truncate
	table
		axonlineconvlog;

open sqlstmt for execute 'SELECT case when substring(lower(psqlquery),1,1) in (''i'',''u'',''d'')  then psqlquery else substring(psqlquery,2,length(psqlquery)) end as psqlquery  FROM ' || ptablename;

fetch next
from
sqlstmt into
	rec;

while found loop
begin
execute rec.psqlquery;

exception
when others then insert
	into
		axonlineconvlog(script,
		tablename,
		errmsg )
	values(rec.psqlquery,
	ptablename,
	sqlerrm);
end;

fetch next
from
sqlstmt into
	rec;
end loop;

close sqlstmt;

temp1 := 'drop table ' || ptablename;

execute temp1;
end;

$function$
;
>>

<<
CREATE OR REPLACE FUNCTION pr_executescript_thread_new(ptablename character varying, pfieldname character varying, pgroupfield character varying, pthread numeric)
 RETURNS void
 LANGUAGE plpgsql
AS $function$ declare sqlstmt varchar(4000);

createtblstmt varchar(4000);

createindexstmt varchar(4000);


begin
createtblstmt := 'create temp table ' || ptablename || '_t on commit drop  as select  b1.' || pgroupfield || ',mod(rank()over(order by b1.' || pgroupfield || '),' || pthread || ')  as ' || pfieldname || ' from (select ' || pgroupfield || ' from ' || ptablename || ' group by ' || pgroupfield || ' ) b1';

createindexstmt := 'create index i_' || ptablename || ' on ' || ptablename || '_t (' || pgroupfield || ')';

sqlstmt := ' update ' || ptablename || ' a set ' || pfieldname || '= ( select b.' || pfieldname || ' from ' || ptablename || '_t b where b.' || pgroupfield || '=a.' || pgroupfield || ') where exists (select  1 from  ' || ptablename || '_t b where  b.' || pgroupfield || '=a.' || pgroupfield || ') ';



execute createtblstmt;

execute createindexstmt;

execute sqlstmt ;

end;

$function$
;
>>

<<
drop view axp_vw_menu;
>>

<<
CREATE OR REPLACE VIEW axp_vw_menu
AS SELECT replace(replace(COALESCE(h.caption, ''::text) || COALESCE('\'::text || g.caption::text, ''::text), '\\\'::text, '\'::text), '\\'::text, '\'::text) AS menupath,
    g.caption,
    g.name,
    g.ordno,
    g.levelno,
    g.parent,
    g.type,
    g.pagetype,
    replace(replace((COALESCE('\'::text || g.visible::text, 'F'::text) || COALESCE('\'::text || h.visible, ''::text)) || '\'::text, '\\\'::text, '\'::text), '\\'::text, '\'::text) AS visible,
    g.websubtype
   FROM axpages g
     LEFT JOIN ( SELECT COALESCE(f.caption, ''::text) || COALESCE('\'::text || e.caption::text, ''::text) AS caption,
            e.parent,
            e.name,
            (COALESCE('\'::text || f.visible, ''::text) || COALESCE('\'::text || e.visible::text, ''::text)) || '\'::text AS visible
           FROM axpages e
             LEFT JOIN ( SELECT (COALESCE(d.caption, ''::character varying)::text || '\'::text) || COALESCE(c.caption, ''::character varying)::text AS caption,
                    c.name,
                    (COALESCE('\'::text || d.visible, ''::text) || COALESCE('\'::text || c.visible::text, ''::text)) || '\'::text AS visible
                   FROM axpages c
                     LEFT JOIN ( SELECT a.name,
                            a.parent,
                            a.caption,
                            a.levelno,
                            a.ordno,
                            1 AS levlno,
                            ('\'::text || a.visible::text) || '\'::text AS visible
                           FROM axpages a
                          WHERE a.levelno = 0::numeric
                          ORDER BY a.levelno, a.ordno) d ON c.parent::text = d.name::text
                  WHERE c.levelno = ANY (ARRAY[1::numeric, 0::numeric])) f ON e.parent::text = f.name::text
          WHERE e.levelno = ANY (ARRAY[1::numeric, 0::numeric, 2::numeric])) h ON g.parent::text = h.name::text
  WHERE g.levelno <= 3::numeric
  ORDER BY g.ordno, g.levelno;
>>

<<
drop view axp_vw_menulist;
>>

<<
CREATE OR REPLACE VIEW axp_vw_menulist
AS SELECT replace(replace(COALESCE('\'::text || h.caption, ''::text) || COALESCE('\'::text || g.caption::text, ''::text), '\\\'::text, '\'::text), '\\'::text, '\'::text) AS menupath,
    g.name,
    g.ordno,
    g.levelno,
    g.parent,
    g.type,
    g.pagetype
   FROM axpages g
     LEFT JOIN ( SELECT COALESCE('\'::text || f.caption, ''::text) || COALESCE('\'::text || e.caption::text, ''::text) AS caption,
            e.parent,
            e.name
           FROM axpages e
             LEFT JOIN ( SELECT (COALESCE('\'::text || d.caption::text, ''::text) || '\'::text) || COALESCE(c.caption, ''::character varying)::text AS caption,
                    c.name
                   FROM axpages c
                     LEFT JOIN ( SELECT a.name,
                            a.parent,
                            a.caption,
                            a.levelno,
                            a.ordno,
                            1 AS levlno
                           FROM axpages a
                          WHERE a.levelno = 0::numeric
                          ORDER BY a.levelno, a.ordno) d ON c.parent::text = d.name::text
                  WHERE c.levelno = ANY (ARRAY[1::numeric, 0::numeric])) f ON e.parent::text = f.name::text
          WHERE e.levelno = ANY (ARRAY[1::numeric, 0::numeric, 2::numeric])) h ON g.parent::text = h.name::text
  WHERE COALESCE(g.levelno, 0::numeric) <= 3::numeric
  ORDER BY g.ordno, g.levelno;
>>

<<
CREATE OR REPLACE VIEW axp_appsearch_data_new
AS SELECT 2 AS slno,
    axp_appsearch_data_v2.hltype,
    axp_appsearch_data_v2.structname,
    btrim(replace(axp_appsearch_data_v2.searchtext::text, 'View'::text, ' '::text)) AS searchtext,
    axp_appsearch_data_v2.params,
    a.oldappurl
   FROM axp_appsearch_data_v2
     JOIN axpages a ON
        CASE axp_appsearch_data_v2.hltype
            WHEN 'iview'::text THEN ('i'::text || axp_appsearch_data_v2.structname::text)::character varying
            WHEN 'tstruct'::text THEN ('t'::text || axp_appsearch_data_v2.structname::text)::character varying
            ELSE axp_appsearch_data_v2.structname
        END::text =
        CASE
            WHEN axp_appsearch_data_v2.hltype::text = 'Page'::text THEN a.name
            ELSE a.pagetype
        END::text
  WHERE lower(axp_appsearch_data_v2.params::text) !~~ '%current_date%'::text
UNION ALL
 SELECT 1.9 AS slno,
    a.hltype,
    a.structname,
    btrim(replace(a.searchtext::text, 'View'::text, ' '::text)) AS searchtext,
    a.params,
    p.oldappurl
   FROM axp_appsearch_data a
     JOIN axpages p ON
        CASE a.hltype
            WHEN 'iview'::text THEN ('i'::text || a.structname::text)::character varying
            WHEN 'tstruct'::text THEN ('t'::text || a.structname::text)::character varying
            ELSE a.structname
        END::text =
        CASE
            WHEN a.hltype::text = 'Page'::text THEN p.name
            ELSE p.pagetype
        END::text
  WHERE NOT (EXISTS ( SELECT 'x'::text AS text
           FROM axp_appsearch_data_v2 b
          WHERE a.structname::text = b.structname::text AND a.params::text = b.params::text))
UNION ALL
 SELECT 2 AS slno,
    axp_appsearch_data_v2.hltype,
    axp_appsearch_data_v2.structname,
    btrim(replace(axp_appsearch_data_v2.searchtext::text, 'View'::text, ' '::text)) AS searchtext,
    replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(axp_appsearch_data_v2.params::text, 'date_trunc(''month'',current_date)'::text, btrim(to_char(date_trunc('month'::text, CURRENT_DATE::timestamp with time zone), 'dd/mm/yyyy'::text))), 'date_trunc(''month'',(add_months(current_date,0-1)))'::text, btrim(to_char(date_trunc('month'::text, add_months(CURRENT_DATE, 0 - 1)::timestamp with time zone), 'dd/mm/yyyy'::text))), 'date_trunc(''month'', current_date) + interval ''0 month'' - interval ''1 day'''::text, btrim(to_char(date_trunc('month'::text, CURRENT_DATE::timestamp with time zone) + '00:00:00'::interval - '1 day'::interval, 'dd/mm/yyyy'::text))), 'date_trunc(''week'',current_date)'::text, btrim(to_char(date_trunc('week'::text, CURRENT_DATE::timestamp with time zone), 'dd/mm/yyyy'::text))), 'date_trunc(''week'',current_date-7)+ interval ''6 day'''::text, btrim(to_char(date_trunc('week'::text, (CURRENT_DATE - 7)::timestamp with time zone) + '6 days'::interval, 'dd/mm/yyyy'::text))), 'date_trunc(''week'',current_date-7)'::text, btrim(to_char(date_trunc('week'::text, (CURRENT_DATE - 7)::timestamp with time zone), 'dd/mm/yyyy'::text))), 'date_trunc(''month'',current_date)'::text, btrim(to_char(date_trunc('month'::text, CURRENT_DATE::timestamp with time zone), 'dd/mm/yyyy'::text))), 'current_date-1'::text, btrim(to_char((CURRENT_DATE - 1)::timestamp with time zone, 'dd/mm/yyyy'::text))), 'current_date'::text, btrim(to_char(CURRENT_DATE::timestamp with time zone, 'dd/mm/yyyy'::text))), ' &'::text, '&'::text) AS params,
    a.oldappurl
   FROM axp_appsearch_data_v2
     JOIN axpages a ON
        CASE axp_appsearch_data_v2.hltype
            WHEN 'iview'::text THEN ('i'::text || axp_appsearch_data_v2.structname::text)::character varying
            WHEN 'tstruct'::text THEN ('t'::text || axp_appsearch_data_v2.structname::text)::character varying
            ELSE axp_appsearch_data_v2.structname
        END::text =
        CASE
            WHEN axp_appsearch_data_v2.hltype::text = 'Page'::text THEN a.name
            ELSE a.pagetype
        END::text
  WHERE lower(axp_appsearch_data_v2.params::text) ~~ '%current_date%'::text
UNION ALL
 SELECT 1 AS slno,
    'tstruct'::character varying AS hltype,
    t.name AS structname,
    t.caption AS searchtext,
    NULL::character varying AS params,
    p.oldappurl
   FROM tstructs t
     JOIN axpages p ON ('t'::text || t.name::text) = p.pagetype::text
  WHERE t.blobno = 1::numeric AND (EXISTS ( SELECT 'x'::text AS text
           FROM axp_vw_menu x
          WHERE x.pagetype::text ~~ 't%'::text AND btrim(substr(x.pagetype::text, 2, 20)) = t.name::text AND x.visible !~~ '%F%'::text))
UNION ALL
 SELECT 0 AS slno,
    'iview'::character varying AS hltype,
    i.name AS structname,
    i.caption AS searchtext,
    NULL::character varying AS params,
    p.oldappurl
   FROM iviews i
     JOIN axpages p ON ('i'::text || i.name::text) = p.pagetype::text
  WHERE i.blobno = 1::numeric AND (EXISTS ( SELECT 'x'::text AS text
           FROM axp_vw_menu x
          WHERE x.pagetype::text ~~ 'i%'::text AND btrim(substr(x.pagetype::text, 2, 20)) = i.name::text AND x.visible !~~ '%F%'::text))
UNION ALL
 SELECT 3 AS slno,
    'Page'::character varying AS hltype,
    axp_vw_menu.name AS structname,
    axp_vw_menu.caption AS searchtext,
    NULL::character varying AS params,
    p.oldappurl
   FROM axp_vw_menu
     JOIN axpages p ON axp_vw_menu.name::text = p.name::text
  WHERE axp_vw_menu.pagetype::text = 'web'::text
  ORDER BY 1;
>>

<<
CREATE OR REPLACE VIEW axp_appsearch
AS SELECT DISTINCT a.searchtext,
    a.params::text ||
        CASE
            WHEN a.params IS NOT NULL AND lower(a.params::text) !~~ '%~act%'::text THEN '~act=load'::text
            ELSE NULL::text
        END AS params,
    a.hltype,
    a.structname,
    a.username,
    a.oldappurl
   FROM ( SELECT s.slno,
            s.searchtext,
            s.params,
            s.hltype,
            s.structname,
            lg.username,
            s.oldappurl
           FROM axp_appsearch_data_new s,
            axuseraccess a_1,
            axusergroups g,
            axuserlevelgroups lg
          WHERE a_1.sname::text = s.structname::text AND a_1.rname::text = g.userroles::text AND g.groupname::text = lg.usergroup::text AND s.structname::text <> 'axurg'::text AND (a_1.stype::text = ANY (ARRAY['t'::character varying::text, 'i'::character varying::text]))
          GROUP BY s.searchtext, s.params, s.hltype, s.structname, lg.username, s.slno, s.oldappurl
        UNION
         SELECT b.slno,
            b.searchtext,
            b.params,
            b.hltype,
            b.structname,
            lg.username,
            b.oldappurl
           FROM axuserlevelgroups lg,
            ( SELECT DISTINCT s.searchtext,
                    s.params,
                    s.hltype,
                    s.structname,
                    0 AS slno,
                    s.oldappurl
                   FROM axp_appsearch_data_new s
                     LEFT JOIN axuseraccess a_1 ON s.structname::text = a_1.sname::text AND (a_1.stype::text = ANY (ARRAY['t'::character varying::text, 'i'::character varying::text]))) b
          WHERE lg.usergroup::text = 'default'::text AND b.structname::text <> 'axurg'::text
  ORDER BY 1, 6) a;
>>

<<
CREATE OR REPLACE FUNCTION axp_pr_page_creation(
	pname character varying,
	pcaption character varying,
	ppagetype character varying,
	pparentname character varying,
	paction character varying,
	props character varying)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
declare 
   pparent    VARCHAR (50);
   pordno     NUMERIC (15);
   plevelno   NUMERIC (15);
   psysdate   VARCHAR (30);

BEGIN

    IF LOWER (paction) <> 'delete' THEN
      --Page Creation before or after

      SELECT parent, ordno, levelno INTO pparent, pordno, plevelno
        FROM (SELECT parent,CASE WHEN LOWER (paction) = 'before' THEN ordno ELSE ordno + 1 END ordno, levelno
                FROM axp_vw_menulist
               WHERE name = pparentname AND TYPE = 'p'
              UNION ALL
               SELECT a.name,MAX (b.ordno) + 1 AS ordno,a.levelno + 1 AS levelno
                  FROM axp_vw_menulist a, axp_vw_menulist b
                 WHERE a.name = pparentname AND b.menupath LIKE replace(a.menupath,'\','\\') || '%'  AND a.TYPE = 'h'
              GROUP BY a.name, a.levelno) a;

      psysdate := TRIM (TO_CHAR (SYSDATE(), 'dd/mm/yyyy hh24:mi:ss'));

      UPDATE axpages SET ordno = ordno + 1 WHERE ordno >= pordno;

      INSERT INTO axpages (name,caption,blobno,visible,TYPE,parent,props,ordno,levelno,pagetype,createdon,
							updatedon,importedon)
           VALUES (pname,pcaption,1,'T','p',pparent,props,pordno,plevelno,ppagetype,psysdate,psysdate,psysdate);

     
   ELSE
      --Page Deleting
      SELECT ordno INTO pordno FROM axp_vw_menulist WHERE name = pname AND TYPE = 'p';

      DELETE FROM axpages WHERE name = pname; 

      UPDATE axpages SET ordno = ordno - 1 WHERE ordno >= pordno and pordno>0 ;

	

   END IF;

END;
$BODY$;
>>

<<
create or replace function pr_bulk_page_delete()  
RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$ 
declare 
i varchar(3000);
begin
for i in (Select name from axpages where pagetype='web' and blobno=1) 
loop
begin
execute axp_pr_page_creation( i.name,null,null,null,'delete',null);
exception when others then
null;
end ;
end loop;
end; $BODY$;
>>

<<
CREATE OR REPLACE FUNCTION pr_source_trigger(phltype character varying, pstructname character varying, psearchtext character varying, psrctable character varying, psrcfield character varying, pparams character varying, pdocid character varying, psrcmultipletransid character varying, pparamchange character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
   pscripts   VARCHAR (3000);
   pcnt       NUMERIC (15);
    BEGIN     
    --To insert  or update dynamic param value from the source table

   IF psrctable IS NOT NULL AND psrcfield IS NOT NULL
   THEN
      --To drop existing trigger if any source field or source table has been changed

      IF pparamchange = 'T'
      THEN
         SELECT COUNT (1)
           INTO pcnt
         FROM information_schema.triggers where trigger_schema=current_user
                AND TRIM (UPPER (TRIGGER_name)) =
                       TRIM (UPPER ('axp_sch_' || pdocid));

         IF pcnt > 0
         THEN
            EXECUTE  'drop trigger if exists axp_sch_' || TRIM (pdocid)||' on '||psrctable||';';
             EXECUTE  'drop trigger if exists axp_sch_' || TRIM (pdocid)||'_delete on '||psrctable||';';
         END IF;

         DELETE FROM axp_appsearch_data_v2
          WHERE docid = pdocid;

      END IF;

      --To create the source table trigger

      pscripts :=
            ' create or replace function axp_sch_'|| pdocid|| '() 
RETURNS trigger
    LANGUAGE ''plpgsql''
    COST 100
    VOLATILE AS 
	$$
begin 
if tg_op=''INSERT''  then 

insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values('''
         || phltype
         || ''','''
         || pstructname
         || ''','
         || 'new.'
         || psrcfield
         || '||  '''
         || psearchtext
         || ''','''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'new.'),
                     '&',
                     '&''||''')
         || ','''
         || pdocid
         || ''');

else if  tg_op=''UPDATE''   then

insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values('''
         || phltype
         || ''','''
         || pstructname
         || ''','
         || 'new.'
         || psrcfield
         || '||  '''
         || psearchtext
         || ''','''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'old.'),
                     '&',
                     '&''||''')
         || ','''
         || pdocid
         || ''');

else  delete  FROM axp_appsearch_data_v2 where hltype='''
         || phltype
         || ''' and params='''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'old.'),
                     '&',
                     '&''||''')
         || ';

 end if;

 end if;
return new;
exception

      when unique_violation then

if tg_op=''INSERT''  then 
      update axp_appsearch_data_v2 set searchtext='
         || 'new.'
         || psrcfield
         || '||  '''
         || psearchtext
         || ''',params='''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'new.'),
                     '&',
                     '&''||''')
         || ' where hltype='''
         || phltype
         || ''' and params='''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'new.'),
                     '&',
                     '&''||''')
         || ' and docid='''
         || pdocid
         || ''';
else 
  update axp_appsearch_data_v2 set searchtext='
         || 'new.'
         || psrcfield
         || '||  '''
         || psearchtext
         || ''',params='''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'new.'),
                     '&',
                     '&''||''')
         || ' where hltype='''
         || phltype
         || ''' and params='''
         || REPLACE (REPLACE (pparams, '@', '''||' || 'old.'),
                     '&',
                     '&''||''')
         || ' and docid='''
         || pdocid
         || ''';
end if;

return new;
   when others then 

return new;

 end ;  
 $$
 ';

      EXECUTE    pscripts;
	  
	  execute  ' drop trigger IF EXISTS axp_sch_'|| pdocid||' on '||psrctable ||';';
	  execute  ' drop trigger IF EXISTS axp_sch_'|| pdocid||'_delete on '||psrctable ||';';
	  
	 --inster and update event
	EXECUTE   'CREATE TRIGGER axp_sch_'|| pdocid||'
    AFTER INSERT OR UPDATE 
    ON '||psrctable ||
	 ' FOR EACH ROW '||
		case when psrcmultipletransid is not null and psrcmultipletransid<>'' 
	then ' when (new.transid='''||psrcmultipletransid||''')' else '' end||'
    EXECUTE PROCEDURE axp_sch_'||pdocid||'();' ;
   
   --delete event
   if psrcmultipletransid is not null and psrcmultipletransid<>'' then
   	EXECUTE   'CREATE TRIGGER axp_sch_'|| pdocid||'_delete
    AFTER delete
    ON '||psrctable ||
	 ' FOR EACH ROW '||
		case when psrcmultipletransid is not null and psrcmultipletransid<>'' 
	then ' when (old.transid='''||psrcmultipletransid||''')' else '' end||'
    EXECUTE PROCEDURE axp_sch_'||pdocid||'();' ;   
   end if;
	
	

      --Rebuild the exsting recordid from source table to appsearch data table

      EXECUTE  'update  ' || psrctable || ' set cancel=cancel';

   END IF;   
  
    
   
    END;
$function$
; 
>>

<<
CREATE OR REPLACE FUNCTION fn_AXP_APPSEARCH_DATA_PERIOD() RETURNS TRIGGER
AS $AXP_APPSEARCH_DATA_PERIOD$

	BEGIN
		if new.periodically ='T' or new.srctable is  null or new.srcfield is  null then
		Begin 

        IF (TG_OP = 'INSERT') THEN 
		
		insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(new.hltype,new.structname, case when new.periodically ='T' then new.searchtext else  new.caption end ,new.params,new.docid);
		
		return new;
		end if;
		
		IF (TG_OP = 'UPDATE') THEN 
		
		insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(old.hltype,old.structname, case when old.periodically ='T' then old.searchtext else  old.caption end ,old.params,old.docid);
		
		return new;
		
		end if;
		
		IF (TG_OP = 'DELETE') THEN 
		
		delete from axp_appsearch_data_v2 where docid = old.docid;
		
		return new;
		
		end if;
		
		exception
      when unique_violation then
      update axp_appsearch_data_v2 set  hltype= new.hltype , structname = new.structname,searchtext = case when new.periodically ='T' then new.searchtext else  new.caption end  ,params=new.params where docid= new.docid;
   when others then null ;

		end ;
		end if; 
end; 
$AXP_APPSEARCH_DATA_PERIOD$ LANGUAGE plpgsql;
>>

<<
CREATE OR REPLACE FUNCTION axp_tr_search_appsearch()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$
    BEGIN
    if TG_OP = 'INSERT' or TG_OP = 'UPDATE' then
    if  new.periodically ='T' or new.srctable is  null or new.srcfield is  null then
if TG_OP = 'INSERT'   then 
insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(new.hltype,new.structname, case when new.periodically ='T' then new.searchtext else  new.caption end ,new.params,new.docid);
else if TG_OP = 'UPDATE'  then
insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(old.hltype,old.structname, case when old.periodically ='T' then old.searchtext else  old.caption end ,old.params,old.docid);
 end if;
  end if; 
  
  END IF;
  end if;

if TG_OP = 'DELETE'  then 
   delete from axp_appsearch_data_v2 where docid = old.docid;
    execute 'drop trigger IF EXISTS axp_sch_'||old.docid|| ' ON '||OLD.srctable||';';
     execute 'DROP FUNCTION IF EXISTS '||'axp_sch_'||old.docid||';';
end if;

  RETURN NEW;
 exception
      when unique_violation then
      update axp_appsearch_data_v2 set  hltype= new.hltype , structname = new.structname,searchtext = case when new.periodically ='T' then new.searchtext else  new.caption end  ,params=new.params where docid= new.docid;
         RETURN NEW;
    END;
$BODY$;
>>

<<
CREATE TRIGGER axp_tr_search_appsearch
    after INSERT OR UPDATE OR DELETE
    ON axp_appsearch_data_period
    FOR EACH ROW
    EXECUTE PROCEDURE axp_tr_search_appsearch();    
>> 

<<
CREATE OR REPLACE FUNCTION pr_axcnfgiv_tab_create(
	structtransid character varying)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
v_cnt numeric(2) ;
v_sql varchar(4000);
begin
      select COALESCE(count(table_name),0) into v_cnt from information_schema.tables where lower(table_name) = lower( 'axpconfigsiv'||chr(95)||structtransid );
      if v_cnt = 0
      then
        v_sql := 'create table axpconfigsiv'||chr(95)||structtransid||' ( configname varchar(30),cvalue varchar(240),condition varchar(240))' ;
        execute  v_sql;

      end if;
end;
$BODY$;
>>

<<
CREATE OR REPLACE FUNCTION pr_axcnfg_tab_create(
	structtransid character varying)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
v_cnt numeric(2) ;
v_sql varchar(4000);
begin
      select COALESCE(count(table_name),0) into v_cnt from information_schema.tables where lower(table_name) = lower( 'axpconfigs'||chr(95)||structtransid );
      if v_cnt = 0
      then
      v_sql := 'create table axpconfigs'||chr(95)||structtransid||' ( configname varchar(30),cvalue varchar(2000),condition varchar(240))' ;
        execute v_sql;

        end if;
end;
$BODY$;
>>

<<
CREATE OR REPLACE FUNCTION get_columns_name(p_selectquery character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$ 
declare 
    l_result  varchar(32767);
begin
	drop table temp_testtable ;
	execute 'Create table temp_testtable as '|| p_selectQuery;
	
	SELECT string_agg(COLUMN_NAME,',') into l_result FROM information_schema.COLUMNS WHERE TABLE_NAME = 'temp_testtable';
	   
    return  l_result;
end; $function$;
>>

<<
CREATE OR REPLACE FUNCTION get_columns_names(p_selectquery character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$ 
declare 
    l_result  varchar(32767);
begin
	drop table temp_testtable ;
	execute 'Create table temp_testtable as '|| p_selectQuery;
	
	SELECT string_agg(COLUMN_NAME,',') into l_result FROM information_schema.COLUMNS 
	WHERE TABLE_NAME = 'temp_testtable';
	   
    return  l_result;
end; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_UPDATDSIGN() RETURNS TRIGGER
AS $AXDSIGNCONFIG$
	BEGIN

        -- Work out the increment/decrement amount(s).
        IF (TG_OP = 'INSERT') THEN 
		
		NEW.USERNAME = NEW.PUSERNAME; 
		new.rolename = new.prolename;
		
		return new;
	end if;
		
	IF (TG_OP = 'UPDATE') THEN 
		
		NEW.USERNAME = NEW.PUSERNAME; 
		new.rolename = new.prolename;
		
		return new;
	end if;
		
end; 
$AXDSIGNCONFIG$ LANGUAGE plpgsql;
>>

<<
create trigger TRG_UPDATDSIGN  
before insert or update on AXDSIGNCONFIG    
for each row

execute procedure fn_UPDATDSIGN();

end;
>>

<<
DROP FUNCTION sysdate;
>>

<<
CREATE OR REPLACE FUNCTION sysdate()
 RETURNS timestamp without time zone
 LANGUAGE plpgsql
AS $function$
BEGIN
RETURN to_CHAR(CURRENT_TIMESTAMP,'DD/MM/YYYY hh24:mi:ss');
END; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION getiview(isql character varying, inoofrec numeric, ipageno numeric, icountflag numeric, oresult refcursor, oiviewcount refcursor)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
  v_frompos numeric;
 QRY VARCHAR(31000); 
 cnt numeric; 
    BEGIN     
    QRY := ISql; 
 cnt := 0; 
 IF (ICountFlag = 1 AND IPageNo = 1) THEN QRY := 'select count(*) recno from ('|| QRY ||')a';
  EXECUTE  QRY INTO cnt; 
  End If; 
  open OIviewCount for execute 'select '||to_char(cnt)||' as IviewCount from dual';
   QRY := ISql; 
   IF (INoofRec > 0 AND IPageNo > 0) THEN QRY:= 'select a.* from (select row_number()over() AS Rowno, '''' as axrowtype, a.* from (' || QRY||') a )a where a.Rowno > ' || cast( INoofRec * (IpageNo-1.00) as varchar ) || ' and ' || cast( INoofRec * (IpageNo) as varchar)|| ' >= a.Rowno'; 
   else QRY:='select row_number()over() AS Rowno, '''' as axrowtype, a.* from (' || QRY||') a '; 
   END IF; 
   open OResult for execute QRY; 
  exception when others then null;
    END;
$function$
;
>>

<<
Drop view if exists vw_cards_calendar_data;
>>

<<
CREATE OR REPLACE VIEW vw_cards_calendar_data
AS SELECT DISTINCT a.uname,
    a.axcalendarid,
    a.eventname,
    a.sendername,
    a.messagetext,
    a.eventtype,
    a.startdate,
    COALESCE(a.axptm_starttime, '00:00'::character varying) AS axptm_starttime,
    a.enddate,
        CASE
            WHEN COALESCE(a.axptm_endtime, '00:00'::character varying)::text = '00:00'::text THEN '23:59'::character varying
            ELSE a.axptm_endtime
        END AS axptm_endtime,
    a.location,
    a.status,
    b.eventcolor,
        CASE
            WHEN a.sourceid = 0::numeric THEN a.axcalendarid
            ELSE a.sourceid
        END AS recordid,
    a.eventstatus,
    c.eventstatcolor,
    "substring"(a.mapname::text, 1, 5) AS mapname
   FROM axcalendar a
     JOIN axpdef_axcalendar_event b ON a.axpdef_axcalendar_eventid = b.axpdef_axcalendar_eventid
     LEFT JOIN ( SELECT axpdef_axcalendar_eventstatus.axpdef_axcalendar_eventid,
            axpdef_axcalendar_eventstatus.eventstatus,
            axpdef_axcalendar_eventstatus.eventstatcolor
           FROM axpdef_axcalendar_eventstatus) c ON a.axpdef_axcalendar_eventid = c.axpdef_axcalendar_eventid AND a.eventstatus::text = c.eventstatus::text
  WHERE a.cancel::text = 'F'::text AND a.parenteventid > 0::numeric
UNION ALL
 SELECT DISTINCT a.sendername AS uname,
    a.axcalendarid,
    a.eventname,
    a.sendername,
    a.messagetext,
    a.eventtype,
    a.startdate,
    COALESCE(a.axptm_starttime, '00:00'::character varying) AS axptm_starttime,
        CASE
            WHEN a.recurring IS NULL THEN a.enddate
            ELSE a.startdate
        END AS enddate,
        CASE
            WHEN COALESCE(a.axptm_endtime, '00:00'::character varying)::text = '00:00'::text THEN '23:59'::character varying
            ELSE a.axptm_endtime
        END AS axptm_endtime,
    a.location,
    a.status,
    b.eventcolor,
        CASE
            WHEN a.sourceid = 0::numeric THEN a.axcalendarid
            ELSE a.sourceid
        END AS recordid,
    a.eventstatus,
    c.eventstatcolor,
    "substring"(a.mapname::text, 1, 5) AS mapname
   FROM axcalendar a
     JOIN axpdef_axcalendar_event b ON a.axpdef_axcalendar_eventid = b.axpdef_axcalendar_eventid
     LEFT JOIN ( SELECT axpdef_axcalendar_eventstatus.axpdef_axcalendar_eventid,
            axpdef_axcalendar_eventstatus.eventstatus,
            axpdef_axcalendar_eventstatus.eventstatcolor
           FROM axpdef_axcalendar_eventstatus) c ON a.axpdef_axcalendar_eventid = c.axpdef_axcalendar_eventid AND a.eventstatus::text = c.eventstatus::text
  WHERE a.cancel::text = 'F'::text AND a.parenteventid = 0::numeric
  ORDER BY 7;
>>

<<
CREATE OR REPLACE FUNCTION tr_axpconfigs_tstructs()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
 V_CNT NUMERIC(2);
V_SQL VARCHAR(4000);
    BEGIN      
     IF TG_OP='INSERT' OR TG_OP='UPDATE'
    THEN 
    

     IF TG_OP='INSERT' THEN
     SELECT COALESCE(COUNT(TABLE_NAME),0) INTO V_CNT FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=CURRENT_SCHEMA AND  LOWER(TABLE_NAME) = LOWER( 'axpconfigs'||CHR(95)||NEW.STRUCTTRANSID );
      IF V_CNT = 0
      THEN
      V_SQL := 'create table axpconfigs'||CHR(95)||NEW.STRUCTTRANSID||' ( configname varchar(30),cvalue varchar(2000),condition varchar(2000))' ;
        EXECUTE  V_SQL;
        END IF;
    ELSIF TG_OP='UPDATE'
    THEN
	
        V_SQL = 'delete from axpconfigs'||CHR(95)||OLD.STRUCTTRANSID;
		begin
        EXECUTE  V_SQL; 
		exception when others then null;
		end ;
        END IF;
        
     IF NEW.CV_SEARCHFLDS IS NOT NULL and NEW.CV_SEARCHFLDS  <> ''
      THEN
        V_SQL = 'insert into axpconfigs'||CHR(95)||NEW.STRUCTTRANSID||' ( configname,cvalue,condition ) values ('''||NEW.CONFIGNAME1||''','''||NEW.CV_SEARCHFLDS||''',null)';
        EXECUTE  V_SQL;
      END IF;
      
      IF NEW.CV_GROUPBUTTONS IS NOT NULL and NEW.CV_GROUPBUTTONS <>''
      THEN
        V_SQL = 'insert into axpconfigs'||CHR(95)||NEW.STRUCTTRANSID||' ( configname,cvalue,condition ) values ('''||NEW.CONFIGNAME2||''','''||NEW.CV_GROUPBUTTONS||''',null)';
        EXECUTE  V_SQL;
      END IF;
      
      IF NEW.CV_HTMLPRINTS IS NOT NULL and NEW.CV_HTMLPRINTS <> ''
      THEN
        V_SQL = 'insert into axpconfigs'||CHR(95)||NEW.STRUCTTRANSID||' ( configname,cvalue,condition ) values ('''||NEW.CONFIGNAME3||''','''||NEW.CV_HTMLPRINTS||''',null)';
        EXECUTE  V_SQL;
      END IF;     
              
      IF NEW.CV_MASTERFLDS IS NOT NULL and NEW.CV_MASTERFLDS <>''
      THEN
        V_SQL = 'insert into axpconfigs'||CHR(95)||NEW.STRUCTTRANSID||' ( configname,cvalue,condition ) values ('''||NEW.CONFIGNAME4||''','''||NEW.CV_MASTERFLDS||''',null)';
        EXECUTE  V_SQL;
      END IF;
      
    END IF;
    
    
    IF TG_OP='DELETE'
    THEN
        V_SQL = 'delete from axpconfigs'||CHR(95)||OLD.STRUCTTRANSID;
        EXECUTE  V_SQL;   
        END IF;
       RETURN NEW;
    END;
$function$;
>>

<<
create trigger tr_axpconfigs_tstructs1 after insert
    or delete
        or update
            on
            tconfiguration for each row execute procedure tr_axpconfigs_tstructs();
>>

<<
CREATE OR REPLACE FUNCTION tr_axpconfigs_iviews()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
 v_cnt NUMERIC(2);
v_sql varchar(4000);
    BEGIN 	 
	  if TG_OP='INSERT'
    then
	 select  count(1)  into v_cnt from information_schema.tables where table_schema=current_schema and lower(table_name) = lower( 'axpconfigsiv'||chr(95)||new.structtransid  );
     
	 if v_cnt = 0
      then
        v_sql := 'create table axpconfigsiv'||chr(95)||new.structtransid ||' ( configname varchar(30),cvalue varchar(240),condition varchar(240))' ;
        execute  v_sql;
		end if;
		
if new.cv_groupbuttons is not null
      then
        v_sql = 'insert into axpconfigsiv'||chr(95)||new.structtransid||' ( configname,cvalue,condition ) values ('''||new.configname2||''','''||new.cv_groupbuttons||''',null)';
        execute  v_sql;
      end if;
	  
end if;	  
	  
    if TG_OP='UPDATE'
    then
        v_sql = 'delete from axpconfigsiv'||chr(95)||old.structtransid;
        execute  v_sql;  
		
      if new.cv_groupbuttons is not null
      then
        v_sql = 'insert into axpconfigsiv'||chr(95)||new.structtransid||' ( configname,cvalue,condition ) values ('''||new.configname2||''','''||new.cv_groupbuttons||''',null)';
        execute  v_sql;
      end if;
	  
	end if;  
     if TG_OP='DELETE' 
    then
        v_sql = 'delete from axpconfigsiv'||chr(95)||old.structtransid;
        execute  v_sql;   
    end if;
  
	
       RETURN NEW;
    END;$function$;
>>

<<
create trigger tr_axpconfigs_iviews1 after insert
    or delete
        or update
            on
            iconfiguration for each row execute procedure tr_axpconfigs_iviews();
>>

<<
CREATE OR REPLACE FUNCTION fn_ruledef_formula(formula text, applicability character varying, nexttask character varying, nexttask_true character varying, nexttask_false character varying, pegversion character varying DEFAULT 'v1'::character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
    v_formula text;

begin

if pegversion = 'v1' then
-----Used in Rule definition conditions
with a as(
select
	regexp_split_to_table(formula, E'~') cols),
b as(select 	string_agg(case when split_part( cols, '|', 2) not in('In','Not in') then  substring(substring(split_part(cols, '|', 1), position('-(' in split_part(cols, '|', 1))+ 2, abs((position('-(' in split_part(cols, '|', 1) )+ 2) - length(substring(split_part(cols, '|', 1), 1, length(split_part(cols, '|', 1)))))),2) else '' end||' '||
	case when split_part( cols, '|', 2)='Equal to' then '='
	when split_part( cols, '|', 2)='Not equal to' then '#'
	when split_part( cols, '|', 2)='Greater than' then '>'
	when split_part( cols, '|', 2)='Lesser than' then '<' 
	when split_part( cols, '|', 2) in('In','Not in') then 'StringPOS('||substring(substring(split_part(cols, '|', 1), position('-(' in split_part(cols, '|', 1))+ 2, abs((position('-(' in split_part(cols, '|', 1) )+ 2) - length(substring(split_part(cols, '|', 1), 1, length(split_part(cols, '|', 1)))))),2)||','
	end||' '||
	case when substring(substring(split_part(cols, '|', 1), position('-(' in split_part(cols, '|', 1))+ 2, abs((position('-(' in split_part(cols, '|', 1) )+ 2) - length(substring(split_part(cols, '|', 1), 1, length(split_part(cols, '|', 1)))))),1,1) in('c','t')
	then case when substring(trim(split_part( cols, '|', 3)),1,1)!=':' then concat('{',split_part( cols, '|', 3),'}') else replace(split_part( cols, '|', 3),':',' ') end 
	else case when substring(trim(split_part( cols, '|', 3)),1,1)!=':' then split_part( cols, '|', 3) else replace(split_part( cols, '|', 3),':',' ') end  end ||
	case when split_part( cols, '|', 2)='In' then ') # -1' when split_part( cols, '|', 2)='Not in' then ') = -1' else '' end||' '||
	case when split_part( cols, '|', 4)='And' then '&'
	when split_part( cols, '|', 4)='Or' then '|' 
	when split_part( cols, '|', 4)='And(' then '&('
	when split_part( cols, '|', 4)='Or(' then '|('
	else split_part( cols, '|', 4) end ,' ') cndtxt from a)
	select 
case when applicability ='T' then 'iif('||cndtxt||',{T},{F})' 
when nexttask='T' then 'iif('||cndtxt||',{'||nexttask_true||'},'||'{'||nexttask_false||'})'
else cndtxt end  into v_formula from b;

-----Used for PEG condition based on task params

elseif pegversion = 'v2' then

with a as(
select
	regexp_split_to_table(formula, E'~') cols),
b as(select 	string_agg(case when split_part( cols, '|', 2) not in('In','Not in') then  substring(split_part(cols, '|', 1), position('-(' in split_part(cols, '|', 1))+ 2, abs((position('-(' in split_part(cols, '|', 1) )+ 2) - length(substring(split_part(cols, '|', 1), 1, length(split_part(cols, '|', 1)))))) else '' end||' '||
	case when split_part( cols, '|', 2)='Equal to' then '='
	when split_part( cols, '|', 2)='Not equal to' then '#'
	when split_part( cols, '|', 2)='Greater than' then '>'
	when split_part( cols, '|', 2)='Lesser than' then '<' 
	when split_part( cols, '|', 2) in('In','Not in') then 'StringPOS('||substring(split_part(cols, '|', 1), position('-(' in split_part(cols, '|', 1))+ 2, abs((position('-(' in split_part(cols, '|', 1) )+ 2) - length(substring(split_part(cols, '|', 1), 1, length(split_part(cols, '|', 1))))))||','
	end||' '||
	case when substring(substring(substring(split_part(cols, '|', 1), position('-(' in split_part(cols, '|', 1))+ 2, abs((position('-(' in split_part(cols, '|', 1) )+ 2) - length(substring(split_part(cols, '|', 1), 1, length(split_part(cols, '|', 1)))))),position('.' in substring(split_part(cols, '|', 1), position('-(' in split_part(cols, '|', 1))+ 2, abs((position('-(' in split_part(cols, '|', 1) )+ 2) - length(substring(split_part(cols, '|', 1), 1, length(split_part(cols, '|', 1)))))))+1),1,1) in('c','t')
	then concat('{',split_part( cols, '|', 3),'}') else split_part( cols, '|', 3) end||
	case when split_part( cols, '|', 2)='In' then ') # -1' when split_part( cols, '|', 2)='Not in' then ') = -1' else '' end ||' '||
	case when split_part( cols, '|', 4)='And' then '&'
	when split_part( cols, '|', 4)='Or' then '|'
	when split_part( cols, '|', 4)='And(' then '&('
	when split_part( cols, '|', 4)='Or(' then '|('	
	else split_part( cols, '|', 4) end,' ') cndtxt
	 from a)
	select 'iif('||cndtxt||',{T},{F})' into v_formula from b;

end if;

return v_formula;
end;

$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_ruledef_table_genaxscript(pcmd character varying, ptbldtls character varying, pcnd numeric)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
    v_formula varchar(2000);

   BEGIN

if pcnd=1 then 	   

	select concat(pcmd,' ',
	string_agg(case when split_part( fname, '|', 2) not in('In','Not in') then  substring(substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),2) else '' end||' '||
	case  when split_part(fname, '|', 2)='Equal to' then ' = ' 
	when split_part(fname, '|', 2)='Not equal to' then ' # ' 
	when split_part(fname, '|', 2)='Greater than' then ' > ' 
	when split_part(fname, '|', 2)='Lesser than' then ' < ' 
	when split_part( fname, '|', 2) in('In','Not in') then 'StringPOS('||substring(substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),2)||','
	end ||' '||
	case when substring(substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),1,1) in('c','t')
	then concat('{',split_part( fname, '|', 3),'}') else split_part( fname, '|', 3) end ||
	case when split_part( fname, '|', 2)='In' then ') # -1' when split_part( fname, '|', 2)='Not in' then ') = -1' else '' end 	
	||' '||
	case split_part(fname, '|', 4) when 'And' then ' & ' when 'Or' then ' | ' when 'And(' then ' & (' when 'Or(' then ' | (' else split_part(fname, '|', 4) end,'')) into v_formula 
	from(select unnest(string_to_array( ptbldtls, '~')) fname)a ;
	/*select concat(pcmd,' ',string_agg(concat(substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),
	case split_part(fname, '|', 2)
	when 'Equal to' then ' = ' 
	when 'Not equal to' then ' # ' 
	when 'Greater than' then ' > ' 
	when 'Lesser than' then ' < ' end,
	split_part(fname, '|', 3),
	case split_part(fname, '|', 4) when 'And' then ' & ' when 'Or' then ' | ' when 'And(' then ' & (' when 'Or(' then ' | (' else split_part(fname, '|', 4) end),'')) into v_formula
	from(select unnest(string_to_array( ptbldtls, '~')) fname)a;*/

elseif pcnd =2 then 
	select case when pcmd ='Show' then concat('Axunhidecontrols({', fnames ,'})') 
	when pcmd ='Hide' then concat('Axhidecontrols({', fnames ,'})')
	when pcmd ='Enable' then concat('Axenablecontrols({', fnames ,'})')
	when pcmd ='Disable' then concat('Axdisablecontrols({', fnames ,'})')
	when pcmd ='Mandatory' then concat('AxAllowEmpty({', fnames ,'},{F})')
	when pcmd ='Non mandatory' then concat('AxAllowEmpty({', fnames ,'},{T})') end  into v_formula from 
	(select string_agg(substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),',') fnames
	from(select unnest(string_to_array(ptbldtls, '~')) fname )a)b;

elseif pcnd in(3,31) then 
	select case when pcmd='Mask few characters' then concat('AxMask({',substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),'}',
	',{',split_part(fname, '|', 2),'},{',
	split_part(fname, '|', 3),'~',
	split_part(fname, '|', 4),'})') 
	when pcmd ='Mask all characters' then concat('AxMask({',substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),
	'},{',split_part(fname, '|', 2),'},{all})') 
	end  into v_formula
	from(select unnest(string_to_array(ptbldtls, '~')) fname )a;

elseif pcnd=4 then

	select string_agg(concat('SetValue({',substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),
	'},1,{',split_part(fname, '|', 2),'})'),chr(10)) into v_formula
	from(select unnest(string_to_array(ptbldtls, '~')) fname )a;
	
	/* 
	 select concat('SetValue({',substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),
	'},1,{',split_part(fname, '|', 2),'})') into v_formula
	from(select unnest(string_to_array(ptbldtls, '~')) fname )a;*/

elseif pcnd=5 then  
	select case when pcmd='Show message' then concat('ShowMessage({',split_part(fname, '|', 1),'},{Simple},{})')
	when pcmd='Show error' then concat('ShowMessage({',split_part(fname, '|', 1),'},{Exception},{})') end  into v_formula
	from(select unnest(string_to_array(ptbldtls, '~')) fname )a;

elseif pcnd=6 then 
	v_formula := pcmd;

------------used in PEG for Set value
elseif pcnd=7 then 
	select string_agg(concat('SetValue({',substring(split_part(fname, '|', 1), position('-(' in split_part(fname, '|', 1))+ 2, abs((position('-(' in split_part(fname, '|', 1) )+ 2) - length(substring(split_part(fname, '|', 1), 1, length(split_part(fname, '|', 1)))))),
	'},1,{',split_part(fname, '|', 2),'})'),chr(10)) into v_formula
	from(select unnest(string_to_array(ptbldtls, '~')) fname )a;

end if;
	
RETURN v_formula;
END;
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_ruledef_tablefield(pcnd numeric)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare
v_json varchar;

BEGIN  

/*
1	If,Else if
2	Enable,Show,Hide,Disable,Mandatory,Non mandatory
3	Mask all characters,Mask few characters
4	Set value to field
5	Show message,Show error
6	Else
*/
	
if pcnd = 1 then --If , Else if 	 

select '{"props":{"type":"table","colcount":"4","rowcount":"1","addrow":"t","deleterow":"t","valueseparator":"|","rowseparator":"~"},"columns":{	"1":{"caption":"Condition field","name":"cfld","value":"","source":"cndfldcaption","exp":"","vexp":""},"2":{"caption":"Operator","name":"opr","value":"","source":"formula_opr","exp":"","vexp":""},"3":{"caption":"Value","name":"fldvalue","value":"","source":"","exp":"","vexp":""},"4":{"caption":"Condition","name":"ccnd","value":"","source":"formula_andor","exp":"","vexp":""}}}'  into v_json;
		
		
 
elseif pcnd = 2 then  --Enable,Disable,Show,Hide,Mandatory,Non mandatory

select '{"props":{"type":"table","colcount":"1","rowcount":"1","addrow":"t","deleterow":"t","valueseparator":"|","rowseparator":"~"},"columns":{"1":{"caption":"Apply rule on","name":"cndfld","value":"","source":"fctlfldcaption","exp":"","vexp":""}}}' into v_json;

elseif pcnd = 4 then --Set value to field

select '{"props":{"type":"table","colcount":"2","rowcount":"1","addrow":"t","deleterow":"t","valueseparator":"|","rowseparator":"~"},"columns":{"1":{"caption":"Set value to field","name":"cndfld","value":"","source":"setvalueflds","exp":"","vexp":""},"2":{"caption":"Value","name":"sval","value":"","source":"","exp":"","vexp":""}}}'  into v_json;

elseif pcnd=5 then -- Show message,Show error

select '{"props":{"type":"table","colcount":"1","rowcount":"1","addrow":"f","deleterow":"f","valueseparator":"|","rowseparator":"~"},"columns":{"1":{"caption":"Message",	"name":"cndfld","value":"","source":"","exp":"","vexp":""}}}'  into v_json;

end if;

  RETURN v_json;
 
END;
$function$
;
>>

<<
CREATE TABLE axactivetasks (
	eventdatetime varchar(30) NULL,
	taskid varchar(15) NULL,
	processname varchar(500) NULL,
	tasktype varchar(30) NULL,
	taskname varchar(500) NULL,
	taskdescription varchar(4000) NULL,
	assigntorole varchar(50) NULL,
	transid varchar(8) NULL,
	keyfield varchar(30) NULL,
	execonapprove varchar(5) NULL,
	keyvalue varchar(500) NULL,
	transdata varchar(4000) NULL,
	fromrole varchar(30) NULL,
	fromuser varchar(30) NULL,
	touser varchar(500) NULL,
	priorindex numeric(10) NULL,
	priortaskname varchar(200) NULL,
	corpdimension varchar(10) NULL,
	orgdimension varchar(10) NULL,
	department varchar(30) NULL,
	grade varchar(10) NULL,
	datavalue varchar(4000) NULL,
	displayicon varchar(200) NULL,
	displaytitle varchar(500) NULL,
	displaysubtitle varchar(250) NULL,
	displaycontent text NULL,
	displaybuttons varchar(250) NULL,
	groupfield varchar(4000) NULL,
	groupvalue varchar(4000) NULL,
	priorusername varchar(100) NULL,
	initiator varchar(100) NULL,
	mapfieldvalue varchar(4000) NULL,
	useridentificationfilter varchar(1000) NULL,
	useridentificationfilter_of varchar(1000) NULL,
	mapfield_group varchar(1000) NULL,
	mapfield varchar(1000) NULL,
	grouped varchar(1) NULL,
	indexno numeric(10) NULL,
	subindexno numeric(10) NULL,
	processowner varchar(100) NULL,
	assigntoflg varchar(1) NULL,
	assigntoactor varchar(1000) NULL,
	actorfilter text NULL,
	recordid numeric(20) NULL,
	processownerflg numeric(1) NULL,
	pownerfilter varchar(4000) NULL,
	approvereasons varchar(4000) NULL,
	defapptext varchar(4000) NULL,
	returnreasons varchar(4000) NULL,
	defrettext varchar(4000) NULL,
	rejectreasons varchar(4000) NULL,
	defregtext varchar(4000) NULL,
	approvalcomments varchar(1) NULL,
	rejectcomments varchar(1) NULL,
	returncomments varchar(1) NULL,
	escalation varchar(1) NULL,
	reminder varchar(1) NULL,
	displaymcontent text NULL,
	groupwithpriorindex numeric(2) NULL,
	delegation varchar(1) DEFAULT 'F'::character varying NULL,
	returnable varchar(1) NULL,
	sendtoactor varchar(4000) NULL,
	allowsend varchar(30) NULL,
	allowsendflg varchar(1) NULL,
	sendtocomments varchar(4000) NULL,
	usebusinessdatelogic varchar(1) NULL,
	initiator_approval varchar(1) NULL,
	initonbehalf varchar(100) NULL,
	removeflg varchar(1) DEFAULT 'F'::character varying NULL,
	pownerflg varchar(1) DEFAULT 'F'::character varying NULL,
	changedusr varchar(1) DEFAULT 'F'::character varying NULL,
	actor_user_groups text NULL,
	actor_default_users varchar(1) NULL,
	actor_data_grp varchar(200) NULL,
	cancel varchar(1) DEFAULT 'F'::character varying NULL,
	cancelledby varchar(100) NULL,
	cancelledon timestamp NULL,
	cancelremarks text NULL,
	action_buttons varchar(100) NULL,
	autoapprove varchar(1) NULL,
	isoptional varchar(1) NULL,
	reminderstartdate date NULL,
	escalationstartdate date NULL,
	reminderjsondata text NULL,
	escalationjsondata text NULL
);
>>

<<
CREATE INDEX ui_axactivetasks_keyvalue ON axactivetasks USING btree (keyvalue);
>>

<<
CREATE INDEX ui_axactivetasks_transid ON axactivetasks USING btree (transid);
>>

<<
CREATE OR REPLACE FUNCTION fn_peg_assigntoactor(assigntoactor character varying, actorfilter character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare
rec record;
ag record;
agc record;
v_grpname varchar[] DEFAULT  ARRAY[]::varchar[];
qry text;
sqlstmt refcursor;
cndresult int;
grpresult int;
truecnt int;
v_totalcnd int;
allusers int;
v_datagrpusers varchar[] DEFAULT  ARRAY[]::varchar[];

begin
	grpresult = 0;
truecnt = 0;
cndresult = 0;
allusers=0;

	<<Actor_Groups>>
	for ag in 	
	select a.actorname,b.axpdef_peg_grpfilterrow,b.tbl_datagrp,b.datagrpusers,axpdef_peg_grpfilterid,a.priorindextransid stransid
	from axpdef_peg_actor a,axpdef_peg_grpfilter b
	where a.axpdef_peg_actorid =b.axpdef_peg_actorid 	
	and a.actorname = assigntoactor 
	
	loop		
	select array_length(string_to_array( tbl_datagrp, '~'),1)  into v_totalcnd from axpdef_peg_grpfilter 
	where axpdef_peg_grpfilterid = ag.axpdef_peg_grpfilterid;

	<<Groups_Condition>>	
		for agc in 
			select substring(unnest(string_to_array( split_part(tbl_datagrp,'|',1) , ',')), position('-(' in unnest(string_to_array( split_part(tbl_datagrp,'|',1) , ',')))+ 2, abs((position('-(' in unnest(string_to_array( split_part(tbl_datagrp,'|',1) , ',')))+ 2) - length(substring(unnest(string_to_array( split_part(tbl_datagrp,'|',1) , ',')), 1, length(unnest(string_to_array( split_part(tbl_datagrp,'|',1) , ','))))))) fldname,
			substring(substring(unnest(string_to_array( split_part(tbl_datagrp,'|',1) , ',')), position('-(' in unnest(string_to_array( split_part(tbl_datagrp,'|',1) , ',')))+ 2, abs((position('-(' in unnest(string_to_array( split_part(tbl_datagrp,'|',1) , ',')))+ 2) - length(substring(unnest(string_to_array( split_part(tbl_datagrp,'|',1) , ',')), 1, length(unnest(string_to_array( split_part(tbl_datagrp,'|',1) , ','))))))),1,1) flddatatype,
			case when split_part(tbl_datagrp,'|',2) = 'Equal to' then '='
			when split_part(tbl_datagrp,'|',2) = 'Not equal to' then '!='
			when split_part(tbl_datagrp,'|',2) = 'In' then 'in'
			when split_part(tbl_datagrp,'|',2) = 'Not in' then 'not in'
			when split_part(tbl_datagrp,'|',2) = 'Greater than' then '>'
			when split_part(tbl_datagrp,'|',2) = 'Greater than or Equal to' then '>='
			when split_part(tbl_datagrp,'|',2) = 'Lesser than' then '<'
			when split_part(tbl_datagrp,'|',2) = 'Lesser than or Equal to' then '<=' end cndoprsym,
			split_part(tbl_datagrp,'|',3) fldvalue,axpdef_peg_grpfilterid,datagrpusers,dgname from 
			(select unnest(string_to_array(tbl_datagrp,'~')) tbl_datagrp,axpdef_peg_grpfilterid,datagrpusers,dgname
			from axpdef_peg_grpfilter g2
			where g2.axpdef_peg_grpfilterid =  ag.axpdef_peg_grpfilterid)a		
			
			
			loop 
				
				if agc.cndoprsym  = 'in' or agc.cndoprsym  = 'not in' then										
					open sqlstmt for with ud as (select split_part(regexp_split_to_table(actorfilter,'~'),'=',1) cndfld,
					split_part(regexp_split_to_table(actorfilter,'~'),'=',2) cndfldval) 
					select *  from ud;
					fetch next from sqlstmt into rec;						
					<<user_data>>
					while found loop 	   						
			   		qry :='select count(*) from dual where '''||agc.fldname||'''='''||rec.cndfld ||''' and '''|| rec.cndfldval||''''||agc.cndoprsym||'('''||replace(agc.fldvalue,',',''',''')||''')';			   					   						   		
				   	execute qry into cndresult;					   					  	
 				    if cndresult > 0 then  grpresult := grpresult +1; end if;					  						  				 					   
				  	if cndresult > 0 then truecnt := truecnt + 1; end if;
				  	exit user_data when cndresult > 0;
				  	fetch next from sqlstmt into rec; 			      	
    				end loop;    		
    			 	if v_totalcnd = truecnt then      			 	
					  	v_grpname := array_append(v_grpname,agc.dgname);  
					  	v_datagrpusers := array_append(v_datagrpusers,cast(concat(agc.dgname,'~~',agc.datagrpusers)as varchar(4000)));
    				end if;  
					CLOSE sqlstmt;
				else
					open sqlstmt for with ud as (select * from(select split_part(regexp_split_to_table(actorfilter,'~'),'=',1) cndfld,
					split_part(regexp_split_to_table(actorfilter,'~'),'=',2) cndfldval)a
					where cndfld = agc.fldname
					) 
					select * from ud;
					fetch next from sqlstmt into rec;						
					<<user_data>>
					while found loop 	   						
			   		qry :='select count(*) from dual where '''||agc.fldname||'''='''||rec.cndfld||'''' ||case when agc.flddatatype='n' then ' and '||rec.cndfldval||' '||agc.cndoprsym||' '||agc.fldvalue else  ' and '''||rec.cndfldval||''''||agc.cndoprsym||''''||agc.fldvalue||''''end;			   					   											   	
			   		execute qry into cndresult;					   						
 					if cndresult > 0 then  grpresult := grpresult +1; end if;								  				 					   	
					if cndresult > 0 then truecnt := truecnt + 1; end if;					  
					exit user_data when cndresult > 0;
				    fetch next from sqlstmt into rec;				      	
    				end loop;    		
    				if v_totalcnd = truecnt then  
					  	v_grpname := array_append(v_grpname,agc.dgname); 	
	  				    v_datagrpusers := array_append(v_datagrpusers,cast(concat(agc.dgname,'~~',agc.datagrpusers)as varchar(4000)));
    				end if; 
					CLOSE sqlstmt;
				end if;    		
			end loop;		
			grpresult = 0;truecnt = 0;			
	end loop;		
if array_length(v_datagrpusers,1)>0 then 
return array_to_string(v_datagrpusers,'|~');
else 
return '0'; end if;
end;
$function$
;
>>

<<
CREATE TABLE axpdef_peg_usergroups (
	username varchar(100) NULL,
	usergroupname varchar(500) NULL,
	usergroupcode varchar(20) NULL,
	active varchar(1) NULL,
	effectivefrom timestamp NULL,
	fromuser varchar(1) DEFAULT 'F'::character varying NULL);
>>

<<
CREATE OR REPLACE FUNCTION fn_axactivetasks()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare 
v_grpname varchar[] DEFAULT  ARRAY[]::varchar[];
usercount int;
v_assignmodecnd int;
v_defusers varchar;
v_datagrpusers varchar;
v_usergrpuser varchar;
v_initiator_usergrps varchar;
v_processonwer_cnt int;
v_sqlstmt refcursor;
rec record;
begin
/* assigntoflg=
 * 1 - Reporting manager
 * 2 - Assign to Actor
 * 3 - Assign to Role
 * 4 - From form field
 * 6 - Skip level
 */
/*processownerflg
 * 1 - Actor
 * 2 - Role
 */	
/*allowsendflg
 * 1 - None
 * 2 - Any user
 * 3 - Users in this process
 * 4 - Actor
 * */	
	

	
----------------------------Assign to Reporting Manager & Form fields when touser is null | Redirect to Process owners	
if new.assigntoflg in('1','4','6') and new.touser is null and new.grouped is null then            
		
	select count(*) into v_processonwer_cnt
	from axuserlevelgroups c
	where c.usergroup = new.processowner		
	and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
	and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));

	if v_processonwer_cnt > 0 then	
	insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
	keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
	displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
	useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
	assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
	allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,isoptional,
	Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
	select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
	new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,
	new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,
	new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,	new.useridentificationfilter,
	new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
	new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
	new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
	new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,new.returnable,
	new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,new.initonbehalf,'T',
	new.autoapprove,new.isoptional,new.Reminderstartdate,new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
	from axuserlevelgroups c
	where c.usergroup = new.processowner		
	and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
	and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
	else
	---Redirect to default role when no users exists in process owner
	insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
	keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
	displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
	useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
	assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
	allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,isoptional,
	Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
	select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
	new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,
	new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,
	new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,	new.useridentificationfilter,
	new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
	new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
	new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
	new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,new.returnable,
	new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,new.initonbehalf,'T',
	new.autoapprove,new.isoptional,new.Reminderstartdate,new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
	from axuserlevelgroups c
	where c.usergroup = 'default'		
	and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
	and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
	end if;
								
end if;	
	
	
-----------------------Assign to Reporting Manager & Form fields & User exists  - Redirect to delegated users
if new.assigntoflg in('1','4','6') and new.touser is not null and new.grouped ='T' then	

	insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
	transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
	displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
	useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,
	pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder,
	displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,sendtoactor,initiator_approval,
	usebusinessdatelogic,initonbehalf,autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 								
	select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,new.execonapprove,
	new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,new.department,
	new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,
	new.priorusername,new.initiator,new.mapfieldvalue,new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',
	new.indexno,new.subindexno,new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
	new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,
	new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,'T',new.returnable,new.allowsend,new.allowsendflg,
	new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,new.initonbehalf,new.autoapprove,
	new.isoptional,new.Reminderstartdate,new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata			
	from axprocessdef_delegation c 
	where c.fromusername = new.touser				
	and current_date  >= c.fromdate
	and current_date  <= c.todate;

end if;
	


------------------------------- Assign to Actor
if new.assigntoflg ='2' then 
	
	select coalesce(assignmodecnd,0) assignmodecnd,defusername,case when array_length(string_to_array(defusername,','),1) is null then 0 else  array_length(string_to_array(defusername,','),1) end usercount
	into v_assignmodecnd,v_defusers ,usercount
	from axpdef_peg_actor a
	where a.actorname=new.assigntoactor; 


	if v_assignmodecnd = 1 then --------Default user
	
		if usercount > 0 then
		insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
		keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,
		displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
		useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,
		actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,
		rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,allowsendflg,sendtoactor,
		initiator_approval,usebusinessdatelogic,initonbehalf,actor_default_users,autoapprove,isoptional,
		Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
		select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
		new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,regexp_split_to_table(v_defusers,','),new.priorindex,new.priortaskname,
		new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,
		new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
		new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
		new.processowner,new.assigntoflg,new.assigntoactor,	new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,new.approvereasons,
		new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,
		new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,new.returnable,new.allowsend,new.allowsendflg,new.sendtoactor,
		new.initiator_approval,new.usebusinessdatelogic,new.initonbehalf,'T' ,new.autoapprove,
		new.isoptional,new.Reminderstartdate,new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
		from dual;
	
	
	
		---------Delegation(Default users)
		insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
		transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
		displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
		useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,
		recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,
		rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,
		sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,autoapprove,isoptional,
		Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
		select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,
		new.keyfield,new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,
		new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,
		new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
		new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
		new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
		new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,
		new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,'T',new.returnable,
		new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,new.initonbehalf,new.autoapprove,
		new.isoptional,new.Reminderstartdate,new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
		from 
		(select regexp_split_to_table(v_defusers,',') fuser)a,axprocessdef_delegation c 
		where a.fuser = c.fromusername				
		and current_date  >= c.fromdate
		and current_date  <= c.todate;	
		else
		------------Redirect to process owner	
		select count(*) into v_processonwer_cnt
		from axuserlevelgroups c
		where c.usergroup = new.processowner		
		and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
		and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
	
		if v_processonwer_cnt > 0 then			
		insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
		keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
		displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
		useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
		assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
		approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
		allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,
		isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
		select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
		new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,
		new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,
		new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,	new.useridentificationfilter,
		new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
		new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
		new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
		new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,new.returnable,
		new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,new.initonbehalf,'T',
		new.autoapprove,new.isoptional,new.Reminderstartdate,new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
		from axuserlevelgroups c
		where c.usergroup = new.processowner		
		and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
		and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
		else----Redirect to default role if users are not exists in process owner
		insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
		keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
		displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
		useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
		assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
		approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
		allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,
		isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
		select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
		new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,
		new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,
		new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,	new.useridentificationfilter,
		new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
		new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
		new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
		new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,new.returnable,
		new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,new.initonbehalf,'T',
		new.autoapprove,new.isoptional,new.Reminderstartdate,new.Escalationstartdate,
		new.reminderjsondata,new.escalationjsondata
		from axuserlevelgroups c
		where c.usergroup = 'default'		
		and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
		and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
		end if;
			
		--------------Delegation(Process owner)
		insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
		transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
		displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,
		mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
		approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,
		reminder,displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,sendtoactor,initiator_approval,
		usebusinessdatelogic,initonbehalf,autoapprove,isoptional,Reminderstartdate,
		Escalationstartdate,reminderjsondata,escalationjsondata) 								
		select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
		new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,
		new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,
		new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,new.useridentificationfilter,new.useridentificationfilter_of,
		new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,
		new.processownerflg,new.pownerfilter,new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
		new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,'T',
		new.returnable,new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,
		new.initonbehalf,new.autoapprove,new.isoptional,new.Reminderstartdate,
		new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
		from axuserlevelgroups a,axprocessdef_delegation c 
		where a.usergroup = new.processowner
		and a.username = c.fromusername
		and current_date  >= c.fromdate
		and current_date  <= c.todate					 		
		and ((a.startdate is not null and current_date  >= a.startdate) or (a.startdate is null)) 
		and ((a.enddate is not null and current_date  <= a.enddate) or (a.enddate is null));
		
		end if;
	elseif v_assignmodecnd = 2 then -----------User group
			
		select distinct string_agg(usergroupname,',') into  v_initiator_usergrps 
		from axpdef_peg_usergroups where username = case when length(new.initonbehalf)>1 then new.initonbehalf else  new.initiator end
		and active='T'
		and effectivefrom <= current_date;
		
		----------- Check approval users are assigned for the initiator's group
		select string_agg(concat(usergroupname,'~~',unames),'|~') ,count(*) into v_usergrpuser,usercount
		from (select distinct b.usergroupname, b.ugrpusername unames
		from axpdef_peg_actor a
		join axpdef_peg_actorusergrp b on a.axpdef_peg_actorid=b.axpdef_peg_actorid
		where a.actorname = new.assigntoactor 
		and b.usergroupname in (select regexp_split_to_table(v_initiator_usergrps,','))
		order by 1 )a;
		
			
			--------- if approval users are assinged in process users
			if usercount > 0 then 
			
				open v_sqlstmt for 
				select  split_part(unnest(string_to_array(v_usergrpuser,'|~')),'~~',1) ugrpname,
				split_part(unnest(string_to_array(v_usergrpuser,'|~')),'~~',2) ugrpusers;
			
				fetch next from v_sqlstmt into rec;
			
				while found 		
    			loop 	
			
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
				transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
				displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
				useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,
				processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,
				returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,
				allowsend,allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,actor_user_groups,
				autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
				new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,regexp_split_to_table(rec.ugrpusers,','),new.priorindex,new.priortaskname,
				new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,
				new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,new.useridentificationfilter,
				new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,new.assigntoflg,new.assigntoactor,
				new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,
				new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,
				new.groupwithpriorindex,new.returnable,new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,
				new.initonbehalf,rec.ugrpname,new.autoapprove,new.isoptional,new.Reminderstartdate,
				new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
				from dual;
			
				 fetch next from v_sqlstmt into rec;
		   		    
    			end loop;	
			
				---------Delegation(usergroup users)
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
				transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
				displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
				useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,
				recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,
				rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,
				sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,autoapprove,isoptional,
				Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,
				new.keyfield,new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,
				new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,
				new.displaycontent,new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,
				new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
				new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,
				new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,'T',new.returnable,
				new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,new.initonbehalf,
				new.autoapprove,new.isoptional,new.Reminderstartdate,new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
				from 
				(select regexp_split_to_table(v_usergrpuser,',') fuser)a,axprocessdef_delegation c 
				where a.fuser = c.fromusername				
				and current_date  >= c.fromdate
				and current_date  <= c.todate;
				
			else ------------------------ if approval users are not assinged in process users,Redirect to process owner	
				select count(*) into v_processonwer_cnt
				from axuserlevelgroups c
				where c.usergroup = new.processowner		
				and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
	
				if v_processonwer_cnt > 0 then				
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
				keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
				displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
				useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
				assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
				approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
				allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,
				isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
				new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,
				new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,
				new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,	new.useridentificationfilter,
				new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
				new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
				new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,new.returnable,
				new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,
				new.initonbehalf,'T',new.autoapprove,new.isoptional,new.Reminderstartdate,
				new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
				from axuserlevelgroups c
				where c.usergroup = new.processowner		
				and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
				else
				---Redirect to default role when no users exists in process owner
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
				keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
				displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
				useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
				assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
				approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
				allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,
				autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
				new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,
				new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,
				new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,	new.useridentificationfilter,
				new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
				new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
				new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,new.returnable,
				new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,
				new.initonbehalf,'T',new.autoapprove,new.isoptional,new.Reminderstartdate,
				new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
				from axuserlevelgroups c
				where c.usergroup = 'default'		
				and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
				end if;
				--------------Delegation(Process owner)
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
				transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
				displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,
				mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,
				reminder,displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic
				,initonbehalf,autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 								
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
				new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,
				new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,
				new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,new.useridentificationfilter,new.useridentificationfilter_of,
				new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,
				new.processownerflg,new.pownerfilter,new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
				new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,'T',
				new.returnable,new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,
				new.initonbehalf,new.autoapprove,new.isoptional,new.Reminderstartdate,new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
				from axuserlevelgroups a,axprocessdef_delegation c 
				where a.usergroup = new.processowner
				and a.username = c.fromusername
				and current_date  >= c.fromdate
				and current_date  <= c.todate					 		
				and ((a.startdate is not null and current_date  >= a.startdate) or (a.startdate is null)) 
				and ((a.enddate is not null and current_date  <= a.enddate) or (a.enddate is null));	
				
			end if;
			
			
	elseif v_assignmodecnd = 3 then 	---- Data groups

		select fn_peg_assigntoactor(new.assigntoactor,new.actorfilter) into v_datagrpusers ;		

			if v_datagrpusers != '0' then
				open v_sqlstmt for 
				select split_part(unnest(string_to_array(v_datagrpusers,'|~')),'~~',1) dgrpname,
				split_part(unnest(string_to_array(v_datagrpusers,'|~')),'~~',2) dgrpusers;
			
				fetch next from v_sqlstmt into rec;
			
				while found 		
    			loop 					
    				
    			insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
				transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
				displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
				useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,
				processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,
				returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,
				allowsend,allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,actor_data_grp,
				autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
				new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,regexp_split_to_table(rec.dgrpusers,','),new.priorindex,new.priortaskname,
				new.corpdimension,new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,
				new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,new.useridentificationfilter,
				new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,new.assigntoflg,new.assigntoactor,
				new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,
				new.rejectreasons,new.defregtext,new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,
				new.groupwithpriorindex,new.returnable,new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,new.initonbehalf,
				rec.dgrpname,new.autoapprove,new.isoptional,new.Reminderstartdate,
				new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
				from dual;	
			
     			fetch next from v_sqlstmt into rec;		   		    
    			end loop;	
			
    		    						
				---------Delegation(data group users)
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
				transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
				displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
				useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,
				recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,
				rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,
				sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,autoapprove,isoptional,
				Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
				new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,new.orgdimension,
				new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,new.groupfield,
				new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,new.useridentificationfilter,new.useridentificationfilter_of,new.mapfield_group,
				new.mapfield,'T',new.indexno,new.subindexno,new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,
				new.pownerfilter,new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,new.approvalcomments,
				new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,'T',new.returnable,
				new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,
				new.initonbehalf,new.autoapprove,new.isoptional,new.Reminderstartdate,
				new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
				from 
				(select regexp_split_to_table(v_datagrpusers,',') fuser)a,axprocessdef_delegation c 
				where a.fuser = c.fromusername				
				and current_date  >= c.fromdate
				and current_date  <= c.todate;			
			else		
				----------Redirect to process owner
				select count(*) into v_processonwer_cnt
				from axuserlevelgroups c
				where c.usergroup = new.processowner		
				and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
	
				if v_processonwer_cnt > 0 then					
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
				transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
				displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,
				mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,
				reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,allowsendflg,sendtoactor,initiator_approval,
				usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,isoptional,
				Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
				new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,
				new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,
				new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,new.useridentificationfilter,new.useridentificationfilter_of,
				new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,
				new.processownerflg,new.pownerfilter,new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
				new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,
				new.returnable,new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,
				new.initonbehalf,'T',new.autoapprove,new.isoptional,new.Reminderstartdate,
				new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
				from axuserlevelgroups c
				where c.usergroup = new.processowner		
				and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
				else	
				---Redirect to default role when no users exists in process owner
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
				keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
				displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
				useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
				assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
				approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
				allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,
				autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
				new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,
				new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,
				new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,	new.useridentificationfilter,
				new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
				new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
				new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,new.returnable,
				new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,
				new.initonbehalf,'T',new.autoapprove,new.isoptional,new.Reminderstartdate,
				new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
				from axuserlevelgroups c
				where c.usergroup = 'default'		
				and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
				end if;						
						
				--------------Delegation(Process owner | Role)
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
				transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
				displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,
				mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,
				reminder,displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,sendtoactor,initiator_approval,
				usebusinessdatelogic,initonbehalf,autoapprove,isoptional,Reminderstartdate,
				Escalationstartdate,reminderjsondata,escalationjsondata) 								
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
				new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,
				new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,
				new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,new.useridentificationfilter,new.useridentificationfilter_of,
				new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,
				new.processownerflg,new.pownerfilter,new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
				new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,'T',
				new.returnable,new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,
				new.usebusinessdatelogic,new.initonbehalf,new.autoapprove,new.isoptional,
				new.Reminderstartdate,new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
				from axuserlevelgroups a,axprocessdef_delegation c 
				where a.usergroup = new.processowner
				and a.username = c.fromusername
				and current_date  >= c.fromdate
				and current_date  <= c.todate					 		
				and ((a.startdate is not null and current_date  >= a.startdate) or (a.startdate is null)) 
				and ((a.enddate is not null and current_date  <= a.enddate) or (a.enddate is null));	
												
				end if;	
			
			elseif v_assignmodecnd = 0 then ----'When Assign users data is not entered'
				----------Redirect to process owner
				select count(*) into v_processonwer_cnt
				from axuserlevelgroups c
				where c.usergroup = new.processowner		
				and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
	
				if v_processonwer_cnt > 0 then					
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
				transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
				displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,
				mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,
				reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,allowsendflg,sendtoactor,initiator_approval,
				usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,isoptional,
				Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
				new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,
				new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,
				new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,new.useridentificationfilter,new.useridentificationfilter_of,
				new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,
				new.processownerflg,new.pownerfilter,new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
				new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,
				new.returnable,new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,
				new.initonbehalf,'T',new.autoapprove,new.isoptional,new.Reminderstartdate,
				new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
				from axuserlevelgroups c
				where c.usergroup = new.processowner		
				and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
			
				--------------Delegation(Process owner | Role)
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
				transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
				displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,useridentificationfilter_of,
				mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
				approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,
				reminder,displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,sendtoactor,initiator_approval,
				usebusinessdatelogic,initonbehalf,autoapprove,isoptional,Reminderstartdate,
				Escalationstartdate,reminderjsondata,escalationjsondata) 								
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
				new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.tousername,new.priorindex,new.priortaskname,new.corpdimension,
				new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,new.displaybuttons,
				new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,new.useridentificationfilter,new.useridentificationfilter_of,
				new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,
				new.processownerflg,new.pownerfilter,new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
				new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,'T',
				new.returnable,new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,
				new.initonbehalf,new.autoapprove,new.isoptional,new.Reminderstartdate,
				new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
				from axuserlevelgroups a,axprocessdef_delegation c 
				where a.usergroup = new.processowner
				and a.username = c.fromusername
				and current_date  >= c.fromdate
				and current_date  <= c.todate					 		
				and ((a.startdate is not null and current_date  >= a.startdate) or (a.startdate is null)) 
				and ((a.enddate is not null and current_date  <= a.enddate) or (a.enddate is null));	
												
			
				else	
				---Redirect to default role when no users exists in process owner
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
				keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
				displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
				useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
				assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
				approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
				allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,
				autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select new.eventdatetime,new.taskid,new.processname,new.tasktype,new.taskname,new.taskdescription,new.assigntorole,new.transid,new.keyfield,
				new.execonapprove,new.keyvalue,new.transdata,new.fromrole,new.fromuser,c.username,new.priorindex,new.priortaskname,new.corpdimension,
				new.orgdimension,new.department,new.grade,new.datavalue,new.displayicon,new.displaytitle,new.displaysubtitle,new.displaycontent,
				new.displaybuttons,new.groupfield,new.groupvalue,new.priorusername,new.initiator,new.mapfieldvalue,	new.useridentificationfilter,
				new.useridentificationfilter_of,new.mapfield_group,new.mapfield,'T',new.indexno,new.subindexno,
				new.processowner,new.assigntoflg,new.assigntoactor,new.actorfilter,new.recordid,new.processownerflg,new.pownerfilter,
				new.approvereasons,new.defapptext,new.returnreasons,new.defrettext,new.rejectreasons,new.defregtext,
				new.approvalcomments,new.rejectcomments,new.returncomments,new.escalation,new.reminder,new.displaymcontent,new.groupwithpriorindex,new.returnable,
				new.allowsend,new.allowsendflg,new.sendtoactor,new.initiator_approval,new.usebusinessdatelogic,
				new.initonbehalf,'T',new.autoapprove,new.isoptional,new.Reminderstartdate,
				new.Escalationstartdate,new.reminderjsondata,new.escalationjsondata
				from axuserlevelgroups c
				where c.usergroup = 'default'		
				and ((c.startdate is not null and current_date  >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and current_date  <= c.enddate) or (c.enddate is null));
				end if;		
			end if;
end if;			
  
return new;
end; 
$function$
;
>>

<<
create trigger trg_axactivetasks after
insert
    on
    axactivetasks for each row
    when ((((new.grouped is null)
        and ((new.assigntoflg)::text = any (array[('2'::character varying)::text,
        ('3'::character varying)::text])))
        or ((new.assigntoflg)::text = any (array[('1'::character varying)::text,
        ('4'::character varying)::text])))) execute function fn_axactivetasks();
>>

<<
CREATE TABLE axactivetaskdata (
	eventdatetime varchar(30) NULL,
	taskid varchar(15) NULL,
	transid varchar(8) NULL,
	keyfield varchar(30) NULL,
	keyvalue varchar(500) NULL,
	datavalues varchar(4000) NULL
);
>>

<<
CREATE TABLE axactivetaskstatus (
	eventdatetime varchar(30) NULL,
	taskid varchar(15) NULL,
	transid varchar(8) NULL,
	keyfield varchar(30) NULL,
	keyvalue varchar(500) NULL,
	taskstatus varchar(15) NULL,
	username varchar(30) NULL,
	tasktype varchar(500) NULL,
	taskname varchar(500) NULL,
	processname varchar(500) NULL,
	priorindex numeric(10) NULL,
	indexno numeric(10) NULL,
	subindexno numeric(10) NULL,
	recordid numeric(20) NULL,
	statusreason varchar(4000) NULL,
	statustext varchar(4000) NULL,
	cancelremarks text NULL,
	cancelledby varchar(100) NULL,
	cancelledon timestamp NULL,
	cancel varchar(1) NULL,
	sendtocomments varchar(4000) NULL
);
>>

<<
CREATE INDEX username_idx ON axpdef_peg_usergroups USING btree (username);
>>

<<
CREATE TABLE axprocessdef (
	axprocessdefid numeric(16) NOT NULL,
	cancel varchar(1) NULL,
	sourceid numeric(16) NULL,
	mapname varchar(20) NULL,
	username varchar(50) NULL,
	modifiedon timestamp NULL,
	createdby varchar(50) NULL,
	createdon timestamp NULL,
	wkid varchar(15) NULL,
	app_level numeric(3) NULL,
	app_desc numeric(1) NULL,
	app_slevel numeric(3) NULL,
	cancelremarks varchar(150) NULL,
	wfroles varchar(250) NULL,
	processname varchar(500) NULL,
	indexno numeric(10) NULL,
	subindexno numeric(2) NULL,
	tasktype varchar(10) NULL,
	active varchar(1) NULL,
	taskgroupname varchar(250) NULL,
	taskname varchar(500) NULL,
	taskdescription text NULL,
	formcaption varchar(500) NULL,
	keyfieldcaption varchar(500) NULL,
	transid varchar(10) NULL,
	keyfield varchar(250) NULL,
	axpdef_peg_processmasterid numeric(15) NULL,
	prenotify varchar(250) NULL,
	postnotify varchar(250) NULL,
	assignto varchar(50) NULL,
	assigntoflg varchar(10) NULL,
	formfieldscaption varchar(250) NULL,
	formfieldname varchar(100) NULL,
	assigntoactor varchar(100) NULL,
	assigntorole varchar(4000) NULL,
	useridentificationfilter varchar(4000) NULL,
	useridentificationfilter_of varchar(20) NULL,
	assigntouserflag varchar(5) NULL,
	assigntouser varchar(100) NULL,
	mapfield varchar(100) NULL,
	mapfieldcaption varchar(250) NULL,
	mapfield_group varchar(250) NULL,
	formula_opr varchar(50) NULL,
	formula_andor varchar(20) NULL,
	applicability_tbl varchar(4000) NULL,
	applicability varchar(4000) NULL,
	exp_editor_applicability text NULL,
	nexttask_tbl varchar(4000) NULL,
	nexttask_truecnd varchar(250) NULL,
	nexttask_falsecnd varchar(250) NULL,
	nexttask varchar(4000) NULL,
	exp_editor_nexttask text NULL,
	displaybuttons varchar(250) NULL,
	displayicon varchar(200) NULL,
	displaytitle varchar(500) NULL,
	displaysubtitle varchar(250) NULL,
	displaycontent text NULL,
	displaytemplate text NULL,
	processownerui varchar(300) NULL,
	processowner varchar(300) NULL,
	processownerflg numeric(1) NULL,
	approvereasons varchar(4000) NULL,
	defapptext varchar(4000) NULL,
	returnreasons varchar(4000) NULL,
	defrettext varchar(4000) NULL,
	rejectreasons varchar(4000) NULL,
	defregtext varchar(4000) NULL,
	execmaps varchar(2000) NULL,
	editablefieldscaption varchar(4000) NULL,
	execonapprove varchar(250) NULL,
	approvecmt varchar(1) NULL,
	rejectcmt varchar(1) NULL,
	returncmt varchar(1) NULL,
	reminder numeric(2) NULL,
	escalation numeric(2) NULL,
	indexdupchk varchar(1000) NULL,
	mobilenotify varchar(1) NULL,
	CONSTRAINT aglaxprocessdefid PRIMARY KEY (axprocessdefid)
);
>>

<<
CREATE TABLE axactivemessages (eventdatetime varchar(30) NULL,msgtype varchar(30) NULL,fromuser varchar(30) NULL,touser varchar(500) NULL,taskid varchar(15) NULL,tasktype varchar(30) NULL,
processname varchar(500) NULL,taskname varchar(500) NULL,indexno numeric(10) NULL,keyfield varchar(30) NULL,keyvalue varchar(30) NULL,transid varchar(8) NULL,displaytitle varchar(500) NULL,displaycontent text NULL,
effectivefrom timestamp NULL,effectiveto timestamp NULL,html text NULL,scripts text NULL,hide varchar(1) NULL,displayicon varchar(200) NULL,hlink varchar(500) NULL,hlink_transid varchar(50) NULL,hlink_params varchar(2000) NULL,requestpayload text);
>>

<<
CREATE OR REPLACE VIEW vw_pegv2_activetasks
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
    NULL::text AS hlink_params
   FROM axactivetasks a
     JOIN axprocessdefv2 b ON a.processname::text = b.processname::text AND a.taskname::text = b.taskname::text
     JOIN axpdef_peg_processmaster p ON a.processname::text = p.caption::text
     LEFT JOIN axactivetasks aa ON a.processname::text = aa.processname::text AND a.keyvalue::text = aa.keyvalue::text AND a.transid::text = aa.transid::text AND aa.tasktype::text = 'Make'::text AND aa.recordid IS NOT NULL
  WHERE NOT (EXISTS ( SELECT b_1.taskid
           FROM axactivetaskstatus b_1
          WHERE a.taskid::text = b_1.taskid::text)) AND a.removeflg::text = 'F'::text
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
    axactivemessages.hlink_params
   FROM axactivemessages
     LEFT JOIN axpdef_peg_processmaster p ON axactivemessages.processname::text = p.caption::text
  WHERE NOT (EXISTS ( SELECT b.taskid
           FROM axactivetaskstatus b
          WHERE axactivemessages.taskid::text = b.taskid::text));
>>

<<
CREATE OR REPLACE FUNCTION pr_pegv2_transcurstatus(ptransid character varying, pkeyvalue character varying, pprocess character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare 
v_qry text;
v_output numeric;
begin
	

v_qry := concat('select cast(status as varchar(2)) status from axpeg_',ptransid,' 
where keyvalue =''',pkeyvalue,'''and processname=''',pprocess,'''');


execute v_qry into  v_output;


return case v_output when 1 then 'Approved' when 2 then 'Rejected' when 3 then 'Withdrawn' else 'In Progress' end;

END; $function$
;
>>

<<
CREATE OR REPLACE VIEW vw_pegv2_alltasks
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
    NULL::text AS taskstatus,
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
    NULL::text AS taskstatus,
    NULL::text AS statusreason,
    NULL::text AS statustext,
    NULL::text AS cancelremarks,
    NULL::text AS cancelledby,
    NULL::text AS cancelledon,
    NULL::text AS cancel,
    NULL::text AS username,
    'Active'::text AS cstatus
   FROM axactivemessages
     LEFT JOIN axpdef_peg_processmaster p ON axactivemessages.processname::text = p.caption::text
  WHERE NOT (EXISTS ( SELECT b.taskid
           FROM axactivetaskstatus b
          WHERE axactivemessages.taskid::text = b.taskid::text))
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
     JOIN axactivetaskstatus b ON a.taskid::text = b.taskid::text;
>>

<<
CREATE OR REPLACE VIEW vw_pegv2_completed_tasks
AS SELECT a.processname,
    a.taskname,
    a.tasktype,
    to_char(to_timestamp(b.eventdatetime::text, 'YYYYMMDDHH24MISSSSS'::text), 'dd/mm/yyyy hh24:mi:ss'::text) AS eventdatetime,
    a.eventdatetime AS edatetime,
    a.fromuser,
    a.displayicon,
    a.displaytitle,
    a.taskid,
    a.keyfield,
    a.keyvalue,
    a.recordid,
    a.transid,
    a.displaycontent,
    a.indexno,
    b.taskstatus,
    b.statusreason,
    b.statustext,
    b.cancelremarks,
    b.cancelledby,
    b.cancelledon,
    b.cancel,
    b.username
   FROM axactivetasks a
     JOIN axactivetaskstatus b ON a.taskid::text = b.taskid::text AND
        CASE
            WHEN a.indexno = 1::numeric THEN a.fromuser
            ELSE a.touser
        END::text = b.username::text;
>>

<<
CREATE OR REPLACE VIEW vw_pegv2_processdef_tree
AS SELECT axprocessdefv2.processname,
    axprocessdefv2.taskname,
    axprocessdefv2.tasktype,
    axprocessdefv2.taskgroupname AS taskgroup,
    axprocessdefv2.active AS taskactive,
    axprocessdefv2.indexno,
    axprocessdefv2.subindexno AS subindex,
    axprocessdefv2.groupwithprior AS details,
    axprocessdefv2.transid,
    axprocessdefv2.axprocessdefv2id AS recordid,
    axprocessdefv2.displayicon,
    axprocessdefv2.groupwithprior,
    axprocessdefv2.keyfield
   FROM axprocessdefv2;
>>

<<
CREATE OR REPLACE FUNCTION fn_pegv2_editabletask(p_processname character varying, p_taskname character varying, p_keyvalue character varying, p_currentuser character varying, p_indexno numeric)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
v_flag varchar(1);
v_finalapproved varchar(1);
v_finalappqry text;
v_currentuser varchar(50);
v_editable varchar(1);
v_nextleveluser numeric;
v_activeuser numeric;

begin
 

select concat('select case when status=0 then ''F'' else ''T'' end from axpeg_',transid,' where keyvalue=''',p_keyvalue,'''') into v_finalappqry 
from axprocessdefv2 where processname=p_processname
and indexno =(select max(indexno) from axprocessdefv2 a where processname=p_processname and stransid!='pgv2c'); 

execute v_finalappqry into v_finalapproved;

--- Current task createdby user and the next task touser is same
select sum(case when taskname =p_taskname and touser=p_currentuser then 1 else 0 end) activeuser,
sum(case when indexno =p_indexno+1 and touser = p_currentuser then 1 else 0 end) nexttaskuser
into v_activeuser,v_nextleveluser from vw_pegv2_activetasks vpa 
where processname =p_processname and keyvalue =p_keyvalue;



-----Task is created by current user
select case when username = p_currentuser then 'T' else 'F' end into  v_currentuser
from axactivetaskstatus where processname=p_processname and taskname=p_taskname and keyvalue=p_keyvalue;

------Editable task validation in process definition
with a as (
select cast(regexp_split_to_table(allowedittasksid,',') as numeric)  defid,axprocessdefv2id from axprocessdefv2 a1 where processname=p_processname and allowedit='T') 
select case when count(*) = 0 then 'F' else 'T' end flg  into v_flag from axprocessdefv2 b join a on a.axprocessdefv2id = b.axprocessdefv2id
join axprocessdefv2 c on a.defid = c.axprocessdefv2id and c.taskname=p_taskname
join axactivetasks t on b.processname = p_processname and keyvalue = p_keyvalue and b.taskname = t.taskname and t.touser = p_currentuser;


select case when v_finalapproved='T' then 'F' else 
case when v_activeuser > 0 then 'T'
when v_currentuser='T' and v_nextleveluser > 0 then 'T'  
when v_currentuser='F' and v_activeuser = 0  then v_flag else v_flag end end into v_editable;


return v_editable;
end;

$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_pegv2_tasklists(pprocessname character varying, pindexno numeric, ptaskname character varying DEFAULT NULL::character varying, ptransid character varying DEFAULT NULL::character varying, precordid numeric DEFAULT 0, pusername character varying DEFAULT NULL::character varying, ptaskid numeric DEFAULT 0, pkeyvalue character varying DEFAULT NULL::character varying)
 RETURNS TABLE(taskname character varying)
 LANGUAGE plpgsql
AS $function$
declare 
v_sql text;

begin
	
	v_sql := 'SELECT TASKNAME FROM AXPROCESSDEFV2 a WHERE PROCESSNAME  = '''||pprocessname||''' AND INDEXNO >'|| pindexno ||'order by indexno';
		
	
    RETURN QUERY    execute v_sql;
END; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_pegv2_updapp_datagroups()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare
v_newusers varchar(4000);
v_delusers varchar(4000);
v_retainedusers varchar(4000);
begin

with a as(select regexp_split_to_table(new.olddatagrpusers,',') usr),b as (select regexp_split_to_table(new.datagrpusers,',') usr)
select string_agg(a.usr,',') into v_delusers from a left join b on a.usr = b.usr
where b.usr is null;

with a as(select regexp_split_to_table(new.olddatagrpusers,',') usr),b as (select regexp_split_to_table(new.datagrpusers,',') usr)
select string_agg(b.usr,',') into v_newusers from a right join b on a.usr = b.usr
where a.usr is null;


with a as(select regexp_split_to_table(new.olddatagrpusers,',') usr),b as (select regexp_split_to_table(new.datagrpusers,',') usr)
select string_agg(b.usr,',') into v_retainedusers from a join b on a.usr = b.usr;


update axactivetasks a set removeflg='T' where assigntoflg='2' and delegation='F' and pownerflg='F' and removeflg='F' and grouped='T'
and assigntoactor= new.dg_actorname 
and actor_data_grp  = new.dgname
and touser in(select regexp_split_to_table(v_delusers,','))
and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid);


insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
	keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
	displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
	useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
	assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
	allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,changedusr,actor_data_grp) 	
	select distinct eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,
	execonapprove,keyvalue,transdata,fromrole,fromuser,regexp_split_to_table(v_newusers,','),priorindex,priortaskname,corpdimension,
	orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,
	displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,	useridentificationfilter,
	useridentificationfilter_of,mapfield_group,mapfield,'T',indexno,subindexno,
	processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
	approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,
	allowsend,allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,'T',new.dgname
	from axactivetasks a 	
	where assigntoflg='2' and delegation='F' and pownerflg ='F' and removeflg ='F' and grouped='T'
	and assigntoactor = new.dg_actorname
	and actor_data_grp  = new.dgname 
	and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid); 

	
return new;
end; 
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_pegv2_updapp_default()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare
v_newusers varchar(4000);
v_delusers varchar(4000);
v_retainedusers varchar(4000);
begin

with a as(select regexp_split_to_table(new.olddefusername,',') usr),b as (select regexp_split_to_table(new.defusername,',') usr)
select string_agg(a.usr,',') into v_delusers from a left join b on a.usr = b.usr
where b.usr is null;

with a as(select regexp_split_to_table(new.olddefusername,',') usr),b as (select regexp_split_to_table(new.defusername,',') usr)
select string_agg(b.usr,',') into v_newusers from a right join b on a.usr = b.usr
where a.usr is null;


with a as(select regexp_split_to_table(new.olddefusername,',') usr),b as (select regexp_split_to_table(new.defusername,',') usr)
select string_agg(b.usr,',') into v_retainedusers from a join b on a.usr = b.usr;


update axactivetasks a set removeflg='T' where assigntoflg='2' and delegation='F' and pownerflg='F' and removeflg='F' and actor_default_users='T' and grouped='T'
and assigntoactor= new.actorname and touser in(select regexp_split_to_table(v_delusers,','))
and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid);


insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
	keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
	displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
	useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
	assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
	allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,changedusr,actor_default_users) 	
	select distinct eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,
	execonapprove,keyvalue,transdata,fromrole,fromuser,regexp_split_to_table(v_newusers,','),priorindex,priortaskname,corpdimension,
	orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,
	displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,	useridentificationfilter,
	useridentificationfilter_of,mapfield_group,mapfield,'T',indexno,subindexno,
	processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
	approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,
	allowsend,allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,'T','T'
	from axactivetasks a 	
	 where assigntoflg='2' and delegation='F' and pownerflg ='F' and removeflg ='F' and grouped='T' and actor_default_users='T'
	 and assigntoactor = new.actorname	 
	 and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid); 

	
return new;
end; 
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_pegv2_updapp_reporting(p_fromuser character varying, p_existingapp character varying, p_newapp character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin 

insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
	keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
	displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
	useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
	assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
	allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,changedusr) 	
	select eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,
	execonapprove,keyvalue,transdata,fromrole,fromuser,p_newapp,priorindex,priortaskname,corpdimension,
	orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,
	displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,	useridentificationfilter,
	useridentificationfilter_of,mapfield_group,mapfield,'T',indexno,subindexno,
	processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
	approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,
	allowsend,allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,'T'
	from axactivetasks a 	
	 where assigntoflg='1' and delegation='F' and pownerflg ='F' and grouped='T'
	 and fromuser= p_fromuser and touser= p_existingapp and removeflg ='F'
	and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid); 
	
	
	
	
update axactivetasks a set removeflg ='T' where assigntoflg='1' and delegation='F' and pownerflg ='F' 
and fromuser= p_fromuser and touser= p_existingapp and not exists 
(SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid);




end; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_pegv2_updapp_usegroups()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare
v_newusers varchar(4000);
v_delusers varchar(4000);
v_retainedusers varchar(4000);
begin

with a as(select regexp_split_to_table(new.oldugrpusername,',') usr),b as (select regexp_split_to_table(new.ugrpusername,',') usr)
select string_agg(a.usr,',') into v_delusers from a left join b on a.usr = b.usr
where b.usr is null;

with a as(select regexp_split_to_table(new.oldugrpusername,',') usr),b as (select regexp_split_to_table(new.ugrpusername,',') usr)
select string_agg(b.usr,',') into v_newusers from a right join b on a.usr = b.usr
where a.usr is null;


with a as(select regexp_split_to_table(new.oldugrpusername,',') usr),b as (select regexp_split_to_table(new.ugrpusername,',') usr)
select string_agg(b.usr,',') into v_retainedusers from a join b on a.usr = b.usr;


update axactivetasks a set removeflg='T' where assigntoflg='2' and delegation='F' and pownerflg='F' and removeflg='F' and grouped='T'
and assigntoactor= new.ug_actorname 
and actor_user_groups  = new.usergroupname
and touser in(select regexp_split_to_table(v_delusers,','))
and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid);


insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
	keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
	displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
	useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
	assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
	allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,changedusr,actor_user_groups) 	
	select distinct eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,
	execonapprove,keyvalue,transdata,fromrole,fromuser,regexp_split_to_table(v_newusers,','),priorindex,priortaskname,corpdimension,
	orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,
	displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,	useridentificationfilter,
	useridentificationfilter_of,mapfield_group,mapfield,'T',indexno,subindexno,
	processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
	approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,
	allowsend,allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,'T',new.usergroupname
	from axactivetasks a 	
	 where assigntoflg='2' and delegation='F' and pownerflg ='F' and removeflg ='F' and grouped='T'
	 and assigntoactor = new.ug_actorname
	 and actor_user_groups  = new.usergroupname 
	 and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid); 

	
return new;
end; 
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION pr_pegv2_processlist(pprocessname character varying)
 RETURNS TABLE(taskname character varying, tasktype character varying, tasktime character varying, taskfromuser character varying, taskstatus character varying, displayicon character varying, displaytitle text, taskid character varying, keyfield character varying, keyvalue character varying, recordid numeric, transid character varying)
 LANGUAGE plpgsql
AS $function$
declare 
v_createtblscr varchar(4000);
v_processtable varchar(100);

begin
	
	select processtable into v_processtable from axpdef_peg_processmaster where lower(caption) = lower(pprocessname);
	
	v_createtblscr :='select taskname,tasktype,cast(to_char(to_timestamp(eventdatetime, ''YYYYMMDDHH24MISSSSS''),''dd/mm/yyyy hh24:mi:ss'')as varchar) eventdatetime,username,taskstatus,displayicon,displaytitle,taskid,keyfield,keyvalue,recordid,transid from '|| v_processtable;
	
    RETURN QUERY    execute v_createtblscr;
END; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION pr_pegv2_processprogress(pprocessname character varying, pkeyvalue character varying)
 RETURNS TABLE(processname character varying, taskname character varying, indexno numeric, eventdatetime character varying, taskstatus character varying, taskid character varying, transid character varying, keyfield character varying, keyvalue character varying, recordid numeric, rnum numeric)
 LANGUAGE plpgsql
AS $function$
declare 
v_createtblscr varchar(4000);
v_processtable varchar(100);
v_keyvalue varchar(2000);

begin
    
    select processtable into v_processtable from axpdef_peg_processmaster where lower(caption) = lower(pprocessname);
   
   
   v_createtblscr :=concat('with c as (select distinct a.processname,a.taskname,a.indexno,
    a.eventdatetime,
    coalesce(b.taskstatus, ''active'')taskstatus,a.taskid,
    a.transid,a.keyfield,a.keyvalue,a.recordid from ', v_processtable ,' a 
    join(select processname,taskname,indexno,transid,keyvalue,taskstatus,
    eventdatetime from axactivetaskstatus
    where lower(processname) ='''||lower(pprocessname)||    ''' and lower(keyvalue) = ''',lower(pkeyvalue),''' )b 
    on a.taskname = b.taskname and a.indexno = b.indexno 
    and a.eventdatetime =  b.eventdatetime    
     where lower(a.processname) ='''||lower(pprocessname)||
    ''' and lower(a.keyvalue) = ''',lower(pkeyvalue),''' ) select 
    coalesce(c.processname,d.processname) processname,coalesce(c.taskname,d.taskname) taskname,
    coalesce(c.indexno,d.indexno)indexno,
cast(to_char(to_timestamp(left(coalesce(c.eventdatetime,d.eventdatetime),14) , ''YYYYMMDDHH24MISSSSS''),''dd/mm/yyyy hh24:mi:ss'') as varchar)eventdatetime,
    coalesce(c.taskstatus,''Active'') taskstatus,coalesce(c.taskid,d.taskid) taskid,coalesce(c.transid,d.transid)transid,
    coalesce(c.keyfield,d.keyfield) keyfield,coalesce(c.keyvalue,d.keyvalue)keyvalue,coalesce(c.recordid,d.recordid) recordid,
    cast(row_number() over(partition by coalesce(c.indexno,d.indexno) order by coalesce(c.indexno,d.indexno),coalesce(c.eventdatetime,d.eventdatetime) desc) as numeric)rnum
    from c   right join (select j.indexno,j.transid,j.keyfield,j.keyvalue,j.eventdatetime,
j.processname,j.taskname,j.taskid,j.recordid    from axactivetasks j 
    where lower(processname) = ''',lower(pprocessname),''' and lower(keyvalue) = ''',lower(pkeyvalue) ,''' and removeflg=''F'') d on
    c.indexno = d.indexno and c.transid = d.transid and c.keyfield = d.keyfield and c.keyvalue = d.keyvalue and c.taskid = d.taskid
    group by   coalesce(c.processname,d.processname) ,coalesce(c.taskname,d.taskname) ,coalesce(c.indexno,d.indexno),coalesce(c.eventdatetime,d.eventdatetime),
    coalesce(c.taskstatus,''Active'') ,coalesce(c.taskid,d.taskid) ,coalesce(c.transid,d.transid),
    coalesce(c.keyfield,d.keyfield) ,coalesce(c.keyvalue,d.keyvalue),coalesce(c.recordid,d.recordid)
    order by coalesce(c.indexno,d.indexno)'); 
  
   
RETURN QUERY   execute v_createtblscr;


END; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION pr_pegv2_sendto_userslist(pallowsendflg numeric, pactor character varying, pprocessname character varying, pkeyvalue character varying, ptaskname character varying)
 RETURNS TABLE(pusername character varying)
 LANGUAGE plpgsql
AS $function$
declare
v_usergroup_in varchar;
v_usergroup_notin varchar;
v_usergroup_in_cnt numeric;
v_usergroup_notin_cnt numeric;
begin
	
/*
 * 2 - Any user
 * 3 - Users in this process
 * 4 - Actor
 */

select senduser_in,senduser_notin,
coalesce(length(senduser_in),0),coalesce(length(senduser_notin),0) 
into v_usergroup_in,v_usergroup_notin,v_usergroup_in_cnt,v_usergroup_notin_cnt
from axprocessdefv2 where processname = pprocessname and taskname = ptaskname;	
	
RETURN QUERY 

----------  Any user & Both In & Not in usergroup is empty
select username from axusers 
where pallowsendflg = 2 and v_usergroup_in_cnt=0 and v_usergroup_notin_cnt=0
union all
---------- Any user & not in is empty
select a.username from axusers a,axpdef_peg_usergroups b 
where pallowsendflg = 2 and v_usergroup_in_cnt>0 and v_usergroup_notin_cnt=0
and a.username = b.username
and b.usergroupname in(select unnest(string_to_array(v_usergroup_in,','))) 
union all ---------- Any user & in is empty
select a.username from axusers a,axpdef_peg_usergroups b
where pallowsendflg = 2 and v_usergroup_in_cnt=0 and v_usergroup_notin_cnt>0
and a.username= b.username
and b.usergroupname not in(select unnest(string_to_array(v_usergroup_in,',')))
union all ---------- Any user & both in & not in is selected
select a.username from axusers a,axpdef_peg_usergroups b
where pallowsendflg = 2 and v_usergroup_in_cnt=0 and v_usergroup_notin_cnt>0
and a.username= b.username
and b.usergroupname not in(select unnest(string_to_array(v_usergroup_notin,',')))
and b.usergroupname in(select unnest(string_to_array(v_usergroup_in,',')))
union all
select touser from axactivetasks where grouped='T' 
and 3 = pallowsendflg  and processname = pprocessname and keyvalue = pkeyvalue and removeflg='F'
group by touser;

   
END; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION pr_pegv2_transactionstatus(ptransid character varying, pkeyvalue character varying)
 RETURNS TABLE(processname character varying, taskname character varying, status character varying, statustext character varying, recordid numeric, keyvalue character varying, username character varying, eventdatetime character varying, indexno numeric, cnd numeric)
 LANGUAGE plpgsql
AS $function$
declare 
v_qry text;
v_processes varchar(8000);
v_logrec record;
v_logqry text[] DEFAULT  ARRAY[]::varchar[];
v_logqrytxt text;

begin
	
execute 'select distinct string_agg(b.processtable,'','') from axpeg_'||ptransid||' a join  axpdef_peg_processmaster b on a.processname = b.caption 
where a.keyvalue ='''||pkeyvalue||'''' into v_processes;  	

for v_logrec in select regexp_split_to_table(v_processes,',') tblname,
'select processname,taskname,taskstatus,tasktype,recordid,keyvalue,username,eventdatetime,cast(indexno as numeric) ,cast(1 as numeric) cnd from '||regexp_split_to_table(v_processes,',')
||' where keyvalue='''||pkeyvalue||'''' logqry from dual
loop
v_logqry := array_append(v_logqry,v_logrec.logqry);
end loop;
v_logqrytxt := array_to_string(v_logqry,' union all ');

if array_length(v_logqry,1) > 0 then

v_qry := concat('select processname,null taskname,cast(status as varchar(2)) status,statustext,recordid,keyvalue,cast(''NA'' as varchar(2)) username,
cast(eventdatetime as varchar(100)),0 indexno,cast(0 as numeric) cnd from axpeg_'||ptransid||' 
where status in (1,2) and keyvalue ='''||pkeyvalue||'''
union all
select a.processname,taskname,cast(b.status as varchar(20)) status,concat(a.taskname,'' is pending '',string_agg(a.touser,'','')) statustext,
b.recordid,b.keyvalue,cast(''NA'' as varchar(2)) username,null eventdatetime,0 indexno,cast(0 as numeric) cnd
from vw_pegv2_activetasks a join axpeg_'||ptransid||' b on a.processname=b.processname 
and a.keyvalue=b.keyvalue
where b.status=0
and a.keyvalue ='''||pkeyvalue||'''
group by a.processname,a.transid,a.keyvalue,a.taskname,b.recordid,b.keyvalue,b.status',chr(10),' union all ',chr(10),v_logqrytxt);

else 

v_qry := 'select processname,null taskname,cast(status as varchar(2)) status,statustext,recordid,keyvalue,cast(''NA'' as varchar(2)) username,
cast(eventdatetime as varchar(100)),cast(0 as numeric) indexno,cast(0 as numeric) cnd from axpeg_'||ptransid||' 
where status in (1,2) and keyvalue ='''||pkeyvalue||'''
union all
select a.processname,taskname,cast(b.status as varchar(20)) status,concat(a.taskname,'' is pending '',string_agg(a.touser,'','')) statustext,
b.recordid,b.keyvalue,cast(''NA'' as varchar(2)) username,null eventdatetime,cast(indexno as numeric),cast(0 as numeric) cnd
from vw_pegv2_activetasks a join axpeg_'||ptransid||' b on a.processname=b.processname 
and a.keyvalue=b.keyvalue
where b.status=0
and a.keyvalue ='''||pkeyvalue||'''
group by a.processname,a.transid,a.keyvalue,a.taskname,b.recordid,b.keyvalue,b.status,a.indexno';


end if;


RETURN QUERY   execute v_qry;


END; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_axprocessdefv2_index_update(pprocessname character varying, pindexno numeric, dbevent character varying, recordid numeric, poldindexno numeric)
 RETURNS void
 LANGUAGE plpgsql
AS $function$ 
declare
v_axprocessdefv2id numeric;
begin
	
if dbevent = 'Insert' then 
	select axprocessdefv2id into v_axprocessdefv2id from axprocessdefv2 where processname = pprocessname and indexno = pindexno and axprocessdefv2id!=recordid;
	if v_axprocessdefv2id is not null then
			update axprocessdefv2 set indexno = indexno+1 where axprocessdefv2id = v_axprocessdefv2id;	
			update axprocessdefv2 set indexno = indexno+1 where processname=pprocessname and indexno>pindexno and  axprocessdefv2id != v_axprocessdefv2id and axprocessdefv2id != recordid;
	end if;
end if;


if dbevent = 'Update' then
	update axprocessdefv2 set indexno = indexno+1 where processname=pprocessname and indexno>=pindexno and indexno < poldindexno and  axprocessdefv2id != recordid;
end if;

if dbevent = 'Delete' then
	update axprocessdefv2 set indexno = indexno-1 where processname=pprocessname and indexno>pindexno and  axprocessdefv2id != recordid;
end if;

exception when others then 
 null ;

end;

$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_peg_utl_actorusers(assigntoactor character varying, actorfilter character varying, pinitiator character varying)
 RETURNS TABLE(pusername character varying)
 LANGUAGE plpgsql
AS $function$
declare
v_assignmodecnd int;
v_defusers varchar;
v_datagrpusers varchar;
usercount int;
v_users varchar;
v_initiator_usergrps varchar;
v_usergrpuser varchar;

begin

select coalesce(assignmodecnd,0) assignmodecnd,defusername,
case when array_length(string_to_array(defusername,','),1) is null then 0 
else  array_length(string_to_array(defusername,','),1) end usercount
into v_assignmodecnd,v_defusers ,usercount
from axpdef_peg_actor a
where a.actorname=assigntoactor; 

	if v_assignmodecnd = 1 then --------Default user
	
		if usercount > 0 then
		v_users := v_defusers;
		end if;
	
	elseif v_assignmodecnd = 2 then -----------User group
		select distinct string_agg(usergroupname,',') into  v_initiator_usergrps 
		from axpdef_peg_usergroups 
		where username = pinitiator and active='T' and effectivefrom <= current_date;
		
		----------- Check approval users are assigned for the initiator's group
		select string_agg(concat(usergroupname,'~~',unames),'|~') ,count(*) into v_usergrpuser,usercount
		from (select distinct b.usergroupname, b.ugrpusername unames
		from axpdef_peg_actor a
		join axpdef_peg_actorusergrp b on a.axpdef_peg_actorid=b.axpdef_peg_actorid
		where a.actorname = assigntoactor 
		and b.usergroupname in (select regexp_split_to_table(v_initiator_usergrps,','))
		order by 1 )a;
		
			--------- if approval users are assinged in process users
		if usercount > 0 then 
		select	split_part(v_usergrpuser,'~~',2) into v_users;
		end if;	
			
	elseif v_assignmodecnd = 3 then 	---- Data groups
		select fn_peg_assigntoactor(assigntoactor,actorfilter) into v_datagrpusers ;		
			if v_datagrpusers != '0' then
				select split_part(v_datagrpusers,'~~',2) dgrpusers into v_users;
			end if;
	end if;		

return query 

select cast(regexp_split_to_table(v_users,',') as varchar);

end;
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION trg_axprocessdefv2()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    declare 
   	v_rem_esc_sfrom varchar;
   	v_rem_esc_taskparam varchar;
   	
    begin
	    
	   select string_agg(sfrom,',') into v_rem_esc_sfrom  from (
    select distinct regexp_split_to_table(new.rem_esc_startfrom,',') sfrom)a;
   
   select string_agg(fname, ',') from (select	substring(unnest(string_to_array( v_rem_esc_sfrom , ',')), position('-(' in unnest(string_to_array( v_rem_esc_sfrom , ',')))+ 2, abs((position('-(' in unnest(string_to_array( v_rem_esc_sfrom , ',')))+ 2) - length(substring(unnest(string_to_array( v_rem_esc_sfrom , ',')), 1, length(unnest(string_to_array( v_rem_esc_sfrom , ',')))))))fname where v_rem_esc_sfrom is not null) a
    into v_rem_esc_taskparam;

        IF (TG_OP = 'INSERT') THEN
		
		new.taskparamsui = concat(new.taskparamsui,',',v_rem_esc_sfrom);
		new.taskparams=concat(new.taskparams,',',v_rem_esc_taskparam);
		
		return new;
	end if;
		
		IF (TG_OP = 'UPDATE') THEN
		
		new.taskparamsui = concat(new.taskparamsui,',',v_rem_esc_sfrom);
		new.taskparams=concat(new.taskparams,',',v_rem_esc_taskparam);
		
		return new;
	end if;
end; 
$function$
;
>>

<<
create trigger trg_axpdef_peg_actor after
update
    on
    axpdef_peg_actor for each row
    when (((new.olddefusername) <> (new.defusername))) execute procedure fn_pegv2_updapp_default();
>>

<<
create trigger trg_axpdef_peg_actorusergrp after
update
    on
    axpdef_peg_actorusergrp for each row
    when (((new.oldugrpusername) <> (new.ugrpusername))) execute procedure fn_pegv2_updapp_usegroups();
>>

<<
create trigger trg_axpdef_peg_grpfilter after
update
    on
    axpdef_peg_grpfilter for each row
    when (((new.olddatagrpusers) <> (new.datagrpusers))) execute procedure fn_pegv2_updapp_datagroups();
>>

<<
create trigger trg_axprocessdefv2 before
insert
    or
update
    on
    axprocessdefv2 for each row execute procedure trg_axprocessdefv2();
>>

<<
CREATE TABLE axactivetaskparams (eventdatetime varchar(30) NULL,taskid varchar(30) NULL,transid varchar(8) NULL,keyfield varchar(30) NULL,keyvalue varchar(500) NULL,taskstatus varchar(15) NULL,username varchar(30) NULL,
tasktype varchar(500) NULL,taskname varchar(500) NULL,processname varchar(500) NULL,priorindex numeric(10) NULL,indexno numeric(10) NULL,	subindexno numeric(10) NULL,recordid numeric(20) NULL,taskparams varchar(4000) NULL);
>>

<<
CREATE OR REPLACE FUNCTION trg_axpeg_sendmsg()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
   	
    begin

insert into axactivemessages(eventdatetime,msgtype,fromuser,touser,displaytitle,displaycontent,effectivefrom,effectiveto,hlink_transid,hlink_params)
	select
	to_char(current_timestamp,'YYYYMMDDHH24MISSSS'),new.msgtype,new.fromuser,new.touser,new.msgtitle,new.message,current_date,
	new.effectiveto,new.hlink_transid,new.hlink_params;
	 
		return new;

end; 
$function$;
>>

<<
create trigger trg_axpeg_sendmsg after
insert
    on
    axpeg_sendmsg for each row execute procedure trg_axpeg_sendmsg();
>>

<<
CREATE OR REPLACE FUNCTION fn_generate_cardjson(pchartprops text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
    cardprops1 text;
BEGIN

 

select concat('{"attributes":{',
'"cck":"',split_part( pchartprops,'|',1),'",',
'"shwLgnd":',lower(split_part(pchartprops,'|',2)),','
'"xAxisL":"',split_part(pchartprops,'|',3),'",'
'"yAxisL":"',split_part(pchartprops,'|',4),'",'
'"gradClrChart":',lower(split_part(pchartprops,'|',5)),','
'"shwChartVal":',lower(split_part(pchartprops,'|',6)),','
'"threeD":"',case when split_part(pchartprops,'|',7)='True' then 'create' else 'remove' end,'",'
'"enableSlick":',lower(split_part(pchartprops,'|',8)),
',"numbSym":',lower(split_part(pchartprops,'|',9)),
'','}}')  into cardprops1 from dual ac;

 

RETURN cardprops1;

END;
$function$;
>>

<<
CREATE TABLE fast_print_paper_size (
	psize varchar(250) NULL,
	pheight numeric(15, 2) NULL,
	pwidth numeric(15, 2) NULL
);
>>

<<
CREATE OR REPLACE FUNCTION get_sql_columns(sql_query text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    column_names text;
    formatted_query text;
    param_names text[];
    i integer;
BEGIN
    -- Extract parameter names from the query
    select array_agg(cols) INTO param_names from (SELECT unnest(regexp_matches(sql_query, ':\w+', 'g'))cols)a;

    -- Replace parameter placeholders with NULL values if there are any parameters
    IF array_length(param_names, 1) > 0 THEN
        formatted_query := sql_query;
        FOR i IN 1..array_length(param_names, 1) LOOP
            formatted_query := replace(formatted_query, param_names[i], 'NULL');
        END LOOP;
    ELSE
        formatted_query := sql_query;
    END IF;	
	

   EXECUTE format('CREATE TEMPORARY TABLE Ax_GetColumn_temp_table AS (%s) LIMIT 0', formatted_query);
   
    column_names := array_to_string(
        ARRAY(
            SELECT attname
            FROM pg_attribute
            WHERE attrelid = 'Ax_GetColumn_temp_table'::regclass
                AND attnum > 0
                AND NOT attisdropped
            ORDER BY attnum
        ),
        ','
    );

    -- Drop the temporary table
    EXECUTE 'DROP TABLE IF EXISTS Ax_GetColumn_temp_table';

    RETURN column_names;
 
END; 
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_stringcomparision(pstring1 text, pstring2 text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
   v_results text;
   v_added text;
   v_removed text;
begin

	case when length(pstring1) = 0  and length(pstring2) != 0 then
			
			v_results := '<span style="font-weight:bold;">'||'Added : '||'</span><br/>'||pstring2||'<br/>';		
				
		 when length(pstring1) != 0  and length(pstring2) = 0 then
		 				 
	    	v_results := '<span style="font-weight:bold;">'||'Removed : '||'</span><br/>'||pstring1||'<br/>';
		 					 
		 when length(pstring1) != 0  and length(pstring2) != 0 then 
		 			
		 	select replace(replace(REPLACE(array_agg(strings)::text,'{',''),'}',''),'"','') into v_removed   		 	
		 	from (
			select '{'||a.strings||'}' as strings from  
		 	(select unnest (string_to_array( pstring1 ,',')) as strings from dual) a
		 	where a.strings not in 
		 	(select unnest (string_to_array( pstring2,',')) as strings from dual b) 
		 	) a ;
		 
		 	select replace(replace(REPLACE(array_agg(strings)::text,'{',''),'}',''),'"','') into v_added    		 	
		 	from (
			select '{'||a.strings||'}' as strings from  
		 	(select unnest (string_to_array( pstring2 ,',')) as strings from dual) a
		 	where a.strings not in 
		 	(select unnest (string_to_array( pstring1,',')) as strings from dual b) 
		 	) a ;
		 		 
			v_results := '<span style="font-weight:bold;">'||'Removed : '||'</span><br/>'||v_removed||'<br/>'||
						 '<span style="font-weight:bold;">'||'Added : '||'</span><br/>'||v_added||'<br/>';
		 		 			 	
	else
			v_results := 'no result';
	end case;		 
		 
   RETURN v_results;
END;
$function$
;
>>

<<
CREATE TABLE axinqueuesdata (createdon timestamp NULL DEFAULT CURRENT_TIMESTAMP,axqueuename varchar(100) NULL,transid varchar(10) NULL,recordid numeric NULL,queuedata text NULL);
>>

<<
CREATE TABLE axoutqueuesdata (createdon timestamp NULL DEFAULT CURRENT_TIMESTAMP,axqueuename varchar(100) NULL,transid varchar(10) NULL,recordid numeric NULL,queuedata text NULL);
>>

<<
CREATE OR REPLACE FUNCTION pr_utl_forms_menutree(ppagetype varchar)
 RETURNS varchar
 LANGUAGE plpgsql
AS $function$
declare v_mtree varchar(1000);
begin

WITH RECURSIVE cte AS (
   SELECT name, caption, 1 AS level,pagetype,caption a,name b,visible
   FROM   axpages 
   UNION  ALL
   SELECT t.name, t.caption, c.level + 1,t.pagetype,c.a,c.b,t.visible
   FROM   cte    c
   JOIN   axpages t ON t.parent = c.name    
   )
   select a.mtree into v_mtree from
(SELECT string_agg(a,'/') over(order by level desc) mtree,row_number() over(order by level) rnum
FROM   cte where substring(pagetype,1,1)='t'  and visible ='T'
and pagetype =ppagetype)a where rnum=1;
return 'Menu - '|| v_mtree||'</br>';
END; $function$;
>>

<<
INSERT INTO axpdef_axcalendar_event (axpdef_axcalendar_eventid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, eventname, eventcolor) VALUES(1116010000000, 'F', 0, NULL, 'admin', '2022-12-14 20:01:28.000', 'admin', '2022-12-14 19:45:44.000', NULL, 1, 1, NULL, NULL, NULL, 'Meeting', 'cerise');
>>

<<
INSERT INTO axpdef_axcalendar_event (axpdef_axcalendar_eventid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, eventname, eventcolor) VALUES(1117110000000, 'F', 0, NULL, 'admin', '2022-12-15 17:20:08.000', 'admin', '2022-12-15 17:20:08.000', NULL, 1, 1, NULL, NULL, NULL, 'Personal', 'blue');
>>

<<
INSERT INTO axpdef_axcalendar_event (axpdef_axcalendar_eventid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, eventname, eventcolor) VALUES(1117110000002, 'F', 0, NULL, 'admin', '2022-12-15 17:20:25.000', 'admin', '2022-12-15 17:20:25.000', NULL, 1, 1, NULL, NULL, NULL, 'Leave', 'Red');
>>

<<
INSERT INTO axpdef_axcalendar_event (axpdef_axcalendar_eventid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, eventname, eventcolor) VALUES(1117110000001, 'F', 0, NULL, 'admin', '2022-12-16 12:27:11.000', 'admin', '2022-12-15 17:20:19.000', NULL, 1, 1, NULL, NULL, NULL, 'Online meet', 'Fuchsia Blue');
>>

<<
CREATE TABLE axpdef_axvars_dbvar (
	axpdef_axvars_dbvarid numeric(16) NOT NULL,
	axpdef_axvarsid numeric(16) NULL,
	axpdef_axvars_dbvarrow int4 NULL,
	db_varname varchar(200) NULL,
	db_varval varchar(500) NULL,
	db_vartype varchar(100) NULL,
	db_varcaption varchar(500) NULL,
	CONSTRAINT aglaxpdef_axvars_dbvarid PRIMARY KEY (axpdef_axvars_dbvarid)
);
>>

<<
CREATE TABLE axpdef_axvars (axpdef_axvarsid numeric(16) NOT NULL,cancel varchar(1) NULL,
sourceid numeric(16) NULL,mapname varchar(20) NULL,username varchar(50) NULL,
modifiedon date NULL,createdby varchar(50) NULL,createdon date NULL,
wkid varchar(15) NULL,app_level numeric(3) NULL,app_desc numeric(1) NULL,
app_slevel numeric(3) NULL,cancelremarks varchar(150) NULL,wfroles varchar(250) NULL,
transid varchar(5) NULL,db_function varchar(500) NULL,db_function_params varchar(4000) NULL,
event_onlogin varchar(1) NULL,event_onformload varchar(1) NULL,forms varchar(4000) NULL,
forms_transid varchar(4000) NULL,event_onreportload varchar(1) NULL,reports varchar(4000) NULL,
reports_transid varchar(4000) NULL,isdbobj varchar(1) NULL,remarks text NULL,
CONSTRAINT aglaxpdef_axvarsid PRIMARY KEY (axpdef_axvarsid));
>>

<<
CREATE TABLE axamend (
	transid varchar(5) NULL,
	usersession varchar(50) NULL,
	primaryrecordid numeric(20) NULL,
	amendno varchar(25) NULL,
	amendedby varchar(100) NULL,
	amendedon timestamp NULL,
	fieldlist text NULL,
	parselist text NULL,
	recidlist text NULL
);
>>

<<
CREATE OR REPLACE FUNCTION execute_sql_list(sql_list text, sql_separator character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    query text;
BEGIN
    query := replace(sql_list, sql_separator, E';\n');
    IF query IS NOT NULL AND query <> '' THEN
        EXECUTE query;
    END IF;
END;
$function$
;
>>

<<
CREATE TABLE axrequest (
	requestid varchar(100) NOT NULL,
	requestreceivedtime timestamptz NULL,
	sourcefrom varchar(255) NULL,
	requeststring text NULL,
	headers text NULL,
	params text NULL,
	authz varchar(255) NULL,
	contenttype varchar(150) NULL,
	contentlength varchar(10) NULL,
	host varchar(255) NULL,
	url text NULL,
	endpoint varchar(255) NULL,
	requestmethod varchar(10) NULL,
	apiname varchar(255) NULL,
	username varchar(255) NULL,
	additionaldetails text NULL,
	sourcemachineip varchar(255) NULL,
	CONSTRAINT axrequest_pkey PRIMARY KEY (requestid));
>>

<<
CREATE TABLE axresponse (
	responseid varchar(100) NOT NULL,
	responsesenttime timestamptz NULL,
	statuscode int4 NULL,
	responsestring text NULL,
	headers text NULL,
	contenttype varchar(150) NULL,
	contentlength varchar(10) NULL,
	errordetails text NULL,
	endpoint varchar(255) NULL,
	requestmethod varchar(10) NULL,
	username varchar(255) NULL,
	additionaldetails text NULL,
	requestid varchar(100) NULL,
	executiontime varchar(20) NULL,
	CONSTRAINT axresponse_pkey PRIMARY KEY (responseid),
	CONSTRAINT axresponse_requestid_fkey FOREIGN KEY (requestid) REFERENCES axrequest(requestid));
>>

<<
CREATE TABLE importdatadetails (
	sessionid varchar(30) NULL,
	username varchar(50) NULL,
	calledon timestamp NULL,
	structname varchar(6) NULL,
	recordid numeric(15) NULL,
	recordcount numeric(5) NULL,
	paramdetails varchar(250) NULL,
	filename varchar(200) NULL,
	success numeric(5) NULL,
	id numeric(30) NULL,
	mapfields varchar(250) NULL,
	infile numeric(1) NULL,
	rapidimpid varchar(100) NULL);
>>

<<
CREATE TABLE importdataexceptions (
	sessionid varchar(30) NULL,
	username varchar(50) NULL,
	calledon timestamp NULL,
	recordno numeric(5) NULL,
	errormsg varchar(250) NULL,
	id varchar(30) NULL,
	rapidimpid varchar(100) NULL);
>>

<<
CREATE SEQUENCE ax_entity_relseq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 101
	CACHE 1
	NO cycle;
>>	

<<
CREATE OR REPLACE VIEW vw_entityrelations
AS SELECT DISTINCT nextval('ax_entity_relseq'::regclass) AS axentityrelationsid,
    'F'::text AS cancel,
    'admin'::text AS username,
    CURRENT_TIMESTAMP AS modifiedon,
    'admin'::text AS createdby,
    CURRENT_TIMESTAMP AS createdon,
    1 AS app_level,
    1 AS app_desc,
    a.rtype,
    a.mstruct,
    a.mfield,
    m.tablename AS mtable,
    dc.tablename AS primarytable,
    a.dstruct,
    a.dfield,
    d.tablename AS dtable,
    'Dropdown'::text AS rtypeui,
    concat(mt.caption, '-(', mt.name, ')') AS mstructui,
    concat(m.caption, '-(', m.fname, ')') AS mfieldui,
    concat(dt.caption, '-(', dt.name, ')') AS dstructui,
    concat(d.caption, '-(', d.fname, ')') AS dfieldui,
    ddc.tablename AS dprimarytable
   FROM ( SELECT DISTINCT axrelations.mstruct,
            axrelations.dstruct,
            axrelations.mfield,
            axrelations.dfield,
            axrelations.rtype
           FROM axrelations) a
     JOIN tstructs mt ON a.mstruct::text = mt.name::text
     JOIN tstructs dt ON a.dstruct::text = dt.name::text
     LEFT JOIN axpflds m ON a.mstruct::text = m.tstruct::text AND a.mfield::text = m.fname::text
     LEFT JOIN axpflds d ON a.dstruct::text = d.tstruct::text AND a.dfield::text = d.fname::text
     LEFT JOIN axpdc dc ON a.mstruct::text = dc.tstruct::text AND dc.dname::text = 'dc1'::text
     LEFT JOIN axpdc ddc ON a.dstruct::text = ddc.tstruct::text AND ddc.dname::text = 'dc1'::text
  WHERE a.rtype::text = 'md'::text
UNION ALL
 SELECT nextval('ax_entity_relseq'::regclass) AS axentityrelationsid,
    a.cancel,
    a.username,
    a.modifiedon,
    a.createdby,
    a.createdon,
    a.app_level,
    a.app_desc,
    a.rtype,
    a.mstruct,
    a.mfield,
    a.mtable,
    a.primarytable,
    a.dstruct,
    a.dfield,
    a.dtable,
    a.rtypeui,
    a.mstructui,
    a.mfieldui,
    a.dstructui,
    a.dfieldui,
    a.dprimarytable
   FROM ( SELECT DISTINCT 'F'::text AS cancel,
            'admin'::text AS username,
            CURRENT_TIMESTAMP AS modifiedon,
            'admin'::text AS createdby,
            CURRENT_TIMESTAMP AS createdon,
            1 AS app_level,
            1 AS app_desc,
            'gm'::character varying AS rtype,
            a_1.tstruct AS mstruct,
            concat(sd.tablename, 'id') AS mfield,
            sd.tablename AS mtable,
            pd.tablename AS primarytable,
            a_1.targettstr AS dstruct,
            'sourceid'::character varying AS dfield,
            td.tablename AS dtable,
            'Genmap'::text AS rtypeui,
            concat(mt.caption, '-(', mt.name, ')') AS mstructui,
            NULL::text AS mfieldui,
            concat(dt.caption, '-(', dt.name, ')') AS dstructui,
            NULL::text AS dfieldui,
            td.tablename AS dprimarytable
           FROM axpgenmaps a_1
             JOIN tstructs mt ON a_1.tstruct::text = mt.name::text
             JOIN tstructs dt ON a_1.targettstr::text = dt.name::text
             LEFT JOIN axpdc sd ON a_1.tstruct::text = sd.tstruct::text AND sd.dname::text = a_1.basedondc::text
             LEFT JOIN axpdc td ON a_1.targettstr::text = td.tstruct::text AND td.dname::text = 'dc1'::text
             LEFT JOIN axpdc pd ON a_1.tstruct::text = pd.tstruct::text AND pd.dname::text = 'dc1'::text) a;
>>

<<
CREATE SEQUENCE axpdef_genseq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO cycle;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_ap_charts(pentity_transid character varying, pcriteria character varying, pfilter character varying, pusername character varying DEFAULT 'admin'::character varying, papplydac character varying DEFAULT 'T'::character varying, puserrole character varying DEFAULT 'All'::character varying, pconstraints text DEFAULT NULL::text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
rec record;
rec_filters record;
v_primarydctable varchar;
v_subentitytable varchar;
v_transid varchar;
v_grpfld varchar;
v_aggfld varchar;
v_aggfnc varchar;
v_srckey varchar;
v_srctbl varchar;
v_srcfld varchar;
v_aempty varchar;
v_aggfldtable varchar;
v_sql text;
v_normalizedjoin varchar;
v_keyname varchar;
v_keyname_coalesce varchar;
v_entitycond varchar;
v_keyfld_fname varchar;
v_keyfld_fval varchar;
v_final_sqls text[] DEFAULT  ARRAY[]::text[];
v_fldname_transidcnd numeric;
v_sql1 text;
v_filter_srcfld varchar;
v_filter_srctxt varchar;
v_filter_join varchar;
v_filter_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_cnd varchar;
v_filter_cndary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_joinreq numeric;
v_filter_dcjoinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_col varchar;
v_filter_normalized varchar;
v_filter_sourcetbl varchar;
v_filter_sourcefld varchar;
v_filter_datatype varchar;
v_filter_listedfld varchar;
v_filter_tablename varchar;
v_emptyary varchar[] DEFAULT  ARRAY[]::varchar[];
v_grpfld_tbl varchar;
v_grpfld_tablejoins varchar;
v_aggfld_tablejoins varchar;
v_tablejoins varchar;
v_aggfldtransid varchar;
v_aggfld_primarydctable varchar;
v_entityrelation varchar;
v_aggfldname_transidcnd numeric;
v_entity_parent_reltable varchar;
v_entity_child_reltable varchar;
v_dac_cnd varchar;
v_tablenames varchar[] DEFAULT  ARRAY[]::varchar[];
begin

	/*	 
	 * pcriteria_v1 - transid~aggfnc~groupfld~normalized~srctable~srcfld~allowempty~grpfld_tablename~aggfld~aggfld_tablename(Not in use)	 
	 * pcriteria_v2 - aggfnc~grpfld_transid~groupfld~normalized~srctable~srcfld~allowempty~grpfld_tablename~aggfld_transid~aggfld~aggfld_tablename~grpfld_transid_AND_aggfld_transid_relation
	 * Ex1(agg fld in Non grid dc) - sum~gcust~party_name~F~~~~mg_partyhdr~slord~total_discount~salesorder_header~mg_partyhdr.mg_partyhdrid = salesorder_header.customer
	 * Ex2(agg fld in grid dc) - sum~gcust~party_name~F~~~~mg_partyhdr~slord~taxableamount~salesorder_items~mg_partyhdr.mg_partyhdrid = salesorder_header.customer

	*/ 	 
	
	
	select lower(trim(tablename)) into v_primarydctable from axpdc where tstruct = pentity_transid and dname ='dc1';
	
	select count(1) into v_fldname_transidcnd from axpflds where tstruct = pentity_transid and lower(tablename)=lower(v_primarydctable) and lower(fname)='transid';

	v_tablenames := array_append(v_tablenames,v_primarydctable);
	
	
-------------Permission filter
	   if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_primarydctable||'.');											   					   			   										
			   end if;		  
	
	
	
	    FOR rec IN
    	    select unnest(string_to_array(pcriteria,'^')) criteria 
    	    -----aggfnc~grpfld_transid~groupfld~normalized~srctable~srcfld~allowempty~grpfld_tablename~aggfld_transid~aggfld~aggfld_tablename~grpfld_transid_AND_aggfld_transid_relation
		    loop
			    	
			    v_aggfnc := split_part(rec.criteria,'~',1);---- agg function
			    v_transid := split_part(rec.criteria,'~',2);---grpfld_transid  			    
		    	v_grpfld := split_part(rec.criteria,'~',3);---grpfld_name
			    v_srckey := split_part(rec.criteria,'~',4);---normalized_grpfld_flag
	   			v_srctbl := split_part(rec.criteria,'~',5);---normalied_source table	   			
		   		v_srcfld := split_part(rec.criteria,'~',6);---normalied_source field
			   	v_aempty := split_part(rec.criteria,'~',7);---grpfld_allowempty - to franme left join or join
			    v_grpfld_tbl := lower(trim(split_part(rec.criteria,'~',8)));--grpfld_tablename
			    v_aggfldtransid :=split_part(rec.criteria,'~',9);--aggfld_transid;
				v_aggfld := case when split_part(rec.criteria,'~',10)='count' then '1' else split_part(rec.criteria,'~',10) end;				
				v_aggfldtable := lower(trim(split_part(rec.criteria,'~',11)));---aggfld_tablename
				v_entityrelation := split_part(rec.criteria,'~',12);---grpfld_transid_aggfld_transid_relation
				v_entity_parent_reltable := lower(trim(split_part(split_part(v_entityrelation,'=',1),'.',1)));
				v_entity_child_reltable := lower(trim(split_part(split_part(v_entityrelation,'=',2),'.',1)));
				
				
				v_normalizedjoin := case when v_srckey='T' then concat(' left join ',v_srctbl,' b on ',v_grpfld_tbl,'.',v_grpfld,' = b.',v_srctbl,'id ') else ' ' end;
				v_keyname := case when length(v_grpfld) > 0 then case when v_srckey='T' then concat('b.',v_srcfld) else concat(v_grpfld_tbl,'.',v_grpfld) end else 'null' end;			
				v_keyname_coalesce := 'coalesce(trim('||v_keyname||'), '''')';					

				v_tablenames := case when v_srckey='T' then  array_append(v_tablenames,v_srctbl) end;
				v_tablenames := case when v_srckey='T' then  array_append(v_tablenames,v_grpfld_tbl) end;
				v_tablenames := array_append(v_tablenames,v_aggfldtable);
				
			
			if v_transid = v_aggfldtransid then
			
				if lower(v_aggfldtable)=lower(v_primarydctable) and lower(v_grpfld_tbl)=lower(v_primarydctable) then
					v_tablejoins := v_primarydctable;								   			   									
				elsif lower(v_grpfld_tbl) != lower(v_primarydctable) and lower(v_aggfldtable)=lower(v_primarydctable) then
					v_tablejoins := v_primarydctable||' left join '||v_grpfld_tbl||' on '||v_grpfld_tbl||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';
				elsif lower(v_aggfldtable) != lower(v_primarydctable) and lower(v_grpfld_tbl)=lower(v_primarydctable) then
					v_tablejoins := v_primarydctable||' left join '||v_aggfldtable||' on '||v_aggfldtable||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';
				elsif lower(v_aggfldtable) != lower(v_primarydctable) and lower(v_grpfld_tbl)=lower(v_aggfldtable) then
					v_tablejoins := v_primarydctable||' left join '||v_aggfldtable||' on '||v_aggfldtable||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';
				elsif lower(v_aggfldtable) != lower(v_primarydctable) and lower(v_grpfld_tbl)!=lower(v_aggfldtable) then
					v_tablejoins := v_primarydctable||' left join '||v_aggfldtable||' on '||v_aggfldtable||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id left join '||v_grpfld_tbl||' on '||v_grpfld_tbl||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';
				end if;	----------------- v_tablejoins																						
			
			elsif v_transid != v_aggfldtransid then
				select lower(trim(tablename)) into v_aggfld_primarydctable from axpdc where tstruct = v_aggfldtransid and dname ='dc1';	
			
				select count(1) into v_aggfldname_transidcnd from axpflds where tstruct = v_aggfldtransid and lower(tablename) = lower(v_aggfld_primarydctable) 
				and lower(fname)='transid';

				------------group field joins
				if lower(v_grpfld_tbl)=lower(v_primarydctable)  and lower(v_entity_parent_reltable)=lower(v_primarydctable) then 
					v_grpfld_tablejoins := v_grpfld_tbl;
				elsif lower(v_grpfld_tbl)!=lower(v_primarydctable) and lower(v_entity_parent_reltable)=lower(v_primarydctable) then 
					v_grpfld_tablejoins := v_primarydctable||' join '||v_grpfld_tbl||' on '||v_grpfld_tbl||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';
				elsif lower(v_grpfld_tbl)=lower(v_primarydctable) and lower(v_entity_parent_reltable)!=lower(v_primarydctable) then 
					v_grpfld_tablejoins := v_primarydctable||' join '||v_entity_parent_reltable||' on '||v_entity_parent_reltable||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';	
				elsif lower(v_grpfld_tbl)!=lower(v_primarydctable) and lower(v_entity_parent_reltable)!=lower(v_primarydctable) then
					v_grpfld_tablejoins := v_primarydctable||' join '||v_grpfld_tbl||' on '||v_grpfld_tbl||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id'
									||' join '||v_entity_parent_reltable||' on '||v_entity_parent_reltable||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';
				end if;								
					
				--------------agg field joins	
				if lower(v_aggfldtable)=lower(v_aggfld_primarydctable)  and lower(v_entity_child_reltable)=lower(v_aggfld_primarydctable) then 
					v_aggfld_tablejoins := ' join '||v_aggfldtable||' on '||v_entityrelation;
				elsif lower(v_aggfldtable)!=lower(v_aggfld_primarydctable) and lower(v_entity_child_reltable)=lower(v_aggfld_primarydctable) then 
					v_aggfld_tablejoins := ' join '||v_entity_child_reltable||' on '||v_entityrelation||' join '||v_aggfldtable||' on '||v_aggfldtable||'.'||v_aggfld_primarydctable||'id='||v_aggfld_primarydctable||'.'||v_aggfld_primarydctable||'id';
				elsif lower(v_aggfldtable)=lower(v_aggfld_primarydctable) and lower(v_entity_child_reltable)!=lower(v_aggfld_primarydctable) then 
					v_aggfld_tablejoins := ' join '||v_entity_child_reltable||' on '||v_entityrelation||' join '||v_aggfld_primarydctable||' on '||v_aggfld_primarydctable||'.'||v_aggfld_primarydctable||'id='||v_entity_child_reltable||'.'||v_aggfld_primarydctable||'id';	
				elsif lower(v_aggfldtable)!=lower(v_aggfld_primarydctable) and lower(v_entity_child_reltable)!=lower(v_aggfld_primarydctable) then
					v_aggfld_tablejoins := ' join '||v_entity_child_reltable||' on '||v_entityrelation||' join '||v_aggfld_primarydctable||' on '||v_aggfld_primarydctable||'.'||v_aggfld_primarydctable||'id='||v_entity_child_reltable||'.'||v_aggfld_primarydctable||'id'||
											' join '||v_aggfldtable||' on '||v_aggfldtable||'.'||v_aggfld_primarydctable||'id='||v_aggfld_primarydctable||'.'||v_aggfld_primarydctable||'id';									
				end if;											
				
				v_tablejoins := concat(v_grpfld_tablejoins,' ',v_aggfld_tablejoins);
			
			end if; ------- v_transid = v_aggfldtransid
				
			
			
			select concat('select ',v_keyname_coalesce,' keyname,',case when lower(trim(v_aggfnc)) in ('sum','avg') then 'round('||v_aggfnc||'('||v_aggfld||'),2)'else v_aggfnc||'('||v_aggfld||')' end,
			'keyvalue,','''',rec.criteria,'''::varchar',' criteria from ',v_tablejoins,' ',v_normalizedjoin)
			into v_sql;
																								
			
			
				if coalesce(pfilter,'NA') ='NA' then 
				
				
			v_sql1 := concat(v_sql,' where ',v_primarydctable,'.cancel=''F''',
						case when v_fldname_transidcnd > 0 then concat(' and ',v_primarydctable,'.transid=''',pentity_transid,'''') end,
						case when v_transid != v_aggfldtransid then ' and '||v_aggfld_primarydctable||'.cancel=''F''' end,
						case when v_aggfldname_transidcnd > 0 then concat(' and ',v_aggfld_primarydctable,'.transid=''',v_aggfldtransid,'''') end,
						case when papplydac ='T' then concat(' and (',v_dac_cnd,')') end
						,case when length(v_grpfld) > 0 then concat(' group by ',v_keyname_coalesce) else '' end);
	
		else 
			FOR rec_filters IN
    			select unnest(string_to_array(pfilter,'^')) ifilter
			    loop		    	
			    	v_filter_srcfld := split_part(rec_filters.ifilter,'|',1);
			    	v_filter_srctxt := split_part(rec_filters.ifilter,'|',2);
			    	v_filter_col := split_part(v_filter_srcfld,'~',1);
				    v_filter_normalized := split_part(v_filter_srcfld,'~',2);
 				    v_filter_sourcetbl := split_part(v_filter_srcfld,'~',3);
 				    v_filter_sourcefld := split_part(v_filter_srcfld,'~',4);
					v_filter_datatype := split_part(v_filter_srcfld,'~',5);
					v_filter_listedfld :=split_part(v_filter_srcfld,'~',6);
					v_filter_tablename:=split_part(v_filter_srcfld,'~',7);
					
		
			    				    	
			    	if  v_filter_listedfld = 'F' then
			    	
					v_filter_joinreq := case when lower(v_aggfldtable)=lower(v_filter_tablename) then 1 else 0 end; 			    		
					
			    	if v_filter_joinreq = 0  then 
				    	v_filter_dcjoinsary := array_append(v_filter_dcjoinsary,concat(' join ',v_filter_tablename,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_filter_tablename,'.',v_primarydctable,'id') );
			    	end if;
			    
			    	
			    
		    		select case when v_filter_normalized='T' 
					then concat(' join ',v_filter_sourcetbl,' ',v_filter_col,' on ',v_filter_tablename,'.',v_filter_col,' = ',v_filter_col,'.',v_filter_sourcetbl,'id')
					end into v_filter_join from dual where v_filter_normalized='T';
					
					 
					v_filter_joinsary :=array_append(v_filter_joinsary,v_filter_join);				
					
				
					end if;
			
									
					select case when v_filter_normalized='F' 
					then concat(case when v_filter_datatype='c' then 'lower(' end,v_filter_tablename,'.',v_filter_col,case when v_filter_datatype='c' then ')' end,' ',v_filter_srctxt) 
					else concat(case when v_filter_datatype='c' then 'lower(' end,v_filter_col,'.',v_filter_sourcefld,case when v_filter_datatype='c' then ')' end,' ',v_filter_srctxt) 
					end into v_filter_cnd;
		    	
					v_filter_cndary := array_append(v_filter_cndary,v_filter_cnd);				
			
									
			    end loop;
			   
			   	v_filter_dcjoinsary := ARRAY(SELECT DISTINCT UNNEST(v_filter_dcjoinsary));			
			   
				v_sql1 := concat(v_sql,array_to_string(v_filter_dcjoinsary,' '),array_to_string(v_filter_joinsary,' '),
						' where ',v_primarydctable,'.cancel=''F''',
						case when v_fldname_transidcnd > 0 then concat(' and ',v_primarydctable,'.transid=''',pentity_transid,''' and ') end,
						case when v_transid != v_aggfldtransid then v_aggfld_primarydctable||'.cancel=''F''' end,
						case when v_aggfldname_transidcnd > 0 then concat(' and ',v_aggfld_primarydctable,'.transid=''',v_aggfldtransid,'''') end,						
						array_to_string(v_filter_cndary,' and ')
						,case when papplydac ='T' then concat(' and (',v_dac_cnd,')') end
						,case when length(v_grpfld) > 0 then concat(' group by ',v_keyname_coalesce) else '' end);					    						
		end if;

			v_final_sqls := array_append(v_final_sqls,v_sql1);
			v_filter_cndary:= v_emptyary;
	    	END LOOP;
	      	

   return array_to_string(v_final_sqls,'^^^') ;
END;
$function$
;
>>

<<
ALTER TABLE axp_appsearch_data_period Disable TRIGGER axp_tr_search_appsearch1;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_axupscript()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
v_sqlary text[] DEFAULT  ARRAY[]::text[];
v_sql text;
begin

for rec in
select fname from axpflds where tstruct = 'a__ua' and dcname='dc3' and fname not in('axuserrole','sqltext','cnd')
loop




v_sql := 'select ''exists(select 1 from unnest(string_to_array('||replace(rec.fname,'axup_','{primarytable.}axg_')||','''','''')) val where val in(''''''||replace( :'||rec.fname||','','','''''','''''')||''''''))'' cnd from(select '''||rec.fname||''' gname,unnest(string_to_array(:'||rec.fname||','','')) gval from dual)a group by gname having sum(case when gval=''All'' then 1 else 0 end) = 0';


v_sqlary := array_append(v_sqlary,v_sql);

end loop;

return 'select string_agg(cnd,'' and '') from ( '||array_to_string(v_sqlary,' union all ')||')b';

END; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_create_grpcol(ptransid character varying, ptable character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare
v_altersql text; 
r record;
begin
	

for r in select grpname from axgroupingmst loop 

	v_altersql :='alter table '||ptable||' add axg_'||r.grpname||' varchar(4000)';
	execute v_altersql;

end loop;

return 'T';

exception when others then return 'F';
 
end;

$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getadscnd(ptransid character varying, padsname character varying, pusername character varying, proles character varying DEFAULT 'All'::character varying, pkeyfield character varying DEFAULT NULL::character varying, pkeyvalue character varying DEFAULT NULL::character varying)
 RETURNS TABLE(fullcontrol character varying, userrole character varying, view_access character varying, view_includeflds character varying, view_excludeflds character varying, maskedflds character varying, filtercnd text)
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
rolesql text;
v_permissionsql text;
v_permissionexists numeric;
begin


if proles='All' then 
	rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
	case when viewctrl=''2'' then viewlist else null end view_excludedflds,a.fieldmaskstr,b.cnd,viewctrl 
	from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||padsname||'''
	join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''';
	
	
	v_permissionsql := 'select count(*) from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||padsname||'''
	join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''';

else

	rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
	case when viewctrl=''2'' then viewlist else null end view_excludedflds,
	a.fieldmaskstr,b.cnd,viewctrl from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||padsname||'''
	join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
	where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (b.axuserrole))';
	
	v_permissionsql:=  'select count(*) from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||padsname||'''
	join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
	where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (b.axuserrole))';

end if;

execute v_permissionsql into  v_permissionexists;

if v_permissionexists = 0 then 

	fullcontrol:= 'T';
	return next;

else

	for rec in execute rolesql
	loop
	
			userrole := rec.axuserrole;
			view_includeflds := rec.view_includedflds;
			view_excludeflds := rec.view_excludedflds;
			maskedflds := rec.fieldmaskstr;
			filtercnd := rec.cnd;		
			view_access := case when rec.viewctrl='4' then 'None' else null end;		
			return next;
	
	
	end loop;

end if;
 
return;
	
END; 
$function$
;
>>

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
begin

select sqltext into v_adssql from axdirectsql where sqlname = padsname;

if pcond !='NA' then 

select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';


v_filtercnd := concat(' and (',replace(pcond,'{primarytable.}',v_primarydctable||'.'),')');
	
v_filtersql := replace(v_adssql,'--permission_filter',v_filtercnd);


end if;

return case when pcond ='NA' then  v_adssql else v_filtersql end;
	
	
END; 
$function$
;
>>


<<
CREATE OR REPLACE FUNCTION fn_permissions_getcnd(pmode character varying, ptransid character varying, pkeyfld character varying, pkeyvalue character varying, pusername character varying, proles character varying DEFAULT 'All'::character varying)
 RETURNS TABLE(fullcontrol character varying, userrole character varying, allowcreate character varying, view_access character varying, view_includedc character varying, view_excludedc character varying, view_includeflds character varying, view_excludeflds character varying, edit_access character varying, edit_includedc character varying, edit_excludedc character varying, edit_includeflds character varying, edit_excludeflds character varying, maskedflds character varying, filtercnd text, recordid numeric)
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
rolesql text;
v_transid_primetable varchar(100);
v_transid_primetableid varchar(100);
v_keyfld_normalized varchar(1);
v_keyfld_srctbl varchar(100);
v_keyfld_srcfld varchar(100);
v_keyfld_mandatory varchar(1);
v_keyfld_joins varchar(500);
v_keyfld_cnd varchar(500);
sql_permission_cnd text;
sql_permission_cnd_result numeric;
v_dcfldslist text;
v_recordid numeric;
v_permissionsql text;
v_permissionexists numeric;
v_menuaccess numeric;
v_fullcontrolsql text;
v_fullcontrolrecid numeric;
begin

select srckey,srctf,srcfld,allowempty into v_keyfld_normalized,v_keyfld_srctbl,v_keyfld_srcfld,v_keyfld_mandatory
from axpflds where tstruct = ptransid and fname = pkeyfld;

select tablename into v_transid_primetable from axpdc where tstruct=ptransid and dname='dc1';

v_transid_primetableid := case when lower(pkeyfld)='recordid' then v_transid_primetable||'id' else pkeyfld end;

v_keyfld_cnd := case when v_keyfld_normalized='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else  v_transid_primetable||'.'||v_transid_primetableid end ||'='||pkeyvalue||' and ';

if v_keyfld_normalized='T' then 
	v_keyfld_joins := case when v_keyfld_mandatory='T' then ' join ' else ' left join ' end
					  ||v_keyfld_srctbl||' '||pkeyfld||' on '||v_transid_primetable||'.'||pkeyfld||'='||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id';		
	
end if;

select sum(cnt) into v_menuaccess from 
(select 1 cnt from axusergroups a join axusergroupsdetail b on a.axusergroupsid = b.axusergroupsid
join axuseraccess a2 on b.roles_id = a2.rname and stype ='t' 
where a2.sname = ptransid
and exists(select 1 from unnest(string_to_array(proles,',')) val where val = a.groupname)
union all
select 1 from dual where proles like '%default%'
union all
select 1 from axuserlevelgroups where username = pusername and usergroup='default'
union all
select 1 cnt from axusergroups a join axusergroupsdetail b on a.axusergroupsid = b.axusergroupsid
join axuseraccess a2 on b.roles_id = a2.rname and stype ='t'
join axuserlevelgroups u on a.groupname = u.usergroup and u.username = pusername 
where a2.sname = ptransid and proles = 'All'
)a;


if proles='All' then 
rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||ptransid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''';


v_permissionsql := 'select count(*) from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||ptransid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''';

else

rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||ptransid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (b.axuserrole))';

v_permissionsql:=  'select count(*) from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||ptransid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (b.axuserrole))';

end if;

execute v_permissionsql into  v_permissionexists;

if v_menuaccess > 0 and v_permissionexists = 0 then 

v_fullcontrolsql := concat('select ',v_transid_primetable,'id',' from ',v_transid_primetable,' ',v_keyfld_joins,' where ',replace(v_keyfld_cnd,' and ',''));
execute v_fullcontrolsql into v_fullcontrolrecid;
fullcontrol:= 'T';
recordid := v_fullcontrolrecid;
return next;

else

for rec in execute rolesql
loop

	sql_permission_cnd := concat('select count(*),',v_transid_primetable,'id',' from ',v_transid_primetable,' ',v_keyfld_joins,' where ',v_keyfld_cnd,replace(rec.cnd,'{primarytable.}',v_transid_primetable||'.'),'group by ',v_transid_primetable,'id');

	execute sql_permission_cnd into sql_permission_cnd_result,v_recordid;

	
	
	if sql_permission_cnd_result > 0 then
		

		userrole := rec.axuserrole;
		select string_agg(dname,',') into view_includedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array( rec.view_includedflds,',')) val where val = dname);
		select string_agg(dname,',') into view_excludedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array( rec.view_excludedflds,',')) val where val = dname);		 
		select string_agg(fname,',') into view_includeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.view_includedflds,',')) val where val = fname);
		select string_agg(fname,',') into view_excludeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.view_excludedflds,',')) val where val = fname);
		select string_agg(dname,',') into edit_includedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array( rec.edit_includedflds,',')) val where val = dname);
		select string_agg(dname,',') into edit_excludedc  from axpdc where tstruct=ptransid and exists (select 1 from unnest(string_to_array( rec.edit_excludedflds,',')) val where val = dname);		 
		select string_agg(fname,',') into edit_includeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.edit_includedflds,',')) val where val = fname);
		select string_agg(fname,',') into edit_excludeflds  from axpflds where tstruct=ptransid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.edit_excludedflds,',')) val where val = fname);
		maskedflds := rec.fieldmaskstr;
		filtercnd := rec.cnd;
		recordid :=v_recordid;
		view_access := case when rec.editctrl='0' then null else case when rec.viewctrl='4' then 'None' else null end end;
		edit_access := case when rec.editctrl='4' then 'None' else null end;	
		allowcreate := rec.allowcreate;
		view_includeflds := case when rec.viewctrl='0' then view_includeflds else concat(view_includeflds,',',edit_includeflds) end;		
		view_includedc :=case when rec.viewctrl='0' then view_includedc else  concat(view_includedc,',',edit_includedc) end;		
		return next;

	end if;



end loop;

end if;
 
return;
	
END; 
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getdcrecid(ptransid character varying, precordid numeric, pdcstring character varying)
 RETURNS TABLE(dcname character varying, rowno numeric, recordid numeric)
 LANGUAGE plpgsql
AS $function$
declare 
v_rec record;
v_rec1 record;
v_sql text;
v_dcname varchar;
v_rowstring varchar;
v_dctable varchar;
v_primarydctable varchar;
begin


select tablename into v_primarydctable from axpdc where tstruct=ptransid and dname='dc1';

for v_rec in select unnest(string_to_array(pdcstring,'|')) str from dual
Loop
	v_dcname := split_part(v_rec.str,'~',1);
	v_rowstring := split_part(v_rec.str,'~',2);

	select tablename into v_dctable from axpdc where tstruct=ptransid and dname=v_dcname;

	if v_rowstring = '0' then 
		v_sql := 'select '''||v_dcname||''' dcname,'||v_rowstring||' rowno,'||v_dctable||'id recordid from '||v_dctable||' where '||v_primarydctable||'id::numeric='||precordid;
	else 
		v_sql := 'select '''||v_dcname||''' dcname,'||v_dctable||'row rowno,'||v_dctable||'id recordid from '||v_dctable||' where '||v_primarydctable||'id::numeric='||precordid||' and '||v_dctable||'row in(select unnest(string_to_array('''||v_rowstring||''','',''))::numeric)';
	end if;

		for v_rec1 in execute v_sql 
		Loop 		
			dcname :=v_rec1.dcname;
			rowno :=v_rec1.rowno;
			recordid :=v_rec1.recordid;		
			return next;
		end loop; 
	

		 		
end loop;

return;


	
END; 
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getpermission(pmode character varying, ptransid character varying, pusername character varying, proles character varying DEFAULT 'All'::character varying)
 RETURNS TABLE(transid character varying, fullcontrol character varying, userrole character varying, allowcreate character varying, view_access character varying, view_includedc character varying, view_excludedc character varying, view_includeflds character varying, view_excludeflds character varying, edit_access character varying, edit_includedc character varying, edit_excludedc character varying, edit_includeflds character varying, edit_excludeflds character varying, maskedflds character varying, filtercnd text)
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
rolesql text;
v_permissionsql text;
v_permissionexists numeric;
v_menuaccess numeric;
rec_transid record;
begin

for rec_transid in(select unnest(string_to_array(ptransid,',')) transid) loop

select sum(cnt) into v_menuaccess from 
(select 1 cnt from axusergroups a join axusergroupsdetail b on a.axusergroupsid = b.axusergroupsid
join axuseraccess a2 on b.roles_id = a2.rname and stype ='t' 
where a2.sname = rec_transid.transid
and exists(select 1 from unnest(string_to_array(proles,',')) val where val = a.groupname)
union all
select 1 from dual where proles like '%default%'
union all
select 1 from axuserlevelgroups where username = pusername and usergroup='default'
union all
select 1 cnt from axusergroups a join axusergroupsdetail b on a.axusergroupsid = b.axusergroupsid
join axuseraccess a2 on b.roles_id = a2.rname and stype ='t'
join axuserlevelgroups u on a.groupname = u.usergroup and u.username = pusername 
where a2.sname = ptransid and proles = 'All'
)a;

if proles='All' then 
rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||rec_transid.transid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''';

v_permissionsql := 'select count(*) from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||rec_transid.transid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''';

else

rolesql := 'select a.axuserrole,case when viewctrl=''1'' then viewlist else null end view_includedflds,
case when viewctrl=''2'' then viewlist else null end view_excludedflds,case when editctrl=''1'' then editlist else null end edit_includedflds,
case when editctrl=''2'' then editlist else null end edit_excludedflds,
a.fieldmaskstr,b.cnd,viewctrl,allowcreate,editctrl from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||rec_transid.transid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (b.axuserrole))';

v_permissionsql :='select count(*) from AxPermissions a join axuserpermissions b on a.axuserrole = b.axuserrole and a.formtransid='''||rec_transid.transid||'''
join axusers u on b.axusersid = u.axusersid  and u.username = '''||pusername||'''
where exists (select 1 from unnest(string_to_array('''||proles||''','','')) val where val in (b.axuserrole))';

end if;

execute v_permissionsql into  v_permissionexists;


if v_menuaccess > 0 and v_permissionexists = 0 then 

fullcontrol:= 'T';
transid := rec_transid.transid;
userrole := null;
view_includedc  :=null;
view_excludedc  :=null;		 
view_includeflds:=null;
view_excludeflds :=null;
edit_includedc :=null;
edit_excludedc :=null;		 
edit_includeflds :=null;
edit_excludeflds :=null;
maskedflds := null;				
view_access := null;
edit_access := null;
view_includeflds := null;		
view_includedc :=null;
allowcreate := null;
filtercnd := null;
		
return next;

else

for rec in execute rolesql
loop	
		transid := rec_transid.transid;
		userrole := rec.axuserrole;
		select string_agg(dname,',') into view_includedc  from axpdc where tstruct=rec_transid.transid and exists (select 1 from unnest(string_to_array( rec.view_includedflds,',')) val where val = dname);
		select string_agg(dname,',') into view_excludedc  from axpdc where tstruct=rec_transid.transid and exists (select 1 from unnest(string_to_array( rec.view_excludedflds,',')) val where val = dname);		 
		select string_agg(fname,',') into view_includeflds  from axpflds where tstruct=rec_transid.transid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.view_includedflds,',')) val where val = fname);
		select string_agg(fname,',') into view_excludeflds  from axpflds where tstruct=rec_transid.transid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.view_excludedflds,',')) val where val = fname);
		select string_agg(dname,',') into edit_includedc  from axpdc where tstruct=rec_transid.transid and exists (select 1 from unnest(string_to_array( rec.edit_includedflds,',')) val where val = dname);
		select string_agg(dname,',') into edit_excludedc  from axpdc where tstruct=rec_transid.transid and exists (select 1 from unnest(string_to_array( rec.edit_excludedflds,',')) val where val = dname);		 
		select string_agg(fname,',') into edit_includeflds  from axpflds where tstruct=rec_transid.transid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.edit_includedflds,',')) val where val = fname);
		select string_agg(fname,',') into edit_excludeflds  from axpflds where tstruct=rec_transid.transid and savevalue='T' and exists (select 1 from unnest(string_to_array( rec.edit_excludedflds,',')) val where val = fname);
		maskedflds := rec.fieldmaskstr;				
		view_access := case when rec.editctrl='0' then null else case when rec.viewctrl='4' then 'None' else null end end;
		edit_access := case when rec.editctrl='4' then 'None' else null end;
		view_includeflds := case when rec.viewctrl='0' then view_includeflds else concat(view_includeflds,',',edit_includeflds) end;		
		view_includedc :=case when rec.viewctrl='0' then view_includedc else  concat(view_includedc,',',edit_includedc) end;
		allowcreate := rec.allowcreate;
		filtercnd := rec.cnd;
		fullcontrol:= null;
		return next;

end loop;

end if;

end loop;
 
return;
	
END; 
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getsqls(pmode character varying, ptransid character varying, pkeyfld character varying, pkeyvalue character varying, pcond text, pincdc character varying, pexcdc character varying, pincflds text, pexcflds text)
 RETURNS TABLE(dcno character varying, dcsql text)
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
rec1 record;
rec2 record;
--rolesql text;
v_transid_primetable varchar(100);
v_transid_primetableid varchar(100);
v_keyfld_normalized varchar(1);
v_keyfld_srctbl varchar(100);
v_keyfld_srcfld varchar(100);
v_keyfld_mandatory varchar(1);
v_keyfld_joins varchar(500);
v_keyfld_cnd varchar(500);
--sql_permission_cnd text;
--sql_permission_cnd_result numeric;
v_primarydctable varchar;
v_allflds text;
v_fldname_dctablename varchar;
v_fldname_dcflds text;
v_fldname_dcjoinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_dctables varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_col varchar;
v_fldname_normalized varchar;
v_fldname_srctbl varchar;
v_fldname_srcfld varchar;
v_fldname_allowempty varchar;
v_fldnamesary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_normalizedtables varchar[] DEFAULT  ARRAY[]::varchar[];
v_sql text;
v_onlydcselect numeric;
v_emptyary varchar[] DEFAULT  ARRAY[]::varchar[];
v_alldcs varchar;
begin

select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';

select srckey,srctf,srcfld,allowempty into v_keyfld_normalized,v_keyfld_srctbl,v_keyfld_srcfld,v_keyfld_mandatory
from axpflds where tstruct = ptransid and fname = pkeyfld;

select tablename into v_transid_primetable from axpdc where tstruct=ptransid and dname='dc1';

v_transid_primetableid := case when lower(pkeyfld)='recordid' then v_transid_primetable||'id' else pkeyfld end;

v_keyfld_cnd := case when v_keyfld_normalized='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else  v_transid_primetable||'.'||v_transid_primetableid end ||'='||pkeyvalue;

if v_keyfld_normalized='T' then 
	v_keyfld_joins := case when v_keyfld_mandatory='T' then ' join ' else ' left join ' end
					  ||v_keyfld_srctbl||' '||pkeyfld||' on '||v_transid_primetable||'.'||pkeyfld||'='||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id';		
	
end if;



	if pincdc is null then 	
		select string_agg(dname,',') into v_alldcs from axpdc where tstruct = ptransid
		and not exists(select 1 from unnest(string_to_array( pexcdc,',')) val where val = dname);	
	else		
		with a as(select unnest(string_to_array('dc1,dc2,dc3',','))  fname from dual)
		select fname into v_alldcs  from a where not exists(select 1 from unnest(string_to_array(pexcdc,',')) val where val = a.fname);
	end if;



for rec in select unnest(string_to_array(v_alldcs,',')) dcname 
loop

	select count(1) into v_onlydcselect
	from axpflds where tstruct= ptransid and dcname=rec.dcname and savevalue='T' 
	and exists (select 1 from unnest(string_to_array( pincflds,',')) val where val = fname);

	if v_onlydcselect > 0 then
		select concat(tablename,'=',string_agg(str,'|'))  into v_allflds From(
		select tablename, concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~',allowempty) str
		from axpflds where tstruct=ptransid and dcname=rec.dcname and savevalue='T' 
		and exists (select 1 from unnest(string_to_array( pincflds,',')) val where val = fname)
		and not exists(select 1 from unnest(string_to_array( pexcflds,',')) val where val = fname) 		
		order by dcname ,ordno)a group by a.tablename;
	else
		select concat(tablename,'=',string_agg(str,'|'))  into v_allflds From(
		select tablename, concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~',allowempty) str
		from axpflds where tstruct=ptransid and dcname=rec.dcname and savevalue='T' 
		and not exists(select 1 from unnest(string_to_array( pexcflds,',')) val where val = fname) 		
		order by dcname ,ordno)a group by a.tablename;
	end if; 
	
	FOR rec1 IN
    		select unnest(string_to_array(v_allflds,'^')) dcdtls
    		loop	
    			v_fldname_dctablename := split_part(rec1.dcdtls,'=',1);
				v_fldname_dcflds := split_part(rec1.dcdtls,'=',2);
			
			if v_fldname_dctablename!=v_primarydctable then
						v_fldname_dcjoinsary := array_append(v_fldname_dcjoinsary,concat('left join ',v_fldname_dctablename,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_fldname_dctablename,'.',v_primarydctable,'id') );						
					end if;
					v_fldname_dctables := array_append(v_fldname_dctables,v_fldname_dctablename);

			FOR rec2 IN
    		select unnest(string_to_array(v_fldname_dcflds,'|')) fldname    		    	       			
				loop		    	
					v_fldname_col := split_part(rec2.fldname,'~',1);
					v_fldname_normalized := split_part(rec2.fldname,'~',2);
					v_fldname_srctbl := split_part(rec2.fldname,'~',3);
					v_fldname_srcfld := split_part(rec2.fldname,'~',4);	
					v_fldname_allowempty := split_part(rec2.fldname,'~',5);
			    
				
					
					if v_fldname_normalized ='F' then 
						v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_dctablename,'.',v_fldname_col)::varchar);
					elsif v_fldname_normalized ='T' then	
						v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_col,'.',v_fldname_srcfld,' ',v_fldname_col)::varchar);	
						v_fldname_joinsary := array_append(v_fldname_joinsary,concat(case when v_fldname_allowempty='F' then ' join ' else ' left join ' end,v_fldname_srctbl,' ',v_fldname_col,' on ',v_fldname_dctablename,'.',v_fldname_col,' = ',v_fldname_col,'.',v_fldname_srctbl,'id')::Varchar);
						v_fldname_normalizedtables := array_append(v_fldname_normalizedtables,lower(v_fldname_srctbl));
					end if;
								
			    end loop;
		   
			   end loop;
		   	v_sql := concat(' select ',v_primarydctable,'.',v_primarydctable,'id recordid,',array_to_string(v_fldnamesary,','),' from ',v_primarydctable,' ',
		   			 array_to_string(v_fldname_dcjoinsary,' '),' ',array_to_string(v_fldname_joinsary,' '),' where ',v_keyfld_cnd);--,' and ',pcond);


			dcno := rec.dcname;
			dcsql := v_sql;
			return next;
			v_fldnamesary:= v_emptyary;
		   				v_fldname_joinsary:= v_emptyary;	   				
		   				v_fldname_dcjoinsary:= v_emptyary;	

end loop; 

 
return;
	
END; 
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_grpmaster(pgrpname character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare
v_altersql text; 
r record;
begin
	

for r in select a.ftransid,d.tablename from axgrouptstructs a join axpdc d on a.ftransid = d.tstruct and d.dcno =1 
 loop 

	v_altersql :='alter table '||r.tablename||' add axg_'||pgrpname||' varchar(4000)';
	execute v_altersql;

end loop;
 
return 'T';

exception when others then return 'F';


end;

$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_chartdata(psource character varying, pentity_transid character varying, pcondition character varying, pcriteria character varying, pfilter character varying DEFAULT 'NA'::character varying, pusername character varying DEFAULT 'admin'::character varying, papplydac character varying DEFAULT 'T'::character varying, puserrole character varying DEFAULT 'All'::character varying, pconstraints text DEFAULT NULL::text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
rec record;
rec_filters record;
dacrec record;
v_primarydctable varchar;
v_subentitytable varchar;
v_transid varchar;
v_grpfld varchar;
v_aggfld varchar;
v_aggfnc varchar;
v_srckey varchar;
v_srctbl varchar;
v_srcfld varchar;
v_aempty varchar;
v_tablename varchar;
v_sql text;
v_normalizedjoin varchar;
v_keyname varchar;
v_keyname_coalesce varchar;
v_entitycond varchar;
v_keyfld_fname varchar;
v_keyfld_fval varchar;
v_keyfld_srckey varchar;
v_keyfld_srctbl varchar;
v_keyfld_srcfld varchar;
v_final_sqls text[] DEFAULT  ARRAY[]::text[];
v_fldname_transidcnd numeric;
v_sql1 text;
v_jointables varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_srcfld varchar;
v_filter_srctxt varchar;
v_filter_join varchar;
v_filter_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_cnd varchar;
v_filter_cndary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_joinreq numeric;
v_filter_dcjoinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_col varchar;
v_filter_normalized varchar;
v_filter_sourcetbl varchar;
v_filter_sourcefld varchar;
v_filter_datatype varchar;
v_filter_listedfld varchar;
v_filter_tablename varchar;
v_emptyary varchar[] DEFAULT  ARRAY[]::varchar[];
v_dac_cnd varchar;

begin

	/*
	 * psource - Entity / Subentity	
	 * pcriteria - transid~groupfld~aggfld~aggfnc~normalized~srctable~srcfld~allowempty~tablename~keyfld~keyval
	 * 
	 * pfilter 
	 * search field|operator search text^
	 * fldname~normalized~sourcetable~sourcefld~datatype~listedfield~tablename| operator search text^
	*/ 	 
	
	
	select tablename into v_primarydctable from axpdc where tstruct = pentity_transid and dname ='dc1';	

	v_jointables := array_append(v_jointables,v_primarydctable);


-------------Permission filter
	   if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_primarydctable||'.');											   					   			   										
			   end if;		   			
		   			
	
	if pcondition ='Custom' then
	
		select count(1) into v_fldname_transidcnd from axpflds where tstruct = pentity_transid and dcname ='dc1' and lower(fname)='transid';


		if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_primarydctable||'.');											   					   			   										
			   end if;		   			
	
	    FOR rec IN
    	    select unnest(string_to_array(pcriteria,'^')) criteria 
		    loop		    			    
			    v_transid := split_part(rec.criteria,'~',1);
		    	v_grpfld := split_part(rec.criteria,'~',2);
				v_aggfld := case when split_part(rec.criteria,'~',3)='count' then '1' else split_part(rec.criteria,'~',3) end;
				v_aggfnc := split_part(rec.criteria,'~',4);
				v_srckey := split_part(rec.criteria,'~',5);
				v_srctbl := split_part(rec.criteria,'~',6);
				v_srcfld := split_part(rec.criteria,'~',7);
				v_aempty := split_part(rec.criteria,'~',8);
				v_tablename := split_part(rec.criteria,'~',9);
				v_keyfld_fname := split_part(rec.criteria,'~',10);
				v_keyfld_fval := split_part(rec.criteria,'~',11);
				
				v_jointables := case when v_srckey='T' then array_append(v_jointables,v_srctbl) end;
				v_normalizedjoin := case when v_srckey='T' then concat(' left join ',v_srctbl,' b on ',v_primarydctable,'.',v_grpfld,' = b.',v_srctbl,'id ') else ' ' end;
				v_keyname := case when length(v_grpfld) > 0 then case when v_srckey='T' then concat('b.',v_srcfld) else concat(v_primarydctable,'.',v_grpfld) end else 'null' end;			
				v_keyname_coalesce := 'coalesce(trim('||v_keyname||'), '''')';							
				
					if lower(v_tablename)=lower(v_primarydctable) then
						select concat('select ',v_keyname_coalesce,' keyname,',case when lower(trim(v_aggfnc)) in ('sum','avg') then 'round('||v_aggfnc||'('||v_aggfld||'),2)'else v_aggfnc||'('||v_aggfld||')' end,
						'keyvalue,''Custom''::varchar cnd,','''',rec.criteria,'''::varchar',' criteria from ',v_tablename,' ',v_normalizedjoin)
						into v_sql;
						v_jointables := array_append(v_jointables,v_tablename);		   			   									
					else
						select concat('select ',
						concat(' ',v_keyname,' keyname,',case when lower(trim(v_aggfnc)) in ('sum','avg') then 'round('||v_aggfnc||'('||v_aggfld||'),2)'else v_aggfnc||'('||v_aggfld||')' end,
						' keyvalue,''Custom''::varchar cnd,','''',rec.criteria,'''::varchar',' criteria from ',
						concat(v_primarydctable,'  join ',v_tablename,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_tablename,'.',v_primarydctable,'id '),
						v_normalizedjoin))a
						into v_sql;
						v_jointables := array_append(v_jointables,v_tablename);
						
					end if;																											
			
						
			
				if coalesce(pfilter,'NA') ='NA' then 

			v_sql1 := concat(v_sql,' ',' where ',v_primarydctable,'.cancel=''F''',
						case when v_fldname_transidcnd > 0 then concat(' and ',v_primarydctable,'.transid=''',pentity_transid,'''') end,
						case when papplydac ='T' then concat(' and (',v_dac_cnd,')') end,'
						--axp_filter
						',
						case when length(v_grpfld) > 0 then concat(' group by ',v_keyname_coalesce) else '' end);
	
		else 
			FOR rec_filters IN
    			select unnest(string_to_array(pfilter,'^')) ifilter
			    loop		    	
			    	v_filter_srcfld := split_part(rec_filters.ifilter,'|',1);
			    	v_filter_srctxt := split_part(rec_filters.ifilter,'|',2);
			    	v_filter_col := split_part(v_filter_srcfld,'~',1);
				    v_filter_normalized := split_part(v_filter_srcfld,'~',2);
 				    v_filter_sourcetbl := split_part(v_filter_srcfld,'~',3);
 				    v_filter_sourcefld := split_part(v_filter_srcfld,'~',4);
					v_filter_datatype := split_part(v_filter_srcfld,'~',5);
					v_filter_listedfld :=split_part(v_filter_srcfld,'~',6);
					v_filter_tablename:=split_part(v_filter_srcfld,'~',7);
					
		
			    				    	
			    	if  v_filter_listedfld = 'F' then
			    	
					v_filter_joinreq := case when lower(v_tablename)=lower(v_filter_tablename) then 1 else 0 end; 			    		
					
			    	if v_filter_joinreq = 0  then 
				    	v_filter_dcjoinsary := array_append(v_filter_dcjoinsary,concat(' join ',v_filter_tablename,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_filter_tablename,'.',v_primarydctable,'id') );
			    	end if;
			    
			    	
			    
		    		select case when v_filter_normalized='T' 
					then concat(' join ',v_filter_sourcetbl,' ',v_filter_col,' on ',v_filter_tablename,'.',v_filter_col,' = ',v_filter_col,'.',v_filter_sourcetbl,'id')
					end into v_filter_join from dual where v_filter_normalized='T';
					
					 
					v_filter_joinsary :=array_append(v_filter_joinsary,v_filter_join);				
					
				
					end if;
			
									
					select case when v_filter_normalized='F' 
					then concat(case when v_filter_datatype='c' then 'lower(' end,v_filter_tablename,'.',v_filter_col,case when v_filter_datatype='c' then ')' end,' ',v_filter_srctxt) 
					else concat(case when v_filter_datatype='c' then 'lower(' end,v_filter_col,'.',v_filter_sourcefld,case when v_filter_datatype='c' then ')' end,' ',v_filter_srctxt) 
					end into v_filter_cnd;
		    	
					v_filter_cndary := array_append(v_filter_cndary,v_filter_cnd);				
			
									
			    end loop;
			   
			   	v_filter_dcjoinsary := ARRAY(SELECT DISTINCT UNNEST(v_filter_dcjoinsary));				
				v_sql1 := concat(v_sql,array_to_string(v_filter_dcjoinsary,' '),array_to_string(v_filter_joinsary,' '),'
						  where ',v_primarydctable,'.cancel=''F''',
						case when v_fldname_transidcnd > 0 then concat(' and ',v_primarydctable,'.transid=''',pentity_transid,''' and ') end,array_to_string(v_filter_cndary,' and '),
						case when papplydac ='T' then concat(' and (',v_dac_cnd,')') end,'
						--axp_filter
						',
						case when length(v_grpfld) > 0 then concat(' group by ',v_keyname_coalesce) else '' end);					    						
		end if;

			v_final_sqls := array_append(v_final_sqls,v_sql1);
			v_filter_cndary:= v_emptyary;
			v_jointables :=v_emptyary;
	    	END LOOP;
	   
   elsif pcondition = 'General' then 
		if psource ='Entity' then    
						
			select count(1) into v_fldname_transidcnd from axpflds where tstruct = pentity_transid and dcname ='dc1' and lower(fname)='transid';


			if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_primarydctable||'.');											   					   			   										
			   end if;		   			

			select concat('select count(*) totrec,
			sum(case when date_part(''year'' ,',v_primarydctable,'.createdon) = date_part(''year'',current_date) then 1 else 0 end) cyear,
			sum(case when date_part(''month'' ,',v_primarydctable,'.createdon) = date_part(''month'',current_date) then 1 else 0 end) cmonth,
			sum(case when date_part(''week'' ,',v_primarydctable,'.createdon) = date_part(''week'',current_date) then 1 else 0 end) cweek,
			sum(case when ',v_primarydctable,'.createdon::Date = current_date - 1 then 1 else 0 end) cyesterday,
			sum(case when ',v_primarydctable,'.createdon::Date = current_date then 1 else 0 end) ctoday,''General''::varchar cnd,null::varchar criteria
			from ',v_primarydctable,' where ',v_primarydctable,'.cancel=''F''',
			case when v_fldname_transidcnd > 0 then concat(' and transid=''',pentity_transid,'''') end,
			case when papplydac ='T' then concat(' and (',v_dac_cnd,')') end) into v_sql;				
			
		v_final_sqls := array_append(v_final_sqls,v_sql);

		
				
		elsif psource= 'Subentity' then 		
		    FOR rec IN
	    	    select unnest(string_to_array(pcriteria,'^')) criteria
		    loop		    			    
	      		v_transid := split_part(rec.criteria,'~',1);
	      		v_tablename := split_part(rec.criteria,'~',9);
				v_keyfld_fname := split_part(rec.criteria,'~',10);
				v_keyfld_fval := split_part(rec.criteria,'~',11);
				v_keyfld_srckey := split_part(rec.criteria,'~',5);
				v_keyfld_srctbl := split_part(rec.criteria,'~',6);
				v_keyfld_srcfld := split_part(rec.criteria,'~',7);

				select tablename into v_subentitytable from axpdc where tstruct = v_transid and dname ='dc1';				
			
				select count(1) into v_fldname_transidcnd from axpflds where tstruct = v_transid and dcname ='dc1' and lower(fname)='transid';


				if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_tablename||'.');											   					   			   										
			   end if;		   			
			
				if lower(v_tablename)=lower(v_subentitytable) then
			
				 v_sql := concat('select ','''',v_transid,'''transid',',count(*) totrec,''General''::varchar cnd,','''',replace(rec.criteria,'''',''),'''  criteria from '
								,v_tablename
								,case when v_keyfld_srckey='T' then ' join '||v_keyfld_srctbl||' on '||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id = '||v_tablename||'.'||v_keyfld_fname end
								,' where ',v_tablename,'.cancel=''F'' and ',
				 case when v_fldname_transidcnd > 0 then concat(v_tablename,'.transid=''',v_transid,''' and ') end
				 ,case when v_keyfld_srckey='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else v_keyfld_fname end,'=',v_keyfld_fval				 
					);				
				
				else 
				
				v_sql := concat('select ','''',v_transid,'''transid',',count(*) totrec,''General''::varchar cnd,','''',replace(rec.criteria,'''',''),'''  criteria from '
								,v_tablename,' a join ',v_subentitytable,' b on a.',v_subentitytable,'id=b.',v_subentitytable,'id '
								,case when v_keyfld_srckey='T' then ' join '||v_keyfld_srctbl||' on '||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id = a.'||v_keyfld_fname end
								,' where b.cancel=''F'' and ',
				case when v_fldname_transidcnd > 0 then concat(' b.transid=''',v_transid,''' and ') end
				 ,case when v_keyfld_srckey='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else v_keyfld_fname end,'=',v_keyfld_fval				 
				);
				
					
				end if;
			
				v_final_sqls := array_append(v_final_sqls,v_sql);			
			
			END LOOP;	
		
		end if;
	end if;

 
   return array_to_string(v_final_sqls,'^^^') ;

END;
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_edittxn(ptransid character varying, precordid numeric, pusername character varying DEFAULT 'admin'::character varying, papplydac character varying DEFAULT 'T'::character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
rec1 record;
rec2 record;
dacrec record;
v_sql text;
v_sql1 text;
v_primarydctable varchar;
v_fldnamesary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_col varchar;
v_fldname_normalized varchar;
v_fldname_srctbl varchar;
v_fldname_srcfld varchar;
v_fldname_allowempty varchar;
v_fldname_dcjoinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_dctablename varchar;
v_fldname_dcflds text;
v_fldname_dctables varchar[] DEFAULT  ARRAY[]::varchar[];
v_allflds varchar;
v_dacenabled numeric;
v_dactype numeric;
v_dac_cnd varchar;
v_dac_cndary varchar[] DEFAULT  ARRAY[]::varchar[];
v_editable varchar;
v_dac_join varchar;
v_dac_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_dac_joinreq numeric;
v_dac_normalizedjoinreq numeric; 
v_dac_entry numeric;
v_dac_onlyview numeric;


begin


	select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';


select count(*) into v_dac_entry from axpdef_dac_config where stransid = ptransid and editmode in('Edit','ViewEdit');



----DAC V5
	select sum(cnt),sum(appl),sum(onlyview) into v_dacenabled,v_dactype,v_dac_onlyview from
(select count(*) cnt,2 appl,0 onlyview from axpdef_dac_config a  
where a.uname = pusername and a.stransid = ptransid and a.editmode in ('Edit','ViewEdit')
having count(*) > 0
union all
select count(*),1 appl,0 onlyview from axpdef_dac_config a  join axuserlevelgroups a2 on a.urole = a2.usergroup 
where a2.username = pusername and a.stransid = ptransid and a.editmode in ('Edit','ViewEdit')
and ((a2.startdate is not null and current_date  >= startdate) or (startdate is null)) and ((enddate is not null and current_date  <= enddate) or (enddate is null))
having count(*) > 0
union all
select 0 cnt,0 appl,2 onlyview from axpdef_dac_config a  
where a.uname = pusername and a.stransid = ptransid and a.editmode='View'
having count(*) > 0
union all
select 0,0 appl,1 onlyview from axpdef_dac_config a  join axuserlevelgroups a2 on a.urole = a2.usergroup 
where a2.username = pusername and a.stransid = ptransid and a.editmode='View'
and ((a2.startdate is not null and current_date  >= startdate) or (startdate is null)) and ((enddate is not null and current_date  <= enddate) or (enddate is null))
having count(*) > 0
)a
where 'T' = papplydac;


 
			
			select string_agg(str,'^')  into v_allflds 
					from 
					(
					select concat(f.tablename,'=',string_agg(concat(f.fname,'~',f.srckey,'~',f.srctf,'~',f.srcfld,'~',f.allowempty),'|')) str
					from axpdef_dac_config a join axpdef_dac_configdtl b on a.axpdef_dac_configid =  b.axpdef_dac_configid
					join axpflds f on a.stransid =f.tstruct and b.fldname = f.fname 
					where a.uname = pusername  and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					and a.dataaccesscnd = 30 and v_dactype in(2,3) 
					group by f.tablename									
					union all					
					select  tablename||'='||'createdby~F~~~F'
					from axpdef_dac_config a 
					join axpdc d on a.stransid =d.tstruct and d.dname= 'dc1' 
					where a.uname = pusername and a.dataaccesscnd in (10,11,12) 
					and a.stransid = ptransid and a.editmode in('Edit','ViewEdit') and v_dactype in(2,3)					
					union all					
					select concat(f.tablename,'=',string_agg(concat(f.fname,'~',f.srckey,'~',f.srctf,'~',f.srcfld,'~',f.allowempty),'|')) str
					from axpdef_dac_config a join axpdef_dac_configdtl b on a.axpdef_dac_configid =  b.axpdef_dac_configid
					join axpflds f on a.stransid =f.tstruct and b.fldname = f.fname 
					join axuserlevelgroups u on a.urole = u.usergroup and ((u.startdate is not null and current_date  >= startdate) or (startdate is null)) and ((enddate is not null and current_date  <= enddate) or (enddate is null))
					and u.username = pusername and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					where a.dataaccesscnd =30 and v_dactype = 1					
					group by f.tablename	
					union all
					select tablename||'='||'createdby~F~~~F'
					from axpdef_dac_config a 
					join axpdc d on a.stransid =d.tstruct and d.dname= 'dc1'
					join axuserlevelgroups u on a.urole = u.usergroup and ((u.startdate is not null and current_date  >= startdate) or (startdate is null)) and ((enddate is not null and current_date  <= enddate) or (enddate is null))
					and u.username = pusername and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					where a.dataaccesscnd in (10,11,12) and v_dactype = 1
					)a;			
		
						
		FOR rec1 IN
    		select unnest(string_to_array(v_allflds,'^')) dcdtls
    		loop	
    			v_fldname_dctablename := split_part(rec1.dcdtls,'=',1);
				v_fldname_dcflds := split_part(rec1.dcdtls,'=',2);
			
			if v_fldname_dctablename!=v_primarydctable then
						v_fldname_dcjoinsary := array_append(v_fldname_dcjoinsary,concat('left join ',v_fldname_dctablename,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_fldname_dctablename,'.',v_primarydctable,'id') );						
					end if;
					v_fldname_dctables := array_append(v_fldname_dctables,v_fldname_dctablename);

				FOR rec2 IN
	    		select unnest(string_to_array(v_fldname_dcflds,'|')) fldname    		    	       			
					loop		    	
						v_fldname_col := split_part(rec2.fldname,'~',1);
						v_fldname_normalized := split_part(rec2.fldname,'~',2);
						v_fldname_srctbl := split_part(rec2.fldname,'~',3);
						v_fldname_srcfld := split_part(rec2.fldname,'~',4);	
						v_fldname_allowempty := split_part(rec2.fldname,'~',5);
				    
											
						if v_fldname_normalized ='F' then 
							v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_dctablename,'.',v_fldname_col)::varchar);
						elsif v_fldname_normalized ='T' then	
							v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_col,'.',v_fldname_srcfld,' ',v_fldname_col)::varchar);	
							v_fldname_joinsary := array_append(v_fldname_joinsary,concat(case when v_fldname_allowempty='F' then ' join ' else ' left join ' end,v_fldname_srctbl,' ',v_fldname_col,' on ',v_fldname_dctablename,'.',v_fldname_col,' = ',v_fldname_col,'.',v_fldname_srctbl,'id')::Varchar);
							v_fldname_dctables := array_append(v_fldname_dctables,v_fldname_srctbl);
						end if;
									
				    end loop;
		   
			end loop;

		   	v_sql := concat(' select count(*) from ',v_primarydctable,' ',array_to_string(v_fldname_dcjoinsary,' '),' ',array_to_string(v_fldname_joinsary,' '));
 

		   			
---------DAC filters
			   if v_dacenabled > 0 then
				   			   				
			   ------------------ DAC V5
			    for dacrec in 			   
					select fname,tablename,srckey,srctf,srcfld,
					case when filtercnd in('like','not like') then case when isglovar='F' then '''%'||attribvalue||'%''' else 
					case when lower(trim(attribvalue))=':username' then  '''%'||pusername||'%''' else '''%''||'||attribvalue||'||''%''' end end
					when filtercnd in('in','not in') then case when isglovar='F' then ''''||replace(attribvalue,',',''',''')||'''' else case when lower(trim(attribvalue))=':username' then  ''''||pusername||'''' else attribvalue end end
					when filtercnd in('=','!=','>','<') then case when isglovar='F' then ''''||attribvalue||'''' else case when lower(trim(attribvalue))=':username' then  ''''||pusername||'''' else attribvalue end end  end cnd,
					ord,filtercnd  from
					(
					select case when b.dynamicval ='No' and a.dataaccesscnd = 30 then b.fldstaticval when b.dynamicval ='Yes' and a.dataaccesscnd = 30 then b.fldmastvalue end  attribvalue,
					f.fname,f.tablename,1 ord, b.filtercnd,b.isglovar,f.srckey,f.srctf,f.srcfld
					from axpdef_dac_config a join axpdef_dac_configdtl b on a.axpdef_dac_configid =  b.axpdef_dac_configid
					join axpflds f on a.stransid =f.tstruct and b.fldname = f.fname 
					where a.uname = pusername  and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					and a.dataaccesscnd = 30 and v_dactype in(2,3)					
					union all			
					select case when b.dynamicval ='No' and a.dataaccesscnd = 30 then b.fldstaticval when b.dynamicval ='Yes' and a.dataaccesscnd = 30 then b.fldmastvalue end  attribvalue,
					b.fldname ,d.tablename,1 ord, b.filtercnd,b.isglovar,'F',null,null
					from axpdef_dac_config a join axpdef_dac_configdtl b on a.axpdef_dac_configid =  b.axpdef_dac_configid
					join axpdc d on a.stransid =d.tstruct and d.dname= 'dc1' 
					where a.uname = pusername  and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					and a.dataaccesscnd = 30 and b.fldname in('createdby','username','createdon','modifiedon')  and v_dactype in(2,3)
					union all		
					select  pusername attribvalue, 'createdby' ,d.tablename,1 ord,'='filtercnd,'F','F' srckey,null srctf, null srcfld
					from axpdef_dac_config a 
					join axpdc d on a.stransid =d.tstruct and d.dname= 'dc1' 
					where a.uname = pusername and a.dataaccesscnd in (10,11,12) 
					and a.stransid = ptransid and a.editmode in('Edit','ViewEdit') 
					and v_dactype in(2,3)					
					union all					
					select case when b.dynamicval ='No' and a.dataaccesscnd = 30 then b.fldstaticval when b.dynamicval ='Yes' and a.dataaccesscnd = 30 then b.fldmastvalue end  attribvalue,
					f.fname,f.tablename,2 ord, b.filtercnd,b.isglovar,f.srckey,f.srctf,f.srcfld
					from axpdef_dac_config a join axpdef_dac_configdtl b on a.axpdef_dac_configid =  b.axpdef_dac_configid
					join axpflds f on a.stransid =f.tstruct and b.fldname = f.fname 
					join axuserlevelgroups u on a.urole = u.usergroup and ((u.startdate is not null and current_date  >= startdate) or (startdate is null)) and ((enddate is not null and current_date  <= enddate) or (enddate is null))
					and u.username = pusername and a.stransid = ptransid 
					and a.editmode in('Edit','ViewEdit')
					where a.dataaccesscnd =30 and v_dactype = 1
					union all
					select case when b.dynamicval ='No' and a.dataaccesscnd = 30 then b.fldstaticval when b.dynamicval ='Yes' and a.dataaccesscnd = 30 then b.fldmastvalue end  attribvalue,
					b.fldname,d.tablename,2 ord, b.filtercnd,b.isglovar,'F',null,null
					from axpdef_dac_config a join axpdef_dac_configdtl b on a.axpdef_dac_configid =  b.axpdef_dac_configid
					join axpdc d on a.stransid =d.tstruct and d.dname= 'dc1'
					join axuserlevelgroups u on a.urole = u.usergroup and ((u.startdate is not null and current_date  >= startdate) or (startdate is null)) and ((enddate is not null and current_date  <= enddate) or (enddate is null))
					and u.username = pusername and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					where a.dataaccesscnd =30 and v_dactype = 1	and  b.fldname in('createdby','username','createdon','modifiedon') 						
					union all
					select  pusername attribvalue, 'createdby' ,d.tablename,2 ord,'='filtercnd ,'F','F' srckey,null srctf, null srcfld
					from axpdef_dac_config a 
					join axpdc d on a.stransid =d.tstruct and d.dname= 'dc1'
					join axuserlevelgroups u on a.urole = u.usergroup and ((u.startdate is not null and current_date  >= startdate) or (startdate is null)) and ((enddate is not null and current_date  <= enddate) or (enddate is null))
					and u.username = pusername and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					where a.dataaccesscnd in (10,11,12) and v_dactype = 1
					)a
					order by ord 
					
					loop												
					
							select count(1) into v_dac_joinreq from (
						select distinct unnest(v_fldname_dctables)tbls 												
						)a 
						where lower(a.tbls)=lower(dacrec.tablename);	


						if dacrec.srckey ='T' then
							select count(1) into v_dac_normalizedjoinreq from (
							select distinct unnest(v_fldname_dctables)tbls 						
							)a 
							where lower(a.tbls)=lower(dacrec.srctf);	
	
								if v_dac_normalizedjoinreq = 0 then
									v_dac_joinsary := array_append(v_dac_joinsary,concat(' join ',dacrec.srctf,' on ',dacrec.srctf,'.',dacrec.srctf,'id=',dacrec.tablename,'.',dacrec.fname));
									v_fldname_dctables := array_append(v_fldname_dctables,dacrec.srctf);						
								end if;

						end if;		

												
						if v_dac_joinreq = 0 then
						v_dac_joinsary := array_append(v_dac_joinsary,concat(' join ',dacrec.tablename,' on ',v_primarydctable,'.',v_primarydctable,'id=',dacrec.tablename,'.',v_primarydctable,'id') );
						v_fldname_dctables := array_append(v_fldname_dctables,dacrec.tablename);		
						end if;							

						v_dac_cnd := case 
									 when dacrec.srckey='F' then  concat(dacrec.tablename,'.',dacrec.fname,' ',dacrec.filtercnd,'(', case when dacrec.filtercnd in('in','not in') then 'select unnest(string_to_array('||replace(dacrec.cnd,':','axglovar.')||','',''))' else replace(dacrec.cnd,':','axglovar.')	end,')')  
									 when 	dacrec.srckey='T' then  
									 case when v_dac_normalizedjoinreq = 0 then concat(dacrec.srctf,'.',dacrec.srcfld,' ',dacrec.filtercnd,'(',case when dacrec.filtercnd in('in','not in') then 'select unnest(string_to_array('||replace(dacrec.cnd,':','axglovar.')||','',''))' else replace(dacrec.cnd,':','axglovar.')	end	,')') 
									else concat(dacrec.fname,'.',dacrec.srcfld,' ',dacrec.filtercnd,'(',case when dacrec.filtercnd in('in','not in') then 'select unnest(string_to_array('||replace(dacrec.cnd,':','axglovar.')||','',''))' else replace(dacrec.cnd,':','axglovar.')	end	,')') end
									end;
					
					
						v_dac_cndary := array_append(v_dac_cndary,v_dac_cnd);									
					

					end loop;
								
			   end if;		   			
		   			
						v_sql1 := concat(v_sql,' join axglovar on axglovar.axglo_user = ','''',pusername,'''',' where ',v_primarydctable,'id=',precordid,case when v_dacenabled > 0 then concat(' and ',array_to_string(v_dac_cndary,' and ')) else ' and 1=2 ' end);	
		

					execute v_sql1 into v_editable;								   					   			   							


			
return case when v_dac_entry > 0 and v_dac_onlyview = 0 then 
case when v_editable = '0' then 'F' else 'T' end 
when v_dac_entry > 0 and v_dac_onlyview =2 then 'F'
when v_dac_entry > 0 and v_dac_onlyview in (1,3) then case when v_editable = '0' then 'F' else 'T' end
when v_dac_entry = 0 and v_dac_onlyview in (1,2,3) then 'F'
else 'T' end;


END; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_filterdata(ptransid character varying, pflds text)
 RETURNS TABLE(datavalue character varying)
 LANGUAGE plpgsql
AS $function$
declare 
v_sql text;
begin
---pflds - fldname~normalized~source table~source fld
	
	
	if split_part(pflds,'~',2)='T' then	
		v_sql := concat('select distinct ',split_part(pflds,'~',4),' from ',split_part(pflds,'~',3));
	elsif 
		split_part(pflds,'~',2)='F' then
		v_sql := concat('select distinct ',split_part(pflds,'~',1),' from ',split_part(pflds,'~',3));
	end if;
		
	
return query execute v_sql;


END; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_ins_axreltn()
 RETURNS void
 LANGUAGE plpgsql
AS $function$ 
begin
	
delete from axentityrelations where rtype!='custom';
 
insert into axentityrelations ( 
axentityrelationsid,cancel,username,modifiedon,createdby,createdon,app_level,app_desc,
rtype,mstruct,mfield,mtable,primarytable,dstruct,dfield,dtable,rtypeui,mstructui,mfieldui,dstructui,dfieldui,dprimarytable)
select * from vw_entityrelations;
 
	
end;

$function$
;
>>

<<
SELECT fn_axpanalytics_ins_axreltn();
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_listdata(ptransid character varying, pflds text DEFAULT 'All'::text, ppagesize numeric DEFAULT 25, ppageno numeric DEFAULT 1, pfilter text DEFAULT 'NA'::text, puser character varying DEFAULT 'admin'::character varying, papplydac character varying DEFAULT 'T'::character varying, puserrole character varying DEFAULT 'All'::character varying, pconstraints text DEFAULT NULL::text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare 
rec record;
rec1 record;
rec2 record;
v_sql text;
v_sql1 text;
v_primarydctable varchar;
v_fldnamesary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_col varchar;
v_fldname_normalized varchar;
v_fldname_srctbl varchar;
v_fldname_srcfld varchar;
v_fldname_allowempty varchar;
v_fldname_dcjoinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_dctablename varchar;
v_fldname_dcflds text;
v_fldname_dctables varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_normalizedtables varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_transidcnd numeric;
v_allflds varchar;
v_filter_srcfld varchar;
v_filter_srctxt varchar;
v_filter_join varchar;
v_filter_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_cnd varchar;
v_filter_cndary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_joinreq numeric;
v_filter_dcjoinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_filter_col varchar;
v_filter_normalized varchar;
v_filter_sourcetbl varchar;
v_filter_sourcefld varchar;
v_filter_datatype varchar;
v_filter_listedfld varchar;
v_filter_tablename varchar;
v_fldname_tables varchar[] DEFAULT  ARRAY[]::varchar[];
v_dac_cnd varchar;
 

begin

/*
---pflds - tbl1=fldname~normalized~source_table~source_fld~mandatory|fldname~normalized~source_table~source_fld~mandatory^
		tb12=fldname~normalized~source_table~source_fld~mandatory|fldname~normalized~source_table~source_fld~mandatory
 */
	
/* pfilter
search field|operator search text^ 
fldname~normalized~sourcetable~sourcefld~datatype~listedfield~tablename| operator search text^
*/
		

	select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';



	select count(1) into v_fldname_transidcnd from axpflds where tstruct = ptransid and dcname ='dc1' and lower(fname)='transid';

		if pflds = 'All' then 		
			select concat(tablename,'=',string_agg(str,'|'))  into v_allflds From(
			select tablename, concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~',allowempty) str
			from axpflds where tstruct=ptransid and dcname='dc1' and 
			asgrid ='F' and hidden ='F' and savevalue='T' and tablename = v_primarydctable and datatype not in('i','t')
			order by dcname ,ordno)a group by a.tablename;		
		end if;
						
		FOR rec1 IN
    		select unnest(string_to_array(case when pflds='All' then v_allflds else pflds end,'^')) dcdtls
    		loop	
    			v_fldname_dctablename := split_part(rec1.dcdtls,'=',1);
				v_fldname_dcflds := split_part(rec1.dcdtls,'=',2);
			
			if v_fldname_dctablename!=v_primarydctable then
						v_fldname_dcjoinsary := array_append(v_fldname_dcjoinsary,concat('left join ',v_fldname_dctablename,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_fldname_dctablename,'.',v_primarydctable,'id') );						
					end if;
					v_fldname_dctables := array_append(v_fldname_dctables,v_fldname_dctablename);

			FOR rec2 IN
    		select unnest(string_to_array(v_fldname_dcflds,'|')) fldname    		    	       			
				loop		    	
					v_fldname_col := split_part(rec2.fldname,'~',1);
					v_fldname_normalized := split_part(rec2.fldname,'~',2);
					v_fldname_srctbl := split_part(rec2.fldname,'~',3);
					v_fldname_srcfld := split_part(rec2.fldname,'~',4);	
					v_fldname_allowempty := split_part(rec2.fldname,'~',5);
			    
				
					
					if v_fldname_normalized ='F' then 
						v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_dctablename,'.',v_fldname_col)::varchar);
					elsif v_fldname_normalized ='T' then	
						v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_col,'.',v_fldname_srcfld,' ',v_fldname_col)::varchar);	
						v_fldname_joinsary := array_append(v_fldname_joinsary,concat(case when v_fldname_allowempty='F' then ' join ' else ' left join ' end,v_fldname_srctbl,' ',v_fldname_col,' on ',v_fldname_dctablename,'.',v_fldname_col,' = ',v_fldname_col,'.',v_fldname_srctbl,'id')::Varchar);
						v_fldname_normalizedtables := array_append(v_fldname_normalizedtables,lower(v_fldname_srctbl));
					end if;
								
			    end loop;
		   
			   end loop;
		   	v_sql := concat(' select ','''',ptransid,''' transid,',v_primarydctable,'.',v_primarydctable,'id recordid,',v_primarydctable,'.username modifiedby,',v_primarydctable,'.modifiedon,',v_primarydctable,'.createdon,',v_primarydctable,'.createdby,',
		   			 array_to_string(v_fldnamesary,','),',null axpeg_processname,null axpeg_keyvalue,null axpeg_status,null axpeg_statustext from ',v_primarydctable,' ',
		   			 array_to_string(v_fldname_dcjoinsary,' '),' ',array_to_string(v_fldname_joinsary,' ')
					--,' left join fn_axpanalytics_pegstatus(''',ptransid,''',',v_primarydctable,'.',v_primarydctable,'id) b on ', v_primarydctable,'.',v_primarydctable,'id=b.axpeg_recordid'
					 );
 

		   			
---------DAC filters
			   if papplydac = 'T' then					
					v_dac_cnd := replace(pconstraints,'{primarytable.}',v_primarydctable||'.');											   					   			   										
			   end if;		   			
		   			
			
		if coalesce(pfilter,'NA') ='NA' then 

			v_sql1 := concat('select b.* from(select a.*,row_number() over(order by modifiedon desc)::Numeric rno,
			case when mod(row_number() over(order by modifiedon desc),',ppagesize,')=0 then row_number() over(order by modifiedon desc)/',ppagesize,' else row_number() over(order by modifiedon desc)/',ppagesize,'+1 end::numeric pageno from 
			(',concat(v_sql,' where ',v_primarydctable,'.cancel=''F''',case when v_fldname_transidcnd>0 then concat(' and ',v_primarydctable,'.transid=','''',ptransid,'''') else '' end,
			case when papplydac ='T' then concat(' and (',v_dac_cnd,')') end),'
			--axp_filter
			',')a order by modifiedon desc limit ',ppagesize*ppageno,' )b ',case when ppageno=0 then '' else concat('where pageno=',ppageno) end);
	
		else 
			FOR rec IN
    			select unnest(string_to_array(pfilter,'^')) ifilter
			    loop		    	
			    	v_filter_srcfld := split_part(rec.ifilter,'|',1);
			    	v_filter_srctxt := split_part(rec.ifilter,'|',2);
			    	v_filter_col := split_part(v_filter_srcfld,'~',1);
				    v_filter_normalized := split_part(v_filter_srcfld,'~',2);
 				    v_filter_sourcetbl := split_part(v_filter_srcfld,'~',3);
 				    v_filter_sourcefld := split_part(v_filter_srcfld,'~',4);
					   v_filter_datatype := split_part(v_filter_srcfld,'~',5);
					v_filter_listedfld :=split_part(v_filter_srcfld,'~',6);
				v_filter_tablename:=split_part(v_filter_srcfld,'~',7);
					
		
			    				    	
			    	if  v_filter_listedfld = 'F' then
			    	
					select count(1) into v_filter_joinreq from (select distinct unnest(v_fldname_dctables)tbls )a where lower(a.tbls)=lower(v_filter_tablename);			    		
					
			    	if v_filter_joinreq = 0  then 
				    	v_filter_dcjoinsary := array_append(v_filter_dcjoinsary,concat(' join ',v_filter_tablename,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_filter_tablename,'.',v_primarydctable,'id') );
				    	v_fldname_tables := array_append(v_fldname_tables,v_filter_tablename);
			    	end if;
			    
			    	
			    
		    		select case when v_filter_normalized='T' 
					then concat(' join ',v_filter_sourcetbl,' ',v_filter_col,' on ',v_filter_tablename,'.',v_filter_col,' = ',v_filter_col,'.',v_filter_sourcetbl,'id')
					end into v_filter_join from dual where v_filter_normalized='T';
					
					 
					v_filter_joinsary :=array_append(v_filter_joinsary,v_filter_join);				
					
				
					end if;
			
									
					select case when v_filter_normalized='F' 
					then concat(case when v_filter_datatype='c' then 'lower(' end,v_filter_tablename,'.',v_filter_col,case when v_filter_datatype='c' then ')' end,' ',v_filter_srctxt) 
					else concat(case when v_filter_datatype='c' then 'lower(' end,v_filter_col,'.',v_filter_sourcefld,case when v_filter_datatype='c' then ')' end,' ',v_filter_srctxt) 
					end into v_filter_cnd;
		    	
					v_filter_cndary := array_append(v_filter_cndary,v_filter_cnd);				
			
									
			    end loop;
			   
			   	v_filter_dcjoinsary := ARRAY(SELECT DISTINCT UNNEST(v_filter_dcjoinsary));				   					   
			   
			   
				v_sql1 := concat('select b.* from(select a.*,row_number() over(order by modifiedon desc)::Numeric rno,
						case when mod(row_number() over(order by modifiedon desc),',ppagesize,')=0 then row_number() over(order by modifiedon desc)/',ppagesize,' else row_number() over(order by modifiedon desc)/',ppagesize,'+1 end::numeric pageno from 
						(',v_sql,concat(array_to_string(v_filter_dcjoinsary,' '),array_to_string(v_filter_joinsary,' '),' where ',v_primarydctable,'.cancel=''F'' and ',case when v_fldname_transidcnd>0 then concat(v_primarydctable,'.transid=','''',ptransid,''' and ') else '' end,
						array_to_string(v_filter_cndary,' and '),case when papplydac ='T' then concat(' and (',v_dac_cnd,')') end),'
						--axp_filter
						',')a order by modifiedon desc limit ',ppagesize*ppageno,' )b ',case when ppageno=0 then '' else concat('where pageno=',ppageno) end);					    						
		end if;

return v_sql1;


END; $function$
;
>>

<<
CREATE TABLE axpdef_axpanalytics_mdata (
	ftransid varchar(10) NULL,
	fcaption varchar(500) NULL,
	fldname varchar(50) NULL,
	fldcap varchar(500) NULL,
	cdatatype varchar(50) NULL,
	fdatatype varchar(50) NULL,
	fmodeofentry varchar(50) NULL,
	hide varchar(10) NULL,
	props varchar(4000) NULL,
	"normalized" varchar(10) NULL,
	srctable varchar(50) NULL,
	srcfield varchar(50) NULL,
	srctransid varchar(10) NULL,
	allowempty varchar(10) NULL,
	filtertype varchar(50) NULL,
	grpfield varchar(10) NULL,
	aggfield varchar(10) NULL,
	subentity varchar(1) NULL,
	datacnd numeric(1) NULL,
	entityrelfld varchar(100) NULL,
	allowduplicate varchar(1) NULL,
	tablename varchar(100) NULL,
	dcname varchar(10) NULL,
	fordno numeric NULL,
	dccaption varchar(100) NULL,
	griddc varchar(2) NULL,
	listingfld varchar(1) NULL,
	"encrypted" varchar(1) NULL,
	masking varchar(100) NULL,
	lastcharmask varchar(100) NULL,
	firstcharmask varchar(100) NULL,
	maskchar varchar(1) NULL,
	maskroles varchar(1000) NULL,
	customdecimal varchar(1) NULL);
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_metadata(ptransid character varying, psubentity character varying DEFAULT 'F'::character varying, planguage character varying DEFAULT 'English'::character varying)
 RETURNS SETOF axpdef_axpanalytics_mdata
 LANGUAGE plpgsql
AS $function$
declare
r axpdef_axpanalytics_mdata%rowtype;
rec record;
v_subentitytable varchar;
v_sql text;
v_subentitysql text;
v_primarydctable varchar;
begin
 

	select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';

	select concat('select axpflds.tstruct transid,coalesce(lf.compcaption,t.caption) formcap, fname ,coalesce(l.compcaption,axpflds.caption) fcap,customdatatype cdatatype,"datatype" dt,modeofentry,
	hidden fhide,cast(null as varchar) props,srckey ,srctf ,srcfld ,srctrans ,axpflds.allowempty,
	case when modeofentry =''select'' then case when srckey =''T'' then ''Dropdown'' else ''Text'' end else ''Text'' end::varchar filtercnd,
	case when (modeofentry =''select'' or datatype=''c'') then ''T'' else ''F'' end::varchar grpfld,
	case when "datatype" =''n'' then ''T'' else ''F'' end::varchar aggfld,''F'' subentity,1 datacnd,null entityrelfld,allowduplicate,axpflds.tablename,
	dcname,ordno,d.caption dccaption,d.asgrid,case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,encrypted,masking,lastcharmask,firstcharmask,maskchar,maskroles,customdecimal
	from axpflds join tstructs t on axpflds.tstruct = t.name join axpdc d on axpflds.tstruct = d.tstruct and axpflds.dcname = d.dname
	left join axlanguage l on substring(l.sname FROM 2)= t.name and lower(l.dispname)=''',lower(planguage),''' and axpflds.fname = l.compname
	left join axlanguage lf on substring(lf.sname FROM 2)= t.name and lower(lf.dispname)=''',lower(planguage),''' and lf.compname=''x__headtext'' 		
	where axpflds.tstruct=','''',ptransid,''' and savevalue =''T'' 
	union all
	select a.name,coalesce(lf.compcaption,t.caption),key,coalesce(l.compcaption,title),	''button'',null,null,''F'',	concat(script, ''~'', icon),''F'',null,null,null,null,null,null,null,''F'' subentity,1,null,
	null,null,null,ordno,null,''F'',''F'',null encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
	from axtoolbar a join tstructs t on a.name = t.name
	left join axlanguage l on substring(l.sname FROM 2)= t.name and lower(l.dispname)=''',lower(planguage),''' and a.key = l.compname
	left join axlanguage lf on substring(lf.sname FROM 2)= t.name and lower(lf.dispname)=''',lower(planguage),''' and lf.compname=''x__headtext''
	where visible = ''true'' and script is not null and a.name= ','''',ptransid,'''') into v_sql;

	for r in execute v_sql
		loop	    	
			RETURN NEXT r; -- return current row of select
		END LOOP;	
	

if psubentity ='T' then		

    FOR rec IN
        select distinct a.dstruct,a.rtype,dprimarytable  from axentityrelations a 		
		where rtype in('md','custom','gm') and mstruct = ptransid 
   	loop		
	

select concat('select distinct axpflds.tstruct transid,coalesce(lf.compcaption,t.caption) formcap, fname ,coalesce(l.compcaption,axpflds.caption) fcap,customdatatype cdatatype,"datatype" dt,modeofentry ,hidden fhide,
		cast(null as varchar) props,srckey ,srctf ,srcfld ,srctrans ,axpflds.allowempty,
		case when modeofentry =''select'' then case when srckey =''T'' then ''Dropdown'' else ''Text'' end else ''Text'' end::varchar filtercnd,
		case when modeofentry =''select'' then ''T'' else ''F'' end::varchar grpfld,
		case when "datatype" =''n'' then ''T'' else ''F'' end::varchar aggfld,''T'' subentity,2 datacnd,
		r.mfield entityrelfld,
		allowduplicate,axpflds.tablename,dcname,ordno,d.caption,d.asgrid,case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,
		encrypted,masking,lastcharmask,firstcharmask,maskchar,maskroles,customdecimal	
		from axpflds join tstructs t on axpflds.tstruct = t.name join axpdc d on axpflds.tstruct = d.tstruct and axpflds.dcname = d.dname
		left join axentityrelations r on axpflds.tstruct = r.dstruct and axpflds.fname = r.dfield and r.mstruct=''',ptransid,'''
		left join axlanguage l on substring(l.sname FROM 2)=''',rec.dstruct,''' and lower(l.dispname)=''',lower(planguage),''' and axpflds.fname = l.compname
		left join axlanguage lf on substring(lf.sname FROM 2)= t.name and lower(lf.dispname)=''',lower(planguage),''' and lf.compname=''x__headtext''		
		where axpflds.tstruct=','''',rec.dstruct,''' and savevalue =''T'' 
		union all select ','''',rec.dstruct,''',null,''sourceid'',''sourceid'',''Simple Text'',''c'',''accept'',''T'',
		null,''F'',null,null,null,''F'',null,''F'',''F'',''T'',2,''recordid'',''T'',','''',rec.dprimarytable,'''',',null,1000,null,''F'',''F'',
		null encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
		from dual where ''gm''=','''',rec.rtype,'''') into v_subentitysql;


	   	

	    for r in execute v_subentitysql
      		loop	    	
        		RETURN NEXT r; -- return current row of select        		
        	END LOOP;


    END LOOP;


end if;

END; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_pegstatus(ptransid character varying, precordid numeric)
 RETURNS TABLE(axpeg_processname character varying, axpeg_keyvalue character varying, axpeg_status numeric, axpeg_statustext text, axpeg_recordid numeric)
 LANGUAGE plpgsql
AS $function$
declare 
v_pegtable text;
v_pegstatus numeric;

begin
	
	execute 'select status from axpeg_'||ptransid||' where recordid ='||precordid into v_pegstatus;

if v_pegstatus  in(1,2) then 

	return query execute 'select processname axpeg_processname,keyvalue axpeg_keyvalue,status::numeric axpeg_status,statustext::text axpeg_statustext,recordid::numeric axpeg_recordid from axpeg_'||ptransid||' 
where status in (1,2) and recordid ='||precordid;
else
return query execute 'select a.processname,keyvalue,0::numeric status,concat(a.taskname,'' is pending '',string_agg(a.touser,'','')) statustext
,recordid::numeric
from vw_pegv2_activetasks a 
where  a.recordid='||precordid||'
group by a.processname,a.keyvalue,a.taskname,a.recordid';

end if;

exception when others then null;


END; $function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_se_chartdata(pcriteria character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
rec record;
v_subentitytable varchar;
v_transid varchar;
v_operations varchar;
v_aggfnc varchar;
v_tablename varchar;
v_sql text;
v_keyfld_fname varchar;
v_keyfld_fval varchar;
v_keyfld_srckey varchar;
v_keyfld_srctbl varchar;
v_keyfld_srcfld varchar;
v_final_sqls text[] DEFAULT  ARRAY[]::text[];
v_fldname_transidcnd numeric;

begin

--criteria - transid~opr1,opr2,opr3~normalized~srctable~srcfld~allowempty~tablename~keyfld~keyval

		    FOR rec IN
	    	    select unnest(string_to_array(pcriteria,'^')) criteria
		    loop		    			    
	      		v_transid := split_part(rec.criteria,'~',1);
				v_operations := split_part(rec.criteria,'~',2);
				v_keyfld_srckey := split_part(rec.criteria,'~',3);
				v_keyfld_srctbl := split_part(rec.criteria,'~',4);
				v_keyfld_srcfld := split_part(rec.criteria,'~',5);
	      		v_tablename := split_part(rec.criteria,'~',7);
				v_keyfld_fname := split_part(rec.criteria,'~',8);
				v_keyfld_fval := split_part(rec.criteria,'~',9);
				
				

				select tablename into v_subentitytable from axpdc where tstruct = v_transid and dname ='dc1';				
			
				select count(1) into v_fldname_transidcnd from axpflds where tstruct = v_transid and dcname ='dc1' and lower(fname)='transid';

							
				if lower(v_tablename)=lower(v_subentitytable) then
			
				 v_sql := concat('select ','''',v_transid,'''transid,',v_operations,',''General''::varchar cnd,','''',replace(rec.criteria,'''',''),'''  criteria from '
								,v_tablename
								,case when v_keyfld_srckey='T' then ' join '||v_keyfld_srctbl||' on '||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id = '||v_tablename||'.'||v_keyfld_fname end
								,' where ',v_tablename,'.cancel=''F'' and ',
				case when v_fldname_transidcnd > 0 then concat(v_tablename,'.transid=''',v_transid,''' and ') end
				 ,case when v_keyfld_srckey='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else v_keyfld_fname end,'=',v_keyfld_fval);				
				
				else 
				
				v_sql := concat('select ','''',v_transid,'''transid,',v_operations,',''General''::varchar cnd,','''',replace(rec.criteria,'''',''),'''  criteria from '
								,v_tablename,' a join ',v_subentitytable,' b on a.',v_subentitytable,'id=b.',v_subentitytable,'id '
								,case when v_keyfld_srckey='T' then ' join '||v_keyfld_srctbl||' on '||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id = a.'||v_keyfld_fname end
								,' where b.cancel=''F'' and ',
				case when v_fldname_transidcnd > 0 then concat(' b.transid=''',v_transid,''' and ') end
				 ,case when v_keyfld_srckey='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else v_keyfld_fname end,'=',v_keyfld_fval);
				
					
				end if;
			
				v_final_sqls := array_append(v_final_sqls,v_sql);			
			
			END LOOP;	
		

 
   return array_to_string(v_final_sqls,'^^^') ;

END;
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_se_listdata(pentity_transid character varying, pflds_keyval text, ppagesize numeric DEFAULT 50, ppageno numeric DEFAULT 1)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
rec record;
rec1 record;
rec2 record;
v_sql text;
v_sql1 text;
v_fldname_table varchar;
v_fldname_col varchar;
v_fldname_normalized varchar;
v_fldname_srctbl varchar;
v_fldname_srcfld varchar;
v_fldname_allowempty varchar;
v_fldname_transidcnd numeric;
v_allflds varchar;
v_fldnamesary varchar[] DEFAULT  ARRAY[]::varchar[];
v_fldname_join varchar;
v_fldname_tblflds text;
v_fldname_joinsary varchar[] DEFAULT  ARRAY[]::varchar[];
v_emptyary varchar[] DEFAULT  ARRAY[]::varchar[];
v_pflds_transid varchar;
v_pflds_flds varchar;
v_pflds_keyvalue varchar;
v_pflds_keytable varchar;
v_keyvalue_fname varchar;
v_keyvalue_fvalue varchar;
v_keyvalue_fname_srckey varchar;
v_keyvalue_fname_srctbl varchar;
v_keyvalue_fname_srcfld varchar;
v_final_sqls text[] DEFAULT  ARRAY[]::text[];
v_primarydctable varchar;
v_fldname_dcjoinsary varchar[] DEFAULT  ARRAY[]::varchar[];

begin	

	/*
	 * transid=fldlist=dependfld~depvalue~dependtblname~dependfldprops++transid2=fldlist=dependfld~depvalue
	 * pflds_keyval - transid=tablename!~fldname~normalized~source_table~source_fld~allowempty|fldname2~normalized~source_table~source_fld~allowempty^tablename2!~fldname~normalized~srctbl~srcfld~allowempty=dependfld~dependval++
	 * transid2=tablename!~fldname~normalized~source_table~source_fld~allowempty|fldname2~normalized~source_table~source_fld~allowempty=dependfld~dependval		 
	 */
	
	
	FOR rec in select unnest(string_to_array(pflds_keyval,'++')) fldkeyvals ---- multiple transid split   	 
    loop
	    	
	    	v_pflds_transid := split_part(rec.fldkeyvals,'=',1) ;	    	
	    	v_pflds_flds := split_part(rec.fldkeyvals,'=',2) ;--tablename=~fldname~normalized~source_table~source_fld~mandatory|fldname2~normalized~source_table~source_fld~mandatory^tablename2=~fldname~normalized~srctbl~srcfld~mandatory
	    	v_pflds_keyvalue := split_part(rec.fldkeyvals,'=',3) ;
	    	v_pflds_keytable := split_part(v_pflds_keyvalue,'~',3) ;  	    
			v_keyvalue_fname := split_part(v_pflds_keyvalue,'~',1);
			v_keyvalue_fvalue := split_part(v_pflds_keyvalue,'~',2);		
			v_keyvalue_fname_srckey := split_part(v_pflds_keyvalue,'~',4) ;
			v_keyvalue_fname_srctbl := split_part(v_pflds_keyvalue,'~',5) ;
			v_keyvalue_fname_srcfld := split_part(v_pflds_keyvalue,'~',6) ;		
						
	    	

	    	select tablename into v_primarydctable from axpdc where tstruct =v_pflds_transid and dname ='dc1';
	    
	    	select count(1) into v_fldname_transidcnd from axpflds where tstruct = v_pflds_transid and dcname ='dc1' and lower(fname)='transid';
	    	    	    
	    
	    	if lower(v_pflds_keytable) = lower(v_primarydctable) and v_pflds_flds ='All' then
		    	select concat(tablename ,'!~',string_agg(str,'|'))  into v_allflds From(
				select tablename,concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~',allowempty) str
				from axpflds where tstruct=v_pflds_transid and 
				dcname ='dc1' and 
				asgrid ='F' and hidden ='F' and savevalue='T' and datatype not in('i','t')
				order by dcname ,ordno)a group by a.tablename;
			elsif lower(v_pflds_keytable) != lower(v_primarydctable) and v_pflds_flds ='All' then
				select concat(tablename ,'!~',string_agg(str,'|'),'^',v_pflds_keytable,'!~',split_part(split_part(v_pflds_keyvalue,'~',1),'.',2),'~',split_part(v_pflds_keyvalue,'~',4),'~',split_part(v_pflds_keyvalue,'~',5),'~',split_part(v_pflds_keyvalue,'~',6),'~',split_part(v_pflds_keyvalue,'~',7))  into v_allflds From(
				select tablename,concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~',allowempty) str
				from axpflds where tstruct=v_pflds_transid and 
				dcname ='dc1' and 
				asgrid ='F' and hidden ='F' and savevalue='T' and datatype not in('i','t')
				order by dcname ,ordno)a group by a.tablename;				
		    end if;
	    
	    for rec1 in select unnest(string_to_array(case when v_pflds_flds='All' then v_allflds else v_pflds_flds end,'^')) tblflds --single transid & single table split --tablename=~fldname~normalized~source_table~source_fld~mandatory|fldname2~normalized~source_table~source_fld~mandatory 
	    	loop		    			    			    			     
		    		v_fldname_table := 	split_part(rec1.tblflds,'!~',1);
		    		v_fldname_tblflds := 	split_part(rec1.tblflds,'!~',2);
		    		
		    	if lower(v_fldname_table)!=lower(v_primarydctable) then
					v_fldname_dcjoinsary := array_append(v_fldname_dcjoinsary,concat('left join ',v_fldname_table,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_fldname_table,'.',v_primarydctable,'id') );		    							
				end if;
		    
				if lower(v_fldname_table)!=lower(v_pflds_keytable) then
					v_fldname_dcjoinsary := array_append(v_fldname_dcjoinsary,concat('left join ',v_pflds_keytable,' on ',v_primarydctable,'.',v_primarydctable,'id=',v_pflds_keytable,'.',v_primarydctable,'id') );		    							
				end if;
				
					if v_keyvalue_fname_srckey='T' then 
							v_fldname_joinsary := array_append(v_fldname_joinsary,concat(' join ' ,v_keyvalue_fname_srctbl,' ',' on ',v_keyvalue_fname,' = ',v_keyvalue_fname_srctbl,'.',v_keyvalue_fname_srctbl,'id')::Varchar);
					
							end if;
							
		
		    			    	
			    FOR rec2 in			    	
    				select unnest(string_to_array(v_fldname_tblflds,'|')) fldname--tablename=~fldname~normalized~source_table~source_fld~mandatory
						loop							
							v_fldname_col := split_part(rec2.fldname,'~',1);
							v_fldname_normalized := split_part(rec2.fldname,'~',2);
							v_fldname_srctbl := split_part(rec2.fldname,'~',3);
							v_fldname_srcfld := split_part(rec2.fldname,'~',4);														
							v_fldname_allowempty := split_part(rec2.fldname,'~',5);
								
						
							
							
							
							if v_fldname_normalized ='F' then 
								v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_table,'.',v_fldname_col)::varchar);
							elsif v_fldname_normalized ='T' then	
								v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_col,'.',v_fldname_srcfld,' ',v_fldname_col)::varchar);	
								
								v_fldname_joinsary := array_append(v_fldname_joinsary,concat(case when v_fldname_allowempty='F' then ' join ' else ' left join ' end,v_fldname_srctbl,' ',v_fldname_col,' on ',v_fldname_table,'.',v_fldname_col,' = ',v_fldname_col,'.',v_fldname_srctbl,'id')::Varchar);
							end if;								
												
						

						

			    		end loop;
		   end loop;
		  
		  v_fldname_dcjoinsary := ARRAY(SELECT DISTINCT UNNEST(v_fldname_dcjoinsary));	
		  v_fldname_joinsary := ARRAY(SELECT DISTINCT UNNEST(v_fldname_joinsary));
		
		   
		   	v_sql := concat(' select ','''',v_pflds_transid,''' transid,',v_primarydctable,'.',v_primarydctable,'id recordid,',v_primarydctable,'.username modifiedby,',v_primarydctable,'.modifiedon,',v_primarydctable,'.createdon,',v_primarydctable,'.createdby,',
		   			 array_to_string(v_fldnamesary,','),',null axpeg_processname,null axpeg_keyvalue,null axpeg_status,null axpeg_statustext from ',v_primarydctable,' ',array_to_string(v_fldname_dcjoinsary,' '),' ',array_to_string(v_fldname_joinsary,' '),
		   			--' left join fn_axpanalytics_pegstatus(''',v_pflds_transid,''',',v_primarydctable,'.',v_primarydctable,'id) b on ',v_primarydctable,'.',v_primarydctable,'id=b.axpeg_recordid',
					' where ',v_primarydctable,'.cancel=''F'' and ',case when v_fldname_transidcnd>0 then concat(v_primarydctable,'.transid=','''',v_pflds_transid,''' and ') end ,
					case when v_keyvalue_fname_srckey='T'  then v_keyvalue_fname_srctbl||'.'||v_keyvalue_fname_srcfld else v_keyvalue_fname end ,'=',v_keyvalue_fvalue,'
					--axp_filter
					');

		   				v_fldnamesary:= v_emptyary;
		   				v_fldname_joinsary:= v_emptyary;	   				
		   				v_fldname_dcjoinsary:= v_emptyary;	   				
	 
	    
	    
	   v_sql1 := concat('select * from(select a.*,row_number() over(order by modifiedon desc)::Numeric rno,
			case when mod(row_number() over(order by modifiedon desc),',ppagesize,')=0 then row_number() over(order by modifiedon desc)/',ppagesize,' else row_number() over(order by modifiedon desc)/',ppagesize,'+1 end::numeric pageno from 
			(',v_sql,')a order by modifiedon desc limit ',ppagesize*ppageno,' )b ',case when ppageno=0 then '' else concat('where pageno=',ppageno) end);
		
		
		
v_final_sqls := array_append(v_final_sqls,v_sql1);

    END LOOP;
  
    return array_to_string(v_final_sqls,'^^^') ;

END;
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_dac_masterdata(pmtransid character varying, pmfldname character varying, pminctransid numeric, pmcnd numeric)
 RETURNS TABLE(datavalue character varying)
 LANGUAGE plpgsql
AS $function$
declare 
v_sql text;
v_mastertable varchar(50);
begin
	
	
	if pmcnd = 2 then 
	select tablename into v_mastertable from axpflds where tstruct = pmtransid and fname = pmfldname;
	else 
	v_mastertable = pmtransid;
	end if; 	

	v_sql := concat('select distinct ',pmfldname,' from ',v_mastertable,case when pminctransid = 0 then null else concat('where transid = ','''',pmtransid,'''') end );
					
	

return query execute v_sql;

exception when others then null;

END; 
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_axrelations()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    
    begin

	delete from axentityrelations where mstruct = new.mstruct and mfield = new.mfield and dstruct = new.dstruct and dfield = new.dfield and 'md' = new.rtype;

	delete from axentityrelations where mstruct = new.mstruct and dstruct = new.dstruct  and 'gm' = new.rtype;
	
	insert into axentityrelations ( 
axentityrelationsid,cancel,username,modifiedon,createdby,createdon,app_level,app_desc,
rtype,mstruct,mfield,mtable,primarytable,dstruct,dfield,dtable,rtypeui,mstructui,mfieldui,dstructui,dfieldui,dprimarytable)    
	SELECT DISTINCT nextval('ax_entity_relseq'::regclass) AS axentityrelationsid,
    'F' AS cancel,
    'admin' AS username,
    CURRENT_TIMESTAMP AS modifiedon,
    'admin' AS createdby,
    CURRENT_TIMESTAMP AS createdon,
    1 AS app_level,
    1 AS app_desc,
    new.rtype,
    new.mstruct,
    new.mfield,
    m.tablename AS mtable,
    dc.tablename AS primarytable,
    new.dstruct,
    new.dfield,
    d.tablename AS dtable,
    'Dropdown' AS rtypeui,
    concat(mt.caption, '-(', mt.name, ')') AS mstructui,
    concat(m.caption, '-(', m.fname, ')') AS mfieldui,
    concat(dt.caption, '-(', dt.name, ')') AS dstructui,
    concat(d.caption, '-(', d.fname, ')') AS dfieldui,
    ddc.tablename AS dprimarytable
   FROM tstructs mt 
     JOIN tstructs dt ON new.dstruct = dt.name
     LEFT JOIN axpflds m ON new.mstruct = m.tstruct AND new.mfield = m.fname
     LEFT JOIN axpflds d ON new.dstruct = d.tstruct AND new.dfield = d.fname
     LEFT JOIN axpdc dc ON new.mstruct = dc.tstruct AND dc.dname = 'dc1'
     LEFT JOIN axpdc ddc ON new.dstruct = ddc.tstruct AND ddc.dname = 'dc1'
  WHERE new.rtype = 'md' and new.mstruct = mt.name
UNION ALL
 SELECT DISTINCT nextval('ax_entity_relseq'::regclass) AS axentityrelationsid,
    'F' AS cancel,
    'admin' AS username,
    CURRENT_TIMESTAMP AS modifiedon,
    'admin' AS createdby,
    CURRENT_TIMESTAMP AS createdon,
    1 AS app_level,
    1 AS app_desc,
    'gm'::character varying AS rtype,
    new.mstruct AS mstruct,  
null mfield,   
	null as mtable,
    pd.tablename AS primarytable,
    new.dstruct,
    'sourceid'::character varying AS dfield,
    td.tablename AS dtable,
    'Genmap' AS rtypeui,
    concat(mt.caption, '-(', mt.name, ')') AS mstructui,
    NULL AS mfieldui,
    concat(dt.caption, '-(', dt.name, ')') AS dstructui,
    NULL AS dfieldui,
    td.tablename AS dprimarytable
   FROM tstructs mt 
     JOIN tstructs dt ON new.dstruct = dt.name
     LEFT JOIN axpdc td ON new.dstruct = td.tstruct AND td.dname = 'dc1'
     LEFT JOIN axpdc pd ON new.mstruct = pd.tstruct AND pd.dname = 'dc1'
where  new.mstruct = mt.name and 'gm' = new.rtype ;

return new;
  end; 

$function$
;
>>

<<
create trigger trg_axrelations before insert   on axrelations for each row execute function fn_axrelations();
>>

<<
CREATE OR REPLACE FUNCTION fn_axusers_usergrp(pusername character varying, pusergroup character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$ 
begin
	
delete from axpdef_peg_usergroups where username = pusername and fromuser='T';
 
insert into axpdef_peg_usergroups 
select pusername,unnest(string_to_array(pusergroup,',')),unnest(string_to_array(pusergroup,',')),'T',current_date ,'T';
	
end;

$function$
;
>>

<<
CREATE TABLE importdatacompletion (
	id numeric(30) NULL,
	rapidimpid varchar(100) NULL,
	sessionid varchar(30) NULL,
	username varchar(50) NULL,
	calledon timestamp NULL,
	structname varchar(6) NULL,
	filename varchar(200) NULL,
	recordcount numeric(5) NULL,
	success numeric(5) NULL,
	resultmsg varchar(4000) NULL,
	errlist text NULL,
	blobno numeric NULL
);
>>

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
CREATE TABLE ax_htmlplugins (
	name varchar(200) NOT NULL,
	htmltext text NULL,
	context varchar(20) NULL,
	CONSTRAINT ax_htmlplugins_pk PRIMARY KEY (name)
);
>>

<<
CREATE OR REPLACE VIEW vw_cards_dashboard
AS SELECT a.cardtype,
    a.cardname,
    a.cardicon,
    a.charttype,
    a.pluginname,
        CASE
            WHEN a.pluginname IS NULL THEN a.html_editor_card
            ELSE h.htmltext
        END AS htmltext,
    a.card_datasource,
    s.sqltext,
    a.width,
    a.height,
    a.autorefresh,
    unnest(string_to_array(a.accessstringui::text, ','::text)) AS uroles,
    a.axp_cardsid,
    h.context,
    a.orderno,
    a.chartjson
   FROM axp_cards a
     LEFT JOIN ax_htmlplugins h ON a.pluginname::text = h.name::text
     LEFT JOIN axdirectsql s ON a.card_datasource::text = s.sqlname::text
  WHERE a.indashboard::text = 'T'::text;
>>

<<
CREATE OR REPLACE VIEW vw_cards_homepages
AS SELECT a.cardtype,
    a.cardname,
    a.cardicon,
    a.charttype,
    a.pluginname,
        CASE
            WHEN a.pluginname IS NULL THEN a.html_editor_card
            ELSE h.htmltext
        END AS htmltext,
    a.card_datasource,
    s.sqltext,
    a.width,
    a.height,
    a.autorefresh,
    unnest(string_to_array(a.accessstringui::text, ','::text)) AS uroles,
    a.axp_cardsid,
    h.context,
    a.orderno,
    a.chartjson
   FROM axp_cards a
     LEFT JOIN ax_htmlplugins h ON a.pluginname::text = h.name::text
     LEFT JOIN axdirectsql s ON a.card_datasource::text = s.sqlname::text
  WHERE a.inhomepage::text = 'T'::text;
>>

<<
CREATE OR REPLACE FUNCTION t1_axlanguage11x()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
	
	    begin
	 insert into axlanguage(lngname,sname,fontname,fontsize,compname,compcaption,comphint,dispname) 
	 values(new.lngname,new.sname,new.fontname,new.fontsize,new.compname,new.compcaption,new.comphint,new.dispname );
	

EXCEPTION
   WHEN unique_violation
  then update 	axlanguage set fontname=new.fontname,fontsize=new.fontsize,compcaption=new.compcaption,comphint=new.comphint,dispname=new.dispname
 where  concat(lngname,sname,compname)=concat(new.lngname,new.sname,new.compname);
end;


 RETURN NEW;

end;    
$function$
;
>>

<<
create trigger t1_axlanguage11x after
insert
    on
    axlanguage11x for each row execute function t1_axlanguage11x()
>>

<<
CREATE OR REPLACE FUNCTION fn_get_query_cols(pquery text)
 RETURNS TABLE(column_list character varying)
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
   EXECUTE 'CREATE TEMP TABLE vtmp1 ON COMMIT DROP AS ' ||pquery|| ' limit 1';
   EXECUTE 'CREATE TEMP TABLE vtmp2 ON COMMIT DROP AS select column_name::varchar from INFORMATION_SCHEMA.COLUMNS where table_name =''vtmp1'' ';

     RETURN QUERY TABLE vtmp2;
END
$function$
;
>>

<<
CREATE OR REPLACE VIEW vw_axlanguage_export
AS SELECT 'tstruct'::text AS comptype,
    0 AS ord,
    't'::text || tstructs.name::text AS ntransid,
    'x__headtext'::character varying AS compname,
    tstructs.caption,
    0 AS ord2,
    0 AS ord3,
    'NA'::text AS hidden
   FROM tstructs
UNION ALL
 SELECT 'tstruct'::text AS comptype,
    1 AS ord,
    't'::text || axpdc.tstruct::text AS ntransid,
    axpdc.dname AS compname,
    axpdc.caption,
    "substring"(axpdc.dname::text, 3)::numeric AS ord2,
    "substring"(axpdc.dname::text, 3)::numeric AS ord3,
    'NA'::text AS hidden
   FROM axpdc
UNION ALL
 SELECT 'tstruct'::text AS comptype,
    2 AS ord,
    't'::text || axpflds.tstruct::text AS ntransid,
    axpflds.fname AS compname,
    axpflds.caption,
    "substring"(axpflds.dcname::text, 3)::numeric AS ord2,
    axpflds.ordno AS ord3,
        CASE
            WHEN axpflds.hidden::text = 'TRUE'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS hidden
   FROM axpflds
UNION ALL
 SELECT 'tstruct'::text AS comptype,
    4 AS ord,
    't'::text || axtoolbar.name::text AS ntransid,
    axtoolbar.key AS compname,
    axtoolbar.title AS caption,
    '100'::numeric AS ord2,
    axtoolbar.ordno AS ord3,
    'NA'::text AS hidden
   FROM axtoolbar
  WHERE axtoolbar.stype::text = 'tstruct'::text
UNION ALL
 SELECT 'tstruct'::text AS comptype,
    5 AS ord,
    't'::text || b.name::text AS ntransid,
    a.ctype AS compname,
    a.ccaption AS caption,
    a.ord AS ord2,
    0 AS ord3,
    'NA'::text AS hidden
   FROM ( SELECT 'pop1'::text AS ctype,
            'Remove'::text AS ccaption,
            10001 AS ord
        UNION ALL
         SELECT 'pop2'::text AS text,
            'Print'::text AS text,
            10002
        UNION ALL
         SELECT 'pop3'::text AS text,
            'Preview'::text AS text,
            10003
        UNION ALL
         SELECT 'pop4'::text AS text,
            'Regenerate Packets'::text AS text,
            10004
        UNION ALL
         SELECT 'pop5'::text AS text,
            'View History'::text AS text,
            10005
        UNION ALL
         SELECT 'lpop1'::text AS text,
            'Remove'::text AS text,
            10006
        UNION ALL
         SELECT 'lpop2'::text AS text,
            'Print'::text AS text,
            10007
        UNION ALL
         SELECT 'lpop3'::text AS text,
            'Preview'::text AS text,
            10008
        UNION ALL
         SELECT 'lpop4'::text AS text,
            'Params'::text AS text,
            10009
        UNION ALL
         SELECT 'lpop5'::text AS text,
            'Preview Form'::text AS text,
            10010
        UNION ALL
         SELECT 'lpop6'::text AS text,
            'Print Form'::text AS text,
            10011
        UNION ALL
         SELECT 'lpop7'::text AS text,
            'PDF'::text AS text,
            10012
        UNION ALL
         SELECT 'lpop8'::text AS text,
            'Regenerate Packets'::text AS text,
            10013
        UNION ALL
         SELECT 'lpop9'::text AS text,
            'Save As'::text AS text,
            10014
        UNION ALL
         SELECT 'lpop10'::text AS text,
            'To XL'::text AS text,
            10015
        UNION ALL
         SELECT 'lpop11'::text AS text,
            'Rapid XL Export'::text AS text,
            10016
        UNION ALL
         SELECT 'lpop12'::text AS text,
            'View Attachment'::text AS text,
            10017
        UNION ALL
         SELECT 'lblSearh'::text AS text,
            'Search For'::text AS text,
            10018
        UNION ALL
         SELECT 'lblWith'::text AS text,
            'With'::text AS text,
            10019) a,
    tstructs b
UNION ALL
 SELECT 'AxPages'::text AS comptype,
    axpages.levelno AS ord,
    NULL::character varying AS ntransid,
    axpages.name AS compname,
    axpages.caption,
    axpages.ordno AS ord2,
    0 AS ord3,
    'NA'::text AS hidden
   FROM axpages
UNION ALL
 SELECT 'iview'::text AS comptype,
    0 AS ord,
    'i'::text || iviews.name::text AS ntransid,
    'x__head'::character varying AS compname,
    iviews.caption,
    1 AS ord2,
    0 AS ord3,
    'NA'::text AS hidden
   FROM iviews
UNION ALL
 SELECT 'iview'::text AS comptype,
    1 AS ord,
    'i'::text || iviewmain.iname::text AS ntransid,
    'RH1'::character varying AS compname,
    iviewmain.header1 AS caption,
    2 AS ord2,
    0 AS ord3,
    'NA'::text AS hidden
   FROM iviewmain
UNION ALL
 SELECT 'iview'::text AS comptype,
    2 AS ord,
    'i'::text || iviewparams.iname::text AS ntransid,
    iviewparams.pname AS compname,
    iviewparams.pcaption AS caption,
    iviewparams.ordno AS ord2,
    0 AS ord3,
    'NA'::text AS hidden
   FROM iviewparams
UNION ALL
 SELECT 'iview'::text AS comptype,
    3 AS ord,
    'i'::text || iviewcols.iname::text AS ntransid,
    iviewcols.f_name AS compname,
    iviewcols.f_caption AS caption,
    iviewcols.ordno AS ord2,
    0 AS ord3,
    'NA'::text AS hidden
   FROM iviewcols
UNION ALL
 SELECT 'iview'::text AS comptype,
    4 AS ord,
    'i'::text || axtoolbar.name::text AS ntransid,
    axtoolbar.key AS compname,
    axtoolbar.title AS caption,
    axtoolbar.ordno AS ord2,
    0 AS ord3,
    'NA'::text AS hidden
   FROM axtoolbar
  WHERE axtoolbar.stype::text = 'iview'::text
UNION ALL
 SELECT 'iview'::text AS comptype,
    5 AS ord,
    'i'::text || b.name::text AS ntransid,
    a.ctype AS compname,
    a.ccaption AS caption,
    a.ord AS ord2,
    0 AS ord3,
    'NA'::text AS hidden
   FROM iviews b,
    ( SELECT 'anac1'::text AS ctype,
            'Column Heading'::text AS ccaption,
            1 AS ord
        UNION ALL
         SELECT 'anac2'::text AS text,
            'Operator'::text AS text,
            2
        UNION ALL
         SELECT 'anac3'::text AS text,
            'Value (s)'::text AS text,
            3
        UNION ALL
         SELECT 'anac4'::text AS text,
            'Relations'::text AS text,
            4
        UNION ALL
         SELECT 'pop1'::text AS text,
            'Delete'::text AS text,
            5
        UNION ALL
         SELECT 'pop2'::text AS text,
            'New'::text AS text,
            6
        UNION ALL
         SELECT 'pop3'::text AS text,
            'Params'::text AS text,
            7
        UNION ALL
         SELECT 'pop4'::text AS text,
            'Preview Form'::text AS text,
            8
        UNION ALL
         SELECT 'pop5'::text AS text,
            'Print Form'::text AS text,
            9
        UNION ALL
         SELECT 'pop6'::text AS text,
            'PDF'::text AS text,
            10
        UNION ALL
         SELECT 'pop7'::text AS text,
            'Regenerate Packets'::text AS text,
            11
        UNION ALL
         SELECT 'pop8'::text AS text,
            'Save As'::text AS text,
            12
        UNION ALL
         SELECT 'pop9'::text AS text,
            'To XL'::text AS text,
            13
        UNION ALL
         SELECT 'pop10'::text AS text,
            'Rapid XL Export'::text AS text,
            14
        UNION ALL
         SELECT 'pop11'::text AS text,
            'View Attachment'::text AS text,
            15) a;
>>

<<
CREATE TABLE axpublishreport (
	transid varchar(30) NULL,
	publishedon varchar(25) NULL,
	publishedby varchar(30) NULL,
	status varchar(4000) NULL,
	remarks varchar(1000) NULL,
	createdon date DEFAULT now() NULL,
	publishedto varchar(100) NULL,
	transtype varchar(10) NULL
);
>>


<<
DROP TABLE customtypes;
>>

<<
CREATE TABLE customtypes (
	customtypesid numeric(16) NOT NULL,
	cancel varchar(1) NULL,
	sourceid numeric(16) NULL,
	mapname varchar(20) NULL,
	username varchar(50) NULL,
	modifiedon timestamp NULL,
	createdby varchar(50) NULL,
	createdon timestamp NULL,
	wkid varchar(15) NULL,
	app_level numeric(3) NULL,
	app_desc numeric(1) NULL,
	app_slevel numeric(3) NULL,
	cancelremarks varchar(150) NULL,
	wfroles varchar(250) NULL,
	typename varchar(20) NULL,
	"datatype" varchar(10) NULL,
	width numeric(4) NULL,
	deci numeric(5, 3) NULL,
	namecheck varchar(30) NULL,
	replacechar varchar(30) NULL,
	fcharcheck varchar(30) NULL,
	validchk varchar(30) NULL,
	modeofentry varchar(20) NULL,
	cvalues varchar(100) NULL,
	defaultvalue varchar(100) NULL,
	sql_editor_details varchar(500) NULL,
	exp_editor_expression varchar(200) NULL,
	exp_editor_validateexpression varchar(200) NULL,
	readonly varchar(10) NULL,
	chide varchar(1) NULL,
	cpattern varchar(20) NULL,
	cmask varchar(50) NULL,
	cregularexpress varchar(500) NULL,
	CONSTRAINT aglcustomtypesid PRIMARY KEY (customtypesid));
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1065440000000, 'F', 0, NULL, 'admin', '2020-10-30 11:50:42.000', 'admin', '2020-09-15 17:31:04.000', NULL, 1, 1, NULL, NULL, NULL, 'Random Number', 'Numeric', 10, 0.000, 'ADD', 'Random Number', 'T', 'T', 'Accept', '', '', '', '', '', 'F', 'F', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1055660000007, 'F', 0, NULL, 'admin', '2020-09-12 13:37:11.000', 'admin', '2020-09-12 09:39:26.000', NULL, 1, 1, NULL, NULL, NULL, 'Date', 'Date/Time', 10, 0.000, 'ADD', 'Date', 'T', 'T', 'Accept', '', '', '', 'Date()', '', '', '', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1056880000000, 'F', 0, NULL, 'admin', '2020-09-14 14:57:46.000', 'admin', '2020-09-14 14:57:46.000', NULL, 1, 1, NULL, NULL, NULL, 'Short Text', 'Character', 10, 0.000, 'ADD', 'Short Text', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1055660000009, 'F', 0, NULL, 'admin', '2020-09-15 11:27:42.000', 'admin', '2020-09-12 09:42:14.000', NULL, 1, 1, NULL, NULL, NULL, 'Auto Generate', 'Character', 20, 0.000, 'ADD', 'Auto Generate', 'T', 'T', 'AutoGenerate', '', '', '', '', '', 'T', '', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1055660000003, 'F', 0, NULL, 'admin', '2020-09-15 14:23:29.000', 'admin', '2020-09-12 09:37:34.000', NULL, 1, 1, NULL, NULL, NULL, 'HTML Text', 'Text', 4000, 0.000, 'ADD', 'HTML Text', 'T', 'T', 'Accept', '', '', '', '', '', '', '', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1055660000002, 'F', 0, NULL, 'admin', '2020-09-15 14:23:55.000', 'admin', '2020-09-12 09:37:09.000', NULL, 1, 1, NULL, NULL, NULL, 'Rich Text', 'Text', 4000, 0.000, 'ADD', 'Rich Text', 'T', 'T', 'Accept', '', '', '', '', '', '', '', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1055660000004, 'F', 0, NULL, 'admin', '2020-09-15 14:24:09.000', 'admin', '2020-09-12 09:38:05.000', NULL, 1, 1, NULL, NULL, NULL, 'Whole Number', 'Numeric', 10, 0.000, 'ADD', 'Whole Number', 'T', 'T', 'Accept', '', '', '', '', '', '', '', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1055660000000, 'F', 0, NULL, 'admin', '2020-09-15 14:24:39.000', 'admin', '2020-09-12 09:36:21.000', NULL, 1, 1, NULL, NULL, NULL, 'Simple Text', 'Character', 50, 0.000, 'ADD', 'Simple Text', 'T', 'T', 'Accept', '', '', '', '', '', '', '', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1055660000008, 'F', 0, NULL, 'admin', '2020-09-15 14:24:53.000', 'admin', '2020-09-12 09:39:45.000', NULL, 1, 1, NULL, NULL, NULL, 'Time', 'Character', 10, 0.000, 'ADD', 'Time', 'T', 'T', 'Accept', '', '', '', '', '', '', '', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1055660000006, 'F', 0, NULL, 'admin', '2020-09-15 14:25:08.000', 'admin', '2020-09-12 09:38:56.000', NULL, 1, 1, NULL, NULL, NULL, 'Currency', 'Numeric', 10, 2.000, 'ADD', 'Currency', 'T', 'T', 'Accept', '', '', '', '', '', '', '', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1055660000005, 'F', 0, NULL, 'admin', '2020-09-15 15:17:38.000', 'admin', '2020-09-12 09:38:31.000', NULL, 1, 1, NULL, NULL, NULL, 'Decimal Number', 'Numeric', 10, 2.000, 'ADD', 'Decimal Number', 'T', 'T', 'Accept', '', '', '', '', '', '', '', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1065550000000, 'F', 0, NULL, 'admin', '2020-09-15 17:31:30.000', 'admin', '2020-09-15 17:31:30.000', NULL, 1, 1, NULL, NULL, NULL, 'Email', 'Character', 50, 0.000, 'ADD', 'Email', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1065660000000, 'F', 0, NULL, 'admin', '2020-09-15 17:32:07.000', 'admin', '2020-09-15 17:32:07.000', NULL, 1, 1, NULL, NULL, NULL, 'URL', 'Character', 100, 0.000, 'ADD', 'URL', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1065880000000, 'F', 0, NULL, 'admin', '2020-09-15 17:32:55.000', 'admin', '2020-09-15 17:32:55.000', NULL, 1, 1, NULL, NULL, NULL, 'Password', 'Character', 15, 0.000, 'ADD', 'Password', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1065990000000, 'F', 0, NULL, 'admin', '2020-09-15 17:33:55.000', 'admin', '2020-09-15 17:33:55.000', NULL, 1, 1, NULL, NULL, NULL, 'Mobile Number', 'Numeric', 10, 0.000, 'ADD', 'Mobile Number', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1066010000000, 'F', 0, NULL, 'admin', '2020-09-15 17:34:16.000', 'admin', '2020-09-15 17:34:16.000', NULL, 1, 1, NULL, NULL, NULL, 'Phone Number', 'Numeric', 10, 0.000, 'ADD', 'Phone Number', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1066110000000, 'F', 0, NULL, 'admin', '2020-09-15 17:34:36.000', 'admin', '2020-09-15 17:34:36.000', NULL, 1, 1, NULL, NULL, NULL, 'Pin Code', 'Numeric', 6, 0.000, 'ADD', 'Pin Code', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1066220000000, 'F', 0, NULL, 'admin', '2020-09-15 17:34:58.000', 'admin', '2020-09-15 17:34:58.000', NULL, 1, 1, NULL, NULL, NULL, 'Zip Code', 'Numeric', 6, 0.000, 'ADD', 'Zip Code', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1065770000000, 'F', 0, NULL, 'admin', '2020-09-16 10:11:07.000', 'admin', '2020-09-15 17:32:28.000', NULL, 1, 1, NULL, NULL, NULL, 'IP Address', 'Character', 100, 0.000, 'ADD', 'IP Address', 'T', 'T', 'Accept', '', '', '', '', '', 'F', 'F', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1100220000000, 'F', 0, NULL, 'admin', '2020-09-30 10:44:32.000', 'admin', '2020-09-30 10:44:32.000', NULL, 1, 1, NULL, NULL, NULL, 'Table', 'Character', 2000, 0.000, 'ADD', 'Table', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1078330000000, 'F', 0, NULL, 'admin', '2020-09-30 14:34:24.000', 'admin', '2020-09-25 10:50:28.000', NULL, 1, 1, NULL, NULL, NULL, 'DropDown', 'Character', 20, 0.000, 'ADD', 'DropDown', 'T', 'T', 'Select From Form', '', '', '', '', '', 'F', 'F', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1139550000000, 'F', 0, NULL, 'admin', '2020-10-21 17:12:41.000', 'admin', '2020-10-21 17:12:41.000', NULL, 1, 1, NULL, NULL, NULL, 'Expression Editor', 'Character', 300, 0.000, 'ADD', 'Expression Editor', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1139440000000, 'F', 0, NULL, 'admin', '2020-10-21 17:13:09.000', 'admin', '2020-10-21 17:08:31.000', NULL, 1, 1, NULL, NULL, NULL, 'SQL Editor', 'Character', 2000, 0.000, 'ADD', 'SQL Editor', 'T', 'T', 'Accept', '', '', '', '', '', 'F', 'F', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1200660000000, 'F', 0, NULL, 'admin', '2020-11-24 15:18:20.000', 'admin', '2020-11-24 15:18:20.000', NULL, 1, 1, NULL, NULL, NULL, 'Image', 'Image', 50, 0.000, 'ADD', 'Image', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1215880000000, 'F', 0, NULL, 'admin', '2020-12-02 12:15:06.000', 'admin', '2020-12-01 13:09:13.000', NULL, 1, 1, NULL, NULL, NULL, 'RadioGroup', 'Character', 50, 0.000, 'ADD', 'RadioGroup', 'T', 'T', 'Select From Form', '', '', '', '', '', 'F', 'F', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1215770000000, 'F', 0, NULL, 'admin', '2020-12-01 13:35:40.000', 'admin', '2020-12-01 13:08:45.000', NULL, 1, 1, NULL, NULL, NULL, 'Check box', 'Character', 20, 0.000, 'ADD', 'Check box', 'T', 'T', 'Accept', '', '', '', '', '', 'F', 'F', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1215660000000, 'F', 0, NULL, 'admin', '2020-12-02 12:14:54.000', 'admin', '2020-12-01 13:08:19.000', NULL, 1, 1, NULL, NULL, NULL, 'CheckList', 'Character', 50, 0.000, 'ADD', 'CheckList', 'T', 'T', 'Select From Form', '', '', '', '', '', 'F', 'F', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1245880000000, 'F', 0, NULL, 'admin', '2020-12-09 15:29:42.000', 'admin', '2020-12-09 15:29:42.000', NULL, 1, 1, NULL, NULL, NULL, 'Multi Select', 'Character', 200, 0.000, 'ADD', 'Multi Select', 'T', 'T', 'Select From Form', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1055660000001, 'F', 0, NULL, 'admin', '2020-09-15 10:58:45.000', 'admin', '2020-09-12 09:36:46.000', NULL, 1, 1, NULL, NULL, NULL, 'Large Text', 'Text', 4000, 0.000, 'ADD', 'Large Text', 'T', 'T', 'Accept', '', '', '', '', '', '', '', '', '', '');
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1058990000006, 'F', 0, NULL, 'admin', '2022-07-04 12:59:55.000', 'admin', '2022-07-04 12:59:55.000', NULL, 1, 1, NULL, NULL, NULL, 'Address', 'Character', 1000, 0.000, 'ADD', 'Address', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1058990000005, 'F', 0, NULL, 'admin', '2022-07-04 12:59:38.000', 'admin', '2022-07-04 12:59:38.000', NULL, 1, 1, NULL, NULL, NULL, 'Boolean', 'Character', 10, 0.000, 'ADD', 'Boolean', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1058990000004, 'F', 0, NULL, 'admin', '2022-07-04 12:59:13.000', 'admin', '2022-07-04 12:59:13.000', NULL, 1, 1, NULL, NULL, NULL, 'Date Range', 'Character', 500, 0.000, 'ADD', 'Date Range', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1058990000003, 'F', 0, NULL, 'admin', '2022-07-04 12:59:03.000', 'admin', '2022-07-04 12:59:03.000', NULL, 1, 1, NULL, NULL, NULL, 'File upload field', 'Character', 250, 0.000, 'ADD', 'File upload field', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1058990000002, 'F', 0, NULL, 'admin', '2022-07-04 12:58:51.000', 'admin', '2022-07-04 12:58:51.000', NULL, 1, 1, NULL, NULL, NULL, 'Number range', 'Character', 500, 0.000, 'ADD', 'Number range', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1058990000001, 'F', 0, NULL, 'admin', '2022-07-04 12:58:39.000', 'admin', '2022-07-04 12:58:39.000', NULL, 1, 1, NULL, NULL, NULL, 'Time Range', 'Character', 500, 0.000, 'ADD', 'Time Range', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO customtypes (customtypesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, typename, "datatype", width, deci, namecheck, replacechar, fcharcheck, validchk, modeofentry, cvalues, defaultvalue, sql_editor_details, exp_editor_expression, exp_editor_validateexpression, readonly, chide, cpattern, cmask, cregularexpress) VALUES(1058990000000, 'F', 0, NULL, 'admin', '2022-07-04 12:58:25.000', 'admin', '2022-07-04 12:58:25.000', NULL, 1, 1, NULL, NULL, NULL, 'Website', 'Character', 250, 0.000, 'ADD', 'Website', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO axpdef_axpertprops (axpdef_axpertpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, smtphost, smtpport, smtpuser, smtppwd, amtinmillions, currseperator, lastlogin, autogen, customfrom, customto, loginattempt, pwdexp, pwdchange, pwdminchar, pwdreuse, pwdalphanum, pwdencrypt, axpsiteno) VALUES(1, 'F', 0, NULL, 'admin', '2022-01-17 13:28:03.000', 'admin', '2022-01-17 13:28:03.000', NULL, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, 'F', 'F', 'T', 'F', NULL, NULL, 0, 0, 0, 0, 0, 'F', 'F', 0);
>>  

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Disablesplit');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Navigation');
>>

<<
insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property','FetchSize');
>>

<<
insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property','General');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'SaveImage');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'ApplicationTemplate');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'mainPageTemplate');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'WebService Timeout');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Trim IView Data');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Excel Export');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'ExportVerticalAlign');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Autocomplete Search Pattern');
>>

<<
Insert into AXCTX1(AXCONTEXT, ATYPE) Values ('File Upload Limit', 'Property');
>>

<<
Insert into AXCTX1(AXCONTEXT, ATYPE) Values   ('camera option', 'Property');
>>

<<
Insert into AXCTX1(AXCONTEXT, ATYPE) Values ('Date format','Property');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Text');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Lds');
>>

<<
Insert into AXCTX1(AXCONTEXT, ATYPE) Values('GridEdit', 'Property');
>>

<<
Insert into AXCTX1   (AXCONTEXT, ATYPE) Values ('FormLoad', 'Property');
>>

<<
insert into axctx1(axcontext,atype) values ('Multi Select','Property');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Resolve Attachment Path');
>>

<<
insert into axctx1 (axcontext,atype) values ('Custom JavaScript','Property');
>>

<<
insert into axctx1 (axcontext,atype) values ('Custom CSS','Property');
>>

<<
insert into axctx1 (axcontext,atype) values('Auto Save Draft','Property');
>>

<<
insert into axctx1 (axcontext,atype) values('Show keyboard in Hybrid App','Property');
>>
 
<<
INSERT INTO axctx1 (axcontext,atype) values ('Mobile Reports as Table','Property');
>>

<<
INSERT INTO axctx1 (axcontext,atype) values ('Iview Button Style','Property');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'icon path');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Tstruct Button Style');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Apply Mobile UI');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Split Ratio');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Iview Retain Parameters On Next Load');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Fixed Header for Grid');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Iview Responsive Column Width');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Not Fill Dependent Fields');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Fill Dependent Fields');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Striped Reports UI');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'HomePageTemplate');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'CompressedMode');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Upload file types');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Autosplit');
>>

<<
insert into axctx1(atype,axcontext) values('Property','Google Maps Zoom');
>>

<<
insert into axctx1(atype,axcontext) values('Property','Iview Session Caching');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'column separator for reports');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Popup fillgrid data based on query order');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Popup fillgrid data show all');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Unicode support for PDF export');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Auto column width for report based on data');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000220000000, 'F', 0, NULL, 'admin', '2022-12-26 14:22:37.000', 'admin', '2019-11-15 15:17:24.000', NULL, 1, 1, NULL, NULL, NULL, 'ExportVerticalAlign', 'ExportVerticalAlign', 'allows you to set excel row data vertical aligned', 'configtypeExportVerticalAlign', '', 'Iview', 'F', 'F', 'T', 'F', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000220000004, 'F', 0, NULL, 'admin', '2022-12-26 14:24:57.000', 'admin', '2019-11-15 15:17:43.000', NULL, 1, 1, NULL, NULL, NULL, 'Excel Export', 'Excel Export', 'enable Excel button in reports to download the report data into excel format', 'configtypeExcel Export', '', 'Iview', 'F', 'F', 'T', 'F', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000220000007, 'F', 0, NULL, 'admin', '2022-12-26 14:26:51.000', 'admin', '2019-11-15 15:17:58.000', NULL, 1, 1, NULL, NULL, NULL, 'Trim IView Data', 'Trim IView Data', 'Enable/Disable to trim spaces in iview data', 'configtypeTrim IView Data', '', 'Iview', 'F', 'F', 'T', 'F', 'T', '');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000220000012, 'F', 0, NULL, 'admin', '2022-12-26 14:28:28.000', 'admin', '2019-11-15 15:18:35.000', NULL, 1, 1, NULL, NULL, NULL, 'ApplicationCompressedMode', 'General', 'This property will allow you to fit the page on screen, it will disable the card layout of the application.', 'configtypeApplicationCompressedMode', '', 'Common', 'F', 'F', 'F', 'F', 'F', '');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000220000015, 'F', 0, NULL, 'admin', '2022-12-26 14:31:10.000', 'admin', '2019-11-15 15:18:53.000', NULL, 1, 1, NULL, NULL, NULL, 'ApplicationTemplate', 'General', 'Using this property you can change the application layout template.', 'configtypeApplicationTemplate', '', 'All', 'F', 'F', 'F', 'F', 'F', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000550000003, 'F', 0, NULL, 'admin', '2018-12-27 00:00:00.000', 'admin', '2018-12-27 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Load forms along with list', 'Autosplit', 'Enable split on tstruct and load along with listview', 'configtypeLoad forms along with list', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'F', NULL);
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000550000006, 'F', 0, NULL, 'admin', '2018-12-27 00:00:00.000', 'admin', '2018-12-27 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Load reports/lists along with form', 'Autosplit', 'Enable split on iview and open/load the tstruct on the first hyperlink', 'configtypeLoad reports/lists along with form', NULL, 'Iview', 'F', 'F', NULL, 'F', 'T', NULL);
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000550000009, 'F', 0, NULL, 'admin', '2018-12-27 00:00:00.000', 'admin', '2018-12-27 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Disablesplit', 'Disablesplit', 'To disable split to the application or page wise', 'configtypeDisablesplit', NULL, 'All', 'F', 'F', NULL, 'T', 'T', NULL);
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000550000012, 'F', 0, NULL, 'admin', '2018-12-27 00:00:00.000', 'admin', '2018-12-27 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Open Window mode', 'Navigation', 'Open Window mode', 'configtypeOpen Window mode', NULL, 'All', 'T', 'T', NULL, 'F', 'F', NULL);
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1040440000000, 'F', 0, NULL, 'admin', '2019-04-10 00:00:00.000', 'admin', '2019-04-10 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Tstruct Grid edit option', 'GridEdit', 'Enable/Disable to inline grid or popup grid', 'configtypeTstruct Grid edit option', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'F', NULL);
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1903990000000, 'F', 0, NULL, 'admin', '2019-01-23 00:00:00.000', 'admin', '2019-01-23 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Align Text', 'Text', 'Align Text', 'configtypeAlign Text', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'T', NULL);
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1751880000000, 'F', 0, NULL, 'admin', '2019-04-05 00:00:00.000', 'admin', '2019-04-05 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Main Page Reload', 'General', 'Main Page Reload', 'configtypeMain Page Reload', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'T', NULL);
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1742550000002, 'F', 0, NULL, 'admin', '2019-04-03 00:00:00.000', 'admin', '2019-04-03 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Change Password', 'General', 'Enable/Disable change password option for cloud application', 'configtypeChange Password', NULL, 'All', 'F', 'F', NULL, 'T', 'T', NULL);
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000440000000, 'F', 0, NULL, 'admin', '2018-12-27 00:00:00.000', 'admin', '2018-12-27 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Autocomplete Search Pattern', 'Autocomplete Search Pattern', 'Autocomplete Search Pattern', 'configtypeAutocomplete Search Pattern', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'F', NULL);
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1742550000008, 'F', 0, NULL, 'admin', '2019-04-03 00:00:00.000', 'admin', '2019-04-03 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'FetchSize', 'FetchSize', 'Page Size number of Iview data to be loaded', 'configtypeFetchSize', NULL, 'All', 'F', 'F', NULL, 'T', 'T', NULL);
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1790770000000, 'F', 0, NULL, 'pandi', '2019-04-12 00:00:00.000', 'pandi', '2019-04-12 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Local Dataset', 'Lds', 'Local Dataset', 'configtypeLocal Dataset', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'T', NULL);
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1104220000000, 'F', 0, NULL, 'admin', '2019-02-25 00:00:00.000', 'admin', '2019-02-25 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'FormLoad Cache', 'FormLoad', 'To avoid tstruct formload service call', 'configtypeFormLoad Cache', NULL, 'Tstruct', 'F', 'F', NULL, 'T', 'F', 'T');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1657440000021, 'F', 0, NULL, 'admin', '2019-06-03 00:00:00.000', 'admin', '2019-06-03 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Save Image in DB', 'SaveImage', 'Save Image in DB', 'configtypeSave Image in DB', NULL, 'Tstruct', 'F', 'F', 'T', 'T', 'F', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(2680010000000, 'F', 0, NULL, 'admin', '2019-06-13 00:00:00.000', 'admin', '2019-06-13 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Date Format', 'General', 'Date Format', 'configtypeDate Format', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'T');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(2175770000001, 'F', 0, NULL, 'admin', '2019-07-04 00:00:00.000', 'admin', '2019-06-29 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Hide Camera Option', 'camera option', 'Hide Camera Option', 'configtypeHide Camera Option', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(2037880000001, 'F', 0, NULL, 'admin', '2019-07-05 00:00:00.000', 'admin', '2019-07-05 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'File upload limit', 'File Upload Limit', 'File upload limit', 'configtypeFile upload limit', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'T');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1008440000004, 'F', 0, NULL, 'admin', '2019-12-27 17:34:22.000', 'admin', '2019-12-27 17:34:22.000', NULL, 1, 1, NULL, NULL, NULL, 'Multi Select Field', 'Multi Select', 'Multi Select Field', 'configtypeMulti Select Field', NULL, 'Tstruct', 'F', 'F', 'T', 'T', 'F', 'T');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1072550000000, 'F', 0, NULL, 'superadmin', '2020-01-31 00:00:00.000', 'superadmin', '2020-01-31 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Global Parameter Form', 'General', 'Global Parameter Form', 'configtypeGlobal Parameter Form', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'T');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1072550000006, 'F', 0, NULL, 'superadmin', '2020-01-31 00:00:00.000', 'superadmin', '2020-01-31 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Google Maps Api Key', 'General', 'Google Maps Api Key', 'configtypeGoogle Maps Api Key', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1235440000043, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.484', 'admin', '2022-12-25 22:29:56.484', NULL, 1, 1, NULL, NULL, NULL, 'Custom JavaScript', 'Custom JavaScript', 'Reports:
Use this property to attach custom javascript to Reports/forms. Set this property value to "true" for a selected report. If this property is set to true, the custom javascript file for Reposts should be saved into the web root\<ProjectName>\report\js folder. The file name should <reportName>.js. In case this property is set to true for all reports instead of a selected report, the file name should be custom.js

Tstructs:
Use this property to attach custom javascript to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom javascript file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.js. In case this property is set to true for all forms instead of a selected form, the file name should be custom.js.', 'configtypeCustom JavaScript', '', 'All', 'F', 'F', 'F', 'T', 'T', 'F');


INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1235660000010, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.485', 'admin', '2022-12-25 22:29:56.485', NULL, 1, 1, NULL, NULL, NULL, 'Custom CSS', 'Custom CSS', 'Reports:
Use this property to attach custom CSS to Reports. Set this property value to "True" for a selected report. If for report this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\report\js folder. The file name should <reportName>.CSS. In case this property is set to true for all reports instead of a selected report, the file name should be custom.CSS.

Tstructs:
Use this property to attach custom CSS to TStructs. Set this property value to "True" for a selected form. If this property is set to true, the custom CSS file should be saved into the web root\<ProjectName>\tstructs\js folder. The file name should <tstructname>.CSS. In case this property is set to true for all forms instead of a selected form, the file name should be custom.CSS.
', 'configtypeCustom CSS', '', 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1355440000006, 'F', 0, NULL, 'admin', '2022-12-25 22:29:56.490', 'admin', '2022-12-25 22:29:56.490', NULL, 1, 1, NULL, NULL, NULL, 'Auto Save Draft', 'Auto Save Draft', 'If key is set to true and time in millisecs(for ex for 60 secs give 60000 . Note: default time will be 120 seconds/2 minutes if no time is set) then on loading tstruct,it will check if unsaved data is there, if unsaved data  exists it will throw a popup with yes /no buttons.If yes, it will load the unsaved data else it will load a new tstruct.If new tstruct is opened for which key exists,then only if any field is changed,it will push data in redis after the mentioned time  in developer options at regular intervals.', 'configtypeAuto Save Draft', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1355440000003, 'F', 0, NULL, 'admin', '2022-12-25 22:29:56.491', 'admin', '2022-12-25 22:29:56.491', NULL, 1, 1, NULL, NULL, NULL, 'Show keyboard in Hybrid App', 'Show keyboard in Hybrid App', 'An enhancement to make an intuitive UI in Axpert Hybrid App i.e., 
-- based on the "Show keyboard in Hybrid App" key value, user can enable or disable the keyboard for autocomplete fields in tstruct level.
-- By default, value is set as true which makes no difference in the existing feature/functionality.
-- If set false,  keyboard is hidden/disabled along with the drop-down and clear icons. On single click of the field, drop down appears to choose the desired value.
', 'configtypeShow keyboard in Hybrid App', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1635440000037, 'F', 0, NULL, 'admin', '2022-12-25 22:29:56.517', 'admin', '2022-12-25 22:29:56.517', NULL, 1, 1, NULL, NULL, NULL, 'Enforced Strong Password Policy', 'General', 'If key is set to true,Strong Password Policy will work.Details for Enforced Strong Password Policy: Password should be alphanumeric, contains one UpperCharacter, one LowerCharacter with atleast one special character.It will check the following condition if key set to true and if password entered is not matching the condition,then it will throw error.', 'configtypeEnforced Strong Password Policy', NULL, 'Common', 'F', 'F', 'F', 'F', 'F', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1984880000036, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.519', 'superadmin', '2022-12-25 22:29:56.519', NULL, 1, 1, NULL, NULL, NULL, 'Notification Time Interval', 'General', 'Notification feature can be enabled at Application level by adding Developer Option "Notification Time Interval" , with values in minutes for time intervals as 1, 2, 3 , 4 etc. Once this key is added, long running web services/backend scheduled jobs completion can be notified to the user with given time intervals, so that user would be able to do other operations during long running web services/backend jobs.', 'configtypeNotification Time Interval', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1984440000004, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.520', 'superadmin', '2022-12-25 22:29:56.520', NULL, 1, 1, NULL, NULL, NULL, 'User Manual', 'General', 'User can able to access the files through web application which is saved in local folder through User Manual option (located in right sidebar menu)', 'configtypeUser Manual', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1984220000001, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.521', 'superadmin', '2022-12-25 22:29:56.521', NULL, 1, 1, NULL, NULL, NULL, 'Mobile Reports as Table', 'Mobile Reports as Table', 'Administrator can enable tabular view in mobile instead of cards view', 'configtypeMobile Reports as Table', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1000330000005, 'F', 0, NULL, 'admin', '2022-12-25 22:29:56.532', 'admin', '2022-12-25 22:29:56.532', NULL, 1, 1, NULL, NULL, NULL, 'WebService Timeout', 'WebService Timeout', 'WebService Timeout', 'configtypeWebService Timeout', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1251990000026, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.536', 'superadmin', '2022-12-25 22:29:56.536', NULL, 1, 1, NULL, NULL, NULL, 'Show Image Widget Action Button', 'General', 'The SmartView''s columns template can be changed to achieve desired UI and Actions', 'configtypeShow Image Widget Action Button', NULL, 'Common', 'F', 'F', 'F', 'T', 'T', 'T');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1420440000004, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.538', 'superadmin', '2022-12-25 22:29:56.538', NULL, 1, 1, NULL, NULL, NULL, 'Show Application Menu on Login', 'General', 'Application menu can be shown/hidden by setting this Developer Option.', 'configtypeShow Application Menu on Login', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1072550000003, 'F', 0, NULL, 'superadmin', '2020-01-31 00:00:00.000', 'superadmin', '2020-01-31 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Resolve Attachment Path', 'Resolve Attachment Path', 'Resolve Attachment Path', 'configtypeResolve Attachment Path', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1226220000004, 'F', 0, NULL, 'superadmin', '2022-12-25 22:29:56.534', 'superadmin', '2022-12-25 22:29:56.534', NULL, 1, 1, NULL, NULL, NULL, 'Iview Button Style', 'Iview Button Style', 'New Iview buttons UI can be switched as Modern(Google like UI) / Classic(Classic Bootstrap like UI) . Product default Iview Button UI is  "Modern" Style.', 'configtypeIview Button Style', '', 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1314010000000, 'F', 0, NULL, 'admin', '2021-04-14 12:01:12.000', 'admin', '2021-03-31 11:50:59.000', NULL, 1, 1, NULL, NULL, NULL, 'Tstruct Button Style', 'Tstruct Button Style', 'Tstruct Button Style', 'configtypeTstruct Button Style', '', 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'T');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1294220000002, 'F', 0, NULL, 'admin', '2021-04-27 18:22:36.000', 'admin', '2021-04-27 18:22:36.000', NULL, 1, 1, NULL, NULL, NULL, 'Apply Mobile UI', 'Apply Mobile UI', 'Apply Mobile UI', 'configtypeApply Mobile UI', NULL, 'Tstruct', 'T', 'F', 'T', 'T', 'F', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(9436330000000, 'F', 0, NULL, 'admin', '2021-07-21 18:40:15.000', 'admin', '2021-07-21 18:25:02.000', NULL, 1, 1, NULL, NULL, NULL, 'Split Ratio', 'Split Ratio', ' Description : Split Ratio format - windowSIze1:windowsize2:splitRatioType(Optional: auto(default)/fixed)
            § Developer Option Key : Split Ratio
        ○ Note: Split Ratio value is in following format 
            § windowSIze1:windowsize2:splitRatioType(Optional: auto(default)/fixed)
            §  Example:
                □ 1:1
                □ 1:2:auto
                □ 2:1
                □ 25:75
                □ 40:60
                □ 1:3:fixed
            § Split Ratio Type
                □ auto(default)
                    ®  If window is not resized manually then given split ratio configuration will be used
                    ® If window is resized manually then configuration is ignored
                □ fixed
                    ® If configuration is applied with fixed then resized window size will be ignored and split ratio configuration will always be applied', 'configtypeSplit Ratio', '', 'All', 'F', 'T', 'T', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1913880000000, 'F', 0, NULL, 'admin', '2021-11-03 20:05:58.000', 'swetha', '2021-10-29 18:23:59.000', NULL, 1, 1, NULL, NULL, NULL, 'Fixed Header for Grid', 'Fixed Header for Grid', 'Fixed Header for Grid', 'configtypeFixed Header for Grid', '', 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1005770000000, 'F', 0, NULL, 'admin', '2021-12-07 13:32:15.000', 'admin', '2021-12-07 13:32:15.000', NULL, 1, 1, NULL, NULL, NULL, 'Not Fill Dependent Fields', 'Not Fill Dependent Fields', 'Not Fill Dependent Fields', 'configtypeNot Fill Dependent Fields', NULL, 'Tstruct', 'F', 'F', 'T', 'T', 'F', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1005880000000, 'F', 0, NULL, 'admin', '2021-12-07 13:33:12.000', 'admin', '2021-12-07 13:33:12.000', NULL, 1, 1, NULL, NULL, NULL, 'Fill Dependent Fields', 'Fill Dependent Fields', 'Fill Dependent Fields', 'configtypeFill Dependent Fields', NULL, 'Tstruct', 'F', 'F', 'T', 'T', 'F', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(6210110000000, 'F', 0, NULL, 'admin', '2022-08-12 10:55:30.000', 'admin', '2022-08-12 10:55:30.000', NULL, 1, 1, NULL, NULL, NULL, 'Listview as default from search', 'General', 'Listview as default from search', 'configtypeListview as default from search', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1373110000000, 'F', 0, NULL, 'admin', '2022-12-02 16:06:01.000', 'admin', '2022-12-02 16:06:01.000', NULL, 1, 1, 0, NULL, NULL, 'Upload file types', 'Upload file types', 'Upload file types', 'configtypeUpload file types', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'F', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1913770000000, 'F', 0, NULL, 'admin', '2021-11-03 20:04:40.000', 'swetha', '2021-10-29 18:21:27.000', NULL, 1, 1, NULL, NULL, NULL, 'Iview Retain Parameters On Next Load', 'Iview Retain Parameters On Next Load', 'Iview Retain Parameters On Next Load', 'configtypeIview Retain Parameters On Next Load', '', 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1883880000000, 'F', 0, NULL, 'admin', '2021-11-19 19:27:08.000', 'admin', '2021-11-19 19:23:23.000', NULL, 1, 1, NULL, NULL, NULL, 'Iview Responsive Column Width', 'Iview Responsive Column Width', NULL, 'configtypeIview Responsive Column Width', NULL, 'All', 'F', 'F', NULL, 'T', 'T', NULL);
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1121550000000, 'F', 0, NULL, 'admin', '2022-12-29 08:30:30.000', 'admin', '2022-12-29 08:30:30.000', NULL, 1, 1, NULL, NULL, NULL, 'Google Maps Zoom', 'Google Maps Zoom', 'Google Maps Zoom', 'configtypeGoogle Maps Zoom', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops
(axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, dupchk, context, ptype, caction, chyperlink, alltstructs, alliviews, alluserroles, cfields, description)
VALUES(1518330000000, 'F', 0, NULL, 'admin', '2022-12-29 11:41:12.000', 'admin', '2022-12-29 11:41:12.000', NULL, 1, 1, 0, NULL, NULL, 'Iview Session Caching', 'Iview Session Caching', 'configtypeIview Session Caching', NULL, 'Iview', 'F', 'F', 'F', 'T', 'F', 'F', 'Iview Session Caching');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000004, 1000550000003, 1, 'True');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000005, 1000550000003, 2, 'False');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000007, 1000550000006, 1, 'True');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000008, 1000550000006, 2, 'False');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000010, 1000550000009, 1, 'True');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000011, 1000550000009, 2, 'False');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000013, 1000550000012, 1, 'Default');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000014, 1000550000012, 2, 'Popup');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000015, 1000550000012, 3, 'Newpage');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000550000016, 1000550000012, 4, 'Split');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000001, 1000220000000, 1, 'middle');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000002, 1000220000000, 2, 'top');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000003, 1000220000000, 3, 'bottom');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000005, 1000220000004, 1, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000006, 1000220000004, 2, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000008, 1000220000007, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000009, 1000220000007, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000013, 1000220000012, 1, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000014, 1000220000012, 2, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000220000016, 1000220000015, 1, 'mainPageTemplate.html');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000440000001, 1000440000000, 1, 'starts with');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000440000002, 1000440000000, 2, 'contains');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1840440000000, 1314010000000, 1, 'old');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1840440000001, 1314010000000, 2, 'modern');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1840440000002, 1314010000000, 3, 'classic');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1294220000003, 1294220000002, 1, 'all');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1294220000004, 1294220000002, 2, 'mobile');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1294220000005, 1294220000002, 3, 'none');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(9436330000001, 9436330000000, 1, '1:1');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(9436330000002, 9436330000000, 2, '1:2:auto');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(9436330000003, 9436330000000, 3, '2:1 ');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(9436330000004, 9436330000000, 4, '25:75:fixed');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000003, 1742550000002, 1, 'Disable');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000004, 1742550000002, 2, 'Enable');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000007, 1742550000005, 2, 'iview');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000006, 1742550000005, 1, 'tstruct');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000010, 1742550000008, 2, '30');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000028, 1742550000008, 20, '5000');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000027, 1742550000008, 19, '2000');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000026, 1742550000008, 18, '1000');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000009, 1742550000008, 1, '25');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000029, 1742550000008, 21, 'ALL');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000011, 1742550000008, 3, '35');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000012, 1742550000008, 4, '40');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000013, 1742550000008, 5, '45');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000014, 1742550000008, 6, '50');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000015, 1742550000008, 7, '55');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000016, 1742550000008, 8, '60');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000017, 1742550000008, 9, '65');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000018, 1742550000008, 10, '70');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000019, 1742550000008, 11, '75');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000020, 1742550000008, 12, '80');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000021, 1742550000008, 13, '85');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000022, 1742550000008, 14, '90');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000023, 1742550000008, 15, '95');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000024, 1742550000008, 16, '100');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1742550000025, 1742550000008, 17, '500');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1751880000001, 1751880000000, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1751880000002, 1751880000000, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1903990000001, 1903990000000, 1, 'Right');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1903990000002, 1903990000000, 2, 'Left');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1790770000002, 1790770000000, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1040440000001, 1040440000000, 1, 'Inline');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1040440000002, 1040440000000, 2, 'Popup');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1104220000001, 1104220000000, 1, '30 min');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1104220000002, 1104220000000, 2, '1 hour');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1104220000003, 1104220000000, 3, '2 hour');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1104220000004, 1104220000000, 4, '5 hour');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1104220000005, 1104220000000, 5, '10 hour');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1104220000006, 1104220000000, 6, 'None');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1657440000022, 1657440000021, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(9436330000005, 9436330000000, 5, '40:60');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1913770000001, 1913770000000, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1913770000002, 1913770000000, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1913880000001, 1913880000000, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1913880000002, 1913880000000, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1883880000001, 1883880000000, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1883880000002, 1883880000000, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1005770000001, 1005770000000, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1005770000002, 1005770000000, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1005880000001, 1005880000000, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1005880000002, 1005880000000, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1210110000001, 1210110000000, 1, 'True');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1210110000002, 1210110000000, 2, 'False');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1373110000001, 1373110000000, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1373110000002, 1373110000000, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1237550000000, 1742550000005, 3, 'general');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1787880000005, 1742550000008, 22, '10');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(2680010000001, 2680010000000, 1, 'en-US');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(2175770000002, 2175770000001, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(2037880000002, 2037880000001, 1, '1');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1008440000005, 1008440000004, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1008440000006, 1008440000004, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1072550000001, 1072550000000, 1, 'hide');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1072550000002, 1072550000000, 2, 'show');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1072550000004, 1072550000003, 1, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1072550000005, 1072550000003, 2, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1235440000044, 1235440000043, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1235440000045, 1235440000043, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1235660000011, 1235660000010, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1235660000012, 1235660000010, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1355440000004, 1355440000003, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1355440000005, 1355440000003, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1355440000007, 1355440000006, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1355440000008, 1355440000006, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1355440000010, 1355440000009, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1355440000011, 1355440000009, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1635440000038, 1635440000037, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984220000002, 1984220000001, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984220000003, 1984220000001, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984440000005, 1984440000004, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984440000006, 1984440000004, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984880000037, 1984880000036, 1, '1');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984880000038, 1984880000036, 2, '3');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984880000039, 1984880000036, 3, '5');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984880000040, 1984880000036, 4, '10');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1984880000041, 1984880000036, 5, '30');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1000330000006, 1000330000005, 1, '100000');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1525110003964, 1000330000005, 2, '1000000');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1226220000005, 1226220000004, 1, 'Modern');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1226220000006, 1226220000004, 2, 'Classic');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1251990000027, 1251990000026, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1251990000028, 1251990000026, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1420440000005, 1420440000004, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1420440000006, 1420440000004, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1121550000001, 1121550000000, 1, '1');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1121550000002, 1121550000000, 2, '5');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1121550000003, 1121550000000, 3, '10');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1121550000004, 1121550000000, 4, '11');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1121550000005, 1121550000000, 5, '15');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1121550000006, 1121550000000, 6, '20');
>>

<<
INSERT INTO axpstructconfigproval(axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues)VALUES(1518330000001, 1518330000000, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval(axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues)VALUES(1518330000002, 1518330000000, 2, 'false');
>>

<<
INSERT INTO axpstructconfig (axpstructconfigid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, asprops, setype, props, context, propvalue1, propvalue2, propsval, alluserroles, structcaption, structname, structelements, sfield, icolumn, sbutton, hlink, stype, userroles, dupchk, purpose) VALUES(2038330000000, 'F', 0, NULL, 'admin', '2019-07-05 00:00:00.000', 'admin', '2019-07-05 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'File upload limit', 'Tstruct', 'File Upload Limit', NULL, '1', NULL, '1', NULL, 'ALL Forms', 'ALL Forms', NULL, NULL, NULL, NULL, NULL, 'Tstruct', 'ALL', 'File upload limitALL Forms1ALL', NULL);
>>

<<
INSERT INTO axpstructconfig (axpstructconfigid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, asprops, setype, props, context, propvalue1, propvalue2, propsval, alluserroles, structcaption, structname, structelements, sfield, icolumn, sbutton, hlink, stype, userroles, dupchk, purpose) VALUES(2176010000000, 'F', 0, NULL, 'admin', '2019-07-04 00:00:00.000', 'admin', '2019-06-29 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Hide Camera Option', 'Tstruct', 'camera option', NULL, 'true', NULL, 'true', NULL, 'ALL Forms', 'ALL Forms', NULL, NULL, NULL, NULL, NULL, 'Tstruct', 'ALL', 'Hide Camera OptionALL FormstrueALL', NULL);
>>

<<
INSERT INTO axpstructconfig (axpstructconfigid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, asprops, setype, props, context, propvalue1, propvalue2, propsval, alluserroles, structcaption, structname, structelements, sfield, icolumn, sbutton, hlink, stype, userroles, dupchk, purpose) VALUES(1386770000002, 'F', 0, NULL, 'admin', '2019-06-05 00:00:00.000', 'admin', '2019-06-05 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Save Image in DB', 'Tstruct', 'SaveImage', NULL, 'true', NULL, 'true', NULL, 'My Profile(dprof)', 'dprof', NULL, NULL, NULL, NULL, NULL, 'Tstruct', 'ALL', 'Save Image in DBdproftrueALL', NULL);
>>

<<
INSERT INTO axpstructconfig (axpstructconfigid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, asprops, setype, props, context, propvalue1, propvalue2, propsval, alluserroles, structcaption, structname, structelements, sfield, icolumn, sbutton, hlink, stype, userroles, dupchk, purpose) VALUES(1799550000000, 'F', 0, NULL, 'admin', '2019-06-08 00:00:00.000', 'admin', '2019-06-08 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'FetchSize', 'All', 'FetchSize', NULL, '25', NULL, '25', NULL, 'ALL Reports', 'ALL Reports', NULL, NULL, NULL, NULL, NULL, 'Iview', 'ALL', 'FetchSizeALL Reports25ALL', 'Page Size number of Iview data to be loaded');
>>

<<
INSERT INTO axpstructconfig (axpstructconfigid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, asprops, setype, props, context, propvalue1, propvalue2, propsval, alluserroles, structcaption, structname, structelements, sfield, icolumn, sbutton, hlink, stype, userroles, dupchk, purpose) VALUES(1058330000000, 'F', 0, NULL, 'admin', '2019-05-17 00:00:00.000', 'admin', '2019-05-17 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Tstruct Grid edit option', 'Tstruct', 'GridEdit', NULL, 'inline', NULL, 'inline', NULL, 'ALL Forms', 'ALL Forms', NULL, NULL, NULL, NULL, NULL, 'Tstruct', 'ALL', 'Tstruct Grid edit optionALL FormsinlineALL', 'Enable/Disable to inline grid or popup grid');
>>

<<
INSERT INTO axpstructconfig (axpstructconfigid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, asprops, setype, props, context, propvalue1, propvalue2, propsval, alluserroles, structcaption, structname, structelements, sfield, icolumn, sbutton, hlink, stype, userroles, dupchk, purpose) VALUES(1573550000000, 'F', 0, NULL, 'admin', '2019-01-10 00:00:00.000', 'admin', '2019-01-10 00:00:00.000', NULL, 1, 1, NULL, NULL, NULL, 'Disablesplit', 'All', 'Disablesplit', NULL, 'true', NULL, 'true', NULL, 'Advance Settings(axstc)', 'axstc', NULL, NULL, NULL, NULL, NULL, 'Tstruct', 'ALL', 'DisablesplitaxstctrueALL', 'To disable split to the application or page wise');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) 
VALUES(1601770000002, 'F', 0, NULL, 'admin', '2022-12-29 11:41:12.000', 'admin','2022-12-29 11:41:12.000', NULL, 1, 1, 0, NULL, NULL, 'column separator for reports', 'column separator for reports', 'column separator for reports', 'configtypecolumn separator for reports', NULL, 'Common', 'F', 'F', 'F', 'T', 'T', 'F')
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1601770000003, 1601770000002, 1, 'true')
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1601770000004, 1601770000002, 2, 'false')
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) 
VALUES(1368990000000, 'F', 0, NULL, 'admin', '2022-12-29 11:41:12.000', 'admin', '2022-12-29 11:41:12.000', NULL, 1, 1, NULL, NULL, NULL, 'Popup fillgrid data based on query order', 'Popup fillgrid data based on query order', 'Popup fillgrid data based on query order', 'configtypePopup fillgrid data based on query order', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'T', 'F')
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1368990000001, 1368990000000, 1, 'true')
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1368990000002, 1368990000000, 2, 'false')
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) 
VALUES(1368990000003, 'F', 0, NULL, 'admin', '2022-12-29 11:41:12.000', 'admin', '2022-12-29 11:41:12.000', NULL, 1, 1, NULL, NULL, NULL, 'Popup fillgrid data show all', 'Popup fillgrid data show all', 'Popup fillgrid data show all', 'configtypePopup fillgrid data show all', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'T', 'F')
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1368990000004, 1368990000003, 1, 'true')
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1368990000005, 1368990000003, 2, 'false')
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) 
VALUES(3819110000000, 'F', 0, NULL, 'admin', '2023-04-10 10:57:39.000', 'admin', '2023-04-10 10:57:39.000', NULL, 1, 1, NULL, NULL, NULL, 'Unicode support for PDF export', 'Unicode support for PDF export', 'Unicode support for PDF export', 'configtypeUnicode support for PDF export', NULL, 'All', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1819110000001, 3819110000000, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1819110000002, 3819110000000, 2, 'false');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) 
VALUES(3819010000000, 'F', 0, NULL, 'admin', '2023-04-10 10:57:10.000', 'admin', '2023-04-10 10:57:10.000', NULL, 1, 1, NULL, NULL, NULL, 'Auto column width for report based on data', 'Auto column width for report based on data', 'Auto column width for report based on data', 'configtypeAuto column width for report based on data', NULL, 'All', 'F', 'F', 'F', 'F', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1819010000001, 3819010000000, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1819010000002, 3819010000000, 2, 'false');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(5095990000000, 'F', 0, NULL, 'admin', '2023-06-09 19:06:34.000', 'admin', '2023-06-09 19:04:03.000', NULL, 1, 1, 0, NULL, NULL, 'Force Field Validation', 'General', 'Force Field Validation', 'configtypeForce Field Validation', NULL, 'Tstruct', 'F', 'F', 'T', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1095990000001, 5095990000000, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1095990000002, 5095990000000, 2, 'false');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1320010000002, 'F', 0, NULL, 'admin', '2023-10-31 17:22:16.000', 'admin', '2023-10-31 16:30:04.000', NULL, 1, 1, 0, NULL, NULL, 'Hide Select ALL option in Multiselect Component', 'Hide Select ALL option in Multiselect Component', 'Hide Select ALL option in Multiselect Component', 'configtypeHide Select ALL option in Multiselect Component', NULL, 'Iview', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1393550000002, 'F', 0, NULL, 'admin', '2023-08-04 14:44:31.000', 'admin', '2023-08-04 14:44:15.000', NULL, 1, 1, 0, NULL, NULL, 'Fill AutoSelect fields for dropdown fields', 'Fill AutoSelect fields for dropdown fields', 'Fill AutoSelect fields for dropdown fields', 'configtypeFill AutoSelect fields for dropdown fields', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'T', 'T');
>>

<<
INSERT INTO axpstructconfigprops (axpstructconfigpropsid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, configprops, propcode, description, dupchk, context, ptype, caction, chyperlink, cfields, alltstructs, alliviews, alluserroles) VALUES(1369990000002, 'F', 0, NULL, 'admin', '2023-08-02 10:13:46.000', 'admin', '2023-08-02 10:13:46.000', NULL, 1, 1, 0, NULL, NULL, 'Show Sql Columns In Advance Search In Field Level', 'Show Sql Columns In Advance Search In Field Level', 'Show Sql Columns In Advance Search In Field Level', 'configtypeShow Sql Columns In Advance Search In Field Level', NULL, 'Tstruct', 'F', 'F', 'F', 'T', 'T', 'F');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1369990000003, 1369990000002, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1369990000004, 1369990000002, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1393550000003, 1393550000002, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1393550000004, 1393550000002, 2, 'false');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1320010000003, 1320010000002, 1, 'true');
>>

<<
INSERT INTO axpstructconfigproval (axpstructconfigprovalid, axpstructconfigpropsid, axpstructconfigprovalrow, configvalues) VALUES(1320010000004, 1320010000002, 2, 'false');
>>

<<
update axpstructconfigprops set description= configprops where description is null or description='';
>>

<<
CREATE TABLE axcardtypemaster (
	axcardtypemasterid numeric(16) NULL,
	cancel varchar(1) NULL,
	sourceid numeric(16) NULL,
	mapname varchar(20) NULL,
	username varchar(50) NULL,
	modifiedon timestamp NULL,
	createdby varchar(50) NULL,
	createdon timestamp NULL,
	wkid varchar(15) NULL,
	app_level numeric(3) NULL,
	app_desc numeric(1) NULL,
	app_slevel numeric(3) NULL,
	cancelremarks varchar(150) NULL,
	wfroles varchar(250) NULL,
	cardtype varchar(15) NULL,
	cardcaption varchar(100) NULL,
	cardicon varchar(500) NULL,
	axpfile_cardimg varchar(4000) NULL,
	axpfilepath_cardimg varchar(1000) NULL
);
>>

<<
INSERT INTO axcardtypemaster (axcardtypemasterid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, cardtype, cardcaption, cardicon, axpfile_cardimg, axpfilepath_cardimg) VALUES(1362010000000, 'F', 0, NULL, 'abinash', '2021-04-28 19:18:59.000', 'abinash', '2021-04-28 19:18:42.000', NULL, 1, 1, NULL, NULL, NULL, 'chart', 'Chart', '', '', '');
>>

<<
INSERT INTO axcardtypemaster (axcardtypemasterid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, cardtype, cardcaption, cardicon, axpfile_cardimg, axpfilepath_cardimg) VALUES(1362220000000, 'F', 0, NULL, 'abinash', '2021-04-28 19:22:00.000', 'abinash', '2021-04-28 19:22:00.000', NULL, 1, 1, NULL, NULL, NULL, 'kpi', 'KPI', NULL, NULL, NULL);
>>

<<
INSERT INTO axcardtypemaster (axcardtypemasterid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, cardtype, cardcaption, cardicon, axpfile_cardimg, axpfilepath_cardimg) VALUES(1362440000000, 'F', 0, NULL, 'abinash', '2021-04-28 19:22:50.000', 'abinash', '2021-04-28 19:22:50.000', NULL, 1, 1, NULL, NULL, NULL, 'list', 'List', NULL, NULL, NULL);
>>

<<
INSERT INTO axcardtypemaster (axcardtypemasterid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, cardtype, cardcaption, cardicon, axpfile_cardimg, axpfilepath_cardimg) VALUES(1362550000000, 'F', 0, NULL, 'abinash', '2021-04-28 19:23:04.000', 'abinash', '2021-04-28 19:23:04.000', NULL, 1, 1, NULL, NULL, NULL, 'menu', 'Menu card', NULL, NULL, NULL);
>>

<<
INSERT INTO axcardtypemaster (axcardtypemasterid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, cardtype, cardcaption, cardicon, axpfile_cardimg, axpfilepath_cardimg) VALUES(1362660000000, 'F', 0, NULL, 'abinash', '2021-04-28 19:23:23.000', 'abinash', '2021-04-28 19:23:23.000', NULL, 1, 1, NULL, NULL, NULL, 'modern menu', 'Modern menu', NULL, NULL, NULL);
>>

<<
INSERT INTO axcardtypemaster (axcardtypemasterid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, cardtype, cardcaption, cardicon, axpfile_cardimg, axpfilepath_cardimg) VALUES(1659550000037, 'F', 0, NULL, 'abinash', '2021-05-07 09:33:54.000', 'abinash', '2021-05-07 09:33:54.000', NULL, 1, 1, NULL, NULL, NULL, 'image card', 'Image card', NULL, NULL, NULL);
>>

<<
INSERT INTO axcardtypemaster (axcardtypemasterid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, cardtype, cardcaption, cardicon, axpfile_cardimg, axpfilepath_cardimg) VALUES(1962990000000, 'F', 0, NULL, 'abinash', '2021-06-09 16:04:56.000', 'abinash', '2021-06-09 16:04:56.000', NULL, 1, 1, NULL, NULL, NULL, 'calendar', 'Calendar', NULL, NULL, NULL);
>>

<<
INSERT INTO axcardtypemaster (axcardtypemasterid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, cardtype, cardcaption, cardicon, axpfile_cardimg, axpfilepath_cardimg) VALUES(1042770000000, 'F', 0, NULL, 'admin', '2022-01-24 19:52:53.000', 'admin', '2022-01-24 19:52:53.000', NULL, 1, 1, NULL, NULL, NULL, 'html', 'HTML Card', NULL, NULL, NULL);
>>

<<
INSERT INTO axcardtypemaster (axcardtypemasterid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, cardtype, cardcaption, cardicon, axpfile_cardimg, axpfilepath_cardimg) VALUES(8139880000000, 'F', 0, NULL, 'admin', '2023-04-26 18:15:25.000', 'admin', '2023-04-26 18:15:25.000', NULL, 1, 1, NULL, NULL, NULL, 'options card', 'options card', NULL, NULL, NULL);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd) VALUES(1309880000000, 'F', 0, NULL, 'admin', '2024-02-02 15:31:58.000', 'admin', '2023-08-31 19:26:05.000', NULL, 1, 1, NULL, NULL, NULL, 'Fast_Print_Master', '', 'select id,caption,source from(
select  regexp_split_to_table(get_sql_columns(sqltext),'','')  id,regexp_split_to_table(get_sql_columns(sqltext),'','') caption,''Data source'' source,1 ord 
from axdirectsql a where ''Form data'' != :master_data_source and sqlname = :masterdsrctmp 
union all
select fname,caption,''Form'',2 ord from axpflds where asgrid=''F'' and ''Form data'' = :master_data_source and tstruct = :ftransid 
union all
select db_varname,db_varcaption,''Axvars'' ,3 ord from axpdef_axvars_dbvar a,axpdef_axvars b
where b.axpdef_axvarsid=a.axpdef_axvarsid 
union all
select regexp_split_to_table(''username,usergroup'','',''),regexp_split_to_table(''Login username,User role'','',''),''App vars'' ,4 ord from dual
union all
select fname,caption,''Glovar'',5 ord from axpflds where tstruct=''axglo''
order by 4,1)a', 'master_data_source,masterdsrctmp,ftransid', 'master_data_source,masterdsrctmp,ftransid', 'ALL', '', 'API', 1);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd) VALUES(1311220000000, 'F', 0, NULL, 'admin', '2024-01-25 12:47:04.000', 'admin', '2023-08-31 19:40:19.000', NULL, 1, 1, NULL, NULL, NULL, 'Fast_Print_Detail', '', 'select id,caption,source from(
select  regexp_split_to_table(get_sql_columns(sqltext),'','')  id,regexp_split_to_table(get_sql_columns(sqltext),'','') caption,''Data source'' source,1 ord 
from axdirectsql a 
where ''2'' = :dtlsrccnd and sqlname = :dtldsrctmp 
union all
select fname,caption,''Form'',2 ord from axpflds where dcname = :griddcno and ''1'' = :dtlsrccnd and tstruct = :ftransid and savevalue=''T''
  union all
  select fname,caption,''Form'',2 ord from axpflds where asgrid=''F'' and ''3'' = :dtlsrccnd and tstruct = :ftransid 
union all
select db_varname,db_varcaption,''Axvars'' ,3 ord from axpdef_axvars_dbvar a,axpdef_axvars b
where b.axpdef_axvarsid=a.axpdef_axvarsid 
union all
select regexp_split_to_table(''username,usergroup'','',''),regexp_split_to_table(''Login username,User role'','',''),''App vars'' ,4 ord from dual
union all
select fname,caption,''Glovar'',5 ord from axpflds where tstruct=''axglo''
order by 4,1)a', 'dtlsrccnd,dtldsrctmp,griddcno,ftransid', 'dtlsrccnd,dtldsrctmp,griddcno,ftransid', 'ALL', '', 'API', 1);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd) VALUES(1169550000000, 'F', 0, NULL, 'admin', '2024-06-24 17:46:41.000', 'admin', '2024-06-24 17:38:41.000', NULL, 1, 1, NULL, NULL, NULL, 'homepage_company', '', 'select company_name,company_address,company_url, url_fb,url_instagram,url_twitter,url_youtube,url_linkedin from axpdef_company where primarycompany=''T''', '', '', 'ALL', '', 'Home configuration', 2);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd) VALUES(1414440000000, 'F', 0, NULL, 'admin', '2023-10-26 10:52:09.000', 'admin', '2023-10-26 10:52:09.000', NULL, 1, 1, NULL, NULL, NULL, 'Text_Field_Intelligence', NULL, 'select id,caption,source from(
select fname id,caption,''Form'' source,2 ord from axpflds where asgrid=''F'' and tstruct = :txttransid 
union all
select db_varname,db_varcaption,''Axvars'' ,3 ord from axpdef_axvars_dbvar a,axpdef_axvars b
where b.axpdef_axvarsid=a.axpdef_axvarsid 
union all
select regexp_split_to_table(''username,usergroup'','',''),regexp_split_to_table(''Login username,User role'','',''),''App vars'' ,4 ord from dual
union all
select fname,caption,''Glovar'',5 ord from axpflds where tstruct=''axglo''
order by 4,1)a', 'txttransid', 'txttransid', 'ALL', NULL, 'API', 1);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd) VALUES(1569990000000, 'F', 0, NULL, 'admin', '2023-11-07 17:12:21.000', 'admin', '2023-11-07 17:12:21.000', NULL, 1, 1, NULL, NULL, NULL, 'axcalendarsource', NULL, 'select * from vw_cards_calendar_data where mapname is null and uname = :username order by startdate', 'username', 'username', 'ALL', NULL, 'API', 1);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd) VALUES(1473550000000, 'F', 0, NULL, 'admin', '2024-12-24 07:33:03.000', 'admin', '2024-12-24 07:33:03.000', NULL, 1, 1, NULL, NULL, NULL, 'ds_homepage_recentactivities', NULL, 'select * from 
(select case lower(servicename) 
when ''saving data'' then ''new data created in ''||t.caption 
when ''quick form load'' then t.caption ||'' opened''
when ''form load'' then t.caption ||'' opened''
when ''importdata''  then ''Data import''
when ''exportdata'' then ''Data export''
when ''deleting data'' then ''Data deleted in''||t.caption
when ''get iview new'' then i.caption||'' report opened''
when ''get iview'' then i.caption||'' report opened''
when ''logout'' then ''Logout''
when ''login'' then ''Login''
when ''get structure'' then t.caption ||'' opened''
when ''load data''  then ''Load data in ''||t.caption 
when ''quick load data'' then ''Load data in ''||t.caption 
end title,
username,calledon,
case when lower(servicename) in (''get iview new'',''get iview'') then ''i''||structname||''()'' 
when lower(servicename) in(''quick load data'',''load data'') then ''t''||structname||''(recordid=''||recordid||'')''
when lower(servicename) in(''get structure'',''quick form load'',''form load'',''deleting data'') then ''t''||structname||''()'' end link 
from axpertlog a 
left join tstructs t on a.structname = t."name" 
left join iviews i on a.structname = i."name" 
where lower(servicename) in (''load data'',''quick load data'',''form load'',''get structure'',''saving data'',''quick form load'',''importdata'',''exportdata'',''deleting data'',''get iview new'',''get iview'',''logout'',''login'')
and calledon > current_date - 2
and username = :username)a
where a.title is not null
order by calledon desc', 'username', 'username', 'ALL', NULL, 'Home configuration', 2);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd) VALUES(1473660000000, 'F', 0, NULL, 'admin', '2024-12-24 07:43:28.000', 'admin', '2024-12-24 07:43:28.000', NULL, 1, 1, NULL, NULL, NULL, 'ds_homepage_kpicards', NULL, 'select ''Users'',count(*),''taxusr()'' link from axusers
union all
select ''Records created today'',count(*),null from axpertlog a 
where lower(servicename)=''saving data''
and cast(calledon as date)=current_date
and username =:username
union all 
select ''Active sessions'',count(*),null from axaudit a 
where cast(logintime as date)=current_date
and nologout =''T''
union all
select ''Sample with params'',0,''taxusr(pusername=admin~build=''T'') from dual where 1=2', 'username', 'username', 'ALL', NULL, 'Home configuration', 2);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd) VALUES(1473880000000, 'F', 0, NULL, 'admin', '2024-12-24 07:55:05.000', 'admin', '2024-12-24 07:55:05.000', NULL, 1, 1, NULL, NULL, NULL, 'ds_homepage_events', NULL, 'select	eventname title,eventtype subtitle,startdate||'' ''||axptm_starttime,
''taxclr(recordid=''||recordid||'')'' link
from vw_cards_calendar_data
where mapname is null and uname = :username
order by startdate', 'username', 'username', 'ALL', NULL, 'Home configuration', 2);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd) VALUES(1473330000000, 'F', 0, NULL, 'admin', '2024-12-24 06:45:30.000', 'admin', '2024-12-24 06:45:30.000', NULL, 1, 1, NULL, NULL, NULL, 'ds_homepage_quicklinks', NULL, 'SELECT distinct 
case when lower(servicename)=''get structure'' then t.caption
when lower(servicename) in(''get iview new'',''get iview'') then i.caption end caption,
case when lower(servicename)=''get structure'' then ''t''||structname||''()''
when lower(servicename) in(''get iview new'',''get iview'') then ''i''||structname||''()'' end link
from axpertlog a left join tstructs t on a.structname = t."name" 
left join iviews i on a.structname = i."name" 
where cast(calledon as date) > current_date - 1  
and lower(servicename) in(''get structure'',''get iview new'',''get iview'')
and structname is not null
and a.username  = :username', 'username', 'username', 'ALL', NULL, 'Home configuration', 2);
>>

<<
INSERT INTO axdirectsql (axdirectsqlid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles,sqlname,ddldatatype,sqltext,paramcal,sqlparams,accessstring,groupname,sqlsrc,sqlsrccnd) VALUES
	 (1543220000000,'F',0,NULL,'admin','2025-02-06','admin','2025-02-06',NULL,1,1,0,NULL,NULL,'ds_homepage_banner',NULL,'SELECT ''Developer faster'' as title, ''Developer faster using Axpert low code platform.'' as subtitle, ''Jan 01, 2025'' as time, ''https://dev.agilecloud.biz/axpert11.3web/CustomPages/images/slider1.png'' as image, '''' as link from dual
union
SELECT ''UI Plugins'' as title, ''Use UI Plugins to enhance the user experience'' as subtitle, ''Jan 01, 2025'' as time, ''https://dev.agilecloud.biz/axpert11.3web/CustomPages/images/slider1.png'' as image, '''' as link from dual
union
SELECT ''Configure yourself'' as title, ''Configure functionalities as per customer needs'' as subtitle, ''Jan 01, 2025'' as time, ''https://dev.agilecloud.biz/axpert11.3web/CustomPages/images/slider1.png'' as image, '''' as link from dual
',NULL,NULL,'ALL',NULL,'Home configuration',2);
>>

<<
INSERT INTO executeapidef (executeapidefid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, execapidefname, execapiurl, execapiparameterstring, execapiheaderstring, execapirequeststring, execapimethod, execapibasedon, stype, execapiform, execapitransid, execapifilterstring, execapilprintformnames, execapiformattachments, execapiiview, execapiiviewname, execapiiparams, sql_editor_execapisqltext, apicategory, apiresponsetype, apiresponseformat, execapibodyparamstring, execapiauthstring) VALUES(1886660000000, 'F', 0, NULL, 'admin', '2024-01-10 14:40:09.000', 'admin', '2024-01-10 14:40:09.000', NULL, 1, 1, NULL, NULL, NULL, 'PeriodicNotification', 'NA', NULL, NULL, NULL, 'Post', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'NA', 'Axpert', 'JSON', NULL, NULL);
>>

<<
INSERT INTO executeapidef (executeapidefid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, execapidefname, execapiurl, execapiparameterstring, execapiheaderstring, execapirequeststring, execapimethod, execapibasedon, stype, execapiform, execapitransid, execapifilterstring, execapilprintformnames, execapiformattachments, execapiiview, execapiiviewname, execapiiparams, sql_editor_execapisqltext, apicategory, apiresponsetype, apiresponseformat, execapibodyparamstring, execapiauthstring) VALUES(1416550000000, 'F', 0, NULL, 'admin', '2024-08-01 15:47:39.000', 'admin', '2023-10-27 08:26:19.000', NULL, 1, 1, NULL, NULL, NULL, 'Text_Field_Intelligence', 'https://alpha.agilecloud.biz/axpert11.3scripts/ASBMenuRest.dll/datasnap/rest/TASBMenuRest/GetSqldata', '', '', '{"_parameters":[{"getsqldata":{"axpapp":"defschema","sqlname":"Text_Field_Intelligence","isdropdown":"F","trace":"false"},"defschema":{
  "type": "db",
  "structurl": "",
  "db": "Postgre",
  "driver": "dbx",
  "version": "",
  "dbcon": "172.16.0.135",
  "dbuser": "defschema\\goldendump11",
  "pwd": "",
  "dataurl": ""
},"sqlparams":{"txttransid":""}}]}', 'Post', '', '', '', '', '', '', '', '', '', '', '', 'SQL', 'Axpert', 'JSON', '', '');
>>


<<
ALTER TABLE axp_vp ADD CONSTRAINT axp_vp_unique UNIQUE (vpname);
>>

<<
ALTER TABLE axvarcore ADD CONSTRAINT axvarcore_unique UNIQUE (vpname);
>>

<<
INSERT INTO aximpdef (aximpdefid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, aximpdefname, aximpform, aximptransid, aximptextqualifier, aximpmapinfile, aximpheaderrows, aximpprimayfield, aximpgroupfield, aximpfieldseperator, aximpmapfields, aximpthreadcount, aximpprocname, aximpbindtotstruct, aximpstdcolumnwidth, aximpignorefldexception, aximponlyappend, aximpprocessmode, aximpfilefromtable, aximpfieldseperatorui, aximpprimaryfield_details) VALUES(1783010000000, 'F', 0, NULL, 'admin', '2023-03-28', 'admin', '2023-03-24', NULL, 1, 1, NULL, NULL, NULL, 'Axlanguage', 'Axlanguage Data', 'ad_li', 'F', 'F', 1, '', 'compname', ',', 'dispname,sname,compname,compengcap,compcaption', 1, '', 'F', 0, 'F', 'F', 'Process with error (ALL)', 'F', '(comma)', NULL);
>>

<<
ALTER TABLE axp_appsearch_data_period Disable TRIGGER axp_tr_search_appsearch1;
>>

<<
CREATE OR REPLACE FUNCTION fn_ruledefv3_scriptgen(pcmd character varying, pfldstring text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
v_fldnames text;
BEGIN  

  select string_agg(fname, ',') into v_fldnames from (select	substring(unnest(string_to_array( pfldstring , ',')), position('-(' in unnest(string_to_array( pfldstring , ',')))+ 2, abs((position('-(' in unnest(string_to_array( pfldstring , ',')))+ 2) - length(substring(unnest(string_to_array( pfldstring , ',')), 1, length(unnest(string_to_array( pfldstring , ',')))))))fname where pfldstring is not null) a;

if pcmd='Mandatory' then  
return concat('AxAllowEmpty({', v_fldnames,'},{F})');
elsif pcmd='NonMandatory' then
return concat('AxAllowEmpty({', v_fldnames,'},{T})');
else
return concat(pcmd,'({', v_fldnames,'})');
end if;
 
END;
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_ruledefv3_masking(pmaskstring text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
v_maskstring varchar;
v_maskstringary text[] DEFAULT  ARRAY[]::text[];
v_maskfldcap varchar;
v_maskfldname varchar;
v_masktype varchar;
v_maskchar varchar;
v_maskfirstnchar varchar;
v_masklastnchar varchar;
rec record;
begin

for rec in select unnest(string_to_array(pmaskstring, '~')) maskstr
loop
	v_maskfldcap := split_part(rec.maskstr,'|',1);	
	v_maskfldname := substring(unnest(string_to_array( v_maskfldcap , ',')), position('-(' in unnest(string_to_array( v_maskfldcap , ',')))+ 2, abs((position('-(' in unnest(string_to_array( v_maskfldcap , ',')))+ 2) - length(substring(unnest(string_to_array( v_maskfldcap , ',')), 1, length(unnest(string_to_array( v_maskfldcap , ',')))))));	
	v_masktype := split_part(rec.maskstr,'|',2);
	v_maskchar := split_part(rec.maskstr,'|',3);
	v_maskfirstnchar := split_part(rec.maskstr,'|',4);
	v_masklastnchar := split_part(rec.maskstr,'|',5);

	v_maskstring := case when v_masktype ='Mask few characters' 
					then  concat('AxMask({',v_maskfldname,'},{',v_maskchar,'},{',v_maskfirstnchar,'~',v_masklastnchar,'})')
					else concat('AxMask({',v_maskfldname,'},{',v_maskchar,'},{all})') end;

	v_maskstringary := array_append(v_maskstringary,v_maskstring);
	
end loop;
	
return array_to_string(v_maskstringary,chr(10)) ;
	
end;
$function$
;
>>

<<
CREATE OR REPLACE FUNCTION fn_tstruct_getdcrecid(ptransid character varying, precordid numeric, pdcstring character varying)
 RETURNS TABLE(dcname character varying, rowno numeric, recordid numeric)
 LANGUAGE plpgsql
AS $function$
declare 
v_rec record;
v_rec1 record;
v_sql text;
v_dcname varchar;
v_rowstring varchar;
v_dctable varchar;
v_isgrid varchar;
v_primarydctable varchar;
begin


select tablename into v_primarydctable from axpdc where tstruct=ptransid and dname='dc1';

for v_rec in select unnest(string_to_array(pdcstring,',')) str from dual
Loop
	v_dcname := v_rec.str;
	

	select tablename,asgrid into v_dctable,v_isgrid from axpdc where tstruct=ptransid and dname=v_dcname;

	if v_isgrid = 'F' then 

		v_sql := 'select '''||v_dcname||''' dcname,0 rowno,'||v_dctable||'id recordid from '||v_dctable||' where '||v_primarydctable||'id::numeric='||precordid;
	else 
		v_sql := 'select '''||v_dcname||''' dcname,'||v_dctable||'row rowno,'||v_dctable||'id recordid from '||v_dctable||' where '||v_primarydctable||'id::numeric='||precordid;
	end if;

		for v_rec1 in execute v_sql 
		Loop 		
			dcname :=v_rec1.dcname;
			rowno :=v_rec1.rowno;
			recordid :=v_rec1.recordid;		
			return next;
		end loop; 
	

		 		
end loop;

return;


	
END; 
$function$
;
>>

<<
CREATE TABLE ax_mobilenotify (
	username varchar(50) NULL,
	projectname varchar(50) NULL,
	guid varchar(200) NULL,
	firebase_id varchar(500) NULL,
	imei_no varchar(50) NULL,
	status varchar(2) NULL
);
>>

<<
update axusers set pwdauth='T',otpauth='F';
>>

<<
CREATE TABLE axmmetadatamaster
(
    structtype character varying(10) COLLATE pg_catalog."default",
    structname character varying(15) COLLATE pg_catalog."default",
    structcaption character varying(50) COLLATE pg_catalog."default",
    structstatus character varying(50) COLLATE pg_catalog."default",
    ordno integer,
    createdon timestamp without time zone DEFAULT now(),
    updatedon timestamp without time zone DEFAULT now(),
    createdby character varying(50) COLLATE pg_catalog."default",
    updatedby character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT unique_structtype_structname UNIQUE (structtype, structname)
);
>>

<<
insert into axmmetadatamaster (structtype, structname, structcaption, structstatus, createdon, updatedby, createdby, updatedon)
select distinct 'tstruct' structtype,name structname, caption structcaption,'prepare' structstatus,
to_timestamp(createdon,'dd/mm/yyyy hh24:mi:ss')  createdon,coalesce(updatedby,'admin'),coalesce(createdby,'admin'),
to_timestamp(updatedon,'dd/mm/yyyy hh24:mi:ss')
from tstructs t 
join (select SUBSTR(pagetype, 2) stname from axpages where length(pagetype) > 1) c on t.NAME = c.stname
WHERE NOT EXISTS ( select 1 from axmmetadatamaster m where m.structname = t.name and m.structtype = 'tstruct')
and t.blobno = 1
union all
select distinct 'iview' structtype,name structname, caption structcaption,'prepare' structstatus,
to_timestamp(createdon,'dd/mm/yyyy hh24:mi:ss')   createdon,coalesce(updatedby,'admin'),coalesce(createdby,'admin'),
to_timestamp(updatedon,'dd/mm/yyyy hh24:mi:ss') from iviews i
join (select SUBSTR(pagetype, 2) stname from axpages where length(pagetype) > 1) c on i.NAME = c.stname
WHERE NOT EXISTS ( select 1 from axmmetadatamaster m where m.structname = i.name and m.structtype = 'iview'
) and blobno = 1;
>>

<<
delete from axmmetadatamaster a 
where structtype||structname in('tstructa__ap',
'tstructa__fn',
'tstructa__iq',
'tstructa__pn',
'tstructa__qm',
'tstructad__q',
'tstructad_af',
'tstructad_am',
'tstructad_at',
'tstructad_cp',
'tstructad_it',
'tstructad_lg',
'tstructad_li',
'tstructad_pm',
'tstructad_pn',
'tstructad_pr',
'tstructad_td',
'tstructagspr',
'tstructappsr',
'tstructastcp',
'tstructaxadx',
'tstructaxcal',
'tstructaxcht',
'tstructaxclr',
'tstructaxerr',
'tstructaxfin',
'tstructaxglo',
'tstructaxlov',
'tstructaxpub',
'tstructaxrol',
'tstructaxstc',
'tstructjob_s',
'tstructpgv2a',
'tstructpgv2c',
'tstructpgv2m',
'tstructruldf',
'tstructtemps',
'tstructad__e',
'tstructa__ug',
'tstructaxusr',
'tstructad_pa',
'tstructa__sm',
'iviewad___apt',
'iviewad___ntn',
'iviewad___oqm',
'iviewad__act',
'iviewad__alog',
'iviewad__pgal',
'iviewad__pgnt',
'iviewad__prcd',
'iviewad__qlog',
'iviewad__qls',
'iviewad_implg',
'iviewad_lngst',
'iviewad_pgv2',
'iviewad_txalg',
'iviewadxconfv',
'iviewadxinlog',
'iviewadxoutlo',
'iviewapplogsm',
'iviewauditlog',
'iviewaxapilog',
'iviewaxchtdtl',
'iviewaxemllog',
'iviewaxfinyrs',
'iviewaximpfrc',
'iviewaximplog',
'iviewaxlangs',
'iviewaxnxtlst',
'iviewaxpfinhs',
'iviewaxpubls',
'iviewaxroles',
'iviewaxscrlog',
'iviewaxusers',
'iviewaxusracc',
'iviewcerrm',
'iviewdmlscrpt',
'iviewemaillog',
'iviewemlexcp',
'iviewesmsco',
'iviewiaxex',
'iviewiaxpscon',
'iviewidsco',
'iviewikywd',
'iviewimobc',
'iviewinmemdb',
'iviewitimtk',
'iviewivconfdt',
'iviewivhelpto',
'iviewloview1',
'iviewprintlog',
'iviewprnfail',
'iviewpservers',
'iviewpublist',
'iviewpublsdtl',
'iviewresponse',
'iviewsmslog',
'iviewthint',
'iviewad__papi',
'iviewad___fpr',
'iviewad___red',
'iviewad___rel',
'iviewad___pth',
'tstructa__er',
'iviewad___erc',
'tstructaxurg',
'iviewad_pbcs',
'iviewad___ugu',
'iviewad___ual',
'iviewad___url',
'tstructa__ua',
'tstructad_ur',
'tstructa__cd',
'tstructa__td',
'tstructad_vc',
'tstructapidg',
'tstructaxapi',
'tstructaxcdm',
'tstructaxeml',
'tstructaxipd',
'tstructaxvar',
'tstructb_sql',
'tstructctype',
'tstructsect',
'iviewad___tbd',
'iviewad___ugp',
'iviewappvars',
'iviewaximpdef',
'iviewaxjobs',
'iviewaxpcards',
'iviewaxvars',
'iviewcdlist',
'iviewcsqlist',
'iviewdop_list',
'iviewemaildef',
'iviewexapidef',
'iviewhplist',
'iviewjobcdtl',
'iviewjobtsk',
'iviewad___nwa',
'tstructa__na',
'tstructa_pgm',
'tstructa__ag',
'tstructa__up',
'iviewad___ups',
'iviewad___upg',
'tstructa__re',
'tstructad_db',
'iviewad___upm',
'iviewad___rla',
'tstructa__pu',
'tstructa__hp',
'tstructa__hc',
'tstructad__g',
'tstructad__p',
'tstructad__t',
'tstructad_cd',
'tstructad_cg',
'tstructad_cs',
'tstructad_fg',
'tstructad_fp',
'tstructad_ge',
'tstructad_lm',
'tstructad_md',
'tstructad_rm',
'tstructad_ve',
'tstructaxcad',
'tstructaxctx',
'tstructaxfsc',
'tstructaxftp',
'tstructaxmme',
'tstructaxnxt',
'tstructaxpwf',
'tstructaxrlr',
'tstructaxsrr',
'tstructchcon',
'tstructcusto',
'tstructdgmal',
'tstructdsgcn',
'tstructdsigc',
'tstructerrcd',
'tstructhptst',
'tstructiconf',
'tstructkword',
'tstructmntss',
'tstructmntst',
'tstructNF_AG',
'tstructofcon',
'tstructsendm',
'tstructtconf',
'tstructthelp',
'tstructtstco',
'tstructa__bl',
'tstructa__ur',
'tstructa__co',
'tstructa__ul',
'tstructa__uc',
'tstructad_re',
'iviewad___ucl',
'iviewad___ulg',
'iviewad___cmp',
'iviewad___brn',
'iviewad___acr',
'iviewad___acs',
'iviewad___cfd',
'iviewad___hcg',
'iviewad__fstp',
'iviewad__lgex',
'iviewad_cnfgp',
'iviewaxlngexp',
'iviewForms',
'iviewmainrepo',
'tstructa_guc',
'tstructa_dcm',
'tstructa__dm',
'tstructax_ac',
'iviewad_daccf',
'iviewad_dacmc',
'tstructa_pgt',
'tstructa_dup',
'tstructad__d');
>>