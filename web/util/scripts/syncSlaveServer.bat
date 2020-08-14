SET CENTRAL_SERVER_IP=server.antim.hnrw.org
@echo off
cd c:\projects\openclinic\util
del openclinic.sql.gz
wget ftp://mxs:overmeire@%CENTRAL_SERVER_IP%/openclinic.sql.gz
del openclinic.sql
gzip.exe -d openclinic.sql.gz
net stop OpenClinicMySQL
del /F /S /Q "C:\Program Files\MySQL\MySQL Server 5.6\data\ocadmin_dbo"
del /F /S /Q "C:\Program Files\MySQL\MySQL Server 5.6\data\openclinic_dbo"
net start OpenClinicMySQL
"C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe" -u root -h localhost -P 13306 < c:\projects\openclinic\util\openclinic.sql
"C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe" -u root -h localhost -P 13306 < C:\projects\openclinic\util\restoreconfig.sql

