CREATE TABLE Audit_Emp_Values (
    audit_id serial PRIMARY KEY,
    change_user varchar(50) NOT NULL,
    change_timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    employee_id int4 NOT NULL,
    first_name varchar(20) NULL,
    last_name varchar(25) NOT NULL,
    old_job_id varchar(10) NOT NULL,
    new_job_id varchar(10) NOT NULL,
    old_salary numeric(10, 2) NULL,
    new_salary numeric(10, 2) NULL
);

CREATE OR REPLACE FUNCTION audit_employee_changes()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if job_id or salary is being updated
    IF NEW.job_id IS DISTINCT FROM OLD.job_id OR NEW.salary IS DISTINCT FROM OLD.salary THEN
        INSERT INTO Audit_Emp_Values (
            change_user,
            change_timestamp,
            employee_id,
            first_name,
            last_name,
            old_job_id,
            new_job_id,
            old_salary,
            new_salary
        ) VALUES (
            current_user,
            current_timestamp,
            OLD.employee_id,
            OLD.first_name,
            OLD.last_name,
            OLD.job_id,
            NEW.job_id,
            OLD.salary,
            NEW.salary
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER employee_changes_trigger
BEFORE UPDATE OF job_id, salary ON Employees
FOR EACH ROW
EXECUTE FUNCTION audit_employee_changes();

