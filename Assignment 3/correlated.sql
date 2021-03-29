-- [Problem a]
-- This query counts the number of loands for each
-- customer, arranged by descending order of number of
-- loans (highest to lowest) 

USE banking;

SELECT customer_name, COUNT(loan_number) as num_loans
    FROM customer NATURAL LEFT JOIN borrower 
    GROUP BY customer_name ORDER BY num_loans DESC;

-- [Problem b] 
-- This query finds all the branch names where the 
-- sum of the loan is greater than its asset 

SELECT branch_name FROM (SELECT branch_name, assets, SUM(amount)
    AS total_amount FROM branch NATURAL JOIN loan 
    GROUP BY branch_name) AS temp 
    WHERE assets < total_amount;
    
-- [Problem c] 
-- Write a SQL query that computes thenumber of accounts 
-- and the number of loans at each branch
SELECT branch_name, 
    (SELECT COUNT(*) FROM account as a
    WHERE b.branch_name = a.branch_name) AS num_accounts,
    (SELECT COUNT(*) FROM loan as l
    WHERE b.branch_name = l.branch_name) AS num_loans
    FROM branch as b ORDER by branch_name;

-- [Problem d]
-- Create a decorrelated version of the previous query.

SELECT branch_name, COUNT(DISTINCT account_number) AS num_accounts, 
    COUNT(DISTINCT loan_number) AS num_loans 
    FROM branch NATURAL LEFT JOIN account NATURAL LEFT JOIN loan
    GROUP BY branch_name ORDER BY branch_name;
    
    

