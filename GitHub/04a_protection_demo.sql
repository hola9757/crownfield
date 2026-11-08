-- Optional second protection demonstration: sensitive email values encrypted in a
-- temporary table. It does NOT remove/encrypt the original patient.email field.
-- Run the ENTIRE file as one script in one session, as root. No permanent data changes.
USE crownfield_eye_hospital;
SET @previous_mode = @@session.block_encryption_mode;
SET SESSION block_encryption_mode = 'aes-256-cbc';
SET @demo_key = RANDOM_BYTES(32);
DROP TEMPORARY TABLE IF EXISTS cf_encrypted_contact_demo;
CREATE TEMPORARY TABLE cf_encrypted_contact_demo (
    patient_id VARCHAR(10) PRIMARY KEY,
    iv BINARY(16) NOT NULL,
    encrypted_email VARBINARY(512)
) ENGINE=InnoDB;
INSERT INTO cf_encrypted_contact_demo (patient_id, iv)
SELECT patient_id, RANDOM_BYTES(16) FROM patient;
UPDATE cf_encrypted_contact_demo AS d
INNER JOIN patient AS p ON p.patient_id = d.patient_id
SET d.encrypted_email = AES_ENCRYPT(p.email, @demo_key, d.iv);
SELECT d.patient_id, HEX(d.encrypted_email) AS ciphertext,
       (CAST(AES_DECRYPT(d.encrypted_email, @demo_key, d.iv) AS CHAR)
            <=> p.email) AS decryption_matches
FROM cf_encrypted_contact_demo AS d
INNER JOIN patient AS p ON p.patient_id = d.patient_id
ORDER BY d.patient_id;
DROP TEMPORARY TABLE cf_encrypted_contact_demo;
SET @demo_key = NULL;
SET SESSION block_encryption_mode = @previous_mode;
SET @previous_mode = NULL;
