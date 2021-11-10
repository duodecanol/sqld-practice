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
    INTERSECT  ������
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
FROM EMP A JOIN DEPT B USING(DEPTNO); -- ON, WHERE ����ϸ� DEPTNO �÷��� 2���� ������ USING�� ����ϸ� �ϳ��� �����Ǹ� �� ������ �´�.


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
    NAURAL JOIN  -- ���翡 ����
********************************/
SELECT *
FROM EMP A, DEPT B 
WHERE A.DEPTNO = B.DEPTNO;

SELECT *
FROM EMP A INNER JOIN DEPT B 
ON A.DEPTNO = B.DEPTNO;
--- �� ���̺��� DEPTNO, DEPTNO_1 Į���� �ߺ��Ǿ� ��Ÿ���� �߾ӿ��� ������.

SELECT *
FROM EMP A INNER JOIN DEPT B USING (DEPTNO);
--- �̸��� ���� �Ӽ��� DEPTNO�� Query Result�� 1�� Į���� �ȴ�.

SELECT *
FROM EMP A NATURAL JOIN DEPT B; -- NAT JOIN
-- NAT JOIN �� �÷� ���� ��ð� ������Ѵ�. �̸��� ���� �÷��� �ڵ����� ã�´�.
--- ???? �� ���̺� �̸��� ���� �Ӽ��� ������ ��� �ǳ�?
--- ???? �� ���̺� �̸��� ���� �Ӽ��� ���� ���� ��� �ǳ�?


/*******************************
    OUTER JOIN
        LEFT, RIGHT, FULL �� �ϳ��� �����ؾ��Ѵ�.
********************************/

-- OUTER_TEST_A, OUTER_TEST_B �� �̿��� ������ �׽�Ʈ
SELECT * FROM OUTER_TEST_A;
SELECT * FROM OUTER_TEST_B;

-- �� ������ ������
SELECT * FROM OUTER_TEST_A  INTERSECT  SELECT * FROM OUTER_TEST_B;
------------------------------------------------------------------
SELECT *
FROM OUTER_TEST_A A OUTER JOIN OUTER_TEST_B B
    ON A.X = B.X;  -- ������ ����. INVALID IDENTIFIER
------------------------------------------------------------------
SELECT *
FROM OUTER_TEST_A A LEFT OUTER JOIN OUTER_TEST_B B -- LEFT OUTER
    ON A.X = B.X;
SELECT *
FROM OUTER_TEST_A A, OUTER_TEST_B B -- LEFT OUTER OPERATOR (+) 
    WHERE A.X = B.X(+);
------------------------------------------------------------------
SELECT *
FROM OUTER_TEST_A A RIGHT OUTER JOIN OUTER_TEST_B B -- RIGHT OUTER
    ON A.X = B.X;
SELECT *
FROM OUTER_TEST_A A, OUTER_TEST_B B -- RIGHT OUTER OPERATOR (+)
    WHERE A.X (+)= B.X;    
------------------------------------------------------------------
SELECT *
FROM OUTER_TEST_A A FULL OUTER JOIN OUTER_TEST_B B -- FULL OUTER
    ON A.X = B.X;
SELECT *
FROM OUTER_TEST_A A, OUTER_TEST_B B -- FULL OUTER ��ȣ�� �Ұ���. ���ʿ� ���� ����.
    WHERE A.X(+) = B.X(+);
------------------------------------------------------------------
-- CARTESIAN PRODUCT���� ��������?  ���ڵ� 4 * 5 = 20
SELECT * FROM OUTER_TEST_A  CROSS JOIN  OUTER_TEST_B;

------------------------------------------------------------------
-- ���ظ� �������� ���� ����
------------------------------------------------------------------

-- �μ��� ���� ������� ��� �̸�, �����ȣ, �μ���ȣ, �μ����� ���

-- �μ��� ���� ����� ����.  ����� ���� �μ��� �ִ�.

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


-- �� ����� �̸�, �����ȣ, �������� �̸��� �������� ���ӻ���� ���� ����� �����´�.
SELECT * 
FROM EMP A ;

/*******************************
    CROSS JOIN - CARTESIAN PRODUCT
********************************/

SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT * FROM EMP CROSS JOIN DEPT;

/*******************************
    UNION
********************************/
SELECT * FROM OUTER_TEST_A
    UNION 
SELECT * FROM OUTER_TEST_B; -- UNION ����/�ߺ�����

SELECT DEPTNO FROM EMP
    UNION
SELECT DEPTNO FROM EMP; -- UNION ����/�ߺ�����

SELECT * FROM OUTER_TEST_A
    UNION ALL
SELECT * FROM OUTER_TEST_B; -- UNION ALL ����/�ߺ����� ���� 

SELECT DEPTNO FROM EMP
    UNION ALL
SELECT DEPTNO FROM EMP; -- UNION ALL ����/�ߺ����� ���� 

/*******************************
    MINUS ������
********************************/
SELECT DEPTNO FROM DEPT
MINUS -- [[[[[[[[[[[[ MS SQL�� EXCEPT ]]]]]]]]]]]]]]
SELECT DEPTNO FROM EMP; 

SELECT * FROM OUTER_TEST_A
    MINUS
SELECT * FROM OUTER_TEST_B;