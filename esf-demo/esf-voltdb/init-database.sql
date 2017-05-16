insert into user (system_profile_type, login, password, email, issue_date, issued_by, reason, status, user_service_role_type) values ('ADMIN', 'super_admin','b9a5860a1376753b70e92f350557dcca2b7d360a:1384353543952','','01.12.2010','', '', 0, 1);
insert into user (system_profile_type, login, password, email, issue_date, issued_by, reason, status) values ('BUSINESS_USER', '745896125463','b9a5860a1376753b70e92f350557dcca2b7d360a:1384353543952','man4j@ya.ru','01.12.2010','MINISTRY OF JUSTICE', '', 0);
insert into user (system_profile_type, login, password, email, issue_date, issued_by, reason, status) values ('BUSINESS_USER', '951735469875','b9a5860a1376753b70e92f350557dcca2b7d360a:1384353543952','man4j@ya.ru','01.12.2010','MINISTRY OF JUSTICE', '', 0);
insert into user (system_profile_type, login, password, email, issue_date, issued_by, reason, status) values ('BUSINESS_USER', '123456789011','b9a5860a1376753b70e92f350557dcca2b7d360a:1384353543952','man4j@ya.ru','01.12.2010','MINISTRY OF JUSTICE', '', 0);

insert into taxpayer(tin, name_ru, name_kz, address_ru, address_kz, certificate_series, certificate_num, resident, type, state, resource_user) values('super_admin', 'Super admin', 'Super admin', '', '', '', '', 1, 1, 0, 0);
insert into taxpayer(tin, name_ru, name_kz, first_name, last_name, middle_name, first_name_kz, last_name_kz, middle_name_kz,address_ru, address_kz, certificate_series, certificate_num, resident, type, state, resource_user) values('745896125463', 'Ivanov', '','Ivan','Ivanov','Ivanovich','','','', '010000, KZ, Astana, Mira st 1', '', '13788', '1399479', 1, 2, 1, 0);
insert into taxpayer(tin, name_ru, name_kz, FIRST_NAME, LAST_NAME, MIDDLE_NAME, FIRST_NAME_KZ, LAST_NAME_KZ, MIDDLE_NAME_KZ, address_ru, address_kz, certificate_series, certificate_num, resident, type, state, resource_user) values('951735469875', 'Wayne', '', 'Bruce', 'Wayne', 'Ibragimovich','','', '', '010000, KZ, Astana, Mira st 2', '', '13788', '1399478', 1, 2, 1, 0);
insert into taxpayer(tin, name_ru, name_kz, first_name, last_name, middle_name, first_name_kz, last_name_kz, middle_name_kz,address_ru, address_kz, certificate_series, certificate_num, resident, type, state, resource_user) values('123456789011', 'Petrov', '','Petr','Petrov','Petrovich','','','', '010000, KZ, Astana, Mira st 3', '', '13788', '1399477', 1, 2, 1, 0);
insert into taxpayer(tin, name_ru, name_kz, address_ru, address_kz, certificate_series, certificate_num, resident, type, state, resource_user, director_iin) values('753159846249', 'Bat-Car LLC', '', '010000, KZ, Astana, Mira st 1', '', '13788', '1399478', 1, 0, 0, 0,'951735469875');
insert into taxpayer(tin, name_ru, name_kz, address_ru, address_kz, certificate_series, certificate_num, resident, type, state, resource_user, director_iin) values('348951276584', 'Bat-Fly LLC', '', '010000, KZ, Astana, Mira st 2', '', '23788', '2399478', 1, 0, 0, 0,'951735469875');
insert into taxpayer(tin, name_ru, name_kz, address_ru, address_kz, certificate_series, certificate_num, resident, type, state, resource_user, director_iin) values('123456789021', 'Bat-Boat LLC', '', '010000, KZ, Astana, Mira st 3', '', '33788', '3399478', 1, 0, 0, 0,'123456789011');

insert into business_user (iin, tin, business_profile_type, permissions, reason, status, acts_on_the_basis, event_id, update_date, expiration_date) values ('951735469875', '753159846249', 'ADMIN_ENTERPRISE', '[]', '', 0, '', null, 1701770720000, 1701770721444);
insert into business_user (iin, tin, business_profile_type, permissions, reason, status, acts_on_the_basis, event_id, update_date, expiration_date) values ('123456789011', '123456789021', 'ADMIN_ENTERPRISE', '[]', '', 0, '', null, 1701770720000, 1701770721444);

insert into settlement_account(id, taxpayer_tin, bank_id, account_type, account, date_open, date_close) VALUES(2, '753159846249', '433791696918', 0, '22222222222222222222', 433791696918, null);
insert into settlement_account(id, taxpayer_tin, bank_id, account_type, account, date_open, date_close) VALUES(3, '123456789021', '433791696918', 0, '33333333333333333333', 433791696918, null);

insert into settings(key, value, description_ru, description_kz, validation_regexp) values('cacheCertificateValidationResultMillis', '60000', 'Cert cache ms', 'Cert cache ms', '^[0-9]+$ ');
insert into settings(key, value, description_ru, description_kz, validation_regexp) values('upload-dir', '/tmp', 'Update folder', 'Update folder', '^.+$ ');

insert into feedback_to_category(category, emails) values('TECHNICAL',   '["ilyas.narembayev@itesa.kz"]');
insert into feedback_to_category(category, emails) values('METHODOLOGY', '["ilyas.narembayev@itesa.kz"]');
insert into feedback_to_category(category, emails) values('IMPROVEMENT', '["ilyas.narembayev@itesa.kz"]');

insert into enterprise_link_type (link_type) values (3);
insert into enterprise_link (master, slave, link_type) values('120840010109','753159846249', 3);

INSERT INTO nsi_info(version,actuality_date) VALUES('','');

insert into taxpayer(TIN,NAME_RU,NAME_KZ,ADDRESS_RU,ADDRESS_KZ,CERTIFICATE_SERIES,CERTIFICATE_NUM,RESIDENT,TYPE,STATE,RESOURCE_USER) values('120840010109','USS LLC','USS LLC','','','13788','1399478',1,0,1,0);

insert into business_user (iin, tin, business_profile_type, permissions, reason, status, acts_on_the_basis, event_id, update_date, expiration_date) values ('951735469875', '120840010109', 'USER', '["INVOICE_CREATE_FIXED","INVOICE_CREATE_REGULAR","DRAFT_CREATE","INVOICE_REVOKE","INVOICE_VIEW","INVOICE_CREATE_ADDITIONAL"]', '', 0, '', null, 1701770720000, 1701770721444);

insert into bank(ID,ORIGINAL_NAME_RU,ORIGINAL_NAME_KZ,BIK,CODE,TIN,RNN,ACTIVE) VALUES(433791696918,'The Bank','The Bank','NBRKKZKX','190201125','941240001151','600400062088',1);

insert into currency_code(code,symbol,priority) values ('398','KZT',0);
insert into currency_code(code,symbol,priority) values ('643','RUB',0);
