::
:: This file is included by the quickstart script file bw.bat so that it can live
:: within the svn repository.
::
set PRG=%0

saveddir=`pwd`

export QUICKSTART_HOME=$saveddir

:: Default some parameters

set BWCONFIGS=
set bwc=default
set BWCONFIG=
set offline=
set quickstart=

while [ "$1" != "" ]
do
  # Process the next arg
  case $1       # Look at $1
  in
    -bwchome)         # Define location of configs
      shift
      set BWCONFIGS="$1"
      shift
      ;;
    -quickstart)
      set quickstart="yes"
      shift
      ;;
    -usage | -help | -? | ?)
      goto usage
      ;;
    -bwc)
      set shift
      set bwc="$1"
      shift
      ;;
    -offline)
      set offline="-Dorg.bedework.offline.build=yes"
      shift
      ;;
    -*)
      goto usage
      ;;
    *)
::    Assume we've reached the target(s)
      break
      ;;
  esac
done

if "%quickstart%" != "" GOTO :checkBwConfig
  if "%BWCONFIGS%" != "" GOTO doneQB
    set BWCONFIGS=%HOME%\bwbuild
GOTO :doneQB

:checkBwConfig
  if "%BWCONFIGS" == "" GOTO QB
    echo *******************************************************
    echo Error: Cannot specify both -quickstart and -bwchome
    echo *******************************************************
    GOTO :EOF

  set BWCONFIGS=%QUICKSTART_HOME%\bedework\config\bwbuild

:doneQB

export BEDEWORK_CONFIGS_HOME=%BWCONFIGS%
export BEDEWORK_CONFIG=%BWCONFIGS%\%bwc%

if exist %BEDEWORK_CONFIG%/build.properties GOTO foundBuildProperties
  echo *******************************************************
  echo Error: Configuration %BEDEWORK_CONFIG% does not exist or is not a bedework configuration.
  echo *******************************************************
  GOTO :EOF
:foundBuildProperties

if not "%JAVA_HOME%"=="" goto javaOk
  echo *******************************************************
  echo Error: JAVA_HOME is not defined correctly for bedework.
  echo *******************************************************
  GOTO :EOF
:javaOk

:: Make available for ant
set BWCONFIG=-Dorg.bedework.user.build.properties=%BEDEWORK_CONFIG%/build.properties"

echo BWCONFIGS=%BWCONFIGS%
echo BWCONFIG=%BWCONFIG%

set ANT_HOME=`dirname "$PRG"`/apache-ant-1.7.0
set ANT_HOME=`cd "$ANT_HOME" && pwd`

set CLASSPATH=%ANT_HOME%/lib/ant-launcher.jar

%JAVA_HOME%\bin\java.exe -classpath %CLASSPATH% %offline% -Dant.home=%ANT% org.apache.tools.ant.launch.Launcher %BWCONFIG% %*%

GOTO :EOF

:usage
  echo %PRG [-bwchome path | -quickstart ] [ -bwc configname ] [ -offline } [ target ]
  echo
  echo  -bwchome specify path to configurations
  echo  -quickstart  Use the current quickstart configurations
  echo  - bwc specify configuration name
  echo  -offline  build without atempting to retrieve library jars
  echo  target  ant target to execute
  echo
  echo Invokes ant to build or deploy the bedework system. Uses a configuration
  echo directory which contains one directory per configuration.
  echo
  echo Within each configuration directory we expect a file called build.properties
  echo which should point to the proerty and options file needed for the deploy process
  echo
  echo In general these files will be in the same directory as build.properties.
  echo The environment variable BEDEWORK_CONFIG contains the path to the current
  echo configuration directory and can be used to build a path to the other files.
  echo

