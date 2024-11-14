using Microsoft.EntityFrameworkCore;

using Pri.DDDReference.Domain;

namespace Pri.DDDReference.Infrastructure.Services;

public class AccountSqliteDbContext(DbContextOptions options) : DbContext(options)
{
#pragma warning disable CS8618 // Non-nullable field must contain a non-null value when exiting constructor. Consider adding the 'required' modifier or declaring as nullable.
	public DbSet<Account> Accounts { get; set; }
#pragma warning restore CS8618 // Non-nullable field must contain a non-null value when exiting constructor. Consider adding the 'required' modifier or declaring as nullable.


	private static string DbPath
	{
		get
		{
			var folder = Environment.SpecialFolder.LocalApplicationData;
			var path = Environment.GetFolderPath(folder);
			return Path.Join(path, "accountsX.db");
		}
	}


	protected override void OnConfiguring(DbContextOptionsBuilder options)
	{
		options.UseSqlite($"Data Source={DbPath}");
	}

	protected override void OnModelCreating(ModelBuilder modelBuilder)
	{
		modelBuilder.ApplyConfiguration(new AccountEntityTypeConfiguration());
		//modelBuilder.ApplyConfiguration(new AccountHolderEntityTypeConfiguration());
		//modelBuilder.ApplyConfiguration(new PostalAddressEntityTypeConfiguration());

		base.OnModelCreating(modelBuilder);
	}
}