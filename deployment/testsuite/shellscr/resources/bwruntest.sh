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
  echo $RUNCMDPREFIX $2 "org.junit.runner.JUnitCore org.bedework.testsuite.$1"
  $RUNCMDPREFIX $2 "org.junit.runner.JUnitCore" "org.bedework.testsuite.$1"
}

case "$1" in
  apitest)
    runit "apitests.AllApiTests"
    ;;
  apitest.debug)
    runit "apitests.AllApiTests" "-Dorg.bedework.test.debug=true"
    ;;
  *)
    echo "valid parameters:"
    echo "  apitest"
    echo "     run the tests"
    echo "  apitest.debug"
    echo "     run the tests with debugging on"
esac
