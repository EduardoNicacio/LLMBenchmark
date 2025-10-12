using global::Microsoft.EntityFrameworkCore;
using Moq;
using MyApp.Data;
using MyApp.Repositories;
using MyApp.Models;
using System.Collections.Generic;
using System.Threading.Tasks;
using static FluentAssertions.FluentAssertions;

namespace MyApp.Tests.Integration;

[TestFixture]
public class ActivityRepositoryTests
{
    private readonly Mock<IDbContextFactory<ActivityDbContext>> _dbContextFactoryMock;
    private readonly Mock<IActivityRepository> _activityRepositoryMock;
    private ActivityRepository _repositoryUnderTest;

    [SetUp]
    public void SetUp()
    {
        // Arrange mocks
        _dbContextFactoryMock = new Mock<IDbContextFactory<ActivityDbContext>>();
        _activityRepositoryMock = new Mock<IActivityRepository>();

        // Stub the repository to use the mocked context factory.
        var activityRepo = new ActivityRepository(_dbContextFactoryMock.Object, _activityRepositoryMock.Object);
        _repositoryUnderTest = activityRepo;
    }

    [Test]
    public async Task GetById_ShouldReturnActivityWhenExists()
    {
        // Arrange
        var activityId = Guid.NewGuid();
        var expectedActivity = new Activity
        {
            ActivityId = activityId,
            ProjectId = Guid.NewGuid(),
            Name = "Existing"
        };
        _activityRepositoryMock.Setup(r => r.GetByIdAsync(activityId)).ReturnsAsync(expectedActivity);

        // Act
        var actual = await _repositoryUnderTest.GetByIdAsync(activityId);

        // Assert
        actual.Should().BeOfType<Activity>();
        actual!.ActivityId.Should().Be(activityId);
        actual.Should().Equal(expectedActivity);
    }

    [Test]
    public async Task Add_ShouldPersistEntity()
    {
        // Arrange
        var newActivity = new Activity { ProjectId = Guid.NewGuid(), Name = "New" };
        _activityRepositoryMock.Setup(r => r.AddAsync(newActivity)).Returns(Task.CompletedTask);

        // Act
        await _repositoryUnderTest.AddAsync(newActivity);

        // Assert
        _activityRepositoryMock.Verify(r => r.AddAsync(newActivity), Times.Once);
    }

    [Test]
    public async Task Update_ShouldUpdateEntity()
    {
        // Arrange
        var activity = new Activity { ActivityId = Guid.NewGuid(), Name = "Old" };
        var updatedName = "New";
        _activityRepositoryMock.Setup(r => r.UpdateAsync(activity)).Returns(Task.CompletedTask);
        _activityRepositoryMock.Setup(r => r.GetByIdAsync(activity.ActivityId)).ReturnsAsync(activity);

        // Act
        await _repositoryUnderTest.UpdateAsync(activity, updatedName);

        var callArgs = VerifyUpdateCall();
        callArgs[1].Should().Equal(updatedName);

        // Assert
        _activityRepositoryMock.VerifyAllCalls();
    }

    [Test]
    public async Task Delete_ShouldDeleteEntity()
    {
        // Arrange
        var activityId = Guid.NewGuid();
        _activityRepositoryMock.Setup(r => r.DeleteAsync(activityId)).Returns(Task.CompletedTask);

        // Act
        await _repositoryUnderTest.DeleteAsync(activityId);

        // Assert
        _activityRepositoryMock.Verify(r => r.DeleteAsync(activityId), Times.Once);
    }

    private void VerifyUpdateCall()
    {
        var calls = _activityRepositoryMock.CallsMade();
        // The UpdateAsync method should have been called once.
        var updateCalls = calls.Where(c => c.Method.Name == nameof(ActivityRepository.UpdateAsync)).ToArray();
        return updateCalls;
    }
}
