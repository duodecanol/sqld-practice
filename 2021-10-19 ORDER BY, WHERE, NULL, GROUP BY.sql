--ORDER BY
SELECT * FROM EMP;

SELECT * FROM EMP ORDER BY ENAME DESC;
SELECT * FROM EMP ORDER BY DEPTNO;
SELECT * FROM EMP ORDER BY DEPTNO, SAL;
SELECT * FROM EMP ORDER BY DEPTNO, SAL, EMPNO;
SELECT * FROM EMP ORDER BY DEPTNO, SAL DESC, EMPNO;

--WHERE  ----------------------
SELECT * FROM EMP WHERE SAL > 2000;
SELECT ENAME, JOB FROM EMP WHERE SAL > 2000;

--부서번호가 20번이 아닌 행만 보고 싶다
SELECT * FROM EMP WHERE DEPTNO != 20;
SELECT * FROM EMP WHERE DEPTNO ^= 20;
SELECT * FROM EMP WHERE NOT DEPTNO = 20; 

SELECT ENAME, JOB, DEPTNO FROM EMP WHERE DEPTNO !=20;

--1982년 이후 입사자 검색
SELECT * FROM EMP WHERE HIREDATE >= '1982-01-01';
SELECT * FROM EMP WHERE HIREDATE >= '1982/01/01';
SELECT ENAME, HIREDATE FROM EMP WHERE HIREDATE >= '1982-01-01';

--이름이 SCOTT인 사람 찾기
SELECT * FROM EMP WHERE ENAME = 'SCOTT';
SELECT * FROM EMP WHERE ENAME = 'scott'; -- Case sensitive by default

SELECT * FROM EMP WHERE LOWER(ENAME) = 'scott';
SELECT * FROM EMP WHERE UPPER(ENAME) = 'SCOTT';
SELECT * FROM EMP WHERE REGEXP_LIKE (ENAME, 'scott', 'im');
--'i' specifies case-insensitive matching.
--'c' specifies case-sensitive matching.
--'n' allows the period (.), which is the match-any-character wildcard character, to match the newline character. If you omit this parameter, the period does not match the newline character.
--'m' treats the source string as multiple lines. Oracle interprets ^ and $ as the start and end, respectively, of any line anywhere in the source string, rather than only at the start or end of the entire source string. If you omit this parameter, Oracle treats the source string as a single line.

--FETCH INSTANCES JOB ATTR OF WHICH IS NOT MANAGER
SELECT * FROM EMP WHERE NOT JOB = 'MANAGER';

--입사년도가 1981년인 경우
SELECT * FROM EMP WHERE HIREDATE >= '1981/01/01' AND HIREDATE <= '1981/12/31';
SELECT * FROM EMP WHERE HIREDATE BETWEEN '1981/01/01' AND '1981/12/31';
SELECT * FROM EMP WHERE YEAR(HIREDATE) = 1981; -- MySql style, AN ERROR OCCURS
SELECT * FROM EMP WHERE EXTRACT(YEAR FROM HIREDATE) = 1981;
SELECT * FROM EMP
    WHERE EXTRACT(YEAR FROM HIREDATE) = 1981
    ORDER BY 8 DESC;

SELECT
    SYSTIMESTAMP,
    EXTRACT(TIMEZONE_REGION FROM SYSTIMESTAMP) A,
    EXTRACT(TIMEZONE_ABBR FROM SYSTIMESTAMP) B,
    EXTRACT(TIMEZONE_HOUR FROM SYSTIMESTAMP) C,
    EXTRACT(TIMEZONE_MINUTE FROM SYSTIMESTAMP) D
FROM DUAL;

SELECT * FROM V$TIMEZONE_NAMES;

--급여가 3000보다 크거나 1000보다 작은 사원의 이름
SELECT ENAME FROM EMP WHERE SAL > 3000 OR SAL < 1000;
SELECT ENAME FROM EMP WHERE NOT SAL >= 1000 AND SAL <= 3000;
SELECT ENAME FROM EMP WHERE NOT (SAL >= 1000) AND (SAL <= 3000); -- 위 쿼리는 부정연산자가 앞에만 걸려있다.
SELECT ENAME FROM EMP WHERE NOT(SAL >= 1000 AND SAL <= 3000); -- 이렇게 묶어줘야 한다.
SELECT ENAME FROM EMP WHERE NOT SAL >= 1000 AND NOT SAL <= 3000; -- 아무것도 안나옴 
SELECT ENAME FROM EMP WHERE NOT SAL >= 1000 OR NOT SAL <= 3000;  --둘다 걸어줄때는 OR연산

/*******************************
    LIKE 문 사용 p.134
********************************/
--이름이 S로 끝나는 사람
SELECT * FROM EMP WHERE ENAME LIKE '%S';
--이름이 J로 시작하는 사람
SELECT * FROM EMP WHERE ENAME LIKE 'J%';
--이름이 J로 시작해서 S로 끝나는 사람
SELECT * FROM EMP WHERE ENAME LIKE 'J%S';
--이름에 O가 들어가는 사람
SELECT * FROM EMP WHERE ENAME LIKE '%O%';
--이름의 두번째 글짜가 O인 사람
SELECT * FROM EMP WHERE ENAME LIKE '_O%';
--이름이 5 글자인 사람
SELECT ENAME FROM EMP WHERE ENAME LIKE '_____';

/*******************************
    BETWEEN 문 사용 p.136
********************************/
SELECT * FROM EMP WHERE SAL BETWEEN 1000 AND 2000;  -- INCLUSIVE BY DEFAULT (CANNOT CHANGE)
SELECT * FROM EMP WHERE SAL NOT BETWEEN 1000 AND 2000;

/*******************************
    IN 문 사용 p.138
********************************/
SELECT * FROM EMP WHERE JOB IN ('CLERK', 'MANAGER');
SELECT * FROM EMP
WHERE (JOB, DEPTNO) -- 여러 칼럼을 묶어서 같이 비교할 수도 있다.
    IN (('CLERK', 20), ('MANAGER', 30));


/*******************************
    NULL 값 조회 p.139
********************************/
--NULL의 특징:
--1. NULL 은 모르는 값을 의미한다.
--2. 값의 부재를 의미한다.
--3. 숫자/날짜와 더하면 NULL이 된다.
--4. NULL과 어떤 값을 비교하면 '알 수 없음'이 반환된다.

SELECT * FROM EMP WHERE MGR IS NULL;
SELECT * FROM EMP WHERE MGR = NULL; -- RETURNS NOTHING !!!!
SELECT * FROM EMP WHERE COMM IS NOT NULL;

SELECT (NULL * 2) + 3 FROM DUAL; -- NULL 값은 모든 연산에 대해 IDEMPOTENT하다.
SELECT NULL - 200000 FROM DUAL;  -- : NULL에는 어떤 대수연산을 해도 NULL이 된다.
SELECT NULL || 'WOW' FROM DUAL;  -- RESULT: 'WOW'
SELECT TO_CHAR(NULL) FROM DUAL;
SELECT DECODE(TO_CHAR(NULL), NULL, 'EQUAL', 'NOT EQUAL') DD FROM DUAL;

-- FUNCTION NVL
SELECT MGR, NVL(MGR, 100000) FROM EMP; -- NVL > IFNULL (MySQL)
SELECT COMM, NVL(COMM, 0) FROM EMP;
-- FUNCTION NVL2
SELECT NVL2  (COMM,        1000, 0), COMM FROM EMP; -- NVL2
SELECT DECODE(COMM, NULL, 0, 1000), COMM FROM EMP;  -- DECODE와는 ARG 반대임을 주의!
-- FUNCTION NULLIF
CREATE TABLE TEST (
    NUM1 NUMBER(10),
    NUM2 NUMBER(10),
    NUM3 NUMBER(10)
);

INSERT INTO TEST VALUES(10,11,12);
INSERT INTO TEST VALUES(20,21,22);
INSERT INTO TEST VALUES(30,30,32);
INSERT INTO TEST VALUES(40,41,42);

SELECT NUM1, NUM2, NULLIF(NUM1, NUM2) FROM TEST;
/* NULLIF(ARG1, ARG2) 
        -> NULL IF ARG2 == ARG2 
           ELSE ARG1           */
           
-- FUNCTION COALESCE
SELECT COMM, MGR, COALESCE(COMM, MGR) FROM EMP;
-- NULL 이 아닌 최초 인자값 반환
SELECT COMM, MGR, SAL, COALESCE(COMM, MGR, SAL) FROM EMP;

/*******************************
    GROUP BY / HAVING / AGGREGATE FUNCTIONS   p.141
********************************/
SELECT COUNT(COMM) FROM EMP;
SELECT COUNT(MGR) FROM EMP;
SELECT COUNT(*) FROM EMP;

SELECT SUM(SAL) FROM EMP;
SELECT AVG(SAL) FROM EMP;
SELECT SUM(SAL), AVG(SAL) FROM EMP;
SELECT SUM(SAL) FROM EMP GROUP BY DEPTNO;
SELECT ENAME, SUM(SAL) FROM EMP;
SELECT SUM(COMM) FROM EMP;
SELECT SUM(COMM) / COUNT(COMM) AS AVERAGE FROM EMP;
SELECT AVG(COMM) FROM EMP; -- 위의 식과 같은 결과. COUNT는 NULL을 제외하고 연산


-- 출력 결과 수를 제한하기 ROWNUM
SELECT ENAME, SAL FROM EMP WHERE ROWNUM < 4 ORDER BY SAL DESC;
SELECT ENAME, SAL FROM EMP ORDER BY SAL DESC LIMIT 3;    -- MySQL STYLE

/*******************************
    GROUP BY 사용예제 p.144
********************************/

SELECT JOB, AVG(SAL) FROM EMP GROUP BY JOB;
SELECT DEPTNO, SUM(SAL) FROM EMP GROUP BY DEPTNO;
SELECT DEPTNO, SUM(SAL) FROM EMP GROUP BY DEPTNO HAVING SUM(SAL) < 10000;

--부서별, 관리자별 급여평균 계산 
SELECT DEPTNO, MGR, AVG(SAL) FROM EMP GROUP BY DEPTNO, MGR;

--각 부서별로 그룹화, 부서원의 최대 급여가 3000 이하인 부서의 SAL의 총합
SELECT DEPTNO, SUM(SAL), MAX(SAL) FROM EMP
GROUP BY DEPTNO HAVING MAX(SAL) <= 3000;

--JOB이 CLERK인 직원들에 대해서 각 부서별로 그룹화, 부서원의 최소 급여가 1000 이하인 부서에서 직원들의 급여 총합
-- 부서번호 오름차순 정렬
SELECT DEPTNO, SUM(SAL) FROM EMP
WHERE JOB = 'CLERK'
GROUP BY DEPTNO
    HAVING MIN(SAL) < 1000
ORDER BY DEPTNO ASC;
    
--급여가 1500 이상인 직원들에 대해서 부서별로 그룹화
--부서원의 최소 급여가 1000 이상, 최대 급여가 5000 이하인 부서에서 직원들의 평균 급여
--부서로 내림차순 정렬

SELECT DEPTNO, AVG(SAL)             -- 5
FROM EMP                            -- 1 숫자는 실행 순서를 나타냄
WHERE SAL >= 1500                   -- 2
GROUP BY DEPTNO                     -- 3
    HAVING                          -- 4            
        MIN(SAL) >= 1000 AND -- OR/AND 둘다 결과가 같네?
        MAX(SAL) <= 5000
ORDER BY DEPTNO DESC;               -- 6

-- 직원번호별로 부하직원의 수와 부하직원 번호의 나열, 부하직원 번호의 나열을 출력

SELECT * FROM EMP ORDER BY MGR;

SELECT * FROM
(SELECT EMPNO, ENAME, JOB FROM EMP) A,
(SELECT MGR, ENAME, JOB FROM EMP) B
WHERE A.EMPNO = B.MGR
ORDER BY A.EMPNO;

SELECT * FROM
(SELECT EMPNO, ENAME, JOB FROM EMP) A
INNER JOIN
(SELECT MGR, ENAME, JOB FROM EMP) B
ON A.EMPNO = B.MGR
ORDER BY A.EMPNO;

-- 직원번호별로 부하직원의 수와 부하직원 번호의 나열, 
-- CONNECT BY 구조에 의한 계층형 QUERY - p.184

SELECT * FROM EMP;

SELECT MAX(LEVEL) FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

SELECT LEVEL, EMPNO, MGR, ENAME FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

SELECT LEVEL, LPAD(' ', 4 * (LEVEL - 1)) || EMPNO AS HRCH, MGR, CONNECT_BY_ISLEAF FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;