<<
ALTER TABLE axusers ADD licactivation varchar(1) default 'F';
>>

<<
update axusers set licactivation='F' where username!='admin';
>>

<<
update axusers set licactivation='T' where username='admin';
>>