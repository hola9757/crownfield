# Fresh setup execution on 8 November 2026

Executed on the student’s Mac using a separate empty MySQL 8.0.46 instance. The working database was not used. Screenshot: 13_fresh_setup.png.

The checker ran 01_schema.sql, 01a_sample_data.sql, 01b_schema_alignment.sql, 01c_appendix1_first5.sql, 02_individual_queries.sql, 03_procedure_and_trigger.sql, 04_security.sql, 04a_protection_demo.sql and 06_validation.sql. Permission-test sections ran under their intended accounts. The source import was rerun to check for duplicates.

Actual console result:

```text
PASS: cf_patient_demo login and 3 expected access denials
PASS: cf_reception_demo login and 3 expected access denials
PASS: cf_doctor_demo login and 2 expected access denials
PASS: cf_admin_demo login and 1 expected access denials
PASS: fresh setup and all checked results matched.
Result file saved on your Desktop: Crownfield_Fresh_Check_Result_20261108_180735.txt
The separate test instance is now shutting down. Keep the working database as it is.
```

The final PASS was issued after the checker verified all 14 validation results, query outputs, combined counts, import idempotency, role restrictions, administrator CRUD and AES email-copy recovery. The Desktop result file remains with the student; this record uses the supplied console output and screenshot.
