# Client

## __index


```lua
Client
```

## deserialize


```lua
function Client.deserialize(self: Client, value: any)
  -> unknown
```

Defualt enhanced serialization function

## new


```lua
function Client.new(self: Client, tOrSockClient: Client|SockClient)
  -> Client
```

Class constructor

## serialize


```lua
function Client.serialize(self: Client, value: any)
  -> unknown
```

Defualt enhanced serialization function


---

# CustomProfiler

Simple profiler that can be used to measure the duration of a function and the memory usage of a function.

## __index


```lua
CustomProfiler
```

Simple profiler that can be used to measure the duration of a function and the memory usage of a function.

## ceiling


```lua
integer
```

The ceiling in milliseconds. If a function takes longer than this ceiling, it will be truncated.
 Default: 1001 ms

## counter


```lua
integer
```

The counter that is used to determine the order of the function calls.

## getSize


```lua
function CustomProfiler.getSize(self: CustomProfiler)
  -> size: number
```

Returns the size of the report cache.

## init


```lua
function CustomProfiler.init(self: CustomProfiler)
```

## maxEntries


```lua
integer
```

The maximum amount of entries per trace.
 Default: 50

## new


```lua
function CustomProfiler.new(self: CustomProfiler, t: CustomProfiler|nil, otherClassesIfRequireLoop: any)
  -> CustomProfiler
```

CustomProfiler constructor.

## report


```lua
function CustomProfiler.report(self: CustomProfiler)
```

Creates a report of all the functions that were profiled into profiler_2022-11-24_20-23-00.json

## reportCache


```lua
{ [string]: table<number, table<string, number>> }
```

A cache that stores all the data that is used to generate the report.

## reportDirectory


```lua
string
```

The directory where the report will be saved.

## reportFilename


```lua
string
```

The filename of the report.
 Default: report.html

## reportJsonFilenamePattern


```lua
string
```

The filename pattern of the report.
 Default: %s.json

## start


```lua
function CustomProfiler.start(self: CustomProfiler, functionName: string)
  -> returnCounter: number
```

Starts the profiler. This has to be called before the function (or first line of function code) that you want to measure.

@*param* `functionName` — The name of the function that you want to measure. This has to be the same as the one used in CustomProfiler:stop(functionName, customProfilerCounter)

@*return* `returnCounter` — The counter that is used to determine the order of the function calls. This has to be passed to CustomProfiler:stop(functionName, customProfilerCounter)
See: [CustomProfiler](file:///d%3A/a/NoitaMP/NoitaMP/mods/noita-mp/files/scripts/util/GlobalsUtils.lua#32#8) stop(functionName, customProfilerCounter)

## stop


```lua
function CustomProfiler.stop(self: CustomProfiler, functionName: string, customProfilerCounter: number)
  -> integer
```

Stops the profiler. This has to be called after the function (or last line of function code, but before any `return`) that you want to measure.

@*param* `functionName` — The name of the function that you want to measure. This has to be the same as the one used in @see CustomProfiler.start(functionName)

@*param* `customProfilerCounter` — The counter that is used to determine the order of the function calls. This has to same as the one returned by @see CustomProfiler.start(functionName)

## threshold


```lua
number
```

The threshold in milliseconds. If a function takes longer than this threshold, it will be reported.
 Default: 16.5ms = 60.60 fps


---

# CustomProfiler

Simple profiler that can be used to measure the duration of a function and the memory usage of a function.


```lua
CustomProfiler
```


---

# CustomProfiler.start


```lua
function CustomProfiler.start(functionName: any)
```


---

# CustomProfiler.start


```lua
function
```


```lua
function
```


---

# CustomProfiler.stop


```lua
function CustomProfiler.stop(functionName: any, customProfilerCounter: any)
```


---

# FileUtils


```lua
FileUtils
```


```lua
FileUtils
```


---

# FileUtils

## AppendToFile


```lua
function FileUtils.AppendToFile(filenameAbsolutePath: string, appendContent: string)
```

## Create7zipArchive


```lua
function FileUtils.Create7zipArchive(archive_name: string, absolute_directory_path_to_add_archive: string, absolute_destination_path: string)
  -> content: string|number
```

@*param* `archive_name` — server_save06_98-09-16_23:48:10 - without file extension (*.7z)

@*param* `absolute_directory_path_to_add_archive` — C:\Users\Ismoh-PC\AppData\LocalLow\Nolla_Games_Noita\save06

@*param* `absolute_destination_path` — C:\Program Files (x86)\Steam\steamapps\common\Noita\mods
oita-mp\_

@*return* `content` — binary content of archive

## Exists


```lua
function FileUtils.Exists(absolutePath: string)
  -> boolean
```

 Checks if FILE or DIRECTORY exists

@*param* `absolutePath` — full path

## Exists7zip


```lua
function FileUtils.Exists7zip()
  -> boolean
```

## Extract7zipArchive


```lua
function FileUtils.Extract7zipArchive(archive_absolute_directory_path: string, archive_name: string, extract_absolute_directory_path: string)
```

@*param* `archive_absolute_directory_path` — path to archive location like "C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\noita-mp\_"

@*param* `archive_name` — server_save06_98-09-16_23:48:10.7z - with file extension (*.7z)

@*param* `extract_absolute_directory_path` — C:\Users\Ismoh-PC\AppData\LocalLow\Nolla_Games_Noita

## FestartNoita


```lua
function FileUtils.FestartNoita()
```

 Credits to @dextercd !

## Find7zipExecutable


```lua
function FileUtils.Find7zipExecutable()
```

## GetAbsDirPathOfWorldStateXml


```lua
function FileUtils.GetAbsDirPathOfWorldStateXml(saveSlotAbsDirectoryPath: string)
  -> absPath: string
```

 There is a world_state.xml per each saveSlot directory, which contains Globals. Nuid are stored in Globals.

@*param* `saveSlotAbsDirectoryPath` — Absolute directory path to the current selected save slot.

@*return* `absPath` — world_state.xml absolute file path

## GetAbsoluteDirectoryPathOfNoitaMP


```lua
function FileUtils.GetAbsoluteDirectoryPathOfNoitaMP()
  -> FileUtils.GetAbsolutePathOfNoitaRootDirectory: string
```

 Returns the ABSOLUTE path of the mods folder.
 If FileUtils.GetAbsolutePathOfNoitaRootDirectory() is not set yet, then it will be

@*return* `FileUtils.GetAbsolutePathOfNoitaRootDirectory` — ) .. "/mods/noita-mp"

## GetAbsoluteDirectoryPathOfParentSave


```lua
function FileUtils.GetAbsoluteDirectoryPathOfParentSave()
  -> save06_parent_directory_path: string
```

 Return the parent directory of the savegame directory save06.
 If DebugGetIsDevBuild() then Noitas installation path is returned: 'C:\Program Files (x86)\Steam\steamapps\common\Noita'
 otherwise it will return: '%appdata%\..\LocalLow\Nolla_Games_Noita' on windows

@*return* `save06_parent_directory_path` — string of absolute path to '..\Noita' or '..\Nolla_Games_Noita'

## GetAbsoluteDirectoryPathOfRequiredLibs


```lua
function FileUtils.GetAbsoluteDirectoryPathOfRequiredLibs()
  -> FileUtils.GetAbsolutePathOfNoitaRootDirectory: string
```

 Returns the ABSOLUTE path of the library folder required for this mod.
 If FileUtils.GetAbsolutePathOfNoitaRootDirectory() is not set yet, then it will be

@*return* `FileUtils.GetAbsolutePathOfNoitaRootDirectory` — ) .. "/mods/noita-mp/files/libs"

## GetAbsoluteDirectoryPathOfSave06


```lua
function FileUtils.GetAbsoluteDirectoryPathOfSave06()
  -> directory_path_of_save06: string
```

 Returns fullpath of save06 directory on devBuild or release

@*return* `directory_path_of_save06` — : noita installation path\save06 or %appdata%\..\LocalLow\Nolla_Games_Noita\save06 on windows and unknown for unix systems

## GetAbsolutePathOfNoitaMpSettingsDirectory


```lua
function FileUtils.GetAbsolutePathOfNoitaMpSettingsDirectory()
  -> absPath: string
```

 Returns absolute path of NoitaMP settings directory,

@*return* `absPath` — i.e. "C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\noita-mp\settings"

## GetAbsolutePathOfNoitaRootDirectory


```lua
function FileUtils.GetAbsolutePathOfNoitaRootDirectory()
  -> string
```

## GetAllFilesInDirectory


```lua
function FileUtils.GetAllFilesInDirectory(directory: any, fileExtension: any)
  -> table
```

## GetDesktopDirectory


```lua
function FileUtils.GetDesktopDirectory()
  -> string|table
```

## GetLastModifiedSaveSlots


```lua
function FileUtils.GetLastModifiedSaveSlots()
  -> table
```

 see _G.saveSlotMeta

## GetPidOfRunningEnetHostByPort


```lua
function FileUtils.GetPidOfRunningEnetHostByPort()
  -> number?
```


 eNet specific commands

## GetRelativeDirectoryPathOfNoitaMP


```lua
function FileUtils.GetRelativeDirectoryPathOfNoitaMP()
  -> string
```

 Returns the RELATIVE path of the mods folder.

@*return* — mods/noita-mp

## GetRelativeDirectoryPathOfRequiredLibs


```lua
function FileUtils.GetRelativeDirectoryPathOfRequiredLibs()
  -> string
```

 Returns the RELATIVE path of the library folder required for this mod.

@*return* — /mods/noita-mp/files/libs

## GetRelativePathOfNoitaMpSettingsDirectory


```lua
function FileUtils.GetRelativePathOfNoitaMpSettingsDirectory()
  -> unknown
```

## GetVersionByFile


```lua
function FileUtils.GetVersionByFile()
  -> string
```

## IsDirectory


```lua
function FileUtils.IsDirectory(full_path: string)
  -> boolean
```

## IsFile


```lua
function FileUtils.IsFile(full_path: string)
  -> boolean
```

## KillNoitaAndRestart


```lua
function FileUtils.KillNoitaAndRestart()
```

## KillProcess


```lua
function FileUtils.KillProcess(pid: any)
```

## MkDir


```lua
function FileUtils.MkDir(full_path: string)
```

## ReadBinaryFile


```lua
function FileUtils.ReadBinaryFile(file_fullpath: string)
  -> string|number
```

## ReadFile


```lua
function FileUtils.ReadFile(file_fullpath: string, mode?: string)
  -> unknown
```

## RemoveContentOfDirectory


```lua
function FileUtils.RemoveContentOfDirectory(absolutePath: any)
```

## RemoveTrailingPathSeparator


```lua
function FileUtils.RemoveTrailingPathSeparator(path: string)
  -> path: string
```

 Removes trailing path separator in a string: \persistent\flags\ -> \persistent\flags.
 Error if path is not a string.

@*param* `path` — any string, i.e. \persistent\flags\

@*return* `path` — \persistent\flags

## ReplacePathSeparator


```lua
function FileUtils.ReplacePathSeparator(path: string)
  -> path: string
```

 Replaces windows path separator to unix path separator and vice versa.
 Error if path is not a string.

## SaveAndRestartNoita


```lua
function FileUtils.SaveAndRestartNoita()
```

 This executes c code to sent SDL_QUIT command to the app

## ScanDir


```lua
function FileUtils.ScanDir(directory: any)
  -> string[]
```

 Lua implementation of PHP scandir function

## SetAbsolutePathOfNoitaRootDirectory


```lua
function FileUtils.SetAbsolutePathOfNoitaRootDirectory()
```

 Sets root directory of noita.exe, i.e. C:\Program Files (x86)\Steam\steamapps\common\Noita

## SplitPath


```lua
function FileUtils.SplitPath(str: any)
  -> unknown
```

 http://lua-users.org/wiki/SplitJoin -> Example: Split a file path string into components.

## WriteBinaryFile


```lua
function FileUtils.WriteBinaryFile(file_fullpath: string, file_content: any)
```

## WriteFile


```lua
function FileUtils.WriteFile(file_fullpath: string, file_content: string)
```


---

# GetWidthAndHeightByResolution

 Returns width and height depending on resolution.
 GuiGetScreenDimensions( gui:obj ) -> width:number,height:number [Returns dimensions of viewport in the gui coordinate system (which is equal to the coordinates of the screen bottom right corner in gui coordinates). The values returned may change depending on the game resolution because the UI is scaled for pixel-perfect text rendering.]


```lua
function GetWidthAndHeightByResolution()
  -> width: number
  2. height: number
```


---

# GlobalsUtils

 GlobalsUtils:
 class for GlobalsSetValue and GlobalsGetValue


```lua
table
```


---

# GlobalsUtils.getDeadNuids


```lua
function GlobalsUtils.getDeadNuids()
  -> table
```


---

# GlobalsUtils.getNuidEntityPair

 Builds a key string by nuid and returns nuid and entityId found by the globals.


```lua
function GlobalsUtils.getNuidEntityPair(nuid: number)
  -> nuid: number|nil
  2. entityId: number|nil
```


---

# GlobalsUtils.getUpdateGui


```lua
function GlobalsUtils.getUpdateGui()
  -> unknown
```


---

# GlobalsUtils.parseXmlValueToNuidAndEntityId

 Parses key and value string to nuid and entityId.

@*param* `xmlKey` — GlobalsUtils.nuidKeyFormat = "nuid = %s"

@*param* `xmlValue` — GlobalsUtils.nuidValueFormat = "entityId = %s"


```lua
function GlobalsUtils.parseXmlValueToNuidAndEntityId(xmlKey: string, xmlValue: string)
  -> nuid: number|nil
  2. entityId: number|nil
```


---

# GlobalsUtils.removeDeadNuid


```lua
function GlobalsUtils.removeDeadNuid(nuid: any)
```


---

# GlobalsUtils.setDeadNuid


```lua
function GlobalsUtils.setDeadNuid(nuid: any)
```


---

# GlobalsUtils.setNuid


```lua
function GlobalsUtils.setNuid(nuid: any, entityId: any, componentIdForOwnerName: any, componentIdForOwnerGuid: any, componentIdForNuid: any)
```


---

# GlobalsUtils.setUpdateGui


```lua
function GlobalsUtils.setUpdateGui(bool: any)
  -> unknown
```


---

# Gui

Everything regarding ImGui: Credits to @dextercd

## new


```lua
function Gui.new()
  -> table
```


---

# Health

## current


```lua
number
```

## max


```lua
number
```


---

# Logger

## __index


```lua
Logger
```

## debug


```lua
function Logger.debug(self: Logger, channel: any, formattedMessage: any)
  -> boolean
```

## info


```lua
function Logger.info(self: Logger, channel: any, formattedMessage: any)
  -> boolean
```

## new


```lua
function Logger.new(self: Logger, logger: any)
  -> unknown
```

## trace


```lua
function Logger.trace(self: Logger, channel: any, formattedMessage: any)
  -> boolean
```

## warn


```lua
function Logger.warn(self: Logger, channel: any, formattedMessage: any)
  -> boolean
```


---

# Logger


```lua
Logger
```


---

# MAX_MEMORY_USAGE

 KB = 524,438 MB


```lua
integer
```


---

# MinaInformation

See:
  * [Transform](file:///d%3A/a/NoitaMP/NoitaMP/mods/noita-mp/files/scripts/util/MinaUtils.lua#144#18)
  * [Health](file:///d%3A/a/NoitaMP/NoitaMP/mods/noita-mp/files/scripts/util/NoitaComponentUtils.lua#55#14)


```lua
table
```


---

# MinaInformation


---

# MinaUtils

Util class for fetching information about local and remote minas.

## getAllMinas


```lua
function MinaUtils.getAllMinas()
  -> table
```

## getLocalMinaEntityId


```lua
function MinaUtils.getLocalMinaEntityId()
  -> localMinaEntityId: number|nil
```

Getter for local mina entity id. It also takes care of polymorphism!

@*return* `localMinaEntityId` — or nil if not found/dead

## getLocalMinaGuid


```lua
function MinaUtils.getLocalMinaGuid()
  -> localMinaGuid: string
```

Getter for local mina guid. ~It also loads it from settings file.~

## getLocalMinaInformation


```lua
function MinaUtils.getLocalMinaInformation()
  -> localMinaInformation: MinaInformation
```

Getter for local mina information. It also takes care of polymorphism!
 Deprecated: Use separated getters instead, like getLocalMinaName, getLocalMinaGuid, getLocalMinaEntityId, getLocalMinaNuid!
See: [MinaInformation](file:///d%3A/a/NoitaMP/NoitaMP/mods/noita-mp/files/scripts/util/MinaUtils.lua#151#14)

## getLocalMinaName


```lua
function MinaUtils.getLocalMinaName()
  -> localMinaName: string
```

Getter for local mina name. ~It also loads it from settings file.~

## getLocalMinaNuid


```lua
function MinaUtils.getLocalMinaNuid()
  -> nuid: number
```

Getter for local mina nuid. It also takes care of polymorphism!

@*return* `nuid` — if not found/dead

## isLocalMinaPolymorphed


```lua
function MinaUtils.isLocalMinaPolymorphed()
  -> isPolymorphed: boolean
  2. entityId: number|nil
```

Checks if local mina is polymorphed. Returns true, entityId | false, nil

## setLocalMinaGuid


```lua
function MinaUtils.setLocalMinaGuid(guid: string)
```

Setter for local mina guid. It also saves it to settings file.

## setLocalMinaName


```lua
function MinaUtils.setLocalMinaName(name: string)
```

Setter for local mina name. It also saves it to settings file.


---

# ModSettingGet


```lua
function _G.ModSettingGet(id: any)
  -> string|table
```


---

# NetworkCache


```lua
table
```


---

# NetworkCache.cache


```lua
table
```


```lua
table
```


---

# NetworkCache.clear


```lua
function NetworkCache.clear(clientCacheId: any)
```


---

# NetworkCache.get


```lua
function NetworkCache.get(clientCacheId: any, event: any, networkMessageId: any)
  -> unknown|nil
```


---

# NetworkCache.getAll


```lua
function NetworkCache.getAll()
  -> table|unknown
```


---

# NetworkCache.getChecksum


```lua
function NetworkCache.getChecksum(clientCacheId: any, dataChecksum: any)
  -> unknown|nil
```


---

# NetworkCache.set


```lua
function NetworkCache.set(clientCacheId: any, networkMessageId: any, event: any, status: any, ackedAt: any, sendAt: any, dataChecksum: any)
```


---

# NetworkCache.size


```lua
function NetworkCache.size()
  -> integer|unknown
```


---

# NetworkCache.usage


```lua
function NetworkCache.usage()
```


---

# NetworkCache.usingC

 not _G.disableLuaExtensionsDLL


```lua
boolean
```


---

# NetworkCacheUtils


```lua
table
```


---

# NetworkCacheUtils.ack


```lua
function NetworkCacheUtils.ack(peerGuid: any, networkMessageId: any, event: any, status: any, ackedAt: any, sendAt: any, checksum: any)
```


---

# NetworkCacheUtils.get

@*return* `data` — { ackedAt, dataChecksum, event, messageId, sendAt, status}


```lua
function NetworkCacheUtils.get(peerGuid: any, networkMessageId: any, event: any)
  -> data: table
```


---

# NetworkCacheUtils.getByChecksum

@*return* `cacheData` — { ackedAt, dataChecksum, event, messageId, sendAt, status}


```lua
function NetworkCacheUtils.getByChecksum(peerGuid: any, event: any, data: any)
  -> cacheData: table
```


---

# NetworkCacheUtils.getSum


```lua
function NetworkCacheUtils.getSum(event: any, data: any)
  -> string
```


---

# NetworkCacheUtils.logAll


```lua
function NetworkCacheUtils.logAll()
```


---

# NetworkCacheUtils.set

 Manipulates parameters to use Cache-CAPI.

@*param* `peerGuid` — peer.guid


```lua
function NetworkCacheUtils.set(peerGuid: string, networkMessageId: number, event: any, status: any, ackedAt: any, sendAt: any, data: any)
  -> string
```


---

# NetworkUtils

 Because of stack overflow errors when loading lua files,
 I decided to put Utils 'classes' into globals


```lua
table
```


```lua
table
```


---

# NetworkUtils.alreadySent

 Checks if the event within its data was already sent

@*param* `peer` — If Server, then it's the peer, if Client, then it's the 'self' object


```lua
function NetworkUtils.alreadySent(peer: table, event: string, data: table)
  -> boolean
```


---

# NetworkUtils.events


```lua
table
```


---

# NetworkUtils.getClientOrServer

 Sometimes you don't care if it's the client or server, but you need one of them to send the messages.

@*return* `Client` — or Server 'object'


```lua
function NetworkUtils.getClientOrServer()
  -> Client: Client|Server
```


---

# NetworkUtils.getNextNetworkMessageId


```lua
function NetworkUtils.getNextNetworkMessageId()
  -> integer
```


---

# NetworkUtils.isTick


```lua
function NetworkUtils.isTick()
  -> boolean
```


---

# NetworkUtils.networkMessageIdCounter


```lua
integer
```


```lua
integer
```


---

# NetworkVscUtils

 NetworkVscUtils:

## addOrUpdateAllVscs


```lua
function NetworkVscUtils.addOrUpdateAllVscs(entityId: number, ownerName: string, ownerGuid: string, nuid: number|nil, spawnX: number|nil, spawnY: number|nil)
  -> componentIdForOwnerName: integer|nil
  2. componentIdForOwnerGuid: integer|nil
  3. componentIdForNuid: integer|nil
  4. componentIdForNuidDebugger: integer|nil
  5. componentIdForNuidDebugger: integer|nil
```

 Simply adds or updates all needed Network Variable Storage Components.

@*param* `entityId` — Id of an entity provided by Noita

@*param* `ownerName` — Owners name. Cannot be nil.

@*param* `ownerGuid` — Owners guid. Cannot be nil.

@*param* `nuid` — Network unique identifier. Can only be nil on clients, but not on server.

@*param* `spawnX` — X position of the entity, when spawned. Can only be set once! Can be nil.

@*param* `spawnY` — Y position of the entity, when spawned. Can only be set once! Can be nil.

## checkIfSpecificVscExists


```lua
function NetworkVscUtils.checkIfSpecificVscExists(entityId: number, componentTypeName: string, fieldNameForMatch: string, matchValue: string, fieldNameForValue: string)
  -> compId: (number|false)?
  2. value: string?
```

 Checks if an entity already has a specific VariableStorageComponent.

@*param* `entityId` — Id of an entity provided by Noita

@*param* `componentTypeName` — "VariableStorageComponent", "LuaComponent", etc

@*param* `fieldNameForMatch` — Components attribute to match the specific component you are searching for: "name", "script_source_file", "etc". component.name = "brah": 'name' -> fieldNameForMatch

@*param* `matchValue` — The components attribute value, you want to match to: component.name = "brah": 'brah' -> matchValue Have a look on NetworkVscUtils.componentNameOf___

@*param* `fieldNameForValue` — name

@*return* `compId` — The specific componentId, which contains the searched value or false if there isn't any Component

@*return* `value` — The components value

```lua
compId:
    | false
```

## componentNameOfNuid


```lua
string
```

## componentNameOfNuidDebugger


```lua
string
```

## componentNameOfNuidUpdater


```lua
string
```

## componentNameOfOwnersGuid


```lua
string
```

## componentNameOfOwnersName


```lua
string
```

## componentNameOfSpawnX


```lua
string
```

## componentNameOfSpawnY


```lua
string
```

## getAllVcsValuesByComponentIds


```lua
function NetworkVscUtils.getAllVcsValuesByComponentIds(ownerNameCompId: number, ownerGuidCompId: number, nuidCompId: number)
  -> ownerName: string
  2. ownerGuid: string
  3. nuid: number
```

 Returns all Network Vsc values by its component ids.

@*param* `ownerNameCompId` — Component Id of the OwnerNameVsc

@*param* `ownerGuidCompId` — Component Id of the OwnerGuidVsc

@*param* `nuidCompId` — Component Id of the NuidVsc

## getAllVscValuesByEntityId


```lua
function NetworkVscUtils.getAllVscValuesByEntityId(entityId: number)
  -> ownerName: string?
  2. ownerGuid: string?
  3. nuid: number?
```

 Returns all Network Vsc values by its entity id.

@*param* `entityId` — Entity Id provided by Noita

@*return* `ownerName,ownerGuid,nuid` — - nuid can be nil

## hasNetworkLuaComponents


```lua
function NetworkVscUtils.hasNetworkLuaComponents(entityId: any)
  -> boolean|nil
```

## hasNuidSet


```lua
function NetworkVscUtils.hasNuidSet(entityId: number)
  -> has: boolean
  2. nuid: number
```

 Checks if the nuid Vsc exists, if so returns nuid

@*return* `has` — retruns 'false, -1': Returns false, if there is no NuidVsc or nuid is empty.

@*return* `nuid` — Returns 'true, nuid', if set.

## isNetworkEntityByNuidVsc


```lua
function NetworkVscUtils.isNetworkEntityByNuidVsc(entityId: number)
  -> isNetworkEntity: boolean
  2. componentId: number
  3. nuid: number|nil
```

 Returns true, componentId and nuid if the entity has a NetworkVsc.

@*param* `entityId` — entityId provided by Noita

## name


```lua
string
```

## valueString


```lua
string
```

## variableStorageComponentName


```lua
string
```


---

# NetworkVscUtils

 NetworkVscUtils:


```lua
NetworkVscUtils
```


```lua
NetworkVscUtils
```


---

# NetworkVscUtils.addOrUpdateAllVscs

 Simply adds or updates all needed Network Variable Storage Components.

@*param* `entityId` — Id of an entity provided by Noita

@*param* `ownerName` — Owners name. Cannot be nil.

@*param* `ownerGuid` — Owners guid. Cannot be nil.

@*param* `nuid` — Network unique identifier. Can only be nil on clients, but not on server.

@*param* `spawnX` — X position of the entity, when spawned. Can only be set once! Can be nil.

@*param* `spawnY` — Y position of the entity, when spawned. Can only be set once! Can be nil.


```lua
function NetworkVscUtils.addOrUpdateAllVscs(entityId: number, ownerName: string, ownerGuid: string, nuid: number|nil, spawnX: number|nil, spawnY: number|nil)
  -> componentIdForOwnerName: integer|nil
  2. componentIdForOwnerGuid: integer|nil
  3. componentIdForNuid: integer|nil
  4. componentIdForNuidDebugger: integer|nil
  5. componentIdForNuidDebugger: integer|nil
```


---

# NetworkVscUtils.checkIfSpecificVscExists

 Checks if an entity already has a specific VariableStorageComponent.

@*param* `entityId` — Id of an entity provided by Noita

@*param* `componentTypeName` — "VariableStorageComponent", "LuaComponent", etc

@*param* `fieldNameForMatch` — Components attribute to match the specific component you are searching for: "name", "script_source_file", "etc". component.name = "brah": 'name' -> fieldNameForMatch

@*param* `matchValue` — The components attribute value, you want to match to: component.name = "brah": 'brah' -> matchValue Have a look on NetworkVscUtils.componentNameOf___

@*param* `fieldNameForValue` — name

@*return* `compId` — The specific componentId, which contains the searched value or false if there isn't any Component

@*return* `value` — The components value

```lua
compId:
    | false
```


```lua
function NetworkVscUtils.checkIfSpecificVscExists(entityId: number, componentTypeName: string, fieldNameForMatch: string, matchValue: string, fieldNameForValue: string)
  -> compId: (number|false)?
  2. value: string?
```


---

# NetworkVscUtils.componentNameOfNuid


```lua
string
```


---

# NetworkVscUtils.componentNameOfNuidDebugger


```lua
string
```


---

# NetworkVscUtils.componentNameOfNuidUpdater


```lua
string
```


---

# NetworkVscUtils.componentNameOfOwnersGuid


```lua
string
```


---

# NetworkVscUtils.componentNameOfOwnersName


```lua
string
```


---

# NetworkVscUtils.componentNameOfSpawnX


```lua
string
```


---

# NetworkVscUtils.componentNameOfSpawnY


```lua
string
```


---

# NetworkVscUtils.getAllVcsValuesByComponentIds

 Returns all Network Vsc values by its component ids.

@*param* `ownerNameCompId` — Component Id of the OwnerNameVsc

@*param* `ownerGuidCompId` — Component Id of the OwnerGuidVsc

@*param* `nuidCompId` — Component Id of the NuidVsc


```lua
function NetworkVscUtils.getAllVcsValuesByComponentIds(ownerNameCompId: number, ownerGuidCompId: number, nuidCompId: number)
  -> ownerName: string
  2. ownerGuid: string
  3. nuid: number
```


---

# NetworkVscUtils.getAllVscValuesByEntityId

 Returns all Network Vsc values by its entity id.

@*param* `entityId` — Entity Id provided by Noita

@*return* `ownerName,ownerGuid,nuid` — - nuid can be nil


```lua
function NetworkVscUtils.getAllVscValuesByEntityId(entityId: number)
  -> ownerName: string?
  2. ownerGuid: string?
  3. nuid: number?
```


---

# NetworkVscUtils.hasNetworkLuaComponents


```lua
function NetworkVscUtils.hasNetworkLuaComponents(entityId: any)
  -> boolean|nil
```


---

# NetworkVscUtils.hasNuidSet

 Checks if the nuid Vsc exists, if so returns nuid

@*return* `has` — retruns 'false, -1': Returns false, if there is no NuidVsc or nuid is empty.

@*return* `nuid` — Returns 'true, nuid', if set.


```lua
function NetworkVscUtils.hasNuidSet(entityId: number)
  -> has: boolean
  2. nuid: number
```


---

# NetworkVscUtils.isNetworkEntityByNuidVsc

 Returns true, componentId and nuid if the entity has a NetworkVsc.

@*param* `entityId` — entityId provided by Noita


```lua
function NetworkVscUtils.isNetworkEntityByNuidVsc(entityId: number)
  -> isNetworkEntity: boolean
  2. componentId: number
  3. nuid: number|nil
```


---

# NetworkVscUtils.name


```lua
string
```


---

# NetworkVscUtils.valueString


```lua
string
```


---

# NetworkVscUtils.variableStorageComponentName


```lua
string
```


---

# NoitaMpSettings

 NoitaMpSettings: Replacement for Noita ModSettings.

## clearAndCreateSettings


```lua
function NoitaMpSettings.clearAndCreateSettings()
```

## get


```lua
function NoitaMpSettings.get(key: any, dataType: any)
  -> boolean|string|number
```

## isMoreThanOneNoitaProcessRunning


```lua
function NoitaMpSettings.isMoreThanOneNoitaProcessRunning()
  -> boolean
```

## load


```lua
function NoitaMpSettings.load()
```

## save


```lua
function NoitaMpSettings.save()
```

## set


```lua
function NoitaMpSettings.set(key: any, value: any)
  -> table
```


---

# NoitaPatcherUtils

## __index


```lua
NoitaPatcherUtils
```

## deserializeEntity


```lua
function NoitaPatcherUtils.deserializeEntity(self: NoitaPatcherUtils, entityId: any, serializedEntityString: any, x: any, y: any)
  -> unknown
```

## new


```lua
function NoitaPatcherUtils.new(self: NoitaPatcherUtils, t: NoitaPatcherUtils|nil)
  -> NoitaPatcherUtils
```

NoitaPatcherUtils constructor.

## serializeEntity


```lua
function NoitaPatcherUtils.serializeEntity(self: NoitaPatcherUtils, entityId: any)
  -> base64: string
  2. md5: string
```

Serialize an entity to a base64 and md5 string.


---

# NuidUtils

 NuidUtils:
 class for getting the current network unique identifier


```lua
table
```


```lua
table
```


---

# NuidUtils.getEntityIdsByKillIndicator

 If an entity died, the associated nuid-entityId-set will be updated with entityId multiplied by -1.
 If this happens, KillEntityMsg has to be send by network.


```lua
function NuidUtils.getEntityIdsByKillIndicator()
  -> table
```


---

# NuidUtils.getNextNuid


```lua
function NuidUtils.getNextNuid()
  -> number
```


---

# OnEntityRemoved

 Make sure this is only be executed once!


```lua
function OnEntityRemoved(entityId: any, nuid: any)
```


---

# OnProjectileFired

 Must define these callbacks else you get errors every
 time a projectile is fired. Functions are empty since
 we don't use these callbacks at the moment.


```lua
function OnProjectileFired()
```


---

# OnProjectileFiredPost


```lua
function OnProjectileFiredPost()
```


---

# OnWorldInitialized


```lua
function OnWorldInitialized()
```


---

# PlayerNameFunction


```lua
function PlayerNameFunction(entity_id: any, playerName: any)
```


---

# SDL


```lua
unknown
```


---

# SerialisedEntity


---

# Server


```lua
SockServer
```


---

# Server.address


```lua
unknown
```


---

# Server.port


```lua
unknown
```


---

# ServerInit

 Because of stack overflow errors when loading lua files,
 I decided to put Utils 'classes' into globals


```lua
ServerInit
```


```lua
ServerInit
```


---

# ServerInit

## new


```lua
function ServerInit.new(sockServer: SockServer)
  -> self: SockServer
```

 ServerInit constructor
 Creates a new instance of server 'class'


---

# ServerInit.new

 ServerInit constructor
 Creates a new instance of server 'class'


```lua
function ServerInit.new(sockServer: SockServer)
  -> self: SockServer
```


---

# SockServer

## acknowledgeMaxSize


```lua
integer
```

self.acknowledge        = {} -- sock.lua#Client:send -> self.acknowledge[packetsSent] = { event = event, data = data, entityId = data.entityId, status = NetworkUtils.events.acknowledgement.sent }
table.setNoitaMpDefaultMetaMethods(self.acknowledge, "v")

## amIServer


```lua
function SockServer.amIServer()
  -> iAm: boolean
```

 Checks if the current local user is the server

@*return* `iAm` — true if server

## ban


```lua
function SockServer.ban(name: any)
```

## getAckCacheSize


```lua
function SockServer.getAckCacheSize()
  -> cacheSize: number
```

 Mainly for profiling. Returns then network cache, aka acknowledge.

## guid


```lua
boolean|string|number
```

 guid might not be set here or will be overwritten at the end of the constructor. @see setGuid

## health


```lua
table
```

## iAm


```lua
string
```

## isRunning


```lua
function SockServer.isRunning()
  -> boolean
```

## kick


```lua
function SockServer.kick(name: any)
```

## modListCached


```lua
nil
```

## name


```lua
boolean|string|number
```

## nuid


```lua
nil
```

## send


```lua
function SockServer.send(self: SockServer, peer: any, event: any, data: any)
  -> boolean
```

## sendDeadNuids


```lua
function SockServer.sendDeadNuids(deadNuids: any)
```

## sendEntityData


```lua
function SockServer.sendEntityData(entityId: any)
```

## sendMinaInformation


```lua
function SockServer.sendMinaInformation()
  -> boolean
```

## sendNewGuid


```lua
function SockServer.sendNewGuid(peer: any, oldGuid: any, newGuid: any)
  -> boolean
```

## sendNewNuid


```lua
function SockServer.sendNewNuid(ownerName: any, ownerGuid: any, entityId: any, serializedEntityString: any, nuid: any, x: any, y: any, initialSerializedEntityString: any)
  -> boolean
```

 TODO: this is the new sendNewNuid, but it's not tested yet

## sendToAll


```lua
function SockServer.sendToAll(self: SockServer, event: any, data: any)
  -> boolean
```

## sendToAllBut


```lua
function SockServer.sendToAllBut(self: SockServer, peer: any, event: any, data: any)
  -> boolean
```

## start


```lua
function SockServer.start(ip: string, port?: number)
```

 Starts a server on ip and port. Both can be nil, then ModSettings will be used.

@*param* `ip` — localhost or 127.0.0.1 or nil

@*param* `port` — port number from 1 to max of 65535 or nil

## stop


```lua
function SockServer.stop()
```

 Stops the server.

## transform


```lua
table
```

## update


```lua
function SockServer.update(startFrameTime: any)
```

 Updates the server by checking for network events and handling them.


---

# Transform

## x


```lua
number
```

## y


```lua
number
```


---

# Ui

 Ui: NoitaMP UI.
See:
  * ~PlayerList.xml~
  * ~FoldingMenu.xml~


```lua
table
```


---

# Ui.new


```lua
function Ui.new()
  -> table
```


---

# Utils


```lua
Utils
```


```lua
Utils
```


```lua
Utils
```


```lua
Utils
```


---

# Utils

## CopyToClipboard


```lua
function Utils.CopyToClipboard(copy: any)
```

## DebugEntity


```lua
function Utils.DebugEntity(e: any)
```

https://noita.wiki.gg/wiki/Modding:_Utilities#Easier_entity_debugging

## IsEmpty


```lua
function Utils.IsEmpty(var: any)
  -> boolean
```

## ReloadMap


```lua
function Utils.ReloadMap(seed: number)
```

 Reloads the whole world with a specific seed. No need to restart the game and use magic numbers.

@*param* `seed` — max = 4294967295

## Sleep


```lua
function Utils.Sleep(s: number)
```

 Wait for n seconds.

@*param* `s` — seconds to wait

## Str


```lua
function Utils.Str(var: any)
  -> string|unknown
```

https://noita.wiki.gg/wiki/Modding:_Utilities#Easier_entity_debugging

## execLua


```lua
function Utils.execLua(pid: any)
```

## openUrl


```lua
function Utils.openUrl(url: any)
```

## pformat


```lua
function Utils.pformat(var: any)
```


---

# _G


A global variable (not a function) that holds the global environment (see [§2.2](http://www.lua.org/manual/5.4/manual.html#2.2)). Lua itself does not use this variable; changing its value does not affect any environment, nor vice versa.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-_G)



```lua
_G
```


---

# _G.MinaUtils

Globally accessible MinaUtils in _G.MinaUtils.


```lua
MinaUtils
```


---

# _VERSION


A global variable (not a function) that holds a string containing the running Lua version.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-_VERSION)



```lua
string
```


---

# __genOrderedIndex


```lua
function __genOrderedIndex(t: any)
  -> table
```


---

# arg


Command-line arguments of Lua Standalone.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-arg)



```lua
string[]
```


---

# assert


Raises an error if the value of its argument v is false (i.e., `nil` or `false`); otherwise, returns all its arguments. In case of error, `message` is the error object; when absent, it defaults to `"assertion failed!"`

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-assert)


```lua
function assert(v?: <T>, message?: any, ...any)
  -> <T>
  2. ...any
```


---

# collectgarbage


This function is a generic interface to the garbage collector. It performs different functions according to its first argument, `opt`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-collectgarbage)


```lua
opt:
   -> "collect" -- Performs a full garbage-collection cycle.
    | "stop" -- Stops automatic execution.
    | "restart" -- Restarts automatic execution.
    | "count" -- Returns the total memory in Kbytes.
    | "step" -- Performs a garbage-collection step.
    | "isrunning" -- Returns whether the collector is running.
    | "incremental" -- Change the collector mode to incremental.
    | "generational" -- Change the collector mode to generational.
```


```lua
function collectgarbage(opt?: "collect"|"count"|"generational"|"incremental"|"isrunning"...(+3), ...any)
  -> any
```


---

# compId


```lua
unknown
```


```lua
unknown
```


---

# coroutine




[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-coroutine)



```lua
coroutinelib
```


---

# coroutine.close


Closes coroutine `co` , closing all its pending to-be-closed variables and putting the coroutine in a dead state.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-coroutine.close)


```lua
function coroutine.close(co: thread)
  -> noerror: boolean
  2. errorobject: any
```


---

# coroutine.create


Creates a new coroutine, with body `f`. `f` must be a function. Returns this new coroutine, an object with type `"thread"`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-coroutine.create)


```lua
function coroutine.create(f: fun(...any):...unknown)
  -> thread
```


---

# coroutine.isyieldable


Returns true when the coroutine `co` can yield. The default for `co` is the running coroutine.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-coroutine.isyieldable)


```lua
function coroutine.isyieldable(co?: thread)
  -> boolean
```


---

# coroutine.resume


Starts or continues the execution of coroutine `co`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-coroutine.resume)


```lua
function coroutine.resume(co: thread, val1?: any, ...any)
  -> success: boolean
  2. ...any
```


---

# coroutine.running


Returns the running coroutine plus a boolean, true when the running coroutine is the main one.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-coroutine.running)


```lua
function coroutine.running()
  -> running: thread
  2. ismain: boolean
```


---

# coroutine.status


Returns the status of coroutine `co`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-coroutine.status)


```lua
return #1:
    | "running" -- Is running.
    | "suspended" -- Is suspended or not started.
    | "normal" -- Is active but not running.
    | "dead" -- Has finished or stopped with an error.
```


```lua
function coroutine.status(co: thread)
  -> "dead"|"normal"|"running"|"suspended"
```


---

# coroutine.wrap


Creates a new coroutine, with body `f`; `f` must be a function. Returns a function that resumes the coroutine each time it is called.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-coroutine.wrap)


```lua
function coroutine.wrap(f: fun(...any):...unknown)
  -> fun(...any):...unknown
```


---

# coroutine.yield


Suspends the execution of the calling coroutine.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-coroutine.yield)


```lua
(async) function coroutine.yield(...any)
  -> ...any
```


---

# debug




[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug)



```lua
debuglib
```


---

# debug.debug


Enters an interactive mode with the user, running each string that the user enters.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.debug)


```lua
function debug.debug()
```


---

# debug.getfenv


Returns the environment of object `o` .

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.getfenv)


```lua
function debug.getfenv(o: any)
  -> table
```


---

# debug.gethook


Returns the current hook settings of the thread.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.gethook)


```lua
function debug.gethook(co?: thread)
  -> hook: function
  2. mask: string
  3. count: integer
```


---

# debug.getinfo


Returns a table with information about a function.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.getinfo)


---

```lua
what:
   +> "n" -- `name` and `namewhat`
   +> "S" -- `source`, `short_src`, `linedefined`, `lastlinedefined`, and `what`
   +> "l" -- `currentline`
   +> "t" -- `istailcall`
   +> "u" -- `nups`, `nparams`, and `isvararg`
   +> "f" -- `func`
   +> "r" -- `ftransfer` and `ntransfer`
   +> "L" -- `activelines`
```


```lua
function debug.getinfo(thread: thread, f: integer|fun(...any):...unknown, what?: string|"L"|"S"|"f"|"l"...(+4))
  -> debuginfo
```


---

# debug.getlocal


Returns the name and the value of the local variable with index `local` of the function at level `f` of the stack.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.getlocal)


```lua
function debug.getlocal(thread: thread, f: integer|fun(...any):...unknown, index: integer)
  -> name: string
  2. value: any
```


---

# debug.getmetatable


Returns the metatable of the given value.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.getmetatable)


```lua
function debug.getmetatable(object: any)
  -> metatable: table
```


---

# debug.getregistry


Returns the registry table.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.getregistry)


```lua
function debug.getregistry()
  -> table
```


---

# debug.getupvalue


Returns the name and the value of the upvalue with index `up` of the function.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.getupvalue)


```lua
function debug.getupvalue(f: fun(...any):...unknown, up: integer)
  -> name: string
  2. value: any
```


---

# debug.getuservalue


Returns the `n`-th user value associated
to the userdata `u` plus a boolean,
`false` if the userdata does not have that value.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.getuservalue)


```lua
function debug.getuservalue(u: userdata, n?: integer)
  -> any
  2. boolean
```


---

# debug.setcstacklimit


### **Deprecated in `Lua 5.4.2`**

Sets a new limit for the C stack. This limit controls how deeply nested calls can go in Lua, with the intent of avoiding a stack overflow.

In case of success, this function returns the old limit. In case of error, it returns `false`.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.setcstacklimit)


```lua
function debug.setcstacklimit(limit: integer)
  -> boolean|integer
```


---

# debug.setfenv


Sets the environment of the given `object` to the given `table` .

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.setfenv)


```lua
function debug.setfenv(object: <T>, env: table)
  -> object: <T>
```


---

# debug.sethook


Sets the given function as a hook.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.sethook)


---

```lua
mask:
   +> "c" -- Calls hook when Lua calls a function.
   +> "r" -- Calls hook when Lua returns from a function.
   +> "l" -- Calls hook when Lua enters a new line of code.
```


```lua
function debug.sethook(thread: thread, hook: fun(...any):...unknown, mask: string|"c"|"l"|"r", count?: integer)
```


---

# debug.setlocal


Assigns the `value` to the local variable with index `local` of the function at `level` of the stack.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.setlocal)


```lua
function debug.setlocal(thread: thread, level: integer, index: integer, value: any)
  -> name: string
```


---

# debug.setmetatable


Sets the metatable for the given value to the given table (which can be `nil`).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.setmetatable)


```lua
function debug.setmetatable(value: <T>, meta?: table)
  -> value: <T>
```


---

# debug.setupvalue


Assigns the `value` to the upvalue with index `up` of the function.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.setupvalue)


```lua
function debug.setupvalue(f: fun(...any):...unknown, up: integer, value: any)
  -> name: string
```


---

# debug.setuservalue


Sets the given `value` as
the `n`-th user value associated to the given `udata`.
`udata` must be a full userdata.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.setuservalue)


```lua
function debug.setuservalue(udata: userdata, value: any, n?: integer)
  -> udata: userdata
```


---

# debug.traceback


Returns a string with a traceback of the call stack. The optional message string is appended at the beginning of the traceback.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.traceback)


```lua
function debug.traceback(thread: thread, message?: any, level?: integer)
  -> message: string
```


---

# debug.upvalueid


Returns a unique identifier (as a light userdata) for the upvalue numbered `n` from the given function.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.upvalueid)


```lua
function debug.upvalueid(f: fun(...any):...unknown, n: integer)
  -> id: lightuserdata
```


---

# debug.upvaluejoin


Make the `n1`-th upvalue of the Lua closure `f1` refer to the `n2`-th upvalue of the Lua closure `f2`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-debug.upvaluejoin)


```lua
function debug.upvaluejoin(f1: fun(...any):...unknown, n1: integer, f2: fun(...any):...unknown, n2: integer)
```


---

# dofile


Opens the named file and executes its content as a Lua chunk. When called without arguments, `dofile` executes the content of the standard input (`stdin`). Returns all values returned by the chunk. In case of errors, `dofile` propagates the error to its caller. (That is, `dofile` does not run in protected mode.)

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-dofile)


```lua
function dofile(filename?: string)
  -> ...any
```


```lua
function dofile(path: any)
  -> unknown
```


---

# enabled_changed


```lua
function enabled_changed(entityId: any, isEnabled: any)
```


---

# error


Terminates the last protected function called and returns message as the error object.

Usually, `error` adds some information about the error position at the beginning of the message, if the message is a string.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-error)


```lua
function error(message: any, level?: integer)
```


---

# getNoitaMpRootDirectory


```lua
function getNoitaMpRootDirectory()
  -> string
```


---

# getfenv


Returns the current environment in use by the function. `f` can be a Lua function or a number that specifies the function at that stack level.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-getfenv)


```lua
function getfenv(f?: integer|fun(...any):...unknown)
  -> table
```


---

# getmetatable


If object does not have a metatable, returns nil. Otherwise, if the object's metatable has a __metatable field, returns the associated value. Otherwise, returns the metatable of the given object.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-getmetatable)


```lua
function getmetatable(object: any)
  -> metatable: table
```


---

# gui


```lua
unknown
```


```lua
unknown
```


```lua
unknown
```


```lua
unknown
```


```lua
unknown
```


```lua
unknown
```


---

# guiI


```lua
table
```


---

# guid


```lua
unknown
```


---

# io




[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-io)



```lua
iolib
```


---

# io.close


Close `file` or default output file.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-io.close)


```lua
exitcode:
    | "exit"
    | "signal"
```


```lua
function io.close(file?: file*)
  -> suc: boolean?
  2. exitcode: ("exit"|"signal")?
  3. code: integer?
```


---

# io.flush


Saves any written data to default output file.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-io.flush)


```lua
function io.flush()
```


---

# io.input


Sets `file` as the default input file.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-io.input)


```lua
function io.input(file: string|file*)
```


---

# io.lines


------
```lua
for c in io.lines(filename, ...) do
    body
end
```


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-io.lines)


```lua
...(param):
    | "n" -- Reads a numeral and returns it as number.
    | "a" -- Reads the whole file.
   -> "l" -- Reads the next line skipping the end of line.
    | "L" -- Reads the next line keeping the end of line.
```


```lua
function io.lines(filename?: string, ...string|integer|"L"|"a"|"l"...(+1))
  -> fun():any, ...unknown
```


---

# io.open


Opens a file, in the mode specified in the string `mode`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-io.open)


```lua
mode:
   -> "r" -- Read mode.
    | "w" -- Write mode.
    | "a" -- Append mode.
    | "r+" -- Update mode, all previous data is preserved.
    | "w+" -- Update mode, all previous data is erased.
    | "a+" -- Append update mode, previous data is preserved, writing is only allowed at the end of file.
    | "rb" -- Read mode. (in binary mode.)
    | "wb" -- Write mode. (in binary mode.)
    | "ab" -- Append mode. (in binary mode.)
    | "r+b" -- Update mode, all previous data is preserved. (in binary mode.)
    | "w+b" -- Update mode, all previous data is erased. (in binary mode.)
    | "a+b" -- Append update mode, previous data is preserved, writing is only allowed at the end of file. (in binary mode.)
```


```lua
function io.open(filename: string, mode?: "a"|"a+"|"a+b"|"ab"|"r"...(+7))
  -> file*?
  2. errmsg: string?
```


---

# io.output


Sets `file` as the default output file.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-io.output)


```lua
function io.output(file: string|file*)
```


---

# io.popen


Starts program prog in a separated process.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-io.popen)


```lua
mode:
    | "r" -- Read data from this program by `file`.
    | "w" -- Write data to this program by `file`.
```


```lua
function io.popen(prog: string, mode?: "r"|"w")
  -> file*?
  2. errmsg: string?
```


```lua
function io.popen(commandLine: any)
  -> table|nil
```


---

# io.read


Reads the `file`, according to the given formats, which specify what to read.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-io.read)


```lua
...(param):
    | "n" -- Reads a numeral and returns it as number.
    | "a" -- Reads the whole file.
   -> "l" -- Reads the next line skipping the end of line.
    | "L" -- Reads the next line keeping the end of line.
```


```lua
function io.read(...string|integer|"L"|"a"|"l"...(+1))
  -> any
  2. ...any
```


---

# io.tmpfile


In case of success, returns a handle for a temporary file.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-io.tmpfile)


```lua
function io.tmpfile()
  -> file*
```


---

# io.type


Checks whether `obj` is a valid file handle.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-io.type)


```lua
return #1:
    | "file" -- Is an open file handle.
    | "closed file" -- Is a closed file handle.
    | `nil` -- Is not a file handle.
```


```lua
function io.type(file: file*)
  -> "closed file"|"file"|`nil`
```


---

# io.write


Writes the value of each of its arguments to default output file.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-io.write)


```lua
function io.write(...any)
  -> file*
  2. errmsg: string?
```


---

# ipairs


Returns three values (an iterator function, the table `t`, and `0`) so that the construction
```lua
    for i,v in ipairs(t) do body end
```
will iterate over the key–value pairs `(1,t[1]), (2,t[2]), ...`, up to the first absent index.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-ipairs)


```lua
function ipairs(t: <T:table>)
  -> fun(table: <V>[], i?: integer):integer, <V>
  2. <T:table>
  3. i: integer
```


---

# is_linux


```lua
boolean
```


```lua
boolean
```


```lua
boolean
```


---

# is_windows

NoitaMP additions 


```lua
boolean
```


```lua
boolean
```


```lua
boolean
```


---

# load


Loads a chunk.

If `chunk` is a string, the chunk is this string. If `chunk` is a function, `load` calls it repeatedly to get the chunk pieces. Each call to `chunk` must return a string that concatenates with previous results. A return of an empty string, `nil`, or no value signals the end of the chunk.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-load)


```lua
mode:
    | "b" -- Only binary chunks.
    | "t" -- Only text chunks.
   -> "bt" -- Both binary and text.
```


```lua
function load(chunk: string|function, chunkname?: string, mode?: "b"|"bt"|"t", env?: table)
  -> function?
  2. error_message: string?
```


---

# loadfile


Loads a chunk from file `filename` or from the standard input, if no file name is given.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-loadfile)


```lua
mode:
    | "b" -- Only binary chunks.
    | "t" -- Only text chunks.
   -> "bt" -- Both binary and text.
```


```lua
function loadfile(filename?: string, mode?: "b"|"bt"|"t", env?: table)
  -> function?
  2. error_message: string?
```


---

# loadstring


Loads a chunk from the given string.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-loadstring)


```lua
function loadstring(text: string, chunkname?: string)
  -> function?
  2. error_message: string?
```


---

# math




[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math)



```lua
mathlib
```


---

# math.abs


Returns the absolute value of `x`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.abs)


```lua
function math.abs(x: <Number:number>)
  -> <Number:number>
```


---

# math.acos


Returns the arc cosine of `x` (in radians).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.acos)


```lua
function math.acos(x: number)
  -> number
```


---

# math.asin


Returns the arc sine of `x` (in radians).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.asin)


```lua
function math.asin(x: number)
  -> number
```


---

# math.atan


Returns the arc tangent of `y/x` (in radians).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.atan)


```lua
function math.atan(y: number, x?: number)
  -> number
```


---

# math.atan2


Returns the arc tangent of `y/x` (in radians).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.atan2)


```lua
function math.atan2(y: number, x: number)
  -> number
```


---

# math.ceil


Returns the smallest integral value larger than or equal to `x`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.ceil)


```lua
function math.ceil(x: number)
  -> integer
```


---

# math.cos


Returns the cosine of `x` (assumed to be in radians).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.cos)


```lua
function math.cos(x: number)
  -> number
```


---

# math.cosh


Returns the hyperbolic cosine of `x` (assumed to be in radians).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.cosh)


```lua
function math.cosh(x: number)
  -> number
```


---

# math.deg


Converts the angle `x` from radians to degrees.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.deg)


```lua
function math.deg(x: number)
  -> number
```


---

# math.exp


Returns the value `e^x` (where `e` is the base of natural logarithms).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.exp)


```lua
function math.exp(x: number)
  -> number
```


---

# math.floor


Returns the largest integral value smaller than or equal to `x`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.floor)


```lua
function math.floor(x: number)
  -> integer
```


---

# math.fmod


Returns the remainder of the division of `x` by `y` that rounds the quotient towards zero.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.fmod)


```lua
function math.fmod(x: number, y: number)
  -> number
```


---

# math.frexp


Decompose `x` into tails and exponents. Returns `m` and `e` such that `x = m * (2 ^ e)`, `e` is an integer and the absolute value of `m` is in the range [0.5, 1) (or zero when `x` is zero).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.frexp)


```lua
function math.frexp(x: number)
  -> m: number
  2. e: number
```


---

# math.ldexp


Returns `m * (2 ^ e)` .

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.ldexp)


```lua
function math.ldexp(m: number, e: number)
  -> number
```


---

# math.log


Returns the logarithm of `x` in the given base.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.log)


```lua
function math.log(x: number, base?: integer)
  -> number
```


---

# math.log10


Returns the base-10 logarithm of x.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.log10)


```lua
function math.log10(x: number)
  -> number
```


---

# math.max


Returns the argument with the maximum value, according to the Lua operator `<`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.max)


```lua
function math.max(x: <Number:number>, ...<Number:number>)
  -> <Number:number>
```


---

# math.min


Returns the argument with the minimum value, according to the Lua operator `<`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.min)


```lua
function math.min(x: <Number:number>, ...<Number:number>)
  -> <Number:number>
```


---

# math.modf


Returns the integral part of `x` and the fractional part of `x`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.modf)


```lua
function math.modf(x: number)
  -> integer
  2. number
```


---

# math.pow


Returns `x ^ y` .

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.pow)


```lua
function math.pow(x: number, y: number)
  -> number
```


---

# math.rad


Converts the angle `x` from degrees to radians.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.rad)


```lua
function math.rad(x: number)
  -> number
```


---

# math.random


* `math.random()`: Returns a float in the range [0,1).
* `math.random(n)`: Returns a integer in the range [1, n].
* `math.random(m, n)`: Returns a integer in the range [m, n].


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.random)


```lua
function math.random(m: integer, n: integer)
  -> integer
```


---

# math.randomseed


* `math.randomseed(x, y)`: Concatenate `x` and `y` into a 128-bit `seed` to reinitialize the pseudo-random generator.
* `math.randomseed(x)`: Equate to `math.randomseed(x, 0)` .
* `math.randomseed()`: Generates a seed with a weak attempt for randomness.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.randomseed)


```lua
function math.randomseed(x?: integer, y?: integer)
```


---

# math.round

 This way, you can round on any bracket:
 math.round(119.68, 6.4) -- 121.6 (= 19 * 6.4)
 It works for "number of decimals" too, with a rather visual representation:
 math.round(119.68, 0.01) -- 119.68
 math.round(119.68, 0.1) -- 119.7
 math.round(119.68) -- 120
 math.round(119.68, 100) -- 100
 math.round(119.68, 1000) -- 0


```lua
function math.round(v: any, bracket: any)
  -> unknown
```


---

# math.sign


```lua
function math.sign(v: any)
  -> integer
```


---

# math.sin


Returns the sine of `x` (assumed to be in radians).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.sin)


```lua
function math.sin(x: number)
  -> number
```


---

# math.sinh


Returns the hyperbolic sine of `x` (assumed to be in radians).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.sinh)


```lua
function math.sinh(x: number)
  -> number
```


---

# math.sqrt


Returns the square root of `x`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.sqrt)


```lua
function math.sqrt(x: number)
  -> number
```


---

# math.tan


Returns the tangent of `x` (assumed to be in radians).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.tan)


```lua
function math.tan(x: number)
  -> number
```


---

# math.tanh


Returns the hyperbolic tangent of `x` (assumed to be in radians).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.tanh)


```lua
function math.tanh(x: number)
  -> number
```


---

# math.tointeger


If the value `x` is convertible to an integer, returns that integer.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.tointeger)


```lua
function math.tointeger(x: any)
  -> integer?
```


---

# math.type


Returns `"integer"` if `x` is an integer, `"float"` if it is a float, or `nil` if `x` is not a number.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.type)


```lua
return #1:
    | "integer"
    | "float"
    | 'nil'
```


```lua
function math.type(x: any)
  -> "float"|"integer"|'nil'
```


---

# math.ult


Returns `true` if and only if `m` is below `n` when they are compared as unsigned integers.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-math.ult)


```lua
function math.ult(m: integer, n: integer)
  -> boolean
```


---

# md5


```lua
table
```


```lua
unknown
```


---

# module


Creates a module.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-module)


```lua
function module(name: string, ...any)
```


---

# name


```lua
nil
```


```lua
unknown
```


---

# newproxy


```lua
function newproxy(proxy: boolean|table|userdata)
  -> userdata
```


---

# next


Allows a program to traverse all fields of a table. Its first argument is a table and its second argument is an index in this table. A call to `next` returns the next index of the table and its associated value. When called with `nil` as its second argument, `next` returns an initial index and its associated value. When called with the last index, or with `nil` in an empty table, `next` returns `nil`. If the second argument is absent, then it is interpreted as `nil`. In particular, you can use `next(t)` to check whether a table is empty.

The order in which the indices are enumerated is not specified, *even for numeric indices*. (To traverse a table in numerical order, use a numerical `for`.)

The behavior of `next` is undefined if, during the traversal, you assign any value to a non-existent field in the table. You may however modify existing fields. In particular, you may set existing fields to nil.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-next)


```lua
function next(table: table<<K>, <V>>, index?: <K>)
  -> <K>?
  2. <V>?
```


---

# orderedNext


```lua
function orderedNext(t: any, state: any)
  -> unknown|nil
  2. unknown|nil
```


---

# orderedPairs


```lua
function orderedPairs(t: any)
  -> function
  2. unknown
  3. nil
```


---

# os




[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-os)



```lua
oslib
```


---

# os.clock


Returns an approximation of the amount in seconds of CPU time used by the program.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-os.clock)


```lua
function os.clock()
  -> number
```


---

# os.date


Returns a string or a table containing date and time, formatted according to the given string `format`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-os.date)


```lua
function os.date(format?: string, time?: integer)
  -> string|osdate
```


---

# os.difftime


Returns the difference, in seconds, from time `t1` to time `t2`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-os.difftime)


```lua
function os.difftime(t2: integer, t1: integer)
  -> integer
```


---

# os.execute


Passes `command` to be executed by an operating system shell.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-os.execute)


```lua
exitcode:
    | "exit"
    | "signal"
```


```lua
function os.execute(command?: string)
  -> suc: boolean?
  2. exitcode: ("exit"|"signal")?
  3. code: integer?
```


```lua
function os.execute(commandLine: any)
  -> integer
```


---

# os.exit


Calls the ISO C function `exit` to terminate the host program.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-os.exit)


```lua
function os.exit(code?: boolean|integer, close?: boolean)
```


---

# os.getenv


Returns the value of the process environment variable `varname`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-os.getenv)


```lua
function os.getenv(varname: string)
  -> string?
```


---

# os.remove


Deletes the file with the given name.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-os.remove)


```lua
function os.remove(filename: string)
  -> suc: boolean
  2. errmsg: string?
```


---

# os.rename


Renames the file or directory named `oldname` to `newname`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-os.rename)


```lua
function os.rename(oldname: string, newname: string)
  -> suc: boolean
  2. errmsg: string?
```


---

# os.setlocale


Sets the current locale of the program.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-os.setlocale)


```lua
category:
   -> "all"
    | "collate"
    | "ctype"
    | "monetary"
    | "numeric"
    | "time"
```


```lua
function os.setlocale(locale: string|nil, category?: "all"|"collate"|"ctype"|"monetary"|"numeric"...(+1))
  -> localecategory: string
```


---

# os.time


Returns the current time when called without arguments, or a time representing the local date and time specified by the given table.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-os.time)


```lua
function os.time(date?: osdate)
  -> integer
```


---

# os.tmpname


Returns a string with a file name that can be used for a temporary file.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-os.tmpname)


```lua
function os.tmpname()
  -> string
```


---

# os_arch


```lua
unknown
```


---

# os_name


```lua
string
```


---

# package




[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-package)



```lua
packagelib
```


---

# package.config


A string describing some compile-time configurations for packages.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-package.config)



```lua
string
```


---

# package.cpath


```lua
unknown
```


```lua
string
```


---

# package.loaders


A table used by `require` to control how to load modules.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-package.loaders)



```lua
table
```


---

# package.loadlib


Dynamically links the host program with the C library `libname`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-package.loadlib)


```lua
function package.loadlib(libname: string, funcname: string)
  -> any
```


---

# package.path

 [[ LuaRocks modules ]]--


```lua
unknown
```


```lua
unknown
```


```lua
unknown
```


```lua
unknown
```


```lua
unknown
```


```lua
unknown
```


```lua
unknown
```


```lua
string
```


```lua
string
```


---

# package.searchers


A table used by `require` to control how to load modules.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-package.searchers)



```lua
table
```


---

# package.searchpath


Searches for the given `name` in the given `path`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-package.searchpath)


```lua
function package.searchpath(name: string, path: string, sep?: string, rep?: string)
  -> filename: string?
  2. errmsg: string?
```


---

# package.seeall


Sets a metatable for `module` with its `__index` field referring to the global environment, so that this module inherits values from the global environment. To be used as an option to function `module` .

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-package.seeall)


```lua
function package.seeall(module: table)
```


---

# pairs


If `t` has a metamethod `__pairs`, calls it with t as argument and returns the first three results from the call.

Otherwise, returns three values: the [next](http://www.lua.org/manual/5.4/manual.html#pdf-next) function, the table `t`, and `nil`, so that the construction
```lua
    for k,v in pairs(t) do body end
```
will iterate over all key–value pairs of table `t`.

See function [next](http://www.lua.org/manual/5.4/manual.html#pdf-next) for the caveats of modifying the table during its traversal.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-pairs)


```lua
function pairs(t: <T:table>)
  -> fun(table: table<<K>, <V>>, index?: <K>):<K>, <V>
  2. <T:table>
```


---

# pathSeparator


```lua
string
```


```lua
string
```


```lua
string
```


---

# pcall


Calls the function `f` with the given arguments in *protected mode*. This means that any error inside `f` is not propagated; instead, `pcall` catches the error and returns a status code. Its first result is the status code (a boolean), which is true if the call succeeds without errors. In such case, `pcall` also returns all results from the call, after this first result. In case of any error, `pcall` returns `false` plus the error object.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-pcall)


```lua
function pcall(f: fun(...any):...unknown, arg1?: any, ...any)
  -> success: boolean
  2. result: any
  3. ...any
```


---

# print


Receives any number of arguments and prints their values to `stdout`, converting each argument to a string following the same rules of [tostring](http://www.lua.org/manual/5.4/manual.html#pdf-tostring).
The function print is not intended for formatted output, but only as a quick way to show a value, for instance for debugging. For complete control over the output, use [string.format](http://www.lua.org/manual/5.4/manual.html#pdf-string.format) and [io.write](http://www.lua.org/manual/5.4/manual.html#pdf-io.write).


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-print)


```lua
function print(...any)
```


---

# rawequal


Checks whether v1 is equal to v2, without invoking the `__eq` metamethod.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-rawequal)


```lua
function rawequal(v1: any, v2: any)
  -> boolean
```


---

# rawget


Gets the real value of `table[index]`, without invoking the `__index` metamethod.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-rawget)


```lua
function rawget(table: table, index: any)
  -> any
```


---

# rawlen


Returns the length of the object `v`, without invoking the `__len` metamethod.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-rawlen)


```lua
function rawlen(v: string|table)
  -> len: integer
```


---

# rawset


Sets the real value of `table[index]` to `value`, without using the `__newindex` metavalue. `table` must be a table, `index` any value different from `nil` and `NaN`, and `value` any Lua value.
This function returns `table`.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-rawset)


```lua
function rawset(table: table, index: any, value: any)
  -> table
```


---

# require


Loads the given module, returns any value returned by the searcher(`true` when `nil`). Besides that value, also returns as a second result the loader data returned by the searcher, which indicates how `require` found the module. (For instance, if the module came from a file, this loader data is the file path.)

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-require)


```lua
function require(modname: string)
  -> unknown
  2. loaderdata: unknown
```


---

# run_count

 https://github.com/dextercd/Noita-Component-Explorer/blob/main/component-explorer/entities/imgui_warning.lua


```lua
integer
```


```lua
unknown
```


---

# select


If `index` is a number, returns all arguments after argument number `index`; a negative number indexes from the end (`-1` is the last argument). Otherwise, `index` must be the string `"#"`, and `select` returns the total number of extra arguments it received.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-select)


```lua
index:
    | "#"
```


```lua
function select(index: integer|"#", ...any)
  -> any
```


---

# self.amIClient

 Checks if the current local user is a client

@*return* `iAm` — true if client


```lua
function self.amIClient()
  -> iAm: boolean
```


---

# self.clientCacheId


```lua
unknown
```


---

# self.connect

 Connects to a server on ip and port. Both can be nil, then ModSettings will be used.

@*param* `ip` — localhost or 127.0.0.1 or nil

@*param* `port` — port number from 1 to max of 65535 or nil

@*param* `code` — connection code 0 = connecting first time, 1 = connected second time with loaded seed


```lua
function self.connect(ip: string, port?: number, code: number)
```


---

# self.disconnect


```lua
function self.disconnect()
```


---

# self.getAckCacheSize

 Mainly for profiling. Returns then network cache, aka acknowledge.


```lua
function self.getAckCacheSize()
  -> cacheSize: number
```


---

# self.guid


```lua
unknown
```


```lua
unknown
```


---

# self.isConnected


```lua
function self.isConnected()
```


---

# self.missingMods


```lua
table
```


---

# self.nuid


```lua
nil
```


```lua
unknown
```


---

# self.otherClients


```lua
table
```


---

# self.requiredMods


```lua
unknown
```


---

# self.send


```lua
function self.send(self: any, event: any, data: any)
  -> boolean
```


---

# self.sendDeadNuids


```lua
function self.sendDeadNuids(deadNuids: any)
  -> boolean
```


---

# self.sendEntityData


```lua
function self.sendEntityData(entityId: any)
```


---

# self.sendLostNuid


```lua
function self.sendLostNuid(nuid: any)
  -> boolean
```


---

# self.sendMinaInformation


```lua
function self.sendMinaInformation()
  -> boolean
```


---

# self.sendNeedNuid

Sends a message to the server that the client needs a nuid.


```lua
function self.sendNeedNuid(ownerName: string, ownerGuid: string, entityId: number)
```


---

# self.serverInfo


```lua
table
```


---

# self.serverInfo.entityId


```lua
unknown
```


---

# self.serverInfo.guid


```lua
unknown
```


---

# self.serverInfo.health


```lua
unknown
```


---

# self.serverInfo.name


```lua
unknown
```


---

# self.serverInfo.nuid


```lua
unknown
```


---

# self.serverInfo.transform


```lua
unknown
```


---

# self.serverInfo.version


```lua
unknown
```


---

# self.update

 Updates the Client by checking for network events and handling them.


```lua
function self.update(startFrameTime: any)
```


---

# setfenv


Sets the environment to be used by the given function.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-setfenv)


```lua
function setfenv(f: fun(...any):...integer|unknown, table: table)
  -> function
```


---

# setmetatable


Sets the metatable for the given table. If `metatable` is `nil`, removes the metatable of the given table. If the original metatable has a `__metatable` field, raises an error.

This function returns `table`.

To change the metatable of other types from Lua code, you must use the debug library ([§6.10](http://www.lua.org/manual/5.4/manual.html#6.10)).


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-setmetatable)


```lua
function setmetatable(table: table, metatable?: table)
  -> table
```


---

# seven_zip


```lua
string
```


---

# showSettingsSavedTimer


```lua
unknown
```


---

# stack._top


```lua
unknown
```


---

# string




[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string)



```lua
stringlib
```


---

# string.ExtendOrCutStringToLength

@*param* `var` — any string you want to extend or cut

 Extends @var to the @length with @char. Example 1: "test", 6, " " = "test  " | Example 2: "verylongstring", 5, " " = "veryl"


```lua
function string.ExtendOrCutStringToLength(var: string, length: number, char: any, makeItVisible?: boolean)
  -> string
```


---

# string.byte


Returns the internal numeric codes of the characters `s[i], s[i+1], ..., s[j]`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.byte)


```lua
function string.byte(s: string|number, i?: integer, j?: integer)
  -> ...integer
```


---

# string.char


Returns a string with length equal to the number of arguments, in which each character has the internal numeric code equal to its corresponding argument.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.char)


```lua
function string.char(byte: integer, ...integer)
  -> string
```


---

# string.contains

@*param* `str` — String

@*param* `pattern` — String, Char, Regex

@*return* `found` — 'true' if found, else 'false'.

 Contains on lower case


```lua
function string.contains(str: string, pattern: string)
  -> found: boolean
```


---

# string.dump


Returns a string containing a binary representation (a *binary chunk*) of the given function.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.dump)


```lua
function string.dump(f: fun(...any):...unknown, strip?: boolean)
  -> string
```


---

# string.find


Looks for the first match of `pattern` (see [§6.4.1](http://www.lua.org/manual/5.4/manual.html#6.4.1)) in the string.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.find)

@*return* `start`

@*return* `end`

@*return* `...` — captured


```lua
function string.find(s: string|number, pattern: string|number, init?: integer, plain?: boolean)
  -> start: integer
  2. end: integer
  3. ...any
```


---

# string.format


Returns a formatted version of its variable number of arguments following the description given in its first argument.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.format)


```lua
function string.format(s: string|number, ...any)
  -> string
```


---

# string.gmatch


Returns an iterator function that, each time it is called, returns the next captures from `pattern` (see [§6.4.1](http://www.lua.org/manual/5.4/manual.html#6.4.1)) over the string s.

As an example, the following loop will iterate over all the words from string s, printing one per line:
```lua
    s =
"hello world from Lua"
    for w in string.gmatch(s, "%a+") do
        print(w)
    end
```


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.gmatch)


```lua
function string.gmatch(s: string|number, pattern: string|number, init?: integer)
  -> fun():string, ...unknown
```


---

# string.gsub


Returns a copy of s in which all (or the first `n`, if given) occurrences of the `pattern` (see [§6.4.1](http://www.lua.org/manual/5.4/manual.html#6.4.1)) have been replaced by a replacement string specified by `repl`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.gsub)


```lua
function string.gsub(s: string|number, pattern: string|number, repl: string|number|function|table, n?: integer)
  -> string
  2. count: integer
```


---

# string.len


Returns its length.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.len)


```lua
function string.len(s: string|number)
  -> integer
```


---

# string.lower


Returns a copy of this string with all uppercase letters changed to lowercase.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.lower)


```lua
function string.lower(s: string|number)
  -> string
```


---

# string.match


Looks for the first match of `pattern` (see [§6.4.1](http://www.lua.org/manual/5.4/manual.html#6.4.1)) in the string.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.match)


```lua
function string.match(s: string|number, pattern: string|number, init?: integer)
  -> ...any
```


---

# string.pack


Returns a binary string containing the values `v1`, `v2`, etc. packed (that is, serialized in binary form) according to the format string `fmt` (see [§6.4.2](http://www.lua.org/manual/5.4/manual.html#6.4.2)) .

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.pack)


```lua
function string.pack(fmt: string, v1: string|number, v2: any, ...string|number)
  -> binary: string
```


---

# string.packsize


Returns the size of a string resulting from `string.pack` with the given format string `fmt` (see [§6.4.2](http://www.lua.org/manual/5.4/manual.html#6.4.2)) .

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.packsize)


```lua
function string.packsize(fmt: string)
  -> integer
```


---

# string.rep


Returns a string that is the concatenation of `n` copies of the string `s` separated by the string `sep`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.rep)


```lua
function string.rep(s: string|number, n: integer, sep?: string|number)
  -> string
```


---

# string.reverse


Returns a string that is the string `s` reversed.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.reverse)


```lua
function string.reverse(s: string|number)
  -> string
```


---

# string.split

 http://lua-users.org/wiki/SplitJoin
 Function: Split a string with a pattern, Take Two
 Compatibility: Lua-5.1


```lua
function string.split(str: any, pat: any)
  -> table
```


---

# string.sub


Returns the substring of the string that starts at `i` and continues until `j`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.sub)


```lua
function string.sub(s: string|number, i: integer, j?: integer)
  -> string
```


---

# string.trim


```lua
function string.trim(s: any)
  -> string
```


---

# string.unpack


Returns the values packed in string according to the format string `fmt` (see [§6.4.2](http://www.lua.org/manual/5.4/manual.html#6.4.2)) .

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.unpack)


```lua
function string.unpack(fmt: string, s: string, pos?: integer)
  -> ...any
  2. offset: integer
```


---

# string.upper


Returns a copy of this string with all lowercase letters changed to uppercase.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-string.upper)


```lua
function string.upper(s: string|number)
  -> string
```


---

# table




[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-table)



```lua
tablelib
```


---

# table.concat


Given a list where all elements are strings or numbers, returns the string `list[i]..sep..list[i+1] ··· sep..list[j]`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-table.concat)


```lua
function table.concat(list: table, sep?: string, i?: integer, j?: integer)
  -> string
```


---

# table.contains

@*param* `tbl` — Table to check.

@*param* `key` — Number(index) or String(name matching) for indexing the table.

@*return* `true` — if indexing by key does not return nil

@*return* `index` — also returns the index of the found key

 Return true, if the key is contained in the tbl. NOTE: Doesn't check for duplicates inside the table.


```lua
function table.contains(tbl: table, key: any)
  -> true: boolean
  2. index: number
```


---

# table.containsAll

@*param* `tbl` — The table to check within for the values passed in the following parameters.

@*return* `true` — if all the values were in the table.

 https://gist.github.com/HoraceBury/9307117#file-tablelib-lua-L293-L313
 Returns true if all the arg parameters are contained in the tbl.


```lua
function table.containsAll(tbl: table, ...any)
  -> true: boolean
```


---

# table.contentToString

 We need a simple and 'fast' way to convert a lua table into a string.

@*param* `tbl` — Example: { "Name", 2, 234, "string" }

@*return* `Example` — Name,2,234,string


```lua
function table.contentToString(tbl: table)
  -> Example: string
```


---

# table.foreach


Executes the given f over all elements of table. For each element, f is called with the index and respective value as arguments. If f returns a non-nil value, then the loop is broken, and this value is returned as the final value of foreach.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-table.foreach)


```lua
function table.foreach(list: any, callback: fun(key: string, value: any):<T>|nil)
  -> <T>|nil
```


---

# table.foreachi


Executes the given f over the numerical indices of table. For each index, f is called with the index and respective value as arguments. Indices are visited in sequential order, from 1 to n, where n is the size of the table. If f returns a non-nil value, then the loop is broken and this value is returned as the result of foreachi.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-table.foreachi)


```lua
function table.foreachi(list: any, callback: fun(key: string, value: any):<T>|nil)
  -> <T>|nil
```


---

# table.getn


Returns the number of elements in the table. This function is equivalent to `#list`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-table.getn)


```lua
function table.getn(list: <T>[])
  -> integer
```


---

# table.indexOf

 https://stackoverflow.com/a/52922737/3493998


```lua
function table.indexOf(tbl: any, value: any)
  -> integer|nil
```


---

# table.insert


Inserts element `value` at position `pos` in `list`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-table.insert)


```lua
function table.insert(list: table, pos: integer, value: any)
```


---

# table.insertAll

 DEPRECATED use table.insertAllButNotDuplicates(tbl1, tbl2)
 Adds all values of tbl2 into tbl1.


```lua
function table.insertAll(tbl1: table, tbl2: table)
```


---

# table.insertAllButNotDuplicates

 Adds all values of tbl2 into tbl1, but not duplicates.


```lua
function table.insertAllButNotDuplicates(tbl1: table, tbl2: table)
```


---

# table.insertIfNotExist

 Adds a value to a table, if this value doesn't exist in the table


```lua
function table.insertIfNotExist(tbl: table, value: any)
```


---

# table.maxn


Returns the largest positive numerical index of the given table, or zero if the table has no positive numerical indices.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-table.maxn)


```lua
function table.maxn(table: table)
  -> integer
```


---

# table.move


Moves elements from table `a1` to table `a2`.
```lua
a2[t],··· =
a1[f],···,a1[e]
return a2
```


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-table.move)


```lua
function table.move(a1: table, f: integer, e: integer, t: integer, a2?: table)
  -> a2: table
```


---

# table.pack


Returns a new table with all arguments stored into keys `1`, `2`, etc. and with a field `"n"` with the total number of arguments.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-table.pack)


```lua
function table.pack(...any)
  -> table
```


---

# table.remove


Removes from `list` the element at position `pos`, returning the value of the removed element.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-table.remove)


```lua
function table.remove(list: table, pos?: integer)
  -> any
```


---

# table.removeByTable

 Removes all values in tbl1 by the values of tbl2

@*return* `tbl1` — returns tbl1 with remove values containing in tbl2


```lua
function table.removeByTable(tbl1: table, tbl2: table)
  -> tbl1: table
```


---

# table.removeByValue


```lua
function table.removeByValue(tbl: any, value: any)
  -> unknown
```


---

# table.setNoitaMpDefaultMetaMethods

 Sets metamethods for the table, which are default metamethods for NoitaMP.
 __mode = "kv" is set, so the table can be used as a weak table on key and value.
 __index = decreases __len by 1, so the table can be used as a stack.
 __newindex = increases __len by 1, so the table can be used as a stack.
 __len isn't available in lua 5.1, so init it.

@*param* `tbl` — table to set the metamethods

@*param* `mode` — k or v or kv


```lua
function table.setNoitaMpDefaultMetaMethods(tbl: table, mode?: string)
```


---

# table.size


```lua
function table.size(T: any)
  -> integer
```


---

# table.sort


Sorts list elements in a given order, *in-place*, from `list[1]` to `list[#list]`.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-table.sort)


```lua
function table.sort(list: <T>[], comp?: fun(a: <T>, b: <T>):boolean)
```


---

# table.unpack


Returns the elements from the given list. This function is equivalent to
```lua
    return list[i], list[i+1], ···, list[j]
```
By default, `i` is `1` and `j` is `#list`.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-table.unpack)


```lua
function table.unpack(list: <T>[], i?: integer, j?: integer)
  -> ...<T>
```


---

# toBoolean


```lua
function toBoolean(value: any)
  -> boolean
```


---

# tonumber


When called with no `base`, `tonumber` tries to convert its argument to a number. If the argument is already a number or a string convertible to a number, then `tonumber` returns this number; otherwise, it returns `fail`.

The conversion of strings can result in integers or floats, according to the lexical conventions of Lua (see [§3.1](http://www.lua.org/manual/5.4/manual.html#3.1)). The string may have leading and trailing spaces and a sign.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-tonumber)


```lua
function tonumber(e: any)
  -> number?
```


---

# tostring


Receives a value of any type and converts it to a string in a human-readable format.

If the metatable of `v` has a `__tostring` field, then `tostring` calls the corresponding value with `v` as argument, and uses the result of the call as its result. Otherwise, if the metatable of `v` has a `__name` field with a string value, `tostring` may use that string in its final result.

For complete control of how numbers are converted, use [string.format](http://www.lua.org/manual/5.4/manual.html#pdf-string.format).


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-tostring)


```lua
function tostring(v: any)
  -> string
```


---

# type


Returns the type of its only argument, coded as a string. The possible results of this function are `"nil"` (a string, not the value `nil`), `"number"`, `"string"`, `"boolean"`, `"table"`, `"function"`, `"thread"`, and `"userdata"`.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-type)


```lua
type:
    | "nil"
    | "number"
    | "string"
    | "boolean"
    | "table"
    | "function"
    | "thread"
    | "userdata"
```


```lua
function type(v: any)
  -> type: "boolean"|"function"|"nil"|"number"|"string"...(+3)
```


---

# unpack


Returns the elements from the given `list`. This function is equivalent to
```lua
    return list[i], list[i+1], ···, list[j]
```


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-unpack)


```lua
function unpack(list: <T>[], i?: integer, j?: integer)
  -> ...<T>
```


---

# utf8




[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-utf8)



```lua
utf8lib
```


---

# utf8.char


Receives zero or more integers, converts each one to its corresponding UTF-8 byte sequence and returns a string with the concatenation of all these sequences.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-utf8.char)


```lua
function utf8.char(code: integer, ...integer)
  -> string
```


---

# utf8.codepoint


Returns the codepoints (as integers) from all characters in `s` that start between byte position `i` and `j` (both included).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-utf8.codepoint)


```lua
function utf8.codepoint(s: string, i?: integer, j?: integer, lax?: boolean)
  -> code: integer
  2. ...integer
```


---

# utf8.codes


Returns values so that the construction
```lua
for p, c in utf8.codes(s) do
    body
end
```
will iterate over all UTF-8 characters in string s, with p being the position (in bytes) and c the code point of each character. It raises an error if it meets any invalid byte sequence.


[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-utf8.codes)


```lua
function utf8.codes(s: string, lax?: boolean)
  -> fun(s: string, p: integer):integer, integer
```


---

# utf8.len


Returns the number of UTF-8 characters in string `s` that start between positions `i` and `j` (both inclusive).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-utf8.len)


```lua
function utf8.len(s: string, i?: integer, j?: integer, lax?: boolean)
  -> integer?
  2. errpos: integer?
```


---

# utf8.offset


Returns the position (in bytes) where the encoding of the `n`-th character of `s` (counting from position `i`) starts.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-utf8.offset)


```lua
function utf8.offset(s: string, n: integer, i?: integer)
  -> p: integer
```


---

# warn


Emits a warning with a message composed by the concatenation of all its arguments (which should be strings).

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-warn)


```lua
function warn(message: string, ...any)
```


---

# whoAmI


```lua
function _G.whoAmI()
  -> string
```


---

# xpcall


Calls function `f` with the given arguments in protected mode with a new message handler.

[View documents](http://www.lua.org/manual/5.4/manual.html#pdf-xpcall)


```lua
function xpcall(f: fun(...any):...unknown, msgh: function, arg1?: any, ...any)
  -> success: boolean
  2. result: any
  3. ...any
```