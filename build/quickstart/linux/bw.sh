#! /bin/sh

#
# This file is included by the bw-classic script file "bw" so that it can live
# within the repository.
#

# Make this a par
#REPO_HOME=/home/douglm/bw-git
GIT_HOME=`dirname "$PRG"`
GIT_HOME=`cd "$GIT_HOME" && pwd`

echo "+++++++++++++GIT_HOME=$GIT_HOME"

#ant_listener="-listener org.apache.tools.ant.listener.Log4jListener"
#ant_xmllogfile="-DXmlLogger.file=log.xml"
#ant_logger="-logger org.apache.tools.ant.XmlLogger"

deployableDir="$GIT_HOME/bw-classic/dist/deployable"

antHome=
jbossHome=
dsHome=
ant_listener=
ant_xmllogfile=
ant_logger=

ant_loglevel="-quiet"
bw_loglevel=""

mvn_quiet="-q"

#mvn_binary="/usr/share/maven/bin/mvn";
mvn_binary="mvn"

# Projects we need to update - these are the svn projects - not internal variables
# or user parameters.
updateSvnProjects="bedenote"

# Projects we will build - pkgdefault (bedework) is built if nothing specified
pkgdefault=yes
bedenote=
bwtools=
caldavTest=
catsvr=
client=
exchgGateway=
naming=
testsuite=

maven=

# update from git
updateProjects="bw-access"
updateProjects="$updateProjects  bw-caldav"
updateProjects="$updateProjects  bw-calendar-client"
updateProjects="$updateProjects  bw-calendar-engine"
updateProjects="$updateProjects  bw-carddav"
updateProjects="$updateProjects  bw-classic"
updateProjects="$updateProjects  bw-event-registration"
updateProjects="$updateProjects  bw-notifier"
updateProjects="$updateProjects  bw-self-registration"
updateProjects="$updateProjects  bw-synch"
updateProjects="$updateProjects  bw-timezone-server"
updateProjects="$updateProjects  bw-util"
updateProjects="$updateProjects  bw-webdav"
updateProjects="$updateProjects  bw-ws"

# git projects
bw_access=
bw_caldav=
bw_calengine=
bw_carddav=
bw_classic=
bw_eventreg=
bw_notifier=
bw_selfreg=
bw_synch=
bw_tzsvr=
bw_util=
bw_webclients=
bw_webdav=
bw_ws=

# Special targets - avoiding dependencies

cmdutil=
deploylog4j=
deployActivemq=
deployConf=
deployData=
deployEs=
dirstart=
saveData=
buildwebcache=
deploywebcache=
deployurlbuilder=

specialTarget=

dobuild=yes
deployEarsUrl=

echo ""
echo "  Bedework Calendar System"
echo "  ------------------------"
echo ""

PRG="$0"

# project directories

if [ "$1" = "-nosql" ] ; then
  shift
  bwcalcoreDir="bwcalcorenosql"
  bwcalfacadeDir="bwcalfacadenosql"
else
  bwcalcoreDir="bwcalcore"
  bwcalfacadeDir="bwcalFacade"
fi

usage() {
  echo "  $PRG ACTION"
  echo "  $PRG [OPTIONS] [PROJECT] [LOG_LEVEL] [ target ] "
  echo ""
  echo " where:"
  echo ""
  echo "   ACTION defines an action to take usually in the context of the quickstart."
  echo "    In a deployed system many of these actions are handled directly by a"
  echo "    deployed application. ACTION may be one of"
  echo "      -updateall  Does an svn update of all projects"
  echo ""
  echo "   OPTIONS is zero or more from:"
  echo "      -antHome      location of ant"
  echo "      -jbossHome    location of jboss to deploy into"
  echo "      -dsHome       location of apache directory server"
  echo "      -bwc name     optionally defines the configuration to build"
  echo "      -bwjmxconf    location of jmx configuration files"
  echo "   T                specifies the location of a directory which "
  echo "                    contains all the run-time configuration for"
  echo "                    the system."
  echo "      -offline      Build without attempting to retrieve library jars"
  echo ""
  echo "   LOG_LEVEL sets the level of logging and can be"
  echo "      -log-silent   Nearly silent"
  echo "      -log-quiet    The default"
  echo "      -log-in${earName} little more noisy"
  echo "      -log-verbose  Noisier"
  echo "      -log-configs  Some info about configurations"
  echo "      -ant-debug    Vast amounts of ant output"
  echo "      -build-debug  Some bedework build debug output"
  echo "      -mvn-quiet    the default"
  echo "      -mvn-verbose  noisier"
  echo ""
  echo "   target       Special target or Ant target to execute"
  echo ""
  echo "   Special targets"
  echo "      deploylog4j       deploys a log4j configuration"
  echo "      deployActivemq    deploys the Activemq config"
  echo "      deployConf        deploys the configuration files"
  echo "      deployEs          deploys the quickstart elasticsearch config"
  echo ""
  echo "   PROJECT optionally defines the package to build. If omitted the main"
  echo "           bedework calendar system will be built otherwise it is one of"
  echo "           the core, ancillary or experimental targets below:"
  echo ""
  echo "   Core sub-projects: required for a functioning system"
  echo "     -bw_access    Target is for the access classes"
  echo "     -bwann        Target is for the annotation classes"
  echo "     -bw_calengine Target is for the bedework calendar engine"
  echo "     -bw_webclients Target is for the bedework web ui classes"
  echo "     -bw_ws        Target is for the Bedework XML schemas build"
  echo "                        (usually built automatically be dependent projects"
  echo "     -bw_caldav    Target is for the generic CalDAV server"
  echo "     -carddav      Target is for the CardDAV build"
  echo "     -carddav deploy-addrbook    To deploy the Javascript Addressbook client."
  echo "     -eventreg     Target is for the event registration service build"
  echo "     -bw_util      Target is for the Bedework util classes"
  echo "     -notifier     Target is for the notification system build"
  echo "     -selfreg      Target is for the self registration build"
  echo "     -synch        Target is for the synch build"
  echo "     -tzsvr        Target is for the timezones server build"
  echo "     -bw_webdav    Target is for the WebDAV build"
  echo "   Ancillary projects: not required"
  echo "     -bwtools      Target is for the Bedework tools build"
  echo "     -caldavTest   Target is for the CalDAV Test build"
  echo "     -testsuite    Target is for the bedework test suite"
  echo "   Experimental projects: no guarantees"
  echo "     -catsvr       Target is for the Catsvr build"
  echo "     -client       Target is for the bedework client application build"
  echo "     -naming       Target is for the abstract naming api"
  echo ""
  echo "   Invokes ant to build or deploy the Bedework system. Uses a configuration"
  echo "   directory which contains one directory per configuration."
  echo ""
  echo "   Within each configuration directory we expect a file called build.properties"
  echo "   which should point to the property and options file needed for the deploy process"
  echo ""
  echo "   In general these files will be in the same directory as build.properties."
  echo "   The environment variable BEDEWORK_CONFIG contains the path to the current"
  echo "   configuration directory and can be used to build a path to the other files."
  echo ""
}

errorUsage() {
  echo "*******************************************************************************************"
  echo "Error: $1"
  echo "*******************************************************************************************"
  echo
  echo "Sleeping 5 seconds before displaying usage. Safe to ctrl-C."
  sleep 5
  echo ""
  usage
  exit 1
}

# $1 - target directory
# $2 - ear name without version or ".ear"
copyDeployable() {
  basedir=$1
#  echo "copyDeployable par 1 = $1"
#  echo "copyDeployable par 2 = $2"

  for dir in "$basedir"/$2*; do
    if test -d "$dir"; then
#      echo "copyDeployable dir = $dir"

      mkdir -p $deployableDir
      rm -r $deployableDir/$2*.ear
      cp -r $dir $deployableDir/$(basename $dir).ear
    fi
  done
}

# ----------------------------------------------------------------------------
# Update the projects
# ----------------------------------------------------------------------------
actionUpdateall() {
  for project in $updateProjects
  do
    if [ ! -d "$GIT_HOME/$project" ] ; then
      echo "*********************************************************************"
      echo "Project $project is missing. Check it out from the repository"
      echo "*********************************************************************"
      exit 1
    else
      echo "*********************************************************************"
      echo "Updating project $project"
      echo "*********************************************************************"
      cd $GIT_HOME/$project
      git pull
    fi
  done

  exit 0
}

# Change to the next project to build. Exit if we're done.
# The order below reflects the dependencies
setDirectory() {
    specialTarget=
    postDeploy=
    maven=
#    deploy=

#     Special targets
  if [ "$cmdutil" != "" ] ; then
    cd $QUICKSTART_HOME/bwtools
    specialTarget=cmdutil
    cmdutil=
    return
  fi

	if [ "$dirstart" != "" ] ; then
	  cd $GIT_HOME/bw-classic/build/quickstart
	  specialTarget=dirstart
      dirstart=
	  return
	fi

	if [ "$deploylog4j" != "" ] ; then
	  cd $GIT_HOME/bw-classic
	  specialTarget=deploylog4j
      deploylog4j=
	  return
	fi

	if [ "$deployActivemq" != "" ] ; then
	  cd $GIT_HOME/bw-classic
	  specialTarget=deployActivemq
      deployActivemq=
	  return
	fi

  if [ "$deployConf" != "" ] ; then
    cd $GIT_HOME/bw-classic
    specialTarget=deployConf
    deployConf=
    return
  fi

  if [ "$deployData" != "" ] ; then
    cd $GIT_HOME/bw-classic
    specialTarget=deployData
      deployData=
    return
  fi

  if [ "$deployEs" != "" ] ; then
    cd $GIT_HOME/bw-classic
    specialTarget=deployEs
    deployEs=
    return
  fi

  if [ "$saveData" != "" ] ; then
    cd $GIT_HOME/bw-classic
    specialTarget=saveData
      saveData=
    return
  fi

#     projects

    if [ "$bedenote" != "" ] ; then
      cd $GIT_HOME/bedenote
      bedenote=
      return
    fi

	if [ "$bw_ws" != "" ] ; then
      echo "Build ws"
      cd $GIT_HOME/bw-ws
      maven=yes
      bw_ws=
      return
    fi

	if [ "$bw_util" != "" ] ; then
      echo "Build util"
      cd $GIT_HOME/bw-util
      maven=yes
      bw_util=
	  return
	fi

	if [ "$bw_access" != "" ] ; then
      echo "Build access"
      cd $GIT_HOME/bw-access
      maven=yes
      bw_access=
	  return
	fi

	if [ "$bw_eventreg" != "" ] ; then
      echo "Build eventreg"
	  cd $GIT_HOME/bw-event-registration
      maven=yes
      bw_eventreg=
	  return
	fi

  if [ "$bw_webdav" != "" ] ; then
      echo "Build webdav"
      cd $GIT_HOME/bw-webdav
      maven=yes
      bw_webdav=
    return
  fi

	if [ "$bw_caldav" != "" ] ; then
      echo "Build caldav"
      cd $GIT_HOME/bw-caldav
      maven=yes
      bw_caldav=
	  return
	fi

	if [ "$caldavTest" != "" ] ; then
	  cd $GIT_HOME/caldavTest
      caldavTest=
	  return
	fi

  if [ "$bw_carddav" != "" ] ; then
      echo "Build carddav"
      cd $GIT_HOME/bw-carddav
      maven=yes
      bw_carddav=
      deploy="$GIT_HOME/bw-carddav/bw-carddav-ear/target/"
      earName=bw-carddav

      copyDeployable "$deploy" "$earName"

    return
  fi

  if [ "$bw_calengine" != "" ] ; then
      echo "Build calendar engine"
      cd $GIT_HOME/bw-calendar-engine
      maven=yes
      bw_calengine=
    return
  fi

	if [ "$bw_webclients" != "" ] ; then
      echo "Build calendar clients"
      cd $GIT_HOME/bw-calendar-client
      maven=yes
      bw_webclients=
	  return
	fi

	if [ "$catsvr" != "" ] ; then
	  cd $GIT_HOME/catsvr
      catsvr=
	  return
	fi

	if [ "$client" != "" ] ; then
	  cd $GIT_HOME/bwclient
      client=
	  return
	fi

	if [ "$bw_classic" != "" ] ; then
	  cd $GIT_HOME/bw-classic
      bw_classic=
      earName="bwcal"
	  return
	fi

	if [ "$naming" != "" ] ; then
	  cd $GIT_HOME/bwnaming
      naming=
	  return
	fi

	if [ "$exchgGateway" != "" ] ; then
	  cd $GIT_HOME/exchgGateway
      exchgGateway=
	  return
	fi

	if [ "$bw_notifier" != "" ] ; then
      echo "Build notifier"
      cd $GIT_HOME/bw-notifier
      maven=yes
      bw_notifier=
      deploy="$GIT_HOME/bw-notifier/bw-note-ear/target/"
      earName=bw-notifier

      copyDeployable "$deploy" "$earName"

	  return
	fi

	if [ "$bw_selfreg" != "" ] ; then
      echo "Build selfreg"
      earName=bw-self-registration
      cd $GIT_HOME/${earName}
      maven=yes
      bw_selfreg=
      deploy="$GIT_HOME/$earName/$earName-ear/target/"

      copyDeployable "$deploy" "$earName"

	  return
	fi

    if [ "$bw_synch" != "" ] ; then
      echo "Build synch"
      earName=bw-synch
      cd $GIT_HOME/${earName}
      maven=yes
      bw_synch=
      deploy="$GIT_HOME/$earName/$earName-ear/target/"

      copyDeployable "$deploy" "$earName"

      return
    fi

	if [ "$testsuite" != "" ] ; then
	  cd $GIT_HOME/testsuite
      testsuite=
	  return
	fi

	if [ "$bw_tzsvr" != "" ] ; then
      echo "Build tzsvr"
      cd $GIT_HOME/bw-timezone-server
      maven=yes
      bw_tzsvr=
      deploy="$GIT_HOME/bw-timezone-server/bw-timezone-server-ear/target/"
      earName=bw-timezone-server

      copyDeployable "$deploy" "$earName"

	  return
	fi

	if [ "$bwtools" != "" ] ; then
	  cd $GIT_HOME/bwtools
      bwtools=
	  return
	fi

	if [ "$earName" != "" ] ; then
	  cd $QUICKSTART_HOME
      postDeploy="$earName"
      earName=
	  return
	fi

# Nothing left to do
    echo "Finished at $(date)"
	exit 0;
}

if [ -z "$JAVA_HOME" -o ! -d "$JAVA_HOME" ] ; then
  errorUsage "JAVA_HOME is not defined correctly for bedework."
fi

version=$("$JAVA_HOME/bin/java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
#echo version "$version"
#echo "${version:0:3}"
java8plus=false
if [[ "${version:0:3}" > "1.7" ]]; then
  java8plus=true
fi

#saveddir=`pwd`
saveddir=$GIT_HOME

trap 'cd $saveddir' 0
trap "exit 2" 1 2 3 15

#export GIT_HOME=$saveddir

echo "*************** GIT_HOME=$GIT_HOME"

# Default some parameters

BWCONFIGS=
BWJMXCONFIG=
bwc=default
BWCONFIG=
offline=
deployConfig=

action=

if [ "$1" = "" ] ; then
  usage
  exit 1
fi

if [ "$1" = "?" ] ; then
  usage
  exit 1
fi

# look for actions first

if [ "$1" = "-updateall" ] ; then
  actionUpdateall
fi

# ----------------------------------------------------------------------------
#  Here we go through looking for arguments.
#
#  Look further down for where we are specifying projects to build. I've
#  not tried specifying more than one but I think it would work.
#
#  There's a hidden default project "bedework" which you get if you don't specify
#  any of the below projects. That gets turned off by each of them  with
#        pkgdefault=
#  Each also turns on it's own project build and any dependencies it has.
#  Further up in this file is where we build each project that has been turned
#  on. That processing is done in dependency order. Of course this whole process
#  fails if we ever build in a circular dependency - that's why it's important to
#  do a clean build fairly regularly. So as an example
#   -bw_webdav)
#      bw_webdav="yes"
#
#      bw_access="yes"
#      bw_ws="yes"
#      bw_util="yes"
#      pkgdefault=
#  Turns on the webdav build and also access, bw_xml and util because it depends
#  on them.
# ----------------------------------------------------------------------------

while [ "$1" != "" ]
do
  # Process the next arg
  case $1       # Look at $1
  in
    -antHome)
      shift
      antHome="$1"
      shift
      ;;
    -jbossHome)
      shift
      jbossHome="$1"
      shift
      ;;
    -dsHome)
      shift
      dsHome="$1"
      shift
      ;;
    -usage | -help | -? | ?)
      usage
      exit
      shift
      ;;
    -dc)
      shift
      deployConfig="$1"
      shift
      ;;
    -bwjmxconf)
      shift
      BWJMXCONFIG="$1"
      shift
      ;;
    -nobuild)
      dobuild="no"
      shift
      ;;
    -deployUrl)
      shift
      deployEarsUrl="$1"
      shift
      ;;
    -offline)
      offline="-Dorg.bedework.offline.build=yes"
      shift
      ;;
# ----------------------- Log level
    -mvn-quiet)
      mvn_quiet="-q"
      shift
      ;;
    -mvn-verbose)
      mvn_quiet=""
      shift
      ;;
    -log-silent)
      ant_loglevel="-quiet"
      bw_loglevel="-Dorg.bedework.build.silent=true"
      shift
      ;;
    -log-quiet)
      ant_loglevel="-quiet"
      bw_loglevel=""
      shift
      ;;
    -log-inform)
      ant_loglevel=""
      bw_loglevel="-Dorg.bedework.build.inform=true"
      shift
      ;;
    -log-verbose)
      ant_loglevel="-verbose"
      bw_loglevel="-Dorg.bedework.build.inform=true -Dorg.bedework.build.noisy=true"
      shift
      ;;
    -log-configs)
      bw_loglevel="$bw_loglevel -Dorg.bedework.build.showconfigs=true"
      shift
      ;;
    -ant-debug)
      ant_loglevel="-debug"
      shift
      ;;
    -build-debug)
      bw_loglevel="-Dorg.bedework.build.inform=true -Dorg.bedework.build.noisy=true -Dorg.bedework.build.debug=true "
      shift
      ;;
# ------------------------Special targets
    cmdutil)
    cmdutil="yes"
      pkgdefault=
      shift
      ;;
    deploylog4j)
	  deploylog4j="yes"
      pkgdefault=
      shift
      ;;
    deployActivemq)
  	  deployActivemq="yes"
      pkgdefault=
      shift
      ;;
    deployConf)
      deployConf="yes"
      pkgdefault=
      shift
      ;;
    deployData)
      deployData="yes"
      pkgdefault=
      shift
      ;;
    deployEs)
	  deployEs="yes"
      pkgdefault=
      shift
      ;;
  	dirstart)
  	  dirstart="yes"
      pkgdefault=
      shift
      ;;
    saveData)
      saveData="yes"
      pkgdefault=
      shift
      ;;
# ------------------------GIT Projects
    -bw_access)
      bw_access="yes"

      bw_ws="yes"
      bw_util="yes"
      pkgdefault=
      shift
      ;;
    -bw_caldav)
      bw_caldav="yes"

      bw_access="yes"
      bw_ws="yes"
      bw_util="yes"
      bw_webdav="yes"
      pkgdefault=
      shift
      ;;
    -bw_calengine)
      bw_calengine="yes"

      bw_access="yes"
      bw_ws="yes"
      bw_util="yes"
      bw_webdav="yes"
      bw_caldav="yes"
      pkgdefault=
      shift
      ;;
    -bw_ws)
      bw_ws="yes"
      pkgdefault=
      shift
      ;;
    -bw_util)
      bw_util="yes"

      bw_ws="yes"
      pkgdefault=
      shift
      ;;
    -bw_webdav)
      bw_webdav="yes"

      bw_access="yes"
      bw_util="yes"
      pkgdefault=
      shift
      ;;
    -notifier)
      bw_notifier="yes"

      bw_access="yes"
      bw_ws="yes"
      bw_util="yes"
      bw_caldav="yes"
      pkgdefault=
      shift
      ;;
    -synch)
      bw_synch="yes"

      bw_access="yes"
      bw_ws="yes"
      bw_util="yes"
      pkgdefault=
      shift
      ;;
    -tzsvr)
      bw_tzsvr="yes"
      bw_ws="yes"
      bw_util="yes"
      pkgdefault=
      shift
      ;;
    -carddav)
      bw_carddav="yes"

      bw_access="yes"
      bw_ws="yes"
      bw_util="yes"
      bw_webdav="yes"
      pkgdefault=
      shift
      ;;
    -bedenote)
      bedenote="yes"
      pkgdefault=
      shift
      ;;
    -bwtools)
      # Needs importing
      bwtools="yes"

      bwannotations="yes"
      bwcalfacade="yes"
      bwinterfaces="yes"
      bw_ws="yes"
      bw_util="yes"
      pkgdefault=
      shift
      ;;
    -bw_webclients)
      bw_webclients="yes"

      bw_access="yes"
      bw_ws="yes"
      bw_caldav="yes"
      bw_util="yes"
      bw_webdav="yes"
      bw_calengine="yes"
      pkgdefault=
      shift
      ;;
    -caldavTest)
      # Needs importing
      caldavTest="yes"

      bw_access="yes"
      bw_ws="yes"
      bw_util="yes"
      bw_webdav="yes"
      pkgdefault=
      shift
      ;;
    -catsvr)
      catsvr="yes"

      bw_access="yes"
      bw_ws="yes"
      bw_util="yes"
      bw_webdav="yes"
      pkgdefault=
      shift
      ;;
    -client)
      client="yes"
      pkgdefault=
      shift
      ;;
    -eventreg)
      bw_eventreg="yes"

      bw_ws="yes"
      bw_util="yes"
      pkgdefault=
      shift
      ;;
    -naming)
      naming="yes"
      pkgdefault=
      shift
      ;;
    -exchgGateway)
      exchgGateway="yes"

#      bw_access="yes"
      bw_ws="yes"
#      bw_util="yes"
      pkgdefault=
      shift
      ;;
    -selfreg)
      bw_selfreg="yes"

      bw_util="yes"
      pkgdefault=
      shift
      ;;
    -testsuite)
      testsuite="yes"

      pkgdefault="yes"
      shift
      ;;
    -*)
      usage
      exit 1
      ;;
    *)
      # Assume we've reached the target(s)
      break
      ;;
  esac
done

if [ "$pkgdefault" = "yes" ] ; then
  echo "Build default bedework project"
  bw_classic="yes"

  bw_ws="yes"
  bw_util="yes"
  bw_access="yes"
  bw_webdav="yes"
  bw_caldav="yes"
  bw_calengine="yes"
  bw_webclients="yes"
fi

if [ "x" = "x$antHome" ]; then
    antHome=$GIT_HOME/apache-ant-1.7.0
    antHome=`cd "$antHome" && pwd`
fi

if [ "x" = "x$jbossHome" ]; then
    jbossHome=$GIT_HOME/jboss-5.1.0.GA
    jbossHome=`cd "$jbossHome" && pwd`
    echo "GIT_HOME=$GIT_HOME"
    echo "jbossHome=$jbossHome"
fi

if [ "x" = "x$dsHome" ]; then
    dsHome=`dirname "$antHome"`/apacheds-1.5.3-fixed
fi

CLASSPATH=$antHome/lib/ant-launcher.jar
CLASSPATH=$CLASSPATH:$GIT_HOME/bw-classic/build/quickstart/antlib

BWCONFIGS=$GIT_HOME/bw-classic/config/bwbuild
BWJMXCONFIG=$GIT_HOME/bw-classic/config/bedework

export BEDEWORK_CONFIGS_HOME=$BWCONFIGS
export BEDEWORK_CONFIG=$BWCONFIGS/$bwc
export BEDEWORK_JMX_CONFIG=$BWJMXCONFIG
export ANT_HOME=$antHome
export JBOSS_HOME=$jbossHome
export DS_HOME=$dsHome

if [ ! -d "$BEDEWORK_CONFIGS_HOME/.platform" ] ; then
  errorUsage "Configurations directory $BEDEWORK_CONFIGS_HOME is missing directory '.platform'."
fi

if [ ! -d "$BEDEWORK_CONFIGS_HOME/.defaults" ] ; then
  errorUsage "Configurations directory $BEDEWORK_CONFIGS_HOME is missing directory '.defaults'."
fi

if [ ! -f "$BEDEWORK_CONFIG/build.properties" ] ; then
  errorUsage "Configuration $BEDEWORK_CONFIG does not exist or is not a bedework configuration."
fi

# Make available for ant
export BWCONFIG="-Dorg.bedework.build.properties=$BEDEWORK_CONFIG/build.properties"
export QUICKSTART_HOME=$GIT_HOME

echo "BWCONFIGS=$BWCONFIGS"
echo "BWCONFIG=$BWCONFIG"

export GIT_HOME

javacmd="$JAVA_HOME/bin/java -classpath $CLASSPATH"
# Build (of bwxml) blew up with permgen error
if [ "$java8plus" = "true" ] ; then
  javacmd="$javacmd -Xmx512M -XX:MaxMetaspaceSize=512m"
else
  javacmd="$javacmd -Xmx512M -XX:MaxPermSize=512M"
fi

javacmd="$javacmd $ant_xmllogfile $offline"
javacmd="$javacmd -Dant.home=$antHome org.apache.tools.ant.launch.Launcher"
javacmd="$javacmd $BWCONFIG"
javacmd="$javacmd $ant_listener $ant_logger $ant_loglevel $bw_loglevel"
javacmd="$javacmd -lib $GIT_HOME/bw-classic/build/quickstart/antlib"

#echo "par 1 = $1"

if [ "$1" = "clean" ] ; then
  mvncmd="$mvn_binary clean"
else
  mvncmd="$mvn_binary $mvn_quiet -Dmaven.test.skip=true install"
fi

echo "mvncmd = $mvncmd"

if [ "$deployConfig" = "" ] ; then
  deployConfig=./bw-classic/config/deploy.properties
fi

postDeploycmd="./bw-classic/deployment/deployer/deploy.sh --noversion --delete"

if [ "$deployEarsUrl" != "" ] ; then
  postDeploycmd="$postDeploycmd --inurl $deployEarsUrl"
fi

postDeploycmd="$postDeploycmd --props $deployConfig"

while true
do
  setDirectory


#  echo "######### postDeploy = $postDeploy"

  if [ "$specialTarget" != "" ] ; then
    echo "Execute special target $specialTarget"
    $javacmd $specialTarget
  elif [ "$maven" != "" ] ; then
    $mvncmd
  elif [ "$postDeploy" != "" ] ; then
    # Don't do this if bw-classic/dist does not exist. Probably a clean
    if [ -d "./bw-classic/dist/" ] ; then
      echo "$postDeploycmd --ear $postDeploy"
      $postDeploycmd --ear $postDeploy
    fi
  elif [ "$dobuild" = "yes" ] ; then
    $javacmd $*
  fi

#  if [ "$deploy" != "" ] ; then
#    echo "Deploying $deploy to $jbossHome/server/default/bwdeploy/"
#    cp $deploy $jbossHome/server/default/bwdeploy/
#    deploy=
#  fi
done

