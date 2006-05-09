#!/bin/sh

# Run the bedework dump/restore program
# First arg defines the action, dump, restore etc
# Second arg should be the filename

# JAVA_HOME needs to be defined

cp=@CP@

DUMPCMD="$JAVA_HOME/bin/java -cp $cp @DUMP-CLASS@"
RESTORECMD="$JAVA_HOME/bin/java -cp $cp @RESTORE-CLASS@"

APPNAME=@BW-APP-NAME@

case "$1" in
  dump)
    echo $DUMPCMD -appname $APPNAME -f $2 $3 $4 $5 $6 $7 $8 $9
    $DUMPCMD -appname $APPNAME -f $2 $3 $4 $5 $6 $7 $8 $9
    ;;
  restore)
    echo $RESTORECMD -appname $APPNAME -f $2 $3 $4 $5 $6 $7 $8 $9
    $RESTORECMD -appname $APPNAME -f $2 $3 $4 $5 $6 $7 $8 $9
    ;;
  backup)
    TARGET=$2/$3`date +%Y%m%d_%H%M%S`.ldif
    echo $DUMPCMD -appname $APPNAME -f $TARGET
    $DUMPCMD -appname $APPNAME -f $TARGET
    ;;
  initdb)
    echo $RESTORECMD -appname $APPNAME -f ./data/initbedework.xml -initSyspars
    $RESTORECMD -appname $APPNAME -f ./data/initbedework.xml -initSyspars
    ;;
  *)
    echo $"Usage: $0 {dump <filename>|restore <filename>|backup <directory> <prefix>} || initdb"
esac

