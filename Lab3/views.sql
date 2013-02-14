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
		ROW_NUMBER() OVER (ORDER BY sinceDate ASC) AS p1osition
	FROM WaitsFor;

CREATE VIEW PassedCourses AS
	SELECT id AS studentId, course, grade, credits
	FROM Students, Courses, Read
	WHERE course = code
	AND grade != 'U';

CREATE VIEW UnreadMandatory AS
	WITH Mandatory AS
		(SELECT course 
		 FROM MandatoryForStudyProgramme NATURAL JOIN MandatoryForBranch)
	SELECT id as studentId, course
	FROM Mandatory, Students
	WHERE (course, id) NOT IN (SELECT course, student FROM Read WHERE grade != 'U');

CREATE VIEW PathToGraduation AS
	WITH AchievedCredits AS
		(SELECT student, credits
		 FROM Courses, Read, Students
		 WHERE code = course AND id = student),
	BranchCredits AS
		(SELECT id, credits AS bcredits
		 FROM Students, RecommendedForBranch RFB, Courses
		 WHERE course = code
		 AND (id, course) IN (SELECT studentId, course FROM PassedCourses)),
	MathCredits AS
		(SELECT id, credits AS mcredits
		 FROM Students, IsClassified, Courses
		 WHERE classification = 'Mathematical'
		 AND course = code
		 AND (id, course) IN (SELECT studentId, course FROM PassedCourses)),
	ResearchCredits AS
		(SELECT id, credits AS rcredits
		 FROM Students, IsClassified, Courses
		 WHERE classification = 'Research'
		 AND course = code
		 AND (id, course) IN (SELECT studentId, course FROM PassedCourses)),
	SeminarCourses AS
		(SELECT id, COUNT(*) AS scourses
		 FROM Students, IsClassified NATURAL JOIN PassedCourses
		 WHERE id = studentId
		 GROUP BY id),
	MandatoryCourses AS
		(SELECT id, COUNT(*) AS mcourses
		 FROM Students, UnreadMandatory
		 WHERE id = studentId
		 GROUP BY id)
	SELECT
		id AS studentId,
		credits AS achievedCredits,
		bcredits AS branchRecommendedCredits,
		mcredits AS mathematicalCredits,
		rcredits AS reserachCredits,
		scourses AS seminarCourses,
		mcourses AS mandatoryCoursesLeft
	FROM Students, AchievedCredits NATURAL JOIN BranchCredits
		 NATURAL JOIN MathCredits NATURAL JOIN ResearchCredits
		 NATURAL JOIN SeminarCourses NATURAL JOIN MandatoryCourses;