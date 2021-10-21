/*******************************
    BUILT IN FUNCTIONS p.148
    ���ڿ� �Լ�
********************************/

SELECT 
    ENAME, 
    UPPER(ENAME),
    LOWER(ENAME),
    INITCAP(ENAME) -- CAPITALIZE WORDS
FROM EMP;

SELECT ENAME, JOB, CONCAT(ENAME, JOB) FROM EMP;
SELECT ENAME, JOB, CONCAT(ENAME, JOB, EMPNO) FROM EMP; -- ERROR
SELECT ENAME, JOB, ENAME || JOB || EMPNO AS CONCAT FROM EMP;

SELECT ENAME, LENGTH(ENAME) FROM EMP;
SELECT LENGTH('AAAAAAAAAAA AAAAAAAAAAAA ') FROM DUAL;
SELECT SUBSTR('ABCDEFG', 3, 2) FROM DUAL;
SELECT SUBSTR('123456', 3, 2) FROM DUAL; -- 1-based index!!  NOT zero-based

-- ����̸����� �ι�°�� ����° ���ڸ� �����ض�.
SELECT ENAME, SUBSTR(ENAME, 2, 2) FROM EMP;

--DECLARE ??? HOW??
DEFINE    DUMMY = "'      aaaaaaaa          '";
SELECT 
    LTRIM(&DUMMY),
    RTRIM(&DUMMY),
    TRIM(&DUMMY)
FROM DUAL;

DEFINE UNDERBAR = "'=====ASDFSADFSAFD======'"   ;
SELECT
    LTRIM( &UNDERBAR, '=' ),
    RTRIM( &UNDERBAR, '=' ),
    TRIM( &UNDERBAR, '=' )   FROM DUAL;

SELECT TRIM('&DUMMY') FROM DUAL;   -- PROMPT

/*******************************
    ��¥�� �Լ� 
********************************/

SELECT SYSDATE, SYSDATE + 31 FROM DUAL;


/*******************************
    ������ �Լ� p.151
********************************/

SELECT
    ABS(-1214313),
    SIGN(0.232321),    SIGN(-0.00003),    SIGN(0),      -- ��ȣ ���� -1, 0, 1
    MOD(10, 2),    MOD(10, 3),    MOD(10, 4)            -- % ������ �ȵ�
FROM DUAL;

SELECT
    CEIL(4.0), CEIL(4.1), CEIL(4.5), CEIL(4.6), CEIL(4.99)
FROM DUAL;

SELECT
    FLOOR(4.0), FLOOR(4.1), FLOOR(4.5), FLOOR(4.6), FLOOR(4.99)
FROM DUAL;

SELECT
    ROUND(4.0), ROUND(4.1), ROUND(4.5), ROUND(4.6), ROUND(4.99)
FROM DUAL;

SELECT TRUNC(16375.375034), TRUNC(16375.375034, 0) FROM DUAL;
SELECT TRUNC(16375.375034, -1) FROM DUAL;

--�޿� 1500 �̻��� ����� �޿��� 15% �λ��� �ݾ�, �� �Ҽ��� ���ϴ� ������.
SELECT ENAME, SAL, SAL * 1.15, FLOOR(SAL * 1.15) AS ANS
FROM EMP 
WHERE SAL >= 1500;

SELECT ENAME, SAL, SAL * 1.15, TRUNC(SAL * 1.15) AS ANS 
FROM EMP 
WHERE SAL >= 1500;

--�޿� 2000 ������ ����� �޿��� 20% �λ��� �ݾ�, 10�� �ڸ��� �������� �ݿø�.
SELECT ENAME, SAL, SAL*1.2, ROUND(SAL*1.2, -2)
FROM EMP 
WHERE SAL <= 2000
ORDER BY SAL;

/*******************************
    DECODE �� ��� p.152
********************************/
--�μ���ȣ�� 10�̸� TRUE, ELSE FALSE
SELECT DECODE(DEPTNO, 10, 'TRUE', 'FALSE') AA FROM EMP ORDER BY AA;

/* ���޿� ���� �޿� �λ�
CLERK       10
SALESMAN    20
MANAGER     30 
ANALYST     10
PRESIDENT   30                */

SELECT 
    ENAME, JOB, SAL,
    DECODE(JOB,
        'CLERK', SAL * 1.1,
        'SALESMAN', SAL * 1.2,
        'MANAGER', SAL * 1.3,
        'ANALYST', SAL * 1.1,
        'PRESIDENT', SAL * 1.3,
        SAL * 1.1154
    ) RAISED_SAL    
FROM EMP
ORDER BY RAISED_SAL;

/*******************************
    CASE �� ��� p.153
********************************/

������� �޿��� ��� �з�
1000 �̸� : C
1000 �̻� 2000 �̸� B
2000 �̻� A

SELECT
    ENAME, JOB, HIREDATE,
    CASE 
        WHEN SAL < 1000 THEN 'C'
        WHEN SAL >= 1000 AND SAL < 2000 THEN 'B'
        WHEN SAL >= 2000 THEN 'A'
        ELSE 'X'
    END AS CLAS
FROM EMP
ORDER BY CLAS;

����� �޿� �λ�
1000 �̸� : 200%
1000 �̻� 2000 �̸�  150%
2000 �̻� 100%

SELECT
    ENAME, JOB, HIREDATE, SAL,
    CASE
        WHEN SAL < 1000 THEN SAL * 3
        WHEN SAL >= 1000 AND SAL < 2000 THEN SAL * 2.5
        WHEN SAL >= 2000 THEN SAL * 2
        ELSE SAL
    END AS A
FROM EMP
ORDER BY A;

/*******************************
    ROWNUM, ROWID p.154
********************************/

SELECT ROWNUM, ROWID, ENAME, JOB, SAL FROM EMP;

SELECT * FROM EMP WHERE ROWNUM <=4;
SELECT * FROM EMP WHERE ROWNUM >4;  -- RETURNS NONE
SELECT * FROM EMP WHERE ROWNUM = 1;
SELECT * FROM EMP WHERE ROWNUM = 2;  -- RETURNS NONE
SELECT * FROM EMP WHERE ROWNUM BETWEEN 2 AND 6;  -- RETURNS NONE XXXXXXXX

SELECT TOP(4) FROM EMP;         -- SQL SERVER
SELECT TOP 4 * FROM EMP;        -- MS SQL
SELECT * FROM EMP LIMIT 4;      -- MySQL

----XXXXXXXXXX�� ��ȸ ����
SELECT *
FROM
    (SELECT ROWNUM AS LIST, EMPNO, ENAME, JOB, SAL FROM EMP)
WHERE LIST BETWEEN 2 AND 6;

/*******************************
    WITH ���� ��� p.159
********************************/




























































