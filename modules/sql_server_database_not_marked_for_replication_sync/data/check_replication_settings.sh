:: check replication settings

sqlcmd -S ${SERVER_NAME} -d %DATABASE_NAME% -Q "exec sp_helpdb %DATABASE_NAME%" | findstr /i "%REPLICA_NAME%"