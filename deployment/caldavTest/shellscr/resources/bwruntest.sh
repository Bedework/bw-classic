#!/bin/sh

# Run the bedework caldav test program

# JAVA_HOME needs to be defined

cp=.:./classes:./resources

for i in lib/*
  do
    cp=$cp:$i
done

RUNCMD="$JAVA_HOME/bin/java -cp $cp @CALDAVTEST-CLASS@"

APPNAME=@BW-APP-NAME@

echo $RUNCMD $*
$RUNCMD  $*

