--ORDER BY
SELECT * FROM EMP;

SELECT * FROM EMP ORDER BY ENAME DESC;
SELECT * FROM EMP ORDER BY DEPTNO;
SELECT * FROM EMP ORDER BY DEPTNO, SAL;
SELECT * FROM EMP ORDER BY DEPTNO, SAL, EMPNO;
SELECT * FROM EMP ORDER BY DEPTNO, SAL DESC, EMPNO;

--WHERE  ----------------------
SELECT * FROM EMP WHERE SAL > 2000;
SELECT ENAME, JOB FROM EMP WHERE SAL > 2000;

--�μ���ȣ�� 20���� �ƴ� �ุ ���� �ʹ�
SELECT * FROM EMP WHERE DEPTNO != 20;
SELECT * FROM EMP WHERE DEPTNO ^= 20;
SELECT * FROM EMP WHERE NOT DEPTNO = 20; 

SELECT ENAME, JOB, DEPTNO FROM EMP WHERE DEPTNO !=20;

--1982�� ���� �Ի��� �˻�
SELECT * FROM EMP WHERE HIREDATE >= '1982-01-01';
SELECT * FROM EMP WHERE HIREDATE >= '1982/01/01';
SELECT ENAME, HIREDATE FROM EMP WHERE HIREDATE >= '1982-01-01';

--�̸��� SCOTT�� ��� ã��
SELECT * FROM EMP WHERE ENAME = 'SCOTT';
SELECT * FROM EMP WHERE ENAME = 'scott'; -- Case sensitive by default

SELECT * FROM EMP WHERE LOWER(ENAME) = 'scott';
SELECT * FROM EMP WHERE UPPER(ENAME) = 'SCOTT';
SELECT * FROM EMP WHERE REGEXP_LIKE (ENAME, 'scott', 'im');
--'i' specifies case-insensitive matching.
--'c' specifies case-sensitive matching.
--'n' allows the period (.), which is the match-any-character wildcard character, to match the newline character. If you omit this parameter, the period does not match the newline character.
--'m' treats the source string as multiple lines. Oracle interprets ^ and $ as the start and end, respectively, of any line anywhere in the source string, rather than only at the start or end of the entire source string. If you omit this parameter, Oracle treats the source string as a single line.

--FETCH INSTANCES JOB ATTR OF WHICH IS NOT MANAGER
SELECT * FROM EMP WHERE NOT JOB = 'MANAGER';

--�Ի�⵵�� 1981���� ���
SELECT * FROM EMP WHERE HIREDATE >= '1981/01/01' AND HIREDATE <= '1981/12/31';
SELECT * FROM EMP WHERE HIREDATE BETWEEN '1981/01/01' AND '1981/12/31';
SELECT * FROM EMP WHERE YEAR(HIREDATE) = 1981; -- MySql style, AN ERROR OCCURS
SELECT * FROM EMP WHERE EXTRACT(YEAR FROM HIREDATE) = 1981;
SELECT * FROM EMP
    WHERE EXTRACT(YEAR FROM HIREDATE) = 1981
    ORDER BY 8 DESC;

SELECT
    SYSTIMESTAMP,
    EXTRACT(TIMEZONE_REGION FROM SYSTIMESTAMP) A,
    EXTRACT(TIMEZONE_ABBR FROM SYSTIMESTAMP) B,
    EXTRACT(TIMEZONE_HOUR FROM SYSTIMESTAMP) C,
    EXTRACT(TIMEZONE_MINUTE FROM SYSTIMESTAMP) D
FROM DUAL;

SELECT * FROM V$TIMEZONE_NAMES;

--�޿��� 3000���� ũ�ų� 1000���� ���� ����� �̸�
SELECT ENAME FROM EMP WHERE SAL > 3000 OR SAL < 1000;
SELECT ENAME FROM EMP WHERE NOT SAL >= 1000 AND SAL <= 3000;
SELECT ENAME FROM EMP WHERE NOT (SAL >= 1000) AND (SAL <= 3000); -- �� ������ ���������ڰ� �տ��� �ɷ��ִ�.
SELECT ENAME FROM EMP WHERE NOT(SAL >= 1000 AND SAL <= 3000); -- �̷��� ������� �Ѵ�.
SELECT ENAME FROM EMP WHERE NOT SAL >= 1000 AND NOT SAL <= 3000; -- �ƹ��͵� �ȳ��� 
SELECT ENAME FROM EMP WHERE NOT SAL >= 1000 OR NOT SAL <= 3000;  --�Ѵ� �ɾ��ٶ��� OR����

/*******************************
    LIKE �� ��� p.134
********************************/
--�̸��� S�� ������ ���
SELECT * FROM EMP WHERE ENAME LIKE '%S';
--�̸��� J�� �����ϴ� ���
SELECT * FROM EMP WHERE ENAME LIKE 'J%';
--�̸��� J�� �����ؼ� S�� ������ ���
SELECT * FROM EMP WHERE ENAME LIKE 'J%S';
--�̸��� O�� ���� ���
SELECT * FROM EMP WHERE ENAME LIKE '%O%';
--�̸��� �ι�° ��¥�� O�� ���
SELECT * FROM EMP WHERE ENAME LIKE '_O%';
--�̸��� 5 ������ ���
SELECT ENAME FROM EMP WHERE ENAME LIKE '_____';

/*******************************
    BETWEEN �� ��� p.136
********************************/
SELECT * FROM EMP WHERE SAL BETWEEN 1000 AND 2000;  -- INCLUSIVE BY DEFAULT (CANNOT CHANGE)
SELECT * FROM EMP WHERE SAL NOT BETWEEN 1000 AND 2000;

/*******************************
    IN �� ��� p.138
********************************/
SELECT * FROM EMP WHERE JOB IN ('CLERK', 'MANAGER');
SELECT * FROM EMP
WHERE (JOB, DEPTNO) -- ���� Į���� ��� ���� ���� ���� �ִ�.
    IN (('CLERK', 20), ('MANAGER', 30));


/*******************************
    NULL �� ��ȸ p.139
********************************/
--NULL�� Ư¡:
--1. NULL �� �𸣴� ���� �ǹ��Ѵ�.
--2. ���� ���縦 �ǹ��Ѵ�.
--3. ����/��¥�� ���ϸ� NULL�� �ȴ�.
--4. NULL�� � ���� ���ϸ� '�� �� ����'�� ��ȯ�ȴ�.

SELECT * FROM EMP WHERE MGR IS NULL;
SELECT * FROM EMP WHERE MGR = NULL; -- RETURNS NOTHING !!!!
SELECT * FROM EMP WHERE COMM IS NOT NULL;

SELECT (NULL * 2) + 3 FROM DUAL; -- NULL ���� ��� ���꿡 ���� IDEMPOTENT�ϴ�.
SELECT NULL - 200000 FROM DUAL;  -- : NULL���� � ��������� �ص� NULL�� �ȴ�.
SELECT NULL || 'WOW' FROM DUAL;  -- RESULT: 'WOW'
SELECT TO_CHAR(NULL) FROM DUAL;
SELECT DECODE(TO_CHAR(NULL), NULL, 'EQUAL', 'NOT EQUAL') DD FROM DUAL;

-- FUNCTION NVL
SELECT MGR, NVL(MGR, 100000) FROM EMP; -- NVL > IFNULL (MySQL)
SELECT COMM, NVL(COMM, 0) FROM EMP;
-- FUNCTION NVL2
SELECT NVL2  (COMM,        1000, 0), COMM FROM EMP; -- NVL2
SELECT DECODE(COMM, NULL, 0, 1000), COMM FROM EMP;  -- DECODE�ʹ� ARG �ݴ����� ����!
-- FUNCTION NULLIF
CREATE TABLE TEST (
    NUM1 NUMBER(10),
    NUM2 NUMBER(10),
    NUM3 NUMBER(10)
);

INSERT INTO TEST VALUES(10,11,12);
INSERT INTO TEST VALUES(20,21,22);
INSERT INTO TEST VALUES(30,30,32);
INSERT INTO TEST VALUES(40,41,42);

SELECT NUM1, NUM2, NULLIF(NUM1, NUM2) FROM TEST;
/* NULLIF(ARG1, ARG2) 
        -> NULL IF ARG2 == ARG2 
           ELSE ARG1           */
           
-- FUNCTION COALESCE
SELECT COMM, MGR, COALESCE(COMM, MGR) FROM EMP;
-- NULL �� �ƴ� ���� ���ڰ� ��ȯ
SELECT COMM, MGR, SAL, COALESCE(COMM, MGR, SAL) FROM EMP;

/*******************************
    GROUP BY / HAVING / AGGREGATE FUNCTIONS   p.141
********************************/
SELECT COUNT(COMM) FROM EMP;
SELECT COUNT(MGR) FROM EMP;
SELECT COUNT(*) FROM EMP;

SELECT SUM(SAL) FROM EMP;
SELECT AVG(SAL) FROM EMP;
SELECT SUM(SAL), AVG(SAL) FROM EMP;
SELECT SUM(SAL) FROM EMP GROUP BY DEPTNO;
SELECT ENAME, SUM(SAL) FROM EMP;
SELECT SUM(COMM) FROM EMP;
SELECT SUM(COMM) / COUNT(COMM) AS AVERAGE FROM EMP;
SELECT AVG(COMM) FROM EMP; -- ���� �İ� ���� ���. COUNT�� NULL�� �����ϰ� ����


-- ��� ��� ���� �����ϱ� ROWNUM
SELECT ENAME, SAL FROM EMP WHERE ROWNUM < 4 ORDER BY SAL DESC;
SELECT ENAME, SAL FROM EMP ORDER BY SAL DESC LIMIT 3;    -- MySQL STYLE

/*******************************
    GROUP BY ��뿹�� p.144
********************************/

SELECT JOB, AVG(SAL) FROM EMP GROUP BY JOB;
SELECT DEPTNO, SUM(SAL) FROM EMP GROUP BY DEPTNO;
SELECT DEPTNO, SUM(SAL) FROM EMP GROUP BY DEPTNO HAVING SUM(SAL) < 10000;

--�μ���, �����ں� �޿���� ��� 
SELECT DEPTNO, MGR, AVG(SAL) FROM EMP GROUP BY DEPTNO, MGR;

--�� �μ����� �׷�ȭ, �μ����� �ִ� �޿��� 3000 ������ �μ��� SAL�� ����
SELECT DEPTNO, SUM(SAL), MAX(SAL) FROM EMP
GROUP BY DEPTNO HAVING MAX(SAL) <= 3000;

--JOB�� CLERK�� �����鿡 ���ؼ� �� �μ����� �׷�ȭ, �μ����� �ּ� �޿��� 1000 ������ �μ����� �������� �޿� ����
-- �μ���ȣ �������� ����
SELECT DEPTNO, SUM(SAL) FROM EMP
WHERE JOB = 'CLERK'
GROUP BY DEPTNO
    HAVING MIN(SAL) < 1000
ORDER BY DEPTNO ASC;
    
--�޿��� 1500 �̻��� �����鿡 ���ؼ� �μ����� �׷�ȭ
--�μ����� �ּ� �޿��� 1000 �̻�, �ִ� �޿��� 5000 ������ �μ����� �������� ��� �޿�
--�μ��� �������� ����

SELECT DEPTNO, AVG(SAL)             -- 5
FROM EMP                            -- 1 ���ڴ� ���� ������ ��Ÿ��
WHERE SAL >= 1500                   -- 2
GROUP BY DEPTNO                     -- 3
    HAVING                          -- 4            
        MIN(SAL) >= 1000 AND -- OR/AND �Ѵ� ����� ����?
        MAX(SAL) <= 5000
ORDER BY DEPTNO DESC;               -- 6

-- ������ȣ���� ���������� ���� �������� ��ȣ�� ����, �������� ��ȣ�� ������ ���

SELECT * FROM EMP ORDER BY MGR;

SELECT * FROM
(SELECT EMPNO, ENAME, JOB FROM EMP) A,
(SELECT MGR, ENAME, JOB FROM EMP) B
WHERE A.EMPNO = B.MGR
ORDER BY A.EMPNO;

SELECT * FROM
(SELECT EMPNO, ENAME, JOB FROM EMP) A
INNER JOIN
(SELECT MGR, ENAME, JOB FROM EMP) B
ON A.EMPNO = B.MGR
ORDER BY A.EMPNO;

-- ������ȣ���� ���������� ���� �������� ��ȣ�� ����, 
-- CONNECT BY ������ ���� ������ QUERY - p.184

SELECT * FROM EMP;

SELECT MAX(LEVEL) FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

SELECT LEVEL, EMPNO, MGR, ENAME FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

SELECT LEVEL, LPAD(' ', 4 * (LEVEL - 1)) || EMPNO AS HRCH, MGR, CONNECT_BY_ISLEAF FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;