
-- [Problem 1a]
-- Compute what would be a “perfect score” in the course

USE grades;
SELECT SUM(perfectscore) AS perfect_score FROM assignment;

-- [Problem 1b]
-- Write a query that lists every section’s name, 
-- and how many students are in that section.

SELECT sec_name, COUNT(*) AS num_students FROM 
    section NATURAL JOIN student GROUP by sec_id ORDER BY sec_name;

-- [Problem 1c]
-- Create a view named ​totalscores​, which computes each student’s
-- total score over allassignments in the course.  The view’s result
-- should contain each student’s username, 
-- and thetotal score for that student.

CREATE VIEW totalscores AS 
    SELECT username, SUM(score) AS total_score FROM
    student NATURAL LEFT JOIN submission
    WHERE graded = 1 GROUP BY username ORDER BY username;

-- [Problem 1d]
-- Using the ​totalscores​ view, a view called ​passing​ which lists
-- the usernames and scores of allstudents that are passing.
	
CREATE VIEW passing AS 
    SELECT username, total_score FROM totalscores
    WHERE total_score >= 40;

-- [Problem 1e]

CREATE VIEW failing AS 
    SELECT username, total_score FROM totalscores
    WHERE total_score < 40;

-- [Problem 1f]
-- Write a SQL query that lists the usernames of all students that failed
-- to submit work for at leastone lab assignment,
-- but still managed to pass the course. 
-- Result of running: 'turner', 'tucker', 'simmons', 'ross', 'murphy'
-- 'miller', 'harris', 'gibson', 'flores', 'edwards', 'coleman'

SELECT username FROM passing NATURAL JOIN (SELECT username, sub_id FROM
    submission NATURAL JOIN assignment WHERE shortname LIKE 'lab%') as x
    NATURAL LEFT JOIN fileset WHERE fileset.sub_id IS NULL;


-- [Problem 1g]
-- Update and rerun this query to show all students that failed to submit
-- either the midterm or the final, yet still managed to pass the course.

-- Result of running: Collins (only student who passed the class
-- that failed to submit either midterm or final

SELECT username FROM passing NATURAL JOIN (SELECT username, sub_id FROM
    submission NATURAL JOIN assignment WHERE 
    shortname = 'Midterm' OR shortname = 'Final') as x
    NATURAL LEFT JOIN fileset WHERE fileset.sub_id IS NULL;

-- [Problem 2a]
-- Write an SQL query that reports the usernames of all students that
-- submitted work for themidterm after the due date. 

SELECT DISTINCT username FROM submission NATURAL JOIN assignment
    NATURAL JOIN fileset WHERE shortname = 'Midterm' AND sub_date > due;

-- [Problem 2b]
-- Write an SQL query that reports, for each hour in the day, how many 
-- lab assignments(assignments whose short-names start with ​'lab'​) 
-- are submitted in that hour. 

SELECT EXTRACT(HOUR FROM sub_date) AS hour, COUNT(*) AS num_submits
    FROM assignment NATURAL JOIN submission NATURAL JOIN fileset
    WHERE shortname LIKE 'lab%' GROUP BY (EXTRACT(HOUR FROM sub_date))
    ORDER BY hour;

-- [Problem 2c]
-- Write an SQL query that reports the total number of final exams that
-- were submitted in the 30minutes before the final exam due date.
SELECT COUNT(*) AS num_exams_30_min 
    FROM assignment NATURAL JOIN submission NATURAL JOIN fileset
    WHERE shortname = 'Final' AND sub_date BETWEEN due - INTERVAL
    30 MINUTE AND due;

-- [Problem 3a]
-- Add a column named “​email​” to the student table (​VARCHAR(200))

ALTER TABLE student
    ADD email  VARCHAR(200);

-- Populate the new email column by concatenating
-- the student’s username to “@school.edu”.

set sql_safe_updates = 0;
UPDATE student
    SET email = CONCAT(username, '@school.edu');

-- Impose a ​NOT NULL​ constraint on the column

ALTER TABLE student
    MODIFY email VARCHAR(200) NOT NULL;

-- [Problem 3b]
-- Add a column named “​submit_files​” to the assignment table

ALTER TABLE assignment
    ADD submit_files TINYINT DEFAULT 1;
    
-- Write an ​UPDATE​ command that sets all “daily quiz” 
-- assignments to have ​submit_files​ = ​0​.

UPDATE assignment
    SET submit_files = 0 WHERE shortname LIKE 'dq%';

-- [Problem 3c]
-- Create a new table “​gradescheme​” 

DROP TABLE IF EXISTS gradescheme;

CREATE TABLE gradescheme (
    scheme_id  INT PRIMARY KEY,
    scheme_desc  VARCHAR(100)  NOT NULL
);

-- Inserting new columns

INSERT INTO gradescheme
VALUES 
    ( 0, 'Lab assignment with min-grading.'),
    ( 1, 'Daily quiz.'),
    ( 2, 'Midterm or final exam.');

-- Rename the ​gradescheme​ column to be named “​scheme_id​”, 
-- but leave it as an ​INTEGER​ column.

ALTER TABLE assignment
    RENAME COLUMN gradescheme TO scheme_id;

-- Add a foreign key constraint from ​assignment.scheme_id​
-- to the new gradescheme.scheme_id​ column

ALTER TABLE assignment
    ADD FOREIGN KEY (scheme_id)
    REFERENCES gradescheme(scheme_id);

