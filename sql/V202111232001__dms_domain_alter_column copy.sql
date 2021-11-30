-- Change column type. !!!! Will reset all data in column admin_id !!!

-- Transaction start
BEGIN;
ALTER TABLE ${flyway:defaultSchema}.dms_domains ALTER COLUMN admin_id SET DATA TYPE uuid USING ('00000000-0000-0000-0000-000000000000');

-- Transaction end
END;