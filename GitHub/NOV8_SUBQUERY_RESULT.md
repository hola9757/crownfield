# Subquery executed 8 November 2026

Recorded from the supplied MySQL Terminal output. This is a transcription, not an execution screenshot.

| appointment_id | patient_id | appointment_date | status |
| --- | --- | --- | --- |
| 3 | P003 | 2026-10-19 | Completed |
| 6 | P006 | 2026-10-20 | Completed |
| 8 | P008 | 2026-10-20 | Completed |
| 10 | P010 | 2026-10-21 | Completed |
| 16 | OP001 | 2026-10-05 | Scheduled |

The subquery filters linked follow-ups by priority High, not appointment status. Five rows were returned in 0.06 seconds. Appointment 16 is the original Appendix row for Amina Yusuf.
