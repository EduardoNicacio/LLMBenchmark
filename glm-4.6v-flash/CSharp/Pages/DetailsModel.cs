// DetailsModel.cs - For viewing activity details
using System.ComponentModel.DataAnnotations;
using YourApp.DTOs;

namespace YourApp.Pages

{
    public class DetailsModel : PageModel
    {
        [BindProperty]
        public ReadActivityDto Activity { get; set; } = new();

        private readonly IRepository<Activity> _activityRepository;

        public DetailsModel(IRepository<Activity> activityRepository)
        {
            _activityRepository = activityRepository;
        }

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            var activity = _activityRepository.GetById(id);
            if (activity == null) return NotFound();
            
            Activity = new ReadActivityDto
            {
                ActivityId = activity.ActivityId,
                ProjectId = activity.ProjectId,
                ProjectMemberId = activity.ProjectMemberId,
                Name = activity.Name,
                Description = activity.Description,
                StartDate = activity.StartDate,
                TargetDate = activity.TargetDate,
                EndDate = activity.EndDate,
                ProgressStatus = activity.ProgressStatus,
                ActivityPoints = activity.ActivityPoints,
                Priority = activity.Priority,
                Risk = activity.Risk,
                Tags = activity.Tags,
                ActiveFlag = activity.ActiveFlag,
                SystemDeleteFlag = activity.SystemDeleteFlag,
                CreatedDateTime = activity.CreatedDateTime,
                CreatedByUser = activity.CreatedByUser,
                CreatedByProgram = activity.CreatedByProgram,
                UpdatedDateTime = activity.UpdatedDateTime,
                UpdatedByUser = activity.UpdatedByUser,
                UpdatedByProgram = activity.UpdatedByProgram,
                SystemTimestamp = activity.SystemTimestamp
            };
            
            return Page();
        }
    }
}
