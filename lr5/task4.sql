CREATE OR REPLACE FUNCTION get_total_sales(product_id_param int4, start_date_param date, end_date_param date)
RETURNS numeric
LANGUAGE plpgsql
AS $$
DECLARE
    total_sales numeric := 0;
BEGIN
    SELECT COALESCE(SUM(oi.quantity * oi.unit_price), 0)
    INTO total_sales
    FROM hr_poc1.orders o
    JOIN hr_poc1.order_items oi ON o.order_id = oi.order_id
    WHERE oi.product_id = product_id_param
        AND o.order_date BETWEEN start_date_param AND end_date_param;

    RETURN total_sales;
END;
$$;

