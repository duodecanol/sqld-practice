SELECT table_name, owner, NVL(num_rows, 0) num_rows FROM all_tables WHERE owner='SYS'
ORDER BY num_rows DESC;


SELECT * FROM USER_ROLE_PRIVS;


