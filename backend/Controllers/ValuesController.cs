using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers
{
    [Route("api/[controller]")]
    public class ValuesController : Controller
    {
        // GET api/values
        [HttpGet]
        public JsonResult Get()
        {
            Dictionary<string, int> values = new Dictionary<string, int>()
            {
                { "Glasgow", 16 },
                { "London", 18 },
                { "Oslo", 23 },
                { "New York", 16 },
                { "San Francisco", 12 }
            };
            return Json(values);
        }
    }
}
