::  This file is included by the quickstart script file "..\..\bw.bat" so that
::  we may keep this script under version control in the svn repository.

@ECHO off
SETLOCAL

ECHO.
ECHO.
ECHO   Bedework Calendar System
ECHO   ------------------------
ECHO.


SET PRG=%0
SET saveddir=%CD%
SET QUICKSTART_HOME=%saveddir%

SET ANT_HOME=%QUICKSTART_HOME%\apache-ant-1.7.0

SET CLASSPATH="%ANT_HOME%\lib\ant-launcher.jar"
SET CLASSPATH=%CLASSPATH%;"%QUICKSTART_HOME%\bedework\build\quickstart\antlib"
:: SET CLASSPATH=%CLASSPATH%;"%QUICKSTART_HOME%\bedework\applib\log4j-1.2.8.jar"

:: Default some parameters
SET BWCONFIGS=
SET bwc=default
SET BWCONFIG=
SET offline=
SET quickstart=

:: Projects we will build
SET pkgdefault=yes
SET bedework=
SET carddav=
SET caldav=
SET client=
SET monitor=
SET naming=
SET tzsvr=
SET webdav=

SET action=

:: check for command-line arguments and branch on them
IF "%1noargs" == "noargs" GOTO usage
GOTO branch

:quickstart
  ECHO     Preparing quickstart build ...
  SET quickstart="yes"
  SHIFT
  GOTO branch

:bwchome
  :: Define location of configs
  SHIFT
  SET BWCONFIGS=%1
  SHIFT
  GOTO branch

:bwc
  SHIFT
  SET bwc=%1
  SHIFT
  GOTO branch

:offline
  ECHO     Setting to offline mode; libraries will not be downloaded ...
  SET offline="-Dorg.bedework.offline.build=yes"
  SHIFT
  GOTO branch
  

:: PROJECTS

:carddav
  SET carddav="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch
  
:caldav
  SET caldav="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch
  
:client
  SET client="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch
  
:webdav
  SET webdav="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch
  
:monitor
  SET monitor="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:naming
  SET naming="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch
  
:tzsvr
  SET tzsvr="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:reindex
  ECHO     Calling the reindexer
  SET INDEXER=%QUICKSTART_HOME%\bedework\dist\temp\shellscr\indexer

  if exist %INDEXER% goto indexerok
    ECHO The indexer directory %INDEXER% does not exist. You probably need to do a rebuild.
    GOTO:EOF

  :indexerok
  cd %INDEXER%
  bwrun.bat reindex-nostart -user admin -indexlocprefix ..\..\..\..\..\

  GOTO:EOF

:zoneinfo
   ECHO    zoneinfo target is not supported on Windows
   GOTO:EOF
   
:jbossNotice 
  ECHO *************************************************************
  ECHO The jboss configuration has been removed from the quickstart.
  ECHO It is now the default.  Remove the '-bwc jboss' option.
  ECHO *************************************************************
  GOTO:EOF

:doneWithArgs

IF "%bwc%" == "jboss" GOTO jbossNotice

IF NOT "%quickstart%empty" == "empty" GOTO checkBwConfig
IF NOT "%BWCONFIGS%empty" == "empty" GOTO DoneQB
SET BWCONFIGS=%HOMEPATH%\bwbuild
GOTO doneQB

:checkBwConfig

  SET BWCONFIGS=%QUICKSTART_HOME%\bedework\config\bwbuild

:doneQB
  SET BEDEWORK_CONFIGS_HOME=%BWCONFIGS%
  SET BEDEWORK_CONFIG=%BWCONFIGS%\%bwc%

  IF EXIST "%BEDEWORK_CONFIG%\build.properties" GOTO foundBuildProperties
  ECHO *******************************************************
  ECHO Error: Configuration %BEDEWORK_CONFIG%
  ECHO does not exist or is not a Bedework configuration.
  ECHO *******************************************************
  GOTO:EOF
:foundBuildProperties

  IF NOT "%JAVA_HOME%empty"=="empty" GOTO javaOk
  ECHO *******************************************************
  ECHO Error: JAVA_HOME is not defined correctly for Bedework.
  ECHO *******************************************************
  GOTO:EOF
:javaOk

:runBedework
  :: Make available for ant
  SET BWCONFIG=-Dorg.bedework.user.build.properties=%BEDEWORK_CONFIG%\build.properties

  ECHO.
  ECHO     BWCONFIGS = %BWCONFIGS%
  ECHO     BWCONFIG = %BWCONFIG%
  ECHO.

  IF NOT "%caldav%empty" == "empty"  cd %QUICKSTART_HOME%\bedework\projects\caldav
  IF NOT "%carddav%empty" == "empty" cd %QUICKSTART_HOME%\bedework-carddav
  IF NOT "%client%empty" == "empty"  cd %QUICKSTART_HOME%\bwclient
  IF NOT "%monitor%empty" == "empty" cd %QUICKSTART_HOME%\MonitorApp
  IF NOT "%naming%empty" == "empty"  cd %QUICKSTART_HOME%\bwnaming
  IF NOT "%tzsvr%empty" == "empty"   cd %QUICKSTART_HOME%\bwtzsvr
  IF NOT "%webdav%empty" == "empty"  cd %QUICKSTART_HOME%\bedework\projects\webdav

  "%JAVA_HOME%\bin\java.exe" -classpath %CLASSPATH% %offline% -Dant.home="%ANT_HOME%" org.apache.tools.ant.launch.Launcher "%BWCONFIG%" %1

  GOTO:EOF


:: Iterate over the command line arguments;
:: DOS Batch labels can't contain hyphens, so convert them
:: (otherwise, we could just "GOTO %1")
:branch
IF "%1" == "-quickstart" GOTO quickstart
IF "%1" == "-bwchome" GOTO bwchome
IF "%1" == "-bwc" GOTO bwc
IF "%1" == "-offline" GOTO offline
IF "%1" == "-reindex" GOTO reindex
IF "%1" == "-zoneinfo" GOTO zoneinfo
IF "%1" == "-carddav" GOTO carddav 
IF "%1" == "-caldav" GOTO caldav
IF "%1" == "-client" GOTO client
IF "%1" == "-webdav" GOTO webdav
IF "%1" == "-monitor" GOTO monitor
IF "%1" == "-naming" GOTO naming
IF "%1" == "-tzsvr" GOTO tzsvr
GOTO doneWithArgs

:usage
  ECHO    Usage:
  ECHO.
  ECHO    bw [CONFIG-SOURCE] [CONFIG] [PROJECT] [ -offline ] [ target ]
  ECHO    bw ACTION
  ECHO.
  ECHO    Where:
  ECHO.
  ECHO    CONFIG-SOURCE optionally defines the location of configurations and is one or none of
  ECHO     -quickstart      to use the configurations within the quickstart
  ECHO                      e.g. "bw -quickstart start"
  ECHO     -bwchome path    to specify the location of the bwbuild directory
  ECHO.
  ECHO     The default is to look in the user home for the "bwbuild" directory.
  ECHO.
  ECHO    CONFIG optionally defines the configuration to build
  ECHO      -bwc configname      e.g. "-bwc mysql"
  ECHO.
  ECHO    -offline     Build without attempting to retrieve library jars
  ECHO    target       Ant target to execute (e.g. "start")
  ECHO.
  ECHO.
  ECHO.
  ECHO    PROJECT optionally defines the package to build and is none or more of
  ECHO     -carddav     Target is for the CardDAV build
  ECHO     -monitor     Target is for the bedework monitor application
  ECHO     -naming      Target is for the abstract naming api
  ECHO     The default is a calendar build
  ECHO.
  ECHO    Invokes ant to build or deploy the Bedework system. Uses a configuration
  ECHO    directory which contains one directory per configuration.
  ECHO.
  ECHO    Within each configuration directory we expect a file called
  ECHO    build.properties which should point to the property and options file
  ECHO    needed for the deploy process.
  ECHO.
  ECHO    In general these files will be in the same directory as build.properties.
  ECHO    The environment variable BEDEWORK_CONFIG contains the path to the current
  ECHO    configuration directory and can be used to build a path to the other files.
  ECHO.
  ECHO   ACTION defines an action to take usually in the context of the quickstart.
  ECHO    In a deployed system many of these actions are handled directly by a
  ECHO    deployed application. ACTION may be one of
  ECHO      -reindex - runs the indexer directly out of the quickstart bedework
  ECHO                 dist directory to rebuild the lucene indexes
REM   Don't support zoneinfo command on Windows for now
REM   ECHO      -zoneinfo - builds zoneinfo data for the timezones server
REM   ECHO                  requires -version and -tzdata parameters
  ECHO.
  ECHO.
  ECHO.
