<<
CREATE TABLE AxSaveAPIResult (
    CallerId VARCHAR(100),
    CallSequence VARCHAR(20),
    Transid VARCHAR(10),
    Keyfield VARCHAR(100),
    KeyValue VARCHAR(200),
    InputJSON VARCHAR(MAX), 
    ResultString VARCHAR(MAX),
    RequestDatetime DATETIME2,
    RequestedBy VARCHAR(100)
);
>>