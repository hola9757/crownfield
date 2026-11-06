# Crownfield Eye Hospital database prototype

A MySQL relational database for patients, clinicians, clinics, appointments, diagnoses, medicines, prescriptions and follow-up plans in a fictional teaching scenario.

## Requirements and execution
MySQL 8.0.18+ with enforced CHECK constraints and root/admin access for setup. The working server reported MySQL 8.0.46.

Read `START_HERE.md` before running anything. It gives separate instructions for the existing populated database and a fresh reproduction environment.

Fresh execution order:
1. `01_schema.sql` — ten main tables and constraints.
2. `01a_sample_data.sql` — 100 synthetic records with explicit reproducible IDs.
3. `01b_schema_alignment.sql` — reconcile any legacy UNIQUE clinician surname index.
4. `02_individual_queries.sql` — four read-only Part C query features.
5. `03_procedure_and_trigger.sql` — parameterised procedure and follow-up trigger.
6. `04_security.sql` — four roles/accounts, patient mapping/view, grants and hashed-password evidence.
7. `04a_protection_demo.sql` — additional temporary AES encryption demonstration.
8. `06_validation.sql` — server-side transaction/trigger/constraint tests and procedure calls.
9. `07_permission_tests.sql` — tests run under the named restricted accounts, NOT as root.

`05_ERD/crownfield_erd.mmd` is the editable Crow's Foot diagram source. `ACCESS_MATRIX.md` explains access/protection and sources. `TESTING_NOTES.md` records observed results; new test results must be added after execution.

## Assumptions
- All sample people and clinical examples are synthetic. These records are database coursework examples, not prescribing guidance.
- The 10 main tables have 10 synthetic rows each. Original Appendix 1 anomalised data is not included because it was absent from both uploaded SQL files; import and document it separately as the brief requires.
- Explicit seed IDs keep joins reproducible. AUTO_INCREMENT still applies to subsequent records. created_at is generated when loaded.
- Each clinician has one required primary speciality. Appointments can have multiple diagnoses and prescriptions and at most one follow-up plan. Each prescription/medicine pair is unique.
- One or more prescription items is the business rule, but the parent minimum is not enforced by a simple FK. Explain application/transaction enforcement as a limitation.
- The trigger creates a Routine/Pending follow-up 28 days after an UPDATE transition to Completed only if none exists. This timing is a design assumption, not an explicit brief rule. INSERTing an already-completed appointment does not activate it.
- Main appointment dates are 19–21 October 2026; prescriptions match; follow-ups are later. Dates use MySQL DATE/TIME types; cross-table date validation currently has checking queries, not comprehensive automatic enforcement.
- Security uses four localhost demo accounts. The patient view maps the connected login to its own patient record through an auxiliary FK table.
- Native MySQL login passwords are hashed. The AES example encrypts temporary email copies only; existing clinical-table values remain protected by permissions, not whole-database encryption.
- Do not publish generated passwords, session encryption keys or authentication verifiers.

## Current validation status
Updated 4 November 2026. MySQL screenshots demonstrate the aggregate, four-table join, P001 procedure call, trigger completion and password-hash presence. The later server-side validation run was reported to match expected values; before/after trigger results are captured, with the remaining tabs still to be saved. Patient, doctor and receptionist permission checks were performed under separate logins. All four grants/default roles were inspected. The application administrator login test is pending.

A fresh SQLite compatibility conversion of the packaged schema/seed found ten rows per main table, no orphan references, matching prescription dates and later follow-up dates. All four SELECT results matched expectations. This is not a MySQL reproduction test. Current Mac contents remain unverified because later screenshots contain conflicting counts and new queries hang. See TESTING_NOTES.md.

05_ERD contains editable SVG and Mermaid sources, a PNG and normalization working. The evidence directory contains cropped SQL/result captures and an index. Crownfield_Report_Draft.docx is a review draft. SUBMISSION_ACTIONS.md lists remaining requirements.

## Optional secure-coding example
The patient-ID procedure uses a typed parameter in static SQL rather than building SQL text from input. For an application, bind values using its database connector, validate input and grant only the necessary privileges. Do not concatenate untrusted input into queries. SQL-injection protection is an optional extra-credit task in Part D.

## Remaining submission work
Add missing execution evidence, reproduce the scripts in a fresh MySQL environment, reconcile/import/analyse Appendix 1 data, confirm personal contributions, finalize the report and prepare slides and recording. This repository package is not proof of final submission completion.
