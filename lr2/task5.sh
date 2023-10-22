#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    v_order_date hr_poc1.Orders_copy.order_date%TYPE := '2018-12-14'; 
    v_add_price hr_poc1.order_items_copy.unit_price%TYPE;
    v_new_price hr_poc1.order_items_copy.unit_price%TYPE;

    price_cursor CURSOR(p_order_date hr_poc1.Orders_copy.order_date%TYPE) FOR 
    SELECT oi.order_id, oi.item_id, p.rating_p, oi.unit_price
    FROM hr_poc1.orders o
    JOIN hr_poc1.order_items_copy oi ON o.order_id = oi.order_id
    JOIN hr_poc1.products p ON oi.product_id = p.product_id
    WHERE o.order_date = p_order_date AND o.status = 'Pending';

BEGIN
    FOR v_cur_price in price_cursor(v_order_date)
    LOOP
        v_add_price := 
            CASE
                WHEN v_cur_price.rating_p < 3 THEN 0
                WHEN v_cur_price.rating_p < 5 THEN -50
                WHEN v_cur_price.rating_p = 5 THEN -100
                ELSE 0
            END;

        RAISE NOTICE 'order_id=%, item_id=%, rating=%, unit_price=%, add_price=%', 
            v_cur_price.order_id, 
            v_cur_price.item_id,
            v_cur_price.rating_p, 
            v_cur_price.unit_price, 
            v_add_price;

        --обновляем таблицу
        UPDATE hr_poc1.order_items_copy
        SET unit_price = unit_price + v_add_price
        WHERE order_id = v_cur_price.order_id AND
            item_id = v_cur_price.item_id;

    END LOOP;

    RAISE NOTICE '_______________';
    FOR v_cur_price in price_cursor(v_order_date)
    LOOP
        RAISE NOTICE 'order_id=%, item_id=%, rating=%, unit_price=%', 
            v_cur_price.order_id, 
            v_cur_price.item_id,
            v_cur_price.rating_p, 
            v_cur_price.unit_price; 
    END LOOP;

END \$\$
EOF
