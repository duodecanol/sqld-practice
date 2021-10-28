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
	COUNT(*) AS "전체상가수",
	MAX(LO) AS "최대경도", MIN(LO) AS "최소경도",
	MAX(LA) AS "최대위도", MIN(LA) AS "최소위도"
FROM TB_BSSH;


/**********************************************************************
 * EMPTY SET AND MAX()
 **********************************************************************/
SELECT *
FROM TB_SUBWAY_STATN A
WHERE A.STATN_NM = '평양역'; -- 공집합 리턴

SELECT
	MAX(A.SUBWAY_STATN_NO), -- MAX 함수는 공집합이라도 NULL을 포함한 1행은 반환한다.
	MAX(A.LN_NM),
	MAX(A.STATN_NM)
FROM TB_SUBWAY_STATN A
WHERE A.STATN_NM = '평양역';

SELECT
	NVL(MAX(A.SUBWAY_STATN_NO), '지하철역없음') AS SUBWAY_STATN_NO, -- MAX의 NULL값을 이용해서 공집합일 경우 출력할 메시지 행을 구성
	NVL(MAX(A.LN_NM), '노선명없음') AS LN_NM,
	NVL(MAX(A.STATN_NM), '역명없음') AS STATN_NM
FROM TB_SUBWAY_STATN A
WHERE A.STATN_NM = '평양역';

/**********************************************************************
 * 5.7.6 GROUP BY
 **********************************************************************/
--인구 테이블에서 인구구분코드별 인구수 컬럼의 합계를 구하라.

SELECT * FROM TB_POPLTN;
SELECT DISTINCT STD_YM FROM TB_POPLTN;

SELECT
	DECODE(POPLTN_SE_CD, 'M', '남성', 'F', '여성', 'T', '전체', '?') AS 인구구분,
	SUM(POPLTN_CNT)
FROM TB_POPLTN
GROUP BY POPLTN_SE_CD;

SELECT
	POPLTN_SE_CD,
	AGRDE_SE_CD,
	SUM(POPLTN_CNT) AS "인구수합계"
FROM TB_POPLTN
GROUP BY POPLTN_SE_CD, AGRDE_SE_CD
	HAVING SUM(POPLTN_CNT) < 1000000	
ORDER BY 인구수합계;


SELECT
	SUBWAY_STATN_NO,
	"승차인원수합계"
	"하차인원수합계"
	"출근시간대승차인원수합계"	"출근시간대하차인원수합계"
	"퇴근시간대승차인원수합계"	"퇴근시간대하차인원수합계"
	"승하차인원수합계"
FROM TB_SUBWAY_STATN_TK_GFF
WHERE STD_YM = '202010';


SELECT
	(SELECT STATN_NM FROM TB_SUBWAY_STATN T WHERE T.SUBWAY_STATN_NO = A.SUBWAY_STATN_NO) AS "STATION",
	SUM(CASE
			WHEN TK_GFF_SE_CD = 'TGS001'
			THEN TK_GFF_CNT
			ELSE 0 
		END) AS "승차인원수합계",
	SUM(CASE
			WHEN TK_GFF_SE_CD = 'TGS002'
			THEN TK_GFF_CNT
			ELSE 0 
		END) AS "하차인원수합계",
	SUM(CASE
			WHEN	BEGIN_TIME = '0800'
			AND		END_TIME = '0900'
			AND 	TK_GFF_SE_CD = 'TGS001'
			THEN 	TK_GFF_CNT
			ELSE 	0
		END) AS "출근시간대승차인원수합계",
	SUM(CASE
			WHEN	BEGIN_TIME = '0800'
			AND		END_TIME = '0900'
			AND 	TK_GFF_SE_CD = 'TGS002'
			THEN 	TK_GFF_CNT
			ELSE 	0
		END) AS "출근시간대하차인원수합계",
	SUM(CASE
			WHEN	BEGIN_TIME = '1800'
			AND		END_TIME = '1900'
			AND 	TK_GFF_SE_CD = 'TGS001'
			THEN 	TK_GFF_CNT
			ELSE 	0
		END) AS "퇴근시간대승차인원수합계",
	SUM(CASE
			WHEN	BEGIN_TIME = '1800'
			AND		END_TIME = '1900'
			AND 	TK_GFF_SE_CD = 'TGS002'
			THEN 	TK_GFF_CNT
			ELSE 	0
		END) AS "퇴근시간대하차인원수합계",
	SUM(TK_GFF_CNT) AS "승하차인원수합계"
FROM TB_SUBWAY_STATN_TK_GFF A
WHERE STD_YM = '202010'
GROUP BY SUBWAY_STATN_NO
	HAVING SUM(CASE WHEN TK_GFF_SE_CD = 'TGS001'
					THEN TK_GFF_CNT ELSE 0 END) >= 1000000
	OR 	   SUM(CASE WHEN TK_GFF_SE_CD = 'TGS002'
					THEN TK_GFF_CNT ELSE 0 END) >= 1000000;

/**********************************************************************
 * 5.7.9 집계 함수와 NULL
 **********************************************************************/
--테스트 테이블 생성
CREATE TABLE TB_AGG_NULL_TEST (NUM NUMBER(15, 2));

INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES(NULL);
INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES(10);
INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES(20);
INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES(30);
INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES(40);
COMMIT;
-- 집계 함수 이용
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

-- NULL의 정렬
-- 오라클은 ORDER BY 절의 칼럼의 값이 NULL일때 가장 큰 값이라고 인식한다.
SELECT
	INDUTY_CL_CD,
	INDUTY_CL_NM,
	INDUTY_CL_SE_CD,
	UPPER_INDUTY_CL_CD
FROM TB_INDUTY_CL A
WHERE INDUTY_CL_CD LIKE 'Q%'
	AND INDUTY_CL_NM LIKE '%음식%'
ORDER BY UPPER_INDUTY_CL_CD DESC;

-- SELECT 문의 실행 순서
FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY

-- PROJECTION 대상이 아닌 컬럼으로도 정렬이 가능하다.
SELECT
	SUBWAY_STATN_NO,
	LN_NM
FROM TB_SUBWAY_STATN
WHERE LN_NM LIKE '9%' ORDER BY STATN_NM;

SELECT
	SUBWAY_STATN_NO,
	LN_NM, STATN_NM -- 확인 
FROM TB_SUBWAY_STATN
WHERE LN_NM LIKE '9%' ORDER BY STATN_NM;

-- GROUP BY한 경우에는 PROJECTION 대상 ATTR만을 정렬에 사용할수 있다.
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
ORDER BY POPLTN_SE_CD DESC; -- 오류가 납니다.

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

