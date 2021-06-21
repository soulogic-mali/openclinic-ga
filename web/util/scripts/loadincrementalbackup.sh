echo Start: $(date)
echo Decompressing backup files
gunzip base.$1h.sql.gz
gunzip incremental.$1h.sql.gz
echo Loading base backup
cd /root
mysql < base.$1h.sql
echo Loading incremental backup
mysql incremental < incremental.$1h.sql
echo Merging base backup with incremental backup
mysql incremental < merge.sql
echo Loading backup completed
echo End: $(date)
