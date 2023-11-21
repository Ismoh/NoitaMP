# Credits

## Our awesome and valuable Contributors

[![Contributors](https://contrib.rocks/image?repo=Ismoh/NoitaMP)](https://github.com/Ismoh/NoitaMP/graphs/contributors)

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
- <s>[bitser.lua](https://github.com/gvx/bitser) for old serializing and deserializing data</s>
- [pprint.lua](https://github.com/jagt/pprint.lua) for debugging with pretty prints
- <s>[json.lua](https://github.com/rxi/json.lua) for serializing and deserializing data in json format</s>
- [nxml.lua](https://github.com/zatherz/luanxml) for editing xml files used by Noita
- <s>[EZGUI.lua](https://github.com/TheHorscht/EZGUI) for the GUI, but unfortunately it isn't maintained anymore</s>
- [lua-watcher.lua](https://github.com/EvandroLG/lua-watcher) for getting the correct save path for Noita
- [lfs-ffi.lua](https://github.com/sonoro1234/luafilesystem) for lua file system
- [deepcopy.lua](https://gist.github.com/Deco/3985043) for being able to copy tables
- [libzstd.dll](https://github.com/facebook/zstd) for being able to compress and decompress data
- [zstd.lua](https://github.com/sjnam/luajit-zstd) for easy to use libzstd.dll in Lua
- [lua-MessagePack](https://framagit.org/fperrad/lua-MessagePack/-/tree/0.5.2) for serializing and deserializing data
- [plotly.lua](https://github.com/kenloen/plotly.lua) for plotting profiled data
- [dkjson.lua](https://github.com/LuaDist/dkjson) needed by plotly.lua

I had to build the network library by my own, because Noita provides its own lua51.dll. I struggled to build it, if you are interested in,
I've added all the necessary build files inside of .building/dll_building.7z and here you can see the [stackoverflow question](https://stackoverflow.com/questions/70048918/lua-5-1-package-loadlib-and-require-gcc-building-windows-dll) I've created.
