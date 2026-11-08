# Appendix 1 import recorded 8 November 2026

Source: the five original appointment rows from Appendix 1 used for this import. The CSV retains every source value. Successful MySQL execution is shown in 12_appendix1_import.png. These five rows cover four distinct patients.

| Source row | Patient | Appointment | Follow-up due | Priority |
| --- | --- | --- | --- | --- |
| 1 | OP001 Amina Yusuf | 16 | 2026-11-16 | High |
| 2 | OP002 Daniel Reed | 17 | 2026-11-02 | Urgent |
| 3 | OP001 Amina Yusuf | 18 | 2027-02-08 | Routine |
| 4 | OP003 Sofia Bennett | 19 | 2027-04-06 | Routine |
| 5 | OP004 Michael Okoro | 20 | 2026-12-02 | Routine |

The screenshot verifies 5 source rows, 4 distinct patients, 5 linked appointments, 5 diagnoses, 4 prescriptions, 5 medicine items and 5 follow-ups. The database contains 14 patients, including 10 synthetic patients, and 15 appointments. Appointment identifiers have gaps after earlier tests.

> Follow-up intervals are calculated from appointment dates, and prescription dates match appointment dates. Missing appointment and follow-up statuses default to Scheduled and Pending. Other missing details remain NULL. Treatment instruction fields allow NULL; duration must be positive when provided. “None” creates no prescription.
>
> appendix1_source stores the original source text, with one record per appointment. The import skips previously imported rows and stops if source, patient or clinician details conflict. Data changes run in a transaction; schema changes commit separately.
>
> A backup was completed before execution. The fresh setup passed testing on MySQL 8.0.46 on 8 November 2026. See FRESH_SETUP_EXECUTION_20261108.md.
