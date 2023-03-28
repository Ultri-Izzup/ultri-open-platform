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
-- Name: create_account(character varying, uuid); Type: FUNCTION; Schema: izzup_api; Owner: izzup_api
--

CREATE FUNCTION izzup_api.create_account(name_in character varying, owner_uid uuid) RETURNS TABLE(id bigint, uid uuid, created_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$

DECLARE new_account_id BIGINT;
DECLARE new_account_uid uuid;
DECLARE new_account_created_at timestamp without time zone;

BEGIN
    
	INSERT INTO izzup_api.account(name, personal)
		 VALUES(name_in, false)
		 RETURNING izzup_api.account.id, izzup_api.account.uid, izzup_api.account.created_at INTO new_account_id, new_account_uid, new_account_created_at;
		
	INSERT INTO izzup_api.account_member(account_id, member_uid, roles)
		 VALUES(new_account_id, owner_uid,  '{"owner"}');

	RETURN QUERY SELECT new_account_id, new_account_uid, new_account_created_at;
	
	
END; 
$$;


ALTER FUNCTION izzup_api.create_account(name_in character varying, owner_uid uuid) OWNER TO izzup_api;

--
-- Name: create_account_nugget(character varying, character varying, character varying, bigint, uuid); Type: FUNCTION; Schema: izzup_api; Owner: izzup_api
--

CREATE FUNCTION izzup_api.create_account_nugget(public_title character varying, internal_name character varying, nugget_type character varying, account_uid bigint, member_uid uuid, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint) RETURNS record
    LANGUAGE plpgsql
    AS $_$
#variable_conflict use_column
BEGIN

	INSERT INTO izzup_api.nugget(
				public_title, 
				internal_name,   
				account_id, 
				nugget_type_id,
				created_at
			)
			VALUES (
				$1, 
				$2, 
				izzup_api.get_member_account($4),
				1,
				DEFAULT
				)
 	RETURNING id, uid, created_at, account_id INTO id, uid, created_at, account_id;

	

	
END; 
$_$;


ALTER FUNCTION izzup_api.create_account_nugget(public_title character varying, internal_name character varying, nugget_type character varying, account_uid bigint, member_uid uuid, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint) OWNER TO izzup_api;

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
-- Name: create_member_nugget(character varying, character varying, character varying, uuid); Type: FUNCTION; Schema: izzup_api; Owner: izzup_api
--

CREATE FUNCTION izzup_api.create_member_nugget(public_title character varying, internal_name character varying, nugget_type character varying, member_uid uuid, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint) RETURNS record
    LANGUAGE plpgsql
    AS $_$
#variable_conflict use_column
BEGIN

	INSERT INTO izzup_api.nugget(
				public_title, 
				internal_name, 
				nugget_type_id,
				account_id
				)
			VALUES (
				$1, 
				$2, 
				izzup_api.get_nugget_type_id($3, null),
				izzup_api.get_member_account($4)
				)
 	RETURNING id, uid, created_at, account_id INTO id, uid, created_at, account_id;

	

	
END; 
$_$;


ALTER FUNCTION izzup_api.create_member_nugget(public_title character varying, internal_name character varying, nugget_type character varying, member_uid uuid, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint) OWNER TO izzup_api;

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
	WHERE am.member_uid = uid_in
	ORDER BY a.created_at LIMIT 1);

	
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
  RETURN (
  	SELECT id FROM izzup_api.nugget_type WHERE name = 'article' AND ( account_id = account_id_in OR account_id IS NULL )
	ORDER BY account_id
	LIMIT 1
  );
  
	
END; 
$$;


ALTER FUNCTION izzup_api.get_nugget_type_id(type_name_in character varying, account_id_in bigint) OWNER TO izzup_api;

--
-- Name: member_nuggets(uuid, text); Type: FUNCTION; Schema: izzup_api; Owner: postgres
--

CREATE FUNCTION izzup_api.member_nuggets(member_uid_in uuid, nugget_type_in text) RETURNS TABLE(uid uuid, "createdAt" timestamp without time zone, "updatedAt" timestamp without time zone, "pubAt" timestamp without time zone, "unPubAt" timestamp without time zone, "publicTitle" character varying, "internalName" character varying, "nuggetTypeId" bigint, "nuggetType" character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY 
SELECT n.uid,  n.created_at AS createdAt,  n.updated_at AS pubAt,  n.pub_at, n.un_pub_at AS unPubAt, n.public_title AS publicTitle, n.internal_name AS internalName, n.nugget_type_id AS nuggetTypeId, nt.name AS nuggetType
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
-- Name: member; Type: VIEW; Schema: izzup_api; Owner: izzup_api
--

CREATE VIEW izzup_api.member AS
 SELECT (passwordless_users.user_id)::uuid AS member_uid,
    passwordless_users.email,
    passwordless_users.phone_number,
    to_timestamp(((passwordless_users.time_joined / 1000))::double precision) AS created_at
   FROM ultri_auth.passwordless_users;


ALTER TABLE izzup_api.member OWNER TO izzup_api;

--
-- Name: member_accounts; Type: VIEW; Schema: izzup_api; Owner: izzup_api
--

CREATE VIEW izzup_api.member_accounts AS
 SELECT m.email,
    am.member_uid AS "memberUid",
    am.linked_at AS "accountLinkedAt",
    a.uid AS "accountUid",
    a.created_at AS "accountCreatedAt",
    am.roles
   FROM ((izzup_api.account_member am
     JOIN izzup_api.account a ON ((a.id = am.account_id)))
     JOIN izzup_api.member m ON ((m.member_uid = am.member_uid)));


ALTER TABLE izzup_api.member_accounts OWNER TO izzup_api;

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
23	643c8d0f-94c0-48c4-9e4e-cb39ec1fe075	2023-03-24 00:02:14.944919	Izzup Member Account for 8fe443bc-745c-460a-a9c4-0ae7b261d6c4	t
24	a0e1d821-f86e-48f2-8a3a-aa915bac2cb0	2023-03-24 03:12:18.122234	Izzup Member Account for c8885655-74e3-4594-ad69-2419a2129458	t
28	17792eb1-eb48-4044-a85f-edff33b49dfe	2023-03-26 19:39:25.28476	My first  account	t
29	fa06cc56-4665-4259-9202-fe4ad473a8a8	2023-03-26 19:39:35.253513	My first  account	t
30	d7db7fcb-4a77-4169-9823-e38958023528	2023-03-26 20:28:41.031688	My shared account	f
31	af8db92e-aaac-4141-bfb4-4b6487c8a1a7	2023-03-26 20:28:46.285516	My shared account	f
32	bbcc7919-956a-4e7a-8db1-7b5770acaa10	2023-03-28 04:42:34.097693	My shared account	f
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
23	8fe443bc-745c-460a-a9c4-0ae7b261d6c4	2023-03-24 00:02:14.944919	{owner}
24	c8885655-74e3-4594-ad69-2419a2129458	2023-03-24 03:12:18.122234	{owner}
28	c8885655-74e3-4594-ad69-2419a2129458	2023-03-26 19:39:25.28476	{owner}
29	c8885655-74e3-4594-ad69-2419a2129458	2023-03-26 19:39:35.253513	{owner}
30	c8885655-74e3-4594-ad69-2419a2129458	2023-03-26 20:28:41.031688	{owner}
31	c8885655-74e3-4594-ad69-2419a2129458	2023-03-26 20:28:46.285516	{owner}
32	c8885655-74e3-4594-ad69-2419a2129458	2023-03-28 04:42:34.097693	{owner}
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
41	26f0f0ff-62a3-4abc-ab4c-f354a72ee104	2023-03-24 21:51:44.353823	\N	\N	\N	My newest Title	My project	24	1
42	3cb20534-e881-4eaf-89b1-418b7cdcb47c	2023-03-24 21:52:21.345467	\N	\N	\N	My next Title	My next project	24	1
44	1e472044-ad49-4120-a655-0101a40219f2	2023-03-26 20:27:35.046921	\N	\N	\N	My next Title	My next project	24	1
45	de073b73-ff62-4410-8570-838795b44ee9	2023-03-28 04:42:26.033553	\N	\N	\N	My next Title	My next project	24	1
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
11	article	24	2023-03-24 08:06:16.288524
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

SELECT pg_catalog.setval('izzup_api.account_id_seq', 32, true);


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

SELECT pg_catalog.setval('izzup_api.nugget_id_seq', 45, true);


--
-- Name: nugget_type_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.nugget_type_id_seq', 11, true);


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
-- Name: account uq_account_uid; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.account
    ADD CONSTRAINT uq_account_uid UNIQUE (uid);


--
-- Name: nugget_type uq_nugget_type_name; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget_type
    ADD CONSTRAINT uq_nugget_type_name UNIQUE (account_id, name);


--
-- Name: nugget uq_nugget_uid; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget
    ADD CONSTRAINT uq_nugget_uid UNIQUE (uid);


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
-- Name: TABLE member; Type: ACL; Schema: izzup_api; Owner: izzup_api
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

