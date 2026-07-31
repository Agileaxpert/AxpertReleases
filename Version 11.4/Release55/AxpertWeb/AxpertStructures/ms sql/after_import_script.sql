<<
alter FUNCTION fn_permissions_getadssql(
    @ptransid   VARCHAR(255),
    @padsname   VARCHAR(255),
    @pcond      NVARCHAR(MAX)
)
returns @resulttable table(adssql varchar(max))
AS
BEGIN
    DECLARE
        @v_adssql        NVARCHAR(MAX),
        @v_filtersql     NVARCHAR(MAX),
        @v_primarydctable VARCHAR(255),
        @v_filtercnd     NVARCHAR(MAX),      
        @v_addpagination VARCHAR(10),
        @v_dimensions VARCHAR(10);

    SELECT @v_adssql = sqltext,
    @v_addpagination=COALESCE(pagination,'T'),
    @v_dimensions=COALESCE(pagination,'T') 
    FROM axdirectsql
    WHERE sqlname = @padsname;

   IF (lower(trim(@v_adssql)) like 'select%' or lower(trim(@v_adssql)) like 'with%') and @v_addpagination='T' 
   begin
	   select @v_adssql = concat('select --ax_select_columns 
from(
',@v_adssql,'
)wpc
',
'--ax_ui_filter_withwhere
',case when @v_dimensions='T' then ' --ax_permission_filter
' end,
'--ax_groupby
',
'--ax_orderby
',
'--ax_pagination
');
    IF @pcond <> 'NA'
    BEGIN
        SELECT @v_primarydctable = tablename
        FROM axpdc
        WHERE tstruct = @ptransid
          AND dname = 'dc1';

        SET @v_filtercnd =
            ' AND (' +
            REPLACE(@pcond, '{primarytable.}', @v_primarydctable + '.') +
            ')';

        SET @v_filtersql =
            REPLACE(@v_adssql, '--ax_permission_filter', @v_filtercnd);
    END
    
       INSERT INTO @resulttable (adssql)
        VALUES (CASE WHEN @pcond = 'NA' THEN @v_adssql ELSE @v_filtersql END); 
          end
        else begin
             INSERT INTO @resulttable (adssql)
        VALUES (@v_adssql);
       end;
                   return; 
END;
>>

<<
DELETE c
FROM axpstructconfigproval c
WHERE EXISTS (
    SELECT 1 
    FROM axpstructconfigprops b 
    JOIN axpstructconfigproval a 
      ON a.axpstructconfigpropsid = b.axpstructconfigpropsid 
    WHERE b.configprops = 'Landing Structure'
      AND a.configvalues = 'html templates'
      AND c.axpstructconfigprovalid = a.axpstructconfigprovalid
);
>>