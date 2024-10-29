<< ALTER TABLE axprocessdefv2 add subindexno number(10); >>

<< ALTER TABLE AXACTIVETASKS  ADD MAPFIELD_GROUP varchar2(1000); >>

<<ALTER TABLE axprocessdefv2 ADD MAPFIELD_GROUP varchar2(1000); >>

<<ALTER TABLE axprocessdef ADD MAPFIELD_GROUP varchar2(1000); >>

<<alter table AXPROCESSDEFV2 add DIsplaySubTitle varchar2(2000); >>

<<alter table AXPROCESSDEFV2 add DisplayButtons varchar2(200); >>

<<ALTER TABLE axprocessdefv2 ADD action_buttons varchar2(100); >>

<<

CREATE OR REPLACE FUNCTION fn_ruledef_table_genaxscript(pcmd IN varchar2, ptbldtls IN varchar2, pcnd IN number)
RETURN varchar2
IS
v_formula varchar(2000);

   BEGIN

if pcnd=1 then 	   

WITH a AS (SELECT TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)) AS cols
		from dual 
		CONNECT BY REGEXP_SUBSTR (ptbldtls,'[^~]+',1,LEVEL) IS NOT NULL )
,b as(select CASE WHEN TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2)) NOT in('In','Not in') THEN substr(rtrim(substr(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),'-(')+2),')'),2) ELSE ' ' END||
case when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Equal to' then '='
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Not equal to' then '#'
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Greater than' then '>'
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Lesser than' then '<' 
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2)) in('In','Not in') then 'StringPOS('||substr(rtrim(substr(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),'-(')+2),')'),2)||','
	end||' '||
	case when substr(rtrim(substr(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),'-(')+2),')'),1,1) in('c','t')
	then '{'||TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 3))||'}' 	else TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 3))end ||
	case when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='In' then ') # -1' when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Not in' then ') = -1' else '' end||' '||
	case when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='And' then '&'
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='Or' then '|' 
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='And(' then '&('
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='Or(' then '|('
	else TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4)) END cstr
FROM a)
		SELECT pcmd||' '||LISTAGG(cstr,' ') WITHIN GROUP(order BY rownum)  into v_formula  FROM b;

elsif pcnd =2 then 
select case when pcmd ='Show' then 'Axunhidecontrols({'||fnames||'})'
	when pcmd ='Hide' then 'Axhidecontrols({'||fnames||'})'
	when pcmd ='Enable' then 'Axenablecontrols({'||fnames||'})'
	when pcmd ='Disable' then 'Axdisablecontrols({'||fnames||'})'
	when pcmd ='Mandatory' then 'AxAllowEmpty({'||fnames||'},{F})'
	when pcmd ='Non mandatory' then 'AxAllowEmpty({'||fnames||'},{T})' end  into v_formula 
	from 	 
	(SELECT listagg(rtrim(substr(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),'-(')+2),')'),',') WITHIN GROUP (ORDER BY 1) AS fnames
		from dual 
		CONNECT BY REGEXP_SUBSTR (ptbldtls,'[^~]+',1,LEVEL) IS NOT NULL)b;
	
elsif pcnd in(3,31) then  

	select case 
	when pcmd='Mask few characters' then 
	'AxMask({'||rtrim(substr(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),'-(')+2),')')||'}'
	||',{'||TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 2, 2))||'},{'||
	TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 3, 3))||'~'||
	TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 4, 4))||'})' 
	when pcmd ='Mask all characters' then 
	'AxMask({'||rtrim(substr(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),'-(')+2),')')||'}'||
	',{'||TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 2, 2))||'},{all})'
	end  into v_formula 
	FROM dual
	CONNECT BY REGEXP_SUBSTR (ptbldtls,'[^~]+',1,LEVEL) IS NOT NULL;

elsif pcnd=4 then

	SELECT listagg('SetValue({'||rtrim(substr(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),'-(')+2),')')||'},1,{'||
	TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 2))||'})',chr(10)) WITHIN GROUP(ORDER BY rownum) INTO v_formula
		from dual 
		CONNECT BY REGEXP_SUBSTR (ptbldtls,'[^~]+',1,LEVEL) IS NOT NULL;
	
elsif pcnd=5 then  
	select case when pcmd='Show message' then 'ShowMessage({'||ptbldtls||'},{Simple},{})'
	when pcmd='Show error' then 'ShowMessage({'||ptbldtls||'},{Exception},{})' end  into v_formula
	from dual;

elsif pcnd=6 then 
	v_formula := pcmd;

------------used in PEG for Set value
elsif pcnd=7 then 
	SELECT listagg('SetValue({'||rtrim(substr(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),'-(')+2),')')||'},1,{'||
	TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 2))||'})',chr(10)) WITHIN GROUP(ORDER BY rownum) INTO v_formula
		from dual 
		CONNECT BY REGEXP_SUBSTR (ptbldtls,'[^~]+',1,LEVEL) IS NOT NULL;

end if;
	 
RETURN v_formula;
END;

>>

<<

ALTER TABLE AXFORMNOTIFY ADD TBL_NAVIGATIONPARAM VARCHAR2(4000);

>>

----------Oracle 

<<

create table bk19924_ax_layoutdesign_saved as select * from ax_layoutdesign_saved;

>>

<<

create table bk19924_ax_layoutdesign as select * from ax_layoutdesign;

>>

<<

merge INTO ax_layoutdesign_saved a
using (SELECT 'axglo' transid FROM dual) v on (v.transid= a.transid)
when not matched then
INSERT (design_id, transid, module, content, created_by, updated_by, is_deleted, created_on, updated_on, is_migrated, is_publish, is_private, parent_design_id, responsibility, order_by) VALUES(0, 'axglo', 'TSTRUCT', '[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]', 'admin', 'admin', 'N', sysdate, sysdate, 'N', 'Y', 'N', 66, NULL, NULL)
when matched then
update set content='[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]';

>>

<<

merge INTO ax_layoutdesign a
using (SELECT 'axglo' transid FROM dual) v on (v.transid= a.transid)
when not matched then
INSERT (design_id, transid, module, content, created_by, updated_by, is_deleted, is_private, created_on, updated_on, is_migrated) VALUES(0, 'axglo', 'TSTRUCT', '[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]', 'admin', 'admin', 'N', 'N', sysdate, sysdate, 'N')
when matched then
update set content='[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]';

>>

<<

update axp_cards set inhomepage=case when cardtype='kpi' then 'T' else 'F' end

>>

<<

CREATE SEQUENCE AX_ENTITY_RELSEQ INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999 NOCYCLE CACHE 2000 NOORDER;

>>

<<

CREATE OR REPLACE FUNCTION SPLIT_PART(P_VALUE IN VARCHAR2,P_SEPERATOR  IN VARCHAR2,P_POSITION IN INTEGER)
RETURN VARCHAR2
AS
T_VALUE VARCHAR2(32000);
T_RESULT VARCHAR2(32000); 
T_START_POSITION INTEGER;
T_END_POSITION INTEGER;
BEGIN


IF P_POSITION=1 THEN 
T_RESULT := SUBSTR(P_VALUE,1,INSTR(P_VALUE,P_SEPERATOR,1,P_POSITION)-1);
ELSE 
T_VALUE := P_VALUE||P_SEPERATOR;
T_START_POSITION := INSTR(T_VALUE,P_SEPERATOR,1,P_POSITION-1)+length(P_SEPERATOR);
T_END_POSITION := INSTR(T_VALUE,P_SEPERATOR,1,P_POSITION)-T_START_POSITION;
T_RESULT := SUBSTR(P_VALUE,T_START_POSITION,T_END_POSITION);
END IF;


RETURN T_RESULT;


END;

>>

<<

CREATE OR REPLACE FUNCTION array_to_string(input_array IN sys.ODCIVARCHAR2LIST,input_separator in VARCHAR2 default ',')
  RETURN clob
IS

v_result clob;

BEGIN

   select  replace(LISTAGG(COALESCE(NULLIF(column_value, ''), '@@@nullvalreplce@@@'), input_separator) WITHIN GROUP (ORDER BY rownum),'@@@nullvalreplce@@@','')  into v_result  
   from table(input_array) colval  ;

  RETURN v_result;
END;

>>

<<

CREATE OR REPLACE FUNCTION string_to_array(input_string IN VARCHAR2,input_separator in VARCHAR2 default ',')
  RETURN SYS.ODCIVARCHAR2LIST
IS
  parsed_array SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
BEGIN

FOR ROWSTR IN (
SELECT 
  REGEXP_SUBSTR(input_string, '[^'||input_separator||']+', 1, LEVEL) AS val
FROM 
  dual
CONNECT BY 
  REGEXP_SUBSTR(input_string, '[^'||input_separator||']+', 1, LEVEL) IS NOT NULL
)  LOOP 

parsed_array.EXTEND;
parsed_array(parsed_array.COUNT) := ROWSTR.val;

END LOOP;


  RETURN parsed_array;
END;

>>

<<

CREATE OR REPLACE TYPE axpdef_axpanalytics_mdata IS TABLE OF axpdef_axpanalytics_mdata_obj;

>>

<<

CREATE OR REPLACE TYPE axpdef_axpanalytics_mdata_obj AS object(
	ftransid varchar2(10),
	fcaption varchar2(500),
	fldname varchar2(50),
	fldcap varchar2(500),
	cdatatype varchar2(50),
	fdatatype varchar2(50),
	fmodeofentry varchar2(50),
	hide varchar2(10),
	props varchar2(4000),
	normalized varchar2(10),	
	srctable varchar2(50),
	srcfield varchar2(50),
	srctransid varchar2(10),
	allowempty varchar2(10),
	filtertype varchar2(50),
	grpfield varchar2(10),
	aggfield varchar2(10),
	subentity varchar2(1),
	datacnd numeric(1,0),
	entityrelfld varchar2(100),
	allowduplicate varchar2(2),
	tablename varchar2(100),
	dcname varchar2(10),
	fordno NUMERIC(5,0),
	dccaption varchar2(100),
	griddc varchar2(2),
	listingfld varchar2(1));

>>

<<

CREATE OR REPLACE TYPE axpdef_axpanalytics_peg IS TABLE OF axpdef_axpanalytics_peg_obj;

>>

<<

CREATE OR REPLACE TYPE axpdef_axpanalytics_peg_obj AS object(
	axpeg_processname varchar2(200),axpeg_keyvalue varchar2(200),axpeg_status NUMERIC,axpeg_statustext varchar2(4000),axpeg_recordid numeric);

>>

<<
	
CREATE OR REPLACE PROCEDURE fn_axpanalytics_ins_axreltn 
AS
BEGIN 

delete from axentityrelations where  rtype !='custom';

insert into axentityrelations ( 
axentityrelationsid,cancel,username,modifiedon,createdby,createdon,app_level,app_desc,
rtype,mstruct,mfield,mtable,primarytable,dstruct,dfield,dtable,rtypeui,mstructui,mfieldui,dstructui,dfieldui,dprimarytable)
  select ax_entity_relseq.NEXTVAL  AS axentityrelationsid,x.*
 from (
 SELECT DISTINCT  
    'F' AS cancel,
    'admin' AS username,
    SYSDATE AS modifiedon,
    'admin' AS createdby,
    SYSDATE AS createdon,
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
    'Dropdown' AS rtypeui,
    (mt.caption|| '-('|| mt.name|| ')') AS mstructui,
    (m.caption|| '-('|| m.fname|| ')') AS mfieldui,
    (dt.caption|| '-('|| dt.name|| ')') AS dstructui,
    (d.caption|| '-('|| d.fname|| ')') AS dfieldui,
    ddc.tablename AS dprimarytable
   FROM ( SELECT DISTINCT axrelations.mstruct,
            axrelations.dstruct,
            axrelations.mfield,
            axrelations.dfield,
            axrelations.rtype
           FROM axrelations) a
     JOIN tstructs mt ON a.mstruct = mt.name
     JOIN tstructs dt ON a.dstruct = dt.name
     LEFT JOIN axpflds m ON a.mstruct = m.tstruct AND a.mfield = m.fname
     LEFT JOIN axpflds d ON a.dstruct = d.tstruct AND a.dfield = d.fname
     LEFT JOIN axpdc dc ON a.mstruct = dc.tstruct AND dc.dname = 'dc1'
     LEFT JOIN axpdc ddc ON a.dstruct = ddc.tstruct AND ddc.dname = 'dc1'
  WHERE a.rtype = 'md'
UNION ALL
 SELECT DISTINCT
    'F' AS cancel,
    'admin' AS username,
    sysdate AS modifiedon,
    'admin' AS createdby,
    sysdate AS createdon,
    1 AS app_level,
    1 AS app_desc,
    'gm' AS rtype,
    a.tstruct AS mstruct,
    concat(sd.tablename, 'id') AS mfield,
    sd.tablename AS mtable,
    pd.tablename AS primarytable,
    a.targettstr AS dstruct,
    'sourceid' AS dfield,
    td.tablename AS dtable,
    'Genmap' AS rtypeui,
    (mt.caption|| '-('||mt.name|| ')') AS mstructui,
    NULL AS mfieldui,
    (dt.caption|| '-('|| dt.name|| ')') AS dstructui,
    NULL AS dfieldui,
    td.tablename AS dprimarytable
   FROM axpgenmaps a
     JOIN tstructs mt ON a.tstruct = mt.name
     JOIN tstructs dt ON a.targettstr = dt.name
     LEFT JOIN axpdc sd ON a.tstruct = sd.tstruct AND sd.dname = a.basedondc
     LEFT JOIN axpdc td ON a.targettstr = td.tstruct AND td.dname = 'dc1'
     LEFT JOIN axpdc pd ON a.tstruct = pd.tstruct AND pd.dname = 'dc1'
    )x ;

   commit; 

END;

>>

<<

CREATE OR REPLACE FUNCTION fn_axpanalytics_ap_charts(pentity_transid varchar2, pcriteria varchar2, pfilter varchar2, pusername varchar2 DEFAULT 'admin', papplydac varchar2 DEFAULT 'T')
RETURN SYS.ODCIVARCHAR2LIST
--RETURN varchar2
IS
--rec record;
--rec_filters record;
v_primarydctable varchar2(100);
v_subentitytable varchar2(100);
v_transid varchar2(10);
v_grpfld varchar2(100);
v_aggfld varchar2(100);
v_aggfnc varchar2(100);
v_srckey varchar2(100);
v_srctbl varchar2(100);
v_srcfld varchar2(100);
v_aempty varchar2(10);
v_aggfldtable varchar2(100);
v_sql clob;
v_normalizedjoin varchar2(2000);
v_keyname varchar2(100);
v_entitycond varchar2(100);
v_keyfld_fname varchar2(100);
v_keyfld_fval varchar2(4000);
v_final_sqls SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_transidcnd number;
v_sql1 clob;
v_filter_srcfld varchar2(100);
v_filter_srctxt varchar2(100);
v_filter_join varchar2(4000);
v_filter_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_cnd varchar2(100);
v_filter_cndary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_joinreq number;
v_filter_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_col varchar2(1000);
v_filter_normalized varchar2(4000);
v_filter_sourcetbl varchar2(100);
v_filter_sourcefld varchar2(100);
v_filter_datatype varchar2(100);
v_filter_listedfld varchar2(10);
v_filter_tablename varchar2(100);
v_emptyary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dacenabled number;
v_grpfld_tbl varchar2(100);
v_grpfld_tablejoins varchar2(4000);
v_aggfld_tablejoins varchar2(4000);
v_tablejoins varchar2(4000);
v_aggfldtransid varchar2(10);
v_aggfld_primarydctable varchar2(100);
v_entityrelation varchar2(4000);
v_aggfldname_transidcnd numeric;
v_entity_parent_reltable varchar2(100);
v_entity_child_reltable varchar2(100);
v_filter_dcjoinuniq varchar2(4000);
begin

	/*	  
	 * pcriteria_v1 - transid~aggfnc~groupfld~normalized~srctable~srcfld~allowempty~grpfld_tablename~aggfld~aggfld_tablename(Not in use)	 
	 * pcriteria_v2 - aggfnc~grpfld_transid~groupfld~normalized~srctable~srcfld~allowempty~grpfld_tablename~aggfld_transid~aggfld~aggfld_tablename~grpfld_transid_AND_aggfld_transid_relation
	 * Ex1(agg fld in Non grid dc) - sum~gcust~party_name~F~~~~mg_partyhdr~slord~total_discount~salesorder_header~mg_partyhdr.mg_partyhdrid = salesorder_header.customer
	 * Ex2(agg fld in grid dc) - sum~gcust~party_name~F~~~~mg_partyhdr~slord~taxableamount~salesorder_items~mg_partyhdr.mg_partyhdrid = salesorder_header.customer

	*/ 	 
	
	
	select lower(trim(tablename)) into v_primarydctable from axpdc where tstruct = pentity_transid and dname ='dc1';
	
	select count(1) into v_fldname_transidcnd from axpflds where tstruct = pentity_transid and lower(tablename)=lower(v_primarydctable) and lower(fname)='transid';	
	
	
	
	    FOR rec IN(SELECT column_value criteria  from table(string_to_array(pcriteria,'^')))  
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
				
				
				v_normalizedjoin := case when v_srckey='T' then ' left join '||v_srctbl||' b on '||v_grpfld_tbl||'.'||v_grpfld||' = b.'||v_srctbl||'id ' else ' ' end;
				v_keyname := case when length(v_grpfld) > 0 then case when v_srckey='T' then 'b.'||v_srcfld else v_grpfld_tbl||'.'||v_grpfld end else ' ' end;			
			
			
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
				
				v_tablejoins := v_grpfld_tablejoins||' '||v_aggfld_tablejoins;
			
			end if; ------- v_transid = v_aggfldtransid
				
			
			
			select 'select '||v_keyname||' keyname,'||case when lower(trim(v_aggfnc)) in ('sum','avg') then 'round('||v_aggfnc||'('||v_aggfld||'),2)'else v_aggfnc||'('||v_aggfld||')' END||
			'keyvalue,'||''''||rec.criteria||''''||' criteria from '||v_tablejoins||' '||v_normalizedjoin into v_sql FROM dual;
																											
			
			
				if coalesce(pfilter,'NA') ='NA' then 
				
				
			v_sql1 := v_sql||' where '||v_primarydctable||'.cancel=''F'''||
						case when v_fldname_transidcnd > 0 then ' and '||v_primarydctable||'.transid='''||pentity_transid||'''' END||
						case when v_transid != v_aggfldtransid then ' and '||v_aggfld_primarydctable||'.cancel=''F''' END||
						case when v_aggfldname_transidcnd > 0 then ' and '||v_aggfld_primarydctable||'.transid='''||v_aggfldtransid||'''' END||
						case when length(v_grpfld) > 0 then ' group by '||v_keyname else '' end;
	
		else 
			FOR rec_filters IN(select column_value ifilter FROM table(string_to_array(pfilter,'^'))  )
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
				    	v_filter_dcjoinsary.Extend;
				    	v_filter_dcjoinsary(v_filter_dcjoinsary.COUNT):= (' join '||v_filter_tablename||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_filter_tablename||'.'||v_primarydctable||'id');
			    	end if;
			    
			    	
			    
		    		select case when v_filter_normalized='T' 
					then ' join '||v_filter_sourcetbl||' '||v_filter_col||' on '||v_filter_tablename||'.'||v_filter_col||' = '||v_filter_col||'.'||v_filter_sourcetbl||'id'
					end into v_filter_join from dual where v_filter_normalized='T';
					
					 						
					v_filter_dcjoinsary.Extend;
					v_filter_dcjoinsary(v_filter_dcjoinsary.COUNT):=(v_filter_join);
					
				
					end if;
			
									
					select case when v_filter_normalized='F' 
					then case when v_filter_datatype='c' then 'lower(' END||v_filter_tablename||'.'||v_filter_col||case when v_filter_datatype='c' then ')' END||' '||v_filter_srctxt 
					else case when v_filter_datatype='c' then 'lower(' END||v_filter_col||'.'||v_filter_sourcefld||case when v_filter_datatype='c' then ')' END||' '||v_filter_srctxt 
					end into v_filter_cnd FROM dual;
		    										
					v_filter_cndary.Extend;
					v_filter_cndary(v_filter_cndary.COUNT):=(v_filter_cnd);				
					
			    end loop;
			   	
			   	SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_filter_dcjoinuniq from(select distinct column_value from   table(v_filter_dcjoinsary));
			   			   	
			   
				v_sql1 := v_sql||array_to_string(v_filter_dcjoinsary,' ')||array_to_string(v_filter_joinsary,' ')||
						' where '||v_primarydctable||'.cancel=''F'''||
						case when v_fldname_transidcnd > 0 then ' and '||v_primarydctable||'.transid='''||pentity_transid||''' and ' END||
						case when v_transid != v_aggfldtransid then v_aggfld_primarydctable||'.cancel=''F''' END||
						case when v_aggfldname_transidcnd > 0 then ' and '||v_aggfld_primarydctable||'.transid='''||v_aggfldtransid||'''' END||						
						array_to_string(v_filter_cndary,' and ')||
						case when length(v_grpfld) > 0 then ' group by '||v_keyname else '' end;					    						
		end if;
			
			v_final_sqls.Extend;
			v_final_sqls(v_final_sqls.COUNT):=(v_sql1);				
			v_filter_cndary:= v_emptyary;
			
	    	END LOOP;
	      	

   return v_final_sqls ;
--	    RETURN v_tablejoins;
END;

>>

<<


CREATE OR REPLACE FUNCTION fn_axpanalytics_chartdata(psource in varchar2, pentity_transid in varchar2, pcondition in varchar2, pcriteria in varchar2,pfilter clob DEFAULT 'NA' )
RETURN  SYS.ODCIVARCHAR2LIST
IS
v_primarydctable varchar2(3000);
v_subentitytable varchar2(3000);
v_transid varchar2(3000);
v_grpfld varchar2(3000);
v_aggfld varchar2(3000);
v_aggfnc varchar2(3000);
v_srckey varchar2(3000);
v_srctbl varchar2(3000); 
v_srcfld varchar2(3000);
v_aempty varchar2(3000);
v_tablename varchar2(100);
v_sql clob;
v_normalizedjoin varchar2(3000);
v_keyname varchar2(3000);
v_entitycond varchar2(3000);
v_keyfld_fname varchar2(3000);
v_keyfld_fval varchar2(3000);  
v_final_sqls SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_transidcnd number;
v_sql1 clob;
v_filter_srcfld varchar2(200);
v_filter_srctxt varchar2(2000);
v_filter_join varchar2(2000);
v_filter_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_cnd varchar2(2000);
v_filter_cndary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_joinreq numeric;
v_filter_dcjoin varchar2(3000);
v_filter_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_dcjoinuniq varchar2(3000);
v_filter_col varchar2(2000);
v_filter_normalized varchar2(20); 
v_filter_sourcetbl varchar2(200);
v_filter_sourcefld varchar2(200);
v_filter_datatype varchar2(20);
v_filter_listedfld varchar2(20);
v_filter_tablename varchar2(200);
v_emptyary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();



begin

	/*
	 * psource - Entity / Subentity	
	 *  pcriteria - transid~groupfld~aggfld~aggfnc~normalized~srctable~srcfld~allowempty~tablename~keyfld~keyval^
	 * transid~groupfld~aggfld~aggfnc~normalized~srctable~srcfld~allowempty~tablename~keyfld~keyval	 	 
	*/

	select tablename into v_primarydctable from axpdc where tstruct = pentity_transid and dname ='dc1';

	if pcondition ='Custom' THEN
		select count(1) into v_fldname_transidcnd from axpflds where tstruct = pentity_transid and dcname ='dc1' and lower(fname)='transid';
	    FOR rec IN
    	    (select column_value as criteria from table(string_to_array(pcriteria,'^')) )
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
				v_normalizedjoin := case when v_srckey='T' then (' left join '||v_srctbl||' b on '||v_primarydctable||'.'||v_grpfld||' = b.'||v_srctbl||'id ') else ' ' end;
				v_keyname := case when length(v_grpfld) > 0 then case when v_srckey='T' then ('b.'||v_srcfld) else (v_primarydctable||'.'||v_grpfld) end else 'null' end;			

                if psource = 'Entity' then	
                	if lower(v_tablename)=lower(v_primarydctable) then
		                v_sql := ('select '||' '||v_keyname||' keyname,'||case when lower(trim(v_aggfnc)) in ('sum','avg') then 'round('||v_aggfnc||'('||v_aggfld||'),2)'else v_aggfnc||'('||v_aggfld||')' END||' keyvalue,'||'''Custom'''||' '||'cnd,'''||replace(rec.criteria,'''','')||''' criteria from '||
						v_primarydctable||' '||v_normalizedjoin);		   	
                	ELSE
                	 	v_sql := ('select '||' '||v_keyname||' keyname,'||case when lower(trim(v_aggfnc)) in ('sum','avg') then 'round('||v_aggfnc||'('||v_aggfld||'),2)'else v_aggfnc||'('||v_aggfld||')' end||' keyvalue,'||'''Custom'''||' '||'cnd,'''||replace(rec.criteria,'''','')||''' criteria from '||
						v_primarydctable||' join '||v_tablename||' on '||v_primarydctable||'.'||v_primarydctable||'.id='||v_tablename||'.'||v_primarydctable||'id '||v_normalizedjoin);
                	END IF;
                
                if pfilter ='NA' then 

        v_sql1 := (v_sql||'where '||v_primarydctable||'.cancel=''F'''||CASE WHEN v_fldname_transidcnd > 0 THEN ' and '||v_primarydctable||'.transid='''||pentity_transid||'''' end||'--axp_filter'||'
				'||case when length(v_grpfld) > 0 then (' group by '||v_keyname) else '' END);
		else
			FOR rec_filters IN
    			(select column_value as ifilter from table(string_to_array(pfilter,'^')) )
			    loop		    	
			    	v_filter_srcfld := split_part(rec_filters.ifilter,'|',1); -- tstfm~empcode~F~~
			    	v_filter_srctxt := split_part(rec_filters.ifilter,'|',2);--   = 'EMP-001'
			    	v_filter_col := split_part(v_filter_srcfld,'~',1);
				    v_filter_normalized := split_part(v_filter_srcfld,'~',2);
 				    v_filter_sourcetbl := split_part(v_filter_srcfld,'~',3);
 				    v_filter_sourcefld := split_part(v_filter_srcfld,'~',4);
					v_filter_datatype := split_part(v_filter_srcfld,'~',5);
					v_filter_listedfld :=split_part(v_filter_srcfld,'~',6);
					v_filter_tablename:=split_part(v_filter_srcfld,'~',7);
					
			    if  v_filter_listedfld='F' then 
								    	
			    	v_filter_joinreq := case when lower(v_tablename)=lower(v_filter_tablename) then 1 else 0 end;
			    	
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
			   		
                	 v_sql1 := v_sql||' '||v_filter_dcjoinuniq||' ' ||array_to_string(v_filter_joinsary,' ')||' where '||v_primarydctable||'.cancel=''F'' and '||
                           CASE WHEN v_fldname_transidcnd>0 THEN v_primarydctable||'.transid='''||pentity_transid||''' and 'END||'--axp_filter '
                           ||array_to_string(v_filter_cndary,' and ')||case when length(v_grpfld) > 0 then (' group by '||v_keyname) else '' end;
		end if;


	                    v_final_sqls.EXTEND;
                         v_final_sqls(v_final_sqls.COUNT) := (v_sql1);
				end if;		
			
		end loop;


   elsif pcondition = 'General' then 

		if psource ='Entity' then    

		select count(1) into v_fldname_transidcnd from axpflds where tstruct = pentity_transid and dcname ='dc1' and lower(fname)='transid';
		
		v_sql:=	 ('select count(*) totrec,
			sum(case when EXTRACT(YEAR FROM createdon) = EXTRACT(YEAR FROM SYSDATE) then 1 else 0 end) cyear,
            sum(case when EXTRACT(MONTH FROM createdon) = EXTRACT(MONTH FROM SYSDATE) then 1 else 0 end) cmonth,
            sum(case when TO_NUMBER(TO_CHAR(createdon, ''IW'')) = TO_NUMBER(TO_CHAR(SYSDATE, ''IW''))  then 1 else 0 end) cweek,
            sum(case when to_date(createdon) = to_date(sysdate) - 1 then 1 else 0 end) cyesterday,
            sum(case when to_date(createdon) = to_date(sysdate) then 1 else 0 end) ctoday,''General'' cnd,null criteria 
			from '||v_primarydctable||' where cancel=''F'''||CASE WHEN v_fldname_transidcnd > 0 THEN ' and transid='''||pentity_transid||'''' END||'--axp_filter');				

					     v_final_sqls.EXTEND;
                         v_final_sqls(v_final_sqls.COUNT) := (v_sql);

		elsif psource= 'Subentity' then 		
		    FOR rec IN
	    	    (select column_value as criteria from table(string_to_array(pcriteria,'^'))) 
		    loop		    			    
	      		v_transid := split_part(rec.criteria,'~',1);
	      		v_tablename := split_part(rec.criteria,'~',9);
				v_keyfld_fname := split_part(rec.criteria,'~',10);
				v_keyfld_fval := split_part(rec.criteria,'~',11);

				select tablename into v_subentitytable from axpdc where tstruct = v_transid and dname ='dc1';
			
				if lower(v_tablename)=lower(v_subentitytable) then
			
				v_sql :=  ('select '||''''||v_transid||'''transid'||',count(*) totrec,''General'' cnd,'''||replace(rec.criteria,'''','')||''' criteria  from '||v_subentitytable||
                             ' where cancel=''F'' and '||CASE WHEN v_fldname_transidcnd > 0 THEN ' transid='''||pentity_transid||''' and ' end ||v_keyfld_fname||'='||v_keyfld_fval||' 
							--axp_filter')  ;				
				ELSE
				
				v_sql :=  ('select '||''''||v_transid||'''transid'||',count(*) totrec,''General'' cnd,'''||replace(rec.criteria,'''','')||''' criteria  from '||v_tablename||' a join '||
							v_subentitytable||' b on a.' ||v_subentitytable||'id=b.'||v_subentitytable||'id '||
                             ' where b.cancel=''F'' and '||CASE WHEN v_fldname_transidcnd > 0 THEN ' b.transid='''||pentity_transid||''' and ' end ||v_keyfld_fname||'='||v_keyfld_fval||'
                            --axp_filter');
                            
				END IF;
			                                                  
                          
                v_final_sqls.EXTEND;
                         v_final_sqls(v_final_sqls.COUNT) := (v_sql);
                

			end loop;	
	
		end if;
	end if;

    return v_final_sqls;
END;

>>

<<

<<

CREATE OR REPLACE FUNCTION fn_axpanalytics_filterdata(ptransid varchar2, pflds clob)
 RETURN  SYS.ODCIVARCHAR2LIST
is 
v_sql clob;
v_result_array SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
begin
---pflds - fldname~normalized~source table~source fld


	if split_part(pflds,'~',2)='T' then	
		v_sql := ('select '||split_part(pflds,'~',4)||' from '||split_part(pflds,'~',3));

        --Bulk collect into Array.    
   execute immediate v_sql bulk collect into v_result_array;

	end if;



return v_result_array;

 
END;

>>

<<

CREATE OR REPLACE FUNCTION fn_axpanalytics_listdata(ptransid varchar2, pflds clob DEFAULT 'All', ppagesize numeric DEFAULT 25, ppageno numeric DEFAULT 1, pfilter clob DEFAULT 'NA')
-- RETURN  clob
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
-- v_recdata_json clob;
t_temp_field_list clob;
v_filter_dcjoinuniq varchar2(3000);
v_final_sqls SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_pegenabled NUMERIC;
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


	SELECT count(1) INTO v_pegenabled FROM AXPROCESSDEFV2 WHERE TRANSID = ptransid;

		if pflds = 'All' then 

            select tablename||'='||listagg(str,'|')WITHIN GROUP(order by  dcname ,ordno)   into  v_allflds From(	
			select tablename,fname||'~'||srckey||'~'||srctf||'~'||srcfld||'~'||allowempty str,
             dcname ,ordno			
			 from axpflds where tstruct=ptransid and 
			dcname ='dc1' and asgrid ='F' and hidden ='F' and savevalue='T' and tablename = v_primarydctable and datatype not in('i','t')
			order by dcname ,ordno			
		          	)a GROUP BY tablename;

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
					
					if v_fldname_normalized ='F' then 
                         v_fldnamesary.EXTEND;
                         v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_dctablename||'.'||v_fldname_col);

					elsif v_fldname_normalized ='T' then
                         v_fldnamesary.EXTEND;
						 v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_col||'.'||v_fldname_srcfld||' '||v_fldname_col);
                         v_fldname_joinsary.EXTEND;
						 v_fldname_joinsary(v_fldname_joinsary.count) := (CASE WHEN v_fldname_allowempty='F' THEN ' join ' ELSE ' left join ' end||v_fldname_srctbl||' '||v_fldname_col||' on '||v_primarydctable||'.'||v_fldname_col||' = '||v_fldname_col||'.'||v_fldname_srctbl||'id');
					end if;
			    end loop;
END LOOP;
		   	v_sql := (' select '||''''||ptransid||''' transid,'||v_primarydctable||'.'||v_primarydctable||'id recordid,'||v_primarydctable||'.username modifiedby,'
		   			||v_primarydctable||'.modifiedon,'||array_to_string(v_fldnamesary,',')||
		   			CASE WHEN v_pegenabled > 0 THEN ',b.axpeg_processname,b.axpeg_keyvalue,b.axpeg_status,b.axpeg_statustext from ' ELSE ' from ' END 
		   			||v_primarydctable||' '||array_to_string(v_fldname_dcjoinsary,' ')||' '||array_to_string(v_fldname_joinsary,' ')||
		   			CASE WHEN v_pegenabled > 0 THEN ' left join ('||
		   		    'select processname axpeg_processname,keyvalue axpeg_keyvalue,status axpeg_status,statustext axpeg_statustext,RECORDID axpeg_RECORDID  from axpeg_'||ptransid||' where status in (1,2)'||' union all '||
					'select a.processname,keyvalue,0,a.taskname||'' is pending ''||listagg(touser,'','') WITHIN group(ORDER BY touser),RECORDID from vw_pegv2_activetasks a '||
					'where  a.transid= '''||ptransid||'''group by a.processname,a.keyvalue,a.taskname,a.recordid) b ON '||v_primarydctable||'.'||v_primarydctable||'id =b.axpeg_recordid'  ELSE ' ' end
					 );

		if pfilter ='NA' then 

        v_sql1 :='select * from(                        
                        select a.*,row_number() over(order by modifiedon desc) rno,'||ppageno||' as  pageno  
                           from ( '||v_sql||' where '||v_primarydctable||'.cancel=''F'' --axp_filter 
							'||
                           CASE WHEN v_fldname_transidcnd>0 THEN ' and '||v_primarydctable||'.transid='''||ptransid||''''end||' )a  order by modifiedon desc             
                                ) b  where rno between '||(ppagesize*(ppageno-1)+1)||' and '||(ppagesize*ppageno);
		else
			FOR rec IN
    			(select column_value as ifilter from table(string_to_array(pfilter,'^')) )
			    loop		    	
			    	v_filter_srcfld := split_part(rec.ifilter,'|',1); -- tstfm~empcode~F~~
			    	v_filter_srctxt := split_part(rec.ifilter,'|',2);--   = 'EMP-001'
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
                           from ( '||v_sql||' '||v_filter_dcjoinuniq||' ' ||array_to_string(v_filter_joinsary,' ')||' where '||v_primarydctable||'.cancel=''F'' and '||
                           CASE WHEN v_fldname_transidcnd>0 THEN v_primarydctable||'.transid='''||ptransid||''' and 'end
                           ||array_to_string(v_filter_cndary,' and ')||' )a  order by modifiedon desc             
                                ) b  where rno between '||(ppagesize*(ppageno-1)+1)||' and '||(ppagesize*ppageno) ;
		end if;


		   
	v_final_sqls.EXTEND;
	v_final_sqls(v_final_sqls.COUNT) := (v_sql1);
return v_final_sqls;


 END;

>>

<<


CREATE OR REPLACE FUNCTION fn_axpanalytics_metadata(ptransid varchar2, psubentity varchar2 DEFAULT 'F')
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
	  props,srckey ,srctf ,srcfld ,srctrans ,allowempty,filtercnd,grpfld,aggfld,subentity, datacnd, entityrelfld,allowduplicate,tablename,dcname,fordno,dccaption,griddc,listingfld) from (
select axpflds.tstruct transid,t.caption formcap, fname ,axpflds.caption fcap,customdatatype cdatatype,datatype dt,modeofentry ,hidden fhide,
	null as props,srckey ,srctf ,srcfld ,srctrans ,axpflds.allowempty,
	case when modeofentry =''select'' then case when srckey =''T'' then ''Dropdown'' else ''Text'' end else ''Text'' end filtercnd,
	case when (modeofentry =''select'' or datatype=''c'') then ''T'' else ''F'' end grpfld,
	case when datatype =''n'' then ''T'' else ''F'' end aggfld,''F'' subentity,1 datacnd,null entityrelfld,allowduplicate,axpflds.tablename,
	dcname,ordno fordno,d.caption dccaption,d.asgrid griddc,case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld
	from axpflds join tstructs t on axpflds.tstruct = t.name
	join axpdc d on axpflds.tstruct = d.tstruct and axpflds.dcname = d.dname
	where axpflds.tstruct=:1  and savevalue =''T''	
	union all
	select a.name,t.caption,key,title,	''button'',null,null,''F'',	script|| ''~''|| icon,''F'',null,null,null,null,null,null,null,''F'' subentity,1,null,null
	,null,null,ordno,null,''F'',''F''
	from axtoolbar a join tstructs t on a.name = t.name
	where visible = ''true'' and script is not null and a.name= :2
    ) x'; 
 
--Bulk collect into Array.    
   execute immediate v_sql bulk collect into recdata_dc1_array using ptransid,ptransid;

-- If subentities are requested.  
  if psubentity ='T' then		

 -- Iterate over distinct subentity data structures.   
    FOR rec IN (
        select distinct a.dstruct ,a.rtype--,dc.tablename,a.dfield,a.rtype,a.mfield
		from axentityrelations a 
		join axpdc dc on a.dstruct = dc.tstruct --and dc.dname ='dc1' 
		--join axpflds d on a.dstruct =d.tstruct  and a.dfield = d.fname and d.asgrid ='F'
		where  mstruct = ptransid )
   	loop	
 
 -- Construct and execute SQL query for subentity data.   
v_subentitysql :=  'select  axpdef_axpanalytics_mdata_obj( transid,formcap, fname ,fcap,cdatatype,dt,modeofentry ,fhide,
		 props,srckey ,srctf ,srcfld ,srctrans ,allowempty, filtercnd,grpfld,aggfld,subentity,datacnd,entityrelfld,allowduplicate,tablename,dcname,fordno,dccaption,griddc,listingfld) from (
        select axpflds.tstruct transid,t.caption formcap, fname ,axpflds.caption fcap,customdatatype cdatatype,datatype dt,modeofentry ,hidden fhide,
		null props,srckey ,srctf ,srcfld ,srctrans ,axpflds.allowempty,
		case when modeofentry =''select'' then case when srckey =''T'' then ''Dropdown'' else ''Text'' end else ''Text'' end filtercnd,
		case when modeofentry =''select'' then ''T'' else ''F'' end grpfld,
		case when datatype =''n'' then ''T'' else ''F'' end aggfld,''T'' subentity,2 datacnd,
		case when srckey=''T'' and :1=r.mstruct then ''recordid'' when srckey=''F'' and :2 = r.mstruct then r.mfield end entityrelfld,allowduplicate
		,axpflds.tablename,axpflds.dcname,axpflds.ordno fordno,d.caption dccaption,d.asgrid griddc,case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld
		from axpflds join tstructs t on axpflds.tstruct = t.name  join axpdc d on axpflds.tstruct = d.tstruct and axpflds.dcname = d.dname
		left join axentityrelations r on axpflds.tstruct = r.dstruct and axpflds.fname = r.dfield and r.mstruct=:3 
		where axpflds.tstruct=:4 and savevalue =''T'' 
		 union all select '''||rec.dstruct||''',null,''sourceid'',''sourceid'',''Simple Text'',''c'',''accept'',''T'',
		null,''F'',null,null,null,''T'',''F'',''F'',''F'',''T'',2,''recordid'',''T'',null,null,1000,null,''F'',''F''
		 from dual where ''gm''='''||rec.rtype||''') x' ;

--Bulk collect into Array.         
       execute immediate v_subentitysql bulk collect into temp_recdata_subentity_array using  ptransid,ptransid,ptransid,rec.dstruct;

-- Merge subentity data into main array.       
        recdata_subentity_array := recdata_subentity_array multiset union all temp_recdata_subentity_array; 

   end loop;    

   end if;

 -- Consolidate data arrays.  
   recdata_consoliate_array := recdata_dc1_array multiset union all recdata_subentity_array;

-- Return consolidated metadata. 
    RETURN recdata_consoliate_array;
  
--   EXCEPTION WHEN OTHERS THEN dbms_output.put_Line(v_Sql);
   	 

END;

>>

<<

CREATE OR REPLACE FUNCTION FN_AXPANALYTICS_PEGSTATUS(ptransid varchar2, precordid NUMERIC,pcolname numeric)
RETURN  varchar2
IS
v_pegstatus numeric;
v_qry clob;
v_returnval varchar2(4000);

BEGIN  

	/*
	 * 1 - axpeg_processname
	 * 2 - axpeg_keyvalue
	 * 3 - axpeg_status
	 * 4 - axpeg_statustext
	 * 5 - axpeg_recordid 
	 */
	
execute IMMEDIATE 'select status from axpeg_'||ptransid||' where recordid ='||precordid into v_pegstatus;

if v_pegstatus  in(1,2) then 

v_qry := ('select processname||''~''||keyvalue||''~''||status||''~''||statustext||''~''||recordid from axpeg_'||ptransid||' 
where status in (1,2) and recordid ='||precordid);
else
v_qry := ('select a.processname||''~''||keyvalue||''~''||0||''~''||a.taskname||'' is pending ''||listagg(touser,'','') WITHIN group(ORDER BY touser)||''~''||recordid 
from vw_pegv2_activetasks a 
where  a.recordid='||precordid||'
group by a.processname,a.keyvalue,a.taskname,a.recordid');

end if;



execute immediate v_qry into v_returnval;

--RETURN split_part(v_returnval,'~',pcolname);

RETURN v_returnval;
EXCEPTION 
WHEN TOO_MANY_ROWS THEN dbms_output.put_line(v_returnval); 
WHEN OTHERS THEN null;
END;

CREATE OR REPLACE FUNCTION fn_axpanalytics_se_listdata(pentity_transid varchar2, pflds_keyval clob, ppagesize numeric DEFAULT 50, ppageno numeric DEFAULT 1)
RETURN SYS.ODCIVARCHAR2LIST
--RETURN varchar2
is 
    
v_sql clob;
v_sql1 clob;
--v_pfldtablename varchar2(3000);
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
v_final_sqls SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_primarydctable varchar2(3000);
v_fields_list varchar2(3000);
v_filter_dcjoinuniq varchar2(3000);
--v_recdata_json clob;
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
		    
		    if lower(v_fldname_table)!=lower(v_primarydctable) then								
				v_fldname_dcjoinsary.EXTEND;
	            v_fldname_dcjoinsary(v_fldname_dcjoinsary.COUNT) := ('left join '||v_fldname_table||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_fldname_table||'.'||v_primarydctable||'id');
			end if;
		
		
			if lower(v_fldname_table)!=lower(v_pflds_keytable) then								
				v_fldname_dcjoinsary.EXTEND;
				v_fldname_dcjoinsary(v_fldname_dcjoinsary.COUNT) := ('left join '||v_pflds_keytable||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_pflds_keytable||'.'||v_primarydctable||'id');
			end if;
		    	                
			    FOR rec2 in			    	
    				(select column_value as fldname from table(string_to_array(v_fldname_tblflds,'|'))) 
						loop		    									
							v_fldname_col := split_part(rec2.fldname,'~',1);
							v_fldname_normalized := split_part(rec2.fldname,'~',2);
							v_fldname_srctbl := split_part(rec2.fldname,'~',3);
							v_fldname_srcfld := split_part(rec2.fldname,'~',4);														
							v_fldname_allowempty := split_part(rec2.fldname,'~',5);
							v_keyvalue_fname := split_part(v_pflds_keyvalue,'~',1);
							v_keyvalue_fvalue := split_part(v_pflds_keyvalue,'~',2);		
													

							if v_fldname_normalized ='F' then 
                             v_fldnamesary.EXTEND;
                             v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_table||'.'||v_fldname_col);

							elsif v_fldname_normalized ='T' then	
                             v_fldnamesary.EXTEND;
                             v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_col||'.'||v_fldname_srcfld||' '||v_fldname_col);	

                             v_fldname_joinsary.EXTEND;
                             v_fldname_joinsary(v_fldname_joinsary.COUNT) := (case when v_fldname_allowempty='F' then ' join ' else ' left join ' end||v_fldname_srctbl||' '||v_fldname_col||' on '||v_fldname_table||'.'||v_fldname_col||' = '||v_fldname_col||'.'||v_fldname_srctbl||'id');

							 end if;	

			    		end loop;
	    	end loop;
	    
	    	SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_filter_dcjoinuniq from(select distinct column_value from   table(v_fldname_dcjoinsary));

		   	v_sql := (' select '||''''||v_pflds_transid||''' transid,'||v_primarydctable||'.'||v_primarydctable||'id recordid,'||v_primarydctable||'.username modifiedby,'||v_primarydctable||'.modifiedon,'||
		   			 array_to_string(v_fldnamesary,',')||' from '||v_primarydctable||' '||array_to_string(v_fldname_dcjoinsary,' ')||' '||array_to_string(v_fldname_joinsary,' ')||
                     ' where '||v_primarydctable||'.cancel=''F'' and '||
                     case when v_fldname_transidcnd>0 then v_primarydctable||'.transid='||''''||v_pflds_transid||''' and ' end||v_keyvalue_fname||'='||v_keyvalue_fvalue||' 
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

   	
--return v_fldname_tblflds; 
RETURN v_final_sqls;
END;

>>

<<

CALL FN_AXPANALYTICS_INS_AXRELTN();

>>
