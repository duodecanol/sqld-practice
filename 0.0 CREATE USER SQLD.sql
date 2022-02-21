/**********************************************************************
 * 2.1 사용자 계정 및 테이블스페이스 생성
 * 
 **********************************************************************/

-- Execute the commands by root privilege
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

CREATE USER SQLD IDENTIFIED BY 1234;
ALTER USER SQLD ACCOUNT UNLOCK;
GRANT RESOURCE, DBA, CONNECT TO SQLD;
