# containerization-challenge-freight-rates: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 89/100 · confidence 1.0  
Stateless: yes

1/1 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| FreightRates.Api | web | net8.0 | Ready with configuration (no code changes) | 89 | - |

### FreightRates.Api

`src/FreightRates.Api/FreightRates.Api.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; port=5080; entry=FreightRates.Api.dll; connection_strings=['FreightRates']

- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/FreightRates.Api/web.config:14: <requestFiltering>`
- ⚙ **SQL Server Windows authentication** [config]
  - Why: Integrated Security uses the Windows service account. From Linux it needs Kerberos (keytab) or a switch to SQL/Entra authentication.
  - Fix: Switch to SQL authentication or Entra managed identity with the password from a Secret.
  - Evidence: `src/FreightRates.Api/appsettings.json:11: "FreightRates": "Server=sql01.corp.local;Database=FreightRates;Integrated Security=true;TrustServerCertificate=true"`
