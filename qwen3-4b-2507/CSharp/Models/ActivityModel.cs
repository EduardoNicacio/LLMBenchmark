// C# Model: ActivityModel.cs
/// <summary>
/// Represents the Activity entity in the database.
/// </summary>
public class ActivityModel
{
    /// <summary>
    /// Unique identifier for the activity (Primary Key).
    /// </summary>
    public Guid ActivityId { get; set; }

    /// <summary>
    /// The project this activity belongs to.
    /// </summary>
    public Guid ProjectId { get; set; }

    /// <summary>
    /// The project member assigned to this activity.
    /// </summary>
    public Guid ProjectMemberId { get; set; }

    /// <summary>
    /// Name of the activity (must not be null).
    /// </summary>
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Description of the activity (must not be null).
    /// </summary>
    public string Description { get; set; } = string.Empty;

    /// <summary>
    /// Start date of the activity.
    /// </summary>
    public DateTime? StartDate { get; set; }

    /// <summary>
    /// Target date for completion.
    /// </summary>
    public DateTime? TargetDate { get; set; }

    /// <summary>
    /// End date of the activity.
    /// </summary>
    public DateTime? EndDate { get; set; }

    /// <summary>
    /// Progress status (0 to 100).
    /// </summary>
    public byte? ProgressStatus { get; set; }

    /// <summary>
    /// Estimated activity points (e.g., effort in points).
    /// </summary>
    public short? ActivityPoints { get; set; }

    /// <summary>
    /// Priority level (1 = Low, 2 = Medium, 3 = High, etc.).
    /// </summary>
    public byte? Priority { get; set; }

    /// <summary>
    /// Risk level (1 to 5).
    /// </summary>
    public byte? Risk { get; set; }

    /// <summary>
    /// Tags associated with the activity (comma-separated or as a string).
    /// </summary>
    public string? Tags { get; set; }

    /// <summary>
    /// Flag indicating whether the activity is active (1 = active, 0 = inactive).
    /// </summary>
    public byte ActiveFlag { get; set; } = 1;

    /// <summary>
    /// System flag indicating soft deletion (1 = deleted, 0 = not deleted).
    /// </summary>
    public char SystemDeleteFlag { get; set; } = 'N';

    /// <summary>
    /// Timestamp when the activity was created.
    /// </summary>
    public DateTime CreatedDateTime { get; set; }

    /// <summary>
    /// User who created the activity.
    /// </summary>
    public string CreatedByUser { get; set; } = string.Empty;

    /// <summary>
    /// Program or system that created the activity.
    /// </summary>
    public string CreatedByProgram { get; set; } = string.Empty;

    /// <summary>
    /// Timestamp when the activity was last updated.
    /// </summary>
    public DateTime? UpdatedDateTime { get; set; }

    /// <summary>
    /// User who last updated the activity.
    /// </summary>
    public string? UpdatedByUser { get; set; }

    /// <summary>
    /// Program or system that last updated the activity.
    /// </summary>
    public string? UpdatedByProgram { get; set; }

    /// <summary>
    /// System timestamp for concurrency control.
    /// </summary>
    public byte[] SystemTimestamp { get; set; } = Array.Empty<byte>();
}
