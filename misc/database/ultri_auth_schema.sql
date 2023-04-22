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
0f165d16-fa39-4503-8b91-6c0ce1e23e7c	passwordless	1678861565737
44febcf5-2489-4ef3-9751-b45d22bf0428	passwordless	1678939405370
1d6a86c4-94fe-4133-a7ac-4a8eebca66d3	passwordless	1678990757370
229c4c57-d594-46e4-aa63-27379147d0a4	passwordless	1678991389359
236d9ca2-82ef-4ad9-b815-8f0f3e21fdb3	passwordless	1678991476216
c041e99e-574b-49e5-937d-b4a5fbd4c78e	passwordless	1678992516669
c11640b9-2b79-4c36-960e-74f31e634ceb	passwordless	1678992619009
720e6556-d883-4838-b07a-79d73398d1b5	passwordless	1678992752275
9f77b3df-ed08-4a02-a6c9-e5dbd9573c33	passwordless	1678998477147
a3952355-71f4-434d-9f03-0c61950447b4	passwordless	1678998715610
12b3a861-c627-4493-9243-03e6fd274995	passwordless	1678999155999
df50854c-201f-4829-a67a-953e39aa772f	passwordless	1679121013979
3c1f25cd-065b-483e-ae33-339488f263bb	passwordless	1679168108271
b2264e89-9e8d-40ad-a8ab-75c2146c899d	passwordless	1679208870889
d4dcff47-90a8-48ca-a04b-0cbf4b05091b	passwordless	1679461165633
8fe443bc-745c-460a-a9c4-0ae7b261d6c4	passwordless	1679616134943
c8885655-74e3-4594-ad69-2419a2129458	passwordless	1679627538120
386319aa-abdf-42d6-a53b-ee2cc7511a07	passwordless	1680239692320
8840fab2-da8b-4619-a19d-9977891327f2	passwordless	1681424743397
8e40087d-7a40-4b2c-9406-a0e7ffe9c438	passwordless	1681435694829
b3c2f363-3ec9-4a7b-91cd-a3c3765fc269	passwordless	1681435837992
1d194d19-edc7-4959-95f6-d64be45221d2	passwordless	1681436006245
94b483b7-9ee9-47d2-bad9-35ebe2ff934c	passwordless	1681436127591
d8365632-2ab6-4a22-8767-974a62a5fd62	passwordless	1681436354596
45b10c9e-2ace-41c5-803c-a13609ab605b	passwordless	1681440872175
3c4f3865-1c73-48ee-ac86-7eac86a4efa6	passwordless	1681443656891
21d43421-5217-47ed-b58a-809ee035c34b	passwordless	1681452188036
bc4a1662-f92a-455d-a231-d9b651247b4d	passwordless	1681457952206
8ee246e8-9f21-4f02-a7a5-2648a2420f76	passwordless	1681508740716
fb7c1281-1a35-4dfc-8139-bcccc62e750d	passwordless	1681684152985
753d4c7f-8f73-4f9c-adb2-e2b9f917903d	passwordless	1681970012011
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
53dbabb3-bb21-4b20-b22f-f5ac7e854f93	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	RS256	1678854502447
\.


--
-- Data for Name: key_value; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.key_value (name, value, created_at_time) FROM stdin;
refresh_token_key	1000:ae23d319f1d72fb29f04562d29d8111deea60e875f4c0521b179bbe21ba21107d8609f7d2a2e548c2a39e036f8d783d6fd3f6b7b7c910835f9d9d406f393ce49:e248cc23e9ce22d52a068264f8360783fa928176849ac0b67a43adf9ca009879b46ad9a48c166f725880ae2b7ad7347e9c6cd3a18133a695484dce66b5c384ab	1678854502416
TELEMETRY_ID	f5aabb93-7811-47fb-8358-a5bffb6d7742	1678854502837
FEATURE_FLAG	[]	1681864068173
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
0f165d16-fa39-4503-8b91-6c0ce1e23e7c	alisa_abernathy12@example.com	\N	1678861565737
44febcf5-2489-4ef3-9751-b45d22bf0428	bwinkers@gmail.com	\N	1678939405370
1d6a86c4-94fe-4133-a7ac-4a8eebca66d3	ascsacsa@gmail.com	\N	1678990757370
229c4c57-d594-46e4-aa63-27379147d0a4	sdfewfw@sefw.com	\N	1678991389359
236d9ca2-82ef-4ad9-b815-8f0f3e21fdb3	dsvdsvs@sdfwe.com	\N	1678991476216
c041e99e-574b-49e5-937d-b4a5fbd4c78e	wqdqweq@qwdwq.com	\N	1678992516669
c11640b9-2b79-4c36-960e-74f31e634ceb	ewrfewrf@sdf.com	\N	1678992619009
720e6556-d883-4838-b07a-79d73398d1b5	ewfewfw@dsfvds.cvom	\N	1678992752275
9f77b3df-ed08-4a02-a6c9-e5dbd9573c33	dfgvvdsf@werfewd.com	\N	1678998477147
a3952355-71f4-434d-9f03-0c61950447b4	asedwqada@sadf.com	\N	1678998715610
12b3a861-c627-4493-9243-03e6fd274995	sdfsdfds@ergerg.vom	\N	1678999155999
df50854c-201f-4829-a67a-953e39aa772f	emie19@example.com	\N	1679121013979
3c1f25cd-065b-483e-ae33-339488f263bb	rylee36@example.net	\N	1679168108271
b2264e89-9e8d-40ad-a8ab-75c2146c899d	jimmie.zemlak66@example.org	\N	1679208870889
d4dcff47-90a8-48ca-a04b-0cbf4b05091b	maymie_fadel98@example.com	\N	1679461165633
8fe443bc-745c-460a-a9c4-0ae7b261d6c4	sarina.ratke@example.net	\N	1679616134943
c8885655-74e3-4594-ad69-2419a2129458	knownuser@example.net	\N	1679627538120
386319aa-abdf-42d6-a53b-ee2cc7511a07	knonwuser@example.net	\N	1680239692320
8840fab2-da8b-4619-a19d-9977891327f2	erick.bednar18@example.com	\N	1681424743397
8e40087d-7a40-4b2c-9406-a0e7ffe9c438	marian.kuvalis@example.net	\N	1681435694829
b3c2f363-3ec9-4a7b-91cd-a3c3765fc269	devon32@example.com	\N	1681435837992
1d194d19-edc7-4959-95f6-d64be45221d2	rubye_mclaughlin21@example.org	\N	1681436006245
94b483b7-9ee9-47d2-bad9-35ebe2ff934c	petra65@example.com	\N	1681436127591
d8365632-2ab6-4a22-8767-974a62a5fd62	lukas.ondricka@example.com	\N	1681436354596
45b10c9e-2ace-41c5-803c-a13609ab605b	kamille.purdy@example.org	\N	1681440872175
3c4f3865-1c73-48ee-ac86-7eac86a4efa6	chad.ondricka64@example.org	\N	1681443656891
21d43421-5217-47ed-b58a-809ee035c34b	lindsey39@example.com	\N	1681452188036
bc4a1662-f92a-455d-a231-d9b651247b4d	mozell_johnston20@example.org	\N	1681457952206
8ee246e8-9f21-4f02-a7a5-2648a2420f76	knownuser2@example.net	\N	1681508740716
fb7c1281-1a35-4dfc-8139-bcccc62e750d	ewfew@example.net	\N	1681684152985
753d4c7f-8f73-4f9c-adb2-e2b9f917903d	employee1@example.net	\N	1681970012011
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
1681684153602	MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAl1G/vURNpUQmIzu/f9M2ro4p62lDmBi6uIHOcI5Upd+zCxcmZapeJ5yQL3Zj/trKsDgKwCVctQPz8XcuNkWSOzHSWrxpE6DxDVt6JfljX1Ws5H3r9ht8K9c26KLccDwXBSyiAEfv4EWSPM9BYA8D3BCYS/0nt8wZJ2iAN0xcMwC2u3K8ZtaXiNMb4mkXaO05J9n2dCwL5SMNvMM1fNZvW63YtO2wa/zzmCrP3b+KJCq0hFaRd4SdYOQxreuOzTOQluquApgMFmVBzvfSfeY29y2d1B5bX51HF4Q/Pm8oBbvC+QvcRhKGdcm7aRlanOKk/QT4V+GxqTOyDcIsnsT/1QIDAQAB;MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCXUb+9RE2lRCYjO79/0zaujinraUOYGLq4gc5wjlSl37MLFyZlql4nnJAvdmP+2sqwOArAJVy1A/Pxdy42RZI7MdJavGkToPENW3ol+WNfVazkfev2G3wr1zbootxwPBcFLKIAR+/gRZI8z0FgDwPcEJhL/Se3zBknaIA3TFwzALa7crxm1peI0xviaRdo7Tkn2fZ0LAvlIw28wzV81m9brdi07bBr/POYKs/dv4okKrSEVpF3hJ1g5DGt647NM5CW6q4CmAwWZUHO99J95jb3LZ3UHltfnUcXhD8+bygFu8L5C9xGEoZ1ybtpGVqc4qT9BPhX4bGpM7INwiyexP/VAgMBAAECggEBAI+zxOFbIlnWtFk1fpFH5mAzBkBYQScKJRjfvUtK/7xfCst3erGF79CycIOCbUg0Q9TCBAOh9764OEySIELOIycwE1K0Jx3K8+D5hLDXe7WnyX9czl90jqGbyrt3Ht0/U6VIU7jsmDNmHpC9SpqM599vqxJPIg78Ns8kAM+DJvQPNYkiT5wMdB/NbDJRN9yXYBlkgulm1BQCiML++JgQvSQ0QLXGn2UcnHnlwqaZX7LWjA1d2DRuKyXAHlbld62V9MgP7VRvLJqaoXXD2djxVgZPGBDteie41EguD+dumIjgyGUbK9VHxJixXe0SCLSKuCYUpICmmPcbRCDWjs07BQECgYEA8lDZqTbEO1BfU1YS/ciry5izX+of7v5b0jcIYsKqiSJWNngsSJl5pSFnDG3TETwhor3W/Dwc3ZbHqsHfCS4rQnhL1Zxa7tLvcZroQe+ORlnw2A4u7lVnKjrpYYf6uT8KKn17FmPKEMgN7i5iTx2kQsXp7S3Y6qoFy3mhNxErROECgYEAn91dxGSdMI++0TH+104LEIO0hs1mDAaHq+gFW1cYLOsk0r2Vwl02IJdIdFJVPEBrdnfJrCRFVuspBc+51c8E34oDq+8I7e/9PMh6R7159e4TEA7qDszx11PMDUfD8RxLCf3/jAZyxN1qGhZtm6W6w+jijMiafqEuuft//BxKJXUCgYEA1TXAnzx6I3qPteMZqMYmK2m8AxwdZwvWPTyBG20P4sQcuaa5yFOKjnq6klwcCKExM2H4xU4bU/p0y1H07r36AG2axGTkOhnN59cWn9WqCUrgOSsZrknlEWpuqYudV9wZFNP+NvAs/uEYKMgVZmm9e6drMm9R2wEpQiVObgakXOECgYAPAbCzpt46mMPIz3CktWbEfhiMLuvNZS+HK5iVIm/ah5hFUBam0CkslgbvJGtr5IAx9ryvtBfuONT4/q7rKyvB8Cq4ERA9hbG36vnPkjHIrDiN4ViHWyW4mN0mwf3avFUu8vDyLAjKAh7bpA9V9RC7IzlhDdOy316LhthUyjMLoQKBgEL0ZXzeVaHk5FzCwL6Kk46EVpkZMvevRRXYYXtVZgG8riIOGhOOEEBUe1CTcphQcoq0RZyTA2kAODOwHCUhUcRMFbHnrmYTQZMgOZnfGsYJrQ9+GyxJNPuMzsz/eqZB5iFs949j+MI3ar8kfnPHv/bTMYYENNBbggfFCv5/3YkS
\.


--
-- Data for Name: session_info; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.session_info (session_handle, user_id, refresh_token_hash_2, session_data, expires_at, created_at_time, jwt_user_payload) FROM stdin;
97dbf71f-bcca-4961-96b0-3ba01776cf03	0f165d16-fa39-4503-8b91-6c0ce1e23e7c	5f785609ae27d806bfccab65b021322ae43b73e7fea561444917a7e83109ef8e	{}	1687501565940	1678861565940	{}
55d4c9a2-6418-4b12-9c7b-b18dbf453b68	c8885655-74e3-4594-ad69-2419a2129458	5d3e447b2f1c1d8ecf2d8af24c8cdf49076e225bb9f7fb413d6c8248c908d236	{}	1688870607703	1680230607703	{}
42ac476a-e69d-4656-a7f6-f7df99e75eb2	386319aa-abdf-42d6-a53b-ee2cc7511a07	8d72a957123d1f19fbb5319de27751b5c68808474e4418c24156c036b3276ce0	{}	1688879692374	1680239692374	{}
fc683f47-223d-4e11-8ea6-69466ef3ad07	12b3a861-c627-4493-9243-03e6fd274995	e4ecc8a8e9ab27de3d2b48e94bc7a64a7785443d32ef4abe4870c6019a293b00	{}	1687639156040	1678999156040	{}
e7b12d69-245e-4c68-ad63-4c31c17f50e5	df50854c-201f-4829-a67a-953e39aa772f	a6ca4ddcc061f34e92b994c2db1d4f096007d7ed5deb77aa86339e632f5bfa2f	{}	1687761014215	1679121014215	{}
16da8f21-fc14-498f-b25e-a0bf84a194a7	df50854c-201f-4829-a67a-953e39aa772f	5d4d0f48734a186c3494ffe0130acdcb3aba9556fb0fc5437a05d8ab4e4e09f0	{}	1687766095265	1679126095265	{}
4214faec-ce0a-4bb5-af85-c9d3a4ab2378	3c1f25cd-065b-483e-ae33-339488f263bb	7f5f69b63f5a8801793967ccfa986a5b794f7fc2486f565812f47108adb87f42	{}	1687808108337	1679168108337	{}
adc76d00-e647-47db-87cc-2bdae1ee4645	b2264e89-9e8d-40ad-a8ab-75c2146c899d	9839bd05c74ce18c6bab28a1d129ca7ec1a6ead0a5eeb5a24d6fa03e3f3caaa0	{}	1687848870965	1679208870965	{}
b4e080ac-05de-48ec-af22-8e350af7429d	d4dcff47-90a8-48ca-a04b-0cbf4b05091b	1d92a06178fa2a652a2c37c43c9a3dbd2cbe78866e6d3e0141a2bddf95fc3dac	{}	1688101165690	1679461165690	{}
c79240f3-f3c7-4823-91b5-676241159620	8fe443bc-745c-460a-a9c4-0ae7b261d6c4	dc02a53e25b8accaf6262eeec478398927c8707e81efd9a8b4801832d3f27736	{}	1688256135018	1679616135018	{}
12f28cbe-5786-454b-8226-f906da6f80a7	c8885655-74e3-4594-ad69-2419a2129458	b02ff52871dad910921a3fe6f30133ffbf16dcf7d1adb36a282a20a79735f863	{}	1688267538164	1679627538164	{}
2a72a420-39ac-4822-9db5-6418bc9b07c6	c8885655-74e3-4594-ad69-2419a2129458	d008a79e5927446fc499c18b5e2b8833243a2992c9c2bcaab69da8d89ac54bc0	{}	1688273290307	1679633290307	{}
c359cbf3-ab0f-4d29-8a61-a44ae6be76c9	c8885655-74e3-4594-ad69-2419a2129458	80f5209e24da471a85098668467448916675aa3911cca085ae9d8b410f0e7337	{}	1688280518056	1679640518056	{}
19bcfa54-fe2d-42c9-ac31-c8f82aaa302a	c8885655-74e3-4594-ad69-2419a2129458	4f14fc2e70065ca66bc6ce62e1e18454f51c8abc8c385e07aa1c194a5e7898f3	{}	1688284242443	1679644242443	{}
3ec62f2a-0b31-429f-af6d-6c0320365145	c8885655-74e3-4594-ad69-2419a2129458	098e6a2563b06181b42cdacf241815774a6066e78824cd9ad69fefc409841803	{}	1688334694145	1679694694145	{}
166a603e-aaca-47cc-9e2c-90bfc2a1a9e7	c8885655-74e3-4594-ad69-2419a2129458	ee5e40058085f23ef8260bf3ad79df116f5932918e5796360e2829c1e93dd0b0	{}	1688501939699	1679861939699	{}
7235b52a-9901-4131-85b4-392b16e63fec	c8885655-74e3-4594-ad69-2419a2129458	3ec69fa8633b805839e398f911f3c16f298220247b3753a2f1e6f397dcf3f02a	{}	1688617464662	1679977464662	{}
10bc73d6-200d-4194-b6ad-39b6707afcc9	c8885655-74e3-4594-ad69-2419a2129458	72f2277cb7bd62f63d9b1d2eda76377d37270443ac589659b549a231522958f8	{}	1688624796709	1679984796709	{}
009a8dcd-0178-4f19-b851-0f6edd959634	c8885655-74e3-4594-ad69-2419a2129458	196b1d7324fa6d9c9c7043ea38dcca76b36dec8d20eb126b2a840d4ac287d095	{}	1688712561559	1680072561559	{}
effb80aa-fdd3-4e64-afbf-6d44c592ba54	c8885655-74e3-4594-ad69-2419a2129458	8fb7076f4d4e84012c1d81d9f0b1a6850575a7f98c017a08d0e94f5bf864cb39	{}	1688790913845	1680150913845	{}
60e5297d-7ede-4bfe-969f-9bb50a1a05ec	c8885655-74e3-4594-ad69-2419a2129458	b73d663a37037f56d54d6e41903071de09cbfaafec8af4c31d229f20fb694bff	{}	1688796520672	1680156520672	{}
2ed31fa7-5a4e-425e-9933-ca825968e63d	c8885655-74e3-4594-ad69-2419a2129458	2bf6240fcbee4a48efccadf0b4f815229d05102faa5898007e83ef6292c0814d	{}	1689571727269	1680931727269	{}
6d50d546-780b-4850-ae86-c14e565268d8	c8885655-74e3-4594-ad69-2419a2129458	e11b8cb27c914c5b45d5c91e1a2b869db75811358d118dfc247a72893e3840a1	{}	1689574124380	1680934124380	{}
149a38b0-001e-4e22-8e48-09dc5c5b0049	c8885655-74e3-4594-ad69-2419a2129458	c572651c7ef4de72aec344e0d7d84375ee35169d76b0dc9d7606c18f91d5dd0a	{}	1689574229240	1680934229240	{}
f312bf68-6bac-42b8-9646-f57f85083781	c8885655-74e3-4594-ad69-2419a2129458	6aa404eec91d26be804a6c0be82d1298c0fa2a790cd5b0a7548f9c26473e3111	{}	1689743677709	1681103677709	{}
00915386-1091-4ba0-872f-9c056c640888	c8885655-74e3-4594-ad69-2419a2129458	d4f1a1a78f510ca0ae06f15e64ad9787d7a0a71be33aa90d795d758e274bb73f	{}	1689821452354	1681181452354	{}
24051064-3a7a-447c-8064-11f2eced7410	8840fab2-da8b-4619-a19d-9977891327f2	f0457f285e52d233211d612d02f2487097ed09cbb37a9755a10968aa76c9bc06	{}	1690064743444	1681424743444	{}
f6a53db3-6a4a-44b4-accd-99bbf38aa8cb	8e40087d-7a40-4b2c-9406-a0e7ffe9c438	9b2bf0a21b16bfb5cdc6e70aec6966d61e66895d77ed7a7fb5737749a0e92670	{}	1690075694858	1681435694858	{}
d92a0cc4-0422-402a-b620-fe0d3832dfbc	b3c2f363-3ec9-4a7b-91cd-a3c3765fc269	705c4e8e095b1103a2658e8c4a7c602c6dc72b0735b4f908f53c93d605af6c98	{}	1690075838030	1681435838030	{}
a5e0d4d9-63bd-46b0-8f41-ca6d5a8ccc62	1d194d19-edc7-4959-95f6-d64be45221d2	3f05b91cdbe70e5f9abc0c7ad7b729acb1918c1e603992d4089b8d7c6ed32a43	{}	1690076006271	1681436006271	{}
d1ddcc88-ec88-4791-b814-e3415bb95d80	94b483b7-9ee9-47d2-bad9-35ebe2ff934c	6c73455e4ec333cbe11515a740d08cb3a7d75c3baed4677bea71f6ba2a8e7b9f	{}	1690076127627	1681436127627	{}
84eb37f7-42e8-4eb3-b468-af6131140887	d8365632-2ab6-4a22-8767-974a62a5fd62	c09f3ad7ff72104f4093e2b9cd753d3dc9bed48651f36e85a9563f9ff8a96105	{}	1690076354634	1681436354634	{}
cfe62a31-00dc-46f5-935a-aa2738d1b5f2	45b10c9e-2ace-41c5-803c-a13609ab605b	21ec025cb5e2db54b9e4fbe820eb707818253f4dee95f2f4c586c810997435e1	{}	1690080872206	1681440872206	{}
d492f72c-3dc2-4ebe-819b-ed39af2c5d96	3c4f3865-1c73-48ee-ac86-7eac86a4efa6	0a863b029e5d2ebfdb076d5f612054aeca5acfd06274b93a71cd6116ace04775	{}	1690083656929	1681443656929	{}
1eed2cc2-9832-412c-9879-21d12860d407	c8885655-74e3-4594-ad69-2419a2129458	6cca9bec4bb26efe39be4a2fbfa3d81b4ecb2d010b82b5cff970a9c030093474	{}	1690091533104	1681451533104	{}
3331cd09-7c14-44f4-ba6a-350580b1a9fc	21d43421-5217-47ed-b58a-809ee035c34b	30c4c24b075525f513696fadb4ae37de8c5e3eee50068143ccdad90c921b369a	{}	1690092188078	1681452188078	{}
df73c998-4f91-4b36-876f-9ee5f8c6f3a8	bc4a1662-f92a-455d-a231-d9b651247b4d	43f0cc9212ba283c3048fd5cdee7baedde0c198ec2534db545ef6dff495b0d0e	{}	1690097952266	1681457952266	{}
9517db5b-780f-4d6c-9bc3-d452135de7cd	8ee246e8-9f21-4f02-a7a5-2648a2420f76	3dffacb6af88fa633bfa8ba37e0d648978b0eb5308fdeaed6f52f85249d3f2b6	{}	1690148740746	1681508740746	{}
41c60553-0897-4809-9d54-0c7f97034bc7	8ee246e8-9f21-4f02-a7a5-2648a2420f76	163bae3d85f73ba14b9a6fc031421afe918e9e27997e62ec59ee02112e638998	{}	1690343439737	1681703439737	{}
969f1a64-2819-476e-8e6f-ffca483a1702	8ee246e8-9f21-4f02-a7a5-2648a2420f76	898ec250542381f2429826dda5fdce3ad416aa0a759cd54eae7be529b2609a6f	{}	1690441865456	1681801865456	{}
294ac883-3507-442c-bc8a-7d3b3b2dcf5c	8ee246e8-9f21-4f02-a7a5-2648a2420f76	a79f961397e87a546951e8d9e44c876db891695fc5f39f44c53f3fd3f74efa00	{}	1690520427771	1681880427771	{}
bf1c3ebc-77f6-4406-b810-239c5a1b90a6	8ee246e8-9f21-4f02-a7a5-2648a2420f76	c90cca8a59fd8c4ac9085d73d6b5c281a7eab1e77358464277b9f9e5e39471e4	{}	1690591546761	1681933444937	{}
1e1bc8a5-5456-4dff-a89e-4c26cad38460	8ee246e8-9f21-4f02-a7a5-2648a2420f76	ae2a2c99eb5d149d736afc97fb27e8c9bda941c6241508dbf0b49c59f2648231	{}	1690593971628	1681953971628	{}
535d25bb-2a3d-48f6-8686-9abff3da87d7	753d4c7f-8f73-4f9c-adb2-e2b9f917903d	ce9b73e5059c395210c7b6becd7561abb9b077626db1c65ffffe9c99bc80ffef	{}	1690610012074	1681970012074	{}
edc7110d-1129-4402-ab98-6a030e84d7e6	8ee246e8-9f21-4f02-a7a5-2648a2420f76	f26351062d83216d0f617568564fe3dcca1dca79bf3f13d8f2e071fb59bc21a1	{}	1690611195736	1681971195736	{}
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
-- Name: passwordless_codes passwordless_codes_link_code_hash_key; Type: CONSTRAINT; Schema: ultri_auth; Owner: ultri_auth
--

ALTER TABLE ONLY ultri_auth.passwordless_codes
    ADD CONSTRAINT passwordless_codes_link_code_hash_key UNIQUE (link_code_hash);


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

CREATE INDEX passwordless_devices_email_index ON ultri_auth.passwordless_devices USING btree (email);


--
-- Name: passwordless_devices_phone_number_index; Type: INDEX; Schema: ultri_auth; Owner: ultri_auth
--

CREATE INDEX passwordless_devices_phone_number_index ON ultri_auth.passwordless_devices USING btree (phone_number);


--
-- Name: role_permissions_permission_index; Type: INDEX; Schema: ultri_auth; Owner: ultri_auth
--

CREATE INDEX role_permissions_permission_index ON ultri_auth.role_permissions USING btree (permission);


--
-- Name: user_roles_role_index; Type: INDEX; Schema: ultri_auth; Owner: ultri_auth
--

CREATE INDEX user_roles_role_index ON ultri_auth.user_roles USING btree (role);


--
-- Name: passwordless_users new_user_member_account; Type: TRIGGER; Schema: ultri_auth; Owner: ultri_auth
--

CREATE TRIGGER new_user_member_account AFTER INSERT ON ultri_auth.passwordless_users FOR EACH ROW EXECUTE FUNCTION izzup_api.new_member_from_user();


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
-- Name: SCHEMA ultri_auth; Type: ACL; Schema: -; Owner: ultri_auth
--

GRANT USAGE ON SCHEMA ultri_auth TO izzup_api;


--
-- Name: TABLE passwordless_users; Type: ACL; Schema: ultri_auth; Owner: ultri_auth
--

GRANT SELECT ON TABLE ultri_auth.passwordless_users TO izzup_api;


--
-- PostgreSQL database dump complete
--

