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