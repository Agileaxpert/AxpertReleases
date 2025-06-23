<<
CREATE OR REPLACE TYPE Axpdef_tstruct_rec_obj AS OBJECT (
  dcname    VARCHAR2(100),
  rowno     NUMBER,
  recordid  NUMBER
);
>>

<<
CREATE OR REPLACE TYPE Axpdef_tstruct_rec AS TABLE OF Axpdef_tstruct_rec_obj;
>>

<<
CREATE OR REPLACE FUNCTION fn_tstruct_getdcrecid (
  ptransid    IN VARCHAR2,
  precordid   IN NUMBER,
  pdcstring   IN VARCHAR2
)
RETURN AXPDEF_TSTRUCT_REC
PIPELINED
AS
  v_dcname            VARCHAR2(100);
  v_rowstring         VARCHAR2(100);
  v_dctable           VARCHAR2(100);
  v_isgrid            VARCHAR2(1);
  v_primarydctable    VARCHAR2(100);
  v_sql               VARCHAR2(4000);
  
  CURSOR c_dcnames IS
    SELECT REGEXP_SUBSTR(pdcstring, '[^,]+', 1, LEVEL) AS str
    FROM dual
    CONNECT BY REGEXP_SUBSTR(pdcstring, '[^,]+', 1, LEVEL) IS NOT NULL;
    
  TYPE ref_cursor IS REF CURSOR;
  rc ref_cursor;

  v_dcname_out   VARCHAR2(100);
  v_rowno        NUMBER;
  v_recordid     NUMBER;

BEGIN
  -- Get the primary DC table
  SELECT tablename INTO v_primarydctable
  FROM axpdc
  WHERE tstruct = ptransid AND dname = 'dc1';

  -- Loop over comma-separated list
  FOR rec IN c_dcnames LOOP
    v_dcname := rec.str;

    SELECT tablename, asgrid
    INTO v_dctable, v_isgrid
    FROM axpdc
    WHERE tstruct = ptransid AND dname = v_dcname;

    -- Construct dynamic SQL
    IF v_isgrid = 'F' THEN
      v_sql := 'SELECT ''' || v_dcname || ''', 0 rowno,'||v_dctable||'id FROM ' || v_dctable ||' WHERE ' || v_primarydctable || 'id = :precordid';
    ELSE
      v_sql := 'SELECT '''|| v_dcname ||'''dcname,'||v_dctable||'row rowno,'||v_dctable||'id FROM ' || v_dctable ||' WHERE ' ||v_primarydctable || 'id = :precordid';
    END IF;

    -- Execute dynamic SQL and pipe the results
    OPEN rc FOR v_sql USING precordid;
    LOOP
      FETCH rc INTO v_dcname_out, v_rowno, v_recordid;
      EXIT WHEN rc%NOTFOUND;
      PIPE ROW(AXPDEF_TSTRUCT_REC_OBJ(v_dcname_out, v_rowno, v_recordid));
    END LOOP;
    CLOSE rc;
  END LOOP;

  RETURN;
END;

>>

<<
CREATE OR REPLACE FUNCTION axp_fn_get_scolname (
    v_sql       IN VARCHAR2,
    modeofentry IN VARCHAR2
) RETURN VARCHAR2
IS
    scolname VARCHAR2(4000);
BEGIN
    -- Check if the input is not null or empty
    IF v_sql IS NOT NULL AND v_sql <> '' AND modeofentry = 'Fill' THEN
        -- Process the input and extract the desired part
        scolname := REGEXP_SUBSTR(
            REGEXP_SUBSTR(
                LOWER(REGEXP_REPLACE(REPLACE(v_sql, ':', ''), '\r\n?|\n', '', 'g')),
                'from', 1, 1, 'i', 1
            ),
            'select', 1, 2, 'i', 1
        );
    ELSE
        scolname := NULL;
    END IF;

    RETURN scolname;
END axp_fn_get_scolname;
>>

<<
CREATE OR REPLACE PROCEDURE pr_executescript_new(ptablename varchar2) IS TYPE reftyp IS REF CURSOR;
sqlstmt reftyp;
rec clob;
temp1 varchar2(1000);
BEGIN
	OPEN sqlstmt FOR 'SELECT psqlquery  FROM ' || ptablename;
LOOP
	FETCH sqlstmt INTO 	rec; 
    EXIT WHEN sqlstmt%NOTFOUND;

	EXECUTE IMMEDIATE rec;
END LOOP;

CLOSE sqlstmt;

temp1 := 'drop table ' || ptablename;

EXECUTE IMMEDIATE temp1;
END;
>>

<<
CREATE OR REPLACE PROCEDURE Pr_insertsql_new(ptablename VARCHAR)
IS
sqlstmt VARCHAR(4000); -- Increased size to accommodate long queries
BEGIN
-- Validate table name length
IF LENGTH(ptablename) > 50 THEN
RAISE_APPLICATION_ERROR(-20001, 'Table name exceeds 50 characters');
END IF;
-- Construct SQL statement
sqlstmt := 'CREATE TABLE ' || ptablename || 
' (psqlquery CHAR(2000)) ' ||
'ORGANIZATION EXTERNAL (' ||
'TYPE ORACLE_LOADER ' ||
'DEFAULT DIRECTORY DATALOAD ' ||
'ACCESS PARAMETERS (' ||
'RECORDS DELIMITED BY NEWLINE ' ||
'FIELDS TERMINATED BY '';'' ' ||
'MISSING FIELD VALUES ARE NULL (' ||
'PSQLQUERY CHAR(2000)' ||
')) ' ||
'LOCATION (''' || ptablename||'.txt' || ''')' ||
')';
-- Execute SQL statement
EXECUTE IMMEDIATE sqlstmt;
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
RAISE;
END;
>>