<<
ALTER TABLE axusers ADD licactivation nvarchar(1) default 'F';
>>

<<
ALTER TABLE axusers DISABLE TRIGGER ALL;
>>

<<
update axusers set licactivation='F' where username!='admin';
>>

<<
update axusers set licactivation='T' where username='admin';
>>

<<
ALTER TABLE axusers ENABLE TRIGGER ALL;
>>