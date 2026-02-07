// IRepository.cs - Generic repository interface
using System.Collections.Generic;
using System.Linq.Expressions;

namespace YourApp.Repositories

{
    public interface IRepository<T> where T : class
    {
        IEnumerable<T> Get(Expression<Func<T, bool>> filter = null,
                          Func<IQueryable<T>, IOrderedQueryable<T>> orderBy = null);
        
        T GetById(object id);
        
        void Add(T entity);
        
        void Update(T entity);
        
        void Delete(object id);
        
        // Optional: SaveChanges() method
    }
}
