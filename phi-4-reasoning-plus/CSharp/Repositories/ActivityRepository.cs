using System;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MyApp.Data;

namespace MyApp.Repositories
{
    // Activity-specific repository implementation.
    public class ActivityRepository : IGenericRepository<Models.Activity>
    {
        private readonly MyAppContext _context;

        public ActivityRepository(MyAppContext context)
        {
            _context = context;
        }

        public async Task Add(Models.Activity entity)
        {
            await _context.Activities.AddAsync(entity);
        }

        public async Task<int> SaveChangesAsync()
        {
            return await _context.SaveChangesAsync();
        }

        public void Delete(Models.Activity entity)
        {
            _context.Remove(entity);
        }

        public async Task<IEnumerable<Models.Activity>> GetAllAsync()
        {
            return await _context.Activities.ToListAsync();
        }

        public async Task<Models.Activity> GetByIdAsync(Guid id)
        {
            return await _context.Activities.FindAsync(id);
        }

        public void Update(Models.Activity entity)
        {
            // Mark as modified.
            _context.Entry(entity).State = EntityState.Modified;
        }
    }
}