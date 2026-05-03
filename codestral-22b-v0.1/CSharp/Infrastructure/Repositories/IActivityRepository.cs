// IActivityRepository.cs
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace YourApp.Infrastructure.Repositories;

public interface IActivityRepository : IRepository<Activity>
{
    Task<IReadOnlyList<Activity>> GetByProjectAsync(Guid projectId, CancellationToken ct = default);
    Task<IReadOnlyList<Activity>> GetActiveAsync(CancellationToken ct = default);
}
