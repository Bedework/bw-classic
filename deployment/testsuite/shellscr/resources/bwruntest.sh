#!/bin/sh

# Run the bedework caldav test program

# JAVA_HOME needs to be defined

cp=@CP@

RUNCMDPREFIX="$JAVA_HOME/bin/java -cp $cp "

APPNAME=@BW-APP-NAME@

function runit() {
  echo $RUNCMDPREFIX "org.junit.runner.JUnitCore org.bedework.testsuite.$1"
  $RUNCMDPREFIX "org.junit.runner.JUnitCore" "org.bedework.testsuite.$1"
}

case "$1" in
  apitest)
    runit "apitests.AllApiTests"
    ;;
  *)
esac
