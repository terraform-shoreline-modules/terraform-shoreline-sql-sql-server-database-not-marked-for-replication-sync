if %errorlevel% == 0 (

    echo Replication is enabled for %DATABASE_NAME%.

    goto :end

) else (

    echo Replication is not enabled for %DATABASE_NAME%. Enabling replication...

)