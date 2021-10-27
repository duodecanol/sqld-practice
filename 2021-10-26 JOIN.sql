/**************************************************************
    JOIN
    EQUI JOIN    p.171
***************************************************************/
SELECT * FROM DEPT;

SELECT *
FROM EMP A, DEPT B
WHERE A.DEPTNO = B.DEPTNO
    AND A.ENAME LIKE 'S%'
ORDER BY A.ENAME;

/*******************************
    INNER JOIN
********************************/
SELECT *
FROM EMP A INNER JOIN DEPT B ON A.DEPTNO = B.DEPTNO
WHERE A.ENAME LIKE 'S%'
ORDER BY A.ENAME;

/*******************************
    INTERSECT
********************************/
SELECT DEPTNO FROM EMP
    INTERSECT
SELECT DEPTNO FROM DEPT;

/*******************************
    EQUI JOIN, INNER JOIN ���� �� ��������
********************************/

-- JOIN ������ ���
SELECT * FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO; -- EQUI-JOIN
SELECT * FROM EMP JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO; -- INNER JOIN������ INNER �Ƚᵵ �ȴ�. ����� ����.
SELECT * FROM EMP INNER JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO;
SELECT * FROM EMP JOIN DEPT USING(DEPTNO); --  �÷����� ���� ���� ���

--����� �����ȣ, �̸�, �ٹ��μ��� �����´�.
SELECT A.EMPNO, A.ENAME, B.DNAME
FROM EMP A LEFT OUTER JOIN DEPT B USING(DEPTNO); -- ���� ���� LEFT OUTER JOIN���� �޴�. �ֳ��ϸ� �μ��� �������� �����ϱ�.

SELECT A.EMPNO, A.ENAME, B.DNAME
FROM EMP A, DEPT B 
WHERE A.DEPTNO = B.DEPTNO;

SELECT A.EMPNO, A.ENAME, B.DNAME
FROM EMP A JOIN DEPT B ON A.DEPTNO = B.DEPTNO; -- JOIN / INNER JOIN  ����.

SELECT A.EMPNO, A.ENAME, B.DNAME
FROM EMP A JOIN DEPT B USING(DEPTNO);

--��ī�� �ٹ��ϴ� ������� �����ȣ,�̸�, ������ FETCH
SELECT A.EMPNO, A.ENAME, A.JOB, B.DNAME, B.LOC
FROM EMP A INNER JOIN DEPT B USING(DEPTNO)
WHERE B.LOC LIKE 'CHICAGO';

/*******************************
    NON-EQUI JOIN
********************************/
SELECT * FROM EMP;
SELECT * FROM SALGRADE;

-- SALGRADE ���̺��� ���� ������ ����� ����鿡�� ������Ѷ�.
SELECT A.EMPNO, A.ENAME, A.HIREDATE, B.GRADE, A.SAL, B.LOSAL, B.HISAL
FROM EMP A, SALGRADE B
WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL;

-- �޿������ 4����� ������� �����ȣ, �̸�, �޿�, �μ��̸�, �ٹ����� FETCH
SELECT A.EMPNO, A.ENAME, A.SAL, C.DNAME, C.LOC, B.GRADE AS "���Ȯ��"
FROM EMP A, SALGRADE B, DEPT C
WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL
    AND A.DEPTNO = C.DEPTNO
    AND B.GRADE = 4;

-- �� �޿� ��޺�  // �޿� ���հ� ���, ��� ��, �ִ� �޿�, �ּ� �޿� FETCH
SELECT B.GRADE, SUM(A.SAL), ROUND(AVG(SAL), 4), COUNT(EMPNO), MAX(A.SAL), MIN(A.SAL)
FROM EMP A, SALGRADE B
WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL
GROUP BY B.GRADE
ORDER BY B.GRADE;

/*******************************
    OUTER JOIN
********************************/
SELECT EMP.ENAME, EMP.DEPTNO, DEPT.DEPTNO, DEPT.DNAME
FROM DEPT, EMP
WHERE EMP.DEPTNO = DEPT.DEPTNO;

SELECT EMP.ENAME, EMP.DEPTNO, DEPT.DEPTNO, DEPT.DNAME
FROM EMP, DEPT
WHERE EMP.DEPTNO (+)= DEPT.DEPTNO; -- OUTER JOIN OPERATOR

SELECT EMP.ENAME, EMP.DEPTNO, DEPT.DEPTNO, DEPT.DNAME
FROM DEPT LEFT OUTER JOIN EMP
    ON EMP.DEPTNO = DEPT.DEPTNO;
    
SELECT EMP.ENAME, EMP.DEPTNO, DEPT.DEPTNO, DEPT.DNAME
FROM DEPT RIGHT OUTER JOIN EMP
    ON EMP.DEPTNO = DEPT.DEPTNO;    

/*******************************
    CROSS JOIN - CARTESIAN PRODUCT
********************************/

SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT * FROM EMP CROSS JOIN DEPT;

/*******************************
    UNION
********************************/
SELECT DEPTNO FROM EMP
UNION
SELECT DEPTNO FROM EMP; -- ����/�ߺ�����

SELECT DEPTNO FROM EMP
UNION ALL
SELECT DEPTNO FROM EMP; -- ����/�ߺ����� ���� 

/*******************************
    MINUS ������
********************************/
SELECT DEPTNO FROM DEPT
MINUS -- MS SQL�� EXCEPT
SELECT DEPTNO FROM EMP; 

