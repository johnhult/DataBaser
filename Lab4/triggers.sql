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


/* If we have a course that is restricted and can only take
 a limited amount of students, and is full, is someone unregister
 for the course we wanna check the following:
 1. Check if person unregistering is not just waiting
 2. Is students in course >= maxStudent for restricted course
 3. If there are any students waiting for the course
 4. Change status on first one in queue from waiting to registered */



CREATE OR REPLACE TRIGGER Unregistered
	INSTEAD OF DELETE ON Registrations
	REFERENCING OLD AS unreg
	FOR EACH ROW
		DECLARE
			waitingStatus VARCHAR(20);
			maxStudentsAllowed INT;
			nrStudentsInClass INT;
			firstPersonInQueue CHAR(10);
		BEGIN
			SELECT status INTO waitingStatus
			FROM Registrations
			WHERE studentId = :unreg.studentId
			AND course = :unreg.course;

			BEGIN
				SELECT maxStudents INTO maxStudentsAllowed
				FROM RestrictedCourses
				WHERE course = :unreg.course;

				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						maxStudentsAllowed := -1;
			END;

			IF (waitingStatus = 'Registered') THEN
				DELETE FROM Registered
				WHERE :unreg.studentId = Registered.student
				AND :unreg.course = Registered.course;

			ELSE
				DELETE FROM WaitsFor
				WHERE :unreg.studentId = WaitsFor.student
				AND :unreg.course = WaitsFor.course;
			END IF;

			SELECT COUNT(*) INTO nrStudentsInClass
			FROM Registered
			WHERE Registered.course = :unreg.course;

			/* If we try to unregister someone from a course that is
				not restricted we don't have a queue and thus, we won't
				perform this since maxStudentsAllowed will be -1 */
			IF (nrStudentsInClass < maxStudentsAllowed) THEN
				BEGIN
					SELECT studentId INTO firstPersonInQueue
					FROM CourseQueuePositions
					WHERE course = :unreg.course
					AND position = 1;

					EXCEPTION
						WHEN NO_DATA_FOUND THEN
							firstPersonInQueue := '0';
				END;
				IF (firstPersonInQueue != '0') THEN
					INSERT INTO Registered
					VALUES (firstPersonInQueue, :unreg.course);
					
					DELETE FROM WaitsFor
					WHERE firstPersonInQueue = student
					AND :unreg.course = course;
				END IF;
			END IF;
		END;