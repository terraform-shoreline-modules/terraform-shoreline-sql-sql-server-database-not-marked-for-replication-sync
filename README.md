
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# SQL Server database not marked for replication sync.
---

This incident type refers to a situation where a SQL Server database is not marked for replication sync, which means it may not be synced with its backup. This can result in data loss or inconsistencies between the primary database and its backup. It is important to address this issue promptly to ensure data integrity and prevent potential downtime or data loss.

### Parameters
```shell
# Environment Variables

export SERVER_NAME="PLACEHOLDER"

export REPLICA_NAME="PLACEHOLDER"

export BACKUP_NAME="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export SQL_SERVER_SERVICE_NAME="PLACEHOLDER"

export HOST_NAME_OR_IP_ADDRESS="PLACEHOLDER"

export PORT_NUMBER="PLACEHOLDER"
```

## Debug

### Check if SQL Server service is running
```shell
Get-Service -Name MSSQLSERVER
```

### Check the replication status of a database
```shell
sqlcmd -S ${SERVER_NAME} -E -Q "SELECT name, is_published, is_subscribed, is_merge_published, is_distributor FROM sys.databases"
```

### Check if the database is sync with the backup
```shell
sqlcmd -S ${SERVER_NAME} -E -Q "SELECT [name], [is_sync_with_backup] FROM sys.databases"
```

### Check replication monitor for errors
```shell
sqlcmd -S ${SERVER_NAME} -E -Q "SELECT * FROM [distribution].[dbo].[MSrepl_errors]"
```

## Repair

### Next Step
```shell
@echo off
```

### Next Step
```shell
set DATABASE_NAME=${DATABASE_NAME}

set BACKUP_NAME=${BACKUP_NAME}

set REPLICA_NAME=${REPLICA_NAME}
```

### Next Step
```shell
:: check replication settings

sqlcmd -S ${SERVER_NAME} -d %DATABASE_NAME% -Q "exec sp_helpdb %DATABASE_NAME%" | findstr /i "%REPLICA_NAME%"
```

### Next Step
```shell
if %errorlevel% == 0 (

    echo Replication is enabled for %DATABASE_NAME%.

    goto :end

) else (

    echo Replication is not enabled for %DATABASE_NAME%. Enabling replication...

)
```

### Restart the SQL Server service to see if it resolves the issue.
```shell


@echo off



REM Stop the SQL Server service

net stop ${SQL_SERVER_SERVICE_NAME}



REM Start the SQL Server service

net start ${SQL_SERVER_SERVICE_NAME}



echo SQL Server service restarted successfully.


```

### Check the database replication settings and ensure that it is set to sync with its backup.
```shell


@echo off

set database=${DATABASE_NAME}



echo Checking replication settings for %database%...

sqlcmd -S ${SERVER_NAME} -d %database% -Q "SELECT name, is_published, is_subscribed, is_merge_published, is_distributor FROM sys.databases WHERE name='%database%';"



echo Setting replication to sync with backup...

sqlcmd -S ${SERVER_NAME} -d %database% -Q "EXEC sp_replicationdboption @dbname = '%database%', @optname = N'publish', @value = N'true';"



echo Replication settings updated successfully.


```

### Check the network connectivity and ensure that it is not blocking the replication process.
```shell


@echo off



set host=${HOST_NAME_OR_IP_ADDRESS}

set port=${PORT_NUMBER}



echo Testing network connectivity...

ping %host% -n 1 -w 1000 >nul



if errorlevel 1 (

    echo Network connectivity issue detected.

    echo Attempting to resolve issue...

    netsh advfirewall firewall add rule name="Allow SQL Server replication" dir=in action=allow protocol=TCP localport=%port%

    echo Firewall rule added to allow SQL Server replication.

) else (

    echo Network connectivity is working properly.

)



pause


```