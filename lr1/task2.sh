#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    v_emp_id hr_poc1.Employees.employee_id%TYPE:=105;
    v_emp  hr_poc1.Employees%ROWTYPE;
BEGIN
    SELECT * INTO v_emp
    FROM hr_poc1.Employees
    WHERE employee_id = v_emp_id;
    RAISE NOTICE'Имя: % %' , v_emp.first_name, v_emp.last_name;
    RAISE NOTICE'Работает в отделе: %' , v_emp.department_id;
    RAISE NOTICE'Должность: %' , v_emp.job_id;
    RAISE NOTICE'Поступил на работу: %' , TO_CHAR(v_emp.hire_date, 'DD-MON-YYYY');
    RAISE NOTICE'Зарплата: %' , CAST(v_emp.salary AS INT);
END \$\$
EOF
