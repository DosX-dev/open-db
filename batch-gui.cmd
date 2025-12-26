@echo off

set cols=70
title  
mode con:cols=%cols% lines=6
color f0
set "sp="
for /l %%i in (1, 1, %cols%) do @ (
   call set "sp=%%sp%% "
)
call :colored 0 8 "%sp:~0,1%"
set "title_out=System message"
call :sizeof title_out
set /a "title_out_size=%errorlevel%+3"
call :colored 0 7 "%sp:~0,1%"
call :colored 8 7 "%title_out%"
call call :colored 0 7 "%%sp:~0,-%title_out_size%%%"
call :colored 0 8 " \n"
call :colored 0 f "  "
call :colored 8 f "Batch message box!!\n\n"
call :colored 0 f "%sp:~0,60%"
call :colored f 8 " CLOSE "

pause>nul

exit /b 0

:colored.box
set fore=%~1
set back=%~2
set text=%3
set box_size=%~4

call :colored %fore% %back% %text%

call :sizeof text
set text_size=%errorlevel%
set /a box_size=box_size-text_size+2

call call :colored %fore% %back% "%%sp:~0,%box_size%%%"

goto :eof

:: Colored-Batch (assembly module)
:colored
if "%~3" == "" (
   echo Incorrect arguments
)
set "modulePath=%temp%\colored_batch_module.com"
set "tempSourcePath=%temp%\%random%.tmp"
if not exist "%modulePath%" (
    set/p<nul="using System;namespace ColoredBatch{internal class Program{static void Main(string[] args){try{Console.ForegroundColor=(ConsoleColor)Convert.ToInt32(args[0],16);Console.BackgroundColor=(ConsoleColor)Convert.ToInt32(args[1],16);Console.Write(args[2].Replace("\\n","\n"));Console.ResetColor();Environment.Exit(0);}catch(Exception ex){Console.ResetColor();Console.WriteLine(ex.Message);Environment.Exit(1);}}}}">%tempSourcePath%
    "%windir%\Microsoft.NET\Framework\v4.0.30319\csc.exe" /out:"%modulePath%" "%tempSourcePath%" /nologo /debug- /optimize+
    if exist "%tempSourcePath%" del "%tempSourcePath%"
)
call %modulePath% %*
goto :eof

:: sizeof (native-batch module)
:sizeof
call set "sizeof.in=%%%~1%%"
set sizeof.in=%sizeof.in:"=_%
if ["%sizeof.in%"] == [""] EXIT/B 0
set /a sizeof.len=1
    :sizeof.tmp
        set "sizeof.in=%sizeof.in:~0,-1%"
        if ["%sizeof.in%"] == [""] (EXIT/B %sizeof.len%) else (
            set /a sizeof.len=sizeof.len + 1
            goto sizeof.tmp
        )