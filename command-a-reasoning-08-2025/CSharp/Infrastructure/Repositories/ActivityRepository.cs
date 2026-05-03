namespace YourApp.Infrastructure.Repositories;

public sealed class ActivityRepository : Repository<Activity>, IActivityRepository
{
    public ActivityRepository(AppDbContext context) : base(context) { }

    public override async Task DeleteAsync(Guid id, CancellationToken ct = default)
    {
        var activity = await GetByIdAsync(id, ct);
        if (activity != null)
        {
            activity.SystemDeleteFlag = "Y";
            activity.UpdatedDateTime = DateTime.UtcNow;
            activity.UpdatedByUser = "system";
            activity.UpdatedByProgram = "Repository";
            DbSet.Update(activity);
        }
    }

    public override async Task<IReadOnlyList<T>> GetAllAsync(CancellationToken ct = default) =>
        await DbSet.AsNoTracking()
            .Where(a => a.SystemDeleteFlag == "N")
            .ToListAsync(ct);

    public async Task<IReadOnlyList<Activity>> GetByProjectAsync(Guid projectId, CancellationToken ct = default) =>
        await DbSet.AsNoTracking()
            .Where(a => a.ProjectId == projectId && a.SystemDeleteFlag == "N")
            .ToListAsync(ct);

    public async Task<IReadOnlyList<Activity>> GetActiveAsync(CancellationToken ct = default) =>
        await DbSet.AsNoTracking()
            .Where(a => a.ActiveFlag == 1 && a.SystemDeleteFlag == "N")
            .ToListAsync(ct);
}
