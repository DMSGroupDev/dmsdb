-- Transaction start
BEGIN;

-- PROCEDURE dms_domains_c

CREATE OR REPLACE PROCEDURE ${flyway:defaultSchema}.dms_domains_c(
	i_domain_name character varying DEFAULT NULL::character varying,
	i_admin_id integer DEFAULT NULL::integer,
	i_active boolean DEFAULT true)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
  v_exists INTEGER;
BEGIN
  SELECT count(domain_name) INTO v_exists FROM ${flyway:defaultSchema}.dms_domains WHERE domain_name = LOWER(i_domain_name);
  IF v_exists >= 1 THEN
    RAISE NOTICE 'Domain name must be uniq.';
    RETURN;
  ELSIF i_domain_name = '' OR i_domain_name IS NULL THEN
    RAISE NOTICE 'Domain name can not be empty.';
    RETURN;
  ELSIF i_admin_id < 1 OR i_admin_id IS NULL THEN
    RAISE NOTICE 'Administrator ID can not be empty.';
    RETURN;
  ELSE  
    INSERT INTO ${flyway:defaultSchema}.dms_domains (domain_name, admin_id, active) VALUES (LOWER(i_domain_name),i_admin_id, i_active);
    RETURN;
  END IF;
--EXCEPTION WHEN OTHERS THEN
--  RAISE EXCEPTION 'An unspecified error occured in procedure.';
END;
$BODY$;

-- PROCEDURE dms_domains_u

CREATE OR REPLACE PROCEDURE ${flyway:defaultSchema}.dms_domains_u(
	i_domain_id integer,
	i_domain_name character varying DEFAULT NULL::character varying,
	i_admin_id integer DEFAULT NULL::integer,
	i_active boolean DEFAULT NULL::boolean)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
  v_sql text := 'UPDATE ${flyway:defaultSchema}.dms_domains SET';
  v_exists INTEGER;
  v_current_domain varchar(50);
  v_first_change boolean := true;
BEGIN
  IF i_domain_id IS NOT NULL AND i_domain_name IS NULL and i_admin_id IS NULL and i_active IS NULL THEN
    RAISE WARNING 'It is necessary to provide data for the procedure';
    RETURN;
  END IF;
  SELECT count(domain_name) INTO v_exists FROM ${flyway:defaultSchema}.dms_domains WHERE domain_name = LOWER(i_domain_name);
  SELECT domain_name INTO v_current_domain FROM ${flyway:defaultSchema}.dms_domains WHERE id = i_domain_id;

  IF i_domain_name IS NOT NULL AND v_exists = 0 AND v_current_domain <> lower(i_domain_name) THEN
    v_sql := v_sql || ' domain_name = LOWER($2)';
    v_first_change := false;
  END IF;

  IF i_admin_id IS NOT NULL AND i_admin_id > 0 THEN
	IF v_first_change = false THEN
      v_sql := v_sql || ', ' ;
    END IF;
    v_sql := v_sql || ' admin_id = $3';
    v_first_change := false;
  END IF;

  IF i_active IS NOT NULL THEN
	IF v_first_change = false THEN
      v_sql := v_sql || ', ';
    END IF;
    v_sql := v_sql || ' active = $4';
    v_first_change := false;
  END IF;

  IF i_domain_id > 0 THEN
    v_sql := v_sql || ' WHERE id= $1';
    RAISE NOTICE 'SQL: %', v_sql;
    EXECUTE v_sql USING i_domain_id, i_domain_name, i_admin_id, i_active;
  ELSEIF i_domain_id IS NOT NULL THEN
    RAISE NOTICE 'Domain ID can not be negative.';
    RETURN;
  END IF;

EXCEPTION WHEN OTHERS THEN
  RAISE EXCEPTION 'An unspecified error occured in procedure.';
END;
$BODY$;


-- PROCEDURE dms_domains_d

CREATE OR REPLACE PROCEDURE ${flyway:defaultSchema}.dms_domains_d(
	i_domain_id integer,
	i_domain_name character varying)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
  v_sql text := 'DELETE FROM ${flyway:defaultSchema}.dms_domains WHERE id = $1 and domain_name = $2';
BEGIN
  IF i_domain_id IS NOT NULL AND i_domain_name IS NOT NULL AND i_domain_id > 0 THEN
	EXECUTE v_sql USING i_domain_id, LOWER(i_domain_name);
  ELSE
    RAISE WARNING 'Domain ID and Domain name is necessary to delete the domain.';
    RETURN;
  END IF;
END;
$BODY$;

-- FUNCTION dms_domains_r

CREATE OR REPLACE FUNCTION ${flyway:defaultSchema}.dms_domains_r(
	i_domain_id integer DEFAULT NULL::integer,
	i_domain_name character varying DEFAULT NULL::character varying,
	i_admin_id integer DEFAULT NULL::integer,
	i_active boolean DEFAULT NULL::boolean)
    RETURNS TABLE(id integer, domain_name character varying, admin_id integer, active boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
DECLARE
  v_conditions boolean := false;
  v_sql text := 'SELECT id, domain_name, admin_id, active FROM ${flyway:defaultSchema}.dms_domains';
BEGIN
  IF i_domain_id > 0 THEN
    v_conditions := true;
    v_sql := v_sql || ' WHERE id= $1';
  ELSEIF i_domain_id IS NOT NULL THEN
    RAISE NOTICE 'Domain ID can not be negative.';
    RETURN;
  END IF;
RAISE NOTICE 'SQL: %', i_admin_id;
  IF i_domain_name IS NOT NULL THEN
    IF v_conditions = false THEN
      v_conditions := true;
      v_sql := v_sql || ' WHERE domain_name LIKE $2';
	ELSE
	  v_sql := v_sql || ' AND domain_name LIKE $2';
	END IF;
  END IF;

  IF i_admin_id IS NOT NULL THEN
    IF v_conditions = false THEN
      v_conditions := true;
      v_sql := v_sql || ' WHERE admin_id = $3';
	ELSE
	  v_sql := v_sql || ' AND admin_id = $3';
	END IF;
  ELSEIF i_admin_id IS NOT NULL THEN
    RAISE NOTICE 'Admin ID can not be negative.';
    RETURN;
  END IF;

  IF i_active IS NOT NULL THEN
    IF v_conditions = false THEN
      v_conditions := true;
      v_sql := v_sql || ' WHERE active = $4';
	ELSE
	  v_sql := v_sql || ' AND active = $4';
	END IF;
  END IF;

  RAISE NOTICE 'SQL: %', v_sql;
  RETURN QUERY EXECUTE v_sql USING i_domain_id, i_domain_name, i_admin_id, i_active;
EXCEPTION WHEN OTHERS THEN
  RAISE EXCEPTION 'An unspecified error occured in procedure.';
END;

END;
$BODY$;

-- Transaction end
COMMIT;
