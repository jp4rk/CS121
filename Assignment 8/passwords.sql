-- [Problem 1a]
-- This table will store thedata for this password mechanism. 
-- There are three attributes, including username, salt value,
-- and hash value of the password, or password_hash
-- note that for password_hash, there would be 
-- 64 hexadecimal characters for 256-bit encryption.

USE banking;

DROP TABLE IF EXISTS user_info;

CREATE TABLE user_info(
    username VARCHAR(20)  PRIMARY KEY,
    pw_salt  VARCHAR(20)  NOT NULL,
    password_hash  CHAR(64)  NOT NULL
);


-- [Problem 1b]
-- Create a new procedure that generates a new salt and adds a new record
--  to youruser_info table with theusername, salt, and salted password.

DROP PROCEDURE IF EXISTS sp_add_user;

DELIMITER ? 

CREATE PROCEDURE sp_add_user(
    IN new_username VARCHAR(20),
    IN password VARCHAR(20)
)
BEGIN
    DECLARE pw_salt VARCHAR(20);
    SELECT make_salt(69) INTO pw_salt;
    
    INSERT INTO user_info(
        SELECT new_username, pw_salt, SHA2(CONCAT(pw_salt, password), 256));

END ?

DELIMITER ; 
       


-- [Problem 1c]
-- Create a stored procedure that an existing user record
-- will be updated, rather than adding a new record.

DROP PROCEDURE IF EXISTS sp_change_password;

DELIMITER !

CREATE PROCEDURE sp_change_password(
    IN username VARCHAR(20),
    IN new_password VARCHAR(20)
)
BEGIN
    DECLARE new_salt_val VARCHAR(20);
    SELECT make_salt(420) INTO new_salt_val;
    
    UPDATE user_info
        SET pw_salt = new_salt_val,
        password_hash = SHA2(CONCAT(new_salt_val, new_password), 256)
        WHERE username = user_info.username;

END !

DELIMITER ; 

-- [Problem 1d]
-- Create a function that returns TINYINT basedon whether a
-- valid username andpassword have been provided. 

DROP FUNCTION IF EXISTS authenticate;

DELIMITER !

CREATE FUNCTION authenticate(username VARCHAR(20), password VARCHAR(20))
RETURNS TINYINT DETERMINISTIC
BEGIN
    DECLARE salt VARCHAR(20);
    DECLARE password_hash CHAR(64);
    
    -- Checks if username is not in the database
    
    IF username NOT IN (SELECT username FROM user_info) THEN RETURN 0;
    END IF;
    
    -- Since we know username is in the database due to above if condition
    -- statement, we get the salt and password_hash from the database
    
    SELECT user_info.pw_salt, user_info.password_hash INTO salt, password_hash
    FROM user_info WHERE user_info.username = username;
    -- Return true if the SHA2 of concatenated salt and password value
    -- matches password_hash.
    
    IF SHA2(CONCAT(salt, password), 256) = password_hash THEN RETURN 1; 
    ELSE RETURN 0; 
    END IF;    
END !

DELIMITER ; 


