-- [Problem 4a]
SELECT hostname FROM basic_acc NATURAL JOIN servers 
    GROUP BY hostname, max_sites HAVING COUNT(*) > max_sites;

-- [Problem 4b]
UPDATE accounts SET sub_price = sub_price - 2 
WHERE acc_type = 'B' AND (SELECT COUNT(*) 
FROM accounts NATURAL JOIN package_uses) >= 3;

