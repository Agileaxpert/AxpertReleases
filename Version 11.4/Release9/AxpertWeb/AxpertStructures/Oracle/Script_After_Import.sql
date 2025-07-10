<<
CREATE OR REPLACE FUNCTION fn_generate_cardjson(pchartprops IN varchar2)
 RETURN varchar2
IS
cardprops1 varchar2(4000);
BEGIN

	
	select '{"attributes":{'||'"cck":"'||lower(TRIM(REGEXP_SUBSTR(pchartprops,  '(.*?)(\||$)', 1, 1,NULL, 1)))||'",'
||'"shwLgnd":'||lower(TRIM(REGEXP_SUBSTR(pchartprops, '(.*?)(\||$)', 1, 2,NULL, 1)))||','
||'"xAxisL":"'||TRIM(REGEXP_SUBSTR(pchartprops, '(.*?)(\||$)', 1, 3,NULL, 1))||'",'
||'"yAxisL":"'||TRIM(REGEXP_SUBSTR(pchartprops, '(.*?)(\||$)', 1, 4,NULL, 1))||'",'
||'"gradClrChart":'||lower(TRIM(REGEXP_SUBSTR(pchartprops, '(.*?)(\||$)', 1, 5,NULL, 1)))||','
||'"shwChartVal":'||lower(TRIM(REGEXP_SUBSTR(pchartprops, '(.*?)(\||$)', 1, 6,NULL, 1)))||','
||'"threeD":"'||case when TRIM(REGEXP_SUBSTR(pchartprops, '(.*?)(\||$)', 1, 7,NULL, 1))='True' then 'create' else 'remove' END||'",'
||'"enableSlick":'||lower(TRIM(REGEXP_SUBSTR(pchartprops, '(.*?)(\||$)', 1, 8,NULL, 1)))||','
||'"numbSym":'||lower(TRIM(REGEXP_SUBSTR(pchartprops, '(.*?)(\||$)', 1, 9,NULL, 1)))||'}}'  
into cardprops1 
from dual;
 
RETURN cardprops1;

END;
>>