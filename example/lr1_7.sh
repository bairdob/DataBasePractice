#!/bin/bash
psql postgresql://bair@localhost<< EOF
DO \$\$
DECLARE
    v_prod_id Products_1.product_id%type := 6;
BEGIN
DELETE FROM Products_1
    WHERE RATING_P = (SELECT rating_p FROM Products_1 WHERE product_id = v_prod_id);
END \$\$
EOF
