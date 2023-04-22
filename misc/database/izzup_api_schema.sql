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
		
	INSERT INTO izzup_api.account_member(account_id, member_id , roles)
		 VALUES(new_account_id, (SELECT m.id FROM izzup_api.member m where m.uid = owner_uid),  '{"owner"}');

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
-- Name: create_member_nugget(character varying, character varying, character varying, uuid, jsonb); Type: FUNCTION; Schema: izzup_api; Owner: izzup_api
--

CREATE FUNCTION izzup_api.create_member_nugget(public_title character varying, internal_name character varying, nugget_type character varying, member_uid uuid, blocks jsonb, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint) RETURNS record
    LANGUAGE plpgsql
    AS $_$
#variable_conflict use_column
BEGIN

	INSERT INTO izzup_api.nugget(
				public_title, 
				internal_name, 
				nugget_type,
				account_id,
				blocks
				)
			VALUES (
				$1, 
				$2, 
				$3,
				izzup_api.get_member_account($4),
				$5
				)
 	RETURNING id, uid, created_at, account_id INTO id, uid, created_at, account_id;

	

	
END; 
$_$;


ALTER FUNCTION izzup_api.create_member_nugget(public_title character varying, internal_name character varying, nugget_type character varying, member_uid uuid, blocks jsonb, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint) OWNER TO izzup_api;

--
-- Name: get_member_account(uuid); Type: FUNCTION; Schema: izzup_api; Owner: izzup_api
--

CREATE FUNCTION izzup_api.get_member_account(uid_in uuid) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
BEGIN
	
	RETURN (SELECT a.id 
	FROM izzup_api.account_member am 
	INNER JOIN izzup_api.account a ON a.id = am.account_id
	INNER JOIN izzup_api.member m ON m.id = am.member_id
	WHERE m.uid = uid_in
	 AND a.personal = true
	ORDER BY a.created_at LIMIT 1);

	
END; 
$$;


ALTER FUNCTION izzup_api.get_member_account(uid_in uuid) OWNER TO izzup_api;

--
-- Name: get_member_accounts(uuid); Type: FUNCTION; Schema: izzup_api; Owner: postgres
--

CREATE FUNCTION izzup_api.get_member_accounts(uid_in uuid) RETURNS TABLE("accountUid" uuid, "createdAt" timestamp without time zone, name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	
	RETURN QUERY (SELECT a.uid, a.created_at, a.name 
	FROM izzup_api.account_member am 
	INNER JOIN izzup_api.account a ON a.id = am.account_id
	INNER JOIN izzup_api.member m ON m.id = am.member_id
	WHERE m.uid = uid_in
	 AND a.personal = false);

	
END; 
$$;


ALTER FUNCTION izzup_api.get_member_accounts(uid_in uuid) OWNER TO postgres;

--
-- Name: get_member_nuggets_by_type(uuid, text); Type: FUNCTION; Schema: izzup_api; Owner: postgres
--

CREATE FUNCTION izzup_api.get_member_nuggets_by_type(member_uid_in uuid, nugget_type_in text) RETURNS TABLE("nuggetUid" uuid, "createdAt" timestamp without time zone, "updatedAt" timestamp without time zone, "pubAt" timestamp without time zone, "unPubAt" timestamp without time zone, "publicTitle" character varying, "internalName" character varying, "nuggetType" character varying, blocks jsonb)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY 
SELECT 
n.uid AS "nuggetUid",  
n.created_at AS "createdAt",  
n.updated_at AS "updatedAt",  
n.pub_at AS "pubAt", 
n.un_pub_at AS "unPubAt", 
n.public_title AS "publicTitle", 
n.internal_name AS "internalName", 
n.nugget_type AS "nuggetType",
n.blocks
FROM izzup_api.member m 
INNER JOIN izzup_api.account_member am ON am.member_id = m.id
INNER JOIN izzup_api.account a ON a.id = am.account_id
	AND a.personal = true
INNER JOIN izzup_api.nugget n ON n.account_id = am.account_id
WHERE m.uid = member_uid_in
AND n.nugget_type = nugget_type_in;
END;
$$;


ALTER FUNCTION izzup_api.get_member_nuggets_by_type(member_uid_in uuid, nugget_type_in text) OWNER TO postgres;

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
-- Name: new_member_from_user(); Type: FUNCTION; Schema: izzup_api; Owner: postgres
--

CREATE FUNCTION izzup_api.new_member_from_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE new_member_id BIGINT;
	DECLARE new_account_id BIGINT;	
BEGIN

	INSERT INTO izzup_api.member(uid, created_at)
	 VALUES(uuid(NEW.user_id), to_timestamp(NEW.time_joined/1000) )
	 RETURNING id INTO new_member_id;
	
	INSERT INTO izzup_api.account(name)
		 VALUES('Member Account for ' || new_member_id )
		 RETURNING id INTO new_account_id;
		
	INSERT INTO izzup_api.account_member(account_id, member_id, roles)
		 VALUES(new_account_id, new_member_id, '{"owner"}');
		 
		 RETURN NEW;

END;
$$;


ALTER FUNCTION izzup_api.new_member_from_user() OWNER TO postgres;

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
-- Name: account_group; Type: TABLE; Schema: izzup_api; Owner: postgres
--

CREATE TABLE izzup_api.account_group (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(64),
    roles text[]
);


ALTER TABLE izzup_api.account_group OWNER TO postgres;

--
-- Name: account_group_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: postgres
--

CREATE SEQUENCE izzup_api.account_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE izzup_api.account_group_id_seq OWNER TO postgres;

--
-- Name: account_group_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: postgres
--

ALTER SEQUENCE izzup_api.account_group_id_seq OWNED BY izzup_api.account_group.id;


--
-- Name: account_group_member; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.account_group_member (
    account_group_id bigint NOT NULL,
    member_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE izzup_api.account_group_member OWNER TO izzup_api;

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
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone,
    roles text[] NOT NULL
);


ALTER TABLE izzup_api.account_member OWNER TO izzup_api;

--
-- Name: account_nugget_type; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.account_nugget_type (
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(32) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    account_id bigint NOT NULL
);


ALTER TABLE izzup_api.account_nugget_type OWNER TO izzup_api;

--
-- Name: account_role; Type: TABLE; Schema: izzup_api; Owner: postgres
--

CREATE TABLE izzup_api.account_role (
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(24) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL,
    account_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE izzup_api.account_role OWNER TO postgres;

--
-- Name: account_role_id_seq; Type: SEQUENCE; Schema: izzup_api; Owner: postgres
--

CREATE SEQUENCE izzup_api.account_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE izzup_api.account_role_id_seq OWNER TO postgres;

--
-- Name: account_role_id_seq; Type: SEQUENCE OWNED BY; Schema: izzup_api; Owner: postgres
--

ALTER SEQUENCE izzup_api.account_role_id_seq OWNED BY izzup_api.account_role.id;


--
-- Name: role; Type: TABLE; Schema: izzup_api; Owner: postgres
--

CREATE TABLE izzup_api.role (
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(24) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE izzup_api.role OWNER TO postgres;

--
-- Name: all_perms; Type: VIEW; Schema: izzup_api; Owner: postgres
--

CREATE VIEW izzup_api.all_perms AS
 SELECT a.name,
    jsonb_object_agg(jsonb_each.key, jsonb_each.value) AS jsonb_object_agg
   FROM (( SELECT a_1.id,
            r.name,
            r.permissions
           FROM ((izzup_api.account a_1
             JOIN izzup_api.account_member am ON ((am.account_id = a_1.id)))
             JOIN izzup_api.role r ON (((r.name)::text = ANY (am.roles))))
        UNION ALL
         SELECT a_1.id,
            ar.name,
            ar.permissions
           FROM (izzup_api.account a_1
             JOIN izzup_api.account_role ar ON ((ar.account_id = a_1.id)))) a
     CROSS JOIN LATERAL jsonb_each(a.permissions) jsonb_each(key, value))
  GROUP BY a.id, a.name;


ALTER TABLE izzup_api.all_perms OWNER TO postgres;

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
    uid uuid,
    created_at timestamp without time zone
);


ALTER TABLE izzup_api.member OWNER TO izzup_api;

--
-- Name: member_accounts; Type: VIEW; Schema: izzup_api; Owner: postgres
--

CREATE VIEW izzup_api.member_accounts AS
 SELECT m.id AS "memberId",
    m.uid AS "memberUid",
    m.created_at AS "memberCreatedAt",
    a.id AS "accountId",
    a.uid AS "accountUid",
    a.personal AS "personalAccount",
    a.created_at AS "accountCreatedAt",
    a.name AS "accountName",
    am.roles AS "accountRoles",
    ag.name AS "groupName",
    ag.roles AS "groupRoles",
    agm.created_at AS "groupMembershipCreatedAt"
   FROM ((((izzup_api.member m
     JOIN izzup_api.account_member am ON ((am.member_id = m.id)))
     JOIN izzup_api.account a ON ((a.id = am.account_id)))
     LEFT JOIN izzup_api.account_group_member agm ON ((agm.member_id = m.id)))
     LEFT JOIN izzup_api.account_group ag ON ((ag.id = agm.account_group_id)));


ALTER TABLE izzup_api.member_accounts OWNER TO postgres;

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
-- Name: member_permissions; Type: VIEW; Schema: izzup_api; Owner: postgres
--

CREATE VIEW izzup_api.member_permissions AS
 SELECT ma."memberUid",
    ma."accountUid",
    r.name AS "roleName",
    r.permissions
   FROM (izzup_api.member_accounts ma
     JOIN izzup_api.role r ON (((r.name)::text = ANY (ma."accountRoles"))));


ALTER TABLE izzup_api.member_permissions OWNER TO postgres;

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
    blocks jsonb DEFAULT '{}'::jsonb,
    nugget_type character varying(64) NOT NULL
);


ALTER TABLE izzup_api.nugget OWNER TO izzup_api;

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
    linked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
-- Name: nugget_type; Type: TABLE; Schema: izzup_api; Owner: postgres
--

CREATE TABLE izzup_api.nugget_type (
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(32) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE izzup_api.nugget_type OWNER TO postgres;

--
-- Name: old_account_member; Type: TABLE; Schema: izzup_api; Owner: izzup_api
--

CREATE TABLE izzup_api.old_account_member (
    account_id bigint NOT NULL,
    member_uid uuid NOT NULL,
    linked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    role_uids uuid[]
);


ALTER TABLE izzup_api.old_account_member OWNER TO izzup_api;

--
-- Name: old_member; Type: VIEW; Schema: izzup_api; Owner: izzup_api
--

CREATE VIEW izzup_api.old_member AS
 SELECT (passwordless_users.user_id)::uuid AS member_uid,
    passwordless_users.email,
    passwordless_users.phone_number,
    to_timestamp(((passwordless_users.time_joined / 1000))::double precision) AS created_at
   FROM ultri_auth.passwordless_users;


ALTER TABLE izzup_api.old_member OWNER TO izzup_api;

--
-- Name: passwordless_member_accounts; Type: VIEW; Schema: izzup_api; Owner: postgres
--

CREATE VIEW izzup_api.passwordless_member_accounts AS
 SELECT m.id AS "memberId",
    pu.email,
    m.uid AS "memberUid",
    m.created_at AS "memberCreatedAt",
    a.id AS "accountId",
    a.uid AS "accountUid",
    a.personal AS "personalAccount",
    a.created_at AS "accountCreatedAt",
    a.name AS "accountName",
    am.roles AS "accountRoles",
    ag.name AS "groupName",
    ag.roles AS "groupRoles",
    agm.created_at AS "groupMembershipCreatedAt",
    pu.phone_number
   FROM (((((izzup_api.member m
     JOIN izzup_api.account_member am ON ((am.member_id = m.id)))
     JOIN izzup_api.account a ON ((a.id = am.account_id)))
     JOIN ultri_auth.passwordless_users pu ON (((pu.user_id)::text = (m.uid)::text)))
     LEFT JOIN izzup_api.account_group_member agm ON ((agm.member_id = m.id)))
     LEFT JOIN izzup_api.account_group ag ON ((ag.id = agm.account_group_id)));


ALTER TABLE izzup_api.passwordless_member_accounts OWNER TO postgres;

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
-- Name: account_group id; Type: DEFAULT; Schema: izzup_api; Owner: postgres
--

ALTER TABLE ONLY izzup_api.account_group ALTER COLUMN id SET DEFAULT nextval('izzup_api.account_group_id_seq'::regclass);


--
-- Name: account_role id; Type: DEFAULT; Schema: izzup_api; Owner: postgres
--

ALTER TABLE ONLY izzup_api.account_role ALTER COLUMN id SET DEFAULT nextval('izzup_api.account_role_id_seq'::regclass);


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
35	96be72ff-5b99-4525-a5c3-2fc9ec6f365a	2023-03-31 05:14:52.328446	Izzup Member Account for 386319aa-abdf-42d6-a53b-ee2cc7511a07	t
39	c407cd4b-3c86-45a2-91e9-151f41e4fa0a	2023-04-14 01:28:14.831104	Member Account for 3	t
40	62a9f48e-90ee-4268-9b2c-647681f90d07	2023-04-14 01:30:37.994139	Member Account for 4	t
41	d2c7e06f-5f3c-4b2d-b066-e192cde4e3fc	2023-04-14 01:33:26.246145	Member Account for	t
42	164ece7e-a8aa-42a7-a672-75bfbbde4a87	2023-04-14 01:35:27.592473	Member Account for 6	t
43	78a60a6b-836b-4b8e-be70-9424072d14ee	2023-04-14 01:39:14.597227	Member Account for 7	t
48	f72d574c-85b2-47f7-b244-4b484f366a7e	2023-04-14 02:54:32.176074	Member Account for 8	t
49	27f84f6a-ceae-4f9d-9a7f-2b0c8c58e3e4	2023-04-14 03:40:56.893315	Member Account for 9	t
50	fc8ff7f7-9da1-47c4-8dd3-f14a77aa76fd	2023-04-14 06:03:08.037466	Member Account for 10	t
52	8e71d3f8-3ef7-4a0a-bad0-a5512c548a21	2023-04-14 07:39:12.207195	Member Account for 11	t
54	3facaaad-57b8-4e9f-bf17-61f9573a4b54	2023-04-14 21:45:40.71784	Member Account for 12	t
56	5d1d58e5-00ff-4a2b-a057-fe88603a232e	2023-04-16 22:29:12.986608	Member Account for 13	t
57	d96769d8-68c5-484d-9a49-2573c2e602bb	2023-04-20 05:53:32.017511	Member Account for 14	t
30	d7db7fcb-4a77-4169-9823-e38958023528	2023-03-26 20:28:41.031688	My shared account A	f
31	af8db92e-aaac-4141-bfb4-4b6487c8a1a7	2023-03-26 20:28:46.285516	My shared account B	f
32	bbcc7919-956a-4e7a-8db1-7b5770acaa10	2023-03-28 04:42:34.097693	My shared account C	f
33	7513acb8-41cf-4a0f-b7f6-04e9e0013ed1	2023-03-30 04:35:37.196831	My shared account D	f
34	bf676460-7d92-41e4-a954-a2f18f291d37	2023-03-30 06:11:15.637939	My shared account E	f
36	35064555-8fab-4a56-8ec0-79f0f63774bd	2023-04-08 06:19:30.216301	My shared account F	f
47	3f878978-adbf-4e06-945f-d7bf8d423f7f	2023-04-14 02:38:19.96892	My shared account G	f
51	78707037-a5cb-400f-bf5d-6125e644c71b	2023-04-14 06:58:55.731716	My shared account H	f
53	b6d5e2b2-1d55-4eac-98fe-a80d14284f68	2023-04-14 07:42:40.584335	My shared account I	f
55	8f084b5f-1e5d-491b-bb1f-38ca97218d1a	2023-04-14 21:46:29.675755	My new shared account J	f
58	5638011d-5b27-41d2-86e7-2ab6c6a759de	2023-04-20 06:11:28.560366	My new shared account K	f
59	c88f7e7b-c8a1-45fe-9544-7e56d5103721	2023-04-20 06:13:39.189237	My new shared account L	f
\.


--
-- Data for Name: account_group; Type: TABLE DATA; Schema: izzup_api; Owner: postgres
--

COPY izzup_api.account_group (id, uid, account_id, created_at, name, roles) FROM stdin;
1	c4a7948a-4c22-42da-aa5a-bba2e32eae91	53	2023-04-21 04:42:30.087337	devs	{developer}
\.


--
-- Data for Name: account_group_member; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.account_group_member (account_group_id, member_id, created_at) FROM stdin;
1	4	2023-04-21 04:54:32.96003
\.


--
-- Data for Name: account_member; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.account_member (account_id, member_id, created_at, updated_at, roles) FROM stdin;
39	3	2023-04-14 01:28:14.831104	\N	{owner}
43	7	2023-04-14 01:39:14.597227	\N	{owner}
47	7	2023-04-14 02:38:19.96892	\N	{owner}
48	8	2023-04-14 02:54:32.176074	\N	{owner}
49	9	2023-04-14 03:40:56.893315	\N	{owner}
50	10	2023-04-14 06:03:08.037466	\N	{owner}
51	10	2023-04-14 06:58:55.731716	\N	{owner}
52	11	2023-04-14 07:39:12.207195	\N	{owner}
53	11	2023-04-14 07:42:40.584335	\N	{owner}
54	12	2023-04-14 21:45:40.71784	\N	{owner}
55	12	2023-04-14 21:46:29.675755	\N	{owner}
56	13	2023-04-16 22:29:12.986608	\N	{owner}
57	14	2023-04-20 05:53:32.017511	\N	{owner}
58	14	2023-04-20 06:11:28.560366	\N	{owner}
59	12	2023-04-20 06:13:39.189237	\N	{owner}
55	14	2023-04-20 06:23:42.856705	\N	{editor,billing}
\.


--
-- Data for Name: account_nugget_type; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.account_nugget_type (uid, name, created_at, account_id) FROM stdin;
\.


--
-- Data for Name: account_role; Type: TABLE DATA; Schema: izzup_api; Owner: postgres
--

COPY izzup_api.account_role (uid, name, created_at, permissions, account_id, id) FROM stdin;
1d98c451-fff5-40f3-a12e-03261011afec	billing	2023-04-20 19:42:43.480576	{"nuggets": {"article": ["r", "u"], "invoice": ["c", "r", "u", "d", "pub"]}}	55	1
df69234d-558d-4caa-af90-a1ab7def40dc	developer	2023-04-21 04:44:26.220731	{"nuggets": {"article": ["c", "r", "u", "d"]}}	53	2
\.


--
-- Data for Name: block_type; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.block_type (id, name, created_at) FROM stdin;
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.member (id, uid, created_at) FROM stdin;
3	8e40087d-7a40-4b2c-9406-a0e7ffe9c438	2023-04-14 01:28:14
4	b3c2f363-3ec9-4a7b-91cd-a3c3765fc269	2023-04-14 01:30:37
5	1d194d19-edc7-4959-95f6-d64be45221d2	\N
6	94b483b7-9ee9-47d2-bad9-35ebe2ff934c	2023-04-14 01:35:27
7	d8365632-2ab6-4a22-8767-974a62a5fd62	2023-04-14 01:39:14
8	45b10c9e-2ace-41c5-803c-a13609ab605b	2023-04-14 02:54:32
9	3c4f3865-1c73-48ee-ac86-7eac86a4efa6	2023-04-14 03:40:56
10	21d43421-5217-47ed-b58a-809ee035c34b	2023-04-14 06:03:08
11	bc4a1662-f92a-455d-a231-d9b651247b4d	2023-04-14 07:39:12
12	8ee246e8-9f21-4f02-a7a5-2648a2420f76	2023-04-14 21:45:40
13	fb7c1281-1a35-4dfc-8139-bcccc62e750d	2023-04-16 22:29:12
14	753d4c7f-8f73-4f9c-adb2-e2b9f917903d	2023-04-20 05:53:32
\.


--
-- Data for Name: nugget; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.nugget (id, uid, created_at, updated_at, pub_at, un_pub_at, public_title, internal_name, account_id, blocks, nugget_type) FROM stdin;
41	26f0f0ff-62a3-4abc-ab4c-f354a72ee104	2023-03-24 21:51:44.353823	\N	\N	\N	My newest Title	My project	24	{}	article
42	3cb20534-e881-4eaf-89b1-418b7cdcb47c	2023-03-24 21:52:21.345467	\N	\N	\N	My next Title	My next project	24	{}	article
44	1e472044-ad49-4120-a655-0101a40219f2	2023-03-26 20:27:35.046921	\N	\N	\N	My next Title	My next project	24	{}	article
45	de073b73-ff62-4410-8570-838795b44ee9	2023-03-28 04:42:26.033553	\N	\N	\N	My next Title	My next project	24	{}	article
46	d6ed7e0a-6f29-4256-a074-0da8b6321695	2023-03-30 04:35:29.098299	\N	\N	\N	My next Title	My next project	24	{}	article
47	45219790-7fff-4456-a5f9-d0d2147da845	2023-03-30 06:09:14.194829	\N	\N	\N	My latest Title	My project	24	{}	article
48	72d33848-a935-4a7f-ade7-43fb72d7b1ec	2023-04-08 05:38:37.306684	\N	\N	\N	\N	\N	24	{}	article
49	5d57769c-3636-4a93-bf0f-4e33f380088c	2023-04-08 05:38:37.56209	\N	\N	\N	\N	\N	24	{}	article
50	5f721dc5-d1b6-479a-a0b6-17ed9e7eb89a	2023-04-08 05:40:39.02097	\N	\N	\N	\N	\N	24	{}	article
51	3aa5fa87-34fd-49ee-8636-e0ccf8677bad	2023-04-08 06:12:17.285529	\N	\N	\N	\N	\N	24	{}	article
52	f2faf463-88a4-4c12-836e-d9abae28ead9	2023-04-08 06:16:06.991828	\N	\N	\N	My very latest Title	My project	24	{}	article
53	bdedb8a1-7635-4841-8376-075f7f10949a	2023-04-10 05:14:56.922347	\N	\N	\N	My newester Title	My project	24	{}	article
54	111d636d-71f8-4e77-b605-55b182216c57	2023-04-10 05:15:09.065467	\N	\N	\N	My latest Title	My project	24	{}	article
55	d56d6725-b9de-4552-a9a5-1f9c3c5525e3	2023-04-11 02:51:21.726303	\N	\N	\N	Mysuper latest Title	My project	24	{}	article
56	42b91f7e-9416-46a3-a810-b1bef4386ea9	2023-04-11 03:48:17.922929	\N	\N	\N	Mysuper latest Title	My project	24	[{"id": "at4-DN8Xc71G_LUaUldqc", "data": "<font size=\\"6\\">My Text block.</font><div><br></div><div>A new paragraph.</div><div><br></div><div><br></div>", "type": "richText"}, {"id": "yEzYlzv6zCyzZWBKDbqye", "data": {"fit": "fill", "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgJVeM7lsGf2dRbEdg3JAzDmFt21nzzjLyoOBnLeH5&s", "font": "Arial", "ratio": "1", "altText": "My alt text", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "Overlay text", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}, {"id": "iuZph-jZp2OWzLTUGUrXo", "type": "basicSeparator"}]	article
57	38406982-577e-4e22-a675-f723a71ae680	2023-04-14 04:11:48.881654	\N	\N	\N	Mysuper latest Title	My project	49	[{"id": "at4-DN8Xc71G_LUaUldqc", "data": "<font size=\\"6\\">My Text block.</font><div><br></div><div>A new paragraph.</div><div><br></div><div><br></div>", "type": "richText"}, {"id": "yEzYlzv6zCyzZWBKDbqye", "data": {"fit": "fill", "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgJVeM7lsGf2dRbEdg3JAzDmFt21nzzjLyoOBnLeH5&s", "font": "Arial", "ratio": "1", "altText": "My alt text", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "Overlay text", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}, {"id": "iuZph-jZp2OWzLTUGUrXo", "type": "basicSeparator"}]	article
58	18f2257e-a7b9-4391-b755-b22c14dc2a0d	2023-04-14 04:14:34.064769	\N	\N	\N	Mysuper latest Title	My project	49	[{"id": "at4-DN8Xc71G_LUaUldqc", "data": "<font size=\\"6\\">My big Text block.</font><div><br></div><div>A new paragraph.</div><div><br></div><div><br></div>", "type": "richText"}, {"id": "yEzYlzv6zCyzZWBKDbqye", "data": {"fit": "fill", "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgJVeM7lsGf2dRbEdg3JAzDmFt21nzzjLyoOBnLeH5&s", "font": "Arial", "ratio": "1", "altText": "My alternate text", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "Overlay text", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}, {"id": "iuZph-jZp2OWzLTUGUrXo", "type": "basicSeparator"}]	article
61	48d14120-2e55-4c69-b93c-1c724a0eedfd	2023-04-14 06:04:07.352102	\N	\N	\N	My more newester Title	My project	50	[{"id": "at4-DN8Xc71G_LUaUldqc", "data": "<font size=\\"6\\">My big Text block.</font><div><br></div><div>A new paragraph.</div><div><br></div><div><br></div>", "type": "richText"}, {"id": "yEzYlzv6zCyzZWBKDbqye", "data": {"fit": "fill", "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgJVeM7lsGf2dRbEdg3JAzDmFt21nzzjLyoOBnLeH5&s", "font": "Arial", "ratio": "1", "altText": "My alternate text", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "Overlay text", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}, {"id": "iuZph-jZp2OWzLTUGUrXo", "type": "basicSeparator"}]	article
62	60bbc1f0-2da1-455f-9a6e-57f7746c425d	2023-04-14 06:57:26.771734	\N	\N	\N	My super latest Title	My project	50	[{"id": "at4-DN8Xc71G_LUaUldqc", "data": "<font size=\\"6\\">My big Text block.</font><div><br></div><div>A new paragraph.</div><div><br></div><div><br></div>", "type": "richText"}, {"id": "yEzYlzv6zCyzZWBKDbqye", "data": {"fit": "fill", "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgJVeM7lsGf2dRbEdg3JAzDmFt21nzzjLyoOBnLeH5&s", "font": "Arial", "ratio": "1", "altText": "My alternate text", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "Overlay text", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}, {"id": "iuZph-jZp2OWzLTUGUrXo", "type": "basicSeparator"}]	article
63	7ee49dc9-c27f-45b2-8b72-6a9502f390e9	2023-04-14 07:39:22.32392	\N	\N	\N	My more newester Title	My project	52	[{"id": "at4-DN8Xc71G_LUaUldqc", "data": "<font size=\\"6\\">My big Text block.</font><div><br></div><div>A new paragraph.</div><div><br></div><div><br></div>", "type": "richText"}, {"id": "yEzYlzv6zCyzZWBKDbqye", "data": {"fit": "fill", "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgJVeM7lsGf2dRbEdg3JAzDmFt21nzzjLyoOBnLeH5&s", "font": "Arial", "ratio": "1", "altText": "My alternate text", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "Overlay text", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}, {"id": "iuZph-jZp2OWzLTUGUrXo", "type": "basicSeparator"}]	article
64	f5bbceb7-bc0d-4094-bccd-d7078aad63be	2023-04-14 07:39:24.39632	\N	\N	\N	My more newester Title	My project	52	[{"id": "at4-DN8Xc71G_LUaUldqc", "data": "<font size=\\"6\\">My big Text block.</font><div><br></div><div>A new paragraph.</div><div><br></div><div><br></div>", "type": "richText"}, {"id": "yEzYlzv6zCyzZWBKDbqye", "data": {"fit": "fill", "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgJVeM7lsGf2dRbEdg3JAzDmFt21nzzjLyoOBnLeH5&s", "font": "Arial", "ratio": "1", "altText": "My alternate text", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "Overlay text", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}, {"id": "iuZph-jZp2OWzLTUGUrXo", "type": "basicSeparator"}]	article
65	eadbe48b-dd95-4758-88fa-dd945ed5da2f	2023-04-14 21:46:00.188388	\N	\N	\N	My very latest Title	My project	54	\N	article
66	50e14484-b056-41d6-b47f-8f787de336bd	2023-04-14 21:46:04.52791	\N	\N	\N	My super latest Title	My project	54	[{"id": "at4-DN8Xc71G_LUaUldqc", "data": "<font size=\\"6\\">My big Text block.</font><div><br></div><div>A new paragraph.</div><div><br></div><div><br></div>", "type": "richText"}, {"id": "yEzYlzv6zCyzZWBKDbqye", "data": {"fit": "fill", "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgJVeM7lsGf2dRbEdg3JAzDmFt21nzzjLyoOBnLeH5&s", "font": "Arial", "ratio": "1", "altText": "My alternate text", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "Overlay text", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}, {"id": "iuZph-jZp2OWzLTUGUrXo", "type": "basicSeparator"}]	article
67	efe9297a-c8f8-4848-b7c8-01667747d097	2023-04-18 07:06:44.029116	\N	\N	\N	My Title	\N	54	[{"id": "2JMKdtNkEu_S17-WuFEjU", "data": "My body", "type": "richText"}]	article
68	1e73c16b-16c5-4216-87dc-20eb9106a978	2023-04-18 07:07:40.226366	\N	\N	\N	\N	\N	54	[]	article
69	e5bde649-26c1-4446-97bc-a97b3238d8c8	2023-04-18 07:14:04.698191	\N	\N	\N	New Title	\N	54	[{"id": "W76vU5EMxyvNQLGVi4p3d", "data": "New Body", "type": "richText"}]	article
70	b6000c0b-8cc7-4af3-a6e2-0c1274067de4	2023-04-18 07:23:34.465458	\N	\N	\N	Next title	\N	54	[{"id": "zxriUhWirLGe15iuP0hdV", "data": "Body body boot", "type": "richText"}]	article
71	efc74eaf-5fb5-4aaa-8375-519deadcd407	2023-04-18 07:25:55.151359	\N	\N	\N	dfvfdvd	\N	54	[]	article
72	f9b00030-6ee9-447e-9bdb-df860697e886	2023-04-18 08:55:22.699959	\N	\N	\N	fgbgfdgfdgf	\N	54	[]	article
73	790039cc-4a63-47b6-87b7-9bcd75bb914b	2023-04-18 08:56:06.47247	\N	\N	\N	gfbgfbgfbgfbfgb	\N	54	[]	article
74	71358732-c2f9-48da-bebe-e8b13f4d2385	2023-04-18 08:56:52.930824	\N	\N	\N	Fixed	\N	54	[]	article
75	c5608fc8-e72f-484b-b636-0bb5f46d7883	2023-04-18 09:02:29.517575	\N	\N	\N	dfvfddfvdfvdfv	\N	54	[]	article
76	0c1a9af2-4408-4552-84af-f4ce1f8001fb	2023-04-18 09:03:17.06878	\N	\N	\N	refgregvrevbev	\N	54	[]	article
77	2d07b1cd-8bbe-42f0-9710-b6ed018ad3fb	2023-04-18 09:03:38.568835	\N	\N	\N	regevevrevrev	\N	54	[]	article
78	18162f84-01c4-4b03-8311-26bbe799b178	2023-04-19 04:48:37.596457	\N	\N	\N	Tuesday Article	\N	54	[{"id": "QNcTVAuGr0w90Wq_wCj5y", "data": "Tuesday body", "type": "richText"}]	article
79	db0f959b-ad8b-47f0-8e1f-c3e6cdadfaaf	2023-04-19 04:50:31.507941	\N	\N	\N	hgnhgnghng	\N	54	[]	article
80	027103cd-0f91-49e8-a69b-52f110af3032	2023-04-19 04:53:23.583253	\N	\N	\N	fgbgfbfgbgfb	\N	54	[]	article
81	4be42622-8dc8-4f3b-bc1e-cf2ff1b76da4	2023-04-19 05:00:43.175837	\N	\N	\N	My ultra super latest Title	My project	54	[{"id": "at4-DN8Xc71G_LUaUldqc", "data": "<font size=\\"6\\">My big Text block.</font><div><br></div><div>A new paragraph.</div><div><br></div><div><br></div>", "type": "richText"}, {"id": "yEzYlzv6zCyzZWBKDbqye", "data": {"fit": "fill", "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgJVeM7lsGf2dRbEdg3JAzDmFt21nzzjLyoOBnLeH5&s", "font": "Arial", "ratio": "1", "altText": "My alternate text", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "Overlay text", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}, {"id": "iuZph-jZp2OWzLTUGUrXo", "type": "basicSeparator"}]	article
82	3175e2e5-a946-410b-9728-5b0fd6b6495a	2023-04-19 05:03:58.324237	\N	\N	\N	hgnhgnghnn	\N	54	[]	article
83	aee39cbe-1074-471c-8f71-9a8047bc80cc	2023-04-19 05:05:40.32178	\N	\N	\N	;l/lk/;l/l;/l;/	\N	54	[{"id": "wwxBdHGDEi4WV9Cv_V8MI", "data": ";l/;l/l;", "type": "richText"}]	article
84	52454aa3-594c-45c7-9138-393dbc78633b	2023-04-19 06:32:16.285223	\N	\N	\N	rtgrtgtrgtrgrgr	\N	54	[]	article
85	5898e104-b38f-4282-9088-46380bc1d664	2023-04-19 06:33:15.62123	\N	\N	\N	tyytnytnntyn	\N	54	[]	article
86	ce8b1e8a-f5b1-43bd-b96e-fc7a0d9faa62	2023-04-19 06:33:24.494586	\N	\N	\N	ytjnytnytnytntynj	\N	54	[]	article
87	f155798b-405b-4456-a506-a4ab943251dd	2023-04-19 19:49:16.264771	\N	\N	\N	fgtbgfbfdscdscsdcscs	\N	54	[{"id": "cY24WZ97MrhpglOQZMxma", "data": "cdscdscscdscs", "type": "richText"}]	article
88	9e6c72e1-d362-4b93-a0a5-22f52f9e2e51	2023-04-19 19:55:48.734192	\N	\N	\N	wefwfwefwefwfwefw	\N	54	[]	article
89	164459e7-5a48-4a63-b597-7e2c748ffbbe	2023-04-19 19:57:40.224966	\N	\N	\N	New New	\N	54	[{"id": "B-JOFPcbAzJSkdi1nOlWg", "data": "rgregrege&nbsp; er g er g er g er g er&nbsp;", "type": "richText"}, {"id": "WX3kiu_xSnbGYaJd-m-_C", "data": {"fit": "scale-down", "url": "vcfdb ", "font": "Arial", "ratio": "1", "altText": "", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}]	article
90	90075371-8b5c-4431-be84-547d0fc15923	2023-04-19 20:27:56.541904	\N	\N	\N	\N	\N	54	[]	article
91	1938957a-2c36-40b5-b7a0-73f8726f77de	2023-04-19 23:12:01.581289	\N	\N	\N	ytjytnj ytjtnt ytnmtjty	\N	54	[]	article
92	47aae46b-9bb5-4267-b673-86c6fd5148c4	2023-04-19 23:16:48.558064	\N	\N	\N	rregrege  erg re g re g er g er	\N	54	[]	article
93	03509bc6-8fff-46bf-90df-0f4de387387b	2023-04-20 00:45:46.830501	\N	\N	\N	rregrege  erg re g re g e r g er fgbgtfrbfgbgfbfgbf	\N	54	[]	article
94	e523e9f6-a9ef-4c72-896b-bdee92167cf8	2023-04-20 01:28:54.867067	\N	\N	\N	My ultra super latest Title	My project	54	[{"id": "at4-DN8Xc71G_LUaUldqc", "data": "<font size=\\"6\\">My big Text block.</font><div><br></div><div>A new paragraph.</div><div><br></div><div><br></div>", "type": "richText"}, {"id": "yEzYlzv6zCyzZWBKDbqye", "data": {"fit": "fill", "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgJVeM7lsGf2dRbEdg3JAzDmFt21nzzjLyoOBnLeH5&s", "font": "Arial", "ratio": "1", "altText": "My alternate text", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "Overlay text", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}, {"id": "iuZph-jZp2OWzLTUGUrXo", "type": "basicSeparator"}]	article
95	fb3e005e-3161-4c45-80eb-d8854f1801c7	2023-04-20 01:29:41.561375	\N	\N	\N	My ultra super latest Title	My project	54	[{"id": "at4-DN8Xc71G_LUaUldqc", "data": "<font size=\\"6\\">My big Text block.</font><div><br></div><div>A new paragraph.</div><div><br></div><div><br></div>", "type": "richText"}, {"id": "yEzYlzv6zCyzZWBKDbqye", "data": {"fit": "fill", "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgJVeM7lsGf2dRbEdg3JAzDmFt21nzzjLyoOBnLeH5&s", "font": "Arial", "ratio": "1", "altText": "My alternate text", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "Overlay text", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}, {"id": "iuZph-jZp2OWzLTUGUrXo", "type": "basicSeparator"}]	article
96	1d3c3457-cd28-442f-a30b-4bcf1b207944	2023-04-20 01:30:34.375483	\N	\N	\N	My ultra super latest Title	My project	54	[{"id": "at4-DN8Xc71G_LUaUldqc", "data": "<font size=\\"6\\">My big Text block.</font><div><br></div><div>A new paragraph.</div><div><br></div><div><br></div>", "type": "richText"}, {"id": "yEzYlzv6zCyzZWBKDbqye", "data": {"fit": "fill", "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgJVeM7lsGf2dRbEdg3JAzDmFt21nzzjLyoOBnLeH5&s", "font": "Arial", "ratio": "1", "altText": "My alternate text", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "Overlay text", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}, {"id": "iuZph-jZp2OWzLTUGUrXo", "type": "basicSeparator"}]	article
97	581dd7c1-90bd-41cc-874a-af4a442a9a13	2023-04-20 01:33:41.748707	\N	\N	\N	My ultra super latest Title	My project	54	[{"id": "at4-DN8Xc71G_LUaUldqc", "data": "<font size=\\"6\\">My big Text block.</font><div><br></div><div>A new paragraph.</div><div><br></div><div><br></div>", "type": "richText"}, {"id": "yEzYlzv6zCyzZWBKDbqye", "data": {"fit": "fill", "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgJVeM7lsGf2dRbEdg3JAzDmFt21nzzjLyoOBnLeH5&s", "font": "Arial", "ratio": "1", "altText": "My alternate text", "fontSize": "xxx-large", "fontColor": "#ffffff", "fontStyle": "normal", "fontWeight": "text-weight-regular", "captionText": "Overlay text", "imageSource": "url", "captionPosition": "absolute-full text-subtitle2 flex flex-center"}, "type": "image"}, {"id": "iuZph-jZp2OWzLTUGUrXo", "type": "basicSeparator"}]	article
\.


--
-- Data for Name: nugget_comment; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.nugget_comment (id, uid, "created_at ", account_id, nugget_id) FROM stdin;
\.


--
-- Data for Name: nugget_member; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.nugget_member (nugget_id, member_id, linked_at) FROM stdin;
\.


--
-- Data for Name: nugget_reaction; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.nugget_reaction (nugget_id, account_id, member_id) FROM stdin;
\.


--
-- Data for Name: nugget_type; Type: TABLE DATA; Schema: izzup_api; Owner: postgres
--

COPY izzup_api.nugget_type (uid, name, created_at) FROM stdin;
675d2533-bf73-407e-8f74-bb1090c325b1	article	2023-04-13 07:01:56.756336
c4d1037d-56c5-4bae-9364-6a26ba4e5151	invoice	2023-04-13 07:01:56.756336
a87f31e9-63c9-48ef-8dc5-431564bd1bbe	comment	2023-04-13 07:01:56.756336
6a12c285-cf2a-4d2b-aa02-2aedee32ea99	response	2023-04-13 07:01:56.756336
f904016a-2e57-4c57-a9e6-723be64280a5	message	2023-04-13 07:01:56.756336
af50320e-3f44-498d-a229-60ff8470cadd	proposal	2023-04-13 07:01:56.756336
37189c56-b32b-48e8-b62c-7e2f5c1e4161	task	2023-04-13 07:01:56.756336
91b847d3-b84c-4243-b730-7a8cd63d5f9f	sprint	2023-04-13 07:01:56.756336
24f422a5-996a-45b6-b783-26dbb5b8375a	collection	2023-04-13 07:01:56.756336
4ef3fb49-f917-4e7e-a53a-4c4492c9b54a	temporal	2023-04-13 07:01:56.756336
43db28b4-687a-4897-a1bd-7c3dc466c5fe	item	2023-04-13 07:06:14.537866
0300c026-c8f6-480a-ba2d-7629508f089a	epic	2023-04-13 07:06:14.537866
7712bf93-f42b-4bce-9a3d-32010cf2f595	project	2023-04-13 07:06:14.537866
57179bf9-0f3b-405c-a6e0-5faf8b50b729	location	2023-04-13 07:06:14.537866
cf09d931-db81-4059-95b0-d548ff0dbd64	decision	2023-04-13 07:12:38.674899
ebd2c8ec-5bcb-434d-a28b-dd9c61de6605	vote	2023-04-13 07:12:38.674899
56949eba-821b-4d12-8595-a30acf5242d2	howto	2023-04-13 07:12:38.674899
7257319f-072f-48ee-9ca4-7bd2fc8e1e97	quiz	2023-04-13 07:12:38.674899
b31bbe92-fc28-4666-afac-b824ea3241d1	survey	2023-04-13 07:12:38.674899
242da869-02a3-4edb-a1f1-c21a89988e34	calendar	2023-04-13 07:12:38.674899
411c9901-27f7-4225-9b57-fed3324db970	storefront	2023-04-13 07:16:03.619169
ad1d11e9-8b76-4862-ac17-4d94c81370a3	catalog	2023-04-13 07:16:03.619169
2a494f9f-5d82-4984-9498-0e483be74911	product	2023-04-13 07:16:03.619169
898d4354-6fc5-4091-b6c6-4238daa20d73	post	2023-04-13 07:16:03.619169
db57f2f3-5914-414b-bcb8-15213f8e7649	forsale	2023-04-13 07:16:03.619169
ca8ef377-103a-41ae-a42a-14d6451e9b7a	iso	2023-04-13 07:16:03.619169
73ba8598-a13b-4467-ba02-a944c1ce7f6e	job	2023-04-13 07:16:03.619169
d8fde94a-8c9e-47b7-b15a-c4c1300d2a64	organization	2023-04-13 07:16:03.619169
c7c1a17d-19c3-4d4f-9b98-efef57ccb37c	map	2023-04-13 07:18:59.072807
9dcfa4a5-6333-45dc-9d7c-127666f94a60	resume	2023-04-13 07:18:59.072807
f5696b01-14fc-4be6-9053-a97ae04b0c2c	portfolio	2023-04-13 07:18:59.072807
0cc3a0a5-3af7-4218-8f37-ff8090df2977	website	2023-04-13 07:18:59.072807
9d22a61f-953a-40fd-a5d4-1e752bccb867	webpage	2023-04-13 07:18:59.072807
6962db2f-5421-4ef1-8b51-25aff68463f7	rfc	2023-04-13 07:18:59.072807
c5d66fdc-b294-4ea3-98fd-22ed2888c536	meeting	2023-04-13 07:19:25.307955
76f8b5a0-152c-4482-8889-d86e1c6c75ac	slidedeck	2023-04-13 07:21:35.185477
0c488208-78e2-468a-b27e-fe2c1b4cabfc	album	2023-04-13 07:21:35.185477
ad2412e1-20ab-4826-9389-40222d35a5ce	storage	2023-04-13 07:21:35.185477
99b61c5a-ebae-49e8-8016-e9e4a28888ef	orgChart	2023-04-13 07:23:47.401752
4165da27-cd0a-4b9b-8406-732414bd9120	issue	2023-04-13 07:23:47.401752
a256cae5-3dea-4dd8-b8f4-4cf9b802cb03	order	2023-04-13 07:23:47.401752
cc115a49-24a1-4b1a-b972-bc649559ab8b	shipment	2023-04-13 07:23:47.401752
28892dbc-aa47-4be4-b106-3a04dc1f5314	payment	2023-04-13 07:25:37.10834
06dfb799-b326-4d7d-8a80-3cc432607c12	ledger	2023-04-13 07:25:37.10834
058e24b5-8d5c-425a-ba84-ceeae2ae9aca	transaction	2023-04-13 07:25:37.10834
b699329d-8442-4473-aa2a-8a1c8f31f87b	campaign	2023-04-13 07:26:28.593006
3fe87943-e8cf-4552-aa55-b25beec1d8e7	checklist	2023-04-14 04:35:09.708361
d297f6a3-09f1-4c50-901b-0c1672e024cb	form	2023-04-15 02:09:48.667196
\.


--
-- Data for Name: old_account_member; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.old_account_member (account_id, member_uid, linked_at, role_uids) FROM stdin;
7	64582d96-9dda-4117-91ba-666313852bfe	2023-03-11 05:12:52.829332	\N
5	be0f1caf-6fec-4b23-b1bd-56b9fa80408e	2023-03-11 05:14:53.975062	\N
8	0f165d16-fa39-4503-8b91-6c0ce1e23e7c	2023-03-15 06:26:05.744271	\N
9	44febcf5-2489-4ef3-9751-b45d22bf0428	2023-03-16 04:03:25.371706	\N
10	1d6a86c4-94fe-4133-a7ac-4a8eebca66d3	2023-03-16 18:19:17.372258	\N
11	229c4c57-d594-46e4-aa63-27379147d0a4	2023-03-16 18:29:49.36112	\N
12	236d9ca2-82ef-4ad9-b815-8f0f3e21fdb3	2023-03-16 18:31:16.218219	\N
13	c041e99e-574b-49e5-937d-b4a5fbd4c78e	2023-03-16 18:48:36.678407	\N
14	c11640b9-2b79-4c36-960e-74f31e634ceb	2023-03-16 18:50:19.011995	\N
15	720e6556-d883-4838-b07a-79d73398d1b5	2023-03-16 18:52:32.27825	\N
16	9f77b3df-ed08-4a02-a6c9-e5dbd9573c33	2023-03-16 20:27:57.148596	\N
17	a3952355-71f4-434d-9f03-0c61950447b4	2023-03-16 20:31:55.611748	\N
18	12b3a861-c627-4493-9243-03e6fd274995	2023-03-16 20:39:16.001646	\N
19	df50854c-201f-4829-a67a-953e39aa772f	2023-03-18 06:30:13.989994	\N
20	3c1f25cd-065b-483e-ae33-339488f263bb	2023-03-18 19:35:08.272918	\N
21	b2264e89-9e8d-40ad-a8ab-75c2146c899d	2023-03-19 06:54:30.891231	\N
22	d4dcff47-90a8-48ca-a04b-0cbf4b05091b	2023-03-22 04:59:25.634367	\N
23	8fe443bc-745c-460a-a9c4-0ae7b261d6c4	2023-03-24 00:02:14.944919	\N
24	c8885655-74e3-4594-ad69-2419a2129458	2023-03-24 03:12:18.122234	\N
28	c8885655-74e3-4594-ad69-2419a2129458	2023-03-26 19:39:25.28476	\N
29	c8885655-74e3-4594-ad69-2419a2129458	2023-03-26 19:39:35.253513	\N
30	c8885655-74e3-4594-ad69-2419a2129458	2023-03-26 20:28:41.031688	\N
31	c8885655-74e3-4594-ad69-2419a2129458	2023-03-26 20:28:46.285516	\N
32	c8885655-74e3-4594-ad69-2419a2129458	2023-03-28 04:42:34.097693	\N
33	c8885655-74e3-4594-ad69-2419a2129458	2023-03-30 04:35:37.196831	\N
34	c8885655-74e3-4594-ad69-2419a2129458	2023-03-30 06:11:15.637939	\N
35	386319aa-abdf-42d6-a53b-ee2cc7511a07	2023-03-31 05:14:52.328446	\N
36	c8885655-74e3-4594-ad69-2419a2129458	2023-04-08 06:19:30.216301	\N
\.


--
-- Data for Name: response; Type: TABLE DATA; Schema: izzup_api; Owner: izzup_api
--

COPY izzup_api.response (id, uid, created_at, comment_id, response_id, account_id, nugget_id) FROM stdin;
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: izzup_api; Owner: postgres
--

COPY izzup_api.role (uid, name, created_at, permissions) FROM stdin;
4ae37c11-9346-4b48-8878-32b4c1808840	editor	2023-04-13 06:27:50.772132	{"nuggets": {"article": ["c", "r", "u", "d", "pub"]}}
7f0b5144-7c9d-465c-8b55-fc549b1f43d8	support	2023-04-13 06:38:31.456076	{"nuggets": {"article": ["r"], "invoice": ["r"], "response": ["r"]}}
977d1068-a8e7-4fd5-9943-2cb64b8b3c3b	billing	2023-04-13 06:36:01.322926	{"nuggets": {"invoice": ["r"]}}
00dae312-18b4-486f-820b-acc09f5d1628	social	2023-04-13 06:36:01.322926	{"nuggets": {"comment": ["c", "r", "u", "d", "pub"], "response": ["c", "r", "u", "d", "pub"]}}
baf4d3c1-8252-4f04-8680-c5e158476901	owner	2023-04-13 06:27:50.772132	{"all": "all"}
df7e929b-fa83-4bb2-b82c-389913476529	preview	2023-04-13 06:36:01.322926	{"nuggets": {"all": ["r"]}}
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
-- Name: account_group_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: postgres
--

SELECT pg_catalog.setval('izzup_api.account_group_id_seq', 1, true);


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.account_id_seq', 59, true);


--
-- Name: account_role_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: postgres
--

SELECT pg_catalog.setval('izzup_api.account_role_id_seq', 2, true);


--
-- Name: block_types_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.block_types_id_seq', 1, false);


--
-- Name: member_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.member_id_seq', 14, true);


--
-- Name: nugget_comment_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.nugget_comment_id_seq', 1, false);


--
-- Name: nugget_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.nugget_id_seq', 97, true);


--
-- Name: response_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.response_id_seq', 1, false);


--
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: izzup_api; Owner: izzup_api
--

SELECT pg_catalog.setval('izzup_api.service_id_seq', 21, true);


--
-- Name: account_group_member account_group_member_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.account_group_member
    ADD CONSTRAINT account_group_member_pkey PRIMARY KEY (account_group_id, member_id);


--
-- Name: account_group account_group_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: postgres
--

ALTER TABLE ONLY izzup_api.account_group
    ADD CONSTRAINT account_group_pkey PRIMARY KEY (id);


--
-- Name: old_account_member account_member_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.old_account_member
    ADD CONSTRAINT account_member_pkey PRIMARY KEY (account_id, member_uid);


--
-- Name: account_member account_member_pkey1; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.account_member
    ADD CONSTRAINT account_member_pkey1 PRIMARY KEY (account_id, member_id);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: account_role account_role_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: postgres
--

ALTER TABLE ONLY izzup_api.account_role
    ADD CONSTRAINT account_role_pkey PRIMARY KEY (id);


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
-- Name: nugget_type nugget_type_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: postgres
--

ALTER TABLE ONLY izzup_api.nugget_type
    ADD CONSTRAINT nugget_type_pkey PRIMARY KEY (uid);


--
-- Name: response response_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.response
    ADD CONSTRAINT response_pkey PRIMARY KEY (id);


--
-- Name: role roles_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: postgres
--

ALTER TABLE ONLY izzup_api.role
    ADD CONSTRAINT roles_pkey PRIMARY KEY (uid);


--
-- Name: service service_pkey; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: account_group uq_account_group_name; Type: CONSTRAINT; Schema: izzup_api; Owner: postgres
--

ALTER TABLE ONLY izzup_api.account_group
    ADD CONSTRAINT uq_account_group_name UNIQUE (account_id, name);


--
-- Name: account_nugget_type uq_account_nugget_type_name; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.account_nugget_type
    ADD CONSTRAINT uq_account_nugget_type_name UNIQUE (name, account_id);


--
-- Name: account uq_account_uid; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.account
    ADD CONSTRAINT uq_account_uid UNIQUE (uid);


--
-- Name: account_role uq_acount_role_name; Type: CONSTRAINT; Schema: izzup_api; Owner: postgres
--

ALTER TABLE ONLY izzup_api.account_role
    ADD CONSTRAINT uq_acount_role_name UNIQUE (account_id, name);


--
-- Name: member uq_member_uid; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.member
    ADD CONSTRAINT uq_member_uid UNIQUE (uid);


--
-- Name: nugget_type uq_nugget_type_name; Type: CONSTRAINT; Schema: izzup_api; Owner: postgres
--

ALTER TABLE ONLY izzup_api.nugget_type
    ADD CONSTRAINT uq_nugget_type_name UNIQUE (name);


--
-- Name: nugget uq_nugget_uid; Type: CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget
    ADD CONSTRAINT uq_nugget_uid UNIQUE (uid);


--
-- Name: role uq_role_name; Type: CONSTRAINT; Schema: izzup_api; Owner: postgres
--

ALTER TABLE ONLY izzup_api.role
    ADD CONSTRAINT uq_role_name UNIQUE (name);


--
-- Name: ix_account_member_member_uid; Type: INDEX; Schema: izzup_api; Owner: izzup_api
--

CREATE INDEX ix_account_member_member_uid ON izzup_api.old_account_member USING btree (member_uid) INCLUDE (account_id);


--
-- Name: account_group fk_account_group_account_id; Type: FK CONSTRAINT; Schema: izzup_api; Owner: postgres
--

ALTER TABLE ONLY izzup_api.account_group
    ADD CONSTRAINT fk_account_group_account_id FOREIGN KEY (account_id) REFERENCES izzup_api.account(id) NOT VALID;


--
-- Name: account_member fk_account_member_account_id; Type: FK CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.account_member
    ADD CONSTRAINT fk_account_member_account_id FOREIGN KEY (account_id) REFERENCES izzup_api.account(id);


--
-- Name: account_member fk_account_member_member_id; Type: FK CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.account_member
    ADD CONSTRAINT fk_account_member_member_id FOREIGN KEY (member_id) REFERENCES izzup_api.member(id);


--
-- Name: account_nugget_type fk_account_nugget_type_account_id; Type: FK CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.account_nugget_type
    ADD CONSTRAINT fk_account_nugget_type_account_id FOREIGN KEY (account_id) REFERENCES izzup_api.account(id) NOT VALID;


--
-- Name: account_role fk_account_role_account_id; Type: FK CONSTRAINT; Schema: izzup_api; Owner: postgres
--

ALTER TABLE ONLY izzup_api.account_role
    ADD CONSTRAINT fk_account_role_account_id FOREIGN KEY (account_id) REFERENCES izzup_api.account(id) NOT VALID;


--
-- Name: nugget fk_nugget_account_id; Type: FK CONSTRAINT; Schema: izzup_api; Owner: izzup_api
--

ALTER TABLE ONLY izzup_api.nugget
    ADD CONSTRAINT fk_nugget_account_id FOREIGN KEY (account_id) REFERENCES izzup_api.account(id) NOT VALID;


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
-- Name: FUNCTION new_member_from_user(); Type: ACL; Schema: izzup_api; Owner: postgres
--

GRANT ALL ON FUNCTION izzup_api.new_member_from_user() TO izzup_api;


--
-- Name: FUNCTION register_member(uid_in text, email_in text, time_joined_in numeric); Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON FUNCTION izzup_api.register_member(uid_in text, email_in text, time_joined_in numeric) TO ultri_auth;


--
-- Name: TABLE account; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT SELECT,INSERT ON TABLE izzup_api.account TO ultri_auth;


--
-- Name: SEQUENCE account_id_seq; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON SEQUENCE izzup_api.account_id_seq TO ultri_auth;


--
-- Name: TABLE account_member; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT SELECT,INSERT ON TABLE izzup_api.account_member TO ultri_auth;


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

GRANT SELECT,INSERT ON TABLE izzup_api.member TO ultri_auth;


--
-- Name: SEQUENCE member_id_seq; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT SELECT,USAGE ON SEQUENCE izzup_api.member_id_seq TO ultri_auth;


--
-- Name: TABLE nugget; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.nugget TO ultri_auth;


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
-- Name: TABLE old_account_member; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.old_account_member TO ultri_auth;


--
-- Name: TABLE old_member; Type: ACL; Schema: izzup_api; Owner: izzup_api
--

GRANT ALL ON TABLE izzup_api.old_member TO ultri_auth;


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

