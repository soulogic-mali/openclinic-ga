use openclinic_dbo;
delete from oc_config;
insert into oc_config select * from mysql.oc_config_backup;
delete from oc_config where oc_key='initializeSlaveCounters';
insert into oc_config(oc_key,oc_value) values('initializeSlaveCounters','1');