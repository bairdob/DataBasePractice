CREATE OR REPLACE FUNCTION hr_poc1.prevent_table_deletion()
 RETURNS EVENT_TRIGGER
 LANGUAGE plpgsql
AS $function$
DECLARE
    current_time TIME;
    v_type text;
    v_name text;
BEGIN
    SELECT object_name, object_type into v_name,v_type
    FROM pg_event_trigger_dropped_objects();
    
    SELECT current_time INTO current_time;

    IF v_type = 'table' AND current_time >= '18:00:00' then
        RAISE EXCEPTION 'Запрещено удалять таблицы после 18:00.';
    END IF;
END;
$function$;

CREATE EVENT TRIGGER prevent_table_deletion_trigger
ON SQL_DROP
EXECUTE FUNCTION prevent_table_deletion();
