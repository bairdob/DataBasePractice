#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    v_emp1 hr_poc1.Employees_copy.employee_id%TYPE := 999;
    v_emp2 hr_poc1.Employees_copy.employee_id%TYPE := 888;
    v_temp hr_poc1.Employees_copy.employee_id%TYPE;
    v_new_salary hr_poc1.Employees_copy.salary%TYPE := 1000;
BEGIN
    SELECT employee_id INTO STRICT v_temp
    FROM hr_poc1.Employees_copy
    WHERE employee_id = v_emp1;

    UPDATE hr_poc1.Employees_copy
    SET salary = v_new_salary
    WHERE employee_id = v_emp2;

    EXCEPTION
    WHEN SQLSTATE 'P0002' THEN
        RAISE NOTICE 'Ошибка операции UPDATE, "employee_id=%" does not exist', v_emp1;

    SELECT employee_id INTO v_temp
    FROM hr_poc1.Employees_copy
    WHERE employee_id = v_emp2;

    IF v_temp IS NULL THEN
        DELETE FROM hr_poc1.Employees_copy 
        WHERE employee_id = v_emp2;
        RAISE NOTICE 'Ошибка операции DELETE, "employee_id=%" does not exist', v_emp2;
    END IF;

    END \$\$;
EOF
