-- Change column type. !!!! Will reset all data in column admin_id !!!

-- Transaction start
BEGIN;

-- Alter columns
ALTER TABLE ${flyway:defaultSchema}.dms_domains DROP COLUMN IF EXISTS admin_uuid;

-- Transaction end
END;