

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