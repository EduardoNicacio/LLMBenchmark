// Repositories/ActivityRepository.cs
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyApp.Repositories
{
    public class ActivityRepository : EfCoreRepository<Models.Activity>, IActivityRepository
    {
        // No extra logic needed – inherits all CRUD from base
    }

    public interface IActivityRepository
    {
        Task<Models.Activity?> GetByIdAsync(string id);
        Task<IReadOnlyList<Models.Activity>> ListAllAsync();
        Task AddAsync(Models.Activity activity);
        Task UpdateAsync(Models.Activity activity);
        Task DeleteAsync(string id);
    }
}
