USE StudentDB;
GO

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName NVARCHAR(100),
    Credits INT,
    Department NVARCHAR(50)
);
GO

INSERT INTO Courses (CourseName, Credits, Department)
VALUES 
('Introduction to Databases', 3, 'Computer Science'),
('Web Development', 4, 'Computer Science'),
('Data Structures', 4, 'Computer Science');
GO

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    EnrollmentDate DATE,
    Grade NVARCHAR(2)
);
GO
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, Grade)
VALUES 
(1, 1, '2023-09-01', 'A'),
(1, 2, '2023-09-01', 'B'),
(2, 1, '2023-09-01', 'A'),
(3, 3, '2023-09-15', 'C');
GO
INSERT INTO Courses (CourseName, Credits, Department)
VALUES 
('Introduction to Databases', 3, 'Computer Science'),
('Web Development', 4, 'Computer Science'),
('Data Structures', 4, 'Computer Science');
GO
