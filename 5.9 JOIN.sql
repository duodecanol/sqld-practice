/**********************************************************************
 * 5.9.2	2개 테이블 조인
 **********************************************************************/

SELECT * FROM TB_SUBWAY_STATN;			--지하철 역

SELECT * FROM TB_SUBWAY_STATN_TK_GFF;   -- 지하철역 승하차정보


--강남역을 기준으로 2020년 10월 한달 동안 출근시간대 8시 ~9시 이 역에서 승하차한 인원 수 


SELECT SUBWAY_STATN_NO, STATN_NM FROM TB_SUBWAY_STATN WHERE STATN_NM LIKE '강남%';

SELECT 
	A.SUBWAY_STATN_NO,
	A.LN_NM,
	A.STATN_NM,
	B.BEGIN_TIME, B.END_TIME,
	CASE WHEN B.TK_GFF_SE_CD = 'TGS001' THEN '승차'
		 WHEN B.TK_GFF_SE_CD = 'TGS002' THEN '하차'
	 END TK_GFF_SE_NM,
	B.TK_GFF_CNT
FROM TB_SUBWAY_STATN A, TB_SUBWAY_STATN_TK_GFF B
WHERE A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
	AND A.SUBWAY_STATN_NO = '000032' -- 2호선 강남
	AND B.STD_YM = '202010'
	AND B.BEGIN_TIME = '0800'
	AND B.END_TIME = '0900';
	
/**********************************************************************
 * 5.9.3	3개 테이블 조인
 **********************************************************************/
SELECT * FROM TB_TK_GFF_SE; --승하차구분코드

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
 * 5.9.4	4개 테이블 조인
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
	AND D.ADSTRD_NM LIKE '%경기도%고양시%덕양구%삼송%'
ORDER BY A.POPLTN_CNT DESC;

/**********************************************************************
 * 5.10.1 각 지역별 (시/도) 스타벅스 커피 매장 수 구하기
 **********************************************************************/
SELECT
	CTPRVN_CD, CMPNM_NM, BHF_NM, LNM_ADRES, ADSTRD_CD
FROM TB_BSSH
WHERE (CMPNM_NM LIKE '%스타벅스%'
		OR 
		UPPER(CMPNM_NM) LIKE '%STAR%BUCKS%');

SELECT * FROM TB_ADRES_CL;

SELECT
	A.CTPRVN_CD, 
	B.ADRES_CL_NM,
	COUNT(*) AS CNT
FROM TB_BSSH A, TB_ADRES_CL B
WHERE (CMPNM_NM LIKE '%스타벅스%'
		OR 
		UPPER(CMPNM_NM) LIKE '%STAR%BUCKS%')
	AND A.CTPRVN_CD = B.ADRES_CL_CD
	AND B.ADRES_CL_SE_CD = 'ACS001' -- 시도 기준
GROUP BY A.CTPRVN_CD, B.ADRES_CL_NM
ORDER BY CNT DESC
;

/**********************************************************************
 * 5.10.2	출근시간대 하차인원이 가장 많은 순으로 조회하기    p.
 **********************************************************************/

WITH RES AS (
	SELECT
		A.SUBWAY_STATN_NO AS 역번호,
		B.LN_NM,
		B.STATN_NM,
		A.BEGIN_TIME || ' ~ ' || A.END_TIME AS "탑승시간",
		C.TK_GFF_SE_NM AS "승하차",
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
 * 5.10.3	연령대별 남성/여성 인구수 구하기	p.
 **********************************************************************/

SELECT *  FROM TB_POPLTN A;

WITH SDL AS (
	SELECT AGRDE_SE_CD, AGRDE_SE_NM FROM TB_AGRDE_SE
)
SELECT A.AGRDE_SE_CD, (SELECT SDL.AGRDE_SE_NM FROM SDL WHERE SDL.AGRDE_SE_CD = A.AGRDE_SE_CD) AS 연령대설명,
	SUM(DECODE(A.POPLTN_SE_CD, 'M', A.POPLTN_CNT, 0)) AS MALE_POPLTN_CNT,
	SUM(DECODE(A.POPLTN_SE_CD, 'F', A.POPLTN_CNT, 0)) AS FEMALE_POPLTN_CNT,
	SUM(A.POPLTN_CNT) AS TOTAL
FROM TB_POPLTN A
GROUP BY A.AGRDE_SE_CD
ORDER BY A.AGRDE_SE_CD;

/**********************************************************************
 * 6.1.5	INNER JOIN	p.290
 **********************************************************************/

-- 하나의 지하철역은 여러 개의 승하차 정보를 가진다.
-- 지하철역 1호선 서울역 기준 08시 ~ 09시 승하차인원 조회

SELECT A.SUBWAY_STATN_NO,
	   A.LN_NM,
	   A.STATN_NM,
	   B.BEGIN_TIME,
	   B.END_TIME,
	   CASE WHEN B.TK_GFF_SE_CD = 'TGS001' THEN '승차'
	   		WHEN B.TK_GFF_SE_CD = 'TGS002' THEN '하차'
	   		END AS TK_GFF_SE_NM,
	   B.TK_GFF_CNT	
FROM TB_SUBWAY_STATN A, TB_SUBWAY_STATN_TK_GFF B
WHERE   A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
	AND A.SUBWAY_STATN_NO = '000001' -- 1호선 서울역
	AND B.STD_YM = '202010'
	AND B.BEGIN_TIME = '0800'
	AND B.END_TIME = '0900'
ORDER BY B.TK_GFF_CNT DESC;
-- 1호선 서울역은 출근시간대에 승차인원보다 하차인원이 약 3배 많다.

/**********************************************************************
 * 6.1.6    NATURAL JOIN    p.291
 **********************************************************************/

-- NATURAL JOIN은 두 테이블에서 컬럼명이 같은 속성을 하나 이상 이용해 연결한다.
-- 조건절 없이 자동으로 같은이름의 속성을 모두 찾아서 연결해버린다.
-----------------------------------------------------------------------

-- 실습용 테이블 생성
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

INSERT INTO TT_EMP_616 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E001', '이경오', 'D001');
INSERT INTO TT_EMP_616 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E002', '이수지', 'D001');
INSERT INTO TT_EMP_616 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E003', '김영업', 'D002');
INSERT INTO TT_EMP_616 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E004', '박영업', 'D002');
INSERT INTO TT_EMP_616 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E005', '최개발', 'D003');
INSERT INTO TT_EMP_616 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E006', '정개발', 'D003');

ALTER TABLE TT_EMP_616
ADD CONSTRAINT FK_TT_EMP_616 FOREIGN KEY (DEPT_CD)
REFERENCES TT_DEPT_616 (DEPT_CD);


TRUNCATE TABLE TT_EMP_616;
SELECT * FROM TT_DEPT_616;
SELECT * FROM TT_EMP_616;

-----------------------------------------------------------------------
-- NATURAL JOIN 실습

SELECT *
FROM TT_DEPT_616 A NATURAL JOIN TT_EMP_616 B
;

SELECT DEPT_CD -- 자동으로 찾은 조인 대상 칼럼에는 TABLE ALIAS 사용 안된다.
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
-- USING 절

/*NATURAL JOIN을 하면 복수의 조인칼럼이 자동으로 매칭되므로
조인 칼럼을 지정하고 싶은 경우에는 USING CLAUS 를 사용*/

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
GROUP BY A.STATN_NM, C.TK_GFF_SE_NM HAVING MAX(A.LN_NM) IN ('경의선', '중앙선')
ORDER BY A.STATN_NM, POPULATION
;

SELECT DISTINCT BEGIN_TIME, END_TIME FROM TB_SUBWAY_STATN_TK_GFF;
SELECT * FROM TB_SUBWAY_STATN;
SELECT * FROM TB_TK_GFF_SE;

-----------------------------------------------------------------------
-- ON 절

SELECT A.SUBWAY_STATN_NO,
	   A.LN_NM,
	   A.STATN_NM,
	   B.BEGIN_TIME,
	   B.END_TIME,
	   CASE WHEN B.TK_GFF_SE_CD = 'TGS001' THEN '승차'
	   		WHEN B.TK_GFF_SE_CD = 'TGS002' THEN '하차'
	   		END AS TK_GFF_SE_NM,
	   B.TK_GFF_CNT	
FROM TB_SUBWAY_STATN A INNER JOIN TB_SUBWAY_STATN_TK_GFF B
	ON A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
WHERE   A.SUBWAY_STATN_NO = '000001' -- 1호선 서울역
	AND B.STD_YM = '202010'
	AND B.BEGIN_TIME = '0800'
	AND B.END_TIME = '0900'
ORDER BY B.TK_GFF_CNT DESC;

-----------------------------------------------------------------------
-- 3개 테이블 조인 
-- 출근시간 강남역 승하차 인원수
SELECT A.SUBWAY_STATN_NO
	 , A.LN_NM
	 , A.STATN_NM
	 , B.BEGIN_TIME
	 , B.END_TIME
	 , C.TK_GFF_SE_NM
	 , B.TK_GFF_CNT
FROM TB_SUBWAY_STATN A, TB_SUBWAY_STATN_TK_GFF B, TB_TK_GFF_SE C
WHERE   A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO -- AB 조인조건
	AND B.TK_GFF_SE_CD = C.TK_GFF_SE_CD       -- BC 조인조건
	AND A.SUBWAY_STATN_NO = '000032'
	AND B.STD_YM = '202010'
	AND B.BEGIN_TIME = '0800'
	AND B.END_TIME = '0900'
;

-- ANSI 표준 방식을 이용한 조인
SELECT A.SUBWAY_STATN_NO 
	 , A.LN_NM
	 , A.STATN_NM
	 , B.BEGIN_TIME
	 , B.END_TIME
	 , C.TK_GFF_SE_NM
	 , B.TK_GFF_CNT
FROM TB_SUBWAY_STATN A INNER JOIN -- ANSI 표준 방식을 이용한 조인
	 TB_SUBWAY_STATN_TK_GFF B ON (A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO) INNER JOIN -- AB 조인조건
	 TB_TK_GFF_SE C           ON (B.TK_GFF_SE_CD = C.TK_GFF_SE_CD) -- BC 조인조건
WHERE   A.SUBWAY_STATN_NO = '000032'
	AND B.STD_YM = '202010'
	AND B.BEGIN_TIME = '0800'
	AND B.END_TIME = '0900'
;

-----------------------------------------------------------------------
-- OUTER JOIN

-- 실습용 테이블 생성
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

INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E001', '이경오', 'D001');
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E002', '이수지', 'D001');
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E003', '김영업', 'D002');
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E004', '박영업', 'D002');
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E005', '최개발', 'D003');
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E006', '정개발', 'D003');
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E007', '석신입', NULL);
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E008', '차인턴', NULL);
INSERT INTO TT_EMP_6110 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E009', '강회장', 'D000');

ALTER TABLE TT_EMP_6110
ADD CONSTRAINT FK_TT_EMP_6110 FOREIGN KEY (DEPT_CD)
REFERENCES TT_DEPT_6110 (DEPT_CD);

ALTER TABLE TT_EMP_6110
DROP CONSTRAINT FK_TT_EMP_6110;

SELECT * FROM TT_EMP_6110;
UPDATE TT_EMP_6110 SET DEPT_CD = 'D000' WHERE EMP_NM = '강회장';

-----------------------------------------------------------------------
-- 6.1.11    LEFT OUTER JOIN    p.301

SELECT * FROM TT_DEPT_6110;
SELECT * FROM TT_EMP_6110;

SELECT *
FROM TT_DEPT_6110 A, TT_EMP_6110 B
WHERE A.DEPT_CD = B.DEPT_CD (+)   --- ORACLE 방식 LEFT OUTER JOIN
ORDER BY A.DEPT_CD;

SELECT *
FROM TT_DEPT_6110 A LEFT OUTER JOIN TT_EMP_6110 B
	ON (A.DEPT_CD = B.DEPT_CD)     --- ANSI 방식 LEFT OUTER JOIN
ORDER BY A.DEPT_CD;

-----------------------------------------------------------------------
-- 6.1.12    RIGHT OUTER JOIN    p.303

SELECT *
FROM TT_DEPT_6110 A, TT_EMP_6110 B
WHERE A.DEPT_CD (+) = B.DEPT_CD    --- ORACLE 방식 RIGHT OUTER JOIN
ORDER BY A.DEPT_CD;

SELECT *
FROM TT_DEPT_6110 A RIGHT OUTER JOIN TT_EMP_6110 B
	ON (A.DEPT_CD = B.DEPT_CD)     --- ANSI 방식 RIGHT OUTER JOIN
ORDER BY A.DEPT_CD;

-----------------------------------------------------------------------
-- 6.1.13    FULL OUTER JOIN    p.305

FULL OUTER JOIN = INNER JOIN + LEFT AND RIGHT OUTER JOIN
실무에서 데이터 검증 작업에 자주 쓰임
오라클 방식 없음.  ANSI 표준 방식만 존재.

SELECT *
FROM TT_DEPT_6110 A FULL OUTER JOIN TT_EMP_6110 B
	ON (A.DEPT_CD = B.DEPT_CD)     --- ANSI 방식 FULL OUTER JOIN
ORDER BY A.DEPT_CD;

-----------------------------------------------------------------------
-- 6.1.14    CROSS JOIN    p.306

2개의 테이블을 FROM 절에 기재하고 아무런 조인 조건도 걸지 않으면 CROSS JOIN 된다.
CROSS JOIN == CARTESIAN PRODUCT  레코드 개수  n * m 

SELECT ROWNUM AS RNUM, A.*, B.*
FROM TT_DEPT_6110 A, TT_EMP_6110 B -- DEPT가 5 튜플, EMP가 9 튜플
-- 조인 조건이 없이 테이블 복수만 나열하면 CROSS JOIN
ORDER BY RNUM;

SELECT ROWNUM AS RNUM, A.*, B.*
FROM TT_DEPT_6110 A CROSS JOIN TT_EMP_6110 B -- ANSI STANDARD
ORDER BY RNUM;

-----------------------------------------------------------------------
--
-- CROSS JOIN은 특정 테이블의 데이터를 복제할 때 많이 사용한다.
-----------------------------------------------------------------------
SELECT * FROM TB_INDUTY_CL_SE; -- 대중소

-- 복제용 임시테이블 생성
CREATE TABLE TT_COPY_3
(
  COPY_NUM NUMBER PRIMARY KEY  
);
INSERT INTO TT_COPY_3 (COPY_NUM) VALUES (1);
INSERT INTO TT_COPY_3 (COPY_NUM) VALUES (2);
INSERT INTO TT_COPY_3 (COPY_NUM) VALUES (3);
SELECT * FROM TT_COPY_3;

--CROSS JOIN을 이용한 데이터 복제
SELECT *
FROM TB_INDUTY_CL_SE A CROSS JOIN TT_COPY_3 B -- 대중소 / 대중소 / 대중소
ORDER BY B.COPY_NUM;



/**********************************************************************
 * 6.2    집합연산자    p.310
 **********************************************************************/

UNION, UNION ALL, INTERSECT, MINUS

UNION - 여러개 쿼리문 결과 합집합
	  - 중복이 제거됨
	  - 정렬이 발생할 수 있음
UNION ALL - 여러개 쿼리문 결과 합집합
		  - 중복행도 그대로 출력
		  - 정렬하지 않음
INTERSECT - 여러개 쿼리문 결과 교집합
		  - 중복이 제거됨
MINUS     - 위 쿼리 결과에서 아래 쿼리 결과를 뺌

-----------------------------------------------------------------------
-- 6.2.2    UNION, UNION ALL

SELECT INDUTY_CL_CD AS INDST_CODE
FROM TB_INDUTY_CL A
WHERE   INDUTY_CL_SE_CD = 'ICS001' -- 대분류만
	AND INDUTY_CL_CD = 'Q'   -- 요식업   // 대분류라서 하나만 나옴
UNION
SELECT UPPER_INDUTY_CL_CD AS UPPER_INDST_CODE
FROM TB_INDUTY_CL
WHERE   INDUTY_CL_SE_CD = 'ICS002' -- 중분류만
	AND INDUTY_CL_CD LIKE 'Q%'    -- 커피점/카페      // 중분류라 복수개 14개 나옴.
; -- 중복이 모두 제거되고 1개만 나옴.

SELECT INDUTY_CL_CD AS INDST_CODE
FROM TB_INDUTY_CL A
WHERE   INDUTY_CL_SE_CD = 'ICS001' -- 대분류만
	AND INDUTY_CL_CD = 'Q'   -- 요식업   // 대분류라서 하나만 나옴
UNION ALL
SELECT UPPER_INDUTY_CL_CD AS UPPER_INDST_CODE
FROM TB_INDUTY_CL
WHERE   INDUTY_CL_SE_CD = 'ICS002' -- 중분류만
	AND INDUTY_CL_CD LIKE 'Q%'    -- 커피점/카페      // 중분류라 복수개 14개 나옴.
; -- 중복이 그대로 유지되고 합쳐져서 15개 나옴.

-----------------------------------------------------------------------
-- 6.2.4    UNION, UNION ALL 의 결과집합

UNION 에서 정렬 수행의 가능성이 있으나,  정렬을 보장하기 위해서는 반드시 ORDER BY 절을 사용해야 한다.
UNION/UNION ALL 연산시 ORDER BY 절에 칼럼에는 ALIAS 사용할 수 없다.

SELECT INDUTY_CL_CD, INDUTY_CL_NM
FROM TB_INDUTY_CL A
WHERE   INDUTY_CL_SE_CD = 'ICS002' -- 중분류만
	AND INDUTY_CL_CD LIKE 'N%'   ---관광/여가/오락
UNION ALL 
SELECT INDUTY_CL_CD AS 업종분류코드, INDUTY_CL_NM AS 업종분류명
FROM TB_INDUTY_CL B
WHERE   INDUTY_CL_SE_CD = 'ICS002' -- 중분류만
	AND INDUTY_CL_CD LIKE 'O%'   ---숙박
ORDER BY INDUTY_CL_CD
;

SELECT INDUTY_CL_CD AS 업종분류코드, INDUTY_CL_NM AS 업종분류명 -- HEADER 값은 위의 쿼리문 결과에 따라간다.
FROM TB_INDUTY_CL A
WHERE   INDUTY_CL_SE_CD = 'ICS002' -- 중분류만
	AND INDUTY_CL_CD LIKE 'O%'   ---숙박
UNION ALL 
SELECT INDUTY_CL_CD, INDUTY_CL_NM
FROM TB_INDUTY_CL B
WHERE   INDUTY_CL_SE_CD = 'ICS002' -- 중분류만
	AND INDUTY_CL_CD LIKE 'N%'   ---관광/여가/오락
ORDER BY 업종분류코드            -- ORDER BY 절에 쓸 컬럼명도 HEADER에 맞춰준다.
;