// C# Model (Activity.cs)
using System;

namespace MyApplication.Models
{
    public class Activity
    {
        public Guid ActivityId { get; set; } // Unique identifier for the activity
        public Guid ProjectId { get; set; } // Foreign key to the Project table
        public Guid ProjectMemberId { get; set; } // Foreign key to the ProjectMember table
        public string Name { get; set; } = ""; // Activity name (required)
        public string Description { get; set; } = ""; // Activity description
        public DateTime? StartDate { get; set; } // Start date of the activity
        public DateTime? TargetDate { get; set; } // Target completion date
        public DateTime? EndDate { get; set; } // Actual end date
        public byte? ProgressStatus { get; set; } // Current progress status (e.g., 0-100)
        public short? ActivityPoints { get; set; } // Estimated effort in activity points
        public byte? Priority { get; set; } // Priority level (e.g., 1-5)
        public byte? Risk { get; set; } // Risk assessment (e.g., 1-5)
        public string Tags { get; set; } = ""; // Comma-separated tags for categorization
        public byte ActiveFlag { get; set; } // Flag indicating if the activity is active
        public char SystemDeleteFlag { get; set; } // Flag to prevent accidental deletion
        public DateTime CreatedDateTime { get; set; } // Timestamp of creation
        public string CreatedByUser { get; set; } = ""; // User who created the record
        public string CreatedByProgram { get; set; } = ""; // Program used for creation
        public DateTime? UpdatedDateTime { get; set; } // Timestamp of last update
        public string UpdatedByUser { get; set; } = ""; // User who last updated the record
        public string UpdatedByProgram { get; set; } = ""; // Program used for updating
        public byte[] SystemTimestamp { get; set; } // Row versioning timestamp
    }
}

