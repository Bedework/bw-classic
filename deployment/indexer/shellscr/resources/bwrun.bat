:: Run the bedework indexer program

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

SET RUNCMD="%JAVA_HOME%/bin/java" -cp %cp% org.bedework.indexer.BwIndexApp

SET APPNAME=indexer

ECHO.
ECHO.
ECHO   Bedework Database Tools
ECHO   -----------------------
ECHO.

:branch
  if "%1" == "reindex" GOTO reindex
  if "%1" == "start" GOTO start

:usage
  ECHO   Usage:
  ECHO.
  ECHO     reindex [(-ndebug | -debug)]
  ECHO        Reindex the system then process queue events
  ECHO.
  ECHO     start [(-ndebug | -debug)]
  ECHO        Process queue events
  ECHO.

  GOTO end


:reindex
  ECHO   Reindexing data:
  ECHO.
  ECHO   %RUNCMD% -appname %APPNAME% -reindex %2 %3 %4 %5 %6 %7 %8 %9
  %RUNCMD% -appname %APPNAME% -reindex %2 %3 %4 %5 %6 %7 %8 %9
  GOTO end
  ::
:start
  ECHO   Indexing data:
  ECHO.
  ECHO   %RUNCMD% -appname %APPNAME% -start %2 %3 %4 %5 %6 %7 %8 %9
  %RUNCMD% -appname %APPNAME% -start %2 %3 %4 %5 %6 %7 %8 %9
  GOTO end
  ::

:end
ECHO.
ECHO.
