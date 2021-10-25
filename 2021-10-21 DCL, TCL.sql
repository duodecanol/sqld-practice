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

-- TEST TABLE 만들기
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
--------- AUTOCOMMIT을 꺼놓아야 합니다 -------------
위 구문을 실행한 뒤에 CLI - SQLPLUS에서 같은 사용자로 접속한 세션을 띄운다.   
여기서 같은 사용자명으로 두 개의 세션 SQL DEVELOPER "A" AND  SQLPLUS "B" 생성된다.
B에서는 TEST1을 조회해도 "선택된 레코드가 없습니다" 라고 나온다.
반면 A에서는 하나의 튜플이 조회된다.
이제 A에서 COMMIT을 수행한 다음 B에서 다시 TEST1 테이블을 조회하면 레코드가 조회된다.
*/
COMMIT;

CREATE TABLE TEST2 (         -- DDL이라 즉시 모든 세션에 반영
    DATA1 NUMBER(10) NOT NULL,
    DATA2 NUMBER(10) NOT NULL
);
SELECT * FROM TEST2;

INSERT INTO TEST2 VALUES (111, 222);
INSERT INTO TEST2 VALUES (1231, 9631);
INSERT INTO TEST2 VALUES (1237896, 785242);

COMMIT;
TRUNCATE TABLE TEST2;  -- DDL이라 즉시 모든 세션에 반영


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

ROLLBACK TO T2; -- COMMIT 이후에 생긴 SAVEPOINT는 무효화된다.

SAVEPOINT T1;
UPDATE TEST1 SET DATA2=1 WHERE DATA1=101;

SAVEPOINT T2;
UPDATE TEST1 SET DATA2=2 WHERE DATA1=101;
UPDATE TEST1 SET DATA2=22222 WHERE DATA1=1011;

SAVEPOINT T3;
UPDATE TEST1 SET DATA2=3 WHERE DATA1=2;
UPDATE TEST1 SET DATA2=33333 WHERE DATA1=22222;

