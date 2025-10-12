// Minimal API controller with endpoints for CRUD operations.
namespace YourNamespace.Controllers
{
    public class ActivitiesController : ControllerBase
    {
        private readonly IActivityRepository _repository;

        public ActivitiesController(IActivityRepository repository)
        {
            _repository = repository;
        }

        // GET, POST, PUT, DELETE endpoints for CRUD operations
    }
}
