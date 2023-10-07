#!/bin/bash
psql postgresql://bair@localhost<< EOF
DO \$\$
DECLARE
    v_prod_id Products_1.product_id%TYPE := 6;
    v_add_rating Products_1.rating_p%TYPE :=2;
    v_prod  Products_1%ROWTYPE; 
BEGIN
    UPDATE Products_1
    SET rating_p = rating_p + v_add_rating
    WHERE product_id = v_prod_id;

    SELECT * INTO v_prod
    FROM Products_1
    WHERE product_id = v_prod_id;

    RAISE NOTICE'product_id = %',v_prod.product_id;
    RAISE NOTICE'rating_p = %',v_prod.rating_p;
END \$\$
EOF
