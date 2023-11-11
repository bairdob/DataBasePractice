#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    v_customer_id hr_poc1.Customers.customer_id%TYPE = 2;
    v_customer_id_real hr_poc1.Customers.customer_id%TYPE;
    v_salesman_id hr_poc1.Employees_copy.employee_id%TYPE := 1;
    v_salesman_id_real hr_poc1.Orders_copy.salesman_id%TYPE;
BEGIN
    SELECT customer_id INTO v_customer_id_real
    FROM hr_poc1.Customers 
    WHERE customer_id = v_customer_id;
    RAISE NOTICE 'v_customer_id_real= %', v_customer_id_real;

    -- обрабатываем отсутствие целостности ключа вручную
    IF v_customer_id_real IS NULL THEN
        RAISE EXCEPTION USING ERRCODE = 23503;
    END IF;

    SELECT employee_id INTO v_salesman_id_real
    FROM hr_poc1.Employees_copy 
    WHERE employee_id = v_salesman_id;
    RAISE NOTICE 'v_salesman_id_real= %', v_salesman_id_real;

    -- если employee_id не существует, тогда salesman_id = NULL
    IF v_salesman_id_real IS NULL THEN
        INSERT INTO hr_poc1.orders_copy(
            order_id, customer_id, status, salesman_id, order_date)
        VALUES(0, v_customer_id_real, 'Pending', NULL, CURRENT_DATE);
        RAISE NOTICE 'Операция выполнена, salesman_id изменен на NULL';
    END IF;


    EXCEPTION
    WHEN SQLSTATE '23503' THEN
        RAISE NOTICE 'Операция отклонена, есть нарушение целостности данных';

    END \$\$
EOF
