@echo off
:: Run the bedework dump/restore program
:: First arg defines the action, dump, restore etc
:: Second arg should be the filename

:: JAVA_HOME needs to be defined

if not "%JAVA_HOME%"=="" goto noJavaWarn
::
::
:: ***************************************************************************
::          Warning: JAVA_HOME is not set - results unpredictable
:: ***************************************************************************
::
::
:noJavaWarn

SET cp=@CP@

SET DUMPCMD=%JAVA_HOME%/bin/java -cp %cp% @DUMP-CLASS@
SET RESTORECMD=%JAVA_HOME%/bin/java -cp %cp% @RESTORE-CLASS@
SET SCHEMACMD=%JAVA_HOME%/bin/java -cp %cp% org.hibernate.tool.hbm2ddl.SchemaExport

SET APPNAME=@BW-APP-NAME@

:branch
  if "%1" == "dump" GOTO dump
  if "%1" == "restore" GOTO restore
  if "%1" == "restore-for-quickstart" GOTO restore-for-quickstart
  if "%1" == "backup" GOTO backup
  if "%1" == "initdb" GOTO initdb
  if "%1" == "schema" GOTO schema
  if "%1" == "schema-export" GOTO schema-export

:usage
  ECHO    ----------------------------------------
  ECHO    Usage: %0 dump {filename}
  ECHO               restore {filename}
  ECHO               backup {directory} {prefix}
  ECHO               initdb
  ECHO               schema
  ECHO               schema-export
  GOTO end


:dump
  ECHO Dumping data:
  ECHO %DUMPCMD% -appname %APPNAME% -f %2 %3 %4 %5 %6 %7 %8 %9
  %DUMPCMD% -appname %APPNAME% -f %2 %3 %4 %5 %6 %7 %8 %9
  GOTO end
  ::
:restore
  ECHO Restoring data:
  ECHO %RESTORECMD% -appname %APPNAME% -f %2 %3 %4 %5 %6 %7 %8 %9
  %RESTORECMD% -appname %APPNAME% -f %2 %3 %4 %5 %6 %7 %8 %9
  GOTO end
  ::
:restore-for-quickstart
  ECHO Restoring data for quickstart:
  ECHO %RESTORECMD% -appname %APPNAME% -onlyusers "public-user,caladmin,douglm,agrp_*" -f %2 %3 %4 %5 %6 %7 %8 %9
  %RESTORECMD% -appname %APPNAME% -onlyusers "public-user,caladmin,douglm,agrp_*" -f %2 %3 %4 %5 %6 %7 %8 %9
  GOTO end
  ::
:backup
  ECHO Backing up data:
  ECHO $"The backup target is not currently configured."
  :: TARGET=$2/$3`date +%Y%m%d_%H%M%S`.ldif
  :: %DUMPCMD% -appname %APPNAME% -f $TARGET
  :: %DUMPCMD% -appname %APPNAME% -f $TARGET
  GOTO end
  ::
:initdb
  ECHO Initializing the database:
  ECHO %RESTORECMD% -appname %APPNAME% -f ./data/initbedework.xml -initSyspars
  %RESTORECMD% -appname %APPNAME% -f ./data/initbedework.xml -initSyspars
  GOTO end
  ::
:schema
  ECHO Creating the schema:
  ECHO %SCHEMACMD% --text --create --config=./classes/hibernate.cfg.xml --output=schema.sql
  %SCHEMACMD% --text --create --config=./classes/hibernate.cfg.xml --output=schema.sql
  GOTO end
  ::
:schema-export
  ECHO Exporting the schema:
  ECHO %SCHEMACMD% --create --config=./classes/hibernate.cfg.xml --output=schema.sql
  %SCHEMACMD% --create --config=./classes/hibernate.cfg.xml --output=schema.sql
  GOTO end
  ::

:end
