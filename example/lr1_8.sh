#!/bin/bash
psql postgresql://bair@localhost<< EOF
DO \$\$
DECLARE
    v_sum_sal numeric(10,2):=900000;
    v_bonus   numeric(10,2);
BEGIN

    IF v_sum_sal > 1000000
    THEN
       v_bonus := 50000;
    ELSE
       v_bonus :=0;
    END IF;
    RAISE NOTICE'v_sum_sal = %',v_sum_sal;
    RAISE NOTICE'v_bonus = %',v_bonus;
END \$\$
EOF
