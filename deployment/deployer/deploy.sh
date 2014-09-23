#!/bin/sh

# Run the bedework post-build deployer program

# JAVA_HOME needs to be defined

# run from the quickstart home.

# dir=`dirname $0`
# dir=`cd $dir; pwd`
# cd $dir

cp=.:./classes:./resources

for i in ./bw-util/bw-util-deployment/target/*.jar
  do
    cp=$cp:$i
done

for i in ./bw-util/bw-util-args/target/*.jar
  do
    cp=$cp:$i
done

for i in ./bw-util/bw-util-xml/target/*.jar
  do
    cp=$cp:$i
done

RUNCMDPREFIX="$JAVA_HOME/bin/java -cp $cp "

RUNCMD="$RUNCMDPREFIX org.bedework.util.deployment.ProcessEars $*"

# echo "$RUNCMD"

$RUNCMD
