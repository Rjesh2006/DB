-- 1. Retrieve names of students enrolled in any society.
SELECT DISTINCT s.Name
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo;

-- 2. Retrieve all society names.
SELECT SName
FROM SOCIETY;

-- 3. Retrieve students' names starting with letter ‘A’.
SELECT Name
FROM STUDENT
WHERE Name LIKE 'A%';

-- 4. Retrieve students' details studying in courses ‘computer science’ or ‘chemistry’.
SELECT * 
FROM STUDENT
WHERE Course IN ('computer science', 'chemistry');

-- 5. Retrieve students’ names whose roll no either starts with ‘X’ or ‘Z’ and ends with ‘9’.
SELECT Name
FROM STUDENT
WHERE RollNo LIKE 'X%9' OR RollNo LIKE 'Z%9';

-- 6. Find society details with more than N TotalSeats where N is to be input by the user.
SELECT * 
FROM SOCIETY
WHERE TotalSeats > ?;  -- '?' will be replaced by N during input

-- 7. Update society table for mentor name of a specific society.
UPDATE SOCIETY
SET Mentor = 'New Mentor Name'
WHERE SID = 'specific_sid'; -- replace specific_sid with the actual society ID

-- 8. Find society names in which more than five students have enrolled.
SELECT S.SName
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SID = E.SID
GROUP BY S.SName
HAVING COUNT(E.RollNo) > 5;

-- 9. Find the name of youngest student enrolled in society ‘NSS’.
SELECT s.Name
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo
WHERE e.SID = (SELECT SID FROM SOCIETY WHERE SName = 'NSS')
ORDER BY s.DOB DESC
LIMIT 1;

-- 10. Find the name of most popular society (on the basis of enrolled students).
SELECT S.SName
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SID = E.SID
GROUP BY S.SName
ORDER BY COUNT(E.RollNo) DESC
LIMIT 1;

-- 11. Find the name of two least popular societies (on the basis of enrolled students).
SELECT S.SName
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SID = E.SID
GROUP BY S.SName
ORDER BY COUNT(E.RollNo) ASC
LIMIT 2;

-- 12. Find the student names who are not enrolled in any society.
SELECT Name
FROM STUDENT
WHERE RollNo NOT IN (SELECT RollNo FROM ENROLLMENT);

-- 13. Find the student names enrolled in at least two societies.
SELECT s.Name
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo
GROUP BY s.Name
HAVING COUNT(DISTINCT e.SID) >= 2;

-- 14. Find society names in which maximum students are enrolled.
SELECT S.SName
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SID = E.SID
GROUP BY S.SName
ORDER BY COUNT(E.RollNo) DESC
LIMIT 1;

-- 15. Find names of all students who have enrolled in any society and society names in which at least one student has enrolled.
SELECT DISTINCT s.Name, soc.SName
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo
JOIN SOCIETY soc ON e.SID = soc.SID;

-- 16. Find names of students who are enrolled in any of the three societies ‘Debating’, ‘Dancing’, and ‘Sashakt’.
SELECT DISTINCT s.Name
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo
JOIN SOCIETY soc ON e.SID = soc.SID
WHERE soc.SName IN ('Debating', 'Dancing', 'Sashakt');

-- 17. Find society names such that its mentor has a name with ‘Gupta’ in it.
SELECT SName
FROM SOCIETY
WHERE Mentor LIKE '%Gupta%';

-- 18. Find the society names in which the number of enrolled students is only 10% of its capacity.
SELECT S.SName
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SID = E.SID
GROUP BY S.SID, S.TotalSeats
HAVING COUNT(E.RollNo) = 0.1 * S.TotalSeats;

-- 19. Display the vacant seats for each society.
SELECT S.SName, (S.TotalSeats - COUNT(E.RollNo)) AS VacantSeats
FROM SOCIETY S
LEFT JOIN ENROLLMENT E ON S.SID = E.SID
GROUP BY S.SID;

-- 20. Increment Total Seats of each society by 10%.
UPDATE SOCIETY
SET TotalSeats = TotalSeats * 1.1;

-- 21. Add enrollment fees paid (‘yes’/’No’) field in the enrollment table.
ALTER TABLE ENROLLMENT
ADD COLUMN FeesPaid VARCHAR(3);

-- 22. Update date of enrollment of society id ‘s1’ to ‘2018-01-15’, ‘s2’ to current date and ‘s3’ to ‘2018-01-02’.
UPDATE ENROLLMENT
SET DateOfEnrollment = CASE
    WHEN SID = 's1' THEN '2018-01-15'
    WHEN SID = 's2' THEN CURDATE()
    WHEN SID = 's3' THEN '2018-01-02'
END
WHERE SID IN ('s1', 's2', 's3');

-- 23. Create a view to keep track of society names with the total number of students enrolled in it.
CREATE VIEW SocietyEnrollment AS
SELECT S.SName, COUNT(E.RollNo) AS TotalStudents
FROM SOCIETY S
LEFT JOIN ENROLLMENT E ON S.SID = E.SID
GROUP BY S.SName;
