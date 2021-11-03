/*******************************
    GROUP FUNCTION      p.190
-------------------------------
        1 ROLLUP : �հ�/�Ұ踦 �Ѳ����� ���Ѵ�. SUM/ SUM TOTAL
        2 GROUPING : �հ谪�� �����Ѵ�.
        3 GROUPING SETS : 
        4 CUBE : 
********************************/

-------------------------------------------------------
-- ROLLUP 1
SELECT JOB, SUM(SAL)
FROM EMP
GROUP BY JOB; -- �ܼ��� GB�� �ϸ� DISTINCT�� �Ұ踦 �����ش�.

SELECT JOB, SUM(SAL)
FROM EMP
GROUP BY ROLLUP(JOB); -- ROLLUP�� �����ν� �׷캰 �Ұ��, ��ü ������ ���� �� �� �ִ�.

-------------------------------------------------------
-- ROLLUP 2 
SELECT 
    DEPTNO,
    SUM(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO); -- ���� �ϳ��� ���� ��쿡�� �Ұ踸 ���´�.

SELECT 
    DEPTNO, 
    COALESCE(JOB, '�� �հ�'), -- DEPTNO.LEN = 3, JOB.LEN = 5
    SUM(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB)
ORDER BY DEPTNO; -- ���� �� �� �̻��� ��쿡��, ���� ���� �������� �������� ������ �� ǥ�ä�

-------------------------------------------------------
-- CUBE
SELECT 
    DEPTNO,
    SUM(SAL)
FROM EMP
GROUP BY CUBE(DEPTNO); -- ���� �ϳ��� ���� ��쿡�� �Ұ踸 ���´�.

SELECT 
    DEPTNO,
    COALESCE(JOB, '�� �հ�'), -- DEPTNO.LEN = 3, JOB.LEN = 5
    SUM(SAL)
FROM EMP
GROUP BY CUBE(DEPTNO, JOB) -- ���� ���ϴ� ����� ���� �� ���Ѵ�.
ORDER BY DEPTNO;

-------------------------------------------------------
--GROUPING SETS
SELECT  
    DEPTNO,
    JOB, -- DEPTNO.LEN = 3, JOB.LEN = 5
    SUM(SAL)
FROM EMP
GROUP BY GROUPING SETS(DEPTNO, JOB) -- GROUP BY A // B�� ���� ���ؼ� UNION �Ѵ�.
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

|   ROLLUP(A,B)   |      CUBE(A,B)       |  GROUPING SETS(A,B)   
---------------------------------------------------------------
| GROUP BY A, B   |     GROUP BY A,B     |      
| GROUP BY A      |     GROUP BY A       |    GROUP BY A
|                 |     GROUP BY B       |    GROUP BY B
| GROUP BY NULL   |     GROUP BY NULL    |       
---------------------------------------------------------------

