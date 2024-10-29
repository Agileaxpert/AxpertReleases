--------------------MYSQL
<<

create table bk19924_ax_layoutdesign_saved as select * from ax_layoutdesign_saved;

>>

<<

create table bk19924_ax_layoutdesign as select * from ax_layoutdesign;

>>

<<

CREATE PROCEDURE rel_tmp_axglo_design()
BEGIN
	declare recexists numeric;
	declare recexists1 numeric;
	
select count(1) into recexists from ax_layoutdesign_saved where transid='axglo';
select count(1) into recexists1 from ax_layoutdesign where transid='axglo';

	if recexists = 0 then
		INSERT INTO ax_layoutdesign_saved (transid, module, content, created_by, updated_by, is_deleted, created_on, updated_on, is_migrated, is_publish, is_private, parent_design_id, responsibility, order_by) VALUES('axglo', 'TSTRUCT', '[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]', 'admin', NULL, NULL, NULL, NULL, NULL, 'Y', NULL, 110, NULL, NULL);
	else
		update ax_layoutdesign_saved set content='[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]' where transid='axglo';	
	end if;



	if recexists1 = 0 then
		INSERT INTO ax_layoutdesign (transid, module, content, created_by, updated_by, is_deleted, is_private, created_on, updated_on, is_migrated) VALUES('axglo', 'TSTRUCT','[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]' , 'admin', NULL, NULL, NULL, NULL, NULL, NULL);
	else
		update ax_layoutdesign set content='[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]' where transid='axglo';	
	end if;
	
end;

>>

<<

CALL rel_tmp_axglo_design();

>>


<<

DROP PROCEDURE rel_tmp_axglo_design;

>>

<<

update axp_cards set inhomepage=case when cardtype='kpi' then 'T' else 'F' end

>>

