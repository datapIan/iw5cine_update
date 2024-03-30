@echo off
set gamepath=STEAMGAMEPATH
cd /D %LOCALAPPDATA%\Plutonium
start /wait /abovenormal bin\plutonium-bootstrapper-win32.exe iw5mp "%gamepath%" -lan +set intro 0 +set developer 0 +name "PLAYERNAME" +set fs_game "mods/iw5cine"