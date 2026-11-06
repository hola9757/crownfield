-- MySQL 8.0.16+; run once in an EMPTY database/environment.
-- No DROP statements: existing tables/data are not deleted.
CREATE DATABASE crownfield_eye_hospital;
USE crownfield_eye_hospital;





-- SPECIALITY TABLE

CREATE TABLE speciality (
    speciality_id INT AUTO_INCREMENT PRIMARY KEY,
    speciality_name VARCHAR(60) NOT NULL UNIQUE
);


-- PATIENT TABLE

CREATE TABLE patient (
    patient_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    date_of_birth DATE,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- CLINICIAN TABLE

CREATE TABLE clinician (
    clinician_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    speciality_id INT NOT NULL,
    email VARCHAR(100) UNIQUE,

    CONSTRAINT fk_clinician_speciality
        FOREIGN KEY (speciality_id)
        REFERENCES speciality(speciality_id)
);


-- CLINIC TABLE

CREATE TABLE clinic (
    clinic_id INT AUTO_INCREMENT PRIMARY KEY,
    clinic_name VARCHAR(80) NOT NULL UNIQUE,
    address VARCHAR(150)
);


-- APPOINTMENT TABLE

CREATE TABLE appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(10) NOT NULL,
    clinician_id INT NOT NULL,
    clinic_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    notes VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',

    CONSTRAINT chk_appointment_status
        CHECK (status IN (
            'Scheduled',
            'Completed',
            'Cancelled',
            'Did Not Attend'
        )),

        FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id),

    
        FOREIGN KEY (clinician_id)
        REFERENCES clinician(clinician_id),

    
        FOREIGN KEY (clinic_id)
        REFERENCES clinic(clinic_id)
);

-- DIAGNOSIS TABLE
-- One appointment can have zero or many diagnoses

CREATE TABLE diagnosis (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    diagnosis_name VARCHAR(100) NOT NULL,
    diagnosis_notes VARCHAR(255),

   
        FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id)
        ON DELETE CASCADE
);


-- 7. MEDICINE TABLE

CREATE TABLE medicine (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_name VARCHAR(100) NOT NULL UNIQUE
);


-- 8. PRESCRIPTION TABLE

CREATE TABLE prescription (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    prescription_date DATE NOT NULL,

   
        FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id)
        ON DELETE CASCADE
);

-- 9. PRESCRIPTION ITEM TABLE
-- Associative table between prescription and medicine

CREATE TABLE prescription_item (
    prescription_id INT NOT NULL,
    medicine_id INT NOT NULL,
    dose VARCHAR(50) NOT NULL,
    route VARCHAR(30) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration_days INT NOT NULL,

    PRIMARY KEY (prescription_id, medicine_id),

   
        CHECK (duration_days > 0),

    
        FOREIGN KEY (prescription_id)
        REFERENCES prescription(prescription_id)
        ON DELETE CASCADE,

    
        FOREIGN KEY (medicine_id)
        REFERENCES medicine(medicine_id)
);


-- FOLLOW-UP TABLE

CREATE TABLE follow_up (
    follow_up_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    due_date DATE NOT NULL,
    priority VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',

   
        CHECK (priority IN ('Routine', 'High', 'Urgent')),

    
        FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id)
        ON DELETE CASCADE
);
