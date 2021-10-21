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
