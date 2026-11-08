-- Run as root. This CREATE defines tests; CALL runs them on the SERVER in one session.
-- Workbench: open this file alone and choose Run Script (not Run Current Statement).
-- No application records are intentionally retained after tests.
USE crownfield_eye_hospital;
DROP PROCEDURE IF EXISTS run_coursework_validation;
DELIMITER $$
CREATE PROCEDURE run_coursework_validation()
BEGIN
    DECLARE test_id INT;
    DECLARE rejected BOOLEAN DEFAULT FALSE;
    DECLARE before_followups INT;
    DECLARE saved_due DATE;
    DECLARE saved_priority VARCHAR(20);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF EXISTS (SELECT 1 FROM clinic WHERE clinic_name = 'CF_TRANSACTION_TEST_ONLY') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existing transaction test marker found; inspect before retrying.';
    END IF;

    -- Trigger positive test and rollback: no client-side session gap is possible.
    START TRANSACTION;
    INSERT INTO appointment
        (patient_id, clinician_id, clinic_id, appointment_date, appointment_time, notes, status)
    VALUES ('P001', 9, 1, '2026-10-22', '14:00:00', 'Validation temporary appointment', 'Scheduled');
    SET test_id = LAST_INSERT_ID();
    SELECT 'trigger_before_completion' AS test_name,
        COUNT(*) AS actual, 0 AS expected FROM follow_up WHERE appointment_id = test_id;
    UPDATE appointment SET status = 'Completed' WHERE appointment_id = test_id;
    SELECT 'trigger_after_completion' AS test_name,
        COUNT(*) AS actual, 1 AS expected FROM follow_up
        WHERE appointment_id = test_id AND due_date = '2026-11-19'
          AND priority = 'Routine' AND status = 'Pending';
    UPDATE appointment SET notes = 'Validation repeat update' WHERE appointment_id = test_id;
    SELECT 'trigger_no_duplicate' AS test_name,
        COUNT(*) AS actual, 1 AS expected FROM follow_up WHERE appointment_id = test_id;
    ROLLBACK;
    SELECT 'rollback_appointment' AS test_name,
        COUNT(*) AS actual, 0 AS expected FROM appointment WHERE appointment_id = test_id;
    SELECT 'rollback_follow_up' AS test_name,
        COUNT(*) AS actual, 0 AS expected FROM follow_up WHERE appointment_id = test_id;

    -- Existing follow-up plan must survive the completion transition.
    START TRANSACTION;
    SELECT due_date, priority INTO saved_due, saved_priority FROM follow_up WHERE appointment_id = 1;
    SELECT COUNT(*) INTO before_followups FROM follow_up WHERE appointment_id = 1;
    UPDATE appointment SET status = 'Scheduled' WHERE appointment_id = 1;
    UPDATE appointment SET status = 'Completed' WHERE appointment_id = 1;
    SELECT 'existing_follow_up_preserved' AS test_name,
        COUNT(*) AS actual, before_followups AS expected FROM follow_up
        WHERE appointment_id = 1 AND due_date = saved_due AND priority = saved_priority;
    ROLLBACK;

    -- COMMIT, controlled UPDATE and DELETE with no clinical data modified.
    START TRANSACTION;
    INSERT INTO clinic (clinic_name, address)
        VALUES ('CF_TRANSACTION_TEST_ONLY', 'Initial test address');
    SET test_id = LAST_INSERT_ID();
    UPDATE clinic SET address = 'Updated test address' WHERE clinic_id = test_id;
    COMMIT;
    SELECT 'commit_and_controlled_update' AS test_name,
        COUNT(*) AS actual, 1 AS expected FROM clinic
        WHERE clinic_id = test_id AND address = 'Updated test address';
    START TRANSACTION;
    DELETE FROM clinic WHERE clinic_id = test_id AND clinic_name = 'CF_TRANSACTION_TEST_ONLY';
    COMMIT;
    SELECT 'controlled_delete_cleanup' AS test_name,
        COUNT(*) AS actual, 0 AS expected FROM clinic WHERE clinic_id = test_id;

    -- Negative integrity tests: only the expected MySQL error is handled.
    START TRANSACTION;
    SET rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR 1062 SET rejected = TRUE;
        INSERT INTO patient (patient_id, first_name, last_name, postcode)
        VALUES ('P001', 'Duplicate', 'Test', 'B1 1AA');
    END;
    SELECT 'duplicate_primary_key_rejected' AS test_name, rejected AS actual, 1 AS expected;
    ROLLBACK;

    START TRANSACTION;
    SET rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR 1452 SET rejected = TRUE;
        INSERT INTO appointment
            (patient_id, clinician_id, clinic_id, appointment_date, appointment_time)
        VALUES ('NO_PATIENT', 9, 1, '2026-10-22', '15:00:00');
    END;
    SELECT 'orphan_foreign_key_rejected' AS test_name, rejected AS actual, 1 AS expected;
    ROLLBACK;

    START TRANSACTION;
    SET rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR 1048 SET rejected = TRUE;
        INSERT INTO clinic (clinic_name) VALUES (NULL);
    END;
    SELECT 'required_value_rejected' AS test_name, rejected AS actual, 1 AS expected;
    ROLLBACK;

    START TRANSACTION;
    SET rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR 3819 SET rejected = TRUE;
        UPDATE appointment SET status = 'Invalid' WHERE appointment_id = 1;
    END;
    SELECT 'invalid_status_rejected' AS test_name, rejected AS actual, 1 AS expected;
    ROLLBACK;

    START TRANSACTION;
    SET rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR 3819 SET rejected = TRUE;
        UPDATE follow_up SET priority = 'Invalid' WHERE appointment_id = 1;
    END;
    SELECT 'invalid_priority_rejected' AS test_name, rejected AS actual, 1 AS expected;
    ROLLBACK;

    START TRANSACTION;
    SET rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR 3819 SET rejected = TRUE;
        UPDATE prescription_item SET duration_days = 0 WHERE prescription_id = 1 AND medicine_id = 1;
    END;
    SELECT 'nonpositive_duration_rejected' AS test_name, rejected AS actual, 1 AS expected;
    ROLLBACK;
END$$
DELIMITER ;

CALL run_coursework_validation();
CALL get_patient_appointments('P001');
CALL get_patient_appointments('P010');
CALL get_patient_appointments('NO_PATIENT');
-- Last call should return zero appointments; it must not leak another patient's data.

SELECT 'speciality' AS table_name, COUNT(*) AS row_count FROM speciality
UNION ALL SELECT 'patient', COUNT(*) FROM patient
UNION ALL SELECT 'clinician', COUNT(*) FROM clinician
UNION ALL SELECT 'clinic', COUNT(*) FROM clinic
UNION ALL SELECT 'appointment', COUNT(*) FROM appointment
UNION ALL SELECT 'diagnosis', COUNT(*) FROM diagnosis
UNION ALL SELECT 'medicine', COUNT(*) FROM medicine
UNION ALL SELECT 'prescription', COUNT(*) FROM prescription
UNION ALL SELECT 'prescription_item', COUNT(*) FROM prescription_item
UNION ALL SELECT 'follow_up', COUNT(*) FROM follow_up;
