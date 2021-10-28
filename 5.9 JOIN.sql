/**********************************************************************
 * 5.9.2	2�� ���̺� ����
 **********************************************************************/

SELECT * FROM TB_SUBWAY_STATN;			--����ö ��

SELECT * FROM TB_SUBWAY_STATN_TK_GFF;   -- ����ö�� ����������


--�������� �������� 2020�� 10�� �Ѵ� ���� ��ٽð��� 8�� ~9�� �� ������ �������� �ο� �� 


SELECT SUBWAY_STATN_NO, STATN_NM FROM TB_SUBWAY_STATN WHERE STATN_NM LIKE '����%';

SELECT 
	A.SUBWAY_STATN_NO,
	A.LN_NM,
	A.STATN_NM,
	B.BEGIN_TIME, B.END_TIME,
	CASE WHEN B.TK_GFF_SE_CD = 'TGS001' THEN '����'
		 WHEN B.TK_GFF_SE_CD = 'TGS002' THEN '����'
	 END TK_GFF_SE_NM,
	B.TK_GFF_CNT
FROM TB_SUBWAY_STATN A, TB_SUBWAY_STATN_TK_GFF B
WHERE A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
	AND A.SUBWAY_STATN_NO = '000032' -- 2ȣ�� ����
	AND B.STD_YM = '202010'
	AND B.BEGIN_TIME = '0800'
	AND B.END_TIME = '0900';
	
/**********************************************************************
 * 5.9.3	3�� ���̺� ����
 **********************************************************************/
SELECT * FROM TB_TK_GFF_SE; --�����������ڵ�

SELECT
	A.SUBWAY_STATN_NO,
	A.LN_NM, A.STATN_NM,
	B.BEGIN_TIME, B.END_TIME,
	C.TK_GFF_SE_NM,
	B.TK_GFF_CNT
FROM
	TB_SUBWAY_STATN A,
	TB_SUBWAY_STATN_TK_GFF B,
	TB_TK_GFF_SE C
WHERE
	A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO AND
	A.SUBWAY_STATN_NO = '000032' AND
	B.STD_YM = '202010' AND
	B.BEGIN_TIME = '0800' AND
	B.END_TIME = '0900' AND
	B.TK_GFF_SE_CD = C.TK_GFF_SE_CD;

/**********************************************************************
 * 5.9.4	4�� ���̺� ����
 **********************************************************************/

SELECT * FROM TB_POPLTN;
SELECT * FROM TB_POPLTN_SE;
SELECT * FROM TB_AGRDE_SE;
SELECT * FROM TB_ADSTRD;

SELECT 
	A.ADSTRD_CD,
	D.ADSTRD_NM,
	A.POPLTN_SE_CD,
	B.POPLTN_SE_NM,
	A.AGRDE_SE_CD,
	C.AGRDE_SE_NM,
	A.POPLTN_CNT
FROM TB_POPLTN A,
	TB_POPLTN_SE B,
	TB_AGRDE_SE C,
	TB_ADSTRD D
WHERE A.ADSTRD_CD = D.ADSTRD_CD
	AND A.POPLTN_SE_CD = B.POPLTN_SE_CD
	AND A.AGRDE_SE_CD = C.AGRDE_SE_CD
	AND A.POPLTN_SE_CD IN ('M', 'F')
	AND A.STD_YM = '202010'
	AND C.AGRDE_SE_CD IN ('020', '030', '040')
	AND D.ADSTRD_NM LIKE '%��⵵%����%���籸%���%'
ORDER BY A.POPLTN_CNT DESC;

/**********************************************************************
 * 5.10.1 �� ������ (��/��) ��Ÿ���� Ŀ�� ���� �� ���ϱ�
 **********************************************************************/
SELECT
	CTPRVN_CD, CMPNM_NM, BHF_NM, LNM_ADRES, ADSTRD_CD
FROM TB_BSSH
WHERE (CMPNM_NM LIKE '%��Ÿ����%'
		OR 
		UPPER(CMPNM_NM) LIKE '%STAR%BUCKS%');

SELECT * FROM TB_ADRES_CL;

SELECT
	A.CTPRVN_CD, 
	B.ADRES_CL_NM,
	COUNT(*) AS CNT
FROM TB_BSSH A, TB_ADRES_CL B
WHERE (CMPNM_NM LIKE '%��Ÿ����%'
		OR 
		UPPER(CMPNM_NM) LIKE '%STAR%BUCKS%')
	AND A.CTPRVN_CD = B.ADRES_CL_CD
	AND B.ADRES_CL_SE_CD = 'ACS001' -- �õ� ����
GROUP BY A.CTPRVN_CD, B.ADRES_CL_NM
ORDER BY CNT DESC
;

/**********************************************************************
 * 5.10.2	��ٽð��� �����ο��� ���� ���� ������ ��ȸ�ϱ�    p.
 **********************************************************************/

WITH RES AS (
	SELECT
		A.SUBWAY_STATN_NO AS ����ȣ,
		B.LN_NM,
		B.STATN_NM,
		A.BEGIN_TIME || ' ~ ' || A.END_TIME AS "ž�½ð�",
		C.TK_GFF_SE_NM AS "������",
		A.TK_GFF_CNT
	FROM TB_SUBWAY_STATN_TK_GFF A, TB_SUBWAY_STATN B, TB_TK_GFF_SE C
	WHERE A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
		AND A.TK_GFF_SE_CD = C.TK_GFF_SE_CD
		AND A.STD_YM = '202010'
		AND A.BEGIN_TIME = '0800'
		AND A.END_TIME = '0900'
		AND A.TK_GFF_SE_CD = 'TGS002'
	ORDER BY A.TK_GFF_CNT DESC
	)
SELECT * FROM RES WHERE ROWNUM <= 20;

/**********************************************************************
 * 5.10.3	���ɴ뺰 ����/���� �α��� ���ϱ�	p.
 **********************************************************************/

SELECT *  FROM TB_POPLTN A;

WITH SDL AS (
	SELECT AGRDE_SE_CD, AGRDE_SE_NM FROM TB_AGRDE_SE
)
SELECT A.AGRDE_SE_CD, (SELECT SDL.AGRDE_SE_NM FROM SDL WHERE SDL.AGRDE_SE_CD = A.AGRDE_SE_CD) AS ���ɴ뼳��,
	SUM(DECODE(A.POPLTN_SE_CD, 'M', A.POPLTN_CNT, 0)) AS MALE_POPLTN_CNT,
	SUM(DECODE(A.POPLTN_SE_CD, 'F', A.POPLTN_CNT, 0)) AS FEMALE_POPLTN_CNT,
	SUM(A.POPLTN_CNT) AS TOTAL
FROM TB_POPLTN A
GROUP BY A.AGRDE_SE_CD
ORDER BY A.AGRDE_SE_CD;

/**********************************************************************
 * 6.1.5	INNER JOIN	p.290
 **********************************************************************/

-- �ϳ��� ����ö���� ���� ���� ������ ������ ������.
-- ����ö�� 1ȣ�� ���￪ ���� 08�� ~ 09�� �������ο� ��ȸ

SELECT A.SUBWAY_STATN_NO,
	   A.LN_NM,
	   A.STATN_NM,
	   B.BEGIN_TIME,
	   B.END_TIME,
	   CASE WHEN B.TK_GFF_SE_CD = 'TGS001' THEN '����'
	   		WHEN B.TK_GFF_SE_CD = 'TGS002' THEN '����'
	   		END AS TK_GFF_SE_NM,
	   B.TK_GFF_CNT	
FROM TB_SUBWAY_STATN A, TB_SUBWAY_STATN_TK_GFF B
WHERE   A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
	AND A.SUBWAY_STATN_NO = '000001' -- 1ȣ�� ���￪
	AND B.STD_YM = '202010'
	AND B.BEGIN_TIME = '0800'
	AND B.END_TIME = '0900'
ORDER BY B.TK_GFF_CNT DESC;
-- 1ȣ�� ���￪�� ��ٽð��뿡 �����ο����� �����ο��� �� 3�� ����.

/**********************************************************************
 * 6.1.6    NATURAL JOIN    p.291
 **********************************************************************/

-- NATURAL JOIN�� �� ���̺��� �÷����� ���� �Ӽ��� �ϳ� �̻� �̿��� �����Ѵ�.
-- ������ ���� �ڵ����� �����̸��� �Ӽ��� ��� ã�Ƽ� �����ع�����.
-----------------------------------------------------------------------

-- �ǽ��� ���̺� ����
CREATE TABLE TT_DEPT_616
(
	  DEPT_CD CHAR(4)
	, DEPT_NM VARCHAR2(50)
	, CONSTRAINT PK_TT_DEPT_616 PRIMARY KEY (DEPT_CD)
);

INSERT INTO TT_DEPT_616 (DEPT_CD, DEPT_NM) VALUES ('D001', 'Data Team');
INSERT INTO TT_DEPT_616 (DEPT_CD, DEPT_NM) VALUES ('D002', 'Sales Team');
INSERT INTO TT_DEPT_616 (DEPT_CD, DEPT_NM) VALUES ('D003', 'IT Dev Team');
COMMIT;

CREATE TABLE TT_EMP_616
(
	  EMP_NO CHAR(4)
	, EMP_NM VARCHAR2(50)
	, DEPT_CD CHAR(4)
	, CONSTRAINT PK_TT_EMP_616 PRIMARY KEY(EMP_NO)
);

INSERT INTO TT_EMP_616 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E001', '�̰��', 'D001');
INSERT INTO TT_EMP_616 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E002', '�̼���', 'D001');
INSERT INTO TT_EMP_616 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E003', '�迵��', 'D002');
INSERT INTO TT_EMP_616 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E004', '�ڿ���', 'D002');
INSERT INTO TT_EMP_616 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E005', '�ְ���', 'D003');
INSERT INTO TT_EMP_616 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E006', '������', 'D003');

ALTER TABLE TT_EMP_616
ADD CONSTRAINT FK_TT_EMP_616 FOREIGN KEY (DEPT_CD)
REFERENCES TT_DEPT_616 (DEPT_CD);


TRUNCATE TABLE TT_EMP_616;
SELECT * FROM TT_DEPT_616;
SELECT * FROM TT_EMP_616;

-----------------------------------------------------------------------
-- NATURAL JOIN �ǽ�

SELECT *
FROM TT_DEPT_616 A NATURAL JOIN TT_EMP_616 B
;

SELECT DEPT_CD -- �ڵ����� ã�� ���� ��� Į������ TABLE ALIAS ��� �ȵȴ�.
	, A.DEPT_NM
	, B.EMP_NO
	, B.EMP_NM
FROM TT_DEPT_616 A NATURAL JOIN TT_EMP_616 B
ORDER BY DEPT_CD
;

SELECT A.DEPT_CD
	 , A.DEPT_NM
	 , B.EMP_NO
	 , B.EMP_NM
FROM TT_DEPT_616 A, TT_EMP_616 B
WHERE A.DEPT_CD = B.DEPT_CD
ORDER BY A.DEPT_CD
;

ALTER TABLE TB_EMP_616 RENAME TO TT_EMP_616;
ALTER TABLE TB_DEPT_616 RENAME TO TT_DEPT_616;

-----------------------------------------------------------------------
-- USING ��

/*NATURAL JOIN�� �ϸ� ������ ����Į���� �ڵ����� ��Ī�ǹǷ�
���� Į���� �����ϰ� ���� ��쿡�� USING CLAUS �� ���*/

SELECT MAX(A.LN_NM)
	 , A.STATN_NM
	 , MIN(B.BEGIN_TIME) || '~' || MAX(B.END_TIME) AS TIMERANGE
	 , C.TK_GFF_SE_NM
	 , SUM(B.TK_GFF_CNT) POPULATION
FROM TB_SUBWAY_STATN A JOIN TB_SUBWAY_STATN_TK_GFF B
	USING (SUBWAY_STATN_NO) JOIN TB_TK_GFF_SE C
	USING (TK_GFF_SE_CD)
WHERE A.STATN_NM IS NOT NULL
	AND B.STD_YM = '202010'
	AND B.BEGIN_TIME > '0600' AND B.END_TIME < '1100'
GROUP BY A.STATN_NM, C.TK_GFF_SE_NM HAVING MAX(A.LN_NM) IN ('���Ǽ�', '�߾Ӽ�')
ORDER BY A.STATN_NM, POPULATION
;

SELECT DISTINCT BEGIN_TIME, END_TIME FROM TB_SUBWAY_STATN_TK_GFF;
SELECT * FROM TB_SUBWAY_STATN;
SELECT * FROM TB_TK_GFF_SE;

-----------------------------------------------------------------------
-- ON ��

SELECT A.SUBWAY_STATN_NO,
	   A.LN_NM,
	   A.STATN_NM,
	   B.BEGIN_TIME,
	   B.END_TIME,
	   CASE WHEN B.TK_GFF_SE_CD = 'TGS001' THEN '����'
	   		WHEN B.TK_GFF_SE_CD = 'TGS002' THEN '����'
	   		END AS TK_GFF_SE_NM,
	   B.TK_GFF_CNT	
FROM TB_SUBWAY_STATN A INNER JOIN TB_SUBWAY_STATN_TK_GFF B
	ON A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
WHERE   A.SUBWAY_STATN_NO = '000001' -- 1ȣ�� ���￪
	AND B.STD_YM = '202010'
	AND B.BEGIN_TIME = '0800'
	AND B.END_TIME = '0900'
ORDER BY B.TK_GFF_CNT DESC;

-----------------------------------------------------------------------
-- 3�� ���̺� ���� 
-- ��ٽð� ������ ������ �ο���
SELECT A.SUBWAY_STATN_NO
	 , A.LN_NM
	 , A.STATN_NM
	 , B.BEGIN_TIME
	 , B.END_TIME
	 , C.TK_GFF_SE_NM
	 , B.TK_GFF_CNT
FROM TB_SUBWAY_STATN A, TB_SUBWAY_STATN_TK_GFF B, TB_TK_GFF_SE C
WHERE   A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO -- AB ��������
	AND B.TK_GFF_SE_CD = C.TK_GFF_SE_CD       -- BC ��������
	AND A.SUBWAY_STATN_NO = '000032'
	AND B.STD_YM = '202010'
	AND B.BEGIN_TIME = '0800'
	AND B.END_TIME = '0900'
;

-- ANSI ǥ�� ����� �̿��� ����
SELECT A.SUBWAY_STATN_NO 
	 , A.LN_NM
	 , A.STATN_NM
	 , B.BEGIN_TIME
	 , B.END_TIME
	 , C.TK_GFF_SE_NM
	 , B.TK_GFF_CNT
FROM TB_SUBWAY_STATN A INNER JOIN -- ANSI ǥ�� ����� �̿��� ����
	 TB_SUBWAY_STATN_TK_GFF B ON (A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO) INNER JOIN -- AB ��������
	 TB_TK_GFF_SE C           ON (B.TK_GFF_SE_CD = C.TK_GFF_SE_CD) -- BC ��������
WHERE   A.SUBWAY_STATN_NO = '000032'
	AND B.STD_YM = '202010'
	AND B.BEGIN_TIME = '0800'
	AND B.END_TIME = '0900'
;

-----------------------------------------------------------------------
-- OUTER JOIN

-- �ǽ��� ���̺� ����
CREATE TABLE TT_DEPT_6110
(
	  DEPT_CD CHAR(4)
	, DEPT_NM VARCHAR2(50)
	, CONSTRAINT PK_TT_DEPT_6110 PRIMARY KEY (DEPT_CD)
);

INSERT INTO TT_DEPT_6110 (DEPT_CD, DEPT_NM) VALUES ('D001', 'Data Team');
INSERT INTO TT_DEPT_6110 (DEPT_CD, DEPT_NM) VALUES ('D002', 'Sales Team');
INSERT INTO TT_DEPT_6110 (DEPT_CD, DEPT_NM) VALUES ('D003', 'IT Dev Team');
INSERT INTO TT_DEPT_6110 (DEPT_CD, DEPT_NM) VALUES ('D004', '4th Indstrl Rev Team');
INSERT INTO TT_DEPT_6110 (DEPT_CD, DEPT_NM) VALUES ('D005', 'AI Research Team');

COMMIT;

CREATE TABLE TT_EMP_6110
(
	  EMP_NO CHAR(4)
	, EMP_NM VARCHAR2(50)
	, DEPT_CD CHAR(4)
	, CONSTRAINT PK_TT_EMP_6110 PRIMARY KEY(EMP_NO)
);

INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E001', '�̰��', 'D001');
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E002', '�̼���', 'D001');
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E003', '�迵��', 'D002');
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E004', '�ڿ���', 'D002');
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E005', '�ְ���', 'D003');
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E006', '������', 'D003');
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E007', '������', NULL);
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E008', '������', NULL);
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E009', '��ȸ��', 'D000');

ALTER TABLE TT_EMP_6110
ADD CONSTRAINT FK_TT_EMP_6110 FOREIGN KEY (DEPT_CD)
REFERENCES TT_DEPT_6110 (DEPT_CD);

ALTER TABLE TT_EMP_6110
DROP CONSTRAINT FK_TT_EMP_6110;

SELECT * FROM TT_EMP_6110;
UPDATE TT_EMP_6110 SET DEPT_CD = 'D000' WHERE EMP_NM = '��ȸ��';

-----------------------------------------------------------------------
-- 6.1.11    LEFT OUTER JOIN    p.301

SELECT * FROM TT_DEPT_6110;
SELECT * FROM TT_EMP_6110;

SELECT *
FROM TT_DEPT_6110 A, TT_EMP_6110 B
WHERE A.DEPT_CD = B.DEPT_CD (+)   --- ORACLE ��� LEFT OUTER JOIN
ORDER BY A.DEPT_CD;

SELECT *
FROM TT_DEPT_6110 A LEFT OUTER JOIN TT_EMP_6110 B
	ON (A.DEPT_CD = B.DEPT_CD)     --- ANSI ��� LEFT OUTER JOIN
ORDER BY A.DEPT_CD;

-----------------------------------------------------------------------
-- 6.1.12    RIGHT OUTER JOIN    p.303

SELECT *
FROM TT_DEPT_6110 A, TT_EMP_6110 B
WHERE A.DEPT_CD (+) = B.DEPT_CD    --- ORACLE ��� RIGHT OUTER JOIN
ORDER BY A.DEPT_CD;

SELECT *
FROM TT_DEPT_6110 A RIGHT OUTER JOIN TT_EMP_6110 B
	ON (A.DEPT_CD = B.DEPT_CD)     --- ANSI ��� RIGHT OUTER JOIN
ORDER BY A.DEPT_CD;

-----------------------------------------------------------------------
-- 6.1.13    FULL OUTER JOIN    p.305

FULL OUTER JOIN = INNER JOIN + LEFT AND RIGHT OUTER JOIN
�ǹ����� ������ ���� �۾��� ���� ����
����Ŭ ��� ����.  ANSI ǥ�� ��ĸ� ����.

SELECT *
FROM TT_DEPT_6110 A FULL OUTER JOIN TT_EMP_6110 B
	ON (A.DEPT_CD = B.DEPT_CD)     --- ANSI ��� FULL OUTER JOIN
ORDER BY A.DEPT_CD;

-----------------------------------------------------------------------
-- 6.1.14    CROSS JOIN    p.306

2���� ���̺��� FROM ���� �����ϰ� �ƹ��� ���� ���ǵ� ���� ������ CROSS JOIN �ȴ�.
CROSS JOIN == CARTESIAN PRODUCT  ���ڵ� ����  n * m 

SELECT ROWNUM AS RNUM, A.*, B.*
FROM TT_DEPT_6110 A, TT_EMP_6110 B -- DEPT�� 5 Ʃ��, EMP�� 9 Ʃ��
-- ���� ������ ���� ���̺� ������ �����ϸ� CROSS JOIN
ORDER BY RNUM;

SELECT ROWNUM AS RNUM, A.*, B.*
FROM TT_DEPT_6110 A CROSS JOIN TT_EMP_6110 B -- ANSI STANDARD
ORDER BY RNUM;

-----------------------------------------------------------------------
--
-- CROSS JOIN�� Ư�� ���̺��� �����͸� ������ �� ���� ����Ѵ�.
-----------------------------------------------------------------------
SELECT * FROM TB_INDUTY_CL_SE; -- ���߼�

-- ������ �ӽ����̺� ����
CREATE TABLE TT_COPY_3
(
  COPY_NUM NUMBER PRIMARY KEY  
);
INSERT INTO TT_COPY_3 (COPY_NUM) VALUES (1);
INSERT INTO TT_COPY_3 (COPY_NUM) VALUES (2);
INSERT INTO TT_COPY_3 (COPY_NUM) VALUES (3);
SELECT * FROM TT_COPY_3;

--CROSS JOIN�� �̿��� ������ ����
SELECT *
FROM TB_INDUTY_CL_SE A CROSS JOIN TT_COPY_3 B -- ���߼� / ���߼� / ���߼�
ORDER BY B.COPY_NUM;



/**********************************************************************
 * 6.2    ���տ�����    p.310
 **********************************************************************/

UNION, UNION ALL, INTERSECT, MINUS

UNION - ������ ������ ��� ������
	  - �ߺ��� ���ŵ�
	  - ������ �߻��� �� ����
UNION ALL - ������ ������ ��� ������
		  - �ߺ��൵ �״�� ���
		  - �������� ����
INTERSECT - ������ ������ ��� ������
		  - �ߺ��� ���ŵ�
MINUS     - �� ���� ������� �Ʒ� ���� ����� ��

-----------------------------------------------------------------------
-- 6.2.2    UNION, UNION ALL

SELECT INDUTY_CL_CD AS INDST_CODE
FROM TB_INDUTY_CL A
WHERE   INDUTY_CL_SE_CD = 'ICS001' -- ��з���
	AND INDUTY_CL_CD = 'Q'   -- ��ľ�   // ��з��� �ϳ��� ����
UNION
SELECT UPPER_INDUTY_CL_CD AS UPPER_INDST_CODE
FROM TB_INDUTY_CL
WHERE   INDUTY_CL_SE_CD = 'ICS002' -- �ߺз���
	AND INDUTY_CL_CD LIKE 'Q%'    -- Ŀ����/ī��      // �ߺз��� ������ 14�� ����.
; -- �ߺ��� ��� ���ŵǰ� 1���� ����.

SELECT INDUTY_CL_CD AS INDST_CODE
FROM TB_INDUTY_CL A
WHERE   INDUTY_CL_SE_CD = 'ICS001' -- ��з���
	AND INDUTY_CL_CD = 'Q'   -- ��ľ�   // ��з��� �ϳ��� ����
UNION ALL
SELECT UPPER_INDUTY_CL_CD AS UPPER_INDST_CODE
FROM TB_INDUTY_CL
WHERE   INDUTY_CL_SE_CD = 'ICS002' -- �ߺз���
	AND INDUTY_CL_CD LIKE 'Q%'    -- Ŀ����/ī��      // �ߺз��� ������ 14�� ����.
; -- �ߺ��� �״�� �����ǰ� �������� 15�� ����.

-----------------------------------------------------------------------
-- 6.2.4    UNION, UNION ALL �� �������

UNION ���� ���� ������ ���ɼ��� ������,  ������ �����ϱ� ���ؼ��� �ݵ�� ORDER BY ���� ����ؾ� �Ѵ�.
UNION/UNION ALL ����� ORDER BY ���� Į������ ALIAS ����� �� ����.

SELECT INDUTY_CL_CD, INDUTY_CL_NM
FROM TB_INDUTY_CL A
WHERE   INDUTY_CL_SE_CD = 'ICS002' -- �ߺз���
	AND INDUTY_CL_CD LIKE 'N%'   ---����/����/����
UNION ALL 
SELECT INDUTY_CL_CD AS �����з��ڵ�, INDUTY_CL_NM AS �����з���
FROM TB_INDUTY_CL B
WHERE   INDUTY_CL_SE_CD = 'ICS002' -- �ߺз���
	AND INDUTY_CL_CD LIKE 'O%'   ---����
ORDER BY INDUTY_CL_CD
;

SELECT INDUTY_CL_CD AS �����з��ڵ�, INDUTY_CL_NM AS �����з��� -- HEADER ���� ���� ������ ����� ���󰣴�.
FROM TB_INDUTY_CL A
WHERE   INDUTY_CL_SE_CD = 'ICS002' -- �ߺз���
	AND INDUTY_CL_CD LIKE 'O%'   ---����
UNION ALL 
SELECT INDUTY_CL_CD, INDUTY_CL_NM
FROM TB_INDUTY_CL B
WHERE   INDUTY_CL_SE_CD = 'ICS002' -- �ߺз���
	AND INDUTY_CL_CD LIKE 'N%'   ---����/����/����
ORDER BY �����з��ڵ�            -- ORDER BY ���� �� �÷��� HEADER�� �����ش�.
;