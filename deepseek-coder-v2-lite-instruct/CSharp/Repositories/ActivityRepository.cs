using Microsoft.EntityFrameworkCore;
using System;
using System.Threading.Tasks;

namespace YourNamespace.Repositories
{
    public class ActivityRepository : GenericRepository<Models.Activity>
    {
        public ActivityRepository(DbContext context) : base(context)
        {
        }

        public async Task<Models.Activity> GetByIdAsync(Guid id) => await _context.Set<Models.Activity>().FindAsync(id);
        // Implement other activity-specific methods...
    }
}
