

@echo off

set database=${DATABASE_NAME}



echo Checking replication settings for %database%...

sqlcmd -S ${SERVER_NAME} -d %database% -Q "SELECT name, is_published, is_subscribed, is_merge_published, is_distributor FROM sys.databases WHERE name='%database%';"



echo Setting replication to sync with backup...

sqlcmd -S ${SERVER_NAME} -d %database% -Q "EXEC sp_replicationdboption @dbname = '%database%', @optname = N'publish', @value = N'true';"



echo Replication settings updated successfully.