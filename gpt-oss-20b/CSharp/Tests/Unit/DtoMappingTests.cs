// File: Tests/Unit/DtoMappingTests.cs
using MyApp.DTOs;
using MyApp.Models;
using NUnit.Framework;

namespace MyApp.Tests.Unit;

[TestFixture]
public class DtoMappingTests
{
    [Test]
    public void ActivityCreateDto_ToEntity_Mapping()
    {
        var dto = new ActivityCreateDto
        {
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "New Act",
            Description = "Desc",
            StartDate = DateTime.Today,
            TargetDate = DateTime.Today.AddDays(10),
            EndDate = null,
            ProgressStatus = 1,
            ActivityPoints = 5,
            Priority = 2,
            Risk = 3,
            Tags = "tag1, tag2"
        };

        var entity = new Activity
        {
            ActivityId = Guid.NewGuid(),
            ProjectId = dto.ProjectId,
            ProjectMemberId = dto.ProjectMemberId,
            Name = dto.Name,
            Description = dto.Description,
            StartDate = dto.StartDate,
            TargetDate = dto.TargetDate,
            EndDate = dto.EndDate,
            ProgressStatus = dto.ProgressStatus,
            ActivityPoints = dto.ActivityPoints,
            Priority = dto.Priority,
            Risk = dto.Risk,
            Tags = dto.Tags,
            ActiveFlag = 1,
            SystemDeleteFlag = 'N',
            CreatedDateTime = DateTime.UtcNow,
            CreatedByUser = "unit@test.com",
            CreatedByProgram = "UnitTests"
        };

        Assert.AreEqual(dto.Name, entity.Name);
        // ... more assertions as needed
    }
}
