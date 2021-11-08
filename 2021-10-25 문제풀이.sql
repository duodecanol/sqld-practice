

SELECT DEPTNO, JOB FROM EMP;

SELECT DISTINCT DEPTNO, JOB FROM EMP;

SELECT DISTINCT JOB, DEPTNO FROM EMP;

SELECT DECODE(2, NULL, 'TRUE', 'FALSE') FROM DUAL;
SELECT DECODE(NULL, NULL, 'TRUE', 'FALSE') FROM DUAL;

SELECT * FROM TAB_A;
SELECT * FROM TAB_A WHERE COL1 != COL2;

select * from tab1;
UPDATE TAB1 SET C2 = '' WHERE C1='a';
COMMIT;
SELECT C2 FROM TAB1 WHERE C1='b';
SELECT NVL(C2, 'X') FROM TAB1 WHERE C1 = 'a';
SELECT COUNT(C1) FROM TAB1 WHERE C2= NULL;
SELECT COUNT(C2) FROM TAB1 WHERE C1 IN ('b', 'c');

SELECT 500/0 FROM DUAL;

SELECT * FROM EMP_Q;

SELECT SAL / COMM FROM EMP_Q WHERE ENAME = 'KING';
SELECT SAL / COMM FROM EMP_Q WHERE ENAME = 'FORD';
SELECT SAL / COMM FROM EMP_Q WHERE ENAME = 'SCOTT';


--2014년 11월~ 2015년 3월 매출 합계
SELECT * FROM 월별매출;
UPDATE 월별매출 SET MON = '03' WHERE MON='3';

SELECT SUM(SALE) FROM 월별매출
WHERE YR BETWEEN '2014' AND '2015' AND MON BETWEEN '03' AND '12';

SELECT SUM(SALE) FROM 월별매출
WHERE YR IN ('2014', '2015') AND MON IN ('11', '12', '03', '04', '05');

SELECT SUM(SALE) FROM 월별매출
WHERE (YR = '2014' OR YR = '2015') AND (MON BETWEEN '01' AND '03' OR MON BETWEEN '11' AND '12');

SELECT SUM(SALE) FROM 월별매출
WHERE YR = '2014' AND MON BETWEEN '11' AND '12'
    OR YR = '2015' AND MON BETWEEN '01' AND '03';


SELECT * FROM TAB1_NULL;
SELECT SUM(COALESCE(C1, C2, C3)) FROM TAB1_NULL;

SELECT AVG(C3) FROM TEST34;
SELECT AVG(C3) FROM TEST34 WHERE C1 > 0;
SELECT AVG(C3) FROM TEST34 WHERE C1 IS NOT NULL;

SELECT GRAD, COUNT(*) FROM TEST35 GROUP BY GRAD;
SELECT COUNT(GRAD) FROM TEST35; 
SELECT COUNT(*) FROM TEST35; 

/*******************************
    3. SQL 기본 - 4
********************************/

-- 1
CREATE TABLE TBL (ID NUMBER(3));
SELECT * FROM TBL;

SELECT ID FROM TBL
GROUP BY ID HAVING COUNT(*) = 2
ORDER BY (CASE WHEN ID=999 THEN 0 ELSE ID END);

-- 2
SELECT * FROM TEST42;

SELECT 지역, SUM(매출금액) AS 매출금액 FROM TEST42
GROUP BY 지역 ORDER BY 매출금액 DESC;

SELECT 지역, 매출금액 FROM TEST42
ORDER BY 년 DESC;

SELECT 지역, SUM(매출금액) AS 매출금액 FROM TEST42
GROUP BY 지역 
ORDER BY 년 DESC;

SELECT 지역, SUM(매출금액) AS 매출금액 FROM TEST42
GROUP BY 지역 HAVING SUM(매출금액) > 600
ORDER BY COUNT(*) DESC;

INSERT INTO TEST42 VALUES('서울', 2019, 900);
INSERT INTO TEST42 VALUES('서울', 2018, 1000);
INSERT INTO TEST42 VALUES('부산', 2019, 1100);
INSERT INTO TEST42 VALUES('대구', 2021, 1200);
COMMIT;

SELECT 지역, SUM(매출금액) AS 매출금액, COUNT(*)
FROM TEST42
GROUP BY 지역 HAVING SUM(매출금액) > 600
ORDER BY COUNT(*) DESC; --- COUNT(*) 는 GROUP BY에서 그루핑된 컬럼 기준으로 합쳐진 속성의 개별 COUNT가 된다.

DROP TABLE TBL;

CREATE TABLE TBL(
    ID CHAR(1), AMT NUMBER(3)
);

INSERT INTO TBL VALUES('A', 50);
INSERT INTO TBL VALUES('A', 200);
INSERT INTO TBL VALUES('B', 300);
INSERT INTO TBL VALUES('C', 100);
COMMIT;

SELECT * FROM TBL;
SELECT ID, AMT
FROM TBL
ORDER BY (CASE WHEN ID='A' THEN 1 ELSE 2 END), AMT DESC;


/*******************************
    3. SQL 기본 - 5
********************************/

SELECT * FROM TEST;
ALTER TABLE TEST DROP NUM1;
ALTER TABLE TEST DROP COLUMN NUM1;

-- 8
CREATE TABLE BOARD58 (
    BOARD_ID    VARCHAR2(10) PRIMARY KEY,
    BOARD_NM    VARCHAR2(50) NOT NULL,
    USE_YM      VARCHAR2(1) NOT NULL,
    REG_DATE    DATE NOT NULL,
    BOARD_DESC  VARCHAR2(100) NULL
);
SET ESCAPE ON;
DELETE FROM BOARD58;
SELECT * FROM BOARD58;
COMMIT;
INSERT INTO BOARD58 VALUES (1, 'Q\&A', 'Y', SYSDATE, 'Q\&A 게시판');

INSERT INTO BOARD58 (BOARD_ID, BOARD_NM, USE_YM, BOARD_DESC)
            VALUES ('100', 'FAQ', 'Y', 'FAQ 게시판');
            
UPDATE BOARD58 SET USE_YM = 'N' WHERE BOARD_ID = '1';

INSERT INTO BOARD58 VALUES ('100', 'COMPLAIN', 'N', SYSDATE, 'COMPLAIN 게시판');

UPDATE BOARD58 SET BOARD_ID=200 WHERE BOARD_ID = '100';


--9
SELECT * FROM TEST;
DELETE * FROM TEST; -- ERROR
DELETE FROM TEST;  -- DELETE ALL DATA WITH LOGGING
TRUNCATE TABLE TEST; -- DELETE ALL DATA CLEAR
DROP TABLE TEST;      -- DELETE ALL DATA WITH TABLE ITSELF

ROLLBACK;

/*******************************
    4. SQL 활용 - 1
********************************/
-- 8번  차집합과 동일한 결과를 내는 쿼리를 기술하라.
SELECT ENAME, SAL FROM EMP WHERE DEPTNO = 20
    INTERSECT
SELECT ENAME, SAL FROM EMP WHERE JOB = 'CLERK';

-- 문제 보기의 EXCEPT문을 사용
WITH DEPT20 AS ( SELECT ENAME, SAL FROM EMP WHERE DEPTNO = 20 )
    , CLERKS AS ( SELECT ENAME, SAL FROM EMP WHERE JOB = 'CLERK' )
SELECT ENAME, SAL FROM DEPT20
    EXCEPT
SELECT ENAME, SAL FROM CLERKS;

WITH DEPT20 AS ( SELECT ENAME, SAL FROM EMP WHERE DEPTNO = 20 )
    , CLERKS AS ( SELECT ENAME, SAL FROM EMP WHERE JOB = 'CLERK' )
SELECT ENAME, SAL FROM DEPT20
    MINUS --- EXCEPT / MINUS가 다된다.
SELECT ENAME, SAL FROM CLERKS;

-- 1번보기, 두 테이블의 PRODUCT로부터의 속성이 서로 같지 않은 것
WITH DEPT20 AS ( SELECT ENAME, SAL FROM EMP WHERE DEPTNO = 20 )
    , CLERKS AS ( SELECT ENAME, SAL FROM EMP WHERE JOB = 'CLERK' )
SELECT B.ENAME, B.SAL
FROM DEPT20 A, CLERKS B -- 일단 PRODUCT를 했기때문에 결과가 너무많음
WHERE A.ENAME <> B.ENAME AND A.SAL <> B.SAL;
-- 2번보기, 1번테이블에서 B에 존재하지 않는 컬럼값의 행들을 조회
WITH DEPT20 AS ( SELECT ENAME, SAL FROM EMP WHERE DEPTNO = 20 )
    , CLERKS AS ( SELECT ENAME, SAL FROM EMP WHERE JOB = 'CLERK' )
SELECT A.ENAME, A.SAL
FROM DEPT20 A
WHERE A.ENAME NOT IN (SELECT ENAME FROM CLERKS)
    AND A.SAL NOT IN (SELECT SAL FROM CLERKS);

-- 11번

CREATE TABLE TAB1_511 
(
    COL1 CHAR(2),
    COL2 CHAR(2)
);

INSERT INTO TAB1_511 VALUES ('AA', 'A1');
INSERT INTO TAB1_511 VALUES ('AB', 'A2');
COMMIT;

CREATE TABLE TAB2_511 
(
    COL1 CHAR(2),
    COL2 CHAR(2)
);

INSERT INTO TAB2_511 VALUES ('AA', 'A1');
INSERT INTO TAB2_511 VALUES ('AB', 'A2');
INSERT INTO TAB2_511 VALUES ('AC', 'A3');
INSERT INTO TAB2_511 VALUES ('AD', 'A4');

SELECT * FROM TAB1_511;
SELECT * FROM TAB2_511;

SELECT
    COL1, COL2, COUNT(*) AS CNT
FROM (SELECT * FROM TAB1_511
        UNION ALL
      SELECT * FROM TAB2_511
        UNION -- 위에서는 UNION ALL 을 했지만 이번에는 UNION을 하면서 중복제거/정렬이 일어난다.
      SELECT * FROM TAB1_511)
GROUP BY COL1, COL2;

SELECT
    COL1, COL2, COUNT(*) AS CNT
FROM (SELECT * FROM TAB1_511
        UNION ALL
      SELECT * FROM TAB2_511
        UNION ALL -- UNION ALL 두번하면 중복이 허용되므로 CNT가 달라진다.
      SELECT * FROM TAB1_511)
GROUP BY COL1, COL2;