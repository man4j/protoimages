CREATE TABLE taxpayer (
    tin                 VARCHAR(12) NOT NULL,
    name_ru             VARCHAR(900),
    name_kz             VARCHAR(900),
    first_name          VARCHAR(900),
    last_name           VARCHAR(900),
    middle_name         VARCHAR(900),
    first_name_kz       VARCHAR(900),
    last_name_kz        VARCHAR(900),
    middle_name_kz      VARCHAR(900),
    address_ru          VARCHAR(510),
    address_kz          VARCHAR(510),
    certificate_series  VARCHAR(5),
    certificate_num     VARCHAR(7),
    resident            TINYINT,
    type                TINYINT,
    state               TINYINT,
    resource_user       TINYINT,
    director_iin        VARCHAR(12),
    CONSTRAINT pk_taxpayer PRIMARY KEY (tin)
);

PARTITION TABLE taxpayer ON COLUMN tin;

----------------------------------------------------------------------------------------------------------

CREATE TABLE bank (
    id                 BIGINT NOT NULL,
    original_name_ru   VARCHAR(254),
    original_name_kz   VARCHAR(254),
    bik                VARCHAR(11),
    code               VARCHAR(12),
    tin                VARCHAR(12),
    rnn                VARCHAR(12),
    active             TINYINT,

    CONSTRAINT pk_bank PRIMARY KEY (id)
);

CREATE INDEX idx_bank_bik ON bank(bik);

----------------------------------------------------------------------------------------------------------

CREATE TABLE user (
    system_profile_type       VARCHAR(30)  NOT NULL,
    login                     VARCHAR(12)  NOT NULL,
    password                  VARCHAR(64)  NOT NULL,
    email                     VARCHAR(128) NOT NULL,
    issue_date                VARCHAR(64)  NOT NULL,
    issued_by                 VARCHAR(200) NOT NULL,
    passport_num              VARCHAR(30),
    status                    TINYINT      NOT NULL,
    reason                    VARCHAR(500) NOT NULL,
    preferences               VARCHAR(8000),
    message_view_history_json VARCHAR(2048),
    user_service_role_type    TINYINT DEFAULT 0 NOT NULL,
    admin_permissions         VARCHAR(200), 
    service_man_permissions   VARCHAR(200), 

    CONSTRAINT pk_user PRIMARY KEY (login)
);

PARTITION TABLE user ON COLUMN login;

CREATE INDEX idx_user_email ON user(email);
CREATE INDEX idx_user_service_role_type ON user(user_service_role_type);

----------------------------------------------------------------------------------------------------------

CREATE TABLE business_user (
    iin                    VARCHAR(12)  NOT NULL,
    tin                    VARCHAR(12)  NOT NULL,
    permissions            VARCHAR(200) NOT NULL, 
    business_profile_type  VARCHAR(30)  NOT NULL,
    status                 TINYINT      NOT NULL,
    reason                 VARCHAR(500) NOT NULL,
    acts_on_the_basis      VARCHAR(200),
    event_id               VARBINARY(16),
    update_date            BIGINT,
    expiration_date        BIGINT,

    CONSTRAINT pk_business_user PRIMARY KEY (iin, tin)
);

CREATE INDEX idx_business_user_tin ON business_user(tin);

----------------------------------------------------------------------------------------------------------

CREATE TABLE session (
    session_id            VARCHAR(64)  NOT NULL,
    expiration_date       TIMESTAMP    NOT NULL,
    host                  VARCHAR(20),
    user_login            VARCHAR(32)  NOT NULL,

    CONSTRAINT pk_session PRIMARY KEY (session_id)
);

PARTITION TABLE session ON COLUMN session_id;

CREATE INDEX idx_session_expiration_date ON session(expiration_date);

----------------------------------------------------------------------------------------------------------

CREATE TABLE user_request (
    user_login        VARCHAR(32) NOT NULL,
    verification_key  VARCHAR(40) NOT NULL,
    created_date      TIMESTAMP   NOT NULL,
    expiration_date   TIMESTAMP   NOT NULL,
    json_data         VARCHAR(1512),

    CONSTRAINT pk_user_requestk PRIMARY KEY (user_login)
);

PARTITION TABLE user_request ON COLUMN user_login;

CREATE INDEX idx_user_verification_key ON user_request(verification_key);
CREATE INDEX idx_user_expiration_date ON user_request(expiration_date);

----------------------------------------------------------------------------------------------------------

CREATE TABLE currency_code (
    code               VARCHAR(3)   PRIMARY KEY NOT NULL,
    symbol             VARCHAR(3),
    priority           INTEGER      DEFAULT 0 NOT NULL,
    name_ru            VARCHAR(510),
    name_kz            VARCHAR(510)
);

CREATE INDEX currency_code_symbol_idx ON currency_code(symbol);

----------------------------------------------------------------------------------------------------------

CREATE TABLE esb_client (
    tin                     VARCHAR(12) NOT NULL,
    client_id               VARCHAR(100),
    last_invoice_event_id   VARCHAR(64) NOT NULL,
    last_status_event_id    VARCHAR(64) NOT NULL,
    last_journal_event_id   VARCHAR(64) NOT NULL,

    CONSTRAINT pk_esb_client PRIMARY KEY (tin, client_id)
);

PARTITION TABLE esb_client ON COLUMN tin;

----------------------------------------------------------------------------------------------------------

CREATE TABLE enterprise_link (
    master                 VARCHAR(12)  NOT NULL,
    slave                  VARCHAR(12)  NOT NULL,
    link_type              BIGINT       NOT NULL,

    CONSTRAINT enterprise_link_pk PRIMARY KEY (master, slave)
);

CREATE INDEX idx_slave ON enterprise_link(slave);

----------------------------------------------------------------------------------------------------------


CREATE TABLE feedback_to_category (
    category VARCHAR(32) NOT NULL,
    emails   VARCHAR(400),

    CONSTRAINT idx_feedback_to_category PRIMARY KEY (category)
);

---------------------------------------------------------------------------------------------------------

CREATE TABLE enterprise_link_type (
    link_type              BIGINT NOT NULL,
    create_flag            TINYINT DEFAULT 0 NOT NULL,
    edit_drafts_flag       TINYINT DEFAULT 0 NOT NULL,
    accept_flag            TINYINT DEFAULT 0 NOT NULL,
    decline_flag           TINYINT DEFAULT 0 NOT NULL,
    create_additional_flag TINYINT DEFAULT 0 NOT NULL,
    create_correct_flag    TINYINT DEFAULT 0 NOT NULL,

    CONSTRAINT pk_enterprise_link_type PRIMARY KEY (link_type)
);

---------------------------------------------------------------------------------------------------------

CREATE TABLE settlement_account (
    id                  BIGINT NOT NULL,
    taxpayer_tin        VARCHAR(12) NOT NULL,
    bank_id             BIGINT,
    account_type        INTEGER,
    account             VARCHAR(40), 
    date_open           TIMESTAMP,
    date_close          TIMESTAMP,

    CONSTRAINT pk_settlement_account PRIMARY KEY (taxpayer_tin, bank_id, account)
);

PARTITION TABLE settlement_account ON COLUMN taxpayer_tin;

---------------------------------------------------------------------------------------------------------

CREATE TABLE enterprise_admin_change_request (
    enterprise_tin      VARCHAR(12) NOT NULL,
    old_iin             VARCHAR(12) NOT NULL,
    new_iin             VARCHAR(12) NOT NULL,
    block_date          TIMESTAMP   NOT NULL,
    request_status      TINYINT     NOT NULL,

    CONSTRAINT pk_enterprise_admin_change_requestk PRIMARY KEY (enterprise_tin)
);

CREATE INDEX idx_pk_enterprise_admin_change_date ON enterprise_admin_change_request(block_date);

---------------------------------------------------------------------------------------------------------

CREATE TABLE settings (
    key                 VARCHAR(80)  NOT NULL,
    value               VARCHAR(400) NOT NULL,
    description_ru      VARCHAR(300) NOT NULL,
    description_kz      VARCHAR(300),
    validation_regexp   VARCHAR(100) NOT NULL,

    CONSTRAINT pk_settings PRIMARY KEY (key)
);

CREATE PROCEDURE GET_ALL_SETTINGS AS SELECT * FROM settings;
CREATE PROCEDURE SETTINGS_SELECT_BY_KEY AS SELECT * FROM settings WHERE key = ?;

---------------------------------------------------------------------------------------------------------

CREATE TABLE nsi_info (
    version         VARCHAR(20) NOT NULL,
    actuality_date  VARCHAR(25) NOT NULL
);

CREATE PROCEDURE NsiInfoSelect AS SELECT * FROM nsi_info;
CREATE PROCEDURE NsiInfoUpdate AS UPDATE nsi_info SET version = ?, actuality_date = ?;

---------------------------------------------------------------------------------------------------------

CREATE TABLE registration_number (
    value BIGINT NOT NULL,
    date  BIGINT NOT NULL
);

---------------------------------------------------------------------------------------------------------

CREATE TABLE invoice_sequence (
   id BIGINT NOT NULL,
);

---------------------------------------------------------------------------------------------------------

CREATE TABLE invoice_search_criteria_record (
    id            VARCHAR(36)   NOT NULL,
    name          VARCHAR(80)   NOT NULL,
    shared        TINYINT NOT   NULL,
    author        VARCHAR(12)   NOT NULL,
    json_criteria VARCHAR(2000) NOT NULL,

    CONSTRAINT pk_invoice_search_criteria_record PRIMARY KEY (id)
);

PARTITION TABLE invoice_search_criteria_record ON COLUMN id;

CREATE INDEX invoice_search_criteria_record_author_shared_idx ON invoice_search_criteria_record(author, shared);

CREATE TABLE invoice_draft_json (
   id BIGINT NOT NULL,
   json_data VARCHAR(80000) NOT NULL,
   seller_tin VARCHAR(12) NOT NULL,

   CONSTRAINT Invoice_draft_ID_Idx PRIMARY KEY (id)
);

PARTITION TABLE invoice_draft_json ON COLUMN id;

CREATE INDEX idx_invoice_draft_json_seller_tin ON invoice_draft_json(seller_tin);

---------------------------------------------------------------------------------------------------------

CREATE TABLE invoice_queue (
   id VARCHAR(100) NOT NULL,
   tin VARCHAR(12) NOT NULL,
   input_date BIGINT NOT NULL,
   json_data VARCHAR(80000) NOT NULL,
);

PARTITION TABLE invoice_queue ON COLUMN tin;

CREATE INDEX idx_invoice_queue_tin ON invoice_queue(tin);
CREATE INDEX idx_invoice_queue_id ON invoice_queue(id);

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE TaxpayerFindByTin AS
  SELECT t.tin, t.name_ru, t.name_kz,
    t.first_name, t.last_name, t.middle_name,
    t.first_name_kz, t.last_name_kz, t.middle_name_kz,
    t.address_ru, t.address_kz , t.certificate_series, t.certificate_num,
    t.resident, t.type, t.state, t.resource_user, t.director_iin,
    a.id AS account_id, a.taxpayer_tin, a.account_type, a.account, a.date_open, a.date_close,
    b.id AS bank_id, b.original_name_ru, b.original_name_kz, b.bik, b.code, b.tin, b.rnn, b.active,
    el.master
  FROM taxpayer t
  LEFT JOIN settlement_account a ON a.taxpayer_tin = t.tin AND a.date_close IS NULL
  LEFT JOIN bank b ON b.id = a.bank_id
  LEFT JOIN enterprise_link el ON el.slave = t.tin AND el.link_type = 3
  WHERE t.state <> 2 AND t.tin = ?;
PARTITION PROCEDURE TaxpayerFindByTin ON TABLE taxpayer COLUMN tin;

CREATE PROCEDURE TaxpayerSelectBatch AS SELECT * FROM taxpayer WHERE tin IN ?;
CREATE PROCEDURE TaxpayerCountAll AS SELECT COUNT(*) FROM taxpayer;
CREATE PROCEDURE TaxpayerClearAllAddress AS UPDATE taxpayer SET address_ru = NULL, address_kz = NULL;
CREATE PROCEDURE TaxpayerCountAllWithAddress AS SELECT COUNT(*) FROM taxpayer WHERE address_ru IS NOT NULL;
CREATE PROCEDURE ReadTaxpayers AS SELECT * FROM taxpayer WHERE tin > ? ORDER BY tin LIMIT ?;
CREATE PROCEDURE TaxpayerTruncate AS TRUNCATE TABLE taxpayer;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE BankFindByBik AS SELECT * FROM bank WHERE active = 1 AND bik = ?;
CREATE PROCEDURE BankCountAll AS SELECT COUNT(*) FROM bank;
CREATE PROCEDURE BankSelect AS SELECT * FROM bank WHERE id = ?;
CREATE PROCEDURE BankTruncate AS TRUNCATE TABLE bank;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE GET_MESSAGE_VIEW_HISTORY AS SELECT message_view_history_json FROM user WHERE login=?;
PARTITION PROCEDURE GET_MESSAGE_VIEW_HISTORY ON TABLE user COLUMN login;

CREATE PROCEDURE UPDATE_MESSAGE_VIEW_HISTORY AS UPDATE user SET message_view_history_json=? WHERE login=?;
PARTITION PROCEDURE UPDATE_MESSAGE_VIEW_HISTORY ON TABLE user COLUMN login PARAMETER 1;

CREATE PROCEDURE GetUserByRole AS SELECT * FROM user WHERE user_service_role_type=? ORDER BY login;

CREATE PROCEDURE SelectAll AS SELECT * FROM user;

CREATE PROCEDURE UserSelectWithBusinessUser AS
  SELECT u.system_profile_type, u.login, u.password, u.email, u.issue_date, u.issued_by, u.passport_num,
    u.status, u.reason, u.preferences, u.message_view_history_json, u.user_service_role_type,
    u.admin_permissions, u.service_man_permissions,
    bu.iin AS bu_iin, bu.tin AS bu_tin, bu.permissions AS bu_permissions,
    bu.business_profile_type AS bu_business_profile_type, bu.status AS bu_status,
    bu.reason AS bu_reason, bu.acts_on_the_basis AS bu_acts_on_the_basis,
    bu.event_id AS bu_event_id, bu.expiration_date AS bu_expiration_date,
    bu.update_date AS bu_update_date,
    el.slave AS sub_tin
  FROM user u
  LEFT JOIN business_user bu ON bu.iin = u.login AND u.system_profile_type = 'BUSINESS_USER'
  LEFT JOIN enterprise_link el ON el.master = bu.tin AND el.link_type = 3
  WHERE u.login=?;
PARTITION PROCEDURE UserSelectWithBusinessUser ON TABLE user COLUMN login;

CREATE PROCEDURE UserSelectByTinWithBusinessUser AS
  SELECT u.system_profile_type, u.login, u.password, u.email, u.issue_date, u.issued_by, u.passport_num,
    u.status, u.reason, u.preferences, u.message_view_history_json, u.user_service_role_type,
    u.admin_permissions, u.service_man_permissions,
    bu.iin AS bu_iin, bu.tin AS bu_tin, bu.permissions AS bu_permissions,
    bu.business_profile_type AS bu_business_profile_type, bu.status AS bu_status,
    bu.reason AS bu_reason, bu.acts_on_the_basis AS bu_acts_on_the_basis,
    bu.event_id AS bu_event_id, bu.expiration_date AS bu_expiration_date,
    bu.update_date AS bu_update_date,
    el.slave AS sub_tin
  FROM business_user bu
  INNER JOIN user u ON u.login = bu.iin AND u.system_profile_type = 'BUSINESS_USER'
  LEFT JOIN enterprise_link el ON el.master = bu.tin AND el.link_type = 3
  WHERE bu.tin=? ORDER BY u.login LIMIT ?;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE DeleteAllBusinessUser AS DELETE FROM business_user WHERE iin=?;
CREATE PROCEDURE SelectBusinessUsersByIin AS SELECT * FROM business_user WHERE iin=? ORDER BY tin;
CREATE PROCEDURE UpdateBusinessUser AS UPDATE business_user SET permissions=?,business_profile_type=?,status=?,reason=?,acts_on_the_basis=?,event_id=?,expiration_date=? WHERE iin=? AND tin=?;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE SessionCountAll AS SELECT COUNT(*) FROM session;
CREATE PROCEDURE DeleteExpiredSessions AS DELETE FROM session WHERE expiration_date < ?;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE CurrencyCodeCountAll AS SELECT COUNT(*) FROM currency_code;
CREATE PROCEDURE CurrencyCodeGetAll AS SELECT * FROM currency_code WHERE symbol IS NOT NULL ORDER BY symbol;
CREATE PROCEDURE CurrencyCodeSelect AS SELECT * FROM currency_code WHERE code = ?;
CREATE PROCEDURE CurrencyCodeTruncate AS TRUNCATE TABLE currency_code;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE DeleteExpiredUserRequest AS DELETE FROM user_request WHERE expiration_date < ?;
CREATE PROCEDURE GetUserRequest AS SELECT * FROM user_request WHERE verification_key=? ORDER BY user_login;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE RetrieveChangeEnterpriseRequestsByTin AS SELECT * FROM enterprise_admin_change_request WHERE enterprise_tin = ?;
CREATE PROCEDURE RetrieveExpiredChangeEnterpriseRequests AS SELECT * FROM enterprise_admin_change_request WHERE block_date < ? AND request_status = 0;
CREATE PROCEDURE RetrieveAllEnterpriseChangeRequestsByState AS SELECT * FROM enterprise_admin_change_request WHERE request_status = ?;
CREATE PROCEDURE DeleteAllChangeEnterpriseRequests  AS DELETE FROM enterprise_admin_change_request;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE UpdateInvoiceEventForEsbClient AS UPDATE esb_client SET last_invoice_event_id=? WHERE tin=? AND client_id=?;
PARTITION PROCEDURE UpdateInvoiceEventForEsbClient ON TABLE esb_client COLUMN tin PARAMETER 1;

CREATE PROCEDURE UpdateJournalEventForEsbClient AS UPDATE esb_client SET last_journal_event_id=? WHERE tin=? AND client_id=?;
PARTITION PROCEDURE UpdateJournalEventForEsbClient ON TABLE esb_client COLUMN tin PARAMETER 1;

CREATE PROCEDURE UpdateStatusEventForEsbClient AS UPDATE esb_client SET last_status_event_id=? WHERE tin=? AND client_id=?;
PARTITION PROCEDURE UpdateStatusEventForEsbClient ON TABLE esb_client COLUMN tin PARAMETER 1;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE DeleteAllFeedback AS TRUNCATE TABLE FEEDBACK_TO_CATEGORY;
CREATE PROCEDURE GetAllFeedback AS SELECT * FROM FEEDBACK_TO_CATEGORY ORDER BY CATEGORY;
CREATE PROCEDURE GetFeedbackEmailsByCategory AS SELECT EMAILS FROM FEEDBACK_TO_CATEGORY WHERE CATEGORY=?;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE DeleteAllEnterpriseLink AS TRUNCATE TABLE enterprise_link;
CREATE PROCEDURE SelectEnterpriseLink AS SELECT * FROM enterprise_link WHERE master=? AND slave=?;
CREATE PROCEDURE SelectEnterpriseLinkBySlave AS SELECT * FROM enterprise_link WHERE slave=?;
CREATE PROCEDURE UpdateEnterpriseLink AS UPDATE enterprise_link SET link_type=? WHERE master=? AND slave=?;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE LINK_TYPE_COUNT AS SELECT count(1) FROM enterprise_link_type;
CREATE PROCEDURE DeleteAllLinkTypes AS TRUNCATE TABLE enterprise_link_type;
CREATE PROCEDURE GetAllLinkTypes AS SELECT * FROM enterprise_link_type ORDER BY link_type;
CREATE PROCEDURE SelectLinkType AS SELECT * FROM enterprise_link_type WHERE link_type=?;
CREATE PROCEDURE UpdateLinkType AS UPDATE enterprise_link_type SET create_flag=?,edit_drafts_flag=?,accept_flag=?,decline_flag=?,create_additional_flag=?,create_correct_flag=? WHERE link_type=?;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE SettlementAccountCountAll AS SELECT COUNT(*) FROM settlement_account;
CREATE PROCEDURE ReadAccounts AS SELECT * FROM settlement_account WHERE id>? ORDER BY id LIMIT ?;
CREATE PROCEDURE SettlementAccountTruncate AS TRUNCATE TABLE settlement_account;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE FIND_INVOICE_CRITERIA_FOR_USER AS SELECT * FROM invoice_search_criteria_record WHERE author = ? OR shared = 1;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE FIND_ALL_INVOICE_DRAFTS AS SELECT id, json_data FROM INVOICE_DRAFT_JSON WHERE seller_tin = ? ORDER BY id;
CREATE PROCEDURE FIND_SELECTED_INVOICE_DRAFTS AS SELECT id, json_data FROM INVOICE_DRAFT_JSON WHERE seller_tin = ? and id in ? ORDER BY id;
CREATE PROCEDURE COUNT_INVOICE_DRAFTS AS SELECT COUNT(*) FROM INVOICE_DRAFT_JSON WHERE seller_tin = ?;

---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE GET_QUEUE_BY_TIN AS SELECT json_data FROM invoice_queue WHERE tin = ? ORDER BY input_date LIMIT ? OFFSET ?;
PARTITION PROCEDURE GET_QUEUE_BY_TIN ON TABLE invoice_queue COLUMN tin;

CREATE PROCEDURE GET_QUEUE_COUNT_BY_TIN AS SELECT COUNT(*) FROM invoice_queue WHERE tin = ?;
PARTITION PROCEDURE GET_QUEUE_COUNT_BY_TIN ON TABLE invoice_queue COLUMN tin;

CREATE PROCEDURE GET_QUEUE_COUNT_ALL AS SELECT COUNT(*) FROM invoice_queue;
CREATE PROCEDURE DELETE_QUEUE_BY_ID AS DELETE FROM invoice_queue WHERE id = ?;

CREATE PROCEDURE FROM CLASS ru.uss.esf.voltdb.procedures.DeleteDraftInvoices;
CREATE PROCEDURE FROM CLASS ru.uss.esf.voltdb.procedures.InvoiceQueueInsertBatch;
CREATE PROCEDURE FROM CLASS ru.uss.esf.voltdb.procedures.ReplaceAllSettings;
