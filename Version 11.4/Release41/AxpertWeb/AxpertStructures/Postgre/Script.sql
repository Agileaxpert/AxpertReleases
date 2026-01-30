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

 select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';



 select count(1) into v_fldname_transidcnd from axpflds where tstruct = ptransid and dcname ='dc1' and lower(fname)='transid';

  if pflds = 'All' then   
   select concat(tablename,'=',string_agg(str,'|'))  into v_allflds From(
   select tablename, concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~',allowempty) str,dcname,ordno
   from axpflds where tstruct=ptransid and dcname='dc1' and 
   asgrid ='F' and hidden ='F' and savevalue='T' and tablename = v_primarydctable and datatype not in('i','t')
   union all
   select DISTINCT tablename,'app_desc~F~~~T' str,dname,1 from axpdc where tstruct=ptransid and dname='dc1'
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
       
    
     
     if v_fldname_normalized ='F' and lower(v_fldname_col)!='app_desc' then       
      v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_dctablename,'.',v_fldname_col)::varchar);
     elsif v_fldname_normalized ='F' and lower(v_fldname_col)='app_desc' then      
      v_fldnamesary:= array_append(v_fldnamesary,concat('case when length(',v_primarydctable,'.wkid)>2 then case ',v_primarydctable,'.app_desc when 0 then  ''Created''
  when  1 then ''Approved''
  when  2 then ''Review''
  when  3 then ''Return''
  when  4 then ''Approve''
  when  5 then ''Rejected''
  when  9 then ''Orphan'' end else null end app_desc'));
     elsif v_fldname_normalized ='T' then 
      v_fldnamesary := array_append(v_fldnamesary,concat(v_fldname_col,'.',v_fldname_srcfld,' ',v_fldname_col)::varchar); 
      v_fldname_joinsary := array_append(v_fldname_joinsary,concat(case when v_fldname_allowempty='F' then ' join ' else ' left join ' end,v_fldname_srctbl,' ',v_fldname_col,' on ',v_fldname_dctablename,'.',v_fldname_col,' = ',v_fldname_col,'.',v_fldname_srctbl,'id')::Varchar);
      v_fldname_normalizedtables := array_append(v_fldname_normalizedtables,lower(v_fldname_srctbl));
     end if;
        
       end loop;
     
      end loop;
      v_sql := concat(' select ','''',ptransid,''' transid,',v_primarydctable,'.',v_primarydctable,'id recordid,',v_primarydctable,'.username modifiedby,',v_primarydctable,'.modifiedon,',v_primarydctable,'.createdon,',v_primarydctable,'.createdby,',
         array_to_string(v_fldnamesary,','),',null axpeg_processname,null axpeg_keyvalue,null axpeg_status,null axpeg_statustext from ',v_primarydctable,' ',
         array_to_string(v_fldname_dcjoinsary,' '),' ',array_to_string(v_fldname_joinsary,' '));
 

        
---------DAC filters
      if papplydac = 'T' then     
     v_dac_cnd := replace(pconstraints,'{primarytable.}',v_primarydctable||'.');                                      
      end if;        
        
   
  if coalesce(pfilter,'NA') ='NA' then 

		if ppagesize > 0 then 
		   v_sql1 := concat('select b.* from(select a.*,row_number() over(order by modifiedon desc)::Numeric rno,
		   case when mod(row_number() over(order by modifiedon desc),',ppagesize,')=0 then row_number() over(order by modifiedon desc)/',ppagesize,' else row_number() over(order by modifiedon desc)/',ppagesize,'+1 end::numeric pageno from 
		   (',concat(v_sql,' where ',v_primarydctable,'.cancel=''F''',case when v_fldname_transidcnd>0 then concat(' and ',v_primarydctable,'.transid=','''',ptransid,'''') else '' end,
		   case when papplydac ='T' then concat(' and (',v_dac_cnd,')') end),'
		   --axp_filter
		   ',')a order by modifiedon desc limit ',ppagesize*ppageno,' )b ',case when ppageno=0 then '' else concat('where pageno=',ppageno) end);
		else 
			v_sql1 :=concat('select b.* from(select a.*,row_number() over(order by modifiedon desc)::Numeric rno,1 pageno from 
			(',concat(v_sql,' where 1=1 ',case when v_fldname_transidcnd>0 then ' and '||v_primarydctable||'.transid='||''''||ptransid||'''' end,
			case when papplydac ='T' and length(v_dac_cnd) > 2 then concat(' and (',v_dac_cnd,')') end),'
			--axp_filter
			',')a order by modifiedon desc)b ');
		end if;
 
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
      
		     if ppagesize > 0 then 
					v_sql1 := concat('select b.* from(select a.*,row_number() over(order by modifiedon desc)::Numeric rno,
				    case when mod(row_number() over(order by modifiedon desc),',ppagesize,')=0 then row_number() over(order by modifiedon desc)/',ppagesize,' else row_number() over(order by modifiedon desc)/',ppagesize,'+1 end::numeric pageno from 
				    (',v_sql,concat(array_to_string(v_filter_dcjoinsary,' '),array_to_string(v_filter_joinsary,' '),' where ',v_primarydctable,'.cancel=''F'' and ',case when v_fldname_transidcnd>0 then concat(v_primarydctable,'.transid=','''',ptransid,''' and ') else '' end,
				    array_to_string(v_filter_cndary,' and '),case when papplydac ='T' then concat(' and (',v_dac_cnd,')') end),'
				    --axp_filter
				    ',')a order by modifiedon desc limit ',ppagesize*ppageno,' )b ',case when ppageno=0 then '' else concat('where pageno=',ppageno) end); 
			 else 	
					v_sql1 := concat('select b.* from(select a.*,row_number() over(order by modifiedon desc)::Numeric rno,1 pageno from 
					(',v_sql,concat(array_to_string(v_filter_dcjoinsary,' '),array_to_string(v_filter_joinsary,' '),' where 1=1 '
					,case when v_fldname_transidcnd>0 then concat(' and ',v_primarydctable,'.transid=','''',ptransid,''' and ') else ' and ' end,
					array_to_string(v_filter_cndary,' and '),case when papplydac ='T' and length(v_dac_cnd) > 2 then concat(' and (',v_dac_cnd,')') end),'
					--axp_filter
					)a order by modifiedon desc)b ');		
					
			 end if;	
		               
  end if;

return v_sql1;


END; $function$
;
>>