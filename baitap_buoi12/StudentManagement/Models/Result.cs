using System.ComponentModel.DataAnnotations;

namespace StudentManagement.Models
{
    public class Result
    {
        [Key]
        public int ResultID { get; set; }
        public int UserID { get; set; }
        public User? User { get; set; }
        public string SubjectName { get; set; } = string.Empty;
        public string SubjectCode { get; set; } = string.Empty;
        public string Semester { get; set; } = string.Empty;
        public string AcademicYear { get; set; } = string.Empty;
        public float ProcessScore { get; set; }
        public float ExamScore { get; set; }
        public string FinalGrade { get; set; } = string.Empty;
    }
}