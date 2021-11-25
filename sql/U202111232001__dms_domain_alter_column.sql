-- Change column type. !!!! Will reset all data in column admin_id !!!

-- Transaction start
BEGIN;

-- Alter columns
ALTER TABLE ${flyway:defaultSchema}.dms_domains ALTER COLUMN admin_id SET DATA TYPE int USING (random());
ALTER TABLE ${flyway:defaultSchema}.dms_domains RENAME COLUMN admin_uuid TO admin_id;

-- Transaction end
END;