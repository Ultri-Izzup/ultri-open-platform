--
-- PostgreSQL database dump
--

-- Dumped from database version 14.6 (Debian 14.6-1.pgdg110+1)
-- Dumped by pg_dump version 14.7 (Ubuntu 14.7-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: izzup_api; Type: SCHEMA; Schema: -; Owner: izzup_api
--

CREATE SCHEMA izzup_api;


ALTER SCHEMA izzup_api OWNER TO izzup_api;

--
-- Name: auth_level; Type: TYPE; Schema: izzup_api; Owner: izzup_api
--

CREATE TYPE izzup_api.auth_level AS ENUM (
    'public',
    'member',
    'account',
    'role',
    'account_role',
    'application'
);


ALTER TYPE izzup_api.auth_level OWNER TO izzup_api;

--
-- Name: role; Type: TYPE; Schema: izzup_api; Owner: izzup_api
--

CREATE TYPE izzup_api.role AS ENUM (
    'owner',
    'billing',
    'admin',
    'author',
    'editor',
    'reader',
    'advisor',
    'moderator',
    'messaging',
    'responder',
    'reaction',
    'mailer',
    'marketing',
    'support'
);


ALTER TYPE izzup_api.role OWNER TO izzup_api;

--
-- Name: create_api_account(); Type: FUNCTION; Schema: izzup_api; Owner: izzup_api
--

CREATE FUNCTION izzup_api.create_api_account() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

	DECLARE new_account_id BIGINT;
	
BEGIN

	
	INSERT INTO izzup_api.account(name)
		 VALUES('Izzup Member Account for ' || NEW.user_id )
		 RETURNING id INTO new_account_id;
		
	INSERT INTO izzup_api.account_member(account_id, member_uid, roles)
		 VALUES(new_account_id, uuid(NEW.user_id), '{"owner"}');

	RETURN NEW;
END;
$$;


ALTER FUNCTION izzup_api.create_api_account() OWNER TO izzup_api;

--
-- Name: create_member_account(); Type: FUNCTION; Schema: izzup_api; Owner: izzup_api
--

CREATE FUNCTION izzup_api.create_member_account() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

	DECLARE new_account_id BIGINT;
	
BEGIN


	
	INSERT INTO izzup_api.account(name)
		 VALUES('Izzup Member Account')
		 RETURNING id INTO new_account_id;
		
	INSERT INTO izzup_api.account_member(account_id, member_id, roles)
		 VALUES(new_account_id, NEW.id, '{"owner"}');

	RETURN NEW;
END;
$$;


ALTER FUNCTION izzup_api.create_member_account() OWNER TO izzup_api;

--
-- Name: create_nugget(character varying, character varying, character varying, uuid); Type: FUNCTION; Schema: izzup_api; Owner: izzup_api
--

CREATE FUNCTION izzup_api.create_nugget(public_title character varying, internal_name character varying, nugget_type character varying, member_uid uuid, OUT uid uuid, OUT created_at timestamp without time zone) RETURNS record
    LANGUAGE plpgsql
    AS $_$
#variable_conflict use_column
DECLARE
  muid uuid;
  mcreated_at timestamp without time zone;
BEGIN

	INSERT INTO izzup_api.nugget(
				public_title, 
				internal_name, 
				account_id, 
				nugget_type_id,
	created_at)
			VALUES (
				$1, 
				$2, 
				izzup_api.get_member_account($4),
				1,
				DEFAULT
				)
 	RETURNING uid, created_at INTO uid, created_at;


	

	
END; 
$_$;


ALTER FUNCTION izzup_api.create_nugget(public_title character varying, internal_name character varying, nugget_type character varying, member_uid uuid, OUT uid uuid, OUT created_at timestamp without time zone) OWNER TO izzup_api;

--
-- Name: get_member_account(uuid); Type: FUNCTION; Schema: izzup_api; Owner: izzup_api
--

CREATE FUNCTION izzup_api.get_member_account(uid_in uuid) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
BEGIN
    
	RETURN (SELECT a.id 
	FROM izzup_api.account_member am 
	INNER JOIN izzup_api.account a ON a.id = am.account_id AND a.personal = true
	WHERE am.member_uid = uid_in);

	
END; 
$$;


ALTER FUNCTION izzup_api.get_member_account(uid_in uuid) OWNER TO izzup_api;

--
-- Name: get_nugget_type_id(character varying, bigint); Type: FUNCTION; Schema: izzup_api; Owner: izzup_api
--

CREATE FUNCTION izzup_api.get_nugget_type_id(type_name_in character varying, account_id_in bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
BEGIN

  IF account_id_in is null THEN 
    
	RETURN (SELECT id FROM izzup_api.nugget_type WHERE name = type_name_in and account_id is null);
	
ELSE 
	RETURN (SELECT id FROM izzup_api.nugget_type WHERE name = type_name_in and account_id = account_id_in);
END IF;

	
END; 
$$;


ALTER FUNCTION izzup_api.get_nugget_type_id(type_name_in character varying, account_id_in bigint) OWNER TO izzup_api;

--
-- Name: member_nuggets(uuid, text); Type: FUNCTION; Schema: izzup_api; Owner: postgres
--

CREATE FUNCTION izzup_api.member_nuggets(member_uid_in uuid, nugget_type_in text) RETURNS TABLE(uid uuid, created_at timestamp without time zone, updated_at timestamp without time zone, pub_at timestamp without time zone, un_pub_at timestamp without time zone, public_title character varying, internal_name character varying, nugget_type_id bigint, nugget_type character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY 
SELECT n.uid,  n.created_at,  n.updated_at,  n.pub_at, n.un_pub_at, n.public_title, n.internal_name, n.nugget_type_id, nt.name AS nugget_type
FROM izzup_api.account_member am 
INNER JOIN izzup_api.account a ON a.id = am.account_id
	AND a.personal = true
INNER JOIN izzup_api.nugget n ON n.account_id = am.account_id
INNER JOIN izzup_api.nugget_type nt ON nt.id = n.nugget_type_id
WHERE am.member_uid = member_uid_in
AND nt.name = nugget_type_in;
END;
$$;


ALTER FUNCTION izzup_api.member_nuggets(member_uid_in uuid, nugget_type_in text) OWNER TO postgres;

--
-- Name: register_member(text, text, numeric); Type: FUNCTION; Schema: izzup_api; Owner: izzup_api
--

CREATE FUNCTION izzup_api.register_member(uid_in text, email_in text, time_joined_in numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    
	INSERT INTO izzup_api.member(uid, email, created_at, last_sign_in)
	VALUES(uuid(uid_in), email_in,  to_timestamp(time_joined_in/1000), CURRENT_TIMESTAMP)
	ON CONFLICT (uid) DO UPDATE 
	SET last_sign_in = CURRENT_TIMESTAMP, email = EXCLUDED.email;
	
	RETURN 'OK';
	
END; 
$$;


ALTER FUNCTION izzup_api.register_member(uid_in text, email_in text, time_joined_in numeric) OWNER TO izzup_api;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.account (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(150),
    personal boolean DEFAULT true
);


ALTER TABLE izzup_api.account OWNER TO izzup_api;

--
-- Name: account_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: izzup_api
--

CREATE SEQUENCE izzup_api.account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE izzup_api.account_id_seq OWNER TO izzup_api;

--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: izzup_api
--

ALTER SEQUENCE izzup_api.account_id_seq OWNED BY izzup_api.account.id;


--
-- Name: account_member; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.account_member (
    account_id bigint NOT NULL,
    member_uid uuid NOT NULL,
    linked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    roles izzup_api.role[] DEFAULT '{reader}'::izzup_api.role[] NOT NULL
);


ALTER TABLE izzup_api.account_member OWNER TO izzup_api;

--
-- Name: block; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.block (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone,
    json_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    locale character varying(35) DEFAULT 'en-US'::character varying,
    pub_at timestamp without time zone,
    un_pub_at timestamp without time zone,
    account_id bigint NOT NULL
);


ALTER TABLE izzup_api.block OWNER TO izzup_api;

--
-- Name: block_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: izzup_api
--

CREATE SEQUENCE izzup_api.block_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE izzup_api.block_id_seq OWNER TO izzup_api;

--
-- Name: block_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: izzup_api
--

ALTER SEQUENCE izzup_api.block_id_seq OWNED BY izzup_api.block.id;


--
-- Name: block_type; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.block_type (
    id bigint NOT NULL,
    name character varying(150),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE izzup_api.block_type OWNER TO izzup_api;

--
-- Name: block_types_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: izzup_api
--

CREATE SEQUENCE izzup_api.block_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE izzup_api.block_types_id_seq OWNER TO izzup_api;

--
-- Name: block_types_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: izzup_api
--

ALTER SEQUENCE izzup_api.block_types_id_seq OWNED BY izzup_api.block_type.id;


--
-- Name: member; Type: VIEW; Schema: izzup_api; Owner: postgres
--

CREATE VIEW izzup_api.member AS
 SELECT (passwordless_users.user_id)::uuid AS member_uid,
    passwordless_users.email,
    passwordless_users.phone_number,
    to_timestamp(((passwordless_users.time_joined / 1000))::double precision) AS created_at
   FROM ultri_auth.passwordless_users;


ALTER TABLE izzup_api.member OWNER TO postgres;

--
-- Name: nugget; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.nugget (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone,
    pub_at timestamp without time zone,
    un_pub_at timestamp without time zone,
    public_title character varying(150),
    internal_name character varying(75),
    account_id bigint NOT NULL,
    nugget_type_id bigint NOT NULL
);


ALTER TABLE izzup_api.nugget OWNER TO izzup_api;

--
-- Name: nugget_block; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.nugget_block (
    nugget_id bigint NOT NULL,
    blocks bigint[],
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(75)
);


ALTER TABLE izzup_api.nugget_block OWNER TO izzup_api;

--
-- Name: nugget_comment; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.nugget_comment (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    "created_at " timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    account_id bigint NOT NULL,
    nugget_id bigint NOT NULL
);


ALTER TABLE izzup_api.nugget_comment OWNER TO izzup_api;

--
-- Name: nugget_comment_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: izzup_api
--

CREATE SEQUENCE izzup_api.nugget_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE izzup_api.nugget_comment_id_seq OWNER TO izzup_api;

--
-- Name: nugget_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: izzup_api
--

ALTER SEQUENCE izzup_api.nugget_comment_id_seq OWNED BY izzup_api.nugget_comment.id;


--
-- Name: nugget_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: izzup_api
--

CREATE SEQUENCE izzup_api.nugget_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE izzup_api.nugget_id_seq OWNER TO izzup_api;

--
-- Name: nugget_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: izzup_api
--

ALTER SEQUENCE izzup_api.nugget_id_seq OWNED BY izzup_api.nugget.id;


--
-- Name: nugget_member; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.nugget_member (
    nugget_id bigint NOT NULL,
    member_id bigint NOT NULL,
    linked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    roles izzup_api.role[] DEFAULT '{reader}'::izzup_api.role[] NOT NULL
);


ALTER TABLE izzup_api.nugget_member OWNER TO izzup_api;

--
-- Name: nugget_reaction; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.nugget_reaction (
    nugget_id bigint NOT NULL,
    account_id bigint NOT NULL,
    member_id bigint NOT NULL
);


ALTER TABLE izzup_api.nugget_reaction OWNER TO izzup_api;

--
-- Name: nugget_type; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.nugget_type (
    id bigint NOT NULL,
    name character varying(75) NOT NULL,
    account_id bigint,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE izzup_api.nugget_type OWNER TO izzup_api;

--
-- Name: nugget_type_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: izzup_api
--

CREATE SEQUENCE izzup_api.nugget_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE izzup_api.nugget_type_id_seq OWNER TO izzup_api;

--
-- Name: nugget_type_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: izzup_api
--

ALTER SEQUENCE izzup_api.nugget_type_id_seq OWNED BY izzup_api.nugget_type.id;


--
-- Name: response; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.response (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    comment_id bigint,
    response_id bigint,
    account_id bigint NOT NULL,
    nugget_id bigint NOT NULL
);


ALTER TABLE izzup_api.response OWNER TO izzup_api;

--
-- Name: response_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: izzup_api
--

CREATE SEQUENCE izzup_api.response_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE izzup_api.response_id_seq OWNER TO izzup_api;

--
-- Name: response_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: izzup_api
--

ALTER SEQUENCE izzup_api.response_id_seq OWNED BY izzup_api.response.id;


--
-- Name: service; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.service (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    auth_required character varying(10) DEFAULT 'member'::character varying NOT NULL
);


ALTER TABLE izzup_api.service OWNER TO izzup_api;

--
-- Name: service_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: izzup_api
--

CREATE SEQUENCE izzup_api.service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE izzup_api.service_id_seq OWNER TO izzup_api;

--
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: izzup_api
--

ALTER SEQUENCE izzup_api.service_id_seq OWNED BY izzup_api.service.id;


--
-- Name: account id; Type: DEFAULT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.account ALTER COLUMN id SET DEFAULT nextval('izzup_api.account_id_seq'::regclass);


--
-- Name: block id; Type: DEFAULT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.block ALTER COLUMN id SET DEFAULT nextval('izzup_api.block_id_seq'::regclass);


--
-- Name: block_type id; Type: DEFAULT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.block_type ALTER COLUMN id SET DEFAULT nextval('izzup_api.block_types_id_seq'::regclass);


--
-- Name: nugget id; Type: DEFAULT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget ALTER COLUMN id SET DEFAULT nextval('izzup_api.nugget_id_seq'::regclass);


--
-- Name: nugget_comment id; Type: DEFAULT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget_comment ALTER COLUMN id SET DEFAULT nextval('izzup_api.nugget_comment_id_seq'::regclass);


--
-- Name: nugget_type id; Type: DEFAULT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget_type ALTER COLUMN id SET DEFAULT nextval('izzup_api.nugget_type_id_seq'::regclass);


--
-- Name: response id; Type: DEFAULT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.response ALTER COLUMN id SET DEFAULT nextval('izzup_api.response_id_seq'::regclass);


--
-- Name: service id; Type: DEFAULT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.service ALTER COLUMN id SET DEFAULT nextval('izzup_api.service_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.account (id, uid, created_at, name, personal) FROM stdin;
1	1ab64e24-9ded-405a-a4b7-098be0b2342e	2023-03-07 07:16:01.27951	BrianGmail	t
2	d65b801c-af12-4ffa-94bc-cd35546abc6a	2023-03-07 16:20:56.343359	BrianUltri	t
3	bd83b257-f19d-4950-8191-3a8d23b2e63b	2023-03-09 09:28:48.992197	Izzup Member Account	t
5	740e14e5-fd02-46e2-9bb7-39095f873f43	2023-03-11 05:04:32.124949	Izzup Member Account	t
7	2f354d18-49c3-4ddd-a41d-2ab3d2eaac2b	2023-03-11 05:12:52.829332	Izzup Member Account for 64582d96-9dda-4117-91ba-666313852bfe	t
8	d8e5bc79-d2aa-4ff9-8351-d9125ca11ce3	2023-03-15 06:26:05.744271	Izzup Member Account for 0f165d16-fa39-4503-8b91-6c0ce1e23e7c	t
9	3dde281f-e295-466b-8a90-226aa6f25919	2023-03-16 04:03:25.371706	Izzup Member Account for 44febcf5-2489-4ef3-9751-b45d22bf0428	t
10	9ca0c57c-40c2-4d5a-a489-ce623a55e211	2023-03-16 18:19:17.372258	Izzup Member Account for 1d6a86c4-94fe-4133-a7ac-4a8eebca66d3	t
11	ffa5c708-f5c5-4c33-87a1-22c6912599ce	2023-03-16 18:29:49.36112	Izzup Member Account for 229c4c57-d594-46e4-aa63-27379147d0a4	t
12	a035b2d0-4d13-4236-84c6-61592fef6776	2023-03-16 18:31:16.218219	Izzup Member Account for 236d9ca2-82ef-4ad9-b815-8f0f3e21fdb3	t
13	5b11d267-7bb2-4fbd-854c-c50a687b8d32	2023-03-16 18:48:36.678407	Izzup Member Account for c041e99e-574b-49e5-937d-b4a5fbd4c78e	t
14	29c16815-0d1d-4ac1-a14d-e70f8a1355a5	2023-03-16 18:50:19.011995	Izzup Member Account for c11640b9-2b79-4c36-960e-74f31e634ceb	t
15	cc35a106-c1d6-4dc6-8243-e30d97c6f9cb	2023-03-16 18:52:32.27825	Izzup Member Account for 720e6556-d883-4838-b07a-79d73398d1b5	t
16	ba376154-b127-4709-b6d9-1b14b2fe74d6	2023-03-16 20:27:57.148596	Izzup Member Account for 9f77b3df-ed08-4a02-a6c9-e5dbd9573c33	t
17	7471f3db-0b98-4020-b9a3-9ac9c2aef051	2023-03-16 20:31:55.611748	Izzup Member Account for a3952355-71f4-434d-9f03-0c61950447b4	t
18	d4f0c01d-e860-44b0-82b6-23776a2eb395	2023-03-16 20:39:16.001646	Izzup Member Account for 12b3a861-c627-4493-9243-03e6fd274995	t
19	7a067689-8ba1-4427-af03-705db99f4467	2023-03-18 06:30:13.989994	Izzup Member Account for df50854c-201f-4829-a67a-953e39aa772f	t
20	88f87d14-140b-4fe3-8b4e-7a7b6c75bbc1	2023-03-18 19:35:08.272918	Izzup Member Account for 3c1f25cd-065b-483e-ae33-339488f263bb	t
21	a7525f2d-dc79-4c39-8b4f-7751112b3ec9	2023-03-19 06:54:30.891231	Izzup Member Account for b2264e89-9e8d-40ad-a8ab-75c2146c899d	t
22	1307ecdc-c8e4-4e37-b610-44686a6e474a	2023-03-22 04:59:25.634367	Izzup Member Account for d4dcff47-90a8-48ca-a04b-0cbf4b05091b	t
\.


--
-- Data for Name: account_member; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.account_member (account_id, member_uid, linked_at, roles) FROM stdin;
7	64582d96-9dda-4117-91ba-666313852bfe	2023-03-11 05:12:52.829332	{owner}
5	be0f1caf-6fec-4b23-b1bd-56b9fa80408e	2023-03-11 05:14:53.975062	{owner}
8	0f165d16-fa39-4503-8b91-6c0ce1e23e7c	2023-03-15 06:26:05.744271	{owner}
9	44febcf5-2489-4ef3-9751-b45d22bf0428	2023-03-16 04:03:25.371706	{owner}
10	1d6a86c4-94fe-4133-a7ac-4a8eebca66d3	2023-03-16 18:19:17.372258	{owner}
11	229c4c57-d594-46e4-aa63-27379147d0a4	2023-03-16 18:29:49.36112	{owner}
12	236d9ca2-82ef-4ad9-b815-8f0f3e21fdb3	2023-03-16 18:31:16.218219	{owner}
13	c041e99e-574b-49e5-937d-b4a5fbd4c78e	2023-03-16 18:48:36.678407	{owner}
14	c11640b9-2b79-4c36-960e-74f31e634ceb	2023-03-16 18:50:19.011995	{owner}
15	720e6556-d883-4838-b07a-79d73398d1b5	2023-03-16 18:52:32.27825	{owner}
16	9f77b3df-ed08-4a02-a6c9-e5dbd9573c33	2023-03-16 20:27:57.148596	{owner}
17	a3952355-71f4-434d-9f03-0c61950447b4	2023-03-16 20:31:55.611748	{owner}
18	12b3a861-c627-4493-9243-03e6fd274995	2023-03-16 20:39:16.001646	{owner}
19	df50854c-201f-4829-a67a-953e39aa772f	2023-03-18 06:30:13.989994	{owner}
20	3c1f25cd-065b-483e-ae33-339488f263bb	2023-03-18 19:35:08.272918	{owner}
21	b2264e89-9e8d-40ad-a8ab-75c2146c899d	2023-03-19 06:54:30.891231	{owner}
22	d4dcff47-90a8-48ca-a04b-0cbf4b05091b	2023-03-22 04:59:25.634367	{owner}
\.


--
-- Data for Name: block; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.block (id, uid, created_at, updated_at, json_data, locale, pub_at, un_pub_at, account_id) FROM stdin;
\.


--
-- Data for Name: block_type; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.block_type (id, name, created_at) FROM stdin;
\.


--
-- Data for Name: nugget; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.nugget (id, uid, created_at, updated_at, pub_at, un_pub_at, public_title, internal_name, account_id, nugget_type_id) FROM stdin;
1	6483ab49-ab4c-49db-bda0-7f86241b77b8	2023-03-18 07:14:21.587002	\N	\N	\N	Test Title	My manual created article	19	1
2	e979f903-2112-41db-91a6-1e9ba5992b8b	2023-03-18 20:55:13.251519	\N	\N	\N	pub title	internal name	20	1
3	313c28b7-53e2-4e72-a1c0-678344fd74ff	2023-03-19 07:08:39.27762	\N	\N	\N	My title	My interal name	21	1
4	100c48bb-11c9-42e9-9c17-f745e1c104fa	2023-03-19 07:17:57.191144	\N	\N	\N	My Title	My project	21	1
5	eb6189c2-75c0-49fc-8785-23f5829dc633	2023-03-19 07:29:43.626876	\N	\N	\N	My Title	My project	21	1
6	f4d8e2be-1d15-4c74-a799-8bfbfc6ae5cd	2023-03-19 07:29:52.749567	\N	\N	\N	My Title	My project	21	1
7	97d24d4b-50a3-486e-b0f8-e8edd3f86f67	2023-03-19 07:30:35.619995	\N	\N	\N	My Title	My project	21	1
12	0acfcacf-4197-4362-b32c-981a616d49f3	2023-03-22 07:52:32.740789	\N	\N	\N	sefesd	sdvfdsv	4	1
13	2b9a3730-e559-4c93-a361-804bab9e0156	2023-03-22 07:54:43.640456	\N	\N	\N	my public  title	my internal name	4	1
14	b5da85e5-70e2-4b27-96d3-0e2f264b299f	2023-03-22 07:54:57.313791	\N	\N	\N	my publicfweferwf  title	my internal name	4	1
15	b315e190-3834-404c-9cc0-fb1daaeb497d	2023-03-22 07:55:45.857405	\N	\N	\N	my publicfweferwf  title	my internal name	4	1
16	b542a1ee-dc65-4b50-850e-d8725045a2bf	2023-03-22 07:55:56.684406	\N	\N	\N	my publicfweferwf  title	my internal name	4	1
17	2ce7da09-1f77-46de-9387-9254d0e6aeb1	2023-03-22 07:58:19.398409	\N	\N	\N	wtf my publicfweferwf  title	my internal name	4	1
18	2ebb071d-cfca-4252-8ceb-85ffc3268285	2023-03-22 07:58:48.607709	\N	\N	\N	wtf my publicfweferwf  title	my internal name	4	1
19	8b2c7d6a-984a-48ac-9fa2-e75017fd77ca	2023-03-22 08:07:39.914684	\N	\N	\N	fucking shiteferwf  title	my internal name	4	1
20	626eeda7-a6f8-4f94-9fc5-72bf2191f47e	2023-03-22 08:11:01.715122	\N	\N	\N	fucking shiteferwf  title	my internal name	4	1
21	e4d0f1e1-4389-4b84-926a-d99d9c0ecfe7	2023-03-22 08:25:33.390408	\N	\N	\N	fucking shiteferwf  title	my internal name	4	1
22	26252844-ea4e-42fc-b7e5-759ff31f4408	2023-03-22 08:25:48.733737	\N	\N	\N	fucking shiteferwf  title	my internal name	4	1
23	7fb84f43-3bcc-4983-8550-1f3c2b188cf4	2023-03-22 08:27:26.787095	\N	\N	\N	fucking shiteferwf  title	my internal name	4	1
24	04d07434-d5d7-47ed-8718-0a4f0b293bb3	2023-03-22 08:30:17.85302	\N	\N	\N	fucking shiteferwf  title	my internal name	4	1
25	6762a10c-db3b-4537-84e3-cd8655694afc	2023-03-22 08:30:27.486608	\N	\N	\N	fucking shiteferwf  title	my internal name	4	1
26	b52814a4-5061-422c-8bb8-5b0e10983f27	2023-03-22 08:30:37.157345	\N	\N	\N	fucking shiteferwf  title	my internal name	4	1
27	1c7142cc-10c9-45df-8489-de556201a023	2023-03-22 08:35:15.532269	\N	\N	\N	fucking shiteferwf  title	my internal name	4	1
28	8960dca9-6fdd-4c69-a6f2-724a7060ad83	2023-03-22 08:41:51.343469	\N	\N	\N	fufrvfdvdcking shiteferwf  title	my internal name	22	1
\.


--
-- Data for Name: nugget_block; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.nugget_block (nugget_id, blocks, updated_at, name) FROM stdin;
\.


--
-- Data for Name: nugget_comment; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.nugget_comment (id, uid, "created_at ", account_id, nugget_id) FROM stdin;
\.


--
-- Data for Name: nugget_member; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.nugget_member (nugget_id, member_id, linked_at, roles) FROM stdin;
\.


--
-- Data for Name: nugget_reaction; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.nugget_reaction (nugget_id, account_id, member_id) FROM stdin;
\.


--
-- Data for Name: nugget_type; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.nugget_type (id, name, account_id, created_at) FROM stdin;
1	article	\N	2023-03-15 07:27:56.906351
2	post	\N	2023-03-15 07:27:56.906351
3	comment	\N	2023-03-15 07:27:56.906351
4	response	\N	2023-03-15 07:27:56.906351
5	item	\N	2023-03-15 07:27:56.906351
6	collection	\N	2023-03-15 07:27:56.906351
7	shop	\N	2023-03-15 07:27:56.906351
8	webpage	\N	2023-03-15 07:27:56.906351
9	website	\N	2023-03-15 07:27:56.906351
10	recipe	\N	2023-03-15 07:27:56.906351
\.


--
-- Data for Name: response; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.response (id, uid, created_at, comment_id, response_id, account_id, nugget_id) FROM stdin;
\.


--
-- Data for Name: service; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.service (id, name, url, created_at, auth_required) FROM stdin;
14	update_article	\N	2023-03-07 07:35:55.598283	true
15	delete_article	\N	2023-03-07 07:35:55.598283	true
16	homepage	\N	2023-03-07 07:35:55.598283	true
18	create_post	\N	2023-03-07 16:45:09.358428	true
19	read_post	\N	2023-03-07 16:45:09.358428	true
20	update_post	\N	2023-03-07 16:45:09.358428	true
21	delete_post	\N	2023-03-07 16:45:09.358428	true
12	create_article	\N	2023-03-07 07:35:55.598283	true
11	author_article	\N	2023-03-07 07:35:55.598283	false
17	author_post	\N	2023-03-07 16:45:09.358428	true
13	read_article	\N	2023-03-07 07:35:55.598283	false
\.


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.account_id_seq', 22, true);


--
-- Name: block_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.block_id_seq', 1, false);


--
-- Name: block_types_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.block_types_id_seq', 1, false);


--
-- Name: nugget_comment_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.nugget_comment_id_seq', 1, false);


--
-- Name: nugget_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.nugget_id_seq', 28, true);


--
-- Name: nugget_type_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.nugget_type_id_seq', 10, true);


--
-- Name: response_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.response_id_seq', 1, false);


--
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.service_id_seq', 21, true);


--
-- Name: account_member account_member_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.account_member
    ADD CONSTRAINT account_member_pkey PRIMARY KEY (account_id, member_uid);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: block block_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.block
    ADD CONSTRAINT block_pkey PRIMARY KEY (id, uid);


--
-- Name: block_type block_types_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.block_type
    ADD CONSTRAINT block_types_pkey PRIMARY KEY (id);


--
-- Name: nugget_block nugget_blocks_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget_block
    ADD CONSTRAINT nugget_blocks_pkey PRIMARY KEY (nugget_id);


--
-- Name: nugget_comment nugget_comment_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget_comment
    ADD CONSTRAINT nugget_comment_pkey PRIMARY KEY (id);


--
-- Name: nugget_member nugget_member_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget_member
    ADD CONSTRAINT nugget_member_pkey PRIMARY KEY (nugget_id, member_id);


--
-- Name: nugget nugget_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget
    ADD CONSTRAINT nugget_pkey PRIMARY KEY (id);


--
-- Name: nugget_reaction nugget_reaction_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget_reaction
    ADD CONSTRAINT nugget_reaction_pkey PRIMARY KEY (nugget_id, account_id);


--
-- Name: nugget_type nugget_type_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget_type
    ADD CONSTRAINT nugget_type_pkey PRIMARY KEY (id);


--
-- Name: response response_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.response
    ADD CONSTRAINT response_pkey PRIMARY KEY (id);


--
-- Name: service service_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: nugget_type uq_nugget_type_name; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget_type
    ADD CONSTRAINT uq_nugget_type_name UNIQUE (account_id, name);


--
-- Name: ix_account_member_member_uid; Type: INDEX; Schema: izzup_api; Owner: izzup_api
--

CREATE INDEX ix_account_member_member_uid ON izzup_api.account_member USING btree (member_uid) INCLUDE (account_id);


--
-- Name: ix_account_nuggets_by_type; Type: INDEX; Schema: izzup_api; Owner: izzup_api
--

CREATE INDEX ix_account_nuggets_by_type ON izzup_api.nugget USING btree (account_id, nugget_type_id) INCLUDE (id);


--
-- Name: SCHEMA izzup_api; Type: ACL; Schema: -; Owner: izzup_api
--

GRANT USAGE ON SCHEMA izzup_api TO ultri_auth;


--
-- Name: FUNCTION create_api_account(); Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON FUNCTION izzup_api.create_api_account() TO ultri_auth;


--
-- Name: FUNCTION create_member_account(); Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON FUNCTION izzup_api.create_member_account() TO ultri_auth;


--
-- Name: FUNCTION register_member(uid_in text, email_in text, time_joined_in numeric); Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON FUNCTION izzup_api.register_member(uid_in text, email_in text, time_joined_in numeric) TO ultri_auth;


--
-- Name: TABLE account; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.account TO ultri_auth;


--
-- Name: SEQUENCE account_id_seq; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON SEQUENCE izzup_api.account_id_seq TO ultri_auth;


--
-- Name: TABLE account_member; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.account_member TO ultri_auth;


--
-- Name: TABLE block; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.block TO ultri_auth;


--
-- Name: SEQUENCE block_id_seq; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON SEQUENCE izzup_api.block_id_seq TO ultri_auth;


--
-- Name: TABLE block_type; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.block_type TO ultri_auth;


--
-- Name: SEQUENCE block_types_id_seq; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON SEQUENCE izzup_api.block_types_id_seq TO ultri_auth;


--
-- Name: TABLE member; Type: ACL; Schema: izzup_api; Owner: postgres
--

GRANT ALL ON TABLE izzup_api.member TO ultri_auth;


--
-- Name: TABLE nugget; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.nugget TO ultri_auth;


--
-- Name: TABLE nugget_block; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.nugget_block TO ultri_auth;


--
-- Name: TABLE nugget_comment; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.nugget_comment TO ultri_auth;


--
-- Name: SEQUENCE nugget_comment_id_seq; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON SEQUENCE izzup_api.nugget_comment_id_seq TO ultri_auth;


--
-- Name: SEQUENCE nugget_id_seq; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON SEQUENCE izzup_api.nugget_id_seq TO ultri_auth;


--
-- Name: TABLE nugget_member; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.nugget_member TO ultri_auth;


--
-- Name: TABLE nugget_reaction; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.nugget_reaction TO ultri_auth;


--
-- Name: TABLE nugget_type; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.nugget_type TO ultri_auth;


--
-- Name: SEQUENCE nugget_type_id_seq; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON SEQUENCE izzup_api.nugget_type_id_seq TO ultri_auth;


--
-- Name: TABLE response; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.response TO ultri_auth;


--
-- Name: SEQUENCE response_id_seq; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON SEQUENCE izzup_api.response_id_seq TO ultri_auth;


--
-- Name: TABLE service; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.service TO ultri_auth;


--
-- Name: SEQUENCE service_id_seq; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON SEQUENCE izzup_api.service_id_seq TO ultri_auth;


--
-- PostgreSQL database dump complete
--

