/*******************************
    HIERARCHCIAL QUERY - CONNECT BY p.182
********************************/
SELECT * FROM EMP; -- 각 EMP는 MGR 매니저를 하나 갖거나 갖지 않는다.

SELECT MAX(LEVEL) FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR; --MGR에 의해 형성되는 트리의 최대 깊이

SELECT LEVEL, EMPNO, MGR, ENAME
FROM EMP
START WITH MGR IS NULL -- MGR이 NULL인 자는 자신의 관리자가 없으므로 트리의 최상위 (루트노드)로 설정.
CONNECT BY PRIOR EMPNO = MGR; --순방향

SELECT LEVEL, EMPNO, MGR, ENAME
FROM EMP
START WITH MGR IS NULL -- MGR이 NULL인 자는 자신의 관리자가 없으므로 트리의 최상위 (루트노드)로 설정.
CONNECT BY EMPNO = PRIOR MGR; --역방향 // 역방향으로 하면 부모의 부모를 자식으로 설정하는 셈이라 연결되지 않음.
     -- PRIOR 키워드의 좌/우 위치가 중요한 것이 아니라 속성의 상하관계를 따져야 한다.
     -- 순방향 PRIOR EMPNO = MGR
     -- 순방향 EMPNO의 상사는 MGR 이다.

SELECT
    LEVEL,
    LPAD(' ', 4 * (LEVEL - 1)) || EMPNO AS VISUALIZED_LEVEL,
    ENAME,
    (SELECT ENAME FROM EMP WHERE EMPNO = A.MGR) AS SUPERVISOR_NAME,
    CONNECT_BY_ISLEAF    
FROM EMP A
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

SELECT
    LEVEL,
    SYS_CONNECT_BY_PATH(EMPNO, ' -> ') AS CONNECT_PATH, 
    EMPNO, ENAME
FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

LEVEL                   검색 항목의 깊이. 최상위 1
CONNECT_BY_ROOT         가장 최상위 값
CONNECT_BY_ISLEAF       리프 노드인가 아닌가
SYS_CONNECT_BY_PATH     해당 로우의 값의 경로 표시
NOCYCLE                 순환구조 발생지점까지만 표시
CONNECT_BY_ISCYCLE      순환구조 발생지점 표시

SELECT
    EMPNO,    ENAME,    LEVEL,
    CONNECT_BY_ROOT(EMPNO),
    CONNECT_BY_ISLEAF,
    SYS_CONNECT_BY_PATH(EMPNO, ' -> ') AS CONNECT_PATH    
FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

-- EMP 테이블에서 최상위 관리자부터 상위 직원들 순으로 직원번호, 직원이름, 직속상관번호, 레벨 출력, 단 급여가 2000 이하인 사원들만.
SELECT EMPNO, ENAME, MGR, LEVEL
FROM EMP
WHERE SAL <= 2000
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;


/*******************************
    SUBQUERY      p.186
---------------------------------    
        - Inline view    - FROM
        - Scala Subquery - SELECT
        - Subquery       - WHERE
********************************/
SELECT * FROM EMP
    WHERE DEPTNO = (
        SELECT DEPTNO FROM DEPT
            WHERE DEPTNO = 10
    );

SELECT * FROM EMP
    WHERE DEPTNO IN (
        SELECT DEPTNO FROM DEPT         -- SUBQUERY IN WHERE CLAUSE
            WHERE JOB = 'CLERK'
    );

SELECT *
    FROM (SELECT ROWNUM NUM, ENAME FROM EMP) A   -- ILINE VIEW IN FROM CLAUSE
    WHERE NUM < 5;
    
    
--////////////////////// 스캇이 근무하는 부서명을 가져와. //////////////////////////////
SELECT DEPTNO FROM EMP WHERE ENAME = 'SCOTT'; -- FETCH SCOTT'S INFO
SELECT DNAME FROM DEPT 
    WHERE DEPTNO = (
        SELECT DEPTNO FROM EMP WHERE ENAME = 'SCOTT'  -- WHERE CLAUSE 의 SUBQUERY로 가져옴.
    );
    
SELECT DNAME, ENAME FROM EMP NATURAL JOIN DEPT WHERE ENAME = 'SCOTT'; -- APPROACH USING JOIN

/*******************************
    IN ANY ALL EXIST
********************************/

SELECT DEPTNO FROM EMP WHERE SAL >= 3000; -- 10 20
SELECT * FROM EMP;

SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE DEPTNO IN (SELECT DEPTNO FROM EMP WHERE SAL >= 3000);

SELECT DEPTNO FROM EMP WHERE SAL >= 3000;

SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE DEPTNO = ANY (SELECT DEPTNO FROM EMP WHERE SAL >= 3000);

SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE DEPTNO >= ANY (SELECT DEPTNO FROM EMP WHERE SAL >= 3000); -- 30, 20, 10

SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE DEPTNO < ANY (SELECT DEPTNO FROM EMP WHERE SAL >= 3000); -- 10

SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE DEPTNO = ALL (SELECT DEPTNO FROM EMP WHERE SAL >= 3000);

-- EXIST ==> TRUE OR FALSE
SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE EXISTS (SELECT DEPTNO FROM EMP WHERE SAL >= 3000);

SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE EXISTS (SELECT DEPTNO FROM EMP WHERE SAL >= 99999999);

-- 직무가 CLERK인 사원과 동일부서에서 근무하는 사번, 이름, 입사일
SELECT EMPNO, ENAME, HIREDATE
FROM EMP WHERE DEPTNO IN (SELECT DEPTNO FROM EMP WHERE JOB='CLERK'); --10 20 30

--모든 부서별 급여 평균보다 더 많이 받는 사람의 || 사번 이름 급여
SELECT EMPNO, ENAME, SAL FROM EMP
WHERE SAL >= ALL (SELECT AVG(SAL) FROM EMP GROUP BY DEPTNO);

-- 어느 부서별 최저 급여보다 더 많이 받는 사람의 || 사번 이름 급여
SELECT EMPNO, ENAME, SAL FROM EMP
WHERE SAL > ANY (SELECT MIN(SAL) FROM EMP GROUP BY DEPTNO);

--- DALAS 근무하는 어떤 사람들에 입사일보다 ㅏ빨리 입사한 사원ㄷㄹ의

SELECT EMPNO, ENAME, SAL FROM EMP
WHERE HIREDATE < ANY (SELECT HIREDATE FROM EMP NATURAL JOIN  DEPT WHERE LOC = 'DALLAS');

--- 사원번호원 산원이름. 단 , =급여 3000 이상인 사원존재하는 겨웅에만
SELECT *
FROM EMP
WHERE EXISTS (SELECT * FROM EMP WHERE SAL >= 3000);

/*******************************
    연관 서브쿼리
********************************/
--자신이 속한 부서의 평균 급여보다 더 많은 급여를 받는 사원의 사번 이름 급여

SELECT A.EMPNO, A.ENAME, A.SAL FROM EMP A
WHERE A.SAL > ( SELECT AVG(B.SAL) FROM EMP B WHERE B.DEPTNO = A.DEPTNO GROUP BY B.DEPTNO );

SELECT A.EMPNO, A.ENAME, A.SAL FROM EMP A
WHERE A.SAL > ( SELECT AVG(B.SAL) FROM EMP B GROUP BY B.DEPTNO HAVING MAX(B.DEPTNO)=A.DEPTNO );

/*******************************
    Scala Subquery      p.134
        - The query must return one row and one col.
        - Use in project operation
********************************/

SELECT DEPTNO, (SELECT SUM(SAL) FROM EMP) -- SCALAR SUBQUERY <-- [ SELECT ]
FROM EMP;

SELECT DEPTNO, SUM(SAL)
FROM EMP
GROUP BY DEPTNO;

SELECT DEPTNO, SUM(SAL)
FROM EMP
GROUP BY (SELECT DEPTNO FROM EMP); ---!!!!!! GROUP BY 에는 SUBQUERY 사용 불가 !!!!!!!!!!!!


SELECT *
FROM (SELECT ROWNUM, EMPNO, ENAME, DEPTNO FROM EMP ORDER BY DEPTNO); -- INLINE VIEW <--- [ FROM ] 
-- ㅠㅠㅠ ORDER BY와 ROWNUM을 같이 하고 싶다!

-- ////////////  방법 1.
SELECT ROWNUM, A.*
FROM (SELECT EMPNO, ENAME, DEPTNO FROM EMP ORDER BY DEPTNO) A;

-- ////////////  방법 2.
SELECT ROW_NUMBER() OVER (ORDER BY DEPTNO) RNUM, EMPNO, ENAME, DEPTNO
FROM EMP
ORDER BY DEPTNO;

SELECT ROW_NUMBER() OVER (ORDER BY EMPNO) RNUM, 
    EMPNO, ENAME, DEPTNO -- ROW_NUMBER 함수는 ROW 정렬과 데이터정렬을 달리 할 수 있다.
FROM EMP
ORDER BY DEPTNO;  -- https://gent.tistory.com/170

SELECT ROW_NUMBER() OVER (PARTITION BY JOB ORDER BY JOB, DEPTNO) RNUM, 
    JOB, EMPNO, ENAME, DEPTNO
FROM EMP NATURAL JOIN DEPT
ORDER BY JOB, DEPTNO;

SELECT ROW_NUMBER() OVER (PARTITION BY MGR ORDER BY MGR) RNUM, 
    JOB, EMPNO, ENAME, DEPTNO, MGR
FROM EMP NATURAL JOIN DEPT
ORDER BY MGR, EMPNO;

-- ////////////////  실험. ORDER BY 문에도 SUBQUERY가 가능한가?
-- ////////////////  가능하다. 다만 정렬이 이상해진다? 랜덤?

SELECT * FROM EMP;

SELECT * FROM EMP
ORDER BY (SELECT EMPNO FROM EMP WHERE ENAME='SCOTT'); -- 스칼라 값  77881

-- ////////////////  -- ////////////////  -- ////////////////  -- ////////////////  
-- FORD와 같은 부서에 근무하는 사원들의 사번, 이름, 급여 , 부서번호를 FETCH.
-- SUBQUERY MUST BE USED.
SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE DEPTNO = (SELECT DEPTNO FROM EMP WHERE ENAME = 'FORD');

-- ALLEN과 같은 직속상관을 가진 사원들의 사번, 이름, 직속상관번호 
SELECT EMPNO, ENAME, MGR
FROM EMP
WHERE MGR = (SELECT MGR FROM EMP WHERE ENAME = 'ALLEN');

-- 시카고 지역에서 근무하는 사원들중 블레이크가 직속상관인 사원들 -=> 사번, 이름, 직무
SELECT EMPNO, ENAME, JOB,                                               -- CORRELATED QUERY
    (SELECT ENAME FROM EMP WHERE EMPNO = A.MGR) AS SUPERVISOR, --===={{{{  SUBQUERY 내에서 MAIN QUERY 내의 칼럼을 사용하는 것
    B.LOC
FROM EMP A JOIN DEPT B ON (A.DEPTNO = B.DEPTNO)
WHERE 
    LOC = 'CHICAGO'
    AND MGR = (SELECT EMPNO FROM EMP WHERE ENAME = 'BLAKE')
ORDER BY EMPNO    ;

-- 두 쿼리의 차이는 무엇인가?
select sal, (select avg(sal) from emp) from emp;

select sal, avg(sal) from emp;

select sal, (select avg(sal) from emp where 1=0) from emp;
select sal, (select avg(sal) from emp where 1=1) from emp;

-- 급여가 전 직원 평균급여보다 높은 사원 <- 사번, 이름, 급여
SELECT EMPNO, ENAME, SAL FROM EMP WHERE SAL > (SELECT AVG(SAL) FROM EMP);

-- 가상의 테이블을 설정하여 사원정보 테이블의 4번째 사원이름 조회
SELECT
    * 
FROM (
    SELECT ROW_NUMBER() OVER(ORDER BY ENAME) R, ENAME FROM EMP ORDER BY ENAME
    )
WHERE R = 4;

--https://docs.oracle.com/database/121/DWHSG/analysis.htm#DWHSG9191
SELECT ROW_NUMBER() OVER(ORDER BY ENAME) R, ENAME FROM EMP 
ORDER BY ENAME
FETCH FIRST 5 ROWS ONLY;
OFFSET 2 ROWS FETCH FIRST 5 ROWS ONLY;

-- 사원의 편균 급여에서 급여가 가까운 순서대로 오름차순으로 정렬하여 사원의 이름 급여 전사원평균급여, 급여차이값
SELECT 
    ABS((SELECT ROUND(AVG(SAL), 3) FROM EMP) - E.SAL) DIST_FROM_AVG_SAL, 
    (SELECT ROUND(AVG(SAL), 3) FROM EMP) AVG_SAL, 
    E.SAL, E.ENAME    
FROM EMP E
ORDER BY DIST_FROM_AVG_SAL;
