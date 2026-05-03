using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace YourApp.Infrastructure.Repositories
{
    /// <summary>
    /// Generic repository contract.
    /// </summary>
    public interface IRepository<T> where T : new()
    {
        Task<T?> GetByIdAsync(Guid id, CancellationToken ct = default);
        Task<IReadOnlyList<T>> GetAllAsync(CancellationToken ct = default);
        Task AddAsync(T entity, CancellationToken ct = default);
        Task UpdateAsync(T entity, CancellationToken ct = default);
        Task DeleteAsync(Guid id, CancellationToken ct = default);
        Task<int> SaveChangesAsync(CancellationToken ct = default);
    }
}
