CREATE TABLE TEST1 (
    DATA1 NUMBER(10) NOT NULL,
    DATA2 NUMBER(10) NOT NULL
);

/*******************************
    DCL (Data Control Language)
    -----------------------
    GRANT       p.160
********************************/

SELECT * FROM all_users
ORDER BY created DESC;

-->>>>>>>>>>>>>> SQLPLUS CLI >>>>>>>>>>>>>>>>>>>>>>>>>>>
--SYSDBA>>>>>>>>>>>>>>
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
CREATE USER WOW;
DROP USER WOW;

CREATE USER WOW IDENTIFIED BY 1234;

GRANT CREATE SESSION TO WOW;
GRANT SELECT ON TEST1 TO WOW;
GRANT INSERT ON TEST1 TO WOW;

CONNECT USER WOW/1234;

--WOW>>>>>>>>>>>>>>
SELECT * FROM SQLD.TEST1;


/**************************************************************
    TCL (Transaction Control Language)
    COMMIT       p.162
***************************************************************/

-- TEST TABLE �����
CREATE TABLE TEST1 (
    DATA1 NUMBER(10) NOT NULL,
    DATA2 NUMBER(10) NOT NULL
);
SELECT * FROM TEST1;

INSERT INTO TEST1 VALUES (101, 201);
INSERT INTO TEST1 VALUES (1011, 2201);

SET AUTOCOMMIT ON;
SET AUTOCOMMIT OFF;
/*
--------- AUTOCOMMIT�� �����ƾ� �մϴ� -------------
�� ������ ������ �ڿ� CLI - SQLPLUS���� ���� ����ڷ� ������ ������ ����.   
���⼭ ���� ����ڸ����� �� ���� ���� SQL DEVELOPER "A" AND  SQLPLUS "B" �����ȴ�.
B������ TEST1�� ��ȸ�ص� "���õ� ���ڵ尡 �����ϴ�" ��� ���´�.
�ݸ� A������ �ϳ��� Ʃ���� ��ȸ�ȴ�.
���� A���� COMMIT�� ������ ���� B���� �ٽ� TEST1 ���̺��� ��ȸ�ϸ� ���ڵ尡 ��ȸ�ȴ�.
*/
COMMIT;

CREATE TABLE TEST2 (         -- DDL�̶� ��� ��� ���ǿ� �ݿ�
    DATA1 NUMBER(10) NOT NULL,
    DATA2 NUMBER(10) NOT NULL
);
SELECT * FROM TEST2;

INSERT INTO TEST2 VALUES (111, 222);
INSERT INTO TEST2 VALUES (1231, 9631);
INSERT INTO TEST2 VALUES (1237896, 785242);

COMMIT;
TRUNCATE TABLE TEST2;  -- DDL�̶� ��� ��� ���ǿ� �ݿ�


/*******************************
    ROLLBACK p.163
********************************/

/*******************************
    SAVEPOINT p.164
********************************/
SELECT * FROM TEST1;

SAVEPOINT T1;
UPDATE TEST1 SET DATA2=999 WHERE DATA1=101;

COMMIT;

SAVEPOINT T2;
UPDATE TEST1 SET DATA2=666 WHERE DATA1=101;
UPDATE TEST1 SET DATA2=99999999 WHERE DATA1=1011;
COMMIT;

SAVEPOINT T3;

ROLLBACK TO T2; -- COMMIT ���Ŀ� ���� SAVEPOINT�� ��ȿȭ�ȴ�.

SAVEPOINT T1;
UPDATE TEST1 SET DATA2=1 WHERE DATA1=101;

SAVEPOINT T2;
UPDATE TEST1 SET DATA2=2 WHERE DATA1=101;
UPDATE TEST1 SET DATA2=22222 WHERE DATA1=1011;

SAVEPOINT T3;
UPDATE TEST1 SET DATA2=3 WHERE DATA1=2;
UPDATE TEST1 SET DATA2=33333 WHERE DATA1=22222;

