-- [Problem 1a]
-- Create a view called ​stonewell_customers​ containing the account
-- numbers and customernames (but not the balances) for all accounts 
-- at the Stonewell branch.

CREATE VIEW stonewell_customer AS
    SELECT account_number, customer_name 
    FROM account NATURAL JOIN depositor 
    WHERE branch_name = 'Stonewell';

-- [Problem 1b]
-- Create aview called ​onlyacct_customers​ containing the name, street, 
-- and city of all customerswho have an account with the bank,
-- but do not have a loan

CREATE VIEW onlyacct_customer AS
    SELECT customer_name, customer_street, customer_city
    FROM customer WHERE customer_name NOT IN
    (SELECT customer_name FROM borrower) AND customer_name 
    IN (SELECT customer_name FROM depositor);

-- [Problem 1c]
-- Create a view called ​branch_deposits​ that lists all branches in the
--  bank, along with the totalaccount balance of each branch, and the 
-- average account balance of each branch

CREATE OR REPLACE VIEW branch_deposits (branches, 
    total_acc_balance, avg_acc_balance) 
    AS SELECT branch_name, IFNULL(SUM(balance), 0), AVG(balance) 
    FROM branch NATURAL LEFT JOIN account GROUP BY branch_name;
    
    


