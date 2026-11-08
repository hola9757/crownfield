# Running the Crownfield project

## Existing database

The working database already contains synthetic data and the five imported Appendix rows. Its confirmed totals are 14 patients and 15 appointments. Keep the completed backup Crownfield_before_appendix1.sql private. Do not recreate the schema or reload seed records over this database.

Read-only queries can be rerun to capture current results. Existing saved query images show earlier data and are dated accordingly. Use the appropriate account for permission tests. The root account is required for setup and the validation routine, while cf_admin_demo can execute the patient-appointment procedure.

## Fresh setup

Use a separate empty MySQL 8.0.18+ environment and follow README.md. The numbered import runs after the seed data and before the individual queries. Account setup generates passwords that must be kept privately. Run 06_validation.sql in one server session. Run each restricted-account section of 07_permission_tests.sql under that account.

The scripts use the fixed database name crownfield_eye_hospital. Changing only CREATE DATABASE is insufficient to create an isolated alternate version on the same server because routines, queries and grants also name the database.

## Submission files

Moodle: individual report DOCX, slides PPTX or PDF, and 8–10 minute MP4 recording. The brief requires the camera on unless an approved adjustment applies. The recording must include two executed SQL features, including the procedure or trigger, plus security and transaction behaviour.

GitHub: ordered SQL, README.md, START_HERE.md, ACCESS_MATRIX.md, TESTING_NOTES.md, original ERD files and selected execution evidence. Confirm that the lecturer can access the repository. Do not upload passwords or screenshots exposing credentials.
