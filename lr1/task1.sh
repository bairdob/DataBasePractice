#!/bin/bash
psql postgresql://postgres@localhost<< EOF
DO \$\$
DECLARE
    v_name VARCHAR(255);
    v_date DATE;
    v_date_of_birth DATE;
    v_age INT;
    v_fname VARCHAR(255);
    v_lname VARCHAR(255);
    v_diff INTEGER;
BEGIN 
    v_date := '2023-03-29';
    v_date_of_birth := '1972-04-20';
    v_fname := 'Ivan';
    v_lname := 'Petrov';
    v_name := v_fname || ' ' || v_lname;
    v_diff := EXTRACT(year FROM AGE(v_date_of_birth));
    RAISE notice 'Сегодня: %', TO_CHAR(v_date, 'DD-MON-YYYY');
    RAISE notice 'Мое имя: %', v_fname;
    RAISE notice 'Моя фамилия: %', v_lname;
    RAISE notice 'Я родился: %', TO_CHAR(v_date_of_birth, 'DD-MM-YYYY');
    RAISE notice 'Мне: %', (v_diff || ' год');

END \$\$
EOF
