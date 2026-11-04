# Security gate: containerization-challenge-retail-backoffice

**PASSED**: fails on fixable CRITICAL or worse vulnerabilities and on lint errors.

Lint: 0 errors, 0 warnings.


| Component | Image | Scanner | Critical | High | Medium | Low | Gate |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| vanarsdel-storemanager | base: `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| vanarsdel-storemanager | image: `containerizer/containerization-challenge-retail-backoffice-vanarsdel-storemanager:gate` | trivy | 0 (0 fixable) | 3 (3) | 3 | 1 | pass |
| vanarsdel-storemanager | run with the manifest's security context | | | | | | ok |

## vanarsdel-storemanager

- application package with a fixable HIGH/CRITICAL vulnerability: Newtonsoft.Json 9.0.1 -> 13.0.1
- application package with a fixable HIGH/CRITICAL vulnerability: System.Private.Uri 4.3.0 -> 4.3.2
- scanner unavailable for `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-retail-backoffice-vanarsdel-storemanager:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
