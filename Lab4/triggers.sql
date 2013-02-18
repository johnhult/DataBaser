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

			SELECT NVL(COUNT(*), 0) INTO registeredStudents
			FROM Registrations
			WHERE status = 'Registered'
			AND course = :reg.course;

			BEGIN
				SELECT studentId INTO hasPassed 
				FROM PassedCourses
				WHERE studentId = :reg.studentId
				AND course = :reg.course;
				
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						hasPassed := 'XXXXXXXXX';
			END;
			
			/* Only allow students to register for courses they have not passed */
			IF (hasPassed = 'XXXXXXXXX') THEN
				IF (maxStudents <= registeredStudents) THEN
					/* Put in waiting list */
					INSERT INTO WaitsFor
					VALUES (:reg.course, :reg.studentId, sysdate);
				ELSE
					/* Register for course */
					INSERT INTO Registered
					VALUES (:reg.studentId, :reg.course);
				END IF;
			END IF;
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


