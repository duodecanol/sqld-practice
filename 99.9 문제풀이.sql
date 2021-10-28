/**********************************************************************
 * 
 **********************************************************************/
-----------------------------------------------------------------------
--
SELECT COALESCE(NULL, 4, 2, 5) FROM DUAL;

SELECT MAX(A), MAX(B) FROM (
	SELECT 'Limbest' A, '' B FROM DUAL
	UNION ALL
	SELECT '' A, '기술사' B FROM DUAL
);

/**********************************************************************
 * 5.11		PART 3 SQL 기본 및 활용 연습문제
 **********************************************************************/

-----------------------------------------------------------------------
-- 문제 22	p.250
CREATE TABLE Y_DEPT_22
(
	DEPTNO CHAR(4),
	DEPTNM VARCHAR2(50) NOT NULL,
	CONSTRAINT Y_DEPT_22_PK PRIMARY KEY (DEPTNO)
);

INSERT INTO Y_DEPT_22 (DEPTNO, DEPTNM) VALUES ('D001', 'DATA TEAM');
INSERT INTO Y_DEPT_22 (DEPTNO, DEPTNM) VALUES ('D002', 'JAVA DEV TEAM');

COMMIT; 
SELECT * FROM Y_DEPT_22;

CREATE TABLE Y_Y_DEPT_22_TMP AS 
SELECT * FROM Y_DEPT_22;
-- 제약조건은 AS SELECT로  CREATE TABLE 시에 복사되지 않는다.

-----------------------------------------------------------------------
-- 문제 23	p.251
CREATE TABLE Y_DEPT_23
(
	DEPTNO CHAR(4) PRIMARY KEY,  -- 제약조건을 여기다 써도 복사되지 않느다.
	DEPTNM VARCHAR2(50) NOT NULL	 -- NOT NULL은 복사된다.
);

INSERT INTO Y_DEPT_23 (DEPTNO, DEPTNM) VALUES ('D001', 'DATA TEAM');
INSERT INTO Y_DEPT_23 (DEPTNO, DEPTNM) VALUES ('D002', 'JAVA DEV TEAM');

COMMIT; 
SELECT * FROM Y_DEPT_23;

CREATE TABLE Y_Y_DEPT_23_TMP AS 
SELECT * FROM Y_DEPT_23;

SELECT COUNT (DISTINCT INDUTY_LRGE_CL_CD) FROM TB_BSSH;
