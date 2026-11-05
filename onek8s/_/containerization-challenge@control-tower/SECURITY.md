# Security gate: containerization-challenge-control-tower

**PASSED**: fails on lint errors, a failed image build and a run that fails under the hardened security context. Vulnerability scans are off (`scan.enabled` in rules/60-security.yaml); `containerizer gate` scans.

Lint: 0 errors, 4 warnings.


| Component | Image | Scanner | Critical | High | Medium | Low | Gate |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| controltower-carriergateway | run with the manifest's security context | | | | | | ok |
| controltower-events | run with the manifest's security context | | | | | | inconclusive |
| controltower-telematics | run with the manifest's security context | | | | | | ok |
| controltower-tower-api | run with the manifest's security context | | | | | | ok |

## controltower-carriergateway

- [warning] df-base-eol: runtime image mcr.microsoft.com/dotnet/aspnet:6.0 reached end of support on 2024-11-12; move to 10.0 (controltower-carriergateway/Dockerfile)

## controltower-events

- [warning] df-base-eol: runtime image mcr.microsoft.com/dotnet/runtime:6.0 reached end of support on 2024-11-12; move to 10.0 (controltower-events/Dockerfile)

## controltower-telematics

- [warning] df-base-eol: runtime image mcr.microsoft.com/dotnet/runtime:7.0 reached end of support on 2024-05-14; move to 10.0 (controltower-telematics/Dockerfile)

## controltower-tower-api

- [warning] df-base-eol: runtime image mcr.microsoft.com/dotnet/aspnet:6.0 reached end of support on 2024-11-12; move to 10.0 (controltower-tower-api/Dockerfile)
