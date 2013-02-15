INSERT INTO Departments VALUES ('Data');
INSERT INTO Departments VALUES ('Elektro');
INSERT INTO Departments VALUES ('IT');
INSERT INTO Departments VALUES ('Kemi');

INSERT INTO StudyProgrammes VALUES ('DataProg');
INSERT INTO StudyProgrammes VALUES ('ElektroProg');
INSERT INTO StudyProgrammes VALUES ('ITProg');
INSERT INTO StudyProgrammes VALUES ('KemiProg');

INSERT INTO Hosts VALUES ('DataProg', 'Data');
INSERT INTO Hosts VALUES ('ElektroProg', 'Elektro');
INSERT INTO Hosts VALUES ('ITProg', 'IT');
INSERT INTO Hosts VALUES ('KemiProg', 'Kemi');
INSERT INTO Hosts VALUES ('KemiProg', 'IT');

INSERT INTO Branches VALUES ('Programming', 'ITProg');
INSERT INTO Branches VALUES ('Programming', 'DataProg');
INSERT INTO Branches VALUES ('Syror', 'KemiProg');

INSERT INTO Students VALUES ('0000000001', 'John', 'ITProg');
INSERT INTO Students VALUES ('0000000002', 'Anton', 'DataProg');
INSERT INTO Students VALUES ('0000000003', 'Johannes', 'KemiProg');
INSERT INTO Students VALUES ('0000000004', 'Victor', 'ElektroProg');
INSERT INTO Students VALUES ('0000000005', 'Niclas', 'DataProg');

INSERT INTO MastersAt VALUES ('0000000001', 'Programming', 'ITProg');
INSERT INTO MastersAt VALUES ('0000000002', 'Programming', 'DataProg');
INSERT INTO MastersAt VALUES ('0000000003', 'Syror', 'KemiProg');
INSERT INTO MastersAt VALUES ('0000000005', 'Programming', 'DataProg');
INSERT INTO MastersAt VALUES ('0000000004', 'Syror', 'ElektroProg');

INSERT INTO Courses VALUES ('TDA001', 10, 'IT');
INSERT INTO Courses VALUES ('TDA002', 20, 'Data');
INSERT INTO Courses VALUES ('TNT666', 30, 'Kemi');
INSERT INTO Courses VALUES ('LOL101', 10, 'Elektro');
INSERT INTO Courses VALUES ('XRO807', 40, 'IT');
INSERT INTO Courses VALUES ('TDA003', 1, 'Data');
INSERT INTO Courses VALUES ('TDA004', 500, 'Elektro');
INSERT INTO Courses VALUES ('TDA005', 20, 'IT');
INSERT INTO Courses VALUES ('TST007', 100, 'Data');

INSERT INTO CourseClassifications VALUES ('Mathematical');
INSERT INTO CourseClassifications VALUES ('Seminar');
INSERT INTO CourseClassifications VALUES ('Research');

INSERT INTO IsClassified VALUES ('TDA001', 'Seminar');
INSERT INTO IsClassified VALUES ('XRO807', 'Mathematical');
INSERT INTO IsClassified VALUES ('TNT666', 'Research');
INSERT INTO IsClassified VALUES ('TST007', 'Seminar');
INSERT INTO IsClassified VALUES ('TST007', 'Mathematical');
INSERT INTO IsClassified VALUES ('TST007', 'Research');

INSERT INTO RestrictedCourses VALUES ('TNT666', 20);
INSERT INTO RestrictedCourses VALUES ('LOL101', 500);

INSERT INTO WaitsFor VALUES ('TNT666', '0000000003', TO_DATE('1989/01/01:15:15:15', 'yyyy/mm/dd:hh24:mi:ss'));
INSERT INTO WaitsFor VALUES ('LOL101', '0000000002', TO_DATE('2000/07/05:13:37:00', 'yyyy/mm/dd:hh24:mi:ss'));
INSERT INTO WaitsFor VALUES ('TNT666', '0000000001', TO_DATE('1989/02/01:15:15:15', 'yyyy/mm/dd:hh24:mi:ss'));

INSERT INTO Registered VALUES ('0000000002', 'TNT666');
INSERT INTO Registered VALUES ('0000000005', 'XRO807');
INSERT INTO Registered VALUES ('0000000004', 'XRO807');

INSERT INTO Read VALUES ('0000000002', 'TDA001', '4');
INSERT INTO Read VALUES ('0000000002', 'TDA002', '5');
INSERT INTO Read VALUES ('0000000001', 'XRO807', '5');
INSERT INTO Read VALUES ('0000000001', 'TDA005', 'U');
INSERT INTO Read VALUES ('0000000004', 'TST007', '5');

INSERT INTO Require VALUES ('TDA002', 'TDA001');
INSERT INTO Require VALUES ('TDA002', 'TDA003');
INSERT INTO Require VALUES ('TDA004', 'TDA003');

INSERT INTO MandatoryForStudyProgramme VALUES ('KemiProg', 'TNT666');
INSERT INTO MandatoryForStudyProgramme VALUES ('ITProg', 'TDA001');
INSERT INTO MandatoryForStudyProgramme VALUES ('ElektroProg', 'TST007');

INSERT INTO MandatoryForBranch VALUES ('Programming', 'TDA002', 'ITProg');
INSERT INTO MandatoryForBranch VALUES ('Programming', 'TDA001', 'DataProg');
INSERT INTO MandatoryForBranch VALUES ('Syror', 'XRO807', 'KemiProg');
INSERT INTO MandatoryForBranch VALUES ('Syror', 'TST007', 'ElektroProg');

INSERT INTO RecommendedForBranch VALUES ('Syror', 'TNT666', 'KemiProg');