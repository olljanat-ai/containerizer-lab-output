# containerization-challenge-policy-changes: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 90/100 · confidence 1.0  
Stateless: yes

1/1 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| PolicyChanges.Api | web | net8.0 | Ready with configuration (no code changes) | 90 | - |

### PolicyChanges.Api

`src/PolicyChanges.Api/PolicyChanges.Api.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; port=5280; entry=PolicyChanges.Api.dll; connection_strings=['PolicyChanges']

- ⚙ **SQL Server Windows authentication** [config]
  - Why: Integrated Security uses the Windows service account. From Linux it needs Kerberos (keytab) or a switch to SQL/Entra authentication.
  - Fix: Switch to SQL authentication or Entra managed identity with the password from a Secret.
  - Evidence: `src/PolicyChanges.Api/appsettings.json:11: "PolicyChanges": "Server=sql01.corp.local;Database=PolicyChanges;Integrated Security=true;TrustServerCertificate=true"`
