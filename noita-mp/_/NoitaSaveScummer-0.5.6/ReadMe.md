# Noita Save Scummer

**Noita Save Scummer** is a software that helps with backups and restores of save files of Noita video game.

This software supports backups of game's save into a named uncompressed archive file. **Noita Save Scummer** also offers quick-save and quick-load functionality through the use of hotkeys.

All necessary settings are customizable through the **"Options"** menu that can be opened using a button present on main application's window. This settings include whether the program will attempt to automatically close/open Noita game.

## Please note

If you are running Noita with elevated privileges (*as Administrator*), then you will have to close Noita manually (*you should probably also disable the Autoclose option*).

If you want the program to launch the game upon loading a save file *(if the game is not launched already)*, then just check the **"Launch Noita on load"** option in the **"Options"** menu.

The program does not know where the Noita's executable is located, therefore it will not attempt to launch Noita back after closing the application. To fix that you should start the program while Noita us running or select an executable file in the **"Options"** menu.

If you want faster saving and loading you can consider installing [**7-zip**](https://www.7-zip.org/) file archiver (if you do not use the default installation path, be sure to specify the path to the program in the settings file or add it to the PATH environment variable).

## Default configuration

- **Noita's save folder path** — `%USERPROFILE%\AppData\LocalLow\Nolla_Games_Noita`
- **Quick-Save** — <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>F5</kbd>
- **Quick-Load** — <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>F9</kbd>
- **Save** — <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>F5</kbd>
- **Load** — <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>F9</kbd>
- **Autoclose Noita** — `Yes`
- **Launch Noita on loading save** — `No`
- **Use Steam launch** — `Yes`
- **Noita's executable path** — `None`
- **Steam executable path** — `None`

## Compiling the source code

1. Enter **`src`** directory
2. Run **`resource_encoder.py`** to pack resources
3. Run **`compile.py`** to produce the final executable file, it will be located in the **`dist`** directory

>**NOTE:** If python modules are missing then **`compile.py`** will try to run **`install_modules.ps1`** script with elevated privileges.