# Access matrix and protection

Four user types satisfy D1. The administrator here administers application data, not the MySQL server.

| Role | SELECT | INSERT | UPDATE | DELETE |
| --- | --- | --- | --- | --- |
| Administrator | All application tables/views | All application tables | All application tables | All application tables |
| Doctor | Clinical records, catalogue, appointments and limited patient identity columns | Diagnoses, prescriptions, items, follow-ups | Same clinical tables | None |
| Receptionist | Patient contact columns, appointment scheduling columns, clinicians/clinics/specialities | Patient registration and appointment scheduling columns | Contact/scheduling columns | None |
| Patient | Own appointment view only | None | None | None |

Neither the receptionist nor patient can read diagnoses. Receptionists cannot read appointment notes. Patients cannot read base tables or edit the login-to-patient mapping. A patient login maps to a patient ID in the auxiliary `patient_account` table; the definer view filters using the connected `USER()` login. This local prototype provisions localhost logins only; proxy authentication and remote-host identity policies are outside scope.

The doctor procedure is static SQL with a typed input parameter. Patients are deliberately NOT granted EXECUTE on this unrestricted patient-ID procedure.

## D2: password protection
`04_security.sql` provisions four real MySQL accounts using `caching_sha2_password` and random passwords. The server stores authentication verifiers instead of plaintext passwords. Evidence checks the plugin and that the verifier is present, without exposing it. Random passwords appear in the account-creation results: record them privately, not in the repository or screenshots.

This protects database login passwords. It does not encrypt the existing clinical tables or provide application password registration. It relies on MySQL's authentication implementation rather than an unsalted custom SHA2 password column.

`04a_protection_demo.sql` additionally demonstrates AES-256-CBC encryption and verified decryption of sensitive email copies in a temporary table using a random session key and per-record IV. It leaves no permanent encryption key. It is a demonstration, not whole-database encryption: the original patient.email field remains plaintext and is protected through access controls. CBC alone does not authenticate ciphertext; a production design would require authenticated encryption/integrity protection and managed keys.

## Evidence
Run `07_permission_tests.sql` under the named accounts. Testing as root does not demonstrate least privilege. Successful denials and successful allowed reads both belong in the test log. Never publish generated passwords or authentication verifiers.

## Technical sources
- MySQL 8.0 Reference Manual, Using Roles: https://dev.mysql.com/doc/refman/8.0/en/roles.html
- MySQL 8.0 Reference Manual, Password Management: https://dev.mysql.com/doc/refman/8.0/en/password-management.html
- MySQL 8.0 Reference Manual, Assigning Account Passwords: https://dev.mysql.com/doc/refman/8.0/en/assigning-passwords.html
- MySQL 8.0 Reference Manual, Encryption and Compression Functions: https://dev.mysql.com/doc/refman/8.0/en/encryption-functions.html
- MySQL 8.0 Reference Manual, START TRANSACTION, COMMIT and ROLLBACK: https://dev.mysql.com/doc/refman/8.0/en/commit.html
