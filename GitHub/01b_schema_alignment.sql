-- Reconcile the earlier live clinician surname UNIQUE index with the supplied schema.
-- Run as root. Removes only single-column UNIQUE indexes on last_name.
-- Does not remove the primary key, email uniqueness, or composite indexes.
USE crownfield_eye_hospital;
DROP PROCEDURE IF EXISTS align_clinician_surname;
DELIMITER $$
CREATE PROCEDURE align_clinician_surname()
BEGIN
    DECLARE index_to_remove VARCHAR(64);
    surname_indexes: LOOP
        SELECT MIN(index_name) INTO index_to_remove
        FROM (
            SELECT index_name
            FROM information_schema.statistics
            WHERE table_schema = 'crownfield_eye_hospital'
              AND table_name = 'clinician' AND non_unique = 0
              AND index_name <> 'PRIMARY'
            GROUP BY index_name
            HAVING COUNT(*) = 1 AND MAX(column_name) = 'last_name'
        ) AS surname_only;
        IF index_to_remove IS NULL THEN
            LEAVE surname_indexes;
        END IF;
        SET @alignment_sql = CONCAT('ALTER TABLE crownfield_eye_hospital.clinician DROP INDEX `',
                                    REPLACE(index_to_remove, '`', '``'), '`');
        PREPARE alignment_stmt FROM @alignment_sql;
        EXECUTE alignment_stmt;
        DEALLOCATE PREPARE alignment_stmt;
    END LOOP;
    SET @alignment_sql = NULL;
END$$
DELIMITER ;
CALL align_clinician_surname();
DROP PROCEDURE align_clinician_surname;
SHOW INDEX FROM crownfield_eye_hospital.clinician;
