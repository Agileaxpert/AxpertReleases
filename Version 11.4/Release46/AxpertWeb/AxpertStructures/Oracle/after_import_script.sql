<<
alter table  axusers add STAYSIGNEDIN VARCHAR2(1);
>>

<<
alter table  axusers add SIGNINEXPIRY NUMBER(2,0);
>>

<<
update axusers set staysignedin='F',signinexpiry=14 where (staysignedin is null or length(staysignedin) = 0);
>>