CREATE OR REPLACE TRIGGER RegCourse
	INSTEAD OF INSERT ON Registrations
	REFERENCING NEW AS reg
	FOR EACH ROW
		DECLARE
			hasPassed CHAR(10);
			maxStudents INT;
			registeredStudents INT;
		BEGIN
			SELECT maxStudents INTO maxStudents
			FROM RestrictedCourses
			WHERE course = :reg.course;

			SELECT COUNT(*) INTO registeredStudents
			FROM Registrations
			WHERE status = 'Registered'
			AND course = :reg.course;
			
			/* Only allow students to register for courses they have not passed */
			/*IF () THEN*/
				IF (maxStudents <= registeredStudents) THEN
					/* Put in waiting list */
					INSERT INTO WaitsFor
					VALUES (:reg.course, :reg.studentId, sysdate);
				ELSE
					/* Register for course */
					INSERT INTO Registered
					VALUES (:reg.studentId, :reg.course);
				END IF;
			/*END IF;*/
			/* TODO THROW ERROR ? */
		END;