[Test]
public async Task Add_ShouldPersistEntity()
{
    // Arrange
    var mockContext = new Mock<DbContext>();
    var repository = new Repository<Activity>(mockContext.Object);

    var activity = new Activity { Name = "Test Activity", Description = "Sample description." };
    
    // Act
    await repository.Add(activity);
    var savedActivities = mockContext.Object.Set<Activity>().ToList();

    // Assert
    Assert.IsTrue(savedActivities.Any());
    Assert.AreEqual("Test Activity", savedActivities.First().Name);
}
