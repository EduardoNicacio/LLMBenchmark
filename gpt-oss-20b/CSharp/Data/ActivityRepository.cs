// File: Data/ActivityRepository.cs
using Microsoft.EntityFrameworkCore;
using MyApp.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyApp.Data;

/// <summary>
/// Concrete repository for Activity.
/// </summary>
public class ActivityRepository : GenericRepository<Activity>, IActivityRepository
{
    public ActivityRepository(DbContext context) : base(context)
    {
    }

    public async Task<IEnumerable<Activity>> GetByProjectIdAsync(Guid projectId)
    {
        return await _dbSet.Where(a => a.ProjectId == projectId).ToListAsync();
    }
}
