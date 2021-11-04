/**********************************************************************
 * 	6.8		������ SQL
 * 
 * SQL DEVELOPER���� �����Ұ�. DBEAVER�� PL/SQL ���� �������� ����.
 * 
 **********************************************************************/


CREATE TABLE TB_POPLTN_CTPRVN -- �α��õ� ���̺� 
(
	  CTPRVN_CD CHAR(2)				-- �õ��ڵ�
	, CTPRVN_NM VARCHAR2(50) 		-- �õ��̸�
	, STD_YM CHAR(6)				
	, POPLTN_SE_CD VARCHAR2(6)		-- �α������ڵ�
	, AGRDE_SE_CD CHAR(3)			-- ���ɴ뱸���ڵ�
	, POPLTN_CNT NUMBER(10) NOT NULL -- �α���
	, CONSTRAINT TB_POPLTN_CTPRVN_PK
		PRIMARY KEY (CTPRVN_CD, STD_YM, POPLTN_SE_CD, AGRDE_SE_CD)
);

/*************************************************************************/
/*************************************************************************/
/*************************************************************************/

CREATE OR REPLACE PROCEDURE SP_INSERT_TB_POPLTN_CTPRVN -- NAMING PROCEDURE
(IN_STD_YM IN TB_POPLTN.STD_YM%TYPE) -- DEFINE INPUT PARAMETER

-- VARIABLE DECLARATION
IS
V_CTPRVN_CD TB_POPLTN_CTPRVN.CTPRVN_CD%TYPE;
V_CTPRVN_NM TB_POPLTN_CTPRVN.CTPRVN_NM%TYPE;
V_STD_YM TB_POPLTN_CTPRVN.STD_YM%TYPE;
V_POPLTN_SE_CD TB_POPLTN_CTPRVN.POPLTN_SE_CD%TYPE;
V_AGRDE_SE_CD TB_POPLTN_CTPRVN.AGRDE_SE_CD%TYPE;
V_POPLTN_CNT TB_POPLTN_CTPRVN.POPLTN_CNT%TYPE;
-- END DECLARATION

-- CURSOR DECLARATION
-- �α����̺��� �õ�����, ���س��, �α������ڵ�, ���ɱ����ڵ庰�� �α��հԸ� ��ȸ
CURSOR SELECT_TB_POPLTN IS
SELECT SUBSTR(A.ADSTRD_CD, 1, 2) AS CTPRVN_CD
	, (SELECT L.ADRES_CL_NM
		FROM TB_ADRES_CL L -- �ּҺз� ���̺��� �õ����� ������
		WHERE L.ADRES_CL_CD = SUBSTR(A.ADSTRD_CD, 1, 2)
			AND L.ADRES_CL_SE_CD = 'ACS001' -- �õ�
	  ) AS CTPRVN_NM --�õ���
    , A.STD_YM
    , A.POPLTN_SE_CD
    , A.AGRDE_SE_CD
    , SUM(A.POPLTN_CNT) AS POPLTN_CNT
FROM TB_POPLTN A -- �α����̺�
WHERE 1 = 1
GROUP BY SUBSTR(A.ADSTRD_CD, 1, 2), A.STD_YM
		, A.POPLTN_SE_CD
		, A.AGRDE_SE_CD
ORDER BY SUBSTR(A.ADSTRD_CD, 1, 2)
		, A.STD_YM
		, A.POPLTN_SE_CD
		, A.AGRDE_SE_CD
;
-- END CURSOR DECLARATION

BEGIN -- ����� ����
	OPEN SELECT_TB_POPLTN; -- Ŀ�� ����
	
	-- �ݺ��� ���� �� �α� ���
	DBMS_OUTPUT.PUT_LINE('-----------------------------');
	LOOP -- �ݺ��� ����
		-- Ŀ������ �� �྿ ������
		FETCH SELECT_TB_POPLTN INTO
			V_CTPRVN_CD,
			V_CTPRVN_NM,
			V_STD_YM,
			V_POPLTN_SE_CD,
			V_AGRDE_SE_CD,
			V_POPLTN_CNT;
		-- ���̻� ������ ���� ������ �ݺ��� ����
		EXIT WHEN SELECT_TB_POPLTN%NOTFOUND;
	
		--�α���� ����
		DBMS_OUTPUT.PUT_LINE('V_CTPRVN_CD       :' || '[' || V_CTPRVN_CD	|| ']');
		DBMS_OUTPUT.PUT_LINE('V_CTPRVN_NM       :' || '[' || V_CTPRVN_NM	|| ']');
		DBMS_OUTPUT.PUT_LINE('V_STD_YM          :' || '[' || V_STD_YM	    || ']');
		DBMS_OUTPUT.PUT_LINE('V_POPLTN_SE_CD    :' || '[' || V_POPLTN_SE_CD || ']');
		DBMS_OUTPUT.PUT_LINE('V_AGRDE_SE_CD     :' || '[' || V_AGRDE_SE_CD	|| ']');
		DBMS_OUTPUT.PUT_LINE('V_POPLTN_CNT      :' || '[' || V_POPLTN_CNT	|| ']');
		-- �α���� ����
	
		IF V_STD_YM = IN_STD_YM THEN -- ���ؿ����� �Է³���� ���� ���
			-- TB_POPLTN_CTPRVN ���̺� INSERT
			INSERT INTO TB_POPLTN_CTPRVN
				VALUES(V_CTPRVN_CD	,
						V_CTPRVN_NM	,
						V_STD_YM	,	
						V_POPLTN_SE_CD,
						V_AGRDE_SE_CD,
						V_POPLTN_CNT
			);			
		END IF;
	END LOOP;
	
	CLOSE SELECT_TB_POPLTN; -- Ŀ�� ����
	
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('-----------------------------');
END SP_INSERT_TB_POPLTN_CTPRVN; -- ����� ����
/
/*************************************************************************/

TRUNCATE TABLE TB_POPLTN_CTPRVN;
SET SERVEROUTPUT ON;
EXECUTE SP_INSERT_TB_POPLTN_CTPRVN('202010');

SELECT * FROM TB_POPLTN_CTPRVN;


-----------------------------------------------------------------------
-- 6.8.5 ����� ���� �Լ���?  p.394
-- KEYWORD : FUNCTION
--  �ݵ�� 1���� ��ȯ�Ѵ�.
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION F_GET_TK_GFF_CNT
(
    IN_SUBWAY_STATN_NO IN TB_SUBWAY_STATN.SUBWAY_STATN_NO%TYPE  -- arg 1: ����ö ��ȣ
,   IN_STD_YM IN TB_SUBWAY_STATN_TK_GFF.STD_YM%TYPE				-- arg 2: ���� '202010'
)
RETURN NUMBER IS V_TK_GFF_CNT NUMBER; -- ���ϰ� ���� // �������ο��� �հ�

BEGIN
SELECT 
    SUM(A.TK_GFF_CNT) AS TK_GFF_CNT
    INTO V_TK_GFF_CNT
FROM TB_SUBWAY_STATN_TK_GFF A
WHERE A.SUBWAY_STATN_NO = IN_SUBWAY_STATN_NO
    AND A.STD_YM = IN_STD_YM
;
RETURN V_TK_GFF_CNT;
END;
/
/*************************************************************************/
SELECT *
FROM
    (
        SELECT A.SUBWAY_STATN_NO, A.LN_NM, A.STATN_NM
              , F_GET_TK_GFF_CNT(A.SUBWAY_STATN_NO, '202010') AS TK_GFF_CNT -- ������ �ο��� �հ�
        FROM TB_SUBWAY_STATN A
        WHERE 1=1
            AND A.LN_NM = '2ȣ��'
        ORDER BY TK_GFF_CNT DESC    
    )
WHERE ROWNUM <= 10
;
-----------------------------------------------------------------------
-- 6.8.7	Ʈ���� ����
-- 
-- Ư�� ���̺� INSERT, UPDATE, DELETE�� ������ �� �ڵ����� ����
-- �α� ���̺� (TB_POPLTN)�� Ư�� �����͸� �����ϸ� �α��õ� (TB_POPLTN_CTPRVN)�� �����Ͱ� �Էµǵ��� Ʈ���� ����.
-----------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRIG_TB_POPLTN_CTPRVN_INSERT
    AFTER INSERT -- INSERT �Ŀ� ����
    ON TB_POPLTN -- �ش� ���̺�
    FOR EACH ROW -- ������ ���� �Է¸���
DECLARE -- �������� ����
    V_ADSTRD_CD       TB_POPLTN.ADSTRD_CD%TYPE;    
    V_STD_YM          TB_POPLTN.STD_YM%TYPE;
    V_POPLTN_SE_CD    TB_POPLTN.POPLTN_SE_CD%TYPE;
    V_AGRDE_SE_CD     TB_POPLTN.AGRDE_SE_CD%TYPE;
-- �������� ����
BEGIN
    V_ADSTRD_CD := :NEW.ADSTRD_CD; -- TB_POPLTN�� ������ INSERT�� ADSTRD_CD ��
    V_STD_YM := :NEW.STD_YM;
    V_POPLTN_SE_CD := :NEW.POPLTN_SE_CD;
    V_AGRDE_SE_CD := :NEW.AGRDE_SE_CD;
    
    -- TB_POPLTN_CTPRVN ���̺� �α����� ���� ������Ʈ��.
    UPDATE TB_POPLTN_CTPRVN A
        SET A.POPLTN_CNT = A.POPLTN_CNT + :NEW.POPLTN_CNT
    WHERE A.CTPRVN_CD = SUBSTR(V_ADSTRD_CD, 1, 2)
        AND A.STD_YM = V_STD_YM
        AND A.POPLTN_SE_CD = V_POPLTN_SE_CD
        AND A.AGRDE_SE_CD = V_AGRDE_SE_CD
    ;
    
    -- TB_POPLTN_CTPRVN ���̺� �ش� ���� ���ٸ� �űԷ� INSERT��.
    IF SQL%NOTFOUND THEN
        INSERT INTO TB_POPLTN_CTPRVN
        ( CTPRVN_CD
        , CTPRVN_NM
        , STD_YM
        , POPLTN_SE_CD
        , AGRDE_SE_CD
        , POPLTN_CNT )
        VALUES
        ( SUBSTR(V_ADSTRD_CD, 1, 2)
        , (SELECT L.ADRES_CL_NM -- �ּҺз� ���̺��� �õ����� ������
            FROM TB_ADRES_CL L
            WHERE L.ADRES_CL_CD = SUBSTR(V_ADSTRD_CD, 1,2)
                AND L.ADRES_CL_SE_CD = 'ACS001') -- �õ�
        , V_STD_YM
        , V_POPLTN_SE_CD
        , V_AGRDE_SE_CD
        , :NEW.POPLTN_CNT
        );
    END IF;
END;
/

-- ���ο� �ڷ� �� �Է� // Ʈ���� ȣ��
INSERT INTO TB_POPLTN (ADSTRD_CD, STD_YM, POPLTN_SE_CD, AGRDE_SE_CD, POPLTN_CNT)
    VALUES 
    ( '4128157500' -- ��⵵ ���� ��۵�
    , '202009' -- 2020�� 09�� ����
    , 'F'
    , '030'
    , 2000
    );
-- COMMIT ���� �Էµ� �ڷ� üũ
SELECT *
FROM TB_POPLTN_CTPRVN
WHERE CTPRVN_CD = '41'
    AND STD_YM = '202009';
    
ROLLBACK; -- �ѹ��ϰ��� �α����̺� �ڷᰡ �����Ǹ鼭   �α��õ� ���̺� Ʈ���Ÿ����� �� �ڷᵵ ���� ������.

COMMIT; -- �̹����� Ŀ�� �Ŀ� �ڷḦ üũ�غ���.

-- ���ο� �ڷ� �� �Է� // Ʈ���� ȣ��
INSERT INTO TB_POPLTN (ADSTRD_CD, STD_YM, POPLTN_SE_CD, AGRDE_SE_CD, POPLTN_CNT)
    VALUES 
    ( '4128158000' -- ��⵵ ���� â����
    , '202009' -- 2020�� 09�� ����
    , 'F'
    , '030'
    , 2100
    );
COMMIT;

-- �ڷ�üũ. 2000 + 2100�ؼ� 4100���� ��.
SELECT *
FROM TB_POPLTN_CTPRVN
WHERE CTPRVN_CD = '41'
    AND STD_YM = '202009';
    
/**********************************************************************
 *  PROCEDURE �� TRIGGER�� ������
 **********************************************************************/