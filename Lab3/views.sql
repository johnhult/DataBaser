CREATE VIEW StudentsFollowing AS
	SELECT id AS studentId, MastersAt.studyProgramme AS studyProgramme, branch
	FROM Students, MastersAt
	WHERE student = id;

CREATE VIEW FinishedCourses AS
	SELECT id AS studentId, code AS course, grade, credits
	FROM Students, Courses, Read
	WHERE student = id
		AND course = code;

CREATE VIEW Registrations AS
	WITH R AS
		(SELECT student, course, 'Registered' AS status
		 FROM Registered),
		 WF AS
		(SELECT student, course, 'Waiting' AS status
		 FROM WaitsFor)
	SELECT id AS studentId, course, status
	FROM Students, R NATURAL JOIN WF
	WHERE id = student;

CREATE VIEW CourseQueuePositions AS
	SELECT student AS studentId, course,
		ROW_NUMBER() OVER (ORDER BY sinceDate ASC) AS Position
	FROM WaitsFor;

CREATE VIEW PassedCourses AS
	SELECT id AS studentId, course, grade, credits
	FROM Students, Courses, Read
	WHERE course = code
	AND grade != 'U';

CREATE VIEW UnreadMandatory AS
	(SELECT id AS studentId, course
	FROM MandatoryForStudyProgramme, Students
	WHERE (course, id) NOT IN (SELECT course, student 
								FROM Read
								WHERE grade != 'U'))
	UNION
	(SELECT id AS studentId, course
	FROM MandatoryForBranch, Students
	WHERE (course, id) NOT IN (SELECT course, student
								FROM Read
								WHERE grade != 'U'));