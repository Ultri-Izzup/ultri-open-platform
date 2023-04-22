PGDMP          2                {           izzup    14.6 (Debian 14.6-1.pgdg110+1) #   14.7 (Ubuntu 14.7-0ubuntu0.22.04.1) �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16384    izzup    DATABASE     Y   CREATE DATABASE izzup WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';
    DROP DATABASE izzup;
                postgres    false            �           0    0    DATABASE izzup    ACL     ]   GRANT CONNECT ON DATABASE izzup TO izzup_api;
GRANT CONNECT ON DATABASE izzup TO ultri_auth;
                   postgres    false    3721                        2615    16386 	   izzup_api    SCHEMA        CREATE SCHEMA izzup_api;
    DROP SCHEMA izzup_api;
             	   izzup_api    false            �           0    0    SCHEMA izzup_api    ACL     /   GRANT USAGE ON SCHEMA izzup_api TO ultri_auth;
                	   izzup_api    false    5                        2615    25355 
   nugget_api    SCHEMA        CREATE SCHEMA nugget_api;
    DROP SCHEMA nugget_api;
             	   izzup_api    false                        2615    25354    nugget_data    SCHEMA        CREATE SCHEMA nugget_data;
    DROP SCHEMA nugget_data;
                postgres    false                        2615    16388 
   ultri_auth    SCHEMA        CREATE SCHEMA ultri_auth;
    DROP SCHEMA ultri_auth;
             
   ultri_auth    false            �           0    0    SCHEMA ultri_auth    ACL     /   GRANT USAGE ON SCHEMA ultri_auth TO izzup_api;
                
   ultri_auth    false    7            �           1247    16891 
   auth_level    TYPE     �   CREATE TYPE izzup_api.auth_level AS ENUM (
    'public',
    'member',
    'account',
    'role',
    'account_role',
    'application'
);
     DROP TYPE izzup_api.auth_level;
    	   izzup_api       	   izzup_api    false    5                       1255    17109 '   create_account(character varying, uuid)    FUNCTION     /  CREATE FUNCTION izzup_api.create_account(name_in character varying, owner_uid uuid) RETURNS TABLE(id bigint, uid uuid, created_at timestamp without time zone)
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
 S   DROP FUNCTION izzup_api.create_account(name_in character varying, owner_uid uuid);
    	   izzup_api       	   izzup_api    false    5                       1255    17103 \   create_account_nugget(character varying, character varying, character varying, bigint, uuid)    FUNCTION     �  CREATE FUNCTION izzup_api.create_account_nugget(public_title character varying, internal_name character varying, nugget_type character varying, account_uid bigint, member_uid uuid, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint) RETURNS record
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
   DROP FUNCTION izzup_api.create_account_nugget(public_title character varying, internal_name character varying, nugget_type character varying, account_uid bigint, member_uid uuid, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint);
    	   izzup_api       	   izzup_api    false    5                       1255    16933    create_api_account()    FUNCTION     �  CREATE FUNCTION izzup_api.create_api_account() RETURNS trigger
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
 .   DROP FUNCTION izzup_api.create_api_account();
    	   izzup_api       	   izzup_api    false    5            �           0    0    FUNCTION create_api_account()    ACL     D   GRANT ALL ON FUNCTION izzup_api.create_api_account() TO ultri_auth;
       	   izzup_api       	   izzup_api    false    271            	           1255    16934    create_member_account()    FUNCTION     �  CREATE FUNCTION izzup_api.create_member_account() RETURNS trigger
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
 1   DROP FUNCTION izzup_api.create_member_account();
    	   izzup_api       	   izzup_api    false    5            �           0    0     FUNCTION create_member_account()    ACL     G   GRANT ALL ON FUNCTION izzup_api.create_member_account() TO ultri_auth;
       	   izzup_api       	   izzup_api    false    265                        1255    17137 Z   create_member_nugget(character varying, character varying, character varying, uuid, jsonb)    FUNCTION     �  CREATE FUNCTION izzup_api.create_member_nugget(public_title character varying, internal_name character varying, nugget_type character varying, member_uid uuid, blocks jsonb, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint) RETURNS record
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
   DROP FUNCTION izzup_api.create_member_nugget(public_title character varying, internal_name character varying, nugget_type character varying, member_uid uuid, blocks jsonb, OUT id bigint, OUT uid uuid, OUT created_at timestamp without time zone, OUT account_id bigint);
    	   izzup_api       	   izzup_api    false    5                       1255    17073    get_member_account(uuid)    FUNCTION     s  CREATE FUNCTION izzup_api.get_member_account(uid_in uuid) RETURNS bigint
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
 9   DROP FUNCTION izzup_api.get_member_account(uid_in uuid);
    	   izzup_api       	   izzup_api    false    5                       1255    17343    get_member_accounts(uuid)    FUNCTION     �  CREATE FUNCTION izzup_api.get_member_accounts(uid_in uuid) RETURNS TABLE("accountUid" uuid, "createdAt" timestamp without time zone, name character varying)
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
 :   DROP FUNCTION izzup_api.get_member_accounts(uid_in uuid);
    	   izzup_api          postgres    false    5                       1255    17341 &   get_member_nuggets_by_type(uuid, text)    FUNCTION     �  CREATE FUNCTION izzup_api.get_member_nuggets_by_type(member_uid_in uuid, nugget_type_in text) RETURNS TABLE("nuggetUid" uuid, "createdAt" timestamp without time zone, "updatedAt" timestamp without time zone, "pubAt" timestamp without time zone, "unPubAt" timestamp without time zone, "publicTitle" character varying, "internalName" character varying, "nuggetType" character varying, blocks jsonb)
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
 ]   DROP FUNCTION izzup_api.get_member_nuggets_by_type(member_uid_in uuid, nugget_type_in text);
    	   izzup_api          postgres    false    5                       1255    17074 -   get_nugget_type_id(character varying, bigint)    FUNCTION     L  CREATE FUNCTION izzup_api.get_nugget_type_id(type_name_in character varying, account_id_in bigint) RETURNS bigint
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
 b   DROP FUNCTION izzup_api.get_nugget_type_id(type_name_in character varying, account_id_in bigint);
    	   izzup_api       	   izzup_api    false    5                       1255    17315    new_member_from_user()    FUNCTION     T  CREATE FUNCTION izzup_api.new_member_from_user() RETURNS trigger
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
 0   DROP FUNCTION izzup_api.new_member_from_user();
    	   izzup_api          postgres    false    5            �           0    0    FUNCTION new_member_from_user()    ACL     E   GRANT ALL ON FUNCTION izzup_api.new_member_from_user() TO izzup_api;
       	   izzup_api          postgres    false    285            
           1255    16935 $   register_member(text, text, numeric)    FUNCTION     �  CREATE FUNCTION izzup_api.register_member(uid_in text, email_in text, time_joined_in numeric) RETURNS text
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
 ]   DROP FUNCTION izzup_api.register_member(uid_in text, email_in text, time_joined_in numeric);
    	   izzup_api       	   izzup_api    false    5            �           0    0 L   FUNCTION register_member(uid_in text, email_in text, time_joined_in numeric)    ACL     s   GRANT ALL ON FUNCTION izzup_api.register_member(uid_in text, email_in text, time_joined_in numeric) TO ultri_auth;
       	   izzup_api       	   izzup_api    false    266                       1255    17062    member_nuggets(uuid, text)    FUNCTION     '  CREATE FUNCTION public.member_nuggets(member_uid uuid, n_type text) RETURNS TABLE(uid uuid, created_at timestamp without time zone, updated_at timestamp without time zone, pub_at timestamp without time zone, un_pub_at timestamp without time zone, public_title text, internal_name text, nugget_type_id bigint, nugget_type text)
    LANGUAGE sql
    AS $$
SELECT 
  n.uid, 
  n.created_at, 
  n.updated_at, 
  n.pub_at, 
  n.un_pub_at, 
  n.public_title, 
  n.internal_name, 
  n.nugget_type_id,
  nt.name AS nugget_type
FROM izzup_api.account_member am 
INNER JOIN izzup_api.account a ON a.id = am.account_id
  AND a.personal = true
INNER JOIN izzup_api.nugget n ON n.account_id = a.id
INNER JOIN izzup_api.nugget_type nt ON nt.id = n.nugget_type_id
WHERE am.member_uid = member_uid
AND nt.name = n_type
$$;
 C   DROP FUNCTION public.member_nuggets(member_uid uuid, n_type text);
       public          postgres    false                       1255    17050    create_api_account()    FUNCTION     �  CREATE FUNCTION ultri_auth.create_api_account() RETURNS trigger
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
 /   DROP FUNCTION ultri_auth.create_api_account();
    
   ultri_auth       
   ultri_auth    false    7            �            1259    16936    account    TABLE     �   CREATE TABLE izzup_api.account (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(150),
    personal boolean DEFAULT true
);
    DROP TABLE izzup_api.account;
    	   izzup_api         heap 	   izzup_api    false    5            �           0    0    TABLE account    ACL     >   GRANT SELECT,INSERT ON TABLE izzup_api.account TO ultri_auth;
       	   izzup_api       	   izzup_api    false    231            �            1259    17318    account_group    TABLE       CREATE TABLE izzup_api.account_group (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(64),
    roles text[]
);
 $   DROP TABLE izzup_api.account_group;
    	   izzup_api         heap    postgres    false    5            �            1259    17317    account_group_id_seq    SEQUENCE     �   CREATE SEQUENCE izzup_api.account_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE izzup_api.account_group_id_seq;
    	   izzup_api          postgres    false    255    5            �           0    0    account_group_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE izzup_api.account_group_id_seq OWNED BY izzup_api.account_group.id;
       	   izzup_api          postgres    false    254                        1259    17335    account_group_member    TABLE     �   CREATE TABLE izzup_api.account_group_member (
    account_group_id bigint NOT NULL,
    member_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
 +   DROP TABLE izzup_api.account_group_member;
    	   izzup_api         heap 	   izzup_api    false    5            �            1259    16941    account_id_seq    SEQUENCE     z   CREATE SEQUENCE izzup_api.account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE izzup_api.account_id_seq;
    	   izzup_api       	   izzup_api    false    5    231            �           0    0    account_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE izzup_api.account_id_seq OWNED BY izzup_api.account.id;
       	   izzup_api       	   izzup_api    false    232            �           0    0    SEQUENCE account_id_seq    ACL     >   GRANT ALL ON SEQUENCE izzup_api.account_id_seq TO ultri_auth;
       	   izzup_api       	   izzup_api    false    232            �            1259    17296    account_member    TABLE     �   CREATE TABLE izzup_api.account_member (
    account_id bigint NOT NULL,
    member_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone,
    roles text[] NOT NULL
);
 %   DROP TABLE izzup_api.account_member;
    	   izzup_api         heap 	   izzup_api    false    5            �           0    0    TABLE account_member    ACL     E   GRANT SELECT,INSERT ON TABLE izzup_api.account_member TO ultri_auth;
       	   izzup_api       	   izzup_api    false    253            �            1259    17247    account_nugget_type    TABLE     �   CREATE TABLE izzup_api.account_nugget_type (
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(32) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    account_id bigint NOT NULL
);
 *   DROP TABLE izzup_api.account_nugget_type;
    	   izzup_api         heap 	   izzup_api    false    5            �            1259    17220    account_role    TABLE     4  CREATE TABLE izzup_api.account_role (
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(24) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL,
    account_id bigint NOT NULL,
    id bigint NOT NULL
);
 #   DROP TABLE izzup_api.account_role;
    	   izzup_api         heap    postgres    false    5                       1259    25339    account_role_id_seq    SEQUENCE        CREATE SEQUENCE izzup_api.account_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE izzup_api.account_role_id_seq;
    	   izzup_api          postgres    false    5    248            �           0    0    account_role_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE izzup_api.account_role_id_seq OWNED BY izzup_api.account_role.id;
       	   izzup_api          postgres    false    261            �            1259    17208    role    TABLE     �   CREATE TABLE izzup_api.role (
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(24) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL
);
    DROP TABLE izzup_api.role;
    	   izzup_api         heap    postgres    false    5                       1259    25349 	   all_perms    VIEW     �  CREATE VIEW izzup_api.all_perms AS
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
    DROP VIEW izzup_api.all_perms;
    	   izzup_api          postgres    false    247    253    253    248    231    247    248    248    5            �            1259    16959 
   block_type    TABLE     �   CREATE TABLE izzup_api.block_type (
    id bigint NOT NULL,
    name character varying(150),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
 !   DROP TABLE izzup_api.block_type;
    	   izzup_api         heap 	   izzup_api    false    5            �           0    0    TABLE block_type    ACL     7   GRANT ALL ON TABLE izzup_api.block_type TO ultri_auth;
       	   izzup_api       	   izzup_api    false    234            �            1259    16963    block_types_id_seq    SEQUENCE     ~   CREATE SEQUENCE izzup_api.block_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE izzup_api.block_types_id_seq;
    	   izzup_api       	   izzup_api    false    5    234            �           0    0    block_types_id_seq    SEQUENCE OWNED BY     N   ALTER SEQUENCE izzup_api.block_types_id_seq OWNED BY izzup_api.block_type.id;
       	   izzup_api       	   izzup_api    false    235            �           0    0    SEQUENCE block_types_id_seq    ACL     B   GRANT ALL ON SEQUENCE izzup_api.block_types_id_seq TO ultri_auth;
       	   izzup_api       	   izzup_api    false    235            �            1259    17285    member    TABLE     t   CREATE TABLE izzup_api.member (
    id bigint NOT NULL,
    uid uuid,
    created_at timestamp without time zone
);
    DROP TABLE izzup_api.member;
    	   izzup_api         heap 	   izzup_api    false    5            �           0    0    TABLE member    ACL     =   GRANT SELECT,INSERT ON TABLE izzup_api.member TO ultri_auth;
       	   izzup_api       	   izzup_api    false    252                       1259    17344    member_accounts    VIEW     �  CREATE VIEW izzup_api.member_accounts AS
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
 %   DROP VIEW izzup_api.member_accounts;
    	   izzup_api          postgres    false    256    231    252    252    252    253    253    253    255    255    255    256    256    231    231    231    231    5            �            1259    17284    member_id_seq    SEQUENCE     y   CREATE SEQUENCE izzup_api.member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE izzup_api.member_id_seq;
    	   izzup_api       	   izzup_api    false    5    252            �           0    0    member_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE izzup_api.member_id_seq OWNED BY izzup_api.member.id;
       	   izzup_api       	   izzup_api    false    251            �           0    0    SEQUENCE member_id_seq    ACL     F   GRANT SELECT,USAGE ON SEQUENCE izzup_api.member_id_seq TO ultri_auth;
       	   izzup_api       	   izzup_api    false    251                       1259    17353    member_permissions    VIEW     �   CREATE VIEW izzup_api.member_permissions AS
 SELECT ma."memberUid",
    ma."accountUid",
    r.name AS "roleName",
    r.permissions
   FROM (izzup_api.member_accounts ma
     JOIN izzup_api.role r ON (((r.name)::text = ANY (ma."accountRoles"))));
 (   DROP VIEW izzup_api.member_permissions;
    	   izzup_api          postgres    false    247    257    257    257    247    5            �            1259    16968    nugget    TABLE       CREATE TABLE izzup_api.nugget (
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
    DROP TABLE izzup_api.nugget;
    	   izzup_api         heap 	   izzup_api    false    5            �           0    0    TABLE nugget    ACL     3   GRANT ALL ON TABLE izzup_api.nugget TO ultri_auth;
       	   izzup_api       	   izzup_api    false    236            �            1259    16979    nugget_comment    TABLE     �   CREATE TABLE izzup_api.nugget_comment (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    "created_at " timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    account_id bigint NOT NULL,
    nugget_id bigint NOT NULL
);
 %   DROP TABLE izzup_api.nugget_comment;
    	   izzup_api         heap 	   izzup_api    false    5            �           0    0    TABLE nugget_comment    ACL     ;   GRANT ALL ON TABLE izzup_api.nugget_comment TO ultri_auth;
       	   izzup_api       	   izzup_api    false    237            �            1259    16984    nugget_comment_id_seq    SEQUENCE     �   CREATE SEQUENCE izzup_api.nugget_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE izzup_api.nugget_comment_id_seq;
    	   izzup_api       	   izzup_api    false    237    5            �           0    0    nugget_comment_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE izzup_api.nugget_comment_id_seq OWNED BY izzup_api.nugget_comment.id;
       	   izzup_api       	   izzup_api    false    238            �           0    0    SEQUENCE nugget_comment_id_seq    ACL     E   GRANT ALL ON SEQUENCE izzup_api.nugget_comment_id_seq TO ultri_auth;
       	   izzup_api       	   izzup_api    false    238            �            1259    16985    nugget_id_seq    SEQUENCE     y   CREATE SEQUENCE izzup_api.nugget_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE izzup_api.nugget_id_seq;
    	   izzup_api       	   izzup_api    false    236    5            �           0    0    nugget_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE izzup_api.nugget_id_seq OWNED BY izzup_api.nugget.id;
       	   izzup_api       	   izzup_api    false    239            �           0    0    SEQUENCE nugget_id_seq    ACL     =   GRANT ALL ON SEQUENCE izzup_api.nugget_id_seq TO ultri_auth;
       	   izzup_api       	   izzup_api    false    239            �            1259    16986    nugget_member    TABLE     �   CREATE TABLE izzup_api.nugget_member (
    nugget_id bigint NOT NULL,
    member_id bigint NOT NULL,
    linked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
 $   DROP TABLE izzup_api.nugget_member;
    	   izzup_api         heap 	   izzup_api    false    5            �           0    0    TABLE nugget_member    ACL     :   GRANT ALL ON TABLE izzup_api.nugget_member TO ultri_auth;
       	   izzup_api       	   izzup_api    false    240            �            1259    16993    nugget_reaction    TABLE     �   CREATE TABLE izzup_api.nugget_reaction (
    nugget_id bigint NOT NULL,
    account_id bigint NOT NULL,
    member_id bigint NOT NULL
);
 &   DROP TABLE izzup_api.nugget_reaction;
    	   izzup_api         heap 	   izzup_api    false    5            �           0    0    TABLE nugget_reaction    ACL     <   GRANT ALL ON TABLE izzup_api.nugget_reaction TO ultri_auth;
       	   izzup_api       	   izzup_api    false    241            �            1259    17235    nugget_type    TABLE     �   CREATE TABLE izzup_api.nugget_type (
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(32) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
 "   DROP TABLE izzup_api.nugget_type;
    	   izzup_api         heap    postgres    false    5            �            1259    16942    old_account_member    TABLE     �   CREATE TABLE izzup_api.old_account_member (
    account_id bigint NOT NULL,
    member_uid uuid NOT NULL,
    linked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    role_uids uuid[]
);
 )   DROP TABLE izzup_api.old_account_member;
    	   izzup_api         heap 	   izzup_api    false    5            �           0    0    TABLE old_account_member    ACL     ?   GRANT ALL ON TABLE izzup_api.old_account_member TO ultri_auth;
       	   izzup_api       	   izzup_api    false    233            �            1259    16801    passwordless_users    TABLE     �   CREATE TABLE ultri_auth.passwordless_users (
    user_id character(36) NOT NULL,
    email character varying(256),
    phone_number character varying(256),
    time_joined bigint NOT NULL
);
 *   DROP TABLE ultri_auth.passwordless_users;
    
   ultri_auth         heap 
   ultri_auth    false    7            �           0    0    TABLE passwordless_users    ACL     B   GRANT SELECT ON TABLE ultri_auth.passwordless_users TO izzup_api;
       
   ultri_auth       
   ultri_auth    false    223            �            1259    17056 
   old_member    VIEW     $  CREATE VIEW izzup_api.old_member AS
 SELECT (passwordless_users.user_id)::uuid AS member_uid,
    passwordless_users.email,
    passwordless_users.phone_number,
    to_timestamp(((passwordless_users.time_joined / 1000))::double precision) AS created_at
   FROM ultri_auth.passwordless_users;
     DROP VIEW izzup_api.old_member;
    	   izzup_api       	   izzup_api    false    223    223    223    223    5            �           0    0    TABLE old_member    ACL     7   GRANT ALL ON TABLE izzup_api.old_member TO ultri_auth;
       	   izzup_api       	   izzup_api    false    246                       1259    25334    passwordless_member_accounts    VIEW     q  CREATE VIEW izzup_api.passwordless_member_accounts AS
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
 2   DROP VIEW izzup_api.passwordless_member_accounts;
    	   izzup_api          postgres    false    255    256    256    256    255    255    253    253    253    252    252    252    231    231    231    231    231    223    223    223    5            �            1259    17001    response    TABLE     *  CREATE TABLE izzup_api.response (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    comment_id bigint,
    response_id bigint,
    account_id bigint NOT NULL,
    nugget_id bigint NOT NULL
);
    DROP TABLE izzup_api.response;
    	   izzup_api         heap 	   izzup_api    false    5            �           0    0    TABLE response    ACL     5   GRANT ALL ON TABLE izzup_api.response TO ultri_auth;
       	   izzup_api       	   izzup_api    false    242            �            1259    17006    response_id_seq    SEQUENCE     {   CREATE SEQUENCE izzup_api.response_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE izzup_api.response_id_seq;
    	   izzup_api       	   izzup_api    false    242    5            �           0    0    response_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE izzup_api.response_id_seq OWNED BY izzup_api.response.id;
       	   izzup_api       	   izzup_api    false    243            �           0    0    SEQUENCE response_id_seq    ACL     ?   GRANT ALL ON SEQUENCE izzup_api.response_id_seq TO ultri_auth;
       	   izzup_api       	   izzup_api    false    243            �            1259    17007    service    TABLE       CREATE TABLE izzup_api.service (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    auth_required character varying(10) DEFAULT 'member'::character varying NOT NULL
);
    DROP TABLE izzup_api.service;
    	   izzup_api         heap 	   izzup_api    false    5            �           0    0    TABLE service    ACL     4   GRANT ALL ON TABLE izzup_api.service TO ultri_auth;
       	   izzup_api       	   izzup_api    false    244            �            1259    17014    service_id_seq    SEQUENCE     z   CREATE SEQUENCE izzup_api.service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE izzup_api.service_id_seq;
    	   izzup_api       	   izzup_api    false    244    5            �           0    0    service_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE izzup_api.service_id_seq OWNED BY izzup_api.service.id;
       	   izzup_api       	   izzup_api    false    245            �           0    0    SEQUENCE service_id_seq    ACL     >   GRANT ALL ON SEQUENCE izzup_api.service_id_seq TO ultri_auth;
       	   izzup_api       	   izzup_api    false    245            �            1259    16728    all_auth_recipe_users    TABLE     �   CREATE TABLE ultri_auth.all_auth_recipe_users (
    user_id character(36) NOT NULL,
    recipe_id character varying(128) NOT NULL,
    time_joined bigint NOT NULL
);
 -   DROP TABLE ultri_auth.all_auth_recipe_users;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16748    emailpassword_users    TABLE     �   CREATE TABLE ultri_auth.emailpassword_users (
    user_id character(36) NOT NULL,
    email character varying(256) NOT NULL,
    password_hash character varying(256) NOT NULL,
    time_joined bigint NOT NULL
);
 +   DROP TABLE ultri_auth.emailpassword_users;
    
   ultri_auth         heap 
   ultri_auth    false    7                       1259    25356    v_combined_users    VIEW     _  CREATE VIEW izzup_api.v_combined_users AS
 SELECT u.user_id AS "memberUid",
    COALESCE(pu.email, eu.email) AS email,
    pu.phone_number AS tel
   FROM ((ultri_auth.all_auth_recipe_users u
     LEFT JOIN ultri_auth.passwordless_users pu ON ((pu.user_id = u.user_id)))
     LEFT JOIN ultri_auth.emailpassword_users eu ON ((eu.user_id = u.user_id)));
 &   DROP VIEW izzup_api.v_combined_users;
    	   izzup_api          postgres    false    223    223    223    217    217    214    5                       1259    17349    member_permissions    VIEW     �   CREATE VIEW public.member_permissions AS
 SELECT ma."memberUid",
    ma."accountUid",
    r.name AS "roleName",
    r.permissions
   FROM (izzup_api.member_accounts ma
     JOIN izzup_api.role r ON (((r.name)::text = ANY (ma."accountRoles"))));
 %   DROP VIEW public.member_permissions;
       public          postgres    false    257    257    257    247    247            �            1259    16757    emailpassword_pswd_reset_tokens    TABLE     �   CREATE TABLE ultri_auth.emailpassword_pswd_reset_tokens (
    user_id character(36) NOT NULL,
    token character varying(128) NOT NULL,
    token_expiry bigint NOT NULL
);
 7   DROP TABLE ultri_auth.emailpassword_pswd_reset_tokens;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16775    emailverification_tokens    TABLE     �   CREATE TABLE ultri_auth.emailverification_tokens (
    user_id character varying(128) NOT NULL,
    email character varying(256) NOT NULL,
    token character varying(128) NOT NULL,
    token_expiry bigint NOT NULL
);
 0   DROP TABLE ultri_auth.emailverification_tokens;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16770 !   emailverification_verified_emails    TABLE     �   CREATE TABLE ultri_auth.emailverification_verified_emails (
    user_id character varying(128) NOT NULL,
    email character varying(256) NOT NULL
);
 9   DROP TABLE ultri_auth.emailverification_verified_emails;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16794    jwt_signing_keys    TABLE     �   CREATE TABLE ultri_auth.jwt_signing_keys (
    key_id character varying(255) NOT NULL,
    key_string text NOT NULL,
    algorithm character varying(10) NOT NULL,
    created_at bigint
);
 (   DROP TABLE ultri_auth.jwt_signing_keys;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16721 	   key_value    TABLE     |   CREATE TABLE ultri_auth.key_value (
    name character varying(128) NOT NULL,
    value text,
    created_at_time bigint
);
 !   DROP TABLE ultri_auth.key_value;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16821    passwordless_codes    TABLE     �   CREATE TABLE ultri_auth.passwordless_codes (
    code_id character(36) NOT NULL,
    device_id_hash character(44) NOT NULL,
    link_code_hash character(44) NOT NULL,
    created_at bigint NOT NULL
);
 *   DROP TABLE ultri_auth.passwordless_codes;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16812    passwordless_devices    TABLE     �   CREATE TABLE ultri_auth.passwordless_devices (
    device_id_hash character(44) NOT NULL,
    email character varying(256),
    phone_number character varying(256),
    link_code_salt character(44) NOT NULL,
    failed_attempts integer NOT NULL
);
 ,   DROP TABLE ultri_auth.passwordless_devices;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16847    role_permissions    TABLE     �   CREATE TABLE ultri_auth.role_permissions (
    role character varying(255) NOT NULL,
    permission character varying(255) NOT NULL
);
 (   DROP TABLE ultri_auth.role_permissions;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16842    roles    TABLE     L   CREATE TABLE ultri_auth.roles (
    role character varying(255) NOT NULL
);
    DROP TABLE ultri_auth.roles;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16734 !   session_access_token_signing_keys    TABLE     s   CREATE TABLE ultri_auth.session_access_token_signing_keys (
    created_at_time bigint NOT NULL,
    value text
);
 9   DROP TABLE ultri_auth.session_access_token_signing_keys;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16741    session_info    TABLE     ;  CREATE TABLE ultri_auth.session_info (
    session_handle character varying(255) NOT NULL,
    user_id character varying(128) NOT NULL,
    refresh_token_hash_2 character varying(128) NOT NULL,
    session_data text,
    expires_at bigint NOT NULL,
    created_at_time bigint NOT NULL,
    jwt_user_payload text
);
 $   DROP TABLE ultri_auth.session_info;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16785    thirdparty_users    TABLE     	  CREATE TABLE ultri_auth.thirdparty_users (
    third_party_id character varying(28) NOT NULL,
    third_party_user_id character varying(256) NOT NULL,
    user_id character(36) NOT NULL,
    email character varying(256) NOT NULL,
    time_joined bigint NOT NULL
);
 (   DROP TABLE ultri_auth.thirdparty_users;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16835    user_metadata    TABLE     x   CREATE TABLE ultri_auth.user_metadata (
    user_id character varying(128) NOT NULL,
    user_metadata text NOT NULL
);
 %   DROP TABLE ultri_auth.user_metadata;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16860 
   user_roles    TABLE     ~   CREATE TABLE ultri_auth.user_roles (
    user_id character varying(128) NOT NULL,
    role character varying(255) NOT NULL
);
 "   DROP TABLE ultri_auth.user_roles;
    
   ultri_auth         heap 
   ultri_auth    false    7            �            1259    16871    userid_mapping    TABLE     �   CREATE TABLE ultri_auth.userid_mapping (
    supertokens_user_id character(36) NOT NULL,
    external_user_id character varying(128) NOT NULL,
    external_user_id_info text
);
 &   DROP TABLE ultri_auth.userid_mapping;
    
   ultri_auth         heap 
   ultri_auth    false    7                       1259    25360    v_combined_users    VIEW     `  CREATE VIEW ultri_auth.v_combined_users AS
 SELECT u.user_id AS "memberUid",
    COALESCE(pu.email, eu.email) AS email,
    pu.phone_number AS tel
   FROM ((ultri_auth.all_auth_recipe_users u
     LEFT JOIN ultri_auth.passwordless_users pu ON ((pu.user_id = u.user_id)))
     LEFT JOIN ultri_auth.emailpassword_users eu ON ((eu.user_id = u.user_id)));
 '   DROP VIEW ultri_auth.v_combined_users;
    
   ultri_auth          postgres    false    214    223    217    223    223    217    7            %           2604    17015 
   account id    DEFAULT     n   ALTER TABLE ONLY izzup_api.account ALTER COLUMN id SET DEFAULT nextval('izzup_api.account_id_seq'::regclass);
 <   ALTER TABLE izzup_api.account ALTER COLUMN id DROP DEFAULT;
    	   izzup_api       	   izzup_api    false    232    231            E           2604    17321    account_group id    DEFAULT     z   ALTER TABLE ONLY izzup_api.account_group ALTER COLUMN id SET DEFAULT nextval('izzup_api.account_group_id_seq'::regclass);
 B   ALTER TABLE izzup_api.account_group ALTER COLUMN id DROP DEFAULT;
    	   izzup_api          postgres    false    255    254    255            >           2604    25340    account_role id    DEFAULT     x   ALTER TABLE ONLY izzup_api.account_role ALTER COLUMN id SET DEFAULT nextval('izzup_api.account_role_id_seq'::regclass);
 A   ALTER TABLE izzup_api.account_role ALTER COLUMN id DROP DEFAULT;
    	   izzup_api          postgres    false    261    248            )           2604    17017    block_type id    DEFAULT     u   ALTER TABLE ONLY izzup_api.block_type ALTER COLUMN id SET DEFAULT nextval('izzup_api.block_types_id_seq'::regclass);
 ?   ALTER TABLE izzup_api.block_type ALTER COLUMN id DROP DEFAULT;
    	   izzup_api       	   izzup_api    false    235    234            C           2604    17288 	   member id    DEFAULT     l   ALTER TABLE ONLY izzup_api.member ALTER COLUMN id SET DEFAULT nextval('izzup_api.member_id_seq'::regclass);
 ;   ALTER TABLE izzup_api.member ALTER COLUMN id DROP DEFAULT;
    	   izzup_api       	   izzup_api    false    252    251    252            ,           2604    17018 	   nugget id    DEFAULT     l   ALTER TABLE ONLY izzup_api.nugget ALTER COLUMN id SET DEFAULT nextval('izzup_api.nugget_id_seq'::regclass);
 ;   ALTER TABLE izzup_api.nugget ALTER COLUMN id DROP DEFAULT;
    	   izzup_api       	   izzup_api    false    239    236            0           2604    17019    nugget_comment id    DEFAULT     |   ALTER TABLE ONLY izzup_api.nugget_comment ALTER COLUMN id SET DEFAULT nextval('izzup_api.nugget_comment_id_seq'::regclass);
 C   ALTER TABLE izzup_api.nugget_comment ALTER COLUMN id DROP DEFAULT;
    	   izzup_api       	   izzup_api    false    238    237            4           2604    17021    response id    DEFAULT     p   ALTER TABLE ONLY izzup_api.response ALTER COLUMN id SET DEFAULT nextval('izzup_api.response_id_seq'::regclass);
 =   ALTER TABLE izzup_api.response ALTER COLUMN id DROP DEFAULT;
    	   izzup_api       	   izzup_api    false    243    242            7           2604    17022 
   service id    DEFAULT     n   ALTER TABLE ONLY izzup_api.service ALTER COLUMN id SET DEFAULT nextval('izzup_api.service_id_seq'::regclass);
 <   ALTER TABLE izzup_api.service ALTER COLUMN id DROP DEFAULT;
    	   izzup_api       	   izzup_api    false    245    244            j          0    16936    account 
   TABLE DATA           I   COPY izzup_api.account (id, uid, created_at, name, personal) FROM stdin;
 	   izzup_api       	   izzup_api    false    231   �J      �          0    17318    account_group 
   TABLE DATA           X   COPY izzup_api.account_group (id, uid, account_id, created_at, name, roles) FROM stdin;
 	   izzup_api          postgres    false    255   
T      �          0    17335    account_group_member 
   TABLE DATA           Z   COPY izzup_api.account_group_member (account_group_id, member_id, created_at) FROM stdin;
 	   izzup_api       	   izzup_api    false    256   sT                0    17296    account_member 
   TABLE DATA           a   COPY izzup_api.account_member (account_id, member_id, created_at, updated_at, roles) FROM stdin;
 	   izzup_api       	   izzup_api    false    253   �T      |          0    17247    account_nugget_type 
   TABLE DATA           S   COPY izzup_api.account_nugget_type (uid, name, created_at, account_id) FROM stdin;
 	   izzup_api       	   izzup_api    false    250   �U      z          0    17220    account_role 
   TABLE DATA           ]   COPY izzup_api.account_role (uid, name, created_at, permissions, account_id, id) FROM stdin;
 	   izzup_api          postgres    false    248   �U      m          0    16959 
   block_type 
   TABLE DATA           =   COPY izzup_api.block_type (id, name, created_at) FROM stdin;
 	   izzup_api       	   izzup_api    false    234   �V      ~          0    17285    member 
   TABLE DATA           8   COPY izzup_api.member (id, uid, created_at) FROM stdin;
 	   izzup_api       	   izzup_api    false    252   �V      o          0    16968    nugget 
   TABLE DATA           �   COPY izzup_api.nugget (id, uid, created_at, updated_at, pub_at, un_pub_at, public_title, internal_name, account_id, blocks, nugget_type) FROM stdin;
 	   izzup_api       	   izzup_api    false    236   \X      p          0    16979    nugget_comment 
   TABLE DATA           Z   COPY izzup_api.nugget_comment (id, uid, "created_at ", account_id, nugget_id) FROM stdin;
 	   izzup_api       	   izzup_api    false    237   �d      s          0    16986    nugget_member 
   TABLE DATA           K   COPY izzup_api.nugget_member (nugget_id, member_id, linked_at) FROM stdin;
 	   izzup_api       	   izzup_api    false    240   e      t          0    16993    nugget_reaction 
   TABLE DATA           N   COPY izzup_api.nugget_reaction (nugget_id, account_id, member_id) FROM stdin;
 	   izzup_api       	   izzup_api    false    241   (e      {          0    17235    nugget_type 
   TABLE DATA           ?   COPY izzup_api.nugget_type (uid, name, created_at) FROM stdin;
 	   izzup_api          postgres    false    249   Ee      l          0    16942    old_account_member 
   TABLE DATA           ]   COPY izzup_api.old_account_member (account_id, member_uid, linked_at, role_uids) FROM stdin;
 	   izzup_api       	   izzup_api    false    233   kk      u          0    17001    response 
   TABLE DATA           j   COPY izzup_api.response (id, uid, created_at, comment_id, response_id, account_id, nugget_id) FROM stdin;
 	   izzup_api       	   izzup_api    false    242   �n      y          0    17208    role 
   TABLE DATA           E   COPY izzup_api.role (uid, name, created_at, permissions) FROM stdin;
 	   izzup_api          postgres    false    247   �n      w          0    17007    service 
   TABLE DATA           N   COPY izzup_api.service (id, name, url, created_at, auth_required) FROM stdin;
 	   izzup_api       	   izzup_api    false    244   @p      Y          0    16728    all_auth_recipe_users 
   TABLE DATA           T   COPY ultri_auth.all_auth_recipe_users (user_id, recipe_id, time_joined) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    214   �p      ]          0    16757    emailpassword_pswd_reset_tokens 
   TABLE DATA           [   COPY ultri_auth.emailpassword_pswd_reset_tokens (user_id, token, token_expiry) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    218   �t      \          0    16748    emailpassword_users 
   TABLE DATA           ]   COPY ultri_auth.emailpassword_users (user_id, email, password_hash, time_joined) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    217   �t      _          0    16775    emailverification_tokens 
   TABLE DATA           [   COPY ultri_auth.emailverification_tokens (user_id, email, token, token_expiry) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    220   �t      ^          0    16770 !   emailverification_verified_emails 
   TABLE DATA           O   COPY ultri_auth.emailverification_verified_emails (user_id, email) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    219   �t      a          0    16794    jwt_signing_keys 
   TABLE DATA           Y   COPY ultri_auth.jwt_signing_keys (key_id, key_string, algorithm, created_at) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    222   �t      X          0    16721 	   key_value 
   TABLE DATA           E   COPY ultri_auth.key_value (name, value, created_at_time) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    213   M{      d          0    16821    passwordless_codes 
   TABLE DATA           e   COPY ultri_auth.passwordless_codes (code_id, device_id_hash, link_code_hash, created_at) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    225   v|      c          0    16812    passwordless_devices 
   TABLE DATA           x   COPY ultri_auth.passwordless_devices (device_id_hash, email, phone_number, link_code_salt, failed_attempts) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    224   �|      b          0    16801    passwordless_users 
   TABLE DATA           [   COPY ultri_auth.passwordless_users (user_id, email, phone_number, time_joined) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    223   �|      g          0    16847    role_permissions 
   TABLE DATA           @   COPY ultri_auth.role_permissions (role, permission) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    228   ��      f          0    16842    roles 
   TABLE DATA           )   COPY ultri_auth.roles (role) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    227   ��      Z          0    16734 !   session_access_token_signing_keys 
   TABLE DATA           W   COPY ultri_auth.session_access_token_signing_keys (created_at_time, value) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    215   ځ      [          0    16741    session_info 
   TABLE DATA           �   COPY ultri_auth.session_info (session_handle, user_id, refresh_token_hash_2, session_data, expires_at, created_at_time, jwt_user_payload) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    216   �      `          0    16785    thirdparty_users 
   TABLE DATA           p   COPY ultri_auth.thirdparty_users (third_party_id, third_party_user_id, user_id, email, time_joined) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    221   ��      e          0    16835    user_metadata 
   TABLE DATA           C   COPY ultri_auth.user_metadata (user_id, user_metadata) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    226   �      h          0    16860 
   user_roles 
   TABLE DATA           7   COPY ultri_auth.user_roles (user_id, role) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    229   6�      i          0    16871    userid_mapping 
   TABLE DATA           j   COPY ultri_auth.userid_mapping (supertokens_user_id, external_user_id, external_user_id_info) FROM stdin;
 
   ultri_auth       
   ultri_auth    false    230   S�      �           0    0    account_group_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('izzup_api.account_group_id_seq', 1, true);
       	   izzup_api          postgres    false    254            �           0    0    account_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('izzup_api.account_id_seq', 59, true);
       	   izzup_api       	   izzup_api    false    232            �           0    0    account_role_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('izzup_api.account_role_id_seq', 2, true);
       	   izzup_api          postgres    false    261            �           0    0    block_types_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('izzup_api.block_types_id_seq', 1, false);
       	   izzup_api       	   izzup_api    false    235            �           0    0    member_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('izzup_api.member_id_seq', 14, true);
       	   izzup_api       	   izzup_api    false    251            �           0    0    nugget_comment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('izzup_api.nugget_comment_id_seq', 1, false);
       	   izzup_api       	   izzup_api    false    238            �           0    0    nugget_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('izzup_api.nugget_id_seq', 97, true);
       	   izzup_api       	   izzup_api    false    239            �           0    0    response_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('izzup_api.response_id_seq', 1, false);
       	   izzup_api       	   izzup_api    false    243            �           0    0    service_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('izzup_api.service_id_seq', 21, true);
       	   izzup_api       	   izzup_api    false    245            �           2606    17340 .   account_group_member account_group_member_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY izzup_api.account_group_member
    ADD CONSTRAINT account_group_member_pkey PRIMARY KEY (account_group_id, member_id);
 [   ALTER TABLE ONLY izzup_api.account_group_member DROP CONSTRAINT account_group_member_pkey;
    	   izzup_api         	   izzup_api    false    256    256            �           2606    17325     account_group account_group_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY izzup_api.account_group
    ADD CONSTRAINT account_group_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY izzup_api.account_group DROP CONSTRAINT account_group_pkey;
    	   izzup_api            postgres    false    255            �           2606    17024 &   old_account_member account_member_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY izzup_api.old_account_member
    ADD CONSTRAINT account_member_pkey PRIMARY KEY (account_id, member_uid);
 S   ALTER TABLE ONLY izzup_api.old_account_member DROP CONSTRAINT account_member_pkey;
    	   izzup_api         	   izzup_api    false    233    233            �           2606    17303 #   account_member account_member_pkey1 
   CONSTRAINT     w   ALTER TABLE ONLY izzup_api.account_member
    ADD CONSTRAINT account_member_pkey1 PRIMARY KEY (account_id, member_id);
 P   ALTER TABLE ONLY izzup_api.account_member DROP CONSTRAINT account_member_pkey1;
    	   izzup_api         	   izzup_api    false    253    253            �           2606    17026    account account_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY izzup_api.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);
 A   ALTER TABLE ONLY izzup_api.account DROP CONSTRAINT account_pkey;
    	   izzup_api         	   izzup_api    false    231            �           2606    25348    account_role account_role_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY izzup_api.account_role
    ADD CONSTRAINT account_role_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY izzup_api.account_role DROP CONSTRAINT account_role_pkey;
    	   izzup_api            postgres    false    248            �           2606    17030    block_type block_types_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY izzup_api.block_type
    ADD CONSTRAINT block_types_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY izzup_api.block_type DROP CONSTRAINT block_types_pkey;
    	   izzup_api         	   izzup_api    false    234            �           2606    17291    member member_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY izzup_api.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);
 ?   ALTER TABLE ONLY izzup_api.member DROP CONSTRAINT member_pkey;
    	   izzup_api         	   izzup_api    false    252            �           2606    17034 "   nugget_comment nugget_comment_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY izzup_api.nugget_comment
    ADD CONSTRAINT nugget_comment_pkey PRIMARY KEY (id);
 O   ALTER TABLE ONLY izzup_api.nugget_comment DROP CONSTRAINT nugget_comment_pkey;
    	   izzup_api         	   izzup_api    false    237            �           2606    17036     nugget_member nugget_member_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY izzup_api.nugget_member
    ADD CONSTRAINT nugget_member_pkey PRIMARY KEY (nugget_id, member_id);
 M   ALTER TABLE ONLY izzup_api.nugget_member DROP CONSTRAINT nugget_member_pkey;
    	   izzup_api         	   izzup_api    false    240    240            �           2606    17038    nugget nugget_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY izzup_api.nugget
    ADD CONSTRAINT nugget_pkey PRIMARY KEY (id);
 ?   ALTER TABLE ONLY izzup_api.nugget DROP CONSTRAINT nugget_pkey;
    	   izzup_api         	   izzup_api    false    236            �           2606    17040 $   nugget_reaction nugget_reaction_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY izzup_api.nugget_reaction
    ADD CONSTRAINT nugget_reaction_pkey PRIMARY KEY (nugget_id, account_id);
 Q   ALTER TABLE ONLY izzup_api.nugget_reaction DROP CONSTRAINT nugget_reaction_pkey;
    	   izzup_api         	   izzup_api    false    241    241            �           2606    17243    nugget_type nugget_type_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY izzup_api.nugget_type
    ADD CONSTRAINT nugget_type_pkey PRIMARY KEY (uid);
 I   ALTER TABLE ONLY izzup_api.nugget_type DROP CONSTRAINT nugget_type_pkey;
    	   izzup_api            postgres    false    249            �           2606    17044    response response_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY izzup_api.response
    ADD CONSTRAINT response_pkey PRIMARY KEY (id);
 C   ALTER TABLE ONLY izzup_api.response DROP CONSTRAINT response_pkey;
    	   izzup_api         	   izzup_api    false    242            �           2606    17217    role roles_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY izzup_api.role
    ADD CONSTRAINT roles_pkey PRIMARY KEY (uid);
 <   ALTER TABLE ONLY izzup_api.role DROP CONSTRAINT roles_pkey;
    	   izzup_api            postgres    false    247            �           2606    17046    service service_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY izzup_api.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);
 A   ALTER TABLE ONLY izzup_api.service DROP CONSTRAINT service_pkey;
    	   izzup_api         	   izzup_api    false    244            �           2606    17327 #   account_group uq_account_group_name 
   CONSTRAINT     m   ALTER TABLE ONLY izzup_api.account_group
    ADD CONSTRAINT uq_account_group_name UNIQUE (account_id, name);
 P   ALTER TABLE ONLY izzup_api.account_group DROP CONSTRAINT uq_account_group_name;
    	   izzup_api            postgres    false    255    255            �           2606    17255 /   account_nugget_type uq_account_nugget_type_name 
   CONSTRAINT     y   ALTER TABLE ONLY izzup_api.account_nugget_type
    ADD CONSTRAINT uq_account_nugget_type_name UNIQUE (name, account_id);
 \   ALTER TABLE ONLY izzup_api.account_nugget_type DROP CONSTRAINT uq_account_nugget_type_name;
    	   izzup_api         	   izzup_api    false    250    250            �           2606    17111    account uq_account_uid 
   CONSTRAINT     S   ALTER TABLE ONLY izzup_api.account
    ADD CONSTRAINT uq_account_uid UNIQUE (uid);
 C   ALTER TABLE ONLY izzup_api.account DROP CONSTRAINT uq_account_uid;
    	   izzup_api         	   izzup_api    false    231            �           2606    17229     account_role uq_acount_role_name 
   CONSTRAINT     j   ALTER TABLE ONLY izzup_api.account_role
    ADD CONSTRAINT uq_acount_role_name UNIQUE (account_id, name);
 M   ALTER TABLE ONLY izzup_api.account_role DROP CONSTRAINT uq_acount_role_name;
    	   izzup_api            postgres    false    248    248            �           2606    17295    member uq_member_uid 
   CONSTRAINT     Q   ALTER TABLE ONLY izzup_api.member
    ADD CONSTRAINT uq_member_uid UNIQUE (uid);
 A   ALTER TABLE ONLY izzup_api.member DROP CONSTRAINT uq_member_uid;
    	   izzup_api         	   izzup_api    false    252            �           2606    17246    nugget_type uq_nugget_type_name 
   CONSTRAINT     ]   ALTER TABLE ONLY izzup_api.nugget_type
    ADD CONSTRAINT uq_nugget_type_name UNIQUE (name);
 L   ALTER TABLE ONLY izzup_api.nugget_type DROP CONSTRAINT uq_nugget_type_name;
    	   izzup_api            postgres    false    249            �           2606    17113    nugget uq_nugget_uid 
   CONSTRAINT     Q   ALTER TABLE ONLY izzup_api.nugget
    ADD CONSTRAINT uq_nugget_uid UNIQUE (uid);
 A   ALTER TABLE ONLY izzup_api.nugget DROP CONSTRAINT uq_nugget_uid;
    	   izzup_api         	   izzup_api    false    236            �           2606    17219    role uq_role_name 
   CONSTRAINT     O   ALTER TABLE ONLY izzup_api.role
    ADD CONSTRAINT uq_role_name UNIQUE (name);
 >   ALTER TABLE ONLY izzup_api.role DROP CONSTRAINT uq_role_name;
    	   izzup_api            postgres    false    247            M           2606    16732 0   all_auth_recipe_users all_auth_recipe_users_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY ultri_auth.all_auth_recipe_users
    ADD CONSTRAINT all_auth_recipe_users_pkey PRIMARY KEY (user_id);
 ^   ALTER TABLE ONLY ultri_auth.all_auth_recipe_users DROP CONSTRAINT all_auth_recipe_users_pkey;
    
   ultri_auth         
   ultri_auth    false    214            X           2606    16761 D   emailpassword_pswd_reset_tokens emailpassword_pswd_reset_tokens_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.emailpassword_pswd_reset_tokens
    ADD CONSTRAINT emailpassword_pswd_reset_tokens_pkey PRIMARY KEY (user_id, token);
 r   ALTER TABLE ONLY ultri_auth.emailpassword_pswd_reset_tokens DROP CONSTRAINT emailpassword_pswd_reset_tokens_pkey;
    
   ultri_auth         
   ultri_auth    false    218    218            Z           2606    16763 I   emailpassword_pswd_reset_tokens emailpassword_pswd_reset_tokens_token_key 
   CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.emailpassword_pswd_reset_tokens
    ADD CONSTRAINT emailpassword_pswd_reset_tokens_token_key UNIQUE (token);
 w   ALTER TABLE ONLY ultri_auth.emailpassword_pswd_reset_tokens DROP CONSTRAINT emailpassword_pswd_reset_tokens_token_key;
    
   ultri_auth         
   ultri_auth    false    218            S           2606    16756 1   emailpassword_users emailpassword_users_email_key 
   CONSTRAINT     q   ALTER TABLE ONLY ultri_auth.emailpassword_users
    ADD CONSTRAINT emailpassword_users_email_key UNIQUE (email);
 _   ALTER TABLE ONLY ultri_auth.emailpassword_users DROP CONSTRAINT emailpassword_users_email_key;
    
   ultri_auth         
   ultri_auth    false    217            U           2606    16754 ,   emailpassword_users emailpassword_users_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY ultri_auth.emailpassword_users
    ADD CONSTRAINT emailpassword_users_pkey PRIMARY KEY (user_id);
 Z   ALTER TABLE ONLY ultri_auth.emailpassword_users DROP CONSTRAINT emailpassword_users_pkey;
    
   ultri_auth         
   ultri_auth    false    217            _           2606    16781 6   emailverification_tokens emailverification_tokens_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.emailverification_tokens
    ADD CONSTRAINT emailverification_tokens_pkey PRIMARY KEY (user_id, email, token);
 d   ALTER TABLE ONLY ultri_auth.emailverification_tokens DROP CONSTRAINT emailverification_tokens_pkey;
    
   ultri_auth         
   ultri_auth    false    220    220    220            a           2606    16783 ;   emailverification_tokens emailverification_tokens_token_key 
   CONSTRAINT     {   ALTER TABLE ONLY ultri_auth.emailverification_tokens
    ADD CONSTRAINT emailverification_tokens_token_key UNIQUE (token);
 i   ALTER TABLE ONLY ultri_auth.emailverification_tokens DROP CONSTRAINT emailverification_tokens_token_key;
    
   ultri_auth         
   ultri_auth    false    220            \           2606    16774 H   emailverification_verified_emails emailverification_verified_emails_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.emailverification_verified_emails
    ADD CONSTRAINT emailverification_verified_emails_pkey PRIMARY KEY (user_id, email);
 v   ALTER TABLE ONLY ultri_auth.emailverification_verified_emails DROP CONSTRAINT emailverification_verified_emails_pkey;
    
   ultri_auth         
   ultri_auth    false    219    219            g           2606    16800 &   jwt_signing_keys jwt_signing_keys_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY ultri_auth.jwt_signing_keys
    ADD CONSTRAINT jwt_signing_keys_pkey PRIMARY KEY (key_id);
 T   ALTER TABLE ONLY ultri_auth.jwt_signing_keys DROP CONSTRAINT jwt_signing_keys_pkey;
    
   ultri_auth         
   ultri_auth    false    222            J           2606    16727    key_value key_value_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY ultri_auth.key_value
    ADD CONSTRAINT key_value_pkey PRIMARY KEY (name);
 F   ALTER TABLE ONLY ultri_auth.key_value DROP CONSTRAINT key_value_pkey;
    
   ultri_auth         
   ultri_auth    false    213            u           2606    16827 8   passwordless_codes passwordless_codes_link_code_hash_key 
   CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.passwordless_codes
    ADD CONSTRAINT passwordless_codes_link_code_hash_key UNIQUE (link_code_hash);
 f   ALTER TABLE ONLY ultri_auth.passwordless_codes DROP CONSTRAINT passwordless_codes_link_code_hash_key;
    
   ultri_auth         
   ultri_auth    false    225            w           2606    16825 *   passwordless_codes passwordless_codes_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY ultri_auth.passwordless_codes
    ADD CONSTRAINT passwordless_codes_pkey PRIMARY KEY (code_id);
 X   ALTER TABLE ONLY ultri_auth.passwordless_codes DROP CONSTRAINT passwordless_codes_pkey;
    
   ultri_auth         
   ultri_auth    false    225            q           2606    16818 .   passwordless_devices passwordless_devices_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY ultri_auth.passwordless_devices
    ADD CONSTRAINT passwordless_devices_pkey PRIMARY KEY (device_id_hash);
 \   ALTER TABLE ONLY ultri_auth.passwordless_devices DROP CONSTRAINT passwordless_devices_pkey;
    
   ultri_auth         
   ultri_auth    false    224            i           2606    16809 /   passwordless_users passwordless_users_email_key 
   CONSTRAINT     o   ALTER TABLE ONLY ultri_auth.passwordless_users
    ADD CONSTRAINT passwordless_users_email_key UNIQUE (email);
 ]   ALTER TABLE ONLY ultri_auth.passwordless_users DROP CONSTRAINT passwordless_users_email_key;
    
   ultri_auth         
   ultri_auth    false    223            k           2606    16811 6   passwordless_users passwordless_users_phone_number_key 
   CONSTRAINT     }   ALTER TABLE ONLY ultri_auth.passwordless_users
    ADD CONSTRAINT passwordless_users_phone_number_key UNIQUE (phone_number);
 d   ALTER TABLE ONLY ultri_auth.passwordless_users DROP CONSTRAINT passwordless_users_phone_number_key;
    
   ultri_auth         
   ultri_auth    false    223            m           2606    16807 *   passwordless_users passwordless_users_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY ultri_auth.passwordless_users
    ADD CONSTRAINT passwordless_users_pkey PRIMARY KEY (user_id);
 X   ALTER TABLE ONLY ultri_auth.passwordless_users DROP CONSTRAINT passwordless_users_pkey;
    
   ultri_auth         
   ultri_auth    false    223            ~           2606    16853 &   role_permissions role_permissions_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY ultri_auth.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role, permission);
 T   ALTER TABLE ONLY ultri_auth.role_permissions DROP CONSTRAINT role_permissions_pkey;
    
   ultri_auth         
   ultri_auth    false    228    228            {           2606    16846    roles roles_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY ultri_auth.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role);
 >   ALTER TABLE ONLY ultri_auth.roles DROP CONSTRAINT roles_pkey;
    
   ultri_auth         
   ultri_auth    false    227            O           2606    16740 H   session_access_token_signing_keys session_access_token_signing_keys_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.session_access_token_signing_keys
    ADD CONSTRAINT session_access_token_signing_keys_pkey PRIMARY KEY (created_at_time);
 v   ALTER TABLE ONLY ultri_auth.session_access_token_signing_keys DROP CONSTRAINT session_access_token_signing_keys_pkey;
    
   ultri_auth         
   ultri_auth    false    215            Q           2606    16747    session_info session_info_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY ultri_auth.session_info
    ADD CONSTRAINT session_info_pkey PRIMARY KEY (session_handle);
 L   ALTER TABLE ONLY ultri_auth.session_info DROP CONSTRAINT session_info_pkey;
    
   ultri_auth         
   ultri_auth    false    216            c           2606    16791 &   thirdparty_users thirdparty_users_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.thirdparty_users
    ADD CONSTRAINT thirdparty_users_pkey PRIMARY KEY (third_party_id, third_party_user_id);
 T   ALTER TABLE ONLY ultri_auth.thirdparty_users DROP CONSTRAINT thirdparty_users_pkey;
    
   ultri_auth         
   ultri_auth    false    221    221            e           2606    16793 -   thirdparty_users thirdparty_users_user_id_key 
   CONSTRAINT     o   ALTER TABLE ONLY ultri_auth.thirdparty_users
    ADD CONSTRAINT thirdparty_users_user_id_key UNIQUE (user_id);
 [   ALTER TABLE ONLY ultri_auth.thirdparty_users DROP CONSTRAINT thirdparty_users_user_id_key;
    
   ultri_auth         
   ultri_auth    false    221            y           2606    16841     user_metadata user_metadata_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY ultri_auth.user_metadata
    ADD CONSTRAINT user_metadata_pkey PRIMARY KEY (user_id);
 N   ALTER TABLE ONLY ultri_auth.user_metadata DROP CONSTRAINT user_metadata_pkey;
    
   ultri_auth         
   ultri_auth    false    226            �           2606    16864    user_roles user_roles_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY ultri_auth.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role);
 H   ALTER TABLE ONLY ultri_auth.user_roles DROP CONSTRAINT user_roles_pkey;
    
   ultri_auth         
   ultri_auth    false    229    229            �           2606    16881 2   userid_mapping userid_mapping_external_user_id_key 
   CONSTRAINT     }   ALTER TABLE ONLY ultri_auth.userid_mapping
    ADD CONSTRAINT userid_mapping_external_user_id_key UNIQUE (external_user_id);
 `   ALTER TABLE ONLY ultri_auth.userid_mapping DROP CONSTRAINT userid_mapping_external_user_id_key;
    
   ultri_auth         
   ultri_auth    false    230            �           2606    16877 "   userid_mapping userid_mapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.userid_mapping
    ADD CONSTRAINT userid_mapping_pkey PRIMARY KEY (supertokens_user_id, external_user_id);
 P   ALTER TABLE ONLY ultri_auth.userid_mapping DROP CONSTRAINT userid_mapping_pkey;
    
   ultri_auth         
   ultri_auth    false    230    230            �           2606    16879 5   userid_mapping userid_mapping_supertokens_user_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.userid_mapping
    ADD CONSTRAINT userid_mapping_supertokens_user_id_key UNIQUE (supertokens_user_id);
 c   ALTER TABLE ONLY ultri_auth.userid_mapping DROP CONSTRAINT userid_mapping_supertokens_user_id_key;
    
   ultri_auth         
   ultri_auth    false    230            �           1259    17060    ix_account_member_member_uid    INDEX     y   CREATE INDEX ix_account_member_member_uid ON izzup_api.old_account_member USING btree (member_uid) INCLUDE (account_id);
 3   DROP INDEX izzup_api.ix_account_member_member_uid;
    	   izzup_api         	   izzup_api    false    233    233            K           1259    16733 &   all_auth_recipe_users_pagination_index    INDEX     �   CREATE INDEX all_auth_recipe_users_pagination_index ON ultri_auth.all_auth_recipe_users USING btree (time_joined DESC, user_id DESC);
 >   DROP INDEX ultri_auth.all_auth_recipe_users_pagination_index;
    
   ultri_auth         
   ultri_auth    false    214    214            V           1259    16769 /   emailpassword_password_reset_token_expiry_index    INDEX     �   CREATE INDEX emailpassword_password_reset_token_expiry_index ON ultri_auth.emailpassword_pswd_reset_tokens USING btree (token_expiry);
 G   DROP INDEX ultri_auth.emailpassword_password_reset_token_expiry_index;
    
   ultri_auth         
   ultri_auth    false    218            ]           1259    16784    emailverification_tokens_index    INDEX     o   CREATE INDEX emailverification_tokens_index ON ultri_auth.emailverification_tokens USING btree (token_expiry);
 6   DROP INDEX ultri_auth.emailverification_tokens_index;
    
   ultri_auth         
   ultri_auth    false    220            r           1259    16833 #   passwordless_codes_created_at_index    INDEX     l   CREATE INDEX passwordless_codes_created_at_index ON ultri_auth.passwordless_codes USING btree (created_at);
 ;   DROP INDEX ultri_auth.passwordless_codes_created_at_index;
    
   ultri_auth         
   ultri_auth    false    225            s           1259    16834 '   passwordless_codes_device_id_hash_index    INDEX     t   CREATE INDEX passwordless_codes_device_id_hash_index ON ultri_auth.passwordless_codes USING btree (device_id_hash);
 ?   DROP INDEX ultri_auth.passwordless_codes_device_id_hash_index;
    
   ultri_auth         
   ultri_auth    false    225            n           1259    16819     passwordless_devices_email_index    INDEX     f   CREATE INDEX passwordless_devices_email_index ON ultri_auth.passwordless_devices USING btree (email);
 8   DROP INDEX ultri_auth.passwordless_devices_email_index;
    
   ultri_auth         
   ultri_auth    false    224            o           1259    16820 '   passwordless_devices_phone_number_index    INDEX     t   CREATE INDEX passwordless_devices_phone_number_index ON ultri_auth.passwordless_devices USING btree (phone_number);
 ?   DROP INDEX ultri_auth.passwordless_devices_phone_number_index;
    
   ultri_auth         
   ultri_auth    false    224            |           1259    16859 !   role_permissions_permission_index    INDEX     h   CREATE INDEX role_permissions_permission_index ON ultri_auth.role_permissions USING btree (permission);
 9   DROP INDEX ultri_auth.role_permissions_permission_index;
    
   ultri_auth         
   ultri_auth    false    228            �           1259    16870    user_roles_role_index    INDEX     P   CREATE INDEX user_roles_role_index ON ultri_auth.user_roles USING btree (role);
 -   DROP INDEX ultri_auth.user_roles_role_index;
    
   ultri_auth         
   ultri_auth    false    229            �           2620    17316 *   passwordless_users new_user_member_account    TRIGGER     �   CREATE TRIGGER new_user_member_account AFTER INSERT ON ultri_auth.passwordless_users FOR EACH ROW EXECUTE FUNCTION izzup_api.new_member_from_user();
 G   DROP TRIGGER new_user_member_account ON ultri_auth.passwordless_users;
    
   ultri_auth       
   ultri_auth    false    285    223            �           2606    17330 )   account_group fk_account_group_account_id    FK CONSTRAINT     �   ALTER TABLE ONLY izzup_api.account_group
    ADD CONSTRAINT fk_account_group_account_id FOREIGN KEY (account_id) REFERENCES izzup_api.account(id) NOT VALID;
 V   ALTER TABLE ONLY izzup_api.account_group DROP CONSTRAINT fk_account_group_account_id;
    	   izzup_api          postgres    false    231    3465    255            �           2606    17309 +   account_member fk_account_member_account_id    FK CONSTRAINT     �   ALTER TABLE ONLY izzup_api.account_member
    ADD CONSTRAINT fk_account_member_account_id FOREIGN KEY (account_id) REFERENCES izzup_api.account(id);
 X   ALTER TABLE ONLY izzup_api.account_member DROP CONSTRAINT fk_account_member_account_id;
    	   izzup_api       	   izzup_api    false    231    253    3465            �           2606    17304 *   account_member fk_account_member_member_id    FK CONSTRAINT     �   ALTER TABLE ONLY izzup_api.account_member
    ADD CONSTRAINT fk_account_member_member_id FOREIGN KEY (member_id) REFERENCES izzup_api.member(id);
 W   ALTER TABLE ONLY izzup_api.account_member DROP CONSTRAINT fk_account_member_member_id;
    	   izzup_api       	   izzup_api    false    253    252    3502            �           2606    17256 5   account_nugget_type fk_account_nugget_type_account_id    FK CONSTRAINT     �   ALTER TABLE ONLY izzup_api.account_nugget_type
    ADD CONSTRAINT fk_account_nugget_type_account_id FOREIGN KEY (account_id) REFERENCES izzup_api.account(id) NOT VALID;
 b   ALTER TABLE ONLY izzup_api.account_nugget_type DROP CONSTRAINT fk_account_nugget_type_account_id;
    	   izzup_api       	   izzup_api    false    231    250    3465            �           2606    17230 '   account_role fk_account_role_account_id    FK CONSTRAINT     �   ALTER TABLE ONLY izzup_api.account_role
    ADD CONSTRAINT fk_account_role_account_id FOREIGN KEY (account_id) REFERENCES izzup_api.account(id) NOT VALID;
 T   ALTER TABLE ONLY izzup_api.account_role DROP CONSTRAINT fk_account_role_account_id;
    	   izzup_api          postgres    false    3465    248    231            �           2606    17261    nugget fk_nugget_account_id    FK CONSTRAINT     �   ALTER TABLE ONLY izzup_api.nugget
    ADD CONSTRAINT fk_nugget_account_id FOREIGN KEY (account_id) REFERENCES izzup_api.account(id) NOT VALID;
 H   ALTER TABLE ONLY izzup_api.nugget DROP CONSTRAINT fk_nugget_account_id;
    	   izzup_api       	   izzup_api    false    231    3465    236            �           2606    16764 L   emailpassword_pswd_reset_tokens emailpassword_pswd_reset_tokens_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.emailpassword_pswd_reset_tokens
    ADD CONSTRAINT emailpassword_pswd_reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES ultri_auth.emailpassword_users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;
 z   ALTER TABLE ONLY ultri_auth.emailpassword_pswd_reset_tokens DROP CONSTRAINT emailpassword_pswd_reset_tokens_user_id_fkey;
    
   ultri_auth       
   ultri_auth    false    3413    217    218            �           2606    16828 9   passwordless_codes passwordless_codes_device_id_hash_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.passwordless_codes
    ADD CONSTRAINT passwordless_codes_device_id_hash_fkey FOREIGN KEY (device_id_hash) REFERENCES ultri_auth.passwordless_devices(device_id_hash) ON UPDATE CASCADE ON DELETE CASCADE;
 g   ALTER TABLE ONLY ultri_auth.passwordless_codes DROP CONSTRAINT passwordless_codes_device_id_hash_fkey;
    
   ultri_auth       
   ultri_auth    false    225    3441    224            �           2606    16854 +   role_permissions role_permissions_role_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.role_permissions
    ADD CONSTRAINT role_permissions_role_fkey FOREIGN KEY (role) REFERENCES ultri_auth.roles(role) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY ultri_auth.role_permissions DROP CONSTRAINT role_permissions_role_fkey;
    
   ultri_auth       
   ultri_auth    false    228    227    3451            �           2606    16865    user_roles user_roles_role_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.user_roles
    ADD CONSTRAINT user_roles_role_fkey FOREIGN KEY (role) REFERENCES ultri_auth.roles(role) ON DELETE CASCADE;
 M   ALTER TABLE ONLY ultri_auth.user_roles DROP CONSTRAINT user_roles_role_fkey;
    
   ultri_auth       
   ultri_auth    false    3451    229    227            �           2606    16882 6   userid_mapping userid_mapping_supertokens_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY ultri_auth.userid_mapping
    ADD CONSTRAINT userid_mapping_supertokens_user_id_fkey FOREIGN KEY (supertokens_user_id) REFERENCES ultri_auth.all_auth_recipe_users(user_id) ON DELETE CASCADE;
 d   ALTER TABLE ONLY ultri_auth.userid_mapping DROP CONSTRAINT userid_mapping_supertokens_user_id_fkey;
    
   ultri_auth       
   ultri_auth    false    230    214    3405            j   F	  x�}XɎ$�=�|E�@�F����E�m}�%Vx -�h��z�����K94��U/�$�¦�j+2Y��9��\C��!��'�yp�"~��F���Ꙏ�?��?~�C}������f�z��8�Z5���H9K����Po�\�����?����=��ц��Y�"Gq�c0r
��`�e��^����v��3�����/��|7h������Ǐ ·J�$3�5"�,��7�u��y��%�30�%�[�[�+���������2�S�1�I#pmi�s{ &�e�{J|
|Y?}�����4j"N��RJ�d�ۚ���a3��׺G��R�0�8�J��W˗�`���"���
⢒��j� _��a����ijG~�1&�0�3�[Z��10�Z����/�:Ӎ�5)i,_�@d��W,�
�J���$F������{֎���o5��g�Ts�L�����%0g�r	4J��AԂ1��V<��Dm���v	t`�s�ha�.t|Ҵ����{�%��į�=Yf�w#��Օ������It�*�>jL��x�.r*���P(;���jy� �}e2��I	�t���\x���`+��֮��MHGnD��mm�A��@r�Ŵ��ο-APE�5����У�t�!�4�T���P3�"]mӁ�@����� �v
�d��qY%�R�%�m�F"����"�y��a��f�3��DP&����{ʕb	�i`ƒ�Lq������x���
��,9�0�0`KZ�ԇ��6��]A9ZM��Kh�D#&�j$��2ެD����JbٟPҗ*�\Xu�P�Z���G�5a�w	
�UZi���ᓑch^��ڽs�+fz(ۘ�tPyBI�Qf�1 �H�����CD۝�FY�Gl��VH��p+��Py6 =���1b�O�@�`I�B/���x�=��fY�U�"�?�ƢJdZ�V��iD�ܗHїl�s�6����˗K+�;�8Byv�A`<���VU^ۢ�a�$������:.�۪�tͭuz]�1����NO�:A��)`��uB�����2�z�騚9/a�O����jN����r�]Ȱ�x5(gz�Q#��i;�Tد�4w&)M�>(E�}@�
*3)A{+��
UUyI*�ۤ�o��Sy�L�^K`ϱbϭ�z"4*���q9¶w	�(�����%=�O�U&ѱ���Q_֑��-���ذg�lk�$�.�k*%�4B�S�Pߌ`�EL�����0$Xu�ǫSn+��7%�WȐ����8�Y.��h-�������Ď8�K��Tԣ0�l]|����Rj�c��$��:��&���{Y�?���r��c�����!��p_�-	qBg�[��55#,�Sؔ/m�H+d���9�偰:FVV*�ekҧx';�%T�LA�!Ɓ��6��0|�����fE��?:|�,���a�+D������o%l�_"�L���D�8{8�%�+�&6wb�B1�P�g�9�#�2�))�6���!�5:w���m+a!J`T��I�}`����H�H"RH�	���A�>un�#�r�-z��������g�" a	�*.9j���5�4t���*������w��#A��|l��-AhG"]���ɡ��o���}8=�D=��f���R�r+�p2yՅ|��l3My��nr?���u���Z���֮��v-���	g��X`.p�7�e'zXFL
�!#���J#-i��V�Y҉{�Z���{������O�iCˑV���2�&$�WhwS�.#����o��t���\q��i���\�A�D��k`n��}�NC�H���!��l���J�v
�I�����Ň�b�l��f�@8w�����������#Җ�S��������Xg��؍w5���o4q�@�q���mk������M/_��.Cxaа�S�'�j{���v��'���a�������Ό���<�'����t�=�6iAp�kt41� �a������VP��	�5=�>���/(��ԑ��	�7�W�b:�}�9rw�EpWǮ��r#�\;V�o��6p9R�Er�GV����DlPd݅/�z�`���i�\I��?X,15W�?7�2���m+�F�A�Ҿ����	�7�E�WӨ��6Hw�W`�Y��ȶ�&�ӥ��N���Np�X9G����h��� ���2� ����ՠ	+�ܔ�Bk�	�N���^�j�|�q����܎\�ᢄ�}"�*�\��1T:4?��ox}_�k�����mpd�kE��k���N�Όf��JD���+a�X�s����w���z1$�      �   Y   x��1
�0�9=�HI"U��m6AQp�ox�V�:��l+�����;/�#�1� Pc�Nl2L*Y��Z��}���~���9��>�      �   +   x�3�4�4202�50�52T00�25�26ҳ4300����� n~         
  x�m�[JC1��Ut6���E��>�E
��"� ݻ9*r����矙p.�{�=��Q4��R����q9��p�r�TӉ|�>Qj�S��E� ��$USE7���,9PnM�F2�n�BA���!*���`��j4�ꌎ���8X��U�;�ꕫ�0�V
��6��:z[P��Z����:�Z��umG��Z7�b�^P�,��)�� t�lm�����O��m�_�s�b�
��ls.�+S5��َ�������t>�.o��P�e�Ӳ��      |      x������ � �      z   �   x�}�;n�0Dk�묰�\�ë$.(~�lȖ�w��H ��`��Gi�8�R��b!g@�!Q(9��.K]g��P����{����N=̺�s�]�o&l��|�w������t���s��u|�?ہ��e����T�)ҩt#[I�ܐ@bʈ�^����`�*�{^Η���Q��E<w-3���q�#��n�Vk�	˹I�      m      x������ � �      ~   v  x�]�ˑ\!E��$ ��B/��`6|��������X��)m+b��AOHE��;��9UZadT �Bz�=�Uː�G\@�L���.S��L��@�j���{� MKH;�ul5fZ\~���ԡMF@�}%�F_	b{l>'E���e5qsa�>���-��ڝ������+Z+j�p��ܠ4ʄN��:���c��,2�Hs�!�mo�9�~]����ʣ��W�rc�(ӭ%��a�_�M�bS�]��űU�2�vrg8���>���F�1t���'-W��	6��y�\2����:+㉷���;v%)g�$n��@י�HƼ�y��^�b~��WK�,�q��WW'o�k0ly�"Q���_h�ɫ�_���h؟!      o   �  x��Zis�F��
��*�2�=�x˧�G�>�x�嚓�L�2T*�}{(Yin$'[�-�4bޠ�_�k`�U\e���(��q�B��<%F��B�0଑�����������|0I�i�^��q*��t/���P��k��n���Jϩ@�1�@r��q��CtX�g� 	J���� G�*�@s
@\�h���$�Q�rf3��UN�!k
�r�;qe��kArV� 0J������ )�K\3�� ޯ��R������*E��#*s�_.qT���g��\A���5��[�;quM�-%:�g\�-�4r�aW5�6jf��pǮ��S�J�(�C�=Yg��	����,}t*� Y6�4Bׂ*e��l[��V2J��D(��+�G��
���Ԙ��Kũ���%�d֜� Id����\��)ڤ�7֭t�8Wػ��{V	�3��&r$`S"��G�!d���..u���kn��W�W�g�A	b��q�n�H�λ�MrѮ����jk��fiʏR{�yGr���7��ʼ`���M���3��p�ȜX&%���JX�%�E4`$�e�N�5�J"��Bj�Wa%�yM�'1����D��4��ۘ�̠�;IX�A<�I\���%Zc��\	�Hf�x��DVpoY։X`�
��3�<�)�0*9��,0���v��W"��Q�j[�r���)h����+�j?���[�u�|�V�N��lt��}�vK��m��e	N~<��[7�7nߊ��۷|{����^i����[w�[�N�|��`w�T��Q�-H[�~=�8���ӟǧG�������������/[yԕ/��x\�؎��n�̚�7�$��.E��	������a�s��i�������h������϶3����P<�sz�a����t��|����q�N~5+`��N;r�{����r����~���G���_��\N�����k���{��-g��?t���ɴ�?�+��I�����N���M�C�|)����P�a4���Xvx1=lâ�b�ˋ~��F�s�<~6v����xq9�����q:Y4$�	�L���. ��::|s�K���g;��_��~��4���w�Qx��3uh�_�uI]aR�
*����MI��$����%e�%u�da���(�0V\�:��6��P狡���ɜKd�����x���s�����A�d�ڟJ?n��_�Oj'8Q�q)V��lQ��ԁ�,�G���)żL"���P,����|I��O��*��64�i�+E�,#�"�X{ebV�Rg�A�r�FR��8Z3-�d�ීцE}�,�N	l��3��sb��D9+)���d�X�a�k����\�7,ڰ�KdTYb.J^h$@-�^�$j��sQ	�ְja�ذhâ�����>��$F������]9�����>�8k k#Z3c���wg�.�*�� ��JE�EE<`>4Y���5�PK�-�)�ǟ�o軡��!}u�r��jG�)o�ʫ_��!�)������LI�X�Ԕ[���Έ��}��GO~����߽`��>|���O�i�����XMŒ�)O�{A�)�D���-��~�Y�n�֜+�zc=��({��*I�K�
X�(buYˁ-*gMX�A	(�֏(O��k�����+���������ۯGp b��ʻװ���W��@=1!h.��4'40��*��2Z.�c]P���R�n��'����Ψ}����Hw���p�P��ʹ�r��-��R�}Y_�\y�,�d6b&	誻q�HY3Ʉ�=���(ǣ��<j^e��4����y,/\}������d�Z1�P�#e������ afƆ�7��>_��!jT���_Z����/͇�_l��*��o��X�e�)��'��g"CD���bI^[A�=9y8:I��&� 5ɟ4�%x����̠�ƌ�a��Jɴ��'��m���K�u�,���%�A&Bb�Pʲ_��U8UF���My����MG>��Bw�T{���x��L��孻J�2�X%L-ް�c�Q*P�Z��)�Q�P���ݛ1(������b�����@�<��a�EL,w��^%�����;��-=�t�û�{{r�'���Y����=�Qɡ����4� �
���\^���`���B/��'�w'�O�chE9^�T +h�,��<3F1�Q�Wq��Z��k���g�$V�R�8zUD��,ЗK$d�3�ZEKH5i�FWƈ����]�6q�����J 'O��B5����Q#*��I�U.�F�Zp�}.]D��Ίʥ��c4+�+A�Pj9F�3�k04�U���qX?'|3�9~��ߔm5x�܍�m�0�����ѻ����}z╋��
�*�A��DZ@ Q�Y&VD�QB��!�F����"��W�����-��������,%&^���pb��覄�ݢR�
�9S֊�>V7�w�&�|�D�*Q��#Y���G�BG��h1(�)Gi�5��	�y�79�������*3)�-��J�q�+�������؇c��0��Y?+t��g�Yج�~�����������o������͕.`*�)R��He]���é���i�Ⱅѣ�Sk��4�8��\���k�e+��@6i"�j���D'������O-��΋ ��"����j���ѳ�?��ы�q�&��;þ}ڢ���j�g�0)?m�N^�tv~�G��N^L����Q$��ݽuIg�8�8=��R�Q��>/=������.=��
�-�S�%�*+Ԫ�T�90i��{���}�j�~J?Y۽�X�2+�����n���xA��Fs�5V�K���:���4��50\���~L�qo��W��K�0#�RPrUVk��*�%`T�Ii���T{��t��M���ܟ׀��
I��êo�D_��9fT���j��pNEa"�Um��]|pN��t���ݻ� �P%�E�C�M8 �K�X4��X	s�t�fi@��X'Bm��j�z7�w�zϸ$��E�T&"�B@C�'�	�,��*�P�`8SL���l����_�K�bQR��n��8�e$�����!�pI���Fl���҆K.�
�r�:0��X������cb�K��%�5�h��6\Zp�m}�ƍqt3�      p      x������ � �      s      x������ � �      t      x������ � �      {     x�}WKrc�_��7@	�h���& H��Ⱦ�$w*Y}��d�4q��9��s.�S�ѵY�c_����k-x�)����v��X�St�]�?|9�pHy_R�1�{�t��%�M����e�ܔG
),Ǐ_��^�h-3�!.G�uLW��C��zhm,������+����jr6IwjNՓ#}�HCE�˸�׏�ˁ�x�!����c���]��Ff�^��>�W}{���|$?\�̎�v�Dx���r�/��z^�zzK�b)��(l����\4���!���?_�Hh��g�l���Y����s�i�\�������'ir"����J��ro-�KR\�tv;���x�8����"j� 5f!��X��x?��������Ղ_�����]�؍3�9�r�W�|�O�Ԝw>zo���:3@����L�|���.�|�W �jS�Òp�fЄ��@���˙$m'��y��J( �g�O�4���Y[�,��������%�[�8Iͻ����{뙗>�x}
t�u�*��:Y�R3Ly#sm�w���٧��z������e4u�@z W��ѫ�DL����߷�J�Tb��|���K6eW0�Č���y��H����	�p Iv:ՠ⡑8��\?/��?�`���f�f::L'��������ȋ�i|t���L�GeBDPX����#��M�_���2�e}�h��9HȲӎ�7C��lL���6�ua�!�3������!ea��K���_�p����
',,!ld�Od~��p>�	򜛭{	�/�dkW%�K\`�/A:��D�$�L7"V�8�(�e��V�D�{SL,�!������%$l�]��'�c����8��N�V��Qa�`��<�?���=u�!)�ǥ#$u8Q'�0�˛~��N叏*4 ��X�y�<�o�1S1k������dU_v�m*��a��Hݜ�b.P�8&F�~��������Lh<7�8�D� 0������s�F�c_ns=��|��͢"j]�ߊ=%B����IR���h���<>y�V�;\��s��%Q�rj��s~�����3�f�ԡrX1�t�\9�Y�����:v��6�F�DpD�S��R̨�v�x��(��/�Ү�-�o�ǖ��o��5�`�¶\Oǎ�c_k�CL�P�m�\+��Jy��=B�A�6�HO��kx>�h�a��2�n1*�'��&t�ͽ�w��#�r0�`luY�����!�u[Ļ��?QP���=��
;ͩ+gA�M�����6gG��@2�~>�s���n��c��ūNΦ��ɚ�������b�l�bqZ�������h�m��<��i�@X�����e�J{�� �f������N:Ĳ�F���g+"[��w�F��]4c|��Lh9�����{��pK(�i�i�K�C:����]���5�{��E"	�`�� `�P�b��4��Y�oO8�@u����<G-�f;���O֔���ưБ���$N�������}�D9�:�ef��t��<l��[ȅ�'���͝*�O@802=� y���n���D      l   <  x����q�JE�TJ ,��`?oz�?��UY��J�pE6�.��U��s6P�A���I5�{�,�D�h�e|V>~��aG_�i��� ��v�>���n�_�L�(��@��I�I�Z�Z{���h��2� ��~�_hgQ�B7$ս���5!k�?������?Q/���B��4�U
��EZi9Y�+��}�w
Ջ⢒f���:���PP_
�� )AZ&6}�p\�8�#J>Y|�h���̀^ɠnܲ����G��O��E��J+b����B�LY��>u��=M��^�by(z"W��K�;$S㸠�Z.:V��2'E�C��0.7s��
h�
K���D����ɥ��G�R��kbMY���X6�+2�Y/.����Z�|.G�X̠�N�D'��p8��j��FIq��4����zwɸ����c��Y�'�g��mb��:KsV���Fg�r��%L�Dk�����;���f�jD�Ma<d�fЭ��.h+��j��]z�N�؊]XS\z&b::���ŪۄV[�b�I}��%�q���T���:�ޚ[zTG��?}kG�\4�)�w-�.f�ğбu/U�#Sf�@Ǥd� �*�=�:�<b�D��s���N�
��Z������]�6=����#����Փ�Y^��R�Q������h��HBL,���S�d��D!���i�?Rr�T3z&�;�g�z��h=1��k"�E�dt%+^_��}S��ܗw�J��Cj�~Y:h=w��th&��1�>��K�7���Ƨ�ӯJ���,��ҷ٘����~����8      u      x������ � �      y   \  x����n�0���S:w�rI.�*m�!@�YN��=t��n.Cb�f��C�."��l��8M�#�a��4��֐"��Iٞ\o��9BM�G7�.��_�����>�)���.v?N����C�C�[�^���2��>[A�1P�a��N�\o�l�����xfc��O�[�Ry������ɖ��2_����\Be��$޳��r���M�i�/G3�Wx�D��f��Q*�Α %0��B*����$�TC/q��c������y���Ͼ&���X��mTbEA4���^a����?k1LSe}�6�=� e]�-�Z�G]5�u�oc~�~�߈?��:�m�	����      w   �   x���M
� ��x�^���I�C��"ɴ)�D��-���f9��gX|����9o��Ku�y��B�ء5�(H�$&ڨ���/
�Q�n`��	�#�	�;���N��������}�K�j!J��L��h�� �u����#����p����+S�{纐L      Y   �  x�mU��+7����\hޚI�g AN����k`��K��T��9�-2oJ}S��ѓ������߿�����_�{����cv�\�I��R�3M�-2o3���Ҳ�����2*,Dƪ4r,��[_���}{Dj���edq��%��Ŗ�{ó���#���r.v�E��S����{�C8�ՌO�!O�du�Js����ܶ��7�8GD=�9��"�	��U�CiW���:�\�Փ�N��ޕ�k��rP�N�ꛧ����S7s�tv�8����/}=�Lh��5.�N���m�����r���b�_�� L+$ɬ�1���ݒV�ʿ��Ͼ޺�"i��u)�����h��)�_,�X+���W|mj��ߡq`Bhg�_	���G��%��"a֯�7Y�F�җ�������{���^K�6�_�F��ښ�f�V���l���{�t.Ƒ�h�#���	�ld��V���#ʘ�����v4�!,e���¬\;K{���M�:a"�4\'�#k�x��?�7ъ�wkwL�=:�ihp�D�3��/<�XF�O?�ZG�rX#���$$��{��/���G}��L]r�������a��g�]�������A~�['�E��1d����B��	�M���[h~JH��#���A�~� $c��,˥�tЎ���1�x�'�����>��P}M� ��5��x����](�N���?�Y=(��g�B����|��&�r8�Auz A��R{�ow��g.hR�[2�_��D�v�p�O�|��OԖ������h-���������v�?:'�%���\,���:پ�:����'䤷����T�9�\�G�[�~#Gf�⬦/��֐>��������      ]      x������ � �      \      x������ � �      _      x������ � �      ^      x������ � �      a   E  x�m��������
:>�"��;�l��M��̿�β-�zl�&�"K��'� ����ꟊHs��	�b��Eᔖ5��[���bN�cQbY�g���k�g�l���[Na��`( �V���x�#����t��;�+�D˘�-�3'|@��ڏq�=(9�
�y*�T��?m�N/j��Ӵ\#Wz�}l1*E�Q�.���3-��������:��0��Гy���SD�V<�a��
4�Ӓ��=�ퟛ�B wX+��U��w\�;\PJ&�Rt����Rk�?�	����(�������AgS׃n0�JP�9WI:��{L����?��}�޵`��-ۀ�V�v $,;���V�U�Md�DA�"����Z<�c��7����k�ek�e�_��a���JC�� �����Td�p!�����i�0��b�J��@�8$;��S���ﻒGeS�����nߗ2�3D�$�,n����J��s]�;g��I� ̕[��A�Vn&<Wq�׻񁩽�2
�vC%�˖��*ZN3f~hdF�N��ڋ2�Y�2ȑӝ�h��ӷ���Q}��V�3���E-�XԂ���Il����ͨ�/g�|����g�m\�9%:8�$i1���,���Xt��������I$��o�YqkA�n���	�������XV��?��Ύ�*G�*�1w����$w�%x��"�f2���W쨗 c�W��%��(4&��Z%�q?�/^"�qcE���Q����>�ڏQ�K��s�sf�y��j��L�Ȉe!��	94���5��F���(��3��(��q��oG���A;�P�����	I(CC���0ޒ(��9�^)ݴp�vm�fȖ_��{�3��|���f�-���ƹ,���6��dW\s#�Ţ����Y��wd5��t�񂑷��pG�~Z I��3����������S��ɥ�R�8�ea��Q0�v$�kP]ǖ��#��O�n����k�g�O��{n�Hj�) �c�'�c
$�Շ9�0B��vz<��5+�<^�Y8nof�����xЂNE!���//��GjVtZ�G�8T�b�~�1���arм���ohw��oB����yV	RN�~X5�Ԝ0�&�3�f�R�ɨ��긎����!��*�ĉ(���Q\�&6b�{K��;�+5�x}�� onV�3��
�܆���p���Q-�ѭ ��p_��^>�2��5�D���t���%�%�qO�=Q���ִդ�"~7~iۅ
�o��p�c�]GD8"�dR�����>&�ƣ>Q�2���+\�^��q/	s���0J��܊�^l�u���>r�>x
��3<I�f���E�%_-�/���9ƭ��^r��t=ߍXu�����տ�� �-kT]�_�$s\T�~B�Jn�i������9uxIs4�L����?�m���`lf�C'oc|=���Xd��$Ǿ�x��S�@���IǢ�#Z��o�h�������V �g�:��NO���{�ʹ�|�(J�\���b(�O��a��.�3a�[X7%�p���Z�`9SЕd	��x��x��l֞{�P�
RS������z� �BI���|8N�����������      X     x�M�ˊTAD�}��%U��݀wD7C��&��a@at��[Kw	A��۪�����ϯ������^ b'��R�օ�<s�X��ڄN8P}��� D�4/M
Z�٤`_�R�j�R�%C�NG0����@���j��h�&�򹈲S�I+c���p2T��1a�F��� n{L�H�A�R�f���F*7�X�Ɂ��!�7��Kd���b\PԬ��P���|~:o/_��_�G��|���k�׭`��jH�6��o����x��rޟ�?\�~ߩ���||{w�?5�h      d      x������ � �      c      x������ � �      b   �  x�uV[r#9���$��O�'�����іlk=����؞uo���?�� 2�3HA��X']i58�[0������]�i��E߾z������z^~��$�"!I�1���Z��`ڌ��\�4���Lei����n���O�Tce�b�k�E:�
D�!F�Y�c-�7�Ȉ���]qv���!���=e7Re�b�T%:·5p^y��i��x��||�	�R])ʨ]��	��VBre���-.���s��~��,d힃�j.en��%Wch����\ly��ׇ�>�>���+� "u�!�V��F�(��7�y�`�[[�q����#�z_�L�$%q�������r9�ZFh	0wg�'�;�/H9�Zg�-��l��yr*�:K���Y���@̧�m��WR�sF�V�1QL��01����	u���3�Ƙ��9:�鮿VW2� "j*
�e�\�Fb E�9(s�i�=θ?����R��u��K�����PEu�SM�bU͙�b磅�c�(�k�k�aR��yImk�95���R&Ilm�}�̢�D���O$)��amD��U+ñ��hs9u
,�����R�?�|���z{�"�R2.������W��tu�R���擯�-g�ⷩ�N���m&�q-Әc�Pe�u�nt^-7Hp���]oǋn��b{K��r\{)9]�A���u,��*����r�>.�w��bA���k,�5h�i���3�ޑXA}ް.�}��)V��U
����Ђ�B�NC�hk��B�<i�۱������N�J`���A^��������F1���[����X0��Q/����-�w�I�յ�N3"������� B�+���I�2��z�;�RA\VB.�ʸ�y��j���D~7cDA���ۧ};���??/�Wx�x/��npB���@/rmKؘ��Yg�{���}z0��Q�&=r�MP(!�� 8�
!b��rz���z�H�� ���ʩߑפ}�C��cǀ���%>��E��~����n��qR@LƎ�.�\�y\��{�m��ؘ*K���'?�}ĭP�kE��\��<�2IEA��1��m���>�N:OT%k��/�f%��$B1�Q��@[���|��N�o�_�_�o��]~)#���l��[�� �s[Y�A�(1����Ҟ����}���-�@%��19���`u��#d9�����Ñ�!Q-iEl�vboc�p�Q���\}��~��=���G����vX��Of�y      g      x������ � �      f      x������ � �      Z     x�m�������o%�	����̬n��L������Y�-ُ_�(ŠC�$N!ؿLU��7����۾���+J �<p�??��?[*�G�Y���g�k�Ė�A���U�.U2�V��_��ߗFޮ�gox[�Uh�����u&)w��}�Q�x��"%\B�QZ=�4^I_�vct��(�(K�L8��X����r)`��SF��93뀅\�y�؎�L��Ig�1�In#��NXş��a�hmeGL��fcg?��/^@���H+�^E�Uj�����'��a�w�mLi������b�U(G	�*����|���!�(�V��r�so�'[�a7 "H�����R]�5�QW���@�G�r@��a�<�7g��=hD >�8�O�b=<>}�4#O���i�C;���hJ�|��Ӧ!��0�4i�F�������F�\�M`^��f���G�b�3@�UG��ׯ��sA���ٮ��J��U�Ap��cDj��)E�5`��?\?�*��|����r����"����~蠟�:Cp�1�1��K�!t�-�c��
W��������ڐ��Qm�$S3�����P�YVc�w�*�VOa��w#�A��%�����+GsI��9mB�פU������hL �o�*�\�T��oR��_I!G�k�K]��5�]���U�놿Y�Y�.U�/�qـ�ݲ4E�����a�wy���h�O��@�����x��|y�rq/�lR���u�Q����M�e�����kez`B�v����]@�f��V!h���I�}�#ʹ|g�5�Ỉk$��L�9�YB��&x�~'@�����5��������$V������W�"P����G���rX�l�\Zw%/��_��4���8:e��B�^�slS0���A!�(W��o��n���I�OMd��K5]���ؚ�����K� ���g�cX8K<+�yUj�'wj4�rz3�2[>���a:1@��M�{��iM���JK���fc��ֻk�}<��t�ck]�����wb����T!	ECTm�]�Q �2C��ej�k�,Xt�j�ZIZ��RM�����+!-'>�1*��Y�l)�FI�E"�ga}.uL!�ƻ���7���Bg�Ͷ���zwo���Y��z�a�ҵ$��^4H��\�����2��LGp�Uv�ܜ�!�����-��{��~8K^/S�+$��"7� �S@��Kz��,�-㉍g>\�_���1��s�W{f��@�VxS�l�l�U-��z�)~�.��&����j4���~��n��+�!E'�H�%[)����uh�C���T��.��q�n[������3!z�m����ߊ��ED��11Z�x�x~H���m��Z��6b=�V��*��Q�h�6�ߦ�qu�$K�W�+=)=��B�=A�nT�����$M�-��Y:Ֆ[�E.|�|P~[��̈���z`���a��)ʴ�i�ffcgS-����,$ߗf9�����3�줕%�7d�x�0}=9�����eqE���0��������ϟ��=��      [   �  x���M�#9����p�H������cs��!��쥬�*�]R��p�3z���t�\k��-�n3�#�Zmݨ�x���,ܡ=�5��S��IG���*��b��#u�h�r�ieFI*2N�Y��=�X�9�TG=MS������^�Z-1+=GV�5{V���?����`9��g��W�a��S���k��RB�G�s�z���j��K{��'�:妕v;��n�J^m�{�vDʜ��;s�m�In�ǶE���-�J�XE�g�,c�j#�;d+F�԰�����Lyi3�c��l>�c�sd�ZR��ڮ2z�It������M���, �e�7S�ŃvFm���'����Ek��}V��\Co�A�G�'��ΰ`=���c�#�����eR��K����Rs��u�Y��v���薙Y��<*,�Y�ʹy̓)��{�u�l5�<F�Р�g�S�����2�}����f�%�����N+H�ݹI����Q*^��װ5��kEKW��2{�K�L;��-ƺ��e�Y���U�1�[�\��Z�)K*�'yV�M�G���])�`�V`�8o�#uJ�Xȿ�^�ך-�=�{b�8�^�̈́%��w��u��'�8����.-b�g��ٔ�8+�� ��q[	�o�ti/]�JY;D�����@ir�QM�|���4�e��T;t�k�ћ�2+�녫�.�ڒ���س՛������֞`�^�v�4��Yh�!��U:�ryM˧��O��q�0�I�e�4u��՛��cY5�gm��Q�H�Xh�J�-0�9�����zu�1~+۲B�TV�,���8��PY�LK�f��wa�}k(�y��P�K�i���2�km0pX�!K�ʊ2�[�<��v���iP4�ܥ{�G�(�n���h�g�����:itt&X5�%�n_�"7::[�aF_9�A�%3���������519砌Լu��1ҹ���T��T�^��Og��A�R�k�Yy�ɕ�3�R���ԫ����H�٥��������H�i��K��^�M�1�w2٠�,UҨ=W�U�E~�Z-ڒ�7XyV����ga�v�@e�`�+�p��g�˾��>��lw�����#��"3��e�%�N��h�q_J�~��T�5�}���Z:�S�SD�6���?r�`�����+c����hP��l`o�5x���J8N�p!�O}��l�%���`�r􉸔����yV�l��߁�\rjD��0��)
m� �nI��S�VNd,0u��B�!�4hY�/���F��"�Q�n�T��%!]_���&DMhi��49N�E�5�H����ø�=�����V53���?`����`�E\�[D�Xv���`KF�����SN�� �����"����E�n��/�S��-�O׽���,�����8��
�U�L41��l����L��LH"����{���ȟ��b�GQE�J�{�`"��$W�^Q�N�X��Id&?`{}V^و)�Z2�#��Da�id���A�`�A0׬s�,�ݱ0r��Hպ�J����oL�>K�˚�H/t�/X��9ߕ�#�`#־m���@��0[I!^;{w�����&F��^�vG���g(�g��[m��ώ�gSF�q籐�Yy�b���?�r��Z#�#ܽ��C����s^H�D)���;�
�yc#rL�y�|��@łt��ۢ.h׎x]���2�����Lom?ƌ+�
���	8M�����$t�W��b�����d:���]�*�O����D�Ǡ;n�7�%^���`�Ѫ|�>+�`gk���22`�����[�!�5��X��l���%����k�퇘8��H����_a�a
����`���4������Dj`�V�D�*.+~������t�4q���`��e~=n��uV<,���DucK���1��f�?�91�[��}V���6�w��ʞw�[�}��-c�_��*�)U�X��8a�	��\��hZ-��?���6�6�_`�ɿ`?+��|�Z�+cd(��зT���X#ǌ%��4�i���"���o��}.��65�d�.\}��)�V�f�Z���V�g�������c(�I
B�-���F��Kׅ�ёxo��U'�M}�1V�		5M������aI�0U�i0FÕQ��`۳�sW,$�̼͗�9�l���T���t�	��;�|�O���n��`R�l��%L9ə����qE`��^K��i_�C����7�7XL�g�4 �:4��LZl���u�Eϼ�����NS~�9��T,�A۫O�)4cz�I�\�
�6�1g䮀���De��2�-�;����:�����OpZQ 2Y�0I28Ƹ�Cǝ�5u�U#���@8�d�h()��P.-���8@O�t�ڭ�����(��P3����B:C�c�����������[�%y�����f�,#�H��rG���	g{Pcb��my(%��7R�?��Is;�5���U�3�0Yx<�¦�l�A�	+�֠��������QZ���4$�A��o~�V6Ǆ�M'����y]¤k��3�}Y/��R�IU��Ā� ��g�XY:�ل�:�v� <����MB\���
�-����3��%U��jP_���M%�	�W�;j"��f�V�?���*)拫&�ξ��[��	̆èC��\��{� ���/�4������3�S.��)��е���a31ү����ɑVA2t!	���͗�C/�"�3�~�u��e�pZb~�ϋ�wP���$����~���+���`�r�.�b]��'4r�$�^Yew{��(���|R?	!X,���������n�8�;蓮�=;$��>�(����A`���?�Z�*���]���q{Ζ�N�S4W%�O?�iF��/c��[��ċ�KL��X-���aG�~���k��>S`�`}J)Dz�-��#�-�:ԟSD�F�ؠw<M�D�]��F�%�"�����踨�M�/�+�N�g)Rc��ޱ'Uպ�r����n�"jN��.����?��Z�7���ip+r�=$��[5��}_n[���UE,I�.�LeK 	��c/�]�o�a��G�?��V� -ѻ�u���`��(!�&�?�b�p�<+���*ߜn��à�\�?����L�#��Or3�.0�K���A���Bln��ڸ��ab#�q��r>�=��ZQ��>����$��i�������,^�����x)E�s��or�R?d�l2�P�Yج9]4��I?�& x'�{`��2�@����	�0�Ыo�u�W�CD�A�h�9ܻp�:��|�����mؠ����v^�t�����|��#���m��G��+�'��N�lM����j0	I��<��]����bU/�NN�����6j�m���w�al�گ�Q�z�@u鋿F�ȕ���qKs}V~�|���G��B)��b�� �.n���~v��$�Q��n_����P�oU��T�L�����2�k:��U�.汽����ޛd$�d	^j��0Z��6b�=��/+{���w�h��I���jͰݣ{����o���K��a�?�lN2yKW/���0���ڏI����m�pb�ޫ�m��ˇ{��0d>�H#���~����t�	i�R�]'�ƽ���)B��$���'�o^��=���'D����]��?+?����>7�@�Ӏ�Md��崼i��*�/m<t�G��Ƞ&�/3��T&����7!$�����E�����ۿ�>+�������o��3      `      x������ � �      e      x������ � �      h      x������ � �      i      x������ � �     