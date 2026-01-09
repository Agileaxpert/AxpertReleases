<<
ALTER TABLE tstructs ADD runtimemod varchar2(1) NULL;
>>

<<
ALTER TABLE tstructs ADD runtimetstruct varchar2(1) NULL;
>>

<<
ALTER TABLE TSTRUCTS MODIFY CREATEDBY VARCHAR2(50);
>>

<<
ALTER TABLE TSTRUCTS MODIFY UPDATEDBY VARCHAR2(50);
>>

<<
ALTER TABLE TSTRUCTS MODIFY IMPORTEDBY VARCHAR2(50);
>>

<<
ALTER TABLE iviews MODIFY CREATEDBY VARCHAR2(50);
>>

<<
ALTER TABLE iviews MODIFY UPDATEDBY VARCHAR2(50);
>>

<<
ALTER TABLE iviews MODIFY IMPORTEDBY VARCHAR2(50);
>>

<<
ALTER TABLE axpflds ADD runtimefld varchar2(1) NULL;
>>

<<
ALTER TABLE axpflds ADD applyrule varchar2(1) NULL;
>>

<<
ALTER TABLE axpflds ADD displaytotal varchar2(1) NULL;
>>

<<
ALTER TABLE axpflds ADD createdby varchar2(100) NULL;
>>

<<
ALTER TABLE axpflds ADD createdon date NULL;
>>

<<
ALTER TABLE axpflds ADD modifiedby varchar2(100) NULL;
>>

<<
ALTER TABLE axpflds ADD modifiedon date NULL;
>>

<<
alter table axpflds add encrypted varchar2(1);
>>

<<
alter table axpflds add masking varchar2(100);
>>

<<
alter table axpflds add lastcharmask varchar2(100);
>>

<<
alter table axpflds add firstcharmask varchar2(100);
>>

<<
alter table axpflds add maskchar varchar2(1);
>>

<<
alter table axpflds add maskroles varchar2(1000);
>>

<<
alter table axpflds add customdecimal varchar2(1);
>>

<<
alter table axpfillgrid add createdby varchar2(100);
>>

<<
alter table axpfillgrid add createdon date;
>>

<<
alter table axpfillgrid add modifiedby varchar2(100);
>>

<<
alter table axpfillgrid add modifiedon date;
>>

<<
alter table axpmdmaps add createdby varchar2(100);
>>

<<
alter table axpmdmaps add createdon date;
>>

<<
alter table axpmdmaps add modifiedby varchar2(100);
>>

<<
alter table axpmdmaps add modifiedon date;
>>

<<
alter table axpgenmaps add createdby varchar2(100);
>>

<<
alter table axpgenmaps add createdon date;
>>

<<
alter table axpgenmaps add modifiedby varchar2(100);
>>

<<
alter table axpgenmaps add modifiedon date;
>>

<<
alter table axpdc add createdby varchar2(100);
>>

<<
alter table axpdc add createdon date;
>>

<<
alter table axpdc add modifiedby varchar2(100);
>>

<<
alter table axpdc add modifiedon date;
>>

<<
alter table axusergroups add createdby varchar2(100);
>>

<<
alter table axusergroups add createdon date;
>>

<<
alter table axusergroups add modifiedby varchar2(100);
>>

<<
alter table axusergroups add modifiedon date;
>>

<<
ALTER TABLE axptstructs ADD createdby VARCHAR2(100);
>>

<<
ALTER TABLE axptstructs ADD createdon TIMESTAMP;
>>

<<
ALTER TABLE axptstructs ADD modifiedby VARCHAR2(100);
>>

<<
ALTER TABLE axptstructs ADD modifiedon TIMESTAMP;
>>

<<
alter table axpertlog add calldetails varchar2(2000);
>>

<<
ALTER TABLE AXUSERGROUPS ADD mapname varchar2(20);
>>

<<
ALTER table axusergroups add homepage varchar2(255) DEFAULT null;
>>

<<
ALTER TABLE axuseraccess modify rname varchar2(50);
>>

<<
alter table axfastlink add istemplate varchar2(1);
>>

<<
alter table axpages add oldappurl varchar2(500);
>>

<<
ALTER TABLE axusers ADD pwdauth varchar2(1);
>>

<<
ALTER TABLE axusers ADD otpauth varchar2(1);
>>

<<
ALTER TABLE axusers ADD axlang varchar2(100);
>>

<<
ALTER TABLE AXUSERS ADD singleloginkey VARCHAR2(50);
>>

<<
ALTER table axusers add homepage varchar2(255);
>>

<<
CREATE TABLE "AXPFORMLBLS" 
   (	"TRANSID" VARCHAR2(5), 
	"LBLNAME" VARCHAR2(50), 
	"LBLCAPTION" VARCHAR2(4000)
   );
>>

<<
ALTER TABLE axpages ADD icon varchar2(100);
>>

<<
ALTER TABLE axpages ADD workflow varchar2(5);
>>

<<
ALTER TABLE AXPFLDS ADD TLHW VARCHAR2(20);
>>

<<
ALTER TABLE AXPFLDS ADD LBLTLHW VARCHAR2(20);
>>

<<
ALTER TABLE iviewparams ADD ordno numeric(3);
>>

<<
ALTER TABLE iviewcols ADD ordno numeric(3);
>>

<<
ALTER TABLE axpages ADD websubtype varchar2(15);
>>

<<
CREATE TABLE AXPDEF_USERGROUPS 
   (	AXPDEF_USERGROUPSID NUMBER(*,0), 
	CANCEL CHAR(1), 
	SOURCEID NUMBER(*,0), 
	MAPNAME VARCHAR2(20), 
	USERNAME VARCHAR2(50), 
	MODIFIEDON DATE, 
	CREATEDBY VARCHAR2(50), 
	CREATEDON DATE, 
	WKID VARCHAR2(15), 
	APP_LEVEL NUMBER(3,0), 
	APP_DESC NUMBER(1,0), 
	APP_SLEVEL NUMBER(3,0), 
	CANCELREMARKS VARCHAR2(150), 
	WFROLES VARCHAR2(250), 
	USERNAMES VARCHAR2(4000), 
	USERS_GROUP_NAME VARCHAR2(254), 
	USERS_GROUP_DESCRIPTION VARCHAR2(254), 
	ISACTIVE VARCHAR2(1), 
	 CONSTRAINT AGLAXPDEF_USERGROUPSID PRIMARY KEY (AXPDEF_USERGROUPSID)
    );
>>

<<
ALTER TABLE  AXIMPJOBS  ADD AXIMPPRIMARYFIELD_DETAILS varchar2(4000);
>>


<<
create table tstructscripts ( 
    username VARCHAR2(50) not null, 
    createdon TIMESTAMP default SYSTIMESTAMP, 
    createdby VARCHAR2(50), 
    modifiedon TIMESTAMP, 
    modifiedby VARCHAR2(50), 
    stransid VARCHAR2(5), 
    control_type CHAR(1), 
    event VARCHAR2(50), 
    type VARCHAR2(100), 
    name VARCHAR2(100), 
    caption VARCHAR2(200), 
    script CLOB 
);
>>

<<
CREATE TABLE iviewscripts ( 
    username VARCHAR2(50) NOT NULL, 
    createdon TIMESTAMP DEFAULT SYSTIMESTAMP, 
    createdby VARCHAR2(50), 
    modifiedon TIMESTAMP, 
    modifiedby VARCHAR2(50), 
    iname VARCHAR2(8), 
    event VARCHAR2(50), 
    type VARCHAR2(200), 
    name VARCHAR2(100), 
    caption VARCHAR2(200), 
    script CLOB 
);
>>
