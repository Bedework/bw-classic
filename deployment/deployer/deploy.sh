#!/bin/sh

# Run the bedework post-build deployer program

# JAVA_HOME needs to be defined

# run from the quickstart home.

# dir=`dirname $0`
# dir=`cd $dir; pwd`
# cd $dir

cp=.:./classes:./resources

for i in ./rpiutil/lib/*
  do
    cp=$cp:$i
done

for i in ./rpiutil/dist/*
  do
    cp=$cp:$i
done

RUNCMDPREFIX="$JAVA_HOME/bin/java -cp $cp "

RUNCMD="$RUNCMDPREFIX edu.rpi.sss.util.deployment.ProcessEars $*"

echo "$RUNCMD"

$RUNCMD
