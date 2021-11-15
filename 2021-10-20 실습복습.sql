SELECT * FROM EMP ORDER BY DEPTNO, SAL;

SELECT * FROM EMP WHERE ENAME = 'MILLER';
SELECT * FROM EMP WHERE ENAME LIKE '_I%';
SELECT * FROM EMP WHERE UPPER(ENAME) LIKE2 '%R';

-- 1981년 이후 입사자 검색
SELECT * FROM EMP WHERE EXTRACT(YEAR FROM HIREDATE) >= 1981;

SELECT * FROM EMP WHERE DEPTNO != 20;

SELECT * FROM EMP WHERE REGEXP_LIKE(ENAME, '^.+?TT$', 'i');

SELECT COMM, NVL2(COMM, COMM, -9999) FROM EMP;

--각 부서별로 그룹화, 부서원의 최대 급여가 3000 이하인 부서의 SAL의 총합
--JOB이 CLERK인 직원들에 대해서 각 부서별로 그룹화, 부서원의 최소 급여가 1000 이하인 부서에서 직원들의 급여 총합
-- 부서번호 오름차순 정렬
SELECT DEPTNO, SUM(SAL) FROM EMP GROUP BY DEPTNO HAVING MAX(SAL) <= 3000
ORDER BY DEPTNO ASC;

SELECT
    UPPER('Apple KOREA'),
    LOWER('Apple KOREA'),
    INITCAP('Apple KOREA')
FROM DUAL;

  -- 사원이름에서 두번째와 세번째 글자만 추출해라.
SELECT SUBSTR(ENAME, 2, 2), ENAME FROM EMP;

--급여 1500 이상인 사원의 급여를 15% 인상한 금액, 단 소수점 이하는 버린다.

SELECT ENAME, JOB, SAL, FLOOR(SAL * 1.15) FROM EMP WHERE SAL >= 1500;
SELECT ENAME, JOB, SAL, TRUNC(SAL * 1.15, -1) FROM EMP WHERE SAL >= 1500;


--급여가 1500 이상인 직원들에 대해서 부서별로 그룹화

--부서원의 최소 급여가 1000 이상, 최대 급여가 5000 이하인 부서에서 직원들의 평균 급여
--부서로 내림차순 정렬
SELECT DEPTNO, ROUND(AVG(SAL), 2) FROM EMP WHERE SAL >= 1500
GROUP BY DEPTNO
    HAVING MIN(SAL) >= 1000 AND MAX(SAL) <= 5000
ORDER BY DEPTNO DESC;

-- JOIN 세가지 방법
SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT * FROM EMP A, DEPT B
WHERE A.DEPTNO = B.DEPTNO; -- EQUI-JOIN

SELECT * FROM EMP A JOIN DEPT B
ON A.DEPTNO = B.DEPTNO;

SELECT * FROM EMP A INNER JOIN DEPT B
ON A.DEPTNO = B.DEPTNO;

SELECT * FROM EMP A JOIN DEPT B
USING (DEPTNO); 


--사원의 사원번호, 이름, 근무부서를 가져온다.

SELECT A.EMPNO 사원번호, A.ENAME 사원이름, B.DNAME 근무부서
FROM EMP A JOIN DEPT B
ON A.DEPTNO = B.DEPTNO;

--시카고에 근무하는 사원들의 사원번호,이름, 직무를 FETCH
SELECT A.EMPNO 사원번호, A.ENAME 사원이름, A.JOB 직무, B.LOC 근무지
FROM EMP A JOIN DEPT B USING (DEPTNO)
WHERE B.LOC = 'CHICAGO';

-- SALGRADE 테이블의 연봉 범위별 등급을 사원들에게 적용시켜라.

SELECT A.EMPNO, A.ENAME, A.JOB, A.SAL, B.GRADE, B.LOSAL, B.HISAL
FROM EMP A JOIN SALGRADE B
ON A.SAL BETWEEN B.LOSAL AND B.HISAL;

-- 급여등급이 4등급인 사원들의 사원번호, 이름, 급여, 부서이름, 근무지역 FETCH

SELECT A.EMPNO, A.ENAME, A.SAL, B.GRADE, C.DNAME, C.LOC
FROM EMP A, SALGRADE B, DEPT C
WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL
    AND A.DEPTNO = C.DEPTNO
    AND B.GRADE = 4;

-- 각 급여 등급별  // 급여 총합과 평균, 사원 수, 최대 급여, 최소 급여 FETCH

SELECT 
    SUM(A.SAL) AS 등급급여총합,
    ROUND(AVG(A.SAL), 0) AS 등급급여평균,
    COUNT(*) AS 사원수,
    MAX(A.SAL) AS 등급군최대급여,
    MIN(A.SAL) AS 등급군최소급여
FROM EMP A JOIN SALGRADE B
ON A.SAL BETWEEN B.LOSAL AND B.HISAL
GROUP BY B.GRADE;

