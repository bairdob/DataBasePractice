CREATE OR REPLACE FUNCTION check_item_count()
RETURNS TRIGGER AS $$
DECLARE
    item_count INTEGER;
BEGIN
    -- Подсчет количества разных товаров в заказе
    SELECT COUNT(DISTINCT item_id)
    INTO item_count
    FROM hr_poc1.order_items
    WHERE order_id = NEW.order_id;

    -- Проверка на количество разных товаров
    IF item_count >= 5 THEN
        RAISE EXCEPTION 'Один заказ не может содержать более 5 разных товаров.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Привязка триггера к таблице order_items
CREATE TRIGGER enforce_item_count_constraint
BEFORE INSERT
ON hr_poc1.order_items
FOR EACH ROW
EXECUTE FUNCTION check_item_count();

