<<
update axusers set staysignedin='F',signinexpiry=14;
>>

<<
CREATE FUNCTION fn_axi_metadata (
    @pstructtype VARCHAR(50),
    @pusername VARCHAR(100)
)
RETURNS @ResultTable TABLE (
    structtype NVARCHAR(50),
    caption NVARCHAR(MAX),
    transid NVARCHAR(100)
)
AS
BEGIN

    IF @pstructtype = 'tstructs' OR @pstructtype = 'all'
    BEGIN
        INSERT INTO @ResultTable
        SELECT 'tstruct', caption + '-(' + name + ')', name
        FROM axusergroups a3 
        JOIN axusergroupsdetail a4 ON a3.axusergroupsid = a4.axusergroupsid
        JOIN axuseraccess a5 ON a4.roles_id = a5.rname
        JOIN tstructs t ON a5.sname = t.name
        JOIN axuserlevelgroups ag ON a3.groupname = ag.usergroup 
        WHERE t.blobno = 1 AND ag.username = @pusername
        UNION ALL
        SELECT 'tstruct', caption + '-(' + name + ')', name
        FROM tstructs t 
        JOIN axuserlevelgroups ag ON ag.usergroup = 'default'
        WHERE t.blobno = 1 AND ag.username = @pusername
        UNION ALL
        SELECT 'tstruct', caption + '-(' + name + ')', name 
        FROM tstructs t 
        JOIN axuserlevelgroups u ON u.USERNAME = @pusername
        JOIN axusergroups a ON a.groupname = u.usergroup 
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid        
        WHERE b.ROLES_ID = 'default' AND t.blobno = 1;
    END

    IF @pstructtype = 'iviews' OR @pstructtype = 'all'
    BEGIN
        INSERT INTO @ResultTable
        SELECT 'iview', caption + '-(' + name + ')', name
        FROM axusergroups a3 
        JOIN axusergroupsdetail a4 ON a3.axusergroupsid = a4.axusergroupsid
        JOIN axuseraccess a5 ON a4.roles_id = a5.rname
        JOIN iviews t ON a5.sname = t.name
        JOIN axuserlevelgroups ag ON a3.groupname = ag.usergroup 
        WHERE t.blobno = 1 AND ag.username = @pusername
        UNION ALL
        SELECT 'iview', caption + '-(' + name + ')', name
        FROM iviews t 
        JOIN axuserlevelgroups ag ON ag.usergroup = 'default'
        WHERE t.blobno = 1 AND ag.username = @pusername
        UNION ALL
        SELECT 'iview', caption + '-(' + name + ')', name 
        FROM iviews t 
        JOIN axuserlevelgroups u ON u.USERNAME = @pusername
        JOIN axusergroups a ON a.groupname = u.usergroup 
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid        
        WHERE b.ROLES_ID = 'default' AND t.blobno = 1;
    END


    IF @pstructtype = 'pages' OR @pstructtype = 'all'
    BEGIN
        INSERT INTO @ResultTable
        SELECT 'page', caption + '-(' + name + ')', name
        FROM axusergroups a3 
        JOIN axusergroupsdetail a4 ON a3.axusergroupsid = a4.axusergroupsid
        JOIN axuseraccess a5 ON a4.roles_id = a5.rname
        JOIN axpages p ON a5.sname = p.name AND p.pagetype = 'web'
        JOIN axuserlevelgroups ag ON a3.groupname = ag.usergroup 
        WHERE ag.username = @pusername
        UNION ALL
        SELECT 'page', caption + '-(' + name + ')', name
        FROM axpages t 
        JOIN axuserlevelgroups ag ON ag.usergroup = 'default'
        WHERE t.pagetype = 'web' AND ag.username = @pusername
        UNION ALL
        SELECT 'page', caption + '-(' + name + ')', name 
        FROM axpages t 
        JOIN axuserlevelgroups u ON u.USERNAME = @pusername
        JOIN axusergroups a ON a.groupname = u.usergroup 
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid        
        WHERE b.ROLES_ID = 'default' AND t.pagetype = 'web';
    END

    IF @pstructtype = 'ads' OR @pstructtype = 'all' 
    BEGIN
        INSERT INTO @ResultTable
        SELECT 'ADS', CAST(sqlname AS NVARCHAR(MAX)), sqlname 
        FROM axdirectsql;
    END

    RETURN;
END;
>>

<<
CREATE   FUNCTION fn_axi_struct_metadata
(
    @pstructtype VARCHAR(20),
    @ptransid    VARCHAR(100),
    @pobjtype    VARCHAR(20)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        'Field' AS objtype,
        caption + '(' + fname + ')' AS objcaption,
        fname AS objname,
        dcname,
        asgrid
    FROM axpflds
    WHERE @pstructtype = 'tstruct'
      AND @pobjtype = 'fields'
      AND tstruct = @ptransid
    UNION ALL
    SELECT
        'Genmap',
        caption + '(' + gname + ')',
        gname,
        NULL,
        NULL
    FROM axpgenmaps
    WHERE @pstructtype = 'tstruct'
      AND @pobjtype = 'genmaps'
      AND tstruct = @ptransid
    UNION ALL
    SELECT
        'MDmap',
        caption + '(' + mname + ')',
        mname,
        NULL,
        NULL
    FROM axpmdmaps
    WHERE @pstructtype = 'tstruct'
      AND @pobjtype = 'mdmaps'
      AND tstruct = @ptransid
    UNION ALL
    SELECT
        'Column',
        f_caption + '(' + f_name + ')',
        f_name,
        NULL,
        NULL
    FROM iviewcols
    WHERE @pstructtype = 'iview'
      AND @pobjtype = 'columns'
      AND iname = @ptransid
    UNION ALL
    SELECT
        'Param',
        pcaption + '(' + pname + ')',
        pname,
        NULL,
        NULL
    FROM iviewparams
    WHERE @pstructtype = 'iview'
      AND @pobjtype = 'params'
      AND iname = @ptransid
);
>>

<<
INSERT INTO AXDIRECTSQL (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd, sqlquerycols, encryptedflds, cachedata, cacheinterval, smartlistcnd, adsdesc) VALUES(1109880000000, N'F', 0, NULL, N'admin', '2026-02-18 11:04:38.000', N'admin', '2026-02-18 11:04:38.000', NULL, 1, 1, 0, NULL, NULL, N'Axi_metadata_struct_obj', NULL, N'SELECT * from fn_axi_struct_metadata( :pstructtype, :ptransid , :pobjtype )', N'pstructtype,ptransid,pobjtype', N'pstructtype~Character~,ptransid~Character~,pobjtype~Character~', N'ALL', NULL, N'Metadata', 0, NULL, NULL, N'T', N'6 Hr', NULL, NULL);
>>

<<
INSERT INTO AXDIRECTSQL (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd, sqlquerycols, encryptedflds, cachedata, cacheinterval, smartlistcnd, adsdesc) VALUES(1109770000000, N'F', 0, NULL, N'admin', '2026-02-18 10:51:33.000', N'admin', '2026-02-18 10:51:33.000', NULL, 1, 1, 0, NULL, NULL, N'Axi_getmetadata', NULL, N'SELECT * from fn_axi_metadata( :pstructtype , :pusername )', N'pstructtype,pusername', N'pstructtype~Character~,pusername~Character~', N'ALL', NULL, N'Metadata', 0, NULL, NULL, N'F', N'6 Hr', NULL, NULL);
>>

<<
INSERT INTO AXDIRECTSQL (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd, sqlquerycols, encryptedflds, cachedata, cacheinterval, smartlistcnd, adsdesc) VALUES(1109660000000, N'F', 0, NULL, N'admin', '2026-02-18 10:42:26.000', N'admin', '2026-02-18 10:42:26.000', NULL, 1, 1, 0, NULL, NULL, N'ds_smartlist_ads_metadata', NULL, N'select a.sqlname,b.fldname,b.fldcaption,b.fdatatype, b."normalized" ,b.sourcetable ,b.sourcefld ,hyp_structtype,b.hyp_transid, b.tbl_hyperlink,
case when smartlistcnd like ''%Dynamic select columns%'' then ''T'' else ''F'' end dynamiccolumns,
case when smartlistcnd like ''%Filter%'' then coalesce(b.filter,''No'') else ''F'' end filters,
case when smartlistcnd like ''%Pagination%'' then ''T'' else ''F'' end pagination,
case when smartlistcnd like ''%Sorting%'' then ''T'' else ''F'' end sorting
from axdirectsql a left join axdirectsql_metadata b on a.axdirectsqlid =b.axdirectsqlid 
where sqlname = :adsname
order by b.axdirectsql_metadatarow ', N'adsname', N'adsname~Character~', N'ALL', NULL, N'Metadata', 0, NULL, NULL, N'F', N'6 Hr', NULL, NULL);
>>

<<
INSERT INTO AXDIRECTSQL (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd, sqlquerycols, encryptedflds, cachedata, cacheinterval, smartlistcnd, adsdesc) VALUES(1109550000000, N'F', 0, NULL, N'admin', '2026-02-18 10:41:04.000', N'admin', '2026-02-18 10:41:04.000', NULL, 1, 1, 0, NULL, NULL, N'ds_smartlist_filters', NULL, N'exec fn_axpanalytics_filterdata :ptransid, :psrctxt', N'ptransid,psrctxt', N'ptransid~Character~,psrctxt~Character~', N'ALL', NULL, N'Metadata', 0, NULL, NULL, N'F', N'6 Hr', NULL, NULL);
>>

<<
INSERT INTO AXDIRECTSQL (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd, sqlquerycols, encryptedflds, cachedata, cacheinterval, smartlistcnd, adsdesc) VALUES(1109440000000, N'F', 0, NULL, N'admin', '2026-02-18 10:28:20.000', N'admin', '2026-02-18 10:28:20.000', NULL, 1, 1, 0, NULL, NULL, N'ds_getsmartlists', NULL, N'select sqlname from axdirectsql a where sqlsrc=''Application''', NULL, NULL, N'ALL', NULL, N'Metadata', 0, NULL, NULL, N'F', N'6 Hr', NULL, NULL);
>>

<<
update axdirectsql set sqlsrc='Metadata' 
where sqlname in('Text_Field_Intelligence','ds_getsmartlists','Axi_getmetadata','Axi_metadata_struct_obj','ds_smartlist_filters',
'ds_smartlist_ads_metadata');
>>

<<
update axdirectsql set sqlsrc='Internal' 
where sqlname in('ds_homepage_recentactivities',
'ds_homepage_quicklinks',
'ds_homepage_kpicards',
'ds_homepage_events',
'ds_homepage_banner',
'ds_homepage_activelist',
'axcalendarsource');
>>

<<
update axdirectsql set sqlsrc='Application' 
where sqlname NOT in('Text_Field_Intelligence','ds_getsmartlists','Axi_getmetadata','Axi_metadata_struct_obj','ds_smartlist_filters',
'ds_smartlist_ads_metadata','ds_homepage_recentactivities',
'ds_homepage_quicklinks',
'ds_homepage_kpicards',
'ds_homepage_events',
'ds_homepage_banner',
'ds_homepage_activelist',
'axcalendarsource');
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


    SELECT
        @v_keyfld_normalized = srckey,
        @v_keyfld_srctbl = srctf,
        @v_keyfld_srcfld = srcfld,
        @v_keyfld_mandatory = allowempty
    FROM axpflds
    WHERE tstruct = @ptransid AND fname = @pkeyfield;


    SELECT @v_transid_primetable = tablename
    FROM axpdc
    WHERE tstruct = @ptransid AND dname = 'dc1';


    SET @v_transid_primetableid = CASE WHEN LOWER(@pkeyfield) = 'recordid' THEN @v_transid_primetable + 'id' ELSE @pkeyfield END;


    SET @v_keyfld_cnd = CASE WHEN @v_keyfld_normalized = 'T'
                             THEN QUOTENAME(@v_keyfld_srctbl) + '.' + QUOTENAME(@v_keyfld_srcfld) -- Use QUOTENAME for safety
                             ELSE QUOTENAME(@v_transid_primetable) + '.' + QUOTENAME(@v_transid_primetableid)
                        END + '=' + @pkeyvalue + ' AND ';


    SET @v_keyfld_joins = NULL; -- Initialize
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

        SET @v_permissionexists = 0;
        SET @v_menuaccess = 0;
        SET @rolesql = NULL;
        SET @v_permissionsql = NULL;


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


    SELECT * FROM #PermissionsResults;

    DROP TABLE #PermissionsResults; 

END;
>>
