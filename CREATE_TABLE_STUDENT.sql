/*
CREATE TABLE STUDENT
*/

--Define database schema
--PRIMARY KEY. We want unique values and not null values 

CREATE TABLE student (
	student_id INT PRIMARY KEY,
	name VARCHAR(20),
	major VARCHAR(20) DEFAULT 'undecided'
)

--2nd way: Try to control the data

CREATE TABLE student (
	student_id INT,
	name VARCHAR(20) NOT NULL,   
	major VARCHAR(20) UNIQUE, 
	PRIMARY KEY (student_id)
)

--3rd way: IDENTITY for automatic fill in

CREATE TABLE student (
	student_id INT IDENTITY,
	name VARCHAR(20) NOT NULL,   
	major VARCHAR(20) 
	PRIMARY KEY (student_id)
)

--MODIFIE TABLE

ALTER TABLE student ADD gpa DECIMAL(3,2)

ALTER TABLE student DROP COLUMN gpa 


--Insert data
--1.

INSERT INTO student VALUES 
	(1, 'Jack', 'Biology'),
	(2, 'Kate', 'Sociology'),
	(4, 'Jack', 'Biology'),
	(5, 'Mike', 'Computer Science')
INSERT INTO student (student_id, name) VALUES (3, 'Claire')

--2.

INSERT INTO student VALUES 
	('Jack', 'Biology'),
	('Kate', 'Sociology'),
	('Claire', 'Physics'),
	('Jack', 'Biology'),
	('Mike', 'Computer Science')
	

DROP TABLE student

SELECT *
FROM master..student


--UPDATE

UPDATE student
SET major = 'Bio'
WHERE major = 'Biology'

UPDATE student
SET major = 'Comp Sci'
WHERE student_id = 5

UPDATE student
SET major = 'Biophysics'
WHERE major = 'Bio' OR major = 'Physics'

UPDATE student
SET name = 'Tom', major = 'undecided'
WHERE student_id = 1


--DELETE

DELETE FROM student
WHERE student_id = 5

DELETE FROM student
WHERE name = 'Tom' AND major = 'undecided'


