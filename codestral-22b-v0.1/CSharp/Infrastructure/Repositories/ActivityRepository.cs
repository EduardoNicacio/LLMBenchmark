// ActivityRepository.cs
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace YourApp.Infrastructure.Repositories;

public class ActivityRepository : Repository<Activity>, IActivityRepository
{
    public ActivityRepository(AppDbContext context) : base(context) { }

    public async Task<IReadOnlyList<Activity>> GetByProjectAsync(Guid projectId, CancellationToken ct = default)
        => await _context.Activities.Where(a => a.ProjectId == projectId).ToListAsync(ct);

    public async Task<IReadOnlyList<Activity>> GetActiveAsync(CancellationToken ct = default)
        => await _context.Activities.Where(a => a.SystemDeleteFlag != "Y").ToListAsync(ct);

    public new async Task DeleteAsync(Guid id, CancellationToken ct = default)
    {
        var activity = await GetByIdAsync(id, ct);
        if (activity != null)
        {
            activity.SystemDeleteFlag = "Y";
            activity.UpdatedDateTime = DateTime.UtcNow;
            _context.Entry(activity).State = EntityState.Modified;
        }
    }
}
