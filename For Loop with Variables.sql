set serveroutput on format wrapped;
DECLARE i integer := 1;
BEGIN
    FOR x in (SELECT DISTINCT owner AS y FROM all_tables) LOOP
        dbms_output.put_line(TO_CHAR(i, '00') || ' ' ||x.y);
        i := i + 1;
    END LOOP;
END;
