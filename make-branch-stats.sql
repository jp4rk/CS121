-- [Problem 1]
-- Write the index definition.

CREATE INDEX idx_account ON account(branch_name, balance);

-- [Problem 2]
-- Write the table definition for the 
-- materialized results  ​mv_branch_account_stats

CREATE TABLE mv_branch_account_stats (
    branch_name VARCHAR(15) PRIMARY KEY,
    num_accounts INT NOT NULL, 
    total_deposits NUMERIC(12, 2) NOT NULL,
    min_balance NUMERIC(12, 2) NOT NULL,
    max_balance NUMERIC(12, 2) NOT NULL
); 
    

-- [Problem 3]
-- Write the initial SQL DML statement to populate the
-- materialized view tablemv_branch_account_stats​.

INSERT INTO mv_branch_account_stats (
    SELECT branch_name, COUNT(*), SUM(balance), MIN(balance), MAX(balance) 
    FROM account GROUP BY branch_name);


-- [Problem 4]
-- Write the view definition for ​branch_account_stats​, ​
-- using the column names specified​
-- Creates a materialized view that also includes average of 
-- balance to increase efficiency and speed 

CREATE VIEW branch_account_stats AS
    SELECT 
        branch_name,
        num_accounts,
        total_deposits,
        (total_deposits / num_accounts) AS avg_balance,
        min_balance,
        max_balance
    FROM
        mv_branch_account_stats;

-- [Problem 5]
-- Write the trigger (and related procedures) to handle inserts.

DELIMITER ?

CREATE PROCEDURE pro_inserts (
    IN branch_name_ins VARCHAR(15),
    IN curr NUMERIC(12, 2) 
)
BEGIN
    IF branch_name_ins NOT IN (SELECT branch_name 
    FROM mv_branch_account_stats)
    THEN INSERT INTO mv_branch_account_stats 
        VALUES (branch_name_ins, 1, curr, curr, curr);
	
    ELSE
        UPDATE mv_branch_account_stats
        SET num_accounts = num_accounts + 1,
        total_deposits = total_deposits + curr,
        min_balance = LEAST(min_balance, curr),
        max_balance = GREATEST(max_balance, curr)
        WHERE branch_name = branch_name_ins;
    END IF;

END ? 

    
CREATE TRIGGER trig_insert AFTER INSERT ON account 
FOR EACH ROW 
BEGIN
    CALL pro_inserts (NEW.branch_name, NEW.balance);
END ?

DELIMITER ;

-- [Problem 6]
-- Write the trigger (and related procedures) to handle deletes.


DELIMITER ! 

CREATE PROCEDURE pro_deletes_min_max (
    IN branch_name_del VARCHAR(15),
    IN curr NUMERIC(12, 2) 
)

BEGIN 
    IF curr = LEAST(min_balance, curr)
    THEN UPDATE mv_branch_account_stats 
    SET min_balance = (SELECT MIN(balance) FROM account
    WHERE branch_name = branch_name_del) WHERE branch_name = branch_name_del;
    
    ELSEIF curr = GREATEST(max_balance, curr)
    THEN UPDATE mv_branch_account_stats 
    SET max_balance = (SELECT MAX(balance) FROM account
    WHERE branch_name = branch_name_del) WHERE branch_name = branch_name_del;
    END IF;

END !


CREATE PROCEDURE pro_deletes (
    IN branch_name_del VARCHAR(15),
    IN curr NUMERIC(12, 2) 
)
BEGIN
     DELETE FROM mv_branch_stats WHERE branch_name = branch_name_del
     AND num_accounts = 1; 
     
     IF branch_name_del IN (SELECT branch_name FROM mv_branch_account_stats)
     THEN UPDATE mv_branch_account_stats 
     SET num_accounts = num_accounts + 1,
     total_deposits = total_deposits - curr
     WHERE branch_anme = branch_name_del;
     
     CALL pro_deletes_min_max(branch_name_del, curr);
     END IF;
     
END !

CREATE TRIGGER trig_delete AFTER DELETE ON account 
FOR EACH ROW
BEGIN
    CALL pro_deletes(OLD.branch_name, OLD.balance);

END ! 

DELIIMITER ;
     


-- [Problem 7]
-- Write the trigger (and related procedures) to handle updates.

DELIMITER ?
-- Didn't realize that I would have to make a separate procedure 
-- for updating new min/max, so created another procedure that 
-- accounts for newly changed min/max balance for insertion.

CREATE PROCEDURE pro_inserts_min_max (
    IN branch_name_ins VARCHAR(15),
    IN curr NUMERIC(12, 2) 
)
BEGIN
    
    IF curr = LEAST(min_balance, curr)
    THEN UPDATE mv_branch_account_stats 
    SET min_balance = curr WHERE branch_name = branch_name_del;
    
    ELSEIF curr = GREATEST(max_balance, curr)
    THEN UPDATE mv_branch_account_stats 
    SET max_balance = curr WHERE branch_name = branch_name_del;
    END IF;

END ? 

CREATE TRIGGER trig_update AFTER UPDATE ON account FOR EACH ROW
BEGIN
    IF OLD.branch_name = NEW.branch_name THEN 
        UPDATE mv_branch_account_stats 
            SET total_deposits = total_deposits - OLD.balance + NEW.balance
            WHERE branch_name = NEW.branch_name;
		
        CALL pro_inserts_min_max(NEW.branch_name, NEW.balance);
        CALL pro_deletes_min_max(OLD.branch_name, OLD.balance);
	
    ELSE 
        CALL pro_inserts(NEW.branch_name, NEW.balance);
        CALL pro_deletes(OLD.branch_name, OLD.balance);
	
    END IF;
END ?

DELIMITER ;
    


