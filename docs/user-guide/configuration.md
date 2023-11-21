# Configuration

You are able to define, which entities should be synced by changing the corresponding file:

'**...\\Noita\\mods\\noita-mp\\config.lua**'

Here is an example of the default include and exclude list:

```lua
if not EntityUtils then
    _G.EntityUtils = {}
end

EntityUtils.include = {
    byComponentsName = { "VelocityComponent", "PhysicsBodyComponent", "PhysicsBody2Component", "ItemComponent", "PotionComponent" },
    byFilename = {}
}
EntityUtils.exclude = {
    byComponentsName = {},
    byFilename = { "particle", "tree_entity.xml", "vegetation" }
}
```

Make sure that `_G.EntityUtils` will be defined and not nil.

You can include entities by their component or file names. In addition you are also able to exclude entities for better performance reasons.

In addition to this there are some settings/configurations inside Noitas Mod Settings:

![Mod Settings](/resources/img/mod-settings.png)

| Setting                              | Description                                                                                            |
|--------------------------------------|--------------------------------------------------------------------------------------------------------|
| Username                             | Name displayed when playing                                                                            |
| GUID                                 | Globally Unique Identifier                                                                             |
| Server                               |                                                                                                        |
| Server IP                            | IP on which the server be started                                                                      |
| Server Port                          | Port                                                                                                   |
| Server Password                      | TBC, not possible atm                                                                                  |
| Server start behaviour               | On = Starts the server immediatly when starting the run Off = Server has to be started manually        |
| Radius to detect entities            | Higher value = small freezes, but better sync! Value to low = DEsync!                                  |
| Client                               |                                                                                                        |
| Connect Server IP                    | IP where you want to connect as a client                                                               |
| Connect Server Port                  | Port                                                                                                   |
| Connect Server Password              | The servers password. TBC, not possible atm                                                            |
| Radius to remove entities on clients | Higher value = better sync! Value to low = strange behaviour!                                          |
| Key Bindings                         |                                                                                                        |
| Toggle multiplayer menu              | Not possible atm                                                                                       |
| Debug settings                       |                                                                                                        |
| Toggle debug (in game)               | Enable nuid debugger in a run. Nothing you can do with :)                                              |
| Log level                            | Will be interesting when something isnt working, but for higher fps and performance, keep it on Error! |
