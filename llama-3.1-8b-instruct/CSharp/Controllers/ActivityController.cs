// Controllers/ActivityController.cs

namespace YourNamespace.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ActivityController : ControllerBase
    {
        private readonly ActivityRepository _repository;

        public ActivityController(ActivityRepository repository)
        {
            _repository = repository;
        }

        // GET api/activity
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Activity>>> GetActivities()
        {
            return await _repository.Get();
        }

        // GET api/activity/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Activity>> GetActivity(Guid id)
        {
            return await _repository.Get(id);
        }

        // POST api/activity
        [HttpPost]
        public async Task<ActionResult<Activity>> PostActivity(Activity activity)
        {
            await _repository.Add(activity);
            return CreatedAtAction(nameof(GetActivity), new { id = activity.ActivityId }, activity);
        }

        // PUT api/activity/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutActivity(Guid id, Activity activity)
        {
            if (id != activity.ActivityId)
            {
                return BadRequest();
            }
            await _repository.Update(activity);
            return NoContent();
        }

        // DELETE api/activity/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteActivity(Guid id)
        {
            var entity = await _repository.Get(id);
            if (entity == null)
            {
                return NotFound();
            }
            await _repository.Delete(id);
            return NoContent();
        }
    }
}
