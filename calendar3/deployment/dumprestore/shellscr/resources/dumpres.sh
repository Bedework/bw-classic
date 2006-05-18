#!/bin/sh

# Run the bedework dump/restore program
# First arg defines the action, dump, restore etc
# Second arg should be the filename

# JAVA_HOME needs to be defined

cp=@CP@

DUMPCMD="$JAVA_HOME/bin/java -cp $cp @DUMP-CLASS@"
RESTORECMD="$JAVA_HOME/bin/java -cp $cp @RESTORE-CLASS@"
SCHEMACMD="$JAVA_HOME/bin/java -cp $cp org.hibernate.tool.hbm2ddl.SchemaExport"

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
  schema)
    echo $SCHEMACMD --text --create --config=./classes/hibernate.cfg.xml --output=schema.sql
    $SCHEMACMD --text --create --config=./classes/hibernate.cfg.xml --output=schema.sql
    ;;
  schema-export)
    echo $SCHEMACMD --create --config=./classes/hibernate.cfg.xml --output=schema.sql
    $SCHEMACMD --create --config=./classes/hibernate.cfg.xml --output=schema.sql
    ;;
  *)
    echo $"Usage: $0 {dump <filename> |"
    echo $"           restore <filename> |"
    echo $"           backup <directory> <prefix>} |"
    echo $"           initdb |"
    echo $"           schema |"
    echo $"           schema-export"
esac

