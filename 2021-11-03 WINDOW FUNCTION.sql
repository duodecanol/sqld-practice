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
    RANK() OVER(ORDER BY SAL DESC) SAL_RANK-- 급여 순위를 내림차순으로 
FROM EMP;

SELECT
    ENAME, JOB,
    RANK() OVER (PARTITION BY JOB ORDER BY SAL DESC) SAL_RANK_BY_JOB,
    DEPTNO        -- 급여 순위를 직업별로
FROM EMP C;

/*******************************
    WINDOW_FUNCTION.RANK()
    WINDOW_FUNCTION.DENSE_RANK()
    WINDOW_FUNCTION.ROW_NUMBER()
********************************/
SELECT ENAME, JOB, 
    RANK() OVER(ORDER BY SAL DESC) SAL_RANK-- 동일값은 동순위 처리하고 다음순위가 밀린다.
FROM EMP;
-------------------------------------------------------
SELECT ENAME, JOB, 
    DENSE_RANK() OVER(ORDER BY SAL DESC) SAL_RANK-- 동일값은 동순위처리하고 연속번호 부여한다.
FROM EMP;
-------------------------------------------------------
SELECT ENAME, JOB, 
    ROW_NUMBER() OVER(ORDER BY SAL DESC) SAL_RANK-- 순서대로 행번호를 부여한다.
FROM EMP;
-------------------------------------------------------

SELECT * FROM EMP;
-- 사번, 이름, 급여, 급여 합
SELECT ENAME, SAL, (SELECT SUM(SAL) FROM EMP) SAL_SUM
FROM EMP;
-- 위 쿼리와 완전히 동일한 결과.   // USING SUBQUERY
SELECT ENAME, SAL, SUM(SAL) OVER ()
FROM EMP;
-------------------------------------------------------
-- 사번, 이름, 급여, 급여 합 BY DEPT
SELECT ENAME, SAL, SUM(SAL) OVER (PARTITION BY DEPTNO) SUM_SAL_BY_DEPT
FROM EMP;
-- 위 쿼리와 완전히 동일한 결과.   // USING SUBQUERY
SELECT A.ENAME, A.SAL, 
    (SELECT SUM(B.SAL) FROM EMP B 
        GROUP BY B.DEPTNO HAVING B.DEPTNO=A.DEPTNO) SUM_SAL_BY_DEPT
FROM EMP A
ORDER BY A.DEPTNO;
-------------------------------------------------------
-- 이상한 결과????
SELECT ENAME, SAL, SUM(SAL) OVER (PARTITION BY JOB) SUM_SAL_BY_JOB  -- PARTITION하면 정렬도 됨나?
FROM EMP  -- ORDER BY 문이 가장 마지막에 실행되기 때문에
ORDER BY SAL;  --기껏 해놓은 PARTITION에서 그룹별 정렬해놓은것을 다시 전체정렬한다.
-- 사번, 이름, 급여, 급여 합 BY JOB
SELECT ENAME, SAL, SUM(SAL) OVER (PARTITION BY JOB) SUM_SAL_BY_JOB  -- PARTITION하면 정렬도 됨나?
FROM EMP;
-- 위 쿼리와 완전히 동일한 결과.  // USING SUBQUERY
SELECT A.ENAME, A.SAL, 
    (SELECT SUM(B.SAL) FROM EMP B 
        GROUP BY B.JOB HAVING B.JOB=A.JOB) SUM_SAL_BY_JOB
FROM EMP A
ORDER BY A.JOB;

--부서별 직원들의 연봉이 높은 순서로 정렬 후, 부서별 최초로 나오는 사원의 이름 출력
SELECT 
	ENAME, SAL, DEPTNO,
	MIN(ENAME) OVER (PARTITION BY DEPTNO ORDER BY SAL DESC
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS FIRST
FROM EMP;

SELECT 
	ENAME, SAL, DEPTNO,
	FIRST_VALUE(ENAME) OVER (PARTITION BY DEPTNO ORDER BY SAL DESC) AS FIRST
	-- PARTITION 내에서 최초 행을 가져오는 FIRST_VALUE()
FROM EMP;

SELECT 
	ENAME, SAL, DNAME,
	FIRST_VALUE(ENAME) OVER (PARTITION BY DEPTNO ORDER BY SAL DESC) AS FIRST
FROM EMP NATURAL JOIN DEPT;

--부서별 직원들의 연봉이 높은 순서로 정렬 후, 부서별 마지막으로 나오는 사원의 이름 출력
SELECT 
	ENAME, SAL, DEPTNO,
	LAST_VALUE(ENAME) OVER (PARTITION BY DEPTNO ORDER BY SAL DESC
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS LAST
FROM EMP;

-- 직원들의 번호 정렬
-- 해당 직원의 급여와 이전번호지구언 급여
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
	CURRENT ROW :  현재 행
	[n] PRECEDING : 이전의 n 행
	[n] FOLLOWING : 다음의 n 행
	[UNBOUNDED] PRECEDING : 윈도우 파티션의 1번 행 => n = min(n)
	[UNBOUNDED] FOLLOWING : 윈도우 파티션의 마지막 행 => n = max(n)
	
	ROWS BETWEEN  [] AND []
	
-- EMP 테이블에서 직무, 이름, 급여, 급여누계를 가져온다.
-- 파티션을 직무에 따라 설정, 윈도우절 사용
SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (PARTITION BY JOB ORDER BY SAL
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SAL_ACCU_BY_JOB
FROM EMP;

-- 직무, 이름, 급여, 급여누계[전체에 대해 1행씩 누계]
SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SAL_ACCU
FROM EMP;
SELECT --위와 같은 결과
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		ROWS UNBOUNDED PRECEDING) AS SAL_ACCU
FROM EMP;

-- EMP 테이블에서 직무, 이름, 급여, 급여누계를 가져온다.
-- 직전 1행과 현재행의 합을 출력
SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		ROWS 1 PRECEDING) AS SAL_CUS -- ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
FROM EMP;
-- 현재행과 다음 1행의 합을 출력
SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS SAL_CUS
FROM EMP;


-----------------------------------------------------------------------
-- RANGE 와 ROWS 키워드는 어떻게 다른가?
SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		ROWS 1 PRECEDING) AS SAL_CUS -- ROWS는 물리적인 행의 개수를 대상으로 하는 반면
FROM EMP;

SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		RANGE 200 PRECEDING) AS SAL_CUS  -- RANGE는 값의 범위를 지정한것이다. 물리적으로 앞인지 뒤인지는 중요치않고
FROM EMP;                               -- 그래프에서 CURRENT ROW 값을 기준으로, 설정한 X축 범위 내에 있는 값이 들어잇는 행을 대상으로 함.


SELECT
	JOB, ENAME, SAL, 
	SUM(SAL) OVER (ORDER BY SAL
		RANGE BETWEEN 200 PRECEDING AND 200 FOLLOWING) AS SAL_CUS
FROM EMP;
-----------------------------------------------------------------------
-- 사원번호, 이름, 급여, 집계대상급여를 
--현재행포함해서 직전 2행으로 총 3행으로 설정한 이동평균을 출력한다.
--사원번호를 기준으로 오름차순 정렬
SELECT
	EMPNO, ENAME, SAL,
	ROUND(AVG(SAL) OVER (ORDER BY EMPNO ASC
			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 3) AS MA	
FROM EMP;
-- 현재항하고 직후 2행으로 총 3행 이동평균
SELECT
	EMPNO, ENAME, SAL,
	ROUND(AVG(SAL) OVER (ORDER BY EMPNO ASC
			ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING), 3) AS MA	
FROM EMP;

-----------------------------------------------------------------------
--사원들의 급여기준으로 정렬하고, 본인 급여보다 50~150만큼 차이나는 사원 수를 구한다.
SELECT
	EMPNO, ENAME, SAL,
	COUNT(ENAME) OVER (ORDER BY SAL RANGE BETWEEN 50 PRECEDING AND 150 FOLLOWING) AS AROUND_ME
FROM EMP;

SELECT
	EMPNO, ENAME, SAL,
	 LISTAGG(ENAME) WITHIN GROUP (ORDER BY SAL) OVER (PARTITION BY SAL BETWEEN SAL-50 AND SAL+150) AS AROUND_ME
FROM EMP;

-----------------------------------------------------------------------
--사원들의 급여기준으로 정렬하고, 본인 급여보다 50~150만큼 차이나는 사원 이름들을 구한다.
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
--사원번호, 이름, 급여, 급여기준오름차순으로 맨앞의 값부터 현재항까지 총합
SELECT
	EMPNO, ENAME, SAL,
	SUM(SAL) OVER(ORDER BY SAL ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SAL_ACC
FROM EMP;

/*******************************
    비율 관련 WINDOW_FUNCTION p.204
    [ WINDOW_FUNCTION ] ( [args] ) OVER ( ... )
               CUME_DIST           : 파티션 전체 건수에서 현재 행보다 작거나 같은 건수에 대한 누적 백분율을 조회한다.
               PERCENT_RANK        : 파티션에서 제일 먼저 나온 것을 0으로, 제일 늦게 나온 것을 1로 하여 값이 아닌 행의 순서별 백분율을 조회한다.
               NTILE               : 파티션별로 전체 건수를 ARGUMENT 값으로 N 등분한 결과를 조회한다.
               RATIO_TO_REPORT     : 파티션 내에 전체 SUM(칼럼)에 대한 행 별 칼럼값의 백분율을 소수점까지 조회한다.
********************************/

-- JOB 이 MANAGER인 사원들을 대상으로 전체 급여에서 본인이 차지하는 비율 출력
SELECT 
    ENAME, JOB,
    ROUND(RATIO_TO_REPORT(SAL) OVER (PARTITION BY JOB), 3) * 100 || '%' RATIO
FROM EMP
WHERE JOB = 'MANAGER';

-- 같은 부서 소속사원들의 집합에서 
-- 본인의 급여가 순서상으로 상위 몇% 위치인지 소수점비율로 출력
SELECT
    EMPNO, ENAME, SAL, DEPTNO,
    ROUND(PERCENT_RANK() OVER (PARTITION BY DEPTNO ORDER BY SAL ASC), 5) * 100 || '%' PERCENT_RANK
FROM EMP
;

-- 전체 사원을 급여 내림차순으로 정렬하고 급여를 기준으로 4개의 그룹으로 분류.
SELECT EMPNO, ENAME, SAL, DEPTNO,
    NTILE(4) OVER (ORDER BY SAL DESC) -- 14명을 4개 그룹으로 급여를 기준으로 분류한다. \\ 나누어 떨어지는 12로 3명씩 그룹짓고, 나머지 2를 상위 그룹에 분배한다.  4/4/3/3    
FROM EMP;