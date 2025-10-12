// Generic Repository and Activity Repository are provided below.
namespace YourNamespace.Repositories
{
    public interface IGenericRepository<T> where T : class
    {
        // CRUD methods declaration
    }

    public class GenericRepository<T> : IGenericRepository<T> where T : class
    {
        // CRUD methods implementation
    }

    public interface IActivityRepository : IGenericRepository<Activity>
    {
        // Activity-specific methods declaration
    }

    public class ActivityRepository : GenericRepository<Activity>, IActivityRepository
    {
        // Activity-specific methods implementation
    }
}
