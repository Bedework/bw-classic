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

:: Default some parameters
SET BWCONFIGS=
SET bwc=default
SET BWCONFIG=
SET offline=
SET quickstart=

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

:doneWithArgs

IF NOT "%quickstart%empty" == "empty" GOTO checkBwConfig
IF NOT "%BWCONFIGS%empty" == "empty" GOTO DoneQB
SET BWCONFIGS=%HOMEPATH%\bwbuild
GOTO doneQB

:checkBwConfig
REM  IF "%BWCONFIGS%empty" == "empty" GOTO doneQB
REM    ECHO *******************************************************
REM    ECHO Error: Cannot specify both -quickstart and -bwchome
REM    ECHO *******************************************************
REM    GOTO:EOF

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

  SET ANT_HOME=%QUICKSTART_HOME%\apache-ant-1.7.0

  SET CLASSPATH="%ANT_HOME%\lib\ant-launcher.jar"

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
  ECHO      -zoneinfo - builds zoneinfo data for the timezones server
  ECHO                  requires -version and -tzdata parameters
  ECHO.
  ECHO.
  ECHO.
