using Microsoft.AspNetCore.Mvc;
using StudentManagement.Data;
using System.Linq;

namespace StudentManagement.Controllers
{
    [Route("api/results")]
    [ApiController]
    public class ResultController : ControllerBase
    {
        private readonly AppDbContext _context;
        public ResultController(AppDbContext context)
        {
            _context = context;
        }
        [HttpGet("{userID}")]
        public IActionResult GetResults(int userID)
        {
            var results = _context.Results
                                  .Where(r => r.UserID == userID)
                                  .ToList();
            
            return Ok(results);
        }
    }
}