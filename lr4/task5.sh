#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    v_dep_id hr_poc1.Employees_copy.department_id%TYPE:=10;
    v_cnt int;
BEGIN
    SELECT COUNT(*) INTO v_cnt
    FROM hr_poc1.Employees_copy
    WHERE department_id = v_dep_id;

    IF v_cnt = 1 THEN
        RAISE EXCEPTION USING ERRCODE = 22005,
        MESSAGE = 'Ошибка удаления сотрудника';
    END IF;

    DELETE FROM hr_poc1.employees_copy
    WHERE employee_id=101 AND department_id=v_dep_id;

    EXCEPTION
    WHEN SQLSTATE '22005' THEN
        RAISE NOTICE 'Операция удаления не выполнена';

    END \$\$;
EOF
