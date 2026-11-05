# Security gate: containerization-challenge-broker-quotes

**PASSED**: fails on lint errors, a failed image build and a run that fails under the hardened security context. Vulnerability scans are off (`scan.enabled` in rules/60-security.yaml); `containerizer gate` scans.

Lint: 0 errors, 0 warnings.


| Component | Image | Scanner | Critical | High | Medium | Low | Gate |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| humongous-brokerportal | run with the manifest's security context | | | | | | ok |
| humongous-documents | run with the manifest's security context | | | | | | ok |
| humongous-workbench | run with the manifest's security context | | | | | | ok |
