<<
alter table  axusers add staysignedin nvarchar(1);
>>

<<
alter table  axusers add signinexpiry numeric(2,0);
>>

<<
update axusers set staysignedin='F',signinexpiry=14 where (staysignedin is null or len(staysignedin) = 0);
>>