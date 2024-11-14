# DDDReference

## Scaffolding

```powershell
dotnet new solution -o 'DDDReference\src' -n DDDReference
dotnet new gitignore -o 'DDDReference\src'
dotnet new buildprops -o 'DDDReference\src'
dotnet new classlib -n Pri.DDDReference.Domain -o 'DDDReference\src\Pri.DDDReference.Domain' --framework net8.0 --language 'C#'
dotnet sln 'DDDReference\src' add 'C:\Users\peter\src\experiment\DDDReference\src\Domain'
dotnet new class -n 'Account' -o 'C:\Users\peter\src\experiment\DDDReference\src\Domain' --force
dotnet new class -n 'AccountHolder' -o 'C:\Users\peter\src\experiment\DDDReference\src\Domain' --force
dotnet new class -n 'PostalAddress' -o 'C:\Users\peter\src\experiment\DDDReference\src\Domain' --force
dotnet new classlib -n Pri.DDDReference.Infrastructure -o 'DDDReference\src\Pri.DDDReference.Infrastructure' --framework net8.0 --language 'C#'
dotnet sln 'DDDReference\src' add 'C:\Users\peter\src\experiment\DDDReference\src\Infrastructure'
dotnet add 'C:\Users\peter\src\experiment\DDDReference\src\Infrastructure' reference 'C:\Users\peter\src\experiment\DDDReference\src\Domain'
dotnet add 'C:\Users\peter\src\experiment\DDDReference\src\Infrastructure' package 'Microsoft.EntityFrameworkCore.Sqlite'
dotnet new class -n 'Extensions' -o 'C:\Users\peter\src\experiment\DDDReference\src\Infrastructure\DependencyInjection' --force
dotnet new interface -n 'IAddressValidator' -o 'C:\Users\peter\src\experiment\DDDReference\src\Infrastructure\Services'
dotnet new class -n 'AddressValidator' -o 'C:\Users\peter\src\experiment\DDDReference\src\Infrastructure\Services' --force
dotnet new class -n 'ValidateAddressRequest' -o 'C:\Users\peter\src\experiment\DDDReference\src\Infrastructure\Services' --force
dotnet new class -n 'ValidateAddressResponse' -o 'C:\Users\peter\src\experiment\DDDReference\src\Infrastructure\Services' --force
dotnet new class -n 'AccountSqliteDbContext' -o 'C:\Users\peter\src\experiment\DDDReference\src\Infrastructure\Services' --force
dotnet new class -n 'AccountEntityTypeConfiguration' -o 'C:\Users\peter\src\experiment\DDDReference\src\Infrastructure\Services' --force
dotnet new classlib -n Pri.DDDReference.Application -o 'DDDReference\src\Pri.DDDReference.Application' --framework net8.0 --language 'C#'
dotnet sln 'DDDReference\src' add 'C:\Users\peter\src\experiment\DDDReference\src\Application'
dotnet add 'C:\Users\peter\src\experiment\DDDReference\src\Application' reference 'C:\Users\peter\src\experiment\DDDReference\src\Domain'
dotnet add 'C:\Users\peter\src\experiment\DDDReference\src\Application' package 'Riok.Mapperly'
dotnet new class -n 'CreateAccountCommand' -o 'C:\Users\peter\src\experiment\DDDReference\src\Application\Commands' --force
dotnet new class -n 'CreateAccountCommandHandler' -o 'C:\Users\peter\src\experiment\DDDReference\src\Application\Handlers' --force
dotnet new class -n 'AccountService' -o 'C:\Users\peter\src\experiment\DDDReference\src\Application\Services' --force
dotnet new class -n 'AccountRepository' -o 'C:\Users\peter\src\experiment\DDDReference\src\Application\Services' --force
dotnet new webapi -n Pri.DDDReference.Api -o 'DDDReference\src\Pri.DDDReference.Api' --framework net8.0 --use-program-main --language 'C#'
dotnet sln 'DDDReference\src' add 'C:\Users\peter\src\experiment\DDDReference\src\Api'
dotnet add 'C:\Users\peter\src\experiment\DDDReference\src\Api' reference 'C:\Users\peter\src\experiment\DDDReference\src\Infrastructure'
dotnet add 'C:\Users\peter\src\experiment\DDDReference\src\Api' package 'Microsoft.EntityFrameworkCore.Design'
dotnet add 'C:\Users\peter\src\experiment\DDDReference\src\Api' package 'Riok.Mapperly'
dotnet new interface -n 'IAccountTranslator' -o 'C:\Users\peter\src\experiment\DDDReference\src\Api'
dotnet new interface -n 'ICreateAccountCommandTranslator' -o 'C:\Users\peter\src\experiment\DDDReference\src\Api'
dotnet new class -n 'AccountDto' -o 'C:\Users\peter\src\experiment\DDDReference\src\Api\Dtos' --force
dotnet new class -n 'AccountTranslator' -o 'C:\Users\peter\src\experiment\DDDReference\src\Api\Translation' --force
dotnet new class -n 'CreateAccountCommandTranslator' -o 'C:\Users\peter\src\experiment\DDDReference\src\Api\Translation' --force
dotnet new xunit -n Pri.DDDReference.Tests -o 'DDDReference\src\Pri.DDDReference.Tests' --framework net8.0 --language 'C#'
dotnet sln 'DDDReference\src' add 'C:\Users\peter\src\experiment\DDDReference\src\Tests'
dotnet add 'C:\Users\peter\src\experiment\DDDReference\src\Tests' package 'Moq'
dotnet add 'C:\Users\peter\src\experiment\DDDReference\src\Tests' reference 'C:\Users\peter\src\experiment\DDDReference\src\Application'
dotnet add 'C:\Users\peter\src\experiment\DDDReference\src\Tests' reference 'C:\Users\peter\src\experiment\DDDReference\src\Infrastructure'
dotnet add 'C:\Users\peter\src\experiment\DDDReference\src\Tests' package 'Microsoft.AspNetCore.Mvc.Testing'
```
