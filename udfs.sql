-- [Problem 1a]
-- Write a user-defined function named ​is_weekend​ 
-- that takes a ​DATE​ value and returns a TINYINT​. 
-- Set the "end of statement" character to ! so that
-- semicolons in the function body won't confuse MySQL.
-- Given a date value, returns 1 if it is a weekend,
-- or 0 if it is a weekday.

DELIMITER !

CREATE FUNCTION is_weekend(d DATE) RETURNS TINYINT DETERMINISTIC
BEGIN
    DECLARE day INT DEFAULT WEEKDAY(d);
    DECLARE ans INT DEFAULT 0;
    IF day >= 5 THEN
        SET ans = 1;
    END IF;
    RETURN ans;
END !

DELIMITER ;

-- [Problem 1b]
-- Function name is" is_holiday​", which takes an argument "d" of type DATE
-- that returns a VARCHAR(30). The function serves to describe which 
-- holiday it is. 

DELIMITER !

CREATE FUNCTION is_holiday(d DATE) RETURNS VARCHAR(30) DETERMINISTIC
BEGIN
    DECLARE holiday VARCHAR(30) DEFAULT NULL;
    DECLARE month INT DEFAULT EXTRACT(MONTH FROM d);
    DECLARE day INT DEFAULT WEEKDAY(d);
    DECLARE date INT DEFAULT EXTRACT(DAY FROM d);
    
    IF month = 1 AND date = 1 THEN
        SET holiday = 'New Year\'s Day';
    END IF;
    
    IF month = 5 AND day = 0 AND date BETWEEN 25 AND 31 THEN
        SET holiday = 'Memorial Day';
    END IF;
    
    IF month = 7 AND date = 4 THEN
        SET holiday = 'Independence Day';
    END IF;
    
    IF month = 9 AND day = 0 AND date BETWEEN 1 AND 7 THEN
        SET holiday = 'Labor Day';
    END IF;
    
    IF month = 11 AND day = 3 AND date BETWEEN 22 AND 28 THEN
        SET holiday = 'Thanksgiving';
    END IF;
    
    RETURN holiday;
    
    END !

DELIMITER ;


-- [Problem 2a]
-- Write a query that reports how many filesets were submitted
-- on the various holidaysrecognized by your ​is_holiday()​ function.

SELECT is_holiday(DATE(sub_date)) AS Holiday, COUNT(*) AS num_holiday 
FROM fileset 
GROUP BY is_holiday(DATE(sub_date));


-- [Problem 2b]
-- Write another query that reports how many filesets were
-- submitted on a weekend, and howmany were not submitted on a weekend. 

SELECT CASE WHEN is_weekend(sub_date) = 0 THEN 'weekday' ELSE 'weekend' END
    AS type_of_day, COUNT(*) AS num_weekends FROM fileset
    GROUP BY type_of_day;

