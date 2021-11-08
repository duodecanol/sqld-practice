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

--�μ��� �������� ������ ���� ������ ���� ��, �μ��� ���ʷ� ������ ����� �̸� ���
SELECT 
	ENAME, SAL, DEPTNO,
	MIN(ENAME) OVER (PARTITION BY DEPTNO ORDER BY SAL DESC
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS FIRST
FROM EMP;

SELECT 
	ENAME, SAL, DEPTNO,
	FIRST_VALUE(ENAME) OVER (PARTITION BY DEPTNO ORDER BY SAL DESC) AS FIRST
	-- PARTITION ������ ���� ���� �������� FIRST_VALUE()
FROM EMP;

SELECT 
	ENAME, SAL, DNAME,
	FIRST_VALUE(ENAME) OVER (PARTITION BY DEPTNO ORDER BY SAL DESC) AS FIRST
FROM EMP NATURAL JOIN DEPT;

--�μ��� �������� ������ ���� ������ ���� ��, �μ��� ���������� ������ ����� �̸� ���
SELECT 
	ENAME, SAL, DEPTNO,
	LAST_VALUE(ENAME) OVER (PARTITION BY DEPTNO ORDER BY SAL DESC
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS LAST
FROM EMP;

-- �������� ��ȣ ����
-- �ش� ������ �޿��� ������ȣ������ �޿�
SELECT
	EMPNO, ENAME, SAL,
	LAG(TO_CHAR(SAL, '0,000') || '  - ' || EMPNO) OVER (ORDER BY EMPNO ASC) AS PRECEEDING_SAL_EMPNO
FROM EMP
ORDER BY EMPNO ASC;

SELECT
	EMPNO, ENAME, SAL,
	LEAD(SAL, 2) OVER (ORDER BY EMPNO)
FROM EMP
ORDER BY EMPNO;


/***************************************************************/
SELECT [ WINDOW_FUNCTION ] ( [ args ] ) 
        OVER (
              [ PARTITION BY [ column ] ]
                ORDER BY     [ column ]
              [ WINDOWING_CLAUSE ]
              )
WINDOWING_CLAUSE
	CURRENT ROW :  ���� ��
	[n] PRECEDING : ������ n ��
	[n] FOLLOWING : ������ n ��
	[UNBOUNDED] PRECEDING : ������ ��Ƽ���� 1�� �� => n = min(n)
	[UNBOUNDED] FOLLOWING : ������ ��Ƽ���� ������ �� => n = max(n)
	
	ROWS BETWEEN  [] AND []
	
-- EMP ���̺��� ����, �̸�, �޿�, �޿����踦 �����´�.
-- ��Ƽ���� ������ ���� ����, �������� ���
SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (PARTITION BY JOB ORDER BY SAL
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SAL_ACCU_BY_JOB
FROM EMP;

-- ����, �̸�, �޿�, �޿�����[��ü�� ���� 1�྿ ����]
SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SAL_ACCU
FROM EMP;
SELECT --���� ���� ���
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		ROWS UNBOUNDED PRECEDING) AS SAL_ACCU
FROM EMP;

-- EMP ���̺��� ����, �̸�, �޿�, �޿����踦 �����´�.
-- ���� 1��� �������� ���� ���
SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		ROWS 1 PRECEDING) AS SAL_CUS -- ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
FROM EMP;
-- ������� ���� 1���� ���� ���
SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS SAL_CUS
FROM EMP;


-----------------------------------------------------------------------
-- RANGE �� ROWS Ű����� ��� �ٸ���?
SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		ROWS 1 PRECEDING) AS SAL_CUS -- ROWS�� �������� ���� ������ ������� �ϴ� �ݸ�
FROM EMP;

SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		RANGE 200 PRECEDING) AS SAL_CUS  -- RANGE�� ���� ������ �����Ѱ��̴�. ���������� ������ �������� �߿�ġ�ʰ�
FROM EMP;                               -- �׷������� CURRENT ROW ���� ��������, ������ X�� ���� ���� �ִ� ���� ����մ� ���� ������� ��.


SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		RANGE BETWEEN 200 PRECEDING AND 200 FOLLOWING) AS SAL_CUS
FROM EMP;
-----------------------------------------------------------------------
-- �����ȣ, �̸�, �޿�, ������޿��� 
--�����������ؼ� ���� 2������ �� 3������ ������ �̵������ ����Ѵ�.
--�����ȣ�� �������� �������� ����
SELECT
	EMPNO, ENAME, SAL,
	ROUND(AVG(SAL) OVER (ORDER BY EMPNO ASC
			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 3) AS MA	
FROM EMP;
-- �������ϰ� ���� 2������ �� 3�� �̵����
SELECT
	EMPNO, ENAME, SAL,
	ROUND(AVG(SAL) OVER (ORDER BY EMPNO ASC
			ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING), 3) AS MA	
FROM EMP;

-----------------------------------------------------------------------
--������� �޿��������� �����ϰ�, ���� �޿����� 50~150��ŭ ���̳��� ��� ���� ���Ѵ�.
SELECT
	EMPNO, ENAME, SAL,
	COUNT(ENAME) OVER (ORDER BY SAL RANGE BETWEEN 50 PRECEDING AND 150 FOLLOWING) AS AROUND_ME
FROM EMP;

SELECT
	EMPNO, ENAME, SAL,
	 LISTAGG(ENAME) WITHIN GROUP (ORDER BY SAL) OVER (PARTITION BY SAL BETWEEN SAL-50 AND SAL+150) AS AROUND_ME
FROM EMP;

-----------------------------------------------------------------------
--������� �޿��������� �����ϰ�, ���� �޿����� 50~150��ŭ ���̳��� ��� �̸����� ���Ѵ�.
SELECT
	EMPNO, ENAME, SAL,
	(
		SELECT DISTINCT LISTAGG(X.ENAME, ' ') WITHIN GROUP(ORDER BY X.ENAME) OVER() FROM 
		(SELECT ENAME FROM EMP WHERE SAL BETWEEN A.SAL -50 AND A.SAL +150) X
	) AS AROUND_ME
FROM EMP A
ORDER BY A.SAL;

SELECT DISTINCT LISTAGG(ENAME, ' ') WITHIN GROUP(ORDER BY ENAME) OVER() FROM 
		(SELECT ENAME FROM EMP WHERE SAL BETWEEN 1000 -50 AND 1000+150);

SELECT
	EMPNO, ENAME, SAL,
	 LISTAGG(ENAME, ', ') WITHIN GROUP (ORDER BY SAL) OVER (PARTITION BY DEPTNO) AS DEPT_MEMBERS
FROM EMP;

-----------------------------------------------------------------------
--�����ȣ, �̸�, �޿�, �޿����ؿ����������� �Ǿ��� ������ �����ױ��� ����
SELECT
	EMPNO, ENAME, SAL,
	SUM(SAL) OVER(ORDER BY SAL ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SAL_ACC
FROM EMP;

/*******************************
    ���� ���� �Լ� p.204
    
               CUME_DIST           : ��Ƽ�� ��ü �Ǽ����� ���� �ຸ�� �۰ų� ���� �Ǽ��� ���� ���� ������� ��ȸ�Ѵ�.
               PERCENT_RANK        : ��Ƽ�ǿ��� ���� ���� ���� ���� 0����, ���� �ʰ� ���� ���� 1�� �Ͽ� ���� �ƴ� ���� ������ ������� ��ȸ�Ѵ�.
               NTILE               : ��Ƽ�Ǻ��� ��ü �Ǽ��� ARGUMENT ������ N ����� ����� ��ȸ�Ѵ�.
               RATIO_TO_REPORT     : ��Ƽ�� ���� ��ü SUM(Į��)�� ���� �� �� Į������ ������� �Ҽ������� ��ȸ�Ѵ�.
********************************/

-- JOB �� MANAGER�� ������� ������� ��ü �޿����� ������ �����ϴ� ���� ���
SELECT 
    ENAME, JOB,
    ROUND(RATIO_TO_REPORT(SAL) OVER (PARTITION BY JOB), 3) * 100 || '%' RATIO
FROM EMP
WHERE JOB = 'MANAGER';

-- ���� �μ� �Ҽӻ������ ���տ��� 
-- ������ �޿��� ���������� ���� ��% ��ġ���� �Ҽ��������� ���
SELECT
    EMPNO, ENAME, SAL, DEPTNO,
    ROUND(PERCENT_RANK() OVER (PARTITION BY DEPTNO ORDER BY SAL ASC), 5) * 100 || '%' PERCENT_RANK
FROM EMP
;

-- ��ü ����� �޿� ������������ �����ϰ� �޿��� �������� 4���� �׷����� �з�.
SELECT EMPNO, ENAME, SAL, DEPTNO,
    NTILE(4) OVER (ORDER BY SAL DESC) -- 14���� 4�� �׷����� �޿��� �������� �з��Ѵ�. \\ ������ �������� 12�� 3�� �׷�����, ������ 2�� ���� �׷쿡 �й��Ѵ�.  4/4/3/3    
FROM EMP;