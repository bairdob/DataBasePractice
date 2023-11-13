CREATE TABLE hr_poc1.products_audit (
    audit_id serial PRIMARY KEY,
    action VARCHAR(10) NOT NULL, -- 'INSERT' or 'DELETE'
    product_id int4,
    product_name varchar(255),
    rating_p int4,
    price numeric(10, 2),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создаем триггер для добавления записей
CREATE OR REPLACE FUNCTION products_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
  -- Вставляем данные в журнал (или другую таблицу) при добавлении новой строки
  INSERT INTO hr_poc1.products_audit (action, product_id, product_name, rating_p, price, timestamp)
  VALUES ('INSERT', NEW.product_id, NEW.product_name, NEW.rating_p, NEW.price, CURRENT_TIMESTAMP);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Привязываем триггер к событию вставки (INSERT) в таблицу Products
CREATE TRIGGER products_after_insert_trigger
AFTER INSERT ON hr_poc1.products
FOR EACH ROW
EXECUTE FUNCTION products_insert_trigger();

-- Создаем триггер для удаления записей
CREATE OR REPLACE FUNCTION products_delete_trigger()
RETURNS TRIGGER AS $$
BEGIN
  -- Вставляем данные в журнал (или другую таблицу) перед удалением строки
  INSERT INTO hr_poc1.products_audit (action, product_id, product_name, rating_p, price, timestamp)
  VALUES ('DELETE', OLD.product_id, OLD.product_name, OLD.rating_p, OLD.price, CURRENT_TIMESTAMP);
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Привязываем триггер к событию удаления (DELETE) из таблицы Products
CREATE TRIGGER products_before_delete_trigger
BEFORE DELETE ON hr_poc1.products
FOR EACH ROW
EXECUTE FUNCTION products_delete_trigger();

