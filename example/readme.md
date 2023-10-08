# Листинг3
```sql
CREATE TABLE Customers (
    c_name VARCHAR(255),
    credit_limit DECIMAL(10, 2)
);
```

# Листинг4,5
```sql
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    salary DECIMAL(10, 2),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    position VARCHAR(255),
    hired DATE,
    job_id INT        
);
```

```sql
INSERT INTO Employees (employee_id, salary, first_name, last_name, position, hired,job_id)
VALUES (105, 5280.00, 'David', 'Austin', 'IT_PROG', '1997-06-25' , 60);
```

```sql
INSERT INTO Employees (employee_id, salary, first_name, last_name, position, hired,job_id)
VALUES (1, 51280.00, 'Bruce', 'Lee', 'IT_PROG', '1997-06-25' , 30);

INSERT INTO Employees (employee_id, salary, first_name, last_name, position, hired,job_id)
VALUES (2, 15280.00, 'Connor', 'Gregor', 'IT_PROG', '1997-06-25' , 30);
```


# Листинг6
```sql
CREATE TABLE Products_1 (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    rating_p INT
);
INSERT INTO Products_1 (product_id, product_name, rating_p)
VALUES (6, 'Example Product', 4);
```
