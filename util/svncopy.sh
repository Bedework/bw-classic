#!/bin/sh

# Copy the current trunk to a new location and adjust the externals property

usage() {
  echo "This script will copy the trunk to a new location and adjust the "
  echo "svn:externals property to refer to the new copies"
  echo " "
  echo " $0 help"
  echo " $0 (branch | tag | release) name comment-text"
  echo " "
  echo " par 1: branch tag or release specifies what kind of copy"
  echo " par 2: name e.g. my-copy or bedework-4.0.1"
  echo " par 3: comment text"
  echo " "
  echo ' e.g. svncopy branch my-copy "my personal branch"'
  echo " "
  exit
}

# Check a parameter is set
#
# par 1: branch/tag/release
#
checkbranchtag() {
  if [ "${1}x" = "x" ]
  then
      usage
  fi

  case "$1" in
    branch)
      BTR="branches"
      ;;
    tag)
      BTR="tags"
      ;;
    release)
      BTR="releases"
      ;;
    help)
      usage
      ;;
    *)
      echo " "
      echo "**** "
      echo "**** First parameter must be branch tag or release"
      echo "**** "
      echo " "
      usage
   esac
}

# Check a parameter is set
#
# par 1: Name of parameter
# par 2: value
#
check() {
  if [ "${2}x" = "x" ]
  then
    echo " "
    echo "**** "
    echo "**** Parameter $1 is not set"
    echo "**** "
    echo " "
    usage
  fi
}

# ------------------------------------------------------------------
# copyproject - copy a single project
#
# par 1 - project name
# par 2 - destination
# par 3 - comment
# ------------------------------------------------------------------
copyproject() {
  echo "copyproject $1 $2"
  if [ "${1}" != "bedework" ]
  then
    echo "projects/$1 $SVNREPOSITORY/$1/$2" >> $SCTEMPFILE
  fi
  svn copy -m "$3" -rHEAD $SVNREPOSITORY/$1/trunk $SVNREPOSITORY/$1/$2
}

checkbranchtag "$1"
check "Name" "$2"
check "Comment" "$3"

SVNREPOSITORY="http://svn.bedework.org"
TARGET="$BTR/$2"
COMMENT="$3"

PROJECTS=""
PROJECTS="$PROJECTS access"
PROJECTS="$PROJECTS bedework"
PROJECTS="$PROJECTS bwtools"
PROJECTS="$PROJECTS caldav"
PROJECTS="$PROJECTS caldavTest"
PROJECTS="$PROJECTS calendarapi"
PROJECTS="$PROJECTS contrib"
PROJECTS="$PROJECTS davutil"
PROJECTS="$PROJECTS dumprestore"
PROJECTS="$PROJECTS freebusy"
PROJECTS="$PROJECTS rpiutil"
PROJECTS="$PROJECTS synchml"
PROJECTS="$PROJECTS testsuite"
PROJECTS="$PROJECTS timezones"
PROJECTS="$PROJECTS webapps"
PROJECTS="$PROJECTS webdav"

SCTEMPDIR="${TMPDIR:=/tmp}/svncopydir$$"
SCTEMPFILE=$SCTEMPDIR/svncopy

mkdir $SCTEMPDIR

# Assure the file is removed at program termination
# or after we received a signal:
trap 'rm -rf "$SCTEMPDIR" >/dev/null 2>&1' 0
trap "exit 2" 1 2 3 15

for project in $PROJECTS
do
   copyproject "$project" "$TARGET" "$COMMENT"
done

svn co -N $SVNREPOSITORY/bedework/$TARGET $SCTEMPDIR/bedework
svn propset svn:externals -F $SCTEMPFILE $SCTEMPDIR/bedework
svn commit -N -m "Change externals to new copies" $SCTEMPDIR/bedework
#more $SCTEMPFILE