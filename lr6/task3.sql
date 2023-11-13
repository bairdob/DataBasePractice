CREATE OR REPLACE FUNCTION update_quantity_on_duplicate()
RETURNS TRIGGER AS $$
BEGIN
    -- Проверка наличия записи с указанным order_id и product_id
    IF EXISTS (
        SELECT 1
        FROM hr_poc1.order_items
        WHERE order_id = NEW.order_id AND product_id = NEW.product_id
    ) THEN
        -- Если запись существует, обновить значение столбца quantity
        UPDATE hr_poc1.order_items
        SET quantity = quantity + NEW.quantity
        WHERE order_id = NEW.order_id AND product_id = NEW.product_id;
        
        -- Прервать вставку новой строки
        RETURN NULL;
    END IF;
    
    -- В противном случае, разрешить вставку новой строки
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера, связанного с функцией
CREATE TRIGGER check_duplicate_and_update
BEFORE INSERT ON hr_poc1.order_items
FOR EACH ROW
EXECUTE FUNCTION update_quantity_on_duplicate();

