/**********************************************************************
 * 	6.8		절차형 SQL
 * 
 * SQL DEVELOPER에서 실행할것. DBEAVER는 PL/SQL 실행 지원하지 않음.
 * 
 **********************************************************************/


CREATE TABLE TB_POPLTN_CTPRVN -- 인구시도 테이블 
(
	  CTPRVN_CD CHAR(2)				-- 시도코드
	, CTPRVN_NM VARCHAR2(50) 		-- 시도이름
	, STD_YM CHAR(6)				
	, POPLTN_SE_CD VARCHAR2(6)		-- 인구구분코드
	, AGRDE_SE_CD CHAR(3)			-- 연령대구분코드
	, POPLTN_CNT NUMBER(10) NOT NULL -- 인구수
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

-- /////////////// CURSOR DECLARATION ///////////////
-- 인구테이블을 시도기준, 기준년월, 인구구분코드, 연령구분코드별로 인구합게를 조회
CURSOR SELECT_TB_POPLTN IS
SELECT SUBSTR(A.ADSTRD_CD, 1, 2) AS CTPRVN_CD
	, (SELECT L.ADRES_CL_NM
		FROM TB_ADRES_CL L -- 주소분류 테이블에서 시도명을 가져옴
		WHERE L.ADRES_CL_CD = SUBSTR(A.ADSTRD_CD, 1, 2)
			AND L.ADRES_CL_SE_CD = 'ACS001' -- 시도
	  ) AS CTPRVN_NM --시도명
    , A.STD_YM
    , A.POPLTN_SE_CD
    , A.AGRDE_SE_CD
    , SUM(A.POPLTN_CNT) AS POPLTN_CNT
FROM TB_POPLTN A -- 인구테이블
WHERE 1 = 1
GROUP BY SUBSTR(A.ADSTRD_CD, 1, 2), A.STD_YM
		, A.POPLTN_SE_CD
		, A.AGRDE_SE_CD
ORDER BY SUBSTR(A.ADSTRD_CD, 1, 2)
		, A.STD_YM
		, A.POPLTN_SE_CD
		, A.AGRDE_SE_CD
;
-- /////////////// END CURSOR DECLARATION ///////////////

BEGIN -- 실행부 시작
	OPEN SELECT_TB_POPLTN; -- 커서 열기
	
	-- 반복문 시작 전 로그 출력
	DBMS_OUTPUT.PUT_LINE('-----------------------------');
	LOOP -- 반복문 시작
		-- 커서에서 한 행씩 가져옴
		FETCH SELECT_TB_POPLTN INTO
			V_CTPRVN_CD,
			V_CTPRVN_NM,
			V_STD_YM,
			V_POPLTN_SE_CD,
			V_AGRDE_SE_CD,
			V_POPLTN_CNT;
		-- 더이상 가져올 행이 없으면 반복문 종료
		EXIT WHEN SELECT_TB_POPLTN%NOTFOUND;
	
		--로그출력 시작
		DBMS_OUTPUT.PUT_LINE('V_CTPRVN_CD       :' || '[' || V_CTPRVN_CD	|| ']');
		DBMS_OUTPUT.PUT_LINE('V_CTPRVN_NM       :' || '[' || V_CTPRVN_NM	|| ']');
		DBMS_OUTPUT.PUT_LINE('V_STD_YM          :' || '[' || V_STD_YM	    || ']');
		DBMS_OUTPUT.PUT_LINE('V_POPLTN_SE_CD    :' || '[' || V_POPLTN_SE_CD || ']');
		DBMS_OUTPUT.PUT_LINE('V_AGRDE_SE_CD     :' || '[' || V_AGRDE_SE_CD	|| ']');
		DBMS_OUTPUT.PUT_LINE('V_POPLTN_CNT      :' || '[' || V_POPLTN_CNT	|| ']');
		-- 로그출력 종료
	
		IF V_STD_YM = IN_STD_YM THEN -- 기준연월이 입력년월과 같은 경우
			-- TB_POPLTN_CTPRVN 테이블에 INSERT
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
	
	CLOSE SELECT_TB_POPLTN; -- 커서 종료
	
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('-----------------------------');
END SP_INSERT_TB_POPLTN_CTPRVN; -- 실행부 종료
/
/*************************************************************************/

TRUNCATE TABLE TB_POPLTN_CTPRVN;
SET SERVEROUTPUT ON;
EXECUTE SP_INSERT_TB_POPLTN_CTPRVN('202010');

SELECT * FROM TB_POPLTN_CTPRVN;


-----------------------------------------------------------------------
-- 6.8.5 사용자 정의 함수란?  p.394
-- KEYWORD : FUNCTION
--  반드시 1건을 반환한다.
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION F_GET_TK_GFF_CNT
(
    IN_SUBWAY_STATN_NO IN TB_SUBWAY_STATN.SUBWAY_STATN_NO%TYPE  -- arg 1: 지하철 번호
,   IN_STD_YM IN TB_SUBWAY_STATN_TK_GFF.STD_YM%TYPE				-- arg 2: 연월 '202010'
)
RETURN NUMBER IS V_TK_GFF_CNT NUMBER; -- 리턴값 선언 // 승하차인원수 합계

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
              , F_GET_TK_GFF_CNT(A.SUBWAY_STATN_NO, '202010') AS TK_GFF_CNT -- 승하차 인원수 합계
        FROM TB_SUBWAY_STATN A
        WHERE 1=1
            AND A.LN_NM = '2호선'
        ORDER BY TK_GFF_CNT DESC    
    )
WHERE ROWNUM <= 10
;
-----------------------------------------------------------------------
-- 6.8.7	트리거 생성 p.396
-- 
-- 특정 테이블에 INSERT, UPDATE, DELETE를 수행할 때 자동으로 동작
-- 인구 테이블 (TB_POPLTN)에 특정 데이터를 삽입하면 인구시도 (TB_POPLTN_CTPRVN)에 데이터가 입력되도록 트리거 생성.
-----------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRIG_TB_POPLTN_CTPRVN_INSERT
    AFTER INSERT -- INSERT 후에 실행
    ON TB_POPLTN -- 해당 테이블에
    FOR EACH ROW -- 각각의 행을 입력마다
DECLARE -- 변수선언 시작
    V_ADSTRD_CD       TB_POPLTN.ADSTRD_CD%TYPE;    
    V_STD_YM          TB_POPLTN.STD_YM%TYPE;
    V_POPLTN_SE_CD    TB_POPLTN.POPLTN_SE_CD%TYPE;
    V_AGRDE_SE_CD     TB_POPLTN.AGRDE_SE_CD%TYPE;
-- 변수선언 종료
BEGIN
    V_ADSTRD_CD := :NEW.ADSTRD_CD; -- TB_POPLTN에 새로이 INSERT된 ADSTRD_CD 값
    V_STD_YM := :NEW.STD_YM;
    V_POPLTN_SE_CD := :NEW.POPLTN_SE_CD;
    V_AGRDE_SE_CD := :NEW.AGRDE_SE_CD;
    
    -- TB_POPLTN_CTPRVN 테이블에 인구수를 누적 업데이트함.
    UPDATE TB_POPLTN_CTPRVN A
        SET A.POPLTN_CNT = A.POPLTN_CNT + :NEW.POPLTN_CNT
    WHERE A.CTPRVN_CD = SUBSTR(V_ADSTRD_CD, 1, 2)
        AND A.STD_YM = V_STD_YM
        AND A.POPLTN_SE_CD = V_POPLTN_SE_CD
        AND A.AGRDE_SE_CD = V_AGRDE_SE_CD
    ;
    
    -- TB_POPLTN_CTPRVN 테이블에 해당 행이 없다면 신규로 INSERT함.
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
        , (SELECT L.ADRES_CL_NM -- 주소분류 테이블에서 시도명을 가져옴
            FROM TB_ADRES_CL L
            WHERE L.ADRES_CL_CD = SUBSTR(V_ADSTRD_CD, 1,2)
                AND L.ADRES_CL_SE_CD = 'ACS001') -- 시도
        , V_STD_YM
        , V_POPLTN_SE_CD
        , V_AGRDE_SE_CD
        , :NEW.POPLTN_CNT
        );
    END IF;
END;
/

-- 새로운 자료 행 입력 // 트리거 호출
INSERT INTO TB_POPLTN (ADSTRD_CD, STD_YM, POPLTN_SE_CD, AGRDE_SE_CD, POPLTN_CNT)
    VALUES 
    ( '4128157500' -- 경기도 고양시 삼송동
    , '202009' -- 2020년 09월 기준
    , 'F'
    , '030'
    , 2000
    );
-- COMMIT 전에 입력된 자료 체크
SELECT *
FROM TB_POPLTN_CTPRVN
WHERE CTPRVN_CD = '41'
    AND STD_YM = '202009';
    
ROLLBACK; -- 롤백하고나면 인구테이블에 자료가 삭제되면서   인구시도 테이블에 트리거링으로 들어간 자료도 같이 삭제됨.

COMMIT; -- 이번에는 커밋 후에 자료를 체크해본다.

-- 새로운 자료 행 입력 // 트리거 호출
INSERT INTO TB_POPLTN (ADSTRD_CD, STD_YM, POPLTN_SE_CD, AGRDE_SE_CD, POPLTN_CNT)
    VALUES 
    ( '4128158000' -- 경기도 고양시 창릉동
    , '202009' -- 2020년 09월 기준
    , 'F'
    , '030'
    , 2100
    );
COMMIT;

-- 자료체크. 2000 + 2100해서 4100명이 됨.
SELECT *
FROM TB_POPLTN_CTPRVN
WHERE CTPRVN_CD = '41'
    AND STD_YM = '202009';
    
/****************************************************************************************
 *  PROCEDURE 와 TRIGGER의 차이점
 * 
 * 프로시저는 내부에서 COMMIT 혹은 ROLLBACK을 수행한다.
 * 트리거는 트리거를 발생시킨 SQL문이 COMMIT 혹은 ROLLBACK되는지에 따라서 결정됨.
 * 
 * --------------------------------------------------------------------------------------
 *                  PROCEDURE                 |              TRIGGER
 * --------------------------------------------------------------------------------------
 *   생성 |   CREATE PROCEDURE                |   CREATE TRIGGER
 *   실행 |   EXECUTE (EXEC) 				  |   EVENT DRIVEN
 *   반영 |   내부에서 COMMIT / ROLLBACK 수행 |   내부에서 결정되지 않음. CALLER가 결정.
 * --------------------------------------------------------------------------------------
 ****************************************************************************************/

 
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   