-- [Problem 1]
-- Write the SQL query to return the name, type, and notes of all animals
-- which have “Bonded pair” in their notes (ignoring casing), as well
-- as the name of the shelter they are managed by.

SELECT animals.name AS animal_name, animal_type, 
notes, shelters.name AS shelter_name 
FROM animals, shelters 
WHERE animals.shelter_id = shelters.shelter_id 
AND notes LIKE '%bonded pair%';

-- [Problem 2]
-- Define a view called shelter_applications which returns the
-- app_id, applicant_id, animal_id, and shelter_id 
-- for all applications in the database. 

CREATE VIEW shelter_applications AS 
    SELECT app_id, applicant_id, animals.animal_id, shelter_id
    FROM applications NATURAL JOIN animals;
 
-- [Problem 3]
-- Write the SQL query to return, for each shelter, the total number 
-- of applications in the database for animals managed at that shelter
-- as well as how many have the status “Accepted”.
-- Used case to ensure that we count null values (0) for any non-accepted
-- status when counting for accepted apps. 
 
 SELECT name, COUNT(*) AS total_apps, COUNT(num) AS accepted_apps 
     FROM shelter_applications NATURAL JOIN shelters NATURAL JOIN (SELECT *, 
     CASE 
         WHEN status = 'Accepted' THEN 'NOT NULL'
         END AS num FROM applications) AS x 
	 GROUP BY name ORDER by total_apps DESC, accepted_apps DESC;

    
-- [Problem 4]
-- Write the SQL query translated from the relational algebra result
-- of Question 5 of the Relational Algebra part of this exam.
-- Couldn't natural join with animals since attribute "name" was
-- overlapping; instead used cartesian product and "WHERE" statement

SELECT DISTINCT employees.name AS employee_name, animals.animal_id, 
    animals.name AS animal_name, animal_type 
    FROM (employees NATURAL JOIN applicants NATURAL JOIN applications),
    animals WHERE applications.animal_id = animals.animal_id;
    
-- [Problem 5]
-- Write the SQL statements to replicate the final results of
-- Question 7 of the Relational Algebra part of this exam.
-- Didn't include deleting from applications (which I did on P5)
-- since I used on delete cascade (automatically deletes)

DELETE FROM animals WHERE animal_type = 'Rock';

-- [Problem 6]
-- Write the DDL to create this table and move all records which
-- have a status of “Accepted” or “Rejected” from applications
-- to this new table in a single INSERT statement. Then, remove
-- all such records from the applications table.
-- ADDing into previous_applications and DELETing from applications

CREATE TABLE previous_applications(
    app_id  SERIAL  PRIMARY KEY,
    applicant_id  BIGINT UNSIGNED  NOT NULL,
    animal_id  BIGINT UNSIGNED  NOT NULL,
    status  VARCHAR(15)  DEFAULT 'Submitted'  NOT NULL,
    application_date  DATETIME  DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY  (applicant_id) REFERENCES applicants(applicant_id)
        ON DELETE CASCADE,
	FOREIGN KEY  (animal_id) REFERENCES animals(animal_id)
        ON DELETE CASCADE);
    
    
    INSERT INTO previous_applications 
        SELECT * FROM applications
        WHERE status = 'Accepted' OR status = 'Rejected';
        
	DELETE FROM applications 
        WHERE status = 'Accepted' OR status = 'Rejected';
    

-- [Problem 7]
-- Define a function count_type which takes an animal type as an argument
-- and returns the number of animals of that 
-- type associated with a shelter in the database
-- Had 2 if's statement (b/c if it's if-else statement, then the default
-- value might change by else statement) to ensure inappropriate ani_tye
-- gets a count_type of 0. 

DELIMITER ? 

CREATE FUNCTION count_type(ani_type VARCHAR(50)) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE  ans  INT  DEFAULT 0;
    
	IF ani_type IN (SELECT animal_type FROM animals) THEN 
        SELECT COUNT(*) INTO ans FROM animals
	    WHERE animal_type = ani_type;
	END IF;


    IF ani_type = 'Other' THEN 
        SELECT COUNT(*) INTO ans FROM animals
	    WHERE animal_type != 'Dog' AND animal_type != 'Cat';
    END IF;
    
    RETURN ans;
    
    END ?
    
DELIMITER ;

-- [Problem 8]
-- Use your count_type function from the previous problem to define a view
-- animal_types to show the number of Dogs, Cats, and Other Animals 
-- who are associated with a shelter in the database. 

CREATE OR REPLACE VIEW animal_types AS 
     SELECT animal_type, count_type(animal_type) AS animal_count FROM animals
     WHERE animal_type = 'Dog' OR animal_type = 'Cat' GROUP BY animal_type
     UNION SELECT 'Other Animals', count_type('Other');

-- [Problem 9]
-- Define a procedure accept_adoption which takes an animal id and applicant
-- id as arguments and sets the status to the application matching
-- the animal and applicant to “Accepted”. 

DELIMITER ?

CREATE PROCEDURE accept_adoption(IN ani_id BIGINT, IN app_id BIGINT)
BEGIN
    IF ani_id IN (SELECT animal_id FROM applications 
    WHERE applicant_id = app_id) THEN
		UPDATE applications
		SET status = 'Accepted' WHERE applicant_id = app_id
		AND animal_id = ani_id;
		
		UPDATE applications
		SET status = 'Rejected' WHERE applicant_id != app_id
		AND animal_id = ani_id; 
		
		UPDATE animals
		SET notes = CONCAT('Adoption approved for ', app_id)
		WHERE animal_id = ani_id;
	END IF;
    
    END ?
    
    DELIMITER ;
	
    
-- [Problem 10]
-- Define a procedure nearby_animals that takes a 5-character zipcode
-- as an argument and has two out parameters: 
-- the number of shelters near the zipcode

DELIMITER ?

CREATE PROCEDURE nearby_animals
    (IN zip CHAR(5), OUT num_shelters INT, OUT tot_animals INT)
BEGIN
    SELECT COUNT(*) INTO num_shelters FROM shelters WHERE zipcode 
        LIKE CONCAT(SUBSTRING(zip, 1, 3), '%');
    
    SELECT COUNT(*) INTO tot_animals FROM animals, shelters  
        WHERE animals.shelter_id = shelters.shelter_id 
        AND zipcode LIKE CONCAT(SUBSTRING(zip, 1, 3),'%');
    
    END ?

DELIMITER ;


CALL nearby_animals("98104", @num_shelter, @tot_animals);
    SELECT @num_shelter, @tot_animals;

-- [Problem XC (Optional)]
-- Create another table to the database with at least one foreign
--  key reference to an existing table. 
-- ANSWER: I believe that for animal shelter management system, it would be 
-- important to add another table named 'adoptions' where customers
-- get to know the details about when to pick up their pets once
-- their applications have been 'submitted'. THe attribute consists
-- of adoption_id, animal_id, applicant_id, pickup_date, and notes
-- to make sure right customers get the right pet at an arranged date.

CREATE TABLE adoptions(
    adoption_id  SERIAL  PRIMARY KEY,
    animal_id  BIGINT UNSIGNED  NOT NULL,
    applicant_id  BIGINT UNSIGNED  NOT NULL,
    pickup_date  DATE  NOT NULL,
    notes  VARCHAR(1000),
    
    FOREIGN KEY  (animal_id) REFERENCES animals(animal_id)
	    ON DELETE CASCADE,
	FOREIGN KEY  (applicant_id) REFERENCES applicants(applicant_id)
	    ON DELETE CASCADE
);

