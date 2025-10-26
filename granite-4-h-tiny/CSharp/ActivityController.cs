// ActivityController.cs (Minimal API Equivalent)
[ApiController]
[Route("api/[controller]")]
public class ActivityController : ControllerBase
{
    private readonly IRepository<Activity> _activityRepository;

    public ActivityController(IRepository<Activity> activityRepository)
    {
        _activityRepository = activityRepository;
    }

    [HttpGet]
    public async Task<IActionResult> Get() => Ok(await _activityRepository.Get());

    [HttpPost]
    public async Task<IActionResult> Post([FromBody] CreateDto activity) 
    {
        var entity = AutoMapper.Mapper.Map<Activity>(activity);
        await _activityRepository.Add(entity);
        return CreatedAtAction(nameof(GetById), new { id = entity.ActivityId }, entity);
    }

    // Implement other CRUD methods...
}
