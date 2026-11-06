# Start here

## Existing working database

Do not recreate the schema, reload sample data or rerun account creation over the populated coursework database. Several features and permission tests are already demonstrated. Connection issues and current counts are unresolved. Ask the lecturer or IT support to check the active server, account authentication and live counts before changing data.

Meanwhile use the report, evidence and documentation. TESTING_NOTES.md states what has been demonstrated and what remains pending. A denied operation is a successful negative test when performed under the intended restricted account.

## Fresh reproduction only

Use a separate MySQL 8.0.18+ environment with InnoDB as default storage engine, suitable setup privileges and no existing crownfield_eye_hospital database or cf_* roles/accounts.

1. Run 01_schema.sql.
2. Run 01a_sample_data.sql once.
3. Run 01b_schema_alignment.sql. A clean schema has no legacy surname index to remove.
4. Run 02_individual_queries.sql for the four read-only reports.
5. Run 03_procedure_and_trigger.sql once.
6. Run 04_security.sql once and save each generated password privately with its exact username.
7. Optionally run 04a_protection_demo.sql in one session. It encrypts temporary email copies, not the original patient table.
8. Run 06_validation.sql as a complete script in one server session. Verify every actual/expected result and cleanup.
9. Run the appropriate 07_permission_tests.sql section in each named restricted account, one statement at a time. Root cannot demonstrate restricted access.

The scripts use a fixed database name. If only one server is available, ask the lecturer to help make a consistent alternate database/account configuration; changing only CREATE DATABASE is insufficient.

## GitHub and Moodle

Upload ordered SQL, README, access matrix, testing log, 05_ERD and selected evidence. Do not upload passwords or generated password results. The DOCX report, slides and recording are individual Moodle deliverables. SUBMISSION_ACTIONS.md lists remaining requirements.
