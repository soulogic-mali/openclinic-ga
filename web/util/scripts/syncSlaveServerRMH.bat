SET CENTRAL_SERVER_IP=10.10.86.40
@echo off
cd c:\projects\openclinic\tomcat7\webapps\openclinic\util
del openclinic.sql.gz
wget ftp://mxs:overmeire@%CENTRAL_SERVER_IP%/openclinic.sql.gz
del openclinic.sql
gzip.exe -d openclinic.sql.gz
net stop OpenClinicMySQL
del /F /S /Q "C:\projects\openclinic\mysql5\data\ocadmin_dbo"
del /F /S /Q "C:\projects\openclinic\mysql5\data\openclinic_dbo"
net start OpenClinicMySQL
"C:\projects\openclinic\mysql5\bin\mysql.exe" -u root -h localhost -P 13306 < c:\projects\openclinic\tomcat7\webapps\openclinic\util\openclinic.sql
"C:\projects\openclinic\mysql5\bin\mysql.exe" -u root -h localhost -P 13306 < C:\projects\openclinic\tomcat7\webapps\openclinic\util\restoreconfig.sql

