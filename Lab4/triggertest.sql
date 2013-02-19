/* Restricted course, only first and second student should be registered on insert */
INSERT INTO Courses VALUES ('RST000', 10, 'IT');
INSERT INTO RestrictedCourses VALUES ('RST000', 2);

/* Unrestricted course, should never have students waiting */
INSERT INTO Courses VALUES ('URS000', 10, 'Kemi');

/* Registrations for restricted course, 1 and 2 should be registered
 * 3 should be waiting with queue position 1, 4 waiting with pos 2
 */
INSERT INTO Registrations VALUES ('0000000001', 'RST000', 'Registered');
INSERT INTO Registrations VALUES ('0000000002', 'RST000', 'Registered');
INSERT INTO Registrations VALUES ('0000000004', 'RST000', 'Registered');
INSERT INTO Registrations VALUES ('0000000003', 'RST000', 'Registered');

/* Registrations for unrestricted course, everyone should be registered */
INSERT INTO Registrations VALUES ('0000000001', 'URS000', 'Registered');
INSERT INTO Registrations VALUES ('0000000002', 'URS000', 'Registered');
INSERT INTO Registrations VALUES ('0000000004', 'URS000', 'Registered');
INSERT INTO Registrations VALUES ('0000000003', 'URS000', 'Registered');

/* Should not work */
INSERT INTO Registrations VALUES ('0000000001', 'RST000', 'Registered');

/* Should not be registered nor put in waiting list */
INSERT INTO Read VALUES ('0000000005', 'RST000', '5');
INSERT INTO Registrations VALUES ('0000000005', 'RST000', 'Registered');


/* Views displaying data above, read comments for how it should look */
SELECT * FROM Registrations WHERE course = 'RST000';
SELECT * FROM CourseQueuePositions WHERE course = 'RST000';