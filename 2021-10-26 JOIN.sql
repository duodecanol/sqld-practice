/**************************************************************
    JOIN
    EQUI JOIN    p.171
***************************************************************/

SELECT *
FROM EMP A, DEPT B
WHERE A.DEPTNO = B.DEPTNO
    AND A.ENAME LIKE 'S%'
ORDER BY A.ENAME;
--
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
    NON-EQUI JOIN
********************************/
SELECT * FROM EMP;
SELECT * FROM SALGRADE;
SELECT A.EMPNO, A.ENAME, A.HIREDATE, B.GRADE, A.SAL, B.LOSAL, B.HISAL
FROM EMP A, SALGRADE B
WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL;

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

