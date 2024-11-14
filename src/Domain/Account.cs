namespace Pri.DDDReference.Domain;
// del $Env:LOCALAPPDATA/AccountsX.db
// dotnet ef migrations remove --startup-project Api --project Infrastructure
// dotnet ef migrations add InitialCreate --startup-project Api --project Infrastructure
// dotnet ef database update --startup-project Api --project Infrastructure
// dotnet ef migrations remove --startup-project Api --project Infrastructure; dotnet ef migrations add InitialCreate --startup-project Api --project Infrastructure; dotnet ef database update --startup-project Api --project Infrastructure
public class Account
{
	public string Description { get; set; } = string.Empty;

#if INCLUDE_ACCOUNT_HOLDERS
	private List<AccountHolder> accountHolders = [];
	public IEnumerable<AccountHolder> AccountHolders
	{
		get => accountHolders;
		set => accountHolders = [..value];
	}
#endif
#if INCLUDE_ADDRESSES
	private List<PostalAddress> addresses = [];
	public IEnumerable<PostalAddress> Addresses
	{
		get => addresses;
		set => addresses = [.. value];
	}
#endif
}