#!/bin/sh

# Run the bedework caldav test program

# JAVA_HOME needs to be defined

cp=.:./classes:./resources

for i in lib/*
  do
    cp=$cp:$i
done

RUNCMDPREFIX="$JAVA_HOME/bin/java -cp $cp "

APPNAME=@BW-APP-NAME@

runit() {
  echo $RUNCMDPREFIX "org.junit.runner.JUnitCore org.bedework.testsuite.$1"
  $RUNCMDPREFIX "org.junit.runner.JUnitCore" "org.bedework.testsuite.$1"
}

case "$1" in
  apitest)
    runit "apitests.AllApiTests"
    ;;
  *)
esac
