@echo off
setlocal enabledelayedexpansion


REM Convert all docs\*.md into slides\*.pdf using pandoc.
REM Requires: pandoc. Optionally install MiKTeX/TeX Live for better fonts.


set ROOT_DIR=%~dp0..
set DOCS_DIR=%ROOT_DIR%\docs
set OUT_DIR=%ROOT_DIR%\slides


if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"


where pandoc >nul 2>nul
if errorlevel 1 (
echo Error: pandoc not found. Install pandoc and retry.
exit /b 1
)


for %%f in ("%DOCS_DIR%\*.md") do (
set "name=%%~nf"
echo [pandoc] %%f -^> "%OUT_DIR%\!name!.pdf"
pandoc "%%f" -o "%OUT_DIR%\!name!.pdf" -V geometry:margin=1in --toc
)