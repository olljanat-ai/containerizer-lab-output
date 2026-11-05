# Security gate: containerization-challenge-trade-rebates

**PASSED**: fails on fixable CRITICAL or worse vulnerabilities and on lint errors.

Lint: 0 errors, 0 warnings.


| Component | Image | Scanner | Critical | High | Medium | Low | Gate |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| traderebates-statementworker | base: `mcr.microsoft.com/dotnet/runtime:10.0.14-noble-chiseled-extra` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| traderebates-statementworker | image: `containerizer/containerization-challenge-trade-rebates-traderebates-statementworker:gate` | trivy | 0 (0 fixable) | 0 (0) | 2 | 1 | pass |
| traderebates-statementworker | run with the manifest's security context | | | | | | inconclusive |

## traderebates-statementworker

- scanner unavailable for `mcr.microsoft.com/dotnet/runtime:10.0.14-noble-chiseled-extra` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
- scanner unavailable for `containerizer/containerization-challenge-trade-rebates-traderebates-statementworker:gate` (others were used): grype: [0000] ERROR failed to fetch latest version: Get "https://toolbox-data.anchore.io/grype/releases/latest/VERSION": dial tcp: lookup toolbox-data.anchore.io on 169.254.53.53:53: server misbehaving
[0000
