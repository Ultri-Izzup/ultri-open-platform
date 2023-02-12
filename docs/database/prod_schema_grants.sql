GRANT CONNECT ON DATABASE izzup TO izzup_api;
CREATE SCHEMA IF NOT EXISTS izzup_api;
GRANT USAGE ON SCHEMA izzup_api TO izzup_api;
GRANT ALL ON ALL SEQUENCES IN SCHEMA izzup_api TO izzup_api;
GRANT ALL ON ALL TABLES IN SCHEMA izzup_api TO izzup_api;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA izzup_api TO izzup_api;
ALTER ROLE izzup_api SET search_path = izzup_api,public;
ALTER SCHEMA izzup_api OWNER TO  izzup_api;

GRANT CONNECT ON DATABASE izzup TO ultri_auth;
CREATE SCHEMA IF NOT EXISTS ultri_auth;
GRANT USAGE ON SCHEMA ultri_auth TO ultri_auth;
GRANT ALL ON ALL SEQUENCES IN SCHEMA ultri_auth TO ultri_auth;
GRANT ALL ON ALL TABLES IN SCHEMA ultri_auth TO ultri_auth;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA ultri_auth TO ultri_auth;
ALTER ROLE ultri_auth SET search_path = ultri_auth,public;
ALTER SCHEMA ultri_auth OWNER TO  ultri_auth;