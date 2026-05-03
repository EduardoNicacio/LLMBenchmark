public static class ServiceRegistration
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration config)
    {
        services.AddDbContext<AppDbContext>(options => 
            options.UseSqlServer(config.GetConnectionString("Default")));
        
        services.AddScoped<IActivityRepository, ActivityRepository>();
        return services;
    }
}
