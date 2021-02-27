-- [Problem 0]
-- 1) As shown in slide 40 of lecture 3, we know that the 
-- float and double doesn't represent the base 10 properly. In other 
-- words, by using either float or double, it might lead to miscalculation,
--  or the value that is slightly off. If this accumulates, this could 
-- lead to significant bank balance error. 
-- 2) We could represent account_number with a type differnet than VARCHAR, 
-- since conventional account number has fixed lengths and different 
-- numeric combinations. Using char will prevent from fragmentation. 

USE banking;

-- [Prolem 1a]
-- Retrieve the loan-numbers and amounts of loans with amounts 
-- of at least $1000, and at most $2000.
SELECT loan_number, amount FROM loan WHERE amount BETWEEN 1000 AND 2000;


-- [Prolem 1b]
-- Retrieve the loan-number and amount of all loans owned by Smith.  
-- Order the results byincreasing loan #.

SELECT loan_number, amount FROM loan NATURAL JOIN borrower 
    WHERE customer_name = 'Smith' ORDER BY loan_number;
    
-- [Problem 1c]
-- Retrieve the city of the branch where account A-446 is open.

SELECT branch_city FROM branch NATURAL JOIN account 
    WHERE account_number = 'A-446';

    
-- [Problem 1d]
-- Retrieve the customer name, account number, branch name, and
-- balance, of accounts owned by customers whose names start with “J”.

SELECT customer_name, account_number, branch_name, balance 
    FROM account NATURAL JOIN depositor
    WHERE customer_name LIKE 'J%' ORDER BY customer_name;
    
-- [Problem 1e]
-- Retrieve the names of all customers with more than five bank accounts.

SELECT customer_name FROM depositor NATURAL JOIN account 
    GROUP BY customer_name HAVING COUNT(account_number) > 5; 

-- [Problem 2a]
-- Generate a list of all cities that customers live in, where 
-- there is no bank branch in that city.

SELECT DISTINCT customer_city FROM customer WHERE customer_city NOT in 
    (SELECT branch_city FROM branch) ORDER BY customer_city; 

-- [Problem 2b]
-- Write a SQL query thatreports the name of any customers that 
-- have neither an account nor a loan. 

SELECT customer_name FROM customer WHERE customer_name 
    NOT IN (SELECT customer_name FROM borrower)
    AND customer_name NOT IN (SELECT customer_name FROM depositor);

-- [Problem 2c]
-- The bank decides to promote its branches located in the city of 
-- Horseneck, so it wants to make a $75 gift-deposit into all accounts 
-- held at branches in the city of Horseneck.  Write the SQLUPDATE​ 
-- command for performing this operation.

SET SQL_SAFE_UPDATES = 0;
UPDATE account
    SET balance = balance + 75
    WHERE branch_name IN (SELECT branch_name FROM branch 
    WHERE branch_city = 'Horseneck');
SET SQL_SAFE_UPDATES = 1;

-- [Problem 2d]
-- Write another answerto part c, using different syntax.
SET SQL_SAFE_UPDATES = 0;
UPDATE account, branch SET account.balance = account.balance + 75
    WHERE account.branch_name = branch.branch_name 
    AND branch.branch_city = 'Horseneck';
SET SQL_SAFE_UPDATES = 1;

-- [Problem 2e]
-- Retrieve all details (​account_number​, ​branch_name​,
-- balance​) for the largest account at each branch.
-- Implement this query as a join against a derived 
-- relation in the ​FROM​ clause.

SELECT account_number, branch_name, balance FROM 
    account NATURAL JOIN (select branch_name, MAX(balance) AS balance
    FROM account GROUP BY branch_name) AS max;
    
-- [Problem 2f]
-- Implement the same query as in the previous problem, this time using
-- an ​IN​ predicate withmultiple columns.

SELECT account_number, branch_name, balance FROM account 
    WHERE (branch_name, balance) IN (SELECT branch_name, MAX(balance) 
    FROM account GROUP BY branch_name);

-- [Problem 3]
-- Compute the rank of all bank branches, based on the 
-- amount of assets that each branch holds.

SELECT branch_name, assets, COUNT(*) AS 'rank' FROM 
    (SELECT a.branch_name, a.assets FROM branch a, branch b 
    WHERE a.assets < b.assets 
    OR a.branch_name = b.branch_name) AS x 
    GROUP BY branch_name, assets ORDER BY COUNT(*), branch_name;
