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
-- Name: register_member(text, text, numeric); Type: FUNCTION; Schema: izzup_api; Owner: postgres
--

CREATE FUNCTION izzup_api.register_member(uid_in text, email_in text, timejoined_in numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    
	INSERT INTO izzup_api.member(uid, email, created_at, last_sign_in)
	VALUES(uuid(uid_in), email_in,  to_timestamp(timejoined_in/1000), CURRENT_TIMESTAMP)
	ON CONFLICT (uid) DO UPDATE 
	SET last_sign_in = CURRENT_TIMESTAMP, email = EXCLUDED.email;
	
	RETURN 'OK';
	
END; 
$$;


ALTER FUNCTION izzup_api.register_member(uid_in text, email_in text, timejoined_in numeric) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.account (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(150)
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
    member_id bigint NOT NULL,
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
-- Name: member; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.member (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email character varying(250),
    tel character varying(15),
    username character varying(75),
    last_sign_in timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE izzup_api.member OWNER TO izzup_api;

--
-- Name: member_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: izzup_api
--

CREATE SEQUENCE izzup_api.member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE izzup_api.member_id_seq OWNER TO izzup_api;

--
-- Name: member_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: izzup_api
--

ALTER SEQUENCE izzup_api.member_id_seq OWNED BY izzup_api.member.id;


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
-- Name: member id; Type: DEFAULT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.member ALTER COLUMN id SET DEFAULT nextval('izzup_api.member_id_seq'::regclass);


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

COPY izzup_api.account (id, uid, created_at, name) FROM stdin;
1	1ab64e24-9ded-405a-a4b7-098be0b2342e	2023-03-07 07:16:01.27951	BrianGmail
2	d65b801c-af12-4ffa-94bc-cd35546abc6a	2023-03-07 16:20:56.343359	BrianUltri
\.


--
-- Data for Name: account_member; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.account_member (account_id, member_id, linked_at, roles) FROM stdin;
1	1	2023-03-07 16:35:00.35755	{reader}
2	2	2023-03-07 16:35:00.35755	{reader}
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
-- Data for Name: member; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.member (id, uid, created_at, email, tel, username, last_sign_in) FROM stdin;
1	69023f41-fbd2-4866-9bc3-ea02cacea79d	2023-03-07 16:16:30.344321	brian@ultri.com	\N	\N	2023-03-09 07:19:11.570979
2	188715cf-6960-4b2c-8916-75e1d96d7117	2023-03-07 16:16:30.344321	bwinkers@gmail.com	\N	\N	2023-03-09 07:19:11.570979
8	0111c14f-555e-42f8-9da5-01a5f535b442	2023-03-09 06:44:46.594	carmella.schinner42@example.org	\N	\N	2023-03-09 07:28:09.907084
12	108e4673-1744-41e7-b155-707fcd802701	2023-03-09 08:05:23.414	madelyn.hettinger@example.org	\N	\N	2023-03-09 08:06:08.516461
\.


--
-- Data for Name: nugget; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.nugget (id, uid, created_at, updated_at, pub_at, un_pub_at, public_title, internal_name, account_id, nugget_type_id) FROM stdin;
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

SELECT pg_catalog.setval('izzup_api.account_id_seq', 2, true);


--
-- Name: block_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.block_id_seq', 1, false);


--
-- Name: block_types_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.block_types_id_seq', 1, false);


--
-- Name: member_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.member_id_seq', 13, true);


--
-- Name: nugget_comment_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.nugget_comment_id_seq', 1, false);


--
-- Name: nugget_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.nugget_id_seq', 1, false);


--
-- Name: nugget_type_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.nugget_type_id_seq', 1, false);


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
    ADD CONSTRAINT account_member_pkey PRIMARY KEY (account_id, member_id);


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
-- Name: member member_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


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
-- Name: member uq_member_uid; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.member
    ADD CONSTRAINT uq_member_uid UNIQUE (uid);


--
-- Name: nugget_type uq_nugget_type_name; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget_type
    ADD CONSTRAINT uq_nugget_type_name UNIQUE (account_id, name);


--
-- PostgreSQL database dump complete
--

