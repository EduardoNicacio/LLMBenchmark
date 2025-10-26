// Activity.cs
using System.ComponentModel.DataAnnotations;

public class Activity
{
    [Key]
    public Guid ActivityId { get; set; }
    
    public Guid ProjectId { get; set; }
    public Guid ProjectMemberId { get; set; }
    
    [Required, StringLength(128)]
    public string Name { get; set; }
    
    [Required]
    public string Description { get; set; }
    
    public DateTime? StartDate { get; set; }
    public DateTime? TargetDate { get; set; }
    public DateTime? EndDate { get; set; }
    
    [Range(0, 100)]
    public int ProgressStatus { get; set; } // Assuming a scale from 0 to 100

    [Range(1, 10)]
    public int Priority { get; set; } // Simplified for example
    
    [Range(1, 10)]
    public int Risk { get; set; } // Simplified for example

    [Required]
    public bool ActiveFlag { get; set; }
    
    [Required, StringLength(1)]
    public char SystemDeleteFlag { get; set; } // Assuming 'Y' or 'N'
    
    [Required]
    public DateTime CreatedDateTime { get; set; }
    
    [Required, StringLength(100)]
    public string CreatedByUser { get; set; }

    [Required]
    public bool CreatedByProgram { get; set; }

    public DateTime? UpdatedDateTime { get; set; }
    
    [Required, StringLength(100)]
    public string UpdatedByUser { get; set; } // Nullable for potential future updates

    [Required]
    public Guid ProjectMemberIdForActivity { get; set; } // Assuming Activity has a relationship with ProjectMember
}
