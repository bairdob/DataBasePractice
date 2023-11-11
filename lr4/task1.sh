#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    v_email hr_poc1.Employees_copy.email%TYPE := 'UNIQUE_EMAIL';
BEGIN
    INSERT INTO hr_poc1.Employees_copy(
        employee_id, 
        first_name, 
        last_name, 
        email, 
        phone_number, 
        hire_date, 
        job_id, 
        salary, 
        commission_pct, 
        manager_id, 
        department_id, 
        rating_e)
    VALUES (0,'Lex', 'Chen', 'SKING', '515.123.1231', 
        CURRENT_DATE, 'AD_PRES', 24000.00, NULL, 100, 60, 1);

    RAISE NOTICE 'Операция успешно выполнена';
    EXCEPTION
    WHEN SQLSTATE '23505' THEN
        INSERT INTO hr_poc1.Employees_copy(
            employee_id, 
            first_name, 
            last_name, 
            email, 
            phone_number, 
            hire_date, 
            job_id, 
            salary, 
            commission_pct, 
            manager_id, 
            department_id, 
            rating_e)
        VALUES (0,'Lex', 'Chen', v_email, '515.123.1231', 
            CURRENT_DATE, 'AD_PRES', 24000.00, NULL, 100, 60, 1);
        RAISE NOTICE 'Операция выполнена, емаил изменен на %', v_email;

    END \$\$
EOF
