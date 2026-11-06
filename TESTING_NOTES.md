# Testing log

Updated 4 November 2026. Expected results, student confirmations, captured outputs and fresh execution checks are distinguished below.

## Supplied code and data

The packaged schema, seed and four SELECT queries were executed on 4 November in a SQLite compatibility conversion with foreign keys enabled. All ten clinical tables contained ten synthetic rows; no orphan references were found. Prescription dates matched appointments and follow-up dates were later. The aggregate returned Nadia Begum with 3; the INNER JOIN returned 10 rows; the LEFT JOIN returned medicine IDs 5, 6, 7, 8, 10; the subquery returned appointment IDs 3, 6, 8, 10.

This conversion does not execute MySQL routines, triggers, grants or authentication and does not establish the Mac server's current contents.

## MySQL evidence

| Feature | Evidence | Status |
| --- | --- | --- |
| Aggregate and HAVING | 28 Oct 17:22 screenshot, Nadia Begum count 3 | Included |
| Four-table INNER JOIN | 28 Oct 17:24 screenshot, 10 rows | Included |
| LEFT JOIN and subquery | Earlier student confirmations, matching independent supplied-data results | MySQL screenshots pending |
| Procedure P001 | 28 Oct 17:29 screenshot, P001 with Nadia at Central Clinic | Included |
| Completion trigger | 28 Oct 17:39 screenshot, 22 Oct appointment Completed and follow-up due 19 Nov, Routine Pending | Included |
| Validation before completion | 28 Oct 18:29, actual 0 expected 0 | Included |
| Validation after completion | 4 Nov 16:23:23, actual 1 expected 1 | Included |
| Other validation, COMMIT, ROLLBACK and negative constraints | Student confirmed matching actual and expected values in the later routine run | Remaining result captures pending |
| Clinician surname index | 28 Oct 18:11 lists primary, unique email and speciality indexes; surname index absent | Included |
| Password protection | 28 Oct 18:16, four caching_sha2_password accounts with true hash-presence flags; supplied text confirms again on 2 Nov | Included |
| Four default roles | Supplied 2 Nov output shows the four intended mappings | Recorded text |
| Patient permissions | 2 Nov screenshot shows P001 own view and SELECT/DELETE denials, error 1142 | Included |
| Doctor permissions | Supplied text shows identity SELECT with 10 rows and email denial 1143; DELETE denial confirmed | Recorded text and confirmation |
| Receptionist permissions | Supplied text shows 10 contact rows; diagnosis denial confirmed | Recorded text and confirmation |
| Application administrator | Role grants and default assignment inspected | Independent login test pending |
| AES email-copy example | Code supplied | Execution not confirmed |

## Failure history and current live state

The first manual ROLLBACK failed to remove test records: counts remained 11. Controlled deletion of the marked test appointment restored appointment and follow-up counts to 10. This failed attempt is not successful rollback evidence. The later server-side validation routine keeps transaction steps in one server session.

One 4 November screenshot shows zero counts for all ten tables, while retained result tabs show earlier counts of 10 and a positive trigger result. A new COUNT query subsequently hung. These captures do not establish current contents or cause. A fresh verified query and connection review are pending. Do not initialize, restore or repopulate solely on this evidence.

## Remaining checks

Missing MySQL screenshots; administrator demo-account execution; complete fresh MySQL reproduction; original Appendix 1 import and analysis; confirmed individual contribution statement. Details are in SUBMISSION_ACTIONS.md.
