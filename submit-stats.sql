-- [Problem 1]
-- The function takes an ​INT​ argument specifying the ID 
-- of the submission being investigated.  The return-value 
-- should be the result inseconds. Returns INT.

-- Didn't set up default value for ans as 0 since this would make 
-- min value 0 almost everytime (unless negative value pops up).
-- Thus, we add check if the ans is null for the initial state
-- (since it starts off with having a null value). 

DROP FUNCTION min_submit_interval;

DELIMITER !

CREATE FUNCTION min_submit_interval (sub_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ans INT; 
    DECLARE curr INT;
    DECLARE init_sub_date INT; 
    DECLARE final_sub_date INT;
    DECLARE done TINYINT DEFAULT 0; 
        
    DECLARE cur CURSOR FOR 
        SELECT UNIX_TIMESTAMP(sub_date) FROM fileset 
            WHERE fileset.sub_id = sub_id
            ORDER BY sub_date; 
            
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;
    
    OPEN cur;
    WHILE NOT done DO
        FETCH cur INTO init_sub_date;
        WHILE NOT done DO
            FETCH cur INTO final_sub_date;
            IF NOT done THEN
                SET curr = final_sub_date - init_sub_date;
                IF ISNULL(ans) OR curr < ans THEN 
                    SET ans = curr; 
                END IF; 
                SET init_sub_date = final_sub_date; 
                END IF;
             END WHILE;
         END WHILE;
    CLOSE cur;
    
    RETURN ans;
END !

DELIMITER ;
                
                
-- [Problem 2]
-- The function takes an ​INT​ argument specifying the ID 
-- of the submission being investigated.  The return-value 
-- should be the result inseconds. Returns INT.
-- Setting default as 0 for ans so that ISNULL function is not
-- needed for the if statement.

DROP FUNCTION max_submit_interval;

DELIMITER ! 

CREATE FUNCTION max_submit_interval (sub_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ans INT DEFAULT 0; 
    DECLARE curr INT;
    DECLARE init_sub_date INT; 
    DECLARE final_sub_date INT;
    DECLARE done TINYINT DEFAULT 0; 
    
    DECLARE cur CURSOR FOR 
        SELECT UNIX_TIMESTAMP(sub_date) FROM fileset 
        WHERE fileset.sub_id = sub_id
            ORDER BY sub_date; 
            
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;
    
    OPEN cur;
    WHILE NOT done DO
        FETCH cur INTO init_sub_date;
        WHILE NOT done DO
            FETCH cur INTO final_sub_date;
            IF NOT done THEN
                SET curr = final_sub_date - init_sub_date;
                IF curr > ans THEN 
                    SET ans = curr;
                END IF; 
                SET init_sub_date = final_sub_date; 
             END IF;
         END WHILE;
    END WHILE;
    CLOSE cur;
    
    RETURN ans;
END !

DELIMITER ;
                

-- [Problem 3]
-- The function takes an ​INT​ argument specifying the ID 
-- of the submission being investigated.  The return-value 
-- should be the result inseconds. Returns DOUBLE.

DROP FUNCTION avg_submit_interval;

DELIMITER ! 

CREATE FUNCTION avg_submit_interval(sub_id INT) RETURNS DOUBLE DETERMINISTIC
BEGIN
    RETURN (SELECT (UNIX_TIMESTAMP(MAX(sub_date)) - 
        UNIX_TIMESTAMP(MIN(sub_date))) / (COUNT(*) - 1)
    FROM fileset WHERE fileset.sub_id = sub_id);
	
END ! 

DELIMITER ; 

-- [Problem 4]
-- Create an index on ​fileset​ thatwill dramatically speed up the query.
-- Duration time from 1.123 to 0.164 sec. 

DROP INDEX idx_fileset ON fileset;
 
CREATE INDEX idx_fileset ON fileset(sub_id, sub_date);

