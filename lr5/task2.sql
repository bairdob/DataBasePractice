CREATE OR REPLACE PROCEDURE hr_poc1.update_credit_limit(
    IN p_summ_min NUMERIC,
    IN p_summ_max NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_customer_id INT;
    v_summ NUMERIC;
    v_credit_limit NUMERIC;
BEGIN
    -- Перебираем клиентов и обновляем кредитные лимиты в соответствии с условиями
    FOR v_customer_id, v_summ IN (
        SELECT
            c.customer_id,
            COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_amount
        FROM
            hr_poc1.customers c
        LEFT JOIN
            hr_poc1.orders o ON c.customer_id = o.customer_id
        LEFT JOIN
            hr_poc1.order_items oi ON o.order_id = oi.order_id
        GROUP BY
            c.customer_id
    )
    LOOP
        -- Получаем текущий кредитный лимит для клиента
        SELECT credit_limit INTO v_credit_limit
        FROM hr_poc1.customers
        WHERE customer_id = v_customer_id;
         RAISE NOTICE 'Customer ID %: Cумма продаж=%', v_customer_id, v_summ;

        -- Обновляем кредитный лимит в зависимости от условий
        IF v_summ > p_summ_max THEN
            UPDATE hr_poc1.customers
            SET credit_limit = v_credit_limit * 1.1
            WHERE customer_id = v_customer_id;
            RAISE NOTICE 'Customer ID %: Кредитный лимит повышен.', v_customer_id;
        ELSIF v_summ < p_summ_min THEN
            UPDATE hr_poc1.customers
            SET credit_limit = v_credit_limit * 0.9
            WHERE customer_id = v_customer_id;
            RAISE NOTICE 'Customer ID %: Кредитный лимит уменьшен.', v_customer_id;
        END IF;
    END LOOP;
END;
$$;

