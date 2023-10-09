#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    v_dep_id hr_poc1.Employees_copy.department_id%TYPE := 50;
    v_pct numeric(10,2) := 0.02;
    all_salary_after_bonus hr_poc1.Employees_copy.salary%TYPE;
    mean_all_salary hr_poc1.Employees_copy.salary%TYPE;
    mean_department_salary hr_poc1.Employees_copy.salary%TYPE;
    cnt_salary_increases INTEGER := 1;
BEGIN
    -- средняя зарплата по всем сотрудникам
    SELECT AVG(salary) INTO mean_all_salary
    FROM hr_poc1.Employees_copy;

    -- средняя зарплата отдела v_dep_id
    SELECT AVG(salary) INTO mean_department_salary
    FROM hr_poc1.Employees_copy
    WHERE department_id = v_dep_id;

    RAISE NOTICE'Средняя зарплата = %' , mean_all_salary;
    RAISE NOTICE'Средняя зарплата отдела % = %' , v_dep_id, mean_department_salary;

    -- если средняя зарплата отдела меньше средней средней общей
    WHILE mean_department_salary <= mean_all_salary LOOP
        -- увеличиваем зарплату сотрудников отдела
        UPDATE hr_poc1.Employees_copy
        SET salary = salary * (1.0 + v_pct)
        WHERE department_id = v_dep_id;

        -- увеличиваем счетчик итераций
        cnt_salary_increases := cnt_salary_increases + 1;

        -- получаем среднюю зарлату по отделу v_dep_id
        SELECT AVG(salary) INTO mean_department_salary
        FROM hr_poc1.Employees_copy
        WHERE department_id = v_dep_id;
    END LOOP;

    RAISE NOTICE'Количество итераций повышения зарплаты %' , cnt_salary_increases;

END \$\$
EOF
