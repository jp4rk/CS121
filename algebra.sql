-- [Problem 1]
USE library;

SELECT DISTINCT A FROM R; 

-- [Problem 2]

SELECT * FROM r where B = 42;

-- [Problem 3]

SELECT * FROM r,s;

-- [Problem 4] 

SELECT DISTINCT A,F FROM r,s WHERE C = D;

-- [Problem 5]

SELECT * FROM r1 UNION SELECT * FROM r2;

-- [Problem 6]

SELECT * FROM r1 WHERE (A, B, C) IN (SELECT * FROM r2);

-- [Problem 7]

SELECT * FROM r1 WHERE (A, B, C) NOT IN (SELECT * FROM r2);

