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
   select DISTINCT d.tablename,'app_desc~F~~~T' str,d.dname,1 from axpdc d JOIN AXATTACHWORKFLOW a ON d.tstruct =a.transid 
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
		IF ppagesize > 0 then
	        v_sql1 :='select * from(                        
	                        select a.*,row_number() over(order by modifiedon desc) rno,'||ppageno||' as  pageno  
	                           from ( '||v_sql||array_to_string(v_dac_joinsary,' ')||' where '||v_primarydctable||'.cancel=''F'' 
	       --axp_filter 
	       '||
	                           CASE WHEN v_fldname_transidcnd>0 THEN ' and '||v_primarydctable||'.transid='''||ptransid||''''end||
	                           case when v_dacenabled > 0 then ' and '||array_to_string(v_dac_cndary,' and ') end||' )a  order by modifiedon desc             
	                                ) b  where rno between '||(ppagesize*(ppageno-1)+1)||' and '||(ppagesize*ppageno);
		ELSE
			v_sql1 :='select * from(                        
		                        select a.*,row_number() over(order by modifiedon desc) rno,1 as  pageno  
		                           from ( '||v_sql||' where 1=1 '||
		                           CASE WHEN v_fldname_transidcnd>0 THEN ' and '||v_primarydctable||'.transid='''||ptransid||''''end||
		                           case when papplydac ='T' AND LENGTH(v_dac_cnd)  > 2 THEN (' and ('||v_dac_cnd||')') end||                           
		                           '--axp_filter  
									)a  order by modifiedon desc) b';
		END IF;
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
        
    	IF ppagesize = 0 then
                  v_sql1 := 'select * from(                        
                        select a.*,row_number() over(order by modifiedon desc) rno,'||ppageno||' as  pageno  
                           from ( '||v_sql||' '||v_filter_dcjoinuniq||' '||array_to_string(v_dac_joinsary,' ') ||array_to_string(v_filter_joinsary,' ')||' where '||v_primarydctable||'.cancel=''F'' '||'
      				 --axp_filter 
       					and '||CASE WHEN v_fldname_transidcnd>0 THEN v_primarydctable||'.transid='''||ptransid||''' and 'end
                           ||array_to_string(v_filter_cndary,' and ')||CASE WHEN v_dacenabled > 0 THEN 'and '||array_to_string(v_dac_cndary,' and ') END ||' )a  order by modifiedon desc             
                                ) b  where rno between '||(ppagesize*(ppageno-1)+1)||' and '||(ppagesize*ppageno) ;
		ELSE
				v_sql1 := 'select * from(select a.*,row_number() over(order by modifiedon desc) rno,1 as  pageno  
                           from ( '||v_sql||' '||v_filter_dcjoinuniq||' '||array_to_string(v_filter_joinsary,' ')||' where 1=1 '							
							||CASE WHEN v_fldname_transidcnd>0 THEN ' and '||v_primarydctable||'.transid='''||ptransid||''' and ' ELSE ' and ' end
                           ||array_to_string(v_filter_cndary,' and ')
                           ||CASE WHEN papplydac ='T' and length(v_dac_cnd) > 2 THEN (' and ('||v_dac_cnd||')') END ||' 
							--axp_filter
							)a  order by modifiedon desc) b';
		
		END IF;
	
  end if;


     
 v_final_sqls.EXTEND;
 v_final_sqls(v_final_sqls.COUNT) := (v_sql1);

return v_final_sqls;



 END;
>>