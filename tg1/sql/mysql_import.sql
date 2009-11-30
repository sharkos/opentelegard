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
    read boolean
);


COMMENT ON TABLE fileareas IS 'File Areas Configuration';
COMMENT ON COLUMN fileareas.areaid IS 'Unique ID';
COMMENT ON COLUMN fileareas.name IS 'File Area Name';
COMMENT ON COLUMN fileareas.description IS 'File Area Description';
COMMENT ON COLUMN fileareas.write IS 'Writeable? Uploads allowed';
COMMENT ON COLUMN fileareas.moderator IS 'Assigned Moderator';
COMMENT ON COLUMN fileareas.mingid IS 'Restrict to a specific group id';
COMMENT ON COLUMN fileareas.autoindex IS 'Allow routine scanning and auto updates';
COMMENT ON COLUMN fileareas.path IS 'Path to directory where files are stored for this area';
COMMENT ON COLUMN fileareas.password IS 'If set, require password to enter';
COMMENT ON COLUMN fileareas.read IS 'Allow reads - Useful for dropboxes';

CREATE TABLE filecategories (
    catid integer,
    parent integer,
    name character varying(64) NOT NULL,
    description text
);

COMMENT ON TABLE filecategories IS 'Cateogies for File Areas and Message Areas';
COMMENT ON COLUMN filecategories.catid IS 'Category ID';
COMMENT ON COLUMN filecategories.parent IS 'Parent Category ID if this is a sub, otherwise NULL';
COMMENT ON COLUMN filecategories.name IS 'Category Name';
COMMENT ON COLUMN filecategories.description IS 'Category Description';

CREATE TABLE files (
    fileid integer,
    areaid integer NOT NULL,
    filename character varying(255) NOT NULL,
    catid integer,
    description text,
    owner integer,
    checksum character varying(255),
    version character varying(32),
    platform integer
);

COMMENT ON TABLE files IS 'File Details';
COMMENT ON COLUMN files.fileid IS 'Unique File Identifier';
COMMENT ON COLUMN files.areaid IS 'File Area ID';
COMMENT ON COLUMN files.filename IS 'Filename (no path)';
COMMENT ON COLUMN files.catid IS 'Category ID';
COMMENT ON COLUMN files.description IS 'Long Description';
COMMENT ON COLUMN files.owner IS 'UID of uploader or owner';
COMMENT ON COLUMN files.checksum IS 'File''s MD5sum for verification';
COMMENT ON COLUMN files.platform IS 'Platform ID';

CREATE TABLE groups (
    gid integer NOT NULL,
    name character varying(25),
    description character varying(256)
);

COMMENT ON COLUMN groups.description IS 'Group Short Description';

CREATE TABLE languages (
    id integer NOT NULL,
    lang character varying(3) NOT NULL,
    name character varying(80) NOT NULL,
    charset character varying(35)
);

COMMENT ON TABLE languages IS 'List of installed languages';
COMMENT ON COLUMN languages.id IS 'Language ID #';
COMMENT ON COLUMN languages.lang IS 'Short Abreviation ex: en, uk, rus, de';
COMMENT ON COLUMN languages.name IS 'Language''s Longer name';
COMMENT ON COLUMN languages.charset IS 'Characterset Used by Lang';

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
    filesarea boolean
);

COMMENT ON COLUMN permissions.admin_chat IS 'Allow Chat Admin';
COMMENT ON COLUMN permissions.admin_extprogs IS 'Admin external programs';
COMMENT ON COLUMN permissions.admin_mail IS 'Admin Mail Services';
COMMENT ON COLUMN permissions.msgsarea IS 'Allow access to messages area submenu';
COMMENT ON COLUMN permissions.filesarea IS 'Allow access to files area submenu';

CREATE TABLE platforms (
    osid integer NOT NULL,
    name character varying(64) NOT NULL,
    description character varying(255)
);


COMMENT ON TABLE platforms IS 'List of OS Platforms';

CREATE TABLE users (
    uid integer NOT NULL,
    gid integer,
    login character varying(40),
    password character varying(128),
    firstname character varying(30),
    lastname character varying(30),
    city character varying(40),
    state character varying(3),
    country character varying(3),
    email character varying(60)
);


INSERT INTO fileareas VALUES (3, 'NEWAREA-3', 'Newly Created File Area 3', false, 1, 4, true, '/bbs/files/3', NULL, true);
INSERT INTO fileareas VALUES (2, 'PROTECTED', 'Sample Password Protected File Area', false, 1, 3, true, '/bbs/files/2', 'ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff', true);
INSERT INTO fileareas VALUES (1, 'DROPBOX', 'SYSOP Dropbox (this area cannot be removed)', true, 1, 4, true, '/bbs/files/DROPBOX', NULL, false);

INSERT INTO filecategories VALUES (1, NULL, 'Unsorted', 'Files that have not been placed into a category');

INSERT INTO files VALUES (1, 1, 'testfile.tgz', 1, 'A sample file for the database', 1, 'SOME VALUE', '1.1', 1);

INSERT INTO groups VALUES (1, 'super', 'Full Administration Rights (aka: SYSOP)');
INSERT INTO groups VALUES (6, 'locked', 'No Permissions (Account Locked)');
INSERT INTO groups VALUES (5, 'new', 'New user default privilges.');
INSERT INTO groups VALUES (4, 'user', 'Regular User');
INSERT INTO groups VALUES (3, 'poweruser', 'User with Extended Rights');
INSERT INTO groups VALUES (2, 'poweradmin', 'Co-SysOP or assistant admin.');

INSERT INTO languages VALUES (1, 'us', 'US English', 'UTF-8');

INSERT INTO permissions VALUES (2, NULL, true, true, false, true, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true);
INSERT INTO permissions VALUES (1, NULL, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true);
INSERT INTO permissions VALUES (NULL, 5, true, true, false, true, false, true, false, true, true, false, false, false, false, false, false, false, false, false, false, true, true);
INSERT INTO permissions VALUES (NULL, 4, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, true, true);
INSERT INTO permissions VALUES (NULL, 1, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true);
INSERT INTO permissions VALUES (NULL, 3, true, true, true, true, true, true, true, false, false, true, false, false, false, false, false, false, false, false, false, true, true);
INSERT INTO permissions VALUES (NULL, 2, true, true, true, true, true, true, true, false, false, true, false, false, true, true, true, true, true, false, true, true, true);
INSERT INTO permissions VALUES (NULL, 6, false, false, false, false, false, false, false, true, false, true, false, false, false, false, false, false, false, false, false, false, false);

INSERT INTO platforms VALUES (1, 'linux-x86', 'Linux x86 and compatible');
INSERT INTO platforms VALUES (2, 'linux-amd64', 'Linux 64-bit AMD64/EMT64');
INSERT INTO platforms VALUES (3, 'linux-ppc', 'Linux for PowerPC');
INSERT INTO platforms VALUES (4, 'linux-other', 'Linux on other hardware');
INSERT INTO platforms VALUES (5, 'no-arch', 'Multi Platform');

INSERT INTO users VALUES (1, 1, 'sysop', 'bd2b1aaf7ef4f09be9f52ce2d8d599674d81aa9d6a4421696dc4d93dd0619d682ce56b4d64a9ef097761ced99e0f67265b5f76085e5b0ee7ca4696b2ad6fe2b2', 'System', 'Operator', 'Denver', 'CO', 'US', 'sysop@localhost');
INSERT INTO users VALUES (2, 5, 'newuser', NULL, 'NEW', 'User', 'Nowhere', 'NW', 'US', 'new@localhost');

