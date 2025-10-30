:: Deleting all non-necessary files to start fresh
md d
move .\* .\d
move d\curl.exe .
move d\fixpath.bat .
move d\install.bat .
move d\lucon.ttf .
move d\msvcp140.dll .
move d\tar.exe .
del /s /q d
rd /s /q d

:: Downloading all required files
if not exist curl.exe      (echo curl is missing. This is a requirement for this script. Extract the entirety of the zip file containing this script. & pause & exit)
if not exist tar.exe       (echo tar is missing. This is a requirement for this script. Extract the entirety of the zip file containing this script. & pause & exit)
if not exist cm.zip        (.\curl -Lo cm.zip   "https://gitlab.com/the-no-frauds-club/cosmonarchy-bw-prerelease/-/archive/main/cosmonarchy-bw-prerelease-main.zip")
if not exist maps.zip      (.\curl -Lo maps.zip "https://gitlab.com/the-no-frauds-club/cmbw-root/-/archive/main/cmbw-root-main.zip")
if not exist bw.zip        (.\curl -Lo bw.zip   "https://fraudsclub.com/files/starcraft.zip")
if not exist msvcp140.dll  (.\curl -LO          "https://mikamika.top/cm/dl/msvcp140.dll")
if not exist lucon.ttf     (.\curl -LO          "https://mikamika.top/cm/dl/lucon.ttf")
if not exist fixpath.bat   (.\curl -LO          "https://mikamika.top/cm/dl/fixpath.bat")
if not exist cnc-ddraw.zip (.\curl -LO          "https://github.com/FunkyFr3sh/cnc-ddraw/releases/download/v7.0.0.0/cnc-ddraw.zip")
if not exist CrownLink.snp (.\curl -LO          "https://github.com/impromptu1583/CrownLink/releases/latest/download/CrownLink.snp")

:: Setting up Cosmonarchy
.\tar xf cm.zip
ren cosmonarchy-bw-* cm
move cm\* . /y 2>nul
rd cm

:: Setting up Brood War
.\tar xf bw.zip
move Starcraft\* . /y 2>nul
rd Starcraft
reg add "HKLM\Software\Wow6432Node\Blizzard Entertainment\Starcraft" /V "Program" /D "%CD%\StarCraft.exe" /F

:: Setting up Maps
.\tar xf maps.zip
md maps
move cmbw-root* maps\cmbw-root

:: Setting up misc
.\tar xf cnc-ddraw.zip
reg add "HKCU\Software\Wine\DllOverrides" /V "ddraw" /D "native,builtin" /F
if not exist %SystemRoot%\Fonts\lucon.ttf (copy lucon.ttf %SystemRoot%\Fonts)
del *.zip
:: Video Settings
"cnc-ddraw config"
:: Creating data file...
:: Please wait...
"Cosmonarchy BW"

