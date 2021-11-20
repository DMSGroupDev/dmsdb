-- Transaction start
BEGIN;

-- FUNCTION dms_domains_r
DROP FUNCTION IF EXISTS ${flyway:defaultSchema}.dms_domains_rf(integer, character varying, integer, boolean);

-- PROCEDURE dms_domains_d
DROP PROCEDURE IF EXISTS ${flyway:defaultSchema}.dms_domains_d(integer, character varying);

-- PROCEDURE dms_domains_u
DROP PROCEDURE IF EXISTS ${flyway:defaultSchema}.dms_domains_u(integer, character varying, integer, boolean);

-- PROCEDURE dms_domains_c
DROP PROCEDURE IF EXISTS ${flyway:defaultSchema}.dms_domains_c(character varying, integer, boolean);

-- TABLE dms_domains
DROP TABLE IF EXISTS ${flyway:defaultSchema}.dms_domains;  

-- Sequence
DROP SEQUENCE IF EXISTS ${flyway:defaultSchema}.dms_domains_id_seq;

-- Schema
DROP SCHEMA IF EXISTS ${flyway:defaultSchema} CASCADE;

-- Transation end
END;
