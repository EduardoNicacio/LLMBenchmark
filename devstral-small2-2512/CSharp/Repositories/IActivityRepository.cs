using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using ProjectManagement.Models;

namespace ProjectManagement.Data.Repositories
{
    public interface IActivityRepository : IGenericRepository<Activity>
    {
        Task<IEnumerable<Activity>> GetActivitiesByProjectIdAsync(Guid projectId);
        Task<IEnumerable<Activity>> GetActiveActivitiesAsync();
        Task UpdateProgressStatusAsync(Guid activityId, byte progressStatus);
    }
}
