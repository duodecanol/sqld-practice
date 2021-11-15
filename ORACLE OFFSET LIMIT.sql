/**********************************************************************
 * ORACLE 12 버전부터 추가된 OFFSET / FETCH ROWS 구문
 * MySQL에서의 LIMIT와 비슷한 역할을 한다.
 **********************************************************************/

[ OFFSET offset { ROW | ROWS } ]

[ FETCH { FIRST | NEXT } [ { rowcount | percent PERCENT } ] { ROW | ROWS } { ONLY | WITH TIES } ]

SELECT COUNT(*) FROM TB_INDUTY_CL; -- 테이블의 총 행 수 855

SELECT * FROM TB_INDUTY_CL
FETCH FIRST 10 ROW ONLY;  -- 복수라고 해서 꼭 ROWS로 해야하는 것은 아님.

SELECT COUNT(*) FROM
(SELECT * FROM TB_INDUTY_CL        -- 10 PERCENT하면 전체 행의 10% 수를 가져온다.
FETCH FIRST 10 PERCENT ROWS ONLY); -- 86개

SELECT * FROM EMP -- 14 TUPLES
OFFSET 4 ROWS; -- 10

SELECT * FROM EMP
OFFSET 4 ROWS
FETCH NEXT 4 ROWS ONLY;

SELECT * FROM EMP
ORDER BY DEPTNO  -- ORDER BY 절에 의한 정렬
OFFSET 2 ROWS	 --- 정확히 4개만 가져온다.
FETCH NEXT 4 ROWS ONLY;  

SELECT * FROM EMP
ORDER BY DEPTNO
OFFSET 2 ROWS    -- WITH TIES는 정렬기준상 동점인것까지는 포함시킨다. 
FETCH NEXT 4 ROWS WITH TIES; --- 결과 6개.



