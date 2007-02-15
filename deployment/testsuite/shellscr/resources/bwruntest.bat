:: Run the bedework caldav test program

:: JAVA_HOME needs to be defined

@echo off
setlocal

if not "%JAVA_HOME%"=="" goto noJavaWarn
ECHO
ECHO
ECHO ***************************************************************************
ECHO          Warning: JAVA_HOME is not set - results unpredictable
ECHO ***************************************************************************
ECHO
ECHO
:noJavaWarn

SET cp=@CP@

SET RUNCMD="%JAVA_HOME%/bin/java" -cp %cp% @CALDAVTEST-CLASS@

SET APPNAME=@BW-APP-NAME@

ECHO.
ECHO.
ECHO   Bedework CalDAV test
ECHO   --------------------
ECHO.

  ECHO   %RUNCMD% %2 %3 %4 %5 %6 %7 %8 %9
  %DUMPCMD% %2 %3 %4 %5 %6 %7 %8 %9
ECHO.
ECHO.
