/**********************************************************************
 * AGGREGATE FUNCTIONS
 ***********************************************************************/

COUNT(*)
COUNT(ATTRIBUTE)
SUM(ATTRIBUTE)
AVG(ATTRIBUTE)
MAX(ATTRIBUTE)
MIN(ATTRIBUTE)
STDDEV(ATTRIBUTE)
VARIAN(ATTRIBUTE)


SELECT
	COUNT(*) AS "��ü�󰡼�",
	MAX(LO) AS "�ִ�浵", MIN(LO) AS "�ּҰ浵",
	MAX(LA) AS "�ִ�����", MIN(LA) AS "�ּ�����"
FROM TB_BSSH;


/**********************************************************************
 * EMPTY SET AND MAX()
 **********************************************************************/
SELECT *
FROM TB_SUBWAY_STATN A
WHERE A.STATN_NM = '��翪'; -- ������ ����

SELECT
	MAX(A.SUBWAY_STATN_NO), -- MAX �Լ��� �������̶� NULL�� ������ 1���� ��ȯ�Ѵ�.
	MAX(A.LN_NM),
	MAX(A.STATN_NM)
FROM TB_SUBWAY_STATN A
WHERE A.STATN_NM = '��翪';

SELECT
	NVL(MAX(A.SUBWAY_STATN_NO), '����ö������') AS SUBWAY_STATN_NO, -- MAX�� NULL���� �̿��ؼ� �������� ��� ����� �޽��� ���� ����
	NVL(MAX(A.LN_NM), '�뼱�����') AS LN_NM,
	NVL(MAX(A.STATN_NM), '�������') AS STATN_NM
FROM TB_SUBWAY_STATN A
WHERE A.STATN_NM = '��翪';

/**********************************************************************
 * 5.7.6 GROUP BY
 **********************************************************************/
--�α� ���̺��� �α������ڵ庰 �α��� �÷��� �հ踦 ���϶�.

SELECT * FROM TB_POPLTN;
SELECT DISTINCT STD_YM FROM TB_POPLTN;

SELECT
	DECODE(POPLTN_SE_CD, 'M', '����', 'F', '����', 'T', '��ü', '?') AS �α�����,
	SUM(POPLTN_CNT)
FROM TB_POPLTN
GROUP BY POPLTN_SE_CD;

SELECT
	POPLTN_SE_CD,
	AGRDE_SE_CD,
	SUM(POPLTN_CNT) AS "�α����հ�"
FROM TB_POPLTN
GROUP BY POPLTN_SE_CD, AGRDE_SE_CD
	HAVING SUM(POPLTN_CNT) < 1000000	
ORDER BY �α����հ�;


SELECT
	SUBWAY_STATN_NO,
	"�����ο����հ�"
	"�����ο����հ�"
	"��ٽð�������ο����հ�"	"��ٽð��������ο����հ�"
	"��ٽð�������ο����հ�"	"��ٽð��������ο����հ�"
	"�������ο����հ�"
FROM TB_SUBWAY_STATN_TK_GFF
WHERE STD_YM = '202010';


SELECT
	(SELECT STATN_NM FROM TB_SUBWAY_STATN T WHERE T.SUBWAY_STATN_NO = A.SUBWAY_STATN_NO) AS "STATION",
	SUM(CASE
			WHEN TK_GFF_SE_CD = 'TGS001'
			THEN TK_GFF_CNT
			ELSE 0 
		END) AS "�����ο����հ�",
	SUM(CASE
			WHEN TK_GFF_SE_CD = 'TGS002'
			THEN TK_GFF_CNT
			ELSE 0 
		END) AS "�����ο����հ�",
	SUM(CASE
			WHEN	BEGIN_TIME = '0800'
			AND		END_TIME = '0900'
			AND 	TK_GFF_SE_CD = 'TGS001'
			THEN 	TK_GFF_CNT
			ELSE 	0
		END) AS "��ٽð�������ο����հ�",
	SUM(CASE
			WHEN	BEGIN_TIME = '0800'
			AND		END_TIME = '0900'
			AND 	TK_GFF_SE_CD = 'TGS002'
			THEN 	TK_GFF_CNT
			ELSE 	0
		END) AS "��ٽð��������ο����հ�",
	SUM(CASE
			WHEN	BEGIN_TIME = '1800'
			AND		END_TIME = '1900'
			AND 	TK_GFF_SE_CD = 'TGS001'
			THEN 	TK_GFF_CNT
			ELSE 	0
		END) AS "��ٽð�������ο����հ�",
	SUM(CASE
			WHEN	BEGIN_TIME = '1800'
			AND		END_TIME = '1900'
			AND 	TK_GFF_SE_CD = 'TGS002'
			THEN 	TK_GFF_CNT
			ELSE 	0
		END) AS "��ٽð��������ο����հ�",
	SUM(TK_GFF_CNT) AS "�������ο����հ�"
FROM TB_SUBWAY_STATN_TK_GFF A
WHERE STD_YM = '202010'
GROUP BY SUBWAY_STATN_NO
	HAVING SUM(CASE WHEN TK_GFF_SE_CD = 'TGS001'
					THEN TK_GFF_CNT ELSE 0 END) >= 1000000
	OR 	   SUM(CASE WHEN TK_GFF_SE_CD = 'TGS002'
					THEN TK_GFF_CNT ELSE 0 END) >= 1000000;

/**********************************************************************
 * 5.7.9 ���� �Լ��� NULL
 **********************************************************************/
--�׽�Ʈ ���̺� ����
CREATE TABLE TB_AGG_NULL_TEST (NUM NUMBER(15, 2));

INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES(NULL);
INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES(10);
INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES(20);
INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES(30);
INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES(40);
COMMIT;
-- ���� �Լ� �̿�
SELECT * FROM TB_AGG_NULL_TEST;
SELECT
	SUM(NUM), AVG(NUM), MAX(NUM), MIN(NUM), COUNT(NUM), COUNT(*)
FROM TB_AGG_NULL_TEST;


/**********************************************************************
 * 5.8 ORDER BY
 **********************************************************************/

SELECT
	INDUTY_CL_CD,
	INDUTY_CL_NM,
	INDUTY_CL_SE_CD,
	UPPER_INDUTY_CL_CD
FROM TB_INDUTY_CL A
WHERE INDUTY_CL_SE_CD = 'ICS001'
ORDER BY INDUTY_CL_CD ASC;

SELECT
	INDUTY_CL_CD,
	INDUTY_CL_NM,
	INDUTY_CL_SE_CD,
	UPPER_INDUTY_CL_CD
FROM TB_INDUTY_CL A
WHERE INDUTY_CL_SE_CD = 'ICS001'
ORDER BY INDUTY_CL_CD DESC;

-- NULL�� ����
-- ����Ŭ�� ORDER BY ���� Į���� ���� NULL�϶� ���� ū ���̶�� �ν��Ѵ�.
SELECT
	INDUTY_CL_CD,
	INDUTY_CL_NM,
	INDUTY_CL_SE_CD,
	UPPER_INDUTY_CL_CD
FROM TB_INDUTY_CL A
WHERE INDUTY_CL_CD LIKE 'Q%'
	AND INDUTY_CL_NM LIKE '%����%'
ORDER BY UPPER_INDUTY_CL_CD DESC;

-- SELECT ���� ���� ����
FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY

-- PROJECTION ����� �ƴ� �÷����ε� ������ �����ϴ�.
SELECT
	SUBWAY_STATN_NO,
	LN_NM
FROM TB_SUBWAY_STATN
WHERE LN_NM LIKE '9%' ORDER BY STATN_NM;

SELECT
	SUBWAY_STATN_NO,
	LN_NM, STATN_NM -- Ȯ�� 
FROM TB_SUBWAY_STATN
WHERE LN_NM LIKE '9%' ORDER BY STATN_NM;

-- GROUP BY�� ��쿡�� PROJECTION ��� ATTR���� ���Ŀ� ����Ҽ� �ִ�.
SELECT
	AGRDE_SE_CD,
	SUM(POPLTN_CNT)
FROM TB_POPLTN
WHERE STD_YM = '202010' AND POPLTN_SE_CD IN ('M', 'F')
GROUP BY AGRDE_SE_CD
ORDER BY SUM(POPLTN_CNT) DESC;
SELECT
	AGRDE_SE_CD,
	SUM(POPLTN_CNT)
FROM TB_POPLTN
WHERE STD_YM = '202010' AND POPLTN_SE_CD IN ('M', 'F')
GROUP BY AGRDE_SE_CD
ORDER BY POPLTN_SE_CD DESC; -- ������ ���ϴ�.

-- ROWNUM

SELECT BSSH_NO,
	CMPNM_NM,
	BHF_NM,
	LNM_ADRES,
	LO, LA
FROM TB_BSSH
ORDER BY LO;



SELECT BSSH_NO,
	CMPNM_NM,
	BHF_NM,
	LNM_ADRES,
	LO, LA
FROM (
	SELECT BSSH_NO,
		CMPNM_NM,
		BHF_NM,
		LNM_ADRES,
		LO, LA
	FROM TB_BSSH
	ORDER BY LO
	)
WHERE ROWNUM <= 10;

