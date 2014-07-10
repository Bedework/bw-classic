:: Run the bedework post build deployer program

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

SET RUNCMD="%JAVA_HOME%\bin\java" -cp %cp% edu.rpi.sss.util.deployment.ProcessEars

ECHO.

  ECHO   %RUNCMD% %2 %3 %4 %5 %6 %7 %8 %9
  %RUNCMD% %2 %3 %4 %5 %6 %7 %8 %9
ECHO.
ECHO.
