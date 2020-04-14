CREATE TABLE users
 (
 id NUMBER(1,0),
 name VARCHAR2(50),
 email VARCHAR2(100),
 CONSTRAINT pk1 PRIMARY KEY(id)
 ); 

insert into users values (1,'test','test@test.com');
commit;
