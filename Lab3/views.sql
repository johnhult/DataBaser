CREATE VIEW UnreadMandatory AS
	WITH Mandatory AS
		(SELECT course 
		 FROM MandatoryForStudyProgramme NATURAL JOIN MandatoryForBranch)
	SELECT id as studentId, course
	FROM Mandatory, Students
	WHERE (course, id) NOT IN (SELECT course, student FROM Read WHERE grade != 'U')