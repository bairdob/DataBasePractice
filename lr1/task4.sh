#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    emp_start INTEGER; 
    emp_end INTEGER;
    salary_increase INTEGER;
    emp_job_id hr_poc1.Employees_copy.job_id%TYPE;
BEGIN
    -- получаем начало конец для цикла
    SELECT MIN(employee_id) INTO emp_start
    FROM hr_poc1.Employees_copy;

    SELECT MAX(employee_id) INTO emp_end
    FROM hr_poc1.Employees_copy;

    -- проходимся по всем записям employees
    FOR i IN emp_start..emp_end LOOP
        -- получаем job_id по employee_id
        SELECT job_id into emp_job_id
        FROM hr_poc1.Employees_copy
        WHERE employee_id = i;

        -- получаем размер увеличения зарплаты по job_id
        salary_increase := 
            CASE emp_job_id
                WHEN 'IT_PROG' THEN 300
                WHEN 'MK_MAN' THEN 200
                WHEN 'MK_REP' THEN 220
                WHEN 'PR_REP' THEN 180
                WHEN 'RU_CLERK' THEN 150
                ELSE 0
            END;
        RAISE NOTICE '% % %', i,emp_job_id, salary_increase;

        -- увеличиваем зарплату 
        IF salary_increase > 0 THEN
            UPDATE hr_poc1.Employees_copy
            SET salary = salary + salary_increase
            WHERE employee_id = i;
        END IF;
    END LOOP;

    RAISE NOTICE'start % end %', emp_start, emp_end;

END \$\$
EOF
