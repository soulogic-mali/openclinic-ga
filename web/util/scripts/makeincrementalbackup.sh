echo Start: $(date)
echo Making base backup
cd /root
mysqldump -h 10.254.0.4 \
--ignore-table=ocadmin_dbo.accesslogs \
--ignore-table=ocadmin_dbo.admin \
--ignore-table=ocadmin_dbo.adminprivate \
--ignore-table=openclinic_dbo.concepts \
--ignore-table=openclinic_dbo.errors \
--ignore-table=openclinic_dbo.items \
--ignore-table=openclinic_dbo.itemshistory \
--ignore-table=openclinic_dbo.keywords \
--ignore-table=openclinic_dbo.oc_batchoperations \
--ignore-table=openclinic_dbo.oc_debets \
--ignore-table=openclinic_dbo.oc_debets_history \
--ignore-table=openclinic_dbo.oc_encounters \
--ignore-table=openclinic_dbo.oc_encounters_history \
--ignore-table=openclinic_dbo.oc_insurances \
--ignore-table=openclinic_dbo.oc_insurances_history \
--ignore-table=openclinic_dbo.oc_labels \
--ignore-table=openclinic_dbo.oc_pacs \
--ignore-table=openclinic_dbo.oc_patientcredits \
--ignore-table=openclinic_dbo.oc_patientinvoices \
--ignore-table=openclinic_dbo.oc_patientinvoices_history \
--ignore-table=openclinic_dbo.oc_productstocks_history \
--ignore-table=openclinic_dbo.oc_productstockoperations \
--ignore-table=openclinic_dbo.oc_wicket_credits \
--ignore-table=openclinic_dbo.requestedlabanalyses \
--ignore-table=openclinic_dbo.transactions \
--ignore-table=openclinic_dbo.transactionshistory \
--databases ocadmin_dbo openclinic_dbo ocstats_dbo > base.$1h.sql
echo Making incremental backup
mysqldump -h 10.254.0.4 ocadmin_dbo --tables accesslogs --where 'accesstime>date_sub(now(),interval 2 day)' > incremental.$1h.sql
mysqldump -h 10.254.0.4 ocadmin_dbo --tables admin --where 'updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 ocadmin_dbo --tables adminprivate --where 'updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --single-transaction --tables items --where 'transactionid in (select transactionid from transactions where ts>date_sub(now(),interval 2 day))' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --single-transaction --tables itemshistory --where 'transactionid in (select transactionid from transactionshistory where ts>date_sub(now(),interval 2 day))' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_batchoperations --where 'oc_batchoperation_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_debets --where 'oc_debet_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_debets_history --where 'oc_debet_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_encounters --where 'oc_encounter_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_encounters_history --where 'oc_encounter_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_insurances --where 'oc_insurance_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_insurances_history --where 'oc_insurance_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_pacs --where 'oc_pacs_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_patientcredits --where 'oc_patientcredit_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_patientinvoices --where 'oc_patientinvoice_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_patientinvoices_history --where 'oc_patientinvoice_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_productstocks_history --where 'oc_stock_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_productstockoperations --where 'oc_operation_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables oc_wicket_credits --where 'oc_wicket_credit_updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables requestedlabanalyses --where 'updatetime>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables transactions --where 'ts>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
mysqldump -h 10.254.0.4 openclinic_dbo --tables transactionshistory --where 'ts>date_sub(now(),interval 2 day)' >> incremental.$1h.sql
echo Creating incremental backup completed
echo Compressing backup files
rm -rf base.$1h.sql.gz
rm -rf incremental.$1h.sql.gz
gzip base.$1h.sql
gzip incremental.$1h.sql
echo Copying backup files to NAS
cp -rf base.$1h.sql.gz /mnt/backup/Backup\ OC/base.$1h.sql.gz
cp -rf incremental.$1h.sql.gz /mnt/backup/Backup\ OC/incremental.$1h.sql.gz
echo End: $(date)
