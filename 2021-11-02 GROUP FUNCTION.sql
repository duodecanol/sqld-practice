/*******************************
    GROUP FUNCTION      p.190
        1 ROLLUP
        2 
********************************/

-- ROLLUP
SELECT 
    DEPTNO,
    SUM(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO);

SELECT 
    DEPTNO, JOB,
    SUM(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB);


