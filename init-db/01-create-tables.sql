-- Create BALANCE table
CREATE TABLE BALANCE (
    DATE DATE PRIMARY KEY,
    BALANCE NUMERIC
);

-- Create Transaction table
CREATE TABLE Transaction (
    ID SERIAL PRIMARY KEY,
    DATE DATE,
    AMOUNT NUMERIC,
    TYPE CHAR(1),  -- 'C' for Credit, 'D' for Debit
    RUNNING_BALANCE NUMERIC
);
