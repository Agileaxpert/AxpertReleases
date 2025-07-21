<<

CREATE OR REPLACE FUNCTION fn_axpanalytics_listdata(ptransid varchar2, pflds clob DEFAULT 'All', ppagesize numeric DEFAULT 25, ppageno numeric DEFAULT 1, pfilter clob DEFAULT 'NA', pusername varchar2 DEFAULT 'admin', papplydac varchar2 DEFAULT 'T', puserrole varchar2 DEFAULT 'All',pconstraints clob DEFAULT NULL)
RETURN SYS.ODCIVARCHAR2LIST

 
IS 
 
v_sql clob;
v_sql1 clob;
v_primarydctable  varchar2(3000);
v_fldnamesary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_join  varchar2(3000);
v_fldname_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_col  varchar2(3000);
v_fldname_normalized  varchar2(3000);
v_fldname_srctbl  varchar2(3000);
v_fldname_srcfld  varchar2(3000);
v_fldname_allowempty  varchar2(3000); 
v_fldname_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_dctablename varchar2(3000);
v_fldname_dcflds varchar2(4000);
v_fldname_transidcnd number;
v_fldname_dctables SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_normalizedtables SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_allflds  varchar2(4000);
v_filter_srcfld varchar2(3000);
v_filter_srctxt  varchar2(3000);
v_filter_join  varchar2(3000);
v_filter_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_dcjoin varchar2(3000);
v_filter_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_cnd  varchar2(3000);
v_filter_cndary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_col varchar2(3000);
v_filter_normalized varchar2(3000);
v_filter_sourcetbl varchar2(3000);
v_filter_sourcefld varchar2(3000);
v_filter_datatype varchar2(3000);
v_filter_listedfld varchar2(3000);
v_filter_tablename varchar2(3000);
v_filter_joinreq number;
t_temp_field_list clob;
v_filter_dcjoinuniq varchar2(3000);
v_final_sqls SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_pegenabled NUMERIC;
v_dacenabled numeric;
v_dactype numeric;
v_dac_join varchar2(4000);
v_dac_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dac_cnd varchar2(4000);
v_dac_cndary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dac_joinreq numeric;
v_dac_normalizedjoinreq numeric; 
 begin
 
 
	select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';	

	select count(1) into v_fldname_transidcnd from axpflds where tstruct = ptransid and dcname ='dc1' and lower(fname)='transid';


	SELECT count(1) INTO v_pegenabled FROM AXPROCESSDEFV2 WHERE TRANSID = ptransid;


		if pflds = 'All' then 

            select tablename||'='||listagg(str,'|')WITHIN GROUP(order by  dcname ,ordno)   into  v_allflds From(	
			select tablename,fname||'~'||srckey||'~'||srctf||'~'||srcfld||'~'||allowempty str,
             dcname ,ordno			
			 from axpflds where tstruct=ptransid and 
			dcname ='dc1' and asgrid ='F' and hidden ='F' and savevalue='T' and tablename = v_primarydctable and datatype not in('i','t')
			union all
			select d.tablename,'app_desc~F~~~T' str,d.dname,1 from axpdc d JOIN AXATTACHWORKFLOW a ON d.tstruct =a.transid 
			where d.tstruct=ptransid and d.dname='dc1'
			order by dcname ,ordno)a GROUP BY tablename;

		end if;

t_temp_field_list := case when pflds='All' then v_allflds else pflds end;

FOR rec2 IN (select column_value as dcdtls from table(string_to_array(t_temp_field_list,'^')) )
LOOP
	v_fldname_dctablename := split_part(rec2.dcdtls,'=',1);
	v_fldname_dcflds := split_part(rec2.dcdtls,'=',2);
	
	if v_fldname_dctablename!=v_primarydctable THEN
		v_fldname_dcjoinsary.Extend;
		v_fldname_dcjoinsary(v_fldname_dcjoinsary.COUNT):= ('left join '||v_fldname_dctablename||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_fldname_dctablename||'.'||v_primarydctable||'id');				    									
	end if;
		v_fldname_dctables.Extend;
		v_fldname_dctables(v_fldname_dctables.COUNT):= v_fldname_dctablename;
					
 	FOR rec1 in  (select column_value as fldname from table(string_to_array(v_fldname_dcflds,'|')))
loop		    	
					v_fldname_col := split_part(rec1.fldname,'~',1);
					v_fldname_normalized := split_part(rec1.fldname,'~',2);
					v_fldname_srctbl := split_part(rec1.fldname,'~',3);
					v_fldname_srcfld := split_part(rec1.fldname,'~',4);					
					v_fldname_allowempty := split_part(rec1.fldname,'~',5);
					
					if v_fldname_normalized ='F' and lower(v_fldname_col)!='app_desc' then 
                         v_fldnamesary.EXTEND;
                         v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_dctablename||'.'||v_fldname_col);
					elsif v_fldname_normalized ='F' and lower(v_fldname_col)='app_desc' then						
						v_fldnamesary.EXTEND;						
						v_fldnamesary(v_fldnamesary.COUNT) := 'case when length('||v_fldname_dctablename||'.wkid)>2 then case '||v_fldname_dctablename||'.app_desc when 0 then  ''Created''
					  when  1 then ''Approved''
					  when  2 then ''Review''
					  when  3 then ''Return''
					  when  4 then ''Approve''
					  when  5 then ''Rejected''
					  when  9 then ''Orphan'' end else null end app_desc';
					elsif v_fldname_normalized ='T' then
                         v_fldnamesary.EXTEND;
						 v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_col||'.'||v_fldname_srcfld||' '||v_fldname_col);
                         v_fldname_joinsary.EXTEND;
						 v_fldname_joinsary(v_fldname_joinsary.count) := (CASE WHEN v_fldname_allowempty='F' THEN ' join ' ELSE ' left join ' end||v_fldname_srctbl||' '||v_fldname_col||' on '||v_primarydctable||'.'||v_fldname_col||' = '||v_fldname_col||'.'||v_fldname_srctbl||'id');
					end if;
			    end loop;
END LOOP;
		   	v_sql := (' select '||''''||ptransid||''' transid,'||v_primarydctable||'.'||v_primarydctable||'id recordid,'||v_primarydctable||'.username modifiedby,'
		   			||v_primarydctable||'.modifiedon,'||v_primarydctable||'.createdon,'||v_primarydctable||'.createdby,'||array_to_string(v_fldnamesary,',')||
		   			',null axpeg_processname,null axpeg_keyvalue,null axpeg_status,null axpeg_statustext from ' 
		   			||v_primarydctable||' '||array_to_string(v_fldname_dcjoinsary,' ')||' '||array_to_string(v_fldname_joinsary,' '));
					


		if pfilter ='NA' then 

        v_sql1 :='select * from(                        
                        select a.*,row_number() over(order by modifiedon desc) rno,'||ppageno||' as  pageno  
                           from ( '||v_sql||array_to_string(v_dac_joinsary,' ')||' where '||v_primarydctable||'.cancel=''F'' 
							--axp_filter 
							'||
                           CASE WHEN v_fldname_transidcnd>0 THEN ' and '||v_primarydctable||'.transid='''||ptransid||''''end||
                           case when v_dacenabled > 0 then ' and '||array_to_string(v_dac_cndary,' and ') end||' )a  order by modifiedon desc             
                                ) b  where rno between '||(ppagesize*(ppageno-1)+1)||' and '||(ppagesize*ppageno);
		else
			FOR rec IN
    			(select column_value as ifilter from table(string_to_array(pfilter,'^')) )
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
					
			    if  v_filter_listedfld='F' then 
								    	
			    	select count(1) into v_filter_joinreq FROM (select distinct column_value from   table(v_fldname_dctables))a where lower(a.column_value)=lower(v_filter_tablename);
			    	
			    	if v_filter_joinreq = 0  then  
				    	v_filter_dcjoin := ' join '||v_filter_tablename||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_filter_tablename||'.'||v_primarydctable||'id';
				    	v_filter_dcjoinsary.EXTEND;
	                   	v_filter_dcjoinsary(v_filter_dcjoinsary.COUNT) := v_filter_dcjoin;
			    	end if;
			    				    		  	
                   	if v_filter_normalized='T' then  	
 		           		v_filter_join := (' join '||v_filter_sourcetbl||' '||v_filter_col||' on '||v_filter_tablename||'.'||v_filter_col||' = '||v_filter_col||'.'||v_filter_sourcetbl||'id');
        	    	   	v_filter_joinsary.EXTEND;
            	       	v_filter_joinsary(v_filter_joinsary.COUNT) := v_filter_join;
                  	end if;
                    
				END IF;
				    if v_filter_normalized='F' then                    
                   		v_filter_cnd := case when v_filter_datatype='c' then 'lower(' END ||(v_filter_tablename||'.'||v_filter_col||case when v_filter_datatype='c' then ')' end||' '||v_filter_srctxt) ;
                    else 
                    	v_filter_cnd := case when v_filter_datatype='c' then 'lower(' END||(v_filter_col||'.'||v_filter_sourcefld||case when v_filter_datatype='c' then ')' end||' '||v_filter_srctxt) ;
                    end if; 

                    v_filter_cndary.EXTEND;
                    v_filter_cndary(v_filter_cndary.COUNT) := v_filter_cnd;

			    end loop;
					SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_filter_dcjoinuniq from(select distinct column_value from   table(v_filter_dcjoinsary));
			   		
                	 v_sql1 := 'select * from(                        
                        select a.*,row_number() over(order by modifiedon desc) rno,'||ppageno||' as  pageno  
                           from ( '||v_sql||' '||v_filter_dcjoinuniq||' '||array_to_string(v_dac_joinsary,' ') ||array_to_string(v_filter_joinsary,' ')||' where '||v_primarydctable||'.cancel=''F'' '||'
							--axp_filter 
							and '||CASE WHEN v_fldname_transidcnd>0 THEN v_primarydctable||'.transid='''||ptransid||''' and 'end
                           ||array_to_string(v_filter_cndary,' and ')||CASE WHEN v_dacenabled > 0 THEN 'and '||array_to_string(v_dac_cndary,' and ') END ||' )a  order by modifiedon desc             
                                ) b  where rno between '||(ppagesize*(ppageno-1)+1)||' and '||(ppagesize*ppageno) ;
		end if;


		   
	v_final_sqls.EXTEND;
	v_final_sqls(v_final_sqls.COUNT) := (v_sql1);

return v_final_sqls;



 END;

>>

<<

CREATE OR REPLACE FUNCTION fn_axpanalytics_metadata(ptransid varchar2, psubentity varchar2 DEFAULT 'F',planguage varchar2 DEFAULT 'English')
 RETURN  axpdef_axpanalytics_mdata
IS
recdata_consoliate_array axpdef_axpanalytics_mdata := axpdef_axpanalytics_mdata();
recdata_dc1_array axpdef_axpanalytics_mdata := axpdef_axpanalytics_mdata();
recdata_subentity_array axpdef_axpanalytics_mdata := axpdef_axpanalytics_mdata();
temp_recdata_subentity_array axpdef_axpanalytics_mdata := axpdef_axpanalytics_mdata();
v_primarydctable varchar2(3000);
v_subentitytable varchar2(3000);
v_sql clob;
v_subentitysql clob;
BEGIN  
  
-- Retrieve primary data table name.
select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';

-- Construct and execute SQL query for primary data.
v_sql :=' select axpdef_axpanalytics_mdata_obj(transid, formcap, fname , fcap, cdatatype, dt,modeofentry , fhide,
	  props,srckey ,srctf ,srcfld ,srctrans ,allowempty,filtercnd,grpfld,aggfld,subentity, datacnd, entityrelfld,
	allowduplicate,tablename,dcname,fordno,dccaption,griddc,listingfld,encrypted,masking,lastcharmask,
	firstcharmask,maskchar,maskroles,customdecimal)
	 from (
select axpflds.tstruct transid,coalesce(lf.compcaption,t.caption) formcap, fname ,coalesce(l.compcaption,axpflds.caption) fcap,customdatatype cdatatype,datatype dt,modeofentry ,hidden fhide,
	null as props,srckey ,srctf ,srcfld ,srctrans ,axpflds.allowempty,
	case when modeofentry =''select'' then case when srckey =''T'' then ''Dropdown'' else ''Text'' end else ''Text'' end filtercnd,
	case when (modeofentry =''select'' or datatype=''c'') then ''T'' else ''F'' end grpfld,
	case when datatype =''n'' then ''T'' else ''F'' end aggfld,''F'' subentity,1 datacnd,null entityrelfld,allowduplicate,axpflds.tablename,
	dcname,ordno fordno,d.caption dccaption,d.asgrid griddc,case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,encrypted,masking,lastcharmask,firstcharmask,maskchar,maskroles,customdecimal
	from axpflds join tstructs t on axpflds.tstruct = t.name
	join axpdc d on axpflds.tstruct = d.tstruct and axpflds.dcname = d.dname
    left join axlanguage l on substr(l.sname,2)= t.name and lower(l.dispname)='''||lower(planguage)||''' and axpflds.fname = l.compname 		
	left join axlanguage lf on substr(lf.sname,2)= t.name and lower(lf.dispname)='''||lower(planguage)||''' and lf.compname=''x__headtext''
	where axpflds.tstruct=:1  and savevalue =''T''	
	union all
	select a.name,coalesce(lf.compcaption,t.caption) ,key,coalesce(l.compcaption,title),	''button'',null,null,''F'',	script|| ''~''|| icon,''F'',null,null,null,null,null,null,null,''F'' subentity,1,null,null
	,null,null,ordno,null,''F'',''F'',null encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
	from axtoolbar a join tstructs t on a.name = t.name
	left join axlanguage l on substr(l.sname,2)= t.name and lower(l.dispname)='''||lower(planguage)||''' and a.key = l.compname
	left join axlanguage lf on substr(lf.sname,2)= t.name and lower(lf.dispname)='''||lower(planguage)||''' and lf.compname=''x__headtext'' 
	where visible = ''true'' and script is not null and a.name= :2
	union all
	select t.name transid,coalesce(lf.compcaption,t.caption) formcap, ''app_desc'' ,''Workflow status'' fcap,null cdatatype,''c'' dt,
	null modeofentry,''F'' fhide,null props,''F'' srckey ,null srctf ,null srcfld ,null srctrans ,''T'' allowempty,''Text'' filtercnd,
	''F'' grpfld,''F'' aggfld,''F'' subentity,1 datacnd,null entityrelfld,''T'' allowduplicate,d.tablename,
	d.dname,1000 fordno,d.caption dccaption,d.asgrid griddc,case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,
	''F'' encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
	from axattachworkflow a join tstructs t on a.transid = t.name 		
	join axpdc d on a.transid = d.tstruct and d.dname =''dc1''		
	left join axlanguage lf on substr(lf.sname,2)= t.name and lower(lf.dispname)='''||lower(planguage)||''' and lf.compname=''x__headtext''
	where t.name=:3  	
    ) x'; 
 
--Bulk collect into Array.    
   execute immediate v_sql bulk collect into recdata_dc1_array using ptransid,ptransid,ptransid;

-- If subentities are requested.  
  if psubentity ='T' then		


    FOR rec IN (
        select distinct a.dstruct ,a.rtype,dprimarytable
		from axentityrelations a 
		join axpdc dc on a.dstruct = dc.tstruct 
		where  mstruct = ptransid )
   	loop	
	   	
 	 
	   	
	   	v_subentitysql :=  'select  axpdef_axpanalytics_mdata_obj( transid,formcap, fname ,fcap,cdatatype,dt,modeofentry ,fhide,
		 props,srckey ,srctf ,srcfld ,srctrans ,allowempty, filtercnd,grpfld,aggfld,subentity,datacnd,entityrelfld,allowduplicate,
		tablename,dcname,fordno,dccaption,griddc,listingfld,encrypted,masking,lastcharmask,firstcharmask,maskchar,maskroles,customdecimal)
		 from (
        select axpflds.tstruct transid,coalesce(lf.compcaption,t.caption) formcap, fname ,coalesce(l.compcaption,axpflds.caption) fcap,customdatatype cdatatype,datatype dt,modeofentry,
		hidden fhide,null props,srckey ,srctf ,srcfld ,srctrans ,axpflds.allowempty,
		case when modeofentry =''select'' then case when srckey =''T'' then ''Dropdown'' else ''Text'' end else ''Text'' end filtercnd,
		case when modeofentry =''select'' then ''T'' else ''F'' end grpfld,
		case when datatype =''n'' then ''T'' else ''F'' end aggfld,''T'' subentity,2 datacnd,
		r.mfield entityrelfld,
		allowduplicate,axpflds.tablename,axpflds.dcname,axpflds.ordno fordno,d.caption dccaption,d.asgrid griddc,
		case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,encrypted,masking,lastcharmask,firstcharmask,maskchar,maskroles,customdecimal
		from axpflds join tstructs t on axpflds.tstruct = t.name  join axpdc d on axpflds.tstruct = d.tstruct and axpflds.dcname = d.dname
		left join axentityrelations r on axpflds.tstruct = r.dstruct and axpflds.fname = r.dfield and r.mstruct=:1 
		left join axlanguage l on substr(l.sname,2)= t.name and lower(l.dispname)='''||lower(planguage)||''' and axpflds.fname = l.compname 
		left join axlanguage lf on substr(lf.sname,2)= t.name and lower(lf.dispname)='''||lower(planguage)||''' and lf.compname=''x__headtext''		
		where axpflds.tstruct=:2 and savevalue =''T'' 
		 union all select '''||rec.dstruct||''',null,''sourceid'',''sourceid'',''Simple Text'',''c'',''accept'',''T'',
		null,''F'',null,null,null,''T'',''F'',''F'',''F'',''T'',2,''recordid'',''T'','''||rec.dprimarytable||''',null,1000,null,''F'',''F'',
		null encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
		 from dual where ''gm''='''||rec.rtype||'''
		UNION ALL
		select t.name transid,coalesce(lf.compcaption,t.caption) formcap, ''app_desc'',''Workflow status'' fcap,null cdatatype,''c'' dt,null modeofentry,
		''F'' fhide,null props,''F'' srckey ,null srctf ,null srcfld ,null srctrans ,''T'' allowempty,
		''Text'' filtercnd,''F'' grpfld,''F'' aggfld,''T'' subentity,2 datacnd,
		null entityrelfld,''T'' allowduplicate,d.tablename,d.dname,1000 fordno,d.caption dccaption,d.asgrid griddc,
		case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,''F'' encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
		from axattachworkflow a join tstructs t on a.transid = t.name 		
		join axpdc d on a.transid = d.tstruct and d.dname =''dc1''			 
		left join axlanguage lf on substr(lf.sname,2)= t.name and lower(lf.dispname)='''||lower(planguage)||''' and lf.compname=''x__headtext''		
		where t.name=:2 ) x' ;

--Bulk collect into Array.         
       execute immediate v_subentitysql bulk collect into temp_recdata_subentity_array using  ptransid,rec.dstruct;

-- Merge subentity data into main array.       
        recdata_subentity_array := recdata_subentity_array multiset union all temp_recdata_subentity_array; 

   end loop;    

   end if;

 -- Consolidate data arrays.  
   recdata_consoliate_array := recdata_dc1_array multiset union all recdata_subentity_array;

-- Return consolidated metadata. 
    RETURN recdata_consoliate_array;
 
   	 

END;

>>

<<

CREATE OR REPLACE FUNCTION fn_axpanalytics_se_listdata(pentity_transid varchar2, pflds_keyval clob, ppagesize numeric DEFAULT 50, ppageno numeric DEFAULT 1)
RETURN SYS.ODCIVARCHAR2LIST
is 
    
v_sql clob;
v_sql1 clob; 
v_fldname_table varchar2(300);
v_fldname_transid  varchar2(3000);
v_fldname_col  varchar2(3000);
v_fldname_normalized  varchar2(3000);
v_fldname_srctbl  varchar2(3000);
v_fldname_srcfld  varchar2(3000);
v_fldname_allowempty  varchar2(3000); 
v_fldname_transidcnd number;
v_allflds  varchar2(3000);
v_fldnamesary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_join  varchar2(3000);
v_fldname_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_tblflds varchar2(4000);
v_emptyary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_pflds_transid  varchar2(3000); 
v_pflds_flds  varchar2(3000);
v_pflds_keyvalue  varchar2(3000);
v_pflds_keytable varchar2(200);
v_keyvalue_fname  varchar2(3000);
v_keyvalue_fvalue  varchar2(3000);
v_keyvalue_fname_srckey varchar2(10);
v_keyvalue_fname_srctbl varchar2(50);
v_keyvalue_fname_srcfld varchar2(50);
v_final_sqls SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_primarydctable varchar2(3000);
v_fields_list varchar2(3000);
v_filter_dcjoinuniq varchar2(3000);
v_fldname_joinsuniq varchar2(3000);
begin	


	
	/*
	 * transid=fldlist=dependfld~depvalue~dependtblname~dependfldprops++transid2=fldlist=dependfld~depvalue
	 * pflds_keyval - transid=tablename!~fldname~normalized~source_table~source_fld~allowempty|fldname2~normalized~source_table~source_fld~allowempty^tablename2!~fldname~normalized~srctbl~srcfld~allowempty=dependfld~dependval++
	 * transid2=tablename!~fldname~normalized~source_table~source_fld~allowempty|fldname2~normalized~source_table~source_fld~allowempty=dependfld~dependval		 
	 */

	FOR rec in  (select column_value as fldkeyvals from  table(string_to_array(pflds_keyval,'++')))    	 
    loop

	    	v_pflds_transid := split_part(rec.fldkeyvals,'=',1);
	    	v_pflds_flds := split_part(rec.fldkeyvals,'=',2);
	    	v_pflds_keyvalue := split_part(rec.fldkeyvals,'=',3);
	    	v_pflds_keytable := split_part(v_pflds_keyvalue,'~',3) ;  
	    	v_keyvalue_fname := split_part(v_pflds_keyvalue,'~',1);
			v_keyvalue_fvalue := split_part(v_pflds_keyvalue,'~',2);		
			v_keyvalue_fname_srckey := split_part(v_pflds_keyvalue,'~',4) ;
			v_keyvalue_fname_srctbl := split_part(v_pflds_keyvalue,'~',5) ;
			v_keyvalue_fname_srcfld := split_part(v_pflds_keyvalue,'~',6) ;	
	    
	    	select tablename into v_primarydctable from axpdc where tstruct =v_pflds_transid and dname ='dc1';
	    
	    	select count(1) into v_fldname_transidcnd from axpflds where tstruct = v_pflds_transid and dcname ='dc1' and lower(fname)='transid';
	    
	    	if  lower(v_pflds_keytable) = lower(v_primarydctable) and v_pflds_flds ='All' then
	    		select tablename||'!~'||listagg(str,'|') within group ( order by dcname ,ordno)  into  v_allflds From(
				select tablename,(fname||'~'||srckey||'~'||srctf||'~'||srcfld||'~'||allowempty) str,
                dcname,ordno
				from axpflds where tstruct=v_pflds_transid and 
				dcname ='dc1' and asgrid ='F' and hidden ='F' and savevalue='T' AND datatype not in('i','t') )a GROUP BY tablename;		    	
			ELSIF lower(v_pflds_keytable) != lower(v_primarydctable) and v_pflds_flds ='All' THEN
				select tablename||'!~'||listagg(str,'|') within group ( order by dcname ,ordno)||'^'||
				v_pflds_keytable||'!~'||split_part(split_part(v_pflds_keyvalue,'~',1),'.',2)||'~'||
				split_part(v_pflds_keyvalue,'~',4)||'~'||split_part(v_pflds_keyvalue,'~',5)||'~'||
				split_part(v_pflds_keyvalue,'~',6)||'~'||split_part(v_pflds_keyvalue,'~',7)
				into  v_allflds From(
				select tablename,(fname||'~'||srckey||'~'||srctf||'~'||srcfld||'~'||allowempty) str,
                dcname,ordno
				from axpflds where tstruct=v_pflds_transid and 
				dcname ='dc1' and asgrid ='F' and hidden ='F' and savevalue='T' AND datatype not in('i','t'))a GROUP BY tablename;	
	    	end if;
			
	    	v_fields_list := case when v_pflds_flds='All' then v_allflds else v_pflds_flds end;

	    for rec1 in (select column_value as tblflds from table(string_to_array(v_fields_list,'^'))) 
	    	loop
			    v_fldname_table := 	split_part(rec1.tblflds,'!~',1);
		    	v_fldname_tblflds := 	split_part(rec1.tblflds,'!~',2);  	
		    
		    if 	lower(v_fldname_table)!=lower(v_primarydctable) then								
				v_fldname_dcjoinsary.EXTEND;
	            v_fldname_dcjoinsary(v_fldname_dcjoinsary.COUNT) := ('left join '||v_fldname_table||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_fldname_table||'.'||v_primarydctable||'id');
			end if;
		
		
			IF	lower(v_fldname_table)!=lower(v_pflds_keytable) then								
				v_fldname_dcjoinsary.EXTEND;
				v_fldname_dcjoinsary(v_fldname_dcjoinsary.COUNT) := ('left join '||v_pflds_keytable||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_pflds_keytable||'.'||v_primarydctable||'id');
			end if;
		
			IF	v_keyvalue_fname_srckey='T' then 				
				v_fldname_joinsary .EXTEND;
				v_fldname_joinsary (v_fldname_joinsary.COUNT):= (' join ' ||v_keyvalue_fname_srctbl||' on '||v_keyvalue_fname||' = '||v_keyvalue_fname_srctbl||'.'||v_keyvalue_fname_srctbl||'id');
			end if;
		    	                
			    FOR rec2 in			    	
    				(select column_value as fldname from table(string_to_array(v_fldname_tblflds,'|'))) 
						loop		    									
							v_fldname_col := split_part(rec2.fldname,'~',1);
							v_fldname_normalized := split_part(rec2.fldname,'~',2);
							v_fldname_srctbl := split_part(rec2.fldname,'~',3);
							v_fldname_srcfld := split_part(rec2.fldname,'~',4);														
							v_fldname_allowempty := split_part(rec2.fldname,'~',5);
												

							if v_fldname_normalized ='F' and lower(v_fldname_col)!='app_desc' then 
                             v_fldnamesary.EXTEND;
                             v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_table||'.'||v_fldname_col);
                            elsif v_fldname_normalized ='F' and lower(v_fldname_col)='app_desc' then						
								v_fldnamesary.EXTEND;						
								v_fldnamesary(v_fldnamesary.COUNT) := 'case when length('||v_fldname_table||'.wkid)>2 then case '||v_fldname_table||'.app_desc when 0 then  ''Created''
								  when  1 then ''Approved''
								  when  2 then ''Review''
								  when  3 then ''Return''
								  when  4 then ''Approve''
								  when  5 then ''Rejected''
								  when  9 then ''Orphan'' end else null end app_desc';
							elsif v_fldname_normalized ='T' then	
                             v_fldnamesary.EXTEND;
                             v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_col||'.'||v_fldname_srcfld||' '||v_fldname_col);	

                             v_fldname_joinsary.EXTEND;
                             v_fldname_joinsary(v_fldname_joinsary.COUNT) := (case when v_fldname_allowempty='F' then ' join ' else ' left join ' end||v_fldname_srctbl||' '||v_fldname_col||' on '||v_fldname_table||'.'||v_fldname_col||' = '||v_fldname_col||'.'||v_fldname_srctbl||'id');

							 end if;	

			    		end loop;
	    	end loop;
	    
	    	
	    	SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_filter_dcjoinuniq from(select distinct column_value from   table(v_fldname_dcjoinsary));
			SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_fldname_joinsuniq from(select distinct column_value from   table(v_fldname_joinsary));
		
		 
				v_sql := (' select '||''''||v_pflds_transid||''' transid,'||v_primarydctable||'.'||v_primarydctable||'id recordid,'||v_primarydctable||'.username modifiedby,'||v_primarydctable||'.modifiedon,'||v_primarydctable||'.createdon,'||v_primarydctable||'.createdby,'||array_to_string(v_fldnamesary,',')
		   			 ||' from '
		   			 ||v_primarydctable||' '||v_filter_dcjoinuniq||' '||v_fldname_joinsuniq
		   			 ||' where '||v_primarydctable||'.cancel=''F'' and '
                     ||case when v_fldname_transidcnd>0 then v_primarydctable||'.transid='||''''||v_pflds_transid||''' and ' END
                     ||case when v_keyvalue_fname_srckey='T'  then v_keyvalue_fname_srctbl||'.'||v_keyvalue_fname_srcfld else v_keyvalue_fname end ||'='||v_keyvalue_fvalue
                     ||'				
					--axp_filter');

		   				v_fldnamesary:= v_emptyary;
		   				v_fldname_joinsary:= v_emptyary;	  
		   				v_fldname_dcjoinsary:=v_emptyary; 
		   				

       v_sql1 :='select * from(                        
                        select a.*,row_number() over(order by modifiedon desc) rno,'||ppageno||' as  pageno  
                           from ( '||v_sql||' )a where rownum <='||(ppagesize*ppageno)||' order by modifiedon desc             
                                ) b  where rno between '||(ppagesize*(ppageno-1)+1)||' and '||(ppagesize*ppageno);


	v_final_sqls.EXTEND;
	v_final_sqls(v_final_sqls.COUNT) := (v_sql1);
    END LOOP;

   	

RETURN v_final_sqls;
END;

>>