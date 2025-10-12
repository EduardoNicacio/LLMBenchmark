using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data;
using MyApp.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyApp.Pages.Activities
{
    public class UpdateViewModel : PageModel
    {
        private readonly AppDbContext _context;
        public const int MaxTagsLength = 200;

        public UpdateViewModel(AppDbContext context)
        {
            _context = context;
        }

        [BindProperty]
        public ActivityUpdateDto? Model { get; set; } = new();

        // Dropdown data
        public List<ProjectSelectDto> AvailableProjects { get; set; } = new();
        public List<ProjectMemberSelectDto> AvailableMembers { get; set; } = new();

        public async Task OnGetAsync(Guid activityId)
        {
            if (activityId == Guid.Empty) return;

            var activity = await _context.Activities
                .Where(a => a.ActivityId == activityId && !a.SystemDeleteFlag.Equals('Y'))
                .FirstOrDefaultAsync();

            if (activity == null)
            {
                // 404 handling – you could redirect to Index or show message.
                return;
            }

            Model = new ActivityUpdateDto
            {
                ActivityId      = activity.ActivityId,
                Name            = activity.Name,
                Description     = activity.Description,
                ProjectId       = activity.ProjectId,
                ProjectMemberId = activity.ProjectMemberId,
                StartDate       = activity.StartDate,
                TargetDate      = activity.TargetDate,
                EndDate         = activity.EndDate,
                ProgressStatus  = activity.ProgressStatus,
                ActivityPoints  = activity.ActivityPoints,
                Priority        = activity.Priority,
                Risk            = activity.Risk,
                Tags            = activity.Tags,
                ActiveFlag      = (short)activity.ActiveFlag,
                SystemDeleteFlag= (char)activity.SystemDeleteFlag
            };

            // Populate dropdowns for completeness.
            AvailableProjects = await _context.Projects.ToListAsync();
            foreach (var p in AvailableProjects)
                p.ProjectId = p.Id;

            AvailableMembers = await _context.ProjectMembers.ToListAsync();
            foreach (var m in AvailableMembers)
                m.ProjectMemberId = m.Id;
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid) return Page();

            var activity = await _context.Activities
                .Where(a => a.ActivityId == Model.ActivityId && !a.SystemDeleteFlag.Equals('Y'))
                .FirstOrDefaultAsync();

            if (activity == null)
            {
                // Should not happen; treat as 404.
                return Page();
            }

            // Apply changes
            activity.Name               = Model.Name;
            activity.Description        = Model.Description;
            activity.ProjectId          = Model.ProjectId;
            activity.ProjectMemberId    = Model.ProjectMemberId;

            activity.StartDate          = Model.StartDate ?? activity.StartDate;
            activity.TargetDate         = Model.TargetDate ?? activity.TargetDate;
            activity.EndDate            = Model.EndDate ?? activity.EndDate;
            activity.ProgressStatus     = Model.ProgressStatus ?? activity.ProgressStatus;
            activity.ActivityPoints     = Model.ActivityPoints ?? activity.ActivityPoints;
            activity.Priority           = Model.Priority ?? activity.Priority;
            activity.Risk               = Model.Risk ?? activity.Risk;
            activity.Tags              = string.IsNullOrWhiteSpace(Model.Tags) ? null : Model.Tags;

            // Soft delete flag
            if (Model.SystemDeleteFlag != activity.SystemDeleteFlag)
                activity.SystemDeleteFlag = Model.SystemDeleteFlag;

            // Active flag – keep existing unless changed.
            if (Model.ActiveFlag != activity.ActiveFlag)
                activity.ActiveFlag = Model.ActiveFlag;

            // Audit fields
            activity.UpdatedDateTime   = DateTime.UtcNow;
            activity.UpdatedByUser     = "system";
            activity.UpdatedByProgram  = "EditPage";

            await _context.SaveChangesAsync();

            return Page("/Index");
        }
    }

    public class ActivityUpdateDto
    {
        [Required, Display(Name = "Activity Id")]
        public Guid ActivityId { get; set; } = default!;

        [Required, StringLength(maxlength: 128)]
        public string Name { get; set; } = null!;

        [Required, StringLength(maxlength: 4000)]
        public string Description { get; set; } = null!;

        [Required]
        public string ProjectId { get; set; } = null!;

        [Required]
        public string ProjectMemberId { get; set; } = null!;

        [Display(Name = "Start Date")]
        public DateTime? StartDate { get; set; }

        [Display(Name = "Target Date")]
        public DateTime? TargetDate { get; set; }

        [Display(Name = "End Date")]
        public DateTime? EndDate { get; set; }

        [Display(Name = "Progress Status")]
        public short? ProgressStatus { get; set; }

        [Display(Name = "Activity Points")]
        public short? ActivityPoints { get; set; }

        [Display(Name = "Priority")]
        public short? Priority { get; set; }

        [Display(Name = "Risk")]
        public short? Risk { get; set; }

        [StringLength(maxlength: MaxTagsLength)]
        public string Tags { get; set; } = null!;

        // Flags
        public short ActiveFlag { get; set; } = 1;
        public char SystemDeleteFlag { get; set; } = 'N';
    }
}
