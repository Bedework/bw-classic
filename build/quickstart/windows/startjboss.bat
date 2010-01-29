@ECHO off
SETLOCAL

:: Script to start jboss with properties defined
:: This currently needs to be executed out of the quickstart directory
:: (via a source)

SET BASE_DIR=%CD%

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

SET RUN_CMD=.\%JBOSS_VERSION%\bin\run.bat -c %JBOSS_CONFIG% %JBOSS_BIND% %JBOSS_PORTS% %LOG_THRESHOLD% %ACTIVEMQ_DIRPREFIX% %BW_DATA_DIR_DEF%

ECHO.
ECHO Starting Bedework JBoss:
ECHO %RUN_CMD%
ECHO.
ECHO.

%RUN_CMD%
 