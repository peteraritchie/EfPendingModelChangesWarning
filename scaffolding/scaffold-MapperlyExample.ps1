# function Set-InternalClass {
#     param ($Path)
#     if(!(test-path($Path))) {
#         return;
#     }
#     $className = Split-Path $Path -LeafBase;
#     if(!($className)) {
#         return;
#     }
#     (Get-Content $Path) -replace "\bpublic\b( +\bclass +$($className))\b", 'internal$1' | Out-File $Path
# }

# Set-InternalClass 'Account.cs'
# exit;

<#
also need, as an example:
ValidateAddressRequest, ValidateAddressResponse (DTOs)
AddressValidationSucceededEvent, AddressValidationFailedEvent
AddressValidationTranslator, etc.
Need to keep DTOs and external service facades in "infrastructure"
#>
<#
where to these live:
 - interfaces/ports, facades, adapters, input validators, domain validation/validators, object validation/validators
 - DTOs, views, models, controllers, 
 - use cases
 - application services, domain services, value objects, entities, aggregates, factories, 
#>
## Presentation Responsibilites
## Infrastructure Responsibilities
# - Adaptation (includes facades)
## Domain Responibilities
# - Domain Validation
# blog about "facadapter"? Anti-pattern?
<# Maxims
"User Interface (or Presentation Layer)" -- Evans
"[Application Layer] does not contain business rules or knowledge, but only coordinates tasks and delegates work to collaborations of domain objects in the next layer down." -- Evans
"[Infrastructure Layer] Provides generic technical capabilities that support the higher layers: message sending for the application, persistence for the domain, [...] and so on"
"Domain and application SERVICES collaborate with these infrastructure SERVICES." -- Evans

Thought: Infrastructure Layer is services, structure the layer by technical capability (data persistence, messaging, etc.) Each capability will have components that are facades, adapters, DTOs, translation, etc.
Thought: Application Layer implements services that 

Thought: [Web Request -> Framework -> Model ->] Controller -> Translator
                                                           \> Mediator
Technical Axioms: 
- Application Layer elements cannot reference Presentation Layer elements.
- Domain Layer elements cannot reference Presentation Layer elements
- Domain Layer elements cannot reference Application Layer elements
- Domain Layer elements cannot reference Infrasturucture Layer elements
- Infrastructure Layer cannot reference Presentation Layer elements
- Infrastructure Layer cannot reference Application Layer elements
Presentation Layer elements
- Implemetnation details:
  - Endpoints/Handlers (API)
  - Controllers/Routers (Web UI, API)
  - Models (Web UI, API)
  - Views (Web UI)
  - Components (SPA)
Application Layer elements
Domain Layer elements
- Aggregate/Entities
- Implementation Details
  - Strategy/Policy Implementations
  - Specification Implementations
Infrastructure Layer elements
- Data Persistence Service
- Messaging Service
- Encryption Service
- etc


Lost + Found:
- Commands + Handlers
- Queries + Handlers
- Reactors

Recommendations:
- use specification pattern to encapsulate rules
- use strategy pattern to encapsulate policies

#>
# blog about EF and child/owned entities

. $env:USERPROFILE\project.ps1

$solutionName = 'MapperlyExample2';
$rootDir = $solutionName;
$srcDir = Join-Path $solutionName 'src';

if(Test-Path $rootDir) {
    throw "Directory `"$rootDir`" already exists!";
}
$rootNamespace = "Pri.$solutionName";

# supporting files #############################################################

dotnet new gitignore -o $rootDir 2>&1 >NUL || $(throw 'error creating .gitignore');
dotnet new editorconfig -o $srcDir 2>&1 >NUL || $(throw 'error creating .editorconfig');
$text = (get-content -Raw $srcDir\.editorconfig);
$text = ($text -replace "(\[\*\]`r`nindent_style\s*=\s)space","`$1tab");
$text = $text.Replace('dotnet_naming_rule.private_fields_should_be__camelcase.style = _camelcase', 'dotnet_naming_rule.private_fields_should_be_camelcase.style = camelcase');
$text = $text.Replace('dotnet_naming_rule.private_fields_should_be__camelcase', 'dotnet_naming_rule.private_fields_should_be_camelcase');
$text = $text.Replace('dotnet_naming_rule.private_fields_should_be__camelcase', 'dotnet_naming_rule.private_fields_should_be_camelcase');
Set-Content -Path $srcDir\.editorconfig -Value $text;

$solution = [Solution]::Create($srcDir, $solutionName);

# domain project ###############################################################
$domainProject = $solution.NewClassLibraryProject("$($rootNamespace).Domain");
$domainProject.AddClass('Account');
# specifications for business rules, used by input validation
# strategy services

# infrastructure layer project #################################################
$infrastructureProject = $solution.NewClassLibraryProject("$($rootNamespace).Infrastructure", $domainProject);
$infrastructureProject.AddClass('DependencyInjection\Extensions');
#       builder.Services.AddSingleton<IAddressValidator, AddressValidator>();
# Example Facades:
$infrastructureProject.AddInternalClass('Services\AddressValidator');
$infrastructureProject.AddInterface('Services\IAddressValidator');
# Example DTOs:
$infrastructureProject.AddInternalClass('Services\ValidateAddressRequest');
$infrastructureProject.AddInternalClass('Services\ValidateAddressResponse');

# application layer project ####################################################
$applicationProject = $solution.NewClassLibraryProject("$($rootNamespace).Application", $domainProject);
$applicationProject.AddPackageReference('Riok.Mapperly'); #??
$applicationProject.AddClass('Commands\CreateAccount');
$applicationProject.AddClass('Handlers\CreateAccountHandler'); # TODO: internal and add di extension?
$applicationProject.AddClass('Services\AccountService');

# web/presentation project ####################################################
#$presentationProject = $solution.NewBlazorProject("$($rootNamespace).Web", $infrastructureProject);
#$presentationProject.AddPackageReference('Riok.Mapperly');

# web/presentation project ####################################################
$presentationProject = $solution.NewApiProject("$($rootNamespace).Api", $infrastructureProject);
$presentationProject.AddPackageReference('Riok.Mapperly');
#       builder.Services.AddSingleton<IAccountTranslator, AccountTranslator>();
#       builder.Services.AddSingleton<ICreateAccountCommandTranslator, CreateAccountCommandTranslator>();
$presentationProject.AddInterface('IAccountTranslator');
$presentationProject.AddInterface('ICreateAccountCommandTranslator');
$presentationProject.AddInternalClass('Dtos\AccountDto');
$presentationProject.AddInternalClass('Translation\AccountTranslator');
$presentationProject.AddInternalClass('Translation\CreateAccountCommandTranslator');

# tests project ################################################################
$testProject = $solution.NewTestProject("$($rootNamespace).Tests", $applicationProject, $infrastructureProject);
$testProject.AddPackageReference('Microsoft.AspNetCore.Mvc.Testing');

## Create readme ###############################################################
Set-Content -Path $rootDir\README.md -Value "# $solutionName`r`n`r`n## Scaffolding`r`n`r`n``````powershell";

foreach($cmd in $solution.ExecutedCommands)
{
    Add-Content -Path $rootDir\README.md -Value $cmd;
}
Add-Content -Path $rootDir\README.md -Value ``````;

################################################################################
md "$($rootDir)\scaffolding";
copy scaffold-MapperlyExample.ps1 "$($rootDir)\scaffolding";

# git init #####################################################################
git init $rootDir;
git --work-tree=$rootDir --git-dir=$rootDir/.git add .;
git --work-tree=$rootDir --git-dir=$rootDir/.git commit -m "initial commit";


# dotnet ef migrations add InitialCreate && dotnet ef database update

# dotnet ef migrations add InitialCreate
# dotnet ef database update
# rmdir -r -force .\Migrations\; del $env:LOCALAPPDATA\clients.db

<#
@startuml

skin rose
' comment

title Domain-Driven Design Solution Layout (Web)


package Domain <<Frame>> {
  package Services <<Namespace>> {
  }
  package AggregatesAndEntities <<Namespace>> {
  }
  package Events <<Namespace>> {
  }
  package Specifications <<Namespace>> {
  }
  package Policies <<Namespace>> {
  }
}

package Infrastructure <<Frame>> {
  package Persistence <<Namespace>> {
  }
  package Messaging <<Namespace>> {
  }
}

package Presentation <<Frame>> {
  package Models/DTOs <<Namespace>> {
  }
  package Views <<Namespace>> {
  }
  package Translators <<Namespace>> {
  }
}

package Application <<Frame>> {
  package Services <<Namespace>> {
  }
  package Commands <<Namespace>> {
  }
  package Queries <<Namespace>> {
  }
  package Handlers <<Namespace>> {
  }
}

Application ..> Domain
Infrastructure ..> Domain
Presentation ..> Infrastructure
Presentation ..> Application
Presentation .. Domain
@enduml
#>

# Consider a structure supporting vertical slicing
<#
@startuml

skin rose
' comment

title Domain-Driven Design Solution Layout (API)


package Domain <<Frame>> {
  package Services <<Namespace>> {
  }
  package AggregatesAndEntities <<Namespace>> {
  }
  package Events <<Namespace>> {
  }
  package Specifications <<Namespace>> {
  }
  package Policies <<Namespace>> {
  }
}

package Infrastructure <<Frame>> {
  package Persistence <<Namespace>> {
    package Dtos <<Namespace>> {
    }
    package Adapters <<Namespace>> {
    }
  }
  package Messaging <<Namespace>> {
    package Dtos <<Namespace>> {
    }
    package Adapters <<Namespace>> {
    }
  }
}

package Presentation <<Frame>> {
  package RequestDtos <<Namespace>> {
  }
  package Validators <<Namespace>> {
  }
  package Translators <<Namespace>> {
  }
}

package Application <<Frame>> {
  package Services <<Namespace>> {
  }
  package Commands <<Namespace>> {
  }
  package Queries <<Namespace>> {
  }
  package Handlers <<Namespace>> {
  }
}

Application ..> Domain
Infrastructure ..> Domain
Presentation ..> Infrastructure
Presentation ..> Application
Presentation .. Domain
@enduml
#>