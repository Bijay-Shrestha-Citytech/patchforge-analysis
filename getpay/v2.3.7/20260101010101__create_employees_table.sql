-- PATCH_ID: 20260101010101__create_employees_table
-- PATCH_TYPE: DATA
-- SNAPSHOT_TABLES: employees

-- Create employees table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_code VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department VARCHAR(50),
    position VARCHAR(50),
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2) NOT NULL CHECK (salary >= 0),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE employees IS 'Employee master data';
