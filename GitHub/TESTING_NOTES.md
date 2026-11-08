# Testing log

Historical seed-data tests recorded on 7 November 2026. Root TCP access was recovered on the expected server. Fresh supplied MySQL output confirms ten rows in every main table. This resolves the uncertainty from earlier conflicting retained result tabs; it does not identify why Workbench stalled.

## Current execution evidence

- GROUP BY/HAVING: clinician 9, Nadia Begum, 3 appointments, independently rerun under administrator.
- Four-table INNER JOIN: earlier captured successful execution, 10 rows.
- LEFT JOIN: 5 unused medicines, IDs 5,6,7,8,10; 7 November screenshot included.
- High-priority subquery: appointments 3,6,8,10; supplied Terminal output recorded.
- P001 procedure: one appointment with Nadia Begum and Central Clinic, rerun under administrator.
- All 14 validation tests passed with matching actual/expected results. See evidence/NOV7_EXECUTION_RESULTS.md for the transcribed values.
- Final counts: all ten main tables contain 10 records after test cleanup.
- Administrator login: cf_admin_demo@localhost, cf_administrator@% active, SELECT permitted and procedure callable. Write privileges were inspected in earlier grants but not separately exercised under this account.
- Patient, doctor and receptionist allow/deny tests: earlier screenshots and supplied execution text remain valid historical evidence. They have not all been rerun following recovery.
- Password protection: earlier output records caching_sha2_password and stored hash-presence flags. Actual passwords are excluded.
- Optional AES email-copy demonstration: code supplied, execution unconfirmed.

## Failure history

An early manual rollback failed and required controlled cleanup. It is not successful rollback evidence. The later server-side validation routine passed rollback checks for both appointment and follow-up. Earlier account/password failures and stalled Workbench queries were followed by successful normal Terminal access on 7 November.

## Reproduction limits

A SQLite compatibility conversion checked seed relationships and date consistency. It cannot test MySQL-specific routines or grants. The complete package subsequently passed a fresh MySQL 8.0.46 setup in an isolated instance on 8 November; see FRESH_SETUP_EXECUTION_20261108.md. On 8 November, the five supplied Appendix 1 rows were imported alongside the seed data. Their mapping and verified source counts are recorded in NOV8_APPENDIX_IMPORT.md. Combined totals were confirmed as 14 patients and 15 appointments. The recorded output is student supplied; transcribed evidence is labelled and is not a fabricated screenshot.


## Appendix import on 8 November

Actual MySQL screenshot: 5 source rows, 4 patients, 5 appointments, 5 diagnoses, 4 prescriptions, 5 prescription items, 5 follow-ups. Original appointments received IDs 16–20 after earlier tests advanced AUTO_INCREMENT. Source dates and intervals are preserved. Missing treatment details are NULL. The source mapping links through an appointment foreign key. A completed database backup preceded import. Combined totals were confirmed by the student as 14 patients, 10 synthetic patients and 15 appointments.

These new records change subsequent aggregate, join and subquery results. The 7 November results remain historical evidence for the seed dataset. New outputs must be recorded as observed, rather than inferred from those old screenshots.

The High-priority subquery was rerun after the import and returned appointments 3, 6, 8, 10 and 16. See NOV8_SUBQUERY_RESULT.md for the actual supplied output.


## Fresh setup on 8 November 2026

The student ran run_fresh_check.sh in a separate empty MySQL 8.0.46 instance. The script completed with PASS after checking all 14 validation results, post-import query results and counts, source-import idempotency, four account logins and expected denials, administrator CRUD and the temporary AES demonstration. The working database was not used. The actual console screenshot is 13_fresh_setup.png. The full safe result file was saved on the student’s Desktop as Crownfield_Fresh_Check_Result_20261108_180735.txt.
