#! /bin/sh

#
# This file is included by the quickstart script file "bw" so that it can live
# within the svn repository.
#

ANT_HOME=`dirname "$PRG"`/apache-ant-1.7.0
ANT_HOME=`cd "$ANT_HOME" && pwd`

#ant_listener="-listener org.apache.tools.ant.listener.Log4jListener"
#ant_xmllogfile="-DXmlLogger.file=log.xml"
#ant_logger="-logger org.apache.tools.ant.XmlLogger"

ant_listener=
ant_xmllogfile=
ant_logger=

ant_loglevel="-quiet"
bw_loglevel=""

# Projects we need to update - these are the svn projects - not internal variables
# or user parameters.
updateProjects="access"
updateProjects="$updateProjects  bedenote"
updateProjects="$updateProjects  bedework"
updateProjects="$updateProjects  bedework-carddav"
updateProjects="$updateProjects  bwannotations"
updateProjects="$updateProjects  bwcalcore"
updateProjects="$updateProjects  bwcaldav"
updateProjects="$updateProjects  bwcalFacade"
updateProjects="$updateProjects  bwdeployutil"
updateProjects="$updateProjects  bwical"
updateProjects="$updateProjects  bwinterfaces"
updateProjects="$updateProjects  bwsysevents"
updateProjects="$updateProjects  bwtzsvr"
updateProjects="$updateProjects  bwwebapps"
updateProjects="$updateProjects  bwxml"
updateProjects="$updateProjects  cachedfeeder"
updateProjects="$updateProjects  caldav"
updateProjects="$updateProjects  dumprestore"
updateProjects="$updateProjects  eventreg"
# updateProjects="$updateProjects  geronimo-hib"
# updateProjects="$updateProjects  genkeys"
updateProjects="$updateProjects  indexer"
updateProjects="$updateProjects  rpiutil"
updateProjects="$updateProjects  selfreg"
updateProjects="$updateProjects  synch"
updateProjects="$updateProjects  webdav"

# Projects we will build - pkgdefault (bedework) is built if nothing specified
pkgdefault=yes
access=
bedenote=
bedework=
bwannotations=
bwcalcore=
bwcaldav=
bwcalfacade=
bwdeployutil=
bwicalendar=
bwinterfaces=
bwsysevents=
bwtools=
bwwebapps=
bwxml=
caldav=
caldavTest=
carddav=
catsvr=
client=
dumprestore=
eventreg=
exchgGateway=
genkeys=
geronimoHib=
indexer=
monitor=
naming=
rpiutil=
selfreg=
synch=
testsuite=
tzsvr=
webdav=

# Special targets - avoiding dependencies

cmdutil=
deploylog4j=
deployActivemq=
deployConf=
deployData=
deploySolr=
deployEs=
dirstart=
saveData=

specialTarget=

echo ""
echo "  Bedework Calendar System"
echo "  ------------------------"
echo ""

PRG="$0"

usage() {
  echo "  $PRG ACTION"
  echo "  $PRG [CONFIG-SOURCE] [CONFIG] [PROJECT] [ -offline ] [LOG_LEVEL] [ target ] "
  echo ""
  echo " where:"
  echo ""
  echo "   ACTION defines an action to take usually in the context of the quickstart."
  echo "    In a deployed system many of these actions are handled directly by a"
  echo "    deployed application. ACTION may be one of"
  echo "      -updateall  Does an svn update of all projects"
  echo "      -zoneinfo   builds zoneinfo data for the timezones server"
  echo "                  requires -version and -tzdata parameters.   "
  echo "                  NOTE: build depends on glib2 and only works on Linux/Unix"
  echo "      -buildwebcache     builds webcache"
  echo "      -deploywebcache    deploys webcache"
  echo "      -deployurlbuilder  deploys url/widget builder"
  echo ""
  echo "   CONFIG-SOURCE optionally defines the location of configurations and"
  echo "                 is one or none of  "
  echo "     -quickstart    to use the configurations within the quickstart"
  echo "     -bwchome path  to specify the location of the bwbuild directory"
  echo "   The default is to look in the user home for the bwbuild directory."
  echo ""
  echo "   CONFIG optionally defines the configuration to build"
  echo "      -bwc configname"
  echo "      -bwjmxconf location of jmx configuration files"
  echo "   The -bwjmxconf parameter specifies the location of a "
  echo "   directory which contains all the run-time configuration for"
  echo "   the system."
  echo ""
  echo "   -offline     Build without attempting to retrieve library jars"
  echo ""
  echo "   LOG_LEVEL sets the level of logging and can be"
  echo "      -log-silent   Nearly silent"
  echo "      -log-quiet    The default"
  echo "      -log-inform   A little more noisy"
  echo "      -log-verbose  Noisier"
  echo "      -log-configs  Some info about configurations"
  echo "      -ant-debug    Vast amounts of ant output"
  echo "      -build-debug  Some bedework build debug output"
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
  echo "     -access       Target is for the access classes"
  echo "     -bwann        Target is for the annotation classes"
  echo "     -bwcalcore    Target is for the bedework core api implementation"
  echo "     -bwcaldav     Target is for the bedework CalDAV implementation"
  echo "     -bwcalfacade  Target is for the bedework api interface classes"
  echo "     -bwicalendar  Target is for the bedework icalendar classes"
  echo "     -bwinterfaces Target is for the bedework service and api interfaces"
  echo "     -bwsysevents  Target is for the system JMS event classes"
  echo "     -bwwebapps    Target is for the bedework web ui classes"
  echo "     -bwxml        Target is for the Bedework XML schemas build"
  echo "                        (usually built automatically be dependent projects"
  echo "     -caldav       Target is for the generic CalDAV server"
  echo "     -carddav      Target is for the CardDAV build"
  echo "     -carddav deploy-addrbook    To deploy the Javascript Addressbook client."
  echo "     -dumprestore  Target is for the Bedework dump/restore service"
  echo "     -eventreg     Target is for the event registration service build"
  echo "     -genkeys      Target is for the genkeys module build"
  echo "     -indexer      Target is for the Bedework indexer service"
  echo "     -rpiutil      Target is for the Bedework util classes"
  echo "     -selfreg      Target is for the self registration build"
  echo "     -synch        Target is for the synch build"
  echo "     -tzsvr        Target is for the timezones server build"
  echo "     -webdav       Target is for the WebDAV build"
  echo "   Ancillary projects: not required"
  echo "     -bwtools      Target is for the Bedework tools build"
  echo "     -caldavTest   Target is for the CalDAV Test build"
  echo "     -deployutil   Target is for the Bedework deployment classes"
  echo "     -monitor      Target is for the bedework monitor application"
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

# ----------------------------------------------------------------------------
# Update the projects
# ----------------------------------------------------------------------------
actionUpdateall() {
  for project in $updateProjects
  do
    if [ ! -d "$project" ] ; then
      echo "*********************************************************************"
      echo "Project $project is missing. Check it out from the repository"
      echo "*********************************************************************"
      exit 1
    else
      echo "*********************************************************************"
      echo "Updating project $project"
      echo "*********************************************************************"
      svn update $project
    fi
  done

  exit 0
}

# Change to the next project to build. Exit if we're done.
# The order below reflects the dependencies
setDirectory() {
    specialTarget=

#     Special targets
  if [ "$cmdutil" != "" ] ; then
    cd $QUICKSTART_HOME/bwtools
    specialTarget=cmdutil
    cmdutil=
    return
  fi

    if [ "$dirstart" != "" ] ; then
      cd $QUICKSTART_HOME
      specialTarget=dirstart
      dirstart=
      return
    fi

    if [ "$deploylog4j" != "" ] ; then
      cd $QUICKSTART_HOME
      specialTarget=deploylog4j
      deploylog4j=
      return
    fi

    if [ "$deployActivemq" != "" ] ; then
      cd $QUICKSTART_HOME
      specialTarget=deployActivemq
      deployActivemq=
      return
    fi

  if [ "$deployConf" != "" ] ; then
    cd $QUICKSTART_HOME
    specialTarget=deployConf
    deployConf=
    return
  fi

  if [ "$deployData" != "" ] ; then
    cd $QUICKSTART_HOME
    specialTarget=deployData
    deployData=
    return
  fi

  if [ "$deploySolr" != "" ] ; then
    cd $QUICKSTART_HOME
    specialTarget=deploySolr
    deploySolr=
    return
  fi

  if [ "$deployEs" != "" ] ; then
    cd $QUICKSTART_HOME
    specialTarget=deployEs
    deployEs=
    return
  fi

  if [ "$saveData" != "" ] ; then
    cd $QUICKSTART_HOME
    specialTarget=saveData
      saveData=
    return
  fi

#     projects

	if [ "$geronimoHib" != "" ] ; then
	  cd $QUICKSTART_HOME/geronimo-hibernate
      geronimoHib=
	  return
	fi

	if [ "$bedenote" != "" ] ; then
	  cd $QUICKSTART_HOME/bedenote
      bedenote=
	  return
	fi

	if [ "$bwdeployutil" != "" ] ; then
	  cd $QUICKSTART_HOME/bwdeployutil
      bwdeployutil=
	  return
	fi

	if [ "$bwxml" != "" ] ; then
	  cd $QUICKSTART_HOME/bwxml
      bwxml=
	  return
	fi

	if [ "$rpiutil" != "" ] ; then
	  cd $QUICKSTART_HOME/rpiutil
      rpiutil=
	  return
	fi

	if [ "$access" != "" ] ; then
	  cd $QUICKSTART_HOME/access
      access=
	  return
	fi

	if [ "$eventreg" != "" ] ; then
	  cd $QUICKSTART_HOME/eventreg
      eventreg=
	  return
	fi

	if [ "$webdav" != "" ] ; then
	  cd $QUICKSTART_HOME/webdav
      webdav=
	  return
	fi

	if [ "$caldav" != "" ] ; then
	  cd $QUICKSTART_HOME/caldav
      caldav=
	  return
	fi

	if [ "$caldavTest" != "" ] ; then
	  cd $QUICKSTART_HOME/caldavTest
      caldavTest=
	  return
	fi

	if [ "$carddav" != "" ] ; then
	  cd $QUICKSTART_HOME/bedework-carddav
      carddav=
	  return
	fi

	if [ "$bwannotations" != "" ] ; then
	  cd $QUICKSTART_HOME/bwannotations
      bwannotations=
	  return
	fi

	if [ "$bwcalfacade" != "" ] ; then
	  cd $QUICKSTART_HOME/bwcalFacade
      bwcalfacade=
	  return
	fi

	if [ "$bwinterfaces" != "" ] ; then
	  cd $QUICKSTART_HOME/bwinterfaces
      bwinterfaces=
	  return
	fi

	if [ "$genkeys" != "" ] ; then
	  cd $QUICKSTART_HOME/genkeys
      genkeys=
	  return
	fi

	if [ "$bwsysevents" != "" ] ; then
	  cd $QUICKSTART_HOME/bwsysevents
      bwsysevents=
	  return
	fi

	if [ "$bwicalendar" != "" ] ; then
	  cd $QUICKSTART_HOME/bwical
      bwicalendar=
	  return
	fi

	if [ "$bwwebapps" != "" ] ; then
	  cd $QUICKSTART_HOME/bwwebapps
      bwwebapps=
	  return
	fi

	if [ "$bwcaldav" != "" ] ; then
	  cd $QUICKSTART_HOME/bwcaldav
      bwcaldav=
	  return
	fi

	if [ "$bwcalcore" != "" ] ; then
	  cd $QUICKSTART_HOME/bwcalcore
      bwcalcore=
	  return
	fi

	if [ "$catsvr" != "" ] ; then
	  cd $QUICKSTART_HOME/catsvr
      catsvr=
	  return
	fi

	if [ "$client" != "" ] ; then
	  cd $QUICKSTART_HOME/bwclient
      client=
	  return
	fi

	if [ "$indexer" != "" ] ; then
	  cd $QUICKSTART_HOME/indexer
      indexer=
	  return
	fi

	if [ "$dumprestore" != "" ] ; then
	  cd $QUICKSTART_HOME/dumprestore
      dumprestore=
	  return
	fi

	if [ "$bedework" != "" ] ; then
	  cd $QUICKSTART_HOME
      bedework=
	  return
	fi

	if [ "$monitor" != "" ] ; then
	  cd $QUICKSTART_HOME/MonitorApp
      monitor=
	  return
	fi

	if [ "$naming" != "" ] ; then
	  cd $QUICKSTART_HOME/bwnaming
      naming=
	  return
	fi

	if [ "$exchgGateway" != "" ] ; then
	  cd $QUICKSTART_HOME/exchgGateway
      exchgGateway=
	  return
	fi

	if [ "$selfreg" != "" ] ; then
	  cd $QUICKSTART_HOME/selfreg
      selfreg=
	  return
	fi

  if [ "$synch" != "" ] ; then
    cd $QUICKSTART_HOME/synch
      synch=
    return
  fi

	if [ "$testsuite" != "" ] ; then
	  cd $QUICKSTART_HOME/testsuite
      testsuite=
	  return
	fi

	if [ "$tzsvr" != "" ] ; then
	  cd $QUICKSTART_HOME/bwtzsvr
      tzsvr=
	  return
	fi

	if [ "$bwtools" != "" ] ; then
	  cd $QUICKSTART_HOME/bwtools
      bwtools=
	  return
	fi

# Nothing left to do
    echo "Finished at $(date)"
	exit 0;
}

usageZoneinfo() {
  echo ""
  echo "$PRG -zoneinfo -fetch"
  echo "to have data fetched and processed. Alternatively to process a specific set of data"
  echo "$PRG -zoneinfo -version VERSION -tzdata path-to-data"
  echo "for example:"
  echo "$PRG -zoneinfo -version 2010m -tzdata /data/olson/tzdata2010m.tar.gz"
  echo ""
  echo "The code and data can be obtained manually from:"
  echo "  http://www.iana.org/time-zones/repository/tzcode-latest.tar.gz"
  echo "  http://www.iana.org/time-zones/repository/tzdata-latest.tar.gz"
  echo ""
  echo "  ftp://ftp.iana.org/tz/tzcode-latest.tar.gz"
  echo "  ftp://ftp.iana.org/tz/tzdata-latest.tar.gz"
  echo "e.g."
  echo "  wget 'ftp://ftp.iana.org/tz/tzdata-latest.tar.gz'"
  echo ""
  echo "For a specific version replace 'latest' with the version, e.g."
  echo "  ftp://ftp.iana.org/tz/releases/tzcode2012e.tar.gz"

  exit 1
}

# ----------------------------------------------------------------------------
# Build zoneinfo - require -version -tzdata
# The version parameter value should be the version code from the tzdata name
# ----------------------------------------------------------------------------
actionZoneinfo() {
  bwtzsvr="$QUICKSTART_HOME/bwtzsvr"
  bwresources="$bwtzsvr/resources"

  rm -rf /tmp/bedework
  mkdir /tmp/bedework
  mkdir /tmp/bedework/timezones
  mkdir /tmp/bedework/timezones/data

  cd /tmp/bedework/timezones

  shift

  if [ "$1" = "-fetch" ] ; then
    shift
    cd data
    wget 'http://www.iana.org/time-zones/repository/tzdata-latest.tar.gz'
    gzip -dc tzdata*.tar.gz | tar -xf -

    filename=$(basename `ls tzdata*`)
    version=$( echo $filename | cut -c 7-11 )

    tzdata="/tmp/bedework/timezones/data/$filename"

    cd ..

    echo version=$version
    echo tzdata=$tzdata
  else
    if [ "$1" != "-version" ] ; then
      echo "got $1"
      echo "Must supply -version parameter for -zoneinfo"
      usageZoneinfo
    fi

    shift

    echo "got $1"
    version=$1

    shift

    if [ "$1" != "-tzdata" ] ; then
      echo "Must supply -tzdata parameter for -zoneinfo"
      usageZoneinfo
    fi

    shift

    tzdata=$1

    shift
  fi

  wget http://bedework.org/downloads/lib/vzic-1.3.tgz
  gunzip vzic-1.3.tgz
  tar -xf vzic-1.3.tar

# copy and unpack the data
  mkdir olsondata
  cd olsondata
  cp $tzdata tzdata.tar.gz
  gunzip tzdata.tar.gz
  tar -xf tzdata.tar
  rm tzdata.tar
  cd ..

# Replace lines in the makefile. Sure real unix types can do better

  cd vzic-1.3

  sed "s/\(^OLSON_DIR = \)\(..*$\)/\1\/tmp\/bedework\/timezones\/olsondata/" Makefile > Makefile1

  sed "s/\(^PRODUCT_ID = \)\(..*$\)/\1\/bedework.org\/\/NONSGML Bedework\/\/EN/" Makefile1 > Makefile2

  sed "s/\(^TZID_PREFIX = \)\(..*$\)/\1/" Makefile2 > Makefile

  make

# omit the pure for allegedly better outlook compatability -
# but not altogether correct timezones
  ./vzic --pure

  cd ..

  mkdir tzdata
  cp -r vzic-1.3/zoneinfo tzdata
  cp $bwresources/aliases.txt tzdata

  cd tzdata

  echo "version=$version" > info.txt
#  date +buildTime=%D-%T-%N >> info.txt
  date --utc +buildTime=%Y%m%dT%H%M%SZ >> info.txt

  zip -r tzdata *

  cp tzdata.zip $bwtzsvr/dist

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "tzdata.zip has been built and is at $bwtzsvr/dist/tzdata.zip"
  echo "------------------------------------------------------------------------------"
  echo ""

  exit 0
}

if [ -z "$JAVA_HOME" -o ! -d "$JAVA_HOME" ] ; then
  errorUsage "JAVA_HOME is not defined correctly for bedework."
fi

saveddir=`pwd`

trap 'cd $saveddir' 0
trap "exit 2" 1 2 3 15

export QUICKSTART_HOME=$saveddir

CLASSPATH=$ANT_HOME/lib/ant-launcher.jar
CLASSPATH=$CLASSPATH:$QUICKSTART_HOME/bedework/build/quickstart/antlib

# Default some parameters

BWCONFIGS=
BWJMXCONFIG=
bwc=default
BWCONFIG=
offline=
quickstart=

action=

if [ "$1" = "" ] ; then
  usage
  exit 1
fi

# look for actions first

if [ "$1" = "-updateall" ] ; then
  actionUpdateall
fi

if [ "$1" = "-zoneinfo" ] ; then
  actionZoneinfo $*
fi

if [ "$1" = "-buildwebcache" ] ; then
  cd $QUICKSTART_HOME/cachedfeeder
  ./buildWebCache
  exit
fi

if [ "$1" = "-deploywebcache" ] ; then
  cd $QUICKSTART_HOME/cachedfeeder
  $JAVA_HOME/bin/java -classpath $CLASSPATH $ant_xmllogfile -Dant.home=$ANT_HOME org.apache.tools.ant.launch.Launcher \
                 $BWCONFIG $ant_listener $ant_logger $ant_loglevel $bw_loglevel -lib $QUICKSTART_HOME/bedework/build/quickstart/antlib deploy-webcache
  exit
fi

if [ "$1" = "-deployurlbuilder" ] ; then
  cd $QUICKSTART_HOME/cachedfeeder
  $JAVA_HOME/bin/java -classpath $CLASSPATH $ant_xmllogfile -Dant.home=$ANT_HOME org.apache.tools.ant.launch.Launcher \
                 $BWCONFIG $ant_listener $ant_logger $ant_loglevel $bw_loglevel -lib $QUICKSTART_HOME/bedework/build/quickstart/antlib deploy-urlbuilder
  exit
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
#   -webdav)
#      webdav="yes"
#
#      access="yes"
#      bwxml="yes"
#      rpiutil="yes"
#      pkgdefault=
#  Turns on the webdav build and also access, bwxml and rpiutil because it depends
#  on them.
# ----------------------------------------------------------------------------

while [ "$1" != "" ]
do
  # Process the next arg
  case $1       # Look at $1
  in
    -bwchome)         # Define location of configs
      shift
      BWCONFIGS="$1"
      shift
      ;;
    -quickstart)
      quickstart="yes"
      shift
      ;;
    -usage | -help | -? | ?)
      usage
      exit
      shift
      ;;
    -bwc)
      shift
      bwc="$1"
      shift
      ;;
    -bwjmxconf)
      shift
      BWJMXCONFIG="$1"
      shift
      ;;
    -offline)
      offline="-Dorg.bedework.offline.build=yes"
      shift
      ;;
# ----------------------- Log level
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
  deploySolr)
	  deploySolr="yes"
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
# ------------------------Projects
    -access)
      access="yes"

      bwxml="yes"
      rpiutil="yes"
      pkgdefault=
      shift
      ;;
    -bedenote)
      bedenote="yes"
      pkgdefault=
      shift
      ;;
    -bwann)
      bwannotations="yes"
      pkgdefault=
      shift
      ;;
    -bwcaldav)
      bwcaldav="yes"

      access="yes"
      bwannotations="yes"
      bwcalfacade="yes"
      bwicalendar="yes"
      bwinterfaces="yes"
      bwsysevents="yes"
      bwxml="yes"
      caldav="yes"
      rpiutil="yes"
      webdav="yes"
      pkgdefault=
      shift
      ;;
    -bwcalcore)
      bwcalcore="yes"

      access="yes"
      bwannotations="yes"
      bwcalfacade="yes"
      bwicalendar="yes"
      bwinterfaces="yes"
      bwsysevents="yes"
      bwxml="yes"
      caldav="yes"
      rpiutil="yes"
      webdav="yes"
      pkgdefault=
      shift
      ;;
    -bwcalfacade)
      bwcalfacade="yes"

      access="yes"
      bwannotations="yes"
      bwxml="yes"
      caldav="yes"
      rpiutil="yes"
      webdav="yes"
      pkgdefault=
      shift
      ;;
    -bwicalendar)
      bwicalendar="yes"

      bwannotations="yes"
      bwcalfacade="yes"
      bwxml="yes"

      pkgdefault=
      shift
      ;;
    -bwinterfaces)
      bwinterfaces="yes"

      access="yes"
      bwannotations="yes"
      bwcalfacade="yes"
      bwxml="yes"
      caldav="yes"
      rpiutil="yes"
      webdav="yes"

      pkgdefault=
      shift
      ;;
    -bwsysevents)
      bwsysevents="yes"

      bwinterfaces="yes"
      rpiutil="yes"
      pkgdefault=
      shift
      ;;
    -bwtools)
      bwtools="yes"

      bwannotations="yes"
      bwcalfacade="yes"
      bwinterfaces="yes"
      bwxml="yes"
      rpiutil="yes"
      pkgdefault=
      shift
      ;;
    -bwwebapps)
      bwwebapps="yes"

      access="yes"
      bwannotations="yes"
      bwcalfacade="yes"
      bwicalendar="yes"
      bwinterfaces="yes"
      bwxml="yes"
      caldav="yes"
      rpiutil="yes"
      webdav="yes"
      pkgdefault=
      shift
      ;;
    -bwxml)
      bwxml="yes"
      pkgdefault=
      shift
      ;;
    -caldav)
      caldav="yes"

      access="yes"
      bwxml="yes"
      rpiutil="yes"
      webdav="yes"
      pkgdefault=
      shift
      ;;
    -caldavTest)
      caldavTest="yes"

      access="yes"
      bwxml="yes"
      rpiutil="yes"
      webdav="yes"
      pkgdefault=
      shift
      ;;
    -carddav)
      carddav="yes"

      access="yes"
      bwxml="yes"
      rpiutil="yes"
      webdav="yes"
      pkgdefault=
      shift
      ;;
    -catsvr)
      catsvr="yes"

      access="yes"
      bwxml="yes"
      rpiutil="yes"
      webdav="yes"
      pkgdefault=
      shift
      ;;
    -client)
      client="yes"
      pkgdefault=
      shift
      ;;
    -deployutil)
      bwdeployutil="yes"

      pkgdefault=
      shift
      ;;
    -dumprestore)
      dumprestore="yes"

      access="yes"
      bwannotations="yes"
      bwcalcore="yes"
      bwcalfacade="yes"
      bwicalendar="yes"
      bwinterfaces="yes"
      bwsysevents="yes"
      indexer="yes"
      rpiutil="yes"
      pkgdefault=
      shift
      ;;
    -eventreg)
      eventreg="yes"

      bwxml="yes"
      rpiutil="yes"
      pkgdefault=
      shift
      ;;
    -genkeys)
      genkeys="yes"

      bwinterfaces="yes"
      rpiutil="yes"
      pkgdefault=
      shift
      ;;
    -geronimohib)
      geronimoHib="yes"

      pkgdefault=
      shift
      ;;
    -indexer)
      indexer="yes"

      access="yes"
      bwannotations="yes"
      bwcalcore="yes"
      bwcalfacade="yes"
      bwicalendar="yes"
      bwinterfaces="yes"
      bwsysevents="yes"
      rpiutil="yes"
      pkgdefault=
      shift
      ;;
    -monitor)
      monitor="yes"
      pkgdefault=
      shift
      ;;
    -naming)
      naming="yes"
      pkgdefault=
      shift
      ;;
    -rpiutil)
      rpiutil="yes"

      bwxml="yes"
      pkgdefault=
      shift
      ;;
    -exchgGateway)
      exchgGateway="yes"

#      access="yes"
      bwxml="yes"
#      rpiutil="yes"
      pkgdefault=
      shift
      ;;
    -selfreg)
      selfreg="yes"

      rpiutil="yes"
      pkgdefault=
      shift
      ;;
    -synch)
      synch="yes"

      access="yes"
      bwxml="yes"
      rpiutil="yes"
      pkgdefault=
      shift
      ;;
    -testsuite)
      testsuite="yes"

      pkgdefault="yes"
      shift
      ;;
    -tzsvr)
      tzsvr="yes"
      bwxml="yes"
      rpiutil="yes"
      pkgdefault=
      shift
      ;;
    -webdav)
      webdav="yes"

      access="yes"
      rpiutil="yes"
      pkgdefault=
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
  bedework="yes"

  access="yes"
  bwannotations="yes"
  bwcalcore="yes"
  bwcaldav="yes"
  bwcalfacade="yes"
  bwicalendar="yes"
  bwinterfaces="yes"
  bwsysevents="yes"
  bwwebapps="yes"
  bwxml="yes"
  caldav="yes"
  dumprestore="yes"
  indexer="yes"
  rpiutil="yes"
  webdav="yes"
fi

if [ "$quickstart" != "" ] ; then
  if [ "$BWCONFIGS" != "" ] ; then
    errorUsage "Cannot specify both -quickstart and -bwchome"
  fi

  BWCONFIGS=$QUICKSTART_HOME/bedework/config/bwbuild
elif [ "$BWCONFIGS" = "" ] ; then
  BWCONFIGS=$HOME/bwbuild
fi

if [ "$BWJMXCONFIG" = "" ] ; then
  BWJMXCONFIG=$QUICKSTART_HOME/bedework/config/bedework
fi

export BEDEWORK_CONFIGS_HOME=$BWCONFIGS
export BEDEWORK_CONFIG=$BWCONFIGS/$bwc
export BEDEWORK_JMX_CONFIG=$BWJMXCONFIG

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

echo "BWCONFIGS=$BWCONFIGS"
echo "BWCONFIG=$BWCONFIG"

javacmd="$JAVA_HOME/bin/java -classpath $CLASSPATH"
# Build (of bwxml) blew up with permgen error
javacmd="$javacmd -Xmx512M -XX:MaxPermSize=512M"

javacmd="$javacmd $ant_xmllogfile $offline"
javacmd="$javacmd -Dant.home=$ANT_HOME org.apache.tools.ant.launch.Launcher"
javacmd="$javacmd $BWCONFIG"
javacmd="$javacmd $ant_listener $ant_logger $ant_loglevel $bw_loglevel"
javacmd="$javacmd -lib $QUICKSTART_HOME/bedework/build/quickstart/antlib"

while true
do
  setDirectory

  if [ "$specialTarget" != "" ] ; then
    $javacmd $specialTarget
  else
#    echo $javacmd $*
    $javacmd $*
  fi
done

