-- [Problem 5a]

DELIMITER ! 

-- Set the return value as around 100 times larger max 
-- in the case that the user has a lot of packages with high monthly prices.
CREATE FUNCTION monthly_pkgs_cost(username_in VARCHAR(20)) 
RETURNS NUMERIC(10, 2) DETERMINISTIC
BEGIN 
    DECLARE ans NUMERIC(8, 2);

IF username_in NOT IN (SELECT username FROM package_uses) THEN RETURN 0;
    END IF;
    
SELECT (SELECT SUM(pack_price) FROM (SELECT * FROM package_uses WHERE 
username_in = package_uses.username) NATURAL JOIN packages) INTO ans;

RETURN ans; 

END ! 

DELIMITER ; 

-- [Problem 5b]

DELIMITER ? 

CREATE PROCEDURE update_account(
    IN username_pro  VARCHAR(20),
    IN hostname_pro  VARCHAR(40),
    IN acc_type_pro  CHAR(1)
)
BEGIN

    DECLARE error1 VARCHAR(150);
    DECLARE error2 VARCHAR(150);
    DECLARE error3 VARCHAR(150);
    DECLARE error4 VARCHAR(150);
    
    -- To account for error_handling. If the error occurs,
    -- then we don't downgrade/upgrade.
    
    DECLARE error_handle BOOLEAN DEFAULT false;
    
    -- Declare new hostname to put into other account. 
    DECLARE var VARCHAR(40);
    
    SELECT CONCAT('No user found for ', username_pro) INTO error1;
    SELECT CONCAT(username_pro, ' does not have account with ',
    hostname_pro) INTO error2;
    SELECT CONCAT(username_pro, 'already has ', acc_type_pro,
    ' account for ', hostname_pro) INTO error3;
    SELECT 'Accounts can only be basic or preferred' INTO error4;
    
    IF username_pro NOT IN (SELECT username FROM accounts)
    THEN SELECT error1;
    SET error_handle = true; 
    END IF;
    
    IF hostname_pro NOT IN (SELECT hostname FROM servers 
    NATURAL JOIN pref_acc) OR hostname_pro NOT IN (SELECT hostname 
    FROM servers NATURAL JOIN basic_acc)
    THEN SELECT error2;
    SET error_handle = true; 
    END IF;
    
    -- No need to check if the username is same for pref_acc since both 
    -- hostname and username are unique 
    
    IF username_pro = (SELECT username FROM accounts NATURAL JOIN 
    basic_acc WHERE accounts.username = username_pro AND 
    accounts.acc_type = acc_type_pro AND basic_acc.hostname = hostname_pro)
    OR username_pro = (SELECT username FROM accounts NATURAL JOIN 
    pref_acc WHERE accounts.acc_type = acc_type_pro AND 
    pref_acc.hostname = hostname_pro) THEN SELECT error3;
    SET error_handle = true; 
    END IF;
    
    
    IF acc_type_pro != 'B' OR acc_type_pro != 'P' 
    THEN SELECT error4;
    SET error_handle = true; 
    END IF;
    
    -- First, we update the type from accounts, delete from the old account, 
    -- select a dedicated server, and insert into the other account. 
    
    IF acc_type_pro = 'P' AND error_handle = true THEN 
    
    UPDATE accounts SET acc_type = 'P' WHERE accounts.username = username_pro;
    
    DELETE FROM basic_acc WHERE basic_acc.username = username_pro;
    
    
    SELECT hostname INTO var FROM servers
    WHERE server_type = 'P' AND hostname NOT IN (SELECT hostname FROM pref_acc);
    
    INSERT INTO pref_acc VALUES(username_pro, var);
    
    END IF;
    
    -- First, we update the type from accounts, delete from the old account, 
    -- select a server that is not at a max capacity, and insert into 
    -- the other account.
    
    IF acc_type_pro = 'B' THEN 
    UPDATE accounts SET acc_type = 'B' WHERE accounts.username = username_pro;
    
    DELETE FROM pref_acc WHERE pref_acc.username = username_pro; 
    
    SELECT hostname INTO var FROM shared_server NATURAL JOIN servers
    GROUP BY hostname, max_sites HAVING COUNT(*) < max_sites LIMIT 1; 
    
    INSERT INTO basic_acc VALUES (username_pro, var);
    
    END IF;
    
END ? 

DELIMITER ; 


