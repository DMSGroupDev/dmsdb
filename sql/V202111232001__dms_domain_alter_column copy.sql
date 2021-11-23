-- Change column type. !!!! Will reset all data in column admin_id !!!

-- Transaction start
BEGIN;

-- Alter columns
ALTER TABLE ${flyway:defaultSchema}.dms_domains ALTER COLUMN admin_id SET DATA TYPE uuid USING (uuid_generate_v4());

-- Transaction end
END;