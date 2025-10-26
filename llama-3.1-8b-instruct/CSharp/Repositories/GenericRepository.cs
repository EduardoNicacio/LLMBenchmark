// Repositories/GenericRepository.cs

namespace YourNamespace.Repositories
{
    public interface IGreenericRepository<T> where T : class, IEntity
    {
        IEnumerable<T> Get();
        T Get(Guid id);
        void Add(T entity);
        void Update(T entity);
        void Delete(Guid id);
    }

    public class GenericRepository<T> : IGreenericRepository<T> where T : class, IEntity
    {
        private readonly DbContext _context;

        public GenericRepository(DbContext context)
        {
            _context = context;
        }

        public IEnumerable<T> Get()
        {
            return _context.Set<T>().ToList();
        }

        public T Get(Guid id)
        {
            return _context.Set<T>().Find(id);
        }

        public void Add(T entity)
        {
            _context.Set<T>().Add(entity);
            _context.SaveChanges();
        }

        public void Update(T entity)
        {
            _context.Set<T>().Update(entity);
            _context.SaveChanges();
        }

        public void Delete(Guid id)
        {
            var entity = Get(id);
            if (entity != null)
            {
                _context.Set<T>().Remove(entity);
                _context.SaveChanges();
            }
        }
    }
}

// Repositories/ActivityRepository.cs

namespace YourNamespace.Repositories
{
    public class ActivityRepository : GenericRepository<Activity>
    {
        public ActivityRepository(DbContext context) : base(context)
        {
        }

        // Custom methods can be added here for specific business logic.
    }
}
