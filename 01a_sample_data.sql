-- Synthetic coursework data, not clinical instructions. Run once after schema.
USE crownfield_eye_hospital;
START TRANSACTION;

INSERT INTO speciality
(speciality_id, speciality_name)
VALUES
(1, 'Cataract Surgery'),
(2, 'Glaucoma'),
(3, 'Retinal Diseases'),
(4, 'Corneal Diseases'),
(5, 'Paediatric Ophthalmology'),
(6, 'Medical Retina'),
(7, 'Oculoplastics'),
(8, 'Neuro-Ophthalmology'),
(9, 'General Ophthalmology'),
(10, 'Emergency Eye Care');

INSERT INTO patient
(patient_id, first_name, last_name, postcode, date_of_birth, phone, email)
VALUES
('P001', 'Laiba', 'Iqbal', 'B5 1HA', '1989-06-12', '0714345601', 'laiba.iqbal@google.com'),
('P002', 'Anmo', 'Brown', 'B9 2BY', '1970-09-28', '07123456002', 'anmo.brown@google.com'),
('P003', 'Kygo', 'Ayble', 'B3 3TT', '1993-01-15', '07123456003', 'kygo.ayble@google.com'),
('P004', 'Peker', 'Johnson', 'B4 4EF', '1978-06-09', '07123456004', 'peker.johnson@google.com'),
('P005', 'Maya', 'singh', 'B5 5KE', '2007-11-27', '07123456005', 'maya.singh@google.com'),
('P006', 'Bob', 'Miles', 'B2 6JF', '1979-03-19', '07123456006', 'bob.miles@google.com'),
('P007', 'Lotty', 'Hussain', 'B7 7GG', '1995-07-25', '07123456007', 'lotty.hussain@google.com'),
('P008', 'Noah', 'Ark', 'B8 8LH', '1978-12-04', '07123456008', 'noah.Ark@google.com'),
('P009', 'Tara', 'Ali', 'B9 9JH', '2008-02-17', '07123456009', 'tara.ali@google.com'),
('P010', 'James', 'Corn', 'B10 0FK', '1977-08-21', '07123456010', 'james.corn@google.com');

INSERT INTO clinician
(clinician_id, first_name, last_name, speciality_id, email)
VALUES
(1, 'Amina', 'Rifat', 1, 'amina.rifat@example.com'),
(2, 'David', 'Clam', 2, 'david.clam@example.com'),
(3, 'Priti', 'Patel', 3, 'priti.patel@example.com'),
(4, 'Dean', 'Malik', 4, 'dean.malik@example.com'),
(5, 'Halen', 'Jans', 5, 'halen.jans@example.com'),
(6, 'Yusuf', 'Aftab', 6, 'yusuf.atfab@example.com'),
(7, 'Lee', 'Walker', 7, 'lee.walker@example.com'),
(8, 'Adam', 'Bills', 8, 'adam.bills@example.com'),
(9, 'Nadia', 'Begum', 9, 'nadia.begum@example.com'),
(10, 'Tom', 'Heer', 10, 'tom.heer@example.com');

INSERT INTO clinic
(clinic_id, clinic_name, address)
VALUES
(1, 'Crownfield Central Clinic', '10 Ost Road, Birmingham'),
(2, 'Crownfield North Clinic', '20 Eple Road, Birmingham'),
(3, 'Crownfield South Clinic', '30 Ample Road, Birmingham'),
(4, 'Crownfield East Clinic', '40 Miple Road, Birmingham'),
(5, 'Crownfield West Clinic', '50 Yot Road, Birmingham'),
(6, 'Crownfield Riverside Clinic', '60 Side Road, Birmingham'),
(7, 'Crownfield Park Clinic', '70 fis Road, Birmingham'),
(8, 'Crownfield Community Clinic', '80 Joking Road, Birmingham'),
(9, 'Crownfield Outpatient Clinic', '90 Pets Road, Birmingham'),
(10, 'Crownfield Diagnostic Clinic', '100 Case Road, Birmingham');

INSERT INTO appointment
(appointment_id, patient_id, clinician_id, clinic_id, appointment_date, appointment_time, notes, status)
VALUES
(1, 'P001', 9, 1, '2026-10-19', '09:00:00', 'General eye assessment', 'Completed'),
(2, 'P002', 1, 2, '2026-10-19', '09:30:00', 'Cataract assessment', 'Completed'),
(3, 'P003', 2, 3, '2026-10-19', '10:00:00', 'Glaucoma assessment', 'Completed'),
(4, 'P004', 4, 4, '2026-10-19', '10:30:00', 'Corneal assessment', 'Completed'),
(5, 'P005', 9, 5, '2026-10-20', '09:00:00', 'Routine eye examination', 'Completed'),
(6, 'P006', 6, 6, '2026-10-20', '09:30:00', 'Medical retina assessment', 'Completed'),
(7, 'P007', 7, 7, '2026-10-20', '10:00:00', 'Eyelid assessment', 'Completed'),
(8, 'P008', 8, 8, '2026-10-20', '10:30:00', 'Neuro-ophthalmology assessment', 'Completed'),
(9, 'P009', 9, 9, '2026-10-21', '09:00:00', 'General eye assessment', 'Completed'),
(10, 'P010', 3, 10, '2026-10-21', '09:30:00', 'Retinal assessment', 'Completed');

INSERT INTO diagnosis
(diagnosis_id, appointment_id, diagnosis_name, diagnosis_notes)
VALUES
(1, 1, 'Suspected dry eye', 'Provisional diagnosis recorded at assessment; follow-up review planned.'),
(2, 2, 'Suspected cataract', 'Provisional diagnosis recorded at assessment; accompanying dry-eye symptoms treated; follow-up planned.'),
(3, 3, 'Suspected glaucoma', 'Provisional diagnosis recorded at assessment; follow-up review planned.'),
(4, 4, 'Suspected keratoconus', 'Provisional diagnosis recorded at assessment; accompanying dry-eye symptoms treated; follow-up planned.'),
(5, 5, 'Suspected myopia', 'Provisional diagnosis recorded at assessment; accompanying dry-eye symptoms treated; follow-up planned.'),
(6, 6, 'Suspected diabetic retinopathy', 'Provisional diagnosis recorded at assessment; accompanying dry-eye symptoms treated; follow-up planned.'),
(7, 7, 'Suspected ptosis', 'Provisional diagnosis recorded at assessment; accompanying dry-eye symptoms treated; follow-up planned.'),
(8, 8, 'Suspected optic nerve disorder', 'Provisional diagnosis recorded at assessment; accompanying dry-eye symptoms treated; follow-up planned.'),
(9, 9, 'Suspected allergic conjunctivitis', 'Provisional diagnosis recorded at assessment; follow-up review planned.'),
(10, 10, 'Suspected retinal degeneration', 'Provisional diagnosis recorded at assessment; accompanying dry-eye symptoms treated; follow-up planned.');

INSERT INTO medicine
(medicine_id, medicine_name)
VALUES
(1, 'Hypromellose'),
(2, 'Carmellose sodium'),
(3, 'Sodium hyaluronate'),
(4, 'Latanoprost'),
(5, 'Timolol'),
(6, 'Dorzolamide'),
(7, 'Brimonidine'),
(8, 'Chloramphenicol'),
(9, 'Sodium cromoglicate'),
(10, 'Prednisolone');

INSERT INTO prescription
(prescription_id, appointment_id, prescription_date)
VALUES
(1, 1, '2026-10-19'),
(2, 2, '2026-10-19'),
(3, 3, '2026-10-19'),
(4, 4, '2026-10-19'),
(5, 5, '2026-10-20'),
(6, 6, '2026-10-20'),
(7, 7, '2026-10-20'),
(8, 8, '2026-10-20'),
(9, 9, '2026-10-21'),
(10, 10, '2026-10-21');

INSERT INTO prescription_item
(prescription_id, medicine_id, dose, route, frequency, duration_days)
VALUES
(1, 1, '1 drop', 'Ophthalmic', 'Four times daily', 28),
(2, 2, '1 drop', 'Ophthalmic', 'Four times daily', 28),
(3, 4, '1 drop', 'Ophthalmic', 'Once daily in the evening', 28),
(4, 3, '1 drop', 'Ophthalmic', 'Three times daily', 28),
(5, 1, '1 drop', 'Ophthalmic', 'Four times daily', 14),
(6, 2, '1 drop', 'Ophthalmic', 'Four times daily', 28),
(7, 3, '1 drop', 'Ophthalmic', 'Three times daily', 14),
(8, 1, '1 drop', 'Ophthalmic', 'Four times daily', 28),
(9, 9, '1 drop', 'Ophthalmic', 'Four times daily', 14),
(10, 2, '1 drop', 'Ophthalmic', 'Four times daily', 28);

INSERT INTO follow_up
(follow_up_id, appointment_id, due_date, priority, status)
VALUES
(1, 1, '2026-11-16', 'Routine', 'Pending'),
(2, 2, '2026-11-16', 'Routine', 'Pending'),
(3, 3, '2026-11-02', 'High', 'Pending'),
(4, 4, '2026-11-16', 'Routine', 'Pending'),
(5, 5, '2026-11-17', 'Routine', 'Pending'),
(6, 6, '2026-11-03', 'High', 'Pending'),
(7, 7, '2026-11-17', 'Routine', 'Pending'),
(8, 8, '2026-11-03', 'High', 'Pending'),
(9, 9, '2026-11-04', 'Routine', 'Pending'),
(10, 10, '2026-11-04', 'High', 'Pending');

COMMIT;
