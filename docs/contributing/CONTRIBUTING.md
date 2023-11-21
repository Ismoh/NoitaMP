# Contributing to NoitaMP

I am happy to accept contributions to NoitaMP.
Please follow these guidelines when contributing,
but first off, thanks for taking the time to contribute!

## Table of Contents

- [Requirements](#requirements)
- [Contributing](#contributing)
  - [Before contributing](#before-contributing)
- [How does NoitaMP work?](#how-does-noitamp-work)
- [Important resources](#important-resources)

## Requirements

- [ ] I have read the [Contributing](CONTRIBUTING.md) document.
- [ ] I have read the [Code of Conduct](CODE_OF_CONDUCT.md) document.
- [ ] I have read the [LICENSE](/about/LICENSE.md) document.
- [ ] I have experience in Lua.
- [ ] I have experience in Noita modding.

To be honest, I am sure that you have experience in Lua and Noita modding and if you read this, you will probably be able to contribute to NoitaMP.
Everything will be explained here and if there are still questions, you can ask them in the [Discord server](https://discord.gg/DhMurdcw4k).

## Contributing

### Before contributing

Please get in contact with me or the other collaborators on [Discord](https://discord.gg/DhMurdcw4k), before you start working on a feature or a bug fix.
This is to avoid duplicate work.

## How does NoitaMP work?

NoitaMP is a mod that uses the [Noita API](https://noita.wiki.gg/wiki/Modding), but there is something that you need to know about the API.
The API is a Lua library that is used to interact with the game.
The API is not a mod, it is a library that is used to create mods.

### Lua context

There are different Lua contexts in Noita, but the most important one is the `init.lua` context.

### Contexts in Noita

Let me try to explain it with an example:
![NoitaMP](/resources/img/lua-contexts.png)
In the diagram above you can see the default Noita modding structure.
There are different Lua contexts:

- One for `init.lua`
  - This is the 'main' context that is used to interact with NoitaMP, because unrestricted Lua code (unrestricted mod mode) is only available in the `init.lua` context.
- and contexts for `LuaComponents`
  - How contexts for LuaComponents are defined, depends on the value of `vm_type`.
    `SHARED_BY_MANY_COMPONENTS` means that for that script path, it uses a single Lua context.
    `ONE_PER_COMPONENT_INSTANCE` means that even with the same script path, every LuaComponent has its own Lua context.
    The path of the entity XML file is irrelevant as far as I can tell.
    `SHARED_BY_MANY_COMPONENTS` is the default, see [wiki](https://noita.wiki.gg/wiki/Documentation:_LuaComponent)

    _Credits to dextercd_

**You are able to use Noita API functions in each context, but you are not able to use functions from other contexts.**
There is no way to access the `init.lua` context from a LuaComponent context and vice versa, **but there are workarounds**!

### Workarounds for communication between contexts

There are different ways to communicate between contexts:

- by Noita API Globals `GlobalsSetValue` and `GlobalsGetValue`
- VariableStorageComponents
- Using `init.lua` context only

Assume we need a value in NoitaMP, which can only be fetched in LuaComponents. So in different Lua contexts!
We can solve this problem by the examples below:

#### GlobalsSetValue and GlobalsGetValue

Then we would set a global "foo" variable in the `LuaComponent` context _(see 1 and 2 in the diagram below)_
and afterwards we would use the `init.lua` context to fetch the value of the global "foo" variable _(see 3 and 4 in the diagram below)_.
In addition, please note that `GlobalsSetValue` and `GlobalsGetValue` has nothing to do with Lua globals `_G`.
See diagram below for a better understanding:
![NoitaMP](/resorces/img/lua-contexts-workaround.png)

#### VariableStorageComponents

Another workaround is to use `VariableStorageComponents` to store values in the `LuaComponent` context and to fetch them in the `init.lua` context.
In a LuaComponent context, we would create a `VariableStorageComponent` and set a value in it:

```lua
local componentId = EntityAddComponent2(entityId, "VariableStorageComponent",
    {
        name         = "exampleName",
        value_string = "exampleValue"
    }
)
```

In the `init.lua` context, we would fetch the value of the `VariableStorageComponent` with the name `"exampleName"`:

```lua
local componentIds = EntityGetComponentIncludingDisabled(entityId, "VariableStorageComponent") or {}
for i = 1, #componentIds do
  local componentId = componentIds[i]
  -- get the components name
  local componentName    = tostring(ComponentGetValue2(componentId, "name"))
  if string.find(componentName, "exampleName", 1, true) then
    -- if the name of the component match to the one we are searching for, then get the value
    local value = tostring(ComponentGetValue2(componentId, "value_string"))
    return componentIds[i], value
  end
end
```

#### Using init.lua context only

If you are able to use the `init.lua` context only, then you can use the NoitaMP functions directly.
For example, if you want to get local player/Minä, then you can use the NoitaMP function `MinaUtils.getLocalMinaInformation()`:

```lua
--- Gets the local player information.
--- Including polymorphed entity id. When polymorphed, entityId will be the new one and not minäs anymore.
--- @return PlayerInfo playerInfo
function MinaUtils.getLocalMinaInformation()
  -- more code
  local ownerName = tostring(ModSettingGet("noita-mp.name"))
  local ownerGuid = tostring(ModSettingGet("noita-mp.guid"))
  local entityId  = MinaUtils.getLocalMinaEntityId()
  local nuid = nil
  -- yet another code fragment
end
```

## 'Classes' in NoitaMP

Most of NoitaMPs functions are in 'class' tables, available in Luas globals `_G`.
I tried to create topics for each class table, so you can find the global classes per topic:

- Mostly everything regarding Entities: `EntityUtils.lua`
- Mostly everything regarding Globals: `GlobalsUtils.lua`
- Mostly everything regarding Network: `NetworkUtils.lua`, besides `Server.lua` and `Client.lua`
- Mostly everything regarding (Network)VariableStorageComponents: `NetworkVscUtils.lua`
- Just some utilise functions: `util.lua`
- and so on...

I try to use KISS (Keep It Simple Stupid) and DRY (Don't Repeat Yourself) as much as possible.
So before you want to add a new function, please try to use existing functions and classes, if possible.
If there are no existing functions or classes you could use, then take in mind:

- to create a new class with functions
- or to add functions to existing classes
- and add the `CustomProfiler` per new function.

`CustomProfiler` is a class that is used to measure the execution time of a function, because we had terrible performance issues and memory leaks in the past.
Therefore it is important to measure the time of each function, so we can find the functions that are causing performance issues.
To add the CustomProfiler to a function, you can use the following example:

```lua
function EntityUtils.isEntityPolymorphed(entityId)
  -- first line of the function should be the CustomProfiler
  local cpc = CustomProfiler.start("EntityUtils.isEntityPolymorphed")
  --                                ClassName.functionName
  -- your code
  --
  -- last line of the function should be the CustomProfiler
  CustomProfiler.stop("EntityUtils.isEntityPolymorphed", cpc)
  -- Make sure to use the same name as in the start function and the same cpc variable
  -- if there is a return value, then put CustomProfiler.stop() before the return
  return false
end
```

## Making use of LuaRocks

### Setup

### Usage

## TTD - Test Driven Development

Please! Please! Please, make sure to write tests for your functions!
I know it is not easy to write tests, but it is very important to do so.
If you are not able to write tests, then please ask for help in the Discord server.
I will help you to write tests for your functions.
I will not accept any pull requests without tests, sorry.

### Location of tests

`mods/noita-mp/tests/`

### How to run tests

See LuaRocks section above.

### How to write tests?

Simple example by adding a new function to an existing test class:
_Assume you've added a new event to **NetworkUtils.events**, then make sure to extend the **TestNetworkUtils** table in **NetworkUtils_test.lua**.)_

```lua
```

How to run tests?
`luarocks test > result.log`

If there are any questions left, then please ask them on [Discord](https://discord.gg/DhMurdcw4k).

### Important resources

Along with this document, the following resources are important when contributing to NoitaMP:

- documentation
- bugs
- communication
