# Noita Multiplayer

[![latest release](https://img.shields.io/github/v/release/ismoh/noitamp?include_prereleases&label=latest%20release&style=for-the-badge)](https://github.com/Ismoh/NoitaMP/releases)

### Table of Contents

- [TL:DR](#tldr)
- [Documentation](#documentation)
- [Our awesome and valuable Contributors](#our-awesome-and-valuable-contributors)
- [Credits, Supporter and special thanks](#credits-supporter-and-special-thanks)
- [Used libraries, frameworks and other stuff](#used-libraries-frameworks-and-other-stuff)
- [Roadmap](#roadmap)

## TL;DR

**Currently work in progress and not working unless there is a GitHub release available!**

If you want to get notifications, [join](https://discord.gg/DhMurdcw4k) my discord server. There is a MEE6 role assigment for NoitaMP in #noita-modding!

---

[![latest release](https://img.shields.io/github/v/release/ismoh/noitamp?include_prereleases&label=latest%20release&style=for-the-badge)](https://github.com/Ismoh/NoitaMP/releases)
[![GitHub release](https://img.shields.io/github/v/release/ismoh/noitamp?display_name=release&include_prereleases&sort=date&style=for-the-badge)](https://github.com/Ismoh/NoitaMP/releases)
[![GitHub tag](https://img.shields.io/github/v/tag/ismoh/noitamp?include_prereleases&sort=semver&style=for-the-badge)](https://github.com/Ismoh/NoitaMP/tags)
[![.version](https://img.shields.io/badge/dynamic/json?label=.version&query=version&url=https%3A%2F%2Fraw.githubusercontent.com%2FIsmoh%2FNoitaMP%2Fdevelop%2Fmods%2Fnoita-mp%2F.version&style=for-the-badge)](https://github.com/Ismoh/NoitaMP/blob/develop/mods/noita-mp/.version)

[![last-commit](https://img.shields.io/github/last-commit/ismoh/noitamp?style=for-the-badge)](https://github.com/Ismoh/NoitaMP/commit/develop)
[![luarocks-version](https://img.shields.io/badge/luarocks-v3.9.1-brightgreen?style=for-the-badge)](https://github.com/Ismoh/NoitaMP/blob/develop/.building/luarocks-3.9.1-windows-32)

[![GitHub issues by-label](https://img.shields.io/github/issues/ismoh/noitamp/help_wanted?style=for-the-badge)](https://github.com/Ismoh/NoitaMP/issues?q=is%3Aopen+is%3Aissue+label%3A%22help_wanted%22)
[![GitHub issues](https://img.shields.io/github/issues/ismoh/noitamp?style=for-the-badge)](https://github.com/Ismoh/NoitaMP/issues)

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/ismoh/noitamp/windows-latest-lua-unit-testing.yml?label=Tests%20&logo=windows&style=for-the-badge)
[![Coveralls](https://img.shields.io/coveralls/github/Ismoh/NoitaMP?logo=coveralls&style=for-the-badge)](https://coveralls.io/github/Ismoh/NoitaMP)
[![Codecov](https://img.shields.io/codecov/c/gh/Ismoh/NoitaMP?logo=codecov&style=for-the-badge)](https://codecov.io/gh/Ismoh/NoitaMP)

[![GitHub watchers](https://img.shields.io/github/watchers/ismoh/noitamp?style=for-the-badge)](https://github.com/Ismoh/NoitaMP/watchers)
[![GitHub forks](https://img.shields.io/github/forks/ismoh/noitamp?style=for-the-badge)](https://github.com/Ismoh/NoitaMP/network/members)
[![GitHub Repo stars](https://img.shields.io/github/stars/ismoh/noitamp?style=for-the-badge)](https://github.com/Ismoh/NoitaMP/stargazers)
![GitHub Sponsors](https://img.shields.io/github/sponsors/ismoh?style=for-the-badge)

[![GitHub](https://img.shields.io/github/license/ismoh/noitamp?style=for-the-badge)](https://github.com/Ismoh/NoitaMP/blob/master/LICENSE.md)

---

I love to play [Noita](https://noitagame.com/)! You should give it a try!
Usually I like to play with my friends. Truly Noita is made for being a single-player game,
but I can't get rid of the idea to try implementing a multiplayer mod, just to share all the feelings playing Noita with
friends.

Let's see, if I can do so?! I am new to Lua and modding, but someone said to me: "You seem to be asking the right questions".

<div align="center">

[![gif](miscs/2022-06-21_teaser.gif)](miscs/2022-06-21_teaser.gif)

21.06.2022 teaser
</div>

## Documentation

Installation, configuration and support can be found on the [docs](https://ismoh.github.io/NoitaMP/).

## Our awesome and valuable Contributors

<a href="https://github.com/Ismoh/NoitaMP/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Ismoh/NoitaMP" />
</a>

## Credits, Supporter and special thanks

I wouldn't be able to create this mod without the help by

- [@EvaisaGiac](https://github.com/EvaisaGiac/)
- [@TheHorscht](https://github.com/TheHorscht/)
- [@Pyry](https://github.com/probable-basilisk)
- [@DevonX](https://github.com/DevonX)
- [@shebpamm](https://github.com/shebpamm)
- @Coxas/Thighs
- [@dextercd](https://github.com/dextercd)
- [@BlueAmulet](https://github.com/BlueAmulet)
- [@Shaw](https://github.com/ShawSumma)
- [@Ramiels](https://github.com/Ramiels)
- [@bruham](https://steamcommunity.com/id/bruham/myworkshopfiles/?appid=881100)
- [@ofoxsmith](https://github.com/ofoxsmith)
- [@Nathan](https://github.com/Nathdsgfiugaoiysfnhuah/)
- [@Myzumi](https://github.com/Myzumi)

I also want to say thank you to the sponsors of this project on

- [GitHub](https://github.com/sponsors/Ismoh)
- [Patreon](https://www.patreon.com/ismoh)
- [Discord](https://donatebot.io/checkout/747169041457872917)

|                    Name                     |  Amount  |    Type    |     Start      |
|:-------------------------------------------:|:--------:|:----------:|:--------------:|
|  [stefnotch](https://github.com/stefnotch)  |   20$    |  one-time  |  Nov 18, 2022  |
|  [den3606](https://github.com/den3606)      |    1$    |  monthly   |  Feb 8, 2023   |
|  [clragon](https://github.com/clragon)      |   25$    |  one-time  |  Feb 17, 2023  |
|  [stefnotch](https://github.com/stefnotch)  |   20$    |  one-time  |  Jul 13, 2023  |
|  [conga lyne](https://github.com/Conga0)    |   25$    |  monthly   |  Jul 13, 2023  |
|  [clragon](https://github.com/clragon)      |   20$    |  one-time  |  Jul 13, 2023  |

If you spot anything I should mention, feel free to create an issue or get in touch with [me](https://github.com/Ismoh)!

### Used libraries, frameworks and other stuff

Also, special thanks to the people, who share their libraries, frameworks and other stuff. See below!

- custom lua51.dll provided by Noita
- [luaJIT-2.0.4](https://github.com/LuaJIT/LuaJIT/releases/tag/v2.0.4) used by Noita
- [eNet](http://enet.bespin.org/) for network communication
- [lua-enet](https://github.com/leafo/lua-enet) for being able to use eNet in Lua
- [sock.lua](https://github.com/camchenry/sock.lua) for 'easy' to use lua-enet and eNet in Lua
- ~~[bitser.lua](https://github.com/gvx/bitser) for old serializing and deserializing data~~
- [pprint.lua](https://github.com/jagt/pprint.lua) for debugging with pretty prints
- ~~[json.lua](https://github.com/rxi/json.lua) for serializing and deserializing data in json format~~
- ~~[nxml.lua](https://github.com/zatherz/luanxml) for editing xml files used by Noita~~
- ~~[EZGUI.lua](https://github.com/TheHorscht/EZGUI) for the GUI, but unfortunately it isn't maintained anymore~~
- [lua-watcher.lua](https://github.com/EvandroLG/lua-watcher) for getting the correct save path for Noita
- ~~[lfs-ffi.lua](https://github.com/sonoro1234/luafilesystem) for lua file system~~
- ~~[deepcopy.lua](https://gist.github.com/Deco/3985043) for being able to copy tables~~
- [libzstd.dll](https://github.com/facebook/zstd) for being able to compress and decompress data
- [zstd.lua](https://github.com/sjnam/luajit-zstd) for easy to use libzstd.dll in Lua
- [lua-MessagePack](https://framagit.org/fperrad/lua-MessagePack/-/tree/0.5.2) for serializing and deserializing data
- ~~[plotly.lua](https://github.com/kenloen/plotly.lua) for plotting profiled data~~
- [dkjson.lua](https://github.com/LuaDist/dkjson) needed by plotly.lua

I had to build the network library by my own, because Noita provides its own lua51.dll. I struggled to build it, if you are interested in,
I've added all the necessary build files inside of .building/dll_building.7z and here you can see the [stackoverflow question](https://stackoverflow.com/questions/70048918/lua-5-1-package-loadlib-and-require-gcc-building-windows-dll) I've created.

[![Timeline graph](https://images.repography.com/36027144/Ismoh/NoitaMP/recent-activity/jAELA8Z3rdlroh0bPJvficEtziU3iyDdNnTghMkIcw0/_530-g9qI7Ne9TS6ZHbAFiMyTtIpN5ijgQKz3hwdxrU_timeline.svg)](https://github.com/Ismoh/NoitaMP/commits)

[![Issue status graph](https://images.repography.com/36027144/Ismoh/NoitaMP/recent-activity/jAELA8Z3rdlroh0bPJvficEtziU3iyDdNnTghMkIcw0/_530-g9qI7Ne9TS6ZHbAFiMyTtIpN5ijgQKz3hwdxrU_issues.svg)](https://github.com/Ismoh/NoitaMP/issues)

[![Pull request status graph](https://images.repography.com/36027144/Ismoh/NoitaMP/recent-activity/jAELA8Z3rdlroh0bPJvficEtziU3iyDdNnTghMkIcw0/_530-g9qI7Ne9TS6ZHbAFiMyTtIpN5ijgQKz3hwdxrU_prs.svg)](https://github.com/Ismoh/NoitaMP/pulls)
