#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    v_dep_id hr_poc1.Employees_copy.department_id%TYPE:=60;
    v_emp  hr_poc1.Employees_copy%ROWTYPE;
    cnt_by_department_id INTEGER;
    all_salary hr_poc1.Employees_copy.salary%TYPE;
    all_salary_after_bonus hr_poc1.Employees_copy.salary%TYPE;
    v_add_salary hr_poc1.Employees_copy.salary%TYPE;

    Cur_Emp CURSOR (p_department_id hr_poc1.Employees_copy.department_id%TYPE) IS 
    SELECT *
    FROM hr_poc1.Employees_copy
    WHERE department_id = p_department_id;
 
BEGIN
    SELECT SUM(salary) INTO all_salary 
    FROM hr_poc1.Employees_copy
    WHERE department_id = v_dep_id;
    RAISE NOTICE 'Общая сумма зарплаты сотрудников отдела % до изменения = %' , v_dep_id, all_salary;

    FOR v_cur_emp in Cur_Emp(v_dep_id)
    LOOP
        v_add_salary := 
        CASE
            WHEN v_cur_emp.salary < 3000 THEN 1000
            WHEN v_cur_emp.salary > 3500 AND v_cur_emp.salary < 4000 THEN 500
            WHEN v_cur_emp.salary > 4200 AND v_cur_emp.salary < 4700 THEN -500
            ELSE 0
        END;

        UPDATE hr_poc1.Employees_copy
        SET salary = salary + v_add_salary
        WHERE CURRENT OF Cur_Emp;

        RAISE NOTICE '% + %', v_cur_emp.salary, v_add_salary;
    END LOOP;


    SELECT SUM(salary) INTO all_salary_after_bonus
    FROM hr_poc1.Employees_copy
    WHERE department_id = v_dep_id;
    RAISE NOTICE'Общая сумма зарплаты сотрудников отдела % после изменения = %' , v_dep_id, all_salary_after_bonus;
    RAISE NOTICE'Общая сумма увеличения зарплаты сотрудников отдела % = %' , v_dep_id, (all_salary_after_bonus - all_salary);

END \$\$
EOF
