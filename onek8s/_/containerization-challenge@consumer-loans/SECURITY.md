# Security gate: containerization-challenge-consumer-loans

**PASSED**: fails on lint errors, a failed image build and a run that fails under the hardened security context. Vulnerability scans are off (`scan.enabled` in rules/60-security.yaml); `containerizer gate` scans.

Lint: 0 errors, 2 warnings.


| Component | Image | Scanner | Critical | High | Medium | Low | Gate |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| lucerne-lending-customerportal | run with the manifest's security context | | | | | | ok |
| lucerne-lending-documents | run with the manifest's security context | | | | | | ok |

## lucerne-lending-customerportal

- [warning] df-base-eol: runtime image mcr.microsoft.com/dotnet/aspnet:6.0 reached end of support on 2024-11-12; move to 10.0 (lucerne-lending-customerportal/Dockerfile)

## lucerne-lending-documents

- [warning] df-base-eol: runtime image mcr.microsoft.com/dotnet/runtime:6.0 reached end of support on 2024-11-12; move to 10.0 (lucerne-lending-documents/Dockerfile)
