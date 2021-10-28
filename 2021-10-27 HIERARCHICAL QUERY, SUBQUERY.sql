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
    
    Inline view - FROM
    Scala Subquery - SELECT
    Subquery - WHERE
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
    
   
    