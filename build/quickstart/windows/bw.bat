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
SET BWJMXCONFIG=
SET bwc=default
SET BWCONFIG=
SET offline=

SET ant_listener=
SET ant_xmllogfile=
SET ant_logger=

SET ant_loglevel="-quiet"
SET bw_loglevel=

SET mvn_quiet="-q"

SET mvn_binary="mvn3"

:: Projects we need to update - these are the svn projects - not internal variables
:: or user parameters.
SET "updateSvnProjects=bedenote"

:: Projects we will build - pkgdefault (bedework) is built if nothing specified
SET pkgdefault=yes
SET bedenote=
SET bwtools=
SET caldavTest=
SET catsvr=
SET client=
SET naming=
SET testsuite=

SET action=

SET maven=

# update from git
SET updateProjects="bw-access"
SET updateProjects="%updateProjects%  bw-caldav"
SET updateProjects="%updateProjects%  bw-calendar-client"
SET updateProjects="%updateProjects%  bw-calendar-engine"
SET updateProjects="%updateProjects%  bw-carddav"
SET updateProjects="%updateProjects%  bw-classic"
SET updateProjects="%updateProjects%  bw-event-registration"
SET updateProjects="%updateProjects%  bw-notifier"
SET updateProjects="%updateProjects%  bw-self-registration"
SET updateProjects="%updateProjects%  bw-synch"
SET updateProjects="%updateProjects%  bw-timezone-server"
SET updateProjects="%updateProjects%  bw-util"
SET updateProjects="%updateProjects%  bw-webdav"
SET updateProjects="%updateProjects%  bw-ws"

# git projects
SET bw_access=
SET bw_caldav=
SET bw_calengine=
SET bw_carddav=
SET bw_classic=
SET bw_eventreg=
SET bw_notifier=
SET bw_selfreg=
SET bw_synch=
SET bw_tzsvr=
SET bw_util=
SET bw_webclients=
SET bw_webdav=
SET bw_ws=

:: Special targets - avoiding dependencies

SET deploylog4j=
SET deployActivemq=
SET deployConf=
SET deployData=
SET deployEs=
SET dirstart=
SET saveData=

SET specialTarget=

:: check for command-line arguments and branch on them
IF "%1noargs" == "noargs" GOTO usage
GOTO branch

:bwjmxconf
  :: Define location of jmx configs
  SHIFT
  SET BWJMXCONFIG=%1
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

:: ----------------------- Special targets
:deploylog4j
  SET deploylog4j="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:deployActivemq
  SET deployActivemq="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:deployConf
  SET deployConf="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:deployData
  SET deployData="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:deployEs
  SET deployEs="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:dirstart
  SET dirstart="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:saveData
  SET saveData="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:: ----------------------- PROJECTS

:bw_access
  SET bw_access="yes"

  SET bw_ws="yes"
  SET bw_util="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:bw_caldav
  SET bw_caldav="yes"

  SET bw_access="yes"
  SET bw_ws="yes"
  SET bw_util="yes"
  SET bw_webdav="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:bw_calengine
  SET bw_calengine="yes"

  SET bw_access="yes"
  SET bw_ws="yes"
  SET bw_util="yes"
  SET bw_webdav="yes"
  SET bw_caldav="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:bw_ws
  SET bw_ws="yes"

  SET pkgdefault=
  SHIFT
  GOTO branch

:bw_util
  SET bw_util="yes"

  SET bw_ws="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:bw_webdav
  SET bw_webdav="yes"

  SET bw_access="yes"
  SET bw_util="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:notifier
  SET bw_notifier="yes"

  SET bw_access="yes"
  SET bw_ws="yes"
  SET bw_util="yes"
  SET bw_caldav="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:synch
  SET bw_synch="yes"

  SET bw_access="yes"
  SET bw_ws="yes"
  SET bw_util="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:tzsvr
  SET bw_tzsvr="yes"

  SET bw_ws="yes"
  SET bw_util="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:carddav
  SET bw_carddav="yes"

  SET bw_access="yes"
  SET bw_ws="yes"
  SET bw_util="yes"
  SET bw_webdav="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:bedenote
  SET bedenote="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:bwtools
  SET bwtools="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:bw_webclients
  SET bw_webclients="yes"

  SET bw_access="yes"
  SET bw_ws="yes"
  SET bw_caldav="yes"
  SET bw_util="yes"
  SET bw_webdav="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:caldavTest
  SET caldavTest="yes"

  SET access="yes"
  SET bw_ws="yes"
  SET rpiutil="yes"
  SET webdav="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:client
  SET client="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:eventreg
  SET bw_eventreg="yes"

  SET bw_ws="yes"
  SET bw_util="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:naming
  SET naming="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:selfreg
  SET bw_selfreg="yes"

  SET bw_util="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:testsuite
  SET testsuite="yes"
  SET pkgdefault=
  SHIFT
  GOTO branch

:updateall
  for %%p in (%updateProjects%) do (
  rem   IF EXIST "%QUICKSTART_HOME%\%%p" GOTO foundProjectToUpdate
  rem    ECHO *******************************************************
  rem    ECHO Error: Project %%p is missing. Check it out from the repository"
  rem    ECHO *******************************************************
  rem    GOTO:EOF
rem :foundProjectToUpdate

    ECHO *************************************************************
    ECHO Updating project %%p
    ECHO *************************************************************

    cd %QUICKSTART_HOME%\%%p
    git pull
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

:doneWithArgs

IF NOT "%pkgdefault%" == "yes" GOTO notdefault
  SET bw_classic="yes"

  SET bw_ws="yes"
  SET bw_util="yes"
  SET bw_access="yes"
  SET bw_webdav="yes"
  SET bw_caldav="yes"
  SET bw_calengine="yes"
  SET bw_webclients="yes"

:notdefault

SET BWCONFIGS=%QUICKSTART_HOME%\bedework\config\bwbuild

SET BWJMXCONFIG=%QUICKSTART_HOME%\bedework\config\bedework

  SET BEDEWORK_CONFIGS_HOME=%BWCONFIGS%
  SET BEDEWORK_CONFIG=%BWCONFIGS%\%bwc%
  SET BEDEWORK_JMX_CONFIG=%BWJMXCONFIG%

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
  SET BWCONFIG=-Dorg.bedework.build.properties=%BEDEWORK_CONFIG%\build.properties

  ECHO.
  ECHO     BWCONFIGS = %BWCONFIGS%
  ECHO     BWCONFIG = %BWCONFIG%

:: This below reflects the dependency ordering
:: Special targets first
  IF NOT "%dirstart%empty" == "empty" GOTO cdDirstart
  IF NOT "%deploylog4j%empty" == "empty" GOTO cdDeploylog4j
  IF NOT "%deployActivemq%empty" == "empty" GOTO cdDeployActivemq
  IF NOT "%deployConf%empty" == "empty" GOTO cdDeployConf
  IF NOT "%deployData%empty" == "empty" GOTO cdDeployData
  IF NOT "%deployEs%empty" == "empty" GOTO cdDeployEs
  IF NOT "%saveData%empty" == "empty" GOTO cdSaveData
:: Now projects
  IF NOT "%bw_ws%empty" == "empty" GOTO cdBwWs
  IF NOT "%bw_util%empty" == "empty" GOTO cdBwUtil
  IF NOT "%bw_access%empty" == "empty"  GOTO cdBwAccess
  IF NOT "%bedenote%empty" == "empty"  GOTO cdBedenote
  IF NOT "%bw_eventreg%empty" == "empty"  GOTO cdEventreg
  IF NOT "%bw_webdav%empty" == "empty"  GOTO cdWebdav
  IF NOT "%bw_caldav%empty" == "empty"  GOTO cdCaldav
  IF NOT "%caldavTest%empty" == "empty"  GOTO cdCaldavTest
  IF NOT "%carddav%empty" == "empty" GOTO cdCarddav
  IF NOT "%bw_calengine%empty" == "empty" GOTO cdBwcalengine
  IF NOT "%bwwebapps%empty" == "empty" GOTO cdBwwebapps
  IF NOT "%catsvr%empty" == "empty" GOTO cdCatsvr
  IF NOT "%bw_webclients%empty" == "empty"  GOTO cdWebclients
  IF NOT "%naming%empty" == "empty"  GOTO cdNaming
  IF NOT "%bw_synch%empty" == "empty"  GOTO cdSynch
  IF NOT "%bw_notifier%empty" == "empty"  GOTO cdNotifier
  IF NOT "%testsuite%empty" == "empty"  GOTO cdTestsuite
  IF NOT "%bwtools%empty" == "empty"  GOTO cdBwtools
  IF NOT "%bw_tzsvr%empty" == "empty"   GOTO cdTzsvr
  IF NOT "%bw_selfreg%empty" == "empty" GOTO cdSelfreg

GOTO:EOF

:doant
  ECHO     WORKING DIRECTORY = %cd%
  ECHO     COMMAND =  "%JAVA_HOME%\bin\java.exe" -Xmx512M -XX:MaxPermSize=512M -classpath %CLASSPATH% %offline% -Dant.home="%ANT_HOME%" org.apache.tools.ant.launch.Launcher "%BWCONFIG%" %ant_listener% %ant_logger% %ant_loglevel% %bw_loglevel% %1
  ECHO.
  ECHO.
  "%JAVA_HOME%\bin\java.exe" -Xmx512M -XX:MaxPermSize=512M -classpath %CLASSPATH% %offline% -Dant.home="%ANT_HOME%" org.apache.tools.ant.launch.Launcher "%BWCONFIG%" %ant_listener% %ant_logger% %ant_loglevel% %bw_loglevel% %1

  GOTO runBedework

:dospecial
  ECHO     WORKING DIRECTORY = %cd%
  ECHO     COMMAND =  "%JAVA_HOME%\bin\java.exe" -Xmx512M -XX:MaxPermSize=512M -classpath %CLASSPATH% %offline% -Dant.home="%ANT_HOME%" org.apache.tools.ant.launch.Launcher "%BWCONFIG%" %ant_listener% %ant_logger% %ant_loglevel% %bw_loglevel% %specialTarget%
  ECHO.
  ECHO.
  "%JAVA_HOME%\bin\java.exe" -Xmx512M -XX:MaxPermSize=512M -classpath %CLASSPATH% %offline% -Dant.home="%ANT_HOME%" org.apache.tools.ant.launch.Launcher "%BWCONFIG%" %ant_listener% %ant_logger% %ant_loglevel% %bw_loglevel% %specialTarget%

  GOTO runBedework

:: Special targets

:cdDirstart
  cd %QUICKSTART_HOME%
  SET dirstart=
  SET specialTarget="dirstart"
  GOTO dospecial

:cdDeploylog4j
  cd %QUICKSTART_HOME%
  SET deploylog4j=
  SET specialTarget="deploylog4j"
  GOTO dospecial

:cdDeployActivemq
  cd %QUICKSTART_HOME%
  SET deployActivemq=
  SET specialTarget="deployActivemq"
  GOTO dospecial

:cdDeployConf
  cd %QUICKSTART_HOME%
  SET deployConf=
  SET specialTarget="deployConf"
  GOTO dospecial

:cdDeployData
  cd %QUICKSTART_HOME%
  SET deployData=
  SET specialTarget="deployData"
  GOTO dospecial

:cdDeployEs
  cd %QUICKSTART_HOME%
  SET deployEs=
  SET specialTarget="deployEs"
  GOTO dospecial

:cdSaveData
  cd %QUICKSTART_HOME%
  SET saveData=
  SET specialTarget="saveData"
  GOTO dospecial

:: Projects
:cdAccess
  cd %QUICKSTART_HOME%\bw-access
  SET bw_access=
  GOTO doant

:cdBedenote
  cd %QUICKSTART_HOME%\bedenote
  SET bedenote=
  GOTO doant

:cdBedework
  cd %QUICKSTART_HOME%
  SET bedework=
  GOTO doant

:cdBwtools
  cd %QUICKSTART_HOME%\bwtools
  SET bwtools=
  GOTO doant

:cdBwwebapps
  cd %QUICKSTART_HOME%\bwwebapps
  SET bwwebapps=
  GOTO doant

:cdBwWs
  cd %QUICKSTART_HOME%\bw-ws
  SET bw_ws=
  GOTO doant

:cdCaldav
  cd %QUICKSTART_HOME%\bw-caldav
  SET bw_caldav=
  GOTO doant

:cdCaldavTest
  cd %QUICKSTART_HOME%\caldavTest
  SET caldavTest=
  GOTO doant

:cdCalengine
  cd %QUICKSTART_HOME%\bw-calendar-engine
  SET bw_calengine=
  GOTO doant

:cdCarddav
  cd %QUICKSTART_HOME%\bedework-carddav
  SET carddav=
  GOTO doant

:cdClient
  cd %QUICKSTART_HOME%\client
  SET client=
  GOTO doant

:cdEventreg
  cd %QUICKSTART_HOME%\bw-event-registration
  SET bw_eventreg=
  GOTO doant

:cdNaming
  cd %QUICKSTART_HOME%\naming
  SET naming=
  GOTO doant

:cdBwUtil
  cd %QUICKSTART_HOME%\bw-util
  SET bw_util=
  GOTO doant

:cdSelfreg
  cd %QUICKSTART_HOME%\bw-self-registration
  SET bw_selfreg=
  GOTO doant

:cdNotifier
  cd %QUICKSTART_HOME%\bw-notifier
  SET deploy="%QUICKSTART_HOME%\bw-notifier\bw-note-ear\target\bw-notify*ear"
  SET bw_notifier=
  GOTO doant

:cdSynch
  cd %QUICKSTART_HOME%\bw-synch
  SET bw_synch=
  SET deploy="%QUICKSTART_HOME%\bw-synch\bw-synch-ear\target\bw-synch*ear"
  GOTO doant

:cdTestsuite
  cd %QUICKSTART_HOME%\testsuite
  SET testsuite=
  GOTO doant

:cdTzsvr
  cd %QUICKSTART_HOME%\bw-timezone-server
  SET bw_tzsvr=
  SET deploy="%QUICKSTART_HOME%\bw-timezone-server\bw-timezone-server-ear\target\bw-timezone-server*ear"
  GOTO doant

:cdWebclients
  cd %QUICKSTART_HOME%\bw-calendar-client
  SET bw_webclients=
  GOTO doant

:cdWebdav
  cd %QUICKSTART_HOME%\bw-webdav
  SET bw_webdav=
  GOTO doant


:: Iterate over the command line arguments;
:: DOS Batch labels can't contain hyphens, so convert them
:: (otherwise, we could just "GOTO %1")
:branch
:: Special targets
IF "%1" == "deploylog4j" GOTO deploylog4j
IF "%1" == "deployActivemq" GOTO deployActivemq
IF "%1" == "deployConf" GOTO deployConf
IF "%1" == "deployData" GOTO deployData
IF "%1" == "deployEs" GOTO deployEs
IF "%1" == "dirstart" GOTO dirstart
IF "%1" == "saveData" GOTO saveData

:: projects
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

IF "%1" == "-bw_access" GOTO bw_access
IF "%1" == "-bw_caldav" GOTO bw_caldav
IF "%1" == "-bw_calengine" GOTO bw_calengine
IF "%1" == "-bwtools" GOTO bwtools
IF "%1" == "-bw_webclients" GOTO bw_webclients
IF "%1" == "-bw_ws" GOTO bw_ws
IF "%1" == "-caldav" GOTO caldav
IF "%1" == "-caldavTest" GOTO caldavTest
IF "%1" == "-carddav" GOTO carddav
IF "%1" == "-client" GOTO client
IF "%1" == "-eventreg" GOTO eventreg
IF "%1" == "-naming" GOTO naming
IF "%1" == "-bw_util" GOTO bw_util
IF "%1" == "-selfreg" GOTO selfreg
IF "%1" == "-synch" GOTO synch
IF "%1" == "-notifier" GOTO notifier
IF "%1" == "-testsuite" GOTO testsuite
IF "%1" == "-tzsvr" GOTO tzsvr
IF "%1" == "-bw_webdav" GOTO bw_webdav
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
  ECHO
  ECHO    Special targets
  ECHO      deploylog4j       deploys a log4j configuration
  ECHO      deployActivemq    deploys the Activemq config
  ECHO      deployConf        deploys the configuration files
  ECHO      deployEs          deploys the quickstart elasticsearch config
  ECHO.
  ECHO    PROJECT optionally defines the package to build and is one of
  ECHO            the core, ancillary or experimental targets below:
  ECHO.
  ECHO   Core projects: required for a functioning system
  ECHO      -bw_access    Target is for the access classes
  ECHO      -bw_calengine Target is for the bedework core api implementation
  ECHO      -bwcaldav     Target is for the bedework CalDAV implementation
  ECHO      -bw_webclients Target is for the bedework web ui classes
  ECHO      -bw_ws        Target is for the Bedework XML schemas build
  ECHO                       (usually built automatically be dependent projects
  ECHO      -caldav       Target is for the generic CalDAV server
  ECHO      -carddav      Target is for the CardDAV build
  ECHO      -carddav deploy-addrbook    To deploy the Javascript Addressbook client.
  ECHO      -eventreg     Target is for the Bedework event registration service
  ECHO      -bw_util      Target is for the Bedework util classes
  ECHO      -selfreg      Target is for the self registration build
  ECHO      -synch        Target is for the synch build
  ECHO      -notifier     Target is for the notifier build
  ECHO      -tzsvr       Target is for the timezones server build
  ECHO   Ancillary projects: not required
  ECHO      -bwtools      Target is for the Bedework tools build
  ECHO      -caldavTest   Target is for the CalDAV Test build
  ECHO      -testsuite    Target is for the bedework test suite
  ECHO   Experimental projects: no guarantees
  ECHO      -client      Target is for the bedework client application build
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
