# Security gate: containerization-challenge-consumer-loans

**PASSED**: fails on fixable CRITICAL or worse vulnerabilities and on lint errors.

Lint: 0 errors, 0 warnings.


| Component | Image | Scanner | Critical | High | Medium | Low | Gate |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| lucerne-lending-customerportal | base: `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| lucerne-lending-customerportal | image: `containerizer/containerization-challenge-consumer-loans-lucerne-lending-customerportal:gate` | trivy | 0 (0 fixable) | 1 (0) | 2 | 1 | pass |
| lucerne-lending-customerportal | run with the manifest's security context | | | | | | ok |
| lucerne-lending-documents | base: `mcr.microsoft.com/dotnet/runtime:10.0.14-noble-chiseled-extra` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| lucerne-lending-documents | image: `containerizer/containerization-challenge-consumer-loans-lucerne-lending-documents:gate` | trivy | 0 (0 fixable) | 2 (1) | 5 | 2 | pass |
| lucerne-lending-documents | run with the manifest's security context | | | | | | ok |

## lucerne-lending-customerportal

- scanner unavailable for `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-consumer-loans-lucerne-lending-customerportal:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000

## lucerne-lending-documents

- application package with a fixable HIGH/CRITICAL vulnerability: System.Security.Cryptography.Pkcs 6.0.1 -> 7.0.2, 6.0.3
- scanner unavailable for `mcr.microsoft.com/dotnet/runtime:10.0.14-noble-chiseled-extra` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-consumer-loans-lucerne-lending-documents:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
