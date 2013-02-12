CREATE TABLE Departments (
	name VARCHAR(50),
	PRIMARY KEY (name)
);

CREATE TABLE StudyProgramme (
	name VARCHAR(50),
	PRIMARY KEY (name)
);

CREATE TABLE Hosts (
	studyProgramme VARCHAR(50),
	department VARCHAR(50),
	PRIMARY KEY (studyProgramme, departments),
	FOREIGN KEY (studyProgramme) REFERENCES StudyProgramme(name)
);

CREATE TABLE Branches (
	name VARCHAR(50),
	studyProgramme VARCHAR(50),
	PRIMARY KEY (name, studyProgramme),
	FOREIGN KEY (studyProgramme) REFERENCES StudyProgramme(name)
);

CREATE TABLE Students (
	id CHAR(10),
	name VARCHAR(50),
	studyProgramme VARCHAR(50),
	PRIMARY KEY (id),
	FOREIGN KEY (studyProgramme) REFERENCES StudyProgramme(name)
);

CREATE TABLE MastersAt (
	student CHAR(10),
	branch VARCHAR(50),
	studyProgramme VARCHAR(50),
	PRIMARY KEY (student),
	FOREIGN KEY (student, branch) REFERENCES Students(id, studyProgramme),
	FOREIGN KEY (branch, studyProgramme) REFERENCES Branches(name, studyProgramme)
);

CREATE TABLE Courses (
	code CHAR(6),
	credits INT,
	department VARCHAR(50),
	PRIMARY KEY (code),
	FOREIGN KEY (department) REFERENCES Departments(name)
);

CREATE TABLE CourseClassifications (
	classification VARCHAR(50),
	PRIMARY KEY (classification)
);

CREATE TABLE IsClassified (
	course CHAR(6),
	classification VARCHAR(50),
	PRIMARY KEY (course, classification),
	FOREIGN KEY (course) REFERENCES Courses(name),
	FOREIGN KEY (classification) REFERENCES CourseClassifications(classification)
);

CREATE TABLE WaitsFor (
	course CHAR(6),
	student CHAR(10),
	sinceDate DATE,
	PRIMARY KEY (course) REFERENCES RestrictedCourses(code),
	PRIMARY KEY (student) REFERENCES Students(id),
	(course, sinceDate) UNIQUE
);