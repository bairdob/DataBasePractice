#!/bin/bash
psql postgresql://bair@localhost<< EOF
DO \$\$
DECLARE
    v_emp_id Employees.employee_id%TYPE := 120;
    v_emp_salary Employees.salary%TYPE;
    v_name VARCHAR(20);
BEGIN
   SELECT salary INTO  v_emp_salary
   FROM Employees
   WHERE employee_id = v_emp_id;

   RAISE NOTICE'employee_id = %', v_emp_id;
   RAISE NOTICE'salary = %', v_emp_salary;
END \$\$
EOF
