<img src="AWAITING HEADER IMAGE...">

# *IW5Cine*

### 🎥 A features-rich cinematic mod for Call of Duty: Modern Warfare 3

<img src="https://img.shields.io/badge/REWRITE%20IN%20PROGRESS-90c433?style=flat-square">　<a href="https://github.com/dtpln/iw5cine/releases"><img src="https://img.shields.io/github/v/release/dtpln/iw5cine?label=Latest%20release&style=flat-square&color=90c433"></a>　<a href="https://discord.gg/wgRJDJJ"><img src="https://img.shields.io/discord/617736623412740146?label=Join%20the%20IW4Cine%20Discord!&style=flat-square&color=90c433"></a>　<a href="https://github.com/dtpln/iw5cine/releases/latest"><img src="https://img.shields.io/github/downloads/dtpln/iw5cine/total?color=90c433&label=Downloads&style=flat-square"></a>
<br/><br/>

**PLEASE NOTE**: As the original mod is in a WIP phase, so will this port be..

This is a port of [Sass' Cinematic Mod](https://github.com/sortileges/iw4cine) for Call of Duty: Modern Warfare 3, designed for video editors to create cinematics shots in-game.

This mod creates new dvars combined as player commands. They are all associated to script functions that are triggered when the dvar doesn't equal it's default value, meaning these functions will all independently stay idle until they get notified to go ahead.

This mod was also designed as a Multiplayer mod only. It will not work in Singleplayer or Zombies.


<br/><br/>
## Requirements

In order to use the latest version of this mod directly from the repo, you'll need a copy of **Call of Duty: Modern Warfare 3** with **[Plutonium](https://plutonium.pw)** installed. This mod may also work on [IW5-Mod](https://alterware.dev). This mod was built on the Plutonium version of Modern Warfare 3.

<br/><br/>
## Installation

Simply download the mod through [this link](https://github.com/dtpln/iw5cine/releases/latest). Scroll down and click on "Source code (zip)" to download the archive.

Once the mod is downloaded, open the ZIP file and drag the "iw5cine" folder into your `MW3/mods` folder. If the `mods` folder doesn't exist, create it. (*You can also rename the mod if you'd like.*)

<br/>

```text
X:/
└── .../
    └── Modern Warfare 3/
        └── mods/
            └── iw5cine
```
- Plutonium full path: `%localappdata%\Plutonium\storage\iw5`

Then, open your game, open the in-game console with `~`, and type `/fs_game mods/iw5cine`.

<br/><br/>
## How to use

The link below contains a HTML file that explains every command from the [latest release](https://github.com/sortileges/iw4cine/releases/latest) in details. The HTML file will open a new browser tab when you click on it. 
- **[sortileges.github.io/iw4cine/help](https://sortileges.github.io/iw4cine/help)**.

**It is not up-to-date with what's in the master branch,** although everything should still work as intended. Just don't be surprised if something is missing or not working as expected!

Once **[Sass](https://github.com/sortileges)** finishes the mod's rewrite, the HTML file will be updated accordingly.


<br/><br/>
## Features
**MISC FUNCTIONS**
    
    - [x]     clone         -- <set to 1>
    - [x]     drop          -- <set to 1>
    - [x]     about         -- <set to 1>
    - [x]     clearbodies   -- <set to 1>
    - [x]     viewhands     -- <model_name>
    - [x]     eb_explosive  -- <radius>
    - [x]     eb_magic      -- <degrees>

**VISUAL FUNCTIONS**

    - [x]    spawn_model    -- <model_name>
    - [x]    spawn_fx       -- <fx_name>
    - [x]    vision         -- <vision>
    - [ ]    fog            -- <start end red green blue transition>

**BOT FUNCTIONS**

    - [x]    spawn          -- <weapon_mp> <axis/allies> <camo>
    - [x]    move           -- <bot_name>
    - [x]    aim            -- <bot_name>
    - [x]    stare          -- <bot_name>
    - [x]    model          -- <bot_name> <SMG/ASSAULT/SNIPER/LMG/RIOT/SHOTGUN/JUGGERNAUT/GHILLIE> <axis/allies>
    - [x]    kill           -- <bot_name> <body/head/shotgun/cash>
    - [x]    holdgun        -- <set to 1>
    - [x]    freeze         -- <set to 1>

**BOT FUNCTIONS**

    - [x]   actorback         -- <set to 1>
    - [x]   actor_anim        -- <actor_name> <anim_name>
    - [ ]   actor_copy        -- <actor_name>
    - [x]   actor_death       -- <actor_name> <anim_name>
    - [x]   actor_spawn       -- <body_model> <head_model> <base_anim> <death_anim>
    - [x]   actor_move        -- <actor_name>
    - [x]   actor_health      -- <actor_name>
    - [x]   actor_model       -- <actor_name> <body_model> <head_model>
    - [x]   actor_weapon      -- <actor_name> <tag_name> <weapon_mp/model/delete> <camo>
    - [ ]   actor_gopro       -- <actor_name> <tag_name> <x> <y> <z> <yaw> <pitch> <roll>
    - [ ]   actor_fx          -- <actor_name> <tag_name> <fx_name> <when>

**PLANNED FEATURES**

    - [ ]    Implementation of Bot Warfare mod for IW5 Plutonium.

<br/><br/>
## Credits
    -   Sass - Created the original IW4Cine mod.
    -   Antiga - Helped rewrite some functions.