use openclinic_dbo;

if if(exists (select 1 from oc_config_backup),false,true) then
insert into OC_CONFIG_BACKUP select * from OC_CONFIG;
end if;