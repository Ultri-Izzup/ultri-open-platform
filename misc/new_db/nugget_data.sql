CREATE TABLE IF NOT EXISTS nugget_data.account
(
    id bigint NOT NULL DEFAULT nextval('nugget_data.account_id_seq'::regclass),
    uid uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    name character varying(150) COLLATE pg_catalog."default",
    personal boolean DEFAULT true,
    CONSTRAINT account_pkey PRIMARY KEY (id),
    CONSTRAINT uq_account_uid UNIQUE (uid)
);

CREATE TABLE IF NOT EXISTS nugget_data.member
(
    id bigint NOT NULL DEFAULT nextval('nugget_data.member_id_seq'::regclass),
    uid uuid,
    contact character varying(150),
    realm_id bigint NOT NULL,
    created_at timestamp without time zone,
    CONSTRAINT member_pkey PRIMARY KEY (id),
    CONSTRAINT uq_member_uid UNIQUE (uid),
    CONSTRAINT fk_member_realm_id FOREIGN KEY (account_id)
);

CREATE TABLE IF NOT EXISTS nugget_data.account_group
(
    id bigint NOT NULL DEFAULT nextval('nugget_data.account_group_id_seq'::regclass),
    uid uuid NOT NULL DEFAULT gen_random_uuid(),
    account_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    name character varying(64) COLLATE pg_catalog."default",
    roles text[] COLLATE pg_catalog."default",
    CONSTRAINT account_group_pkey PRIMARY KEY (id),
    CONSTRAINT uq_account_group_name UNIQUE (account_id, name),
    CONSTRAINT fk_account_group_account_id FOREIGN KEY (account_id)
        REFERENCES nugget_data.account (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

CREATE TABLE IF NOT EXISTS nugget_data.account_group_member
(
    account_group_id bigint NOT NULL,
    member_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT account_group_member_pkey PRIMARY KEY (account_group_id, member_id)
);

CREATE TABLE IF NOT EXISTS nugget_data.account_member
(
    account_id bigint NOT NULL,
    member_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone,
    roles text[] COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT account_member_pkey1 PRIMARY KEY (account_id, member_id),
    CONSTRAINT fk_account_member_account_id FOREIGN KEY (account_id)
        REFERENCES nugget_data.account (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_account_member_member_id FOREIGN KEY (member_id)
        REFERENCES nugget_data.member (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS nugget_data.account_nugget_type
(
    uid uuid NOT NULL DEFAULT gen_random_uuid(),
    name character varying(32) COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_id bigint NOT NULL,
    CONSTRAINT uq_account_nugget_type_name UNIQUE (name, account_id),
    CONSTRAINT fk_account_nugget_type_account_id FOREIGN KEY (account_id)
        REFERENCES nugget_data.account (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

CREATE TABLE IF NOT EXISTS nugget_data.account_role
(
    uid uuid NOT NULL DEFAULT gen_random_uuid(),
    name character varying(24) COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    permissions jsonb NOT NULL DEFAULT '{}'::jsonb,
    account_id bigint NOT NULL,
    id bigint NOT NULL DEFAULT nextval('nugget_data.account_role_id_seq'::regclass),
    CONSTRAINT account_role_pkey PRIMARY KEY (id),
    CONSTRAINT uq_acount_role_name UNIQUE (account_id, name),
    CONSTRAINT fk_account_role_account_id FOREIGN KEY (account_id)
        REFERENCES nugget_data.account (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);


CREATE TABLE IF NOT EXISTS nugget_data.nugget
(
    id bigint NOT NULL DEFAULT nextval('nugget_data.nugget_id_seq'::regclass),
    uid uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone,
    pub_at timestamp without time zone,
    un_pub_at timestamp without time zone,
    public_title character varying(150) COLLATE pg_catalog."default",
    internal_name character varying(75) COLLATE pg_catalog."default",
    account_id bigint NOT NULL,
    blocks jsonb DEFAULT '{}'::jsonb,
    nugget_type character varying(64) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT nugget_pkey PRIMARY KEY (id),
    CONSTRAINT uq_nugget_uid UNIQUE (uid),
    CONSTRAINT fk_nugget_account_id FOREIGN KEY (account_id)
        REFERENCES nugget_data.account (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

CREATE TABLE IF NOT EXISTS nugget_data.nugget_comment
(
    id bigint NOT NULL DEFAULT nextval('nugget_data.nugget_comment_id_seq'::regclass),
    uid uuid NOT NULL DEFAULT gen_random_uuid(),
    "created_at " timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    account_id bigint NOT NULL,
    nugget_id bigint NOT NULL,
    CONSTRAINT nugget_comment_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS nugget_data.nugget_member
(
    nugget_id bigint NOT NULL,
    member_id bigint NOT NULL,
    linked_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT nugget_member_pkey PRIMARY KEY (nugget_id, member_id)
);

CREATE TABLE IF NOT EXISTS nugget_data.nugget_reaction
(
    nugget_id bigint NOT NULL,
    account_id bigint NOT NULL,
    member_id bigint NOT NULL,
    CONSTRAINT nugget_reaction_pkey PRIMARY KEY (nugget_id, account_id)
);

CREATE TABLE IF NOT EXISTS nugget_data.nugget_type
(
    uid uuid NOT NULL DEFAULT gen_random_uuid(),
    name character varying(32) COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT nugget_type_pkey PRIMARY KEY (uid),
    CONSTRAINT uq_nugget_type_name UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS nugget_data.role
(
    uid uuid NOT NULL DEFAULT gen_random_uuid(),
    name character varying(24) COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    permissions jsonb NOT NULL DEFAULT '{}'::jsonb,
    CONSTRAINT roles_pkey PRIMARY KEY (uid),
    CONSTRAINT uq_role_name UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS nugget_data.nugget_comment_response
(
    id bigint NOT NULL DEFAULT nextval('nugget_data.response_id_seq'::regclass),
    uid uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_id bigint NOT NULL,
    nugget_id bigint NOT NULL,
    comment_id bigint,
    response_id bigint,
    CONSTRAINT response_pkey PRIMARY KEY (id)
);

CREATE OR REPLACE FUNCTION nugget_data.new_member_from_user()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	DECLARE new_member_id BIGINT;
	DECLARE new_account_id BIGINT;	
BEGIN

	INSERT INTO nugget_data.member(uid, created_at)
	 VALUES(uuid(NEW.user_id), to_timestamp(NEW.time_joined/1000) )
	 RETURNING id INTO new_member_id;
	
	INSERT INTO nugget_data.account(name)
		 VALUES('Personal Account for memberId: ' || new_member_id )
		 RETURNING id INTO new_account_id;
		
	INSERT INTO nugget_data.account_member(account_id, member_id, roles)
		 VALUES(new_account_id, new_member_id, '{"owner"}');
		 
		 RETURN NEW;

END;
$BODY$;

CREATE TRIGGER new_auth_user_nugget_member_account
    AFTER INSERT
    ON ultri_auth.all_auth_recipe_users
    FOR EACH ROW
    EXECUTE FUNCTION nugget_data.new_member_from_user();

CREATE OR REPLACE VIEW ultri_auth.v_combined_users AS
SELECT u.user_id AS "memberUid", COALESCE(pu.email, eu.email) AS email, pu.phone_number as tel, , u.recipe_id AS recipe
FROM ultri_auth.all_auth_recipe_users u
LEFT JOIN ultri_auth.passwordless_users  pu ON pu.user_id = u.user_id
LEFT JOIN ultri_auth.emailpassword_users eu ON eu.user_id = u.user_id;


GRANT USAGE ON SCHEMA ultri_auth TO nugget_data;
GRANT SELECT ON ultri_auth.all_auth_recipe_users  TO nugget_data;
GRANT SELECT ON ultri_auth.v_combined_users  TO nugget_data;

INSERT INTO nugget_data.nugget_type(name)
VALUES(
'action',
'album',
'assumption',
'article',
'businessModelCanvas',
'businessPlan',
'calendar',
'canvas',
'campaign',
'card',
'catalog',
'checklist',
'collection',
'comment',
'contact',
'decision',
'epic',
'experiment',
'forecast',
'form',
'forsale',
'game',
'gannt',
'howto',
'hypothesis',
'invoice',
'iso',
'issue',
'item',
'job',
'joke',
'leanPlan',
'ledger',
'location',
'logisticsPlan',
'map',
'marketingPlan',
'meeting',
'message',
'metric',
'milestone',
'missionStatement',
'order',
'orgChart',
'payment',
'portfolio',
'post',
'product',
'project',
'proposal',
'quiz',
'quote',
'report',
'response',
'resume',
'riddle',
'roadmap',
'round',
'rfc',
'schedule',
'sermon',
'shipment',
'slidedeck',
'sprint',
'storage',
'storefront',
'swot',
'survey',
'tactic', 
'task',
'temporal',
'transaction',
'vote',
'webpage',
'website');

