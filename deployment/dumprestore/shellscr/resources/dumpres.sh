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
  restore-for-quickstart)
    echo $RESTORECMD -appname $APPNAME -onlyusers "public-user,caladmin,douglm,agrp_*" -f $2 $3 $4 $5 $6 $7 $8 $9
    $RESTORECMD -appname $APPNAME -onlyusers "public-user,caladmin,douglm,agrp_*" -f $2 $3 $4 $5 $6 $7 $8 $9
    ;;
  backup)
    TARGET=$2/$3`date +%Y%m%d_%H%M%S`.xml
    echo $DUMPCMD -appname $APPNAME -f $TARGET
    $DUMPCMD -appname $APPNAME -f $TARGET
    ;;
  initdb)
    echo $RESTORECMD -appname $APPNAME -f ./data/initbedework.xml -initSyspars $2 $3 $4 $5 $6 $7 $8 $9
    $RESTORECMD -appname $APPNAME -f ./data/initbedework.xml -initSyspars $2 $3 $4 $5 $6 $7 $8 $9
    ;;
  drop)
    echo $SCHEMACMD --text --drop --formatted --delimiter="@SCHEMA-DELIMITER@" --config=./classes/hibernate.cfg.xml --output=schema.sql
    $SCHEMACMD --text --drop --formatted --delimiter="@SCHEMA-DELIMITER@" --config=./classes/hibernate.cfg.xml --output=schema.sql
    ;;
  export-drop)
    echo $SCHEMACMD --drop --formatted --delimiter="@SCHEMA-DELIMITER@" --config=./classes/hibernate.cfg.xml --output=schema.sql $2 $3 $4 $5 $6 $7 $8 $9
    $SCHEMACMD --drop --formatted --delimiter="@SCHEMA-DELIMITER@" --config=./classes/hibernate.cfg.xml --output=schema.sql $2 $3 $4 $5 $6 $7 $8 $9
    ;;
  schema)
    echo $SCHEMACMD --text --create --formatted --delimiter="@SCHEMA-DELIMITER@" --config=./classes/hibernate.cfg.xml --output=schema.sql
    $SCHEMACMD --text --create --formatted --delimiter="@SCHEMA-DELIMITER@" --config=./classes/hibernate.cfg.xml --output=schema.sql
    ;;
  schema-export)
    echo $SCHEMACMD --create --formatted --delimiter="@SCHEMA-DELIMITER@" --config=./classes/hibernate.cfg.xml --output=schema.sql $2 $3 $4 $5 $6 $7 $8 $9
    $SCHEMACMD --create --formatted --delimiter="@SCHEMA-DELIMITER@" --config=./classes/hibernate.cfg.xml --output=schema.sql $2 $3 $4 $5 $6 $7 $8 $9
    ;;
  *)
    echo $" "
    echo $"Usage: "
    echo $"  $0 dump <filename> "
    echo $"     Dump the database in xml format suitable for restore."
    echo $" "
    echo $"  $0 restore <filename> "
    echo $"     Restore the database from an xml formatted dump."
    echo $" "
    echo $"  $0 backup <directory> <prefix>} "
    echo $"     Dump the database in xml format suitable for restore."
    echo $"     Files will have a name built from the prefix and the current date/time."
    echo $" "
    echo $"  $0 initdb [--indexroot=<lucene-index-root>"
    echo $"     Populate the database using the provided initial data."
    echo $" "
    echo $"  $0 drop [--haltonerror] "
    echo $"     Create a file in the current directory with sql drop statements"
    echo $" "
    echo $"  $0 export-drop [--haltonerror]"
    echo $"     Drop tables in the database. Note this may not work if the schema"
    echo $"     was changed."
    echo $" "
    echo $"  $0 schema [--haltonerror] "
    echo $"     Create a schema from the xml schema. Placed in a file in the current directory"
    echo $" "
    echo $"  $0 schema-export [--haltonerror]"
    echo $"     Create a schema from the xml schema."
    echo $"     Also create the database tables, indexes etc."
    echo $" "
esac

