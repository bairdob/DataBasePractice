#!/bin/bash
psql postgresql://bair@localhost<< EOF
DO \$\$
DECLARE
    v_emp_id Employees.employee_id%TYPE := 120;
    v_emp  Employees%ROWTYPE;
BEGIN
    SELECT * INTO v_emp
    FROM Employees
    WHERE employee_id = v_emp_id;

    RAISE NOTICE'% % % % %' , v_emp.employee_id, v_emp.first_name, v_emp.last_name, v_emp.job_id, v_emp.salary;
END \$\$
EOF
