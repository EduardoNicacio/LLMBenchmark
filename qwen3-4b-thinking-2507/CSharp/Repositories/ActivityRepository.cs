using Microsoft.EntityFrameworkCore;
using YourNamespace.Models;
using YourNamespace.Repositories;

namespace YourNamespace.Repositories
{
    public interface IActivityRepository : IGenericRepository<Activity>
    {
        Task<Activity> GetActivityByIdAsync(Guid activityId);
    }

    public class ActivityRepository : IActivityRepository
    {
        private readonly ApplicationDbContext _context;

        public ActivityRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<Activity> GetActivityByIdAsync(Guid activityId)
        {
            return await _context.Activities
                .Where(a => a.ActivityId == activityId)
                .FirstOrDefaultAsync();
        }

        // Implementation of IGenericRepository methods
        public async Task<IEnumerable<Activity>> GetAllAsync()
        {
            return await _context.Activities.ToListAsync();
        }

        public async Task<Activity> GetByIdAsync(Guid id)
        {
            return await _context.Activities.FindAsync(id);
        }

        public async Task AddAsync(Activity activity)
        {
            await _context.Activities.AddAsync(activity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Activity activity)
        {
            _context.Activities.Update(activity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(Activity activity)
        {
            _context.Activities.Remove(activity);
            await _context.SaveChangesAsync();
        }

        public async Task<int> SaveAsync()
        {
            return await _context.SaveChangesAsync();
        }
    }

    public interface IGenericRepository<T> where T : class
    {
        Task<T> GetByIdAsync(Guid id);
        Task<IEnumerable<T>> GetAllAsync();
        Task AddAsync(T entity);
        Task UpdateAsync(T Entity);
        Task DeleteAsync(T Entity);
        Task<int> SaveAsync();
    }
}
