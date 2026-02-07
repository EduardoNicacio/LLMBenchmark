// EditModel.cs - For editing existing activity
using System.ComponentModel.DataAnnotations;
using YourApp.DTOs;

namespace YourApp.Pages

{
    public class EditModel : PageModel
    {
        [BindProperty]
        public UpdateActivityDto UpdateActivityDto { get; set; } = new();

        private readonly IRepository<Activity> _activityRepository;

        public EditModel(IRepository<Activity> activityRepository)
        {
            _activityRepository = activityRepository;
        }

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            var activity = _activityRepository.GetById(id);
            if (activity == null) return NotFound();
            
            UpdateActivityDto.ActivityId = activity.ActivityId;
            UpdateActivityDto.ProjectId = activity.ProjectId;
            UpdateActivityDto.ProjectMemberId = activity.ProjectMemberId;
            UpdateActivityDto.Name = activity.Name;
            UpdateActivityDto.Description = activity.Description;
            UpdateActivityDto.StartDate = activity.StartDate;
            UpdateActivityDto.TargetDate = activity.TargetDate;
            UpdateActivityDto.EndDate = activity.EndDate;
            UpdateActivityDto.ProgressStatus = activity.ProgressStatus;
            UpdateActivityDto.ActivityPoints = activity.ActivityPoints;
            UpdateActivityDto.Priority = activity.Priority;
            UpdateActivityDto.Risk = activity.Risk;
            UpdateActivityDto.Tags = activity.Tags;
            UpdateActivityDto.ActiveFlag = activity.ActiveFlag;
            UpdateActivityDto.SystemDeleteFlag = activity.SystemDeleteFlag;
            UpdateActivityDto.UpdatedDateTime = activity.UpdatedDateTime;
            UpdateActivityDto.UpdatedByUser = activity.UpdatedByUser;
            UpdateActivityDto.UpdatedByProgram = activity.UpdatedByProgram;

            return Page();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid) return Page();
            
            var entity = _activityRepository.GetById(UpdateActivityDto.ActivityId);
            if (entity == null) return NotFound();

            // Update properties
            entity.ProjectId = UpdateActivityDto.ProjectId;
            entity.ProjectMemberId = UpdateActivityDto.ProjectMemberId;
            entity.Name = UpdateActivityDto.Name;
            entity.Description = UpdateActivityDto.Description;
            entity.StartDate = UpdateActivityDto.StartDate;
            entity.TargetDate = UpdateActivityDto.TargetDate;
            entity.EndDate = UpdateActivityDto.EndDate;
            entity.ProgressStatus = UpdateActivityDto.ProgressStatus;
            entity.ActivityPoints = UpdateActivityDto.ActivityPoints;
            entity.Priority = UpdateActivityDto.Priority;
            entity.Risk = UpdateActivityDto.Risk;
            entity.Tags = UpdateActivityDto.Tags;
            entity.ActiveFlag = UpdateActivityDto.ActiveFlag;
            entity.SystemDeleteFlag = UpdateActivityDto.SystemDeleteFlag;
            entity.UpdatedDateTime = DateTime.UtcNow;
            entity.UpdatedByUser = UpdateActivityDto.UpdatedByUser;
            entity.UpdatedByProgram = UpdateActivityDto.UpdatedByProgram;

            _activityRepository.Update(entity);
            
            return RedirectToPage("./Index");
        }
    }
}
