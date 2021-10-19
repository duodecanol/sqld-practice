CREATE TABLE DEPT(
    DEPTNO VARCHAR2(4) PRIMARY KEY,
    DEPTNAME VARCHAR2(20)
);

CREATE TABLE EMP (
    EMPNO   NUMBER(10),
    ENAME   VARCHAR2(20),
    SAL     NUMBER(10, 2) DEFAULT 0,
    DEPTNO  VARCHAR2(4) NOT NULL,
    CREATEDATE  DATE DEFAULT SYSDATE,
    CONSTRAINT EMP_PK PRIMARY KEY (EMPNO)
);

DROP TABLE EMP;
DROP TABLE DEPT;

SELECT * FROM EMP;
SELECT * FROM DEPT;

ALTER TABLE EMP ADD CONSTRAINT DEPT_FK FOREIGN KEY (DEPTNO) REFERENCES DEPT(DEPTNO);
ALTER TABLE EMP DROP CONSTRAINT DEPT_FK;
ALTER TABLE EMP ADD CONSTRAINT DEPT_FK FOREIGN KEY (DEPTNO) REFERENCES DEPT(DEPTNO)  -- 제약조건은 수정이 불가능~!!!!
    ON DELETE CASCADE;
    

INSERT INTO DEPT VALUES('1000', 'HR');
INSERT INTO DEPT VALUES('1001', 'GA');

INSERT INTO EMP VALUES(100, 'IMBEST', 1000, '1000', DEFAULT);
INSERT INTO EMP VALUES(101, 'GENERAL MORTORS', 2000, '1001', DEFAULT);

DELETE FROM DEPT WHERE DEPTNO = '1000'; -- ON DELETE CASCADE에 의해 EMP의 참조 행도 삭제된다

---------------------------------------------------------------

ALTER TABLE EMP RENAME TO EMP_NEW;
SELECT * FROM EMP;
SELECT * FROM emp_new;

DROP TABLE DEPT;