# cm-install-script

A primitive way to install Cosmonarchy, simple and fast to the point.

**Download [cm-install-script.zip](https://github.com/MikaMika/cm-install-script/releases/latest/download/cm-install-script.zip)**

Extract the folder Cosmonarchy to your desired location and launch `install.bat`.
This will install [the latest Prerelease of Cosmonarchy](https://gitlab.com/the-no-frauds-club/cosmonarchy-bw-prerelease) and [the latest Cosmonarchy Maps](https://gitlab.com/the-no-frauds-club/cmbw-root) straight from Gitlab so you don't have to.

If you rename or move cosmonarchy, launch `fixpath.bat` to register the new location.

# cm-kb-txt

**Download [cm-kb-txt.zip](https://github.com/MikaMika/cm-install-script/releases/latest/download/cm-kb-txt.zip) to set custom KeyBinds**
- Unzip in Prerelease folder
- Run `kb.bat` once to generate the `kb.txt` file (config) and edit that
- Run `kb.bat` a second time to import your changes
- To go back to Grid, delete `kb.txt` and run `kb.bat`

The config takes the first character of a line as Hotkey, then the exact name of the Button (case sensitive). You may have Spaces, or Tabs, or even nothing between them. *Many choices!*
Takes about 6 seconds to patch 416 keys.
You may have `kb.txt` empty or just a few lines like `P Assemble Scribe` to make it run even faster. (0.377s)

On Linux, you don't have to use the bat, because that would be slower, so use the kb.sh! (Mark the file as executable in properties permissions)

# Additional information

To ensure compatibility with different versions of Windows and Linux Wine, the following are included where needed:
- tar.exe (renamed from bsdtar.exe) from https://sourceforge.net/projects/bsdtar/
- curl.exe from https://curl.se/windows/
- msvcp140.dll from https://aka.ms/vs/17/release/vc_redist.x86.exe
- lucon.ttf
- busybox64u.exe from https://frippery.org/busybox/
