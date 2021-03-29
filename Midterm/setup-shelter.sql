-- DROP TABLE statements (no CREATE/USE)
-- -- Cleaning up old tables. Note that tables containing foreign keys are
-- dropped first for the sake of referential integrity constraints.

DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS employees, animals;
DROP TABLE IF EXISTS shelters, applicants;

-- Creating shelters table with shelter_id, name, address
-- zipcode, city, state. This table represents a particular animal
--  shelter with animals available for adoption, and none accept null values.


CREATE TABLE shelters (
    shelter_id  SERIAL  PRIMARY KEY,
    name  VARCHAR(100)  NOT NULL,
    address  VARCHAR(100)  NOT NULL,
    -- Zipcode is 5 digits for all US.
    zipcode  CHAR(5)  NOT NULL,
    city  VARCHAR(100)  NOT NULL,
    -- State is 2 letters for all US.
    state  CHAR(2)  NOT NULL
);

-- Creating applicants table with applicant_id, name, phone, address
-- zipcode, curr_pet_count, household_size, notes. This table 
-- represents potential adopters of pets. 

CREATE TABLE applicants (
    applicant_id  SERIAL  PRIMARY KEY,
    name  VARCHAR(100)  NOT NULL,
    phone  CHAR(12)  NOT NULL, 
    address  VARCHAR(100)  NOT NULL,
    zipcode  CHAR(5)  NOT NULL,
    -- Number of pet that the applicant curerntly own
    curr_pet_count  INT  NOT NULL,
    -- Number of people in the household of the applicant
    household_size  INT  NOT NULL,
    -- Keep track of any important notes about applicant
    notes  VARCHAR(1000),
    UNIQUE (name, phone)
);

-- Creating employees table with emp_id, name, gender, is_volunteer
-- phone, email, role, join_date, shelter_id. The table 
-- describes the information with regards to the employees.


CREATE TABLE employees (
    emp_id  SERIAL  PRIMARY KEY,
    name  VARCHAR(100)  NOT NULL,
    gender  VARCHAR(20), 
    -- If 0, they are volunteer, otherwise 1. 
    is_volunteer  TINYINT(1)  NOT NULL,
    phone  CHAR(12)  NOT NULL,
    email  VARCHAR(100)  NOT NULL,
    -- Role given to the employee 
    role  VARCHAR(50)  NOT NULL,
    -- Date the employee joined the shelter.
    join_date  DATE  NOT NULL,
    -- References the shelter which the employee works at
    shelter_id  BIGINT UNSIGNED  NOT NULL,
    UNIQUE(name, phone),
    FOREIGN KEY  (shelter_id) REFERENCES shelters(shelter_id)
        ON DELETE CASCADE
);

-- Creating animlals table with animal_id, name, gender, animal_type,
-- breed, age_est, notes, shelter_id, join_date, adoption_price. 
-- This table represents all of the animals 
-- being currently managed in the database.
-- Gender, breed, age_est, and notes are the only values that can be null


CREATE TABLE animals (
    animal_id  SERIAL  PRIMARY KEY,
    name  VARCHAR(100)  NOT NULL,
    gender  VARCHAR(20), 
    animal_type  VARCHAR(50)  NOT NULL, 
    breed  VARCHAR(100),
    -- Estimate for the animal’s age in years. If 0, it menas btw 0 & 1. 
    age_est  INT,
    notes  VARCHAR(1000),
    shelter_id  BIGINT UNSIGNED  NOT NULL,
    --  Date (not time) the animal joined the shelter.
    join_date  DATE  NOT NULL,
    -- Adoption price for the particular animal
    adoption_price  NUMERIC(5, 2)  NOT NULL,
    
    FOREIGN KEY  (shelter_id) REFERENCES shelters(shelter_id)
        ON DELETE CASCADE
);

--  Creating applications table with app_id, applicant_id, animal_id
-- status, application_date.  
-- This table holds information about submitted applications for
--  potential adoptions, relating adopter applicants to 
-- animals available for adoption at different shelters.

CREATE TABLE applications (
    app_id  SERIAL  PRIMARY KEY,
    applicant_id  BIGINT UNSIGNED  NOT NULL,
    animal_id  BIGINT UNSIGNED  NOT NULL,
    --  Current status of the application
    status  VARCHAR(15) DEFAULT 'Submitted'  NOT NULL,
    -- Including both date and time components
    application_date  DATETIME  DEFAULT CURRENT_TIMESTAMP  NOT NULL,
    
    FOREIGN KEY  (applicant_id) REFERENCES applicants(applicant_id)
        ON DELETE CASCADE,
	FOREIGN KEY  (animal_id) REFERENCES animals(animal_id)
        ON DELETE CASCADE
);


