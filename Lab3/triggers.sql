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
			WHERE studentId = :unreg.status;

			SELECT maxStudents INTO maxStudentsAllowed
			FROM RestrictedCourses
			WHERE course = :unreg.course;


			IF (waitingStatus = 'Registered') THEN
				DELETE FROM Registered WHERE (:unreg.studentId = Registered.student
				AND :unreg.course = Registered.course);

			ELSE DELETE FROM WaitsFor WHERE (:unreg.studentId = WaitsFor.student
				AND :unreg.course = WaitsFor.course);
			END IF;

			SELECT COUNT(*) INTO nrStudentsInClass 
			FROM Registered
			WHERE course = :unreg.course;

			IF (nrStudentsInClass < maxStudentsAllowed) THEN
				SELECT NVL(studentId, '0') INTO firstPersonInQueue
				FROM CourseQueuePositions
				WHERE course = :unreg.course
					AND position = 1;
				IF (firstPersonInQueue != '0') THEN
					INSERT INTO Registered VALUES (firstPersonInQueue, :unreg.course);
				END IF;
			END IF;
		END;


