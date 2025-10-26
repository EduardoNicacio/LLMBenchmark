// File: Tests/Integration/RepositoryIntegrationTests.cs
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MyApp.Data;
using MyApp.Models;
using NUnit.Framework;

namespace MyApp.Tests.Integration;

/// <summary>
/// Uses an in‑memory EF Core database to test the generic repository.
/// </summary>
[TestFixture]
public class RepositoryIntegrationTests
{
    private DbContextOptions<AppDbContext> _options = null!;
    private AppDbContext _context = null!;

    [SetUp]
    public void Setup()
    {
        _options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        _context = new AppDbContext(_options);
    }

    [TearDown]
    public void Teardown() => _context.Dispose();

    [Test]
    public async Task AddAsync_ShouldPersistEntity()
    {
        var repo = new GenericRepository<Activity>(_context);

        var activity = new Activity
        {
            ActivityId = Guid.NewGuid(),
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "Integration Test",
            Description = "Testing AddAsync",
            ActiveFlag = 1,
            SystemDeleteFlag = 'N',
            CreatedDateTime = DateTime.UtcNow,
            CreatedByUser = "integration@test.com",
            CreatedByProgram = "IntegrationTests"
        };

        await repo.AddAsync(activity);

        var persisted = await _context.Activities.FindAsync(activity.ActivityId);
        Assert.NotNull(persisted);
        Assert.AreEqual("Integration Test", persisted!.Name);
    }

    [Test]
    public async Task Update_ShouldModifyEntity()
    {
        // Seed
        var activity = new Activity
        {
            ActivityId = Guid.NewGuid(),
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "Old",
            Description = "Desc",
            ActiveFlag = 1,
            SystemDeleteFlag = 'N',
            CreatedDateTime = DateTime.UtcNow,
            CreatedByUser = "integration@test.com",
            CreatedByProgram = "IntegrationTests"
        };
        _context.Activities.Add(activity);
        await _context.SaveChangesAsync();

        // Update
        var repo = new GenericRepository<Activity>(_context);
        activity.Name = "Updated";
        repo.Update(activity);

        var updated = await _context.Activities.FindAsync(activity.ActivityId);
        Assert.AreEqual("Updated", updated!.Name);
    }

    [Test]
    public async Task Delete_ShouldRemoveEntity()
    {
        // Seed
        var activity = new Activity
        {
            ActivityId = Guid.NewGuid(),
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "ToDelete",
            Description = "Desc",
            ActiveFlag = 1,
            SystemDeleteFlag = 'N',
            CreatedDateTime = DateTime.UtcNow,
            CreatedByUser = "integration@test.com",
            CreatedByProgram = "IntegrationTests"
        };
        _context.Activities.Add(activity);
        await _context.SaveChangesAsync();

        // Delete
        var repo = new GenericRepository<Activity>(_context);
        repo.Delete(activity);

        var deleted = await _context.Activities.FindAsync(activity.ActivityId);
        Assert.IsNull(deleted);
    }
}
