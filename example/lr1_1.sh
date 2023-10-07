#!/bin/bash
psql postgresql://bair@localhost<< EOF
DO \$\$
DECLARE
    v_f_name VARCHAR(10);
    v_l_name VARCHAR(10);
    v_name VARCHAR(20);
BEGIN
    v_f_name := 'Ivan';
    v_l_name := 'Petrov';
    v_name := v_f_name || ' ' || v_l_name;
    RAISE notice 'Меня зовут %', v_name;
END \$\$
EOF
