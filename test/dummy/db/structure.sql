--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: frecuencia; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE frecuencia AS ENUM (
    'inmediata',
    'diaria',
    'semanal'
);


--
-- Name: procedencia; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE procedencia AS ENUM (
    'todos',
    'blogs',
    'foros',
    'vídeos'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: suscribir_newsletters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE suscribir_newsletters (
    id integer NOT NULL,
    nombre character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    suscripciones_count integer DEFAULT 0
);


--
-- Name: suscribir_newsletters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE suscribir_newsletters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suscribir_newsletters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE suscribir_newsletters_id_seq OWNED BY suscribir_newsletters.id;


--
-- Name: suscribir_suscripciones; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE suscribir_suscripciones (
    id integer NOT NULL,
    suscribible_id integer NOT NULL,
    suscribible_type character varying NOT NULL,
    dominio_de_alta character varying DEFAULT 'es'::character varying NOT NULL,
    suscriptor_id integer,
    suscriptor_type character varying,
    email character varying NOT NULL,
    nombre_apellidos character varying,
    cod_postal character varying,
    provincia_id integer,
    activo boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    contacto_id integer,
    procedencia procedencia DEFAULT 'todos'::procedencia,
    frecuencia frecuencia DEFAULT 'inmediata'::frecuencia,
    mejores boolean DEFAULT false
);


--
-- Name: suscribir_suscripciones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE suscribir_suscripciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suscribir_suscripciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE suscribir_suscripciones_id_seq OWNED BY suscribir_suscripciones.id;


--
-- Name: tematicas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tematicas (
    id integer NOT NULL,
    nombre character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    suscripciones_count integer DEFAULT 0
);


--
-- Name: tematicas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tematicas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tematicas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tematicas_id_seq OWNED BY tematicas.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE usuarios (
    id integer NOT NULL,
    nombre character varying,
    apellidos character varying,
    email character varying,
    cod_postal character varying,
    provincia_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    suscripciones_count integer DEFAULT 0
);


--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE usuarios_id_seq OWNED BY usuarios.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY suscribir_newsletters ALTER COLUMN id SET DEFAULT nextval('suscribir_newsletters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY suscribir_suscripciones ALTER COLUMN id SET DEFAULT nextval('suscribir_suscripciones_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tematicas ALTER COLUMN id SET DEFAULT nextval('tematicas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY usuarios ALTER COLUMN id SET DEFAULT nextval('usuarios_id_seq'::regclass);


--
-- Name: suscribir_newsletters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY suscribir_newsletters
    ADD CONSTRAINT suscribir_newsletters_pkey PRIMARY KEY (id);


--
-- Name: suscribir_suscripciones_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY suscribir_suscripciones
    ADD CONSTRAINT suscribir_suscripciones_pkey PRIMARY KEY (id);


--
-- Name: tematicas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tematicas
    ADD CONSTRAINT tematicas_pkey PRIMARY KEY (id);


--
-- Name: usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: index_suscribir_newsletters_on_suscripciones_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_suscribir_newsletters_on_suscripciones_count ON suscribir_newsletters USING btree (suscripciones_count);


--
-- Name: index_suscribir_suscripciones_on_contacto_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_suscribir_suscripciones_on_contacto_id ON suscribir_suscripciones USING btree (contacto_id);


--
-- Name: index_suscribir_suscripciones_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_suscribir_suscripciones_on_email ON suscribir_suscripciones USING btree (email);


--
-- Name: index_tematicas_on_suscripciones_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tematicas_on_suscripciones_count ON tematicas USING btree (suscripciones_count);


--
-- Name: index_usuarios_on_suscripciones_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_usuarios_on_suscripciones_count ON usuarios USING btree (suscripciones_count);


--
-- Name: ix_suscripciones_on_activo_and_suscribible_and_dominio; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_suscripciones_on_activo_and_suscribible_and_dominio ON suscribir_suscripciones USING btree (activo, suscribible_type, suscribible_id, dominio_de_alta);


--
-- Name: ix_suscripciones_on_provincia_activo_suscribible_and_dominio; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_suscripciones_on_provincia_activo_suscribible_and_dominio ON suscribir_suscripciones USING btree (provincia_id, activo, suscribible_type, suscribible_id, dominio_de_alta);


--
-- Name: ix_suscripciones_on_suscribible_and_dominio_and_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX ix_suscripciones_on_suscribible_and_dominio_and_email ON suscribir_suscripciones USING btree (suscribible_type, suscribible_id, dominio_de_alta, email);


--
-- Name: ix_suscripciones_on_suscriptor_and_activo; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_suscripciones_on_suscriptor_and_activo ON suscribir_suscripciones USING btree (suscriptor_type, suscriptor_id, activo);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140219153752');

INSERT INTO schema_migrations (version) VALUES ('20140219181927');

INSERT INTO schema_migrations (version) VALUES ('20140219182744');

INSERT INTO schema_migrations (version) VALUES ('20140224125451');

INSERT INTO schema_migrations (version) VALUES ('20140704103922');

INSERT INTO schema_migrations (version) VALUES ('20150429090008');

INSERT INTO schema_migrations (version) VALUES ('20150611074514');

INSERT INTO schema_migrations (version) VALUES ('20150612082604');

INSERT INTO schema_migrations (version) VALUES ('20150612082804');

INSERT INTO schema_migrations (version) VALUES ('20150722105712');

