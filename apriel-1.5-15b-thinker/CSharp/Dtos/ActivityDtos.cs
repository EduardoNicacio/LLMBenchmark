// Models/Dtos/ActivityCreateDto.cs
using System.ComponentModel.DataAnnotations;

namespace MyApp.Models.Dtos
{
    public class ActivityCreateDto
    {
        // Required fields (excluding auto‑generated columns)
        [Required]
        public Guid ProjectId { get; set; }

        [Required]
        public Guid ProjectMemberId { get; set; }

        [Required, MaxLength(128)]
        public string Name { get; set; } = null!;

        [Required, MaxLength(4000)]
        public string Description { get; set; } = null!;

        [AllowNullable]
        public DateTime? StartDate { get; set; }

        [AllowNullable]
        public DateTime? TargetDate { get; set; }

        [AllowNullable]
        public DateTime? EndDate { get; set; }

        [AllowNullable]
        public short? ProgressStatus { get; set; }

        [AllowNullable]
        public short? ActivityPoints { get; set; }

        [AllowNullable]
        public short? Priority { get; set; }

        [AllowNullable]
        public short? Risk { get; set; }

        [AllowNullable]
        public string Tags { get; set; } = null!;

        // System columns – defaults are enforced in the service layer
        [Required]               // ActiveFlag is mandatory by DB schema
        public short ActiveFlag { get; set; }

        [Default('N')]
        public char SystemDeleteFlag { get; set; }
    }
}

// Models/Dtos/ActivityUpdateDto.cs
namespace MyApp.Models.Dtos
{
    public class ActivityUpdateDto
    {
        // All mutable columns – nullable to allow partial updates
        [AllowNullable]
        public string? Name { get; set; }

        [AllowNullable]
        public string? Description { get; set; }

        [AllowNullable]
        public DateTime? StartDate { get; set; }

        [AllowNullable]
        public DateTime? TargetDate { get; set; }

        [AllowNullable]
        public DateTime? EndDate { get; set; }

        [AllowNullable]
        public short? ProgressStatus { get; set; }

        [AllowNullable]
        public short? ActivityPoints { get; set; }

        [AllowNullable]
        public short? Priority { get; set; }

        [AllowNullable]
        public short? Risk { get; set; }

        [AllowNullable]
        public string Tags { get; set; } = null!;

        // Soft‑delete flag can be toggled
        [AllowNullable]
        public char? SystemDeleteFlag { get; set; }

        // ActiveFlag is rarely changed but exposed for completeness
        [AllowNullable]
        public short? ActiveFlag { get; set; }
    }
}

// Models/Dtos/ActivityReadDto.cs
namespace MyApp.Models.Dtos
{
    public class ActivityReadDto
    {
        public Guid ActivityId { get; set; }

        public Guid ProjectId { get; set; }
        public Guid ProjectMemberId { get; set; }

        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;

        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }

        public short? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public short? Priority { get; set; }
        public short? Risk { get; set; }

        public string Tags { get; set; } = string.Empty;

        public short ActiveFlag { get; set; }
        public char SystemDeleteFlag { get; set; }

        public DateTime CreatedDateTime { get; set; }
        public string CreatedByUser { get; set; } = string.Empty;
        public string CreatedByProgram { get; set; } = string.Empty;

        public DateTime? UpdatedDateTime { get; set; }
        public string? UpdatedByUser { get; set; }
        public string? UpdatedByProgram { get; set; }

        // Optional – only returned on DELETE endpoint
        public DateTime? DeletedAt { get; set; }
    }
}
