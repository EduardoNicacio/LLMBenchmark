namespace YourApp.Infrastructure.Data;

public sealed class AppDbContext : DbContext
{
    public DbSet<Activity> Activities => Set<Activity>();

    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Activity>(entity =>
        {
            entity.Property(e => e.ActivityId)
                .ValueGeneratedOnAdd()
                .HasDefaultValueSql("NEWSEQUENTIALID()");

            entity.Property(e => e.SystemTimestamp)
                .IsRowVersion()
                .IsConcurrencyToken();

            entity.Property(e => e.SystemDeleteFlag)
                .HasDefaultValue("N");

            entity.Property(e => e.ActiveFlag)
                .HasDefaultValue(1);

            entity.Property(e => e.CreatedDateTime)
                .HasDefaultValueSql("SYSUTCDATETIME()");
        });
    }
}
