CREATE TABLE Departments (
	name VARCHAR(50),
	PRIMARY KEY (name)
);

CREATE TABLE StudyProgrammes (
	name VARCHAR(50),
	PRIMARY KEY (name)
);

CREATE TABLE Hosts (
	studyProgramme VARCHAR(50),
	department VARCHAR(50),
	PRIMARY KEY (studyProgramme, department),
	FOREIGN KEY (studyProgramme) REFERENCES StudyProgrammes(name)
);

CREATE TABLE Branches (
	name VARCHAR(50),
	studyProgramme VARCHAR(50),
	PRIMARY KEY (name, studyProgramme),
	FOREIGN KEY (studyProgramme) REFERENCES StudyProgrammes(name)
);

CREATE TABLE Students (
	id CHAR(10),
	name VARCHAR(50),
	studyProgramme VARCHAR(50),
	PRIMARY KEY (id),
	FOREIGN KEY (studyProgramme) REFERENCES StudyProgrammes(name),
	UNIQUE (id, studyProgramme)
);

CREATE TABLE MastersAt (
	student CHAR(10),
	branch VARCHAR(50),
	studyProgramme VARCHAR(50),
	PRIMARY KEY (student),
	FOREIGN KEY (student, studyProgramme) REFERENCES Students(id, studyProgramme),
	FOREIGN KEY (branch, studyProgramme) REFERENCES Branches(name, studyProgramme)
);

CREATE TABLE Courses (
	code CHAR(6),
	credits INT CHECK (credits > 0),
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
	FOREIGN KEY (course) REFERENCES Courses(code),
	FOREIGN KEY (classification) REFERENCES CourseClassifications(classification)
);

CREATE TABLE RestrictedCourses(
	course CHAR(6),
	maxStudents INT CHECK (credits > 0),
	PRIMARY KEY (course),
	FOREIGN KEY (course) REFERENCES Courses(code)
);

CREATE TABLE WaitsFor (
	course CHAR(6),
	student CHAR(10),
	sinceDate DATE,
	PRIMARY KEY (course, student),
	FOREIGN KEY (course) REFERENCES RestrictedCourses(course),
	FOREIGN KEY (student) REFERENCES Students(id),
	UNIQUE (course, sinceDate)
);

CREATE TABLE Registered(
	student CHAR(10),
	course CHAR(6),
	PRIMARY KEY (student, course),
	FOREIGN KEY (student) REFERENCES Students(id),
	FOREIGN KEY (course) REFERENCES Courses(code)
);

CREATE TABLE Read(
	student CHAR(10),
	course CHAR(6),
	grade CHAR(1) CHECK (grade IN ('U', '3', '4', '5')),
	PRIMARY KEY (student, course),
	FOREIGN KEY (student) REFERENCES Students(id),
	FOREIGN KEY (course) REFERENCES Courses(code)
);

CREATE TABLE Require(
	course CHAR(6),
	requiredCourse CHAR(6),
	CHECK (course <> requiredCourse),
	PRIMARY KEY (course, requiredCourse),
	FOREIGN KEY (course) REFERENCES Courses(code),
	FOREIGN KEY (requiredCourse) REFERENCES Courses(code)
);

CREATE TABLE MandatoryForStudyProgramme(
	studyProgramme VARCHAR(50),
	course CHAR(6),
	PRIMARY KEY (studyProgramme, course),
	FOREIGN KEY (studyProgramme) REFERENCES StudyProgrammes(name),
	FOREIGN KEY (course) REFERENCES Courses(code)
);

CREATE TABLE MandatoryForBranch(
	branch VARCHAR(50),
	course CHAR(6),
	studyProgramme VARCHAR(50),
	PRIMARY KEY (branch, course),
	FOREIGN KEY (branch, studyProgramme) REFERENCES Branches(name, studyProgramme),
	FOREIGN KEY (course) REFERENCES Courses(code)
);

CREATE TABLE RecommendedForBranch(
	branch VARCHAR(50),
	course CHAR(6),
	studyProgramme VARCHAR(50),
	PRIMARY KEY (branch, course),
	FOREIGN KEY (branch, studyProgramme) REFERENCES Branches(name, studyProgramme),
	FOREIGN KEY (course) REFERENCES Courses(code)
);