CREATE OR REPLACE FUNCTION pr_go_online_axpdef_toolbar(ptransid character varying, ptype character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
------ Delete toolbar definition tstruct tables
delete from axpdef_toolbar where stransid =    ptransid and stype = ptype;
delete from axpdef_toolbar_groups where stransid =    ptransid and stype = ptype;
delete from axpdef_toolbar_buttons where gtransid =    ptransid and gstype  = ptype;

alter table axpdef_toolbar_buttons disable trigger trg_del_axpdef_toolbar_btn;
alter table axpdef_toolbar_buttons enable trigger trg_del_axpdef_toolbar_btn;
ALTER TABLE axpdef_toolbar DISABLE TRIGGER trg_axpdef_toolbar;

---axpdef_toolbar
insert into axpdef_toolbar(axpdef_toolbarid,cancel ,username ,modifiedon ,createdby ,createdon,app_level ,app_desc ,stransid ,stype ,defaultbtns ,newform )
select nextval('ax_migration_seq') axpdef_toolbarid,'F' cancel,'go_online' username,now() modifiedon ,'go_online' createdby , now() createdon ,
1 app_level ,1 app_desc ,stransid,stype ,string_agg(title,',') defaultbtns ,string_agg(title,',') newform
from
(select a2.name stransid,a2.stype,a2.title 
from axtoolbar a2  
where a2.task is not null and a2.folder ='false' and a2."name" =ptransid and stype = ptype
order by a2.name ,a2.ordno )a
group by stransid ,stype;

ALTER TABLE axpdef_toolbar ENABLE TRIGGER trg_axpdef_toolbar;

----axpdef_toolbar_groups
ALTER TABLE axpdef_toolbar_groups DISABLE TRIGGER trg_ins_axpdef_toolbar_grp;

insert into axpdef_toolbar_groups (axpdef_toolbar_groupsid,cancel ,username ,modifiedon ,createdby ,createdon ,app_level ,app_desc,
stransid ,stype ,grpname,grpcaption ,grpicon ,grpposition ,grpvisible ,grpordno ,mordno ,ngrpname ,dupchk )
select nextval('ax_migration_seq') axpdef_toolbar_groupsid,'F' cancel,'go_online' username,now() modifiedon ,'go_online' createdby , now() createdon ,1 app_level ,1 app_desc ,
a2."name" stransid,a2.stype ,a2.key grpname,a2.title grpcaption,
case when  a2.icon like '%|%' then substring(a2.icon,1,position('|' in a2.icon)-1)  else a2.icon end grpicon,
case when a2.footer ='true' then 'Footer' else 'Default' end grpposition,
case when a2.visible ='true' then 'T' else 'F' end grpvisible,
row_number() over(partition by a2.name order by a2.name,a2.ordno ) grpordno,
row_number() over(partition by a2.name order by a2.name,a2.ordno )-1 mordno
,a2.key ngrpname,a2.name||a2.stype||a2.title dupchk
from axtoolbar a2  
where a2.folder ='true' and a2.name = ptransid and stype =ptype;

ALTER TABLE axpdef_toolbar_groups enable TRIGGER trg_ins_axpdef_toolbar_grp;
----axpdef_toolbar_buttons
ALTER TABLE axpdef_toolbar_buttons DISABLE TRIGGER trg_ins_axpdef_toolbar_btn;

insert into axpdef_toolbar_buttons (axpdef_toolbar_buttonsid,axpdef_toolbarid ,axpdef_toolbar_buttonsrow,
btnname ,btncaption ,btnicon ,btnaction ,btnscript ,btntask ,btnparent ,btnposition ,btnvisible ,gtransid ,gstype,btnordno ,
arows,btnparentcaption )
select nextval('ax_migration_seq') axpdef_toolbar_buttonsid,
c.axpdef_toolbarid ,row_number () over(partition by a2.name order by a2.name,a2.ordno )axpdef_toolbar_buttonsrow,
a2."key" ,a2.title ,
case when  a2.icon like '%|%' then substring(a2.icon,1,position('|' in a2.icon)-1)  else a2.icon end icon,
a2."action" ,a2.script ,a2.task ,a2.parent ,
case when a2.footer ='true' then 'Footer' else 'Default' end btnposition,
case when a2.visible ='true' then 'Yes' else 'No' end btnvisible,
a2.name gtransid,a2.stype gstype ,a2.ordno ,
16+row_number () over(partition by a2.name order by a2.name,a2.ordno ) arows,a3.grpcaption 
from axtoolbar a2  
join  axpdef_toolbar c on a2."name" =c.stransid 
left join axpdef_toolbar_groups a3 on a2."name" =a3.stransid and a2.parent =a3.grpname 
where (length(a2.action ) > 0 or length(a2.script) > 0)and a2.folder ='false' and a2.name= ptransid and a2.stype =ptype;

ALTER TABLE axpdef_toolbar_buttons ENABLE TRIGGER trg_ins_axpdef_toolbar_btn;

end;
$function$
;
