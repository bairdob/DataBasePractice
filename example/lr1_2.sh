#!/bin/bash
psql postgresql://bair@localhost<< EOF
DO \$\$ DECLARE
   v_m_name VARCHAR(20):='Ivan Petrov';
   v_m_date_of_birth DATE:='01.09.1990';
   v_diff INTEGER;
   v_date DATE;
v_day text;
   v_time text;
BEGIN
   RAISE NOTICE 'Меня зовут: %',v_m_name;
   RAISE NOTICE 'Я родился: %', v_m_date_of_birth;
   v_date := TO_CHAR(CURRENT_DATE, 'DD-MM-YYYY');
   v_day :=  TO_CHAR(CURRENT_DATE, 'DAY');
   v_time := TO_CHAR(CURRENT_TIMESTAMP, 'HH24:MI:SS');
   v_diff := EXTRACT(year FROM AGE(v_m_date_of_birth));
   RAISE NOTICE 'Сегодня: %', v_date;
   RAISE NOTICE 'День недели: %',v_day;
   RAISE NOTICE 'Время: %',  v_time;
   RAISE NOTICE 'Мне: %', (v_diff||' года');
END \$\$;

EOF
