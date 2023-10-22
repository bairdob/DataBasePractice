#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    v_emp  hr_poc1.Employees_copy%ROWTYPE;
    v_dep_id hr_poc1.Employees_copy.department_id%TYPE:=60;
    v_n INTEGER := 10;
    Cur_Highest_Salary CURSOR (p_n INTEGER,p_m hr_poc1.Employees_copy.department_id%TYPE) FOR
    SELECT *
    FROM hr_poc1.Employees_copy
    WHERE department_id = p_m
    ORDER BY hr_poc1.Employees_copy.salary DESC
    LIMIT p_n;
    v_counter INTEGER := 1;
    v_prev_salary hr_poc1.Employees_copy.salary%TYPE;
BEGIN
    OPEN Cur_Highest_Salary(v_n, v_dep_id);

    LOOP
        FETCH Cur_Highest_Salary INTO v_emp; 
        EXIT WHEN NOT FOUND;

        -- update counter 
        IF v_emp.salary != v_prev_salary THEN
            v_counter := v_counter + 1;
        END IF;
    
        RAISE NOTICE '% Record: % % % % %', 
            v_counter,
            v_emp.employee_id, 
            v_emp.first_name, 
            v_emp.last_name, 
            v_emp.job_id, 
            v_emp.salary;

        -- update prev_salary
        v_prev_salary := v_emp.salary;

    END LOOP;
    
    CLOSE Cur_Highest_Salary;
END \$\$
EOF
