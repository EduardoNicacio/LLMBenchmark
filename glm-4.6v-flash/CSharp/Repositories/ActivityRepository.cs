// ActivityRepository.cs - Repository for Activity table
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq.Expressions;

namespace YourApp.Repositories

{
    public class ActivityRepository : IRepository<Activity>
    {
        private readonly DbContext _context; // Replace with your actual DbContext
        
        public ActivityRepository(DbContext context)
        {
            _context = context;
        }

        public IEnumerable<Activity> Get(Expression<Func<Activity, bool>> filter = null,
                                        Func<IQueryable<Activity>, IOrderedQueryable<Activity>> orderBy = null)
        {
            var query = _context.Set<Activity>().AsQueryable();
            
            if (filter != null) query = query.Where(filter);
            
            if (orderBy != null) return orderBy(query).ToList();
            
            return query.ToList();
        }

        public Activity GetById(object id)
        {
            // Assuming id is Guid
            var activityId = (Guid)id;
            return _context.Set<Activity>().Find(activityId);
        }
        
        public void Add(Activity entity)
        {
            _context.Set<Activity>().Add(entity);
        }

        public void Update(Activity entity)
        {
            _context.Set<Activity>().Update(entity);
        }

        public void Delete(object id)
        {
            var activity = GetById(id);
            if (activity != null) _context.Set<Activity>().Remove(activity);
        }
    }
}
