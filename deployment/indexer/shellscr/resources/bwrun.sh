#!/bin/sh

# Run the bedework indexer program

# JAVA_HOME needs to be defined

cp=.:./classes:./resources

for i in lib/*
  do
    cp=$cp:$i
done

# Need a temp dir for hibernate cache
TEMPDIR="./temp"
mkdir $TEMPDIR

RUNCMD="$JAVA_HOME/bin/java -Djava.io.tmpdir="$TEMPDIR" -cp $cp org.bedework.indexer.BwIndexApp"

APPNAME=indexer


case "$1" in
  reindex)
    echo $RUNCMD -appname $APPNAME reindex $2 $3 $4 $5 $6 $7 $8 $9
    $RUNCMD -appname $APPNAME reindex $2 $3 $4 $5 $6 $7 $8 $9
    ;;
  start)
    echo $RUNCMD -appname $APPNAME start $2 $3 $4 $5 $6 $7 $8 $9
    $RUNCMD -appname $APPNAME start $2 $3 $4 $5 $6 $7 $8 $9
    ;;
  *)
    echo $" "
    echo $"Usage: "
    echo $"  $0 reindex [(-ndebug | -debug)] "
    echo $"     Reindex the system then process queue events"
    echo $"  $0 start [(-ndebug | -debug)] "
    echo $"     Process queue events"
    echo $" "
esac

