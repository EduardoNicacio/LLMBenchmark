// EF Core Generic Repository Interface
/// <summary>
/// Generic repository interface for CRUD operations.
/// </summary>
/// <typeparam name="T">Entity type.</typeparam>
public interface IGenericRepository<T> where T : class
{
    Task<T> GetByIdAsync(Guid id);
    Task<IEnumerable<T>> GetAllAsync();
    Task AddAsync(T entity);
    Task UpdateAsync(T entity);
    Task DeleteAsync(T entity);
    Task<bool> ExistsAsync(Guid id);
}
