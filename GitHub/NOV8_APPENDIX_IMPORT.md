# Appendix 1 import recorded 8 November 2026

Source: the five original appointment rows supplied in the conversation. The CSV retains every source value. Successful MySQL execution is shown in 12_appendix1_import.png. These five rows cover four distinct patients. No claim is made about any further Appendix rows not supplied.

| Source row | Patient | Appointment | Follow-up due | Priority |
| --- | --- | --- | --- | --- |
| 1 | OP001 Amina Yusuf | 16 | 2026-11-16 | High |
| 2 | OP002 Daniel Reed | 17 | 2026-11-02 | Urgent |
| 3 | OP001 Amina Yusuf | 18 | 2027-02-08 | Routine |
| 4 | OP003 Sofia Bennett | 19 | 2027-04-06 | Routine |
| 5 | OP004 Michael Okoro | 20 | 2026-12-02 | Routine |

The screenshot verifies 5 source rows, 4 distinct patients, 5 linked appointments, 5 diagnoses, 4 prescriptions, 5 medicine items and 5 follow-ups. The student confirmed the subsequent totals as 14 patients, 10 synthetic patients and 15 appointments. Appointment identifiers have gaps after earlier tests; gaps do not mean missing source rows.

Assumptions: follow-up intervals start on appointment dates; prescription dates equal appointment dates; missing appointment statuses use the Scheduled default and follow-ups use Pending. Missing DOB, contact details, addresses and treatment instructions remain NULL. The import makes dose, route, frequency and duration nullable and retains the positive-duration CHECK. None creates no prescription. Dr is retained in source text and excluded from the normalised first name.

appendix1_source preserves the raw text and has a unique foreign key to appointment. It is provenance data, not an eleventh clinical entity. The import recognises rows already imported and aborts on conflicting source/patient/clinician information. Its DML runs in a transaction; the preceding ALTER/CREATE statements commit separately. A backup completed before execution. The complete fresh setup has not been independently rerun in MySQL.
