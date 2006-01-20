#!/bin/sh

# Run the uw calendar config program

# JAVA_HOME needs to be defined

CP=@CP@

RUNCMD="$JAVA_HOME/bin/java -cp $CP @MAIN-CLASS@";

$RUNCMD $1 $2 $3 $4 $5 $6 $7 $8 $9

