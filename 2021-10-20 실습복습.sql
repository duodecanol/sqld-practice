SELECT * FROM EMP ORDER BY DEPTNO, SAL;

SELECT * FROM EMP WHERE ENAME = 'MILLER';
SELECT * FROM EMP WHERE ENAME LIKE '_I%';
SELECT * FROM EMP WHERE UPPER(ENAME) LIKE2 '%R';

-- 1981�� ���� �Ի��� �˻�
SELECT * FROM EMP WHERE EXTRACT(YEAR FROM HIREDATE) >= 1981;

SELECT * FROM EMP WHERE DEPTNO != 20;

SELECT * FROM EMP WHERE REGEXP_LIKE(ENAME, '^.+?TT$', 'i');

SELECT COMM, NVL2(COMM, COMM, -9999) FROM EMP;

--�� �μ����� �׷�ȭ, �μ����� �ִ� �޿��� 3000 ������ �μ��� SAL�� ����
--JOB�� CLERK�� �����鿡 ���ؼ� �� �μ����� �׷�ȭ, �μ����� �ּ� �޿��� 1000 ������ �μ����� �������� �޿� ����
-- �μ���ȣ �������� ����
SELECT DEPTNO, SUM(SAL) FROM EMP GROUP BY DEPTNO HAVING MAX(SAL) <= 3000
ORDER BY DEPTNO ASC;

SELECT
    UPPER('Apple KOREA'),
    LOWER('Apple KOREA'),
    INITCAP('Apple KOREA')
FROM DUAL;

  -- ����̸����� �ι�°�� ����° ���ڸ� �����ض�.
SELECT SUBSTR(ENAME, 2, 2), ENAME FROM EMP;

--�޿� 1500 �̻��� ����� �޿��� 15% �λ��� �ݾ�, �� �Ҽ��� ���ϴ� ������.

SELECT ENAME, JOB, SAL, FLOOR(SAL * 1.15) FROM EMP WHERE SAL >= 1500;
SELECT ENAME, JOB, SAL, TRUNC(SAL * 1.15, -1) FROM EMP WHERE SAL >= 1500;


--�޿��� 1500 �̻��� �����鿡 ���ؼ� �μ����� �׷�ȭ

--�μ����� �ּ� �޿��� 1000 �̻�, �ִ� �޿��� 5000 ������ �μ����� �������� ��� �޿�
--�μ��� �������� ����
SELECT DEPTNO, ROUND(AVG(SAL), 2) FROM EMP WHERE SAL >= 1500
GROUP BY DEPTNO
    HAVING MIN(SAL) >= 1000 AND MAX(SAL) <= 5000
ORDER BY DEPTNO DESC;

-- JOIN ������ ���
SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT * FROM EMP A, DEPT B
WHERE A.DEPTNO = B.DEPTNO; -- EQUI-JOIN

SELECT * FROM EMP A JOIN DEPT B
ON A.DEPTNO = B.DEPTNO;

SELECT * FROM EMP A INNER JOIN DEPT B
ON A.DEPTNO = B.DEPTNO;

SELECT * FROM EMP A JOIN DEPT B
USING (DEPTNO); 


--����� �����ȣ, �̸�, �ٹ��μ��� �����´�.

SELECT A.EMPNO �����ȣ, A.ENAME ����̸�, B.DNAME �ٹ��μ�
FROM EMP A JOIN DEPT B
ON A.DEPTNO = B.DEPTNO;

--��ī�� �ٹ��ϴ� ������� �����ȣ,�̸�, ������ FETCH
SELECT A.EMPNO �����ȣ, A.ENAME ����̸�, A.JOB ����, B.LOC �ٹ���
FROM EMP A JOIN DEPT B USING (DEPTNO)
WHERE B.LOC = 'CHICAGO';

-- SALGRADE ���̺��� ���� ������ ����� ����鿡�� ������Ѷ�.

SELECT A.EMPNO, A.ENAME, A.JOB, A.SAL, B.GRADE, B.LOSAL, B.HISAL
FROM EMP A JOIN SALGRADE B
ON A.SAL BETWEEN B.LOSAL AND B.HISAL;

-- �޿������ 4����� ������� �����ȣ, �̸�, �޿�, �μ��̸�, �ٹ����� FETCH

SELECT A.EMPNO, A.ENAME, A.SAL, B.GRADE, C.DNAME, C.LOC
FROM EMP A, SALGRADE B, DEPT C
WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL
    AND A.DEPTNO = C.DEPTNO
    AND B.GRADE = 4;

-- �� �޿� ��޺�  // �޿� ���հ� ���, ��� ��, �ִ� �޿�, �ּ� �޿� FETCH

SELECT 
    SUM(A.SAL) AS ��ޱ޿�����,
    ROUND(AVG(A.SAL), 0) AS ��ޱ޿����,
    COUNT(*) AS �����,
    MAX(A.SAL) AS ��ޱ��ִ�޿�,
    MIN(A.SAL) AS ��ޱ��ּұ޿�
FROM EMP A JOIN SALGRADE B
ON A.SAL BETWEEN B.LOSAL AND B.HISAL
GROUP BY B.GRADE;

