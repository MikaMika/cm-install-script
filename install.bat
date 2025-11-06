@echo off
echo.
echo :: Checking directory name is Cosmonarchy with no subdirectory
for %%I in (.) do set CurrDirName=%%~nxI
IF /I NOT "%CurrDirName%" == "cosmonarchy" (echo This script will only run from a directory named cosmonarchy. Verify you are in the correct location or rename accordingly. & pause & exit)
for /d %%a in (.\*) do (echo Directory detected. This script should only be run as a fresh new install. Extract the entirety of the zip file containing this script then try again. & pause & exit)
echo.
echo :: Downloading all required files
if not exist curl.exe      (echo curl is missing. This is a requirement for this script. Extract the entirety of the zip file containing this script then try again. & pause & exit)
if not exist tar.exe       (echo tar is missing. This is a requirement for this script. Extract the entirety of the zip file containing this script then try again. & pause & exit)
if not exist cm.zip        (echo cm    & .\curl -Lo cm.zip   "https://gitlab.com/the-no-frauds-club/cosmonarchy-bw-prerelease/-/archive/main/cosmonarchy-bw-prerelease-main.zip")
if not exist maps.zip      (echo maps  & .\curl -Lo maps.zip "https://gitlab.com/the-no-frauds-club/cmbw-root/-/archive/main/cmbw-root-main.zip")
if not exist bw.zip        (echo bw    & .\curl -Lo bw.zip   "https://fraudsclub.com/files/starcraft.zip")
if not exist msvcp140.dll  (echo msvc  & .\curl -LO          "https://github.com/MikaMika/cm-install-script/raw/refs/heads/main/msvcp140.dll")
if not exist lucon.ttf     (echo lucon & .\curl -LO          "https://github.com/MikaMika/cm-install-script/raw/refs/heads/main/lucon.ttf")
if not exist fixpath.bat   (echo path  & .\curl -LO          "https://github.com/MikaMika/cm-install-script/raw/refs/heads/main/fixpath.bat")
if not exist cnc-ddraw.zip (echo ddraw & .\curl -LO          "https://github.com/FunkyFr3sh/cnc-ddraw/releases/download/v7.0.0.0/cnc-ddraw.zip")
if not exist CrownLink.snp (echo crlnk & .\curl -LO          "https://github.com/impromptu1583/CrownLink/releases/latest/download/CrownLink.snp")
echo.
echo :: Setting up Cosmonarchy
.\tar xf cm.zip
move cosmonarchy-bw-prerelease-* Prerelease
if not exist %SystemRoot%\Fonts\lucon.ttf (copy lucon.ttf %SystemRoot%\Fonts)
echo.
echo :: Setting up Brood War
.\tar xf bw.zip
cd Starcraft
reg add "HKLM\Software\Wow6432Node\Blizzard Entertainment\Starcraft" /V "Program" /D "%CD%\StarCraft.exe" /F
echo.
echo :: Setting up Maps
..\tar xf ..\maps.zip
md maps
move cmbw-root* maps\cmbw-root
echo.
echo :: Setting up misc
..\tar xf ..\cnc-ddraw.zip
reg add "HKCU\Software\Wine\DllOverrides" /V "ddraw" /D "native,builtin" /F
copy ..\CrownLink.snp .
copy ..\msvcp140.dll .
copy ..\fixpath.bat .
cd ..\Prerelease
echo.
echo :: Video Settings
"..\Starcraft\cnc-ddraw config"
echo.
echo :: Creating data file...
echo :: Please wait...
"Cosmonarchy BW"
echo.
echo ::
echo ::
echo :: You may now delete the downloaded files,
echo :: or keep them for an offline reinstallation.
echo ::
echo ::
echo.
pause
