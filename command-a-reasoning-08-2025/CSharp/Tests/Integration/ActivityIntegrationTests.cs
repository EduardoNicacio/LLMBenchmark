namespace YourApp.Tests.Integration;

[TestFixture]
public class ActivityIntegrationTests
{
    private WebApplicationFactory<Program> _factory = null!;
    private AppDbContext _context = null!;

    [OneTimeSetUp]
    public void OneTimeSetUp() => _factory = new WebApplicationFactory<Program>();

    [SetUp]
    public void Setup() => _context = _factory.Services.GetRequiredService<AppDbContext>();

    [Test]
    public async Task AddActivity_ValidData_ShouldPersist()
    {
        var repo = new ActivityRepository(_context);
        var dto = new ActivityCreateDto { /* Valid data */ };
        var entity = dto.ToEntity();
        
        await repo.AddAsync(entity);
        await repo.SaveChangesAsync();
        
        var saved = await repo.GetByIdAsync(entity.ActivityId);
        Assert.That(saved, Is.Not.Null);
    }
}
