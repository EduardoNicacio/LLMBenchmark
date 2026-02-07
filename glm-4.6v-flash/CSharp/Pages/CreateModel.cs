// CreateModel.cs - For creating new activity
using System.ComponentModel.DataAnnotations;
using YourApp.DTOs;

namespace YourApp.Pages

{
    public class CreateModel : PageModel
    {
        [BindProperty]
        public CreateActivityDto CreateActivityDto { get; set; } = new();

        private readonly IRepository<Activity> _activityRepository;

        public CreateModel(IRepository<Activity> activityRepository)
        {
            _activityRepository = activityRepository;
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid) return Page();
            
            var entity = new Activity
            {
                ProjectId = CreateActivityDto.ProjectId,
                ProjectMemberId = CreateActivityDto.ProjectMemberId,
                Name = CreateActivityDto.Name,
                Description = CreateActivityDto.Description,
                StartDate = CreateActivityDto.StartDate,
                TargetDate = CreateActivityDto.TargetDate,
                EndDate = CreateActivityDto.EndDate,
                ProgressStatus = CreateActivityDto.ProgressStatus,
                ActivityPoints = CreateActivityDto.ActivityPoints,
                Priority = CreateActivityDto.Priority,
                Risk = CreateActivityDto.Risk,
                Tags = CreateActivityDto.Tags,
                ActiveFlag = CreateActivityDto.ActiveFlag,
                SystemDeleteFlag = CreateActivityDto.SystemDeleteFlag,
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = CreateActivityDto.CreatedByUser,
                CreatedByProgram = CreateActivityDto.CreatedByProgram
            };
            
            _activityRepository.Add(entity);
            
            return RedirectToPage("./Index");
        }
    }
}
