#!/bin/bash
psql postgresql://bair@localhost<< EOF
DO \$\$
DECLARE
BEGIN
END \$\$
EOF
