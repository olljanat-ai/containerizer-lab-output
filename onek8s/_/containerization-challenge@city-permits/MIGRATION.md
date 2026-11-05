# containerization-challenge-city-permits: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 90/100 · confidence 1.0  
Stateless: yes

2/2 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| CityPermits.Inspections | web | net6.0 | Ready with configuration (no code changes) | 89 | - |
| CityPermits.OpenData | web | net8.0 | Ready with configuration (no code changes) | 90 | - |

### CityPermits.Inspections

`src/CityPermits.Inspections/CityPermits.Inspections.csproj` · web · Ready with configuration (no code changes)

Facts: entry=CityPermits.Inspections.dll; connection_strings=['Permits']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It can still be containerized without code changes by rolling forward onto the supported .NET 10 runtime (DOTNET_ROLL_FORWARD=Major) or by publishing with -p:TargetFramework=net10.0.
  - Fix: The generated Dockerfile builds with the .NET 10 SDK and runs on the .NET 10 runtime with roll-forward; retarget to net10.0 when convenient.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/CityPermits.Inspections/CityPermits.Inspections.csproj: TargetFramework=net6.0`

### CityPermits.OpenData

`src/CityPermits.OpenData/CityPermits.OpenData.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; entry=CityPermits.OpenData.dll; connection_strings=['Permits']

- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/CityPermits.OpenData/CityPermits.OpenData.csproj: package Serilog.Sinks.File 5.0.0`

## Libraries with notable findings

- CityPermits.Gis: Code marked Windows-only by its authors, Single-threaded apartment (STA) threads, Vendor SDK loaded from its Windows installation, Windows-specific target framework (-windows)
