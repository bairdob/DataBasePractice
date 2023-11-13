CREATE OR REPLACE FUNCTION get_top_n_products_with_max_sales(n_param int4)
RETURNS TABLE (
    product_id int4,
    product_name varchar(255),
    total_sales numeric
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.product_id,
        p.product_name,
        COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_sales
    FROM
        hr_poc1.products p
    LEFT JOIN
        hr_poc1.order_items oi ON p.product_id = oi.product_id
    GROUP BY
        p.product_id, p.product_name
    ORDER BY
        total_sales DESC
    LIMIT
        n_param;

    RETURN;
END;
$$;

