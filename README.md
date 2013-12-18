netbackup-nagios-checks
=======================
Nagios/OP5 checks for NetBackup services.

Scripts should be very vanilla so that they are compatible with both nagios and OP5.

Checks:
  - Master server checks
    - NetBackup services
    - Last status of catalog backup?
  - Media server checks
    - NetBackup services
    - PureDisk pool/disk volume status
      - On each media server poll the entire structure from status of STU, Diskpool and verify that ``crcontrol --getmode`` outputs ``GET=Yes`` and ``PUT=Yes``
    - Tape drive status
      - Up/down/offline/needs cleaning etc
      - Paths
    - Tape library status
      - Up/down
      - ??
