-- Part C: four query features. Read-only; run after schema and sample data.

-- 1. Aggregate workload report
-- Groups appointments by clinician and filters to counts above one. Expected: Nadia Begum, 3.
SELECT
    c.clinician_id,
    c.first_name,
    c.last_name,
    COUNT(a.appointment_id) AS total_appointments
FROM crownfield_eye_hospital.clinician AS c
INNER JOIN crownfield_eye_hospital.appointment AS a
    ON a.clinician_id = c.clinician_id
GROUP BY
    c.clinician_id,
    c.first_name,
    c.last_name
HAVING COUNT(a.appointment_id) > 1
ORDER BY total_appointments DESC, c.clinician_id;

-- 2. Appointment details across four tables
-- INNER JOIN links appointments, patients, clinicians and clinics. Expected: 10 rows.
SELECT
    a.appointment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(c.first_name, ' ', c.last_name) AS clinician_name,
    cl.clinic_name,
    a.appointment_date,
    a.appointment_time,
    a.status
FROM crownfield_eye_hospital.appointment AS a
INNER JOIN crownfield_eye_hospital.patient AS p
    ON p.patient_id = a.patient_id
INNER JOIN crownfield_eye_hospital.clinician AS c
    ON c.clinician_id = a.clinician_id
INNER JOIN crownfield_eye_hospital.clinic AS cl
    ON cl.clinic_id = a.clinic_id
ORDER BY
    a.appointment_date,
    a.appointment_time,
    a.appointment_id;

-- 3. Medicines not prescribed
-- LEFT JOIN retains medicines without items; IS NULL selects missing matches. Expected IDs: 5, 6, 7, 8, 10.
SELECT
    m.medicine_id,
    m.medicine_name,
    pi.prescription_id
FROM crownfield_eye_hospital.medicine AS m
LEFT JOIN crownfield_eye_hospital.prescription_item AS pi
    ON pi.medicine_id = m.medicine_id
WHERE pi.prescription_id IS NULL
ORDER BY m.medicine_id;

-- 4. High-priority follow-up appointments
-- IN subquery filters appointments by their follow-up priority. Expected IDs: 3, 6, 8, 10.
SELECT
    appointment_id,
    patient_id,
    appointment_date,
    status
FROM crownfield_eye_hospital.appointment
WHERE appointment_id IN (
    SELECT appointment_id
    FROM crownfield_eye_hospital.follow_up
    WHERE priority = 'High'
)
ORDER BY appointment_id;
