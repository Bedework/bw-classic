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

:: Default some parameters
SET BWCONFIGS=
SET bwc=default
SET BWCONFIG=
SET offline=
SET quickstart=

SET ant_listener=
SET ant_xmllogfile=
SET ant_logger=

SET ant_loglevel="-quiet"
SET bw_loglevel=

:: Projects we need to update
SET updateProjects="bwxml bedework bedework-carddav bwtzsvr cachedfeeder"

:: Projects we will build
SET pkgdefault=yes
SET bedework=
SET bwxml=
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
  

:: ----------------------- Log level       

:log-silent
  SET ant_loglevel="-quiet"
  SET bw_loglevel="-Dorg.bedework.build.silent=true"
  SHIFT
  GOTO branch

:log-quiet
  SET ant_loglevel="-quiet"
  SET bw_loglevel=""
  SHIFT
  GOTO branch

:log-inform
  SET ant_loglevel=""
  SET bw_loglevel="-Dorg.bedework.build.inform=true"
  SHIFT
  GOTO branch

:log-verbose
  SET ant_loglevel="-verbose"
  SET bw_loglevel="-Dorg.bedework.build.inform=true -Dorg.bedework.build.noisy=true"
  SHIFT
  GOTO branch

:ant-debug
  SET ant_loglevel="-debug"
  SHIFT
  GOTO branch

:build-debug
  SET bw_loglevel="-Dorg.bedework.build.inform=true -Dorg.bedework.build.noisy=true -Dorg.bedework.build.debug=true "
  SHIFT
  GOTO branch
      
:: ----------------------- PROJECTS

:bwxml
  SET bwxml="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch
  
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

:updateall
  for %%p in ("%updateProjects%") do (
    ECHO *************************************************************
    ECHO Updating project %%p
    ECHO *************************************************************
    
    svn update %%p
  )

  GOTO:EOF
  
:zoneinfo
   ECHO    zoneinfo target is not supported on Windows
   GOTO:EOF
   
:buildwebcache
   cd %QUICKSTART_HOME%\cachedfeeder
   buildWebCache.bat
   GOTO:EOF

:deploywebcache
  cd %QUICKSTART_HOME%\cachedfeeder
  "%JAVA_HOME%\bin\java.exe" -classpath %CLASSPATH% -Dant.home="%ANT_HOME%" org.apache.tools.ant.launch.Launcher "%BWCONFIG%" deploy-webcache
   GOTO:EOF
   
:deployurlbuilder
  cd %QUICKSTART_HOME%\cachedfeeder
  "%JAVA_HOME%\bin\java.exe" -classpath %CLASSPATH% -Dant.home="%ANT_HOME%" org.apache.tools.ant.launch.Launcher "%BWCONFIG%" deploy-urlbuilder
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

  IF EXIST "%BEDEWORK_CONFIGS_HOME%\.platform" GOTO foundDotPlatform
  ECHO *******************************************************
  ECHO Error: Configurations directory %BEDEWORK_CONFIGS_HOME%
  ECHO is missing directory '.platform'.
  ECHO *******************************************************
  GOTO:EOF
:foundDotPlatform

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

  IF NOT "%bwxml%empty" == "empty"  cd %QUICKSTART_HOME%\bwxml
  IF NOT "%caldav%empty" == "empty"  cd %QUICKSTART_HOME%\bedework\projects\caldav
  IF NOT "%carddav%empty" == "empty" cd %QUICKSTART_HOME%\bedework-carddav
  IF NOT "%client%empty" == "empty"  cd %QUICKSTART_HOME%\bwclient
  IF NOT "%monitor%empty" == "empty" cd %QUICKSTART_HOME%\MonitorApp
  IF NOT "%naming%empty" == "empty"  cd %QUICKSTART_HOME%\bwnaming
  IF NOT "%tzsvr%empty" == "empty"   cd %QUICKSTART_HOME%\bwtzsvr
  IF NOT "%webdav%empty" == "empty"  cd %QUICKSTART_HOME%\bedework\projects\webdav

  ECHO     WORKING DIRECTORY = %cd%
  ECHO     COMMAND =  "%JAVA_HOME%\bin\java.exe" -classpath %CLASSPATH% %offline% -Dant.home="%ANT_HOME%" org.apache.tools.ant.launch.Launcher "%BWCONFIG%" %ant_listener% %ant_logger% %ant_loglevel% %bw_loglevel% %1
  ECHO.
  ECHO.
  "%JAVA_HOME%\bin\java.exe" -classpath %CLASSPATH% %offline% -Dant.home="%ANT_HOME%" org.apache.tools.ant.launch.Launcher "%BWCONFIG%" %ant_listener% %ant_logger% %ant_loglevel% %bw_loglevel% %1

  GOTO:EOF


:: Iterate over the command line arguments;
:: DOS Batch labels can't contain hyphens, so convert them
:: (otherwise, we could just "GOTO %1")
:branch
IF "%1" == "-quickstart" GOTO quickstart
IF "%1" == "-bwchome" GOTO bwchome
IF "%1" == "-bwc" GOTO bwc
IF "%1" == "-offline" GOTO offline
IF "%1" == "-updateall" GOTO updateall
IF "%1" == "-zoneinfo" GOTO zoneinfo
IF "%1" == "-buildwebcache" GOTO buildwebcache
IF "%1" == "-deploywebcache" GOTO deploywebcache
IF "%1" == "-deployurlbuilder" GOTO deployurlbuilder

IF "%1" == "-log-silent" GOTO log-silent
IF "%1" == "-log-quiet" GOTO log-quiet
IF "%1" == "-log-inform" GOTO log-inform
IF "%1" == "-log-verbose" GOTO log-verbose
IF "%1" == "-ant-debug" GOTO ant-debug
IF "%1" == "-build-debug" GOTO build-debug

IF "%1" == "-bwxml" GOTO bwxml 
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
  ECHO    bw ACTION
  ECHO    bw [CONFIG-SOURCE] [CONFIG] [PROJECT] [ -offline ] [ target ]
  ECHO.
  ECHO    Where:
  ECHO.
  ECHO   ACTION defines an action to take usually in the context of the quickstart.
  ECHO    In a deployed system many of these actions are handled directly by a
  ECHO    deployed application. ACTION may be one of
  ECHO      -updateall  Does an svn update of all projects"
REM   Don't support zoneinfo command on Windows for now
REM   ECHO      -zoneinfo - builds zoneinfo data for the timezones server
REM   ECHO                  requires -version and -tzdata parameters
  ECHO      -buildwebcache    builds webcache
  ECHO      -deploywebcache   deploys webcache 
  ECHO      -deployurlbuilder deploys url/widget builder
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
  ECHO    PROJECT optionally defines the package to build and is one of
  ECHO            the core, ancillary or experimental targets below:
  ECHO.
  ECHO   Core projects: required for a functioning system
  ECHO      -bwxml       Target is for the Bedework XML schemas build
  ECHO                       (usually built automatically be dependent projects
  ECHO      -carddav     Target is for the CardDAV build
  ECHO      -carddav deploy-addrbook    To deploy the Javascript Addressbook client.
  ECHO      -tzsvr       Target is for the timezones server build
  ECHO   Ancillary projects: not required
  ECHO      -monitor     Target is for the bedework monitor application
  ECHO   Experimental projects: no guarantees
  ECHO      -client      Target is for the bedework client application build
  ECHO      -exsynch     Target is for the Exchange synch build
  ECHO      -naming      Target is for the abstract naming api
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
  ECHO.
  ECHO.
