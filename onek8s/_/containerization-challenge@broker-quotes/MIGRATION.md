# containerization-challenge-broker-quotes: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 93/100 · confidence 1.0  
Stateless: yes

3/3 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| Humongous.BrokerPortal | web | net8.0 | Ready: containerize as is | 100 | - |
| Humongous.Documents | worker | net8.0 | Ready with configuration (no code changes) | 90 | - |
| Humongous.Workbench | web | net8.0 | Ready with configuration (no code changes) | 90 | - |

### Humongous.BrokerPortal

`src/Humongous.BrokerPortal/Humongous.BrokerPortal.csproj` · web · Ready: containerize as is

Facts: health=/health; port=5320; entry=Humongous.BrokerPortal.dll


### Humongous.Documents

`src/Humongous.Documents/Humongous.Documents.csproj` · worker · Ready with configuration (no code changes)

Facts: entry=Humongous.Documents.dll; connection_strings=['Quoting']

- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/Humongous.Documents/Mail/MailSender.cs:68: Directory.CreateDirectory(o.PickupFolder);`

### Humongous.Workbench

`src/Humongous.Workbench/Humongous.Workbench.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; port=5330; entry=Humongous.Workbench.dll

- ⚙ **Blazor Server (interactive server rendering)** [config]
  - Why: Each user has a stateful circuit over a WebSocket held by one pod. With several replicas the ingress must keep users on their pod, and circuits are lost when a pod restarts or is rescheduled.
  - Fix: Enable cookie-based session affinity and WebSockets (long proxy timeouts) on the ingress, persist Data Protection keys, and use graceful shutdown/reconnect UI; or Azure SignalR Service.
  - Learn more: [learn.microsoft.com: server](https://learn.microsoft.com/en-us/aspnet/core/blazor/host-and-deploy/server)
  - Evidence: `src/Humongous.Workbench/Program.cs:57: builder.Services.AddRazorComponents().AddInteractiveServerComponents();`

## Libraries with notable findings

- Humongous.Quoting.Rating: 32-bit (x86) process, COM interop with a registered component, Code marked Windows-only by its authors, Single-threaded apartment (STA) threads, Windows-specific target framework (-windows)
