@echo off

:: Проверка на наличие файла обновления
if not exist "Updater.bat" (
  echo ERROR! Updater.bat not found!
  echo Please make sure Updater.bat is in the same folder.
  timeout /t 10 >nul
  exit /b 1
)

:: Проверка на наличие новой версии/билда
call Updater.bat
title Cleaner %ver% (build %build%)
if "%vern%"=="%ver%" goto menu
if not "%vern%"=="%ver%" (
	goto updm
)


:menu
cls
	echo.
	echo Cleaner
	echo.
	echo 1) KL Cleaner
	echo 2) Delete all unnecessary files of level 1 (Administrator rights required)
	echo 3) Delete all unnecessary files of level 2 (Administrator rights required)
	echo 4) Delete all unnecessary files of level 3 (Administrator rights required)
	echo 5) Info about cleaner
	echo 6) Check updates
	echo 7) Change log
	echo 0) Exit
	echo.
set /p optt=Select option: 
if "%optt%"=="1" (
	goto menukl
) else if "%optt%"=="2" (
	goto optt2
) else if "%optt%"=="3" (
	goto optt3
) else if "%optt%"=="4" (
	goto optt4
) else if "%optt%"=="5" (
	goto Info
) else if "%optt%"=="6" (
	goto upd
) else if "%optt%"=="0" (
	exit
) else if "%optt%"=="7" (
	goto cl
)


:menukl
cls
	echo.
	echo KL Cleaner - clean utility special for KLauncher
	echo.
	echo 1) Delete logs
	echo 2) Delete cache (Optimization memory)
	echo 3) Delete all empty folders
	echo 4) Delete KLauncher (REMOVE FULL KL INCLUDE ALL VERSION AND SAVES!!!)
	echo 5) Back
	echo 0) Exit
	echo.
set /p opt=Select option: 
if "%opt%"=="1" (
	goto opt1
) else if "%opt%"=="2" (
	goto opt2
) else if "%opt%"=="3" (
	goto opt3
) else if "%opt%"=="4" (
	goto opt4 
) else if "%opt%"=="5" (
	goto menu
) else if "%opt%"=="0" (
	exit
)


:optt2
cls
	echo.
	echo Removing all unnecessary files of level 1. Please wait...
	echo.
del /s /f /q "C:\Windows\Temp\*" 2>nul
del /s /f /q "C:\Windows\Prefetch\*" 2>nul
del /s /f /q "C:\Windows\LiveKernelReports\*" 2>nul
del /s /f /q "C:\Users\%USERNAME%\AppData\Local\Temp\*" 2>nul
del /s /f /q "C:\Users\%USERNAME%\AppData\Local\Microsoft\Windows\INetCache\*" 2>nul
del /s /f /q "C:\Users\%USERNAME%\AppData\Local\Microsoft\Windows\WebCache\*" 2>nul
del /s /f /q "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Recent\*" 2>nul
del /q /f /q "C:\ProgramData\Microsoft\Windows\WER\*" 2>nul

timeout /t 10 >nul
cls
	echo.
	echo Done!
	echo.
echo Teleporting to menu...
timeout /t 2 >nul
goto menu


:optt3
cls
echo.
echo This option will be available in the next update
echo (Or your version/build does not support this feature)

echo.
echo Teleporting to menu...
timeout /t 10 >nul
cls
goto menu


:optt4
cls
echo.
echo This option will be available in the next update
echo (Or your version/build does not support this feature)

echo.
echo Teleporting to menu...
timeout /t 10 >nul
cls
goto menu


:info
cls
echo.
echo Soon, sorry :(
echo.

echo Teleporting to menu...
timeout /t 3 >nul
cls
goto menu


:upd
cls
echo.
echo Checking updates...
echo.
timeout /t 2 >nul
if "%vern%"=="%ver%" (
	cls
	echo.
	echo No updates detected! You are using the latest version.
	echo.
	echo Teleporting to menu...
	timeout /t 3 >nul
	cls
	goto menu
)
if not "%vern%"=="%ver%" (
	goto updm
)


:updm
cls
echo.
echo A new update is available! We recommend installing it
set /p down=Press 1 to download or 2 to skip: 
if "%down%"=="1" (
	cls
	start "" "https://github.com/your-repo/releases"
	echo Opening updates page...
	timeout /t 3 >nul
	goto menu
) else if "%down%"=="2" goto menu


:cl
cls
echo.
echo Change log last version: %ver%
echo + Added option "Delete all unnecessary files of level 1"
echo + Added option "Delete all unnecessary files of level 2"
echo + Added option "Delete all unnecessary files of level 3"
echo + Added info about Cleaner
echo.
echo Change log last build: %build%
echo + Added info about Cleaner
echo = Fixed menu logic
echo.
echo.
echo Press ENTER to go to menu
pause >nul
goto menu


:opt1
cls
cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher\game\instances"

:: Setlocal
setlocal EnableDelayedExpansion
set count=0

:: Получаем папки
for /d %%i in (*) do (
  set /a count+=1
  set FOLDER!count!=%%i
)

:: Показываем список (отдельный цикл)
echo List profiles(game) versions
echo.
for /l %%i in (1,1,%count%) do (
  echo %%i. !FOLDER%%i!
)
echo.

:: Выбор папки
set /p SELECT_NUM=Select profile(game) version (1-%count%): 
if %SELECT_NUM% lss 1 goto opt1
if %SELECT_NUM% gtr %count% goto opt1
set SELECTED=!FOLDER%SELECT_NUM%!

:: Удаление логов
cls
cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher\game\instances\!SELECTED!"
rmdir /s /q logs 2>nul
echo Done! Logs has been deleted

echo.
echo Teleporting to menu...
timeout /t 3 >nul
endlocal
cls
goto menukl


:opt2
cls
cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher\game\instances"

:: Setlocal
setlocal EnableDelayedExpansion
set count=0

:: Получаем папки
for /d %%i in (*) do (
  set /a count+=1
  set FOLDER!count!=%%i
)

:: Показываем список (отдельный цикл)
echo List profiles(game) versions
echo.
for /l %%i in (1,1,%count%) do (
  echo %%i. !FOLDER%%i!
)
echo.

:: Выбор папки
set /p SELECT_NUM=Select profile(game) version (1-%count%): 
if %SELECT_NUM% lss 1 goto opt1
if %SELECT_NUM% gtr %count% goto opt1
set SELECTED=!FOLDER%SELECT_NUM%!

:: Удаление логов
cls
cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher\game\instances\!SELECTED!"
rmdir /s /q .bobby 2>nul
rmdir /s /q .cache 2>nul
rmdir /s /q .fabric 2>nul
rmdir /s /q crash-reports 2>nul
rmdir /s /q logs 2>nul
rmdir /s /q _IAS_ACCOUNTS_DO_NOT_SEND_TO_ANYONE 2>nul
rmdir /s /q debug 2>nul
echo Done! Cache has been deleted

echo.
echo Teleporting to menu...
timeout /t 3 >nul
endlocal
cls
goto menukl


:opt3
cls
cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher\game\instances"

:: Setlocal
setlocal EnableDelayedExpansion
set count=0

:: Получаем папки
for /d %%i in (*) do (
  set /a count+=1
  set FOLDER!count!=%%i
)

:: Показываем список (отдельный цикл)
echo List profiles(game) versions
echo.
for /l %%i in (1,1,%count%) do (
  echo %%i. !FOLDER%%i!
)
echo.

:: Выбор папки
set /p SELECT_NUM=Select profile(game) version (1-%count%): 
if %SELECT_NUM% lss 1 goto opt1
if %SELECT_NUM% gtr %count% goto opt1
set SELECTED=!FOLDER%SELECT_NUM%!

:: Удаление логов
cls
cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher\game\instances\!SELECTED!"
for /f "delims=" %%i in ('dir /ad/b/s ^| sort /r') do rd "%%i" 2>nul
echo Done! All empty folders been deleted

echo.
echo Teleporting to menu...
timeout /t 3 >nul
endlocal
cls
goto menukl


:opt4
cls
echo.
echo This option will be available in the next update, as it is considered dangerous!
echo (Or your version/build does not support this feature)

echo.
echo Teleporting to menu...
timeout /t 10 >nul
cls
goto menukl
