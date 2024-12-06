@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

:: ASCII Banner
ECHO.
ECHO =======================================================
ECHO.
ECHO     ULTIMATE PC CLEANUP AND OPTIMIZATION SCRIPT
ECHO           Developed By PUBUDU DISSANAYAKA
ECHO.
ECHO =======================================================
ECHO.

:: Check for admin rights
NET SESSION >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO Error: This script requires administrator privileges.
    ECHO Please run as administrator.
    PAUSE
    EXIT /B 1
)

:: Log cleanup operations
SET LOG_FILE="%TEMP%\system_cleanup_log_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%.txt"
ECHO Cleanup Started: %DATE% %TIME% > !LOG_FILE!

:: Cleanup Recent Items
IF EXIST "%USERPROFILE%\Recent\*.*" (
    ECHO Cleaning Recent Items >> !LOG_FILE!
    DEL /S /F /Q "%USERPROFILE%\Recent\*.*" >> !LOG_FILE! 2>&1
)

:: Cleanup Prefetch
IF EXIST "C:\Windows\Prefetch\*.*" (
    ECHO Cleaning Prefetch Folder >> !LOG_FILE!
    DEL /S /F /Q "C:\Windows\Prefetch\*.*" >> !LOG_FILE! 2>&1
)

:: Cleanup Windows Temp
IF EXIST "C:\Windows\Temp\*.*" (
    ECHO Cleaning Windows Temp Folder >> !LOG_FILE!
    DEL /S /F /Q "C:\Windows\Temp\*.*" >> !LOG_FILE! 2>&1
)

:: Cleanup User Temp
IF EXIST "%USERPROFILE%\AppData\Local\Temp\*.*" (
    ECHO Cleaning User Temp Folder >> !LOG_FILE!
    DEL /S /F /Q "%USERPROFILE%\AppData\Local\Temp\*.*" >> !LOG_FILE! 2>&1
)

:: Additional Cleanup Targets
IF EXIST "%USERPROFILE%\AppData\Local\Microsoft\Windows\INetCache\*.*" (
    ECHO Cleaning Internet Cache >> !LOG_FILE!
    DEL /S /F /Q "%USERPROFILE%\AppData\Local\Microsoft\Windows\INetCache\*.*" >> !LOG_FILE! 2>&1
)

IF EXIST "%USERPROFILE%\AppData\Local\Microsoft\Windows\WER\*.*" (
    ECHO Cleaning Windows Error Reporting Folder >> !LOG_FILE!
    DEL /S /F /Q "%USERPROFILE%\AppData\Local\Microsoft\Windows\WER\*.*" >> !LOG_FILE! 2>&1
)

:: PC Speed Optimization Commands
ECHO Optimizing PC Performance >> !LOG_FILE!

:: Disable Unnecessary Windows Services
SC CONFIG "DiagTrack" START= DISABLED >> !LOG_FILE! 2>&1
SC CONFIG "WerSvc" START= DISABLED >> !LOG_FILE! 2>&1
SC CONFIG "PcaSvc" START= DISABLED >> !LOG_FILE! 2>&1

:: Clear Windows Update Cache
NET STOP WUAUSERV >> !LOG_FILE! 2>&1
RMDIR /S /Q C:\Windows\SoftwareDistribution >> !LOG_FILE! 2>&1
NET START WUAUSERV >> !LOG_FILE! 2>&1

:: Flush DNS Cache
IPCONFIG /FLUSHDNS >> !LOG_FILE! 2>&1

:: Clear Windows Store Cache
WSReset.exe >> !LOG_FILE! 2>&1

:: Run Disk Cleanup Utility (Silent Mode)
CLEANMGR /SAGERUN:1 >> !LOG_FILE! 2>&1

:: Optimize Windows Search Index
"%windir%\system32\searchindexer.exe" /optimize >> !LOG_FILE! 2>&1

:: Disable Startup Programs (Requires Manual Configuration)
:: MSCONFIG can be used to disable unnecessary startup items

:: Final Performance Optimization
ECHO Rebuilding Icon Cache >> !LOG_FILE!
attrib -h -s -r "%UserProfile%\AppData\Local\IconCache.db" >> !LOG_FILE! 2>&1
DEL /F "%UserProfile%\AppData\Local\IconCache.db" >> !LOG_FILE! 2>&1

:: Final Log Entry
ECHO Cleanup and Optimization Completed: %DATE% %TIME% >> !LOG_FILE!

ECHO Optimization complete. Detailed log saved to !LOG_FILE!
ECHO Recommended: Restart your computer for full effect.
PAUSE