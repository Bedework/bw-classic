::  This file launches the quickstart script file "bedework\build\quickstart\windowsbw.bat" so that
::  we may keep taht script under version control in the svn repository.

@ECHO off
SETLOCAL

CMD /c build\quickstart\windows\bw %*%

