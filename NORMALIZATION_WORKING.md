# Normalization working

This is a design reconstruction from the scenario and implemented schema. It is not a transcription of Appendix 1. Replace or annotate the reconstruction against the original dataset before submission.

## Assumptions

- Each appointment has one patient, clinician and clinic.
- Each clinician has one required primary speciality in this implementation.
- A prescription medicine pair occurs once. Treatment instructions depend on that pair.
- Diagnoses and prescriptions are independent repeating groups within an appointment.
- Follow-up is optional and limited to one plan per appointment.

## UNF

An appointment document combines appointment attributes, patient details, clinician and speciality details, clinic details, a repeating set of diagnoses, a repeating set of prescriptions containing medicine lines, and an optional follow-up group.

AppointmentDocument(appointment_id, patient_id, patient_details, clinician_id, clinician_details, speciality_id, speciality_name, clinic_id, clinic_details, appointment_date, appointment_time, notes, status, {diagnosis_id, diagnosis_name, diagnosis_notes}, {prescription_id, prescription_date, {medicine_id, medicine_name, dose, route, frequency, duration_days}}, {follow_up_id, due_date, priority, follow_up_status})

Braces identify repeating or optional groups; they are not SQL syntax.

## First normal form

Give each field a single value. Separate independent repeating diagnosis and prescription groups rather than joining every diagnosis to every medicine and creating artificial combinations. The appointment relation can initially retain repeated parent descriptions. The prescription line relation can initially retain prescription_date, appointment_id and medicine_name.

## Second normal form

The provisional prescription line key is (prescription_id, medicine_id). Partial dependencies are prescription_id → appointment_id, prescription_date and medicine_id → medicine_name. Decompose into prescription(prescription_id, appointment_id, prescription_date), medicine(medicine_id, medicine_name), and prescription_item(prescription_id, medicine_id, dose, route, frequency, duration_days). The first two line attributes jointly form the line primary key and separately reference their parent tables.

## Third normal form

Remove appointment_id → patient_id → patient details; appointment_id → clinician_id → clinician details; clinician_id → speciality_id → speciality_name; appointment_id → clinic_id → clinic details. Patient, clinician, speciality and clinic each store their own descriptions. Appointment keeps their foreign keys. This avoids repeating those descriptions across appointments.

## Final relations and dependencies

- patient: patient_id → first_name, last_name, postcode, date_of_birth, phone, email, created_at.
- speciality: speciality_id → speciality_name.
- clinician: clinician_id → first_name, last_name, speciality_id, email.
- clinic: clinic_id → clinic_name, address.
- appointment: appointment_id → patient_id, clinician_id, clinic_id, appointment_date, appointment_time, notes, status.
- diagnosis: diagnosis_id → appointment_id, diagnosis_name, diagnosis_notes.
- prescription: prescription_id → appointment_id, prescription_date.
- medicine: medicine_id → medicine_name.
- prescription_item: (prescription_id, medicine_id) → dose, route, frequency, duration_days.
- follow_up: follow_up_id → appointment_id, due_date, priority, status. UNIQUE NOT NULL appointment_id is an alternate candidate key here.
- patient_account: login_name → patient_id; added for access control after clinical normalization.

All foreign keys connect the model. Splits use stable identifiers that determine parent attributes, allowing reconstruction of each original parent-child relationship by joins. Optional independent child sets must remain separately represented during reconstruction to avoid invented pairings. These are semantic dependencies under the stated assumptions; ten sample rows alone cannot prove them.

## Physical constraint limits

The conceptual minimum of one item per prescription is not enforced by the two item foreign keys. The model deliberately records the requirement; a controlled insert transaction or additional business-rule enforcement must address it. Existing CHECK constraints do not establish full clinical validity or prevent every scheduling conflict.
