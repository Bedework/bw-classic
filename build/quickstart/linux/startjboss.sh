#! /bin/sh

# Script to start jboss with properties defined
# This currently needs to be executed out of the quickstart directory
# (via a source)

BASE_DIR=`pwd`

PRG="$0"

usage() {
  echo "  $PRG [-heap size] [-newsize size] [-permgen size] [-debug]"
  echo "       [-debugexprfilters name] [-activemquri uri]"
  echo ""
  echo " Where:"
  echo ""
  echo " -heap sets the heap size and should be n for bytes"
  echo "                                        nK for kilo-bytes (e.g. 2560000K)"
  echo "                                        nM for mega-bytes (e.g. 2560M)"
  echo "                                        nG for giga-bytes (e.g. 1G)"
  echo "  Default: $heap"
  echo ""
  echo " -permsize sets the permgen size and has the same form as -heap"
  echo "  The value should probably not be less than 256M"
  echo "  Default: $permsize"
  echo ""
  echo " -debug sets the logging level to DEBUG"
  echo ""
  echo " -debugexprfilters sets the logging level for bedework expression filters to DEBUG"
  echo ""
  echo " -activemquri sets the uri used by the activemq broker for bedework"
  echo "  Some possibilities: vm://localhost tcp://localhost:61616"
  echo "  Default: $activemquri"
  echo ""
  echo " -portoffset sets the offset for the standard jboss ports allowing"
  echo "  multiple instances to be run on the same machine. The activemquri"
  echo "  value may need to be set explicitly if it uses a port."
  echo "  Default: $portoffset"
  echo ""
}

# ===================== Defaults =================================
heap="600M"
newsize="200M"
permsize="256M"
usees="-Dorg.bedework.core.use.es=true"
testmode=""

portoffset=0

activemquri="vm://localhost"

exprfilters=INFO

# =================== End defaults ===============================

LOG_THRESHOLD="-Djboss.server.log.threshold=INFO"
JBOSS_VERSION="jboss-5.1.0.GA"

while [ "$1" != "" ]
do
  # Process the next arg
  case $1       # Look at $1
  in
    -usage | -help | -? | ?)
      usage
      exit
      ;;
    -heap)         # Heap size bytes or nK, nM, nG
      shift
      heap="$1"
      shift
      ;;
    -newsize)
      shift
      newsize="$1"
      shift
      ;;
    -permsize)
      shift
      permsize="$1"
      shift
      ;;
    -jboss)
      shift
      JBOSS_VERSION="$1"
      shift
      ;;
    -testmode)
      shift
      testmode="-Dorg.bedework.testmode=true"
      ;;
    -debug)
      shift
      LOG_THRESHOLD="-Djboss.server.log.threshold=DEBUG"
      ;;
    -debugexprfilters)
      shift
      exprfilters=DEBUG
      shift
      ;;
    -portoffset)
      shift
      portoffset="$1"
      shift
      ;;
    -activemquri)
      shift
      activemquri="$1"
      shift
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

JBOSS_CONFIG="default"
JBOSS_SERVER_DIR="$BASE_DIR/$JBOSS_VERSION/server/$JBOSS_CONFIG"
JBOSS_DATA_DIR="$JBOSS_SERVER_DIR/data"

# If this is empty only localhost will be available.
# With this address anybody can access the consoles if they are not locked down.
JBOSS_BIND="-b 0.0.0.0"

LOG_LEVELS="-Dorg.bedework.loglevel.exprfilters=$exprfilters"

#
# Port shifting
#

# standard ports
JBOSS_PORTS=-Dorg.bedework.system.ports.offset=$portoffset

# standard ports + defined value
#JBOSS_PORTS="-Dorg.bedework.system.ports.offset=505 -Djboss.service.binding.set=ports-syspar"

ACTIVEMQ_DIRPREFIX="-Dorg.apache.activemq.default.directory.prefix=$JBOSS_DATA_DIR/"
ACTIVEMQ_URI="-Dorg.bedework.activemq.uri=$activemquri"

BW_DATA_DIR=$JBOSS_DATA_DIR/bedework
BW_DATA_DIR_DEF=-Dorg.bedework.data.dir=$BW_DATA_DIR/

# Define the system properties used to locate the module specific data

#         carddav data dir
BW_CARDDAV_DATAURI=$BW_DATA_DIR/carddavConfig
BW_CARDDAV_DATAURI_DEF=-Dorg.bedework.carddav.datauri=$BW_CARDDAV_DATAURI/
BW_DATA_DIR_DEF="$BW_DATA_DIR_DEF $BW_CARDDAV_DATAURI_DEF"

#         synch data dir
BW_SYNCH_DATAURI=$BW_DATA_DIR/synch
BW_SYNCH_DATAURI_DEF=-Dorg.bedework.synch.datauri=$BW_SYNCH_DATAURI/
BW_DATA_DIR_DEF="$BW_DATA_DIR_DEF $BW_SYNCH_DATAURI_DEF"

# Configurations property file

BW_CONF_DIR="$JBOSS_SERVER_DIR/conf/bedework"
BW_CONF_DIR_DEF="-Dorg.bedework.config.pfile=$BW_CONF_DIR/config.defs"

# Elastic search home

export ES_HOME="$BW_DATA_DIR/elasticsearch"
JAVA_OPTS="$JAVA_OPTS -Des.path.home=$ES_HOME"

JAVA_OPTS="$JAVA_OPTS -Xms$heap -Xmx$heap"

# Put all the temp stuff inside the jboss temp
JAVA_OPTS="$JAVA_OPTS -Djava.io.tmpdir=$JBOSS_SERVER_DIR/tmp"

HAWT_OPTS="-Dhawtio.authenticationEnabled=true"

export JAVA_OPTS="$JAVA_OPTS -XX:PermSize=$permsize -XX:MaxPermSize=$permsize"

RUN_CMD="./$JBOSS_VERSION/bin/run.sh"
RUN_CMD="$RUN_CMD -c $JBOSS_CONFIG $JBOSS_BIND $JBOSS_PORTS"
RUN_CMD="$RUN_CMD $HAWT_OPTS"
RUN_CMD="$RUN_CMD $usees"
RUN_CMD="$RUN_CMD $testmode"
RUN_CMD="$RUN_CMD $LOG_THRESHOLD $LOG_LEVELS"
RUN_CMD="$RUN_CMD $ACTIVEMQ_DIRPREFIX $ACTIVEMQ_URI"
RUN_CMD="$RUN_CMD $BW_CONF_DIR_DEF $BW_DATA_DIR_DEF"

# Specifying jboss.platform.mbeanserver makes jboss use the standard
# platform mbean server.
RUN_CMD="$RUN_CMD -Djboss.platform.mbeanserver"

# Set up JMX for bedework
#RUN_CMD="$RUN_CMD -Dorg.bedework.jmx.defaultdomain=jboss"
RUN_CMD="$RUN_CMD -Dorg.bedework.jmx.isJboss5=true"
RUN_CMD="$RUN_CMD -Dorg.bedework.jmx.classloader=org.jboss.mx.classloader"

echo $RUN_CMD

$RUN_CMD
