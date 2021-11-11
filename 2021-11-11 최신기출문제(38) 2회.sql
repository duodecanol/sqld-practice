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