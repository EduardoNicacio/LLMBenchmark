// GenericRepository.cs
public interface IRepository<T>
{
    IEnumerable<T> Get();
    T GetById(Guid id);
    void Add(T entity);
    void Update(T entity);
    void Delete(Guid id);
}

// GenericRepositoryImplementation.cs
public class Repository<T> : IRepository<T> where T : class
{
    private readonly DbContext _context;

    public Repository(DbContext context)
    {
        _context = context;
    }

    // Implement Get, GetById, Add, Update, Delete methods using EF Core.
}
