# Security gate: containerization-challenge-broker-quotes

**PASSED**: fails on fixable CRITICAL or worse vulnerabilities and on lint errors.

Lint: 0 errors, 0 warnings.


| Component | Image | Scanner | Critical | High | Medium | Low | Gate |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| humongous-brokerportal | base: `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| humongous-brokerportal | image: `containerizer/containerization-challenge-broker-quotes-humongous-brokerportal:gate` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| humongous-brokerportal | run with the manifest's security context | | | | | | ok |
| humongous-documents | base: `mcr.microsoft.com/dotnet/runtime:10.0.14-noble-chiseled-extra` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| humongous-documents | image: `containerizer/containerization-challenge-broker-quotes-humongous-documents:gate` | trivy | 0 (0 fixable) | 4 (3) | 10 | 2 | pass |
| humongous-documents | run with the manifest's security context | | | | | | ok |
| humongous-workbench | base: `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| humongous-workbench | image: `containerizer/containerization-challenge-broker-quotes-humongous-workbench:gate` | trivy | 0 (0 fixable) | 1 (1) | 2 | 1 | pass |
| humongous-workbench | run with the manifest's security context | | | | | | ok |

## humongous-brokerportal

- scanner unavailable for `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-broker-quotes-humongous-brokerportal:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000

## humongous-documents

- application package with a fixable HIGH/CRITICAL vulnerability: SixLabors.ImageSharp 1.0.4 -> 2.1.9, 3.1.5
- application package with a fixable HIGH/CRITICAL vulnerability: SixLabors.ImageSharp 1.0.4 -> 3.1.3, 2.1.7
- application package with a fixable HIGH/CRITICAL vulnerability: SixLabors.ImageSharp 1.0.4 -> 3.1.7, 2.1.10
- scanner unavailable for `mcr.microsoft.com/dotnet/runtime:10.0.14-noble-chiseled-extra` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-broker-quotes-humongous-documents:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000

## humongous-workbench

- application package with a fixable HIGH/CRITICAL vulnerability: Microsoft.AspNetCore.SignalR.Common 8.0.10 -> 10.0.13, 11.0.0-rc.2, 8.0.32, 9.0.21
- scanner unavailable for `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-broker-quotes-humongous-workbench:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
