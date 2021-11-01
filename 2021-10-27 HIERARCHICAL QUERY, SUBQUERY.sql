/*******************************
    HIERARCHCIAL QUERY - CONNECT BY p.182
********************************/
SELECT * FROM EMP; -- �� EMP�� MGR �Ŵ����� �ϳ� ���ų� ���� �ʴ´�.

SELECT MAX(LEVEL) FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR; --MGR�� ���� �����Ǵ� Ʈ���� �ִ� ����

SELECT LEVEL, EMPNO, MGR, ENAME
FROM EMP
START WITH MGR IS NULL -- MGR�� NULL�� �ڴ� �ڽ��� �����ڰ� �����Ƿ� Ʈ���� �ֻ��� (��Ʈ���)�� ����.
CONNECT BY PRIOR EMPNO = MGR; --������

SELECT LEVEL, EMPNO, MGR, ENAME
FROM EMP
START WITH MGR IS NULL -- MGR�� NULL�� �ڴ� �ڽ��� �����ڰ� �����Ƿ� Ʈ���� �ֻ��� (��Ʈ���)�� ����.
CONNECT BY EMPNO = PRIOR MGR; --������ // ���������� �ϸ� �θ��� �θ� �ڽ����� �����ϴ� ���̶� ������� ����.
     -- PRIOR Ű������ ��/�� ��ġ�� �߿��� ���� �ƴ϶� �Ӽ��� ���ϰ��踦 ������ �Ѵ�.
     -- ������ PRIOR EMPNO = MGR
     -- ������ EMPNO�� ���� MGR �̴�.

SELECT
    LEVEL,
    LPAD(' ', 4 * (LEVEL - 1)) || EMPNO AS VISUALIZED_LEVEL,
    ENAME,
    (SELECT ENAME FROM EMP WHERE EMPNO = A.MGR) AS SUPERVISOR_NAME,
    CONNECT_BY_ISLEAF    
FROM EMP A
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

SELECT
    LEVEL,
    SYS_CONNECT_BY_PATH(EMPNO, ' -> ') AS CONNECT_PATH, 
    EMPNO, ENAME
FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

LEVEL                   �˻� �׸��� ����. �ֻ��� 1
CONNECT_BY_ROOT         ���� �ֻ��� ��
CONNECT_BY_ISLEAF       ���� ����ΰ� �ƴѰ�
SYS_CONNECT_BY_PATH     �ش� �ο��� ���� ��� ǥ��
NOCYCLE                 ��ȯ���� �߻����������� ǥ��
CONNECT_BY_ISCYCLE      ��ȯ���� �߻����� ǥ��

SELECT
    EMPNO,    ENAME,    LEVEL,
    CONNECT_BY_ROOT(EMPNO),
    CONNECT_BY_ISLEAF,
    SYS_CONNECT_BY_PATH(EMPNO, ' -> ') AS CONNECT_PATH    
FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

-- EMP ���̺��� �ֻ��� �����ں��� ���� ������ ������ ������ȣ, �����̸�, ���ӻ����ȣ, ���� ���, �� �޿��� 2000 ������ ����鸸.
SELECT EMPNO, ENAME, MGR, LEVEL
FROM EMP
WHERE SAL <= 2000
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;


/*******************************
    SUBQUERY      p.186
---------------------------------    
        - Inline view    - FROM
        - Scala Subquery - SELECT
        - Subquery       - WHERE
********************************/
SELECT * FROM EMP
    WHERE DEPTNO = (
        SELECT DEPTNO FROM DEPT
            WHERE DEPTNO = 10
    );

SELECT * FROM EMP
    WHERE DEPTNO IN (
        SELECT DEPTNO FROM DEPT         -- SUBQUERY IN WHERE CLAUSE
            WHERE JOB = 'CLERK'
    );

SELECT *
    FROM (SELECT ROWNUM NUM, ENAME FROM EMP) A   -- ILINE VIEW IN FROM CLAUSE
    WHERE NUM < 5;
    
    
--////////////////////// ��ı�� �ٹ��ϴ� �μ����� ������. //////////////////////////////
SELECT DEPTNO FROM EMP WHERE ENAME = 'SCOTT'; -- FETCH SCOTT'S INFO
SELECT DNAME FROM DEPT 
    WHERE DEPTNO = (
        SELECT DEPTNO FROM EMP WHERE ENAME = 'SCOTT'  -- WHERE CLAUSE �� SUBQUERY�� ������.
    );
    
SELECT DNAME, ENAME FROM EMP NATURAL JOIN DEPT WHERE ENAME = 'SCOTT'; -- APPROACH USING JOIN



/*******************************
    Scala Subquery      p.134
        - The query must return one row and one col.
        - Use in project operation
********************************/

SELECT DEPTNO, (SELECT SUM(SAL) FROM EMP) -- SCALAR SUBQUERY <-- [ SELECT ]
FROM EMP;

SELECT DEPTNO, SUM(SAL)
FROM EMP
GROUP BY DEPTNO;

SELECT DEPTNO, SUM(SAL)
FROM EMP
GROUP BY (SELECT DEPTNO FROM EMP); ---!!!!!! GROUP BY ���� SUBQUERY ��� �Ұ� !!!!!!!!!!!!


SELECT *
FROM (SELECT ROWNUM, EMPNO, ENAME, DEPTNO FROM EMP ORDER BY DEPTNO); -- INLINE VIEW <--- [ FROM ] 
-- �ФФ� ORDER BY�� ROWNUM�� ���� �ϰ� �ʹ�!

-- ////////////  ��� 1.
SELECT ROWNUM, A.*
FROM (SELECT EMPNO, ENAME, DEPTNO FROM EMP ORDER BY DEPTNO) A;

-- ////////////  ��� 2.
SELECT ROW_NUMBER() OVER (ORDER BY DEPTNO) RNUM, EMPNO, ENAME, DEPTNO
FROM EMP
ORDER BY DEPTNO;

SELECT ROW_NUMBER() OVER (ORDER BY EMPNO) RNUM, 
    EMPNO, ENAME, DEPTNO -- ROW_NUMBER �Լ��� ROW ���İ� ������������ �޸� �� �� �ִ�.
FROM EMP
ORDER BY DEPTNO;  -- https://gent.tistory.com/170

SELECT ROW_NUMBER() OVER (PARTITION BY JOB ORDER BY JOB, DEPTNO) RNUM, 
    JOB, EMPNO, ENAME, DEPTNO
FROM EMP NATURAL JOIN DEPT
ORDER BY JOB, DEPTNO;

SELECT ROW_NUMBER() OVER (PARTITION BY MGR ORDER BY MGR) RNUM, 
    JOB, EMPNO, ENAME, DEPTNO, MGR
FROM EMP NATURAL JOIN DEPT
ORDER BY MGR, EMPNO;

-- ////////////////  ����. ORDER BY ������ SUBQUERY�� �����Ѱ�?
-- ////////////////  �����ϴ�. �ٸ� ������ �̻�������? ����?

SELECT * FROM EMP;

SELECT * FROM EMP
ORDER BY (SELECT EMPNO FROM EMP WHERE ENAME='SCOTT'); -- ��Į�� ��  77881

-- ////////////////  -- ////////////////  -- ////////////////  -- ////////////////  
-- FORD�� ���� �μ��� �ٹ��ϴ� ������� ���, �̸�, �޿� , �μ���ȣ�� FETCH.
-- SUBQUERY MUST BE USED.
SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE DEPTNO = (SELECT DEPTNO FROM EMP WHERE ENAME = 'FORD');

-- ALLEN�� ���� ���ӻ���� ���� ������� ���, �̸�, ���ӻ����ȣ 
SELECT EMPNO, ENAME, MGR
FROM EMP
WHERE MGR = (SELECT MGR FROM EMP WHERE ENAME = 'ALLEN');

-- ��ī�� �������� �ٹ��ϴ� ������� ����ũ�� ���ӻ���� ����� -=> ���, �̸�, ����
SELECT EMPNO, ENAME, JOB, 
    (SELECT ENAME FROM EMP WHERE EMPNO = A.MGR) AS SUPERVISOR, 
    B.LOC
FROM EMP A JOIN DEPT B ON (A.DEPTNO = B.DEPTNO)
WHERE 
    LOC = 'CHICAGO'
    AND MGR = (SELECT EMPNO FROM EMP WHERE ENAME = 'BLAKE')
ORDER BY EMPNO    ;

-- �� ������ ���̴� �����ΰ�?
select sal, (select avg(sal) from emp) from emp;

select sal, avg(sal) from emp;

select sal, (select avg(sal) from emp where 1=0) from emp;
select sal, (select avg(sal) from emp where 1=1) from emp;

-- �޿��� �� ���� ��ձ޿����� ���� ��� <- ���, �̸�, �޿�
SELECT EMPNO, ENAME, SAL FROM EMP WHERE SAL > (SELECT AVG(SAL) FROM EMP);

-- ������ ���̺��� �����Ͽ� ������� ���̺��� 4��° ����̸� ��ȸ
SELECT
    * 
FROM (
    SELECT ROW_NUMBER() OVER(ORDER BY ENAME) R, ENAME FROM EMP ORDER BY ENAME
    )
WHERE R = 4;

--https://docs.oracle.com/database/121/DWHSG/analysis.htm#DWHSG9191
SELECT ROW_NUMBER() OVER(ORDER BY ENAME) R, ENAME FROM EMP 
ORDER BY ENAME
FETCH FIRST 5 ROWS ONLY;
OFFSET 2 ROWS FETCH FIRST 5 ROWS ONLY;

-- ����� ��� �޿����� �޿��� ����� ������� ������������ �����Ͽ� ����� �̸� �޿� �������ձ޿�, �޿����̰�
SELECT 
    ABS((SELECT ROUND(AVG(SAL), 3) FROM EMP) - E.SAL) DIST_FROM_AVG_SAL, 
    (SELECT ROUND(AVG(SAL), 3) FROM EMP) AVG_SAL, 
    E.SAL, E.ENAME    
FROM EMP E
ORDER BY DIST_FROM_AVG_SAL;
