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
    INTERSECT
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
FROM EMP A JOIN DEPT B USING(DEPTNO);

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
    OUTER JOIN
********************************/
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

/*******************************
    CROSS JOIN - CARTESIAN PRODUCT
********************************/

SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT * FROM EMP CROSS JOIN DEPT;

/*******************************
    UNION
********************************/
SELECT DEPTNO FROM EMP
UNION
SELECT DEPTNO FROM EMP; -- 정렬/중복제거

SELECT DEPTNO FROM EMP
UNION ALL
SELECT DEPTNO FROM EMP; -- 정렬/중복제거 안함 

/*******************************
    MINUS 차집합
********************************/
SELECT DEPTNO FROM DEPT
MINUS -- MS SQL은 EXCEPT
SELECT DEPTNO FROM EMP; 

