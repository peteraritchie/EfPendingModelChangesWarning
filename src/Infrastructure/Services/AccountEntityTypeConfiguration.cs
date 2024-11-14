using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

using Pri.DDDReference.Domain;

namespace Pri.DDDReference.Infrastructure.Services;

public class AccountEntityTypeConfiguration : IEntityTypeConfiguration<Account>
{
	public void Configure(EntityTypeBuilder<Account> builder)
	{
		builder.ToTable("account");
		builder.Property(a => a.Description)
			.HasColumnType("varchar(1024)")
			.HasColumnName("description");
		builder.Property<string>("Id")
			.HasColumnType("varchar(36)")
			.HasColumnName("id")
			.HasMaxLength(36);
		builder.HasKey("Id");
#if INCLUDE_ACCOUNT_HOLDERS
		builder.OwnsMany(a => a.AccountHolders, navigationBuilder =>
		{
			navigationBuilder.ToTable("account_holder");
			navigationBuilder.Property<string>("Id")
				.HasColumnType("varchar(36)")
				.HasColumnName("id")
				.HasMaxLength(36);
			navigationBuilder.HasKey("Id");
			navigationBuilder.Property<string>(h => h.FullName)
				.HasColumnName("full-name").IsRequired()
				.HasMaxLength(747);
			navigationBuilder.WithOwner().HasForeignKey("account_id");
		});
#endif
	}
}
