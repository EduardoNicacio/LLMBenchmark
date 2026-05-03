using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using YourApp.Infrastructure.Data;

namespace YourApp.Infrastructure.Repositories
{
    /// <summary>
    /// Generic EF Core repository implementation.
    /// </summary>
    public sealed class Repository<T> : IRepository<T> where T : new()
    {
        protected readonly AppDbContext _dbContext;
        protected readonly DbSet<T> _dbSet;

        public Repository(AppDbContext dbContext)
        {
            _dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
            _dbSet = dbContext.Set<T>();
        }

        public async Task<T?> GetByIdAsync(Guid id, CancellationToken ct = default)
        {
            // Assumes the entity has a Guid property named Id.
            var entryParameter = Expression.Parameter(typeof(T), "e");
            var idProperty = typeof(T).GetProperties(TypeBindingFlags.Instance | BindingFlags.Public)
                .First(p => p.Name == nameof(Guid) && p.PropertyType == typeof(Guid));
            var equality = Expression.Equal(idProperty.GetAccessExpression(), entryParameter, id);
            var lambda = Expression.Lambda<Func<T, bool>>(equality);
            return await _dbSet.AsNoTracking().FirstOrDefaultAsync(lambda, ct);
        }

        public async Task<IReadOnlyList<T>> GetAllAsync(CancellationToken ct = default) =>
            await _dbSet.ToListAsync(ct);

        public async Task AddAsync(T entity, CancellationToken ct = default) =>
            await _dbSet.AddAsync(entity, ct);

        public async Task UpdateAsync(T entity, CancellationToken ct = default)
        {
            // EF Core tracks changes via change tracker.
            await _dbSet.Update(entity);
        }

        public async Task DeleteAsync(Guid id, CancellationToken ct = default)
        {
            var entity = await GetByIdAsync(id, ct);
            if (entity != null)
                _dbSet.Remove(entity);
        }

        public async Task<int> SaveChangesAsync(CancellationToken ct = default) =>
            await _dbContext.SaveChangesAsync(ct);
    }
}
