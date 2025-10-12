namespace MyApp.Pages.Activities
{
    public class ListViewModel
    {
        public const int PageSize = 10;
        public int? Page { get; set; } = 1;
        public int TotalCount { get; set; }
        public int PageSize { get; set; } = PageSize;

        public List<ActivityDto> Activities { get; set; } = new();
    }

    // DTO used for display in the Index page
    public class ActivityDto
    {
        public Guid ActivityId { get; set; }
        public string Name { get; set; } = null!;
        public short? ProgressStatus { get; set; }
        public DateTime CreatedDateTime { get; set; }

        // Navigation property placeholders (ProjectName, MemberName)
        public string ProjectName { get; set; } = string.Empty;
        public string MemberName   { get; set; } = string.Empty;
    }
}
