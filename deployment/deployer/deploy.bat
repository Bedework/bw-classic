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

SET cp=

FOR /f %%i IN ('dir /b rpiutil\lib\*.jar') DO SET cp=%cp%;.\rpiutil\lib\%%i

FOR /f %%i IN ('dir /b rpiutil\dist\*.jar') DO SET cp=%cp%;.\rpiutil\dist\%%i

SET RUNCMD="%JAVA_HOME%\bin\java" -cp %cp% org.bedework.util.deployment.Runnable

ECHO.

:: ECHO   %RUNCMD% %2 %3 %4 %5 %6 %7 %8 %9
%RUNCMD% %2 %3 %4 %5 %6 %7 %8 %9

ECHO.
