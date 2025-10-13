using Microsoft.AspNetCore.Mvc;
using YourNamespace.Repositories;
using YourNamespace.DTOs;
using System.Threading.Tasks;
using System;

namespace YourNamespace.MinimalApi
{
    [Route("api/[controller]")]
    public class ActivitiesController : ControllerBase
    {
        private readonly ActivityRepository _activityRepo;

        public ActivitiesController(ActivityRepository activityRepo)
        {
            _activityRepo = activityRepo;
        }

        // GET: api/activities
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var activities = await _activityRepo.GetAllAsync();
            return Ok(activities);
        }

        // POST: api/activities
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] ActivityCreateDto activityDto)
        {
            // Implement create logic...
        }

        // PUT: api/activities/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Put(Guid id, [FromBody] ActivityUpdateDto activityDto)
        {
            // Implement update logic...
        }

        // DELETE: api/activities/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            // Implement delete logic...
        }
    }
}
