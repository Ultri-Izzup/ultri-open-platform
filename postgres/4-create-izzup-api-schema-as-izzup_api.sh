#!/bin/bash
set -e
export PGPASSWORD=$IZZUP_DB_PASS;
psql -v ON_ERROR_STOP=1 --username "$IZZUP_DB_USER" --dbname "$TENANT_DB_NAME" <<-EOSQL
  BEGIN;
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

CREATE TYPE izzup_api.auth_level AS ENUM (
    'public',
    'member',
    'account',
    'role',
    'account_role',
    'application'
);


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


SET default_tablespace = '';

SET default_table_access_method = heap;

CREATE TABLE izzup_api.account (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(150)
);


CREATE SEQUENCE izzup_api.account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE izzup_api.account_id_seq OWNED BY izzup_api.account.id;


CREATE TABLE izzup_api.account_member (
    account_id bigint NOT NULL,
    member_id bigint NOT NULL,
    linked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    roles izzup_api.role[] DEFAULT '{reader}'::izzup_api.role[] NOT NULL
);


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


--
-- TOC entry 231 (class 1259 OID 16583)
-- Name: block_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: -
--

CREATE SEQUENCE izzup_api.block_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 231
-- Name: block_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: -
--

ALTER SEQUENCE izzup_api.block_id_seq OWNED BY izzup_api.block.id;


--
-- TOC entry 244 (class 1259 OID 16793)
-- Name: block_type; Type: TABLE; Schema: izzup_api; Owner: -
--

CREATE TABLE izzup_api.block_type (
    id bigint NOT NULL,
    name character varying(150),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 243 (class 1259 OID 16792)
-- Name: block_types_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: -
--

CREATE SEQUENCE izzup_api.block_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 243
-- Name: block_types_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: -
--

ALTER SEQUENCE izzup_api.block_types_id_seq OWNED BY izzup_api.block_type.id;


--
-- TOC entry 230 (class 1259 OID 16573)
-- Name: member; Type: TABLE; Schema: izzup_api; Owner: -
--

CREATE TABLE izzup_api.member (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email character varying(250),
    tel character varying(15),
    username character varying(75),
    password text
);


--
-- TOC entry 229 (class 1259 OID 16572)
-- Name: member_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: -
--

CREATE SEQUENCE izzup_api.member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 229
-- Name: member_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: -
--

ALTER SEQUENCE izzup_api.member_id_seq OWNED BY izzup_api.member.id;


--
-- TOC entry 233 (class 1259 OID 16596)
-- Name: nugget; Type: TABLE; Schema: izzup_api; Owner: -
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


--
-- TOC entry 235 (class 1259 OID 16622)
-- Name: nugget_block; Type: TABLE; Schema: izzup_api; Owner: -
--

CREATE TABLE izzup_api.nugget_block (
    nugget_id bigint NOT NULL,
    blocks bigint[],
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(75)
);


--
-- TOC entry 247 (class 1259 OID 16846)
-- Name: nugget_comment; Type: TABLE; Schema: izzup_api; Owner: -
--

CREATE TABLE izzup_api.nugget_comment (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    "created_at " timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    account_id bigint NOT NULL,
    nugget_id bigint NOT NULL
);


--
-- TOC entry 246 (class 1259 OID 16845)
-- Name: nugget_comment_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: -
--

CREATE SEQUENCE izzup_api.nugget_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 246
-- Name: nugget_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: -
--

ALTER SEQUENCE izzup_api.nugget_comment_id_seq OWNED BY izzup_api.nugget_comment.id;


--
-- TOC entry 234 (class 1259 OID 16599)
-- Name: nugget_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: -
--

CREATE SEQUENCE izzup_api.nugget_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 234
-- Name: nugget_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: -
--

ALTER SEQUENCE izzup_api.nugget_id_seq OWNED BY izzup_api.nugget.id;


--
-- TOC entry 245 (class 1259 OID 16836)
-- Name: nugget_member; Type: TABLE; Schema: izzup_api; Owner: -
--

CREATE TABLE izzup_api.nugget_member (
    nugget_id bigint NOT NULL,
    member_id bigint NOT NULL,
    linked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    roles izzup_api.role[] DEFAULT '{reader}'::izzup_api.role[] NOT NULL
);


--
-- TOC entry 250 (class 1259 OID 16873)
-- Name: nugget_reaction; Type: TABLE; Schema: izzup_api; Owner: -
--

CREATE TABLE izzup_api.nugget_reaction (
    nugget_id bigint NOT NULL,
    account_id bigint NOT NULL,
    member_id bigint NOT NULL
);


--
-- TOC entry 242 (class 1259 OID 16731)
-- Name: nugget_type; Type: TABLE; Schema: izzup_api; Owner: -
--

CREATE TABLE izzup_api.nugget_type (
    id bigint NOT NULL,
    name character varying(75) NOT NULL,
    account_id bigint,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 241 (class 1259 OID 16730)
-- Name: nugget_type_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: -
--

CREATE SEQUENCE izzup_api.nugget_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 241
-- Name: nugget_type_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: -
--

ALTER SEQUENCE izzup_api.nugget_type_id_seq OWNED BY izzup_api.nugget_type.id;


--
-- TOC entry 249 (class 1259 OID 16855)
-- Name: response; Type: TABLE; Schema: izzup_api; Owner: -
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


--
-- TOC entry 248 (class 1259 OID 16854)
-- Name: response_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: -
--

CREATE SEQUENCE izzup_api.response_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 248
-- Name: response_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: -
--

ALTER SEQUENCE izzup_api.response_id_seq OWNED BY izzup_api.response.id;


--
-- TOC entry 240 (class 1259 OID 16702)
-- Name: service; Type: TABLE; Schema: izzup_api; Owner: -
--

CREATE TABLE izzup_api.service (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    auth_required character varying(10) DEFAULT 'member'::character varying NOT NULL
);


--
-- TOC entry 239 (class 1259 OID 16701)
-- Name: service_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: -
--

CREATE SEQUENCE izzup_api.service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 239
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: -
--

ALTER SEQUENCE izzup_api.service_id_seq OWNED BY izzup_api.service.id;

--
-- TOC entry 3315 (class 2604 OID 16639)
-- Name: account id; Type: DEFAULT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.account ALTER COLUMN id SET DEFAULT nextval('izzup_api.account_id_seq'::regclass);


--
-- TOC entry 3306 (class 2604 OID 16587)
-- Name: block id; Type: DEFAULT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.block ALTER COLUMN id SET DEFAULT nextval('izzup_api.block_id_seq'::regclass);


--
-- TOC entry 3325 (class 2604 OID 16796)
-- Name: block_type id; Type: DEFAULT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.block_type ALTER COLUMN id SET DEFAULT nextval('izzup_api.block_types_id_seq'::regclass);


--
-- TOC entry 3303 (class 2604 OID 16576)
-- Name: member id; Type: DEFAULT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.member ALTER COLUMN id SET DEFAULT nextval('izzup_api.member_id_seq'::regclass);


--
-- TOC entry 3311 (class 2604 OID 16600)
-- Name: nugget id; Type: DEFAULT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.nugget ALTER COLUMN id SET DEFAULT nextval('izzup_api.nugget_id_seq'::regclass);


--
-- TOC entry 3329 (class 2604 OID 16849)
-- Name: nugget_comment id; Type: DEFAULT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.nugget_comment ALTER COLUMN id SET DEFAULT nextval('izzup_api.nugget_comment_id_seq'::regclass);


--
-- TOC entry 3323 (class 2604 OID 16734)
-- Name: nugget_type id; Type: DEFAULT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.nugget_type ALTER COLUMN id SET DEFAULT nextval('izzup_api.nugget_type_id_seq'::regclass);


--
-- TOC entry 3332 (class 2604 OID 16858)
-- Name: response id; Type: DEFAULT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.response ALTER COLUMN id SET DEFAULT nextval('izzup_api.response_id_seq'::regclass);


--
-- TOC entry 3320 (class 2604 OID 16705)
-- Name: service id; Type: DEFAULT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.service ALTER COLUMN id SET DEFAULT nextval('izzup_api.service_id_seq'::regclass);


--
-- TOC entry 3605 (class 0 OID 16636)
-- Dependencies: 237
-- Data for Name: account; Type: TABLE DATA; Schema: izzup_api; Owner: -
--

COPY izzup_api.account (id, uid, created_at, name) FROM stdin;
1	1ab64e24-9ded-405a-a4b7-098be0b2342e	2023-03-07 07:16:01.27951	BrianGmail
2	d65b801c-af12-4ffa-94bc-cd35546abc6a	2023-03-07 16:20:56.343359	BrianUltri
\.


--
-- TOC entry 3606 (class 0 OID 16663)
-- Dependencies: 238
-- Data for Name: account_member; Type: TABLE DATA; Schema: izzup_api; Owner: -
--

COPY izzup_api.account_member (account_id, member_id, linked_at, roles) FROM stdin;
1	1	2023-03-07 16:35:00.35755	{reader}
2	2	2023-03-07 16:35:00.35755	{reader}
\.


--
-- TOC entry 3600 (class 0 OID 16584)
-- Dependencies: 232
-- Data for Name: block; Type: TABLE DATA; Schema: izzup_api; Owner: -
--

COPY izzup_api.block (id, uid, created_at, updated_at, json_data, locale, pub_at, un_pub_at, account_id) FROM stdin;
\.


--
-- TOC entry 3612 (class 0 OID 16793)
-- Dependencies: 244
-- Data for Name: block_type; Type: TABLE DATA; Schema: izzup_api; Owner: -
--

COPY izzup_api.block_type (id, name, created_at) FROM stdin;
\.


--
-- TOC entry 3598 (class 0 OID 16573)
-- Dependencies: 230
-- Data for Name: member; Type: TABLE DATA; Schema: izzup_api; Owner: -
--

COPY izzup_api.member (id, uid, created_at, email, tel, username, password) FROM stdin;
1	69023f41-fbd2-4866-9bc3-ea02cacea79d	2023-03-07 16:16:30.344321	brian@ultri.com	\N	\N	\N
2	188715cf-6960-4b2c-8916-75e1d96d7117	2023-03-07 16:16:30.344321	bwinkers@gmail.com	\N	\N	\N
\.


--
-- TOC entry 3601 (class 0 OID 16596)
-- Dependencies: 233
-- Data for Name: nugget; Type: TABLE DATA; Schema: izzup_api; Owner: -
--

COPY izzup_api.nugget (id, uid, created_at, updated_at, pub_at, un_pub_at, public_title, internal_name, account_id, nugget_type_id) FROM stdin;
\.


--
-- TOC entry 3603 (class 0 OID 16622)
-- Dependencies: 235
-- Data for Name: nugget_block; Type: TABLE DATA; Schema: izzup_api; Owner: -
--

COPY izzup_api.nugget_block (nugget_id, blocks, updated_at, name) FROM stdin;
\.


--
-- TOC entry 3615 (class 0 OID 16846)
-- Dependencies: 247
-- Data for Name: nugget_comment; Type: TABLE DATA; Schema: izzup_api; Owner: -
--

COPY izzup_api.nugget_comment (id, uid, "created_at ", account_id, nugget_id) FROM stdin;
\.


--
-- TOC entry 3613 (class 0 OID 16836)
-- Dependencies: 245
-- Data for Name: nugget_member; Type: TABLE DATA; Schema: izzup_api; Owner: -
--

COPY izzup_api.nugget_member (nugget_id, member_id, linked_at, roles) FROM stdin;
\.


--
-- TOC entry 3618 (class 0 OID 16873)
-- Dependencies: 250
-- Data for Name: nugget_reaction; Type: TABLE DATA; Schema: izzup_api; Owner: -
--

COPY izzup_api.nugget_reaction (nugget_id, account_id, member_id) FROM stdin;
\.


--
-- TOC entry 3610 (class 0 OID 16731)
-- Dependencies: 242
-- Data for Name: nugget_type; Type: TABLE DATA; Schema: izzup_api; Owner: -
--

COPY izzup_api.nugget_type (id, name, account_id, created_at) FROM stdin;
\.


--
-- TOC entry 3617 (class 0 OID 16855)
-- Dependencies: 249
-- Data for Name: response; Type: TABLE DATA; Schema: izzup_api; Owner: -
--

COPY izzup_api.response (id, uid, created_at, comment_id, response_id, account_id, nugget_id) FROM stdin;
\.


--
-- TOC entry 3608 (class 0 OID 16702)
-- Dependencies: 240
-- Data for Name: service; Type: TABLE DATA; Schema: izzup_api; Owner: -
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
-- TOC entry 3633 (class 0 OID 0)
-- Dependencies: 236
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: -
--

SELECT pg_catalog.setval('izzup_api.account_id_seq', 2, true);


--
-- TOC entry 3634 (class 0 OID 0)
-- Dependencies: 231
-- Name: block_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: -
--

SELECT pg_catalog.setval('izzup_api.block_id_seq', 1, false);


--
-- TOC entry 3635 (class 0 OID 0)
-- Dependencies: 243
-- Name: block_types_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: -
--

SELECT pg_catalog.setval('izzup_api.block_types_id_seq', 1, false);


--
-- TOC entry 3636 (class 0 OID 0)
-- Dependencies: 229
-- Name: member_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: -
--

SELECT pg_catalog.setval('izzup_api.member_id_seq', 2, true);


--
-- TOC entry 3637 (class 0 OID 0)
-- Dependencies: 246
-- Name: nugget_comment_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: -
--

SELECT pg_catalog.setval('izzup_api.nugget_comment_id_seq', 1, false);


--
-- TOC entry 3638 (class 0 OID 0)
-- Dependencies: 234
-- Name: nugget_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: -
--

SELECT pg_catalog.setval('izzup_api.nugget_id_seq', 1, false);


--
-- TOC entry 3639 (class 0 OID 0)
-- Dependencies: 241
-- Name: nugget_type_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: -
--

SELECT pg_catalog.setval('izzup_api.nugget_type_id_seq', 1, false);


--
-- TOC entry 3640 (class 0 OID 0)
-- Dependencies: 248
-- Name: response_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: -
--

SELECT pg_catalog.setval('izzup_api.response_id_seq', 1, false);


--
-- TOC entry 3641 (class 0 OID 0)
-- Dependencies: 239
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: -
--

SELECT pg_catalog.setval('izzup_api.service_id_seq', 21, true);


--
-- TOC entry 3409 (class 2606 OID 16671)
-- Name: account_member account_member_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.account_member
    ADD CONSTRAINT account_member_pkey PRIMARY KEY (account_id, member_id);


--
-- TOC entry 3407 (class 2606 OID 16643)
-- Name: account account_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- TOC entry 3401 (class 2606 OID 16595)
-- Name: block block_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.block
    ADD CONSTRAINT block_pkey PRIMARY KEY (id, uid);


--
-- TOC entry 3417 (class 2606 OID 16798)
-- Name: block_type block_types_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.block_type
    ADD CONSTRAINT block_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3399 (class 2606 OID 16582)
-- Name: member member_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- TOC entry 3405 (class 2606 OID 16629)
-- Name: nugget_block nugget_blocks_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.nugget_block
    ADD CONSTRAINT nugget_blocks_pkey PRIMARY KEY (nugget_id);


--
-- TOC entry 3421 (class 2606 OID 16853)
-- Name: nugget_comment nugget_comment_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.nugget_comment
    ADD CONSTRAINT nugget_comment_pkey PRIMARY KEY (id);


--
-- TOC entry 3419 (class 2606 OID 16844)
-- Name: nugget_member nugget_member_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.nugget_member
    ADD CONSTRAINT nugget_member_pkey PRIMARY KEY (nugget_id, member_id);


--
-- TOC entry 3403 (class 2606 OID 16610)
-- Name: nugget nugget_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.nugget
    ADD CONSTRAINT nugget_pkey PRIMARY KEY (id);


--
-- TOC entry 3425 (class 2606 OID 16877)
-- Name: nugget_reaction nugget_reaction_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.nugget_reaction
    ADD CONSTRAINT nugget_reaction_pkey PRIMARY KEY (nugget_id, account_id);


--
-- TOC entry 3413 (class 2606 OID 16737)
-- Name: nugget_type nugget_type_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.nugget_type
    ADD CONSTRAINT nugget_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3423 (class 2606 OID 16862)
-- Name: response response_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.response
    ADD CONSTRAINT response_pkey PRIMARY KEY (id);


--
-- TOC entry 3411 (class 2606 OID 16710)
-- Name: service service_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- TOC entry 3415 (class 2606 OID 16744)
-- Name: nugget_type uq_nugget_type_name; Type: CONSTRAINT; Schema: izzup_api; Owner: -
--

ALTER TABLE ONLY izzup_api.nugget_type
    ADD CONSTRAINT uq_nugget_type_name UNIQUE (account_id, name);

    
  COMMIT;

EOSQL