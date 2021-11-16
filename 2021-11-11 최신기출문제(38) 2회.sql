/**************************************************************
    PART 05 --- SQLD 최신기출문제
    SQLD 최신기출문제 (38회) 2회       p.326
***************************************************************/

/*******************************
    16. COUNT의 이해 p.331
********************************/

SELECT COUNT(1) FROM EMP; -- 14

/*******************************
    18. 소계함수들     p.332
********************************/

SELECT DNAME, JOB, SUM(SAL)
FROM EMP NATURAL JOIN DEPT
GROUP BY CUBE(DNAME, JOB)
ORDER BY DNAME;

SELECT DNAME, JOB, SUM(SAL)
FROM EMP NATURAL JOIN DEPT
GROUP BY GROUPING SETS(DNAME, JOB, (DNAME, JOB))
ORDER BY DNAME;

SELECT DNAME, JOB, SUM(SAL)
FROM EMP NATURAL JOIN DEPT
GROUP BY ROLLUP(DNAME, JOB)
ORDER BY DNAME;

/*******************************
    27. 사원이 없는 부서     p.336
********************************/
SELECT * FROM EMP;
SELECT * FROM DEPT; -- 40 VOID

-- 1번보기  EMP에서 부서번호만 모다놓고 하나도 해당없는것을 FETCH
SELECT DEPTNO FROM DEPT
WHERE DEPTNO NOT IN (SELECT DEPTNO FROM EMP);

-- 2번보기 부서번호가 일치하는 결과를 모았는데 결과가 하나도 없는 것을 FETCH
SELECT DEPTNO FROM DEPT A
WHERE NOT EXISTS (SELECT * FROM EMP B WHERE A.DEPTNO = B.DEPTNO);

-- 3번보기 DEPT를 기준으로 OUTER JOIN했는데 사원번호가 NULL인 경우를 FETCH
SELECT B.DEPTNO 
FROM EMP A RIGHT OUTER JOIN DEPT B ON A.DEPTNO = B.DEPTNO
WHERE EMPNO IS NULL;

-- 4번보기 EMP에서 부서번호만 모아놨는데 하나라도 현재 부서번호와 일치하지 않는 경우
SELECT DEPTNO FROM DEPT
WHERE DEPTNO <> ANY (SELECT DEPTNO FROM EMP);

/*******************************
    45. 이거 아니면 저거 --- 변수에 스칼라값 넣기 p.336
********************************/

SELECT DECODE(DEPTNO, 10, 'A', 20, 'B')
FROM DEPT;

SET SERVEROUTPUT ON 
DECLARE
V_NAME EMP.ENAME%TYPE;
BEGIN
SELECT ENAME INTO V_NAME FROM EMP WHERE EMPNO = 7934;
DBMS_OUTPUT.PUT_LINE('============');
DBMS_OUTPUT.PUT_LINE(V_NAME);
DBMS_OUTPUT.PUT_LINE('============');
END;
/
