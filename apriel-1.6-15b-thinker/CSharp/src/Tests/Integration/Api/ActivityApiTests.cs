// Tests/Integration/ActivityApiTests.cs
using Microsoft.AspNetCore.Mvc;
using Moq;
using MyApp.Data.Dtos;
using MyApp.Data.Repositories;
using MyApp.Api.Controllers;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyApp.Tests.Integration;

[TestFixture]
public class ActivityApiTests
{
    private readonly Mock<IActivityRepository> _repoMock;
    private ActivityApiController _controller;

    [SetUp]
    public void Setup()
    {
        _repoMock = new Mock<IActivityRepository>();
        // Arrange a list of activities for GET tests.
        var sampleDtos = new List<ReadActivityDto>
        {
            new ReadActivityDto
            {
                ActivityId   = Guid.NewGuid(),
                ProjectId    = Guid.NewGuid(),
                Name         = "API Test 1"
            },
            new ReadActivityDto { ActivityId = Guid.NewGuid(), Name = "API Test 2" }
        };
        _repoMock.Setup(r => r.GetAllWithDetailsAsync()).Returns(Task.FromResult(sampleDtos));

        // Arrange GetById
        var first = sampleDtos.First();
        _repoMock.Setup(r => r.GetByIdAsync(first.ActivityId)).Returns(first);

        _controller = new ActivityApiController(_repoMock.Object);
    }

    [Test]
    public async Task GetActivities_ReturnsList()
    {
        // Act
        var result = await _controller.GetActivities();

        // Assert
        Assert.IsType<List<ReadActivityDto>>(result.Value);
        Assert.AreEqual(2, (result.Value as List<ReadActivityDto>).Count);
    }

    [Test]
    public async Task GetActivity_ReturnsNotFound_WhenMissing()
    {
        var unknownId = Guid.NewGuid();
        var result = await _controller.GetActivity(unknownId);

        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Test]
    public async Task PostActivity_AddsEntityToRepository()
    {
        // Arrange
        var dto = new CreateActivityDto
        {
            ProjectId      = Guid.NewGuid().ToString(),
            ProjectMemberId= Guid.NewGuid().ToString(),
            Name           = "New API Activity",
            Description    = "Desc",
            ActiveFlag     = 1,
            SystemDeleteFlag='N',
            CreatedByUser   = "API User"
        };

        // Act
        var result = await _controller.PostActivity(dto);

        // Assert
        Assert.IsType<RedirectToActionResult>(result.Result);
        var url = (result.Value as RedirectToActionResult).Url;
        Assert.Contains("GetActivity", url!);

        // Verify repository AddAsync called once with a new entity.
        _repoMock.Verify(r => r.AddAsync(It.IsAny<Activity>()), Times.Once);
    }

    [Test]
    public async Task PutActivity_UpdatesEntity()
    {
        var dto = new UpdateActivityDto
        {
            ActivityId   = Guid.NewGuid(),
            ProjectId    = Guid.NewGuid().ToString(),
            Name         = "Edited",
            Description  = "Updated"
        };

        // Arrange: mock GetByIdAsync to return an existing entity.
        var existingEntity = new Activity { ActivityId = dto.ActivityId };
        _repoMock.Setup(r => r.GetByIdAsync(dto.ActivityId)).Returns(existingEntity);

        // Act
        var result = await _controller.PutActivity(dto, dto.ActivityId);

        // Assert
        Assert.IsType<NoContentResult>(result.Result);
        _repoMock.Verify(r => r.UpdateAsync(It.Is<Activity>(a => a.ActivityId == dto.ActivityId)), Times.Once);
    }

    [Test]
    public async Task DeleteActivity_RemovesEntity()
    {
        var id = Guid.NewGuid();
        var entity = new Activity { ActivityId = id };
        _repoMock.Setup(r => r.GetByIdAsync(id)).Returns(entity);

        var result = await _controller.DeleteActivity(id);
        Assert.IsType<NoContentResult>(result.Result);
        _repoMock.Verify(r => r.DeleteAsync(It.Is<Activity>(a => a.ActivityId == id)), Times.Once);
    }
}
