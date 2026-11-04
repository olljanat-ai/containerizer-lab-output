# containerization-challenge-study-data: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 90/100 · confidence 1.0  
Stateless: yes

1/1 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| StudyData.Sponsor.Api | web | net8.0 | Ready with configuration (no code changes) | 90 | - |

### StudyData.Sponsor.Api

`src/StudyData.Sponsor.Api/StudyData.Sponsor.Api.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; port=5320; entry=StudyData.Sponsor.Api.dll; connection_strings=['StudyData']

- ⚙ **SQL Server Windows authentication** [config]
  - Why: Integrated Security uses the Windows service account. From Linux it needs Kerberos (keytab) or a switch to SQL/Entra authentication.
  - Fix: Switch to SQL authentication or Entra managed identity with the password from a Secret.
  - Evidence: `src/StudyData.Sponsor.Api/appsettings.json:3: "StudyData": "Server=sql01.corp.local;Database=StudyData;Integrated Security=true;TrustServerCertificate=true;Application Name=StudyData.Sponsor"`

## Libraries with notable findings

- StudyData.Calculation: COM interop with a registered component, Code marked Windows-only by its authors, Microsoft Office automation (COM), Single-threaded apartment (STA) threads
- StudyData.Coding: COM interop with a registered component, Code marked Windows-only by its authors, Single-threaded apartment (STA) threads
- StudyData.Documents: Code marked Windows-only by its authors, Single-threaded apartment (STA) threads, Uses WinForms/WPF APIs in server code, Windows printing, Windows-specific target framework (-windows)
