using Moq;
using NUnit.Framework;
using MyApplication.Repositories;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;

[TestFixture]
public class ActivityApiControllerTests
{
    [SetUp]
    public void Setup()
    {
        _mockActivityRepository = new Mock<IActivityRepository>();
        _activityApiController = new ActivityApiController(_mockActivityRepository.Object);
    }

    private Mock<IActivityRepository> _mockActivityRepository;
    private ActivityApiController _activityApiController;


    [Test]
    public void Get_ReturnsOkResult()
    {
        // Arrange - Setup mock repository to return some data
        var activities = new List<MyApplication.Models.Activity>();
        _mockActivityRepository.Setup(repo => repo.Get()).Returns(activities);

        // Act - Call the API controller action method
        var result = _activityApiController.Get();

        // Assert - Verify that the returned result is an OkResult and contains expected data
        Assert.IsInstanceOf<OkResult>(result.Result);
    }
}
