// IndexModel.cs - For listing activities
using System.Collections.Generic;
using YourApp.DTOs;

namespace YourApp.Pages // Razor Pages namespace

{
    public class IndexModel : PageModel
    {
        [BindProperty]
        public List<ReadActivityDto> Activities { get; set; } = new();
        
        // Pagination properties (optional)
        public int CurrentPage { get; set; }
        public int TotalPages { get; set; }

        private readonly IRepository<Activity> _activityRepository;

        public IndexModel(IRepository<Activity> activityRepository)
        {
            _activityRepository = activityRepository;
        }

        public async Task OnGetAsync(int page = 1, int pageSize = 10)
        {
            var query = _activityRepository.Get();
            
            // Apply pagination
            Activities = query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(a => new ReadActivityDto
                {
                    ActivityId = a.ActivityId,
                    ProjectId = a.ProjectId,
                    ProjectMemberId = a.ProjectMemberId,
                    Name = a.Name,
                    Description = a.Description,
                    StartDate = a.StartDate,
                    TargetDate = a.TargetDate,
                    EndDate = a.EndDate,
                    ProgressStatus = a.ProgressStatus,
                    ActivityPoints = a.ActivityPoints,
                    Priority = a.Priority,
                    Risk = a.Risk,
                    Tags = a.Tags,
                    ActiveFlag = a.ActiveFlag,
                    SystemDeleteFlag = a.SystemDeleteFlag,
                    CreatedDateTime = a.CreatedDateTime,
                    CreatedByUser = a.CreatedByUser,
                    CreatedByProgram = a.CreatedByProgram,
                    UpdatedDateTime = a.UpdatedDateTime,
                    UpdatedByUser = a.UpdatedByUser,
                    UpdatedByProgram = a.UpdatedByProgram,
                    SystemTimestamp = a.SystemTimestamp
                })
                .ToList();
        }
    }
}
