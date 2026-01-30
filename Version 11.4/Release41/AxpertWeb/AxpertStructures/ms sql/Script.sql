<<
CREATE or alter function fn_axpanalytics_listdata(
	@ptransid VARCHAR(255), 
    @pflds varchar(max) = 'All', 
    @ppagesize NUMERIC = 25, 
    @ppageno NUMERIC = 1, 
    @pfilter nvarchar(max) = 'NA', 
    @pusername VARCHAR(255) = 'admin', 
    @papplydac VARCHAR(1)='T',
    @puserrole varchar(max) ='All',
    @pconstraints varchar(max) =NULL
    )
    RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE 
        @v_sql NVARCHAR(MAX),
        @v_sql1 NVARCHAR(MAX),
        @v_primarydctable VARCHAR(255),
        @v_allflds VARCHAR(MAX),
        @v_fldname_dctablename VARCHAR(255),
        @v_fldname_dcflds VARCHAR(MAX),
        @v_fldname_col VARCHAR(255),
        @v_fldname_normalized VARCHAR(255),
        @v_fldname_srctbl VARCHAR(255),
        @v_fldname_srcfld VARCHAR(255),
        @v_fldname_allowempty VARCHAR(255), 
        @v_fldname_joinsary NVARCHAR(MAX),
        @v_fldnamesary NVARCHAR(MAX),
        @v_fldname_transidcnd NUMERIC,
        @v_filter_srcfld NVARCHAR(MAX),
		@v_filter_srctxt NVARCHAR(MAX),
		@v_filter_join NVARCHAR(MAX),
		@v_filter_joinsary NVARCHAR(MAX),
		@v_filter_cnd NVARCHAR(MAX),
		@v_filter_cndary NVARCHAR(MAX),
		@v_filter_joinreq numeric,
		@v_filter_dcjoinsary NVARCHAR(MAX),
		@v_filter_col NVARCHAR(MAX),
		@v_filter_normalized NVARCHAR(MAX),
		@v_filter_sourcetbl NVARCHAR(MAX),
		@v_filter_sourcefld NVARCHAR(MAX),
		@v_filter_datatype NVARCHAR(MAX),
		@v_filter_listedfld NVARCHAR(MAX),
		@v_filter_tablename NVARCHAR(MAX),
		@v_fldname_tables NVARCHAR(MAX),
		@v_dacenabled numeric=0,
		@v_dactype numeric,
		@v_dac_join NVARCHAR(MAX),
		@v_dac_joinsary NVARCHAR(MAX),
		@v_dac_cnd NVARCHAR(MAX),
		@v_dac_cndary NVARCHAR(MAX),
		@v_dac_joinreq numeric,
		@v_dac_normalizedjoinreq numeric,
		@v_tablename nvarchar(max)

       

    -- Retrieve primary DC table based on tstruct
    SELECT @v_primarydctable = tablename 
    FROM axpdc 
    WHERE tstruct = @ptransid AND dname = 'dc1';
    
    -- Retrieve transid condition
    SELECT @v_fldname_transidcnd = COUNT(1) 
    FROM axpflds 
    WHERE tstruct = @ptransid AND dcname = 'dc1' AND LOWER(fname) = 'transid';
    
    -- If pflds is 'All', get all fields for primary table
    IF @pflds = 'All'
    BEGIN
        SELECT @v_allflds = concat(tablename, '=', string_agg(CONCAT(fname, '~', srckey, '~', srctf, '~', srcfld, '~', allowempty),'|'))
        FROM axpflds 
        WHERE tstruct = @ptransid 
          AND dcname = 'dc1' 
          AND asgrid = 'F' 
          AND hidden = 'F' 
          AND savevalue = 'T' 
          AND tablename = @v_primarydctable 
          AND datatype NOT IN ('i', 't')
         group by tablename;
    END
    
    -- Iterate over the fields in pflds or all fields if 'All' is passed
    DECLARE @dcdtls VARCHAR(MAX);
    DECLARE @fldname VARCHAR(255);
    
    DECLARE cur1 CURSOR FOR
    SELECT value
    FROM STRING_SPLIT(CASE WHEN @pflds = 'All' THEN @v_allflds ELSE @pflds END, '^');
    
    OPEN cur1;
    FETCH NEXT FROM cur1 INTO @dcdtls;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Split the field details into variables
        SET @v_fldname_dctablename = dbo.split_part(@dcdtls,'=',1);
        SET @v_fldname_dcflds = dbo.split_part(@dcdtls,'=',2);

        -- Join DC tables if needed
        IF @v_fldname_dctablename != @v_primarydctable
        BEGIN
            SET @v_fldname_joinsary = CONCAT(@v_fldname_joinsary, ' LEFT JOIN ', @v_fldname_dctablename, 
                                               ' ON ', @v_primarydctable, '.', @v_primarydctable, 'id = ', 
                                               @v_fldname_dctablename, '.', @v_primarydctable, 'id');
        END
        
        -- Iterate over fields to join or select
        DECLARE cur2 CURSOR FOR 
        SELECT value
        FROM STRING_SPLIT(@v_fldname_dcflds, '|');
        
        OPEN cur2;
        FETCH NEXT FROM cur2 INTO @fldname;
        
   WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @v_fldname_col = dbo.split_part(@fldname,'~',1);
            SET @v_fldname_normalized = dbo.split_part(@fldname,'~',2);
            SET @v_fldname_srctbl = dbo.split_part(@fldname,'~',3);
            SET @v_fldname_srcfld = dbo.split_part(@fldname,'~',4);
            SET @v_fldname_allowempty = dbo.split_part(@fldname,'~',5);
            
            IF @v_fldname_normalized = 'F'
            BEGIN
                SET @v_fldnamesary = CONCAT(@v_fldnamesary, @v_fldname_dctablename, '.', @v_fldname_col, ',');
            END
            ELSE IF @v_fldname_normalized = 'T'
            BEGIN
                SET @v_fldnamesary = CONCAT(@v_fldnamesary, @v_fldname_col, '.', @v_fldname_srcfld, ' ', @v_fldname_col, ',');
                SET @v_fldname_joinsary = CONCAT(@v_fldname_joinsary, 
                    CASE WHEN @v_fldname_allowempty = 'F' THEN ' JOIN ' ELSE ' LEFT JOIN ' END, 
@v_fldname_srctbl, ' ', @v_fldname_col, 
                    ' ON ', @v_fldname_dctablename, '.', @v_fldname_col, ' = ', @v_fldname_col, '.', @v_fldname_srctbl, 'id');
            END
            
            FETCH NEXT FROM cur2 INTO @fldname;
        END
        
        CLOSE cur2;
        DEALLOCATE cur2;
        
        FETCH NEXT FROM cur1 INTO @dcdtls;
    END
    
    CLOSE cur1;
    DEALLOCATE cur1;
	set @v_fldnamesary = LEFT(@v_fldnamesary, LEN(@v_fldnamesary) - 1); 	
    -- Construct the final SQL statement
    SET @v_sql = CONCAT('SELECT ''', @ptransid, ''' AS transid, ', @v_primarydctable, '.', @v_primarydctable, 
                        'id AS recordid, ', @v_primarydctable, '.username AS modifiedby, ', 
                        @v_primarydctable, '.modifiedon, ', @v_primarydctable, '.createdon, ', 
                        @v_primarydctable, '.createdby, ', @v_fldnamesary, 
                        ' FROM ', @v_primarydctable, ' ', @v_fldname_joinsary);
                       
                       
---------filters	        
		IF @pfilter = 'NA'
		    	BEGIN
			    	if @ppagesize > 0 begin
		        SET @v_sql1 =  
    'SELECT b.* FROM (' +
    '    SELECT a.*, ' +
    '        ROW_NUMBER() OVER(ORDER BY modifiedon DESC) AS rno, ' +
    '        CASE ' +
    '            WHEN ROW_NUMBER() OVER(ORDER BY modifiedon DESC) %' + CAST(@ppagesize AS NVARCHAR) + ' = 0 ' +
    '                THEN ROW_NUMBER() OVER(ORDER BY modifiedon DESC) / ' + CAST(@ppagesize AS NVARCHAR) + ' ' +
    '            ELSE ROW_NUMBER() OVER(ORDER BY modifiedon DESC) / ' + CAST(@ppagesize AS NVARCHAR) + ' + 1 ' +
    '        END AS pageno ' +
    '    FROM (' +    
    '        ' + @v_sql + ' ' +    
    '        WHERE ' + @v_primarydctable + '.cancel = ''F'' ' +
    '        ' + CASE WHEN @v_fldname_transidcnd > 0 THEN 'AND ' + @v_primarydctable + '.transid = ''' + @ptransid + '''' ELSE '' END + ' ' +
    '        ' + CASE WHEN @v_dacenabled > 0 THEN 'AND ' + @v_dac_cndary ELSE '' END + ' ' +
    '    ) a ' +
    '    ORDER BY modifiedon DESC ' +
    '    OFFSET ' + CAST(@ppagesize * (@ppageno - 1) AS NVARCHAR) + ' ROWS ' +
    '    FETCH NEXT ' + CAST(@ppagesize AS NVARCHAR) + ' ROWS ONLY' +
    ') b ' +
    CASE WHEN @ppageno = 0 THEN '' ELSE 'WHERE pageno = ' + CAST(@ppageno AS NVARCHAR) END;
   end
   else begin
	    SET @v_sql1 =  
    'SELECT b.* FROM (' +
    '    SELECT a.*, ' +
    '        ROW_NUMBER() OVER(ORDER BY modifiedon DESC) AS rno, ' +
    '       1 AS pageno ' +
    '    FROM (' +    
    '        ' + @v_sql + ' ' +    
    '        WHERE ' + @v_primarydctable + '.cancel = ''F'' ' +
    '        ' + CASE WHEN @v_fldname_transidcnd > 0 THEN 'AND ' + @v_primarydctable + '.transid = ''' + @ptransid + '''' ELSE '' END + ' ' +
    '        ' + CASE WHEN @v_dacenabled > 0 THEN 'AND ' + @v_dac_cndary ELSE '' END + ' ' +
    '    ) a ' +
    '    ) b ORDER BY modifiedon DESC ' ;
	   end
		    	END
	    ELSE
		    BEGIN
		        DECLARE @filterList TABLE (filter NVARCHAR(MAX));
		
		        INSERT INTO @filterList
		        SELECT value
		        FROM STRING_SPLIT(@pfilter, '^');
		
		        DECLARE @filter NVARCHAR(MAX);
		        
		
		        DECLARE filterCursor CURSOR FOR 
		        SELECT filter 
		        FROM @filterList;
		
		        OPEN filterCursor;
		
		        FETCH NEXT FROM filterCursor INTO @filter;
		
		        WHILE @@FETCH_STATUS = 0
		        BEGIN
		            SET @v_filter_srcfld =  dbo.split_part(@filter,'|',1);
		            SET @v_filter_srctxt = dbo.split_part(@filter,'|',2);
		            SET @v_filter_col = dbo.split_part(@v_filter_srcfld,'~',1);
					SET @v_filter_normalized = dbo.split_part(@v_filter_srcfld,'~',2);
		 			SET @v_filter_sourcetbl = dbo.split_part(@v_filter_srcfld,'~',3);
		 			SET @v_filter_sourcefld = dbo.split_part(@v_filter_srcfld,'~',4);
					SET @v_filter_datatype = dbo.split_part(@v_filter_srcfld,'~',5);
					SET @v_filter_listedfld =dbo.split_part(@v_filter_srcfld,'~',6);
		            SET @v_filter_tablename = dbo.split_part(@v_filter_srcfld,'~',7);
		           
		           
		          	if  @v_filter_listedfld = 'F' begin
					    set @v_filter_joinreq = case when lower(@v_tablename)=lower(@v_filter_tablename) then 1 else 0 end; 			    		
								
						if @v_filter_joinreq = 0  
							begin 
								set @v_filter_dcjoinsary = concat(@v_filter_dcjoinsary,',',concat(' join ',@v_filter_tablename,' on ',@v_primarydctable,'.',@v_primarydctable,'id=',@v_filter_tablename,'.',@v_primarydctable,'id') );
							end
						    				    					  
					    select @v_filter_join  = case when @v_filter_normalized='T' 
						then concat(' join ',@v_filter_sourcetbl,' ',@v_filter_col,' on ',@v_filter_tablename,'.',@v_filter_col,' = ',@v_filter_col,'.',@v_filter_sourcetbl,'id')
						end from dual where @v_filter_normalized='T';
														 
						set @v_filter_joinsary =concat(@v_filter_joinsary,',',@v_filter_join);														
					end
		
		           	select @v_filter_cnd = case when @v_filter_normalized='F' then 
		            concat(case when @v_filter_datatype='c' then 'lower(' end,@v_filter_tablename,'.',@v_filter_col,case when @v_filter_datatype='c' then ')' end,' ',@v_filter_srctxt) else 
					concat(case when @v_filter_datatype='c' then 'lower(' end,@v_filter_col,'.',@v_filter_sourcefld,case when @v_filter_datatype='c' then ')' end,' ',@v_filter_srctxt) end;
		
		            SET @v_filter_cndary = CONCAT(@v_filter_cndary, ' AND ', @v_filter_cnd);
		
		            FETCH NEXT FROM filterCursor INTO @filter;
		        END;
		
		        CLOSE filterCursor;
		        DEALLOCATE filterCursor;
		       
		       if @ppagesize > 0 begin
		        SET @v_sql1 = 
    'SELECT b.* FROM (' +
    '    SELECT a.*, ' +
    '           ROW_NUMBER() OVER (ORDER BY modifiedon DESC) AS rno, ' +
    '           CASE ' +
    '               WHEN ROW_NUMBER() OVER (ORDER BY modifiedon DESC)% ' + CAST(@ppagesize AS NVARCHAR) + ' = 0 ' +
    '                   THEN ROW_NUMBER() OVER (ORDER BY modifiedon DESC) / ' + CAST(@ppagesize AS NVARCHAR) + ' ' +
    '               ELSE ROW_NUMBER() OVER (ORDER BY modifiedon DESC) / ' + CAST(@ppagesize AS NVARCHAR) + ' + 1 ' +
    '           END AS pageno ' +
    '    FROM (' + @v_sql + ' ' +
    ISNULL(@v_filter_dcjoinsary, '') + ' ' +
    ISNULL(@v_filter_joinsary, '') + ' ' +
    'WHERE ' + @v_primarydctable + '.cancel = ''F'' ' +
    + CASE WHEN @v_fldname_transidcnd > 0 
        THEN 'AND ' +@v_primarydctable + '.transid = ''' + @ptransid + ''' AND '
        ELSE '' END + 
    ISNULL(@v_filter_cndary, '') + 
    CASE WHEN @v_dacenabled > 0 
        THEN ' AND ' + ISNULL(@v_dac_cndary, '') 
        ELSE '' END + 
    ') a ' +
    'ORDER BY modifiedon DESC ' +
    'OFFSET ' + CAST(@ppagesize * (@ppageno - 1) AS NVARCHAR) + ' ROWS ' +
    'FETCH NEXT ' + CAST(@ppagesize AS NVARCHAR) + ' ROWS ONLY) b ' +
    CASE WHEN @ppageno = 0 
        THEN '' 
        ELSE 'WHERE pageno = ' + CAST(@ppageno AS NVARCHAR) 
    END;
   end
   else begin
	     SET @v_sql1 = 
    'SELECT b.* FROM (' +
    '    SELECT a.*, ' +
    '           ROW_NUMBER() OVER (ORDER BY modifiedon DESC) AS rno, ' +
    '          1 AS pageno ' +
    '    FROM (' + @v_sql + ' ' +
    ISNULL(@v_filter_dcjoinsary, '') + ' ' +
    ISNULL(@v_filter_joinsary, '') + ' ' +
    'WHERE ' + @v_primarydctable + '.cancel = ''F'' ' +
    + CASE WHEN @v_fldname_transidcnd > 0 
        THEN 'AND ' +@v_primarydctable + '.transid = ''' + @ptransid + ''' AND '
        ELSE '' END + 
    ISNULL(@v_filter_cndary, '') + 
    CASE WHEN @v_dacenabled > 0 
        THEN ' AND ' + ISNULL(@v_dac_cndary, '') 
        ELSE '' END + 
    ') a ' +') b ORDER BY modifiedon DESC ';
	end
		end

    return @v_sql1;
END;
>>
