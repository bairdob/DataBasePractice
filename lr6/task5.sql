CREATE OR REPLACE FUNCTION prevent_table_deletion()
RETURNS TRIGGER AS $$
DECLARE
    current_time TIME;
BEGIN
    -- Получение текущего времени
    SELECT current_time INTO current_time;

    -- Проверка времени (запрет удаления после 18:00)
    IF current_time >= '18:00:00' THEN
        RAISE EXCEPTION 'Запрещено удалять таблицы после 18:00.';
    ELSE
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Привязка триггера ко всем таблицам в схеме hr_poc1
DO $$ 
DECLARE 
    table_name text;
BEGIN 
    FOR table_name IN (SELECT table_name FROM information_schema.tables WHERE table_schema = 'hr_poc1') 
    LOOP 
        EXECUTE 'CREATE TRIGGER prevent_table_deletion_trigger BEFORE DROP ON hr_poc1.' || table_name || ' FOR EACH STATEMENT EXECUTE FUNCTION prevent_table_deletion();'; 
    END LOOP; 
END $$;

