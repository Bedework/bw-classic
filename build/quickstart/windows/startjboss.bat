@ECHO off
SETLOCAL

:: Script to start jboss with properties defined
:: This currently needs to be executed out of the quickstart directory
:: (via a source)

SET BASE_DIR=%CD%
SET PRG=%0

:: Set defaults
SET heap=1G
SET newsize=330M
SET permsize=256M

GOTO branch

:heap
  SHIFT
  SET heap=%1
  SHIFT
  GOTO branch

:newsize
  SHIFT
  SET newsize=%1
  SHIFT
  GOTO branch

:permsize
  SHIFT
  SET permsize=%1
  SHIFT
  GOTO branch

:doneWithArgs

SET JBOSS_VERSION=jboss-5.1.0.GA
SET JBOSS_CONFIG=default
SET JBOSS_SERVER_DIR=%BASE_DIR%\%JBOSS_VERSION%\server\%JBOSS_CONFIG%
SET JBOSS_DATA_DIR=%JBOSS_SERVER_DIR%\data

:: If this is empty only localhost will be available.
:: With this address anybody can access the consoles if they are not locked down.
SET JBOSS_BIND=-b 0.0.0.0

::
:: Port shifting
::

:: standard ports
SET JBOSS_PORTS=-Dorg.bedework.system.ports.offset=0

:: standard ports + defined value
::JBOSS_PORTS=-Dorg.bedework.system.ports.offset=505 -Djboss.service.binding.set=ports-syspar

SET ACTIVEMQ_DIRPREFIX=-Dorg.apache.activemq.default.directory.prefix=%JBOSS_DATA_DIR%\

SET LOG_THRESHOLD=-Djboss.server.log.threshold=DEBUG

SET BW_DATA_DIR=%JBOSS_DATA_DIR%\bedework
SET BW_DATA_DIR_DEF=-Dorg.bedework.data.dir=%BW_DATA_DIR%\

SET JAVA_OPTS=%JAVA_OPTS% -Xms%heap% -Xmx%heap%
SET JAVA_OPTS=%JAVA_OPTS% -XX:NewSize=%newsize% -XX:MaxNewSize=%newsize%
SET JAVA_OPTS=%JAVA_OPTS% -XX:PermSize=%permsize% -XX:MaxPermSize=%permsize%

SET RUN_CMD=.\%JBOSS_VERSION%\bin\run.bat -c %JBOSS_CONFIG% %JBOSS_BIND% %JBOSS_PORTS% %LOG_THRESHOLD% %ACTIVEMQ_DIRPREFIX% %BW_DATA_DIR_DEF%

ECHO.
ECHO Starting Bedework JBoss:
ECHO %RUN_CMD%
ECHO.
ECHO.

%RUN_CMD%
GOTO:EOF


:: Iterate over the command line arguments;
:: DOS Batch labels can't contain hyphens, so convert them
:: (otherwise, we could just "GOTO %1")
:branch
IF "%1" == "-usage" GOTO usage
IF "%1" == "-heap" GOTO heap
IF "%1" == "-newsize" GOTO newsize
IF "%1" == "-permsize" GOTO permsize
GOTO doneWithArgs
 
:usage
ECHO.
ECHO.
ECHO.
ECHO startjboss.bat [-heap size] [-newsize size] [-permsize size]
ECHO.
ECHO Where:
ECHO.
ECHO -heap sets the heap size and should be n for bytes
ECHO                                        nK for kilo-bytes (e.g. 256K)
ECHO                                        nM for mega-bytes (e.g. 256M)
ECHO                                        nG for giga-bytes (e.g. 1G)
ECHO.
ECHO -newsize sets the new generation size and has the same form as -heap
ECHO  the value should be around one third of the heap
ECHO.
ECHO -permsize sets the permgen size and has the same form as -heap
ECHO   The value should probably not be less than 256M
ECHO.
ECHO.
ECHO. Default settings:
ECHO. heap    = %heap%
ECHO. newsize = %newsize%
ECHO. permgen = %permsize%