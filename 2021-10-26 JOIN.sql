/**************************************************************
    JOIN
    EQUI JOIN    p.171
***************************************************************/
SELECT * FROM DEPT;

SELECT *
FROM EMP A, DEPT B
WHERE A.DEPTNO = B.DEPTNO
    AND A.ENAME LIKE 'S%'
ORDER BY A.ENAME;

/*******************************
    INNER JOIN
********************************/
SELECT *
FROM EMP A INNER JOIN DEPT B ON A.DEPTNO = B.DEPTNO
WHERE A.ENAME LIKE 'S%'
ORDER BY A.ENAME;

/*******************************
    INTERSECT  교집합
********************************/
SELECT DEPTNO FROM EMP
    INTERSECT
SELECT DEPTNO FROM DEPT;

/*******************************
    EQUI JOIN, INNER JOIN 고찰 및 연습문제
********************************/

-- JOIN 세가지 방법
SELECT * FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO; -- EQUI-JOIN
SELECT * FROM EMP JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO; -- INNER JOIN이지만 INNER 안써도 된다. 결과는 같다.
SELECT * FROM EMP INNER JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO;
SELECT * FROM EMP JOIN DEPT USING(DEPTNO); --  컬럼명이 같을 때만 사용


--사원의 사원번호, 이름, 근무부서를 가져온다.
SELECT A.EMPNO, A.ENAME, B.DNAME
FROM EMP A LEFT OUTER JOIN DEPT B USING(DEPTNO); -- 문제 답은 LEFT OUTER JOIN으로 햇다. 왜냐하면 부서가 없을수도 있으니까.

SELECT A.EMPNO, A.ENAME, B.DNAME
FROM EMP A, DEPT B 
WHERE A.DEPTNO = B.DEPTNO;

SELECT A.EMPNO, A.ENAME, B.DNAME
FROM EMP A JOIN DEPT B ON A.DEPTNO = B.DEPTNO; -- JOIN / INNER JOIN  같다.

SELECT A.EMPNO, A.ENAME, B.DNAME
FROM EMP A JOIN DEPT B USING(DEPTNO); -- ON, WHERE 사용하면 DEPTNO 컬럼이 2개가 되지만 USING을 사용하면 하나만 생성되며 맨 앞으로 온다.


--시카고에 근무하는 사원들의 사원번호,이름, 직무를 FETCH
SELECT A.EMPNO, A.ENAME, A.JOB, B.DNAME, B.LOC
FROM EMP A INNER JOIN DEPT B USING(DEPTNO)
WHERE B.LOC LIKE 'CHICAGO';

/*******************************
    NON-EQUI JOIN
********************************/
SELECT * FROM EMP;
SELECT * FROM SALGRADE;

-- SALGRADE 테이블의 연봉 범위별 등급을 사원들에게 적용시켜라.
SELECT A.EMPNO, A.ENAME, A.HIREDATE, B.GRADE, A.SAL, B.LOSAL, B.HISAL
FROM EMP A, SALGRADE B
WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL;

-- 급여등급이 4등급인 사원들의 사원번호, 이름, 급여, 부서이름, 근무지역 FETCH
SELECT A.EMPNO, A.ENAME, A.SAL, C.DNAME, C.LOC, B.GRADE AS "등급확인"
FROM EMP A, SALGRADE B, DEPT C
WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL
    AND A.DEPTNO = C.DEPTNO
    AND B.GRADE = 4;

-- 각 급여 등급별  // 급여 총합과 평균, 사원 수, 최대 급여, 최소 급여 FETCH
SELECT B.GRADE, SUM(A.SAL), ROUND(AVG(SAL), 4), COUNT(EMPNO), MAX(A.SAL), MIN(A.SAL)
FROM EMP A, SALGRADE B
WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL
GROUP BY B.GRADE
ORDER BY B.GRADE;

/*******************************
    NAURAL JOIN  -- 교재에 없음
********************************/
SELECT *
FROM EMP A, DEPT B 
WHERE A.DEPTNO = B.DEPTNO;

SELECT *
FROM EMP A INNER JOIN DEPT B 
ON A.DEPTNO = B.DEPTNO;
--- 두 테이블의 DEPTNO, DEPTNO_1 칼럼이 중복되어 나타나며 중앙에서 만난다.

SELECT *
FROM EMP A INNER JOIN DEPT B USING (DEPTNO);
--- 이름이 같은 속성인 DEPTNO가 Query Result의 1번 칼럼이 된다.

SELECT *
FROM EMP A NATURAL JOIN DEPT B; -- NAT JOIN
-- NAT JOIN 은 컬럼 조건 명시가 없어야한다. 이름이 같은 컬럼을 자동으로 찾는다.
--- ???? 두 테이블에 이름이 같은 속성이 없으면 어떻게 되나?
--- ???? 두 테이블에 이름이 같은 속성이 여러 개면 어떻게 되나?


/*******************************
    OUTER JOIN
        LEFT, RIGHT, FULL 중 하나를 선택해야한다.
********************************/

-- OUTER_TEST_A, OUTER_TEST_B 를 이용한 간단한 테스트
SELECT * FROM OUTER_TEST_A;
SELECT * FROM OUTER_TEST_B;

-- 두 집합의 교집합
SELECT * FROM OUTER_TEST_A  INTERSECT  SELECT * FROM OUTER_TEST_B;
------------------------------------------------------------------
SELECT *
FROM OUTER_TEST_A A OUTER JOIN OUTER_TEST_B B
    ON A.X = B.X;  -- 오류가 난다. INVALID IDENTIFIER
------------------------------------------------------------------
SELECT *
FROM OUTER_TEST_A A LEFT OUTER JOIN OUTER_TEST_B B -- LEFT OUTER
    ON A.X = B.X;
SELECT *
FROM OUTER_TEST_A A, OUTER_TEST_B B -- LEFT OUTER OPERATOR (+) 
    WHERE A.X = B.X(+);
------------------------------------------------------------------
SELECT *
FROM OUTER_TEST_A A RIGHT OUTER JOIN OUTER_TEST_B B -- RIGHT OUTER
    ON A.X = B.X;
SELECT *
FROM OUTER_TEST_A A, OUTER_TEST_B B -- RIGHT OUTER OPERATOR (+)
    WHERE A.X (+)= B.X;    
------------------------------------------------------------------
SELECT *
FROM OUTER_TEST_A A FULL OUTER JOIN OUTER_TEST_B B -- FULL OUTER
    ON A.X = B.X;
SELECT *
FROM OUTER_TEST_A A, OUTER_TEST_B B -- FULL OUTER 기호는 불가능. 양쪽에 쓰면 오류.
    WHERE A.X(+) = B.X(+);
------------------------------------------------------------------
-- CARTESIAN PRODUCT와의 차이점은?  레코드 4 * 5 = 20
SELECT * FROM OUTER_TEST_A  CROSS JOIN  OUTER_TEST_B;

------------------------------------------------------------------
-- 이해를 바탕으로 예제 연습
------------------------------------------------------------------

-- 부서가 없는 사원들의 사원 이름, 사원번호, 부서번호, 부서명을 출력

-- 부서가 없는 사원은 없다.  사원이 없는 부서는 있다.

SELECT EMP.ENAME, EMP.DEPTNO, DEPT.DEPTNO, DEPT.DNAME
FROM DEPT, EMP
WHERE EMP.DEPTNO = DEPT.DEPTNO;

SELECT EMP.ENAME, EMP.DEPTNO, DEPT.DEPTNO, DEPT.DNAME
FROM EMP, DEPT
WHERE EMP.DEPTNO (+)= DEPT.DEPTNO; -- OUTER JOIN OPERATOR

SELECT EMP.ENAME, EMP.DEPTNO, DEPT.DEPTNO, DEPT.DNAME
FROM DEPT LEFT OUTER JOIN EMP
    ON EMP.DEPTNO = DEPT.DEPTNO;
    
SELECT EMP.ENAME, EMP.DEPTNO, DEPT.DEPTNO, DEPT.DNAME
FROM DEPT RIGHT OUTER JOIN EMP
    ON EMP.DEPTNO = DEPT.DEPTNO;    


-- 각 사원의 이름, 사원번호, 직장상사의 이름을 가져오고 직속상관이 없는 사원도 가져온다.
SELECT * 
FROM EMP A ;

/*******************************
    CROSS JOIN - CARTESIAN PRODUCT
********************************/

SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT * FROM EMP CROSS JOIN DEPT;

/*******************************
    UNION
********************************/
SELECT * FROM OUTER_TEST_A
    UNION 
SELECT * FROM OUTER_TEST_B; -- UNION 정렬/중복제거

SELECT DEPTNO FROM EMP
    UNION
SELECT DEPTNO FROM EMP; -- UNION 정렬/중복제거

SELECT * FROM OUTER_TEST_A
    UNION ALL
SELECT * FROM OUTER_TEST_B; -- UNION ALL 정렬/중복제거 안함 

SELECT DEPTNO FROM EMP
    UNION ALL
SELECT DEPTNO FROM EMP; -- UNION ALL 정렬/중복제거 안함 

/*******************************
    MINUS 차집합
********************************/
SELECT DEPTNO FROM DEPT
MINUS -- [[[[[[[[[[[[ MS SQL은 EXCEPT ]]]]]]]]]]]]]]
SELECT DEPTNO FROM EMP; 

SELECT * FROM OUTER_TEST_A
    MINUS
SELECT * FROM OUTER_TEST_B;