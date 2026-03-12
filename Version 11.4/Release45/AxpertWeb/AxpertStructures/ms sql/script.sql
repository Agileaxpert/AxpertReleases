<<
DROP PROCEDURE fn_permissions_getcnd;
>>


<<
CREATE PROCEDURE fn_permissions_getcnd
    @pmode         VARCHAR(MAX),
    @ptransid      VARCHAR(MAX),
    @pkeyfield       VARCHAR(MAX),
    @pkeyvalue     VARCHAR(MAX),
    @pusername     VARCHAR(MAX),
    @proles        VARCHAR(MAX) = 'All',
    @pglobalvars   varchar(max) = 'NA'  
AS
BEGIN
    SET NOCOUNT ON;

    
    DECLARE @v_keyfld_normalized   VARCHAR(1);
    DECLARE @v_keyfld_srctbl       VARCHAR(100);
    DECLARE @v_keyfld_srcfld       VARCHAR(100);
    DECLARE @v_keyfld_mandatory    VARCHAR(1);

    DECLARE @v_transid_primetable    VARCHAR(100);
    DECLARE @v_transid_primetableid  VARCHAR(100);
    DECLARE @v_keyfld_joins        VARCHAR(500);
    DECLARE @v_keyfld_cnd          VARCHAR(500);

    DECLARE @sql_permission_cnd    NVARCHAR(MAX); 
    DECLARE @sql_permission_cnd_result BIGINT;    
    DECLARE @v_dcfldslist          NVARCHAR(MAX);
    DECLARE @v_recordid            BIGINT;
    DECLARE @v_permissionsql       NVARCHAR(MAX);
    DECLARE @v_permissionexists    BIGINT;
    DECLARE @v_menuaccess          BIGINT;
    DECLARE @v_fullcontrolsql      NVARCHAR(MAX);
    DECLARE @v_fullcontrolrecid    BIGINT;

    -- Variables to hold data for the result set    
    DECLARE @fullcontrol_out         VARCHAR(1);
    DECLARE @userrole_out            VARCHAR(250);
    DECLARE @allowcreate_out         VARCHAR(1);
    DECLARE @view_access_out         VARCHAR(250);
    DECLARE @view_includedc_out      VARCHAR(MAX);
    DECLARE @view_excludedc_out      VARCHAR(MAX);
    DECLARE @view_includeflds_out    VARCHAR(MAX);
    DECLARE @view_excludeflds_out    VARCHAR(MAX);
    DECLARE @edit_access_out         VARCHAR(250);
    DECLARE @edit_includedc_out      VARCHAR(MAX);
    DECLARE @edit_excludedc_out      VARCHAR(MAX);
    DECLARE @edit_includeflds_out    VARCHAR(MAX);
    DECLARE @edit_excludeflds_out    VARCHAR(MAX);
    DECLARE @maskedflds_out          VARCHAR(MAX);
    DECLARE @filtercnd_out           NVARCHAR(MAX);
    DECLARE @recordid_out            numeric;
  DECLARE @v_encryptedflds   NVARCHAR(MAX);
 
    -- Temp table to store results if multiple rows are processed
    CREATE TABLE #fn_permissions_getcnd_results (
        fullcontrol     VARCHAR(1),
        userrole        VARCHAR(250),
        allowcreate     VARCHAR(1),
        view_access     VARCHAR(250),
        view_includedc  VARCHAR(MAX),
        view_excludedc  VARCHAR(MAX),
        view_includeflds VARCHAR(MAX),
        view_excludeflds VARCHAR(MAX),
        edit_access     VARCHAR(250),
        edit_includedc  VARCHAR(MAX),
        edit_excludedc  VARCHAR(MAX),
        edit_includeflds VARCHAR(MAX),
        edit_excludeflds VARCHAR(MAX),
        maskedflds      VARCHAR(MAX),
        filtercnd       NVARCHAR(MAX),
        recordid        BIGINT,
        encryptedflds NVARCHAR(MAX));

    -- 1. Get key field details from axpflds
    SELECT
        @v_keyfld_normalized = srckey,
        @v_keyfld_srctbl = srctf,
        @v_keyfld_srcfld = srcfld,
        @v_keyfld_mandatory = allowempty
    FROM axpflds
    WHERE tstruct = @ptransid AND fname = @pkeyfield;

    -- 2. Get primary table name from axpdc
    SELECT @v_transid_primetable = tablename
    FROM axpdc
    WHERE tstruct = @ptransid AND dname = 'dc1';

    -- 3. Determine the primary table ID field
    SET @v_transid_primetableid = CASE WHEN LOWER(@pkeyfield) = 'recordid' THEN @v_transid_primetable + 'id' ELSE @pkeyfield END;

    -- 4. Construct the key field condition (@v_keyfld_cnd)
    SET @v_keyfld_cnd = CASE WHEN @v_keyfld_normalized = 'T'
                             THEN QUOTENAME(@v_keyfld_srctbl) + '.' + QUOTENAME(@v_keyfld_srcfld) -- Use QUOTENAME for safety
                             ELSE QUOTENAME(@v_transid_primetable) + '.' + QUOTENAME(@v_transid_primetableid)
                        END + '=' + @pkeyvalue + ' AND ';

    -- 5. Construct the key field joins (@v_keyfld_joins)
    SET @v_keyfld_joins = NULL; -- Initialize
    IF @v_keyfld_normalized = 'T'
    BEGIN
        SET @v_keyfld_joins = CASE WHEN @v_keyfld_mandatory = 'T' THEN ' JOIN ' ELSE ' LEFT JOIN ' END
                              + QUOTENAME(@v_keyfld_srctbl) + ' ' + QUOTENAME(@pkeyfield) + ' ON ' -- Alias it
                              + QUOTENAME(@v_transid_primetable) + '.' + QUOTENAME(@pkeyfield) + '=' + QUOTENAME(@v_keyfld_srctbl) + '.' + QUOTENAME(@v_keyfld_srctbl) + 'id';
    END;

    -- 6. Calculate @v_menuaccess (equivalent to PostgreSQL's sum(cnt) from subquery)
    SELECT @v_menuaccess = COUNT(*)
    FROM (
        SELECT 1 AS cnt FROM axusergroups a
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
        JOIN axuseraccess a2 ON b.roles_id = a2.rname AND a2.stype = 't'
        WHERE a2.sname = @ptransid
          AND EXISTS (SELECT 1 FROM STRING_SPLIT(@proles, ',') AS val WHERE val.value = a.groupname) -- unnest(string_to_array) -> STRING_SPLIT
        UNION ALL
        SELECT 1 WHERE @proles LIKE '%default%' -- DUAL table not needed in SQL Server
        UNION ALL
        SELECT 1 FROM axuserlevelgroups WHERE username = @pusername AND usergroup = 'default'
        UNION ALL
        SELECT 1 AS cnt FROM axusergroups a
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
        JOIN axuseraccess a2 ON b.roles_id = a2.rname AND a2.stype = 't'
        JOIN axuserlevelgroups u ON a.groupname = u.usergroup AND u.username = @pusername
        WHERE a2.sname = @ptransid AND @proles = 'All'
    ) AS MenuAccessSubquery; 

    -- Dynamic SQL for rolesql and v_permissionsql
    DECLARE @rolesql NVARCHAR(MAX);
 
        SET @v_fullcontrolsql = CONCAT('SELECT @fullcontrolrecid_output=', @v_transid_primetable, 'id FROM ', @v_transid_primetable, ' ', @v_keyfld_joins, ' WHERE ', REPLACE(@v_keyfld_cnd, ' AND ', ''));

        -- Execute dynamic SQL to get a single value into a variable
        EXEC sp_executesql @v_fullcontrolsql,
                           N'@fullcontrolrecid_output BIGINT OUTPUT',
                           @fullcontrolrecid_output = @v_fullcontrolrecid OUTPUT;
                          

        SET @fullcontrol_out = 'T';
        SET @recordid_out = @v_fullcontrolrecid; 
        SET @userrole_out = NULL;
        SET @allowcreate_out = NULL;
        SET @view_access_out = NULL;
        SET @view_includedc_out = NULL;
        SET @view_excludedc_out = NULL;
        SET @view_includeflds_out = NULL;
        SET @view_excludeflds_out = NULL;
        SET @edit_access_out = NULL;
        SET @edit_includedc_out = NULL;
        SET @edit_excludedc_out = NULL;
        SET @edit_includeflds_out = NULL;
        SET @edit_excludeflds_out = NULL;
        SET @maskedflds_out = NULL;
        SET @filtercnd_out = NULL;
  SELECT @v_encryptedflds = STRING_AGG(fname, ',') WITHIN GROUP (ORDER BY ordno) FROM axpflds WHERE tstruct = @ptransid 
  AND encrypted = 'T';
       
       
        INSERT INTO #fn_permissions_getcnd_results (
            fullcontrol, userrole, allowcreate, view_access,
            view_includedc, view_excludedc, view_includeflds, view_excludeflds,
            edit_access, edit_includedc, edit_excludedc, edit_includeflds, edit_excludeflds,
            maskedflds, filtercnd, recordid,encryptedflds)
        VALUES (
            @fullcontrol_out, @userrole_out, @allowcreate_out, @view_access_out,
            @view_includedc_out, @view_excludedc_out, @view_includeflds_out, @view_excludeflds_out,
            @edit_access_out, @edit_includedc_out, @edit_excludedc_out, @edit_includeflds_out, @edit_excludeflds_out,
            @maskedflds_out, @filtercnd_out, @recordid_out,@v_encryptedflds);
    
    SELECT * FROM #fn_permissions_getcnd_results;

    DROP TABLE #fn_permissions_getcnd_results; 

END;
>>
 
<<
ALTER TABLE axusers DISABLE TRIGGER t1_axusers;
>>
 
<<
update axusers set staysignedin='F',signinexpiry=14;
>>
 
<<
ALTER TABLE axusers ENABLE TRIGGER t1_axusers;
>>
