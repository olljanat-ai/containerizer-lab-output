# containerization-challenge-consumer-loans: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 88/100 · confidence 1.0  
Stateless: yes

2/2 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| Lucerne.Lending.CustomerPortal | web | net6.0 | Ready with configuration (no code changes) | 89 | - |
| Lucerne.Lending.Documents | worker | net6.0 | Ready with configuration (no code changes) | 87 | - |

### Lucerne.Lending.CustomerPortal

`src/Lucerne.Lending.CustomerPortal/Lucerne.Lending.CustomerPortal.csproj` · web · Ready with configuration (no code changes)

Facts: port=5101; entry=Lucerne.Lending.CustomerPortal.dll; connection_strings=['PortalIdentity']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/Lucerne.Lending.CustomerPortal/Lucerne.Lending.CustomerPortal.csproj: TargetFramework=net6.0`
- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/Lucerne.Lending.CustomerPortal/web.config:14: <requestFiltering>`

### Lucerne.Lending.Documents

`src/Lucerne.Lending.Documents/Lucerne.Lending.Documents.csproj` · worker · Ready with configuration (no code changes)

Facts: entry=Lucerne.Lending.Documents.dll; connection_strings=['Lending']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/Lucerne.Lending.Documents/Lucerne.Lending.Documents.csproj: TargetFramework=net6.0`
- ⚙ **Cultures / Windows time zone IDs** [config]
  - Why: Culture data needs ICU in the image (chiseled 'extra' images include it). Windows time zone IDs ("W. Europe Standard Time") are converted automatically on .NET 6+ only when ICU and tzdata are present.
  - Fix: Use an image with ICU and tzdata (the generator picks *-chiseled-extra); keep DOTNET_SYSTEM_GLOBALIZATION_INVARIANT unset.
  - Learn more: [learn.microsoft.com: globalization icu](https://learn.microsoft.com/en-us/dotnet/core/extensions/globalization-icu), [devblogs.microsoft.com: date time and time zone enhancements in net 6](https://devblogs.microsoft.com/dotnet/date-time-and-time-zone-enhancements-in-net-6/), [github.com: image variants](https://github.com/dotnet/dotnet-docker/blob/main/documentation/image-variants.md)
  - Evidence: `src/Lucerne.Lending.Documents/Rendering/LoanDocuments.cs:12: private static readonly CultureInfo Fi = CultureInfo.GetCultureInfo("fi-FI");`
- ⚙ **Windows drive paths as defaults in code** [config] (in library Lucerne.Lending.Integration)
  - Why: Paths like @"D:\Data\Import" are not paths on Linux: the whole string becomes one oddly named relative file in the (read-only) working directory, so reads fail with FileNotFound and writes fail. As option defaults or fallbacks (?? @"D:\...") they apply whenever the setting is not configured.
  - Fix: Set the corresponding settings to Linux paths on mounted volumes with environment variables (Section__Key=/data/...); better, change the defaults to relative or Linux-friendly paths.
  - Learn more: [learn.microsoft.com: system.io.path.directoryseparatorchar](https://learn.microsoft.com/en-us/dotnet/api/system.io.path.directoryseparatorchar), [learn.microsoft.com: configuration](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/configuration/)
  - Evidence: `src/Lucerne.Lending.Integration/GeneralLedger.cs:11: public string OutboundFolder { get; set; } = @"D:\Interfaces\GL\Outbound";`
- ⚙ **Mail is dropped into a pickup folder** [config] (in library Lucerne.Lending.Integration)
  - Why: On the Windows server an SMTP service (IIS SMTP / Exchange pickup) drained the folder. In the container nothing reads it: mail is silently never sent, and the folder must be writable.
  - Fix: Configure network delivery to an SMTP relay (host, port and credentials from a Secret); keep the pickup folder only for test environments, on a mounted volume.
  - Learn more: [learn.microsoft.com: system.net.mail.smtpdeliverymethod](https://learn.microsoft.com/en-us/dotnet/api/system.net.mail.smtpdeliverymethod)
  - Evidence: `src/Lucerne.Lending.Integration/Mail.cs:40: client.DeliveryMethod = SmtpDeliveryMethod.SpecifiedPickupDirectory;`

## Libraries with notable findings

- Lucerne.Lending.CoreBanking.IbmI: COM interop with a registered component, Code marked Windows-only by its authors, IBM i Access Client (cwbx/iSeries provider), OLE DB / Access database engine, Single-threaded apartment (STA) threads
- Lucerne.Lending.CoreBanking: IBM i Access Client (cwbx/iSeries provider), OLE DB / Access database engine
