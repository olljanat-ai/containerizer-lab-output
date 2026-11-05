# Security gate: containerization-challenge-control-tower

**PASSED**: fails on lint errors, a failed image build and a run that fails under the hardened security context. Vulnerability scans are off (`scan.enabled` in rules/60-security.yaml); `containerizer gate` scans.

Lint: 0 errors, 0 warnings.


| Component | Image | Scanner | Critical | High | Medium | Low | Gate |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| controltower-carriergateway | run with the manifest's security context | | | | | | ok |
| controltower-events | run with the manifest's security context | | | | | | inconclusive |
| controltower-telematics | run with the manifest's security context | | | | | | ok |
| controltower-tower-api | run with the manifest's security context | | | | | | ok |
