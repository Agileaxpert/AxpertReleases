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