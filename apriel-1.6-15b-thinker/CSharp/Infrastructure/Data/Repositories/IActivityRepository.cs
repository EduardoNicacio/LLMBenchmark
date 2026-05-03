using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using YourApp.Domain.Entities;

namespace YourApp.Infrastructure.Repositories
{
    /// <summary>
    /// Activity‑specific repository contract.
    /// </summary>
    public interface IActivityRepository : IRepository<Activity>
    {
        Task<IReadOnlyList<Activity>> GetByProjectAsync(Guid projectId, CancellationToken ct = default);
        Task<IReadOnlyList<Activity>> GetActiveAsync(CancellationToken ct = default);
    }
}
