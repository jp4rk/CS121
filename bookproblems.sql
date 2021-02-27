-- [Problem 1a]
-- Find the names of all students who have taken at least one CS course

USE university; 

SELECT DISTINCT name
    FROM takes NATURAL JOIN COURSE NATURAL JOIN 
	(select ID, name FROM student) AS x WHERE dept_name = 'Comp. Sci.';
    
-- [Problem 1b]
-- For each department, find the maximum salary 
-- of instructors in that department.

SELECT dept_name, MAX(salary) 
    FROM instructor
    GROUP BY dept_name;
    
-- [Problem 1c] 
-- Find the lowest, across all departments, of per-department maximum salary 

SELECT MIN(max_sal) FROM 
    (SELECT dept_name, MAX(salary) AS max_sal
    FROM instructor
    GROUP BY dept_name) as x;
    
-- [Problem 1d]
--  Rewrite your answer from part c using WITH​ 
-- clause to perform the innermost aggregation.

WITH temp AS 
   (SELECT dept_name, MAX(salary) AS max_sal 
   FROM instructor 
   GROUP BY dept_name)
   SELECT MIN(max_sal) FROM temp;

-- [Problem 2a] 
-- Create a new course “CS-001”, titled 
-- “Weekly Seminar”, with 3 credits.

INSERT INTO course 
    VALUES ('CS-001', 'Weekly Seminar', 'Comp. Sci.', 3);

-- [Problem 2b]
-- Create a section of this course in Winter 2021, with ​sec_id​ of 1.

INSERT INTO section(course_id, sec_id, semester, year)
    VALUES ('CS-001', '1', 'Winter', 2021);
    

-- [Problem 2c]
-- Enroll every student in the Comp. Sci. department in the above section. 

INSERT INTO takes(ID, course_id, sec_id, semester, year) 
    SELECT ID, 'CS-001', '1', 'Winter', 2021 
    FROM student
    WHERE dept_name = 'Comp. Sci.';
    
-- [Problem 2d] 
-- Delete enrollments in the above section 
-- where the student's name is Chavez. 

DELETE FROM takes
    WHERE course_id = 'CS-001' AND sec_id = '1' 
    AND semester = 'Winter' AND year = '2021'
    AND (ID IN (SELECT ID FROM student WHERE name = 'Chavez'));

-- [Problem 2e]
-- Delete the course CS-001. 

DELETE FROM course WHERE course_id = 'CS-001';

-- Based on the Universitry Database diagram, we can 
-- see that the section's course_id 
-- is a foreign key (cascade delete), so we know that the 
-- section of the course gets automatically deleted. 

-- [Problem 2f]
-- Delete all ​takes ​tuples corresponding to any section of any 
-- course with the word "database"as a part of the title

DELETE FROM takes WHERE 
    course_id = (SELECT course_id FROM course WHERE 
    LOWER(title) LIKE '%database%');
    
USE library;
    
-- [Problem 3a]
-- Retrieve the names of members who have 
-- borrowed ​any​ book published by "McGraw-Hill".

SELECT DISTINCT name 
    FROM member NATURAL JOIN borrowed NATURAL JOIN 
    book where publisher = 'McGraw-Hill';
    
-- [Problem 3b]
-- Retrieve the names of members who have borrowed 
-- ​all​ books published by "McGraw-Hill".

SELECT name from member NATURAL JOIN book NATURAL JOIN borrowed 
    WHERE publisher = 'McGraw-Hill'
    GROUP BY name HAVING count(isbn) = (SELECT COUNT(isbn)
    FROM book WHERE publisher = 'McGraw-Hill');

-- [Problem 3c]
-- For each publisher, retrieve the names of members who have 
-- borrowed more than fivebooks of that publisher.

SELECT publisher, name FROM member NATURAL JOIN borrowed NATURAL JOIN book
    GROUP BY publisher, name HAVING COUNT(isbn) > 5;

-- [Problem 3d] 
-- Compute the average number of books borrowed per member.

SELECT AVG(num_borrow) FROM 
    (SELECT name, COUNT(*) num_borrow FROM 
    member NATURAL LEFT JOIN borrowed GROUP BY name) AS x;

    
-- [Problem 3f]
-- Rewrite your answer for part d using a ​WITH​ clause.

WITH x AS (
    SELECT name, COUNT(isbn) AS borrow_count FROM 
	member NATURAL LEFT JOIN borrowed
    GROUP BY name) SELECT AVG(borrow_count) FROM x;



