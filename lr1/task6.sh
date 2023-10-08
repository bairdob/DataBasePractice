#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    emp_salary hr_poc1.Employees_copy.salary%TYPE;
    v_sum_salary hr_poc1.Employees_copy.salary%TYPE:=1;
    emp_rating hr_poc1.Employees_copy.rating_e%TYPE;
    rating hr_poc1.Employees_copy.rating_e%TYPE;
BEGIN
    -- получаем сумму продаж интервала сотрудников
    SELECT SUM(salary) INTO v_sum_salary
    FROM hr_poc1.Employees_copy
    WHERE employee_id BETWEEN 101 AND 200;

    RAISE NOTICE 'Сумма продаж сотрудников с 101 по 200 = %', v_sum_salary;

    FOR i IN 101..200 LOOP
        -- получаем рейтинг по employee_id
        SELECT rating_e INTO emp_rating
        FROM hr_poc1.Employees_copy 
        WHERE employee_id = i;

        -- получаем размер увеличения рейтинга 
        IF COALESCE(v_sum_salary,0) > 1000000 AND emp_rating < 5 THEN rating := 1;
            ELSIF COALESCE(v_sum_salary,0) > 200000 and emp_rating > 1 THEN rating := -1;
            ELSIF COALESCE(v_sum_salary,0) > 500000 THEN rating := 0;
            ELSE rating:=0;
        END IF;
        RAISE NOTICE '% %', emp_rating, rating;
        
        -- обновляем рейтинг
        UPDATE hr_poc1.Employees_copy
        SET rating_e = rating_e + rating
        WHERE employee_id = i;

        SELECT rating_e INTO emp_rating
        FROM hr_poc1.Employees_copy 
        WHERE employee_id = i;
        RAISE NOTICE '% ', emp_rating;
    END LOOP;

END \$\$
EOF
