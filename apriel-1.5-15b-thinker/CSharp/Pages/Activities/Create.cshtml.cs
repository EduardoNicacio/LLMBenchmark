using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data;
using MyApp.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyApp.Pages.Activities
{
    public class CreateViewModel : PageModel
    {
        private readonly AppDbContext _context;
        public const int MaxTagsLength = 200;

        public CreateViewModel(AppDbContext context)
        {
            _context = context;
        }

        [BindProperty]
        public ActivityCreateDto? Model { get; set; } = new();

        // Prepopulated lists for dropdowns
        public List<ProjectSelectDto> AvailableProjects { get; set; } = new();
        public List<ProjectMemberSelectDto> AvailableMembers { get; set; } = new();

        public async Task OnGetAsync()
        {
            // Populate dropdown data (assuming Project and ProjectMember entities exist)
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

            // Map view model to entity
            var activity = new Models.Activity
            {
                ActivityId      = Guid.NewGuid(),
                ProjectId       = Model.ProjectId,
                ProjectMemberId = Model.ProjectMemberId,
                Name            = Model.Name,
                Description     = Model.Description,
                StartDate       = Model.StartDate,
                TargetDate      = Model.TargetDate,
                EndDate         = Model.EndDate,
                ProgressStatus  = Model.ProgressStatus,
                ActivityPoints  = Model.ActivityPoints,
                Priority        = Model.Priority,
                Risk            = Model.Risk,
                Tags            = Model.Tags,
                ActiveFlag      = (short)Model.ActiveFlag,
                SystemDeleteFlag= (char)Model.SystemDeleteFlag,
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser   = "system",
                CreatedByProgram= "CreatePage"
            };

            _context.Activities.Add(activity);
            await _context.SaveChangesAsync();

            // After successful creation, redirect to Index
            return Page("/Index");
        }
    }

    public class ActivityCreateDto
    {
        [Required, StringLength(maxlength: 128)]
        public string Name { get; set; } = null!;

        [Required, StringLength(maxlength: 4000)]
        public string Description { get; set; } = null!;

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

        [Required]
        public string ProjectId { get; set; } = null!;

        [Required]
        public string ProjectMemberId { get; set; } = null!;

        [StringLength(maxlength: MaxTagsLength)]
        public string Tags { get; set; } = null!;

        // Soft delete and active flags
        public short ActiveFlag { get; set; } = 1;
        public char SystemDeleteFlag { get; set; } = 'N';
    }

    // DTOs for dropdown lists (simplified)
    public class ProjectSelectDto
    {
        public Guid ProjectId { get; set; }
        public string ProjectName { get; set; } = null!;
    }

    public class ProjectMemberSelectDto
    {
        public Guid ProjectMemberId { get; set; }
        public string MemberName { get; set; } = null!;
    }
}
