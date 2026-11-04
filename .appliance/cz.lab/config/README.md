# Configuration of the appliance cz.lab

Copied from `/etc/containerizer` at its last boot, without secrets: a setting whose value is a secret says only
whether it is set (`<set: not backed up>`); passwords inside values are `<redacted>`. `secrets/` (generated passwords, the
credential key) and `tls/` are never copied: back them up separately (docs/appliance-admin.md#backup).
