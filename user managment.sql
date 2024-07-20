PROFILES:

Get profile information....

set lines 200 ;
set pages 200;
col profile for a32;
col resource_name for a50;
col limit for a50;

select distinct profile from dba_profiles ;

select profile,resource_name, limit from dba_profiles where profile = 'APP_PROFILE';

CREATE PROFILE:

CREATE PROFILE APP_PROFILE
LIMIT
COMPOSITE_LIMIT UNLIMITED
SESSIONS_PER_USER 2
CPU_PER_SESSION UNLIMITED
CPU_PER_CALL UNLIMITED
LOGICAL_READS_PER_SESSION UNLIMITED
LOGICAL_READS_PER_CALL UNLIMITED
IDLE_TIME 1
CONNECT_TIME 5
PRIVATE_SGA UNLIMITED
FAILED_LOGIN_ATTEMPTS 10
PASSWORD_LIFE_TIME 180
PASSWORD_REUSE_TIME UNLIMITED
PASSWORD_REUSE_MAX UNLIMITED
PASSWORD_VERIFY_FUNCTION NULL
PASSWORD_LOCK_TIME UNLIMITED
PASSWORD_GRACE_TIME UNLIMITED;

alter profile:

ALTER PROFILE APP_PROFILE LIMIT SESSIONS_PER_USER 1;

ROLES

---to check grants of a ROLES

select ROLE,GRANTED_ROLE  from role_role_privs where role='DBA';

-- System privileges granted to an user ( scott)

SELECT * FROM DBA_SYS_PRIVS where grantee='A124';

-- Roles granted to an user ( scott)

SELECT * FROM DBA_ROLE_PRIVS where grantee='USER1';

-- Object privileges granted to an user ( SCOTT)

SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE='CONNECT';

-- Column specific privileges granted

SELECT * FROM DBA_COL_PRIVS WHERE GRANTEE='SCOTT';

-- Table privileges

GRANT READ ANY TABLE TO SCOTT;

GRANT SELECT ANY TABLE TO SCOTT;

GRANT INSERT, UPDATE, DELETE ON TESTUSER1.EMPTABL on SCOTT;
GRANT ALL ON TESTUSER1.EMPTABL on SCOTT;

-- Grant privilege on few columns of a table
--Only INSERT,UPDATE can be granted at COLUMN level.

GRANT insert (emp_id) ON TESTUSER1.EMPTABL TO SCOTT;
GRANT UPDATE(emp_id) ON TESTUSER1.EMPTABL TO SCOTT;

USER
create user identified by password default tablespace users  temporary tablespace temp;

Eg:

create user SCOTT identified by oracle#41234
default tablespace users
temporary tablespace TEMP;

-To create an user, which will prompt for new password upon login:

create user SCOTT identified by oracle#41234
default tablespace users
temporary tablespace TEMP
account unlock 
profile APP_PROFILE
password expire;

-- Change password of an user

ALTER USER SCOTT identified by NEW_PWD;

-- Change user profile;

ALTER USER SCOTT PROFILE SIEBEL_PROFILE;

-- Unlock/lock a user

ALTER USER SCOTT account unlock;
ALTER USER SCOTT account lock;

-- Make sure account expiry, so upon login, it will ask for new one

ALTER USER a124 password expire;

-- Get default tablespace of a user:

set lines 200
col username for a23
select username,DEFAULT_TABLESPACE from dba_users where username='SCOTT';

USERNAME               DEFAULT_TABLESPACE
----------------------- ------------------------------
SCOTT                          USERS

-- Change default tablespace of a user:

ALTER USER SCOTT DEFAULT TABLESPACE DATATS;

select username,DEFAULT_TABLESPACE from dba_users where username='SCOTT';

USERNAME               DEFAULT_TABLESPACE
----------------------- ------------------------------
SCOTT                           DATATS

-- Get the current tablespace quota information of an user
set lines 299
select TABLESPACE_NAME,BYTES/1024/1024 "UTILIZIED_SPACE" ,MAX_BYTES/1024/1024 "QUOTA_ALLOCATED" from dba_ts_quotas where username='SCOTT';

TABLESPACE_NAME                                 UTILIZIED_SPACE                  QUOTA_ALLOCATED
------------------------------         ---------------------------        --------------------------
USERS                                           .0625                                    1024

--- Change the tablespace quota for the user to 5G

ALTER USER SCOTT QUOTA 5G ON USERS;

--- Grant unlimited tablespace quota:

ALTER USER SCOTT QUOTA UNLIMITED ON USERS;

--- You can connect to another user without knowing the password, with grant connect through privilege
--- Suppose a user TEST1 wants to connect to TEST2 user and create a table and we don’t know the password of TEST2.

Conn / as sysdba
SQL >alter user TEST2 grant connect through TEST1;

User altered.

SQL >conn TEST1[TEST2]
Enter password:< Give password for TEST1>

SQL >show user
USER is "TEST2"
SQL >create table emp_test as select * from emp;

Table created.

SQL > conn / as sysdba
connected
SQL > select owner from dba_tables where table_name='EMP_TEST';

OWNER
------
TEST2
