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
-- 4번보기가 정답이지만 2번보기도 같은 결과값을 출력하고 있어 질문드립니다.

SELECT ENAME, SAL FROM EMP WHERE DEPTNO = 20
    INTERSECT  -- 교집합을 먼저 체크하여 결과를 예상해본다.
SELECT ENAME, SAL FROM EMP WHERE JOB = 'CLERK';

/*
  Table 1         Table 2

ENAME|SAL |		ENAME |SAL |
-----+----+		------+----+
SMITH| 800|		SMITH | 800|
JONES|2975|		ADAMS |1100|
SCOTT|3000|		JAMES | 950|
ADAMS|1100|		MILLER|1300|
FORD |3000|		
 * */

-- 문제 보기의 EXCEPT문을 사용
WITH DEPT20 AS ( SELECT ENAME, SAL FROM EMP WHERE DEPTNO = 20 )
    , CLERKS AS ( SELECT ENAME, SAL FROM EMP WHERE JOB = 'CLERK' )
SELECT ENAME, SAL FROM DEPT20
    EXCEPT -- SQL developer에서는 실행됨.
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
WHERE A.ENAME NOT IN (SELECT B.ENAME FROM CLERKS B)
    AND A.SAL NOT IN (SELECT B.SAL FROM CLERKS B);
-- 3번보기, 조인 // INTERSECT와 결과값이 같다.
WITH DEPT20 AS ( SELECT ENAME, SAL FROM EMP WHERE DEPTNO = 20 )
    , CLERKS AS ( SELECT ENAME, SAL FROM EMP WHERE JOB = 'CLERK' )
SELECT B.ENAME, B.SAL
FROM DEPT20 A, CLERKS B
WHERE A.ENAME = B.ENAME AND A.SAL = B.SAL;
--4번보기
WITH DEPT20 AS ( SELECT ENAME, SAL FROM EMP WHERE DEPTNO = 20 )
    , CLERKS AS ( SELECT ENAME, SAL FROM EMP WHERE JOB = 'CLERK' )
SELECT A.ENAME, A.SAL
FROM DEPT20 A
WHERE NOT EXISTS (SELECT 'X' FROM CLERKS B WHERE A.ENAME = B.ENAME AND A.SAL = B.SAL);

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

--18번문제  : 부양가족이 없는 사원의 이름 구하기

-- 테이블 생성
CREATE TABLE "TT_EMP_18HARD" 
   ("EMPNO" NUMBER(38,0), 
	"ENAME" VARCHAR2(26), 
	"AGE" NUMBER(38,0)
   );

INSERT INTO TT_EMP_18HARD (EMPNO,ENAME,AGE) VALUES
	 (6754,'JOHN',24),
	 (6755,'CHRIS',44),
	 (6756,'GEORGE',35),
	 (6759,'ANATOLY',65);

CREATE TABLE "TT_SUPPORTEDFAMILIY_18HARD" 
   ("NAME" VARCHAR2(26), 
	"AGE" NUMBER(38,0), 
	"EMPNO_REF" NUMBER(38,0)
   );
INSERT INTO TT_SUPPORTEDFAMILIY_18HARD (NAME,AGE,EMPNO_REF) VALUES
	 ('MAX',66,6754),
	 ('MAHON',75,6755),
	 ('NIXON',46,6755),
	 ('GARRISON',59,6755);

-- 테이블 체크
SELECT * FROM TT_EMP_18HARD;
SELECT * FROM TT_SUPPORTEDFAMILIY_18HARD;
/*
            SELECT 이름 
            FROM 사원
            WHERE (           )
            (SELECT * FROM 가족 WHERE (           ));
*/
--/////////// SOLUTION 1
SELECT * 
FROM TT_EMP_18HARD 
WHERE NOT EXISTS 
(SELECT * FROM TT_SUPPORTEDFAMILIY_18HARD WHERE EMPNO_REF = EMPNO);

--/////////// SOLUTION 2
SELECT * FROM TT_EMP_18HARD 
WHERE EMPNO NOT IN 
(SELECT EMPNO FROM (SELECT * FROM TT_SUPPORTEDFAMILIY_18HARD WHERE EMPNO_REF = EMPNO));
SELECT * FROM TT_EMP_18HARD 
WHERE ENAME NOT IN 
(SELECT ENAME FROM (SELECT * FROM TT_SUPPORTEDFAMILIY_18HARD WHERE EMPNO_REF = EMPNO));

--/////////// SOLUTION 3    문제에서 주어진 형식을 다소 벗어남
SELECT TT_EMP_18HARD.* 
FROM TT_EMP_18HARD LEFT OUTER JOIN TT_SUPPORTEDFAMILIY_18HARD ON TT_EMP_18HARD.EMPNO = TT_SUPPORTEDFAMILIY_18HARD.EMPNO_REF
WHERE TT_SUPPORTEDFAMILIY_18HARD.EMPNO_REF IS NULL;

--/////////// SOULTION 4    문제에서 주어진 형식을 다소 벗어남
-- 될거같다고 생각했는데 모든 값이 나옵니다.
-- SUBQUERY는 NULL인데 EXISTS에서는 NOT NULL로 평가???
-- Column name ambiguity를 해소하니 기대하는 결과값이 출력되었습니다.
SELECT * 
FROM TT_EMP_18HARD X
WHERE EXISTS
(
SELECT A.EMPNO FROM TT_EMP_18HARD A WHERE A.EMPNO = X.EMPNO
	MINUS
SELECT EMPNO_REF FROM (SELECT * FROM TT_SUPPORTEDFAMILIY_18HARD B WHERE B.EMPNO_REF = X.EMPNO)
);
    
SELECT A.EMPNO FROM TT_EMP_18HARD A WHERE A.EMPNO = 6756 -- 부양가족이 없는 6756번 GEORGE 
        MINUS
SELECT EMPNO_REF FROM TT_SUPPORTEDFAMILIY_18HARD WHERE EMPNO_REF = 6756; -- RESULT: 6756

SELECT A.EMPNO FROM TT_EMP_18HARD A WHERE A.EMPNO = 6754 -- 부양가족이 있는  6754번 JOHN
        MINUS
SELECT EMPNO_REF FROM tt_supportedfamiliy_18hard WHERE EMPNO_REF = 6754; -- RESULT: NOTHING



SELECT EMPNO, ENAME, MGR FROM EMP
ORDER BY MGR;

-- 15번문제  사원들의 매니저 ORDER SIBLINGS BY [COL] 순서를 묻는다.
SELECT EMPNO, ENAME, LEVEL, MGR FROM (SELECT * FROM EMP WHERE EMPNO IN (7698, 7566) OR MGR IN (7698, 7566))
START WITH MGR = 7839
CONNECT BY PRIOR EMPNO = MGR
ORDER SIBLINGS BY EMPNO;

-- 두 결과가 같다.  같은 이유는?
SELECT EMPNO, ENAME, LEVEL, MGR FROM (SELECT * FROM EMP WHERE EMPNO IN (7698, 7566) OR MGR IN (7698, 7566))
START WITH MGR = 7839
CONNECT BY PRIOR EMPNO = MGR
ORDER SIBLINGS BY MGR;



/*******************************
    4. SQL 활용 - 2
********************************/
CREATE VIEW VIEW1 AS
SELECT EMPNO, ENAME, SAL FROM EMP;

SELECT * FROM VIEW1;

/*
 * EMP, DEPT 테이블을 조인하여 
 * EMPNO, ENAME, SAL, DNAME, LOC 출력하는 VIEW 생성
*/
CREATE VIEW VIEW2 AS
SELECT EMPNO, ENAME, SAL, DNAME, LOC
FROM EMP NATURAL JOIN DEPT;

SELECT * FROM VIEW2;
/*
 * 과제: 
 * 1. 뷰를 생성하고 나서  원래 테이블을 삭제한 후 뷰 FETCH 되는지?
 * 2. 뷰를 생성하고 나서 원래 테이블의 컬럼명을 변경한 후 FETCH 되는지?
 * 3. 뷰를 생성하고 나서 원래 테이블의 값을 UPDATE/DELETE/INSERT한후 뷰 내용이 변경되는지?
 * 4. 뷰를 업데이트하면 원래 테이블이 영향받는지?
 * 5. 뷰의 업데이트 제한 사항은 어떻게 세분되는지?
*/
-- 2번문제 
CREATE TABLE TBL422 (C1 CHAR(1), C2 NUMBER);
INSERT INTO TBL422 VALUES ('A', 100);
INSERT INTO TBL422 VALUES ('B', 200);
INSERT INTO TBL422 VALUES ('B', 100);
INSERT INTO TBL422 VALUES ('B', NULL);
INSERT INTO TBL422 VALUES (NULL, 200);
-- CHECK CREATED TABLE
SELECT * FROM TBL422;
-- CREATE VIEW
CREATE VIEW V_TBL422 AS
SELECT * FROM TBL422
WHERE C1 = 'B' OR C1 IS NULL;
-- CHECK CREATED VIEW
SELECT * FROM V_TBL422;
-- CHECK QUERY
SELECT SUM(C2) C2 FROM V_TBL422
WHERE C2 >= 200 AND C1 = 'B';

ROLLUP (A,B)
GROUP BY A,B
GROUP BY A
GROUP BY NULL

CUBE (A,B)
GROUP BY A,B
GROUP BY A
GROUP BY B
GROUP BY NULL

GROUPING SETS (A,B)
GROUP BY A
GROUP BY B


-- 4번문제: ROLLUP/GROUPING SETS/CUBE 결과를 머리속으로 구현할 수 있는지?
SELECT DEPTNO, JOB, SUM(SAL) 
FROM EMP
GROUP BY CUBE(DEPTNO, JOB)
ORDER BY DEPTNO  -- ORDER BY를 안해주면 DEPTNO의 NULL값이 맨위로 올라온다.
;
SELECT DEPTNO, JOB, SUM(SAL) 
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB)
ORDER BY DEPTNO
;
SELECT DEPTNO, JOB, SUM(SAL) 
FROM EMP
GROUP BY GROUPING SETS(DEPTNO, JOB)
ORDER BY DEPTNO
;

-- 5번문제: GROUPING SETS의 결과를 구현하라.
CREATE TABLE 월별매출425 ( PRODID CHAR(4), YM CHAR(7), SALES NUMBER );
INSERT INTO 월별매출425 VALUES ('P001', '2014.10', 1500);
INSERT INTO 월별매출425 VALUES ('P001', '2014.11', 1500);
INSERT INTO 월별매출425 VALUES ('P001', '2014.12', 2500);
INSERT INTO 월별매출425 VALUES ('P002', '2014.10', 1000);
INSERT INTO 월별매출425 VALUES ('P002', '2014.11', 2000);
INSERT INTO 월별매출425 VALUES ('P002', '2014.12', 1500);
INSERT INTO 월별매출425 VALUES ('P003', '2014.10', 2000);
INSERT INTO 월별매출425 VALUES ('P003', '2014.11', 1000);
INSERT INTO 월별매출425 VALUES ('P003', '2014.12', 1000);
COMMIT;
SELECT * FROM 월별매출425;
-- WRITE AND EXECUTE QUERY IN INTEREST
SELECT PRODID, YM, SUM(SALES) AS 매출액
FROM 월별매출425
WHERE YM BETWEEN '2014.10' AND '2014.12'
GROUP BY GROUPING SETS (PRODID, YM);

--7번문제 윈도우함수 결과를 머릿속으로 구현
DROP TABLE 추천내역427;
CREATE TABLE 추천내역427 (LIKEROUTE VARCHAR(50), LIKESUBJECT VARCHAR(50), LIKEOBJECT VARCHAR(50), LIKESCORE NUMBER);
INSERT INTO 추천내역427 VALUES ('SNS', '나한일', '강감찬', 75);
INSERT INTO 추천내역427 VALUES ('SNS', '이순신', '강감찬', 80);
INSERT INTO 추천내역427 VALUES ('이벤트응모', '홍길동', '강감찬', 88);
INSERT INTO 추천내역427 VALUES ('이벤트응모', '저절로', '이순신', 78);
INSERT INTO 추천내역427 VALUES ('홈페이지', '저절로', '이대로', 93);
INSERT INTO 추천내역427 VALUES ('홈페이지', '홍두깨', '심청이', 98);
COMMIT;
SELECT * FROM 추천내역427;
-- WRITE AND EXECUTE QUERY IN INTEREST
SELECT LIKEROUTE, LIKESUBJECT, LIKEOBJECT, LIKESCORE
FROM (SELECT LIKEROUTE, LIKESUBJECT, LIKEOBJECT, LIKESCORE, ROW_NUMBER()
        OVER (PARTITION BY LIKEROUTE ORDER BY LIKESCORE DESC) AS RNUM
        FROM 추천내역427)
WHERE RNUM = 1;
