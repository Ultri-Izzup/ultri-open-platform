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
-- Name: ultri_auth; Type: SCHEMA; Schema: -; Owner: ultri_auth
--

CREATE SCHEMA ultri_auth;


ALTER SCHEMA ultri_auth OWNER TO ultri_auth;

--
-- Name: create_api_account(); Type: FUNCTION; Schema: ultri_auth; Owner: ultri_auth
--

CREATE FUNCTION ultri_auth.create_api_account() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

	DECLARE new_account_id BIGINT;
	
BEGIN

	
	INSERT INTO izzup_api.account(name)
		 VALUES('Izzup Member Account')
		 RETURNING id INTO new_account_id;
		
	INSERT INTO izzup_api.account_member(account_id, member_id, roles)
		 VALUES(new_account_id, uuid(NEW.user_id), '{"owner"}');

	RETURN NEW;
END;
$$;


ALTER FUNCTION ultri_auth.create_api_account() OWNER TO ultri_auth;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: passwordless_users; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.passwordless_users (
    user_id character(36) NOT NULL,
    email character varying(256),
    phone_number character varying(256),
    time_joined bigint NOT NULL
);


ALTER TABLE ultri_auth.passwordless_users OWNER TO ultri_auth;

--
-- Name: all_auth_recipe_users; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.all_auth_recipe_users (
    user_id character(36) NOT NULL,
    recipe_id character varying(128) NOT NULL,
    time_joined bigint NOT NULL
);


ALTER TABLE ultri_auth.all_auth_recipe_users OWNER TO ultri_auth;

--
-- Name: emailpassword_pswd_reset_tokens; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.emailpassword_pswd_reset_tokens (
    user_id character(36) NOT NULL,
    token character varying(128) NOT NULL,
    token_expiry bigint NOT NULL
);


ALTER TABLE ultri_auth.emailpassword_pswd_reset_tokens OWNER TO ultri_auth;

--
-- Name: emailpassword_users; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.emailpassword_users (
    user_id character(36) NOT NULL,
    email character varying(256) NOT NULL,
    password_hash character varying(256) NOT NULL,
    time_joined bigint NOT NULL
);


ALTER TABLE ultri_auth.emailpassword_users OWNER TO ultri_auth;

--
-- Name: emailverification_tokens; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.emailverification_tokens (
    user_id character varying(128) NOT NULL,
    email character varying(256) NOT NULL,
    token character varying(128) NOT NULL,
    token_expiry bigint NOT NULL
);


ALTER TABLE ultri_auth.emailverification_tokens OWNER TO ultri_auth;

--
-- Name: emailverification_verified_emails; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.emailverification_verified_emails (
    user_id character varying(128) NOT NULL,
    email character varying(256) NOT NULL
);


ALTER TABLE ultri_auth.emailverification_verified_emails OWNER TO ultri_auth;

--
-- Name: jwt_signing_keys; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.jwt_signing_keys (
    key_id character varying(255) NOT NULL,
    key_string text NOT NULL,
    algorithm character varying(10) NOT NULL,
    created_at bigint
);


ALTER TABLE ultri_auth.jwt_signing_keys OWNER TO ultri_auth;

--
-- Name: key_value; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.key_value (
    name character varying(128) NOT NULL,
    value text,
    created_at_time bigint
);


ALTER TABLE ultri_auth.key_value OWNER TO ultri_auth;

--
-- Name: passwordless_codes; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.passwordless_codes (
    code_id character(36) NOT NULL,
    device_id_hash character(44) NOT NULL,
    link_code_hash character(44) NOT NULL,
    created_at bigint NOT NULL
);


ALTER TABLE ultri_auth.passwordless_codes OWNER TO ultri_auth;

--
-- Name: passwordless_devices; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.passwordless_devices (
    device_id_hash character(44) NOT NULL,
    email character varying(256),
    phone_number character varying(256),
    link_code_salt character(44) NOT NULL,
    failed_attempts integer NOT NULL
);


ALTER TABLE ultri_auth.passwordless_devices OWNER TO ultri_auth;

--
-- Name: role_permissions; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.role_permissions (
    role character varying(255) NOT NULL,
    permission character varying(255) NOT NULL
);


ALTER TABLE ultri_auth.role_permissions OWNER TO ultri_auth;

--
-- Name: roles; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.roles (
    role character varying(255) NOT NULL
);


ALTER TABLE ultri_auth.roles OWNER TO ultri_auth;

--
-- Name: session_access_token_signing_keys; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.session_access_token_signing_keys (
    created_at_time bigint NOT NULL,
    value text
);


ALTER TABLE ultri_auth.session_access_token_signing_keys OWNER TO ultri_auth;

--
-- Name: session_info; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.session_info (
    session_handle character varying(255) NOT NULL,
    user_id character varying(128) NOT NULL,
    refresh_token_hash_2 character varying(128) NOT NULL,
    session_data text,
    expires_at bigint NOT NULL,
    created_at_time bigint NOT NULL,
    jwt_user_payload text
);


ALTER TABLE ultri_auth.session_info OWNER TO ultri_auth;

--
-- Name: thirdparty_users; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.thirdparty_users (
    third_party_id character varying(28) NOT NULL,
    third_party_user_id character varying(256) NOT NULL,
    user_id character(36) NOT NULL,
    email character varying(256) NOT NULL,
    time_joined bigint NOT NULL
);


ALTER TABLE ultri_auth.thirdparty_users OWNER TO ultri_auth;

--
-- Name: user_metadata; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.user_metadata (
    user_id character varying(128) NOT NULL,
    user_metadata text NOT NULL
);


ALTER TABLE ultri_auth.user_metadata OWNER TO ultri_auth;

--
-- Name: user_roles; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.user_roles (
    user_id character varying(128) NOT NULL,
    role character varying(255) NOT NULL
);


ALTER TABLE ultri_auth.user_roles OWNER TO ultri_auth;

--
-- Name: userid_mapping; Type: TABLE; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TABLE ultri_auth.userid_mapping (
    supertokens_user_id character(36) NOT NULL,
    external_user_id character varying(128) NOT NULL,
    external_user_id_info text
);


ALTER TABLE ultri_auth.userid_mapping OWNER TO ultri_auth;

--
-- Data for Name: all_auth_recipe_users; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.all_auth_recipe_users (user_id, recipe_id, time_joined) FROM stdin;
be0f1caf-6fec-4b23-b1bd-56b9fa80408e	passwordless	1678508958786
8696485a-5297-45f6-9454-b7042b92f018	passwordless	1678509244976
a6c440fa-5f17-453f-9cae-71f55a45f1ed	passwordless	1678509327512
62a374a1-6eb4-414b-ad8a-ea18d07bbbbe	passwordless	1678509604070
6434d727-1e01-40f8-9362-79cdf8377939	passwordless	1678509904016
85262ce4-bbbc-477b-8efb-4f96efeff9f8	passwordless	1678510006871
b3f695cd-d1a5-498c-bfbb-1810466658ef	passwordless	1678510098749
a98472c3-8bc2-4158-ab98-da8acf2898a0	passwordless	1678510442283
64582d96-9dda-4117-91ba-666313852bfe	passwordless	1678511572827
\.


--
-- Data for Name: emailpassword_pswd_reset_tokens; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.emailpassword_pswd_reset_tokens (user_id, token, token_expiry) FROM stdin;
\.


--
-- Data for Name: emailpassword_users; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.emailpassword_users (user_id, email, password_hash, time_joined) FROM stdin;
\.


--
-- Data for Name: emailverification_tokens; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.emailverification_tokens (user_id, email, token, token_expiry) FROM stdin;
\.


--
-- Data for Name: emailverification_verified_emails; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.emailverification_verified_emails (user_id, email) FROM stdin;
\.


--
-- Data for Name: jwt_signing_keys; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.jwt_signing_keys (key_id, key_string, algorithm, created_at) FROM stdin;
864ae26a-d8c2-4478-a674-bd173e767cb9	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	RS256	1678506683753
\.


--
-- Data for Name: key_value; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.key_value (name, value, created_at_time) FROM stdin;
FEATURE_FLAG	[]	1678506682726
refresh_token_key	1000:2343dc6320e9bfcadc5bccec84c9c4ef935f4d342b25f1fcfa421118aed81f3a027d67cc962e55f22ee26459ecc724cca3362f2c660cfae7b77fed97fb8fe1ad:6fdd88edd5a0c233d3a44ce7739fd100d9fc0b7b020e99021e3b7a74f59b423dcc02f68965aae6f465c4f4d77b8b88509bfe32bde59c5fb650250200255eea24	1678506683731
TELEMETRY_ID	cd4062cd-b4cc-44cc-9c77-366a754cc479	1678506684111
\.


--
-- Data for Name: passwordless_codes; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.passwordless_codes (code_id, device_id_hash, link_code_hash, created_at) FROM stdin;
\.


--
-- Data for Name: passwordless_devices; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.passwordless_devices (device_id_hash, email, phone_number, link_code_salt, failed_attempts) FROM stdin;
\.


--
-- Data for Name: passwordless_users; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.passwordless_users (user_id, email, phone_number, time_joined) FROM stdin;
be0f1caf-6fec-4b23-b1bd-56b9fa80408e	edwardo_harris71@example.com	\N	1678508958786
8696485a-5297-45f6-9454-b7042b92f018	aryanna.okeefe58@example.net	\N	1678509244976
a6c440fa-5f17-453f-9cae-71f55a45f1ed	victoria9@example.org	\N	1678509327512
62a374a1-6eb4-414b-ad8a-ea18d07bbbbe	gabriella.bergstrom66@example.org	\N	1678509604070
6434d727-1e01-40f8-9362-79cdf8377939	tony62@example.com	\N	1678509904016
85262ce4-bbbc-477b-8efb-4f96efeff9f8	muhammad.macejkovic@example.com	\N	1678510006871
b3f695cd-d1a5-498c-bfbb-1810466658ef	jackeline.larkin76@example.org	\N	1678510098749
a98472c3-8bc2-4158-ab98-da8acf2898a0	kailey_shanahan@example.org	\N	1678510442283
64582d96-9dda-4117-91ba-666313852bfe	daphne9@example.net	\N	1678511572827
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.role_permissions (role, permission) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.roles (role) FROM stdin;
\.


--
-- Data for Name: session_access_token_signing_keys; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.session_access_token_signing_keys (created_at_time, value) FROM stdin;
1678506683558	MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjHk3EP8r9Roh3YDyH63e/ZcPJgawjrb3wwboe2evqAak6R8YUfNktpdpLFqWOtYPS9A0DpHSgVAjLBEsb3W8SjPTwmPQJIQ1t/9iJZ68ytV9XeQ1/Hl7QqWrUHwpn8joK6WcfYRBAYBEDYfhpfDmzElVoI5EFOBh1Fev4i1MLdw5tUdBnPy4TogCLUJqR9Hl+lPrnGc4uNTdAkg/B2ImkuTzWky7ceRuuGlectdMLIXmPPmY4/QQCE7z87yr33zk4Y9BEpf+7Q44X9pGsDkCLeM7LE9ny157fqoQfYTVFccprWaJZShD3HKbKPW4EcLeDRUB8jT6idfCVnpM4IIm7QIDAQAB;MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCMeTcQ/yv1GiHdgPIfrd79lw8mBrCOtvfDBuh7Z6+oBqTpHxhR82S2l2ksWpY61g9L0DQOkdKBUCMsESxvdbxKM9PCY9AkhDW3/2IlnrzK1X1d5DX8eXtCpatQfCmfyOgrpZx9hEEBgEQNh+Gl8ObMSVWgjkQU4GHUV6/iLUwt3Dm1R0Gc/LhOiAItQmpH0eX6U+ucZzi41N0CSD8HYiaS5PNaTLtx5G64aV5y10wsheY8+Zjj9BAITvPzvKvffOThj0ESl/7tDjhf2kawOQIt4zssT2fLXnt+qhB9hNUVxymtZollKEPccpso9bgRwt4NFQHyNPqJ18JWekzggibtAgMBAAECggEBAIgGFImT3hfwXxyjcVG1xvlenl+fGLaJfC9Q8CwXQiP9kxDeeGlau4qH4WL+sPx2Lcem69Gz6NgpJnXUh2fC5TohJ4vTpUjG8VGjrYFqTbxHsKcLhi9d3zqxO8uq/49nN1KUgo2UVHJEpyFHE/zg4kytMopPWKOyh2jcJEdqv5qjcvgBEgVi+PRrJRD0iDMM7OapR+nYHt8MvbaZECG74DbHK8b6XjLV2wMgMV3dvxdhathlD5hKQeH7PxloIVRAmSdIzciejrnF1PocKWfx1nK0ay1Sn/Uu8IwnA3ozuqgQhuXyjKwd8S8QjLlcQezYoewNSuLy5ONc3AB0fYI1JKECgYEA3ukSiuCZoXfLtaraQVtTe1tbOkIDBBClDdPDc+JNLTt3h7G29a1KjJMtKf+SRdl4U++a3G5AXo+xDkQE/W4igqrhgb7z4gP8WPmS6sAp9OjJoBkcluOI+3jw7JLB4b6WoOEIudZcXfz4wiUJIlxAIGK9F7SU2e/Wnc+zmGqVE4kCgYEAoVNqnqSlrC/hxcQmcRfg8k0jNWN5zgMHhNioEEvJsjtl163/gJSZw1JqM8nYp/1L99R9Bv58i0nkCBPR06BceswOkg5GiAsaKdnMkSIgo2yhJMq3hDl9drcyE4e4/Ll02ZCKcr7XuGXfduCO8nIUoWaPSBLyasLYbitfV7JVC0UCgYEAsxruzSueBYEt6vA2oeDxeOJ0sKCtr6x4El4eY5Rnknp/lkYSzd/JUJ5I4b/6Famg50BUW90yV0h5aQ76O28sx3Tp8MgvSWEOd6dAhuKUU7ZfmwXSVOLKA9SvMEbTBcGPYgCudDNq0BIdBlGfvz4EQIFVkiCEoX/2H6LtmP+6fJECgYAdH4j04LZD0lUItbNW4T+rnj9H6RBZH3ThB5e3cWcU9OIawH+Kf8kOWLdxZ/Pjx7dKIyL6+0ASiSFQT/umH6HyTRooRcl3z8FGYtoqLSYFOpwQn0Pn69T5dHLm0a6UeQpeKFjGBCu/Tyy7Mii8HdoZlQEyurDmkwwtP0kz9K6jnQKBgH6WK26uijJH5rXcRuIXtyB/NEAY/OL4INLeciyBpDR7jasKSkm+6edFTI1lUPr4J7efUKExAXBqVEDZQmW36BMYY/RNoe2DzBB9B/5yZCF28OevgchGOWkO7B1KghIJLUlbXbGaJ/FF4NNwERoWWnDjiKV89Z5psih/OkyIFfZr
\.


--
-- Data for Name: session_info; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.session_info (session_handle, user_id, refresh_token_hash_2, session_data, expires_at, created_at_time, jwt_user_payload) FROM stdin;
82857896-842f-4cf1-a151-f8373fbd6d68	be0f1caf-6fec-4b23-b1bd-56b9fa80408e	90fe6f70053ff1230de5cea2fd70096f67439dfdeda036565028544050e3213c	{}	1687148958905	1678508958905	{}
d74990e0-86b6-4ba4-93d5-aa84057f72c2	8696485a-5297-45f6-9454-b7042b92f018	7d443245ac9a1330e8c8b32daeb296fce8a802798fcb5c6c387e944ea3a41248	{}	1687149245007	1678509245007	{}
eaab74e7-54f9-463d-9452-289fa82b6114	a6c440fa-5f17-453f-9cae-71f55a45f1ed	8b6d287093c3bbfd21d8da20ef94d4bf9aad0f622c6186f7a8208b3942a7c0f0	{}	1687149327540	1678509327540	{}
82fbcb82-557e-416e-b892-299286d976be	62a374a1-6eb4-414b-ad8a-ea18d07bbbbe	607307ee6f99facba5ee36005ade97f2cee5ee38512f8a3f90a7725701ef8be3	{}	1687149604130	1678509604130	{}
7d0c56e1-ec99-461f-93f1-0f51ba6d15ad	6434d727-1e01-40f8-9362-79cdf8377939	6a49d9a5313f5d6c79bb3d85c189dbd28a61d2c7ac87f321e204871ce9f8d1ba	{}	1687149904066	1678509904066	{}
12f7d6ad-528d-4b77-8ca6-1ec1e90a1021	85262ce4-bbbc-477b-8efb-4f96efeff9f8	9f34f29b2fb148c8f7eb20006aae5c318deefbd23a83f834c4179e567749957e	{}	1687150006899	1678510006899	{}
ad099ff5-a15e-49b5-8e1c-825c5e7400f8	b3f695cd-d1a5-498c-bfbb-1810466658ef	36e627a3f60243944c1704677f96a8a9ce5d8e0b54f8d3c4641537f5dc6c9ca4	{}	1687150098782	1678510098782	{}
ce452882-8021-4575-9f72-ec0e1b15a045	a98472c3-8bc2-4158-ab98-da8acf2898a0	b3ab53308b30c3309d8f5410a6c4eab2712baa1a8cd28f616dc10ecb122fc787	{}	1687150442316	1678510442316	{}
75938fb3-cfee-48b8-aa4d-a7c0c69058c8	64582d96-9dda-4117-91ba-666313852bfe	f012c6f3637e5f1f69971749028dd0a91b22fea9eef6b9b7cc55f276ea89b146	{}	1687151572866	1678511572866	{}
\.


--
-- Data for Name: thirdparty_users; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.thirdparty_users (third_party_id, third_party_user_id, user_id, email, time_joined) FROM stdin;
\.


--
-- Data for Name: user_metadata; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.user_metadata (user_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.user_roles (user_id, role) FROM stdin;
\.


--
-- Data for Name: userid_mapping; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.userid_mapping (supertokens_user_id, external_user_id, external_user_id_info) FROM stdin;
\.


--
-- Name: all_auth_recipe_users all_auth_recipe_users_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.all_auth_recipe_users
    ADD CONSTRAINT all_auth_recipe_users_pkey PRIMARY KEY (user_id);


--
-- Name: emailpassword_pswd_reset_tokens emailpassword_pswd_reset_tokens_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.emailpassword_pswd_reset_tokens
    ADD CONSTRAINT emailpassword_pswd_reset_tokens_pkey PRIMARY KEY (user_id, token);


--
-- Name: emailpassword_pswd_reset_tokens emailpassword_pswd_reset_tokens_token_key; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.emailpassword_pswd_reset_tokens
    ADD CONSTRAINT emailpassword_pswd_reset_tokens_token_key UNIQUE (token);


--
-- Name: emailpassword_users emailpassword_users_email_key; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.emailpassword_users
    ADD CONSTRAINT emailpassword_users_email_key UNIQUE (email);


--
-- Name: emailpassword_users emailpassword_users_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.emailpassword_users
    ADD CONSTRAINT emailpassword_users_pkey PRIMARY KEY (user_id);


--
-- Name: emailverification_tokens emailverification_tokens_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.emailverification_tokens
    ADD CONSTRAINT emailverification_tokens_pkey PRIMARY KEY (user_id, email, token);


--
-- Name: emailverification_tokens emailverification_tokens_token_key; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.emailverification_tokens
    ADD CONSTRAINT emailverification_tokens_token_key UNIQUE (token);


--
-- Name: emailverification_verified_emails emailverification_verified_emails_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.emailverification_verified_emails
    ADD CONSTRAINT emailverification_verified_emails_pkey PRIMARY KEY (user_id, email);


--
-- Name: jwt_signing_keys jwt_signing_keys_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.jwt_signing_keys
    ADD CONSTRAINT jwt_signing_keys_pkey PRIMARY KEY (key_id);


--
-- Name: key_value key_value_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.key_value
    ADD CONSTRAINT key_value_pkey PRIMARY KEY (name);


--
-- Name: passwordless_codes passwordless_codes_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.passwordless_codes
    ADD CONSTRAINT passwordless_codes_pkey PRIMARY KEY (code_id);


--
-- Name: passwordless_devices passwordless_devices_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.passwordless_devices
    ADD CONSTRAINT passwordless_devices_pkey PRIMARY KEY (device_id_hash);


--
-- Name: passwordless_codes passwordless_link_code_hash_key; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.passwordless_codes
    ADD CONSTRAINT passwordless_link_code_hash_key UNIQUE (link_code_hash);


--
-- Name: passwordless_users passwordless_users_email_key; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.passwordless_users
    ADD CONSTRAINT passwordless_users_email_key UNIQUE (email);


--
-- Name: passwordless_users passwordless_users_phone_number_key; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.passwordless_users
    ADD CONSTRAINT passwordless_users_phone_number_key UNIQUE (phone_number);


--
-- Name: passwordless_users passwordless_users_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.passwordless_users
    ADD CONSTRAINT passwordless_users_pkey PRIMARY KEY (user_id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role, permission);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role);


--
-- Name: session_access_token_signing_keys session_access_token_signing_keys_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.session_access_token_signing_keys
    ADD CONSTRAINT session_access_token_signing_keys_pkey PRIMARY KEY (created_at_time);


--
-- Name: session_info session_info_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.session_info
    ADD CONSTRAINT session_info_pkey PRIMARY KEY (session_handle);


--
-- Name: thirdparty_users thirdparty_users_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.thirdparty_users
    ADD CONSTRAINT thirdparty_users_pkey PRIMARY KEY (third_party_id, third_party_user_id);


--
-- Name: thirdparty_users thirdparty_users_user_id_key; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.thirdparty_users
    ADD CONSTRAINT thirdparty_users_user_id_key UNIQUE (user_id);


--
-- Name: user_metadata user_metadata_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.user_metadata
    ADD CONSTRAINT user_metadata_pkey PRIMARY KEY (user_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role);


--
-- Name: userid_mapping userid_mapping_external_user_id_key; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.userid_mapping
    ADD CONSTRAINT userid_mapping_external_user_id_key UNIQUE (external_user_id);


--
-- Name: userid_mapping userid_mapping_pkey; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.userid_mapping
    ADD CONSTRAINT userid_mapping_pkey PRIMARY KEY (supertokens_user_id, external_user_id);


--
-- Name: userid_mapping userid_mapping_supertokens_user_id_key; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.userid_mapping
    ADD CONSTRAINT userid_mapping_supertokens_user_id_key UNIQUE (supertokens_user_id);


--
-- Name: all_auth_recipe_users_pagination_index; Type: INDEX; Schema: ultri_auth; Owner: ultri_auth
--

CREATE INDEX all_auth_recipe_users_pagination_index ON ultri_auth.all_auth_recipe_users USING btree (time_joined DESC, user_id DESC);


--
-- Name: emailpassword_password_reset_token_expiry_index; Type: INDEX; Schema: ultri_auth; Owner: ultri_auth
--

CREATE INDEX emailpassword_password_reset_token_expiry_index ON ultri_auth.emailpassword_pswd_reset_tokens USING btree (token_expiry);


--
-- Name: emailverification_tokens_index; Type: INDEX; Schema: ultri_auth; Owner: ultri_auth
--

CREATE INDEX emailverification_tokens_index ON ultri_auth.emailverification_tokens USING btree (token_expiry);


--
-- Name: passwordless_codes_created_at_index; Type: INDEX; Schema: ultri_auth; Owner: ultri_auth
--

CREATE INDEX passwordless_codes_created_at_index ON ultri_auth.passwordless_codes USING btree (created_at);


--
-- Name: passwordless_codes_device_id_hash_index; Type: INDEX; Schema: ultri_auth; Owner: ultri_auth
--

CREATE INDEX passwordless_codes_device_id_hash_index ON ultri_auth.passwordless_codes USING btree (device_id_hash);


--
-- Name: passwordless_devices_email_index; Type: INDEX; Schema: ultri_auth; Owner: ultri_auth
--

CREATE INDEX passwordless_devices_email_index ON ultri_auth.passwordless_devices USING hash (email);


--
-- Name: passwordless_devices_phone_number_index; Type: INDEX; Schema: ultri_auth; Owner: ultri_auth
--

CREATE INDEX passwordless_devices_phone_number_index ON ultri_auth.passwordless_devices USING hash (phone_number);


--
-- Name: role_permissions_permission_index; Type: INDEX; Schema: ultri_auth; Owner: ultri_auth
--

CREATE INDEX role_permissions_permission_index ON ultri_auth.role_permissions USING btree (permission);


--
-- Name: user_roles_role_index; Type: INDEX; Schema: ultri_auth; Owner: ultri_auth
--

CREATE INDEX user_roles_role_index ON ultri_auth.user_roles USING btree (role);


--
-- Name: passwordless_users new_izzup_member; Type: TRIGGER; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TRIGGER new_izzup_member AFTER INSERT ON ultri_auth.passwordless_users FOR EACH ROW EXECUTE FUNCTION izzup_api.create_api_account();


--
-- Name: emailpassword_pswd_reset_tokens emailpassword_pswd_reset_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.emailpassword_pswd_reset_tokens
    ADD CONSTRAINT emailpassword_pswd_reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES ultri_auth.emailpassword_users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: passwordless_codes passwordless_codes_device_id_hash_fkey; Type: FK CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.passwordless_codes
    ADD CONSTRAINT passwordless_codes_device_id_hash_fkey FOREIGN KEY (device_id_hash) REFERENCES ultri_auth.passwordless_devices(device_id_hash) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_fkey; Type: FK CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.role_permissions
    ADD CONSTRAINT role_permissions_role_fkey FOREIGN KEY (role) REFERENCES ultri_auth.roles(role) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_role_fkey; Type: FK CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.user_roles
    ADD CONSTRAINT user_roles_role_fkey FOREIGN KEY (role) REFERENCES ultri_auth.roles(role) ON DELETE CASCADE;


--
-- Name: userid_mapping userid_mapping_supertokens_user_id_fkey; Type: FK CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.userid_mapping
    ADD CONSTRAINT userid_mapping_supertokens_user_id_fkey FOREIGN KEY (supertokens_user_id) REFERENCES ultri_auth.all_auth_recipe_users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

