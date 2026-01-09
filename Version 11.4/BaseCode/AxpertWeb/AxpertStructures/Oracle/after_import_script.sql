<<
ALTER TABLE AXP_VP MODIFY VPVALUE VARCHAR2(300);
>>

<<
ALTER TABLE AXUSERGROUPS ADD mapname varchar2(20);
>>

<<
ALTER TABLE importdatadetails ADD RapidImpId VARCHAR2(100);
>>

<<
ALTER TABLE importdataexceptions ADD RapidImpId VARCHAR2(100);
>>

<<
ALTER TABLE AXUSERACCESS MODIFY RNAME VARCHAR2(50);
>>

<<
ALTER TABLE executeapidef ADD execapiauthstring varchar2(100);
>>

<<
ALTER TABLE axpages ADD OLDAPPURL varchar2(500);
>>

<<
ALTER TABLE axpages ADD WEBSUBTYPE VARCHAR2(15);
>>

<<
ALTER TABLE AXUSERS ADD singleloginkey VARCHAR2(50);
>>

<<
ALTER TABLE axusers ADD axlang varchar2(100) NULL;
>>

<<
alter table axusers add pwdauth varchar2(1);
>>

<<
alter table axusers add otpauth varchar2(1);
>>

<<
alter table axfastlink add istemplate varchar2(1);
>>

<<
update axfastlink set istemplate='T' where transid='axftp' and caption in('letterformat','reportformat');
>>

<<
ALTER TABLE AX_PAGE_SAVED ADD WIDGET_GROUPS Varchar2(1);
>>

<<
ALTER TABLE AX_PAGES ADD WIDGET_GROUPS Varchar2(1);
>>

<<
alter table axpertlog add calldetails varchar2(2000);
>>

<<
ALTER TABLE iviewparams ADD ORDNO NUMBER(3,0);
>>

<<
ALTER TABLE iviewcols ADD ordno NUMERIC (3,0);
>>

<<
ALTER TABLE AXPROCESSDEFV2 Add ACTION_BUTTONS VARCHAR2(100);
>>

<<
ALTER TABLE AXPROCESSDEFV2 add DISPLAYBUTTONS VARCHAR2(200);
>>

<<
ALTER TABLE AXPROCESSDEFV2 add DISPLAYSUBTITLE VARCHAR2(2000);
>>

<<
ALTER TABLE AXPROCESSDEFV2 add MAPFIELD_GROUP VARCHAR2(1000);
>>

<<
ALTER TABLE AXPROCESSDEFV2 add SUBINDEXNO NUMBER(12,0);
>>

<<
ALTER TABLE axp_vp ADD masterdlselect varchar2(200);
>>

<<
CREATE TABLE "AXAPIJOBDETAILS" 
   (	"JOBID" VARCHAR2(100), 
	"REQUESTID" VARCHAR2(50), 
	"URL" VARCHAR2(500), 
	"SERVICENAME" VARCHAR2(50), 
	"METHOD" VARCHAR2(10), 
	"REQUESTSTR" NCLOB, 
	"PARAMS" VARCHAR2(2000), 
	"BPARAMS" VARCHAR2(2000), 
	"HEADER" VARCHAR2(2000), 
	"RESPONSESTR" NCLOB, 
	"STARTTIME" DATE, 
	"ENDTIME" DATE, 
	"SCHJOBID" VARCHAR2(100), 
	"STATUS" VARCHAR2(20), 
	"SESSIONID" VARCHAR2(30), 
	"USERNAME" VARCHAR2(50), 
	"CONTEXT" VARCHAR2(10), 
	"ACT_SCRIPT_NAME" VARCHAR2(100), 
	"AUTHSTR" VARCHAR2(100)
   );
>>

<<
CREATE TABLE "AXONLINECONVLOG" 
   (	"SCRIPT" NCLOB, 
	"ERRMSG" VARCHAR2(4000), 
	"TABLENAME" VARCHAR2(100)
   );
>>

<<
DROP TABLE customtypes;
>>

<<
CREATE TABLE customtypes (
    customtypesid NUMBER(16) NOT NULL,
    cancel VARCHAR2(1) NULL,
    sourceid NUMBER(16) NULL,
    mapname VARCHAR2(20) NULL,
    username VARCHAR2(50) NULL,
    modifiedon TIMESTAMP NULL,
    createdby VARCHAR2(50) NULL,
    createdon TIMESTAMP NULL,
    wkid VARCHAR2(15) NULL,
    app_level NUMBER(3) NULL,
    app_desc NUMBER(1) NULL,
    app_slevel NUMBER(3) NULL,
    cancelremarks VARCHAR2(150) NULL,
    wfroles VARCHAR2(250) NULL,
    typename VARCHAR2(20) NULL,
    datatype VARCHAR2(10) NULL,
    width NUMBER(4) NULL,
    deci NUMBER(5,3) NULL,
    namecheck VARCHAR2(30) NULL,
    replacechar VARCHAR2(30) NULL,
    fcharcheck VARCHAR2(30) NULL,
    validchk VARCHAR2(30) NULL,
    modeofentry VARCHAR2(20) NULL,
    cvalues VARCHAR2(100) NULL,
    defaultvalue VARCHAR2(100) NULL,
    sql_editor_details VARCHAR2(500) NULL,
    exp_editor_expression VARCHAR2(200) NULL,
    exp_editor_validateexpression VARCHAR2(200) NULL,
    readonly VARCHAR2(10) NULL,
    chide VARCHAR2(1) NULL,
    cpattern VARCHAR2(20) NULL,
    cmask VARCHAR2(50) NULL,
    cregularexpress VARCHAR2(500) NULL,
    CONSTRAINT aglcustomtypesid PRIMARY KEY (customtypesid)
);
>>

<<
CREATE TABLE axpublishreport (
    transid VARCHAR2(30),
    publishedon VARCHAR2(25),
    publishedby VARCHAR2(30),
    status VARCHAR2(4000),
    remarks VARCHAR2(1000),
    createdon DATE DEFAULT SYSDATE,
    publishedto VARCHAR2(100),
    transtype VARCHAR2(10)
);
>>

<<
CREATE TABLE AXTOOLBAR 
   (	NAME VARCHAR2(50), 
	STYPE VARCHAR2(20), 
	TITLE VARCHAR2(50), 
	KEY VARCHAR2(50), 
	FOLDER VARCHAR2(10), 
	ACTION VARCHAR2(100), 
	TASK VARCHAR2(100), 
	SCRIPT VARCHAR2(1000), 
	ICON VARCHAR2(100), 
	PARENT VARCHAR2(50), 
	HASCHILDREN VARCHAR2(5), 
	ORDNO NUMBER(3,0), 
	FOOTER VARCHAR2(6), 
	VISIBLE VARCHAR2(7), 
	PARENTDC VARCHAR2(10), 
	POSITION VARCHAR2(30), 
	API VARCHAR2(200)
   );
>>

<<
create table axmmetadatamaster(
structtype VARCHAR2(10),
structname VARCHAR2(15),
structcaption VARCHAR2(50),
structstatus VARCHAR2(50),
ordno NUMBER,
createdon TIMESTAMP default sysdate,
updatedon TIMESTAMP default sysdate,
createdby VARCHAR2(50),
updatedby VARCHAR2(50),
constraint unique_structtype_structname unique(structtype,structname));
>>

<<
CREATE TABLE AXCARDTYPEMASTER 
   (	"AXCARDTYPEMASTERID" NUMBER(*,0), 
	"CANCEL" CHAR(1), 
	"SOURCEID" NUMBER(*,0), 
	"MAPNAME" VARCHAR2(20), 
	"USERNAME" VARCHAR2(50), 
	"MODIFIEDON" DATE, 
	"CREATEDBY" VARCHAR2(50), 
	"CREATEDON" DATE, 
	"WKID" VARCHAR2(15), 
	"APP_LEVEL" NUMBER(3,0), 
	"APP_DESC" NUMBER(1,0), 
	"APP_SLEVEL" NUMBER(3,0), 
	"CANCELREMARKS" VARCHAR2(150), 
	"WFROLES" VARCHAR2(250), 
	"CARDTYPE" VARCHAR2(15), 
	"CARDCAPTION" VARCHAR2(100), 
	"CARDICON" VARCHAR2(500), 
	"AXPFILE_CARDIMG" VARCHAR2(4000), 
	"AXPFILEPATH_CARDIMG" VARCHAR2(1000), 
	 CONSTRAINT "AGLAXCARDTYPEMASTERID" PRIMARY KEY ("AXCARDTYPEMASTERID")
   );
>>

<<
CREATE TABLE AX_HTMLPLUGINS
   (	"name" VARCHAR2(200) NOT NULL ENABLE, 
	"HTMLTEXT" NCLOB, 
	"CONTEXT" VARCHAR2(20), 
	 CONSTRAINT "AX_HTMLPLUGINS_PK" PRIMARY KEY ("name"));
>>

<<
CREATE TABLE importdatacompletion (
    id NUMBER(30) NULL,
    rapidimpid VARCHAR2(100 CHAR) NULL,
    sessionid VARCHAR2(30 CHAR) NULL,
    username VARCHAR2(50 CHAR) NULL,
    calledon TIMESTAMP NULL,
    structname VARCHAR2(6 CHAR) NULL,
    filename VARCHAR2(200 CHAR) NULL,
    recordcount NUMBER(5) NULL,
    success NUMBER(5) NULL,
    resultmsg VARCHAR2(4000 CHAR) NULL,
    errlist CLOB NULL,
    blobno NUMBER NULL
);
>>

<<
CREATE TABLE AXPDEF_SCRIPT 
   (	AXPDEF_SCRIPTID NUMBER(16,0) NOT NULL ENABLE, 
	CANCEL VARCHAR2(1), 
	SOURCEID NUMBER(16,0), 
	MAPNAME VARCHAR2(20), 
	USERNAME VARCHAR2(50), 
	MODIFIEDON TIMESTAMP (6), 
	CREATEDBY VARCHAR2(50), 
	CREATEDON TIMESTAMP (6), 
	WKID VARCHAR2(15), 
	APP_LEVEL NUMBER(3,0), 
	APP_DESC NUMBER(1,0), 
	APP_SLEVEL NUMBER(3,0), 
	CANCELREMARKS VARCHAR2(150), 
	WFROLES VARCHAR2(250), 
	STRUCTNAME VARCHAR2(10), 
	RECID NUMBER(15,0), 
	STRANSID VARCHAR2(5), 
	AXPDEF_TSTRUCTID NUMBER(15,0), 
	CONTROL_TYPE VARCHAR2(1), 
	EVENT VARCHAR2(50), 
	TYPE VARCHAR2(20), 
	FLDFLG NUMBER(1,0), 
	OBJECT VARCHAR2(30), 
	CTFLG VARCHAR2(3), 
	CTDC NUMBER(3,0), 
	NAME VARCHAR2(10), 
	CAPTION VARCHAR2(20), 
	EXP_EDITOR_SCRIPT CLOB, 
	JS_EDITOR_SCRIPT CLOB, 
	SCRIPTPARAMS VARCHAR2(200), 
	PURPOSE VARCHAR2(1000), 
	ACTIVE VARCHAR2(10), 
	SORDERNO NUMBER(10,0), 
	FDETAILS VARCHAR2(100), 
	ISAPI VARCHAR2(1), 
	EXP_EDITOR_FCSCRIPT CLOB, 
	 CONSTRAINT AGLAXPDEF_SCRIPTID PRIMARY KEY (AXPDEF_SCRIPTID));
>>

<<
CREATE TABLE DWB_IVIEWSCRIPTS 
   (	DWB_IVIEWSCRIPTSID NUMBER(16,0) NOT NULL ENABLE, 
	CANCEL VARCHAR2(1), 
	SOURCEID NUMBER(16,0), 
	MAPNAME VARCHAR2(20), 
	USERNAME VARCHAR2(50), 
	MODIFIEDON TIMESTAMP (6), 
	CREATEDBY VARCHAR2(50), 
	CREATEDON TIMESTAMP (6), 
	WKID VARCHAR2(15), 
	APP_LEVEL NUMBER(3,0), 
	APP_DESC NUMBER(1,0), 
	APP_SLEVEL NUMBER(3,0), 
	CANCELREMARKS VARCHAR2(150), 
	WFROLES VARCHAR2(250), 
	STRUCTNAME VARCHAR2(10), 
	RECID NUMBER(15,0), 
	INAME VARCHAR2(8), 
	DWB_IVIEWSID NUMBER(15,0), 
	EVENT VARCHAR2(50), 
	CTFLG VARCHAR2(3), 
	NAME VARCHAR2(10), 
	CAPTION VARCHAR2(20), 
	DUPCHK VARCHAR2(100), 
	EXP_EDITOR_SCRIPT CLOB, 
	SORDERNO NUMBER(10,0), 
	FDETAILS VARCHAR2(100), 
	CAPTITLE VARCHAR2(50), 
	PPAGECREATE VARCHAR2(10), 
	STYPE VARCHAR2(10), 
	ISAPI VARCHAR2(1), 
	 CONSTRAINT AGLDWB_IVIEWSCRIPTSID PRIMARY KEY (DWB_IVIEWSCRIPTSID));
>>

<<
CREATE TABLE ax_userconfigdata (
   page VARCHAR2(100),
   struct VARCHAR2(100),
   keyname VARCHAR2(100),
   username VARCHAR2(100),
   value CLOB
);
>>

<<
CREATE TABLE AXPROCESSDEF 
   (	"AXPROCESSDEFID" NUMBER(16,0) NOT NULL ENABLE, 
	"CANCEL" VARCHAR2(1), 
	"SOURCEID" NUMBER(16,0), 
	"MAPNAME" VARCHAR2(20), 
	"USERNAME" VARCHAR2(50), 
	"MODIFIEDON" TIMESTAMP (6), 
	"CREATEDBY" VARCHAR2(50), 
	"CREATEDON" TIMESTAMP (6), 
	"WKID" VARCHAR2(15), 
	"APP_LEVEL" NUMBER(3,0), 
	"APP_DESC" NUMBER(1,0), 
	"APP_SLEVEL" NUMBER(3,0), 
	"CANCELREMARKS" VARCHAR2(150), 
	"WFROLES" VARCHAR2(250), 
	"PROCESSNAME" VARCHAR2(500), 
	"INDEXNO" NUMBER(10,0), 
	"TASKTYPE" VARCHAR2(10), 
	"TASKNAME" VARCHAR2(500), 
	"ASSIGNTOROLE" VARCHAR2(4000), 
	"FORMCAPTION" VARCHAR2(500), 
	"KEYFIELDCAPTION" VARCHAR2(500), 
	"KEYFIELD" VARCHAR2(250), 
	"DISPLAYTEMPLATE" VARCHAR2(20), 
	"EXP_EDITOR_APPLICABILITY" VARCHAR2(20), 
	"EXP_EDITOR_NEXTTASK" VARCHAR2(20), 
	"PRENOTIFY" VARCHAR2(250), 
	"POSTNOTIFY" VARCHAR2(250), 
	"ALLOWFORWARDTO" VARCHAR2(4000), 
	"MAXTIMEDAYS" NUMBER(2,0), 
	"MAXTIMEHR" NUMBER(2,0), 
	"MAXTIMEMM" NUMBER(2,0), 
	"MAXTIME" VARCHAR2(20), 
	"ESCALATION" VARCHAR2(100), 
	"EXCALATION_ROLE" VARCHAR2(4000), 
	"DATAFIELDS" VARCHAR2(4000), 
	"FORMDATACACHE" VARCHAR2(10), 
	"EXECMAPS" VARCHAR2(2000), 
	"TRANSID" VARCHAR2(10), 
	"TASKDESC" VARCHAR2(20), 
	"ACTIVE" VARCHAR2(1),MAPFIELD_GROUP varchar2(1000), 
	 CONSTRAINT "AGLAXPROCESSDEFID" PRIMARY KEY ("AXPROCESSDEFID"));
>>

<<
CREATE TABLE axrequest (
    requestid VARCHAR2(100) NOT NULL,
    requestreceivedtime TIMESTAMP WITH TIME ZONE NULL,
    sourcefrom VARCHAR2(255) NULL,
    requeststring CLOB NULL,
    headers CLOB NULL,
    params CLOB NULL,
    authz VARCHAR2(255) NULL,
    contenttype VARCHAR2(150) NULL,
    contentlength VARCHAR2(10) NULL,
    host VARCHAR2(255) NULL,
    url CLOB NULL,
    endpoint VARCHAR2(255) NULL,
    requestmethod VARCHAR2(10) NULL,
    apiname VARCHAR2(255) NULL,
    username VARCHAR2(255) NULL,
    additionaldetails CLOB NULL,
    sourcemachineip VARCHAR2(255) NULL,
    CONSTRAINT axrequest_pkey PRIMARY KEY (requestid));
>>

<<
CREATE TABLE axresponse (
    responseid VARCHAR2(100) NOT NULL,
    responsesenttime TIMESTAMP WITH TIME ZONE NULL,
    statuscode NUMBER(4) NULL,
    responsestring CLOB NULL,
    headers CLOB NULL,
    contenttype VARCHAR2(150) NULL,
    contentlength VARCHAR2(10) NULL,
    errordetails CLOB NULL,
    endpoint VARCHAR2(255) NULL,
    requestmethod VARCHAR2(10) NULL,
    username VARCHAR2(255) NULL,
    additionaldetails CLOB NULL,
    requestid VARCHAR2(100) NULL,
    executiontime VARCHAR2(20) NULL,
    CONSTRAINT axresponse_pkey PRIMARY KEY (responseid),
    CONSTRAINT axresponse_requestid_fkey FOREIGN KEY (requestid) REFERENCES axrequest(requestid));
>>

<<
CREATE TABLE "AXACTIVETASKS" 
   (	"EVENTDATETIME" VARCHAR2(30), 
	"TASKID" VARCHAR2(15), 
	"PROCESSNAME" VARCHAR2(500), 
	"TASKTYPE" VARCHAR2(30), 
	"TASKNAME" VARCHAR2(500), 
	"TASKDESCRIPTION" VARCHAR2(4000), 
	"ASSIGNTOROLE" VARCHAR2(50), 
	"TRANSID" VARCHAR2(8), 
	"KEYFIELD" VARCHAR2(30), 
	"EXECONAPPROVE" VARCHAR2(5), 
	"KEYVALUE" VARCHAR2(500), 
	"TRANSDATA" VARCHAR2(4000), 
	"FROMROLE" VARCHAR2(30), 
	"FROMUSER" VARCHAR2(30), 
	"TOUSER" VARCHAR2(500), 
	"PRIORINDEX" NUMBER(10,0), 
	"PRIORTASKNAME" VARCHAR2(200), 
	"CORPDIMENSION" VARCHAR2(10), 
	"ORGDIMENSION" VARCHAR2(10), 
	"DEPARTMENT" VARCHAR2(30), 
	"GRADE" VARCHAR2(10), 
	"DATAVALUE" VARCHAR2(4000), 
	"DISPLAYICON" VARCHAR2(200), 
	"DISPLAYTITLE" VARCHAR2(500), 
	"DISPLAYSUBTITLE" VARCHAR2(250), 
	"DISPLAYCONTENT" NCLOB, 
	"DISPLAYBUTTONS" VARCHAR2(250), 
	"GROUPFIELD" VARCHAR2(4000), 
	"GROUPVALUE" VARCHAR2(4000), 
	"PRIORUSERNAME" VARCHAR2(100), 
	"INITIATOR" VARCHAR2(100), 
	"MAPFIELDVALUE" VARCHAR2(4000), 
	"USERIDENTIFICATIONFILTER" VARCHAR2(1000), 
	"USERIDENTIFICATIONFILTER_OF" VARCHAR2(1000), 
	"MAPFIELD_GROUP" VARCHAR2(1000), 
	"MAPFIELD" VARCHAR2(1000), 
	"GROUPED" VARCHAR2(1), 
	"INDEXNO" NUMBER(10,0), 
	"SUBINDEXNO" NUMBER(10,0), 
	"PROCESSOWNER" VARCHAR2(100), 
	"ASSIGNTOFLG" VARCHAR2(1), 
	"ASSIGNTOACTOR" VARCHAR2(1000), 
	"ACTORFILTER" NCLOB, 
	"RECORDID" NUMBER(20,0), 
	"PROCESSOWNERFLG" NUMBER(1,0), 
	"POWNERFILTER" VARCHAR2(4000), 
	"APPROVEREASONS" VARCHAR2(4000), 
	"DEFAPPTEXT" VARCHAR2(4000), 
	"RETURNREASONS" VARCHAR2(4000), 
	"DEFRETTEXT" VARCHAR2(4000), 
	"REJECTREASONS" VARCHAR2(4000), 
	"DEFREGTEXT" VARCHAR2(4000), 
	"APPROVALCOMMENTS" VARCHAR2(1), 
	"REJECTCOMMENTS" VARCHAR2(1), 
	"RETURNCOMMENTS" VARCHAR2(1), 
	"ESCALATION" VARCHAR2(1), 
	"REMINDER" VARCHAR2(1), 
	"DISPLAYMCONTENT" NCLOB, 
	"GROUPWITHPRIORINDEX" NUMBER(2,0), 
	"DELEGATION" VARCHAR2(1) DEFAULT 'F', 
	"RETURNABLE" VARCHAR2(1), 
	"SENDTOACTOR" VARCHAR2(4000), 
	"ALLOWSEND" VARCHAR2(30), 
	"ALLOWSENDFLG" VARCHAR2(1), 
	"SENDTOCOMMENTS" VARCHAR2(4000), 
	"USEBUSINESSDATELOGIC" VARCHAR2(1), 
	"INITIATOR_APPROVAL" VARCHAR2(1), 
	"INITONBEHALF" VARCHAR2(100), 
	"REMOVEFLG" VARCHAR2(1) DEFAULT 'F', 
	"POWNERFLG" VARCHAR2(1) DEFAULT 'F', 
	"CHANGEDUSR" VARCHAR2(1) DEFAULT 'F', 
	"ACTOR_USER_GROUPS" NCLOB, 
	"ACTOR_DEFAULT_USERS" VARCHAR2(1), 
	"ACTOR_DATA_GRP" VARCHAR2(200), 
	"CANCEL" VARCHAR2(1) DEFAULT 'F', 
	"CANCELLEDBY" VARCHAR2(100), 
	"CANCELLEDON" DATE, 
	"CANCELREMARKS" VARCHAR2(4000), 
	"ACTION_BUTTONS" VARCHAR2(100), 
	"AUTOAPPROVE" VARCHAR2(1), 
	"ISOPTIONAL" VARCHAR2(1), 
	"REMINDERSTARTDATE" DATE, 
	"ESCALATIONSTARTDATE" DATE, 
	"REMINDERJSONDATA" NCLOB, 
	"ESCALATIONJSONDATA" NCLOB) ;
>>

<<
CREATE INDEX "UI_AXACTIVETASKS_TRANSID" ON "AXACTIVETASKS" ("TRANSID");
>>

<<
CREATE INDEX "UI_AXACTIVETASKS_KEYVALUE" ON "AXACTIVETASKS" ("KEYVALUE");
>>

<<
CREATE TABLE AXACTIVETASKDATA 
  (	EVENTDATETIME VARCHAR2(30), 
	TASKID VARCHAR2(15), 
	TRANSID VARCHAR2(8), 
	KEYFIELD VARCHAR2(30), 
	KEYVALUE VARCHAR2(500), 
	DATAVALUES VARCHAR2(4000)
   ); 
>>

<<
CREATE TABLE AXACTIVETASKPARAMS 
   (	EVENTDATETIME VARCHAR2(30), 
	TASKID VARCHAR2(30), 
	TRANSID VARCHAR2(8), 
	KEYFIELD VARCHAR2(30), 
	KEYVALUE VARCHAR2(500), 
	TASKSTATUS VARCHAR2(15), 
	USERNAME VARCHAR2(30), 
	TASKTYPE VARCHAR2(500), 
	TASKNAME VARCHAR2(500), 
	PROCESSNAME VARCHAR2(500), 
	PRIORINDEX NUMBER(10,0), 
	INDEXNO NUMBER(10,0), 
	SUBINDEXNO NUMBER(10,0), 
	RECORDID NUMBER(20,0), 
	TASKPARAMS VARCHAR2(4000)
   );
>>

<<
CREATE TABLE AXACTIVETASKSTATUS 
   (	EVENTDATETIME VARCHAR2(30), 
	TASKID VARCHAR2(15), 
	TRANSID VARCHAR2(8), 
	KEYFIELD VARCHAR2(30), 
	KEYVALUE VARCHAR2(500), 
	TASKSTATUS VARCHAR2(15), 
	USERNAME VARCHAR2(30), 
	TASKTYPE VARCHAR2(500), 
	TASKNAME VARCHAR2(500), 
	PROCESSNAME VARCHAR2(500), 
	PRIORINDEX NUMBER(10,0), 
	INDEXNO NUMBER(10,0), 
	SUBINDEXNO NUMBER(10,0), 
	RECORDID NUMBER(20,0), 
	STATUSREASON VARCHAR2(4000), 
	STATUSTEXT VARCHAR2(4000), 
	CANCELREMARKS VARCHAR2(4000), 
	CANCELLEDBY VARCHAR2(100), 
	CANCELLEDON DATE, 
	CANCEL VARCHAR2(1)
   ); 
>>

<<
CREATE TABLE AXPDEF_PEG_USERGROUPS 
   (	USERNAME VARCHAR2(100), 
	USERGROUPNAME VARCHAR2(500), 
	USERGROUPCODE VARCHAR2(20), 
	ACTIVE VARCHAR2(1), 
	EFFECTIVEFROM DATE, 
	FROMUSER VARCHAR2(1) DEFAULT 'F'
   );
>>

<<
CREATE INDEX USERNAME_IDX ON AXPDEF_PEG_USERGROUPS (USERNAME);
>>

<<
CREATE INDEX UI_AXPDEF_PEG_UGRP_UGROUPNAME ON AXPDEF_PEG_USERGROUPS (USERGROUPNAME);
>>

<<
CREATE TABLE AXACTIVEMESSAGES 
   (	EVENTDATETIME VARCHAR2(30), 
	MSGTYPE VARCHAR2(30), 
	FROMUSER VARCHAR2(30), 
	TOUSER VARCHAR2(500), 
	TASKID VARCHAR2(15), 
	TASKTYPE VARCHAR2(30), 
	PROCESSNAME VARCHAR2(500), 
	TASKNAME VARCHAR2(500), 
	INDEXNO NUMBER(10,0), 
	KEYFIELD VARCHAR2(30), 
	KEYVALUE VARCHAR2(30), 
	TRANSID VARCHAR2(8), 
	DISPLAYTITLE VARCHAR2(500), 
	DISPLAYCONTENT NCLOB, 
	EFFECTIVEFROM DATE, 
	EFFECTIVETO DATE, 
	HTML NCLOB, 
	SCRIPTS NCLOB, 
	HIDE VARCHAR2(1), 
	DISPLAYICON VARCHAR2(200), 
	HLINK VARCHAR2(500), 
	HLINK_TRANSID VARCHAR2(50), 
	HLINK_PARAMS VARCHAR2(2000), 
	REQUESTPAYLOAD NCLOB
   );
>>

<<
CREATE TABLE AXINQUEUESDATA 
   (	CREATEDON DATE DEFAULT sysdate, 
	AXQUEUENAME VARCHAR2(100), 
	TRANSID VARCHAR2(10), 
	RECORDID NUMBER(*,0), 
	QUEUEDATA CLOB
   );
>>

<<
CREATE TABLE AXOUTQUEUESDATA 
   (	CREATEDON DATE DEFAULT sysdate, 
	AXQUEUENAME VARCHAR2(100), 
	TRANSID VARCHAR2(10), 
	RECORDID NUMBER(*,0), 
	QUEUEDATA NCLOB
   );
>>

<<
CREATE TABLE AXPFORMLBLS 
   (	TRANSID VARCHAR2(5), 
	LBLNAME VARCHAR2(50), 
	LBLCAPTION VARCHAR2(4000)
   );
>>

<<
CREATE TABLE "AXAMEND" 
   (	"TRANSID" VARCHAR2(5), 
	"USERSESSION" VARCHAR2(50), 
	"PRIMARYRECORDID" NUMBER(20,0), 
	"AMENDNO" VARCHAR2(25), 
	"AMENDEDBY" VARCHAR2(100), 
	"AMENDEDON" DATE, 
	"FIELDLIST" CLOB, 
	"PARSELIST" CLOB, 
	"RECIDLIST" CLOB
   );
>>

<<
CREATE TABLE axp_struct_release_log (createdon date DEFAULT sysdate,axpversion varchar(100) NULL);
>>

<<
create table Axp_TransCheck(sessionid varchar2(50));
>>

<<
create unique index  ui_AXCTX1 on AXCTX1 (axcontext,atype);
>>

<<
CREATE TABLE AXP_APPSEARCH_DATA
(
  CANCEL                CHAR(1 BYTE),
  SOURCEID              INTEGER,
  MAPNAME               VARCHAR2(20 BYTE),
  USERNAME              VARCHAR2(50 BYTE),
  MODIFIEDON            DATE,
  CREATEDBY             VARCHAR2(50 BYTE),
  CREATEDON             DATE,
  WKID                  VARCHAR2(15 BYTE),
  APP_LEVEL             NUMBER(3),
  APP_DESC              NUMBER(1),
  APP_SLEVEL            NUMBER(3),
  CANCELREMARKS         VARCHAR2(150 BYTE),
  WFROLES               VARCHAR2(250 BYTE),
  HLTYPE                VARCHAR2(10 BYTE),
  STRUCTNAME            VARCHAR2(50 BYTE),
  SEARCHTEXT            VARCHAR2(500 BYTE),
  PARAMS                VARCHAR2(500 BYTE),
  AXP_APPSEARCH_DATAID  NUMBER(16)
);
>>

<<  
CREATE TABLE AXP_APPSEARCH_DATA_V2
(
  HLTYPE      VARCHAR2(10 BYTE),
  STRUCTNAME  VARCHAR2(25 BYTE),
  SEARCHTEXT  VARCHAR2(200 BYTE),
  PARAMS      VARCHAR2(150 BYTE),
  CREATEDON   DATE                              DEFAULT sysdate,
  DOCID       VARCHAR2(50 BYTE)
);
>>

<<
CREATE UNIQUE INDEX UI_AXP_APPSEARCH_DATA_V2 ON AXP_APPSEARCH_DATA_V2(HLTYPE, STRUCTNAME, PARAMS);
>>

<<
CREATE UNIQUE INDEX "AGLAXPROCESSDEFV2ID" ON "AXPROCESSDEFV2" ("AXPROCESSDEFV2ID");
>>

<<
CREATE OR REPLACE TYPE type_peg_sendto AS OBJECT (pusername VARCHAR2(50));
>>

<<
CREATE OR REPLACE TYPE peg_sendto_tab IS TABLE OF type_peg_sendto;
>>

<<
CREATE OR REPLACE TYPE axpdef_axpanalytics_mdata_obj AS object(
	ftransid varchar2(10),
	fcaption varchar2(500),
	fldname varchar2(50),
	fldcap varchar2(500),
	cdatatype varchar2(50),
	fdatatype varchar2(50),
	fmodeofentry varchar2(50),
	hide varchar2(10),
	props varchar2(4000),
	normalized varchar2(10),	
	srctable varchar2(50),
	srcfield varchar2(50),
	srctransid varchar2(10),
	allowempty varchar2(10),
	filtertype varchar2(50),
	grpfield varchar2(10),
	aggfield varchar2(10),
	subentity varchar2(1),
	datacnd numeric(1,0),
	entityrelfld varchar2(100),
	allowduplicate varchar2(2),
	tablename varchar2(100),
	dcname varchar2(10),
	fordno NUMERIC(5,0),
	dccaption varchar2(100),
	griddc varchar2(2),
	listingfld varchar2(1),
	encrypted varchar2(1),
	masking varchar2(100),
	lastcharmask varchar2(100),
	firstcharmask varchar2(100),
	maskchar varchar2(1),
	maskroles varchar2(1000),
	customdecimal varchar2(1));
>>

<<
CREATE OR REPLACE TYPE axpdef_axpanalytics_mdata IS TABLE OF axpdef_axpanalytics_mdata_obj;
>>

<<
CREATE OR REPLACE TYPE axpdef_axpanalytics_peg_obj AS object(axpeg_processname varchar2(200),axpeg_keyvalue varchar2(200),axpeg_status NUMERIC,axpeg_statustext varchar2(4000),axpeg_recordid numeric);
>>

<<
CREATE OR REPLACE TYPE axpdef_axpanalytics_peg IS TABLE OF axpdef_axpanalytics_peg_obj;
>>

<<
CREATE OR REPLACE TYPE axpdef_peg_tasklist_obj AS object(taskname varchar2(500));

>>

<<
CREATE OR REPLACE TYPE axpdef_peg_tasklist IS TABLE OF axpdef_peg_tasklist_obj;
>>

<<
CREATE SEQUENCE AX_ENTITY_RELSEQ INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999 NOCYCLE CACHE 2000 NOORDER;
>>

<<
CREATE SEQUENCE AX_NOTIFY_SEQ INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 20 NOORDER;
>>

<<
Insert into AXCTX1(AXCONTEXT, ATYPE) Values ('File Upload Limit', 'Property');
>>

<<
Insert into AXCTX1(AXCONTEXT, ATYPE) Values ('camera option', 'Property');
>>

<<
Insert into AXCTX1(AXCONTEXT, ATYPE) Values ('Date format','Property');
>>

<<
insert into axctx1(axcontext,atype) values ('Multi Select','Property');
>>

<<
Insert into AXCTX1(ATYPE, AXCONTEXT)Values('Property', 'Resolve Attachment Path');
>>

<<
insert into axctx1 (axcontext,atype) values ('Custom JavaScript','Property');
>>

<<
insert into axctx1 (axcontext,atype) values ('Custom CSS','Property');
>>

<<
insert into axctx1 (axcontext,atype) values('Auto Save Draft','Property');
>>

<<
insert into axctx1 (axcontext,atype) values('Grid Scrollbar','Property');
>>

<<
insert into axctx1 (axcontext,atype) values('Show keyboard in Hybrid App','Property');
>>

<<
INSERT INTO axctx1 (axcontext,atype) values ('Mobile Reports as Table','Property');
>>

<<
INSERT INTO axctx1 (axcontext,atype) values ('Iview Button Style','Property');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'icon path');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Tstruct Button Style');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Apply Mobile UI');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Split Ratio');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Iview Retain Parameters On Next Load');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Fixed Header for Grid');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Iview Responsive Column Width');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Not Fill Dependent Fields');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Fill Dependent Fields');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Striped Reports UI');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'HomePageTemplate');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'CompressedMode');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Upload file types');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Google Maps Zoom');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Iview Session Caching');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Popup fillgrid data based on query order');
>>

<<
INSERT INTO axctx1 (atype, axcontext) VALUES('Property', 'Popup fillgrid data show all');
>>

<<
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND) VALUES(1077770000000, 'F', 0, NULL, 'admin', TIMESTAMP '2023-11-08 14:10:11.000000', 'admin', TIMESTAMP '2023-11-08 14:10:05.000000', NULL, 1, 1, 0, NULL, NULL, 'axcalendarsource', NULL, 'select * from vw_cards_calendar_data where mapname is null and uname = :username order by startdate', 'username', 'username', 'ALL', NULL, 'General', 5);
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND) VALUES(1092550000000, 'F', 0, NULL, 'admin', TIMESTAMP '2023-11-09 17:44:55.000000', 'admin', TIMESTAMP '2023-11-09 17:44:25.000000', NULL, 1, 1, 0, NULL, NULL, 'Text_Field_Intelligence', NULL, 'select id,caption,source from(
select fname id,caption,''Form'' source,2 ord from axpflds where asgrid=''F'' and tstruct = :txttransid 
union all
select db_varname,db_varcaption,''Axvars'' ,3 ord from axpdef_axvars_dbvar a,axpdef_axvars b
where b.axpdef_axvarsid=a.axpdef_axvarsid 
union all
select ''username'',''Login username'',''App vars'' ,4 ord from dual
union all
select ''usergroup'',''User role'',''App vars'' ,4 ord from dual
union all
select fname,caption,''Glovar'',5 ord from axpflds where tstruct=''axglo''
order by 4,1)a
', 'txttransid', 'txttransid', 'ALL', NULL, 'Data intellisense', 3);
>>

<<
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND) VALUES(1369550000000, 'F', 0, NULL, 'admin', TIMESTAMP '2025-01-08 17:25:24.000000', 'admin', TIMESTAMP '2025-01-08 17:25:24.000000', NULL, 1, 1, 0, NULL, NULL, 'ds_homepage_activelist', NULL, 'SELECT touser, fromuser, taskname, eventdatetime, displaytitle, displaycontent , tasktype , rectype, msgtype , taskstatus, cstatus FROM
(select touser, fromuser, taskname, eventdatetime, displaytitle, displaycontent , tasktype , rectype, msgtype , taskstatus, cstatus,ROW_NUMBER() over(ORDER BY edatetime desc) rno,edatetime 
from vw_pegv2_alltasks where case when cstatus=''Active'' then lower(touser) else lower(username) end = :username) 
WHERE rno BETWEEN 1 AND 100
order by edatetime desc 
', 'username', 'username', 'ALL', NULL, 'Home configuration', 2);
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND) VALUES(1359330000000, 'F', 0, NULL, 'admin', TIMESTAMP '2024-12-24 15:56:26.000000', 'admin', TIMESTAMP '2024-12-24 15:56:26.000000', NULL, 1, 1, 0, NULL, NULL, 'ds_homepage_quicklinks', NULL, 'SELECT distinct 
case when lower(servicename)=''get structure'' then t.caption
when lower(servicename) in(''get iview new'',''get iview'') then i.caption end caption,
case when lower(servicename)=''get structure'' then ''t''||structname||''()''
when lower(servicename) in(''get iview new'',''get iview'') then ''i''||structname||''()'' end link
from axpertlog a left join tstructs t on a.structname = t.name 
left join iviews i on a.structname = i.name
where cast(calledon as date) > current_date - 1  
and lower(servicename) in(''get structure'',''get iview new'',''get iview'')
and structname is not null
and a.username  = :username', 'username', 'username', 'ALL', NULL, 'Home configuration', 2);
>>

<<
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND) VALUES(1359220000000, 'F', 0, NULL, 'admin', TIMESTAMP '2024-12-24 15:55:58.000000', 'admin', TIMESTAMP '2024-12-24 15:55:58.000000', NULL, 1, 1, 0, NULL, NULL, 'ds_homepage_recentactivities', NULL, 'select * from 
(select case lower(servicename) 
when ''saving data'' then ''new data created in ''||t.caption 
when ''quick form load'' then t.caption ||'' opened''
when ''form load'' then t.caption ||'' opened''
when ''importdata''  then ''Data import''
when ''exportdata'' then ''Data export''
when ''deleting data'' then ''Data deleted in''||t.caption
when ''get iview new'' then i.caption||'' report opened''
when ''get iview'' then i.caption||'' report opened''
when ''logout'' then ''Logout''
when ''login'' then ''Login''
when ''get structure'' then t.caption ||'' opened''
when ''load data''  then ''Load data in ''||t.caption 
when ''quick load data'' then ''Load data in ''||t.caption 
end title,
username,calledon,
case when lower(servicename) in (''get iview new'',''get iview'') then ''i''||structname||''()'' 
when lower(servicename) in(''quick load data'',''load data'') then ''t''||structname||''(recordid=''||recordid||'')''
when lower(servicename) in(''get structure'',''quick form load'',''form load'',''deleting data'') then ''t''||structname||''()'' end link 
from axpertlog a 
left join tstructs t on a.structname = t.name 
left join iviews i on a.structname = i.name 
where lower(servicename) in (''load data'',''quick load data'',''form load'',''get structure'',''saving data'',''quick form load'',''importdata'',''exportdata'',''deleting data'',''get iview new'',''get iview'',''logout'',''login'')
and calledon > current_date - 2
and username = :username)a
where a.title is not null
order by calledon desc', 'username', 'username', 'ALL', NULL, 'Home configuration', 2);
>>

<<
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND) VALUES(1423880000000, 'F', 0, NULL, 'admin', TIMESTAMP '2025-02-06 10:02:19.000000', 'admin', TIMESTAMP '2025-02-06 10:02:19.000000', NULL, 1, 1, 0, NULL, NULL, 'ds_homepage_banner', NULL, 'SELECT ''Developer faster'' as title, ''Developer faster using Axpert low code platform.'' as subtitle, ''Jan 01, 2025'' as time, ''https://dev.agilecloud.biz/axpert11.3web/CustomPages/images/slider1.png'' as image, '''' as link from dual
union
SELECT ''UI Plugins'' as title, ''Use UI Plugins to enhance the user experience'' as subtitle, ''Jan 01, 2025'' as time, ''https://dev.agilecloud.biz/axpert11.3web/CustomPages/images/slider1.png'' as image, '''' as link from dual
union
SELECT ''Configure yourself'' as title, ''Configure functionalities as per customer needs'' as subtitle, ''Jan 01, 2025'' as time, ''https://dev.agilecloud.biz/axpert11.3web/CustomPages/images/slider1.png'' as image, '''' as link from dual
', NULL, NULL, 'ALL', NULL, 'Home configuration', 2);
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND) VALUES(1359110000000, 'F', 0, NULL, 'admin', TIMESTAMP '2025-01-08 18:37:34.000000', 'admin', TIMESTAMP '2024-12-24 15:55:02.000000', NULL, 1, 1, 0, NULL, NULL, 'ds_homepage_kpicards', NULL, 'select ''Users'' name,count(*) value,''taxusr()'' link from axusers
union all
select ''Records created today'',count(*),null from axpertlog a 
where lower(servicename)=''saving data''
and cast(calledon as date)=current_date
and username =:username
union all 
select ''Active sessions'',count(*),null from axaudit a 
where cast(logintime as date)=current_date
and nologout =''T''
union all
select ''Sample with params'',0,''taxusr(pusername=admin~build=T)'' from dual where 1=2', 'username', 'username', 'ALL', NULL, 'Home configuration', 2);
>>

<<
INSERT INTO AXDIRECTSQL (AXDIRECTSQLID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, SQLNAME, DDLDATATYPE, SQLTEXT, PARAMCAL, SQLPARAMS, ACCESSSTRING, GROUPNAME, SQLSRC, SQLSRCCND) VALUES(1359010000000, 'F', 0, NULL, 'admin', TIMESTAMP '2025-03-11 17:10:57.000000', 'admin', TIMESTAMP '2024-12-24 15:53:04.000000', NULL, 1, 1, 0, NULL, NULL, 'ds_homepage_events', NULL, 'select	title,subdetails subtitle,modifiedon ,''ta__na(recordid=''||axpdef_news_eventsid||'')'' link
from axpdef_news_events
where active=''T'' 
and  (current_date >= effectfrom and (effecto >= current_date or effecto is null))
order by effectfrom', NULL, NULL, 'ALL', NULL, 'Home configuration', 2);
>>

<<
INSERT INTO EXECUTEAPIDEF (EXECUTEAPIDEFID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, EXECAPIDEFNAME, EXECAPIURL, EXECAPIPARAMETERSTRING, EXECAPIHEADERSTRING, EXECAPIREQUESTSTRING, EXECAPIMETHOD, EXECAPIBASEDON, STYPE, EXECAPIFORM, EXECAPITRANSID, EXECAPIFILTERSTRING, EXECAPILPRINTFORMNAMES, EXECAPIFORMATTACHMENTS, EXECAPIIVIEW, EXECAPIIVIEWNAME, EXECAPIIPARAMS, SQL_EDITOR_EXECAPISQLTEXT, APICATEGORY, APIRESPONSETYPE, APIRESPONSEFORMAT, EXECAPIBODYPARAMSTRING, EXECAPIAUTHSTRING) VALUES(1092880000000, 'F', 0, NULL, 'admin', TIMESTAMP '2024-11-08 18:54:51.000000', 'admin', TIMESTAMP '2023-11-09 17:45:42.000000', NULL, 1, 1, 0, NULL, NULL, 'Text_Field_Intelligence', 'https://axpertdeveloper.agilecloud.biz/Dev11.3scripts/ASBMenuRest.dll/datasnap/rest/TASBMenuRest/GetSqldata', NULL, NULL, '{"_parameters":[{"getsqldata":{"axpapp":"deforacle112","sqlname":"Text_Field_Intelligence","isdropdown":"F","trace":"false"},"deforacle112":{
  "type": "db",
  "structurl": "",
  "db": "Oracle",
  "driver": "dbx",
  "version": "",
  "dbcon": "172.16.0.135/orcl",
  "dbuser": "deforacle112",
  "pwd": "",
  "dataurl": ""
},"sqlparams":{"txttransid":""}}]}', 'Post', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SQL', 'Axpert', 'JSON', NULL, NULL);
>>

<<
INSERT INTO axinqueues (axinqueuesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, axqueuename, axqueuedesc, active) VALUES(1540770000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Import broker queue', 'This queue will push data into Axpert. The result is pushed into RapidSaveResponse Queue. The request may contain file upload fields. In this case, the value will be a byte array. This will be stored into Axpert as per definition. Further, a request JSON may have a node named "PrintRequest" with print form names as value for this node. If this is present, the request response JSON will contain the requested print form in the requested file format as byte arrays.', 'T');
>>

<<
INSERT INTO axinqueues (axinqueuesid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, axqueuename, axqueuedesc, active) VALUES(1540880000000, 'F', 0, NULL, 'admin',sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Data import queue', 'This queue will import data into a given Db table in this application. The response will be given in DBTableImportResponse Queue.', 'T');
>>

<<
INSERT INTO axoutqueuesmst (axoutqueuesmstid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, axqueuename, axqueuedesc) VALUES(1551110000000, 'F', 0, NULL, 'admin', sysdate, 'admin',sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Data out queue', 'This default queue will export data from axpert and can be consumed from other applications');
>>

<<
INSERT INTO axoutqueuesmst (axoutqueuesmstid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, axqueuename, axqueuedesc) VALUES(1550990000000, 'F', 0, NULL, 'admin',sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Notification queue', 'This default queue will be used for notifications');
>>

<<
INSERT INTO axpdef_axcalendar_event (axpdef_axcalendar_eventid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, eventname, eventcolor) VALUES(1116010000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Meeting', 'cerise');
>>

<<
INSERT INTO axpdef_axcalendar_event (axpdef_axcalendar_eventid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, eventname, eventcolor) VALUES(1117110000000, 'F', 0, NULL, 'admin',sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Personal', 'blue');
>>

<<
INSERT INTO axpdef_axcalendar_event (axpdef_axcalendar_eventid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, eventname, eventcolor) VALUES(1117110000002, 'F', 0, NULL, 'admin',sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Leave', 'Red');
>>

<<
INSERT INTO axpdef_axcalendar_event (axpdef_axcalendar_eventid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, eventname, eventcolor) VALUES(1117110000001, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Online meet', 'Fuchsia Blue');
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1065440000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Random Number', 'Numeric', 10, 0, 'ADD', 'Random Number', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1055660000007, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Date', 'Date/Time', 10, 0, 'ADD', 'Date', 'T', 'T', 'Accept', NULL, NULL, NULL, 'Date()', NULL, NULL, NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1056880000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Short Text', 'Character', 10, 0, 'ADD', 'Short Text', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1055660000009, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Auto Generate', 'Character', 20, 0, 'ADD', 'Auto Generate', 'T', 'T', 'AutoGenerate', NULL, NULL, NULL, NULL, NULL, 'T', NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1055660000003, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'HTML Text', 'Text', 4000, 0, 'ADD', 'HTML Text', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1055660000002, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Rich Text', 'Text', 4000, 0, 'ADD', 'Rich Text', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1055660000004, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Whole Number', 'Numeric', 10, 0, 'ADD', 'Whole Number', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1055660000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Simple Text', 'Character', 50, 0, 'ADD', 'Simple Text', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1055660000008, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Time', 'Character', 10, 0, 'ADD', 'Time', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1055660000006, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Currency', 'Numeric', 10, 2, 'ADD', 'Currency', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1055660000005, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Decimal Number', 'Numeric', 10, 2, 'ADD', 'Decimal Number', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1065550000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Email', 'Character', 50, 0, 'ADD', 'Email', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1065660000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'URL', 'Character', 100, 0, 'ADD', 'URL', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1065880000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Password', 'Character', 15, 0, 'ADD', 'Password', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1065990000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Mobile Number', 'Numeric', 10, 0, 'ADD', 'Mobile Number', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1066010000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Phone Number', 'Numeric', 10, 0, 'ADD', 'Phone Number', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1066110000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Pin Code', 'Numeric', 6, 0, 'ADD', 'Pin Code', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1066220000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Zip Code', 'Numeric', 6, 0, 'ADD', 'Zip Code', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1065770000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'IP Address', 'Character', 100, 0, 'ADD', 'IP Address', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1100220000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Table', 'Character', 2000, 0, 'ADD', 'Table', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1078330000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'DropDown', 'Character', 20, 0, 'ADD', 'DropDown', 'T', 'T', 'Select From Form', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1139550000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Expression Editor', 'Character', 300, 0, 'ADD', 'Expression Editor', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1139440000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'SQL Editor', 'Character', 2000, 0, 'ADD', 'SQL Editor', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1200660000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Image', 'Image', 50, 0, 'ADD', 'Image', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1215880000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'RadioGroup', 'Character', 50, 0, 'ADD', 'RadioGroup', 'T', 'T', 'Select From Form', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1215770000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Check box', 'Character', 20, 0, 'ADD', 'Check box', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1215660000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'CheckList', 'Character', 50, 0, 'ADD', 'CheckList', 'T', 'T', 'Select From Form', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1245880000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Multi Select', 'Character', 200, 0, 'ADD', 'Multi Select', 'T', 'T', 'Select From Form', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1055660000001, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Large Text', 'Text', 4000, 0, 'ADD', 'Large Text', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1058990000006, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Address', 'Character', 1000, 0, 'ADD', 'Address', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1058990000005, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Boolean', 'Character', 10, 0, 'ADD', 'Boolean', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1058990000004, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Date Range', 'Character', 500, 0, 'ADD', 'Date Range', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>


<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1058990000003, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'File upload field', 'Character', 250, 0, 'ADD', 'File upload field', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1058990000002, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Number range', 'Character', 500, 0, 'ADD', 'Number range', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1058990000001, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Time Range', 'Character', 500, 0, 'ADD', 'Time Range', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO CUSTOMTYPES (CUSTOMTYPESID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, TYPENAME, DATATYPE, WIDTH, DECI, NAMECHECK, REPLACECHAR, FCHARCHECK, VALIDCHK, MODEOFENTRY, CVALUES, DEFAULTVALUE, SQL_EDITOR_DETAILS, EXP_EDITOR_EXPRESSION, EXP_EDITOR_VALIDATEEXPRESSION, READONLY, CHIDE, CPATTERN, CMASK, CREGULAREXPRESS) VALUES(1058990000000, 'F', 0, NULL, 'admin', sysdate, 'admin', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'Website', 'Character', 250, 0, 'ADD', 'Website', 'T', 'T', 'Accept', NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, NULL);
>>

<<
INSERT INTO AXIMPDEF (AXIMPDEFID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, AXIMPDEFNAME, AXIMPFORM, AXIMPTRANSID, AXIMPTEXTQUALIFIER, AXIMPMAPINFILE, AXIMPHEADERROWS, AXIMPPRIMAYFIELD, AXIMPGROUPFIELD, AXIMPFIELDSEPERATOR, AXIMPMAPFIELDS, AXIMPTHREADCOUNT, AXIMPPROCNAME, AXIMPBINDTOTSTRUCT, AXIMPSTDCOLUMNWIDTH, AXIMPIGNOREFLDEXCEPTION, AXIMPONLYAPPEND, AXIMPPROCESSMODE, AXIMPFILEFROMTABLE, AXIMPFIELDSEPERATORUI, AXIMPPRIMARYFIELD_DETAILS) VALUES(1783010000000, 'F', 0, NULL, 'admin', TIMESTAMP '2025-02-11 12:16:59.000000', 'admin', TIMESTAMP '2023-03-24 18:31:48.000000', NULL, 1, 1, 0, NULL, NULL, 'Axlanguage', 'Axlanguage Data', 'ad_li', 'F', 'F', 1, NULL, 'compname', ',', 'dispname,sname,compname,compengcap,compcaption', 1, NULL, 'F', 0, 'F', 'F', 'Process with error (ALL)', 'F', '(comma)', NULL);
>>

<<
INSERT INTO AXCARDTYPEMASTER (AXCARDTYPEMASTERID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, CARDTYPE, CARDCAPTION, CARDICON, AXPFILE_CARDIMG, AXPFILEPATH_CARDIMG) VALUES(1132110000000, 'F', 0, NULL, 'admin', TIMESTAMP '2025-01-09 13:24:19.000000', 'admin', TIMESTAMP '2025-01-09 13:24:19.000000', NULL, 1, 1, NULL, NULL, NULL, 'menu', 'Menu Card', NULL, NULL, NULL);
>>

<<
INSERT INTO AXCARDTYPEMASTER (AXCARDTYPEMASTERID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, CARDTYPE, CARDCAPTION, CARDICON, AXPFILE_CARDIMG, AXPFILEPATH_CARDIMG) VALUES(1132220000000, 'F', 0, NULL, 'admin', TIMESTAMP '2025-01-09 13:24:38.000000', 'admin', TIMESTAMP '2025-01-09 13:24:38.000000', NULL, 1, 1, NULL, NULL, NULL, 'modern menu', 'Modern menu', NULL, NULL, NULL);
>>

<<
INSERT INTO AXCARDTYPEMASTER (AXCARDTYPEMASTERID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, CARDTYPE, CARDCAPTION, CARDICON, AXPFILE_CARDIMG, AXPFILEPATH_CARDIMG) VALUES(1132330000000, 'F', 0, NULL, 'admin', TIMESTAMP '2025-01-09 13:24:53.000000', 'admin', TIMESTAMP '2025-01-09 13:24:53.000000', NULL, 1, 1, NULL, NULL, NULL, 'image card', 'Image card', NULL, NULL, NULL);
>>

<<
INSERT INTO AXCARDTYPEMASTER (AXCARDTYPEMASTERID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, CARDTYPE, CARDCAPTION, CARDICON, AXPFILE_CARDIMG, AXPFILEPATH_CARDIMG) VALUES(1132440000000, 'F', 0, NULL, 'admin', TIMESTAMP '2025-01-09 13:25:09.000000', 'admin', TIMESTAMP '2025-01-09 13:25:09.000000', NULL, 1, 1, NULL, NULL, NULL, 'calendar', 'Calendar', NULL, NULL, NULL);
>>

<<
INSERT INTO AXCARDTYPEMASTER (AXCARDTYPEMASTERID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, CARDTYPE, CARDCAPTION, CARDICON, AXPFILE_CARDIMG, AXPFILEPATH_CARDIMG) VALUES(1132550000000, 'F', 0, NULL, 'admin', TIMESTAMP '2025-01-09 13:25:48.000000', 'admin', TIMESTAMP '2025-01-09 13:25:48.000000', NULL, 1, 1, NULL, NULL, NULL, 'html', 'HTML Card', NULL, NULL, NULL);
>>

<<
INSERT INTO AXCARDTYPEMASTER (AXCARDTYPEMASTERID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, CARDTYPE, CARDCAPTION, CARDICON, AXPFILE_CARDIMG, AXPFILEPATH_CARDIMG) VALUES(1131990000000, 'F', 0, NULL, 'admin', TIMESTAMP '2025-01-09 13:18:17.000000', 'admin', TIMESTAMP '2025-01-09 13:18:17.000000', NULL, 1, 1, NULL, NULL, NULL, 'kpi', 'KPI', NULL, NULL, NULL);
>>

<<
INSERT INTO AXCARDTYPEMASTER (AXCARDTYPEMASTERID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, CARDTYPE, CARDCAPTION, CARDICON, AXPFILE_CARDIMG, AXPFILEPATH_CARDIMG) VALUES(1132010000000, 'F', 0, NULL, 'admin', TIMESTAMP '2025-01-09 13:23:33.000000', 'admin', TIMESTAMP '2025-01-09 13:23:33.000000', NULL, 1, 1, NULL, NULL, NULL, 'list', 'List', NULL, NULL, NULL);
>>

<<
INSERT INTO AXCARDTYPEMASTER (AXCARDTYPEMASTERID, CANCEL, SOURCEID, MAPNAME, USERNAME, MODIFIEDON, CREATEDBY, CREATEDON, WKID, APP_LEVEL, APP_DESC, APP_SLEVEL, CANCELREMARKS, WFROLES, CARDTYPE, CARDCAPTION, CARDICON, AXPFILE_CARDIMG, AXPFILEPATH_CARDIMG) VALUES(1132660000000, 'F', 0, NULL, 'admin', TIMESTAMP '2025-01-09 13:27:40.000000', 'admin', TIMESTAMP '2025-01-09 13:27:40.000000', NULL, 1, 1, NULL, NULL, NULL, 'Options card', 'Options Card', NULL, NULL, NULL);
>>

<<
INSERT INTO axcardtypemaster (axcardtypemasterid, cancel, sourceid, mapname, username, modifiedon, createdby, createdon, wkid, app_level, app_desc, app_slevel, cancelremarks, wfroles, cardtype, cardcaption, cardicon, axpfile_cardimg, axpfilepath_cardimg) VALUES(1362010000000, 'F', 0, NULL, 'abinash',sysdate, 'abinash', sysdate, NULL, 1, 1, NULL, NULL, NULL, 'chart', 'Chart', '', '', '');
>>

<<
insert into  axmmetadatamaster( structtype, structname, structcaption,structstatus, updatedby,createdby)
 select distinct 'tstruct' as structtype, t.name as structname, t.caption as structcaption,'prepare' as structstatus,
 nvl(t.updatedby,'admin') as updatedby,  nvl(t.createdby,'admin') as createdby
 from tstructs t join (select substr(pagetype,2) as stname from axpages where length(pagetype)>1) c on t.name=c.stname
 where
 not exists( select 1 from axmmetadatamaster m where m.structname =t.name and m.STRUCTTYPE='tstruct') and t.blobno=1 
 union all
 select distinct 'iview' as structtype, i.name as structname, i.caption as structcaption, 'prepare' as structstatus,
 nvl(i.updatedby,'admin') as updatedby,  nvl(i.createdby,'admin') as createdby
 from iviews i join ( select substr(pagetype,2) as stname from axpages where length(pagetype)>1) c  on i.name=c.stname
 where
 not exists( select 1 from axmmetadatamaster m where m.structname =i.name and m.STRUCTTYPE='iview') and i.blobno=1;
>>

<<
CREATE OR REPLACE VIEW "AXP_VW_MENU" ("MENUPATH", "CAPTION", "NAME", "ORDNO", "LEVELNO", "PARENT", "TYPE", "PAGETYPE", "VISIBLE", "WEBSUBTYPE") AS 
  SELECT
	menupath,
	caption,
	name,
	ordno,
	levelno,
	parent,
	TYPE,
	pagetype,
	visible,
	websubtype
FROM
	(
	SELECT
		caption,
		DECODE (LEVEL,
		2,
		caption,
		LPAD (' ',
		(LEVEL + levelno * 2) - 1) || caption)

                           AS menu_tree,
		levelno,
		TYPE,
		pagetype,
		SYS_CONNECT_BY_PATH (caption,
		'\') || '\' AS menupath,
		ordno,
		parent,
		name,
		SYS_CONNECT_BY_PATH (visible,
		'\') || '\' AS visible,
		websubtype
	FROM
		axpages
	WHERE
		blobno = 1
	START WITH
		parent IS NULL
	CONNECT BY
		PRIOR name = parent)
ORDER BY ordno,menupath;
>>

<<
CREATE OR REPLACE
VIEW "AXP_VW_MENULIST" ("MENUPATH",
"NAME",
"ORDNO",
"LEVELNO",
"PARENT",
"TYPE",
"PAGETYPE") AS 
  SELECT menupath,name,ordno,levelno,parent,TYPE,pagetype
FROM
	(SELECT 	caption,DECODE (LEVEL,2,caption,LPAD (' ',(LEVEL + levelno * 2) - 1) || caption) AS menu_tree,
		levelno,TYPE,pagetype,SYS_CONNECT_BY_PATH (caption,'\') || '\' AS menupath,
		ordno,parent,name
	FROM axpages
	WHERE blobno = 1
	START WITH parent IS NULL CONNECT BY PRIOR name = parent)
ORDER BY ordno,menupath;
>>

<<
CREATE OR REPLACE VIEW "AXP_APPSEARCH_DATA_NEW" ("SLNO", "HLTYPE", "STRUCTNAME", "SEARCHTEXT", "PARAMS", "OLDAPPURL") AS 
  SELECT 2 AS slno,
          hltype,
          structname,
          TRIM (REPLACE (searchtext, 'View', ' ')) AS searchtext,
          params,a.oldappurl
     FROM axp_appsearch_data_v2 join axpages a on    
   case axp_appsearch_data_v2.hltype when 'iview' then 'i'||axp_appsearch_data_v2.structname 
   when 'tstruct' then 't'||axp_appsearch_data_v2.structname 
   else axp_appsearch_data_v2.structname end = case when axp_appsearch_data_v2.hltype ='Page' then a.name else a.pagetype end 
    WHERE LOWER (PARAMS) NOT LIKE '%sysdate%'
    UNION ALL    
   SELECT 1.9 AS slno,
          hltype,
          structname,
          TRIM (REPLACE (searchtext, 'View', ' ')) AS searchtext,
          params,p.oldappurl
     FROM axp_appsearch_data a join axpages p on    
   case hltype when 'iview' then 'i'||a.structname 
   when 'tstruct' then 't'||a.structname 
   else a.structname end = case when hltype ='Page' then p.name else p.pagetype end 
    WHERE  not exists (Select 'x'  from   axp_appsearch_data_v2 b where a.structname=b.structname and a.params=b.params)    
   UNION ALL   
   SELECT 2,
          hltype,
          structname,
          TRIM (REPLACE (searchtext, 'View', ' ')) AS searchtext,
          REPLACE (
             REPLACE (
                REPLACE (
                   REPLACE (
                      REPLACE (
                         REPLACE (
                            REPLACE (
                               REPLACE (
                                  REPLACE (
                                     PARAMS,
                                     'trunc(add_months(sysdate,0-1),''MM'')',
                                     TRIM (
                                        TO_CHAR (
                                           TRUNC (
                                              ADD_MONTHS (SYSDATE, 0 - 1),
                                              'MM'),
                                           'dd/mm/yyyy'))),
                                  'last_day(add_months(trunc(sysdate),0-1))',
                                  TRIM (
                                     TO_CHAR (
                                        LAST_DAY (
                                           ADD_MONTHS (TRUNC (SYSDATE),
                                                       0 - 1)),
                                        'dd/mm/yyyy'))),
                               'trunc(sysdate)-1',
                               TRIM (
                                  TO_CHAR (TRUNC (SYSDATE) - 1, 'dd/mm/yyyy'))),
                            'trunc(sysdate)',
                            TRIM (TO_CHAR (TRUNC (SYSDATE), 'dd/mm/yyyy'))),
                         'trunc(sysdate,''IW'')',
                         TRIM (TO_CHAR (TRUNC (SYSDATE, 'IW'), 'dd/mm/yyyy'))),
                      'trunc(sysdate-7,''IW'')+6',
                      TRIM (
                         TO_CHAR (TRUNC (SYSDATE - 7, 'IW') + 6,
                                  'dd/mm/yyyy'))),
                   'trunc(sysdate-7,''IW'')',
                   TRIM (TO_CHAR (TRUNC (SYSDATE - 7, 'IW'), 'dd/mm/yyyy'))),
                'trunc(sysdate,''MM'')',
                TRIM (TO_CHAR (TRUNC (SYSDATE, 'MM'), 'dd/mm/yyyy'))),
             ' &',
             '&')
             AS params,a.oldappurl
     FROM axp_appsearch_data_v2 join axpages a on    
   case hltype when 'iview' then 'i'||axp_appsearch_data_v2.structname 
   when 'tstruct' then 't'||axp_appsearch_data_v2.structname 
   else axp_appsearch_data_v2.structname end = case when hltype ='Page' then a.name else a.pagetype end 
    WHERE LOWER (PARAMS) LIKE '%sysdate%'    
   UNION ALL   
   SELECT 1 AS ord,
          'tstruct' AS hltype,
          t.name AS structname,
          t.caption AS searchtext,
          NULL params,p.oldappurl
     FROM tstructs t JOIN axpages p ON 't'||t.name = p.PAGETYPE 
    WHERE t.blobno = 1
          AND EXISTS
                 (SELECT 'x'
                    FROM axp_vw_menu x
                   WHERE     x.pagetype LIKE 't%'
                         AND TRIM (SUBSTR (x.pagetype, 2, 20)) = t.name
                         AND x.visible NOT LIKE '%F%')                        
   UNION ALL   
   SELECT 0 AS ord,
          'iview' AS hltype,
          i.name AS structname,
          i.caption AS searchtext,
          NULL params,p.oldappurl
     FROM iviews i JOIN axpages p ON 'i'||i.name = p.PAGETYPE 
    WHERE i.blobno = 1
          AND EXISTS
                 (SELECT 'x'
                    FROM axp_vw_menu x
                   WHERE     x.pagetype LIKE 'i%'
                         AND TRIM (SUBSTR (x.pagetype, 2, 20)) = i.name
                         AND x.visible NOT LIKE '%F%')                        
UNION ALL 
SELECT 3 AS slno,
    'htmlpages' hltype,
    SUBSTR(axp_vw_menu.name,3) AS structname,
    axp_vw_menu.caption AS searchtext,
    NULL params,p.oldappurl
from axp_vw_menu JOIN axpages p ON axp_vw_menu.name = p.name  
where axp_vw_menu.pagetype='web' and axp_vw_menu.websubtype='htmlpage'
   ORDER BY 1;
>>   
  
<<
CREATE OR REPLACE VIEW "AXP_APPSEARCH" ("SEARCHTEXT", "PARAMS", "HLTYPE", "STRUCTNAME", "USERNAME", "OLDAPPURL") AS 
  SELECT
	UNIQUE
          SEARCHTEXT,
	PARAMS|| CASE
		WHEN PARAMS IS NOT NULL
		AND LOWER(PARAMS) NOT LIKE '%~act%' THEN '~act=load'
		ELSE NULL
	END            AS PARAMS,
	HLTYPE,
	STRUCTNAME,
	USERNAME,oldappurl
FROM
	(
	SELECT
		s.slno,
		s.searchtext,
		s.params,
		s.hltype,
		s.structname,
		lg.username,s.oldappurl
	FROM
		axp_appsearch_data_NEW s,
		axuseraccess a,
		axusergroups g,
		axuserlevelgroups lg
	WHERE
		a.sname = s.structname
		AND a.rname = g.userroles
		AND g.groupname = lg.usergroup
		AND a.stype IN ('t', 'i') AND s.structname!='axurg'
	GROUP BY
		s.searchtext,
		s.params,
		s.hltype,
		s.structname,
		lg.username,
		s.slno,s.oldappurl
UNION
	SELECT
		b.slno,
		b.searchtext,
		b.params,
		b.hltype,
		b.structname,
		lg.username,b.oldappurl
	FROM
		axuserlevelgroups lg,
		(
		SELECT
			DISTINCT s.searchtext,
			s.params,
			s.hltype,
			s.structname,
			NULL slno,s.oldappurl
		FROM
			axp_appsearch_data_NEW s,
			axuseraccess a
		WHERE
			a.sname(+) = s.structname
			AND a.stype(+) IN ('t', 'i') and s.structname!='axurg') b
	WHERE
		lg.usergroup = 'default' AND b.structname!='axurg'
	ORDER BY
		slno,
		username);  
>>

<<
CREATE OR REPLACE VIEW "VW_AXLANGUAGE_EXPORT" ("COMPTYPE", "ORD", "NTRANSID", "COMPNAME", "CAPTION", "ORD2", "ORD3", "HIDDEN") AS 
  SELECT 'tstruct' AS comptype,
    0 AS ord,
    't' || tstructs.name AS ntransid,
    'x__headtext' AS compname,
    tstructs.caption,
    0 AS ord2,
    0 AS ord3,
    'NA' AS hidden
   FROM tstructs
UNION ALL
 SELECT 'tstruct' AS comptype,
    1 AS ord,
    't' || tstruct AS ntransid,
    dname AS compname,
    caption,
    cast(substr(dname, 3) as numeric(10)) AS ord2,
    cast(substr(dname, 3) as numeric(10)) AS ord3,
    'NA' AS hidden
   FROM axpdc
UNION ALL
 SELECT 'tstruct' AS comptype,
    2 AS ord,
    't' || axpflds.tstruct AS ntransid,
    axpflds.fname AS compname,
    axpflds.caption,
    cast(substr(dcname, 3) as numeric(10)) AS ord2,
    axpflds.ordno AS ord3,
        CASE
            WHEN axpflds.hidden = 'TRUE' THEN 'Yes'
            ELSE 'No'
        END AS hidden
   FROM axpflds
UNION ALL
 SELECT 'tstruct' AS comptype,
    4 AS ord,
    't' || name AS ntransid,
    key AS compname,
    title AS caption,
    100 AS ord2,
    ordno AS ord3,
    'NA' AS hidden
   FROM axtoolbar
  WHERE stype = 'tstruct'
UNION ALL
 SELECT 'tstruct' AS comptype,
    5 AS ord,
    't' || b.name AS ntransid,
    a.ctype AS compname,
    a.ccaption AS caption,
    a.ord AS ord2,
    0 AS ord3,
    'NA' AS hidden
   FROM ( SELECT 'pop1' AS ctype,
            'Remove' AS ccaption,
            10001 AS ord FROM dual
        UNION ALL
         SELECT 'pop2' AS text,
            'Print' AS text,
            10002 FROM dual
        UNION ALL
         SELECT 'pop3' AS text,
            'Preview' AS text,
            10003 FROM dual
        UNION ALL
         SELECT 'pop4' AS text,
            'Regenerate Packets' AS text,
            10004 FROM dual
        UNION ALL
         SELECT 'pop5' AS text,
            'View History' AS text,
            10005 FROM dual
        UNION ALL
         SELECT 'lpop1' AS text,
            'Remove' AS text,
            10006 FROM dual
        UNION ALL
         SELECT 'lpop2' AS text,
            'Print' AS text,
            10007 FROM dual
        UNION ALL
         SELECT 'lpop3' AS text,
            'Preview' AS text,
            10008 FROM dual
        UNION ALL
         SELECT 'lpop4' AS text,
            'Params' AS text,
            10009 FROM dual
        UNION ALL
         SELECT 'lpop5' AS text,
            'Preview Form' AS text,
            10010 FROM dual
        UNION ALL
         SELECT 'lpop6' AS text,
            'Print Form' AS text,
            10011 FROM dual
        UNION ALL
         SELECT 'lpop7' AS text,
            'PDF' AS text,
            10012 FROM dual
        UNION ALL
         SELECT 'lpop8' AS text,
            'Regenerate Packets' AS text,
            10013 FROM dual
        UNION ALL
         SELECT 'lpop9' AS text,
            'Save As' AS text,
            10014 FROM dual
        UNION ALL
         SELECT 'lpop10' AS text,
            'To XL' AS text,
            10015 FROM dual
        UNION ALL
         SELECT 'lpop11' AS text,
            'Rapid XL Export' AS text,
            10016 FROM dual
        UNION ALL
         SELECT 'lpop12' AS text,
            'View Attachment' AS text,
            10017 FROM dual
        UNION ALL
         SELECT 'lblSearh' AS text,
            'Search For' AS text,
            10018 FROM dual
        UNION ALL
         SELECT 'lblWith' AS text,
            'With' AS text,
            10019 FROM dual) a,
    tstructs b
UNION ALL
 SELECT 'AxPages' AS comptype,
    levelno AS ord,
    NULL AS ntransid,
    name AS compname,
    caption,
    ordno AS ord2,
    0 AS ord3,
    'NA' AS hidden
   FROM axpages
UNION ALL
 SELECT 'iview' AS comptype,
    0 AS ord,
    'i' || name AS ntransid,
    'x__head' AS compname,
    iviews.caption,
    1 AS ord2,
    0 AS ord3,
    'NA' AS hidden
   FROM iviews
UNION ALL
 SELECT 'iview' AS comptype,
    1 AS ord,
    'i' || iname AS ntransid,
    'RH1' AS compname,
    header1 AS caption,
    2 AS ord2,
    0 AS ord3,
    'NA' AS hidden
   FROM iviewmain
UNION ALL
 SELECT 'iview' AS comptype,
    2 AS ord,
    'i' || iname AS ntransid,
    pname AS compname,
    pcaption AS caption,
    ordno AS ord2,
    0 AS ord3,
    'NA' AS hidden
   FROM iviewparams
UNION ALL
 SELECT 'iview' AS comptype,
    3 AS ord,
    'i' || iname AS ntransid,
    f_name AS compname,
    f_caption AS caption,
    ordno AS ord2,
    0 AS ord3,
    'NA' AS hidden
   FROM iviewcols
UNION ALL
 SELECT 'iview' AS comptype,
    4 AS ord,
    'i' || name AS ntransid,
    key AS compname,
    title AS caption,
    ordno AS ord2,
    0 AS ord3,
    'NA' AS hidden
   FROM axtoolbar
  WHERE stype = 'iview'
UNION ALL
 SELECT 'iview' AS comptype,
    5 AS ord,
    'i' || b.name AS ntransid,
    a.ctype AS compname,
    a.ccaption AS caption,
    a.ord AS ord2,
    0 AS ord3,
    'NA' AS hidden
   FROM iviews b,
    ( SELECT 'anac1' AS ctype,
            'Column Heading' AS ccaption,
            1 AS ord FROM dual
        UNION ALL
         SELECT 'anac2' AS text,
            'Operator' AS text,
            2 FROM dual
        UNION ALL
         SELECT 'anac3' AS text,
            'Value (s)' AS text,
            3 FROM dual
        UNION ALL
         SELECT 'anac4' AS text,
            'Relations' AS text,
            4 FROM dual
        UNION ALL
         SELECT 'pop1' AS text,
            'Delete' AS text,
            5 FROM dual
        UNION ALL
         SELECT 'pop2' AS text,
            'New' AS text,
            6 FROM dual
        UNION ALL
         SELECT 'pop3' AS text,
            'Params' AS text,
            7 FROM dual
        UNION ALL
         SELECT 'pop4' AS text,
            'Preview Form' AS text,
            8 FROM dual
        UNION ALL
         SELECT 'pop5' AS text,
            'Print Form' AS text,
            9 FROM dual
        UNION ALL
         SELECT 'pop6' AS text,
            'PDF' AS text,
            10 FROM dual
        UNION ALL
         SELECT 'pop7' AS text,
            'Regenerate Packets' AS text,
            11 FROM dual
        UNION ALL
         SELECT 'pop8' AS text,
            'Save As' AS text,
            12 FROM dual
        UNION ALL
         SELECT 'pop9' AS text,
            'To XL' AS text,
            13 FROM dual
        UNION ALL
         SELECT 'pop10' AS text,
            'Rapid XL Export' AS text,
            14 FROM dual
        UNION ALL
         SELECT 'pop11' AS text,
            'View Attachment' AS text,
            15 FROM dual) a;
>>

<<
CREATE OR REPLACE VIEW "VW_CARDS_CALENDAR_DATA" ("UNAME", "AXCALENDARID", "EVENTNAME", "SENDERNAME", "MESSAGETEXT", "EVENTTYPE", "STARTDATE", "AXPTM_STARTTIME", "ENDDATE", "AXPTM_ENDTIME", "LOCATION", "STATUS", "EVENTCOLOR", "RECORDID", "EVENTSTATUS", "EVENTSTATCOLOR", "MAPNAME") AS 
  SELECT DISTINCT a.uname,
a.axcalendarid,
a.eventname,
a.sendername,
to_char(a.messagetext) messagetext,
a.eventtype,
a.startdate,
nvl(a.axptm_starttime, '00:00') AS axptm_starttime,
a.enddate,
CASE
WHEN nvl(a.axptm_endtime, '00:00') = '00:00' THEN '23:59'
ELSE a.axptm_endtime
END AS axptm_endtime,
a.location,
a.status,
    b.eventcolor,
        CASE
            WHEN a.sourceid = 0 THEN a.axcalendarid
            ELSE a.sourceid
        END AS recordid,
    a.eventstatus,
    c.eventstatcolor,SUBSTR(a.mapname,1,5) mapname
FROM axcalendar a  JOIN axpdef_axcalendar_event b ON a.axpdef_axcalendar_eventid = b.axpdef_axcalendar_eventid
     LEFT JOIN ( SELECT axpdef_axcalendar_eventst.axpdef_axcalendar_eventid,
            axpdef_axcalendar_eventst.eventstatus,
            axpdef_axcalendar_eventst.eventstatcolor
           FROM axpdef_axcalendar_eventst) c ON a.axpdef_axcalendar_eventid = c.axpdef_axcalendar_eventid AND a.eventstatus = c.eventstatus
  WHERE a.cancel = 'F' AND a.parenteventid > 0
UNION ALL
SELECT DISTINCT a.sendername AS uname,
a.axcalendarid,
a.eventname,
a.sendername,
to_char(a.messagetext) messagetext,
a.eventtype,
a.startdate,
nvl(a.axptm_starttime, '00:00') AS axptm_starttime,
CASE
WHEN a.recurring IS NULL THEN a.enddate
ELSE a.startdate
END AS enddate,
CASE
WHEN nvl(a.axptm_endtime, '00:00') = '00:00'THEN '23:59'
ELSE a.axptm_endtime
END AS axptm_endtime,
a.location,
a.status,
    b.eventcolor,
        CASE
            WHEN a.sourceid = 0 THEN a.axcalendarid
            ELSE a.sourceid
        END AS recordid,
    a.eventstatus,
    c.eventstatcolor,substr(a.mapname,1,5) mapname
FROM axcalendar a   JOIN axpdef_axcalendar_event b ON a.axpdef_axcalendar_eventid = b.axpdef_axcalendar_eventid
     LEFT JOIN ( SELECT axpdef_axcalendar_eventst.axpdef_axcalendar_eventid,
            axpdef_axcalendar_eventst.eventstatus,
            axpdef_axcalendar_eventst.eventstatcolor
           FROM axpdef_axcalendar_eventst) c ON a.axpdef_axcalendar_eventid = c.axpdef_axcalendar_eventid AND a.eventstatus = c.eventstatus
WHERE a.cancel= 'F' AND a.parenteventid = 0
ORDER BY 7;
>>

<<
CREATE OR REPLACE VIEW VW_CARDS_DASHBOARD  
AS 
  SELECT
	a.cardtype,
	a.cardname,
	a.cardicon,
	a.charttype,
	a.pluginname,
	CASE
		WHEN a.pluginname IS NULL THEN a.html_editor_card
		ELSE h.htmltext
	END AS htmltext,
	a.card_datasource,
	s.sqltext sqltext,
	a.width,
	a.height,
	a.autorefresh,
	uroles.role AS uroles,
	a.axp_cardsid,
	h.context,
	a.orderno,
	a.chartjson,ROW_NUMBER() over(PARTITION BY uroles.role,CARDTYPE,cardname ORDER BY CARDTYPE,cardname) rno
FROM
	axp_cards a
LEFT JOIN
ax_htmlplugins h ON
	a.pluginname = h."name"
LEFT JOIN
axdirectsql s ON
	a.card_datasource = s.sqlname
LEFT JOIN
(
	SELECT distinct
		a.axp_cardsid,
		trim(regexp_substr(a.accessstringui, '[^,]+', 1, LEVEL)) AS ROLE
	FROM
		axp_cards a
	CONNECT BY
		regexp_substr(a.accessstringui, '[^,]+', 1, LEVEL) IS NOT NULL
) uroles ON
	a.axp_cardsid = uroles.axp_cardsid
WHERE
	a.indashboard = 'T';
>>

<<
CREATE OR REPLACE VIEW VW_CARDS_HOMEPAGES AS 
SELECT
	a.cardtype,
	a.cardname,
	a.cardicon,
	a.charttype, 
	a.pluginname,
	CASE
		WHEN a.pluginname IS NULL THEN a.html_editor_card
		ELSE h.htmltext
	END AS htmltext,
	a.card_datasource,
	s.sqltext sqltext,
	a.width,
	a.height,
	a.autorefresh,
	uroles.role AS uroles,
	a.axp_cardsid,
	h.context,
	a.orderno,
	a.chartjson,ROW_NUMBER() over(PARTITION BY uroles.ROLE,CARDTYPE,cardname ORDER BY CARDTYPE,cardname) rno
FROM
	axp_cards a
LEFT JOIN
ax_htmlplugins h ON
	a.pluginname = h."name"
LEFT JOIN
axdirectsql s ON
	a.card_datasource = s.sqlname
LEFT JOIN
(
	SELECT DISTINCT 
		a.axp_cardsid,
		trim(regexp_substr(a.accessstringui, '[^,]+', 1, LEVEL)) AS ROLE
	FROM
		axp_cards a
	CONNECT BY
		regexp_substr(a.accessstringui, '[^,]+', 1, LEVEL) IS NOT NULL
) uroles ON
	a.axp_cardsid = uroles.axp_cardsid
WHERE
	a.inhomepage = 'T';
>>

<<
CREATE OR REPLACE VIEW "VW_PEGV2_ACTIVETASKS" ("TOUSER", "PROCESSNAME", "TASKNAME", "TASKID", "TASKTYPE", "EDATETIME", "EVENTDATETIME", "FROMUSER", "FROMROLE", "DISPLAYICON", "DISPLAYTITLE", "DISPLAYMCONTENT", "DISPLAYCONTENT", "DISPLAYBUTTONS", "KEYFIELD", "KEYVALUE", "TRANSID", "PRIORINDEX", "INDEXNO", "SUBINDEXNO", "APPROVEREASONS", "DEFAPPTEXT", "RETURNREASONS", "DEFRETTEXT", "REJECTREASONS", "DEFREGTEXT", "RECORDID", "APPROVALCOMMENTS", "REJECTCOMMENTS", "RETURNCOMMENTS", "RECTYPE", "MSGTYPE", "RETURNABLE", "INITIATOR", "INITIATOR_APPROVAL", "DISPLAYSUBTITLE", "AMENDMENT", "ALLOWSEND", "ALLOWSENDFLG", "CMSG_APPCHECK", "CMSG_RETURN", "CMSG_REJECT", "SHOWBUTTONS", "HLINK", "HLINK_TRANSID", "HLINK_PARAMS") AS 
  SELECT DISTINCT a.touser,
    a.processname,
    a.taskname,
    a.taskid,
    a.tasktype,
    a.eventdatetime AS edatetime,
    to_char(to_timestamp(SUBSTR(a.eventdatetime,1,14), 'YYYYMMDDHH24MISS'), 'dd/mm/yyyy hh24:mi:ss') AS eventdatetime,
    a.fromuser,
    a.fromrole,
    a.displayicon,
    a.displaytitle,
    to_char(a.displaymcontent) displaymcontent,
    to_char(a.displaycontent)displaycontent,
    a.displaybuttons,
    a.keyfield,
    a.keyvalue,
    a.transid,
    a.priorindex,
    a.indexno,
    a.subindexno,
    a.approvereasons,
    a.defapptext,
    a.returnreasons,
    a.defrettext,
    a.rejectreasons,
    a.defregtext,
    aa.recordid,
    a.approvalcomments,
    a.rejectcomments,
    a.returncomments,
    'PEG' AS rectype,
    'NA' AS msgtype,
    a.returnable,
    a.initiator,
    a.initiator_approval,
    a.displaysubtitle,
    p.amendment,
    a.allowsend,
    a.allowsendflg,
    to_char(b.cmsg_appcheck)cmsg_appcheck,
    to_char(b.cmsg_return)cmsg_return,
    to_char(b.cmsg_reject)cmsg_reject,
    b.showbuttons ,NULL hlink,
NULL     hlink_transid,
NULL     hlink_params
   FROM axactivetasks a
     JOIN axprocessdefv2 b ON a.processname = b.processname AND a.taskname = b.taskname
     JOIN axpdef_peg_processmaster p ON a.processname = p.caption
     LEFT JOIN axactivetasks aa ON a.processname = aa.processname AND a.keyvalue = aa.keyvalue AND a.transid = aa.transid AND aa.tasktype = 'Make' AND aa.recordid IS NOT NULL
  WHERE NOT (EXISTS ( SELECT b_1.taskid FROM axactivetaskstatus b_1 WHERE a.taskid = b_1.taskid)) AND a.removeflg = 'F'                            
UNION ALL
 SELECT axactivemessages.touser,
    axactivemessages.processname,
    axactivemessages.taskname,
    axactivemessages.taskid,
    axactivemessages.tasktype,
    axactivemessages.eventdatetime AS edatetime,
    to_char(to_timestamp(SUBSTR(axactivemessages.eventdatetime,1,14), 'YYYYMMDDHH24MISS'), 'dd/mm/yyyy hh24:mi:ss') AS eventdatetime,
    axactivemessages.fromuser,
    NULL AS fromrole,
    axactivemessages.displayicon,
    axactivemessages.displaytitle,
    NULL AS displaymcontent,
    to_char(axactivemessages.displaycontent)displaycontent,
    NULL AS displaybuttons,
    axactivemessages.keyfield,
    axactivemessages.keyvalue,
    axactivemessages.transid,
    0 AS priorindex,
    axactivemessages.indexno,
    0 AS subindexno,
    NULL AS approvereasons,
    NULL AS defapptext,
    NULL AS returnreasons,
    NULL AS defrettext,
    NULL AS rejectreasons,
    NULL AS defregtext,
    0 AS recordid,
    NULL AS approvalcomments,
    NULL AS rejectcomments,
    NULL AS returncomments,
    'MSG' AS rectype,
    axactivemessages.msgtype,
    'F' AS returnable,
    NULL AS initiator,
    NULL AS initiator_approval,
    NULL AS displaysubtitle,
    p.amendment,
    'F' AS allowsend,
    'F' AS allowsendflg,
    NULL AS cmsg_appcheck,
    NULL AS cmsg_return,
    NULL AS cmsg_reject,
    NULL AS showbuttons,hlink,
    hlink_transid,
    hlink_params
   FROM axactivemessages
    left JOIN axpdef_peg_processmaster p ON axactivemessages.processname = p.caption
  WHERE NOT (EXISTS ( SELECT b.taskid
           FROM axactivetaskstatus b
          WHERE axactivemessages.taskid = b.taskid));
>>

<<
CREATE OR REPLACE FUNCTION pr_pegv2_transcurstatus(ptransid VARCHAR2, pkeyvalue VARCHAR2, pprocess VARCHAR2)
RETURN VARCHAR2
AS
  v_qry VARCHAR2(4000);
  v_output NUMBER;
BEGIN
  v_qry := 'SELECT status FROM axpeg_' || ptransid || ' WHERE keyvalue = ''' || pkeyvalue || ''' AND processname = ''' || pprocess || '''';

  EXECUTE IMMEDIATE v_qry INTO v_output;

  RETURN CASE v_output
           WHEN 1 THEN 'Approved'
           WHEN 2 THEN 'Rejected'
           WHEN 3 THEN 'Withdrawn'
           ELSE 'In Progress'
         END;

END;
>>

<<
CREATE OR REPLACE VIEW "VW_PEGV2_ALLTASKS" ("TOUSER", "PROCESSNAME", "TASKNAME", "TASKID", "TASKTYPE", "EDATETIME", "EVENTDATETIME", "FROMUSER", "FROMROLE", "DISPLAYICON", "DISPLAYTITLE", "DISPLAYMCONTENT", "DISPLAYCONTENT", "DISPLAYBUTTONS", "KEYFIELD", "KEYVALUE", "TRANSID", "PRIORINDEX", "INDEXNO", "SUBINDEXNO", "APPROVEREASONS", "DEFAPPTEXT", "RETURNREASONS", "DEFRETTEXT", "REJECTREASONS", "DEFREGTEXT", "RECORDID", "APPROVALCOMMENTS", "REJECTCOMMENTS", "RETURNCOMMENTS", "RECTYPE", "MSGTYPE", "RETURNABLE", "INITIATOR", "INITIATOR_APPROVAL", "DISPLAYSUBTITLE", "AMENDMENT", "ALLOWSEND", "ALLOWSENDFLG", "CMSG_APPCHECK", "CMSG_RETURN", "CMSG_REJECT", "SHOWBUTTONS", "HLINK", "HLINK_TRANSID", "HLINK_PARAMS", "TASKSTATUS", "STATUSREASON", "STATUSTEXT", "CANCELREMARKS", "CANCELLEDBY", "CANCELLEDON", "CANCEL", "USERNAME", "CSTATUS", "RNO") AS 
  SELECT DISTINCT a.touser,
    a.processname,
    a.taskname,
    a.taskid,
    a.tasktype,
    a.eventdatetime AS edatetime,
    to_char(to_timestamp(SUBSTR(a.eventdatetime,1,14), 'YYYYMMDDHH24MISS'), 'dd/mm/yyyy hh24:mi:ss') AS eventdatetime,
    a.fromuser,
    a.fromrole,
    a.displayicon,
    a.displaytitle,
    to_char(a.displaymcontent) displaymcontent,
    to_char(a.displaycontent)displaycontent,
    a.displaybuttons,
    a.keyfield,
    a.keyvalue,
    a.transid,
    a.priorindex,
    a.indexno,
    a.subindexno,
    a.approvereasons,
    a.defapptext,
    a.returnreasons,
    a.defrettext,
    a.rejectreasons,
    a.defregtext,
    aa.recordid,
    a.approvalcomments,
    a.rejectcomments,
    a.returncomments,
    'PEG' AS rectype,
    'NA' AS msgtype,
    a.returnable,
    a.initiator,
    a.initiator_approval,
    a.displaysubtitle,
    p.amendment,
    a.allowsend,
    a.allowsendflg,
    to_char(b.cmsg_appcheck)cmsg_appcheck,
    to_char(b.cmsg_return)cmsg_return,
    to_char(b.cmsg_reject)cmsg_reject,
    b.showbuttons ,NULL hlink,
NULL     hlink_transid,
NULL     hlink_params,
null taskstatus,
    null statusreason,
	null statustext,
    null  cancelremarks,
    null cancelledby,
    null cancelledon,
    null cancel,
    null username,
    'Active' cstatus,
    row_number() over(order by a.eventdatetime desc) rno 
   FROM axactivetasks a
     JOIN axprocessdefv2 b ON a.processname = b.processname AND a.taskname = b.taskname
     JOIN axpdef_peg_processmaster p ON a.processname = p.caption
     LEFT JOIN axactivetasks aa ON a.processname = aa.processname AND a.keyvalue = aa.keyvalue AND a.transid = aa.transid AND aa.tasktype = 'Make' AND aa.recordid IS NOT NULL
  WHERE NOT (EXISTS ( SELECT b_1.taskid FROM axactivetaskstatus b_1 WHERE a.taskid = b_1.taskid)) AND a.removeflg = 'F'                            
  UNION ALL
SELECT axactivemessages.touser,
    axactivemessages.processname,
    axactivemessages.taskname,
    axactivemessages.taskid,
    axactivemessages.tasktype,
    axactivemessages.eventdatetime AS edatetime,
    to_char(to_timestamp(SUBSTR(axactivemessages.eventdatetime,1,14), 'YYYYMMDDHH24MISS'), 'dd/mm/yyyy hh24:mi:ss') AS eventdatetime,
    axactivemessages.fromuser,
    NULL AS fromrole,
    axactivemessages.displayicon,
    axactivemessages.displaytitle,
    NULL AS displaymcontent,
    to_char(axactivemessages.displaycontent)displaycontent,
    NULL AS displaybuttons,
    axactivemessages.keyfield,
    axactivemessages.keyvalue,
    axactivemessages.transid,
    0 AS priorindex,
    axactivemessages.indexno,
    0 AS subindexno,
    NULL AS approvereasons,
    NULL AS defapptext,
    NULL AS returnreasons,
    NULL AS defrettext,
    NULL AS rejectreasons,
    NULL AS defregtext,
    0 AS recordid,
    NULL AS approvalcomments,
    NULL AS rejectcomments,
    NULL AS returncomments,
    'MSG' AS rectype,
    axactivemessages.msgtype,
    'F' AS returnable,
    NULL AS initiator,
    NULL AS initiator_approval,
    NULL AS displaysubtitle,
    p.amendment,
    'F' AS allowsend,
    'F' AS allowsendflg,
    NULL AS cmsg_appcheck,
    NULL AS cmsg_return,
    NULL AS cmsg_reject,
    NULL AS showbuttons,hlink,
    hlink_transid,
    hlink_params,
    null taskstatus,
    null statusreason,
	null statustext,
    null  cancelremarks,
    null cancelledby,
    null cancelledon,
    null cancel,
    null username,
    'Active' cstatus,
    row_number() over(order by axactivemessages.eventdatetime desc) rno
   FROM axactivemessages
    left JOIN axpdef_peg_processmaster p ON axactivemessages.processname = p.caption
  WHERE NOT (EXISTS ( SELECT b.taskid
           FROM axactivetaskstatus b
          WHERE axactivemessages.taskid = b.taskid))
       UNION ALL
SELECT
          a.touser,
	a.processname,
	a.taskname,
	a.taskid,
	a.tasktype,
	a.eventdatetime as edatetime,
	to_char(to_timestamp(SUBSTR(a.eventdatetime,1,14), 'YYYYMMDDHH24MISS'), 'dd/mm/yyyy hh24:mi:ss')  as eventdatetime,
	 a.fromuser,
    a.fromrole,
    a.displayicon,
    a.displaytitle,
    to_char(a.displaymcontent) displaymcontent,
    to_char(a.displaycontent)displaycontent,
    a.displaybuttons,
    a.keyfield,
    a.keyvalue,
    a.transid,
    a.priorindex,
    a.indexno,
    a.subindexno,
    a.approvereasons,
    a.defapptext,
    a.returnreasons,
    a.defrettext,
    a.rejectreasons,
    a.defregtext,
    a.recordid,
    a.approvalcomments,
    a.rejectcomments,
    a.returncomments,
    'PEG' rectype,
    'NA' msttype,
    a.returnable,
    a.initiator,
    a.initiator_approval ,
    a.displaysubtitle,
    null amendment ,
    a.allowsend,
    a.allowsendflg,
    null cmsg_appcheck,
    null cmsg_return,
    null cmsg_reject,
    null showbuttons,
    null hlink,
    null hlink_transid,
    null hlink_params,
    pr_pegv2_transcurstatus(a.transid,a.keyvalue,a.processname) taskstatus,
    --b.taskstatus,
    b.statusreason,
    b.statustext,
    b.cancelremarks,
    b.cancelledby,    
    to_char(b.cancelledon) cancelledon,
    b.cancel,
    --b.username,
       CASE
            WHEN a.indexno = 1 THEN a.fromuser
            ELSE a.touser
        END username,
    'Completed' cstatus,
    row_number() over(order by a.eventdatetime desc) rno
from
	axactivetasks a
join axactivetaskstatus b on
	a.taskid = b.taskid;
>>

<<
CREATE OR REPLACE VIEW VW_PEGV2_PROCESSDEF_TREE
(PROCESSNAME,TASKNAME,TASKTYPE,TASKGROUP,TASKACTIVE,INDEXNO,SUBINDEX,DETAILS,TRANSID,RECORDID,DISPLAYICON,GROUPWITHPRIOR,KEYFIELD)
AS
SELECT axprocessdefv2.processname,
    axprocessdefv2.taskname,
    axprocessdefv2.tasktype,
    axprocessdefv2.taskgroupname AS taskgroup,
    axprocessdefv2.active AS taskactive,
    axprocessdefv2.indexno,
    axprocessdefv2.subindexno AS subindex,
    axprocessdefv2.groupwithprior AS details,
    axprocessdefv2.transid,
    axprocessdefv2.axprocessdefv2id AS recordid,
    axprocessdefv2.displayicon,
    axprocessdefv2.groupwithprior,
    axprocessdefv2.keyfield
   FROM axprocessdefv2;
>>

<<
CREATE OR REPLACE procedure pr_source_trigger ( phltype in varchar2, pstructname in varchar2, psearchtext in varchar2, psrctable in varchar2,psrcfield in varchar2 , pparams in varchar2,pdocid in varchar2,psrcmultipletransid in varchar2,pparamchange varchar2 )
  AUTHID CURRENT_USER
  is
  pscripts varchar2(3000);
  pcnt number(15);
begin
--To insert  or update dynamic param value from the source table

if psrctable is not null and psrcfield is not null then

--To drop existing trigger if any source field or source table has been changed

if pparamchange ='T' THEN 
select count(1) into pcnt from user_objects where object_type='TRIGGER' and trim(upper(object_name))=trim(upper('axp_sch_'|| pdocid) ) ;

if pcnt >0 then 

execute immediate 'drop trigger axp_sch_'|| trim(pdocid);

end if;

delete  axp_appsearch_data_v2 where docid= pdocid ;

commit;

end if;

--To create the source table trigger

pscripts :=  ' create or replace trigger axp_sch_'||pdocid ||' 

before insert or update or delete on '||psrctable ||' 

for each row ' || 

case when psrcmultipletransid is not null then ' when ( new.transid='''||psrcmultipletransid||''' or  old.transid='''||psrcmultipletransid||''')' else null end ||'

begin 

if inserting  then 

insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values('''|| phltype || ''','''||pstructname||''',:'||'new.'||psrcfield||'||  '''||psearchtext||''','''||replace( replace( pparams ,'@','''||:'||'new.') ,'&','&''||''')||','''||pdocid||''');

else if  updating then

insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values('''|| phltype || ''','''||pstructname||''',:'||'new.'||psrcfield||'||  '''||psearchtext||''','''||replace( replace( pparams ,'@','''||:'||'old.') ,'&','&''||''')||','''||pdocid||''');

else  delete  axp_appsearch_data_v2 where hltype='''||phltype||''' and params='''||replace( replace( pparams ,'@','''||:'||'old.') ,'&','&''||''')||';

 end if;

 end if;

exception

      when DUP_VAL_ON_INDEX then

      update axp_appsearch_data_v2 set searchtext=:'||'new.'||psrcfield||'||  '''||psearchtext||''',params='''||replace( replace( pparams ,'@','''||:'||'new.') ,'&','&''||''')||' where hltype='''||phltype||''' and params='''||replace( replace( pparams ,'@','''||:'||'old.') ,'&','&''||''')||' and docid='''||pdocid||''';

   when others then 

 null ;



 end ;  ' ;



execute immediate pscripts  ;



--Rebuild the exsting recordid from source table to appsearch data table

execute immediate 'update  '||psrctable ||' set cancel=cancel' ;



 commit;



 end if;



 EXCEPTION WHEN OTHERS THEN 

 --to check invalid trigger

 pcnt := 0;

  select count(1) into pcnt from user_objects where object_type='TRIGGER' and trim(upper(object_name))=trim(upper('AXP_SCH_'|| pdocid )) and status='INVALID';



 if pcnt >0 then 

 execute immediate 'ALTER TRIGGER '||TRIM(UPPER('AXP_SCH_'|| pdocid ))|| ' DISABLE';

 end if;



 end ;
>>

<<
CREATE OR REPLACE procedure fn_axprocessdefv2_index_update(pprocessname IN varchar2, pindexno IN number, dbevent IN varchar2, recordid IN number, poldindexno IN number)
IS 
v_axprocessdefv2id number(10);
BEGIN
if dbevent = 'Insert' then 
update axprocessdefv2 set indexno = indexno+1 where processname=pprocessname and indexno>pindexno and axprocessdefv2id != recordid;
update axprocessdefv2 set indexno = indexno-1 where processname=pprocessname and indexno<pindexno and axprocessdefv2id != recordid;

ELSIF dbevent = 'Update' then
update axprocessdefv2 set indexno = indexno+1 where processname=pprocessname and indexno>=pindexno and indexno < poldindexno and  axprocessdefv2id != recordid;	
ELSIF dbevent = 'Delete' then
update axprocessdefv2 set indexno = indexno-1 where processname=pprocessname and indexno>pindexno and  axprocessdefv2id != recordid;
end if;

exception when others then  null ;

END;
>>

<<
CREATE OR REPLACE PROCEDURE fn_pegv2_updapp_reporting(p_fromuser IN varchar2, p_existingapp IN varchar2, p_newapp IN varchar2)
IS 
begin 

insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
	keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
	displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
	useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
	assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
	allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,changedusr) 	
	select eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,
	execonapprove,keyvalue,transdata,fromrole,fromuser,p_newapp,priorindex,priortaskname,corpdimension,
	orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,displaycontent,
	displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,	useridentificationfilter,
	useridentificationfilter_of,mapfield_group,mapfield,'T',indexno,subindexno,
	processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,
	approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,
	allowsend,allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,'T'
	from axactivetasks a 	
	 where assigntoflg='1' and delegation='F' and pownerflg ='F' and grouped='T'
	 and fromuser= p_fromuser and touser= p_existingapp and removeflg ='F'
	and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid); 
	
	
update axactivetasks a set removeflg ='T' where assigntoflg='1' and delegation='F' and pownerflg ='F' 
and fromuser= p_fromuser and touser= p_existingapp and not exists 
(SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid);


end;
>>

<<
CREATE OR REPLACE PROCEDURE fn_axpanalytics_ins_axreltn 
AS
BEGIN 

delete from axentityrelations where  rtype !='custom';

insert into axentityrelations ( 
axentityrelationsid,cancel,username,modifiedon,createdby,createdon,app_level,app_desc,
rtype,mstruct,mfield,mtable,primarytable,dstruct,dfield,dtable,rtypeui,mstructui,mfieldui,dstructui,dfieldui,dprimarytable)
  select ax_entity_relseq.NEXTVAL  AS axentityrelationsid,x.*
 from (
 SELECT DISTINCT  
    'F' AS cancel,
    'admin' AS username,
    SYSDATE AS modifiedon,
    'admin' AS createdby,
    SYSDATE AS createdon, 
    1 AS app_level,
    1 AS app_desc,
    a.rtype,
    a.mstruct,
    a.mfield,
    m.tablename AS mtable,
    dc.tablename AS primarytable,
    a.dstruct,
    a.dfield,
    d.tablename AS dtable,
    'Dropdown' AS rtypeui,
    (mt.caption|| '-('|| mt.name|| ')') AS mstructui,
    (m.caption|| '-('|| m.fname|| ')') AS mfieldui,
    (dt.caption|| '-('|| dt.name|| ')') AS dstructui,
    (d.caption|| '-('|| d.fname|| ')') AS dfieldui,
    ddc.tablename AS dprimarytable
   FROM ( SELECT DISTINCT axrelations.mstruct,
            axrelations.dstruct,
            axrelations.mfield,
            axrelations.dfield,
            axrelations.rtype
           FROM axrelations) a
     JOIN tstructs mt ON a.mstruct = mt.name
     JOIN tstructs dt ON a.dstruct = dt.name
     LEFT JOIN axpflds m ON a.mstruct = m.tstruct AND a.mfield = m.fname
     LEFT JOIN axpflds d ON a.dstruct = d.tstruct AND a.dfield = d.fname
     LEFT JOIN axpdc dc ON a.mstruct = dc.tstruct AND dc.dname = 'dc1'
     LEFT JOIN axpdc ddc ON a.dstruct = ddc.tstruct AND ddc.dname = 'dc1'
  WHERE a.rtype = 'md'
UNION ALL
 SELECT DISTINCT
    'F' AS cancel,
    'admin' AS username,
    sysdate AS modifiedon,
    'admin' AS createdby,
    sysdate AS createdon,
    1 AS app_level,
    1 AS app_desc,
    'gm' AS rtype,
    a.tstruct AS mstruct,
    concat(sd.tablename, 'id') AS mfield,
    sd.tablename AS mtable,
    pd.tablename AS primarytable,
    a.targettstr AS dstruct,
    'sourceid' AS dfield,
    td.tablename AS dtable,
    'Genmap' AS rtypeui,
    (mt.caption|| '-('||mt.name|| ')') AS mstructui,
    NULL AS mfieldui,
    (dt.caption|| '-('|| dt.name|| ')') AS dstructui,
    NULL AS dfieldui,
    td.tablename AS dprimarytable
   FROM axpgenmaps a
     JOIN tstructs mt ON a.tstruct = mt.name
     JOIN tstructs dt ON a.targettstr = dt.name
     LEFT JOIN axpdc sd ON a.tstruct = sd.tstruct AND sd.dname = a.basedondc
     LEFT JOIN axpdc td ON a.targettstr = td.tstruct AND td.dname = 'dc1'
     LEFT JOIN axpdc pd ON a.tstruct = pd.tstruct AND pd.dname = 'dc1'
    )x ;

   commit; 

END;
>>

<<
CALL FN_AXPANALYTICS_INS_AXRELTN();
>>

<<
CREATE OR REPLACE PROCEDURE fn_axusers_usergrp(pusername IN varchar2, pusergroup IN varchar2)
IS 
begin 

 
	
	delete from axpdef_peg_usergroups where username = pusername and fromuser='T' AND pusergroup IS NOT null;
	 
		INSERT INTO axpdef_peg_usergroups(username,usergroupname,usergroupcode,active,effectivefrom,fromuser)
	SELECT pusername,ugrp,ugrp,'T',CURRENT_DATE,'T' from(
	  SELECT  REGEXP_SUBSTR(pusergroup, '[^,]+', 1, LEVEL) AS ugrp     FROM   DUAL
	  CONNECT BY  LEVEL <= REGEXP_COUNT(pusergroup, ',') + 1 );
	  
EXCEPTION WHEN OTHERS THEN NULL;

end;
>>

<<
CREATE OR REPLACE FUNCTION fn_ruledef_formula(formula IN varchar2, applicability IN varchar2, nexttask IN varchar2, nexttask_true IN varchar2, nexttask_false IN varchar2, pegversion IN varchar2 DEFAULT 'v1')
 RETURN varchar2
is    
v_formula varchar2(4000);

begin

if pegversion = 'v1' then
-----Used in Rule definition conditions
WITH a AS (SELECT TRIM(REGEXP_SUBSTR(formula, '[^~]+', 1, LEVEL)) AS cols
		from dual 
		CONNECT BY REGEXP_SUBSTR (formula,'[^~]+',1,LEVEL) IS NOT NULL )
,b as(select CASE WHEN TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2)) NOT in('In','Not in') THEN substr(rtrim(substr(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),'-(')+2),')'),2) ELSE ' ' END||
case when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Equal to' then '='
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Not equal to' then '#'
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Greater than' then '>'
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Lesser than' then '<' 
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2)) in('In','Not in') then 'StringPOS('||substr(rtrim(substr(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),'-(')+2),')'),2)||','
	end||' '||
	case when substr(rtrim(substr(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),'-(')+2),')'),1,1) in('c','t')
	then case when substr(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 3)),1,1)!=':' then '{'||TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 3))||'}'
	else replace(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 3)),':',' ') end ELSE TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 3))end ||
	case when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='In' then ') # -1' when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Not in' then ') = -1' else '' end||' '||
	case when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='And' then '&'
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='Or' then '|' 
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='And(' then '&('
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='Or(' then '|('
	else TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4)) END cstr
FROM a)
SELECT 
case when applicability ='T' then 'iif('||LISTAGG(cstr,' ') WITHIN GROUP(order BY rownum)||',{T},{F})' 
else LISTAGG(cstr,' ') WITHIN GROUP(order BY rownum) end  into v_formula 
from b;


-----Used for PEG condition based on task params
elsif pegversion = 'v2' then

WITH a AS (SELECT TRIM(REGEXP_SUBSTR(formula, '[^~]+', 1, LEVEL)) AS cols
		from dual 
		CONNECT BY REGEXP_SUBSTR (formula,'[^~]+',1,LEVEL) IS NOT NULL )
,b as(select CASE WHEN TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2)) NOT in('In','Not in') THEN rtrim(substr(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),'-(')+2),')') ELSE ' ' END||
case when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Equal to' then '='
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Not equal to' then '#'
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Greater than' then '>'
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Lesser than' then '<' 
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2)) in('In','Not in') then 'StringPOS('||substr(rtrim(substr(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),'-(')+2),')'),2)||','
	end||' '||
	case when substr(rtrim(substr(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),'-(')+2),')'),1,1) in('c','t')
	then '{'||TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 3))||'}' 	else TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 3))end ||
	case when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='In' then ') # -1' when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Not in' then ') = -1' else '' end||' '||
	case when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='And' then '&'
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='Or' then '|' 
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='And(' then '&('
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='Or(' then '|('
	else TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4)) END cstr
FROM a)
SELECT 'iif('||LISTAGG(cstr,' ') WITHIN GROUP(order BY rownum)||',{T},{F})'  into v_formula  from b;


end if;
return v_formula;
end;
>>

<<
CREATE OR REPLACE FUNCTION SPLIT_PART(P_VALUE IN VARCHAR2,P_SEPERATOR  IN VARCHAR2,P_POSITION IN INTEGER)
RETURN VARCHAR2
AS
T_VALUE VARCHAR2(32000);
T_RESULT VARCHAR2(32000); 
T_START_POSITION INTEGER;
T_END_POSITION INTEGER;
BEGIN


IF P_POSITION=1 THEN 
T_RESULT := SUBSTR(P_VALUE,1,INSTR(P_VALUE,P_SEPERATOR,1,P_POSITION)-1);
ELSE 
T_VALUE := P_VALUE||P_SEPERATOR;
T_START_POSITION := INSTR(T_VALUE,P_SEPERATOR,1,P_POSITION-1)+length(P_SEPERATOR);
T_END_POSITION := INSTR(T_VALUE,P_SEPERATOR,1,P_POSITION)-T_START_POSITION;
T_RESULT := SUBSTR(P_VALUE,T_START_POSITION,T_END_POSITION);
END IF;


RETURN T_RESULT;


END;
>>

<<
CREATE OR REPLACE FUNCTION string_to_array(input_string IN VARCHAR2,input_separator in VARCHAR2 default ',')
  RETURN SYS.ODCIVARCHAR2LIST
IS
  parsed_array SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
BEGIN

FOR ROWSTR IN (
SELECT 
  REGEXP_SUBSTR(input_string, '[^'||input_separator||']+', 1, LEVEL) AS val
FROM 
  dual
CONNECT BY 
  REGEXP_SUBSTR(input_string, '[^'||input_separator||']+', 1, LEVEL) IS NOT NULL
)  LOOP 

parsed_array.EXTEND;
parsed_array(parsed_array.COUNT) := ROWSTR.val;

END LOOP;


  RETURN parsed_array;
END;
>>

<<
CREATE OR REPLACE FUNCTION array_to_string(input_array IN sys.ODCIVARCHAR2LIST,input_separator in VARCHAR2 default ',')
  RETURN clob
IS

v_result clob;

BEGIN

   select  replace(LISTAGG(COALESCE(NULLIF(column_value, ''), '@@@nullvalreplce@@@'), input_separator) WITHIN GROUP (ORDER BY rownum),'@@@nullvalreplce@@@','')  into v_result  
   from table(input_array) colval  ;

  RETURN v_result;
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_generate_cardjson(pchartprops IN varchar2)
 RETURN varchar2
IS
cardprops1 varchar2(4000);
BEGIN

 
select '{"attributes":{'||'"cck":"'||lower(TRIM(REGEXP_SUBSTR(pchartprops, '[^|]+', 1, 1)))||'",'
||'"shwLgnd":'||lower(TRIM(REGEXP_SUBSTR(pchartprops, '[^|]+', 1, 2)))||','
||'"xAxisL":"'||TRIM(REGEXP_SUBSTR(pchartprops, '[^|]+', 1, 3))||'",'
||'"yAxisL":"'||TRIM(REGEXP_SUBSTR(pchartprops, '[^|]+', 1, 4))||'",'
||'"gradClrChart":'||lower(TRIM(REGEXP_SUBSTR(pchartprops, '[^|]+', 1, 5)))||','
||'"shwChartVal":'||lower(TRIM(REGEXP_SUBSTR(pchartprops, '[^|]+', 1, 6)))||','
||'"threeD":"'||case when TRIM(REGEXP_SUBSTR(pchartprops, '[^|]+', 1, 7))='True' then 'create' else 'remove' END||'",'
||'"enableSlick":'||lower(TRIM(REGEXP_SUBSTR(pchartprops, '[^|]+', 1, 8)))||','
||'"numbSym":'||lower(TRIM(REGEXP_SUBSTR(pchartprops, '[^|]+', 1, 9)))||'}}'  into cardprops1 
from dual;

 
RETURN cardprops1;

END;
>>

<<
CREATE OR REPLACE function fn_peg_assigntoactor(assigntoactor IN varchar2, actorfilter IN varchar2)
RETURN VARCHAR2
IS 
v_totalcnd NUMERIC:=0;
cndresult numeric;
grpresult NUMERIC:=0; 
truecnt NUMERIC:=0; 
qry varchar2(4000);
v_datagrpusers varchar2(4000);
BEGIN
		<<Actor_Groups>>
  FOR ag  IN (select a.actorname,b.axpdef_peg_grpfilterrow,b.tbl_datagrp,b.datagrpusers,axpdef_peg_grpfilterid,a.priorindextransid stransid
	from axpdef_peg_actor a,axpdef_peg_grpfilter b
	where a.axpdef_peg_actorid =b.axpdef_peg_actorid 	
	and a.actorname = assigntoactor) 
	LOOP		
		SELECT count(distinct TRIM(REGEXP_SUBSTR(TBL_DATAGRP, '[^~]+', 1, LEVEL))) into v_totalcnd
		from axpdef_peg_grpfilter 
		where axpdef_peg_grpfilterid =ag.axpdef_peg_grpfilterid
		CONNECT BY REGEXP_SUBSTR (TBL_DATAGRP,'[^~]+',1,LEVEL) IS NOT NULL;		
		<<Groups_Condition>>	
		FOR agc in(
		SELECT  substr(TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 1)),'-(')+2,
		INSTR(TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 1)),'-(',-1,1)) fldname,
		substr(substr(TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 1)),'-(')+2,
		INSTR(TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 1)),'-(',-1,1)),1,1)flddatatype,
		case when TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 2)) = 'Equal to' then '='
		when TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 2)) = 'Not equal to' then '!='
		when TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 2)) = 'In' then 'in'
		when TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 2)) = 'Not in' then 'not in'
		when TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 2)) = 'Greater than' then '>'
		when TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 2)) = 'Greater than or Equal to' then '>='
		when TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 2)) = 'Lesser than' then '<'
		when TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 2)) = 'Lesser than or Equal to' then '<=' end cndoprsym,			
		TRIM(REGEXP_SUBSTR(split_value, '[^|]+', 1, 3)) fldvalue,axpdef_peg_grpfilterid,datagrpusers,dgname FROM 
		(SELECT distinct TRIM(REGEXP_SUBSTR(TBL_DATAGRP, '[^~]+', 1, LEVEL)) AS split_value,axpdef_peg_grpfilterid,datagrpusers,dgname
		from axpdef_peg_grpfilter 
		where axpdef_peg_grpfilterid = ag.axpdef_peg_grpfilterid
		CONNECT BY REGEXP_SUBSTR (TBL_DATAGRP,'[^~]+',1,LEVEL) IS NOT NULL))
			LOOP	
				if agc.cndoprsym  = 'in' or agc.cndoprsym  = 'not in' then	
				FOR rec  IN (SELECT TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(actorfilter, '[^~]+', 1, LEVEL)), '[^=]+', 1, 1)) AS cndfld,
				TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(actorfilter, '[^~]+', 1, LEVEL)), '[^=]+', 1, 2)) cndfldval
				from dual CONNECT BY REGEXP_SUBSTR (actorfilter,'[^~]+',1,LEVEL) IS NOT NULL)
					LOOP
						<<user_data>>
						qry :='select count(*) from dual where '''||agc.fldname||'''='''||rec.cndfld ||''' and '''|| rec.cndfldval||''''||agc.cndoprsym||'('''||replace(agc.fldvalue,',',''',''')||''')';			   					   						   													
						execute immediate qry into cndresult;					   					  			
						if cndresult > 0 then  
							grpresult := grpresult +1; 					  						  				 					   
					  		truecnt := truecnt + 1; 
					  	end if;					  		
	 				  	exit when cndresult > 0;					  	 			      						  	
    				end loop;
				if v_totalcnd = truecnt then  
				v_datagrpusers :=v_datagrpusers||(agc.dgname||'~~'||agc.datagrpusers)||'|~';    			
		    	end if;
		    ELSE
		    	FOR rec  IN (SELECT TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(actorfilter, '[^~]+', 1, LEVEL)), '[^=]+', 1, 1)) AS cndfld,
				TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(actorfilter, '[^~]+', 1, LEVEL)), '[^=]+', 1, 2)) cndfldval
				from dual CONNECT BY REGEXP_SUBSTR (actorfilter,'[^~]+',1,LEVEL) IS NOT NULL)
					LOOP						
						<<user_data>>
						IF agc.flddatatype='n' AND substr(rec.cndfld,1,1)='n' then
						qry :='select count(*) from dual where '''||agc.fldname||'''='''||rec.cndfld||'''' ||case when agc.flddatatype='n' then ' and '||rec.cndfldval||' '||agc.cndoprsym||' '||agc.fldvalue else  ' and '''||rec.cndfldval||''''||agc.cndoprsym||''''||agc.fldvalue||''''end;			   					   						   							
						ELSIF agc.flddatatype='n' AND substr(rec.cndfld,1,1)!='n' THEN 
						qry :='select 0 from dual'; 
						ELSE qry :='select count(*) from dual where '''||agc.fldname||'''='''||rec.cndfld||'''' ||case when agc.flddatatype='n' then ' and '||rec.cndfldval||' '||agc.cndoprsym||' '||agc.fldvalue else  ' and '''||rec.cndfldval||''''||agc.cndoprsym||''''||agc.fldvalue||''''end;
						END IF;						
						execute immediate qry into cndresult;					   					  			
						if cndresult > 0 then  
							grpresult := grpresult +1; 					  						  				 					   
					  		truecnt := truecnt + 1; 
					  	end if;					  	
	 				  	exit when cndresult > 0;		 				  	
    				end loop;
				if v_totalcnd = truecnt then  
				v_datagrpusers :=v_datagrpusers||(agc.dgname||'~~'||agc.datagrpusers)||'|';    			
		    	end if;
    			END if;    		
			END LOOP;
			grpresult := 0;truecnt := 0;			
	  END LOOP;
	 IF length(v_datagrpusers)> 2 then
	 	RETURN v_datagrpusers;
		ELSE RETURN '0';
	 END IF;
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_pegv2_editabletask(p_processname IN varchar2, p_taskname IN varchar2, p_keyvalue IN varchar2, p_currentuser IN varchar2, p_indexno IN number)
RETURN varchar2
IS
v_flag varchar2(1);
v_finalapproved varchar2(1);
v_finalappqry varchar2(4000);
v_currentuser varchar2(50); 
v_editable varchar2(1);
v_nextleveluser NUMBER(10);
v_activeuser NUMBER(10);
begin
     
select 'select case when status=0 then ''F'' else ''T'' end from axpeg_'||transid||' where keyvalue='''||p_keyvalue||'''' into v_finalappqry 
from axprocessdefv2 where processname=p_processname
and indexno =(select max(indexno) from axprocessdefv2 a where processname=p_processname and stransid!='pgv2c'); 

execute IMMEDIATE v_finalappqry into v_finalapproved;

--- Current task createdby user and the next task touser is same
select sum(case when taskname =p_taskname and touser=p_currentuser then 1 else 0 end) activeuser,
sum(case when indexno =p_indexno+1 and touser = p_currentuser then 1 else 0 end) nexttaskuser
into v_activeuser,v_nextleveluser from vw_pegv2_activetasks vpa 
where processname =p_processname and keyvalue =p_keyvalue;



-----Task is created by current user
select case when username = p_currentuser then 'T' else 'F' end into  v_currentuser
from axactivetaskstatus where processname=p_processname and taskname=p_taskname and keyvalue=p_keyvalue;

------Editable task validation in process definition
with a as (
SELECT distinct TRIM(REGEXP_SUBSTR(allowedittasksid, '[^,]+', 1, LEVEL))   defid,axprocessdefv2id
		from axprocessdefv2 a1 where processname=p_processname and allowedit='T'		
		CONNECT BY REGEXP_SUBSTR (allowedittasksid,'[^,]+',1,LEVEL) IS NOT NULL) 
select case when count(*) = 0 then 'F' else 'T' end flg  into v_flag from axprocessdefv2 b join a on a.axprocessdefv2id = b.axprocessdefv2id
join axprocessdefv2 c on a.defid = c.axprocessdefv2id and c.taskname=p_taskname
join axactivetasks t on b.processname = p_processname and keyvalue = p_keyvalue and b.taskname = t.taskname and t.touser = p_currentuser;


select case when v_finalapproved='T' then 'F' else 
case when v_activeuser > 0 then 'T'
when v_currentuser='T' and v_nextleveluser > 0 then 'T'  
when v_currentuser='F' and v_activeuser = 0  then v_flag else v_flag end end  into v_editable FROM dual;

return v_editable;
end;
>>

<<
CREATE OR REPLACE FUNCTION fn_ruledef_tablefield(pcnd IN number)
 RETURN varchar2
IS 
v_json varchar2(4000);

BEGIN  

/*
1	If,Else if
2	Enable,Show,Hide,Disable,Mandatory,Non mandatory
3	Mask all characters,Mask few characters
4	Set value to field
5	Show message,Show error
6	Else
*/
	
if pcnd = 1 then --If , Else if 	 

select '{"props":{"type":"table","colcount":"4","rowcount":"1","addrow":"t","deleterow":"t","valueseparator":"|","rowseparator":"~"},
"columns":{	"1":{"caption":"Condition field","name":"cfld","value":"","source":"cndfldcaption","exp":"","vexp":""},
			"2":{"caption":"Operator","name":"opr","value":"","source":"formula_opr","exp":"","vexp":""},
			"3":{"caption":"Value","name":"fldvalue","value":"","source":"","exp":"","vexp":""},
			"4":{"caption":"Condition","name":"ccnd","value":"","source":"formula_andor","exp":"","vexp":""}
			}}'  into v_json FROM dual;
		
		
 
elsif pcnd = 2 then  --Enable,Disable,Show,Hide,Mandatory,Non mandatory

select '{"props":{"type":"table","colcount":"1","rowcount":"1","addrow":"t","deleterow":"t","valueseparator":"|","rowseparator":"~"},
"columns":{"1":{"caption":"Apply rule on","name":"cndfld","value":"","source":"fctlfldcaption","exp":"","vexp":""}}
}' into v_json FROM dual;

elsif pcnd = 4 then --Set value to field

select '{"props":{"type":"table","colcount":"2","rowcount":"1","addrow":"t","deleterow":"t","valueseparator":"|","rowseparator":"~"},
"columns":{"1":{"caption":"Set value to field","name":"cndfld","value":"","source":"setvalueflds","exp":"","vexp":""},
			"2":{"caption":"Value","name":"sval","value":"","source":"","exp":"","vexp":""}}
}'  into v_json  FROM dual;

elsif pcnd=5 then -- Show message,Show error

select '{"props":{"type":"table","colcount":"1","rowcount":"1","addrow":"f","deleterow":"f","valueseparator":"|","rowseparator":"~"},
"columns":{"1":{"caption":"Message",	"name":"cndfld","value":"","source":"","exp":"","vexp":""}}
}'  into v_json  FROM dual;

end if;

  RETURN v_json;
 
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_ruledef_table_genaxscript(pcmd IN varchar2, ptbldtls IN varchar2, pcnd IN number)
RETURN varchar2
IS
v_formula varchar(2000);

   BEGIN

if pcnd=1 then 	   

WITH a AS (SELECT TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)) AS cols
		from dual 
		CONNECT BY REGEXP_SUBSTR (ptbldtls,'[^~]+',1,LEVEL) IS NOT NULL )
,b as(select CASE WHEN TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2)) NOT in('In','Not in') THEN substr(rtrim(substr(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),'-(')+2),')'),2) ELSE ' ' END||
case when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Equal to' then '='
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Not equal to' then '#'
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Greater than' then '>'
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Lesser than' then '<' 
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2)) in('In','Not in') then 'StringPOS('||substr(rtrim(substr(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),'-(')+2),')'),2)||','
	end||' '||
	case when substr(rtrim(substr(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 1)),'-(')+2),')'),1,1) in('c','t')
	then '{'||TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 3))||'}' 	else TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 3))end ||
	case when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='In' then ') # -1' when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 2))='Not in' then ') = -1' else '' end||' '||
	case when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='And' then '&'
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='Or' then '|' 
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='And(' then '&('
	when TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4))='Or(' then '|('
	else TRIM(REGEXP_SUBSTR(cols, '[^|]+', 1, 4)) END cstr
FROM a)
		SELECT pcmd||' '||LISTAGG(cstr,' ') WITHIN GROUP(order BY rownum)  into v_formula  FROM b;

elsif pcnd =2 then 
select case when pcmd ='Show' then 'Axunhidecontrols({'||fnames||'})'
	when pcmd ='Hide' then 'Axhidecontrols({'||fnames||'})'
	when pcmd ='Enable' then 'Axenablecontrols({'||fnames||'})'
	when pcmd ='Disable' then 'Axdisablecontrols({'||fnames||'})'
	when pcmd ='Mandatory' then 'AxAllowEmpty({'||fnames||'},{F})'
	when pcmd ='Non mandatory' then 'AxAllowEmpty({'||fnames||'},{T})' end  into v_formula 
	from 	 
	(SELECT listagg(rtrim(substr(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),'-(')+2),')'),',') WITHIN GROUP (ORDER BY 1) AS fnames
		from dual 
		CONNECT BY REGEXP_SUBSTR (ptbldtls,'[^~]+',1,LEVEL) IS NOT NULL)b;
	
elsif pcnd in(3,31) then  

	select case 
	when pcmd='Mask few characters' then 
	'AxMask({'||rtrim(substr(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),'-(')+2),')')||'}'
	||',{'||TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 2, 2))||'},{'||
	TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 3, 3))||'~'||
	TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 4, 4))||'})' 
	when pcmd ='Mask all characters' then 
	'AxMask({'||rtrim(substr(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),'-(')+2),')')||'}'||
	',{'||TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 2, 2))||'},{all})'
	end  into v_formula 
	FROM dual
	CONNECT BY REGEXP_SUBSTR (ptbldtls,'[^~]+',1,LEVEL) IS NOT NULL;

elsif pcnd=4 then

	SELECT listagg('SetValue({'||rtrim(substr(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),'-(')+2),')')||'},1,{'||
	TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 2))||'})',chr(10)) WITHIN GROUP(ORDER BY rownum) INTO v_formula
		from dual 
		CONNECT BY REGEXP_SUBSTR (ptbldtls,'[^~]+',1,LEVEL) IS NOT NULL;
	
elsif pcnd=5 then  
	select case when pcmd='Show message' then 'ShowMessage({'||ptbldtls||'},{Simple},{})'
	when pcmd='Show error' then 'ShowMessage({'||ptbldtls||'},{Exception},{})' end  into v_formula
	from dual;

elsif pcnd=6 then 
	v_formula := pcmd;

------------used in PEG for Set value
elsif pcnd=7 then 
	SELECT listagg('SetValue({'||rtrim(substr(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),INSTR(TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 1)),'-(')+2),')')||'},1,{'||
	TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(ptbldtls, '[^~]+', 1, LEVEL)), '[^|]+', 1, 2))||'})',chr(10)) WITHIN GROUP(ORDER BY rownum) INTO v_formula
		from dual 
		CONNECT BY REGEXP_SUBSTR (ptbldtls,'[^~]+',1,LEVEL) IS NOT NULL;

end if;
	 
RETURN v_formula;
END;
>>

<<
CREATE OR REPLACE FUNCTION pr_pegv2_processlist(pprocessname IN varchar2,pkeyvalue varchar2)
RETURN varchar2
IS
v_createtblscr varchar(4000);
v_processtable varchar(100);
 
begin
	
select processtable into v_processtable from axpdef_peg_processmaster where lower(caption) = lower(pprocessname);
	
v_createtblscr :='select taskname,tasktype,to_char(to_timestamp(SUBSTR(eventdatetime,1,14), ''YYYYMMDDHH24MISS''), ''dd/mm/yyyy hh24:mi:ss'') eventdatetime,username,taskstatus,displayicon,displaytitle,taskid,keyfield,keyvalue,recordid,transid from '|| v_processtable||' where lower(keyvalue)='''||lower(pkeyvalue)||''';';
	
RETURN v_createtblscr;
END;
>>

<<
CREATE OR REPLACE FUNCTION pr_pegv2_processprogress(pprocessname IN varchar2, pkeyvalue IN varchar2)
RETURN varchar2
IS
v_createtblscr varchar(4000);
v_processtable varchar(100);
v_keyvalue varchar(2000);

begin
    
    select processtable into v_processtable from axpdef_peg_processmaster where lower(caption) = lower(pprocessname);
   

   v_createtblscr := 'with c as (select distinct a.processname,a.taskname,a.indexno,
    a.eventdatetime,
    coalesce(b.taskstatus, ''active'')taskstatus,a.taskid,
    a.transid,a.keyfield,a.keyvalue,a.recordid from '|| v_processtable ||' a 
    join(select processname,taskname,indexno,transid,keyvalue,taskstatus,
    eventdatetime from axactivetaskstatus
    where lower(processname) ='''||lower(pprocessname)||    ''' and lower(keyvalue) = '''||lower(pkeyvalue)||''' )b 
    on a.taskname = b.taskname and a.indexno = b.indexno 
    and a.eventdatetime =  b.eventdatetime    
     where lower(a.processname) ='''||lower(pprocessname)||
    ''' and lower(a.keyvalue) = '''||lower(pkeyvalue)||''' ) select 
    coalesce(c.processname,d.processname) processname,coalesce(c.taskname,d.taskname) taskname,
    coalesce(c.indexno,d.indexno)indexno,
to_char(to_timestamp(SUBSTR(c.eventdatetime,1,14), ''YYYYMMDDHH24MISS''), ''dd/mm/yyyy hh24:mi:ss'')eventdatetime,
    coalesce(c.taskstatus,''Active'') taskstatus,coalesce(c.taskid,d.taskid) taskid,coalesce(c.transid,d.transid)transid,
    coalesce(c.keyfield,d.keyfield) keyfield,coalesce(c.keyvalue,d.keyvalue)keyvalue,coalesce(c.recordid,d.recordid) recordid,
    cast(row_number() over(partition by coalesce(c.indexno,d.indexno) order by coalesce(c.indexno,d.indexno),coalesce(c.eventdatetime,d.eventdatetime) desc) as numeric)rnum
    from c   right join (select j.indexno,j.transid,j.keyfield,j.keyvalue,j.eventdatetime,
j.processname,j.taskname,j.taskid,j.recordid    from axactivetasks j 
    where lower(processname) = '''||lower(pprocessname)||''' and lower(keyvalue) = '''||lower(pkeyvalue) ||''' and removeflg=''F'') d on
    c.indexno = d.indexno and c.transid = d.transid and c.keyfield = d.keyfield and c.keyvalue = d.keyvalue and c.taskid = d.taskid
    group by   coalesce(c.processname,d.processname) ,coalesce(c.taskname,d.taskname) ,coalesce(c.indexno,d.indexno),coalesce(c.eventdatetime,d.eventdatetime),
    coalesce(c.taskstatus,''Active'') ,coalesce(c.taskid,d.taskid) ,coalesce(c.transid,d.transid),
    coalesce(c.keyfield,d.keyfield) ,coalesce(c.keyvalue,d.keyvalue),coalesce(c.recordid,d.recordid),
	to_char(to_timestamp(SUBSTR(c.eventdatetime,1,14), ''YYYYMMDDHH24MISS''), ''dd/mm/yyyy hh24:mi:ss'')
    order by coalesce(c.indexno,d.indexno)'; 
  
   
RETURN  v_createtblscr;


END;
>>

<<
CREATE OR REPLACE FUNCTION pr_pegv2_sendto_userslist(pallowsendflg in number, pactor IN varchar2, pprocessname IN varchar2, pkeyvalue IN varchar2, ptaskname IN varchar2)
RETURN peg_sendto_tab PIPELINED IS
v_usergroup_in varchar2(4000);
v_usergroup_notin varchar2(4000);
v_usergroup_in_cnt number;
v_usergroup_notin_cnt number;
begin
	 
/*
 * 2 - Any user
 * 3 - Users in this process
 * 4 - Actor 
 */
 
FOR i IN (----------  Any user & Both In & Not in usergroup is empty
select pusername from axusers 
where pallowsendflg = 2 and v_usergroup_in_cnt=0 and v_usergroup_notin_cnt=0
union all
---------- Any user & not in is empty
select a.username from axusers a,axpdef_peg_usergroups b 
where pallowsendflg = 2 and v_usergroup_in_cnt>0 and v_usergroup_notin_cnt=0
and a.username = b.username
and b.usergroupname in(SELECT TRIM(REGEXP_SUBSTR(v_usergroup_in, '[^,]+', 1, LEVEL)) AS split_value
from dual CONNECT BY REGEXP_SUBSTR (v_usergroup_in,'[^,]+',1,LEVEL) IS NOT NULL) 
union all ---------- Any user & in is empty
select a.username from axusers a,axpdef_peg_usergroups b
where pallowsendflg = 2 and v_usergroup_in_cnt=0 and v_usergroup_notin_cnt>0
and a.username= b.username
and b.usergroupname not in(SELECT TRIM(REGEXP_SUBSTR(v_usergroup_in, '[^,]+', 1, LEVEL)) AS split_value
from dual CONNECT BY REGEXP_SUBSTR (v_usergroup_in,'[^,]+',1,LEVEL) IS NOT NULL)
union all ---------- Any user & both in & not in is selected
select a.username from axusers a,axpdef_peg_usergroups b
where pallowsendflg = 2 and v_usergroup_in_cnt=0 and v_usergroup_notin_cnt>0
and a.username= b.username
and b.usergroupname not in(SELECT TRIM(REGEXP_SUBSTR(v_usergroup_notin, '[^,]+', 1, LEVEL)) AS split_value
from dual CONNECT BY REGEXP_SUBSTR (v_usergroup_notin,'[^,]+',1,LEVEL) IS NOT NULL)
and b.usergroupname in(SELECT TRIM(REGEXP_SUBSTR(v_usergroup_in, '[^,]+', 1, LEVEL)) AS split_value
from dual CONNECT BY REGEXP_SUBSTR (v_usergroup_in,'[^,]+',1,LEVEL) IS NOT NULL)
union all
select touser from axactivetasks where grouped='T' 
and 3 = pallowsendflg  and processname = pprocessname and keyvalue = pkeyvalue and removeflg='F'
group by touser
) 
LOOP
    PIPE ROW(type_peg_sendto(i.pusername));   
END LOOP;
   RETURN;
END;


CREATE OR REPLACE FUNCTION GET_SQL_COLUMNS( v_sql IN VARCHAR2)
  RETURN VARCHAR2
IS
  v_string VARCHAR2(4000) := NULL;
  v_cursor_id integer;
  v_col_cnt integer;
  v_columns dbms_sql.desc_tab;
BEGIN
	IF v_sql IS NOT NULL THEN 
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, v_sql, dbms_sql.native);
    dbms_sql.describe_columns(v_cursor_id, v_col_cnt, v_columns);
for i in 1 .. v_columns.count loop
        if v_string IS NULL then
        v_string := v_columns(i).col_name;
        else
        v_string := v_string||','||v_columns(i).col_name;
        end if;
    end loop;
    dbms_sql.close_cursor(v_cursor_id);
   END if;
   RETURN v_string;
exception when others then
    Begin
    dbms_sql.close_cursor(v_cursor_id);
    raise_application_error(-20000, 'Invalid SQL in GET_SQL_COLUMNS');
    end; 
end;
>>

<<
CREATE OR REPLACE FUNCTION fn_periodic_queuejson(axp_appschema varchar2,name varchar2,fromuser varchar2,Startdate DATE,frequency varchar2,sendon varchar2,sendtime varchar2)
RETURN varchar2
IS
queuejson varchar2(4000);
BEGIN

 
select  '{"queuename":"ARMPeriodicNotificationQueue","queuedata":"ARMPeriodicNotificationQueueData","queuejson":{'||
'"project":"'||axp_appschema||'","notification":"'||name||'","username":"'||fromuser||'","start_date":"'||to_date(Startdate)||
'","period":"'||frequency ||'","sendon":"'||sendon||'","sendtime":"'||sendtime||'"}}' INTO queuejson FROM dual  ;

 
RETURN queuejson;

END;
>>

<<
CREATE OR REPLACE FUNCTION fn_stringcomparision(pstring1 IN varchar2, pstring2 IN varchar2) 
   RETURN varchar2 
AS 
   v_results varchar2(2000) := ' '; 
BEGIN
   RETURN pstring1||pstring2;   
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_chartdata(psource in varchar2, pentity_transid in varchar2, pcondition in varchar2, pcriteria in varchar2,pfilter clob DEFAULT 'NA', pusername varchar2 DEFAULT 'admin', papplydac varchar2 DEFAULT 'T', puserrole varchar2 DEFAULT 'All',pconstraints clob DEFAULT NULL )
RETURN  SYS.ODCIVARCHAR2LIST
IS   
v_primarydctable varchar2(3000);
v_subentitytable varchar2(3000);
v_transid varchar2(3000);
v_grpfld varchar2(3000);
v_aggfld varchar2(3000);
v_aggfnc varchar2(3000);
v_srckey varchar2(3000);
v_srctbl varchar2(3000); 
v_srcfld varchar2(3000);
v_aempty varchar2(3000);
v_tablename varchar2(100);
v_sql clob;
v_normalizedjoin varchar2(3000);
v_keyname varchar2(3000);
v_entitycond varchar2(3000);
v_keyfld_fname varchar2(3000);
v_keyfld_fval varchar2(3000);  
v_keyfld_srckey varchar2(10);
v_keyfld_srctbl varchar2(50);
v_keyfld_srcfld varchar2(50);
v_final_sqls SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_transidcnd number;
v_sql1 clob;
v_filter_srcfld varchar2(200);
v_filter_srctxt varchar2(2000);
v_filter_join varchar2(2000);
v_filter_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_cnd varchar2(2000);
v_filter_cndary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_joinreq numeric;
v_filter_dcjoin varchar2(3000);
v_filter_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_dcjoinuniq varchar2(3000);
v_filter_col varchar2(2000);
v_filter_normalized varchar2(20); 
v_filter_sourcetbl varchar2(200);
v_filter_sourcefld varchar2(200);
v_filter_datatype varchar2(20);
v_filter_listedfld varchar2(20);
v_filter_tablename varchar2(200);
v_emptyary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dacenabled numeric;
v_dactype numeric;
v_dac_join varchar2(4000);
v_dac_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dac_cnd varchar2(4000);
v_dac_cndary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dac_joinreq numeric;
v_dac_normalizedjoinreq numeric; 
v_jointables SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();

begin

	/*
	 * psource - Entity / Subentity	
	 *  pcriteria - transid~groupfld~aggfld~aggfnc~normalized~srctable~srcfld~allowempty~tablename~keyfld~keyval^
	 * transid~groupfld~aggfld~aggfnc~normalized~srctable~srcfld~allowempty~tablename~keyfld~keyval	 	 
	*/
	
	
	select tablename into v_primarydctable from axpdc where tstruct = pentity_transid and dname ='dc1';
	
	v_jointables.extend();
	v_jointables(v_jointables.COUNT) := v_primarydctable;
	
	if pcondition ='Custom' THEN
		select count(1) into v_fldname_transidcnd from axpflds where tstruct = pentity_transid and dcname ='dc1' and lower(fname)='transid';
	    FOR rec IN
    	    (select column_value as criteria from table(string_to_array(pcriteria,'^')) )
		    loop		    			    
			    v_transid := split_part(rec.criteria,'~',1);
		    	v_grpfld := split_part(rec.criteria,'~',2);
				v_aggfld := case when split_part(rec.criteria,'~',3)='count' then '1' else split_part(rec.criteria,'~',3) end;
				v_aggfnc := split_part(rec.criteria,'~',4);
				v_srckey := split_part(rec.criteria,'~',5);
				v_srctbl := split_part(rec.criteria,'~',6);
				v_srcfld := split_part(rec.criteria,'~',7);
				v_aempty := split_part(rec.criteria,'~',8);
				v_tablename := split_part(rec.criteria,'~',9);
				v_keyfld_fname := split_part(rec.criteria,'~',10);
				v_keyfld_fval := split_part(rec.criteria,'~',11);
				v_normalizedjoin := case when v_srckey='T' then (' left join '||v_srctbl||' b on '||v_primarydctable||'.'||v_grpfld||' = b.'||v_srctbl||'id ') else ' ' end;
				v_keyname := case when length(v_grpfld) > 0 then case when v_srckey='T' then ('b.'||v_srcfld) else (v_primarydctable||'.'||v_grpfld) end else 'null' end;			
			
				v_jointables.extend();
				v_jointables(v_jointables.COUNT) := case when v_srckey='T' then v_srctbl end;	
	
				

	
                	if lower(v_tablename)=lower(v_primarydctable) then
		                v_sql := ('select '||' '||v_keyname||' keyname,'||case when lower(trim(v_aggfnc)) in ('sum','avg') then 'round('||v_aggfnc||'('||v_aggfld||'),2)'else v_aggfnc||'('||v_aggfld||')' END||' keyvalue,'||'''Custom'''||' '||'cnd,'''||replace(rec.criteria,'''','')||''' criteria from '||
						v_primarydctable||' '||v_normalizedjoin);	
						v_jointables.extend();
						v_jointables(v_jointables.COUNT) := v_tablename;
                	ELSE
                	 	v_sql := ('select '||' '||v_keyname||' keyname,'||case when lower(trim(v_aggfnc)) in ('sum','avg') then 'round('||v_aggfnc||'('||v_aggfld||'),2)'else v_aggfnc||'('||v_aggfld||')' end||' keyvalue,'||'''Custom'''||' '||'cnd,'''||replace(rec.criteria,'''','')||''' criteria from '||
						v_primarydctable||' join '||v_tablename||' on '||v_primarydctable||'.'||v_primarydctable||'.id='||v_tablename||'.'||v_primarydctable||'id '||v_normalizedjoin);
						v_jointables.extend();
						v_jointables(v_jointables.COUNT) := v_tablename;
                	END IF;
               
                
                if pfilter ='NA' then 

        v_sql1 := v_sql||'where '||v_primarydctable||'.cancel=''F'''||
        		CASE WHEN v_fldname_transidcnd > 0 THEN ' and '||v_primarydctable||'.transid='''||pentity_transid||'''' end||
        		case when v_dacenabled > 0 then ' and '||array_to_string(v_dac_cndary,' and ') ELSE ' ' end||
        		'
				  --axp_filter
				'||case when length(v_grpfld) > 0 then (' group by '||v_keyname) else '' END;
		else
			FOR rec_filters IN
    			(select column_value as ifilter from table(string_to_array(pfilter,'^')) )
			    loop		    	
			    	v_filter_srcfld := split_part(rec_filters.ifilter,'|',1); -- tstfm~empcode~F~~
			    	v_filter_srctxt := split_part(rec_filters.ifilter,'|',2);--   = 'EMP-001'
			    	v_filter_col := split_part(v_filter_srcfld,'~',1);
				    v_filter_normalized := split_part(v_filter_srcfld,'~',2);
 				    v_filter_sourcetbl := split_part(v_filter_srcfld,'~',3);
 				    v_filter_sourcefld := split_part(v_filter_srcfld,'~',4);
					v_filter_datatype := split_part(v_filter_srcfld,'~',5);
					v_filter_listedfld :=split_part(v_filter_srcfld,'~',6);
					v_filter_tablename:=split_part(v_filter_srcfld,'~',7);
					
			    if  v_filter_listedfld='F' then 
								    	
			    	v_filter_joinreq := case when lower(v_tablename)=lower(v_filter_tablename) then 1 else 0 end;
			    	
			    	if v_filter_joinreq = 0  then  
				    	v_filter_dcjoin := ' join '||v_filter_tablename||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_filter_tablename||'.'||v_primarydctable||'id';
				    	v_filter_dcjoinsary.EXTEND;
	                   	v_filter_dcjoinsary(v_filter_dcjoinsary.COUNT) := v_filter_dcjoin;
			    	end if;
			    				    		  	
                   	if v_filter_normalized='T' then  	
 		           		v_filter_join := (' join '||v_filter_sourcetbl||' '||v_filter_col||' on '||v_filter_tablename||'.'||v_filter_col||' = '||v_filter_col||'.'||v_filter_sourcetbl||'id');
        	    	   	v_filter_joinsary.EXTEND;
            	       	v_filter_joinsary(v_filter_joinsary.COUNT) := v_filter_join;
                  	end if;
                    
				END IF;
				if v_filter_normalized='F' then                    
                	v_filter_cnd := case when v_filter_datatype='c' then 'lower(' END ||(v_filter_tablename||'.'||v_filter_col||case when v_filter_datatype='c' then ')' end||' '||v_filter_srctxt) ;
                else 
                  	v_filter_cnd := case when v_filter_datatype='c' then 'lower(' END||(v_filter_col||'.'||v_filter_sourcefld||case when v_filter_datatype='c' then ')' end||' '||v_filter_srctxt) ;
                end if; 

                    v_filter_cndary.EXTEND;
                    v_filter_cndary(v_filter_cndary.COUNT) := v_filter_cnd;

			    end loop;
					
			   		SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_filter_dcjoinuniq from(select distinct column_value from   table(v_filter_dcjoinsary));
			   		
                	 v_sql1 := v_sql||' '||v_filter_dcjoinuniq||' ' ||array_to_string(v_filter_joinsary,' ')||' where '||v_primarydctable||'.cancel=''F'' and '||
                           CASE WHEN v_fldname_transidcnd>0 THEN v_primarydctable||'.transid='''||pentity_transid||''' and 'END||
                           case when v_dacenabled > 0 then ' and '||array_to_string(v_dac_cndary,' and ') end||
                           '
							--axp_filter 
							'||array_to_string(v_filter_cndary,' and ')||case when length(v_grpfld) > 0 then (' group by '||v_keyname) else '' end;
				end if;


	                    v_final_sqls.EXTEND;
                         v_final_sqls(v_final_sqls.COUNT) := (v_sql1);
				
			
			v_filter_cndary:= v_emptyary;
			v_dac_cndary:= v_emptyary;
			v_dac_joinsary :=v_emptyary;
			v_jointables :=v_emptyary;
			
		end loop;


   elsif pcondition = 'General' then 

		if psource ='Entity' then    

			select count(1) into v_fldname_transidcnd from axpflds where tstruct = pentity_transid and dcname ='dc1' and lower(fname)='transid';
			
			v_sql:=	 ('select count(*) totrec,
				sum(case when EXTRACT(YEAR FROM createdon) = EXTRACT(YEAR FROM SYSDATE) then 1 else 0 end) cyear,
	            sum(case when EXTRACT(MONTH FROM createdon) = EXTRACT(MONTH FROM SYSDATE) then 1 else 0 end) cmonth,
	            sum(case when TO_NUMBER(TO_CHAR(createdon, ''IW'')) = TO_NUMBER(TO_CHAR(SYSDATE, ''IW''))  then 1 else 0 end) cweek,
	            sum(case when trunc('||v_primarydctable||'.createdon) = to_date(sysdate) - 1 then 1 else 0 end) cyesterday,
	            sum(case when trunc('||v_primarydctable||'.createdon) = to_date(sysdate) then 1 else 0 end) ctoday,''General'' cnd,null criteria 
				from '||v_primarydctable);				
					  				   
							v_sql := (v_sql||' where cancel=''F'''||
									case when v_fldname_transidcnd > 0 then ' and transid='''||pentity_transid||'''' END||
							' 
							--axp_filter
							');												   
			
						     v_final_sqls.EXTEND;
	                         v_final_sqls(v_final_sqls.COUNT) := (v_sql);
	                        v_dac_cndary:= v_emptyary;
							v_dac_joinsary :=v_emptyary;

		elsif psource= 'Subentity' then 		
		    FOR rec IN
	    	    (select column_value as criteria from table(string_to_array(pcriteria,'^'))) 
		    loop		    			    
	      		v_transid := split_part(rec.criteria,'~',1);
	      		v_tablename := split_part(rec.criteria,'~',9);
				v_keyfld_fname := split_part(rec.criteria,'~',10);
				v_keyfld_fval := split_part(rec.criteria,'~',11);
				v_keyfld_srckey := split_part(rec.criteria,'~',5);
				v_keyfld_srctbl := split_part(rec.criteria,'~',6);
				v_keyfld_srcfld := split_part(rec.criteria,'~',7);

				select tablename into v_subentitytable from axpdc where tstruct = v_transid and dname ='dc1';
			
				if lower(v_tablename)=lower(v_subentitytable) then
			
				v_sql :=  ('select '||''''||v_transid||'''transid'||',count(*) totrec,''General'' cnd,'''||replace(rec.criteria,'''','')||''' criteria  
							from '||v_subentitytable||
							case when v_keyfld_srckey='T' then ' join '||v_keyfld_srctbl||' on '||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id = '||v_tablename||'.'||v_keyfld_fname end
                             ||' where '||v_tablename||'.cancel=''F'' and '
                             ||CASE WHEN v_fldname_transidcnd > 0 THEN v_tablename||'.transid='''||pentity_transid end
                             ||case when v_keyfld_srckey='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else v_keyfld_fname END||'='||v_keyfld_fval
                             ||'
								--axp_filter');				
				ELSE
				
				v_sql :=  ('select '||''''||v_transid||'''transid'||',count(*) totrec,''General'' cnd,'''||replace(rec.criteria,'''','')||''' criteria  from '
							||v_tablename||' a join '
							||v_subentitytable||' b on a.' ||v_subentitytable||'id=b.'||v_subentitytable||'id '
							||case when v_keyfld_srckey='T' then ' join '||v_keyfld_srctbl||' on '||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id = a.'||v_keyfld_fname end
							||' where b.cancel=''F'' and '
							||CASE WHEN v_fldname_transidcnd > 0 THEN ' b.transid='''||pentity_transid||''' and ' end 
							||case when v_keyfld_srckey='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else v_keyfld_fname END||'='||v_keyfld_fval
							||'
								--axp_filter'); 
                            
				END IF;
			                                                  
                          
               		 v_final_sqls.EXTEND;
                         v_final_sqls(v_final_sqls.COUNT) := (v_sql);
                

			end loop;	
	
		end if;
	end if;

   return v_final_sqls;

END;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_filterdata(ptransid varchar2, pflds clob)
 RETURN  SYS.ODCIVARCHAR2LIST
is 
v_sql clob;
v_result_array SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
begin
---pflds - fldname~normalized~source table~source fld


	if split_part(pflds,'~',2)='T' then	
		v_sql := ('select distinct '||split_part(pflds,'~',4)||' from '||split_part(pflds,'~',3));
	ELSIF split_part(pflds,'~',2)='F' then
		v_sql := ('select distinct '||split_part(pflds,'~',1)||' from '||split_part(pflds,'~',3));      
	end if;

	--Bulk collect into Array.       
	execute immediate v_sql bulk collect into v_result_array;

return v_result_array;

 
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_listdata(ptransid varchar2, pflds clob DEFAULT 'All', ppagesize numeric DEFAULT 25, ppageno numeric DEFAULT 1, pfilter clob DEFAULT 'NA', pusername varchar2 DEFAULT 'admin', papplydac varchar2 DEFAULT 'T', puserrole varchar2 DEFAULT 'All',pconstraints clob DEFAULT NULL)
RETURN SYS.ODCIVARCHAR2LIST

 
IS 
 
v_sql clob;
v_sql1 clob;
v_primarydctable  varchar2(3000);
v_fldnamesary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_join  varchar2(3000);
v_fldname_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_col  varchar2(3000);
v_fldname_normalized  varchar2(3000);
v_fldname_srctbl  varchar2(3000);
v_fldname_srcfld  varchar2(3000);
v_fldname_allowempty  varchar2(3000); 
v_fldname_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_dctablename varchar2(3000);
v_fldname_dcflds varchar2(4000);
v_fldname_transidcnd number;
v_fldname_dctables SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_normalizedtables SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_allflds  varchar2(4000);
v_filter_srcfld varchar2(3000);
v_filter_srctxt  varchar2(3000);
v_filter_join  varchar2(3000);
v_filter_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_dcjoin varchar2(3000);
v_filter_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_cnd  varchar2(3000);
v_filter_cndary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_col varchar2(3000);
v_filter_normalized varchar2(3000);
v_filter_sourcetbl varchar2(3000);
v_filter_sourcefld varchar2(3000);
v_filter_datatype varchar2(3000);
v_filter_listedfld varchar2(3000);
v_filter_tablename varchar2(3000);
v_filter_joinreq number;
-- v_recdata_json clob;
t_temp_field_list clob;
v_filter_dcjoinuniq varchar2(3000);
v_final_sqls SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_pegenabled NUMERIC;
v_dacenabled numeric;
v_dactype numeric;
v_dac_join varchar2(4000);
v_dac_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dac_cnd varchar2(4000);
v_dac_cndary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dac_joinreq numeric;
v_dac_normalizedjoinreq numeric; 
 begin
 
 
/*
---pflds - tbl1=fldname~normalized~source_table~source_fld~mandatory|fldname~normalized~source_table~source_fld~mandatory^
		tb12=fldname~normalized~source_table~source_fld~mandatory|fldname~normalized~source_table~source_fld~mandatory
 */
	
/* pfilter
search field|operator search text^ 
fldname~normalized~sourcetable~sourcefld~datatype~listedfield~tablename| operator search text^
*/

	select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';	

	select count(1) into v_fldname_transidcnd from axpflds where tstruct = ptransid and dcname ='dc1' and lower(fname)='transid';


	SELECT count(1) INTO v_pegenabled FROM AXPROCESSDEFV2 WHERE TRANSID = ptransid;


/*
 	----DAC V5
IF papplydac ='T' then
	select sum(cnt),sum(appl) into v_dacenabled,v_dactype from
	(select count(*) cnt,2 appl from axpdef_dac_config a  
	where a.uname = pusername and a.stransid = ptransid and a.editmode in('View','ViewEdit')
	having count(*) > 0
	union all
	select count(*),1 appl from axpdef_dac_config a  join axuserlevelgroups a2 on a.urole = a2.usergroup 
	where a2.username = pusername and a.stransid = ptransid and a.editmode in('View','ViewEdit')
	and ((a2.startdate is not null and current_date  >= startdate) or (startdate is null)) 
	and ((enddate is not null and current_date  <= enddate) or (enddate is null))
	having count(*) > 0
	)a
	where 'T' = papplydac;
END IF;
*/
		if pflds = 'All' then 

            select tablename||'='||listagg(str,'|')WITHIN GROUP(order by  dcname ,ordno)   into  v_allflds From(	
			select tablename,fname||'~'||srckey||'~'||srctf||'~'||srcfld||'~'||allowempty str,
             dcname ,ordno			
			 from axpflds where tstruct=ptransid and 
			dcname ='dc1' and asgrid ='F' and hidden ='F' and savevalue='T' and tablename = v_primarydctable and datatype not in('i','t')
			order by dcname ,ordno			
		          	)a GROUP BY tablename;

		end if;

t_temp_field_list := case when pflds='All' then v_allflds else pflds end;

FOR rec2 IN (select column_value as dcdtls from table(string_to_array(t_temp_field_list,'^')) )
LOOP
	v_fldname_dctablename := split_part(rec2.dcdtls,'=',1);
	v_fldname_dcflds := split_part(rec2.dcdtls,'=',2);
	
	if v_fldname_dctablename!=v_primarydctable THEN
		v_fldname_dcjoinsary.Extend;
		v_fldname_dcjoinsary(v_fldname_dcjoinsary.COUNT):= ('left join '||v_fldname_dctablename||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_fldname_dctablename||'.'||v_primarydctable||'id');				    									
	end if;
		v_fldname_dctables.Extend;
		v_fldname_dctables(v_fldname_dctables.COUNT):= v_fldname_dctablename;
					
 	FOR rec1 in  (select column_value as fldname from table(string_to_array(v_fldname_dcflds,'|')))
loop		    	
					v_fldname_col := split_part(rec1.fldname,'~',1);
					v_fldname_normalized := split_part(rec1.fldname,'~',2);
					v_fldname_srctbl := split_part(rec1.fldname,'~',3);
					v_fldname_srcfld := split_part(rec1.fldname,'~',4);					
					v_fldname_allowempty := split_part(rec1.fldname,'~',5);
					
					if v_fldname_normalized ='F' then 
                         v_fldnamesary.EXTEND;
                         v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_dctablename||'.'||v_fldname_col);

					elsif v_fldname_normalized ='T' then
                         v_fldnamesary.EXTEND;
						 v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_col||'.'||v_fldname_srcfld||' '||v_fldname_col);
                         v_fldname_joinsary.EXTEND;
						 v_fldname_joinsary(v_fldname_joinsary.count) := (CASE WHEN v_fldname_allowempty='F' THEN ' join ' ELSE ' left join ' end||v_fldname_srctbl||' '||v_fldname_col||' on '||v_primarydctable||'.'||v_fldname_col||' = '||v_fldname_col||'.'||v_fldname_srctbl||'id');
					end if;
			    end loop;
END LOOP;
		   	v_sql := (' select '||''''||ptransid||''' transid,'||v_primarydctable||'.'||v_primarydctable||'id recordid,'||v_primarydctable||'.username modifiedby,'
		   			||v_primarydctable||'.modifiedon,'||v_primarydctable||'.createdon,'||v_primarydctable||'.createdby,'||array_to_string(v_fldnamesary,',')||
		   			',null axpeg_processname,null axpeg_keyvalue,null axpeg_status,null axpeg_statustext from ' 
		   			||v_primarydctable||' '||array_to_string(v_fldname_dcjoinsary,' ')||' '||array_to_string(v_fldname_joinsary,' '));
					


		if pfilter ='NA' then 

        v_sql1 :='select * from(                        
                        select a.*,row_number() over(order by modifiedon desc) rno,'||ppageno||' as  pageno  
                           from ( '||v_sql||array_to_string(v_dac_joinsary,' ')||' where '||v_primarydctable||'.cancel=''F'' 
							--axp_filter 
							'||
                           CASE WHEN v_fldname_transidcnd>0 THEN ' and '||v_primarydctable||'.transid='''||ptransid||''''end||
                           case when v_dacenabled > 0 then ' and '||array_to_string(v_dac_cndary,' and ') end||' )a  order by modifiedon desc             
                                ) b  where rno between '||(ppagesize*(ppageno-1)+1)||' and '||(ppagesize*ppageno);
		else
			FOR rec IN
    			(select column_value as ifilter from table(string_to_array(pfilter,'^')) )
			    loop		    	
			    	v_filter_srcfld := split_part(rec.ifilter,'|',1); -- tstfm~empcode~F~~
			    	v_filter_srctxt := split_part(rec.ifilter,'|',2);--   = 'EMP-001'
			    	v_filter_col := split_part(v_filter_srcfld,'~',1);
				    v_filter_normalized := split_part(v_filter_srcfld,'~',2);
 				    v_filter_sourcetbl := split_part(v_filter_srcfld,'~',3);
 				    v_filter_sourcefld := split_part(v_filter_srcfld,'~',4);
					v_filter_datatype := split_part(v_filter_srcfld,'~',5);
					v_filter_listedfld :=split_part(v_filter_srcfld,'~',6);
					v_filter_tablename:=split_part(v_filter_srcfld,'~',7);
					
			    if  v_filter_listedfld='F' then 
								    	
			    	select count(1) into v_filter_joinreq FROM (select distinct column_value from   table(v_fldname_dctables))a where lower(a.column_value)=lower(v_filter_tablename);
			    	
			    	if v_filter_joinreq = 0  then  
				    	v_filter_dcjoin := ' join '||v_filter_tablename||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_filter_tablename||'.'||v_primarydctable||'id';
				    	v_filter_dcjoinsary.EXTEND;
	                   	v_filter_dcjoinsary(v_filter_dcjoinsary.COUNT) := v_filter_dcjoin;
			    	end if;
			    				    		  	
                   	if v_filter_normalized='T' then  	
 		           		v_filter_join := (' join '||v_filter_sourcetbl||' '||v_filter_col||' on '||v_filter_tablename||'.'||v_filter_col||' = '||v_filter_col||'.'||v_filter_sourcetbl||'id');
        	    	   	v_filter_joinsary.EXTEND;
            	       	v_filter_joinsary(v_filter_joinsary.COUNT) := v_filter_join;
                  	end if;
                    
				END IF;
				    if v_filter_normalized='F' then                    
                   		v_filter_cnd := case when v_filter_datatype='c' then 'lower(' END ||(v_filter_tablename||'.'||v_filter_col||case when v_filter_datatype='c' then ')' end||' '||v_filter_srctxt) ;
                    else 
                    	v_filter_cnd := case when v_filter_datatype='c' then 'lower(' END||(v_filter_col||'.'||v_filter_sourcefld||case when v_filter_datatype='c' then ')' end||' '||v_filter_srctxt) ;
                    end if; 

                    v_filter_cndary.EXTEND;
                    v_filter_cndary(v_filter_cndary.COUNT) := v_filter_cnd;

			    end loop;
					SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_filter_dcjoinuniq from(select distinct column_value from   table(v_filter_dcjoinsary));
			   		
                	 v_sql1 := 'select * from(                        
                        select a.*,row_number() over(order by modifiedon desc) rno,'||ppageno||' as  pageno  
                           from ( '||v_sql||' '||v_filter_dcjoinuniq||' '||array_to_string(v_dac_joinsary,' ') ||array_to_string(v_filter_joinsary,' ')||' where '||v_primarydctable||'.cancel=''F'' and '||'
							--axp_filter
							'||CASE WHEN v_fldname_transidcnd>0 THEN v_primarydctable||'.transid='''||ptransid||''' and 'end
                           ||array_to_string(v_filter_cndary,' and ')||CASE WHEN v_dacenabled > 0 THEN 'and '||array_to_string(v_dac_cndary,' and ') END ||' )a  order by modifiedon desc             
                                ) b  where rno between '||(ppagesize*(ppageno-1)+1)||' and '||(ppagesize*ppageno) ;
		end if;


		   
	v_final_sqls.EXTEND;
	v_final_sqls(v_final_sqls.COUNT) := (v_sql1);

return v_final_sqls;

 END;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_metadata(ptransid varchar2, psubentity varchar2 DEFAULT 'F',planguage varchar2 DEFAULT 'English')
 RETURN  axpdef_axpanalytics_mdata
IS
recdata_consoliate_array axpdef_axpanalytics_mdata := axpdef_axpanalytics_mdata();
recdata_dc1_array axpdef_axpanalytics_mdata := axpdef_axpanalytics_mdata();
recdata_subentity_array axpdef_axpanalytics_mdata := axpdef_axpanalytics_mdata();
temp_recdata_subentity_array axpdef_axpanalytics_mdata := axpdef_axpanalytics_mdata();
v_primarydctable varchar2(3000);
v_subentitytable varchar2(3000);
v_sql clob;
v_subentitysql clob;
BEGIN  
  
-- Retrieve primary data table name.
select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';

-- Construct and execute SQL query for primary data.
v_sql :=' select axpdef_axpanalytics_mdata_obj(transid, formcap, fname , fcap, cdatatype, dt,modeofentry , fhide,
	  props,srckey ,srctf ,srcfld ,srctrans ,allowempty,filtercnd,grpfld,aggfld,subentity, datacnd, entityrelfld,
	allowduplicate,tablename,dcname,fordno,dccaption,griddc,listingfld,encrypted,masking,lastcharmask,
	firstcharmask,maskchar,maskroles,customdecimal)
	 from (
select axpflds.tstruct transid,coalesce(lf.compcaption,t.caption) formcap, fname ,coalesce(l.compcaption,axpflds.caption) fcap,customdatatype cdatatype,datatype dt,modeofentry ,hidden fhide,
	null as props,srckey ,srctf ,srcfld ,srctrans ,axpflds.allowempty,
	case when modeofentry =''select'' then case when srckey =''T'' then ''Dropdown'' else ''Text'' end else ''Text'' end filtercnd,
	case when (modeofentry =''select'' or datatype=''c'') then ''T'' else ''F'' end grpfld,
	case when datatype =''n'' then ''T'' else ''F'' end aggfld,''F'' subentity,1 datacnd,null entityrelfld,allowduplicate,axpflds.tablename,
	dcname,ordno fordno,d.caption dccaption,d.asgrid griddc,case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,encrypted,masking,lastcharmask,firstcharmask,maskchar,maskroles,customdecimal
	from axpflds join tstructs t on axpflds.tstruct = t.name
	join axpdc d on axpflds.tstruct = d.tstruct and axpflds.dcname = d.dname
    left join axlanguage l on substr(l.sname,2)= t.name and lower(l.dispname)='''||lower(planguage)||''' and axpflds.fname = l.compname 		
	left join axlanguage lf on substr(lf.sname,2)= t.name and lower(lf.dispname)='''||lower(planguage)||''' and lf.compname=''x__headtext''
	where axpflds.tstruct=:1  and savevalue =''T''	
	union all
	select a.name,coalesce(lf.compcaption,t.caption) ,key,coalesce(l.compcaption,title),	''button'',null,null,''F'',	script|| ''~''|| icon,''F'',null,null,null,null,null,null,null,''F'' subentity,1,null,null
	,null,null,ordno,null,''F'',''F'',null encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
	from axtoolbar a join tstructs t on a.name = t.name
	left join axlanguage l on substr(l.sname,2)= t.name and lower(l.dispname)='''||lower(planguage)||''' and a.key = l.compname
	left join axlanguage lf on substr(lf.sname,2)= t.name and lower(lf.dispname)='''||lower(planguage)||''' and lf.compname=''x__headtext'' 
	where visible = ''true'' and script is not null and a.name= :2
    ) x'; 
 
--Bulk collect into Array.    
   execute immediate v_sql bulk collect into recdata_dc1_array using ptransid,ptransid;

-- If subentities are requested.  
  if psubentity ='T' then		

 -- Iterate over distinct subentity data structures.   
    FOR rec IN (
        select distinct a.dstruct ,a.rtype,dprimarytable--,dc.tablename,a.dfield,a.rtype,a.mfield
		from axentityrelations a 
		join axpdc dc on a.dstruct = dc.tstruct --and dc.dname ='dc1' 
		--join axpflds d on a.dstruct =d.tstruct  and a.dfield = d.fname and d.asgrid ='F'
		where  mstruct = ptransid )
   	loop	
	   	
 	 
	   	
	   	v_subentitysql :=  'select  axpdef_axpanalytics_mdata_obj( transid,formcap, fname ,fcap,cdatatype,dt,modeofentry ,fhide,
		 props,srckey ,srctf ,srcfld ,srctrans ,allowempty, filtercnd,grpfld,aggfld,subentity,datacnd,entityrelfld,allowduplicate,
		tablename,dcname,fordno,dccaption,griddc,listingfld,encrypted,masking,lastcharmask,firstcharmask,maskchar,maskroles,customdecimal)
		 from (
        select axpflds.tstruct transid,coalesce(lf.compcaption,t.caption) formcap, fname ,coalesce(l.compcaption,axpflds.caption) fcap,customdatatype cdatatype,datatype dt,modeofentry,
		hidden fhide,null props,srckey ,srctf ,srcfld ,srctrans ,axpflds.allowempty,
		case when modeofentry =''select'' then case when srckey =''T'' then ''Dropdown'' else ''Text'' end else ''Text'' end filtercnd,
		case when modeofentry =''select'' then ''T'' else ''F'' end grpfld,
		case when datatype =''n'' then ''T'' else ''F'' end aggfld,''T'' subentity,2 datacnd,
		r.mfield entityrelfld,
		allowduplicate,axpflds.tablename,axpflds.dcname,axpflds.ordno fordno,d.caption dccaption,d.asgrid griddc,
		case when d.asgrid=''F'' then ''T'' else ''F'' end listingfld,encrypted,masking,lastcharmask,firstcharmask,maskchar,maskroles,customdecimal
		from axpflds join tstructs t on axpflds.tstruct = t.name  join axpdc d on axpflds.tstruct = d.tstruct and axpflds.dcname = d.dname
		left join axentityrelations r on axpflds.tstruct = r.dstruct and axpflds.fname = r.dfield and r.mstruct=:1 
		left join axlanguage l on substr(l.sname,2)= t.name and lower(l.dispname)='''||lower(planguage)||''' and axpflds.fname = l.compname 
		left join axlanguage lf on substr(lf.sname,2)= t.name and lower(lf.dispname)='''||lower(planguage)||''' and lf.compname=''x__headtext''		
		where axpflds.tstruct=:2 and savevalue =''T'' 
		 union all select '''||rec.dstruct||''',null,''sourceid'',''sourceid'',''Simple Text'',''c'',''accept'',''T'',
		null,''F'',null,null,null,''T'',''F'',''F'',''F'',''T'',2,''recordid'',''T'','''||rec.dprimarytable||''',null,1000,null,''F'',''F'',
		null encrypted,null masking,null lastcharmask,null firstcharmask,null maskchar,null maskroles,null customdecimal
		 from dual where ''gm''='''||rec.rtype||''') x' ;

--Bulk collect into Array.         
       execute immediate v_subentitysql bulk collect into temp_recdata_subentity_array using  ptransid,rec.dstruct;

-- Merge subentity data into main array.       
        recdata_subentity_array := recdata_subentity_array multiset union all temp_recdata_subentity_array; 

   end loop;    

   end if;

 -- Consolidate data arrays.  
   recdata_consoliate_array := recdata_dc1_array multiset union all recdata_subentity_array;

-- Return consolidated metadata. 
    RETURN recdata_consoliate_array; 
	 
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_se_listdata(pentity_transid varchar2, pflds_keyval clob, ppagesize numeric DEFAULT 50, ppageno numeric DEFAULT 1)
RETURN SYS.ODCIVARCHAR2LIST
is 
    
v_sql clob;
v_sql1 clob;
v_fldname_table varchar2(300);
v_fldname_transid  varchar2(3000);
v_fldname_col  varchar2(3000);
v_fldname_normalized  varchar2(3000);
v_fldname_srctbl  varchar2(3000);
v_fldname_srcfld  varchar2(3000);
v_fldname_allowempty  varchar2(3000); 
v_fldname_transidcnd number;
v_allflds  varchar2(3000);
v_fldnamesary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_join  varchar2(3000);
v_fldname_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_tblflds varchar2(4000);
v_emptyary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_pflds_transid  varchar2(3000); 
v_pflds_flds  varchar2(3000);
v_pflds_keyvalue  varchar2(3000);
v_pflds_keytable varchar2(200);
v_keyvalue_fname  varchar2(3000);
v_keyvalue_fvalue  varchar2(3000);
v_keyvalue_fname_srckey varchar2(10);
v_keyvalue_fname_srctbl varchar2(50);
v_keyvalue_fname_srcfld varchar2(50);
v_final_sqls SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_primarydctable varchar2(3000);
v_fields_list varchar2(3000);
v_filter_dcjoinuniq varchar2(3000);
v_fldname_joinsuniq varchar2(3000);
begin	


	
	/*
	 * transid=fldlist=dependfld~depvalue~dependtblname~dependfldprops++transid2=fldlist=dependfld~depvalue
	 * pflds_keyval - transid=tablename!~fldname~normalized~source_table~source_fld~allowempty|fldname2~normalized~source_table~source_fld~allowempty^tablename2!~fldname~normalized~srctbl~srcfld~allowempty=dependfld~dependval++
	 * transid2=tablename!~fldname~normalized~source_table~source_fld~allowempty|fldname2~normalized~source_table~source_fld~allowempty=dependfld~dependval		 
	 */

	FOR rec in  (select column_value as fldkeyvals from  table(string_to_array(pflds_keyval,'++')))    	 
    loop

	    	v_pflds_transid := split_part(rec.fldkeyvals,'=',1);
	    	v_pflds_flds := split_part(rec.fldkeyvals,'=',2);
	    	v_pflds_keyvalue := split_part(rec.fldkeyvals,'=',3);
	    	v_pflds_keytable := split_part(v_pflds_keyvalue,'~',3) ;  
	    	v_keyvalue_fname := split_part(v_pflds_keyvalue,'~',1);
			v_keyvalue_fvalue := split_part(v_pflds_keyvalue,'~',2);		
			v_keyvalue_fname_srckey := split_part(v_pflds_keyvalue,'~',4) ;
			v_keyvalue_fname_srctbl := split_part(v_pflds_keyvalue,'~',5) ;
			v_keyvalue_fname_srcfld := split_part(v_pflds_keyvalue,'~',6) ;	
	    
	    	select tablename into v_primarydctable from axpdc where tstruct =v_pflds_transid and dname ='dc1';
	    
	    	select count(1) into v_fldname_transidcnd from axpflds where tstruct = v_pflds_transid and dcname ='dc1' and lower(fname)='transid';
	    
	    	if  lower(v_pflds_keytable) = lower(v_primarydctable) and v_pflds_flds ='All' then
	    		select tablename||'!~'||listagg(str,'|') within group ( order by dcname ,ordno)  into  v_allflds From(
				select tablename,(fname||'~'||srckey||'~'||srctf||'~'||srcfld||'~'||allowempty) str,
                dcname,ordno
				from axpflds where tstruct=v_pflds_transid and 
				dcname ='dc1' and asgrid ='F' and hidden ='F' and savevalue='T' AND datatype not in('i','t') )a GROUP BY tablename;		    	
			ELSIF lower(v_pflds_keytable) != lower(v_primarydctable) and v_pflds_flds ='All' THEN
				select tablename||'!~'||listagg(str,'|') within group ( order by dcname ,ordno)||'^'||
				v_pflds_keytable||'!~'||split_part(split_part(v_pflds_keyvalue,'~',1),'.',2)||'~'||
				split_part(v_pflds_keyvalue,'~',4)||'~'||split_part(v_pflds_keyvalue,'~',5)||'~'||
				split_part(v_pflds_keyvalue,'~',6)||'~'||split_part(v_pflds_keyvalue,'~',7)
				into  v_allflds From(
				select tablename,(fname||'~'||srckey||'~'||srctf||'~'||srcfld||'~'||allowempty) str,
                dcname,ordno
				from axpflds where tstruct=v_pflds_transid and 
				dcname ='dc1' and asgrid ='F' and hidden ='F' and savevalue='T' AND datatype not in('i','t'))a GROUP BY tablename;	
	    	end if;
			
	    	v_fields_list := case when v_pflds_flds='All' then v_allflds else v_pflds_flds end;

	    for rec1 in (select column_value as tblflds from table(string_to_array(v_fields_list,'^'))) 
	    	loop
			    v_fldname_table := 	split_part(rec1.tblflds,'!~',1);
		    	v_fldname_tblflds := 	split_part(rec1.tblflds,'!~',2);  	
		    
		    if 	lower(v_fldname_table)!=lower(v_primarydctable) then								
				v_fldname_dcjoinsary.EXTEND;
	            v_fldname_dcjoinsary(v_fldname_dcjoinsary.COUNT) := ('left join '||v_fldname_table||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_fldname_table||'.'||v_primarydctable||'id');
			end if;
		
		
			IF	lower(v_fldname_table)!=lower(v_pflds_keytable) then								
				v_fldname_dcjoinsary.EXTEND;
				v_fldname_dcjoinsary(v_fldname_dcjoinsary.COUNT) := ('left join '||v_pflds_keytable||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_pflds_keytable||'.'||v_primarydctable||'id');
			end if;
		
			IF	v_keyvalue_fname_srckey='T' then 				
				v_fldname_joinsary .EXTEND;
				v_fldname_joinsary (v_fldname_joinsary.COUNT):= (' join ' ||v_keyvalue_fname_srctbl||' on '||v_keyvalue_fname||' = '||v_keyvalue_fname_srctbl||'.'||v_keyvalue_fname_srctbl||'id');
			end if;
		    	                
			    FOR rec2 in			    	
    				(select column_value as fldname from table(string_to_array(v_fldname_tblflds,'|'))) 
						loop		    									
							v_fldname_col := split_part(rec2.fldname,'~',1);
							v_fldname_normalized := split_part(rec2.fldname,'~',2);
							v_fldname_srctbl := split_part(rec2.fldname,'~',3);
							v_fldname_srcfld := split_part(rec2.fldname,'~',4);														
							v_fldname_allowempty := split_part(rec2.fldname,'~',5);
												

							if v_fldname_normalized ='F' then 
                             v_fldnamesary.EXTEND;
                             v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_table||'.'||v_fldname_col);

							elsif v_fldname_normalized ='T' then	
                             v_fldnamesary.EXTEND;
                             v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_col||'.'||v_fldname_srcfld||' '||v_fldname_col);	

                             v_fldname_joinsary.EXTEND;
                             v_fldname_joinsary(v_fldname_joinsary.COUNT) := (case when v_fldname_allowempty='F' then ' join ' else ' left join ' end||v_fldname_srctbl||' '||v_fldname_col||' on '||v_fldname_table||'.'||v_fldname_col||' = '||v_fldname_col||'.'||v_fldname_srctbl||'id');

							 end if;	

			    		end loop;
	    	end loop;
	    
	    	
	    	SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_filter_dcjoinuniq from(select distinct column_value from   table(v_fldname_dcjoinsary));
			SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_fldname_joinsuniq from(select distinct column_value from   table(v_fldname_joinsary));
		
		 
				v_sql := (' select '||''''||v_pflds_transid||''' transid,'||v_primarydctable||'.'||v_primarydctable||'id recordid,'||v_primarydctable||'.username modifiedby,'||v_primarydctable||'.modifiedon,'||v_primarydctable||'.createdon,'||v_primarydctable||'.createdby,'||array_to_string(v_fldnamesary,',')
		   			 ||' from '
		   			 ||v_primarydctable||' '||v_filter_dcjoinuniq||' '||v_fldname_joinsuniq
		   			 ||' where '||v_primarydctable||'.cancel=''F'' and '
                     ||case when v_fldname_transidcnd>0 then v_primarydctable||'.transid='||''''||v_pflds_transid||''' and ' END
                     ||case when v_keyvalue_fname_srckey='T'  then v_keyvalue_fname_srctbl||'.'||v_keyvalue_fname_srcfld else v_keyvalue_fname end ||'='||v_keyvalue_fvalue
                     ||'				
					--axp_filter');

		   				v_fldnamesary:= v_emptyary;
		   				v_fldname_joinsary:= v_emptyary;	  
		   				v_fldname_dcjoinsary:=v_emptyary; 
		   				

       v_sql1 :='select * from(                        
                        select a.*,row_number() over(order by modifiedon desc) rno,'||ppageno||' as  pageno  
                           from ( '||v_sql||' )a where rownum <='||(ppagesize*ppageno)||' order by modifiedon desc             
                                ) b  where rno between '||(ppagesize*(ppageno-1)+1)||' and '||(ppagesize*ppageno);


	v_final_sqls.EXTEND;
	v_final_sqls(v_final_sqls.COUNT) := (v_sql1);
    END LOOP;

   	

RETURN v_final_sqls;
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_edittxn(ptransid varchar2, precordid NUMERIC, pusername varchar2 DEFAULT 'admin', papplydac varchar2 DEFAULT 'T')
RETURN varchar2
IS 
v_sql clob;
v_sql1 clob;
v_primarydctable  varchar2(3000);
v_fldnamesary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_join  varchar2(3000);
v_fldname_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_col  varchar2(3000);
v_fldname_normalized  varchar2(3000);
v_fldname_srctbl  varchar2(3000);
v_fldname_srcfld  varchar2(3000); 
v_fldname_allowempty  varchar2(3000); 
v_fldname_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_dctablename varchar2(3000);
v_fldname_dcflds varchar2(4000);
v_fldname_transidcnd number;
v_fldname_dctables SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_normalizedtables SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_allflds  varchar2(4000);
v_dacenabled numeric;
v_dactype numeric;
v_dac_join varchar2(4000);
v_dac_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dac_cnd varchar2(4000);
v_dac_cndary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dac_joinreq numeric;
v_dac_normalizedjoinreq numeric;
v_editable varchar2(1);
v_dac_entry numeric;
v_dac_onlyview numeric;

 begin
 
 
	select tablename into v_primarydctable from axpdc where tstruct = ptransid and dname ='dc1';	

	select count(*) into v_dac_entry from axpdef_dac_config where stransid = ptransid and editmode in('Edit','ViewEdit');

	----DAC V5
	IF papplydac ='T' then
		select sum(cnt),sum(appl),sum(onlyview) into v_dacenabled,v_dactype,v_dac_onlyview from
		(select count(*) cnt,2 appl,0 onlyview  from axpdef_dac_config a  
		where a.uname = pusername and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
		having count(*) > 0
		union all
		select count(*),1 appl,0 onlyview from axpdef_dac_config a  join axuserlevelgroups a2 on a.urole = a2.usergroup 
		where a2.username = pusername and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
		and ((a2.startdate is not null and current_date  >= startdate) or (startdate is null)) 
		and ((enddate is not null and current_date  <= enddate) or (enddate is null))
		having count(*) > 0
		union all
		select 0 cnt,0 appl,1 onlyview from axpdef_dac_config a  
		where a.uname = pusername and a.stransid = ptransid and a.editmode='View'
		having count(*) > 0
		union all
		select 0,0 appl,1 onlyview from axpdef_dac_config a  join axuserlevelgroups a2 on a.urole = a2.usergroup 
		where a2.username = pusername and a.stransid = ptransid and a.editmode='View'
		and ((a2.startdate is not null and current_date  >= startdate) or (startdate is null)) 
		and ((enddate is not null and current_date  <= enddate) or (enddate is null))
		having count(*) > 0
		)a
		where 'T' = papplydac;
	END IF;


		           select LISTAGG(str,'^') WITHIN GROUP(ORDER BY 1) into v_allflds 
					from 
					(
					select f.tablename||'='||listagg(f.fname||'~'||f.srckey||'~'||f.srctf||'~'||f.srcfld||'~'||f.allowempty,'|') WITHIN group(ORDER BY b.axpdef_dac_configdtlrow) str
					from axpdef_dac_config a join axpdef_dac_configdtl b on a.axpdef_dac_configid =  b.axpdef_dac_configid
					join axpflds f on a.stransid =f.tstruct and b.fldname = f.fname 
					where a.uname = pusername  and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					and a.dataaccesscnd = 30 and v_dactype in(2,3) 
					group by f.tablename									
					union all					
					select  tablename||'='||'createdby~F~~~F'
					from axpdef_dac_config a 
					join axpdc d on a.stransid =d.tstruct and d.dname= 'dc1' 
					where a.uname = pusername and a.dataaccesscnd in (10,11,12) 
					and a.stransid = ptransid and a.editmode in('Edit','ViewEdit') and v_dactype in(2,3)					
					union all					
					select f.tablename||'='||listagg(f.fname||'~'||f.srckey||'~'||f.srctf||'~'||f.srcfld||'~'||f.allowempty,'|') WITHIN GROUP(ORDER BY b.axpdef_dac_configdtlrow) str
					from axpdef_dac_config a join axpdef_dac_configdtl b on a.axpdef_dac_configid =  b.axpdef_dac_configid
					join axpflds f on a.stransid =f.tstruct and b.fldname = f.fname 
					join axuserlevelgroups u on a.urole = u.usergroup and ((u.startdate is not null and current_date  >= startdate) or (startdate is null)) and ((enddate is not null and current_date  <= enddate) or (enddate is null))
					and u.username = pusername and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					where a.dataaccesscnd =30 and v_dactype = 1					
					group by f.tablename	
					union all
					select tablename||'='||'createdby~F~~~F'
					from axpdef_dac_config a 
					join axpdc d on a.stransid =d.tstruct and d.dname= 'dc1'
					join axuserlevelgroups u on a.urole = u.usergroup and ((u.startdate is not null and current_date  >= startdate) or (startdate is null)) and ((enddate is not null and current_date  <= enddate) or (enddate is null))
					and u.username = pusername and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					where a.dataaccesscnd in (10,11,12) and v_dactype = 1
					)a;


FOR rec2 IN (select column_value as dcdtls from table(string_to_array(v_allflds,'^')) )
LOOP
	v_fldname_dctablename := split_part(rec2.dcdtls,'=',1);
	v_fldname_dcflds := split_part(rec2.dcdtls,'=',2);
	
	if v_fldname_dctablename!=v_primarydctable THEN
		v_fldname_dcjoinsary.Extend;
		v_fldname_dcjoinsary(v_fldname_dcjoinsary.COUNT):= ('left join '||v_fldname_dctablename||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_fldname_dctablename||'.'||v_primarydctable||'id');				    									
	end if;
		v_fldname_dctables.Extend;
		v_fldname_dctables(v_fldname_dctables.COUNT):= v_fldname_dctablename;
					
 	FOR rec1 in  (select column_value as fldname from table(string_to_array(v_fldname_dcflds,'|')))
loop		    	
					v_fldname_col := split_part(rec1.fldname,'~',1);
					v_fldname_normalized := split_part(rec1.fldname,'~',2);
					v_fldname_srctbl := split_part(rec1.fldname,'~',3);
					v_fldname_srcfld := split_part(rec1.fldname,'~',4);					
					v_fldname_allowempty := split_part(rec1.fldname,'~',5);
					
					if v_fldname_normalized ='F' then 
                         v_fldnamesary.EXTEND;
                         v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_dctablename||'.'||v_fldname_col);

					elsif v_fldname_normalized ='T' then
                         v_fldnamesary.EXTEND;
						 v_fldnamesary(v_fldnamesary.COUNT) := (v_fldname_col||'.'||v_fldname_srcfld||' '||v_fldname_col);
                         v_fldname_joinsary.EXTEND;
						 v_fldname_joinsary(v_fldname_joinsary.count) := (CASE WHEN v_fldname_allowempty='F' THEN ' join ' ELSE ' left join ' end||v_fldname_srctbl||' '||v_fldname_col||' on '||v_primarydctable||'.'||v_fldname_col||' = '||v_fldname_col||'.'||v_fldname_srctbl||'id');
						v_fldname_normalizedtables.Extend;
						v_fldname_normalizedtables(v_fldname_normalizedtables.COUNT):= v_fldname_srctbl;
					end if;
			    end loop;
END LOOP;
		   	v_sql := (' select count(*)  from '||v_primarydctable||' '||array_to_string(v_fldname_dcjoinsary,' ')||' '||array_to_string(v_fldname_joinsary,' '));
					
										
---------DAC filters
			   if v_dacenabled > 0 then
				for dacrec in 			   
					(select fname,tablename,srckey,srctf,srcfld,
					case when filtercnd in('like','not like') then case when isglovar='F' then '''%'||attribvalue||'%''' else 
					case when lower(trim(attribvalue))=':username' then  '''%'||pusername||'%''' else '''%''||'||attribvalue||'||''%''' end end
					when filtercnd in('in','not in') then case when isglovar='F' then ''''||replace(attribvalue,',',''',''')||'''' else case when lower(trim(attribvalue))=':username' then  ''''||pusername||'''' else attribvalue end end
					when filtercnd in('=','!=','>','<') then case when isglovar='F' then ''''||attribvalue||'''' else case when lower(trim(attribvalue))=':username' then  ''''||pusername||'''' else attribvalue end end  end cnd,
					ord,filtercnd  from
					(
					select case when b.dynamicval ='No' and a.dataaccesscnd = 30 then b.fldstaticval when b.dynamicval ='Yes' and a.dataaccesscnd = 30 then b.fldmastvalue end  attribvalue,
					f.fname,f.tablename,1 ord, b.filtercnd,b.isglovar,f.srckey,f.srctf,f.srcfld
					from axpdef_dac_config a join axpdef_dac_configdtl b on a.axpdef_dac_configid =  b.axpdef_dac_configid
					join axpflds f on a.stransid =f.tstruct and b.fldname = f.fname 
					where a.uname = pusername  and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					and a.dataaccesscnd = 30 and v_dactype in(2,3)					
					union all			
					select case when b.dynamicval ='No' and a.dataaccesscnd = 30 then b.fldstaticval when b.dynamicval ='Yes' and a.dataaccesscnd = 30 then b.fldmastvalue end  attribvalue,
					b.fldname ,d.tablename,1 ord, b.filtercnd,b.isglovar,'F',null,null
					from axpdef_dac_config a join axpdef_dac_configdtl b on a.axpdef_dac_configid =  b.axpdef_dac_configid
					join axpdc d on a.stransid =d.tstruct and d.dname= 'dc1' 
					where a.uname = pusername  and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					and a.dataaccesscnd = 30 and b.fldname in('createdby','username')  and v_dactype in(2,3)
					union all		
					select  pusername attribvalue, 'createdby' ,d.tablename,1 ord,'='filtercnd,'F','F' srckey,null srctf, null srcfld
					from axpdef_dac_config a 
					join axpdc d on a.stransid =d.tstruct and d.dname= 'dc1' 
					where a.uname = pusername and a.dataaccesscnd in (10,11,12) and a.stransid = ptransid 
					and a.editmode in('Edit','ViewEdit') and v_dactype in(2,3)					
					union all					
					select case when b.dynamicval ='No' and a.dataaccesscnd = 30 then b.fldstaticval when b.dynamicval ='Yes' and a.dataaccesscnd = 30 then b.fldmastvalue end  attribvalue,
					f.fname,f.tablename,2 ord, b.filtercnd,b.isglovar,f.srckey,f.srctf,f.srcfld
					from axpdef_dac_config a join axpdef_dac_configdtl b on a.axpdef_dac_configid =  b.axpdef_dac_configid
					join axpflds f on a.stransid =f.tstruct and b.fldname = f.fname 
					join axuserlevelgroups u on a.urole = u.usergroup and ((u.startdate is not null and current_date  >= startdate) or (startdate is null)) and ((enddate is not null and current_date  <= enddate) or (enddate is null))
					and u.username = pusername and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					where a.dataaccesscnd =30 and v_dactype = 1
					union all
					select case when b.dynamicval ='No' and a.dataaccesscnd = 30 then b.fldstaticval when b.dynamicval ='Yes' and a.dataaccesscnd = 30 then b.fldmastvalue end  attribvalue,
					b.fldname,d.tablename,2 ord, b.filtercnd,b.isglovar,'F',null,null
					from axpdef_dac_config a join axpdef_dac_configdtl b on a.axpdef_dac_configid =  b.axpdef_dac_configid
					join axpdc d on a.stransid =d.tstruct and d.dname= 'dc1'
					join axuserlevelgroups u on a.urole = u.usergroup and ((u.startdate is not null and current_date  >= startdate) or (startdate is null)) and ((enddate is not null and current_date  <= enddate) or (enddate is null))
					and u.username = pusername and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					where a.dataaccesscnd =30 and v_dactype = 1	and  b.fldname in('createdby','username') 						
					union all
					select  pusername attribvalue, 'createdby' ,d.tablename,2 ord,'='filtercnd ,'F','F' srckey,null srctf, null srcfld
					from axpdef_dac_config a 
					join axpdc d on a.stransid =d.tstruct and d.dname= 'dc1'
					join axuserlevelgroups u on a.urole = u.usergroup and ((u.startdate is not null and current_date  >= startdate) or (startdate is null)) and ((enddate is not null and current_date  <= enddate) or (enddate is null))
					and u.username = pusername and a.stransid = ptransid and a.editmode in('Edit','ViewEdit')
					where a.dataaccesscnd in (10,11,12) and v_dactype = 1
					)a
					order by ord)
					
					loop
						
						select count(1) into v_dac_joinreq from (
						select distinct column_value tbls from  table(v_fldname_dctables)
						union 
						select distinct column_value tbls from  table(v_fldname_normalizedtables)								
						)a 
						where lower(a.tbls)=lower(dacrec.tablename);	


						if dacrec.srckey ='T' then
							select count(1) into v_dac_normalizedjoinreq from (
							select distinct column_value tbls FROM table(v_fldname_dctables)
							union 
							select distinct column_value tbls FROM table(v_fldname_normalizedtables)								
							)a 
							where lower(a.tbls)=lower(dacrec.srctf);	
						
							if v_dac_normalizedjoinreq = 0 then
								v_dac_joinsary.extend();
								v_dac_joinsary(v_dac_joinsary.COUNT) := ' join '||dacrec.srctf||' on '||dacrec.srctf||'.'||dacrec.srctf||'id='||dacrec.tablename||'.'||dacrec.fname;
								v_fldname_dctables.extend();
								v_fldname_dctables(v_fldname_dctables.COUNT) := dacrec.srctf;						
							end if;

						end if;		


	
							
						if v_dac_joinreq = 0 THEN
						v_dac_joinsary.extend();
						v_dac_joinsary(v_dac_joinsary.COUNT) := ' join '||dacrec.tablename||' on '||v_primarydctable||'.'||v_primarydctable||'id='||dacrec.tablename||'.'||v_primarydctable||'id';
						v_fldname_dctables.EXTEND();
						v_fldname_dctables(v_fldname_dctables.COUNT) := dacrec.tablename;		
						end if;			
								

						v_dac_cnd := case 
									 when dacrec.srckey='F' then  
									 dacrec.tablename||'.'||dacrec.fname||' '||dacrec.filtercnd||'('|| case when dacrec.filtercnd in('in','not in') then 'SELECT REGEXP_SUBSTR('||replace(dacrec.cnd,':','axglovar.')||', ''[^,]+'', 1, LEVEL) FROM dual CONNECT BY REGEXP_SUBSTR('||replace(dacrec.cnd,':','axglovar.')||', ''[^,]+'', 1, LEVEL) IS NOT NULL' else replace(dacrec.cnd,':','axglovar.')	end||')'  
									 when 	dacrec.srckey='T' then  
									 (dacrec.fname||'.'||dacrec.srcfld||' '||dacrec.filtercnd||'('||case when dacrec.filtercnd in('in','not in') then 'SELECT REGEXP_SUBSTR('||replace(dacrec.cnd,':','axglovar.')||', ''[^,]+'', 1, LEVEL) FROM dual CONNECT BY REGEXP_SUBSTR('||replace(dacrec.cnd,':','axglovar.')||', ''[^,]+'', 1, LEVEL) IS NOT NULL' else replace(dacrec.cnd,':','axglovar.')	end	||')') 
									end;
					
						v_dac_cndary.extend();
						v_dac_cndary(v_dac_cndary.COUNT) := v_dac_cnd;									
					
					end loop;		
			   
			   
			   END IF;

				   
	v_sql1 := v_sql||' join axglovar on axglovar.axglo_user = '||''''||pusername||''''||' where '||v_primarydctable||'id='||precordid||CASE WHEN v_dacenabled > 0 THEN ' and '||array_to_string(v_dac_cndary,' and ') ELSE ' and 1=2 ' END;


EXECUTE IMMEDIATE v_sql1 INTO v_editable;

return case when v_dac_entry > 0 and v_dac_onlyview = 0 then 
case when v_editable = '0' then 'F' else 'T' end 
when v_dac_entry > 0 and v_dac_onlyview =2 then 'F'
when v_dac_entry > 0 and v_dac_onlyview in (1,3) then case when v_editable = '0' then 'F' else 'T' end
when v_dac_entry = 0 and v_dac_onlyview in (1,2,3) then 'F'
else 'T' end;



END;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_ap_charts(pentity_transid varchar2, pcriteria varchar2, pfilter varchar2, pusername varchar2 DEFAULT 'admin', papplydac varchar2 DEFAULT 'T',puserrole varchar2 DEFAULT 'All',pconstraints clob DEFAULT NULL)
RETURN SYS.ODCIVARCHAR2LIST
IS
v_primarydctable varchar2(100);
v_subentitytable varchar2(100);
v_transid varchar2(10);
v_grpfld varchar2(100);
v_aggfld varchar2(100);
v_aggfnc varchar2(100); 
v_srckey varchar2(100);
v_srctbl varchar2(100);
v_srcfld varchar2(100);
v_aempty varchar2(10);
v_aggfldtable varchar2(100);
v_sql clob;
v_normalizedjoin varchar2(2000);
v_keyname varchar2(100);
v_entitycond varchar2(100);
v_keyfld_fname varchar2(100);
v_keyfld_fval varchar2(4000);
v_final_sqls SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_transidcnd number;
v_sql1 clob;
v_filter_srcfld varchar2(100);
v_filter_srctxt varchar2(100);
v_filter_join varchar2(4000);
v_filter_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_cnd varchar2(100);
v_filter_cndary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_joinreq number;
v_filter_dcjoinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_filter_col varchar2(1000);
v_filter_normalized varchar2(4000);
v_filter_sourcetbl varchar2(100);
v_filter_sourcefld varchar2(100);
v_filter_datatype varchar2(100);
v_filter_listedfld varchar2(10);
v_filter_tablename varchar2(100);
v_emptyary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_grpfld_tbl varchar2(100);
v_grpfld_tablejoins varchar2(4000);
v_aggfld_tablejoins varchar2(4000);
v_tablejoins varchar2(4000);
v_aggfldtransid varchar2(10);
v_aggfld_primarydctable varchar2(100);
v_entityrelation varchar2(4000);
v_aggfldname_transidcnd numeric;
v_entity_parent_reltable varchar2(100);
v_entity_child_reltable varchar2(100);
v_filter_dcjoinuniq varchar2(4000);
v_dacenabled number;
v_dactype number;
v_dac_join varchar2(4000);
v_dac_joinsary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dac_cnd varchar2(4000);
v_dac_cndary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_dac_joinreq number;
v_dac_normalizedjoinreq number; 
v_tablenames SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
begin

	/*	  
	 * pcriteria_v1 - transid~aggfnc~groupfld~normalized~srctable~srcfld~allowempty~grpfld_tablename~aggfld~aggfld_tablename(Not in use)	 
	 * pcriteria_v2 - aggfnc~grpfld_transid~groupfld~normalized~srctable~srcfld~allowempty~grpfld_tablename~aggfld_transid~aggfld~aggfld_tablename~grpfld_transid_AND_aggfld_transid_relation
	 * Ex1(agg fld in Non grid dc) - sum~gcust~party_name~F~~~~mg_partyhdr~slord~total_discount~salesorder_header~mg_partyhdr.mg_partyhdrid = salesorder_header.customer
	 * Ex2(agg fld in grid dc) - sum~gcust~party_name~F~~~~mg_partyhdr~slord~taxableamount~salesorder_items~mg_partyhdr.mg_partyhdrid = salesorder_header.customer

	*/ 	 
	
	
	select lower(trim(tablename)) into v_primarydctable from axpdc where tstruct = pentity_transid and dname ='dc1';

	v_tablenames.Extend;
	v_tablenames(v_tablenames.COUNT) := v_primarydctable;
	
	select count(1) into v_fldname_transidcnd from axpflds where tstruct = pentity_transid and lower(tablename)=lower(v_primarydctable) and lower(fname)='transid';	
	
	
	    FOR rec IN(SELECT column_value criteria  from table(string_to_array(pcriteria,'^')))  
    	    -----aggfnc~grpfld_transid~groupfld~normalized~srctable~srcfld~allowempty~grpfld_tablename~aggfld_transid~aggfld~aggfld_tablename~grpfld_transid_AND_aggfld_transid_relation
		    loop
			    	
			    v_aggfnc := split_part(rec.criteria,'~',1);---- agg function
			    v_transid := split_part(rec.criteria,'~',2);---grpfld_transid  			    
		    	v_grpfld := split_part(rec.criteria,'~',3);---grpfld_name
			    v_srckey := split_part(rec.criteria,'~',4);---normalized_grpfld_flag
	   			v_srctbl := split_part(rec.criteria,'~',5);---normalied_source table	   			
		   		v_srcfld := split_part(rec.criteria,'~',6);---normalied_source field
			   	v_aempty := split_part(rec.criteria,'~',7);---grpfld_allowempty - to franme left join or join
			    v_grpfld_tbl := lower(trim(split_part(rec.criteria,'~',8)));--grpfld_tablename
			    v_aggfldtransid :=split_part(rec.criteria,'~',9);--aggfld_transid;
				v_aggfld := case when split_part(rec.criteria,'~',10)='count' then '1' else split_part(rec.criteria,'~',10) end;				
				v_aggfldtable := lower(trim(split_part(rec.criteria,'~',11)));---aggfld_tablename
				v_entityrelation := split_part(rec.criteria,'~',12);---grpfld_transid_aggfld_transid_relation
				v_entity_parent_reltable := lower(trim(split_part(split_part(v_entityrelation,'=',1),'.',1)));
				v_entity_child_reltable := lower(trim(split_part(split_part(v_entityrelation,'=',2),'.',1)));
				
				
				v_normalizedjoin := case when v_srckey='T' then ' left join '||v_srctbl||' b on '||v_grpfld_tbl||'.'||v_grpfld||' = b.'||v_srctbl||'id ' else ' ' end;
				v_keyname := case when length(v_grpfld) > 0 then case when v_srckey='T' then 'b.'||v_srcfld else v_grpfld_tbl||'.'||v_grpfld end else 'null' end;			
			
				v_tablenames.Extend;
				v_tablenames(v_tablenames.COUNT) := case when v_srckey='T' then  v_srctbl end;
				
				v_tablenames.Extend;				
				v_tablenames(v_tablenames.COUNT) := case when v_srckey='T' then  v_grpfld_tbl end;
			
				v_tablenames.Extend;
				v_tablenames(v_tablenames.COUNT) := v_aggfldtable;
			
			
			if v_transid = v_aggfldtransid then
			
				if lower(v_aggfldtable)=lower(v_primarydctable) and lower(v_grpfld_tbl)=lower(v_primarydctable) then
					v_tablejoins := v_primarydctable;								   			   									
				elsif lower(v_grpfld_tbl) != lower(v_primarydctable) and lower(v_aggfldtable)=lower(v_primarydctable) then
					v_tablejoins := v_primarydctable||' left join '||v_grpfld_tbl||' on '||v_grpfld_tbl||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';
				elsif lower(v_aggfldtable) != lower(v_primarydctable) and lower(v_grpfld_tbl)=lower(v_primarydctable) then
					v_tablejoins := v_primarydctable||' left join '||v_aggfldtable||' on '||v_aggfldtable||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';
				elsif lower(v_aggfldtable) != lower(v_primarydctable) and lower(v_grpfld_tbl)=lower(v_aggfldtable) then
					v_tablejoins := v_primarydctable||' left join '||v_aggfldtable||' on '||v_aggfldtable||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';
				elsif lower(v_aggfldtable) != lower(v_primarydctable) and lower(v_grpfld_tbl)!=lower(v_aggfldtable) then
					v_tablejoins := v_primarydctable||' left join '||v_aggfldtable||' on '||v_aggfldtable||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id left join '||v_grpfld_tbl||' on '||v_grpfld_tbl||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';
				end if;	----------------- v_tablejoins																						
			
			elsif v_transid != v_aggfldtransid then
				select lower(trim(tablename)) into v_aggfld_primarydctable from axpdc where tstruct = v_aggfldtransid and dname ='dc1';	
			
				select count(1) into v_aggfldname_transidcnd from axpflds where tstruct = v_aggfldtransid and lower(tablename) = lower(v_aggfld_primarydctable) 
				and lower(fname)='transid';

				------------group field joins
				if lower(v_grpfld_tbl)=lower(v_primarydctable)  and lower(v_entity_parent_reltable)=lower(v_primarydctable) then 
					v_grpfld_tablejoins := v_grpfld_tbl;
				elsif lower(v_grpfld_tbl)!=lower(v_primarydctable) and lower(v_entity_parent_reltable)=lower(v_primarydctable) then 
					v_grpfld_tablejoins := v_primarydctable||' join '||v_grpfld_tbl||' on '||v_grpfld_tbl||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';
				elsif lower(v_grpfld_tbl)=lower(v_primarydctable) and lower(v_entity_parent_reltable)!=lower(v_primarydctable) then 
					v_grpfld_tablejoins := v_primarydctable||' join '||v_entity_parent_reltable||' on '||v_entity_parent_reltable||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';	
				elsif lower(v_grpfld_tbl)!=lower(v_primarydctable) and lower(v_entity_parent_reltable)!=lower(v_primarydctable) then
					v_grpfld_tablejoins := v_primarydctable||' join '||v_grpfld_tbl||' on '||v_grpfld_tbl||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id'
									||' join '||v_entity_parent_reltable||' on '||v_entity_parent_reltable||'.'||v_primarydctable||'id='||v_primarydctable||'.'||v_primarydctable||'id';
				end if;								
					
				--------------agg field joins	
				if lower(v_aggfldtable)=lower(v_aggfld_primarydctable)  and lower(v_entity_child_reltable)=lower(v_aggfld_primarydctable) then 
					v_aggfld_tablejoins := ' join '||v_aggfldtable||' on '||v_entityrelation;
				elsif lower(v_aggfldtable)!=lower(v_aggfld_primarydctable) and lower(v_entity_child_reltable)=lower(v_aggfld_primarydctable) then 
					v_aggfld_tablejoins := ' join '||v_entity_child_reltable||' on '||v_entityrelation||' join '||v_aggfldtable||' on '||v_aggfldtable||'.'||v_aggfld_primarydctable||'id='||v_aggfld_primarydctable||'.'||v_aggfld_primarydctable||'id';
				elsif lower(v_aggfldtable)=lower(v_aggfld_primarydctable) and lower(v_entity_child_reltable)!=lower(v_aggfld_primarydctable) then 
					v_aggfld_tablejoins := ' join '||v_entity_child_reltable||' on '||v_entityrelation||' join '||v_aggfld_primarydctable||' on '||v_aggfld_primarydctable||'.'||v_aggfld_primarydctable||'id='||v_entity_child_reltable||'.'||v_aggfld_primarydctable||'id';	
				elsif lower(v_aggfldtable)!=lower(v_aggfld_primarydctable) and lower(v_entity_child_reltable)!=lower(v_aggfld_primarydctable) then
					v_aggfld_tablejoins := ' join '||v_entity_child_reltable||' on '||v_entityrelation||' join '||v_aggfld_primarydctable||' on '||v_aggfld_primarydctable||'.'||v_aggfld_primarydctable||'id='||v_entity_child_reltable||'.'||v_aggfld_primarydctable||'id'||
											' join '||v_aggfldtable||' on '||v_aggfldtable||'.'||v_aggfld_primarydctable||'id='||v_aggfld_primarydctable||'.'||v_aggfld_primarydctable||'id';									
				end if;											
				
				v_tablejoins := v_grpfld_tablejoins||' '||v_aggfld_tablejoins;
			
			end if; ------- v_transid = v_aggfldtransid
				
			
			
			select 'select '||v_keyname||' keyname,'||case when lower(trim(v_aggfnc)) in ('sum','avg') then 'round('||v_aggfnc||'('||v_aggfld||'),2)'else v_aggfnc||'('||v_aggfld||')' END||
			'keyvalue,'||''''||rec.criteria||''''||' criteria from '||v_tablejoins||' '||v_normalizedjoin into v_sql FROM dual;				
			
				if coalesce(pfilter,'NA') ='NA' then 
				
				
			v_sql1 := v_sql||array_to_string(v_dac_joinsary,' ')||' where '||v_primarydctable||'.cancel=''F'''
						||case when v_fldname_transidcnd > 0 then ' and '||v_primarydctable||'.transid='''||pentity_transid||'''' END
						||case when v_transid != v_aggfldtransid then ' and '||v_aggfld_primarydctable||'.cancel=''F''' END
						||case when v_aggfldname_transidcnd > 0 then ' and '||v_aggfld_primarydctable||'.transid='''||v_aggfldtransid||'''' END
						||case when v_dacenabled > 0 then concat(' and ',array_to_string(v_dac_cndary,' and ')) end
						||case when length(v_grpfld) > 0 then ' group by '||v_keyname else '' end;
	
		else 
			FOR rec_filters IN(select column_value ifilter FROM table(string_to_array(pfilter,'^'))  )
			    loop		    	
			    	v_filter_srcfld := split_part(rec_filters.ifilter,'|',1);
			    	v_filter_srctxt := split_part(rec_filters.ifilter,'|',2);
			    	v_filter_col := split_part(v_filter_srcfld,'~',1);
				    v_filter_normalized := split_part(v_filter_srcfld,'~',2);
 				    v_filter_sourcetbl := split_part(v_filter_srcfld,'~',3);
 				    v_filter_sourcefld := split_part(v_filter_srcfld,'~',4);
					v_filter_datatype := split_part(v_filter_srcfld,'~',5);
					v_filter_listedfld :=split_part(v_filter_srcfld,'~',6);
					v_filter_tablename:=split_part(v_filter_srcfld,'~',7);
					
		
			    				    	
			    	if  v_filter_listedfld = 'F' then
			    	
					v_filter_joinreq := case when lower(v_aggfldtable)=lower(v_filter_tablename) then 1 else 0 end; 			    		
					
			    	if v_filter_joinreq = 0  then 
				    	v_filter_dcjoinsary.Extend;
				    	v_filter_dcjoinsary(v_filter_dcjoinsary.COUNT):= (' join '||v_filter_tablename||' on '||v_primarydctable||'.'||v_primarydctable||'id='||v_filter_tablename||'.'||v_primarydctable||'id');
			    	end if;
			    
			    	
			    
		    		select case when v_filter_normalized='T' 
					then ' join '||v_filter_sourcetbl||' '||v_filter_col||' on '||v_filter_tablename||'.'||v_filter_col||' = '||v_filter_col||'.'||v_filter_sourcetbl||'id'
					end into v_filter_join from dual where v_filter_normalized='T';
					
					 						
					v_filter_dcjoinsary.Extend;
					v_filter_dcjoinsary(v_filter_dcjoinsary.COUNT):=(v_filter_join);
					
				
					end if;
			
									
					select case when v_filter_normalized='F' 
					then case when v_filter_datatype='c' then 'lower(' END||v_filter_tablename||'.'||v_filter_col||case when v_filter_datatype='c' then ')' END||' '||v_filter_srctxt 
					else case when v_filter_datatype='c' then 'lower(' END||v_filter_col||'.'||v_filter_sourcefld||case when v_filter_datatype='c' then ')' END||' '||v_filter_srctxt 
					end into v_filter_cnd FROM dual;
		    										
					v_filter_cndary.Extend;
					v_filter_cndary(v_filter_cndary.COUNT):=(v_filter_cnd);				
					
			    end loop;
			   	
			   	SELECT listagg(column_value,' ') WITHIN group(ORDER BY 1) INTO v_filter_dcjoinuniq from(select distinct column_value from   table(v_filter_dcjoinsary));
			   			   	
			   
				v_sql1 := v_sql||array_to_string(v_filter_dcjoinsary,' ')||array_to_string(v_filter_joinsary,' ')||array_to_string(v_dac_joinsary,' ')
						||' where '||v_primarydctable||'.cancel=''F'''
						||case when v_fldname_transidcnd > 0 then ' and '||v_primarydctable||'.transid='''||pentity_transid||''' and ' END
						||case when v_transid != v_aggfldtransid then v_aggfld_primarydctable||'.cancel=''F''' END
						||case when v_aggfldname_transidcnd > 0 then ' and '||v_aggfld_primarydctable||'.transid='''||v_aggfldtransid||'''' END
						||array_to_string(v_filter_cndary,' and ')
						||case when v_dacenabled > 0 then concat(' and ',array_to_string(v_dac_cndary,' and ')) end
						||case when length(v_grpfld) > 0 then ' group by '||v_keyname else '' end;					    						
		end if;
			
			v_final_sqls.Extend;
			v_final_sqls(v_final_sqls.COUNT):=(v_sql1);				
			v_filter_cndary:= v_emptyary;
			
	    	END LOOP;
	      	

   return v_final_sqls ;
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpanalytics_se_chartdata(pcriteria in varchar2)
RETURN  SYS.ODCIVARCHAR2LIST
IS 
v_primarydctable varchar2(3000);
v_subentitytable varchar2(3000);
v_transid varchar2(3000);
v_operations varchar2(3000);
v_grpfld varchar2(3000);
v_aggfld varchar2(3000);
v_aggfnc varchar2(3000);
v_srckey varchar2(3000);
v_srctbl varchar2(3000); 
v_srcfld varchar2(3000); 
v_aempty varchar2(3000);
v_tablename varchar2(100);
v_sql clob;
v_keyname varchar2(3000);
v_entitycond varchar2(3000);
v_keyfld_fname varchar2(3000);
v_keyfld_fval varchar2(3000);  
v_keyfld_srckey varchar2(10);
v_keyfld_srctbl varchar2(50);
v_keyfld_srcfld varchar2(50);
v_final_sqls SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_fldname_transidcnd number;
v_emptyary SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
v_jointables SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();

begin

--criteria - transid~opr1,opr2,opr3~keyfld_normalized~keyfld_srctable~keyfld_srcfld~allowempty~aggfld_tablename~keyfld~keyval

		
		    FOR rec IN
	    	    (select column_value as criteria from table(string_to_array(pcriteria,'^'))) 
		    loop		    			    
	      		v_transid := split_part(rec.criteria,'~',1);
				v_operations := split_part(rec.criteria,'~',2);
				v_keyfld_srckey := split_part(rec.criteria,'~',3);
				v_keyfld_srctbl := split_part(rec.criteria,'~',4);
				v_keyfld_srcfld := split_part(rec.criteria,'~',5);
	      		v_tablename := split_part(rec.criteria,'~',7);
				v_keyfld_fname := split_part(rec.criteria,'~',8);
				v_keyfld_fval := split_part(rec.criteria,'~',9);

				select tablename into v_subentitytable from axpdc where tstruct = v_transid and dname ='dc1';
			
				select count(1) into v_fldname_transidcnd from axpflds where tstruct = v_transid and dcname ='dc1' and lower(fname)='transid';
			
			
				if lower(v_tablename)=lower(v_subentitytable) then
			
				v_sql :=  ('select '||''''||v_transid||'''transid,'||v_operations||',''General'' cnd,'''||replace(rec.criteria,'''','')||''' criteria  
							from '||v_tablename||
							case when v_keyfld_srckey='T' then ' join '||v_keyfld_srctbl||' on '||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id = '||v_tablename||'.'||v_keyfld_fname end
                             ||' where '||v_tablename||'.cancel=''F'' and '
                             ||CASE WHEN v_fldname_transidcnd > 0 THEN v_tablename||'.transid='''||v_transid end
                             ||case when v_keyfld_srckey='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else v_keyfld_fname END||'='||v_keyfld_fval
                          );				
				ELSE
				
				v_sql :=  ('select '||''''||v_transid||'''transid,'||v_operations||',''General'' cnd,'''||replace(rec.criteria,'''','')||''' criteria  from '
							||v_tablename||' a join '
							||v_subentitytable||' b on a.' ||v_subentitytable||'id=b.'||v_subentitytable||'id '
							||case when v_keyfld_srckey='T' then ' join '||v_keyfld_srctbl||' on '||v_keyfld_srctbl||'.'||v_keyfld_srctbl||'id = a.'||v_keyfld_fname end
							||' where b.cancel=''F'' and '
							||CASE WHEN v_fldname_transidcnd > 0 THEN ' b.transid='''||v_transid||''' and ' end 
							||case when v_keyfld_srckey='T' then v_keyfld_srctbl||'.'||v_keyfld_srcfld else v_keyfld_fname END||'='||v_keyfld_fval
						  ); 
                            
				END IF;
			                                                  
                          
               		 v_final_sqls.EXTEND;
                         v_final_sqls(v_final_sqls.COUNT) := (v_sql);
                

			end loop;	
			

   return v_final_sqls;

END;
>>

<<
CREATE OR REPLACE FUNCTION fn_pegv2_tasklists(pprocessname varchar2, pindexno NUMERIC,ptaskname varchar2 DEFAULT null,ptransid varchar2 DEFAULT null,precordid NUMERIC DEFAULT 0,pusername varchar2 DEFAULT null, ptaskid NUMERIC DEFAULT 0, pkeyvalue varchar2 DEFAULT null)
 RETURN  axpdef_peg_tasklist
IS
recdata_consoliate_array axpdef_peg_tasklist := axpdef_peg_tasklist();
v_sql clob;
BEGIN  
  
v_sql := 'select axpdef_peg_tasklist_obj(taskname) from(SELECT TASKNAME FROM AXPROCESSDEFV2 a WHERE PROCESSNAME  = :1 AND INDEXNO > :2 order by indexno)x';

    
   execute immediate v_sql bulk collect into recdata_consoliate_array using pprocessname,pindexno;


    RETURN recdata_consoliate_array;
    	

END;
>>

<<
CREATE OR REPLACE FUNCTION fn_get_query_cols(pquery IN VARCHAR2)
   RETURN SYS.ODCIVARCHAR2LIST PIPELINED
IS
   v_temp_table_name  VARCHAR2(30) := 'VTMP1';
   v_col_name         VARCHAR2(4000);
   v_sql              VARCHAR2(4000);
BEGIN
   -- Create a temporary table dynamically
   v_sql := 'CREATE GLOBAL TEMPORARY TABLE ' || v_temp_table_name || 
            ' ON COMMIT DELETE ROWS AS ' || pquery || ' WHERE 1 = 0';
   EXECUTE IMMEDIATE v_sql;

   -- Fetch column names from the USER_TAB_COLUMNS view
   FOR col IN (
      SELECT column_name
      FROM USER_TAB_COLUMNS
      WHERE table_name = UPPER(v_temp_table_name)
   )
   LOOP
      PIPE ROW (col.column_name);
   END LOOP;

   -- Drop the temporary table
   EXECUTE IMMEDIATE 'DROP TABLE ' || v_temp_table_name;

   RETURN;
END;
>>

<<
CREATE OR REPLACE FUNCTION GET_SQL_COLUMNS( v_sql IN VARCHAR2)
  RETURN VARCHAR2
IS
  v_string VARCHAR2(4000) := NULL;
  v_cursor_id integer;
  v_col_cnt integer;
  v_columns dbms_sql.desc_tab;
BEGIN
	IF v_sql IS NOT NULL THEN 
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, v_sql, dbms_sql.native);
    dbms_sql.describe_columns(v_cursor_id, v_col_cnt, v_columns);
for i in 1 .. v_columns.count loop
        if v_string IS NULL then
        v_string := v_columns(i).col_name;
        else
        v_string := v_string||','||v_columns(i).col_name;
        end if;
    end loop;
    dbms_sql.close_cursor(v_cursor_id);
   END if;
   RETURN v_string;
exception when others then
    Begin
    dbms_sql.close_cursor(v_cursor_id);
    raise_application_error(-20000, 'Invalid SQL in GET_SQL_COLUMNS');
    end; 
end;
>>

<<
CREATE OR REPLACE FUNCTION fn_axpertjobs_rmqjson(rediskeyname IN varchar2,rmq_version IN varchar2,isactive IN varchar2,rmq_starttime IN varchar2,jobschedule IN varchar2,rmq_interval IN varchar2,rediskeyval IN varchar2)
RETURN nclob
AS
v_json nclob;
BEGIN

	SELECT '{' || '"jobid"'||chr(58)||'"' || rediskeyname || '",'||
  '"version"'||chr(58)||'"' || rmq_version || '",'||
  '"active"'||chr(58)||'"' || isactive || '",'||
  '"starttime"'||chr(58)||'"' || rmq_starttime ||'",'||
  '"sequence"'||chr(58)||'"' || jobschedule || '",'||
  '"interval"'||chr(58)||'"' || rmq_interval || '",'||
  '"jobdata"'||chr(58)||'"' || rediskeyval || '"'||
'}' INTO v_json
FROM dual;

RETURN v_json;


END;
>>

<<
CREATE OR REPLACE TRIGGER AXP_TR_SEARCH_APPSEARCH
before insert or update or delete ON AXP_APPSEARCH_DATA_PERIOD for each row
declare 
cnt number;
begin 
if :new.periodically ='T' or :new.srctable is  null or :new.srcfield is  null then
begin
if inserting  then 
insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(:new.hltype,:new.structname, case when :new.periodically ='T' then :new.searchtext else  :new.caption end ,:new.params,:new.docid);
else if updating then
insert  into axp_appsearch_data_v2 (hltype,structname,searchtext,params,docid) values(:old.hltype,:old.structname, case when :old.periodically ='T' then :old.searchtext else  :old.caption end ,:old.params,:old.docid);
 end if;
  end if;
  
if deleting then 
   delete  axp_appsearch_data_v2 where docid = :old.docid;
   select count(1) into cnt from user_triggers where lower(trigger_name)= lower ( 'axp_sch_'||:old.docid );
   if cnt >0 then
   execute immediate 'drop trigger '||'axp_sch_'||:old.docid;
   end if;
end if;

exception
      when DUP_VAL_ON_INDEX then
      update axp_appsearch_data_v2 set  hltype= :new.hltype , structname = :new.structname,searchtext = case when :new.periodically ='T' then :new.searchtext else  :new.caption end  ,params=:new.params where docid= :new.docid;
   when others then 
 null ;

end ;

end if;

 end ;
>>

<<
CREATE OR REPLACE TRIGGER "TRG_AXACTIVETASKS"  
after INSERT ON axactivetasks
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
 WHEN ((new.grouped IS NULL AND new.assigntoflg=2) OR (new.assigntoflg in(1,4,6,7)) AND NEW.delegation='F' AND NEW.pownerflg='F') DECLARE 
	usercount NUMBER(10);
	v_assignmodecnd NUMBER(10);
	v_defusers varchar2(4000);
	v_datagrpusers varchar2(4000);
	v_usergrpuser varchar2(4000);
	v_initiator_usergrps varchar2(4000);
	v_processonwer_cnt NUMBER(10);
	pragma autonomous_transaction;
BEGIN
/* assigntoflg=
 * 1 - Reporting manager
 * 2 - Assign to Actor
 * 4 - From form field
 * 6 - Skip level
 * 7 - Prior level user
allowsendflg=
 * 1 - None
 * 2 - Any user
 * 3 - Users in this process
 * 4 - Actor
 * */	


-----------------------------Reporint manager,Form field, Skip level, Prior level user
--------------------Delegation | Assignto - Reporting manager, Form field,Skip level, Prior level user & to user is exists 
if :NEW.assigntoflg in('1','4','6','7') and :NEW.touser is NOT null and :NEW.grouped is NOT null AND :NEW.delegation='F' AND :NEW.pownerflg='F'THEN

	insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
	transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
	displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
	useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,
	pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder,
	displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,sendtoactor,initiator_approval,
	usebusinessdatelogic,initonbehalf,autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 								
	select :NEW.eventdatetime,:NEW.taskid,:NEW.processname,:NEW.tasktype,:NEW.taskname,:NEW.taskdescription,:NEW.assigntorole,:NEW.transid,:NEW.keyfield,:NEW.execonapprove,
	:NEW.keyvalue,:NEW.transdata,:NEW.fromrole,:NEW.fromuser,c.tousername,:NEW.priorindex,:NEW.priortaskname,:NEW.corpdimension,:NEW.orgdimension,:NEW.department,
	:NEW.grade,:NEW.datavalue,:NEW.displayicon,:NEW.displaytitle,:NEW.displaysubtitle,:NEW.displaycontent,:NEW.displaybuttons,:NEW.groupfield,:NEW.groupvalue,
	:NEW.priorusername,:NEW.initiator,:NEW.mapfieldvalue,:NEW.useridentificationfilter,:NEW.useridentificationfilter_of,:NEW.mapfield_group,:NEW.mapfield,'T',
	:NEW.indexno,:NEW.subindexno,:NEW.processowner,:NEW.assigntoflg,:NEW.assigntoactor,:NEW.actorfilter,:NEW.recordid,:NEW.processownerflg,:NEW.pownerfilter,
	:NEW.approvereasons,:NEW.defapptext,:NEW.returnreasons,:NEW.defrettext,:NEW.rejectreasons,:NEW.defregtext,:NEW.approvalcomments,:NEW.rejectcomments,
	:NEW.returncomments,:NEW.escalation,:NEW.reminder,:NEW.displaymcontent,:NEW.groupwithpriorindex,'T',:NEW.returnable,:NEW.allowsend,:NEW.allowsendflg,
	:NEW.sendtoactor,:NEW.initiator_approval,:NEW.usebusinessdatelogic,:NEW.initonbehalf,:NEW.autoapprove,
	:NEW.isoptional,:NEW.Reminderstartdate,:NEW.Escalationstartdate,:NEW.reminderjsondata,:NEW.escalationjsondata			
	from axprocessdef_delegation c 
	where c.fromusername = :NEW.touser
	and sysdate >= c.fromdate
	and sysdate <= c.todate;
	COMMIT;
END IF;
-------------- Assignto - Reporting manager, Form field,Skip level, Prior level user & to user is not exists
if :NEW.assigntoflg in('1','4','6','7') and :NEW.touser is null and :NEW.grouped is null THEN

	select count(*) into v_processonwer_cnt
	from axuserlevelgroups c
	where c.usergroup = :NEW.processowner		
	and ((c.startdate is not null and SYSDATE  >= c.startdate) or (c.startdate is null)) 
	and ((c.enddate is not null and SYSDATE <= c.enddate) or (c.enddate is null));

	if v_processonwer_cnt > 0 then	---- Process owner USER EXISTS
	
		insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
		keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
		displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
		useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
		assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
		approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
		allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,isoptional,
		Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
		select :NEW.eventdatetime,:NEW.taskid,:NEW.processname,:NEW.tasktype,:NEW.taskname,:NEW.taskdescription,:NEW.assigntorole,:NEW.transid,:NEW.keyfield,
		:NEW.execonapprove,:NEW.keyvalue,:NEW.transdata,:NEW.fromrole,:NEW.fromuser,c.username,:NEW.priorindex,:NEW.priortaskname,:NEW.corpdimension,
		:NEW.orgdimension,:NEW.department,:NEW.grade,:NEW.datavalue,:NEW.displayicon,:NEW.displaytitle,:NEW.displaysubtitle,:NEW.displaycontent,
		:NEW.displaybuttons,:NEW.groupfield,:NEW.groupvalue,:NEW.priorusername,:NEW.initiator,:NEW.mapfieldvalue,	:NEW.useridentificationfilter,
		:NEW.useridentificationfilter_of,:NEW.mapfield_group,:NEW.mapfield,'T',:NEW.indexno,:NEW.subindexno,
		:NEW.processowner,:NEW.assigntoflg,:NEW.assigntoactor,:NEW.actorfilter,:NEW.recordid,:NEW.processownerflg,:NEW.pownerfilter,
		:NEW.approvereasons,:NEW.defapptext,:NEW.returnreasons,:NEW.defrettext,:NEW.rejectreasons,:NEW.defregtext,
		:NEW.approvalcomments,:NEW.rejectcomments,:NEW.returncomments,:NEW.escalation,:NEW.reminder,:NEW.displaymcontent,:NEW.groupwithpriorindex,:NEW.returnable,
		:NEW.allowsend,:NEW.allowsendflg,:NEW.sendtoactor,:NEW.initiator_approval,:NEW.usebusinessdatelogic,:NEW.initonbehalf,'T',
		:NEW.autoapprove,:NEW.isoptional,:NEW.Reminderstartdate,:NEW.Escalationstartdate,:NEW.reminderjsondata,:NEW.escalationjsondata
		from axuserlevelgroups c
		where c.usergroup = :NEW.processowner		
		and ((c.startdate is not null and sysdate  >= c.startdate) or (c.startdate is null)) 
		and ((c.enddate is not null and sysdate <= c.enddate) or (c.enddate is null));
		--------------Delegation | Process owner			
		insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
		transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
		displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
		useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,
		pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder,
		displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,sendtoactor,initiator_approval,
		usebusinessdatelogic,initonbehalf,autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 								
		select :NEW.eventdatetime,:NEW.taskid,:NEW.processname,:NEW.tasktype,:NEW.taskname,:NEW.taskdescription,:NEW.assigntorole,:NEW.transid,:NEW.keyfield,:NEW.execonapprove,
		:NEW.keyvalue,:NEW.transdata,:NEW.fromrole,:NEW.fromuser,c.tousername,:NEW.priorindex,:NEW.priortaskname,:NEW.corpdimension,:NEW.orgdimension,:NEW.department,
		:NEW.grade,:NEW.datavalue,:NEW.displayicon,:NEW.displaytitle,:NEW.displaysubtitle,:NEW.displaycontent,:NEW.displaybuttons,:NEW.groupfield,:NEW.groupvalue,
		:NEW.priorusername,:NEW.initiator,:NEW.mapfieldvalue,:NEW.useridentificationfilter,:NEW.useridentificationfilter_of,:NEW.mapfield_group,:NEW.mapfield,'T',
		:NEW.indexno,:NEW.subindexno,:NEW.processowner,:NEW.assigntoflg,:NEW.assigntoactor,:NEW.actorfilter,:NEW.recordid,:NEW.processownerflg,:NEW.pownerfilter,
		:NEW.approvereasons,:NEW.defapptext,:NEW.returnreasons,:NEW.defrettext,:NEW.rejectreasons,:NEW.defregtext,:NEW.approvalcomments,:NEW.rejectcomments,
		:NEW.returncomments,:NEW.escalation,:NEW.reminder,:NEW.displaymcontent,:NEW.groupwithpriorindex,'T',:NEW.returnable,:NEW.allowsend,:NEW.allowsendflg,
		:NEW.sendtoactor,:NEW.initiator_approval,:NEW.usebusinessdatelogic,:NEW.initonbehalf,:NEW.autoapprove,
		:NEW.isoptional,:NEW.Reminderstartdate,:NEW.Escalationstartdate,:NEW.reminderjsondata,:NEW.escalationjsondata			
		from axprocessdef_delegation c,axuserlevelgroups d 
		where d.usergroup = :NEW.processowner		
		and ((d.startdate is not null and sysdate  >= d.startdate) or (d.startdate is null)) 
		and ((d.enddate is not null and sysdate <= d.enddate) or (d.enddate is null))
		and	c.fromusername = d.username	
		and sysdate >= c.fromdate
		and sysdate <= c.todate;
		COMMIT;
	ELSE
		
		---Redirect to default role when no users exists in process owner
		insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
		keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
		displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
		useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
		assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
		approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
		allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,isoptional,
		Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
		select :NEW.eventdatetime,:NEW.taskid,:NEW.processname,:NEW.tasktype,:NEW.taskname,:NEW.taskdescription,:NEW.assigntorole,:NEW.transid,:NEW.keyfield,
		:NEW.execonapprove,:NEW.keyvalue,:NEW.transdata,:NEW.fromrole,:NEW.fromuser,c.username,:NEW.priorindex,:NEW.priortaskname,:NEW.corpdimension,
		:NEW.orgdimension,:NEW.department,:NEW.grade,:NEW.datavalue,:NEW.displayicon,:NEW.displaytitle,:NEW.displaysubtitle,:NEW.displaycontent,
		:NEW.displaybuttons,:NEW.groupfield,:NEW.groupvalue,:NEW.priorusername,:NEW.initiator,:NEW.mapfieldvalue,	:NEW.useridentificationfilter,
		:NEW.useridentificationfilter_of,:NEW.mapfield_group,:NEW.mapfield,'T',:NEW.indexno,:NEW.subindexno,
		:NEW.processowner,:NEW.assigntoflg,:NEW.assigntoactor,:NEW.actorfilter,:NEW.recordid,:NEW.processownerflg,:NEW.pownerfilter,
		:NEW.approvereasons,:NEW.defapptext,:NEW.returnreasons,:NEW.defrettext,:NEW.rejectreasons,:NEW.defregtext,
		:NEW.approvalcomments,:NEW.rejectcomments,:NEW.returncomments,:NEW.escalation,:NEW.reminder,:NEW.displaymcontent,:NEW.groupwithpriorindex,:NEW.returnable,
		:NEW.allowsend,:NEW.allowsendflg,:NEW.sendtoactor,:NEW.initiator_approval,:NEW.usebusinessdatelogic,:NEW.initonbehalf,'T',
		:NEW.autoapprove,:NEW.isoptional,:NEW.Reminderstartdate,:NEW.Escalationstartdate,:NEW.reminderjsondata,:NEW.escalationjsondata
		from axuserlevelgroups c
		where c.usergroup = 'default'		
		and ((c.startdate is not null and sysdate >= c.startdate) or (c.startdate is null)) 
		and ((c.enddate is not null and sysdate  <= c.enddate) or (c.enddate is null));
		COMMIT;
	end if;
end if;	

-----------------------------Actor
if :new.assigntoflg ='2' then 

	select coalesce(assignmodecnd,0) assignmodecnd,defusername,count(distinct TRIM(REGEXP_SUBSTR(defusername, '[^,]+', 1, LEVEL))) 	
	into v_assignmodecnd,v_defusers ,usercount
	from axpdef_peg_actor a
	where a.actorname=:new.assigntoactor
	CONNECT BY REGEXP_SUBSTR (defusername,'[^,]+',1,LEVEL) IS NOT NULL
	GROUP BY coalesce(assignmodecnd,0) ,defusername;
------------------------------------Default user
	if v_assignmodecnd = 1 AND usercount > 0 then 
		--INSERT INTO ORCTEST values('assigntoflg=2|v_assignmodecnd = 1','',0);	
		insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
		keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,
		displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
		useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,
		actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,
		rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,allowsendflg,sendtoactor,
		initiator_approval,usebusinessdatelogic,initonbehalf,actor_default_users,autoapprove,isoptional,
		Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
		select :new.eventdatetime,:new.taskid,:new.processname,:new.tasktype,:new.taskname,:new.taskdescription,:new.assigntorole,:new.transid,:new.keyfield,
		:new.execonapprove,:new.keyvalue,:new.transdata,:new.fromrole,:new.fromuser,TRIM(REGEXP_SUBSTR(v_defusers, '[^,]+', 1, LEVEL)),:new.priorindex,:new.priortaskname,
		:new.corpdimension,:new.orgdimension,:new.department,:new.grade,:new.datavalue,:new.displayicon,:new.displaytitle,:new.displaysubtitle,
		:new.displaycontent,:new.displaybuttons,:new.groupfield,:new.groupvalue,:new.priorusername,:new.initiator,:new.mapfieldvalue,
		:new.useridentificationfilter,:new.useridentificationfilter_of,:new.mapfield_group,:new.mapfield,'T',:new.indexno,:new.subindexno,
		:new.processowner,:new.assigntoflg,:new.assigntoactor,	:new.actorfilter,:new.recordid,:new.processownerflg,:new.pownerfilter,:new.approvereasons,
		:new.defapptext,:new.returnreasons,:new.defrettext,:new.rejectreasons,:new.defregtext,:new.approvalcomments,:new.rejectcomments,:new.returncomments,
		:new.escalation,:new.reminder,:new.displaymcontent,:new.groupwithpriorindex,:new.returnable,:new.allowsend,:new.allowsendflg,:new.sendtoactor,
		:new.initiator_approval,:new.usebusinessdatelogic,:new.initonbehalf,'T' ,:new.autoapprove,
		:new.isoptional,:new.Reminderstartdate,:new.Escalationstartdate,:new.reminderjsondata,:new.escalationjsondata
		from dual CONNECT BY REGEXP_SUBSTR (v_defusers,'[^,]+',1,LEVEL) IS NOT NULL;
--------------------Delegation(Default users)
		insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
		transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
		displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
		useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,
		recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,
		rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,
		sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,autoapprove,isoptional,
		Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
		select :new.eventdatetime,:new.taskid,:new.processname,:new.tasktype,:new.taskname,:new.taskdescription,:new.assigntorole,:new.transid,
		:new.keyfield,:new.execonapprove,:new.keyvalue,:new.transdata,:new.fromrole,:new.fromuser,c.tousername,:new.priorindex,:new.priortaskname,
		:new.corpdimension,:new.orgdimension,:new.department,:new.grade,:new.datavalue,:new.displayicon,:new.displaytitle,:new.displaysubtitle,
		:new.displaycontent,:new.displaybuttons,:new.groupfield,:new.groupvalue,:new.priorusername,:new.initiator,:new.mapfieldvalue,
		:new.useridentificationfilter,:new.useridentificationfilter_of,:new.mapfield_group,:new.mapfield,'T',:new.indexno,:new.subindexno,
		:new.processowner,:new.assigntoflg,:new.assigntoactor,:new.actorfilter,:new.recordid,:new.processownerflg,:new.pownerfilter,
		:new.approvereasons,:new.defapptext,:new.returnreasons,:new.defrettext,:new.rejectreasons,:new.defregtext,:new.approvalcomments,
		:new.rejectcomments,:new.returncomments,:new.escalation,:new.reminder,:new.displaymcontent,:new.groupwithpriorindex,'T',:new.returnable,
		:new.allowsend,:new.allowsendflg,:new.sendtoactor,:new.initiator_approval,:new.usebusinessdatelogic,:new.initonbehalf,:new.autoapprove,
		:new.isoptional,:new.Reminderstartdate,:new.Escalationstartdate,:new.reminderjsondata,:new.escalationjsondata
		from 
		(select  TRIM(REGEXP_SUBSTR(v_defusers, '[^,]+', 1, LEVEL)) fuser from dual CONNECT BY REGEXP_SUBSTR (v_defusers,'[^,]+',1,LEVEL) IS NOT NULL)a,
		axprocessdef_delegation c where a.fuser = c.fromusername and current_date  >= c.fromdate	and current_date  <= c.todate;	
		COMMIT;
	ELSIF v_assignmodecnd = 1 AND usercount = 0 then
		--INSERT INTO ORCTEST values('assigntoflg=2|v_assignmodecnd = 1|Powner','',0);	
		select count(*) into v_processonwer_cnt
		from axuserlevelgroups c
		where c.usergroup = :NEW.processowner		
		and ((c.startdate is not null and SYSDATE  >= c.startdate) or (c.startdate is null)) 
		and ((c.enddate is not null and SYSDATE <= c.enddate) or (c.enddate is null));		
		if v_processonwer_cnt > 0 then	---- Process owner USER EXISTS
			
			insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
			keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
			displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
			useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
			assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
			approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
			allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,isoptional,
			Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
			select :NEW.eventdatetime,:NEW.taskid,:NEW.processname,:NEW.tasktype,:NEW.taskname,:NEW.taskdescription,:NEW.assigntorole,:NEW.transid,:NEW.keyfield,
			:NEW.execonapprove,:NEW.keyvalue,:NEW.transdata,:NEW.fromrole,:NEW.fromuser,c.username,:NEW.priorindex,:NEW.priortaskname,:NEW.corpdimension,
			:NEW.orgdimension,:NEW.department,:NEW.grade,:NEW.datavalue,:NEW.displayicon,:NEW.displaytitle,:NEW.displaysubtitle,:NEW.displaycontent,
			:NEW.displaybuttons,:NEW.groupfield,:NEW.groupvalue,:NEW.priorusername,:NEW.initiator,:NEW.mapfieldvalue,	:NEW.useridentificationfilter,
			:NEW.useridentificationfilter_of,:NEW.mapfield_group,:NEW.mapfield,'T',:NEW.indexno,:NEW.subindexno,
			:NEW.processowner,:NEW.assigntoflg,:NEW.assigntoactor,:NEW.actorfilter,:NEW.recordid,:NEW.processownerflg,:NEW.pownerfilter,
			:NEW.approvereasons,:NEW.defapptext,:NEW.returnreasons,:NEW.defrettext,:NEW.rejectreasons,:NEW.defregtext,
			:NEW.approvalcomments,:NEW.rejectcomments,:NEW.returncomments,:NEW.escalation,:NEW.reminder,:NEW.displaymcontent,:NEW.groupwithpriorindex,:NEW.returnable,
			:NEW.allowsend,:NEW.allowsendflg,:NEW.sendtoactor,:NEW.initiator_approval,:NEW.usebusinessdatelogic,:NEW.initonbehalf,'T',
			:NEW.autoapprove,:NEW.isoptional,:NEW.Reminderstartdate,:NEW.Escalationstartdate,:NEW.reminderjsondata,:NEW.escalationjsondata
			from axuserlevelgroups c
			where c.usergroup = :NEW.processowner		
			and ((c.startdate is not null and sysdate  >= c.startdate) or (c.startdate is null)) 
			and ((c.enddate is not null and sysdate <= c.enddate) or (c.enddate is null));
------------------------------Delegation | Process owner			
			insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
			transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
			displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
			useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,
			pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder,
			displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,sendtoactor,initiator_approval,
			usebusinessdatelogic,initonbehalf,autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 								
			select :NEW.eventdatetime,:NEW.taskid,:NEW.processname,:NEW.tasktype,:NEW.taskname,:NEW.taskdescription,:NEW.assigntorole,:NEW.transid,:NEW.keyfield,:NEW.execonapprove,
			:NEW.keyvalue,:NEW.transdata,:NEW.fromrole,:NEW.fromuser,c.tousername,:NEW.priorindex,:NEW.priortaskname,:NEW.corpdimension,:NEW.orgdimension,:NEW.department,
			:NEW.grade,:NEW.datavalue,:NEW.displayicon,:NEW.displaytitle,:NEW.displaysubtitle,:NEW.displaycontent,:NEW.displaybuttons,:NEW.groupfield,:NEW.groupvalue,
			:NEW.priorusername,:NEW.initiator,:NEW.mapfieldvalue,:NEW.useridentificationfilter,:NEW.useridentificationfilter_of,:NEW.mapfield_group,:NEW.mapfield,'T',
			:NEW.indexno,:NEW.subindexno,:NEW.processowner,:NEW.assigntoflg,:NEW.assigntoactor,:NEW.actorfilter,:NEW.recordid,:NEW.processownerflg,:NEW.pownerfilter,
			:NEW.approvereasons,:NEW.defapptext,:NEW.returnreasons,:NEW.defrettext,:NEW.rejectreasons,:NEW.defregtext,:NEW.approvalcomments,:NEW.rejectcomments,
			:NEW.returncomments,:NEW.escalation,:NEW.reminder,:NEW.displaymcontent,:NEW.groupwithpriorindex,'T',:NEW.returnable,:NEW.allowsend,:NEW.allowsendflg,
			:NEW.sendtoactor,:NEW.initiator_approval,:NEW.usebusinessdatelogic,:NEW.initonbehalf,:NEW.autoapprove,
			:NEW.isoptional,:NEW.Reminderstartdate,:NEW.Escalationstartdate,:NEW.reminderjsondata,:NEW.escalationjsondata			
			from axprocessdef_delegation c,axuserlevelgroups d 
			where d.usergroup = :NEW.processowner		
			and ((d.startdate is not null and sysdate  >= d.startdate) or (d.startdate is null)) 
			and ((d.enddate is not null and sysdate <= d.enddate) or (d.enddate is null))
			and	c.fromusername = d.username	
			and sysdate >= c.fromdate
			and sysdate <= c.todate;
			COMMIT;
		ELSE
					
---------------------Redirect to default role when no users exists in process owner
			insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
			keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
			displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
			useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
			assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
			approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
			allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,isoptional,
			Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
			select :NEW.eventdatetime,:NEW.taskid,:NEW.processname,:NEW.tasktype,:NEW.taskname,:NEW.taskdescription,:NEW.assigntorole,:NEW.transid,:NEW.keyfield,
			:NEW.execonapprove,:NEW.keyvalue,:NEW.transdata,:NEW.fromrole,:NEW.fromuser,c.username,:NEW.priorindex,:NEW.priortaskname,:NEW.corpdimension,
			:NEW.orgdimension,:NEW.department,:NEW.grade,:NEW.datavalue,:NEW.displayicon,:NEW.displaytitle,:NEW.displaysubtitle,:NEW.displaycontent,
			:NEW.displaybuttons,:NEW.groupfield,:NEW.groupvalue,:NEW.priorusername,:NEW.initiator,:NEW.mapfieldvalue,	:NEW.useridentificationfilter,
			:NEW.useridentificationfilter_of,:NEW.mapfield_group,:NEW.mapfield,'T',:NEW.indexno,:NEW.subindexno,
			:NEW.processowner,:NEW.assigntoflg,:NEW.assigntoactor,:NEW.actorfilter,:NEW.recordid,:NEW.processownerflg,:NEW.pownerfilter,
			:NEW.approvereasons,:NEW.defapptext,:NEW.returnreasons,:NEW.defrettext,:NEW.rejectreasons,:NEW.defregtext,
			:NEW.approvalcomments,:NEW.rejectcomments,:NEW.returncomments,:NEW.escalation,:NEW.reminder,:NEW.displaymcontent,:NEW.groupwithpriorindex,:NEW.returnable,
			:NEW.allowsend,:NEW.allowsendflg,:NEW.sendtoactor,:NEW.initiator_approval,:NEW.usebusinessdatelogic,:NEW.initonbehalf,'T',
			:NEW.autoapprove,:NEW.isoptional,:NEW.Reminderstartdate,:NEW.Escalationstartdate,:NEW.reminderjsondata,:NEW.escalationjsondata
			from axuserlevelgroups c
			where c.usergroup = 'default'		
			and ((c.startdate is not null and sysdate >= c.startdate) or (c.startdate is null)) 
			and ((c.enddate is not null and sysdate  <= c.enddate) or (c.enddate is null));
			COMMIT;
			end if;				
	END IF;

---------------------------------User group
	if v_assignmodecnd = 2 THEN
				select distinct listagg(usergroupname,',') WITHIN GROUP(ORDER BY usergroupname) into  v_initiator_usergrps 
		from axpdef_peg_usergroups 
		where username = case when length(:NEW.initonbehalf)>1 then :NEW.initonbehalf else  :NEW.initiator END and active='T' 
		and effectivefrom <= sysdate;
		----------- Check approval users are assigned for the initiator's group
		select listagg(ugrpname,'|') WITHIN GROUP(ORDER BY usergroupname),count(*) into v_usergrpuser,usercount
		from (		
		select distinct b.usergroupname, b.ugrpusername unames,b.usergroupname||'~~'||b.ugrpusername ugrpname
		from axpdef_peg_actor a
		join axpdef_peg_actorusergrp b on a.axpdef_peg_actorid=b.axpdef_peg_actorid
		where a.actorname = :NEW.assigntoactor 
		and b.usergroupname in (select  TRIM(REGEXP_SUBSTR(v_initiator_usergrps, '[^,]+', 1, LEVEL)) fuser from dual CONNECT BY REGEXP_SUBSTR (v_initiator_usergrps,'[^,]+',1,LEVEL) IS NOT NULL)				
		ORDER BY 1);				
		if usercount > 0 then 
						FOR rec  IN (SELECT TRIM(REGEXP_SUBSTR(split_value, '[^~~]+', 1, 1))ugrpname,TRIM(REGEXP_SUBSTR(split_value, '[^~~]+', 1, 2)) ugrpusers	FROM 
			(SELECT TRIM(REGEXP_SUBSTR(v_usergrpuser, '[^|]+', 1, LEVEL)) AS split_value
			from dual CONNECT BY REGEXP_SUBSTR (v_usergrpuser,'[^|]+',1,LEVEL) IS NOT NULL)) LOOP 
					
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
				transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
				displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
				useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,
				processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,
				returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,
				allowsend,allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,actor_user_groups,
				autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select :new.eventdatetime,:new.taskid,:new.processname,:new.tasktype,:new.taskname,:new.taskdescription,:new.assigntorole,:new.transid,:new.keyfield,
				:new.execonapprove,:new.keyvalue,:new.transdata,:new.fromrole,:new.fromuser,TRIM(REGEXP_SUBSTR(rec.ugrpusers, '[^,]+', 1, LEVEL)),:new.priorindex,:new.priortaskname,
				:new.corpdimension,:new.orgdimension,:new.department,:new.grade,:new.datavalue,:new.displayicon,:new.displaytitle,:new.displaysubtitle,:new.displaycontent,
				:new.displaybuttons,:new.groupfield,:new.groupvalue,:new.priorusername,:new.initiator,:new.mapfieldvalue,:new.useridentificationfilter,
				:new.useridentificationfilter_of,:new.mapfield_group,:new.mapfield,'T',:new.indexno,:new.subindexno,:new.processowner,:new.assigntoflg,:new.assigntoactor,
				:new.actorfilter,:new.recordid,:new.processownerflg,:new.pownerfilter,:new.approvereasons,:new.defapptext,:new.returnreasons,:new.defrettext,
				:new.rejectreasons,:new.defregtext,:new.approvalcomments,:new.rejectcomments,:new.returncomments,:new.escalation,:new.reminder,:new.displaymcontent,
				:new.groupwithpriorindex,:new.returnable,:new.allowsend,:new.allowsendflg,:new.sendtoactor,:new.initiator_approval,:new.usebusinessdatelogic,
				:new.initonbehalf,rec.ugrpname,:new.autoapprove,:new.isoptional,:new.Reminderstartdate,
				:new.Escalationstartdate,:new.reminderjsondata,:new.escalationjsondata
				from dual CONNECT BY REGEXP_SUBSTR (rec.ugrpusers,'[^,]+',1,LEVEL) IS NOT NULL;
			
				----Delegation(User groups)
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
				transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
				displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
				useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,
				recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,
				rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,
				sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,autoapprove,isoptional,
				Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select :new.eventdatetime,:new.taskid,:new.processname,:new.tasktype,:new.taskname,:new.taskdescription,:new.assigntorole,:new.transid,
				:new.keyfield,:new.execonapprove,:new.keyvalue,:new.transdata,:new.fromrole,:new.fromuser,c.tousername,:new.priorindex,:new.priortaskname,
				:new.corpdimension,:new.orgdimension,:new.department,:new.grade,:new.datavalue,:new.displayicon,:new.displaytitle,:new.displaysubtitle,
				:new.displaycontent,:new.displaybuttons,:new.groupfield,:new.groupvalue,:new.priorusername,:new.initiator,:new.mapfieldvalue,
				:new.useridentificationfilter,:new.useridentificationfilter_of,:new.mapfield_group,:new.mapfield,'T',:new.indexno,:new.subindexno,
				:new.processowner,:new.assigntoflg,:new.assigntoactor,:new.actorfilter,:new.recordid,:new.processownerflg,:new.pownerfilter,
				:new.approvereasons,:new.defapptext,:new.returnreasons,:new.defrettext,:new.rejectreasons,:new.defregtext,:new.approvalcomments,
				:new.rejectcomments,:new.returncomments,:new.escalation,:new.reminder,:new.displaymcontent,:new.groupwithpriorindex,'T',:new.returnable,
				:new.allowsend,:new.allowsendflg,:new.sendtoactor,:new.initiator_approval,:new.usebusinessdatelogic,:new.initonbehalf,:new.autoapprove,
				:new.isoptional,:new.Reminderstartdate,:new.Escalationstartdate,:new.reminderjsondata,:new.escalationjsondata
				FROM (select  TRIM(REGEXP_SUBSTR(rec.ugrpusers, '[^,]+', 1, LEVEL)) fuser from dual CONNECT BY REGEXP_SUBSTR (rec.ugrpusers,'[^,]+',1,LEVEL) IS NOT NULL)a,
				axprocessdef_delegation c where a.fuser = c.fromusername and current_date  >= c.fromdate	and current_date  <= c.todate;	
				--INSERT INTO ORCTEST values('For_Loop',rec.ugrpusers,0);COMMIT;
			END LOOP;
		ELSE					
		select count(*) into v_processonwer_cnt
		from axuserlevelgroups c
		where c.usergroup = :new.processowner		
		and ((c.startdate is not null and SYSDATE  >= c.startdate) or (c.startdate is null)) 
		and ((c.enddate is not null and SYSDATE <= c.enddate) or (c.enddate is null));		
			if v_processonwer_cnt > 0 then	---- Process owner USER EXISTS
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
				keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
				displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
				useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
				assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
				approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
				allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,isoptional,
				Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select :new.eventdatetime,:new.taskid,:new.processname,:new.tasktype,:new.taskname,:new.taskdescription,:new.assigntorole,:new.transid,:new.keyfield,
				:new.execonapprove,:new.keyvalue,:new.transdata,:new.fromrole,:new.fromuser,c.username,:new.priorindex,:new.priortaskname,:new.corpdimension,
				:new.orgdimension,:new.department,:new.grade,:new.datavalue,:new.displayicon,:new.displaytitle,:new.displaysubtitle,:new.displaycontent,
				:new.displaybuttons,:new.groupfield,:new.groupvalue,:new.priorusername,:new.initiator,:new.mapfieldvalue,	:new.useridentificationfilter,
				:new.useridentificationfilter_of,:new.mapfield_group,:new.mapfield,'T',:new.indexno,:new.subindexno,
				:new.processowner,:new.assigntoflg,:new.assigntoactor,:new.actorfilter,:new.recordid,:new.processownerflg,:new.pownerfilter,
				:new.approvereasons,:new.defapptext,:new.returnreasons,:new.defrettext,:new.rejectreasons,:new.defregtext,
				:new.approvalcomments,:new.rejectcomments,:new.returncomments,:new.escalation,:new.reminder,:new.displaymcontent,:new.groupwithpriorindex,:new.returnable,
				:new.allowsend,:new.allowsendflg,:new.sendtoactor,:new.initiator_approval,:new.usebusinessdatelogic,:new.initonbehalf,'T',
				:new.autoapprove,:new.isoptional,:new.Reminderstartdate,:new.Escalationstartdate,:new.reminderjsondata,:new.escalationjsondata
				from axuserlevelgroups c where c.usergroup = :new.processowner and ((c.startdate is not null and sysdate  >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and sysdate <= c.enddate) or (c.enddate is null));
------------------------------Delegation | Process owner			
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
				transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
				displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
				useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,
				pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder,
				displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,sendtoactor,initiator_approval,
				usebusinessdatelogic,initonbehalf,autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 								
				select :new.eventdatetime,:new.taskid,:new.processname,:new.tasktype,:new.taskname,:new.taskdescription,:new.assigntorole,:new.transid,:new.keyfield,:new.execonapprove,
				:new.keyvalue,:new.transdata,:new.fromrole,:new.fromuser,c.tousername,:new.priorindex,:new.priortaskname,:new.corpdimension,:new.orgdimension,:new.department,
				:new.grade,:new.datavalue,:new.displayicon,:new.displaytitle,:new.displaysubtitle,:new.displaycontent,:new.displaybuttons,:new.groupfield,:new.groupvalue,
				:new.priorusername,:new.initiator,:new.mapfieldvalue,:new.useridentificationfilter,:new.useridentificationfilter_of,:new.mapfield_group,:new.mapfield,'T',
				:new.indexno,:new.subindexno,:new.processowner,:new.assigntoflg,:new.assigntoactor,:new.actorfilter,:new.recordid,:new.processownerflg,:new.pownerfilter,
				:new.approvereasons,:new.defapptext,:new.returnreasons,:new.defrettext,:new.rejectreasons,:new.defregtext,:new.approvalcomments,:new.rejectcomments,
				:new.returncomments,:new.escalation,:new.reminder,:new.displaymcontent,:new.groupwithpriorindex,'T',:new.returnable,:new.allowsend,:new.allowsendflg,
				:new.sendtoactor,:new.initiator_approval,:new.usebusinessdatelogic,:new.initonbehalf,:new.autoapprove,
				:new.isoptional,:new.Reminderstartdate,:new.Escalationstartdate,:new.reminderjsondata,:new.escalationjsondata			
				from axprocessdef_delegation c,axuserlevelgroups d 
				where d.usergroup = :new.processowner and ((d.startdate is not null and sysdate  >= d.startdate) or (d.startdate is null)) 
				and ((d.enddate is not null and sysdate <= d.enddate) or (d.enddate is null))
				and	c.fromusername = d.username	and sysdate >= c.fromdate and sysdate <= c.todate;
			COMMIT;
			ELSE
---------------------Redirect to default role when no users exists in process owner
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
				keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
				displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
				useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
				assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
				approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
				allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,isoptional,
				Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select :new.eventdatetime,:new.taskid,:new.processname,:new.tasktype,:new.taskname,:new.taskdescription,:new.assigntorole,:new.transid,:new.keyfield,
				:new.execonapprove,:new.keyvalue,:new.transdata,:new.fromrole,:new.fromuser,c.username,:new.priorindex,:new.priortaskname,:new.corpdimension,
				:new.orgdimension,:new.department,:new.grade,:new.datavalue,:new.displayicon,:new.displaytitle,:new.displaysubtitle,:new.displaycontent,
				:new.displaybuttons,:new.groupfield,:new.groupvalue,:new.priorusername,:new.initiator,:new.mapfieldvalue,	:new.useridentificationfilter,
				:new.useridentificationfilter_of,:new.mapfield_group,:new.mapfield,'T',:new.indexno,:new.subindexno,
				:new.processowner,:new.assigntoflg,:new.assigntoactor,:new.actorfilter,:new.recordid,:new.processownerflg,:new.pownerfilter,
				:new.approvereasons,:new.defapptext,:new.returnreasons,:new.defrettext,:new.rejectreasons,:new.defregtext,
				:new.approvalcomments,:new.rejectcomments,:new.returncomments,:new.escalation,:new.reminder,:new.displaymcontent,:new.groupwithpriorindex,:new.returnable,
				:new.allowsend,:new.allowsendflg,:new.sendtoactor,:new.initiator_approval,:new.usebusinessdatelogic,:new.initonbehalf,'T',
				:new.autoapprove,:new.isoptional,:new.Reminderstartdate,:new.Escalationstartdate,:new.reminderjsondata,:new.escalationjsondata
				from axuserlevelgroups c
				where c.usergroup = 'default' and ((c.startdate is not null and sysdate >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and sysdate  <= c.enddate) or (c.enddate is null));
				COMMIT;
			end if;		
		END IF;
	END IF;
--------------------------------Data group
	if v_assignmodecnd = 3 then 	
	
	SELECT FN_PEG_ASSIGNTOACTOR(:NEW.assigntoactor,:NEW.ACTORFILTER) INTO v_datagrpusers FROM dual;
		if v_datagrpusers != '0' THEN
			FOR rec  IN (SELECT TRIM(REGEXP_SUBSTR(split_value, '[^~~]+', 1, 1))ugrpname,TRIM(REGEXP_SUBSTR(split_value, '[^~~]+', 1, 2)) ugrpusers	FROM 
			(SELECT TRIM(REGEXP_SUBSTR(v_datagrpusers, '[^|]+', 1, LEVEL)) AS split_value
			from dual CONNECT BY REGEXP_SUBSTR (v_datagrpusers,'[^|]+',1,LEVEL) IS NOT NULL)) LOOP 
															
			insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
			transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
			displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
			useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,
			processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,
			returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,
			allowsend,allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,actor_user_groups,
			autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
			select :new.eventdatetime,:new.taskid,:new.processname,:new.tasktype,:new.taskname,:new.taskdescription,:new.assigntorole,:new.transid,:new.keyfield,
			:new.execonapprove,:new.keyvalue,:new.transdata,:new.fromrole,:new.fromuser,TRIM(REGEXP_SUBSTR(rec.ugrpusers, '[^,]+', 1, LEVEL)),:new.priorindex,:new.priortaskname,
			:new.corpdimension,:new.orgdimension,:new.department,:new.grade,:new.datavalue,:new.displayicon,:new.displaytitle,:new.displaysubtitle,:new.displaycontent,
			:new.displaybuttons,:new.groupfield,:new.groupvalue,:new.priorusername,:new.initiator,:new.mapfieldvalue,:new.useridentificationfilter,
			:new.useridentificationfilter_of,:new.mapfield_group,:new.mapfield,'T',:new.indexno,:new.subindexno,:new.processowner,:new.assigntoflg,:new.assigntoactor,
			:new.actorfilter,:new.recordid,:new.processownerflg,:new.pownerfilter,:new.approvereasons,:new.defapptext,:new.returnreasons,:new.defrettext,
			:new.rejectreasons,:new.defregtext,:new.approvalcomments,:new.rejectcomments,:new.returncomments,:new.escalation,:new.reminder,:new.displaymcontent,
			:new.groupwithpriorindex,:new.returnable,:new.allowsend,:new.allowsendflg,:new.sendtoactor,:new.initiator_approval,:new.usebusinessdatelogic,
			:new.initonbehalf,rec.ugrpname,:new.autoapprove,:new.isoptional,:new.Reminderstartdate,
			:new.Escalationstartdate,:new.reminderjsondata,:new.escalationjsondata
			from dual CONNECT BY REGEXP_SUBSTR (rec.ugrpusers,'[^,]+',1,LEVEL) IS NOT NULL;
			
			----Delegation(User groups)
			insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
			transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
			displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
			useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,
			recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,
			rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,
			sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,autoapprove,isoptional,
			Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
			select :new.eventdatetime,:new.taskid,:new.processname,:new.tasktype,:new.taskname,:new.taskdescription,:new.assigntorole,:new.transid,
			:new.keyfield,:new.execonapprove,:new.keyvalue,:new.transdata,:new.fromrole,:new.fromuser,c.tousername,:new.priorindex,:new.priortaskname,
			:new.corpdimension,:new.orgdimension,:new.department,:new.grade,:new.datavalue,:new.displayicon,:new.displaytitle,:new.displaysubtitle,
			:new.displaycontent,:new.displaybuttons,:new.groupfield,:new.groupvalue,:new.priorusername,:new.initiator,:new.mapfieldvalue,
			:new.useridentificationfilter,:new.useridentificationfilter_of,:new.mapfield_group,:new.mapfield,'T',:new.indexno,:new.subindexno,
			:new.processowner,:new.assigntoflg,:new.assigntoactor,:new.actorfilter,:new.recordid,:new.processownerflg,:new.pownerfilter,
			:new.approvereasons,:new.defapptext,:new.returnreasons,:new.defrettext,:new.rejectreasons,:new.defregtext,:new.approvalcomments,
			:new.rejectcomments,:new.returncomments,:new.escalation,:new.reminder,:new.displaymcontent,:new.groupwithpriorindex,'T',:new.returnable,
			:new.allowsend,:new.allowsendflg,:new.sendtoactor,:new.initiator_approval,:new.usebusinessdatelogic,:new.initonbehalf,:new.autoapprove,
			:new.isoptional,:new.Reminderstartdate,:new.Escalationstartdate,:new.reminderjsondata,:new.escalationjsondata
			FROM (select  TRIM(REGEXP_SUBSTR(rec.ugrpusers, '[^,]+', 1, LEVEL)) fuser from dual CONNECT BY REGEXP_SUBSTR (rec.ugrpusers,'[^,]+',1,LEVEL) IS NOT NULL)a,
			axprocessdef_delegation c where a.fuser = c.fromusername and current_date  >= c.fromdate	and current_date  <= c.todate;	
		--	INSERT INTO ORCTEST values('For_Loop',rec.ugrpusers,0);COMMIT;
			END LOOP;
		ELSE					
												
		select count(*) into v_processonwer_cnt
		from axuserlevelgroups c
		where c.usergroup = :new.processowner		
		and ((c.startdate is not null and SYSDATE  >= c.startdate) or (c.startdate is null)) 
		and ((c.enddate is not null and SYSDATE <= c.enddate) or (c.enddate is null));		
			if v_processonwer_cnt > 0 then	---- Process owner USER EXISTS
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
				keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
				displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
				useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
				assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
				approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
				allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,isoptional,
				Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select :new.eventdatetime,:new.taskid,:new.processname,:new.tasktype,:new.taskname,:new.taskdescription,:new.assigntorole,:new.transid,:new.keyfield,
				:new.execonapprove,:new.keyvalue,:new.transdata,:new.fromrole,:new.fromuser,c.username,:new.priorindex,:new.priortaskname,:new.corpdimension,
				:new.orgdimension,:new.department,:new.grade,:new.datavalue,:new.displayicon,:new.displaytitle,:new.displaysubtitle,:new.displaycontent,
				:new.displaybuttons,:new.groupfield,:new.groupvalue,:new.priorusername,:new.initiator,:new.mapfieldvalue,	:new.useridentificationfilter,
				:new.useridentificationfilter_of,:new.mapfield_group,:new.mapfield,'T',:new.indexno,:new.subindexno,
				:new.processowner,:new.assigntoflg,:new.assigntoactor,:new.actorfilter,:new.recordid,:new.processownerflg,:new.pownerfilter,
				:new.approvereasons,:new.defapptext,:new.returnreasons,:new.defrettext,:new.rejectreasons,:new.defregtext,
				:new.approvalcomments,:new.rejectcomments,:new.returncomments,:new.escalation,:new.reminder,:new.displaymcontent,:new.groupwithpriorindex,:new.returnable,
				:new.allowsend,:new.allowsendflg,:new.sendtoactor,:new.initiator_approval,:new.usebusinessdatelogic,:new.initonbehalf,'T',
				:new.autoapprove,:new.isoptional,:new.Reminderstartdate,:new.Escalationstartdate,:new.reminderjsondata,:new.escalationjsondata
				from axuserlevelgroups c where c.usergroup = :new.processowner and ((c.startdate is not null and sysdate  >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and sysdate <= c.enddate) or (c.enddate is null));
------------------------------Delegation | Process owner			
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,keyvalue,
				transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,displayicon,displaytitle,
				displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,useridentificationfilter,
				useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,assigntoactor,actorfilter,recordid,processownerflg,
				pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,approvalcomments,rejectcomments,returncomments,escalation,reminder,
				displaymcontent,groupwithpriorindex,delegation,returnable,allowsend,allowsendflg,sendtoactor,initiator_approval,
				usebusinessdatelogic,initonbehalf,autoapprove,isoptional,Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 								
				select :new.eventdatetime,:new.taskid,:new.processname,:new.tasktype,:new.taskname,:new.taskdescription,:new.assigntorole,:new.transid,:new.keyfield,:new.execonapprove,
				:new.keyvalue,:new.transdata,:new.fromrole,:new.fromuser,c.tousername,:new.priorindex,:new.priortaskname,:new.corpdimension,:new.orgdimension,:new.department,
				:new.grade,:new.datavalue,:new.displayicon,:new.displaytitle,:new.displaysubtitle,:new.displaycontent,:new.displaybuttons,:new.groupfield,:new.groupvalue,
				:new.priorusername,:new.initiator,:new.mapfieldvalue,:new.useridentificationfilter,:new.useridentificationfilter_of,:new.mapfield_group,:new.mapfield,'T',
				:new.indexno,:new.subindexno,:new.processowner,:new.assigntoflg,:new.assigntoactor,:new.actorfilter,:new.recordid,:new.processownerflg,:new.pownerfilter,
				:new.approvereasons,:new.defapptext,:new.returnreasons,:new.defrettext,:new.rejectreasons,:new.defregtext,:new.approvalcomments,:new.rejectcomments,
				:new.returncomments,:new.escalation,:new.reminder,:new.displaymcontent,:new.groupwithpriorindex,'T',:new.returnable,:new.allowsend,:new.allowsendflg,
				:new.sendtoactor,:new.initiator_approval,:new.usebusinessdatelogic,:new.initonbehalf,:new.autoapprove,
				:new.isoptional,:new.Reminderstartdate,:new.Escalationstartdate,:new.reminderjsondata,:new.escalationjsondata			
				from axprocessdef_delegation c,axuserlevelgroups d 
				where d.usergroup = :new.processowner and ((d.startdate is not null and sysdate  >= d.startdate) or (d.startdate is null)) 
				and ((d.enddate is not null and sysdate <= d.enddate) or (d.enddate is null))
				and	c.fromusername = d.username	and sysdate >= c.fromdate and sysdate <= c.todate;
			COMMIT;
			ELSE
---------------------Redirect to default role when no users exists in process owner
				insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
				keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
				displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
				useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
				assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
				approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
				allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,pownerflg,autoapprove,isoptional,
				Reminderstartdate,Escalationstartdate,reminderjsondata,escalationjsondata) 
				select :new.eventdatetime,:new.taskid,:new.processname,:new.tasktype,:new.taskname,:new.taskdescription,:new.assigntorole,:new.transid,:new.keyfield,
				:new.execonapprove,:new.keyvalue,:new.transdata,:new.fromrole,:new.fromuser,c.username,:new.priorindex,:new.priortaskname,:new.corpdimension,
				:new.orgdimension,:new.department,:new.grade,:new.datavalue,:new.displayicon,:new.displaytitle,:new.displaysubtitle,:new.displaycontent,
				:new.displaybuttons,:new.groupfield,:new.groupvalue,:new.priorusername,:new.initiator,:new.mapfieldvalue,	:new.useridentificationfilter,
				:new.useridentificationfilter_of,:new.mapfield_group,:new.mapfield,'T',:new.indexno,:new.subindexno,
				:new.processowner,:new.assigntoflg,:new.assigntoactor,:new.actorfilter,:new.recordid,:new.processownerflg,:new.pownerfilter,
				:new.approvereasons,:new.defapptext,:new.returnreasons,:new.defrettext,:new.rejectreasons,:new.defregtext,
				:new.approvalcomments,:new.rejectcomments,:new.returncomments,:new.escalation,:new.reminder,:new.displaymcontent,:new.groupwithpriorindex,:new.returnable,
				:new.allowsend,:new.allowsendflg,:new.sendtoactor,:new.initiator_approval,:new.usebusinessdatelogic,:new.initonbehalf,'T',
				:new.autoapprove,:new.isoptional,:new.Reminderstartdate,:new.Escalationstartdate,:new.reminderjsondata,:new.escalationjsondata
				from axuserlevelgroups c
				where c.usergroup = 'default' and ((c.startdate is not null and sysdate >= c.startdate) or (c.startdate is null)) 
				and ((c.enddate is not null and sysdate  <= c.enddate) or (c.enddate is null));
				COMMIT;
			end if;		
		END IF;
	END IF;	
END IF;
COMMIT;
END;
>>

<<
CREATE OR REPLACE TRIGGER "TRG_AXPROCESSDEFV2" 
BEFORE INSERT OR UPDATE ON axprocessdefv2 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare 
   	v_rem_esc_sfrom varchar2(4000);
   	v_rem_esc_taskparam varchar2(4000);
   	 
BEGIN 
	    
	   select listagg(sfrom,',') WITHIN GROUP (ORDER BY 1),
	   listagg(rtrim(substr(sfrom,INSTR(sfrom,'-(')+2),')'),',') 
	   WITHIN GROUP (ORDER BY 1)
		into v_rem_esc_sfrom,  v_rem_esc_taskparam	
		from 
	   (SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.rem_esc_startfrom, '[^,]+', 1, LEVEL)) AS sfrom
		from dual 		
		CONNECT BY REGEXP_SUBSTR (:NEW.rem_esc_startfrom,'[^,]+',1,LEVEL) IS NOT NULL );
   
   

        IF INSERTING AND LENGTH(nvl(v_rem_esc_sfrom,'N')) > 2 
        THEN
		
		:new.taskparamsui := :new.taskparamsui||','||v_rem_esc_sfrom;
		:new.taskparams := :new.taskparams||','||v_rem_esc_taskparam;
		
		
		end if;
			
		IF UPDATING AND LENGTH(nvl(v_rem_esc_sfrom,'N')) > 2 
		THEN
		
		:new.taskparamsui := :new.taskparamsui||','||v_rem_esc_sfrom;
		:new.taskparams :=:new.taskparams||','||v_rem_esc_taskparam;
	
		
	
		end if;
end;
>>

<<
CREATE OR REPLACE TRIGGER trg_axpdef_peg_actorusergrp
after UPDATE ON axpdef_peg_actorusergrp 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
when (new.oldugrpusername!= new.ugrpusername)
declare
v_newusers varchar2(4000);
v_delusers varchar2(4000);
v_retainedusers varchar2(4000);
begin
	
----- Users to be removed
with 
a AS
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.oldugrpusername, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.oldugrpusername,'[^,]+',1,LEVEL) IS NOT NULL ),
b as 
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.ugrpusername, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.ugrpusername,'[^,]+',1,LEVEL) IS NOT NULL )
select LISTAGG(a.usr,',') WITHIN GROUP(ORDER BY 1) into v_delusers from a left join b on a.usr = b.usr
where b.usr is null;

----- New user added to the default list
with 
a AS
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.oldugrpusername, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.oldugrpusername,'[^,]+',1,LEVEL) IS NOT NULL ),
b as 
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.ugrpusername, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.ugrpusername,'[^,]+',1,LEVEL) IS NOT NULL )
select LISTAGG(b.usr,',') WITHIN GROUP(ORDER BY 1) into v_newusers from a right join b on a.usr = b.usr
where a.usr is null;

-----Existing users to be retained
with
a AS
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.oldugrpusername, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.oldugrpusername,'[^,]+',1,LEVEL) IS NOT NULL ),
b as 
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.ugrpusername, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.ugrpusername,'[^,]+',1,LEVEL) IS NOT NULL )
select LISTAGG(b.usr,',') WITHIN GROUP(ORDER BY 1) into v_retainedusers from a join b on a.usr = b.usr;



update axactivetasks a set removeflg='T' where assigntoflg='2' and delegation='F' and pownerflg='F' and removeflg='F' and grouped='T'
and assigntoactor= :new.ug_actorname 
and to_char(actor_user_groups)  = :new.usergroupname
and touser in(SELECT distinct TRIM(REGEXP_SUBSTR(v_delusers, '[^,]+', 1, LEVEL)) AS usr from dual CONNECT BY REGEXP_SUBSTR (v_delusers,'[^,]+',1,LEVEL) IS NOT NULL)
and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid);


insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
	keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
	displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
	useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
	assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
	allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,changedusr,actor_user_groups) 	
	select distinct eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,
	execonapprove,keyvalue,transdata,fromrole,fromuser,b.usr,priorindex,priortaskname,corpdimension,
	orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,to_char(displaycontent),
	displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,	useridentificationfilter,
	useridentificationfilter_of,mapfield_group,mapfield,'T',indexno,subindexno,
	processowner,assigntoflg,assigntoactor,TO_CHAR(actorfilter),recordid,processownerflg,pownerfilter,
	approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,TO_CHAR(displaymcontent),groupwithpriorindex,returnable,
	allowsend,allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,'T',:new.usergroupname
	from axactivetasks a,
	(SELECT distinct TRIM(REGEXP_SUBSTR(v_newusers, '[^,]+', 1, LEVEL)) AS usr from dual CONNECT BY REGEXP_SUBSTR (v_newusers,'[^,]+',1,LEVEL) IS NOT NULL)b 	
	 where assigntoflg='2' and delegation='F' and pownerflg ='F' and removeflg ='F' and grouped='T'
	 and assigntoactor = :new.ug_actorname
	 and to_char(actor_user_groups)  = :new.usergroupname 
	 and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid); 

end;
>>

<<
CREATE OR REPLACE TRIGGER trg_axpdef_peg_grpfilter
after UPDATE ON axpdef_peg_grpfilter 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
when (new.olddatagrpusers!=new.datagrpusers)
declare
v_newusers varchar2(4000);
v_delusers varchar2(4000);
v_retainedusers varchar2(4000);
begin
	
----- Users to be removed
with 
a AS
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.olddatagrpusers, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.olddatagrpusers,'[^,]+',1,LEVEL) IS NOT NULL ),
b as 
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.datagrpusers, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.datagrpusers,'[^,]+',1,LEVEL) IS NOT NULL )
select LISTAGG(a.usr,',') WITHIN GROUP(ORDER BY 1) into v_delusers from a left join b on a.usr = b.usr
where b.usr is null;

----- New user added to the default list
with 
a AS
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.olddatagrpusers, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.olddatagrpusers,'[^,]+',1,LEVEL) IS NOT NULL ),
b as 
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.datagrpusers, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.datagrpusers,'[^,]+',1,LEVEL) IS NOT NULL )
select LISTAGG(b.usr,',') WITHIN GROUP(ORDER BY 1) into v_newusers from a right join b on a.usr = b.usr
where a.usr is null;

-----Existing users to be retained
with
a AS
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.olddatagrpusers, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.olddatagrpusers,'[^,]+',1,LEVEL) IS NOT NULL ),
b as 
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.datagrpusers, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.datagrpusers,'[^,]+',1,LEVEL) IS NOT NULL )
select LISTAGG(b.usr,',') WITHIN GROUP(ORDER BY 1) into v_retainedusers from a join b on a.usr = b.usr;

update axactivetasks a set removeflg='T' where assigntoflg='2' and delegation='F' and pownerflg='F' and removeflg='F' and grouped='T'
and assigntoactor= :new.dg_actorname 
and actor_data_grp  = :new.dgname
and touser in(SELECT distinct TRIM(REGEXP_SUBSTR(v_delusers, '[^,]+', 1, LEVEL)) AS usr from dual CONNECT BY REGEXP_SUBSTR (v_delusers,'[^,]+',1,LEVEL) IS NOT NULL)
and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid);


insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
	keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
	displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
	useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
	assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
	allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,changedusr,actor_data_grp) 	
	select distinct eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,
	execonapprove,keyvalue,transdata,fromrole,fromuser,b.usr,priorindex,priortaskname,corpdimension,
	orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,TO_CHAR(displaycontent),
	displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,	useridentificationfilter,
	useridentificationfilter_of,mapfield_group,mapfield,'T',indexno,subindexno,
	processowner,assigntoflg,assigntoactor,to_char(actorfilter),recordid,processownerflg,pownerfilter,
	approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,to_char(displaymcontent),groupwithpriorindex,returnable,
	allowsend,allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,'T',:new.dgname
	from axactivetasks a,
	(SELECT distinct TRIM(REGEXP_SUBSTR(v_newusers, '[^,]+', 1, LEVEL)) AS usr from dual CONNECT BY REGEXP_SUBSTR (v_newusers,'[^,]+',1,LEVEL) IS NOT NULL)b 	
	where assigntoflg='2' and delegation='F' and pownerflg ='F' and removeflg ='F' and grouped='T'
	and assigntoactor = :new.dg_actorname
	and actor_data_grp  = :new.dgname 
	and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid); 

end;
>>

<<
CREATE OR REPLACE TRIGGER trg_axpeg_sendmsg
after INSERT ON AXPEG_SENDMSG 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN 

	insert into axactivemessages(eventdatetime,msgtype,fromuser,touser,displaytitle,displaycontent,effectivefrom,effectiveto,hlink_transid,hlink_params)
	VALUES (to_char(SYSDATE,'YYYYMMDDHH24MISSSS'),:new.msgtype,:new.fromuser,:new.touser,:new.msgtitle,:new.message,trunc(SYSDATE),
	:new.effectiveto,:new.hlink_transid,:new.hlink_params);
	  
end;
>>

<<
CREATE OR REPLACE TRIGGER trg_axrelations 
after INSERT OR UPDATE ON axrelations 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN

delete from axentityrelations where mstruct = :new.mstruct and mfield = :new.mfield and dstruct = :new.dstruct and dfield = :new.dfield and 'md' = :new.rtype;
delete from axentityrelations where mstruct = :new.mstruct and dstruct = :new.dstruct  and 'gm' = :new.rtype;

insert into axentityrelations ( 
axentityrelationsid,cancel,username,modifiedon,createdby,createdon,app_level,app_desc,
rtype,mstruct,mfield,mtable,primarytable,dstruct,dfield,dtable,rtypeui,mstructui,mfieldui,dstructui,dfieldui,dprimarytable)    
SELECT ax_entity_relseq.NEXTVAL  AS axentityrelationsid,a.* from
(
SELECT DISTINCT 
    'F' AS cancel,
    'admin' AS username,
    CURRENT_TIMESTAMP AS modifiedon,
    'admin' AS createdby,
    CURRENT_TIMESTAMP AS createdon,
    1 AS app_level,
    1 AS app_desc,
    :new.rtype,
    :new.mstruct,
    :new.mfield,
    m.tablename AS mtable,
    dc.tablename AS primarytable,
    :new.dstruct,
    :new.dfield,
    d.tablename AS dtable,
    'Dropdown' AS rtypeui,
    (mt.caption||'-('||mt.name||')') AS mstructui,
    (m.caption|| '-('||m.fname||')') AS mfieldui,
    (dt.caption||'-('||dt.name||')') AS dstructui,
    (d.caption||'-('||d.fname||')') AS dfieldui,
    ddc.tablename AS dprimarytable
   FROM tstructs mt 
     JOIN tstructs dt ON :new.dstruct = dt.name
     LEFT JOIN axpflds m ON :new.mstruct = m.tstruct AND :new.mfield = m.fname
     LEFT JOIN axpflds d ON :new.dstruct = d.tstruct AND :new.dfield = d.fname
     LEFT JOIN axpdc dc ON :new.mstruct = dc.tstruct AND dc.dname = 'dc1'
    LEFT JOIN axpdc ddc ON :new.dstruct = ddc.tstruct AND ddc.dname = 'dc1'     
  WHERE :new.rtype = 'md' and :new.mstruct = mt.name
UNION ALL
 SELECT    'F' AS cancel,
    'admin' AS username,
    CURRENT_TIMESTAMP AS modifiedon,
    'admin' AS createdby,
    CURRENT_TIMESTAMP AS createdon,
    1 AS app_level,
    1 AS app_desc,
    'gm' AS rtype,
    :NEW.mstruct,
    null mfield,
    null AS mtable,
    pd.tablename AS primarytable,
    :NEW.dstruct,
    'sourceid' AS dfield,
    td.tablename AS dtable,
    'Genmap' AS rtypeui,
    (mt.caption||'-('||mt.name||')') AS mstructui,
    NULL AS mfieldui,
    (dt.caption||'-('||dt.name||')') AS dstructui,
    NULL AS dfieldui,
    td.tablename AS dprimarytable
   FROM  tstructs mt 
     JOIN tstructs dt ON :new.dstruct  = dt.name    
     LEFT JOIN axpdc td ON :NEW.dstruct = td.tstruct AND td.dname = 'dc1'
     LEFT JOIN axpdc pd ON :NEW.mstruct = pd.tstruct AND pd.dname = 'dc1'
     where mt.name = :new.mstruct and 'gm' = :new.rtype)a;
	 
END;
>>

<<
CREATE OR REPLACE TRIGGER trg_axpdef_peg_actor
after UPDATE ON axpdef_peg_actor 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
when(new.olddefusername != new.defusername)
declare
v_newusers varchar2(4000);
v_delusers varchar2(4000);
v_retainedusers varchar2(4000);
begin

----- Users to be removed
with 
a AS
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.olddefusername, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.olddefusername,'[^,]+',1,LEVEL) IS NOT NULL ),
b as 
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.defusername, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.defusername,'[^,]+',1,LEVEL) IS NOT NULL )
select LISTAGG(a.usr,',') WITHIN GROUP(ORDER BY 1) into v_delusers from a left join b on a.usr = b.usr
where b.usr is null;

----- New user added to the default list
with 
a AS
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.olddefusername, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.olddefusername,'[^,]+',1,LEVEL) IS NOT NULL ),
b as 
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.defusername, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.defusername,'[^,]+',1,LEVEL) IS NOT NULL )
select LISTAGG(b.usr,',') WITHIN GROUP(ORDER BY 1) into v_newusers from a right join b on a.usr = b.usr
where a.usr is null;

-----Existing users to be retained
with
a AS
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.olddefusername, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.olddefusername,'[^,]+',1,LEVEL) IS NOT NULL ),
b as 
(SELECT distinct TRIM(REGEXP_SUBSTR(:NEW.defusername, '[^,]+', 1, LEVEL)) AS usr
from dual CONNECT BY REGEXP_SUBSTR (:NEW.defusername,'[^,]+',1,LEVEL) IS NOT NULL )
select LISTAGG(b.usr,',') WITHIN GROUP(ORDER BY 1) into v_retainedusers from a join b on a.usr = b.usr;

update axactivetasks a set removeflg='T' where assigntoflg='2' and delegation='F' and pownerflg='F' and removeflg='F' 
and actor_default_users='T' and grouped='T'
and assigntoactor= :new.actorname 
and touser in(SELECT distinct TRIM(REGEXP_SUBSTR(v_delusers, '[^,]+', 1, LEVEL)) AS usr from dual CONNECT BY REGEXP_SUBSTR (v_delusers,'[^,]+',1,LEVEL) IS NOT NULL)
and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid);


insert into axactivetasks(eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,execonapprove,
	keyvalue,transdata,fromrole,fromuser,touser,priorindex,priortaskname,corpdimension,orgdimension,department,grade,datavalue,
	displayicon,displaytitle,displaysubtitle,displaycontent,displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,
	useridentificationfilter,useridentificationfilter_of,mapfield_group,mapfield,grouped,indexno,subindexno,processowner,assigntoflg,
	assigntoactor,actorfilter,recordid,processownerflg,pownerfilter,approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,displaymcontent,groupwithpriorindex,returnable,allowsend,
	allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,changedusr,actor_default_users) 	
	select distinct eventdatetime,taskid,processname,tasktype,taskname,taskdescription,assigntorole,transid,keyfield,
	execonapprove,keyvalue,transdata,fromrole,fromuser,b.usr,priorindex,priortaskname,corpdimension,
	orgdimension,department,grade,datavalue,displayicon,displaytitle,displaysubtitle,TO_char(displaycontent),
	displaybuttons,groupfield,groupvalue,priorusername,initiator,mapfieldvalue,	useridentificationfilter,
	useridentificationfilter_of,mapfield_group,mapfield,'T',indexno,subindexno,
	processowner,assigntoflg,assigntoactor,to_char(actorfilter),recordid,processownerflg,pownerfilter,
	approvereasons,defapptext,returnreasons,defrettext,rejectreasons,defregtext,
	approvalcomments,rejectcomments,returncomments,escalation,reminder,TO_CHAR(displaymcontent),groupwithpriorindex,returnable,
	allowsend,allowsendflg,sendtoactor,initiator_approval,usebusinessdatelogic,initonbehalf,'T','T'
	from axactivetasks a,
	(SELECT distinct TRIM(REGEXP_SUBSTR(v_newusers, '[^,]+', 1, LEVEL)) AS usr from dual CONNECT BY REGEXP_SUBSTR (v_newusers,'[^,]+',1,LEVEL) IS NOT NULL)b
	 where assigntoflg='2' and delegation='F' and pownerflg ='F' and removeflg ='F' and grouped='T' and actor_default_users='T'
	 and assigntoactor = :new.actorname	 
	 and not exists (SELECT b.taskid FROM axactivetaskstatus b WHERE a.taskid = b.taskid); 

end;
>>

<<
CREATE OR REPLACE TRIGGER trg_axlanguage11x
AFTER INSERT ON axlanguage11x
FOR EACH ROW
DECLARE
   v_exists NUMBER;
BEGIN
   -- Check if a matching row already exists
   SELECT COUNT(*)
   INTO v_exists
   FROM axlanguage
   WHERE lngname || sname || compname = :NEW.lngname || :NEW.sname || :NEW.compname;

   IF v_exists > 0 THEN
      -- Update the existing row
      UPDATE axlanguage
      SET fontname = :NEW.fontname,
          fontsize = :NEW.fontsize,
          compcaption = :NEW.compcaption,
          comphint = :NEW.comphint,
          dispname = :NEW.dispname
      WHERE lngname || sname || compname = :NEW.lngname || :NEW.sname || :NEW.compname;
   ELSE
      -- Insert a new row
      INSERT INTO axlanguage (lngname, sname, fontname, fontsize, compname, compcaption, comphint, dispname)
      VALUES (:NEW.lngname, :NEW.sname, :NEW.fontname, :NEW.fontsize, :NEW.compname, :NEW.compcaption, :NEW.comphint, :NEW.dispname);
   END IF;
END;
>>

<<
CREATE OR REPLACE FUNCTION pr_pegv2_transcurstatus(ptransid VARCHAR2, pkeyvalue VARCHAR2, pprocess VARCHAR2)
RETURN VARCHAR2
AS
  v_qry VARCHAR2(4000);
  v_output NUMBER;
BEGIN
  v_qry := 'SELECT status FROM axpeg_' || ptransid || ' WHERE keyvalue = ''' || pkeyvalue || ''' AND processname = ''' || pprocess || '''';

  EXECUTE IMMEDIATE v_qry INTO v_output;

  RETURN CASE v_output
           WHEN 1 THEN 'Approved'
           WHEN 2 THEN 'Rejected'
           WHEN 3 THEN 'Withdrawn'
           ELSE 'In Progress'
         END;

END;
>>

<<
CREATE OR REPLACE FUNCTION axp_fn_get_scolname (
    v_sql       IN VARCHAR2,
    modeofentry IN VARCHAR2
) RETURN VARCHAR2
IS
    scolname VARCHAR2(4000);
BEGIN
    -- Check if the input is not null or empty
    IF v_sql IS NOT NULL AND v_sql <> '' AND modeofentry = 'Fill' THEN
        -- Process the input and extract the desired part
        scolname := REGEXP_SUBSTR(
            REGEXP_SUBSTR(
                LOWER(REGEXP_REPLACE(REPLACE(v_sql, ':', ''), '\r\n?|\n', '', 'g')),
                'from', 1, 1, 'i', 1
            ),
            'select', 1, 2, 'i', 1
        );
    ELSE
        scolname := NULL;
    END IF;

    RETURN scolname;
END axp_fn_get_scolname;
>>

<<
CREATE OR REPLACE TYPE AXPDEF_PERMISSION_GETCND AS OBJECT (
    fullcontrol VARCHAR2(1),
    userrole VARCHAR2(250),
    allowcreate VARCHAR2(1),
    view_access VARCHAR2(250),
    view_includedc VARCHAR2(4000),
    view_excludedc VARCHAR2(4000),
    view_includeflds VARCHAR2(4000),
    view_excludeflds VARCHAR2(4000),
    edit_access VARCHAR2(250),
    edit_includedc VARCHAR2(4000),
    edit_excludedc VARCHAR2(4000),
    edit_includeflds VARCHAR2(4000),
    edit_excludeflds VARCHAR2(4000),
    maskedflds VARCHAR2(4000),
    filtercnd CLOB, 
    recordid NUMBER 
);
>>

<<
CREATE OR REPLACE TYPE AXPDEF_PERMISSION_GETCND_OBJ AS TABLE OF AXPDEF_PERMISSION_GETCND;
>>

<<
CREATE OR REPLACE TYPE AXPDEF_PERMISSION_MDATA AS OBJECT (
    transid VARCHAR2(250),
    fullcontrol VARCHAR2(1), 
    userrole VARCHAR2(250),
    allowcreate VARCHAR2(1), 
    view_access VARCHAR2(250),
    view_includedc VARCHAR2(4000), 
    view_excludedc VARCHAR2(4000),
    view_includeflds VARCHAR2(4000),
    view_excludeflds VARCHAR2(4000),
    edit_access VARCHAR2(250),
    edit_includedc VARCHAR2(4000),
    edit_excludedc VARCHAR2(4000),
    edit_includeflds VARCHAR2(4000),
    edit_excludeflds VARCHAR2(4000),
    maskedflds VARCHAR2(4000),
    filtercnd CLOB 
);
>>

<<
CREATE OR REPLACE TYPE AXPDEF_PERMISSION_MDATA_OBJ AS TABLE OF AXPDEF_PERMISSION_MDATA;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getcnd(
    pmode         IN VARCHAR2,
    ptransid      IN VARCHAR2,
    pkeyfld       IN VARCHAR2,
    pkeyvalue     IN VARCHAR2,
    pusername     IN VARCHAR2,
    proles        IN VARCHAR2 DEFAULT 'All'
) RETURN AXPDEF_PERMISSION_GETCND_OBJ PIPELINED
AS
    -- Variables to hold data from axpflds
    v_keyfld_normalized   VARCHAR2(1);
    v_keyfld_srctbl       VARCHAR2(100);
    v_keyfld_srcfld       VARCHAR2(100);
    v_keyfld_mandatory    VARCHAR2(1);
    v_keyfld_cnt numeric;

    -- Variables for dynamic SQL construction
    v_transid_primetable    VARCHAR2(100);
    v_transid_primetableid  VARCHAR2(100);
    v_keyfld_cnd          VARCHAR2(500);
    v_keyfld_joins        VARCHAR2(500);
    v_sql_permission_cnd  VARCHAR2(4000);
    v_sql_roles           VARCHAR2(4000);
    v_sql_permission_check VARCHAR2(4000);
    v_fullcontrol_sql     VARCHAR2(4000);

    -- Variables for counts and results
    v_menuaccess_count      NUMBER;
    v_permission_exists_count NUMBER;
    sql_permission_cnd_result NUMBER; 
    v_fullcontrol_recid   NUMBER;

    -- Variables to hold row data before piping
    v_fullcontrol         VARCHAR2(1);
    v_userrole            VARCHAR2(250);
    v_allowcreate         VARCHAR2(1);
    v_view_access         VARCHAR2(250);
    v_view_includedc      VARCHAR2(4000);
    v_view_excludedc      VARCHAR2(4000);
    v_view_includeflds    VARCHAR2(4000);
    v_excludeflds         VARCHAR2(4000); 
    v_edit_access         VARCHAR2(250);
    v_edit_includedc      VARCHAR2(4000);
    v_edit_excludedc      VARCHAR2(4000);
    v_edit_includeflds    VARCHAR2(4000);
    v_edit_excludeflds    VARCHAR2(4000);
    v_maskedflds          VARCHAR2(4000);
    v_filtercnd           CLOB;
    v_recordid            NUMBER;
    v_viewctrl            VARCHAR2(10); 
    v_editctrl            VARCHAR2(10); 
    v_viewlist            VARCHAR2(4000); 
    v_editlist            VARCHAR2(4000); 

BEGIN
	
	
	SELECT count(1)INTO v_keyfld_cnt FROM axpflds WHERE tstruct = ptransid AND fname = pkeyfld;
	
    IF v_keyfld_cnt > 0 then
	    SELECT srckey, srctf, srcfld, allowempty INTO v_keyfld_normalized, v_keyfld_srctbl, v_keyfld_srcfld, v_keyfld_mandatory
	    FROM axpflds WHERE tstruct = ptransid AND fname = pkeyfld;
	END IF;

    -- 2. Get primary table name from axpdc
    SELECT tablename
    INTO v_transid_primetable
    FROM axpdc
    WHERE tstruct = ptransid AND dname = 'dc1';

    -- 3. Determine the primary table ID field
    v_transid_primetableid := CASE WHEN LOWER(pkeyfld) = 'recordid' THEN v_transid_primetable || 'id' ELSE pkeyfld END;

    -- 4. Construct the key field condition (v_keyfld_cnd)
    v_keyfld_cnd := CASE WHEN v_keyfld_normalized = 'T'
                         THEN v_keyfld_srctbl || '.' || v_keyfld_srcfld
                         ELSE v_transid_primetable || '.' || v_transid_primetableid
                    END || '=' || pkeyvalue || ' AND ';

    -- 5. Construct the key field joins (v_keyfld_joins)
    v_keyfld_joins := NULL; -- Initialize to NULL
    IF v_keyfld_normalized = 'T' THEN
        v_keyfld_joins := CASE WHEN v_keyfld_mandatory = 'T' THEN ' JOIN ' ELSE ' LEFT JOIN ' END
                          || v_keyfld_srctbl || ' ' || pkeyfld || ' ON '
                          || v_transid_primetable || '.' || pkeyfld || '=' || v_keyfld_srctbl || '.' || v_keyfld_srctbl || 'id';
    END IF;

    -- 6. Calculate v_menuaccess_count (same logic as previous function)
    SELECT COUNT(*)
    INTO v_menuaccess_count
    FROM (
        SELECT 1 AS cnt FROM axusergroups a
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
        JOIN axuseraccess a2 ON b.roles_id = a2.rname AND a2.stype = 't'
        WHERE a2.sname = ptransid
          AND EXISTS (SELECT 1 FROM TABLE(string_to_array(proles, ',')) val WHERE val.COLUMN_VALUE = a.groupname)
        UNION ALL
        SELECT 1 FROM DUAL WHERE proles LIKE '%default%'
        UNION ALL
        SELECT 1 FROM axuserlevelgroups WHERE username = pusername AND usergroup = 'default'
        UNION ALL
        SELECT 1 AS cnt FROM axusergroups a
        JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
        JOIN axuseraccess a2 ON b.roles_id = a2.rname AND a2.stype = 't'
        JOIN axuserlevelgroups u ON a.groupname = u.usergroup AND u.username = pusername
        WHERE a2.sname = ptransid AND proles = 'All'
    );
 
   
    -- 9. Main logic based on menu access and permission existence
    --IF v_menuaccess_count > 0 --AND v_permission_exists_count = 0 
    --THEN
        -- Case: Menu access exists but no specific user permissions, implying full control
        v_fullcontrol_sql := 'SELECT ' || v_transid_primetable || 'id FROM ' || v_transid_primetable || ' ' ||
                             COALESCE(v_keyfld_joins, '') || ' WHERE ' || REPLACE(v_keyfld_cnd, ' AND ', '');

        EXECUTE IMMEDIATE v_fullcontrol_sql INTO v_fullcontrol_recid;

        v_fullcontrol := 'T';
        v_recordid := v_fullcontrol_recid;
        v_userrole := NULL;
        v_allowcreate := NULL;
        v_view_access := NULL;
        v_view_includedc := NULL;
        v_view_excludedc := NULL;
        v_view_includeflds := NULL;
        v_excludeflds := NULL;
        v_edit_access := NULL;
        v_edit_includedc := NULL;
        v_edit_excludedc := NULL;
        v_edit_includeflds := NULL;
        v_edit_excludeflds := NULL;
        v_maskedflds := NULL;
        v_filtercnd := NULL;

        PIPE ROW (AXPDEF_PERMISSION_GETCND(
            v_fullcontrol, v_userrole, v_allowcreate, v_view_access,
            v_view_includedc, v_view_excludedc, v_view_includeflds, v_excludeflds,
            v_edit_access, v_edit_includedc, v_edit_excludedc, v_edit_includeflds, v_edit_excludeflds,
            v_maskedflds, v_filtercnd, v_recordid
        ));
      
    RETURN; 
END;
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getpermission(
    pmode          IN VARCHAR2,
    ptransid       IN VARCHAR2,
    pusername      IN VARCHAR2,
    proles         IN VARCHAR2 DEFAULT 'All'
) RETURN AXPDEF_PERMISSION_MDATA_OBJ PIPELINED
AS
    -- Declare local variables
    v_menuaccess_count NUMBER;
    v_permission_exists_count NUMBER;
    v_sql_roles VARCHAR2(4000);
    v_sql_permission_check VARCHAR2(4000);

    -- Variables to hold results before piping
    v_transid_loop VARCHAR2(250);
    v_fullcontrol VARCHAR2(1);
    v_userrole VARCHAR2(250);
    v_allowcreate VARCHAR2(1);
    v_view_access VARCHAR2(250);
    v_view_includedc VARCHAR2(4000);
    v_view_excludedc VARCHAR2(4000);
    v_view_includeflds VARCHAR2(4000);
    v_view_excludeflds VARCHAR2(4000);
    v_edit_access VARCHAR2(250);
    v_edit_includedc VARCHAR2(4000);
    v_edit_excludedc VARCHAR2(4000);
    v_edit_includeflds VARCHAR2(4000);
    v_edit_excludeflds VARCHAR2(4000);
    v_maskedflds VARCHAR2(4000);
    v_filtercnd CLOB;
    v_viewctrl VARCHAR2(10);
    v_editctrl VARCHAR2(10);
    v_viewlist VARCHAR2(4000);
    v_editlist VARCHAR2(4000);

BEGIN
    -- Loop through each transid in the comma-separated string
    FOR rec_transid IN (SELECT COLUMN_VALUE AS transid FROM TABLE(string_to_array(ptransid, ','))) LOOP
        v_transid_loop := rec_transid.transid; -- Assign to local variable for consistent use

        -- Calculate v_menuaccess_count
        SELECT COUNT(*)
        INTO v_menuaccess_count
        FROM (
            SELECT 1 AS cnt
            FROM axusergroups a
            JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
            JOIN axuseraccess a2 ON b.roles_id = a2.rname AND a2.stype = 't'
            WHERE a2.sname = v_transid_loop
              AND EXISTS (SELECT 1 FROM TABLE(string_to_array(proles, ',')) val WHERE val.COLUMN_VALUE = a.groupname)
            UNION ALL
            SELECT 1 FROM DUAL WHERE proles LIKE '%default%'
            UNION ALL
            SELECT 1 FROM axuserlevelgroups WHERE username = pusername AND usergroup = 'default'
            UNION ALL
            SELECT 1 AS cnt
            FROM axusergroups a
            JOIN axusergroupsdetail b ON a.axusergroupsid = b.axusergroupsid
            JOIN axuseraccess a2 ON b.roles_id = a2.rname AND a2.stype = 't'
            JOIN axuserlevelgroups u ON a.groupname = u.usergroup AND u.username = pusername
            WHERE a2.sname = v_transid_loop AND proles = 'All'
        );

       

        IF v_menuaccess_count > 0 --AND v_permission_exists_count = 0 
        THEN
            -- Reset variables for this row to nulls, then set specific ones
            v_fullcontrol := 'T';
            v_userrole := NULL;
            v_view_includedc := NULL;
            v_view_excludedc := NULL;
            v_view_includeflds := NULL;
            v_view_excludeflds := NULL;
            v_edit_includedc := NULL;
            v_edit_excludedc := NULL;
            v_edit_includeflds := NULL;
            v_edit_excludeflds := NULL;
            v_maskedflds := NULL;
            v_view_access := NULL;
            v_edit_access := NULL;
            v_allowcreate := NULL;
            v_filtercnd := NULL;

            -- Pipe the row
            PIPE ROW (AXPDEF_PERMISSION_MDATA(
                v_transid_loop, v_fullcontrol, v_userrole, v_allowcreate, v_view_access,
                v_view_includedc, v_view_excludedc, v_view_includeflds, v_view_excludeflds,
                v_edit_access, v_edit_includedc, v_edit_excludedc, v_edit_includeflds, v_edit_excludeflds,
                v_maskedflds, v_filtercnd
            ));
        END if;
     
    END LOOP; -- End of rec_transid loop

    RETURN; 
END;
>>

<<
CREATE OR REPLACE PROCEDURE Pr_insertsql_new(ptablename VARCHAR)
IS
sqlstmt VARCHAR(4000); -- Increased size to accommodate long queries
BEGIN
-- Validate table name length
IF LENGTH(ptablename) > 50 THEN
RAISE_APPLICATION_ERROR(-20001, 'Table name exceeds 50 characters');
END IF;
-- Construct SQL statement
sqlstmt := 'CREATE TABLE ' || ptablename || 
' (psqlquery CHAR(2000)) ' ||
'ORGANIZATION EXTERNAL (' ||
'TYPE ORACLE_LOADER ' ||
'DEFAULT DIRECTORY DATALOAD ' ||
'ACCESS PARAMETERS (' ||
'RECORDS DELIMITED BY NEWLINE ' ||
'FIELDS TERMINATED BY '';'' ' ||
'MISSING FIELD VALUES ARE NULL (' ||
'PSQLQUERY CHAR(2000)' ||
')) ' ||
'LOCATION (''' || ptablename||'.txt' || ''')' ||
')';
-- Execute SQL statement
EXECUTE IMMEDIATE sqlstmt;
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
RAISE;
END;
>>


<<
CREATE OR REPLACE PROCEDURE pr_executescript_new(ptablename varchar2) IS TYPE reftyp IS REF CURSOR;
sqlstmt reftyp;
rec clob;
temp1 varchar2(1000);
BEGIN
	OPEN sqlstmt FOR 'SELECT psqlquery  FROM ' || ptablename;
LOOP
	FETCH sqlstmt INTO 	rec; 
    EXIT WHEN sqlstmt%NOTFOUND;

	EXECUTE IMMEDIATE rec;
END LOOP;

CLOSE sqlstmt;

temp1 := 'drop table ' || ptablename;

EXECUTE IMMEDIATE temp1;
END;
>>

<<
ALTER TABLE  AXIMPJOBS  ADD AXIMPPRIMARYFIELD_DETAILS varchar2(4000);
>>

<<
CREATE OR REPLACE TYPE Axpdef_tstruct_rec_obj AS OBJECT (
  dcname    VARCHAR2(100),
  rowno     NUMBER,
  recordid  NUMBER
);
>>

<<
CREATE OR REPLACE TYPE Axpdef_tstruct_rec AS TABLE OF Axpdef_tstruct_rec_obj;
>>

<<
CREATE OR REPLACE FUNCTION fn_tstruct_getdcrecid (
  ptransid    IN VARCHAR2,
  precordid   IN NUMBER,
  pdcstring   IN VARCHAR2
)
RETURN AXPDEF_TSTRUCT_REC
PIPELINED
AS
  v_dcname            VARCHAR2(100);
  v_rowstring         VARCHAR2(100);
  v_dctable           VARCHAR2(100);
  v_isgrid            VARCHAR2(1);
  v_primarydctable    VARCHAR2(100);
  v_sql               VARCHAR2(4000);
  
  CURSOR c_dcnames IS
    SELECT REGEXP_SUBSTR(pdcstring, '[^,]+', 1, LEVEL) AS str
    FROM dual
    CONNECT BY REGEXP_SUBSTR(pdcstring, '[^,]+', 1, LEVEL) IS NOT NULL;
    
  TYPE ref_cursor IS REF CURSOR;
  rc ref_cursor;

  v_dcname_out   VARCHAR2(100);
  v_rowno        NUMBER;
  v_recordid     NUMBER;

BEGIN
  -- Get the primary DC table
  SELECT tablename INTO v_primarydctable
  FROM axpdc
  WHERE tstruct = ptransid AND dname = 'dc1';

  -- Loop over comma-separated list
  FOR rec IN c_dcnames LOOP
    v_dcname := rec.str;

    SELECT tablename, asgrid
    INTO v_dctable, v_isgrid
    FROM axpdc
    WHERE tstruct = ptransid AND dname = v_dcname;

    -- Construct dynamic SQL
    IF v_isgrid = 'F' THEN
      v_sql := 'SELECT ''' || v_dcname || ''', 0 rowno,'||v_dctable||'id FROM ' || v_dctable ||' WHERE ' || v_primarydctable || 'id = :precordid';
    ELSE
      v_sql := 'SELECT '''|| v_dcname ||'''dcname,'||v_dctable||'row rowno,'||v_dctable||'id FROM ' || v_dctable ||' WHERE ' ||v_primarydctable || 'id = :precordid';
    END IF;

    -- Execute dynamic SQL and pipe the results
    OPEN rc FOR v_sql USING precordid;
    LOOP
      FETCH rc INTO v_dcname_out, v_rowno, v_recordid;
      EXIT WHEN rc%NOTFOUND;
      PIPE ROW(AXPDEF_TSTRUCT_REC_OBJ(v_dcname_out, v_rowno, v_recordid));
    END LOOP;
    CLOSE rc;
  END LOOP;

  RETURN;
END;
>>

<<
CREATE TABLE "AX_MOBILENOTIFY" 
   (	"USERNAME" VARCHAR2(50), 
	"PROJECTNAME" VARCHAR2(50), 
	"GUID" VARCHAR2(200), 
	"FIREBASE_ID" VARCHAR2(500), 
	"IMEI_NO" VARCHAR2(50), 
	"STATUS" VARCHAR2(2)
   );
>>

<<
CREATE OR REPLACE FUNCTION fn_permissions_getadscnd(
    ptransid IN VARCHAR2,
    padsname IN VARCHAR2,
    pusername IN VARCHAR2,
    proles IN VARCHAR2 DEFAULT 'All',
    pkeyfield IN VARCHAR2 DEFAULT NULL,
    pkeyvalue IN VARCHAR2 DEFAULT NULL
) RETURN AXPDEF_PERMISSION_GETADS_OBJ PIPELINED
AS
    rolesql_str      VARCHAR2(4000);
    v_permissionsql  VARCHAR2(4000);
    v_permissionexists NUMBER;
    v_fullcontrol    VARCHAR2(1);
    v_userrole       VARCHAR2(255);
    v_view_access    VARCHAR2(10);
    v_view_includeflds VARCHAR2(4000);
    v_view_excludeflds VARCHAR2(4000);
    v_maskedflds     VARCHAR2(4000);
    v_filtercnd      CLOB;
BEGIN
            PIPE ROW(AXPDEF_PERMISSION_GETADSCND('T', NULL, NULL, NULL, NULL, NULL, NULL));
    
    RETURN;
END;


CREATE OR REPLACE FUNCTION fn_permissions_getadssql (
    ptransid   VARCHAR2,
    padsname   VARCHAR2,
    pcond      CLOB
) RETURN CLOB
IS
    v_adssql        CLOB;
    v_filtersql     CLOB;
    v_primarydctable VARCHAR2(2000);
    v_filtercnd     CLOB;
BEGIN

    SELECT sqltext
      INTO v_adssql
      FROM axdirectsql
     WHERE sqlname = padsname;


    IF pcond <> 'NA' THEN
        SELECT tablename
          INTO v_primarydctable
          FROM axpdc
         WHERE tstruct = ptransid
           AND dname = 'dc1';

        v_filtercnd := ' and (' || REPLACE(pcond, '{primarytable.}', v_primarydctable || '.') || ')';

        
        v_filtersql := REPLACE(v_adssql, '--permission_filter', v_filtercnd);
    END IF;

    
    RETURN CASE
               WHEN pcond = 'NA' THEN v_adssql
               ELSE v_filtersql
           END;
END;
>>

<<
delete from axmmetadatamaster a 
where structtype||structname in('tstructa__ap',
'tstructa__fn',
'tstructa__iq',
'tstructa__pn',
'tstructa__qm',
'tstructad__q',
'tstructad_af',
'tstructad_am',
'tstructad_at',
'tstructad_cp',
'tstructad_it',
'tstructad_lg',
'tstructad_li',
'tstructad_pm',
'tstructad_pn',
'tstructad_pr',
'tstructad_td',
'tstructagspr',
'tstructappsr',
'tstructastcp',
'tstructaxadx',
'tstructaxcal',
'tstructaxcht',
'tstructaxclr',
'tstructaxerr',
'tstructaxfin',
'tstructaxglo',
'tstructaxlov',
'tstructaxpub',
'tstructaxrol',
'tstructaxstc',
'tstructjob_s',
'tstructpgv2a',
'tstructpgv2c',
'tstructpgv2m',
'tstructruldf',
'tstructtemps',
'tstructad__e',
'tstructa__ug',
'tstructaxusr',
'tstructad_pa',
'tstructa__sm',
'iviewad___apt',
'iviewad___ntn',
'iviewad___oqm',
'iviewad__act',
'iviewad__alog',
'iviewad__pgal',
'iviewad__pgnt',
'iviewad__prcd',
'iviewad__qlog',
'iviewad__qls',
'iviewad_implg',
'iviewad_lngst',
'iviewad_pgv2',
'iviewad_txalg',
'iviewadxconfv',
'iviewadxinlog',
'iviewadxoutlo',
'iviewapplogsm',
'iviewauditlog',
'iviewaxapilog',
'iviewaxchtdtl',
'iviewaxemllog',
'iviewaxfinyrs',
'iviewaximpfrc',
'iviewaximplog',
'iviewaxlangs',
'iviewaxnxtlst',
'iviewaxpfinhs',
'iviewaxpubls',
'iviewaxroles',
'iviewaxscrlog',
'iviewaxusers',
'iviewaxusracc',
'iviewcerrm',
'iviewdmlscrpt',
'iviewemaillog',
'iviewemlexcp',
'iviewesmsco',
'iviewiaxex',
'iviewiaxpscon',
'iviewidsco',
'iviewikywd',
'iviewimobc',
'iviewinmemdb',
'iviewitimtk',
'iviewivconfdt',
'iviewivhelpto',
'iviewloview1',
'iviewprintlog',
'iviewprnfail',
'iviewpservers',
'iviewpublist',
'iviewpublsdtl',
'iviewresponse',
'iviewsmslog',
'iviewthint',
'iviewad__papi',
'iviewad___fpr',
'iviewad___red',
'iviewad___rel',
'iviewad___pth',
'tstructa__er',
'iviewad___erc',
'tstructaxurg',
'iviewad_pbcs',
'iviewad___ugu',
'iviewad___ual',
'iviewad___url',
'tstructa__ua',
'tstructad_ur',
'tstructa__cd',
'tstructa__td',
'tstructad_vc',
'tstructapidg',
'tstructaxapi',
'tstructaxcdm',
'tstructaxeml',
'tstructaxipd',
'tstructaxvar',
'tstructb_sql',
'tstructctype',
'tstructsect',
'iviewad___tbd',
'iviewad___ugp',
'iviewappvars',
'iviewaximpdef',
'iviewaxjobs',
'iviewaxpcards',
'iviewaxvars',
'iviewcdlist',
'iviewcsqlist',
'iviewdop_list',
'iviewemaildef',
'iviewexapidef',
'iviewhplist',
'iviewjobcdtl',
'iviewjobtsk',
'iviewad___nwa',
'tstructa__na',
'tstructa_pgm',
'tstructa__ag',
'tstructa__up',
'iviewad___ups',
'iviewad___upg',
'tstructa__re',
'tstructad_db',
'iviewad___upm',
'iviewad___rla',
'tstructa__pu',
'tstructa__hp',
'tstructa__hc',
'tstructad__g',
'tstructad__p',
'tstructad__t',
'tstructad_cd',
'tstructad_cg',
'tstructad_cs',
'tstructad_fg',
'tstructad_fp',
'tstructad_ge',
'tstructad_lm',
'tstructad_md',
'tstructad_rm',
'tstructad_ve',
'tstructaxcad',
'tstructaxctx',
'tstructaxfsc',
'tstructaxftp',
'tstructaxmme',
'tstructaxnxt',
'tstructaxpwf',
'tstructaxrlr',
'tstructaxsrr',
'tstructchcon',
'tstructcusto',
'tstructdgmal',
'tstructdsgcn',
'tstructdsigc',
'tstructerrcd',
'tstructhptst',
'tstructiconf',
'tstructkword',
'tstructmntss',
'tstructmntst',
'tstructNF_AG',
'tstructofcon',
'tstructsendm',
'tstructtconf',
'tstructthelp',
'tstructtstco',
'tstructa__bl',
'tstructa__ur',
'tstructa__co',
'tstructa__ul',
'tstructa__uc',
'tstructad_re',
'iviewad___ucl',
'iviewad___ulg',
'iviewad___cmp',
'iviewad___brn',
'iviewad___acr',
'iviewad___acs',
'iviewad___cfd',
'iviewad___hcg',
'iviewad__fstp',
'iviewad__lgex',
'iviewad_cnfgp',
'iviewaxlngexp',
'iviewForms',
'iviewmainrepo',
'tstructa_guc',
'tstructa_dcm',
'tstructa__dm',
'tstructax_ac',
'iviewad_daccf',
'iviewad_dacmc',
'tstructa_pgt',
'tstructa_dup',
'tstructad__d');
>>

<<
update axusers set pwdauth='T',otpauth='F';
>>

<<
ALTER TABLE AXP_VP ADD CONSTRAINT AXP_VP_UNIQUE UNIQUE (VPNAME) ENABLE;
>>

<<
ALTER TABLE AXVARCORE ADD CONSTRAINT AXVARCORE_UNIQUE UNIQUE (VPNAME) ENABLE;
>>
