select * from Person;


select min(id) as mid, email from Person group by email having count(*) > 1;


with A as (
    select min(id) as mid, email from Person group by email having count(*) > 1
)
select b.id from Person b 
    where b.id not in (select A.mid from A)
        and b.email in (select A.email from A);
        
select * 
from Person p1, Person p2
where p1.email = p2.email;

select * 
from Person p1, Person p2
where p1.email = p2.email
    and p1.id > p2.id;
    
delete from Person where id not in (
    select * from (
        select min(Id) from Person group by email
    ) as p
);


SELECT ROWNUM AS ID, EMPNO, ENAME, DEPTNO FROM EMP;

SELECT * FROM EMP;

SELECT * FROM EMP WHERE ROWNUM > 4;

SELECT * FROM (SELECT ROWNUM AS ID, EMPNO, ENAME, DEPTNO FROM EMP) X 
WHERE X.ID > 1
    AND X.DEPTNO > ( SELECT * FROM (
        SELECT DEPTNO FROM (SELECT ROWNUM, DEPTNO FROM EMP) 
        WHERE ROWNUM = X.ID - 1
        ) AS P
    );