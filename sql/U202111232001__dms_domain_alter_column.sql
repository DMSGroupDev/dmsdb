-- Change column type. !!!! Will reset all data in column admin_id !!!
ALTER TABLE pokus.dms_domains ALTER COLUMN admin_id SET DATA TYPE int USING (random());