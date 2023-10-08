#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    v_dep_id hr_poc1.Employees_copy.department_id%TYPE := 60;
    v_pct numeric(10,1);
    all_salary numeric(10,2);
    cnt_by_department_id INTEGER;
    all_salary_after_bonus numeric(10,2);
    v_max_sum_sal INTEGER := 50000;
BEGIN
    -- получаем общую зарплату отдела v_dep_id
    SELECT SUM(salary) INTO all_salary 
    FROM hr_poc1.Employees_copy
    WHERE department_id = v_dep_id;

    -- получаем количество сотрудников отдела v_dep_id
    SELECT COUNT(*) INTO cnt_by_department_id
    FROM hr_poc1.Employees_copy
    WHERE department_id = v_dep_id;

    RAISE NOTICE'Общая сумма зарплаты сотрудников отдела % = %' , v_dep_id, all_salary;
    RAISE NOTICE'Общee количество сотрудников отдела % = %' , v_dep_id, cnt_by_department_id;
    
    -- если общая зарплата отдела v_dep_id меньше константы
    if all_salary < v_max_sum_sal THEN
        -- получаем процент увеличения зарплаты, и округляем в большую сторону
        v_pct := (all_salary / cnt_by_department_id) / all_salary;
        v_pct := ROUND(v_pct * 100) / 100;
        RAISE NOTICE'Необходимо увеличить зарплату сотрудников на %', v_pct;

        -- увеличиваем зарплату сотрудников
        UPDATE hr_poc1.Employees_copy
        SET salary = salary * (1.0 + v_pct)
        WHERE department_id = v_dep_id;
    END IF;
        
    SELECT SUM(salary) INTO all_salary_after_bonus
    FROM hr_poc1.Employees_copy
    WHERE department_id = v_dep_id;

    RAISE NOTICE'Общая сумма зарплаты сотрудников отдела % после изменения на % = %' , v_dep_id, v_pct,all_salary_after_bonus;
    RAISE NOTICE'Общая сумма увеличения зарплаты сотрудников отдела % = %' , v_dep_id, (all_salary_after_bonus - all_salary);

END \$\$
EOF
