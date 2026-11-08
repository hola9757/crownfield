# Recorded MySQL execution results 7 November 2026

Transcribed from student-supplied Terminal output. This is not a screenshot or a fresh independent execution.

| Test | Actual | Expected |
| --- | --- | --- |
| trigger_before_completion | 0 | 0 |
| trigger_after_completion | 1 | 1 |
| trigger_no_duplicate | 1 | 1 |
| rollback_appointment | 0 | 0 |
| rollback_follow_up | 0 | 0 |
| existing_follow_up_preserved | 1 | 1 |
| commit_and_controlled_update | 1 | 1 |
| controlled_delete_cleanup | 0 | 0 |
| duplicate_primary_key_rejected | 1 | 1 |
| orphan_foreign_key_rejected | 1 | 1 |
| required_value_rejected | 1 | 1 |
| invalid_status_rejected | 1 | 1 |
| invalid_priority_rejected | 1 | 1 |
| nonpositive_duration_rejected | 1 | 1 |

All ten main tables returned 10 rows each after cleanup.

LEFT JOIN: medicine IDs 5 Timolol, 6 Dorzolamide, 7 Brimonidine, 8 Chloramphenicol, 10 Prednisolone.
Subquery: appointment IDs 3/P003/2026-10-19, 6/P006/2026-10-20, 8/P008/2026-10-20, 10/P010/2026-10-21.
Administrator: cf_admin_demo@localhost; active role cf_administrator@%; SELECT patient count 10.
Procedure P001: appointment 1, 2026-10-19 09:00, Nadia Begum, Crownfield Central Clinic, Completed.
Aggregate under administrator: clinician 9, Nadia Begum, 3 appointments.
Normal root connection: root@localhost, port3306, datadir/usr/local/mysql/data/.
