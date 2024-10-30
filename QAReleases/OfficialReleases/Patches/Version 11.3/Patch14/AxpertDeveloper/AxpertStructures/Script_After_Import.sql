UPDATE ax_layoutdesign_saved SET "content"='[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]'
where transid='axglo';


UPDATE ax_layoutdesign SET "content"='[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]'
where transid='axglo';

update axpstructconfig set uploadfiletype=null where asprops !='Upload file types';

update axp_cards set inhomepage=case when cardtype='kpi' then 'T' else 'F' end

ALTER TABLE executeapidef ADD execapiauthstring varchar(100) NULL;

INSERT INTO axdirectsql (axdirectsqlid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, sqlname, ddldatatype, sqltext, paramcal, sqlparams, accessstring, groupname, sqlsrc, sqlsrccnd) VALUES(1239660000000, 'F', 0, NULL, 'admin', '2024-09-05', 'admin', '2024-08-05', NULL, 1, 1, 0, NULL, NULL, 'DAC_Master_Data', NULL, 'SELECT fn_dac_masterdata(:pmtransid, :pmfldname, cast( :pminctransid as numeric), cast( :pmcnd as numeric) ) from dual
union all
select concat('':'',fname) from axpflds where tstruct=''axglo''
union all
select concat('':'',db_varname)  from axpdef_axvars_dbvar
union all
select '':username'' from dual', 'pmtransid,pmfldname,pminctransid,pmcnd', 'pmtransid,pmfldname,pminctransid,pmcnd', 'ALL', NULL, 'API', 1);



INSERT INTO executeapidef (executeapidefid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, execapidefname, execapiurl, execapiparameterstring, execapiheaderstring, execapirequeststring, execapimethod, execapibasedon, stype, execapiform, execapitransid, execapifilterstring, execapilprintformnames, execapiformattachments, execapiiview, execapiiviewname, execapiiparams, sql_editor_execapisqltext, apicategory, apiresponsetype, apiresponseformat, execapibodyparamstring, execapiauthstring) VALUES(1239880000000, 'F', 0, NULL, 'admin', '2024-09-05', 'admin', '2024-08-05', NULL, 1, 1, 0, NULL, NULL, 'DAC_Master_Data', 'https://axpertdeveloper.agilecloud.biz/Dev11.3scripts/ASBMenuRest.dll/datasnap/rest/TASBMenuRest/GetSqldata', NULL, NULL, '{"_parameters":[{"getsqldata":{"axpapp":"defschema","sqlname":"DAC_Master_Data","isdropdown":"T","trace":"false"},"defschema":{
  "type": "db",
  "structurl": "",
  "db": "Postgre",
  "driver": "dbx",
  "version": "",
  "dbcon": "172.16.0.135",
  "dbuser": "defschema\\goldendump11",
  "pwd": "",
  "dataurl": ""
},"sqlparams":{"pmtransid":"","pmfldname":"","pminctransid":"","pmcnd":""}}]}', 'Post', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Drop Down', 'Axpert', 'JSON', NULL, NULL);