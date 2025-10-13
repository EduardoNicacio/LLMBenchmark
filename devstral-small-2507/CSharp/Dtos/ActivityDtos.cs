using System;
using System.ComponentModel.DataAnnotations;

namespace ActivityManagement.Dtos
{
    // Create DTO
    public class CreateActivityDto
    {
        [Required]
        public Guid ProjectId { get; set; }

        [Required]
        public Guid ProjectMemberId { get; set; }

        [Required]
        [StringLength(128)]
        public string Name { get; set; }

        [Required]
        [StringLength(4000)]
        public string Description { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? TargetDate { get; set; }

        public DateTime? EndDate { get; set; }

        public byte? ProgressStatus { get; set; }

        public short? ActivityPoints { get; set; }

        public byte? Priority { get; set; }

        public byte? Risk { get; set; }

        [StringLength(200)]
        public string Tags { get; set; }

        [Required]
        public bool ActiveFlag { get; set; }
    }

    // Update DTO
    public class UpdateActivityDto
    {
        [Required]
        public Guid ActivityId { get; set; }

        [Required]
        public Guid ProjectId { get; set; }

        [Required]
        public Guid ProjectMemberId { get; set; }

        [Required]
        [StringLength(128)]
        public string Name { get; set; }

        [Required]
        [StringLength(4000)]
        public string Description { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? TargetDate { get; set; }

        public DateTime? EndDate { get; set; }

        public byte? ProgressStatus { get; set; }

        public short? ActivityPoints { get; set; }

        public byte? Priority { get; set; }

        public byte? Risk { get; set; }

        [StringLength(200)]
        public string Tags { get; set; }

        [Required]
        public bool ActiveFlag { get; set; }
    }

    // Read DTO
    public class ReadActivityDto
    {
        public Guid ActivityId { get; set; }

        public Guid ProjectId { get; set; }

        public Guid ProjectMemberId { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? TargetDate { get; set; }

        public DateTime? EndDate { get; set; }

        public byte? ProgressStatus { get; set; }

        public short? ActivityPoints { get; set; }

        public byte? Priority { get; set; }

        public byte? Risk { get; set; }

        public string Tags { get; set; }

        public bool ActiveFlag { get; set; }

        public DateTime CreatedDateTime { get; set; }
    }
}
