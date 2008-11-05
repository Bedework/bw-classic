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
  SET password=%4

  IF "%account%" == "help" GOTO usage
  IF "%account%" == "" GOTO errorUsage
  IF "%firstname%" == "" GOTO errorUsage
  IF "%lastname%" == "" GOTO errorUsage

  IF NOT "%JAVA_HOME%empty" == "empty" GOTO javaOk
  ECHO    *******************************************************
  ECHO    Error: JAVA_HOME is not defined correctly for Bedework.
  ECHO    *******************************************************
  GOTO usage

  IF NOT %password% == "" GOTO javaOk
  ECHO.
  ECHO    Password:
  SET /p password=
  ECHO    Reenter password:
  SET /p checkpassword=
  IF %password% == %checkpassword% GOTO javaOk
  ECHO    Passwords do not match
  GOTO:EOF

:javaOk
  SET CLASSPATH=%ANT_HOME%\lib\ant-launcher.jar
  SET ant_home_def=-Dant.home=%ANT_HOME%
  SET ant_class_def=org.apache.tools.ant.launch.Launcher

  SET adduser_defs=-Dorg.bedework.directory.account=%account%
  SET adduser_defs=%adduser_defs% -Dorg.bedework.directory.firstname=%firstname%
  SET adduser_defs=%adduser_defs% -Dorg.bedework.directory.lastname=%lastname%
  SET adduser_defs=%adduser_defs% -Dorg.bedework.directory.password=%password%
  "%JAVA_HOME%\bin\java" -classpath "%CLASSPATH%" %ant_home_def% %adduser_defs% %ant_class_def% addUser
  GOTO:EOF

:errorUsage
  ECHO    *********************************************************
  ECHO    Error: You must supply account, first name and last name.
  ECHO    *********************************************************

:usage
  ECHO.
  ECHO    Usage:
  ECHO.
  ECHO    %PRG% account firstname lastname [password]
  ECHO.
  ECHO    Invokes ant to build the Bedework tools then uses that tool to add
  ECHO    an account in the directory.
  ECHO.
  ECHO    firstname and lastname are required
  ECHO.
  ECHO    If the password is not supplied you will be prompted for the password.
  ECHO.
  ECHO.
