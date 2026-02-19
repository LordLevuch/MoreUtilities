@echo off
chcp 65001 >nul

net session >nul 2>&1
if %errorlevel% neq 0 (
	echo.
	echo. Запрос прав администратора...
	powershell -Command "Start-Process '%~f0' -Verb RunAs" >nul
	exit /b
)

REM ====================================================================
REM 					  Технические параметры
REM ====================================================================

set "ver=1.5"
title More Utilities v%ver%
cls
set count=0
set menu_active=false
set log_check_enable=Выключено
set beta_mode_enable=Выключено
set "beta_view= "
set "java_path=C:\Program Files\Java\jdk-17\bin"
set default_menu=menu
set "git_ver=https://api.github.com/repos/LordLevuch/MoreUtilities/releases/latest"
set "git_down=https://github.com/LordLevuch/MoreUtilities/releases/latest"

REM ====================================================================
REM 							  Версии
REM ====================================================================

setlocal EnableDelayedExpansion
for /f "tokens=1 delims=." %%a in ("!ver!") do set "before=%%a"
set "after=!ver:*.=!"
set /a "ver_d=%after%-1"

curl -s "%git_ver%" > temp_release.json 2>nul
for /f "tokens=2 delims=:," %%a in ('findstr "tag_name" temp_release.json') do set "LATEST_VER=%%a"
set "LATEST_VER=%LATEST_VER: =%"
set "LATEST_VER=%LATEST_VER:"=%"
del temp_release.json 2>nul


goto check_update

REM ====================================================================
REM 							ОБНОВЛЕНИЯ
REM ====================================================================

:check_update
cls
if "%LATEST_VER%"=="" (
	set error=1
    goto error
)

if "%menu_active%"=="true" (
	if "%ver%"=="%LATEST_VER%" (
		echo.
		echo. Вы пользуетесь самой новой версией!
		echo.
		echo. Телепортация в меню...
		timeout /t 3 >nul
		goto %default_menu%
	) else if not "%ver%"=="%LATEST_VER%" (
		echo.
		echo. Вышло новое обновление: %LATEST_VER%
		echo. Ваша версия: %ver%
		choice /c YN /n /m "Хотите скачать новую версию? [Y/N]: "
		if errorlevel 2 goto %default_menu%
		if errorlevel 1 (
			start "" "%git_down%"
			exit
		)
	)
) else if "%menu_active%"=="false" (
	if "%ver%"=="%LATEST_VER%" (
		goto %default_menu%
	) else if not "%ver%"=="%LATEST_VER%" (
		echo.
		echo. Вышло новое обновление: %LATEST_VER%
		echo. Ваша версия: %ver%
		choice /c YN /n /m "Хотите скачать новую версию? [Y/N]: "
		if errorlevel 2 goto %default_menu%
		if errorlevel 1 (
			start "" "%git_down%"
			exit
		)
	)
)

REM ====================================================================
REM 							   МЕНЮ
REM ====================================================================

:menu
call :menu_active_check
cls
	echo.
	echo. More Utilities v%ver% %beta_view%
	echo.
	echo. ========= MC Utility =========
	echo. 1) Удалить логи
	echo. 2) Удалить ненужный кэш
	echo. 3) Удалить все пустые папки
	echo. 4) Удалить KLauncher
	echo.
	echo. ======= Прочие утилиты =======
	echo. 5) Удалить все временные файлы Windows
	echo. 6) Переключение диспетчера задач
	echo. 7) Сбросить и отчистить IP адрес
	echo.
	echo. ===== Другие возможности =====
	echo. 8) Информация об утилите
	echo. 9) Проверить обновления
	echo. 10) Последние изменения
	echo. 11) Настройки
	echo.
	echo. ------------------------------
	echo. 0) Выход
	echo.

set /p menu_choice=Выбери опцию: 
if "%menu_choice%"=="1" set "mccleaner_choice=1" & goto launcher_choice
if "%menu_choice%"=="2" set "mccleaner_choice=2" & goto launcher_choice
if "%menu_choice%"=="3" set "mccleaner_choice=3" & goto launcher_choice
if "%menu_choice%"=="4" goto kl_delete
if "%menu_choice%"=="5" goto win_cache_clear
if "%menu_choice%"=="6" goto tmgr_switcher
if "%menu_choice%"=="7" goto ip_clear
if "%menu_choice%"=="8" goto info
if "%menu_choice%"=="9" goto check_update
if "%menu_choice%"=="10" goto cl
if "%menu_choice%"=="11" goto settings
if "%menu_choice%"=="0" exit /b
goto %default_menu%


:menu_beta
call :menu_active_check
cls
	echo.
	echo. More Utilities v%ver% %beta_view%
	echo.
	echo. ========= MC Utility =========
	echo. 1) Удалить логи
	echo. 2) Удалить ненужный кэш
	echo. 3) Удалить все пустые папки
	echo. 4) Удалить KLauncher
	echo. 5) Создать пустой локальный сервер (BETA)
	echo.
	echo. ======= Прочие утилиты =======
	echo. 6) Удалить все временные файлы Windows
	echo. 7) Переключение диспетчера задач
	echo. 8) Сбросить и отчистить IP адрес
	echo.
	echo. ===== Другие возможности =====
	echo. 9) Информация об утилите
	echo. 10) Проверить обновления
	echo. 11) Последние изменения
	echo. 12) Настройки
	echo.
	echo. ------------------------------
	echo. 0) Выход
	echo.

set /p menu_choice=Выбери опцию: 
if "%menu_choice%"=="1" set "mccleaner_choice=1" & goto launcher_choice
if "%menu_choice%"=="2" set "mccleaner_choice=2" & goto launcher_choice
if "%menu_choice%"=="3" set "mccleaner_choice=3" & goto launcher_choice
if "%menu_choice%"=="4" goto kl_delete
if "%menu_choice%"=="5" goto serv_core_choice
if "%menu_choice%"=="6" goto win_cache_clear
if "%menu_choice%"=="7" goto tmgr_switcher
if "%menu_choice%"=="8" goto ip_clear
if "%menu_choice%"=="9" goto info
if "%menu_choice%"=="10" goto check_update
if "%menu_choice%"=="11" goto cl
if "%menu_choice%"=="12" goto settings
if "%menu_choice%"=="0" exit /b
goto %default_menu%


:settings
cls
	echo.
	echo. More Utilities v%ver% %beta_view%
	echo.
	echo. ===== Настройки утилиты ======
	echo.
	echo. 1) Логирование (%log_check_enable%)
	echo. 2) BETA-mode (%beta_mode_enable%)
	echo. 3) Назад
	echo.
	echo. ------------------------------
	echo. 0) Выход
	echo.
set /p settings_choice=Выберите параметр, чтобы переключить его: 
if "%settings_choice%"== "1" (
	call :log_switch
	goto settings
) else if "%settings_choice%"=="2" (
	call :beta_mode_switch
	goto settings
) else if "%settings_choice%"=="3" (
	goto %default_menu%
) else if "%settings_choice%"=="0" (
	exit /b
) else (
	goto settings
)

REM ====================================================================
REM 				       Создание MC сервера (BETA)
REM ====================================================================

:serv_core_choice
cls
	echo.
	echo. More Utilities v%ver% %beta_view%
	echo.
	echo. ============ Ядро ============
	echo. 1) Vanilla
	echo. 2) Forge (Скоро)
	echo. 3) Fabric (Скоро)
	echo. 4) Paper/Bukkit (Скоро)
	echo.
	echo. 0) Назад
	echo.
set /p serv_core_choice=Выберите ядро сервера: 
if "%serv_core_choice%"=="1" (
	set serv_core=vanilla
	goto serv_ver_menu_choice
) else if "%serv_core_choice%"=="2" (
	REM set serv_core=forge
	REM goto serv_ver_menu_choice
	goto serv_core_choice
) else if "%serv_core_choice%"=="3" (
	REM set serv_core=fabric
	REM goto serv_ver_menu_choice
	goto serv_core_choice
) else if "%serv_core_choice%"=="4" (
	REM set serv_core=paper
	REM goto serv_ver_menu_choice
	goto serv_core_choice
) else if "%serv_core_choice%"=="0" (
	goto %default_menu%
) else (
	goto serv_core_choice
)


:serv_ver_menu_choice
cls
	echo.
	echo. More Utilities v%ver% %beta_view%
	echo.
	echo. =========== Версия ===========
	echo.
	echo. 1) Показать последние релизы версий
	echo. 2) Показать основные версии для серверов
	echo. 3) Показать все версии
	echo.
	echo. 0) Назад
	echo.
set /p serv_ver_menu_choice=Выберите какие версии показать: 
if "%serv_ver_menu_choice%"=="1" (
	goto serv_ver_choice_last_releases
) else if "%serv_ver_menu_choice%"=="2" (
	goto serv_ver_choice_base
) else if "%serv_ver_menu_choice%"=="3" (
	goto serv_ver_choice_all
) else if "%serv_ver_menu_choice%"=="0" (
	goto serv_core_choice
) else (
	goto serv_ver_menu_choice
)


:serv_ver_choice_last_releases
cls
	echo.
	echo. More Utilities v%ver% %beta_view%
	echo.
	echo. =========== Версия ===========
	echo.
	echo. 1) 1.21.11
	echo. 2) 1.20.6
	echo. 3) 1.19.4
	echo. 4) 1.18.2
	echo. 5) 1.17.1
	echo. 6) 1.16.5
	echo. 7) 1.15.2
	echo. 8) 1.14.4
	echo. 9) 1.13.2
	echo. 10) 1.12.2
	echo. 11) 1.11.2
	echo. 12) 1.10.2
	echo. 13) 1.9.4
	echo. 14) 1.8.9
	echo.
	echo. 0) Назад
	echo.
set /p serv_ver_choice=Выберите версию сервера: 
if "%serv_ver_choice%"=="1" (
	set serv_ver=1.21.11
	goto serv_path_set
) else if "%serv_ver_choice%"=="2" (
	set serv_ver=1.20.6
	goto serv_path_set
) else if "%serv_ver_choice%"=="3" (
	set serv_ver=1.19.4
	goto serv_path_set
) else if "%serv_ver_choice%"=="4" (
	set serv_ver=1.18.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="5" (
	set serv_ver=1.17.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="6" (
	set serv_ver=1.16.5
	goto serv_path_set
) else if "%serv_ver_choice%"=="7" (
	set serv_ver=1.15.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="8" (
	set serv_ver=1.14.4
	goto serv_path_set
) else if "%serv_ver_choice%"=="9" (
	set serv_ver=1.13.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="10" (
	set serv_ver=1.12.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="11" (
	set serv_ver=1.11.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="12" (
	set serv_ver=1.10.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="13" (
	set serv_ver=1.9.4
	goto serv_path_set
) else if "%serv_ver_choice%"=="14" (
	set serv_ver=1.8.9
	goto serv_path_set
) else if "%serv_ver_choice%"=="0" (
	goto serv_ver_menu_choice
) else (
	goto serv_ver_choice_last_releases
)


:serv_ver_choice_base
cls
	echo.
	echo. More Utilities v%ver% %beta_view%
	echo.
	echo. =========== Версия ===========
	echo.
	echo. 1) 1.21.1
	echo. 2) 1.20.1
	echo. 3) 1.19.4
	echo. 4) 1.18.2
	echo. 5) 1.16.5
	echo. 6) 1.14.4
	echo. 7) 1.12.2
	echo. 8) 1.8.9
	echo.
	echo. 0) Назад
	echo.
set /p serv_ver_choice=Выберите версию сервера: 
if "%serv_ver_choice%"=="1" (
	set serv_ver=1.21.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="2" (
	set serv_ver=1.20.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="3" (
	set serv_ver=1.19.4
	goto serv_path_set
) else if "%serv_ver_choice%"=="4" (
	set serv_ver=1.18.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="5" (
	set serv_ver=1.16.5
	goto serv_path_set
) else if "%serv_ver_choice%"=="6" (
	set serv_ver=1.14.4
	goto serv_path_set
) else if "%serv_ver_choice%"=="7" (
	set serv_ver=1.12.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="8" (
	set serv_ver=1.8.9
	goto serv_path_set
) else if "%serv_ver_choice%"=="0" (
	goto serv_ver_menu_choice
) else (
	goto serv_ver_choice_base
)


:serv_ver_choice_all
cls
	echo.
	echo. More Utilities v%ver% %beta_view%
	echo.
	echo. =========== Версия ===========
	echo.
	echo. 1) 1.21.11
	echo. 2) 1.21.10
	echo. 3) 1.21.9
	echo. 4) 1.21.8
	echo. 5) 1.21.7
	echo. 6) 1.21.6
	echo. 7) 1.21.5
	echo. 8) 1.21.4
	echo. 9) 1.21.3
	echo. 10) 1.21.2
	echo. 11) 1.21.1
	echo. 12) 1.21
	echo. 13) 1.20.6
	echo. 14) 1.20.5
	echo. 15) 1.20.4
	echo. 16) 1.20.3
	echo. 17) 1.20.2
	echo. 18) 1.20.1
	echo. 19) 1.20
	echo. 20) 1.19.4
	echo. 21) 1.19.3
	echo. 22) 1.19.2
	echo. 23) 1.19.1
	echo. 24) 1.19
	echo. 25) 1.18.2
	echo. 26) 1.18.1
	echo. 27) 1.18
	echo. 28) 1.17.1
	echo. 29) 1.17
	echo. 30) 1.16.5
	echo. 31) 1.16.4
	echo. 32) 1.16.3
	echo. 33) 1.16.2
	echo. 34) 1.16.1
	echo. 35) 1.16
	echo. 36) 1.15.2
	echo. 37) 1.15.1
	echo. 38) 1.15
	echo. 39) 1.14.4
	echo. 40) 1.14.3
	echo. 41) 1.14.2
	echo. 42) 1.14.1
	echo. 43) 1.14
	echo. 44) 1.13.2
	echo. 45) 1.13.1
	echo. 46) 1.13
	echo. 47) 1.12.2
	echo. 48) 1.12.1
	echo. 49) 1.12
	echo. 50) 1.11.2
	echo. 51) 1.11.1
	echo. 52) 1.11
	echo. 53) 1.10.2
	echo. 54) 1.10.1
	echo. 55) 1.10
	echo. 56) 1.9.4
	echo. 57) 1.9.3
	echo. 58) 1.9.2
	echo. 59) 1.9.1
	echo. 60) 1.9
	echo. 61) 1.8.9
	echo. 62) 1.8.8
	echo. 63) 1.8.7
	echo. 64) 1.8.6
	echo. 65) 1.8.5
	echo. 66) 1.8.4
	echo. 67) 1.8.3
	echo. 68) 1.8.2
	echo. 69) 1.8.1
	echo. 70) 1.8
	echo.
	echo. 0) Назад
	echo.
set /p serv_ver_choice=Выберите версию сервера: 
if "%serv_ver_choice%"=="1" (
	set serv_ver=1.21.11
	goto serv_path_set
) else if "%serv_ver_choice%"=="2" (
	set serv_ver=1.21.10
	goto serv_path_set
) else if "%serv_ver_choice%"=="3" (
	set serv_ver=1.21.9
	goto serv_path_set
) else if "%serv_ver_choice%"=="4" (
	set serv_ver=1.21.8
	goto serv_path_set
) else if "%serv_ver_choice%"=="5" (
	set serv_ver=1.21.7
	goto serv_path_set
) else if "%serv_ver_choice%"=="6" (
	set serv_ver=1.21.6
	goto serv_path_set
) else if "%serv_ver_choice%"=="7" (
	set serv_ver=1.21.5
	goto serv_path_set
) else if "%serv_ver_choice%"=="8" (
	set serv_ver=1.21.4
	goto serv_path_set
) else if "%serv_ver_choice%"=="9" (
	set serv_ver=1.21.3
	goto serv_path_set
) else if "%serv_ver_choice%"=="10" (
	set serv_ver=1.21.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="11" (
	set serv_ver=1.21.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="12" (
	set serv_ver=1.21
	goto serv_path_set
) else if "%serv_ver_choice%"=="13" (
	set serv_ver=1.20.6
	goto serv_path_set
) else if "%serv_ver_choice%"=="14" (
	set serv_ver=1.20.5
	goto serv_path_set
) else if "%serv_ver_choice%"=="15" (
	set serv_ver=1.20.4
	goto serv_path_set
) else if "%serv_ver_choice%"=="16" (
	set serv_ver=1.20.3
	goto serv_path_set
) else if "%serv_ver_choice%"=="17" (
	set serv_ver=1.20.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="18" (
	set serv_ver=1.20.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="19" (
	set serv_ver=1.20
	goto serv_path_set
) else if "%serv_ver_choice%"=="20" (
	set serv_ver=1.19.4
	goto serv_path_set
) else if "%serv_ver_choice%"=="21" (
	set serv_ver=1.19.3
	goto serv_path_set
) else if "%serv_ver_choice%"=="22" (
	set serv_ver=1.19.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="23" (
	set serv_ver=1.19.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="24" (
	set serv_ver=1.19
	goto serv_path_set
) else if "%serv_ver_choice%"=="25" (
	set serv_ver=1.18.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="26" (
	set serv_ver=1.18.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="27" (
	set serv_ver=1.18
	goto serv_path_set
) else if "%serv_ver_choice%"=="28" (
	set serv_ver=1.17.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="29" (
	set serv_ver=1.17
	goto serv_path_set
) else if "%serv_ver_choice%"=="30" (
	set serv_ver=1.16.5
	goto serv_path_set
) else if "%serv_ver_choice%"=="31" (
	set serv_ver=1.16.4
	goto serv_path_set
) else if "%serv_ver_choice%"=="32" (
	set serv_ver=1.16.3
	goto serv_path_set
) else if "%serv_ver_choice%"=="33" (
	set serv_ver=1.16.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="34" (
	set serv_ver=1.16.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="35" (
	set serv_ver=1.16
	goto serv_path_set
) else if "%serv_ver_choice%"=="36" (
	set serv_ver=1.15.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="37" (
	set serv_ver=1.15.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="38" (
	set serv_ver=1.15
	goto serv_path_set
) else if "%serv_ver_choice%"=="39" (
	set serv_ver=1.14.4
	goto serv_path_set
) else if "%serv_ver_choice%"=="40" (
	set serv_ver=1.14.3
	goto serv_path_set
) else if "%serv_ver_choice%"=="41" (
	set serv_ver=1.14.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="42" (
	set serv_ver=1.14.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="43" (
	set serv_ver=1.14
	goto serv_path_set
) else if "%serv_ver_choice%"=="44" (
	set serv_ver=1.13.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="45" (
	set serv_ver=1.13.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="46" (
	set serv_ver=1.13
	goto serv_path_set
) else if "%serv_ver_choice%"=="47" (
	set serv_ver=1.12.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="48" (
	set serv_ver=1.12.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="49" (
	set serv_ver=1.12
	goto serv_path_set
) else if "%serv_ver_choice%"=="50" (
	set serv_ver=1.11.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="51" (
	set serv_ver=1.11.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="52" (
	set serv_ver=1.11
	goto serv_path_set
) else if "%serv_ver_choice%"=="53" (
	set serv_ver=1.10.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="54" (
	set serv_ver=1.10.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="55" (
	set serv_ver=1.10
	goto serv_path_set
) else if "%serv_ver_choice%"=="56" (
	set serv_ver=1.9.4
	goto serv_path_set
) else if "%serv_ver_choice%"=="57" (
	set serv_ver=1.9.3
	goto serv_path_set
) else if "%serv_ver_choice%"=="58" (
	set serv_ver=1.9.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="59" (
	set serv_ver=1.9.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="60" (
	set serv_ver=1.9
	goto serv_path_set
) else if "%serv_ver_choice%"=="61" (
	set serv_ver=1.8.9
	goto serv_path_set
) else if "%serv_ver_choice%"=="62" (
	set serv_ver=1.8.8
	goto serv_path_set
) else if "%serv_ver_choice%"=="63" (
	set serv_ver=1.8.7
	goto serv_path_set
) else if "%serv_ver_choice%"=="64" (
	set serv_ver=1.8.6
	goto serv_path_set
) else if "%serv_ver_choice%"=="65" (
	set serv_ver=1.8.5
	goto serv_path_set
) else if "%serv_ver_choice%"=="66" (
	set serv_ver=1.8.4
	goto serv_path_set
) else if "%serv_ver_choice%"=="67" (
	set serv_ver=1.8.3
	goto serv_path_set
) else if "%serv_ver_choice%"=="68" (
	set serv_ver=1.8.2
	goto serv_path_set
) else if "%serv_ver_choice%"=="69" (
	set serv_ver=1.8.1
	goto serv_path_set
) else if "%serv_ver_choice%"=="70" (
	set serv_ver=1.8
	goto serv_path_set
) else if "%serv_ver_choice%"=="0" (
	goto serv_ver_menu_choice
) else (
	goto serv_ver_choice_last_releases
)


:serv_path_set
cls
	echo.
	echo. More Utilities v%ver% %beta_view%
	echo.
	echo. ============ Путь ============
	echo.
	echo. 1) Рабочий стол
	echo. 2) Диск C:\
	echo.
	echo. 0) Назад
	echo.
set /p serv_path_set_choice=Выберите путь для сервера: 
if "%serv_path_set_choice%"=="1" (
	set "serv_path=C:\Users\%USERNAME%\Desktop"
	goto serv_name_set
) else if "%serv_path_set_choice%"=="2" (
	set "serv_path=C:\"
	goto serv_name_set
) else if "%serv_path_set_choice%"=="0" (
	goto serv_ver_menu_choice
) else (
	goto serv_path_set
)


:serv_name_set
cls
	echo.
	echo. More Utilities v%ver% %beta_view%
	echo.
	echo. ========== Название ==========
	echo.
	echo. Используйте только английские буквы и без пробелов
	echo.
set /p serv_name=Введите название вашего локального сервера: 
goto serv_check_settings
	

:serv_check_settings
cls
	echo.
	echo. More Utilities v%ver% %beta_view%
	echo.
	echo. ========== Параметры ==========
	echo.
	echo. Ядро: %serv_core%
	echo. Версия: %serv_ver%
	echo. Путь к серверу: %serv_path%
	echo. Имя сервера: %serv_name%
	echo.

echo. Нажмите ENTER, чтобы создать локальный сервер
pause >nul
goto serv_creator


:serv_creator
cls
call :serv_download_url
	echo.
	echo. Создаю ваш локалный сервер...
	echo.

cd "%serv_path%"
mkdir "%serv_name%_%serv_core%-%serv_ver%"
set "serv_compile_path=%serv_path%\%serv_name%_%serv_core%-%serv_ver%"

powershell -Command "Invoke-WebRequest -Uri '%serv_url%' -OutFile '%serv_compile_path%\server.jar'"
cd "%serv_compile_path%"
echo eula=true>eula.txt
echo @echo off>start.bat
echo title %serv_name%_%serv_core%-%serv_ver%>>start.bat
echo "%java_path%\java.exe" -jar "%serv_compile_path%\server.jar" nogui>>start.bat

cls
	echo.
	echo. More Utilities v%ver% %beta_view%
	echo.
	echo. Ваш сервер готов и находится по пути %serv_compile_path%
	echo. Чтобы его запустить, откройте start.bat в папке с сервером
	echo.
	echo. 1) Открыть папку с сервером
	echo. 2) Вернуься в меню
	echo.
set /p serv_compile=Выберите вариант: 
if "%serv_compile%"=="1" (
	start explorer.exe "%serv_compile_path%"
	exit /b
) else if "%serv_compile%"=="2" (
	goto %default_menu%
) else (
	goto %default_menu%
)


REM ====================================================================
REM 				     ОПЦИИ "Прочие утилиты"
REM ====================================================================

:win_cache_clear
cls
echo.
choice /c YN /n /m "Вы точно хотите удалить все временные файлы Windows? [Y/N]: "
if errorlevel 2 goto %default_menu%
if errorlevel 1 (
		echo.
		echo. Удаляю все временные файлы. Пожалуйста подождите...
		echo.
	call :win_clear
	timeout /t 7 /nobreak >nul

	set log_stat=win_cache_clear
	call :log_check

	cls
		echo.
		echo. Готово! Все временные файлы успешно удалены!
		echo.
	echo. Телепортация в меню...
	timeout /t 3 /nobreak >nul
	goto %default_menu%
)


:tmgr_switcher
cls
call :tmgr_status

	echo.
	echo. More Utilities v%ver% %beta_view%
	echo.
	echo. Ваш диспетчер задач: !tmgr!
	echo.
	echo. 1) Переключить
	echo. 2) Назад
	echo.
set /p tmgr_choice=Выберите опцию: 
if "%tmgr_choice%"=="1" (
	call :tmgr_switch
	goto tmgr_switcher
) else if "%tmgr_choice%"=="2" (
	goto %default_menu%
) else (
	goto tmgr_switcher
)


:ip_clear
cls
echo.
echo. Нажмите ENTER, чтобы сбросить свой IP адрес и отчистить кэш сети
pause >nul

cls
call :get_myip
echo.
echo. Сброс и отчистка вашего IP адреса... (%myip%)
call :ip_reset
timeout /t 5 /nobreak >nul

cls

set log_stat=ip_clear
call :log_check

echo.
echo. Ваш IP адрес был сброшен и отчищен!
echo. (Для корректной работы советуется перезагрузить ПК, но это не обязательно)
echo.
echo. Нажмите ENTER, чтобы вернуться в меню
pause >nul
goto %default_menu%

REM ====================================================================
REM 		   			     ОПЦИИ "MC Utility"
REM ====================================================================

:mc_log_clear
cls
echo.
echo. More Utilities v%ver% %beta_view%
echo.
echo. Список profiles(game) версий
echo.
for /l %%i in (1,1,%count%) do (
  echo. %%i. !FOLDER%%i!
)
echo.

set /p SELECT_NUM=Выберите profile(game) версию (1-%count%): 
if %SELECT_NUM% lss 1 goto opt1
if %SELECT_NUM% gtr %count% goto opt1
set SELECTED=!FOLDER%SELECT_NUM%!

cls
cd "%launcher_path%\!SELECTED!"
rmdir /s /q logs 2>nul

set log_stat=mc_log_clear
call :log_check
call :vars_folders_clear

echo.
echo. Готово! Логи были успешно удалены
echo.
echo. Нажмите ENTER, чтобы вернуться в меню
pause >nul
cls
goto %default_menu%


:mc_cache_clear
cls
echo.
echo. More Utilities v%ver% %beta_view%
echo.
echo. Список profiles(game) версий
echo.
for /l %%i in (1,1,%count%) do (
  echo. %%i. !FOLDER%%i!
)
echo.

set /p SELECT_NUM=Выберите profile(game) версию (1-%count%): 
if %SELECT_NUM% lss 1 goto opt1
if %SELECT_NUM% gtr %count% goto opt1
set SELECTED=!FOLDER%SELECT_NUM%!

cls
cd "%launcher_path%\!SELECTED!"
rmdir /s /q .bobby 2>nul
rmdir /s /q .cache 2>nul
rmdir /s /q .fabric 2>nul
rmdir /s /q crash-reports 2>nul
rmdir /s /q logs 2>nul
rmdir /s /q _IAS_ACCOUNTS_DO_NOT_SEND_TO_ANYONE 2>nul
rmdir /s /q debug 2>nul

set log_stat=mc_cache_clear
call :log_check
call :vars_folders_clear

echo.
echo. Готово! Кэш был успешно удален
echo.
echo. Нажмите ENTER, чтобы вернуться в меню
pause >nul
cls
goto %default_menu%


:mc_empty_folders_clear
cls
echo.
echo. More Utilities v%ver% %beta_view%
echo.
echo. Список profiles(game) версий
echo.
for /l %%i in (1,1,%count%) do (
  echo. %%i. !FOLDER%%i!
)
echo.

set /p SELECT_NUM=Выберите profile(game) версию (1-%count%): 
if %SELECT_NUM% lss 1 goto opt1
if %SELECT_NUM% gtr %count% goto opt1
set SELECTED=!FOLDER%SELECT_NUM%!

cls
cd "%launcher_path%\!SELECTED!"
for /f "delims=" %%i in ('dir /ad/b/s ^| sort /r') do rd "%%i" 2>nul

set log_stat=mc_empty_folders_clear
call :log_check
call :vars_folders_clear

echo.
echo. Готово! Все пустые папки были удалены
echo.
echo. Нажмите ENTER, чтобы вернуться в меню
pause >nul
cls
goto %default_menu%


:kl_delete
cls
echo.
echo. Это действие полностью удалит KLauncher с компьютера
echo. Включая все файлы сохранений, версии, текстуры и сам лаунчер с его настройками!!!
echo.
choice /c YN /n /m "Удалить KL? [Y/N]: "
  if errorlevel 2 goto %default_menu%
  if errorlevel 1 (
	cd "C:\Users\%USERNAME%\AppData\Roaming\KLauncher"
	rmdir /s /q "C:\Users\%USERNAME%\AppData\Roaming\KLauncher" 2>nul
  )

cls
echo. Удаляю KL...

set log_stat=kl_delete
call :log_check

cls
echo.
echo. Готово! KL был успешно удален
echo.
echo. Нажмите ENTER, чтобы вернуться в меню
pause >nul
cls
goto %default_menu%

REM ====================================================================
REM 						 	Информация
REM ====================================================================

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
goto %default_menu%


:cl
cls
echo.
echo. Последние изменения для версии: v%ver%
echo.
echo. + Все меню полностью переработаны
echo. + Вкладка "KL Cleaner" была переименована в "MC Utility"
echo. + Добавлена возможность выбора лаунчера в опциях MC Cleaner
echo. + Опция "Управление диспетчером задач" была переименована в "Переключение диспетчера задач"
echo. + Переписана логика работы "Переключение диспетчера задач" и добавлен новый интерфейс к этой опции
echo. + Добавлена вкладка "Настройки"
echo. + Добавлена система логирования для отображения результата опций (можно включить в настройках)
echo. + Добавлен BETA-mode (можно включить в настройках)
echo. + Добавлена опция "Создать пустой локальный сервер" (опция находится в бете, могут быть ошибки)
echo. = Мелкие исправления
echo.
echo.
echo Изменение в предыдущей версии: v1.%ver_d%
echo.
echo. + Утилита переименована из Cleaner в More Utilities
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
echo. Нажмите ENTER, чтобы вернуться в меню
pause >nul
goto %default_menu%

REM ====================================================================
REM 					   	   Логирование
REM ====================================================================

:log
call :log_folder_check
call :log_file_check

if "%log_stat%"=="mc_log_clear" (
	echo. Время исполнения: %time% >> latest.txt
	echo. Выполнялась опция: Удалить логи >> latest.txt
	echo. Лаунчер: %log_launcher% >> latest.txt
	echo. Версия: !SELECTED! >> latest.txt
	echo. Результат: Логи были успешно удалены >> latest.txt
) else if "%log_stat%"=="mc_cache_clear" (
	echo. Время исполнения: %time% >> latest.txt
	echo. Выполнялась опция: Удалить ненужный кэш >> latest.txt
	echo. Лаунчер: %log_launcher% >> latest.txt
	echo. Версия: !SELECTED! >> latest.txt
	echo. Результат: Кэш был успешно удален >> latest.txt
) else if "%log_stat%"=="mc_empty_folders_clear" (
	echo. Время исполнения: %time% >> latest.txt
	echo. Выполнялась опция: Удалить все пустые папки >> latest.txt
	echo. Лаунчер: %log_launcher% >> latest.txt
	echo. Версия: !SELECTED! >> latest.txt
	echo. Результат: Все пустые папки были удалены >> latest.txt
) else if "%log_stat%"=="kl_delete" (
	echo. Время исполнения: %time% >> latest.txt
	echo. Выполнялась опция: Удалить KLauncher >> latest.txt
	echo. Лаунчер: %log_launcher% >> latest.txt
	echo. Версия: !SELECTED! >> latest.txt
	echo. Результат: KL был успешно удален >> latest.txt
) else if "%log_stat%"=="win_cache_clear" (
	echo. Время исполнения: %time% >> latest.txt
	echo. Выполнялась опция: Удалить все временные файлы >> latest.txt
	echo. Результат: Все временные файлы успешно удалены! >> latest.txt
) else if "%log_stat%"=="ip_clear" (
	echo. Время исполнения: %time% >> latest.txt
	echo. Выполнялась опция: Сбросить и отчистить IP адрес >> latest.txt
	echo. Результат: Ваш IP адрес был сброшен и отчищен! >> latest.txt
)
exit /b


:log_check
if "%log_check_enable%"=="Выключено" (
	cls
) else if "%log_check_enable%"=="Включено" (
	call :log
)
exit /b


:log_switch
if "%log_check_enable%"=="Выключено" (
	set log_check_enable=Включено
	set "log_folder_path=%~dp0logs"
	set "log_file_path=%log_folder_path%\latest.txt"
) else if "%log_check_enable%"=="Включено" (
	set log_check_enable=Выключено
)
exit /b


:log_folder_check
if exist "%log_folder_path%\" (
	cls
) else (
	cd "%~dp0"
	mkdir logs
)
exit /b


:log_file_check
if exist "%log_file_path%" (
	cls
) else (
	cd "%log_folder_path%"
	echo. > latest.txt
)
exit /b

REM ====================================================================
REM 					   Вызываемые службы
REM ====================================================================

:error
if "%error%"=="1" (
	echo.
	echo. ERROR! Нет подключения к GitHub. Невозможно проверить наличие обновлений
	echo. Код ошибки: 1
	echo.
	echo. Нажмите ENTER, чтобы открыть меню
	pause >nul
	goto %default_menu%
)


:launcher_choice
cls
echo.
echo. 1) KLauncher
echo. 2) Другой лаунчер (TLauncher, TL Legacy, Minecraft Launcher, и т.д)
echo.
set /p "launcher=Выберите лаунчер: "
if "%launcher%"=="1" (
	set "launcher_path=C:\Users\%USERNAME%\AppData\Roaming\KLauncher\game\instances"
	set log_launcher=KLauncher
	goto mc_folders_check
) else if "%launcher%"=="2" (
	set "launcher_path=C:\Users\%USERNAME%\AppData\Roaming\.minecraft\versions"
	set log_launcher=TLauncher или другой
	goto mc_folders_check
) else (
	goto launcher_choice
)


:mc_folders_check
cls
cd "%launcher_path%"
for /d %%i in (*) do (
  set /a count+=1
  set FOLDER!count!=%%i
)

if "%mccleaner_choice%"=="1" (
	goto mc_log_clear
) else if "%mccleaner_choice%"=="2" (
	goto mc_cache_clear
) else if "%mccleaner_choice%"=="3" (
	goto mc_empty_folders_clear
)


:vars_folders_clear
set FOLDER=
set count=0
exit /b


:menu_active_check
if "%menu_active%"=="false" (
	set menu_active=true
) else if "%menu_active%"=="true" (
	cls
)
exit /b


:tmgr_status
set "tmgr=none"

for /f "skip=2 tokens=3" %%A in ('
  reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" ^
      /v DisableTaskMgr 2^>nul
') do (
  set "check_tmgr=%%A"
)

if not defined check_tmgr (
    set "tmgr=Включен"
) else (
    if "!check_tmgr!"=="0x0" (
        set "tmgr=Включен"
    ) else (
        set "tmgr=Выключен"
    )
)
exit /b


:tmgr_switch
if "%tmgr%"=="Выключен" (
	reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 0 /f
) else if "%tmgr%"=="Включен" (
	reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f
)
exit /b


:get_myip
for /f "tokens=*" %%i in ('curl ifconfig.me 2^>nul') do set "myip=%%i"
exit /b


:ip_reset
ipconfig /release >nul
ipconfig /flushdns >nul
ipconfig /renew >nul
netsh interface ip delete arpcache >nul
netsh winsock reset >nul
netsh int ip reset >nul
exit /b


:win_clear
del /s /f /q "C:\Windows\Temp\*" 2>nul
del /s /f /q "C:\Users\%USERNAME%\AppData\Local\Temp\*" 2>nul
exit /b


:serv_download_url
if "%serv_core%"=="vanilla" (
	set "serv_url=https://www.mcjars.com/get/%serv_core%-%serv_ver%.jar"
) else if "%serv_core%"=="forge" (
	set "serv_url="
) else if "%serv_core%"=="fabric" (
	set "serv_url=%fabric_url%"
) else if "%serv_core%"=="paper" (
	set "serv_url="
)
exit /b


:beta_mode_switch
if "%beta_mode_enable%"=="Выключено" (
	set beta_mode_enable=Включено
	set default_menu=menu_beta
	set "beta_view=(BETA)"
) else if "%beta_mode_enable%"=="Включено" (
	set beta_mode_enable=Выключено
	set default_menu=menu
	set "beta_view= "
)
exit /b