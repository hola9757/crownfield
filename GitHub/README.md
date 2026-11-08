# Crownfield Eye Hospital database

MySQL coursework prototype for the fictional Crownfield Eye Hospital. The ten clinical tables contain ten synthetic seed records each. The additional import contains the five Appendix 1 appointment rows supplied for this project, covering four original patients. The verified combined totals are 14 patients and 15 appointments.

## Setup

Use MySQL 8.0.18 or later with InnoDB and a separate empty setup environment. The working server reported MySQL 8.0.46. Run the following files in order as a user with setup privileges:

1. 01_schema.sql
2. 01a_sample_data.sql
3. 01b_schema_alignment.sql
4. 01c_appendix1_first5.sql
5. 02_individual_queries.sql
6. 03_procedure_and_trigger.sql
7. 04_security.sql
8. 04a_protection_demo.sql, if demonstrating the additional temporary encryption example
9. 06_validation.sql
10. 07_permission_tests.sql, using each named account for its own section

04_security.sql generates account passwords. Save them privately. Read 07_permission_tests.sql before running it because several commands are deliberately denied. Root cannot demonstrate restricted-account permissions.

For an existing populated database, do not rerun schema creation, seed inserts or account creation. START_HERE.md explains this distinction.

## Original data and assumptions

The original source values are retained in appendix1_first5_source.csv and appendix1_source. The source table maps each row to its normalised appointment through a unique foreign key. The SQL imports the supplied rows alongside the synthetic records and recognises rows already imported. Stop and inspect any error before continuing.

OP001 has two appointments but one patient record. Latanoprost and Timolol become separate items. None creates no prescription. Follow-up intervals start on appointment dates. Prescription dates use appointment dates. Missing appointment status uses the Scheduled default, and follow-up status uses Pending. These are implementation assumptions because the source omits those statuses and prescription dates.

Missing birth dates, contact details, addresses and treatment instructions stay NULL. The import changes prescription_item dose, route, frequency and duration to nullable columns. Its existing CHECK still requires any recorded duration to be positive. The original source values are preserved rather than replaced with invented treatment details. The ALTER and CREATE statements commit separately from the import's transaction.

Each clinician has one primary speciality. Each appointment has one patient, clinician and clinic. It may have multiple diagnoses or prescriptions and at most one follow-up. Each prescription/medicine pair is unique. The business minimum of one item per prescription needs enforcement beyond foreign keys.

The completion trigger creates a Routine, Pending follow-up 28 days after the appointment date when an UPDATE changes an appointment to Completed and no plan exists. This is a coursework assumption. The imported follow-ups use their original intervals instead. Inserting an already Completed appointment does not activate the UPDATE trigger.

## Diagram and files

The diagram files are crownfield_erd.mmd, crownfield_erd.svg and crownfield_erd.png. They are inside 05_ERD in the downloaded package; the existing GitHub upload uses the repository root. The diagram covers the clinical model, patient-account mapping and auxiliary import-source table with its appointment link. The import SQL and NOV8_APPENDIX_IMPORT.md document the source mapping.

ACCESS_MATRIX.md describes the roles. TESTING_NOTES.md identifies the executed tests. Execution evidence is inside evidence in the package; the existing GitHub upload stores its images at the root. Keep file paths consistent when uploading. The report, slides and recording are individual submission files.

## Recorded tests

On 7 November all 14 transaction, trigger and constraint validation results matched expectations. These tests preceded the source import. The four read-only queries and the P001 procedure also produced recorded results. Administrator login, active role, SELECT and procedure execution were verified. Earlier restricted-account results demonstrate allowed and denied access.

On 8 November the Appendix import returned 5 original appointments, 4 original patients, 5 diagnoses, 4 prescriptions, 5 medicine items and 5 follow-ups. The combined patient and appointment totals were then confirmed. These changes affect subsequent query results. Comments in 02_individual_queries.sql explicitly identify its historical seed-only expectations.

On 8 November 2026, the complete supplied setup passed in a separate empty MySQL 8.0.46 instance. All 14 validation checks matched, all four demo logins and expected access denials passed, administrator INSERT/UPDATE/DELETE passed, the temporary AES email-copy round trip matched all 14 values, and rerunning the source import created no duplicates. See FRESH_SETUP_EXECUTION_20261108.md and 13_fresh_setup.png. This test did not use the working database.

## Security

Four roles separate patient, receptionist, doctor and application-administrator access. Patient access uses a login mapping and filtered appointment view. Native MySQL authentication protects account passwords. It does not encrypt all clinical fields. The optional AES example encrypts temporary email copies and leaves original patient fields unchanged.

The patient-ID procedure uses a typed parameter and static SQL. Applications should bind values through their database connector rather than concatenate input. Do not upload passwords, authentication verifiers, encryption keys or screenshots that reveal them.
