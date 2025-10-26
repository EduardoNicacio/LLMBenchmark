// ViewModels/ActivityViewModels.cs

namespace YourNamespace.ViewModels
{
    public class CreateViewModel
    {
        [Required]
        public Guid ProjectId { get; set; }
        [Required]
        public Guid ProjectMemberId { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public string Description { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }
        [Range(1, 5)]
        public byte Priority { get; set; }
        [Range(1, 5)]
        public byte Risk { get; set; }
    }

    public class UpdateViewModel
    {
        [Required]
        public Guid ProjectId { get; set; }
        [Required]
        public Guid ProjectMemberId { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public string Description { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }
        [Range(1, 5)]
        public byte Priority { get; set; }
        [Range(1, 5)]
        public byte Risk { get; set; }
    }

    public class ListViewModel
    {
        public IEnumerable<Activity> Activities { get; set; }
    }
}
