/**********************************************************************
 * PART3 SQL 기본 및 활용 p.210
 **********************************************************************/



-----------------------------------------------------------------------
-- 11. 
SELECT ENAME, SAL,
	LEAD (SAL) OVER (ORDER BY ENAME) AS SAL1
FROM EMP;


-----------------------------------------------------------------------
-- 12 
SELECT
	LEVEL, EMPNO, ENAME, MGR
FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;


-----------------------------------------------------------------------
--13
SELECT DNAME, JOB, SUM(A.SAL) SAL, COUNT(A.EMPNO)
FROM EMP A, DEPT B
WHERE A.DEPTNO = B.DEPTNO
GROUP BY ROLLUP(B.DNAME, A.JOB);


-- EMP 테이블에서 MGR 칼럼이 NULL이면 9999로 출력하는 SELECT문을 작성하시오.
SELECT NVL(MGR, '9999'), MGR
FROM EMP;

-- 모든 관리자보다 월급이 많은 직원을 조회한다.
SELECT A.*, B.SAL
FROM EMP A, EMP B
WHERE A.MGR = B.EMPNO AND
	  A.SAL >= ANY B.SAL;


-- SELECT SYSDATE FROM DUAL; 날짜 데이터를 문자로 바꾸고 
-- 문자에서 연도만 출력하는 SQL문을 작성하시오.
SELECT TO_CHAR(
	(SELECT SYSDATE FROM DUAL), 'YYYY'
)FROM DUAL;

SELECT TO_CHAR(
	EXTRACT(YEAR FROM SYSDATE)
)FROM DUAL;



-----------------------------------------------------------------------
--다음 SQL문을 ANSI/ISO 표준 SQL문으로 바꾸시오.
SELECT * FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO;

SELECT * FROM EMP INNER JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO;

SELECT * FROM EMP JOIN DEPT
USING (DEPTNO);

SELECT * FROM EMP NATURAL JOIN DEPT
;