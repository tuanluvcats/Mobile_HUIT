using System;
using System.ComponentModel.DataAnnotations;

namespace StudentManagement.Models
{
    public class User
    {
        [Key]
        public int UserID { get; set; }
        public string FullName { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty; 
        public string Address { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public DateTime DateOfBirth { get; set; }
    }
}