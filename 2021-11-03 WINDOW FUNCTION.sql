/**************************************************************
    WINDOW FUNCTIONS        p.196
           
------------------------------------------------------------------
SELECT [ WINDOW_FUNCTION ] ( [ args ] ) 
        OVER (
              [ PARTITION BY [ column ] ]
                ORDER BY     [ column ]
              [ WINDOWING_CLAUSE ]
              )

***************************************************************/

SELECT ENAME, JOB, 
    RANK() OVER(ORDER BY SAL DESC) SAL_RANK-- �޿� ������ ������������ 
FROM EMP;

SELECT
    ENAME, JOB,
    RANK() OVER (PARTITION BY JOB ORDER BY SAL DESC) SAL_RANK_BY_JOB,
    DEPTNO        -- �޿� ������ ��������
FROM EMP C;

/*******************************
    WINDOW_FUNCTION.RANK()
    WINDOW_FUNCTION.DENSE_RANK()
    WINDOW_FUNCTION.ROW_NUMBER()
********************************/
SELECT ENAME, JOB, 
    RANK() OVER(ORDER BY SAL DESC) SAL_RANK-- ���ϰ��� ������ ó���ϰ� ���������� �и���.
FROM EMP;
-------------------------------------------------------
SELECT ENAME, JOB, 
    DENSE_RANK() OVER(ORDER BY SAL DESC) SAL_RANK-- ���ϰ��� ������ó���ϰ� ���ӹ�ȣ �ο��Ѵ�.
FROM EMP;
-------------------------------------------------------
SELECT ENAME, JOB, 
    ROW_NUMBER() OVER(ORDER BY SAL DESC) SAL_RANK-- ������� ���ȣ�� �ο��Ѵ�.
FROM EMP;
-------------------------------------------------------

SELECT * FROM EMP;
-- ���, �̸�, �޿�, �޿� ��
SELECT ENAME, SAL, (SELECT SUM(SAL) FROM EMP) SAL_SUM
FROM EMP;
-- �� ������ ������ ������ ���.   // USING SUBQUERY
SELECT ENAME, SAL, SUM(SAL) OVER ()
FROM EMP;
-------------------------------------------------------
-- ���, �̸�, �޿�, �޿� �� BY DEPT
SELECT ENAME, SAL, SUM(SAL) OVER (PARTITION BY DEPTNO) SUM_SAL_BY_DEPT
FROM EMP;
-- �� ������ ������ ������ ���.   // USING SUBQUERY
SELECT A.ENAME, A.SAL, 
    (SELECT SUM(B.SAL) FROM EMP B 
        GROUP BY B.DEPTNO HAVING B.DEPTNO=A.DEPTNO) SUM_SAL_BY_DEPT
FROM EMP A
ORDER BY A.DEPTNO;
-------------------------------------------------------
-- �̻��� ���????
SELECT ENAME, SAL, SUM(SAL) OVER (PARTITION BY JOB) SUM_SAL_BY_JOB  -- PARTITION�ϸ� ���ĵ� �ʳ�?
FROM EMP  -- ORDER BY ���� ���� �������� ����Ǳ� ������
ORDER BY SAL;  --�ⲯ �س��� PARTITION���� �׷캰 �����س������� �ٽ� ��ü�����Ѵ�.
-- ���, �̸�, �޿�, �޿� �� BY JOB
SELECT ENAME, SAL, SUM(SAL) OVER (PARTITION BY JOB) SUM_SAL_BY_JOB  -- PARTITION�ϸ� ���ĵ� �ʳ�?
FROM EMP;
-- �� ������ ������ ������ ���.  // USING SUBQUERY
SELECT A.ENAME, A.SAL, 
    (SELECT SUM(B.SAL) FROM EMP B 
        GROUP BY B.JOB HAVING B.JOB=A.JOB) SUM_SAL_BY_JOB
FROM EMP A
ORDER BY A.JOB;