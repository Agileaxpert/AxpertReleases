<<
CREATE SEQUENCE seq_axdb_recordid
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1
    NO CYCLE;
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
 	DECLARE @v_encryptedflds		 NVARCHAR(MAX);
 
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
    SET @v_keyfld_joins = NULL;
    IF @v_keyfld_normalized = 'T'
    BEGIN
        SET @v_keyfld_joins = CASE WHEN @v_keyfld_mandatory = 'T' THEN ' JOIN ' ELSE ' LEFT JOIN ' END
                              + QUOTENAME(@v_keyfld_srctbl) + ' ' + QUOTENAME(@pkeyfield) + ' ON ' -- Alias it
                              + QUOTENAME(@v_transid_primetable) + '.' + QUOTENAME(@pkeyfield) + '=' + QUOTENAME(@v_keyfld_srctbl) + '.' + QUOTENAME(@v_keyfld_srctbl) + 'id';
    END;

 
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
   
    -- Final SELECT statement to return the results from the temporary table
    SELECT * FROM #fn_permissions_getcnd_results;

    DROP TABLE #fn_permissions_getcnd_results; 

END;
>>

<<
CREATE PROCEDURE fn_permissions_getpermission
    @pmode         VARCHAR(MAX),
    @ptransid      VARCHAR(MAX), -- Now handles comma-separated values
    @pusername     VARCHAR(MAX),
    @proles        VARCHAR(MAX) = 'All',
    @pglobalvars   VARCHAR(MAX) = 'NA' 
AS
BEGIN
    SET NOCOUNT ON;

    
    DECLARE @current_transid VARCHAR(MAX);

    -- Declare variables for internal logic
    DECLARE @v_permissionsql       NVARCHAR(MAX);
    DECLARE @v_permissionexists    BIGINT;
    DECLARE @v_menuaccess          BIGINT;
    DECLARE @rolesql               NVARCHAR(MAX);

    -- Variables to hold data for the result set
    DECLARE @transid_out         VARCHAR(MAX);
    DECLARE @fullcontrol_out     VARCHAR(1);
    DECLARE @userrole_out        VARCHAR(250);
    DECLARE @allowcreate_out     VARCHAR(1);
    DECLARE @view_access_out     VARCHAR(250);
    DECLARE @view_includedc_out  VARCHAR(MAX);
    DECLARE @view_excludedc_out  VARCHAR(MAX);
    DECLARE @view_includeflds_out VARCHAR(MAX);
    DECLARE @view_excludeflds_out VARCHAR(MAX);
    DECLARE @edit_access_out     VARCHAR(250);
    DECLARE @edit_includedc_out  VARCHAR(MAX);
    DECLARE @edit_excludedc_out  VARCHAR(MAX);
    DECLARE @edit_includeflds_out VARCHAR(MAX);
    DECLARE @edit_excludeflds_out VARCHAR(MAX);
    DECLARE @maskedflds_out      VARCHAR(MAX);
    DECLARE @filtercnd_out       NVARCHAR(MAX);
   	DECLARE @v_encryptedflds		 NVARCHAR(MAX);

    -- Temporary table to accumulate all results, similar to PostgreSQL's RETURNS TABLE + RETURN NEXT
    CREATE TABLE #PermissionsResults (
        transid         VARCHAR(MAX),
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
        encryptedflds NVARCHAR(MAX));

    
    DECLARE transid_cursor CURSOR LOCAL FOR
    SELECT value FROM STRING_SPLIT(@ptransid, ',');

    OPEN transid_cursor;
    FETCH NEXT FROM transid_cursor INTO @current_transid;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Reset variables for each transid iteration
        SET @v_permissionexists = 0;
        SET @v_menuaccess = 0;
        SET @rolesql = NULL;
        SET @v_permissionsql = NULL;

        -- Calculate v_menuaccess for the current transid
        SELECT @v_menuaccess = COUNT(*)
        FROM (
            SELECT 1 AS cnt FROM axusergroups a
            JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
            JOIN axuseraccess a2 ON b.roles_id = a2.rname AND a2.stype = 't'
            WHERE a2.sname = @current_transid
              AND EXISTS (SELECT 1 FROM STRING_SPLIT(@proles, ',') AS val WHERE val.value = a.groupname)
            UNION ALL
            SELECT 1 WHERE @proles LIKE '%default%' 
            UNION ALL
            SELECT 1 FROM axuserlevelgroups WHERE username = @pusername AND usergroup = 'default'
            UNION ALL            
            SELECT 1 AS cnt FROM axusergroups a
            JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
            JOIN axuseraccess a2 ON b.roles_id = a2.rname AND a2.stype = 't'
            JOIN axuserlevelgroups u ON a.groupname = u.usergroup AND u.username = @pusername
            WHERE a2.sname = @current_transid AND @proles = 'All' 
        ) AS MenuAccessSubquery;

       
            SET @transid_out = @current_transid;
            SET @fullcontrol_out = 'T';
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
           	SELECT @v_encryptedflds = STRING_AGG(fname, ',') WITHIN GROUP (ORDER BY ordno) FROM axpflds WHERE tstruct = @current_transid 
		AND encrypted = 'T';

            -- Insert the row into the temporary results table
            INSERT INTO #PermissionsResults (
                transid, fullcontrol, userrole, allowcreate, view_access,
                view_includedc, view_excludedc, view_includeflds, view_excludeflds,
                edit_access, edit_includedc, edit_excludedc, edit_includeflds, edit_excludeflds,
    maskedflds, filtercnd,encryptedflds  )
            VALUES (
                @transid_out, @fullcontrol_out, @userrole_out, @allowcreate_out, @view_access_out,
                @view_includedc_out, @view_excludedc_out, @view_includeflds_out, @view_excludeflds_out,
                @edit_access_out, @edit_includedc_out, @edit_excludedc_out, @edit_includeflds_out, @edit_excludeflds_out,
                @maskedflds_out, @filtercnd_out,@v_encryptedflds);
           FETCH NEXT FROM transid_cursor INTO @current_transid;
    END;

    CLOSE transid_cursor;
    DEALLOCATE transid_cursor;

    -- Final SELECT statement to return all accumulated results
    SELECT * FROM #PermissionsResults;

    DROP TABLE #PermissionsResults; -- Clean up the temporary table

END;
>>

<<
CREATE FUNCTION fn_axdbget (
    @ptransid VARCHAR(255), 
    @precordid NUMERIC(18,0) = 0
)
RETURNS @ResultTable TABLE (
    transid VARCHAR(255),
    dcno VARCHAR(255),
    griddc VARCHAR(10),
    sqltext NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @v_primarydctable VARCHAR(255);
    DECLARE @v_allflds NVARCHAR(MAX);
    DECLARE @v_dcdefaultcols NVARCHAR(MAX);
    DECLARE @v_griddc_orderby NVARCHAR(MAX);
    

    DECLARE @rec_dname VARCHAR(MAX), @rec_asgrid VARCHAR(10), @rec_tablename VARCHAR(255);

    -- 1. Get Primary DC Table
    SELECT TOP 1 @v_primarydctable = tablename 
    FROM axpdc 
    WHERE tstruct = @ptransid AND dname = 'dc1';


    DECLARE outer_cursor CURSOR FOR
    SELECT 
        STRING_AGG(dname, ',') WITHIN GROUP (ORDER BY dname) as dname, 
        asgrid, 
        LOWER(tablename) 
    FROM axpdc 
    WHERE tstruct = @ptransid 
    GROUP BY asgrid, LOWER(tablename)
    ORDER BY 1;

    OPEN outer_cursor;
    FETCH NEXT FROM outer_cursor INTO @rec_dname, @rec_asgrid, @rec_tablename;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @v_allflds = NULL;
        SET @v_dcdefaultcols = '';
        SET @v_griddc_orderby = '';

        -- 3. Build v_allflds (Concatenating field metadata)
        SELECT @v_allflds = @rec_tablename + '=' + STRING_AGG(str, '|')
        FROM (
            SELECT tablename, concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~' ,allowempty) AS str, dcname, ordno
            FROM axpflds 
            WHERE tstruct = @ptransid AND savevalue = 'T' AND LOWER(tablename) = @rec_tablename AND datatype != 'i'
            UNION ALL
            SELECT tablename, concat(fname,'~',srckey,'~',srctf,'~',srcfld,'~' ,allowempty)  AS str, dcname, ordno
            FROM axpflds 
            WHERE tstruct = @ptransid AND savevalue = 'T' AND LOWER(tablename) = @rec_tablename AND datatype != 'i' AND srckey = 'T'
        ) a 
        GROUP BY tablename;

        IF LEN(@v_allflds) > 1
        BEGIN
            -- 4. Handle Default Columns
            IF @rec_tablename = @v_primarydctable
            BEGIN
                SET @v_dcdefaultcols =  REPLACE(@v_primarydctable + '.' +'tid,cancel,sourceid,mapname,username,modifiedon,createdby,createdon,wkid,app_level,app_desc,app_slevel,cancelremarks,wfroles', ',', ',' + @v_primarydctable + '.');

                SET @v_dcdefaultcols = REPLACE(@v_dcdefaultcols, 'tid', @v_primarydctable + 'id');
            END
            ELSE IF @rec_asgrid = 'F'
            BEGIN
                SET @v_dcdefaultcols = @rec_tablename + '.' + @v_primarydctable + 'id,' + @rec_tablename + '.' + @rec_tablename + 'id';
            END
            ELSE
            BEGIN
                SET @v_dcdefaultcols = @rec_tablename + '.' + @v_primarydctable + 'id,' + @rec_tablename + '.' + @rec_tablename + 'id,' + @rec_tablename + '.' + @rec_tablename + 'row';
                SET @v_griddc_orderby = ' ORDER BY ' + @rec_tablename + 'row';
            END


            DECLARE @v_fldnames NVARCHAR(MAX) = '';
            DECLARE @v_joins NVARCHAR(MAX) = '';
            

            DECLARE @fld_raw NVARCHAR(MAX) = SUBSTRING(@v_allflds, CHARINDEX('=', @v_allflds) + 1, LEN(@v_allflds));
            
            DECLARE @v_fldname_col VARCHAR(255), @v_fldname_normalized VARCHAR(10), @v_fldname_srctbl VARCHAR(255), 
                    @v_fldname_srcfld VARCHAR(255), @v_fldname_allowempty VARCHAR(10);


            DECLARE field_cursor CURSOR FOR 
            SELECT value FROM STRING_SPLIT(@fld_raw, '|');

            OPEN field_cursor;
            FETCH NEXT FROM field_cursor INTO @fld_raw;
            WHILE @@FETCH_STATUS = 0
            BEGIN
             
              
                SET @v_fldname_col        =  dbo.split_part(@fld_raw,'~',1);
                SET @v_fldname_normalized =  dbo.split_part(@fld_raw,'~',2);
                SET @v_fldname_srctbl     =  dbo.split_part(@fld_raw,'~',3);
                SET @v_fldname_srcfld     =  dbo.split_part(@fld_raw,'~',4);
                SET @v_fldname_allowempty =  dbo.split_part(@fld_raw,'~',5);     
                
               

                IF @v_fldname_normalized = 'F'
                    SET @v_fldnames = @v_fldnames + (CASE WHEN LEN(@v_fldnames) > 0 THEN ',' ELSE '' END) + @rec_tablename + '.' + @v_fldname_col;
                ELSE IF @v_fldname_normalized = 'T'
                BEGIN
                    SET @v_fldnames = @v_fldnames + (CASE WHEN LEN(@v_fldnames) > 0 THEN ',' ELSE '' END) + @v_fldname_col + '.' + @v_fldname_srcfld + ' ' + @v_fldname_col;
                    SET @v_joins = @v_joins + (CASE WHEN @v_fldname_allowempty = 'F' THEN ' JOIN ' ELSE ' LEFT JOIN ' END) + 
                                   @v_fldname_srctbl + ' ' + @v_fldname_col + ' ON ' + @rec_tablename + '.' + @v_fldname_col + ' = ' + @v_fldname_col + '.' + @v_fldname_srctbl + 'id';
                END

                FETCH NEXT FROM field_cursor INTO @fld_raw;
            END
            CLOSE field_cursor;
            DEALLOCATE field_cursor;

            -- 6. Insert Final Result
            INSERT INTO @ResultTable (transid, dcno, griddc, sqltext)
            VALUES (
                @ptransid, 
                @rec_dname, 
                @rec_asgrid, 
                'SELECT ' + @v_dcdefaultcols + ',' + @v_fldnames + ' FROM ' + @rec_tablename + @v_joins + ' WHERE ' + @rec_tablename + '.' + @v_primarydctable + 'id = :recordid' + @v_griddc_orderby
            );
        END

        FETCH NEXT FROM outer_cursor INTO @rec_dname, @rec_asgrid, @rec_tablename;
    END

    CLOSE outer_cursor;
    DEALLOCATE outer_cursor;

    RETURN;
END;
>>

<<
CREATE PROCEDURE FN_AXDBPUT_GETRECID
    @psiteno INT, 
    @pnoofrows INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ResultTable TABLE (recordid VARCHAR(255));
    DECLARE @v_seq_num BIGINT;
    DECLARE @v_final VARCHAR(255);
    DECLARE @i INT = 1;

    WHILE @i <= @pnoofrows
    BEGIN

        SET @v_seq_num = NEXT VALUE FOR seq_axdb_recordid;

     
        DECLARE @padded_site VARCHAR(10) = LEFT(CAST(@psiteno AS VARCHAR) + '000', 3);
        DECLARE @padded_seq VARCHAR(20) = RIGHT('000000000000' + CAST(@v_seq_num AS VARCHAR), 12);

        INSERT INTO @ResultTable (recordid)
        VALUES (@padded_site + @padded_seq);

        SET @i = @i + 1;
    END

    SELECT recordid FROM @ResultTable;
END;
>>