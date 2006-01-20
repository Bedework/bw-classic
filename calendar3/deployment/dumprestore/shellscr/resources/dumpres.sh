#!/bin/sh

# Run the bedework dump/restore program
# First arg defines the action, dump, restore etc
# Second arg should be the filename

# JAVA_HOME needs to be defined

cp=@CP@

DUMPCMD="$JAVA_HOME/bin/java -cp $cp @DUMP-CLASS@"
RESTORECMD="$JAVA_HOME/bin/java -cp $cp @RESTORE-CLASS@"



case "$1" in
  dump)
    echo $DUMPCMD -debug -f $2 $3 $4 $5 $6 $7 $8 $9
    $DUMPCMD -debug -f $2 $3 $4 $5 $6 $7 $8 $9
    ;;
  restore)
    echo $RESTORECMD -debug -f $2 $3 $4 $5 $6 $7 $8 $9
    $RESTORECMD -debug -f $2 $3 $4 $5 $6 $7 $8 $9
    ;;
  backup)
    TARGET=$2/$3`date +%Y%m%d_%H%M%S`.ldif
    echo $RUNCMD -dump -f $TARGET
    $RUNCMD -dump -f $TARGET
    ;;
  *)
    echo $"Usage: $0 {dump <filename>|restore <filename>|backup <directory> <prefix>}"
esac

