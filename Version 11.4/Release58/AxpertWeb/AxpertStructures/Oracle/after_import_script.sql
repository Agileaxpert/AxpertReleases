<<
CREATE OR REPLACE TYPE fn_permissions_apptstructsobj AS OBJECT (
    transid VARCHAR2(50)
);
>>

<<
CREATE OR REPLACE TYPE fn_permissions_apptstructstab AS TABLE OF fn_permissions_apptstructsobj;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_apptstructs (
    pusername IN VARCHAR2,
    puserrole IN VARCHAR2,
    ptype     IN VARCHAR2 DEFAULT 'Tstruct'
) RETURN fn_permissions_apptstructstab PIPELINED 
AS 
BEGIN
    FOR r IN ( 
        SELECT formtransid FROM axpermissions
        WHERE axusername = pusername AND comptype = 'Form'
        UNION
        SELECT formtransid FROM axpermissions
        WHERE comptype = 'Form'
          AND axuserrole IN (
              SELECT trim(regexp_substr(puserrole, '[^,]+', 1, level))
              FROM dual
              CONNECT BY regexp_substr(puserrole, '[^,]+', 1, level) IS NOT NULL
          )
    ) LOOP
        PIPE ROW(fn_permissions_apptstructsobj(r.formtransid));
    END LOOP;

    RETURN;
END;
>>