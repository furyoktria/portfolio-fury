WITH Table_1 AS
(SELECT Employee.name, Bonus.bonus
FROM Bonus
RIGHT JOIN Employee
ON Employee.empId = Bonus.empId)

SELECT *
FROM Table_1
WHERE Bonus IS NULL 
OR Bonus < '1000' ;