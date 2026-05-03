using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using YourApp.Domain.Entities;
using YourApp.Infrastructure.Data;

namespace YourApp.Infrastructure.Repositories
{
    /// <summary>
    /// Activity repository with soft‑delete semantics.
    /// </summary>
    public sealed class ActivityRepository : Repository<Activity>, IActivityRepository
    {
        public ActivityRepository(AppDbContext dbContext) : base(dbContext) { }

        public async Task<IReadOnlyList<Activity>> GetByProjectAsync(Guid projectId, CancellationToken ct = default) =>
            await _dbContext.Activities
                .Where(a => a.ProjectId == projectId && a.SystemDeleteFlag != "Y")
                .ToListAsync(ct);

        public async Task<IReadOnlyList<Activity>> GetActiveAsync(CancellationToken ct = default) =>
            await _dbContext.Activities
                .Where(a => a.SystemDeleteFlag != "Y")
                .ToListAsync(ct);

        public override async Task DeleteAsync(Guid id, CancellationToken ct = default)
        {
            var entity = await GetByIdAsync(id, ct);
            if (entity == null)
                return;

            // Soft‑delete
            entity.SystemDeleteFlag = "Y";
            entity.UpdatedDateTime = DateTime.UtcNow;
            await SaveChangesAsync(ct);
        }

        public override async Task<IReadOnlyList<Activity>> GetAllAsync(CancellationToken ct = default) =>
            await _dbContext.Activities
                .Where(a => a.SystemDeleteFlag != "Y")
                .ToListAsync(ct);
    }
}
