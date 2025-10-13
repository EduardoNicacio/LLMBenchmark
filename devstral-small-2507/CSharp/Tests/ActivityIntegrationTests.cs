using Moq;
using Xunit;
using Microsoft.EntityFrameworkCore;
using System.Linq;

public class RepositoryTests
{
    [Fact]
    public async Task GetAllActiveAsync_ShouldReturnOnlyActiveActivities()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "TestDatabase")
            .Options;

        using (var context = new AppDbContext(options))
        {
            context.Activities.Add(new Activity { ActiveFlag = 1 });
            context.Activities.Add(new Activity { ActiveFlag = 0 });
            await context.SaveChangesAsync();
        }

        var mockSet = new Mock<DbSet<Activity>>();
        var mockContext = new Mock<AppDbContext>();

        mockContext.Setup(c => c.Activities).Returns(mockSet.Object);

        // Act
        var repository = new ActivityRepository(mockContext.Object);
        var result = await repository.GetAllActiveAsync();

        // Assert
        Assert.Single(result);
    }
}

public class ApiTests
{
    [Fact]
    public async Task GetActivity_ShouldReturnOkResult()
    {
        // Arrange
        var activityId = Guid.NewGuid();
        var mockRepository = new Mock<IActivityRepository>();
        mockRepository.Setup(repo => repo.GetByIdAsync(activityId))
            .ReturnsAsync(new Activity { ActivityId = activityId, Name = "Test" });

        var app = new WebApplicationBuilder().Build();

        // Act
        var response = await app.TestClient().GetAsync($"/api/activities/{activityId}");

        // Assert
        Assert.Equal(System.Net.HttpStatusCode.OK, response.StatusCode);
    }
}

public class PageTests
{
    [Fact]
    public async Task IndexPage_ShouldLoadActivities()
    {
        // Arrange
        var mockRepository = new Mock<IActivityRepository>();
        mockRepository.Setup(repo => repo.GetAllActiveAsync())
            .ReturnsAsync(new List<Activity>
            {
                new Activity { Name = "Test Activity 1" },
                new Activity { Name = "Test Activity 2" }
            });

        var pageModel = new IndexModel(mockRepository.Object);

        // Act
        await pageModel.OnGetAsync();

        // Assert
        Assert.Equal(2, pageModel.Activities.Count());
        Assert.Contains(pageModel.Activities, a => a.Name == "Test Activity 1");
    }
}
