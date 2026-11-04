# Security gate: containerization-challenge-furnace-records

**PASSED**: fails on fixable CRITICAL or worse vulnerabilities and on lint errors.

Lint: 0 errors, 0 warnings.


| Component | Image | Scanner | Critical | High | Medium | Low | Gate |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| furnacerecords-api | base: `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| furnacerecords-api | image: `containerizer/containerization-challenge-furnace-records-furnacerecords-api:gate` | trivy | 0 (0 fixable) | 1 (0) | 2 | 1 | pass |
| furnacerecords-api | run with the manifest's security context | | | | | | inconclusive |
| furnacerecords-portal | base: `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble` | trivy | 0 (0 fixable) | 0 (0) | 20 | 5 | pass |
| furnacerecords-portal | image: `containerizer/containerization-challenge-furnace-records-furnacerecords-portal:gate` | trivy | 0 (0 fixable) | 1 (0) | 20 | 5 | pass |
| furnacerecords-portal | run with the manifest's security context | | | | | | ok |
| furnacerecords-worker | base: `mcr.microsoft.com/dotnet/runtime:10.0.14-noble-chiseled-extra` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| furnacerecords-worker | image: `containerizer/containerization-challenge-furnace-records-furnacerecords-worker:gate` | trivy | 0 (0 fixable) | 1 (0) | 2 | 1 | pass |
| furnacerecords-worker | run with the manifest's security context | | | | | | ok |

## furnacerecords-api

- scanner unavailable for `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-furnace-records-furnacerecords-api:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000

## furnacerecords-portal

- scanner unavailable for `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-furnace-records-furnacerecords-portal:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000

## furnacerecords-worker

- scanner unavailable for `mcr.microsoft.com/dotnet/runtime:10.0.14-noble-chiseled-extra` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-furnace-records-furnacerecords-worker:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
