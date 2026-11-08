-- Run ONCE as root/admin after files 01, 01a and 03. MySQL 8.0.18+.
-- Generated passwords appear only in execution results; keep them private.
-- Do not upload password results or screenshots containing passwords to GitHub.
USE crownfield_eye_hospital;

CREATE ROLE IF NOT EXISTS 'cf_administrator', 'cf_doctor', 'cf_patient', 'cf_receptionist';

-- Auxiliary login-to-patient mapping, not an additional clinical main table.
CREATE TABLE IF NOT EXISTS patient_account (
    login_name VARCHAR(32) PRIMARY KEY,
    patient_id VARCHAR(10) NOT NULL,
    CONSTRAINT fk_account_patient FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id)
) ENGINE=InnoDB;

-- USER() identifies the connected session, including inside this definer view.
-- Login names are provisioned only at localhost in this local prototype.
-- Patients cannot edit the mapping or read the base appointment table.
CREATE OR REPLACE SQL SECURITY DEFINER VIEW v_patient_own_appointments AS
SELECT a.appointment_id, a.patient_id, a.appointment_date,
       a.appointment_time, cl.clinic_name, a.status
FROM appointment AS a
INNER JOIN clinic AS cl ON cl.clinic_id = a.clinic_id
INNER JOIN patient_account AS pa ON pa.patient_id = a.patient_id
WHERE pa.login_name = SUBSTRING_INDEX(USER(), '@', 1);

GRANT SELECT, INSERT, UPDATE, DELETE ON crownfield_eye_hospital.* TO 'cf_administrator';
GRANT EXECUTE ON PROCEDURE crownfield_eye_hospital.get_patient_appointments TO 'cf_administrator';

GRANT SELECT (patient_id, first_name, last_name, date_of_birth)
ON crownfield_eye_hospital.patient TO 'cf_doctor';
GRANT SELECT ON crownfield_eye_hospital.appointment TO 'cf_doctor';
GRANT SELECT ON crownfield_eye_hospital.clinician TO 'cf_doctor';
GRANT SELECT ON crownfield_eye_hospital.clinic TO 'cf_doctor';
GRANT SELECT ON crownfield_eye_hospital.speciality TO 'cf_doctor';
GRANT SELECT ON crownfield_eye_hospital.medicine TO 'cf_doctor';
GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.diagnosis TO 'cf_doctor';
GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.prescription TO 'cf_doctor';
GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.prescription_item TO 'cf_doctor';
GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.follow_up TO 'cf_doctor';
GRANT EXECUTE ON PROCEDURE crownfield_eye_hospital.get_patient_appointments TO 'cf_doctor';

GRANT SELECT (patient_id, first_name, last_name, postcode, phone, email),
      INSERT (patient_id, first_name, last_name, postcode, date_of_birth, phone, email),
      UPDATE (first_name, last_name, postcode, phone, email)
ON crownfield_eye_hospital.patient TO 'cf_receptionist';
GRANT SELECT (appointment_id, patient_id, clinician_id, clinic_id,
              appointment_date, appointment_time, status),
      INSERT (patient_id, clinician_id, clinic_id, appointment_date, appointment_time, status),
      UPDATE (clinician_id, clinic_id, appointment_date, appointment_time, status)
ON crownfield_eye_hospital.appointment TO 'cf_receptionist';
GRANT SELECT ON crownfield_eye_hospital.clinic TO 'cf_receptionist';
GRANT SELECT ON crownfield_eye_hospital.clinician TO 'cf_receptionist';
GRANT SELECT ON crownfield_eye_hospital.speciality TO 'cf_receptionist';

GRANT SELECT ON crownfield_eye_hospital.v_patient_own_appointments TO 'cf_patient';

-- Native MySQL authentication hashes passwords before persistent storage.
-- caching_sha2_password is selected explicitly; no cleartext password is in this script.
CREATE USER 'cf_admin_demo'@'localhost'
    IDENTIFIED WITH caching_sha2_password BY RANDOM PASSWORD;
CREATE USER 'cf_doctor_demo'@'localhost'
    IDENTIFIED WITH caching_sha2_password BY RANDOM PASSWORD;
CREATE USER 'cf_patient_demo'@'localhost'
    IDENTIFIED WITH caching_sha2_password BY RANDOM PASSWORD;
CREATE USER 'cf_reception_demo'@'localhost'
    IDENTIFIED WITH caching_sha2_password BY RANDOM PASSWORD;

GRANT 'cf_administrator' TO 'cf_admin_demo'@'localhost';
GRANT 'cf_doctor' TO 'cf_doctor_demo'@'localhost';
GRANT 'cf_patient' TO 'cf_patient_demo'@'localhost';
GRANT 'cf_receptionist' TO 'cf_reception_demo'@'localhost';
SET DEFAULT ROLE 'cf_administrator' TO 'cf_admin_demo'@'localhost';
SET DEFAULT ROLE 'cf_doctor' TO 'cf_doctor_demo'@'localhost';
SET DEFAULT ROLE 'cf_patient' TO 'cf_patient_demo'@'localhost';
SET DEFAULT ROLE 'cf_receptionist' TO 'cf_reception_demo'@'localhost';

INSERT INTO patient_account (login_name, patient_id)
VALUES ('cf_patient_demo', 'P001');

-- Evidence shows that password hashes exist, without disclosing passwords or hashes.
SELECT User, Host, plugin,
       (CHAR_LENGTH(authentication_string) > 0) AS password_hash_present
FROM mysql.user
WHERE User IN ('cf_admin_demo', 'cf_doctor_demo', 'cf_patient_demo', 'cf_reception_demo')
ORDER BY User;

SHOW GRANTS FOR 'cf_administrator';
SHOW GRANTS FOR 'cf_doctor';
SHOW GRANTS FOR 'cf_patient';
SHOW GRANTS FOR 'cf_receptionist';
