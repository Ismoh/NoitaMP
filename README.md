# Noita Multiplayer

<div align="center">

[![platform](https://img.shields.io/badge/platform-ubuntu%20%7C%20windows-lightgrey?style=flat-square)](https://github.com/Ismoh/NoitaMP)[![ubuntu master](https://img.shields.io/github/workflow/status/ismoh/noitamp/Ubuntu%20Lua%20Unit%20Testing/master?label=&logo=ubuntu&style=flat-square)](https://github.com/Ismoh/NoitaMP/actions/workflows/ubuntu-latest-lua-unit-testing.yml?query=branch%3Amaster)[![windows master](https://img.shields.io/github/workflow/status/ismoh/noitamp/Windows%20Lua%20Unit%20Testing/master?label=&logo=windows&style=flat-square)](https://github.com/Ismoh/NoitaMP/actions/workflows/windows-latest-lua-unit-testing.yml?query=branch%3Amaster)

[![latest release](https://img.shields.io/github/v/release/ismoh/noitamp?include_prereleases&label=latest%20release&style=flat-square)](https://github.com/Ismoh/NoitaMP/releases)
[![amount of releases](https://flat.badgen.net/github/releases/ismoh/noitamp)](https://github.com/Ismoh/NoitaMP/releases)
[![last-commit](https://img.shields.io/github/last-commit/ismoh/noitamp?style=flat-square)](https://github.com/Ismoh/NoitaMP/commit/develop)

[![issues](https://flat.badgen.net/github/issues/ismoh/noitamp)](https://github.com/Ismoh/NoitaMP/issues?q=is%3Aissue)
[![open-issues](https://flat.badgen.net/github/open-issues/ismoh/noitamp)](https://github.com/Ismoh/NoitaMP/issues)
[![open-issues-help-wanted](https://flat.badgen.net/github/label-issues/ismoh/noitamp/help%20wanted/open)](https://github.com/Ismoh/NoitaMP/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22)

[![ubuntu - unit testing on develop](https://img.shields.io/github/workflow/status/ismoh/noitamp/Ubuntu%20Lua%20Unit%20Testing/develop?label=tests&logo=ubuntu&style=flat-square)](https://github.com/Ismoh/NoitaMP/actions/workflows/ubuntu-latest-lua-unit-testing.yml?query=branch%3Adevelop)
[![windows - unit testing on develop](https://img.shields.io/github/workflow/status/ismoh/noitamp/Windows%20Lua%20Unit%20Testing/develop?label=tests&logo=windows&style=flat-square)](https://github.com/Ismoh/NoitaMP/actions/workflows/windows-latest-lua-unit-testing.yml?query=branch%3Adevelop)

[![Coveralls](https://img.shields.io/coveralls/github/Ismoh/NoitaMP?logo=coveralls&style=flat-square)](https://coveralls.io/github/Ismoh/NoitaMP)
[![Codecov](https://img.shields.io/codecov/c/gh/Ismoh/NoitaMP?logo=codecov&style=flat-square)](https://codecov.io/gh/Ismoh/NoitaMP)

[![watchers](https://flat.badgen.net/github/watchers/ismoh/noitamp)](https://github.com/Ismoh/NoitaMP/watchers)
[![stars](https://flat.badgen.net/github/stars/ismoh/noitamp)](https://github.com/Ismoh/NoitaMP/stargazers)
[![forks](https://flat.badgen.net/github/forks/ismoh/noitamp)](https://github.com/Ismoh/NoitaMP/network/members)

[![license](https://flat.badgen.net/github/license/ismoh/noitamp)](https://github.com/Ismoh/NoitaMP/blob/develop/LICENSE)

</div>

I love to play [Noita](https://noitagame.com/)! You should give it a try!
Usually I like to play with my friends. Truly Noita is made for being a single-player game,
but I can't get rid of the idea to try implementing a multiplayer mod, just to share all the feelings playing Noita with
friends.
Let's see, if I can do so?!

<div align="center">

[![gif](misc/2022-06-21_teaser.gif)](misc/2022-06-21_teaser.gif)

</div>

## Documentation

Installation, configuration and support can be found on the [docs](https://ismoh.github.io/NoitaMP/).

## Our awesome and valuable Contributors

<a href="https://github.com/Ismoh/NoitaMP/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Ismoh/NoitaMP" />
</a>

## Credits | Special Thanks

I wouldn't be able to create this mod without the help by

- [@EvaisaGiac](https://github.com/EvaisaGiac/)
- [@TheHorscht](https://github.com/TheHorscht/)
- [@Pyry](https://github.com/probable-basilisk)
- [@DevonX](https://github.com/DevonX)
- [@shebpamm](https://github.com/shebpamm)
- @Coxas/Thighs
- [@dextercd](https://github.com/dextercd)
- [@BlueAmulet](https://github.com/BlueAmulet)

I appreaciate your help a lot!
If you spot anything I should mention, feel free to create a issue or get in touch with [me](https://github.com/Ismoh)!

Also special thanks to the ppl, who share their libraries, frameworks and other stuff. See below!

### Used libraries, frameworks and other stuff

- lua 5.1 (lua51.dll provided by Noita)
- [luaJIT-2.0.4](https://github.com/LuaJIT/LuaJIT/releases/tag/v2.0.4) (also used by Noita)
- [eNet](http://enet.bespin.org/)
- [lua-enet](https://github.com/leafo/lua-enet)
- [sock.lua](https://github.com/camchenry/sock.lua)
- [pprint.lua](https://github.com/jagt/pprint.lua)
- [json.lua](https://github.com/rxi/json.lua)
- [nxml.lua](https://github.com/zatherz/luanxml)
- [EZGUI.lua](https://github.com/TheHorscht/EZGUI)
- [lua-watcher.lua](https://github.com/EvandroLG/lua-watcher)
- [lfs-ffi.lua](https://github.com/sonoro1234/luafilesystem)

I had to build the network library by my own, because Noita provides its own lua51.dll. I had struggle to build it, if you are interested in,
I've added all the necessary build files inside of .building/dll_building.7z and here you can see the [stackoverflow question](https://stackoverflow.com/questions/70048918/lua-5-1-package-loadlib-and-require-gcc-building-windows-dll) I've created.
