-------------------SQL Server

<<

select * into bk19924_ax_layoutdesign_saved from ax_layoutdesign_saved;

>>

<<

select * into bk19924_ax_layoutdesign from ax_layoutdesign;

>>

<<

merge ax_layoutdesign_saved a
using (values('axglo')) as v(transid) on v.transid= a.transid
when not matched then
INSERT (design_id, transid, "module", "content", created_by, updated_by, is_deleted, created_on, updated_on, is_migrated, is_publish, is_private, parent_design_id, responsibility, order_by) VALUES(0, 'axglo', 'TSTRUCT', '[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]', 'admin', 'admin', 'N', '2024-09-09 14:17:21.339', '2024-09-09 14:18:11.082', 'N', 'Y', 'N', 66, NULL, NULL)
when matched then
update set content='[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]';

>>

<<

merge ax_layoutdesign a
using (values('axglo')) as v(transid) on v.transid= a.transid
when not matched then
INSERT (design_id, transid, "module", "content", created_by, updated_by, is_deleted, is_private, created_on, updated_on, is_migrated) VALUES(0, 'axglo', 'TSTRUCT', '[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]', 'admin', 'admin', 'N', 'N', '2024-09-09 14:17:21.492', '2024-09-09 14:18:12.072', 'N')
when matched then
update set content='[{"transid":"axglo","compressedMode":true,"newDesign":true,"staticRunMode":false,"wizardDC":false,"selectedLayout":"default","selectedFontSize":"14","selectedControlHeight":"24","tstUpdatedOn":"09-09-2024 14:17:41","dcLayout":"single","formWidth":"100","formAlignment":null,"fieldCaptionWidth":"30","formLabel":[],"buttonFieldFont":[],"dcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":15,"height":1,"visibility":true}],"tableDesign":[{"fld_id":"AxGlo_Hide","width":400,"visibility":true}]}],"newdcs":[{"dc_id":"1","isGrid":"F","gridStretch":false,"fieldsDesign":[{"fld_id":"AxGlo_Hide","x":0,"y":0,"width":36,"height":1,"visibility":true},{"fld_id":"fromuserlogin","x":0,"y":1,"width":36,"height":1,"visibility":true},{"fld_id":"axp_displaytext","x":0,"y":2,"width":36,"height":1,"visibility":true}],"tableDesign":null}]}]';

>>

<<

update axp_cards set inhomepage=case when cardtype='kpi' then 'T' else 'F' end

>>