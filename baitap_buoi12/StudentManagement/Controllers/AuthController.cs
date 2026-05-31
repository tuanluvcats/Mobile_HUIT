using Microsoft.AspNetCore.Mvc;
using StudentManagement.Data;
using StudentManagement.Models;
using StudentManagement.ViewModels;

namespace StudentManagement.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;
        public AuthController(AppDbContext context)
        {
            _context = context;
        }

        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginModel model)
        {
            var user = _context.Users.FirstOrDefault(u => 
                u.Username == model.Username && u.Password == model.Password);
            if (user == null)
            {
                return Unauthorized(new { message = "Tên đăng nhập hoặc mật khẩu không đúng!" });
            }
            return Ok(new { UserID = user.UserID, FullName = user.FullName });
        }
        [HttpPost("register")]
        public IActionResult Register([FromBody] RegisterModel model)
        {
            bool isExist = _context.Users.Any(u => u.Username == model.Username || u.Email == model.Email);
            if (isExist)
            {
                return BadRequest(new { message = "Tên đăng nhập hoặc Email đã tồn tại. Vui lòng chọn tên khác!" });
            }
            var user = new User
            {
                FullName = model.FullName,
                Username = model.Username,
                Password = model.Password,
                PhoneNumber = model.PhoneNumber,
                Address = model.Address,
                Email = model.Email,
                DateOfBirth = model.DateOfBirth
            };
            _context.Users.Add(user);
            _context.SaveChanges();

            return Ok(new { message = "Đăng ký thành công!" });
        }
        [HttpPost("forgot-password")]
        public IActionResult ForgotPassword([FromBody] ForgotPasswordModel model)
        {
            var user = _context.Users.FirstOrDefault(u => u.Email == model.Email);
            if (user == null)
            {
                return NotFound(new { message = "Email không tồn tại trong hệ thống!" });
            }
            return Ok(new { message = "Vui lòng kiểm tra email để lấy lại mật khẩu." });
        }
    }
}