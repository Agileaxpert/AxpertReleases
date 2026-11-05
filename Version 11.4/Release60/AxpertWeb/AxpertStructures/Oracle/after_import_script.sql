<<
alter TABLE axusers ADD LICACTIVATION varchar2(1) DEFAULT 'F'
>>

<<
update axusers set licactivation='F' where username!='admin'
>>

<<
update axusers set licactivation='T' where username='admin'
>>