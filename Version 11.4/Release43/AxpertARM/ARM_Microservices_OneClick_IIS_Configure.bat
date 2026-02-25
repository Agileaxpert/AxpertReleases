@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM ============================================================
REM ARM Microservices IIS Auto Deployment Script
REM Root Website : Default Web Site
REM Root App Name : ARM Microservices
REM Root Path : D:\IIS\ARM Microservices
REM Managed Runtime: No Managed Code
REM ============================================================

echo.
echo ===============================================
echo ARM Microservices IIS Hosting Setup
echo ===============================================
echo.

REM -------- VARIABLES --------
set SITE_NAME=Default Web Site
set ROOT_APP_NAME=ARM_API
set ROOT_PATH=D:\ARM Microservices\ARM Microservices Releases - 20Feb2026\ARM

REM Child Applications List
set APPS=ARM_APIs ARMNotificationHub AxAuth AxList AxStructUtils AxTstructData AxUtils

REM ============================================================
REM STEP 0 - CONFIRM WITH USER BEFORE DOING ANYTHING
REM ============================================================

echo Please review the following configuration carefully:
echo.
echo   Root Website      : %SITE_NAME%
echo   Root App Name     : %ROOT_APP_NAME%
echo   Root App Pool     : %ROOT_APP_NAME%
echo   Root Physical Path: %ROOT_PATH%
echo.
echo   Child Applications and App Pools:
for %%A in (%APPS%) do (
    echo     - App      : /%ROOT_APP_NAME%/%%A
    echo       App Pool : %ROOT_APP_NAME%_%%A
    echo       Path     : %ROOT_PATH%\%%A
    echo.
)

echo -----------------------------------------------
echo WARNING: This will register applications in IIS.
echo Type YES (in capitals) to confirm and continue:
echo -----------------------------------------------
set /p USER_CONFIRM=Your input: 

if NOT "%USER_CONFIRM%"=="YES" (
    echo.
    echo [ABORTED] You did not type YES. Setup has been cancelled.
    echo.
    pause
    ENDLOCAL
    exit /b 1
)

echo.
echo [CONFIRMED] Proceeding with IIS setup...
echo.


REM ============================================================
REM STEP 1 - CREATE ROOT APP POOL (WITH EXISTENCE CHECK)
REM ============================================================

echo -----------------------------------------------
echo STEP 1: Creating Root Application Pool
echo -----------------------------------------------

%windir%\system32\inetsrv\appcmd list apppool /name:"%ROOT_APP_NAME%" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [ERROR] Application Pool "%ROOT_APP_NAME%" already exists. Aborting.
    goto :ABORT
)

%windir%\system32\inetsrv\appcmd add apppool /name:%ROOT_APP_NAME%
%windir%\system32\inetsrv\appcmd set apppool %ROOT_APP_NAME% /managedRuntimeVersion:""
%windir%\system32\inetsrv\appcmd set apppool %ROOT_APP_NAME% /managedPipelineMode:Integrated
echo [OK] App Pool "%ROOT_APP_NAME%" created successfully.
echo.


REM ============================================================
REM STEP 2 - CREATE ROOT APPLICATION (WITH EXISTENCE CHECK)
REM ============================================================

echo -----------------------------------------------
echo STEP 2: Creating Root Application
echo -----------------------------------------------

%windir%\system32\inetsrv\appcmd add app /site.name:"%SITE_NAME%" /path:/%ROOT_APP_NAME% /physicalPath:"%ROOT_PATH%" /applicationPool:%ROOT_APP_NAME%
echo [OK] Root Application "/%ROOT_APP_NAME%" created successfully.
echo.


REM ============================================================
REM STEP 3 - CREATE CHILD APP POOLS (WITH EXISTENCE CHECK)
REM ============================================================

echo -----------------------------------------------
echo STEP 3: Creating Child Application Pools
echo -----------------------------------------------

for %%A in (%APPS%) do (
    set CHILD_POOL=%ROOT_APP_NAME%_%%A

    for /f "tokens=*" %%R in ('%windir%\system32\inetsrv\appcmd list apppool /name:"!CHILD_POOL!"') do (
        echo [ERROR] Application Pool "!CHILD_POOL!" already exists. Aborting.
        goto :ABORT
    )

    %windir%\system32\inetsrv\appcmd add apppool /name:!CHILD_POOL!
    %windir%\system32\inetsrv\appcmd set apppool !CHILD_POOL! /managedRuntimeVersion:""
    %windir%\system32\inetsrv\appcmd set apppool !CHILD_POOL! /managedPipelineMode:Integrated
    echo [OK] App Pool "!CHILD_POOL!" created successfully.
)
echo.


REM ============================================================
REM STEP 4 - CREATE CHILD APPLICATIONS (WITH EXISTENCE CHECK)
REM ============================================================

echo -----------------------------------------------
echo STEP 4: Creating Child Applications
echo -----------------------------------------------

for %%A in (%APPS%) do (
    set CHILD_POOL=%ROOT_APP_NAME%_%%A
    set CHILD_PATH=%ROOT_PATH%\%%A

    %windir%\system32\inetsrv\appcmd add app /site.name:"%SITE_NAME%" ^
        /path:/%ROOT_APP_NAME%/%%A ^
        /physicalPath:"!CHILD_PATH!" ^
        /applicationPool:!CHILD_POOL!
    echo [OK] Application "/%%A" created successfully.
)

echo.
echo ===============================================
echo ARM Microservices IIS Hosting Setup Completed Successfully!
echo ===============================================
echo.
pause
ENDLOCAL
exit /b 0


REM ============================================================
REM ABORT LABEL
REM ============================================================
:ABORT
echo.
echo ===============================================
echo [FAILED] Setup was aborted due to an error.
echo Please resolve the issue and re-run the script.
echo ===============================================
echo.
pause
ENDLOCAL
exit /b 1