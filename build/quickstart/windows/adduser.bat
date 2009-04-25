::  This file is included by the quickstart script file "addgroupmember.bat"
::  so that we may keep this script under version control in the svn repository.

@ECHO off
SETLOCAL

  ECHO.
  ECHO.
  ECHO   Bedework Calendar System
  ECHO   ------------------------
  ECHO.

  SET PRG=%0
  SET saveddir=%CD%
  SET QUICKSTART_HOME=%saveddir%
  SET ANT_HOME=%QUICKSTART_HOME%\apache-ant-1.7.0

  SET account=%1
  SET firstname=%2
  SET lastname=%3
  set caladdr=%4
  SET password=%5

  IF "%account%" == "help" GOTO usage
  IF "%account%empty" == "empty" GOTO errorUsage
  IF "%firstname%empty" == "empty" GOTO errorUsage
  IF "%lastname%empty" == "empty" GOTO errorUsage
  IF "%caladdr%empty" == "empty" GOTO errorUsage
  IF "%password%empty" == "empty" GOTO errorUsage

  IF NOT "%JAVA_HOME%empty" == "empty" GOTO javaOk
  ECHO    *******************************************************
  ECHO    Error: JAVA_HOME is not defined correctly for Bedework.
  ECHO    *******************************************************
  GOTO usage

:javaOk
  SET CLASSPATH=%ANT_HOME%\lib\ant-launcher.jar
  SET ant_home_def=-Dant.home=%ANT_HOME%
  SET ant_class_def=org.apache.tools.ant.launch.Launcher

  SET adduser_defs=-Dorg.bedework.directory.account=%account%
  SET adduser_defs=%adduser_defs% -Dorg.bedework.directory.firstname=%firstname%
  SET adduser_defs=%adduser_defs% -Dorg.bedework.directory.lastname=%lastname%
  SET adduser_defs=%adduser_defs% -Dorg.bedework.directory.caladdr=%caladdr%
  SET adduser_defs=%adduser_defs% -Dorg.bedework.directory.password=%password%
  "%JAVA_HOME%\bin\java" -classpath "%CLASSPATH%" "%ant_home_def%" %adduser_defs% "%ant_class_def%" addUser
  GOTO:EOF

:errorUsage
  ECHO    *******************************************************************************
  ECHO    Error: You must supply account, first name, last name, caladdress, and password.
  ECHO    *******************************************************************************

:usage
  ECHO.
  ECHO    Usage:
  ECHO    %PRG% account firstname lastname caladdr password
  ECHO.
  ECHO    Invokes ant to build the Bedework tools then uses that tool to add
  ECHO    an account in the directory.
  ECHO.
  ECHO    firstname, lastname, caladdr*, and password are required
  ECHO.   *(caladdr is the calendar address, which at this time is
  ECHO.     typically an email address)
  ECHO.
  ECHO.
