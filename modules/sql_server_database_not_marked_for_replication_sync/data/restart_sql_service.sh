

@echo off



REM Stop the SQL Server service

net stop ${SQL_SERVER_SERVICE_NAME}



REM Start the SQL Server service

net start ${SQL_SERVER_SERVICE_NAME}



echo SQL Server service restarted successfully.