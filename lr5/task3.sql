CREATE OR REPLACE FUNCTION has_employee_sold_product(p_employee_id INT, p_product_id INT)
RETURNS INT AS
$$
DECLARE
    sale_count INT;
BEGIN
    -- Проверка, осуществлял ли сотрудник продажи товара с заданным номером
 SELECT COUNT(*) into sale_count from (
  SELECT o.salesman_id as salesman_id, oi.product_id as product_id
  FROM hr_poc1.orders o
  JOIN hr_poc1.order_items oi ON o.order_id = oi.order_id)
 WHERE salesman_id = p_employee_id AND product_id = p_product_id;

    -- Возвращаем 1, если есть продажи, и 0 в противном случае
    RETURN CASE WHEN sale_count > 0 THEN 1 ELSE 0 END;
END;
$$
LANGUAGE plpgsql;

