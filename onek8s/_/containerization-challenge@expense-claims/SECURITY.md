# Security gate: containerization-challenge-expense-claims

**FAILED**: fails on fixable CRITICAL or worse vulnerabilities and on lint errors.

Lint: 0 errors, 0 warnings.


| Component | Image | Scanner | Critical | High | Medium | Low | Gate |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| expenseclaims-api | base: `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| expenseclaims-api | image: `containerizer/containerization-challenge-expense-claims-expenseclaims-api:gate` | trivy | 1 (1 fixable) | 3 (2) | 4 | 1 | 1 blocking |
| expenseclaims-api | run with the manifest's security context | | | | | | inconclusive |
| expenseclaims-jobs | base: `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| expenseclaims-jobs | image: `containerizer/containerization-challenge-expense-claims-expenseclaims-jobs:gate` | trivy | 1 (1 fixable) | 4 (3) | 6 | 1 | 1 blocking |
| expenseclaims-jobs | run with the manifest's security context | | | | | | inconclusive |

## expenseclaims-api

- **CRITICAL** CVE-2021-24112 in System.Drawing.Common 4.7.0, fixed in 4.7.2, 5.0.3 (application package: upgrade it)
- application package with a fixable HIGH/CRITICAL vulnerability: Microsoft.Data.SqlClient 2.1.4 -> 2.1.7, 3.1.5, 4.0.5, 5.1.3
- application package with a fixable HIGH/CRITICAL vulnerability: Microsoft.Extensions.Caching.Memory 6.0.1 -> 8.0.1, 9.0.0-rc.2.24473.5, 6.0.2
- application package with a fixable HIGH/CRITICAL vulnerability: System.Drawing.Common 4.7.0 -> 4.7.2, 5.0.3
- scanner unavailable for `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-expense-claims-expenseclaims-api:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000

## expenseclaims-jobs

- **CRITICAL** CVE-2021-24112 in System.Drawing.Common 4.7.0, fixed in 4.7.2, 5.0.3 (application package: upgrade it)
- application package with a fixable HIGH/CRITICAL vulnerability: Microsoft.Data.SqlClient 2.1.4 -> 2.1.7, 3.1.5, 4.0.5, 5.1.3
- application package with a fixable HIGH/CRITICAL vulnerability: MimeKit 3.4.2 -> 4.7.1
- application package with a fixable HIGH/CRITICAL vulnerability: Newtonsoft.Json 12.0.3 -> 13.0.1
- application package with a fixable HIGH/CRITICAL vulnerability: System.Drawing.Common 4.7.0 -> 4.7.2, 5.0.3
- scanner unavailable for `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled-extra` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-expense-claims-expenseclaims-jobs:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
