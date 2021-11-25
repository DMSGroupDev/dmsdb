-- Change column type. !!!! Will reset all data in column admin_id !!!

-- Transaction start
BEGIN;

-- Alter columns
ALTER TABLE ${flyway:defaultSchema}.dms_domains RENAME COLUMN admin_id TO admin_uuid;

-- Transaction end
END;