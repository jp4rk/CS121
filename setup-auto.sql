-- [Problem 1]

-- Cleaning up old tables. Note that tables containing foreign keys are
-- dropped first for the sake of referential integrity constraints.
CREATE DATABASE IF NOT EXISTS autodb;
USE autodb; 
DROP TABLE IF EXISTS participated, owns;
DROP TABLE IF EXISTS person, car, accident;

-- Creating person table with driver_id, name, address

CREATE TABLE person (
    driver_id  CHAR(10)  PRIMARY KEY,
    name  VARCHAR(20) NOT NULL,
    address  VARCHAR(300)  NOT NULL
); 

-- Creating person table with license, model, year


CREATE TABLE car (
    license  CHAR(7)  PRIMARY KEY,
    model  VARCHAR(10),
    year  YEAR 
); 

-- Creating accident table with 
-- report_number, date_occurred, location, description

CREATE TABLE accident (
    report_number  INT NOT NULL AUTO_INCREMENT,
    date_occurred  TIMESTAMP NOT NULL,
    location  VARCHAR(300) NOT NULL,
    description  VARCHAR(2000),
    PRIMARY KEY (report_number)
); 

-- Creating owns table with foreign keys of driver_id, license

CREATE TABLE owns (
    driver_id  CHAR(10),
    license  CHAR(7),
    PRIMARY KEY  (driver_id, license),
    FOREIGN KEY  (driver_id) REFERENCES person(driver_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY  (license) REFERENCES car(license)
        ON UPDATE CASCADE ON DELETE CASCADE
); 


-- Creating participated table with foreign keys of 
-- driver_id, license, report_number and 
-- damage_amount as non-foreign key.

CREATE TABLE participated (
    driver_id  CHAR(10),
    license  CHAR(7),
    report_number  INT  AUTO_INCREMENT,
    damage_amount  NUMERIC(8, 2),
    PRIMARY KEY (driver_id, license, report_number),
	FOREIGN KEY  (driver_id) REFERENCES person(driver_id)
        ON UPDATE CASCADE,
    FOREIGN KEY  (license) REFERENCES car(license)
        ON UPDATE CASCADE,
	FOREIGN KEY  (report_number) REFERENCES accident(report_number)
        ON UPDATE CASCADE
); 
