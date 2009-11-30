--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.groups DROP CONSTRAINT groups_pkey;
ALTER TABLE ONLY public.files DROP CONSTRAINT files_pkey;
ALTER TABLE ONLY public.files DROP CONSTRAINT files_fileid_key;
ALTER TABLE ONLY public.fileareas DROP CONSTRAINT fileareas_id_key;
ALTER TABLE ONLY public.filecategories DROP CONSTRAINT categories_pkey;
ALTER TABLE ONLY public.filecategories DROP CONSTRAINT categories_catid_key;
ALTER TABLE public.users ALTER COLUMN uid DROP DEFAULT;
ALTER TABLE public.platforms ALTER COLUMN osid DROP DEFAULT;
ALTER TABLE public.languages ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.groups ALTER COLUMN gid DROP DEFAULT;
ALTER TABLE public.files ALTER COLUMN fileid DROP DEFAULT;
ALTER TABLE public.filecategories ALTER COLUMN catid DROP DEFAULT;
ALTER TABLE public.fileareas ALTER COLUMN areaid DROP DEFAULT;
ALTER TABLE public.callhistory ALTER COLUMN callnumber DROP DEFAULT;
DROP SEQUENCE public.users_uid_seq;
DROP TABLE public.users;
DROP SEQUENCE public.platforms_osid_seq;
DROP TABLE public.platforms;
DROP TABLE public.permissions;
DROP SEQUENCE public.languages_id_seq;
DROP TABLE public.languages;
DROP SEQUENCE public.groups_gid_seq;
DROP TABLE public.groups;
DROP SEQUENCE public.files_fileid_seq;
DROP TABLE public.files;
DROP SEQUENCE public.filecategories_catid_seq;
DROP TABLE public.filecategories;
DROP SEQUENCE public.fileareas_areaid_seq;
DROP TABLE public.fileareas;
DROP SEQUENCE public.callhistory_callnumber_seq;
DROP TABLE public.callhistory;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: callhistory; Type: TABLE; Schema: public; Owner: opentg_user; Tablespace: 
--

CREATE TABLE callhistory (
    callnumber integer NOT NULL,
    login character varying(32),
    node character varying(15),
    city character varying(40),
    state character varying(3),
    timeon timestamp with time zone,
    timeoff timestamp with time zone
);


ALTER TABLE public.callhistory OWNER TO opentg_user;

--
-- Name: TABLE callhistory; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON TABLE callhistory IS 'Caller History';


--
-- Name: COLUMN callhistory.callnumber; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN callhistory.callnumber IS 'Call number';


--
-- Name: COLUMN callhistory.login; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN callhistory.login IS 'Login Name - Staticly placed for history';


--
-- Name: COLUMN callhistory.node; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN callhistory.node IS 'Node (tty) login came from';


--
-- Name: COLUMN callhistory.city; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN callhistory.city IS 'City Name';


--
-- Name: COLUMN callhistory.state; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN callhistory.state IS 'state';


--
-- Name: COLUMN callhistory.timeon; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN callhistory.timeon IS 'Login Time';


--
-- Name: COLUMN callhistory.timeoff; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN callhistory.timeoff IS 'Logoff Time';


--
-- Name: callhistory_callnumber_seq; Type: SEQUENCE; Schema: public; Owner: opentg_user
--

CREATE SEQUENCE callhistory_callnumber_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.callhistory_callnumber_seq OWNER TO opentg_user;

--
-- Name: callhistory_callnumber_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: opentg_user
--

ALTER SEQUENCE callhistory_callnumber_seq OWNED BY callhistory.callnumber;


--
-- Name: callhistory_callnumber_seq; Type: SEQUENCE SET; Schema: public; Owner: opentg_user
--

SELECT pg_catalog.setval('callhistory_callnumber_seq', 45, true);


--
-- Name: fileareas; Type: TABLE; Schema: public; Owner: opentg_user; Tablespace: 
--

CREATE TABLE fileareas (
    areaid integer NOT NULL,
    name character varying(16),
    description text,
    write boolean,
    moderator integer,
    mingid integer,
    autoindex boolean,
    path character varying(256),
    password character varying(128),
    read boolean,
    lastindex timestamp with time zone
);


ALTER TABLE public.fileareas OWNER TO opentg_user;

--
-- Name: TABLE fileareas; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON TABLE fileareas IS 'File Areas Configuration';


--
-- Name: COLUMN fileareas.areaid; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN fileareas.areaid IS 'Unique ID';


--
-- Name: COLUMN fileareas.name; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN fileareas.name IS 'File Area Name';


--
-- Name: COLUMN fileareas.description; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN fileareas.description IS 'File Area Description';


--
-- Name: COLUMN fileareas.write; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN fileareas.write IS 'Writeable? Uploads allowed';


--
-- Name: COLUMN fileareas.moderator; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN fileareas.moderator IS 'Assigned Moderator';


--
-- Name: COLUMN fileareas.mingid; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN fileareas.mingid IS 'Restrict to a specific group id';


--
-- Name: COLUMN fileareas.autoindex; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN fileareas.autoindex IS 'Allow routine scanning and auto updates';


--
-- Name: COLUMN fileareas.path; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN fileareas.path IS 'Path to directory where files are stored for this area';


--
-- Name: COLUMN fileareas.password; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN fileareas.password IS 'If set, require password to enter';


--
-- Name: COLUMN fileareas.read; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN fileareas.read IS 'Allow reads - Useful for dropboxes';


--
-- Name: COLUMN fileareas.lastindex; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN fileareas.lastindex IS 'Last time filearea was indexed';


--
-- Name: fileareas_areaid_seq; Type: SEQUENCE; Schema: public; Owner: opentg_user
--

CREATE SEQUENCE fileareas_areaid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.fileareas_areaid_seq OWNER TO opentg_user;

--
-- Name: fileareas_areaid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: opentg_user
--

ALTER SEQUENCE fileareas_areaid_seq OWNED BY fileareas.areaid;


--
-- Name: fileareas_areaid_seq; Type: SEQUENCE SET; Schema: public; Owner: opentg_user
--

SELECT pg_catalog.setval('fileareas_areaid_seq', 1, false);


--
-- Name: filecategories; Type: TABLE; Schema: public; Owner: opentg_user; Tablespace: 
--

CREATE TABLE filecategories (
    catid integer NOT NULL,
    parent integer,
    name character varying(64) NOT NULL,
    description text
);


ALTER TABLE public.filecategories OWNER TO opentg_user;

--
-- Name: TABLE filecategories; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON TABLE filecategories IS 'Cateogies for File Areas and Message Areas';


--
-- Name: COLUMN filecategories.catid; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN filecategories.catid IS 'Category ID';


--
-- Name: COLUMN filecategories.parent; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN filecategories.parent IS 'Parent Category ID if this is a sub, otherwise NULL';


--
-- Name: COLUMN filecategories.name; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN filecategories.name IS 'Category Name';


--
-- Name: COLUMN filecategories.description; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN filecategories.description IS 'Category Description';


--
-- Name: filecategories_catid_seq; Type: SEQUENCE; Schema: public; Owner: opentg_user
--

CREATE SEQUENCE filecategories_catid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.filecategories_catid_seq OWNER TO opentg_user;

--
-- Name: filecategories_catid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: opentg_user
--

ALTER SEQUENCE filecategories_catid_seq OWNED BY filecategories.catid;


--
-- Name: filecategories_catid_seq; Type: SEQUENCE SET; Schema: public; Owner: opentg_user
--

SELECT pg_catalog.setval('filecategories_catid_seq', 1, false);


--
-- Name: files; Type: TABLE; Schema: public; Owner: opentg_user; Tablespace: 
--

CREATE TABLE files (
    fileid integer NOT NULL,
    areaid integer NOT NULL,
    filename character varying(255) NOT NULL,
    catid integer,
    description text,
    owner integer,
    checksum character varying(255),
    version character varying(32),
    platform integer,
    added timestamp with time zone,
    crcmatch boolean,
    date timestamp with time zone,
    size bigint
);


ALTER TABLE public.files OWNER TO opentg_user;

--
-- Name: TABLE files; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON TABLE files IS 'File Details';


--
-- Name: COLUMN files.fileid; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN files.fileid IS 'Unique File Identifier';


--
-- Name: COLUMN files.areaid; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN files.areaid IS 'File Area ID';


--
-- Name: COLUMN files.filename; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN files.filename IS 'Filename (no path)';


--
-- Name: COLUMN files.catid; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN files.catid IS 'Category ID';


--
-- Name: COLUMN files.description; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN files.description IS 'Long Description';


--
-- Name: COLUMN files.owner; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN files.owner IS 'UID of uploader or owner';


--
-- Name: COLUMN files.checksum; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN files.checksum IS 'File''s MD5sum for verification';


--
-- Name: COLUMN files.version; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN files.version IS 'Version if applicable';


--
-- Name: COLUMN files.platform; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN files.platform IS 'Platform ID';


--
-- Name: COLUMN files.added; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN files.added IS 'Date this file was added';


--
-- Name: COLUMN files.crcmatch; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN files.crcmatch IS 'Used by index routine. Does the CRC of the file on the FS match the DB version?';


--
-- Name: COLUMN files.date; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN files.date IS 'File''s actual timestamp on filesystem';


--
-- Name: COLUMN files.size; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN files.size IS 'File''s size expressed in bytes: File.size';


--
-- Name: files_fileid_seq; Type: SEQUENCE; Schema: public; Owner: opentg_user
--

CREATE SEQUENCE files_fileid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.files_fileid_seq OWNER TO opentg_user;

--
-- Name: files_fileid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: opentg_user
--

ALTER SEQUENCE files_fileid_seq OWNED BY files.fileid;


--
-- Name: files_fileid_seq; Type: SEQUENCE SET; Schema: public; Owner: opentg_user
--

SELECT pg_catalog.setval('files_fileid_seq', 13, true);


--
-- Name: groups; Type: TABLE; Schema: public; Owner: opentg_user; Tablespace: 
--

CREATE TABLE groups (
    gid integer NOT NULL,
    name character varying(25),
    description character varying(256)
);


ALTER TABLE public.groups OWNER TO opentg_user;

--
-- Name: COLUMN groups.description; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN groups.description IS 'Group Short Description';


--
-- Name: groups_gid_seq; Type: SEQUENCE; Schema: public; Owner: opentg_user
--

CREATE SEQUENCE groups_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.groups_gid_seq OWNER TO opentg_user;

--
-- Name: groups_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: opentg_user
--

ALTER SEQUENCE groups_gid_seq OWNED BY groups.gid;


--
-- Name: groups_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: opentg_user
--

SELECT pg_catalog.setval('groups_gid_seq', 1, false);


--
-- Name: languages; Type: TABLE; Schema: public; Owner: opentg_user; Tablespace: 
--

CREATE TABLE languages (
    id integer NOT NULL,
    lang character varying(3) NOT NULL,
    name character varying(80) NOT NULL,
    charset character varying(35)
);


ALTER TABLE public.languages OWNER TO opentg_user;

--
-- Name: TABLE languages; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON TABLE languages IS 'List of installed languages';


--
-- Name: COLUMN languages.id; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN languages.id IS 'Language ID #';


--
-- Name: COLUMN languages.lang; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN languages.lang IS 'Short Abreviation ex: en, uk, rus, de';


--
-- Name: COLUMN languages.name; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN languages.name IS 'Language''s Longer name';


--
-- Name: COLUMN languages.charset; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN languages.charset IS 'Characterset Used by Lang';


--
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: opentg_user
--

CREATE SEQUENCE languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.languages_id_seq OWNER TO opentg_user;

--
-- Name: languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: opentg_user
--

ALTER SEQUENCE languages_id_seq OWNED BY languages.id;


--
-- Name: languages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: opentg_user
--

SELECT pg_catalog.setval('languages_id_seq', 1, false);


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: opentg_user; Tablespace: 
--

CREATE TABLE permissions (
    uid integer,
    gid integer,
    allowlogin boolean,
    readmail boolean,
    sendmail boolean,
    readpost boolean,
    writepost boolean,
    pagesysop boolean,
    chat boolean,
    downloads boolean,
    uploads boolean,
    extprogs boolean,
    admin_all boolean,
    admin_system boolean,
    admin_files boolean,
    admin_msgs boolean,
    admin_users boolean,
    admin_groups boolean,
    admin_chat boolean,
    admin_extprogs boolean,
    admin_mail boolean,
    msgsarea boolean,
    filesarea boolean,
    dailytimelimit integer,
    maxtimedeposit integer,
    maxtimewithdraw integer,
    maxcredits integer,
    maxdownloads integer,
    maxdownloadsmb bigint,
    maxuploads integer,
    mailquota bigint,
    maxbulklists integer,
    maxposts integer
);


ALTER TABLE public.permissions OWNER TO opentg_user;

--
-- Name: COLUMN permissions.admin_chat; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.admin_chat IS 'Allow Chat Admin';


--
-- Name: COLUMN permissions.admin_extprogs; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.admin_extprogs IS 'Admin external programs';


--
-- Name: COLUMN permissions.admin_mail; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.admin_mail IS 'Admin Mail Services';


--
-- Name: COLUMN permissions.msgsarea; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.msgsarea IS 'Allow access to messages area submenu';


--
-- Name: COLUMN permissions.filesarea; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.filesarea IS 'Allow access to files area submenu';


--
-- Name: COLUMN permissions.dailytimelimit; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.dailytimelimit IS 'Daily Time Limit';


--
-- Name: COLUMN permissions.maxtimedeposit; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.maxtimedeposit IS 'Maximum value a user may deposit in timebank per day';


--
-- Name: COLUMN permissions.maxtimewithdraw; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.maxtimewithdraw IS 'Maximum value a yser may withdraw in a day';


--
-- Name: COLUMN permissions.maxcredits; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.maxcredits IS 'Maximum number of total Credits a user may have';


--
-- Name: COLUMN permissions.maxdownloads; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.maxdownloads IS 'Max Number of Downloads per day';


--
-- Name: COLUMN permissions.maxdownloadsmb; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.maxdownloadsmb IS 'Max Kilobytes in downloads transferred per day';


--
-- Name: COLUMN permissions.maxuploads; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.maxuploads IS 'Max number of Uploads per day';


--
-- Name: COLUMN permissions.mailquota; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.mailquota IS 'Mailbox Quota';


--
-- Name: COLUMN permissions.maxbulklists; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.maxbulklists IS 'Maximum Number of Bulk Mailing Lists';


--
-- Name: COLUMN permissions.maxposts; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN permissions.maxposts IS 'Maximum Number of Posts per day';


--
-- Name: platforms; Type: TABLE; Schema: public; Owner: opentg_user; Tablespace: 
--

CREATE TABLE platforms (
    osid integer NOT NULL,
    name character varying(64) NOT NULL,
    description character varying(255)
);


ALTER TABLE public.platforms OWNER TO opentg_user;

--
-- Name: TABLE platforms; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON TABLE platforms IS 'List of OS Platforms';


--
-- Name: platforms_osid_seq; Type: SEQUENCE; Schema: public; Owner: opentg_user
--

CREATE SEQUENCE platforms_osid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.platforms_osid_seq OWNER TO opentg_user;

--
-- Name: platforms_osid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: opentg_user
--

ALTER SEQUENCE platforms_osid_seq OWNED BY platforms.osid;


--
-- Name: platforms_osid_seq; Type: SEQUENCE SET; Schema: public; Owner: opentg_user
--

SELECT pg_catalog.setval('platforms_osid_seq', 1, false);


--
-- Name: users; Type: TABLE; Schema: public; Owner: opentg_user; Tablespace: 
--

CREATE TABLE users (
    uid integer NOT NULL,
    gid integer,
    login character varying(40) NOT NULL,
    password character varying(128),
    firstname character varying(30),
    lastname character varying(30),
    city character varying(40),
    state character varying(3),
    country character varying(3),
    email character varying(60),
    gender character varying(1),
    bday date,
    address character varying(128),
    phone character varying(20),
    postal character varying(15),
    signupdate timestamp with time zone,
    lastlogin timestamp with time zone,
    sysopnote character varying(255),
    timebank integer DEFAULT 0,
    credits integer DEFAULT 0,
    logintotal integer DEFAULT 0,
    pwhint character varying(256),
    pwexpires date,
    totalposts integer DEFAULT 0,
    totalfilesup integer DEFAULT 0,
    totalfilesdown integer DEFAULT 0,
    loginfailed integer DEFAULT 0,
    islocked boolean DEFAULT false
);


ALTER TABLE public.users OWNER TO opentg_user;

--
-- Name: COLUMN users.gender; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.gender IS 'User''s Gender';


--
-- Name: COLUMN users.bday; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.bday IS 'User''s Birthdate';


--
-- Name: COLUMN users.address; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.address IS 'Street Address';


--
-- Name: COLUMN users.phone; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.phone IS 'Telephone Number';


--
-- Name: COLUMN users.postal; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.postal IS 'Postal Code';


--
-- Name: COLUMN users.signupdate; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.signupdate IS 'Day user''s account was created';


--
-- Name: COLUMN users.lastlogin; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.lastlogin IS 'User''s last login timestamp';


--
-- Name: COLUMN users.sysopnote; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.sysopnote IS 'Sysop''s private comment about user 255 chars';


--
-- Name: COLUMN users.timebank; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.timebank IS 'User''s current timebank value';


--
-- Name: COLUMN users.credits; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.credits IS 'User''s credit values that may be redeemed';


--
-- Name: COLUMN users.logintotal; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.logintotal IS 'Number of logins for this user';


--
-- Name: COLUMN users.pwhint; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.pwhint IS 'User''s Password Hint';


--
-- Name: COLUMN users.pwexpires; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.pwexpires IS 'Date Password Expires';


--
-- Name: COLUMN users.totalposts; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.totalposts IS 'Total number of message posts';


--
-- Name: COLUMN users.totalfilesup; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.totalfilesup IS 'Total number of files uploaded';


--
-- Name: COLUMN users.totalfilesdown; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.totalfilesdown IS 'Total files downloaded';


--
-- Name: COLUMN users.loginfailed; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.loginfailed IS 'Number of Failed Login Attempts';


--
-- Name: COLUMN users.islocked; Type: COMMENT; Schema: public; Owner: opentg_user
--

COMMENT ON COLUMN users.islocked IS 'Account Locked Out bool';


--
-- Name: users_uid_seq; Type: SEQUENCE; Schema: public; Owner: opentg_user
--

CREATE SEQUENCE users_uid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.users_uid_seq OWNER TO opentg_user;

--
-- Name: users_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: opentg_user
--

ALTER SEQUENCE users_uid_seq OWNED BY users.uid;


--
-- Name: users_uid_seq; Type: SEQUENCE SET; Schema: public; Owner: opentg_user
--

SELECT pg_catalog.setval('users_uid_seq', 24, true);


--
-- Name: callnumber; Type: DEFAULT; Schema: public; Owner: opentg_user
--

ALTER TABLE callhistory ALTER COLUMN callnumber SET DEFAULT nextval('callhistory_callnumber_seq'::regclass);


--
-- Name: areaid; Type: DEFAULT; Schema: public; Owner: opentg_user
--

ALTER TABLE fileareas ALTER COLUMN areaid SET DEFAULT nextval('fileareas_areaid_seq'::regclass);


--
-- Name: catid; Type: DEFAULT; Schema: public; Owner: opentg_user
--

ALTER TABLE filecategories ALTER COLUMN catid SET DEFAULT nextval('filecategories_catid_seq'::regclass);


--
-- Name: fileid; Type: DEFAULT; Schema: public; Owner: opentg_user
--

ALTER TABLE files ALTER COLUMN fileid SET DEFAULT nextval('files_fileid_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: opentg_user
--

ALTER TABLE groups ALTER COLUMN gid SET DEFAULT nextval('groups_gid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: opentg_user
--

ALTER TABLE languages ALTER COLUMN id SET DEFAULT nextval('languages_id_seq'::regclass);


--
-- Name: osid; Type: DEFAULT; Schema: public; Owner: opentg_user
--

ALTER TABLE platforms ALTER COLUMN osid SET DEFAULT nextval('platforms_osid_seq'::regclass);


--
-- Name: uid; Type: DEFAULT; Schema: public; Owner: opentg_user
--

ALTER TABLE users ALTER COLUMN uid SET DEFAULT nextval('users_uid_seq'::regclass);


--
-- Data for Name: callhistory; Type: TABLE DATA; Schema: public; Owner: opentg_user
--

INSERT INTO callhistory VALUES (1, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 00:15:34-06', NULL);
INSERT INTO callhistory VALUES (2, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 21:26:19-06', NULL);
INSERT INTO callhistory VALUES (3, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 21:44:07-06', NULL);
INSERT INTO callhistory VALUES (4, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 21:44:30-06', NULL);
INSERT INTO callhistory VALUES (5, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 21:45:39-06', NULL);
INSERT INTO callhistory VALUES (6, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 21:45:51-06', NULL);
INSERT INTO callhistory VALUES (7, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 21:46:30-06', NULL);
INSERT INTO callhistory VALUES (8, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 21:46:54-06', NULL);
INSERT INTO callhistory VALUES (9, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 21:47:38-06', NULL);
INSERT INTO callhistory VALUES (10, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 21:48:53-06', NULL);
INSERT INTO callhistory VALUES (11, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 21:50:13-06', NULL);
INSERT INTO callhistory VALUES (12, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 22:06:28-06', NULL);
INSERT INTO callhistory VALUES (13, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 22:22:26-06', NULL);
INSERT INTO callhistory VALUES (14, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 22:25:05-06', NULL);
INSERT INTO callhistory VALUES (15, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 22:25:43-06', NULL);
INSERT INTO callhistory VALUES (16, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 22:28:29-06', NULL);
INSERT INTO callhistory VALUES (17, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 22:28:52-06', NULL);
INSERT INTO callhistory VALUES (18, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 22:33:27-06', NULL);
INSERT INTO callhistory VALUES (19, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 22:36:27-06', NULL);
INSERT INTO callhistory VALUES (20, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 22:36:55-06', NULL);
INSERT INTO callhistory VALUES (21, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 22:37:36-06', NULL);
INSERT INTO callhistory VALUES (22, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 22:38:00-06', NULL);
INSERT INTO callhistory VALUES (23, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 22:38:29-06', NULL);
INSERT INTO callhistory VALUES (24, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 22:43:41-06', NULL);
INSERT INTO callhistory VALUES (25, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 22:44:26-06', NULL);
INSERT INTO callhistory VALUES (26, 'SHARKOS', 'none', 'Denver', 'CO', NULL, NULL);
INSERT INTO callhistory VALUES (27, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 23:04:09-06', NULL);
INSERT INTO callhistory VALUES (28, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 23:04:21-06', NULL);
INSERT INTO callhistory VALUES (29, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 23:05:28-06', NULL);
INSERT INTO callhistory VALUES (30, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 23:05:56-06', NULL);
INSERT INTO callhistory VALUES (31, 'SHARKOS', 'none', 'Denver', 'CO', NULL, NULL);
INSERT INTO callhistory VALUES (32, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 23:07:29-06', NULL);
INSERT INTO callhistory VALUES (33, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 23:08:01-06', NULL);
INSERT INTO callhistory VALUES (34, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 23:08:22-06', NULL);
INSERT INTO callhistory VALUES (35, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 23:09:55-06', NULL);
INSERT INTO callhistory VALUES (36, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 23:10:27-06', NULL);
INSERT INTO callhistory VALUES (37, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 23:14:46-06', NULL);
INSERT INTO callhistory VALUES (38, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 23:15:11-06', NULL);
INSERT INTO callhistory VALUES (39, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 23:16:03-06', NULL);
INSERT INTO callhistory VALUES (40, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 23:25:58-06', '2009-04-24 23:25:58-06');
INSERT INTO callhistory VALUES (41, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 23:27:49-06', '2009-04-24 23:27:49-06');
INSERT INTO callhistory VALUES (42, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 23:28:05-06', '2009-04-24 23:28:05-06');
INSERT INTO callhistory VALUES (43, 'PTEST', 'none', 'Winter Parc', 'CO', '2009-04-24 23:28:38-06', '2009-04-24 23:28:38-06');
INSERT INTO callhistory VALUES (44, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 23:29:45-06', '2009-04-24 23:29:45-06');
INSERT INTO callhistory VALUES (45, 'VORTIGON', 'none', 'Denver', 'CO', '2009-04-24 23:29:54-06', '2009-04-24 23:29:54-06');


--
-- Data for Name: fileareas; Type: TABLE DATA; Schema: public; Owner: opentg_user
--

INSERT INTO fileareas VALUES (5, 'NEWAREA-5', 'Newly Created File Area 6', false, 1, 1, false, '/bbs/files/5', NULL, true, NULL);
INSERT INTO fileareas VALUES (6, 'NEWAREA-6', 'Newly Created File Area 7', false, 1, 1, false, '/bbs/files/6', NULL, true, NULL);
INSERT INTO fileareas VALUES (7, 'NEWAREA-7', 'Newly Created File Area 8', false, 1, 1, false, '/bbs/files/7', NULL, true, NULL);
INSERT INTO fileareas VALUES (8, 'NEWAREA-8', 'Newly Created File Area 9', false, 1, 1, false, '/bbs/files/8', NULL, true, NULL);
INSERT INTO fileareas VALUES (9, 'NEWAREA-9', 'Newly Created File Area 9', false, 1, 1, false, '/bbs/files/9', NULL, true, NULL);
INSERT INTO fileareas VALUES (10, 'NEWAREA-10', 'Newly Created File Area 10', false, 1, 1, false, '/bbs/files/10', NULL, true, NULL);
INSERT INTO fileareas VALUES (11, 'NEWAREA-11', 'Newly Created File Area 11', false, 1, 1, false, '/bbs/files/11', NULL, true, NULL);
INSERT INTO fileareas VALUES (12, 'NEWAREA-12', 'Newly Created File Area 12', false, 1, 1, false, '/bbs/files/12', NULL, true, NULL);
INSERT INTO fileareas VALUES (13, 'NEWAREA-13', 'Newly Created File Area 13', false, 1, 1, false, '/bbs/files/13', NULL, true, NULL);
INSERT INTO fileareas VALUES (1, 'DROPBOX', 'SYSOP Dropbox (this area cannot be removed)', true, 1, 4, true, '/bbs/files/DROPBOX', NULL, true, '2009-04-04 13:52:40-06');
INSERT INTO fileareas VALUES (4, 'NEWAREA-4', 'Newly Created File Area 5', false, 1, 1, false, '/bbs/files/4', NULL, true, '2009-04-04 13:52:48-06');
INSERT INTO fileareas VALUES (2, 'PROTECTED', 'Sample Password Protected File Area', false, 1, 3, true, '/bbs/files/2', 'ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff', true, '2009-04-04 22:02:02-06');
INSERT INTO fileareas VALUES (3, 'INDEXTEST', 'Used for developer testing of indexing feature', false, 1, 1, false, '/bbs/files/3', NULL, true, '2009-04-04 22:03:46-06');


--
-- Data for Name: filecategories; Type: TABLE DATA; Schema: public; Owner: opentg_user
--

INSERT INTO filecategories VALUES (1, NULL, 'Unsorted', 'Files that have not been placed into a category');


--
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: opentg_user
--

INSERT INTO files VALUES (2, 2, 'testfile.tgz', 1, 'A test file tarball', 1, 'd41d8cd98f00b204e9800998ecf8427e', '1.1', 1, '2009-04-03 22:11:58-06', true, NULL, NULL);
INSERT INTO files VALUES (11, 3, 'area3tester.tar.gz', NULL, NULL, 1, '98a2672333c3268f94842a6a2270ca8b', NULL, NULL, '2009-04-04 14:01:32-06', true, '2009-04-04 14:01:07-06', 51012);
INSERT INTO files VALUES (12, 3, 'newfile02.txt', NULL, NULL, 1, 'd41d8cd98f00b204e9800998ecf8427e', NULL, NULL, '2009-04-04 22:03:46-06', true, '2009-04-04 22:02:36-06', 0);
INSERT INTO files VALUES (13, 3, 'yetanother.zip', NULL, NULL, 1, 'd41d8cd98f00b204e9800998ecf8427e', NULL, NULL, '2009-04-04 22:03:46-06', true, '2009-04-04 22:02:44-06', 0);
INSERT INTO files VALUES (3, 2, 'area2filetest.rar', 3, 'Another test file in a different area', 1, 'd41d8cd98f00b204e9800998ecf8427e', '0.1', 4, NULL, true, NULL, NULL);
INSERT INTO files VALUES (1, 2, 'yaf-12.zip', NULL, NULL, 1, 'd41d8cd98f00b204e9800998ecf8427e', NULL, NULL, '2009-04-04 11:39:41-06', true, '2009-04-02 22:17:33-06', 0);
INSERT INTO files VALUES (7, 2, 'empty200.img', NULL, NULL, 1, 'c522c1db31cc1f90b5d21992fd30e2ab', NULL, NULL, '2009-04-04 12:34:55-06', true, '2009-04-03 18:03:48-06', 204800);
INSERT INTO files VALUES (8, 2, 'empty500.img', NULL, NULL, 1, '816df6f64deba63b029ca19d880ee10a', NULL, NULL, '2009-04-04 12:39:27-06', true, '2009-04-03 18:05:59-06', 512000);
INSERT INTO files VALUES (9, 2, 'nullfilled.img', NULL, NULL, 1, 'f5f24b666fea7cc6825ceae8f9750362', NULL, NULL, '2009-04-04 12:39:27-06', true, '2009-04-03 18:06:24-06', 30720000);


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: opentg_user
--

INSERT INTO groups VALUES (1, 'super', 'Full Administration Rights (aka: SYSOP)');
INSERT INTO groups VALUES (6, 'locked', 'No Permissions (Account Locked)');
INSERT INTO groups VALUES (5, 'new', 'New user default privilges.');
INSERT INTO groups VALUES (4, 'user', 'Regular User');
INSERT INTO groups VALUES (3, 'poweruser', 'User with Extended Rights');
INSERT INTO groups VALUES (2, 'poweradmin', 'Co-SysOP or assistant admin.');


--
-- Data for Name: languages; Type: TABLE DATA; Schema: public; Owner: opentg_user
--

INSERT INTO languages VALUES (1, 'us', 'US English', 'UTF-8');


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: opentg_user
--

INSERT INTO permissions VALUES (NULL, 1, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, -1, 999, 999, 999, 999, -1, 999, -1, 10, -1);
INSERT INTO permissions VALUES (NULL, 2, true, true, true, true, true, true, true, false, false, true, false, false, true, true, true, true, true, false, true, true, true, -1, 180, 180, 999, 100, 8096, -1, 200, 5, 200);
INSERT INTO permissions VALUES (1, NULL, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, -1, 999, 999, 999, 999, -1, 999, -1, 10, -1);
INSERT INTO permissions VALUES (2, NULL, true, true, false, true, false, true, false, true, true, false, false, false, false, false, false, false, false, false, false, true, true, 30, 0, 0, 0, 0, 0, 0, 1, 0, 0);
INSERT INTO permissions VALUES (5, NULL, true, true, false, true, false, true, false, true, true, false, false, false, false, false, false, false, false, false, false, true, true, 30, 0, 0, 0, 0, 0, 0, 1, 0, 0);
INSERT INTO permissions VALUES (NULL, 5, true, true, false, true, false, true, false, true, true, false, false, false, false, false, false, false, false, false, false, true, true, 30, 0, 0, 0, 0, 0, 0, 1, 0, 0);
INSERT INTO permissions VALUES (4, NULL, true, true, false, true, false, true, false, true, true, false, false, false, false, true, false, false, false, false, false, true, true, 60, 0, 0, 0, 0, 0, 0, 1, 0, 0);
INSERT INTO permissions VALUES (NULL, 4, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, true, true, 90, 30, 60, 3, 5, 1024, 3, 10, 1, 25);
INSERT INTO permissions VALUES (NULL, 3, true, true, true, true, true, true, true, false, false, true, false, false, false, false, false, false, false, false, false, true, true, 240, 90, 60, 5, 15, 4096, 10, 50, 3, 50);
INSERT INTO permissions VALUES (NULL, 6, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);


--
-- Data for Name: platforms; Type: TABLE DATA; Schema: public; Owner: opentg_user
--

INSERT INTO platforms VALUES (1, 'linux-x86', 'Linux x86 and compatible');
INSERT INTO platforms VALUES (2, 'linux-amd64', 'Linux 64-bit AMD64/EMT64');
INSERT INTO platforms VALUES (3, 'linux-ppc', 'Linux for PowerPC');
INSERT INTO platforms VALUES (4, 'linux-other', 'Linux on other hardware');
INSERT INTO platforms VALUES (5, 'no-arch', 'Multi Platform');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: opentg_user
--

INSERT INTO users VALUES (5, 5, 'crumb', '$2a$10$D5WzK.g9qjarZxmnYZA24uPgTPjy/FmU80RrjGz7OdNj7e4VPK9Iq', 'John', 'Crump', 'crumbville', 'oh', 'us', 'blahbalh', 'm', '1981-01-01', NULL, NULL, '11111', '2009-04-20 22:39:07-06', NULL, NULL, 0, 0, 0, 'test123', '2009-07-19', 0, 0, 0, 0, false);
INSERT INTO users VALUES (3, 5, 'sharkos', '$2a$10$kDt1G79ap3jiT0tFpbxjgeF4SIHUUOqq.IxMj31QAVxXVMuVURJ86', 'Chris', 'Tusa', 'Denver', 'CO', 'US', 'christusa@opentg.org', 'm', '1978-03-22', NULL, NULL, '80210', '2009-04-18 22:48:05-06', '2009-04-18 22:50:00-06', NULL, 0, 0, 2, 'test123', '2009-07-17', 0, 0, 0, 0, false);
INSERT INTO users VALUES (4, 5, 'ptest', '$2a$10$6sNpxA10Ry43LCQJb86HveI9MzvIgeWgnu5TRxUURDUdkBqpIt6oW', 'Perms', 'Test', 'Winter Parc', 'CO', 'US', 'ptest@opentg.org', 'm', '1970-01-01', '1100 HWY 70', '000-000-0000', '80210', '2009-04-19 21:53:16-06', '2009-04-24 23:28:38-06', 'Delete this later', 0, 0, 69, 'test123', '2009-07-18', 0, 0, 0, 0, false);
INSERT INTO users VALUES (2, 5, 'vortigon', '$2a$10$82i/hjZRuOneFIgNhdvPbeENF1ckFJlaKZYWNesgOI1oOY7qPvA0G', 'Rasta', 'Mana', 'Denver', 'CO', 'us', 'vortigon@vortigon.com', 'm', '1970-01-01', NULL, NULL, '80210', '2009-04-20 22:36:30-06', '2009-04-24 23:29:54-06', NULL, 0, 0, 17, 'test123', '2009-07-19', 0, 0, 0, 0, false);
INSERT INTO users VALUES (1, 1, 'sysop', '$2a$10$nU93vH0ZWltqwWDrPr7ODORI9FN/22lpVmT6BxwVN3Yh/eEXXbEAG', 'System', 'Operator', 'Riverbed', 'TX', 'US', 'sysop@localhost', 'm', '1999-01-01', '1100 Somestreet', '000-000-0000', '74233', NULL, NULL, 'Master Super User', 10, -1, 0, 'none', '2009-05-12', NULL, NULL, NULL, 4, false);


--
-- Name: categories_catid_key; Type: CONSTRAINT; Schema: public; Owner: opentg_user; Tablespace: 
--

ALTER TABLE ONLY filecategories
    ADD CONSTRAINT categories_catid_key UNIQUE (catid);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: opentg_user; Tablespace: 
--

ALTER TABLE ONLY filecategories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (name);


--
-- Name: fileareas_id_key; Type: CONSTRAINT; Schema: public; Owner: opentg_user; Tablespace: 
--

ALTER TABLE ONLY fileareas
    ADD CONSTRAINT fileareas_id_key UNIQUE (areaid);


--
-- Name: files_fileid_key; Type: CONSTRAINT; Schema: public; Owner: opentg_user; Tablespace: 
--

ALTER TABLE ONLY files
    ADD CONSTRAINT files_fileid_key UNIQUE (fileid);


--
-- Name: files_pkey; Type: CONSTRAINT; Schema: public; Owner: opentg_user; Tablespace: 
--

ALTER TABLE ONLY files
    ADD CONSTRAINT files_pkey PRIMARY KEY (filename);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: opentg_user; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (gid);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

