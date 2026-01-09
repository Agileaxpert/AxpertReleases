<<
ALTER TABLE tstructs ADD runtimemod varchar(1) NULL;
>>

<<
ALTER TABLE tstructs ADD runtimetstruct varchar(1) NULL;
>>

<<
ALTER TABLE TSTRUCTS ALTER COLUMN createdby TYPE varchar(50) USING createdby::varchar(50);
>>

<<
ALTER TABLE TSTRUCTS ALTER COLUMN UPDATEDBY TYPE varchar(50) USING UPDATEDBY::varchar(50);
>>

<<
ALTER TABLE TSTRUCTS ALTER COLUMN IMPORTEDBY TYPE varchar(50) USING IMPORTEDBY ::varchar(50);
>>

<<
ALTER TABLE iviews ALTER COLUMN createdby TYPE varchar(50) USING createdby::varchar(50);
>>

<<
ALTER TABLE iviews ALTER COLUMN UPDATEDBY TYPE varchar(50) USING UPDATEDBY::varchar(50);
>>

<<
ALTER TABLE iviews ALTER COLUMN IMPORTEDBY TYPE varchar(50) USING IMPORTEDBY ::varchar(50);
>>

<<
ALTER TABLE axpflds ADD runtimefld VARCHAR(1) NULL;
>>

<<
ALTER TABLE axpflds ADD applyrule VARCHAR(1) NULL;
>>

<<
ALTER TABLE axpflds ADD displaytotal VARCHAR(1) NULL;
>>

<<
ALTER TABLE axpflds ADD createdby VARCHAR(100) NULL;
>>

<<
ALTER TABLE axpflds ADD createdon date NULL;
>>

<<
ALTER TABLE axpflds ADD modifiedby VARCHAR(100) NULL;
>>

<<
ALTER TABLE axpflds ADD modifiedon date NULL;
>>

<<
alter table axpflds add encrypted VARCHAR(1);
>>

<<
alter table axpflds add masking VARCHAR(100);
>>

<<
alter table axpflds add lastcharmask VARCHAR(100);
>>

<<
alter table axpflds add firstcharmask VARCHAR(100);
>>

<<
alter table axpflds add maskchar VARCHAR(1);
>>

<<
alter table axpflds add maskroles VARCHAR(1000);
>>

<<
alter table axpflds add customdecimal VARCHAR(1);
>>

<<
alter table axpfillgrid add createdby VARCHAR(100);
>>

<<
alter table axpfillgrid add createdon date;
>>

<<
alter table axpfillgrid add modifiedby VARCHAR(100);
>>

<<
alter table axpfillgrid add modifiedon date;
>>

<<
alter table axpmdmaps add createdby VARCHAR(100);
>>

<<
alter table axpmdmaps add createdon date;
>>

<<
alter table axpmdmaps add modifiedby VARCHAR(100);
>>

<<
alter table axpmdmaps add modifiedon date;
>>

<<
alter table axpgenmaps add createdby VARCHAR(100);
>>

<<
alter table axpgenmaps add createdon date;
>>

<<
alter table axpgenmaps add modifiedby VARCHAR(100);
>>

<<
alter table axpgenmaps add modifiedon date;
>>

<<
alter table axpdc add createdby VARCHAR(100);
>>

<<
alter table axpdc add createdon date;
>>

<<
alter table axpdc add modifiedby VARCHAR(100);
>>

<<
alter table axpdc add modifiedon date;
>>

<<
alter table axusergroups add createdby VARCHAR(100);
>>

<<
alter table axusergroups add createdon date;
>>

<<
alter table axusergroups add modifiedby VARCHAR(100);
>>

<<
alter table axusergroups add modifiedon date;
>>

<<
ALTER TABLE axptstructs ADD createdby VARCHAR(100);
>>

<<
ALTER TABLE axptstructs ADD createdon TIMESTAMP;
>>

<<
ALTER TABLE axptstructs ADD modifiedby VARCHAR(100);
>>

<<
ALTER TABLE axptstructs ADD modifiedon TIMESTAMP;
>>

<<
alter table axpertlog add calldetails varchar(2000);
>>

<<
ALTER TABLE AXUSERGROUPS ADD mapname varchar(20);
>>

<<
ALTER table axusergroups add homepage varchar(255) DEFAULT null;
>>

<<
drop VIEW axp_appsearch;
>>

<<
drop view axp_appsearch_data_new;
>>

<<
ALTER TABLE axuseraccess ALTER COLUMN rname TYPE varchar(50) USING rname::varchar(50);
>>

<<
alter table axfastlink add istemplate varchar(1);
>>

<<
alter table axpages add oldappurl varchar(500);
>>

<<
ALTER TABLE axusers ADD pwdauth varchar(1) NULL;
>>

<<
ALTER TABLE axusers ADD otpauth varchar(1) NULL;
>>

<<
update axusers set pwdauth='T',otpauth='F';
>>

<<
ALTER TABLE axusers ADD axlang varchar(100) NULL;
>>

<<
ALTER TABLE AXUSERS ADD singleloginkey VARCHAR(50);
>>

<<
ALTER table axusers add homepage varchar(255) DEFAULT null;
>>

<<
create table if not exists axpformlbls(transid varchar(5), lblname varchar(50), lblcaption varchar(4000));
>>

<<
ALTER TABLE axpages ADD icon varchar(100) NULL;
>>

<<
ALTER TABLE axpages ADD workflow varchar(5) NULL;
>>

<<
ALTER TABLE AXPFLDS ADD TLHW VARCHAR(20);
>>

<<
ALTER TABLE AXPFLDS ADD LBLTLHW VARCHAR(20);
>>

<<
ALTER TABLE iviewparams ADD ordno numeric(3);
>>

<<
ALTER TABLE iviewcols ADD ordno numeric(3);
>>

<<
ALTER TABLE axpages ADD websubtype varchar(15) NULL;
>>

<<
CREATE TABLE axtoolbar (
	"name" varchar(50) NULL,
	stype varchar(20) NULL,
	title varchar(50) NULL,
	"key" varchar(50) NULL,
	folder varchar(10) NULL,
	"action" varchar(100) NULL,
	task varchar(100) NULL,
	script varchar(1000) NULL,
	icon varchar(100) NULL,
	parent varchar(50) NULL,
	haschildren varchar(5) NULL,
	ordno numeric(3) NULL,
	footer varchar(6) NULL,
	visible varchar(7) NULL,
	parentdc varchar(10) NULL,
	"position" varchar(30) NULL,
	api varchar(200) NULL,
	scripts varchar(1000) NULL
);
>>

<<
CREATE TABLE axpdef_usergroups (
	axpdef_usergroupsid numeric(16) NOT NULL,
	cancel varchar(1) NULL,
	sourceid numeric(16) NULL,
	mapname varchar(20) NULL,
	username varchar(50) NULL,
	modifiedon timestamp NULL,
	createdby varchar(50) NULL,
	createdon timestamp NULL,
	wkid varchar(15) NULL,
	app_level numeric(3) NULL,
	app_desc numeric(1) NULL,
	app_slevel numeric(3) NULL,
	cancelremarks varchar(150) NULL,
	wfroles varchar(250) NULL,
	usernames varchar(4000) NULL,
	users_group_name varchar(254) NULL,
	users_group_description varchar(254) NULL,
	isactive varchar(1) NULL,
	CONSTRAINT aglaxpdef_usergroupsid PRIMARY KEY (axpdef_usergroupsid)
);
>>

<<
CREATE TABLE tstructscripts ( 
    username VARCHAR(50) NOT NULL, 
    createdon TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    createdby VARCHAR(50), 
    modifiedon TIMESTAMP, 
    modifiedby VARCHAR(50), 
    stransid VARCHAR(5), 
    control_type CHAR(1), 
    event VARCHAR(50), 
    type VARCHAR(200), 
    name VARCHAR(100), 
    caption VARCHAR(200), 
    script TEXT 
);
>>

<<
CREATE TABLE iviewscripts ( 
    username VARCHAR(50) NOT NULL, 
    createdon TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    createdby VARCHAR(50), 
    modifiedon TIMESTAMP, 
    modifiedby VARCHAR(50), 
    iname VARCHAR(8), 
    event VARCHAR(50), 
    type VARCHAR(200), 
    name VARCHAR(100), 
    caption VARCHAR(200), 
    script TEXT 
);
>>



