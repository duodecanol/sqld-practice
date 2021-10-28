/*******************************
    HIERARCHCIAL QUERY - CONNECT BY p.182
********************************/
SELECT * FROM EMP; -- �� EMP�� MGR �Ŵ����� �ϳ� ���ų� ���� �ʴ´�.

SELECT MAX(LEVEL) FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR; --MGR�� ���� �����Ǵ� Ʈ���� �ִ� ����

SELECT LEVEL, EMPNO, MGR, ENAME
FROM EMP
START WITH MGR IS NULL -- MGR�� NULL�� �ڴ� �ڽ��� �����ڰ� �����Ƿ� Ʈ���� �ֻ��� (��Ʈ���)�� ����.
CONNECT BY PRIOR EMPNO = MGR; --������

SELECT LEVEL, EMPNO, MGR, ENAME
FROM EMP
START WITH MGR IS NULL -- MGR�� NULL�� �ڴ� �ڽ��� �����ڰ� �����Ƿ� Ʈ���� �ֻ��� (��Ʈ���)�� ����.
CONNECT BY EMPNO = PRIOR MGR; --������ // ���������� �ϸ� �θ��� �θ� �ڽ����� �����ϴ� ���̶� ������� ����.
     -- PRIOR Ű������ ��/�� ��ġ�� �߿��� ���� �ƴ϶� �Ӽ��� ���ϰ��踦 ������ �Ѵ�.
     -- ������ PRIOR EMPNO = MGR
     -- ������ EMPNO�� ���� MGR �̴�.

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

LEVEL                   �˻� �׸��� ����. �ֻ��� 1
CONNECT_BY_ROOT         ���� �ֻ��� ��
CONNECT_BY_ISLEAF       ���� ����ΰ� �ƴѰ�
SYS_CONNECT_BY_PATH     �ش� �ο��� ���� ��� ǥ��
NOCYCLE                 ��ȯ���� �߻����������� ǥ��
CONNECT_BY_ISCYCLE      ��ȯ���� �߻����� ǥ��

SELECT
    EMPNO,    ENAME,    LEVEL,
    CONNECT_BY_ROOT(EMPNO),
    CONNECT_BY_ISLEAF,
    SYS_CONNECT_BY_PATH(EMPNO, ' -> ') AS CONNECT_PATH    
FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

-- EMP ���̺��� �ֻ��� �����ں��� ���� ������ ������ ������ȣ, �����̸�, ���ӻ����ȣ, ���� ���, �� �޿��� 2000 ������ ����鸸.
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
    
   
    