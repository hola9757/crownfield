-- Crownfield Appendix 1: only the five source rows supplied on 8 November.
-- Run in the existing database as root after saving a backup.
-- Existing synthetic records are retained. Reruns recognise imported source rows.
USE crownfield_eye_hospital;

-- The source gives no dose, route, frequency or treatment duration.
-- This DDL commits separately from the import transaction. Existing values remain.
-- The existing CHECK (duration_days > 0) continues to reject zero/negative values.
ALTER TABLE prescription_item
    MODIFY dose VARCHAR(50) NULL,
    MODIFY route VARCHAR(30) NULL,
    MODIFY frequency VARCHAR(50) NULL,
    MODIFY duration_days INT NULL;

-- Preserve the source text and link every imported row to its appointment.
CREATE TABLE IF NOT EXISTS appendix1_source (
    source_row SMALLINT PRIMARY KEY,
    patient_id VARCHAR(10) NOT NULL,
    patient_name VARCHAR(101) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    clinician_name VARCHAR(110) NOT NULL,
    speciality_name VARCHAR(60) NOT NULL,
    clinic_name VARCHAR(80) NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    diagnosis_name VARCHAR(100) NOT NULL,
    medicines_text VARCHAR(255) NOT NULL,
    follow_up_text VARCHAR(80) NOT NULL,
    source_notes VARCHAR(255) NOT NULL,
    appointment_id INT UNIQUE,
    CONSTRAINT fk_appendix1_appointment FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id)
);

DROP PROCEDURE IF EXISTS import_appendix1_first5_20261108;
DELIMITER $$
CREATE PROCEDURE import_appendix1_first5_20261108()
BEGIN
    DECLARE finished INT DEFAULT 0;
    DECLARE sr SMALLINT;
    DECLARE pid VARCHAR(10);
    DECLARE pname VARCHAR(101);
    DECLARE pc VARCHAR(10);
    DECLARE cname VARCHAR(110);
    DECLARE spname VARCHAR(60);
    DECLARE clname VARCHAR(80);
    DECLARE ad DATE;
    DECLARE atime TIME;
    DECLARE dname VARCHAR(100);
    DECLARE meds VARCHAR(255);
    DECLARE followtext VARCHAR(80);
    DECLARE ntext VARCHAR(255);
    DECLARE aid INT;
    DECLARE sid INT;
    DECLARE cid INT;
    DECLARE locid INT;
    DECLARE rxid INT;
    DECLARE mid INT;
    DECLARE medname VARCHAR(100);
    DECLARE remaining_meds VARCHAR(255);
    DECLARE cf VARCHAR(50);
    DECLARE cl VARCHAR(50);
    DECLARE n INT;
    DECLARE weeks_count INT;
    DECLARE fpriority VARCHAR(20);
    DECLARE source_cursor CURSOR FOR
        SELECT source_row, patient_id, patient_name, postcode, clinician_name,
               speciality_name, clinic_name, appointment_date, appointment_time,
               diagnosis_name, medicines_text, follow_up_text, source_notes,
               appointment_id
        FROM appendix1_source WHERE source_row BETWEEN 1 AND 5 ORDER BY source_row;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    DROP TEMPORARY TABLE IF EXISTS appendix1_incoming;
    CREATE TEMPORARY TABLE appendix1_incoming LIKE appendix1_source;
    INSERT INTO appendix1_incoming
        (source_row, patient_id, patient_name, postcode, clinician_name,
         speciality_name, clinic_name, appointment_date, appointment_time,
         diagnosis_name, medicines_text, follow_up_text, source_notes)
    VALUES
    (1,'OP001','Amina Yusuf','NE1 4AB','Dr Maya Shah','Glaucoma','City Road',
     '2026-10-05','09:00:00','Ocular hypertension','Latanoprost | Timolol',
     '6 weeks | High','Review IOP'),
    (2,'OP002','Daniel Reed','N16 7QP','Dr Leo Grant','Retina','City Road',
     '2026-10-05','09:30:00','Diabetic macular oedema','Aflibercept',
     '4 weeks | Urgent','OCT before review'),
    (3,'OP001','Amina Yusuf','NE1 4AB','Dr Maya Shah','Glaucoma','Bedford',
     '2026-11-16','10:15:00','Ocular hypertension','Latanoprost',
     '12 weeks | Routine','Visual field test'),
    (4,'OP003','Sofia Bennett','E8 2LD','Dr Maya Shah','Glaucoma','City Road',
     '2026-10-06','11:00:00','Glaucoma suspect','None',
     '26 weeks | Routine','Monitor'),
    (5,'OP004','Michael Okoro','SE6 3RT','Dr Priya Nair','Cornea','Croydon',
     '2026-10-07','14:00:00','Keratoconus','Sodium chloride drops',
     '8 weeks | Routine','Corneal topography');

    IF EXISTS (
        SELECT 1 FROM appendix1_source s JOIN appendix1_incoming i USING (source_row)
        WHERE NOT (s.patient_id <=> i.patient_id)
           OR NOT (s.patient_name <=> i.patient_name)
           OR NOT (s.postcode <=> i.postcode)
           OR NOT (s.clinician_name <=> i.clinician_name)
           OR NOT (s.speciality_name <=> i.speciality_name)
           OR NOT (s.clinic_name <=> i.clinic_name)
           OR NOT (s.appointment_date <=> i.appointment_date)
           OR NOT (s.appointment_time <=> i.appointment_time)
           OR NOT (s.diagnosis_name <=> i.diagnosis_name)
           OR NOT (s.medicines_text <=> i.medicines_text)
           OR NOT (s.follow_up_text <=> i.follow_up_text)
           OR NOT (s.source_notes <=> i.source_notes)
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Existing Appendix source row differs: review before importing';
    END IF;

    INSERT INTO appendix1_source
        (source_row, patient_id, patient_name, postcode, clinician_name,
         speciality_name, clinic_name, appointment_date, appointment_time,
         diagnosis_name, medicines_text, follow_up_text, source_notes)
    SELECT i.source_row, i.patient_id, i.patient_name, i.postcode, i.clinician_name,
           i.speciality_name, i.clinic_name, i.appointment_date, i.appointment_time,
           i.diagnosis_name, i.medicines_text, i.follow_up_text, i.source_notes
    FROM appendix1_incoming i
    WHERE NOT EXISTS (SELECT 1 FROM appendix1_source s WHERE s.source_row=i.source_row);

    OPEN source_cursor;
    source_loop: LOOP
        FETCH source_cursor INTO sr,pid,pname,pc,cname,spname,clname,ad,atime,
                                 dname,meds,followtext,ntext,aid;
        IF finished = 1 THEN LEAVE source_loop; END IF;
        IF aid IS NOT NULL THEN ITERATE source_loop; END IF;

        SELECT COUNT(*) INTO n FROM patient WHERE patient_id=pid;
        IF n=0 THEN
            INSERT INTO patient(patient_id,first_name,last_name,postcode)
            VALUES(pid,SUBSTRING_INDEX(pname,' ',1),SUBSTRING_INDEX(pname,' ',-1),pc);
        ELSEIF EXISTS (
            SELECT 1 FROM patient WHERE patient_id=pid
            AND (first_name<>SUBSTRING_INDEX(pname,' ',1)
              OR last_name<>SUBSTRING_INDEX(pname,' ',-1) OR postcode<>pc)
        ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Existing original patient differs: no overwrite performed';
        END IF;

        INSERT INTO speciality(speciality_name)
        SELECT spname WHERE NOT EXISTS
            (SELECT 1 FROM speciality WHERE speciality_name=spname);
        SELECT speciality_id INTO sid FROM speciality WHERE speciality_name=spname;
        SET cf=SUBSTRING_INDEX(SUBSTRING(cname,4),' ',1);
        SET cl=SUBSTRING_INDEX(cname,' ',-1);
        SELECT COUNT(*) INTO n FROM clinician WHERE first_name=cf AND last_name=cl;
        IF n>1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Ambiguous clinician name: import rolled back';
        ELSEIF n=0 THEN
            INSERT INTO clinician(first_name,last_name,speciality_id) VALUES(cf,cl,sid);
        ELSEIF EXISTS (
            SELECT 1 FROM clinician WHERE first_name=cf AND last_name=cl AND speciality_id<>sid
        ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Clinician speciality conflicts: import rolled back';
        END IF;
        SELECT clinician_id INTO cid FROM clinician WHERE first_name=cf AND last_name=cl;
        INSERT INTO clinic(clinic_name)
        SELECT clname WHERE NOT EXISTS (SELECT 1 FROM clinic WHERE clinic_name=clname);
        SELECT clinic_id INTO locid FROM clinic WHERE clinic_name=clname;

        -- Reject an untracked matching appointment rather than silently duplicate it.
        IF EXISTS (SELECT 1 FROM appointment WHERE patient_id=pid AND clinician_id=cid
                   AND clinic_id=locid AND appointment_date=ad AND appointment_time=atime) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Matching untracked appointment exists: review before importing';
        END IF;
        -- Status is absent from Appendix 1: retain the documented Scheduled default.
        INSERT INTO appointment(patient_id,clinician_id,clinic_id,appointment_date,
                                appointment_time,notes)
        VALUES(pid,cid,locid,ad,atime,ntext);
        SET aid=LAST_INSERT_ID();
        INSERT INTO diagnosis(appointment_id,diagnosis_name) VALUES(aid,dname);

        IF meds<>'None' THEN
            -- Source assumption: prescription date equals its appointment date.
            INSERT INTO prescription(appointment_id,prescription_date) VALUES(aid,ad);
            SET rxid=LAST_INSERT_ID();
            SET remaining_meds=meds;
            medicine_loop: LOOP
                SET medname=TRIM(SUBSTRING_INDEX(remaining_meds,'|',1));
                INSERT INTO medicine(medicine_name)
                SELECT medname WHERE NOT EXISTS
                    (SELECT 1 FROM medicine WHERE medicine_name=medname);
                SELECT medicine_id INTO mid FROM medicine WHERE medicine_name=medname;
                INSERT INTO prescription_item
                    (prescription_id,medicine_id,dose,route,frequency,duration_days)
                VALUES(rxid,mid,NULL,NULL,NULL,NULL);
                IF LOCATE('|',remaining_meds)=0 THEN LEAVE medicine_loop; END IF;
                SET remaining_meds=SUBSTRING(remaining_meds,LOCATE('|',remaining_meds)+1);
            END LOOP;
        END IF;
        SET weeks_count=CAST(SUBSTRING_INDEX(TRIM(followtext),' ',1) AS UNSIGNED);
        SET fpriority=TRIM(SUBSTRING_INDEX(followtext,'|',-1));
        -- Source assumption: each interval starts on the appointment date.
        INSERT INTO follow_up(appointment_id,due_date,priority)
        VALUES(aid,DATE_ADD(ad,INTERVAL weeks_count WEEK),fpriority);
        UPDATE appendix1_source SET appointment_id=aid WHERE source_row=sr;
    END LOOP;
    CLOSE source_cursor;
    DROP TEMPORARY TABLE appendix1_incoming;

    SELECT COUNT(*) INTO n FROM appendix1_source
        WHERE source_row BETWEEN 1 AND 5 AND appointment_id IS NOT NULL;
    IF n<>5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Source mapping count failed: import rolled back';
    END IF;
    COMMIT;
END$$
DELIMITER ;

CALL import_appendix1_first5_20261108();
-- Removes only this one-use helper, not any clinical table or record.
DROP PROCEDURE import_appendix1_first5_20261108;

-- Verification: source rows 5, patients 4, diagnoses 5, prescriptions 4,
-- prescription items 5, follow-ups 5. These describe this source subset only.
SELECT COUNT(*) AS source_rows, COUNT(DISTINCT patient_id) AS original_patients,
       COUNT(appointment_id) AS imported_appointments
FROM appendix1_source WHERE source_row BETWEEN 1 AND 5;
SELECT s.source_row,a.appointment_id,a.patient_id,a.appointment_date,a.appointment_time,
       c.first_name,c.last_name,l.clinic_name,f.due_date,f.priority
FROM appendix1_source s
JOIN appointment a ON a.appointment_id=s.appointment_id
JOIN clinician c ON c.clinician_id=a.clinician_id
JOIN clinic l ON l.clinic_id=a.clinic_id
JOIN follow_up f ON f.appointment_id=a.appointment_id
WHERE s.source_row BETWEEN 1 AND 5 ORDER BY s.source_row;
SELECT 'diagnoses' AS item, COUNT(*) AS source_count
FROM diagnosis d JOIN appendix1_source s ON s.appointment_id=d.appointment_id
WHERE s.source_row BETWEEN 1 AND 5
UNION ALL
SELECT 'prescriptions',COUNT(*) FROM prescription p JOIN appendix1_source s
 ON s.appointment_id=p.appointment_id WHERE s.source_row BETWEEN 1 AND 5
UNION ALL
SELECT 'prescription_items',COUNT(*) FROM prescription_item i
 JOIN prescription p ON p.prescription_id=i.prescription_id
 JOIN appendix1_source s ON s.appointment_id=p.appointment_id WHERE s.source_row BETWEEN 1 AND 5
UNION ALL
SELECT 'follow_ups',COUNT(*) FROM follow_up f JOIN appendix1_source s
 ON s.appointment_id=f.appointment_id WHERE s.source_row BETWEEN 1 AND 5;
