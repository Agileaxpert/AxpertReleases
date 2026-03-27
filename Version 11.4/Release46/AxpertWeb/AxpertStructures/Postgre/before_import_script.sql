<<
CREATE OR REPLACE FUNCTION fn_utl_forms_dateconversion(pupdatedon VARCHAR)
RETURNS TIMESTAMP AS $$
BEGIN
        CASE 
        WHEN pupdatedon ~ '^\d{1,2}-\d{1,2}-\d{4}\s\d{2}:\d{2}:\d{2}$' THEN 
            RETURN TO_TIMESTAMP(pupdatedon, 'DD-MM-YYYY HH24:MI:SS');
        WHEN pupdatedon ~ '^\d{1,2}/\d{1,2}/\d{4}\s\d{2}:\d{2}:\d{2}$' THEN 
            RETURN TO_TIMESTAMP(pupdatedon, 'DD/MM/YYYY HH24:MI:SS');
        ELSE 
            RETURN NULL;
    END CASE;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;
>>