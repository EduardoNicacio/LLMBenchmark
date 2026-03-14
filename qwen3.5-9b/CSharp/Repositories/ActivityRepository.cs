using System.Linq.Expressions;
using ActivityApp.Models;
using Microsoft.EntityFrameworkCore;

namespace ActivityApp.Repositories
{
    /// <summary>
    /// Generic Repository Interface.
    /// </summary>
    public interface IRepository<T> where T : class
    {
        Task<T?> GetByIdAsync(Guid id);
        Task<IEnumerable<T>> GetAllAsync();
        Task<T?> AddAsync(T entity);
        Task UpdateAsync(T entity);
        Task DeleteAsync(Guid id);
        Task DeleteAsync(T entity);
        Task<bool> ExistsAsync(Guid id);
    }

    /// <summary>
    /// Activity-specific Repository Implementation.
    /// </summary>
    public class ActivityRepository : IRepository<Activity>
    {
        private readonly ActivityDbContext _context;

        public ActivityRepository(ActivityDbContext context)
        {
            _context = context;
        }

        public async Task<Activity?> GetByIdAsync(Guid id)
        {
            return await _context.Activities
                .FirstOrDefaultAsync(a => a.ActivityId == id && !a.SystemDeleteFlag);
        }

        public async Task<IEnumerable<Activity>> GetAllAsync()
        {
            return await _context.Activities
                .Where(a => !a.SystemDeleteFlag)
                .ToListAsync();
        }

        public async Task<Activity?> AddAsync(Activity entity)
        {
            entity.CreatedDateTime = DateTime.UtcNow;
            entity.CreatedByUser = "System"; // In production, inject user context
            entity.CreatedByProgram = "System";
            entity.SystemDeleteFlag = false;
            entity.SystemTimestamp = null; // EF Core handles this on save
            await _context.Activities.AddAsync(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task UpdateAsync(Activity entity)
        {
            entity.UpdatedDateTime = DateTime.UtcNow;
            entity.SystemTimestamp = null; // EF Core handles this on save
            await _context.Activities.UpdateAsync(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(Guid id)
        {
            var entity = await GetByIdAsync(id);
            if (entity != null)
            {
                entity.SystemDeleteFlag = true;
                entity.UpdatedDateTime = DateTime.UtcNow;
                await UpdateAsync(entity);
            }
        }

        public async Task DeleteAsync(Activity entity)
        {
            entity.SystemDeleteFlag = true;
            entity.UpdatedDateTime = DateTime.UtcNow;
            await UpdateAsync(entity);
        }

        public Task<bool> ExistsAsync(Guid id)
        {
            return Task.FromResult(_context.Activities.Any(a => a.ActivityId == id && !a.SystemDeleteFlag));
        }
    }
}
