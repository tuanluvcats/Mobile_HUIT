USE StudentManagementDB;
GO
INSERT INTO Results (UserID, SubjectName, SubjectCode, Semester, AcademicYear, ProcessScore, ExamScore, FinalGrade)
VALUES 
(1, N'Cơ sở lập trình', 'CS101', N'Học kỳ 1', '2023-2024', 8.5, 7.0, 'B'),
(1, N'Cơ sở dữ liệu', 'CS102', N'Học kỳ 1', '2023-2024', 9.0, 8.5, 'A'),
(1, N'Lập trình hướng đối tượng', 'CS103', N'Học kỳ 2', '2023-2024', 7.5, 8.0, 'B');