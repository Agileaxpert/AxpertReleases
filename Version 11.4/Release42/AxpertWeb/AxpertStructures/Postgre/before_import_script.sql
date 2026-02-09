<<
CREATE OR REPLACE FUNCTION fn_utl_timeformat_24hr(
    jhrs varchar, 
    jminutes varchar, 
    ampm varchar
)
RETURNS varchar
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN to_char((jhrs || ':' || jminutes || ' ' || ampm)::time, 'HH24MI') || '00';
EXCEPTION WHEN OTHERS THEN
    RETURN NULL; 
END;
$$;
>>