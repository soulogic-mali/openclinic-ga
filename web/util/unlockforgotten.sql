use openclinic_dbo;
update oc_maintenanceoperations,oc_maintenanceplans,oc_assets set oc_maintenanceoperation_lockedby=-1
where oc_maintenanceplan_objectid=replace(oc_maintenanceoperation_maintenanceplanuid,'1.','') and
oc_asset_objectid=replace(oc_maintenanceplan_assetuid,'1.','') and
oc_asset_lockedby>-1 and
oc_asset_lockeddate is not null and
datediff(now(),oc_asset_lockeddate)>30;
update oc_maintenanceplans,oc_assets set oc_maintenanceplan_lockedby=-1
where
oc_asset_objectid=replace(oc_maintenanceplan_assetuid,'1.','') and
oc_asset_lockedby>-1 and
oc_asset_lockeddate is not null and
datediff(now(),oc_asset_lockeddate)>30;
update oc_assets set oc_asset_lockedby=-1,oc_asset_lockeddate=null
where
oc_asset_lockedby>-1 and
oc_asset_lockeddate is not null and
datediff(now(),oc_asset_lockeddate)>30;
delete from oc_assets where (oc_asset_nomenclature is null or oc_asset_nomenclature='') and oc_asset_description='';
