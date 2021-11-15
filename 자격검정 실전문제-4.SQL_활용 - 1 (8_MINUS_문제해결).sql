/*******************************
    4. SQL 활용 - 1
********************************/
-- 8번  차집합과 동일한 결과를 내는 쿼리를 기술하라.
DROP TABLE TAB1;

CREATE TABLE TAB1( A NUMBER(10), B VARCHAR2(20));
CREATE TABLE TAB2( A NUMBER(10), B VARCHAR2(20));

INSERT INTO TAB1 (A, B) VALUES (1, 'A');
INSERT INTO TAB1 (A, B) VALUES (1, 'A');
INSERT INTO TAB1 (A, B) VALUES (2, 'B');
INSERT INTO TAB1 (A, B) VALUES (2, 'C');

INSERT INTO TAB2 (A, B) VALUES (1, 'A');
INSERT INTO TAB2 (A, B) VALUES (1, 'C');
INSERT INTO TAB2 (A, B) VALUES (2, 'A');
INSERT INTO TAB2 (A, B) VALUES (2, 'C');

SELECT * FROM TAB1;
SELECT * FROM TAB2;

SELECT * FROM TAB1
    MINUS
SELECT * FROM TAB2;

/* 2번보기. NOT IN 을 이용해 차집합을 구현한다.
 *    
 *    X - Y => X ∩ (X ∩ Y)c 
 *    (X ∩ Y)c => (Xc ∪ Yc)
*/    
SELECT *
FROM TAB1 
WHERE TAB1.A NOT IN (SELECT TAB2.A FROM TAB2) -- 1, 1, 2, 2
    AND TAB1.B NOT IN (SELECT TAB2.B FROM TAB2); -- A, C, A, C 
    -- AND 조건 접속하면 여집합에 대해 공통부분이 없다. 공집합이 된다.
    -- 유의할 것은, 복수 컬럼 상태에서 교집합/차집합하는 것은 튜플을 통째로 원소로 삼는다는 것이다.
    -- 따라서, (a, b, c, ...) <> (x, y, z, ... ) 형태로 되어야 하며, 만약 여기서 a=x, b=y 이더라도 c<>z이면 조건은 만족되어야 한다.
    -- 그러므로 공집합이 아니도록 조건접속을 하려면 AND가 아닌 OR로 조건의 합집합을 형성해야 한다.

SELECT *
FROM TAB1
WHERE TAB1.A NOT IN (SELECT TAB2.A FROM TAB2) -- 1, 1, 2, 2
    OR TAB1.B NOT IN (SELECT TAB2.B FROM TAB2); -- A, C, A, C

SELECT *
FROM TAB1
WHERE (TAB1.A, TAB1.B) NOT IN (SELECT TAB2.A, TAB2.B FROM TAB2);

/*  4번보기. NOT EXISTS를 이용해 차집합을 구현한다.
 *   로직은 2번보기와 유사하며, 조건의 접속을 and로 할지 or로 할지의 문제는 동일한 형태이다.
 *    X - Y => X ∩ (X ∩ Y)c 
 *    (X ∩ Y)c => (Xc ∪ Yc)
*/
SELECT *
FROM TAB1
WHERE NOT EXISTS (SELECT 'X' FROM TAB2 WHERE TAB1.A=TAB2.A AND TAB1.B=TAB2.B);


SELECT *
FROM TAB1
WHERE NOT EXISTS (SELECT 'X' FROM TAB2 WHERE TAB1.A = TAB2.A)
    OR NOT EXISTS (SELECT 'X' FROM TAB2 WHERE TAB1.B = TAB2.B);
    
SELECT *
FROM TAB1
WHERE NOT EXISTS (SELECT 'X' FROM TAB2 WHERE TAB1.A = TAB2.A)
    AND NOT EXISTS (SELECT 'X' FROM TAB2 WHERE TAB1.B = TAB2.B); -- 공집합
    