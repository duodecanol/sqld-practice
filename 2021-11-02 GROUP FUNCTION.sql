/*******************************
    GROUP FUNCTION      p.190
-------------------------------
        1 ROLLUP : 합계/소계를 한꺼번에 구한다. SUM/ SUM TOTAL
        2 GROUPING : 합계값을 구분한다.
        3 GROUPING SETS : 
        4 CUBE : 
********************************/

-------------------------------------------------------
-- ROLLUP 1
SELECT JOB, SUM(SAL)
FROM EMP
GROUP BY JOB; -- 단순히 GB를 하면 DISTINCT별 소계를 보여준다.

SELECT JOB, SUM(SAL)
FROM EMP
GROUP BY ROLLUP(JOB); -- ROLLUP을 함으로써 그룹별 소계와, 전체 총합을 같이 볼 수 있다.

-------------------------------------------------------
-- ROLLUP 2 
SELECT 
    DEPTNO,
    SUM(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO); -- 값이 하나만 있을 경우에는 소계만 나온다.

SELECT 
    DEPTNO, 
    COALESCE(JOB, '의 합계'), -- DEPTNO.LEN = 3, JOB.LEN = 5
    SUM(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB)
ORDER BY DEPTNO; -- 값이 두 개 이상인 경우에는, 왼쪽 값을 기준으로 오른쪽의 조합을 중 표시ㅣ

-------------------------------------------------------
-- CUBE
SELECT 
    DEPTNO,
    SUM(SAL)
FROM EMP
GROUP BY CUBE(DEPTNO); -- 값이 하나만 있을 경우에는 소계만 나온다.

SELECT 
    DEPTNO,
    COALESCE(JOB, '의 합계'), -- DEPTNO.LEN = 3, JOB.LEN = 5
    SUM(SAL)
FROM EMP
GROUP BY CUBE(DEPTNO, JOB) -- 서로 속하는 경우의 수를 다 구한다.
ORDER BY DEPTNO;

-------------------------------------------------------
--GROUPING SETS
SELECT  
    DEPTNO,
    JOB, -- DEPTNO.LEN = 3, JOB.LEN = 5
    SUM(SAL)
FROM EMP
GROUP BY GROUPING SETS(DEPTNO, JOB) -- GROUP BY A // B를 따로 구해서 UNION 한다.
ORDER BY DEPTNO;

-------------------------------------------------------
-- LISTAGG()
SELECT
    JOB,
    LISTAGG(ENAME, ' // ') WITHIN GROUP(ORDER BY EMPNO) LISTAGG
FROM EMP
GROUP BY JOB;

---------------------------------------------------------------
--      COMPARISON OF ROLLUP / CUBE / GROUPING SETS         --

|   ROLLUP(A,B)     |      CUBE(A,B)       |  GROUPING SETS(A,B)   
---------------------------------------------------------------
| GROUP BY A, B     |     GROUP BY A,B     |      
| GROUP BY A        |     GROUP BY A       |    GROUP BY A
|                   |     GROUP BY B       |    GROUP BY B
| GROUP BY NULL     |     GROUP BY NULL    |       
---------------------------------------------------------------


---------------------------------------------------------------
--         YIELD SAME RESULT WITH GROUPING SETS()            --

|   ROLLUP(A,B)     |      CUBE(A,B)       |  GROUPING SETS(A,B)   
---------------------------------------------------------------
| GROUPING SETS(    | GROUPING SETS(       | GROUPING SETS(      
|     (A, B)        |     (A, B)           |     
|     , A           |     , A, B           |    A, B
|     , NULL )      |     , NULL )         |    )   
---------------------------------------------------------------
-- *Note: 'NULL's in each case are interchangeable with '()'


