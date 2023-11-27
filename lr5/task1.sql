CREATE OR REPLACE PROCEDURE hr_poc1.increase_product_rating(IN p_sum_sal numeric)
AS $procedure$
DECLARE
    v_product_id hr_poc1.order_items_copy.product_id%TYPE;
    v_total_sales numeric;
    cur_product CURSOR FOR
        SELECT product_id, SUM(quantity * unit_price) AS total_sales
        FROM hr_poc1.order_items_copy
        GROUP BY product_id; 
BEGIN
    OPEN cur_product;
    LOOP
        FETCH cur_product INTO v_product_id, v_total_sales;
        EXIT WHEN NOT FOUND;

        RAISE NOTICE 'Processing product_id: %, total_sales = %', v_product_id, v_total_sales;

        IF v_total_sales > p_sum_sal then
            RAISE NOTICE 'Rating increased by 1';
            UPDATE hr_poc1.products_copy
            SET rating_p = rating_p + 1
            WHERE rating_p < 5 AND product_id=v_product_id;
        END IF;
    END LOOP;
    CLOSE cur_product;
END $procedure$ LANGUAGE 'plpgsql';  
