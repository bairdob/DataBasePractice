CREATE OR REPLACE PROCEDURE hr_poc1.increase_product_rating(IN p_sum_sal numeric)
AS $procedure$
DECLARE
    v_product_id hr_poc1.order_items_copy.product_id%TYPE;
    cur_product CURSOR FOR
        SELECT DISTINCT product_id
        FROM hr_poc1.order_items_copy
        WHERE quantity * unit_price > p_sum_sal;
begin
	OPEN cur_product;
    LOOP
        FETCH cur_product INTO v_product_id;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Processing product_id: %', v_product_id;
        UPDATE hr_poc1.products_copy
    	  SET rating_p = rating_p + 1
    	  WHERE rating_p < 5 AND product_id=v_product_id;
    END LOOP;
    CLOSE cur_product;
END $procedure$ LANGUAGE 'plpgsql'; 

