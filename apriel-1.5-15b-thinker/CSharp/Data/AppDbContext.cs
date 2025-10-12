using Microsoft.EntityFrameworkCore;
using System;

namespace MyApp.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) 
            : base(options) { }

        public DbSet<Models.Activity> Activities => Set<Models.Activity>();

        // Add other entity sets as needed.
    }
}
