# Noita Multiplayer

I love to play [Noita](https://noitagame.com/)! You should give it a try!
Usually I like to play with my friends. Truly Noita is made for beeing a singleplayer game,
but I can't get rid of the idea to try implemting a multiplayer mod, just to share all the feelings playing Noita with friends.
Let's see, if I can do so?!

## Noita Together Reference

[Noita Together](https://github.com/soler91/noita-together) is a mod I was inspired by trying to do my own mod!
It's awesome and it's more or less a reference to this. You really should try Noita Together! (Just to be clear, there is no 'stolen' code.)

## Credits | Special Thanks

I wouldn't be able to create this mod without the help by

- @Evaisa
- @Horscht
- @M127
- @Pyry
- Soler91

I appreaciate your help a lot!
If you spot anything I should mention, feel free to create a issue or get in touch with me!

Also special thanks to the ppl, who share their libraries, frameworks and other stuff. See below!

### Used libraries, frameworks and other stuff

- lua 5.1 (lua51.dll provided by Noita)
- [luaJIT-2.0.4](https://github.com/LuaJIT/LuaJIT/releases/tag/v2.0.4) (also used by Noita)
- [eNet](http://enet.bespin.org/)
- [lua-enet](https://github.com/leafo/lua-enet)
- [sock.lua](https://github.com/camchenry/sock.lua)

I had to build the network library by my own, because Noita provides its own lua51.dll. I had struggle to build it, if you are interested in,
I've added all the necessary build files inside of .building/dll_building.7z and here you can see the [stackoverflow question](https://stackoverflow.com/questions/70048918/lua-5-1-package-loadlib-and-require-gcc-building-windows-dll) I've created.

### Testing (wip)

[![lua-testing](https://github.com/Ismoh/NoitaMP/actions/workflows/lua-testing.yml/badge.svg?event=push)](https://github.com/Ismoh/NoitaMP/actions/workflows/lua-testing.yml)
[![lua-testing](https://github.com/Ismoh/NoitaMP/actions/workflows/lua-testing.yml/badge.svg?event=pull_request)](https://github.com/Ismoh/NoitaMP/actions/workflows/lua-testing.yml)
[![codecov](https://codecov.io/gh/Ismoh/NoitaMP/branch/develop/graph/badge.svg?token=9WPMOAJIGY)](https://codecov.io/gh/Ismoh/NoitaMP)
