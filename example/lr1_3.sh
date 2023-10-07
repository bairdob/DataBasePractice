#!/bin/bash
psql postgresql://bair@localhost<< EOF
DO \$$ DECLARE
   v_1   Customers%ROWTYPE;
   v_2   Customers%ROWTYPE;
   v_sum_limit numeric(10,2);
 BEGIN
    v_1.c_name:='Ivan Petrov';
    v_1.credit_limit := 200000;
    v_2.c_name:='Sergey Ivanov';
    v_2.credit_limit := 300000;
    v_sum_limit :=  v_1.credit_limit +  v_2.credit_limit;
  RAISE NOTICE 'Имя клиента 1: % % %',v_1.c_name,
               'Кредитный лимит: ', v_1.credit_limit;
  RAISE NOTICE 'Имя клиента 2: % % %', v_2.c_name,
               'Кредитный лимит: ', v_2.credit_limit;
  RAISE NOTICE 'Суммарный кредитный лимит: %', v_sum_limit;
END \$$;

EOF
