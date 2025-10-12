// Repositories/GenericRepository.cs
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyApp.Repositories
{
    public interface IAppDbContext<T> where T : class, DbSet<>
    {
        Task<int> AddAsync(object entity);
        Task<int> UpdateAsync(object entity);
        Task<int> RemoveAsync(object entity);
        Task<T?> FindByIdAsync(string id);
        Task<IReadOnlyList<T>> ListAsync();
        // Additional query helpers can be added here
    }

    public abstract class EfCoreRepository<T> where T : class, AppEntity
    {
        protected readonly IAppDbContext<DbSet<T>> _context;

        protected EfCoreRepository(IAppDbContext<DbSet<T>> context)
        {
            _context = context;
        }

        public virtual async Task<T?> GetByIdAsync(string id)
        {
            return await _context.Set<T>().FindByIdAsync(id);
        }

        public virtual async Task<IReadOnlyList<T>> ListAllAsync()
        {
            return await _context.Set<T>().ToListAsync();
        }

        public virtual async Task AddAsync(T entity)
        {
            if (entity == null) throw new ArgumentNullException(nameof(entity));
            await _context.Set<T>().AddAsync(entity);
        }

        public virtual async Task UpdateAsync(T entity)
        {
            if (entity == null) throw new ArgumentNullException(nameof(entity));
            // Attach if detached
            _context.Set<T>().Update(entity);
            await _context.SaveChangesAsync();
        }

        public virtual async Task DeleteAsync(string id)
        {
            var entity = await GetByIdAsync(id);
            if (entity != null)
                _context.Set<T>().Remove(entity);
        }
    }
}
