-- 1. Create STUDENT table
CREATE TABLE STUDENT (
  RollNo    CHAR(6)    PRIMARY KEY,
  StudentName VARCHAR(20),
  Course    VARCHAR(10),
  DOB       DATE
);

-- 2. Create SOCIETY table
CREATE TABLE SOCIETY (
  SocID       CHAR(6)      PRIMARY KEY,
  SocName     VARCHAR(20),
  MentorName  VARCHAR(15),
  TotalSeats  INT UNSIGNED
);

-- 3. Create ENROLLMENT table (many-to-many link)
CREATE TABLE ENROLLMENT (
  RollNo           CHAR(6),
  SID              CHAR(6),
  DateOfEnrollment DATE,
  FOREIGN KEY (RollNo) REFERENCES STUDENT(RollNo),
  FOREIGN KEY (SID)    REFERENCES SOCIETY(SocID)
);





-- 1. Retrieve names of students enrolled in any society.
SELECT DISTINCT s.StudentName
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo;

-- 2. Retrieve all society names.
SELECT SocName
FROM SOCIETY;

-- 3. Retrieve students' names starting with letter ‘A’.
SELECT StudentName
FROM STUDENT
WHERE StudentName LIKE 'A%';

-- 4. Retrieve students' details studying in courses ‘computer science’ or ‘chemistry’.
SELECT *
FROM STUDENT
WHERE Course IN ('computer science', 'chemistry');

-- 5. Retrieve students’ names whose roll no either starts with ‘X’ or ‘Z’ and ends with ‘9’.
SELECT StudentName
FROM STUDENT
WHERE RollNo LIKE 'X%9' OR RollNo LIKE 'Z%9';

-- 6. Find society details with more than N TotalSeats (user-input N).
SELECT *
FROM SOCIETY
WHERE TotalSeats > ?;  -- replace ? with your N

-- 7. Update society table for mentor name of a specific society.
UPDATE SOCIETY
SET MentorName = 'New Mentor Name'
WHERE SocID = 'S12345';  -- replace with actual SocID

-- 8. Find society names in which more than five students have enrolled.
SELECT S.SocName
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocName
HAVING COUNT(E.RollNo) > 5;

-- 9. Find the name of the youngest student enrolled in society ‘NSS’.
SELECT s.StudentName
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo
WHERE e.SID = (SELECT SocID FROM SOCIETY WHERE SocName = 'NSS')
ORDER BY s.DOB DESC
LIMIT 1;

-- 10. Find the name of the most popular society (by enrolled students).
SELECT S.SocName
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocName
ORDER BY COUNT(E.RollNo) DESC
LIMIT 1;

-- 11. Find the names of the two least popular societies.
SELECT S.SocName
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocName
ORDER BY COUNT(E.RollNo) ASC
LIMIT 2;

-- 12. Find the student names who are not enrolled in any society.
SELECT StudentName
FROM STUDENT
WHERE RollNo NOT IN (SELECT RollNo FROM ENROLLMENT);

-- 13. Find the student names enrolled in at least two societies.
SELECT s.StudentName
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo
GROUP BY s.StudentName
HAVING COUNT(DISTINCT e.SID) >= 2;

-- 14. Find society names in which the maximum students are enrolled.
SELECT S.SocName
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocName
ORDER BY COUNT(E.RollNo) DESC
LIMIT 1;

-- 15. Find names of all students and their societies (where at least one enrollment exists).
SELECT DISTINCT s.StudentName, soc.SocName
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo
JOIN SOCIETY soc ON e.SID = soc.SocID;

-- 16. Find names of students enrolled in any of ‘Debating’, ‘Dancing’, ‘Sashakt’.
SELECT DISTINCT s.StudentName
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo
JOIN SOCIETY soc ON e.SID = soc.SocID
WHERE soc.SocName IN ('Debating', 'Dancing', 'Sashakt');

-- 17. Find society names where MentorName contains ‘Gupta’.
SELECT SocName
FROM SOCIETY
WHERE MentorName LIKE '%Gupta%';

-- 18. Find societies where enrolled count = 10% of TotalSeats.
SELECT S.SocName
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocID, S.TotalSeats
HAVING COUNT(E.RollNo) = 0.1 * S.TotalSeats;

-- 19. Display the vacant seats for each society.
SELECT S.SocName,
       (S.TotalSeats - COUNT(E.RollNo)) AS VacantSeats
FROM SOCIETY S
LEFT JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocID;

-- 20. Increment TotalSeats of each society by 10%.
UPDATE SOCIETY
SET TotalSeats = CEILING(TotalSeats * 1.10);

-- 21. Add enrollment fees paid (‘yes’/’No’) field in the ENROLLMENT table.
ALTER TABLE ENROLLMENT
ADD COLUMN FeesPaid VARCHAR(3) DEFAULT 'No';

-- 22. Update DateOfEnrollment for s1, s2, s3.
UPDATE ENROLLMENT
SET DateOfEnrollment = CASE
  WHEN SID = 's1' THEN '2018-01-15'
  WHEN SID = 's2' THEN CURDATE()
  WHEN SID = 's3' THEN '2018-01-02'
END
WHERE SID IN ('s1','s2','s3');

-- 23. Create a view tracking each society’s total enrollments.
CREATE VIEW SocietyEnrollment AS
SELECT S.SocName,
       COUNT(E.RollNo) AS TotalStudents
FROM SOCIETY S
LEFT JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocName;

-- 24. Find student names enrolled in all societies.
SELECT s.StudentName
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo
GROUP BY s.StudentName
HAVING COUNT(DISTINCT e.SID) = (SELECT COUNT(*) FROM SOCIETY);

-- 25. Count societies with more than 5 enrollments.
SELECT COUNT(*)
FROM (
  SELECT SID
  FROM ENROLLMENT
  GROUP BY SID
  HAVING COUNT(RollNo) > 5
) AS T;

-- 26. Add column Mobile in STUDENT with default ‘9999999999’.
ALTER TABLE STUDENT
ADD COLUMN Mobile VARCHAR(10) DEFAULT '9999999999';

-- 27. Find total number of students whose age > 20.
SELECT COUNT(*)
FROM STUDENT
WHERE TIMESTAMPDIFF(YEAR, DOB, CURDATE()) > 20;

-- 28. Find students born in 2001 and enrolled at least once.
SELECT DISTINCT s.StudentName
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo
WHERE YEAR(s.DOB) = 2001;

-- 29. Count societies whose name starts with ‘S’ and ends with ‘t’ and have ≥5 enrollments.
SELECT COUNT(*)
FROM (
  SELECT S.SocID
  FROM SOCIETY S
  JOIN ENROLLMENT E ON S.SocID = E.SID
  WHERE S.SocName LIKE 'S%t'
  GROUP BY S.SocID
  HAVING COUNT(E.RollNo) >= 5
) AS U;
