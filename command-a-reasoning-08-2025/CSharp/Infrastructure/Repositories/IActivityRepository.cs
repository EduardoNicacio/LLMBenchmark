namespace YourApp.Infrastructure.Repositories;

public interface IActivityRepository : IRepository<Activity>
{
    Task<IReadOnlyList<Activity>> GetByProjectAsync(Guid projectId, CancellationToken ct = default);
    Task<IReadOnlyList<Activity>> GetActiveAsync(CancellationToken ct = default);
}
