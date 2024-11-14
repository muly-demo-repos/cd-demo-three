using Microsoft.EntityFrameworkCore;

namespace Paz.Infrastructure;

public class PazDbContext : DbContext
{
    public PazDbContext(DbContextOptions<PazDbContext> options)
        : base(options) { }
}
