-- [Problem 2a]
-- Insert at least one row with a ​NULL​ value to 
-- represent some unknown information. Insert at least 
-- three records into each of the five tables. 

INSERT INTO PERSON
VALUES 
  ('6969696969', 'Lebron James', '63 Lake View Lane, Grosse Pointe, MI 48236'),
  ('1234567890', 'Lamelo Ball', '7573 Rock Maplem Drive Natick, MA 01760'),
  ('4204204200', 'Lonzo Ball', '617 Marconi St. Culpeper, VA 22701');

-- Inserting NULL values non-explicitly
  
INSERT INTO car
VALUES ('6969420', 'Lamborgini', 2018);

INSERT INTO car (license, year)
VALUES ('1234567', 2012);

INSERT INTO car (license, model)
VALUES ('7654321', 'Porsche');

INSERT INTO accident (date_occurred, location, description)
VALUES
  ('2011-11-11 11:11:11', 'Pasadena, CA', 'Fallen wheels'),
  ('2010-10-10 10:23:45', 'San Francisco, CA', 'Gas leak');
  
INSERT INTO accident (date_occurred, location)
VALUES
  ('2013-02-10 8:29:54', 'Los Angeles, CA');  

INSERT INTO owns
VALUES
  ('6969696969', '6969420'),
  ('1234567890', '1234567'),
  ('4204204200', '7654321');

INSERT INTO participated
VALUES
  ('6969696969', '6969420', 1, 6969.69),
  ('1234567890', '1234567', 2, 111.11);

INSERT INTO participated (driver_id, license, report_number)
VALUES ('4204204200', '7654321', 3);

-- [Problem 2b]
-- Write two UPDATE statements for both person and car 

SET SQL_SAFE_UPDATES = 0;

UPDATE person
SET driver_id = '7474747474'
WHERE name = 'Lebron James';

UPDATE car
SET license = '2914303'
WHERE year = '2018';


-- [Problem 2c]
-- Write Write one ​DELETE​ statement
-- to remove a row from the ​car​ table 

DELETE FROM car WHERE license = '7654321';





