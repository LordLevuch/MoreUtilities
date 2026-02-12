@echo off
chcp 65001 >nul

:: Проверка прав администратора
echo.
echo. Запрос прав администратора...
net session >nul 2>&1
if %errorlevel% neq 0 (
	powershell -Command "Start-Process '%~f0' -Verb RunAs" >nul
	exit /b
)

:: Текущая версия
set "ver=1.4"
title More Utilities %ver%

:: Технические параметры
cls
set "pass=4242"

:: Предыдущая версия
setlocal EnableDelayedExpansion
for /f "tokens=1 delims=." %%a in ("!ver!") do set "before=%%a"
set "after=!ver:*.=!"
set /a "ver_d=%after%-1"
goto check_update


:check_update
curl -s "https://api.github.com/repos/LordLevuch/MoreUtilities/releases/latest" > temp_release.json 2>nul

for /f "tokens=2 delims=:," %%a in ('findstr "tag_name" temp_release.json') do set "LATEST_VER=%%a"
set "LATEST_VER=%LATEST_VER: =%"
set "LATEST_VER=%LATEST_VER:"=%"

del temp_release.json 2>nul

if "%LATEST_VER%"=="" (
  cls
  echo.
  echo. ERROR! Нет подключения к GitHub. Невозможно проверить наличие обновлений
  echo. Код ошибки: 1
  echo.
  echo. Нажмите ENTER, чтобы открыть меню
  pause >nul
  goto menu
)

if "%ver%"=="%LATEST_VER%" (
  goto menu
) else if not "%ver%"=="%LATEST_VER%" (
  echo.
  echo. Вышло новое обновление: %LATEST_VER%
  echo. Ваша версия: %ver%
  choice /c YN /n /m "Хотите скачать новую версию? [Y/N]: "
  if errorlevel 2 goto menu
  if errorlevel 1 goto gitdown
)


:gitdown
start "" "https://github.com/LordLevuch/MoreUtilities/releases/latest"
exit


:upd
cls
curl -s "https://api.github.com/repos/LordLevuch/MoreUtilities/releases/latest" > temp_release.json 2>nul

for /f "tokens=2 delims=:," %%a in ('findstr "tag_name" temp_release.json') do set "LATEST_VER=%%a"
set "LATEST_VER=%LATEST_VER: =%"
set "LATEST_VER=%LATEST_VER:"=%"

del temp_release.json 2>nul

if "%LATEST_VER%"=="" (
  cls
  echo.
  echo. ERROR! Нет подключения к GitHub. Невозможно проверить наличие обновлений
  echo. Код ошибки: 1
  echo. Нажмите ENTER, чтобы открыть меню
  pause >nul
  goto menu
)

if "%ver%"=="%LATEST_VER%" (
  echo.
  echo. Вы пользуетесь самой новой версией!
  echo.
  echo. Телепортация в меню...
  timeout /t 3 >nul
  goto menu
) else if not "%ver%"=="%LATEST_VER%" (
  echo.
  echo. Вышло новое обновление: %LATEST_VER%
  echo. Ваша версия: %ver%
  choice /c YN /n /m "Хотите скачать новую версию? [Y/N]: "
  if errorlevel 2 goto menu
  if errorlevel 1 goto gitdown
)


:menu
cls
	echo.
	echo. More Utilities
	echo.
	echo. 1) KL Cleaner
	echo. 2) Cleaner
	echo. 3) Прочие утилиты
	echo. 4) Информация об утилите
	echo. 5) Проверить обновления
	echo. 6) Последние изменения
	echo. 0) Выход
	echo.
set /p menuc=Выбери опцию: 
if "%menuc%"=="1" (
	goto menukl
) else if "%menuc%"=="2" (
	goto cleaner
) else if "%menuc%"=="3" (
	goto uti
) else if "%menuc%"=="4" (
	goto info
) else if "%menuc%"=="5" (
	goto upd
) else if "%menuc%"=="6" (
	goto cl
) else if "%menuc%"=="0" (
	exit
) else (
	goto menu
)


:menukl
cls
	echo.
	echo. KL Cleaner - отчищающая утилита специально для KLauncher
	echo.
	echo. 1) Удалить логи
	echo. 2) Удалить ненужный кэш (Оптимизация памяти)
	echo. 3) Удалить все пустые папки
	echo. 4) Удалить KLauncher (УДАЛЯЕТ KL ПОЛНОСТЬЮ, ВКЛЮЧАЯ ВЕРСИИ И ВСЕ СОХРАНЕНИЯ!!!)
	echo. 5) Назад
	echo. 0) Выход
	echo.
set /p opt=Выберите опцию: 
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
) else (
	goto menukl
)


:cleaner
cls
	echo.
	echo. Cleaner - отчищающая утилита
	echo.
	echo. 1) Удалить все временные файлы
	echo. 2) Воспользоваться спеиальной программой (Скоро)
	echo. 3) Назад
	echo. 0) Выход
	echo.
set /p cleanc=Выберите опцию: 
if "%cleanc%"=="1" (
	goto cleanc1
) else if "%cleanc%"=="2" (
	REM goto cleanc2
	goto testmode
) else if "%cleanc%"=="3" (
	goto menu
) else if "%cleanc%"=="0" (
	exit
) else (
	goto cleaner
)


:uti
cls
	echo.
	echo. Прочие утилиты
	echo.
	echo. 1) Управление диспетчером задач
	echo. 2) Сбросить и отчистить IP адрес
	echo. 3) (Скоро)
	echo. 4) (Скоро)
	echo. 5) Назад
	echo. 0) Выход
	echo.
set /p ut=Выберите опцию: 
if "%ut%"=="1" (
	goto ut1
) else if "%ut%"=="2" (
	goto ut2
) else if "%ut%"=="3" (
	REM goto ut3
	goto testmode
) else if "%ut%"=="4" (
	REM goto ut4
	goto testmode
) else if "%ut%"=="5" (
	goto menu
) else if "%ut%"=="0" (
	exit
) else (
	goto uti
)


:ut1
cls
setlocal EnableDelayedExpansion
set "tmgr=none"

:: Определение DisableTaskMgr
for /f "skip=2 tokens=3" %%A in ('
  reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" ^
      /v DisableTaskMgr 2^>nul
') do (
  set "check_tmgr=%%A"
)

:: Установка переменных
if not defined check_tmgr (
    set "tmgr=Включен"
) else (
    if "!check_tmgr!"=="0x0" (
        set "tmgr=Включен"
    ) else (
        set "tmgr=Выключен"
    )
)

echo.
echo. Ваш диспетчер задач: !tmgr!
echo.
echo. 1) Включить
echo. 2) Выключить
echo. 3) Назад
echo.
set /p tmgr_c=Выберите опцию: 
if "%tmgr_c%"=="1" (
	if "%tmgr%"=="Включен" (
		cls
		echo.
		echo. Ваш диспетчер задач уже включен
		echo.
		echo. Нажмите ENTER, чтобы вернуться обратно
		pause >nul
		goto ut1
	) else if "%tmgr%"=="Выключен" (
		reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 0 /f
		cls
		echo.
		echo. Диспетчер задач успешно включен
		echo.
		echo. Нажмите ENTER, чтобы вернуться обратно
		pause >nul
		goto ut1
	)
) else if "%tmgr_c%"=="2" (
	if "%tmgr%"=="Выключен" (
		cls
		echo.
		echo. Ваш диспетчер задач уже выключен
		echo.
		echo. Нажмите ENTER, чтобы вернуться обратно
		pause >nul
		goto ut1
	) else if "%tmgr%"=="Включен" (
		reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f
		cls
		echo.
		echo. Диспетчер задач успешно выключен
		echo.
		echo. Нажмите ENTER, чтобы вернуться обратно
		pause >nul
		goto ut1
	)
) else if "%tmgr_c%"=="3" (
	goto uti
) else (
	goto ut1
)
endlocal


:ut2
cls
echo.
echo. Нажмите ENTER, чтобы сбросить свой IP адрес и отчистить кэш сети
pause >nul

cls
setlocal EnableDelayedExpansion
for /f "tokens=*" %%i in ('curl ifconfig.me 2^>nul') do set "myip=%%i"

echo. Сброс и отчистка вашего IP адреса... (%myip%)
	ipconfig /release >nul
	ipconfig /flushdns >nul
	ipconfig /renew >nul
	netsh interface ip delete arpcache >nul
	netsh winsock reset >nul
	netsh int ip reset >nul
	timeout /t 5 >nul

cls
echo.
echo. Ваш IP адрес был сброшен и отчищен!
echo. (Для корректной работы советуется перезагрузить ПК, но это не обязательно)
echo.
echo. Телепортация в меню...
timeout /t 3 >nul
cls
goto uti


:ut3
cls


:ut4
cls


:cleanc1
cls
	echo.
	echo. Удаляю все временные файлы. Пожалуйста подождите...
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
	echo. Готово! Все временные файлы успешно удалены!
	echo.
echo. Телепортация в меню...
timeout /t 2 >nul
goto menu


:opt1
cls
cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher\game\instances"

setlocal EnableDelayedExpansion
set count=0

:: Получаем папки
for /d %%i in (*) do (
  set /a count+=1
  set FOLDER!count!=%%i
)

:: Показываем список
echo. Список profiles(game) версий
echo.
for /l %%i in (1,1,%count%) do (
  echo %%i. !FOLDER%%i!
)
echo.

:: Выбор папки
set /p SELECT_NUM=Выберите profile(game) версию (1-%count%): 
if %SELECT_NUM% lss 1 goto opt1
if %SELECT_NUM% gtr %count% goto opt1
set SELECTED=!FOLDER%SELECT_NUM%!

:: Удаление логов
cls
cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher\game\instances\!SELECTED!"
rmdir /s /q logs 2>nul
echo.
echo. Готово! Логи были успешно удалены

echo.
echo. Телепортация в меню...
timeout /t 3 >nul
endlocal
cls
goto menukl


:opt2
cls
cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher\game\instances"

setlocal EnableDelayedExpansion
set count=0

:: Получаем папки
for /d %%i in (*) do (
  set /a count+=1
  set FOLDER!count!=%%i
)

:: Показываем список
echo. Список profiles(game) версий
echo.
for /l %%i in (1,1,%count%) do (
  echo %%i. !FOLDER%%i!
)
echo.

:: Выбор папки
set /p SELECT_NUM=Выберите profile(game) версию (1-%count%): 
if %SELECT_NUM% lss 1 goto opt1
if %SELECT_NUM% gtr %count% goto opt1
set SELECTED=!FOLDER%SELECT_NUM%!

:: Удаление кэша
cls
cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher\game\instances\!SELECTED!"
rmdir /s /q .bobby 2>nul
rmdir /s /q .cache 2>nul
rmdir /s /q .fabric 2>nul
rmdir /s /q crash-reports 2>nul
rmdir /s /q logs 2>nul
rmdir /s /q _IAS_ACCOUNTS_DO_NOT_SEND_TO_ANYONE 2>nul
rmdir /s /q debug 2>nul
echo.
echo. Готово! Кэш был успешно удален

echo.
echo. Телепортация в меню...
timeout /t 3 >nul
endlocal
cls
goto menukl


:opt3
cls
cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher\game\instances"

setlocal EnableDelayedExpansion
set count=0

:: Получаем папки
for /d %%i in (*) do (
  set /a count+=1
  set FOLDER!count!=%%i
)

:: Показываем список
echo. Список profiles(game) версий
echo.
for /l %%i in (1,1,%count%) do (
  echo %%i. !FOLDER%%i!
)
echo.

:: Выбор папки
set /p SELECT_NUM=Выберите profile(game) версию (1-%count%): 
if %SELECT_NUM% lss 1 goto opt1
if %SELECT_NUM% gtr %count% goto opt1
set SELECTED=!FOLDER%SELECT_NUM%!

:: Удаление пустыъ папок
cls
cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher\game\instances\!SELECTED!"
for /f "delims=" %%i in ('dir /ad/b/s ^| sort /r') do rd "%%i" 2>nul
echo.
echo. Готово! Все пустые папки были удалены

echo.
echo. Телепортация в меню...
timeout /t 3 >nul
endlocal
cls
goto menukl


:opt4
cls
echo.
echo. Это действие полностью удалит KLauncher с компьютера
echo. Включая все файлы сохранений, версии, текстуры и сам лаунчер с его настройками!!!
echo.
choice /c YN /n /m "Удалить KL? [Y/N]: "
  if errorlevel 2 goto menukl
  if errorlevel 1 (
	cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher"
	rmdir /s /q "C:\Users\%USERNAME%\AppData\Roaming\KLauncher" 2>nul
	cd "C:\Users\%USERNAME%\AppData\Roaming\.minecraft"
	rmdir /s /q "C:\Users\%USERNAME%\AppData\Roaming\KLauncher" 2?nul
	)
cls
echo.
echo. Готово! KL был успешно удален
echo.
echo. Телепортация в меню...
timeout /t 3 >nul
cls
goto menukl


:info
cls
echo.
echo. Эта утилита создана для отчистки определённых файлов Windows для оптимизации
echo. Так же утилита предоставляет возможность удалить ненужные файлы KLauncher'а
echo. Ещё в утилите есть дополнительные опции во вкладве "Прочие утилиты" и не только
echo. Некоторые опции вызыввают отдельные программы для отчистки
echo.
echo. Коды ошибок:
echo. 1 - Проверьте подключение к интернету или сайту GitHub
echo.
echo. Автор: LordLevuch
echo. Версия: %ver%
echo.

echo. Нажмите ENTER, чтобы вернуться в меню
pause >nul
cls
goto menu


:cl
cls
echo.
echo. Последние изменения для версии: %ver%
echo.
echo. + Программа переименована из Cleaner в More Utilities
echo. + Теперь для запуска утилиты требуются права администратора
echo. + Добавлена новая вкладка "Прочие утилиты"
echo. + Добавлена опция "Управление диспетчером задач" в Прочие утилиты
echo. = Опция "Сбросить и отчистить IP адрес" была перенесена в Прочие утилиты
echo. = Cleaner перенесен в отдельную вкладку
echo. = Обновлена информация для описания утилиты
echo. = Исправление работы логики сброса и отчистки IP адреса
echo. = Мелкие исправления и оптимизация
echo.
echo.
echo Изменение в предыдущей версии: 1.%ver_d%
echo.
echo. + Добавлена информация об кодах ошибок
echo. + Добавлена возможность сбросить и отчистить кэш на своем IP адресе
echo. + Обновлена информация для описания утилиты
echo. = Мелкие исправления и оптимизация
echo. - Удалена опция "Удалить все пустые папки, ненужные файлы и т.п."
echo.
echo.
echo. Нажмите ENTER, чтобы вернуться в меню
pause >nul
goto menu


:testmode
cls
echo.
echo. Эта опция будет доступна в следующих обновлениях!
echo. (Или же она не поддерживает вашу версию, проверьте на наличие обновлений)
echo.
set /p "testmode=Нажмите ENTER, чтобы вернуться в меню "
if "%testmode%"=="%pass%" (
	cls
	echo.
	echo. Test Mode activated
	echo.
	echo. Test version: 1.%after%
	echo. Latest version: %LATEST_VER%
	echo.
	echo. menuc3
	echo. Эта опция должна вызывать программу Glary Utilitis если она есть на ПК
	echo. Если нет, то зайти на сайт и попросить скачать её
	echo.
	echo. ut3
	echo. Нет сведений
	echo.
	echo. ut4
	echo. Нет сведений
	pause >nul
	goto menu
) else if not "%testmode%"=="%pass%" (
	goto menu
)
