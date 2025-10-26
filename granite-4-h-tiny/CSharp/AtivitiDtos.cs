// CreateDto.cs, UpdateDto.cs, ReadDto.cs (for details)
using System.ComponentModel.DataAnnotations;

public class CreateDto : Activity
{
    [Required] public string Name { get; set; }
    [Required] public string Description { get; set; }
    public DateTime? StartDate { get; set; }
    public DateTime? TargetDate { get; set; }
    // Other properties would be here...
}

public class UpdateDto : Activity
{
    [Required] public string Name { get; set; }
    [Required] public string Description { get; set; }
    // Note: EndDate, ProgressStatus, etc., are mutable but may not need to be in every update.
    public DateTime? StartDate { get; set; }
    public DateTime? TargetDate { get; set; }
}

public class ReadDto : Activity
{
    public Guid ActivityId { get; set; } // Assuming the details view needs this ID for further actions
}
