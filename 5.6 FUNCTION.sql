--5.6 FUNCTION

--5.6.3 FUNCTION RETURNS STRING
SELECT LOWER('SQL developer') FROM DUAL;
SELECT UPPER('SQL developer') FROM DUAL;
SELECT ASCII('A') FROM DUAL;
SELECT CHR('65') FROM DUAL;
SELECT CONCAT('SQL', 'DEVELOPER') FROM DUAL;
SELECT SUBSTR('SQL developer', 1, 3) FROM DUAL;
SELECT LENGTH('SQL') FROM DUAL;
SELECT LTRIM('    SQL') FROM DUAL;
SELECT RTRIM('SQL         ') FROM DUAL;


--5.6.4 FUNCTION RETURNS NUMBER 
SELECT ABS(-15) FROM DUAL;
SELECT SIGN(-3) FROM DUAL; -- RETURN 1 IF POSITIVE NUMBER AND -1 IF NEGATIVE NUMBER
SELECT MOD(8, 3) FROM DUAL;
SELECT CEIL(38.1) FROM DUAL;
SELECT FLOOR(38.9) FROM DUAL;
SELECT ROUND(38.678, 2) FROM DUAL;
SELECT ROUND(38.678, 1) FROM DUAL;
SELECT ROUND(38.678, 0) FROM DUAL;
SELECT ROUND(38.678, -1) FROM DUAL;
SELECT TRUNC(38.678) FROM DUAL;
SELECT TRUNC(38.678, 1) FROM DUAL;
SELECT TRUNC(38.678, 2) FROM DUAL;


--5.6.5 DATETIME DATA TYPE
SELECT SYSDATE FROM DUAL;
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;
SELECT EXTRACT(MONTH FROM SYSDATE) FROM DUAL;
SELECT EXTRACT(DAY FROM SYSDATE) FROM DUAL;
SELECT EXTRACT(HOUR FROM SYSTIMESTAMP) FROM DUAL;
SELECT EXTRACT(MINUTE FROM SYSTIMESTAMP) FROM DUAL;
SELECT EXTRACT(SECOND FROM SYSTIMESTAMP) FROM DUAL;

SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) FROM DUAL;
SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'MM')) FROM DUAL;
SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'DD')) FROM DUAL;
SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) FROM DUAL;
SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'MI')) FROM DUAL;
SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'SS')) FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MM') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'DD') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'HH24') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MI') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'SS') FROM DUAL;


--5.6.6 DATETIME CALC
SELECT SYSDATE FROM DUAL;
SELECT SYSTIMESTAMP FROM DUAL;
SELECT SYSDATE - 2 FROM DUAL;				-- SUBTRACT DAY
SELECT SYSDATE - (3/24) FROM DUAL;			-- SUBTRACT HOUR
SELECT SYSDATE - (1/24/60) FROM DUAL;		-- SUBTRACT MINUTE
SELECT SYSDATE - (1/24/60/60) FROM DUAL;	-- SUBTRACT SECOND
SELECT SYSDATE - (1/24/60/60) * 10 FROM DUAL; -- SUBTRACT 10 SECONDS
SELECT SYSDATE - (1/24/60/60) * 30 FROM DUAL; -- SUBTRACT 30 SECONDS


--5.6.7 TYPE CONVERSION  (CAST)
--EXPLICIT CONVERSION: USE FUNCTIONS LIKE TO_CHAR, TO_NUMBER, TO_DATE
--IMPLICIT CONVERSION: AUTO
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(10.25, '$999,999,999.99') FROM DUAL;
SELECT TO_CHAR(12500, 'L999,999,999') FROM DUAL;  -- L MEANS LOCAL CURRENCY
SELECT TO_CHAR(256, 'XXXX')  FROM DUAL;
SELECT TO_BINARY_DOUBLE('10') FROM DUAL;
SELECT TO_NUMBER('100') + TO_NUMBER('100') FROM DUAL;
SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD') AS RESULT FROM DUAL;

--5.6.9 ������ CASE ǥ���� ����

SELECT
	CASE WHEN A.INDUTY_CL_SE_CD = 'ICS001'
		THEN '��'
		WHEN A.INDUTY_CL_SE_CD = 'ICS002'
		THEN '��'
		WHEN A.INDUTY_CL_SE_CD = 'ICS003'
		THEN '��'
		ELSE '_'
	END AS "�����з�����"
FROM TB_INDUTY_CL_SE A;

SELECT
	DECODE(
		A.INDUTY_CL_SE_CD,
		'ICS001',
		'��',
		'ICS002',
		'��',
		'ICS003',
		'��',
		'_'
	) AS "ũ��з�����"
FROM TB_INDUTY_CL_SE A;


--NULL ���� �н�
SELECT COALESCE(NULL, 4, 2, 5) FROM DUAL;

--NULL�� � ������ �ص� NULL�� �ȴ�.
SELECT
	NULL + 2,
	NULL - 2,
	NULL * 2,
	NULL / 2,
	MOD(10, NULL),
	'WOW' || NULL
FROM DUAL;

SELECT * FROM TB_INDUTY_CL A;

SELECT
	A.INDUTY_CL_CD,
	A.INDUTY_CL_NM,
	A.INDUTY_CL_SE_CD,
	NVL(UPPER_INDUTY_CL_CD, '�ֻ���') AS UPPER_INDUTY_CL_CD
FROM TB_INDUTY_CL A
WHERE A.UPPER_INDUTY_CL_CD IS NULL;

SELECT
	NULLIF('SQLD', 'SQLP'), -- �� ���ڰ� �ٸ��� ���� �� 
	NULLIF('SQLD', 'SQLD'), -- �� ���ڰ� ������ NULL
	NULLIF(1, 1),
	NULLIF(55, 1)
FROM DUAL;

SELECT
	NVL(NULL, 3),
	NVL(1, 3),
	NVL(NULL, NULL),
	NVL2(NULL, 10, 0), -- ���� 1�� NULL�̸� ������ ����
	NVL2(0, 10, 0),		-- ���� 1�� NULL �ƴϸ� �ι�° ����
	NVL2(NULL, 10, NULL)	
FROM DUAL;
