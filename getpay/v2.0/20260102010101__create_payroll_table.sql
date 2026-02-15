-- PATCH_ID: 20260102010101__create_payroll_table
-- PATCH_TYPE: SCHEMA
-- SNAPSHOT_TABLES: payroll, payroll_details

-- Create payroll table
CREATE TABLE payroll (
    payroll_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES employees(employee_id),
    pay_period_start DATE NOT NULL,
    pay_period_end DATE NOT NULL,
    gross_pay DECIMAL(10, 2) NOT NULL CHECK (gross_pay >= 0),
    deductions DECIMAL(10, 2) DEFAULT 0,
    net_pay DECIMAL(10, 2) NOT NULL CHECK (net_pay >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    paid_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create payroll details table
CREATE TABLE payroll_details (
    detail_id SERIAL PRIMARY KEY,
    payroll_id INTEGER NOT NULL REFERENCES payroll(payroll_id) ON DELETE CASCADE,
    item_type VARCHAR(20) NOT NULL CHECK (item_type IN ('earning', 'deduction')),
    item_name VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL
);

COMMENT ON TABLE payroll IS 'Employee payroll records';
COMMENT ON TABLE payroll_details IS 'Detailed breakdown of payroll items';