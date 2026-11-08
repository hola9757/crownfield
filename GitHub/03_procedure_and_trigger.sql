-- Part C: procedure and trigger. Run once after schema and sample data.
-- These objects already exist in the current working database.
-- Single-statement bodies: no DELIMITER change is needed.

-- Input parameter selects one patient without dynamic SQL.
CREATE PROCEDURE crownfield_eye_hospital.get_patient_appointments(
    IN p_patient_id VARCHAR(10)
)
SELECT
    a.appointment_id,
    a.patient_id,
    a.appointment_date,
    a.appointment_time,
    CONCAT(c.first_name, ' ', c.last_name) AS clinician_name,
    cl.clinic_name,
    a.status
FROM crownfield_eye_hospital.appointment AS a
INNER JOIN crownfield_eye_hospital.clinician AS c
    ON c.clinician_id = a.clinician_id
INNER JOIN crownfield_eye_hospital.clinic AS cl
    ON cl.clinic_id = a.clinic_id
WHERE a.patient_id = p_patient_id
ORDER BY a.appointment_date, a.appointment_time, a.appointment_id;

-- Design assumption: a transition to Completed creates a routine follow-up
-- 28 days after the appointment, unless a follow-up plan already exists.
-- This AFTER UPDATE trigger does not handle rows initially INSERTed as Completed.
CREATE TRIGGER crownfield_eye_hospital.trg_completed_follow_up
AFTER UPDATE ON crownfield_eye_hospital.appointment
FOR EACH ROW
INSERT INTO crownfield_eye_hospital.follow_up
    (appointment_id, due_date, priority, status)
SELECT
    NEW.appointment_id,
    DATE_ADD(NEW.appointment_date, INTERVAL 28 DAY),
    'Routine',
    'Pending'
WHERE NEW.status = 'Completed'
  AND OLD.status <> 'Completed'
  AND NOT EXISTS (
      SELECT 1
      FROM crownfield_eye_hospital.follow_up AS f
      WHERE f.appointment_id = NEW.appointment_id
  );
