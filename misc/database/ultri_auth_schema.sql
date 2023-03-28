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
53dbabb3-bb21-4b20-b22f-f5ac7e854f93	MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAg1YfWHa/Phb/+U5tjLXu+4zSBzDEftXRJr3v8aK/t9XymAH2ZKb9dWFepBDi2gQD/rlnx5yLCPmIx6pYI1sSJ8qfuZ+tijgaoG7onzySKKcK6r8nPT3s2Y1FXCMgwR5isawaeUkSEdxloU9jSlgXl1VZP0VSHIHo+bVidXqKdzYvNJlJ/U88C8FTIEl5ulzyBxV2/kB2rfMfPJOGlkBk2JyVq17H66eEQlqiXp2OJgNTvgo+mOt6B4XVpKdQ3KjgT2kP7xz1s/6UAIUdPcBfFL6sdmWnaVYSEKnTwgt18TC8tKUskAsbs2RRfQsv0K+DqtBJJ59jfeOethXNMRF7+wIDAQAB|MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCDVh9Ydr8+Fv/5Tm2Mte77jNIHMMR+1dEmve/xor+31fKYAfZkpv11YV6kEOLaBAP+uWfHnIsI+YjHqlgjWxInyp+5n62KOBqgbuifPJIopwrqvyc9PezZjUVcIyDBHmKxrBp5SRIR3GWhT2NKWBeXVVk/RVIcgej5tWJ1eop3Ni80mUn9TzwLwVMgSXm6XPIHFXb+QHat8x88k4aWQGTYnJWrXsfrp4RCWqJenY4mA1O+Cj6Y63oHhdWkp1DcqOBPaQ/vHPWz/pQAhR09wF8Uvqx2ZadpVhIQqdPCC3XxMLy0pSyQCxuzZFF9Cy/Qr4Oq0Eknn2N94562Fc0xEXv7AgMBAAECggEAAM48bvx7e9QESfEzNtO+3Yglmamw6t5A5C3yFNdcubH0RP5uFnv3vgqU3AjGe3Pe2mckvdK1/54YOrFOzRi36cqSZD8Yf2qMr0M+5gsnElzD8mCtyvBgTY1SSZhlkQmwrUpS9z99fuKNNQoZn9Eeg+0gGQVB1a7uUOnN6s6Pnt+R18Rlp60LOK27RdT4HPTyQHYNkNV2jpN+lBYloSYZ65Imh8w25i9SqZI5SSQm2KVt8r7LNO92yjPgMtNVAeuI64lEkNtoNzmoRUzhtzSg1dMkujYcHD4oIuxsJvTBZtIRNs6qqO8vz53BZ0rhQWlk6fnlmov56MG/0WLUpv274QKBgQD+Fx54NpBQpcqrP99sJPvUNLQdTBNBaieJfBKA9QC09gwQI3J1Xt0bg9P3h1LL3qg54X+NU0idasyp1gmGo2dp/bYT76DybNtcNMXn6K6ND0gQN8w/c3I+FVfi9whVX1SY/+t8nw8tRNf1NvG2hqBBthh9mVAuwGBpYmKUkJ1+EwKBgQCEUtHLXJbdkKj+wvd2EYVIOp+9v4gGHY23IhyV/6tD1ch/Mh2M4fuKkBxpBDo1q8wTYczzrF+Iw8gzAJZBJc5M4X/5XwYnz389jeDzDEDrNJnrnty0J2Q5Ly7eFZQX7KBBt1k7BXW5s5m4lOJbz2CQDGaM3YrGvbrh0WBpI2QneQKBgD0BYgBs4VNrqvBY4pS9gHUfvkr2c/0Vtq5syqiJqoTIOnc5e4awoxezHBZnODrYl71l5dERuPKKrN7uE9VusCqjjq7Urujlt/k4dnfKxvX5QE0ciH6HgltjlnlY5HhS7iXZ9Dk0m1k8GTm32mr/gcSlKtYlFDpVWBCVXaPb4ORfAoGAb28rnF4Z8vc7Smi4a2bv3lb4ZZxhmfzTdpE0j6GjAlqMIYn71sQMyLD6K/pSZxaJoxzus5rLTWrLMyBgaPbEmHwjAMfkcCxPFHBiK2x7U1iV8xZy+QhfX8T7bC2x7L/qac1VSN4dOUklwIspYXXv9P9scV602w+2zSs9TO1wD8kCgYEAkyN6nlkXCCRLaOuU+KRacoN8YESoTIe5OJhDWLMjagGKECGC+r2F5FSMMZLSaxJmaxL7dzgIGYysgNadXT3MdeNwr3lCXYL2IOqJeXmqCAkbHbDmu/dRdOy7D4/XiuJKaz3c9d8fFODcn9SQNZS3pYwAbjwtkQ7FJ2aNExAtzns=	RS256	1678854502447
\.


--
-- Data for Name: key_value; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.key_value (name, value, created_at_time) FROM stdin;
refresh_token_key	1000:ae23d319f1d72fb29f04562d29d8111deea60e875f4c0521b179bbe21ba21107d8609f7d2a2e548c2a39e036f8d783d6fd3f6b7b7c910835f9d9d406f393ce49:e248cc23e9ce22d52a068264f8360783fa928176849ac0b67a43adf9ca009879b46ad9a48c166f725880ae2b7ad7347e9c6cd3a18133a695484dce66b5c384ab	1678854502416
TELEMETRY_ID	f5aabb93-7811-47fb-8358-a5bffb6d7742	1678854502837
FEATURE_FLAG	[]	1679632595874
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
1678854502187	MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA17bvSQdiZ8GN1yR96YXrWdHjunmOBWMuuGGU1DJBPsT2ldbr1XO4CIQYxx80P89of3yPZqU1sP1rR2Ozc+CICC0Yn6NDqFoPtwQLDC6xMHVobR+edGqhukj6eAa4fMvvh6N0tuEfvlokgrDY8KzX+lhXQaWo3nADBh0uhEjEavcQ8DNkPcjj01K+dd5R1v8fiKqjJqWDqhqAdm2iBquIUT99dyuiwI6aMaT4rDeL2uUtPlJU/LV73CJaymmW/ExAUQ/oNptwLRHjOPDCchFxSSJbdlt4gdcWwuGzm63OtN4CRNt5OtPOshRZWKgAdYJT/Eo9FoG4OwH0ruxF5/nimQIDAQAB;MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDXtu9JB2JnwY3XJH3phetZ0eO6eY4FYy64YZTUMkE+xPaV1uvVc7gIhBjHHzQ/z2h/fI9mpTWw/WtHY7Nz4IgILRifo0OoWg+3BAsMLrEwdWhtH550aqG6SPp4Brh8y++Ho3S24R++WiSCsNjwrNf6WFdBpajecAMGHS6ESMRq9xDwM2Q9yOPTUr513lHW/x+IqqMmpYOqGoB2baIGq4hRP313K6LAjpoxpPisN4va5S0+UlT8tXvcIlrKaZb8TEBRD+g2m3AtEeM48MJyEXFJIlt2W3iB1xbC4bObrc603gJE23k6086yFFlYqAB1glP8Sj0Wgbg7AfSu7EXn+eKZAgMBAAECggEAdkNq6KTNxIiPFPaCuXacU0AJFAD0Zeu8f4WwLK3oq1scvYV5AitRKAoT84ceBCXX6p0FmYbV6tTk7dyxU8QzkBf5OfwuaawGlZX34JPwvNqBh+If4z9ar2C3QPqeRn0gM0LgCCtgVeHhxmziYwC/4BZysCD8dgb/AWkaSZgDZ4hOUVSSUQeckcjH9KK2EBhW1Y/QXPB/UG6JyMLONz47Yl8jz0h7nl/KoMzQM4EU771++KnFaH5cYtZfTWLepIObvtLe7odch1iYoXCQm5vNbMpI9i2I4enfMnfXBVf0iucM3nMwXj6S3DY+yq9czO9m9WUPfsNKmgUNVRHXl9eVIQKBgQD7l94AEF5l4m2253L6RoUVj78VysTBosaVbMFUbyy6RrCM7kKd8H6VufeTIbLdWPGQrOCCXXJg3HUYQn09RT7wxG93mXrqaFY6Ds0TzLhKgrSOufmJncTTq8/TZVmwTXip+F0u6ivpBJRZ5oHuUxXIB0jXv0YI/2pe4+PPWGR4LQKBgQDbfjB1QG0IA0vCVZX5DZaW1WeZLlQ80EuuHC30zNRirY9Adau1jGwfMjaAmXUTKcxnq9gt8rJ2YAA8efiphOBOv400SKpltyFvGIvkQL2mG7eAjWztMvfDdx8IO1oTd9Q2BFwZUEdU74MVOjd1nHHZM0NlK8eNVkyJDYPOSSNLnQKBgQCamyOYJHbt4ywKtsYIGGfV7SS+roEkgPPJhTB0w3DX83Kw2AVl6xDOz53c81tn/C1N+35nfic4cKEgTFOL4E6iRAQ/mbhX7c/3E3tgjHA/kXyFLLG0qJf4f19SB7kKx0C8KlyQ5OQg6GiFqknz+2iqKBfSRL8z7kkekKpAk5AB7QKBgDQLtAnZgQEJZwlpqeooYrDZYXtdFPRmn8tlOzB08VeEuBccz954sZqkGXBc8vncS2+5u8UJa2/OS8ALW/82VsnVefIP2PfNeMwTEfjJsS6WG+kLn+yOzVk4Ac+94xoCq/szBXOrKX7mXDrIVyY4Nna+RRjUTLki4XsODVb42LmxAoGBANHA5GPFUxjtu5UoeILLv3kxF7halkHug/R562tXP5Y7EYmJZkOSkretNHAovxrxI4mPhICT5cv273cYfWfhKwpUT6nayEbdyOgifQb5TDhebw/s2bTdt+cn2/onpp0Vk536HperZwPPKti8kGi03TEgGn8RDrxkbXSoiz64tNP+
1679461166238	MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv/XDPT3Bpje6ScEEFH5ukDfOdg8KZbz0Fe933rXkUb5VwXseLXDXEkHrkBIW6Q6VE70LKcPoS6rwuHdHZ75o2tz5qZOcdPAtld6oAl17uOOBYDDEQgLB3JxwaFwSibnB07cssy2AGZKAKtlQPH9e9PcV3gY0c8jQJV+K/p50BMguahGQQ2CUb4usl9HCMGrTPR8/SZIM5RdUSL/h1ziGM89YfzgrEZkuthmxrtKzXxc6HElCYrr2ig0RFUSTzYCl4JJpXdgRDZk6WjR3AMdDFmK68cY7KUPhhwKKFzFG+w/mz+uJAs7yUrUPgGJYYNcr5xV9xOfEsOnw2ALYPn2eMwIDAQAB;MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC/9cM9PcGmN7pJwQQUfm6QN852DwplvPQV73feteRRvlXBex4tcNcSQeuQEhbpDpUTvQspw+hLqvC4d0dnvmja3Pmpk5x08C2V3qgCXXu444FgMMRCAsHcnHBoXBKJucHTtyyzLYAZkoAq2VA8f1709xXeBjRzyNAlX4r+nnQEyC5qEZBDYJRvi6yX0cIwatM9Hz9JkgzlF1RIv+HXOIYzz1h/OCsRmS62GbGu0rNfFzocSUJiuvaKDREVRJPNgKXgkmld2BENmTpaNHcAx0MWYrrxxjspQ+GHAooXMUb7D+bP64kCzvJStQ+AYlhg1yvnFX3E58Sw6fDYAtg+fZ4zAgMBAAECggEBALHfEa2SpvjVVJn470XqLZsXCwmcQD8rimU1AzbsBoe0PZRN+BWVJMT3LkbObEpCR+MFXe2yaXKMEAhuBk1cQ57h+bmnXOeCkkr4CWg/pWAZ94zhQ0oDcg1xLDuXbVoPNUpvxky1UajgdkC+IzobsCp/NdUInNvY7P5kfNAYlVrDYoXQbcihfxfePqj62EUQA2FR2hfgQZ7T8MDeWgeWJP3gl2W1GsOjeowJ556yMsLWye4Qgb9YrC+/ZbJQFPcohTmkEi5WaWRyVYKzhD5iLQp4A0gUEVpjyJ4pur9bQ9phOW5pTPUYQIlsNtfKr06tsAZOMAGcxsN8TY9n+Fbf7kECgYEA89aTb3Zc4vmi6cnptNVQnn5l7g0yfXf731h0PVihnLxVTMOsRw4rkfcl3Ak93ueKz6lyVS1j7mBg4hB6P/FO/buHpJiMQ+lmQ118W8vaDKLOmA6mX9dyapzVEcobRKy+k3Tm71v9rvEEbE86cVRraK5snQf88diwqtzUBcMfcuECgYEAyYjJCV7PMYUp/IxqSISPvS1I/tbPU3ewsuRI6l49BC9cyMZxDnT+vdYKEr64PSxw9wJyKHE0KZpv5h2VSS9sq1F/l31FMUMgM459Z4nvtwhZyhTMqQepRvvW5zinKMQn2nvIW58un4gQxuxeLpkg/NxwRzCzBkYQlqofk1Mah5MCgYEA1S0zmK8SZh15oIs2FzKnWOmIk6ZWDftn6MucVEW4hR7iNEqdw0FQNjysjMJHpSko4oRxwKX+R9la2kktl9mQBaR94hi8CGN1VE/W+SovZ/yuQaINMp1ZGnwii3r2fAPKWYBKpdj24Is2IrrhjVMQ1GQp8N+a9JVNXxPRCXiddgECgYAPKQ0GeW1Yqk3IQ7/TCLXPY1K0aPBbtQtDycx6ZPBuGin+qH7kuYRYP3uugU5Wu7sbucFgrXNhFc8JHnyWbszb7luMx82msQgBGNzyJvwzZptqijoDFSJ0xokaB7b7aBYfZ2RhEA5vzcqFTE6hbr9+hg6kLFOrSyYAT3fkm0HJpQKBgQC3RDlyLuStLLLNZbrk+fWRsQj/4di37H4Fi4Op1nWRr/TtWjSelCTSyS9rMPPhkK6epk3hm1NagfnXSYdg7OkpPga3AX4AA1CuNagP820OCHpRuwoJc9rtamclgC95Fca2nQc6LywuKUUAXrgjQ7ueVAOGaGFmIvdshGAdtMWh9g==
\.


--
-- Data for Name: session_info; Type: TABLE DATA; Schema: ultri_auth; Owner: ultri_auth
--

COPY ultri_auth.session_info (session_handle, user_id, refresh_token_hash_2, session_data, expires_at, created_at_time, jwt_user_payload) FROM stdin;
97dbf71f-bcca-4961-96b0-3ba01776cf03	0f165d16-fa39-4503-8b91-6c0ce1e23e7c	5f785609ae27d806bfccab65b021322ae43b73e7fea561444917a7e83109ef8e	{}	1687501565940	1678861565940	{}
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

