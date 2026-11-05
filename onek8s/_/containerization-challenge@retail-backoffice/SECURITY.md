# Security gate: containerization-challenge-retail-backoffice

**PASSED**: fails on lint errors, a failed image build and a run that fails under the hardened security context. Vulnerability scans are off (`scan.enabled` in rules/60-security.yaml); `containerizer gate` scans.

Lint: 0 errors, 5 warnings.


| Component | Image | Scanner | Critical | High | Medium | Low | Gate |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| vanarsdel-allocation-api | run with the manifest's security context | | | | | | inconclusive |
| vanarsdel-backoffice | run with the manifest's security context | | | | | | inconclusive |
| vanarsdel-catalog-api | run with the manifest's security context | | | | | | inconclusive |
| vanarsdel-customers-api | run with the manifest's security context | | | | | | inconclusive |
| vanarsdel-gateway | run with the manifest's security context | | | | | | ok |
| vanarsdel-inventory-api | run with the manifest's security context | | | | | | inconclusive |
| vanarsdel-notifications | run with the manifest's security context | | | | | | ok |
| vanarsdel-orders-api | run with the manifest's security context | | | | | | inconclusive |
| vanarsdel-pricing-api | run with the manifest's security context | | | | | | inconclusive |
| vanarsdel-returns-api | run with the manifest's security context | | | | | | inconclusive |
| vanarsdel-scheduler | run with the manifest's security context | | | | | | inconclusive |
| vanarsdel-storemanager | run with the manifest's security context | | | | | | ok |
| vanarsdel-storeops-api | run with the manifest's security context | | | | | | inconclusive |

## vanarsdel-allocation-api

- [warning] df-base-eol: runtime image mcr.microsoft.com/dotnet/aspnet:6.0 reached end of support on 2024-11-12; move to 10.0 (vanarsdel-allocation-api/Dockerfile)

## vanarsdel-backoffice

- [warning] df-base-eol: runtime image mcr.microsoft.com/dotnet/aspnet:6.0 reached end of support on 2024-11-12; move to 10.0 (vanarsdel-backoffice/Dockerfile)

## vanarsdel-notifications

- [warning] df-base-eol: runtime image mcr.microsoft.com/dotnet/aspnet:6.0 reached end of support on 2024-11-12; move to 10.0 (vanarsdel-notifications/Dockerfile)

## vanarsdel-orders-api

- [warning] df-base-eol: runtime image mcr.microsoft.com/dotnet/aspnet:6.0 reached end of support on 2024-11-12; move to 10.0 (vanarsdel-orders-api/Dockerfile)

## vanarsdel-returns-api

- [warning] df-base-eol: runtime image mcr.microsoft.com/dotnet/aspnet:6.0 reached end of support on 2024-11-12; move to 10.0 (vanarsdel-returns-api/Dockerfile)
