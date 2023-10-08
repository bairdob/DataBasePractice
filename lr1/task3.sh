#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    v_dep_id hr_poc1.Employees_copy.department_id%TYPE:=30;
    v_emp  hr_poc1.Employees_copy%ROWTYPE;
    v_pct numeric(10,1):=0.1;
    all_salary hr_poc1.Employees_copy.salary%TYPE;
    cnt_by_department_id INTEGER;
    all_salary_after_bonus hr_poc1.Employees_copy.salary%TYPE;
BEGIN
    SELECT SUM(salary) INTO all_salary 
    FROM hr_poc1.Employees_copy
    WHERE department_id = v_dep_id;

    SELECT COUNT(*) INTO cnt_by_department_id
    FROM hr_poc1.Employees_copy
    WHERE department_id = v_dep_id;

    RAISE NOTICE'Общая сумма зарплаты сотрудников отдела % до изменения = %' , v_dep_id, all_salary;
    RAISE NOTICE'Общee количество сотрудников отдела % = %' , v_dep_id, cnt_by_department_id;

    UPDATE hr_poc1.Employees_copy
    SET salary = salary * (1.0 + v_pct)
    WHERE department_id = 30;

    SELECT SUM(salary) INTO all_salary_after_bonus
    FROM hr_poc1.Employees_copy
    WHERE department_id = v_dep_id;
    RAISE NOTICE'Общая сумма зарплаты сотрудников отдела % после изменения на % = %' , v_dep_id, v_pct, all_salary_after_bonus;
    RAISE NOTICE'Общая сумма увеличения зарплаты сотрудников отдела % = %' , v_dep_id, (all_salary_after_bonus - all_salary);

END \$\$
EOF
