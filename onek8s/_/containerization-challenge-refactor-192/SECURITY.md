# Security gate: containerization-challenge-field-service-refactor-192

**PASSED**: fails on fixable CRITICAL or worse vulnerabilities and on lint errors.

Lint: 0 errors, 0 warnings.


| Component | Image | Scanner | Critical | High | Medium | Low | Gate |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| fieldservice-web | base: `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| fieldservice-web | image: `containerizer/containerization-challenge-field-service-refactor-192-fieldservice-web:gate` | trivy | 0 (0 fixable) | 1 (0) | 2 | 1 | pass |
| fieldservice-web | run with the manifest's security context | | | | | | inconclusive |
| fieldservice-worker | base: `mcr.microsoft.com/dotnet/runtime:10.0.14-noble-chiseled-extra` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| fieldservice-worker | image: `containerizer/containerization-challenge-field-service-refactor-192-fieldservice-worker:gate` | trivy | 0 (0 fixable) | 1 (0) | 2 | 1 | pass |
| fieldservice-worker | run with the manifest's security context | | | | | | ok |

## fieldservice-web

- scanner unavailable for `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-field-service-refactor-192-fieldservice-web:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000

## fieldservice-worker

- scanner unavailable for `mcr.microsoft.com/dotnet/runtime:10.0.14-noble-chiseled-extra` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-field-service-refactor-192-fieldservice-worker:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
