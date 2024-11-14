namespace Pri.DDDReference.Domain;

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
}