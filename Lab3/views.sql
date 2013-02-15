CREATE VIEW StudentsFollowing AS
	SELECT id AS studentId, MastersAt.studyProgramme AS studyProgramme, branch
	FROM Students, MastersAt
	WHERE student = id
	UNION
	SELECT id AS studentId, studyProgramme, NULL
	FROM Students
	WHERE id NOT IN (SELECT student FROM MastersAt);

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
		FROM Students, R
		WHERE id = student
	UNION
		SELECT id AS studentId, course, status
		FROM Students, WF
		WHERE id = student;

CREATE VIEW CourseQueuePositions AS
	SELECT student AS studentId, course,
		ROW_NUMBER() OVER (PARTITION BY course ORDER BY sinceDate ASC) AS p1osition
	FROM WaitsFor;

CREATE VIEW PassedCourses AS
	SELECT id AS studentId, course, grade, credits
	FROM Students, Courses, Read
	WHERE course = code
	AND student = id
	AND grade != 'U'
	ORDER BY id;

CREATE VIEW UnreadMandatory AS
	WITH Mandatory AS
			(SELECT id AS studentId, course, B.studyProgramme, branch
			FROM Students, MandatoryForBranch B
			WHERE B.studyProgramme = Students.studyProgramme
		UNION
			SELECT id as studentId, course, P.studyProgramme, NULL		
			FROM Students, MandatoryForStudyProgramme P
			WHERE Students.studyProgramme = P.studyProgramme)
	SELECT *
	FROM Mandatory
	WHERE (studentId, course) NOT IN (SELECT studentId, course FROM PassedCourses)

CREATE VIEW PathToGraduation AS
	WITH AchievedCredits AS
		(SELECT id, SUM(credits) AS acredits
		 FROM Courses, Students
		 WHERE (id, code) IN (SELECT studentId, course FROM PassedCourses)
		 GROUP BY id),
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
		 AND classification = 'Seminar'
		 GROUP BY id),
	MandatoryCourses AS
		(SELECT id, COUNT(*) AS mcourses
		 FROM Students, UnreadMandatory
		 WHERE id = studentId
		 GROUP BY id)
	SELECT
		id AS studentId,
		acredits AS achievedCredits,
		bcredits AS branchRecommendedCredits,
		mcredits AS mathematicalCredits,
		rcredits AS reserachCredits,
		scourses AS seminarCourses,
		mcourses AS mandatoryCoursesLeft
	FROM Students NATURAL LEFT OUTER JOIN AchievedCredits NATURAL LEFT OUTER JOIN BranchCredits
		 NATURAL LEFT OUTER JOIN MathCredits NATURAL LEFT OUTER JOIN ResearchCredits
		 NATURAL LEFT OUTER JOIN SeminarCourses NATURAL LEFT OUTER JOIN MandatoryCourses
	 ORDER BY id;