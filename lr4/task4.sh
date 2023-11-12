#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    v_rating_p hr_poc1.Products.rating_p%TYPE := 0;
BEGIN
    INSERT INTO hr_poc1.products(
        product_id, product_name, rating_p, price)
    VALUES(87, 'super_fruit', v_rating_p, 10);

    EXCEPTION
    WHEN SQLSTATE '23514' THEN
        v_rating_p = v_rating_p + 1;

        INSERT INTO hr_poc1.products(
            product_id, product_name, rating_p, price)
        VALUES(87, 'super_fruit', v_rating_p, 10);
        
        RAISE NOTICE 'Операция выполнена, rating_p увеличен на 1, rating_p=%', 
            v_rating_p;

    END \$\$;
EOF
