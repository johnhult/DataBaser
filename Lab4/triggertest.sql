INSERT INTO Courses VALUES ('RST000', 10, 'IT');

INSERT INTO RestrictedCourses VALUES ('RST000', 2);

INSERT INTO Registrations VALUES ('0000000001', 'RST000', 'Registered');
INSERT INTO Registrations VALUES ('0000000002', 'RST000', 'Registered');
INSERT INTO Registrations VALUES ('0000000004', 'RST000', 'Registered');
INSERT INTO Registrations VALUES ('0000000003', 'RST000', 'Registered');

/* Should not work */
INSERT INTO Registrations VALUES ('0000000001', 'RST000', 'Registered');

/* Should not be registered or put in waiting list */
INSERT INTO Read VALUES ('0000000005', 'RST000', '5');
INSERT INTO Registrations VALUES ('0000000005', 'RST000', 'Registered');

/* 1 and 2 should be registered, 3 and 4 should be waiting */
SELECT * FROM Registrations WHERE course = 'RST000';
/* 3 should have queue position 1 and 4 position 2 */
SELECT * FROM CourseQueuePositions WHERE course = 'RST000';