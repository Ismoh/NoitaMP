rockspec_format = "3.0"
package         = "noita-mp"
version         = "3.0.0-3" -- Needs to be updated manually and the same as in `.version` file.
source          = {
    url = "git+https://github.com/Ismoh/NoitaMP.git"
}
description     = {
    homepage = "https://github.com/Ismoh/NoitaMP",
    license  = "GNU GPL v3"
}
dependencies    = {
    "lua ~> 5.1",
    "luafilesystem = 1.8.0-1",
    "luafilesystem-ffi = scm-1",
    "luaunit = 3.4-1",
}
build           = {
    type    = "builtin",
    modules = { -- change this to copy_directories? Does package path work without `modules`?
        config                                                    = "config.lua",
        ["files.scripts.DefaultBiomeMap"]                         = "files/scripts/DefaultBiomeMap.lua",
        ["files.scripts.Ui"]                                      = "files/scripts/Ui.lua",
        ["files.scripts.biome.testingRoom"]                       = "files/scripts/biome/testingRoom.lua",
        ["files.scripts.extensions.ffi_extensions"]               = "files/scripts/extensions/ffi_extensions.lua",
        ["files.scripts.extensions.globalExtensions"]             = "files/scripts/extensions/globalExtensions.lua",
        ["files.scripts.extensions.mathExtensions"]               = "files/scripts/extensions/mathExtensions.lua",
        ["files.scripts.extensions.string_extensions"]            = "files/scripts/extensions/string_extensions.lua",
        ["files.scripts.extensions.table_extensions"]             = "files/scripts/extensions/table_extensions.lua",
        ["files.scripts.init.init_"]                              = "files/scripts/init/init_.lua",
        ["files.scripts.init.init_logger"]                        = "files/scripts/init/init_logger.lua",
        ["files.scripts.init.init_package_loading"]               = "files/scripts/init/init_package_loading.lua",
        ["files.scripts.net.Client"]                              = "files/scripts/net/Client.lua",
        ["files.scripts.net.Server"]                              = "files/scripts/net/Server.lua",
        ["files.scripts.noita-components.dump_logger"]            = "files/scripts/noita-components/dump_logger.lua",
        ["files.scripts.noita-components.lua_component_enabler"]  = "files/scripts/noita-components/lua_component_enabler.lua",
        ["files.scripts.noita-components.name_tags"]              = "files/scripts/noita-components/name_tags.lua",
        ["files.scripts.noita-components.nuid_debug"]             = "files/scripts/noita-components/nuid_debug.lua",
        ["files.scripts.noita-components.nuid_updater"]           = "files/scripts/noita-components/nuid_updater.lua",
        ["files.scripts.util.CoroutineUtils"]                     = "files/scripts/util/CoroutineUtils.lua",
        ["files.scripts.util.CustomProfiler"]                     = "files/scripts/util/CustomProfiler.lua",
        ["files.scripts.util.EntityUtils"]                        = "files/scripts/util/EntityUtils.lua",
        ["files.scripts.util.GlobalsUtils"]                       = "files/scripts/util/GlobalsUtils.lua",
        ["files.scripts.util.NetworkUtils"]                       = "files/scripts/util/NetworkUtils.lua",
        ["files.scripts.util.NetworkVscUtils"]                    = "files/scripts/util/NetworkVscUtils.lua",
        ["files.scripts.util.NoitaComponentUtils"]                = "files/scripts/util/NoitaComponentUtils.lua",
        ["files.scripts.util.NuidUtils"]                          = "files/scripts/util/NuidUtils.lua",
        ["files.scripts.util.file_util"]                          = "files/scripts/util/file_util.lua",
        ["files.scripts.util.GuidUtils"]                               = "files/scripts/util/GuidUtils.lua",
        ["files.scripts.util.util"]                               = "files/scripts/util/util.lua",
        init                                                      = "init.lua",
        modSettingsUpdater                                        = "modSettingsUpdater.lua",
        settings                                                  = "settings.lua",
        ["tests.config_test"]                                     = "tests/config_test.lua",
        ["tests.files.scripts.extensions.string_extensions_test"] = "tests/files/scripts/extensions/string_extensions_test.lua",
        ["tests.files.scripts.extensions.table_extensions_test"]  = "tests/files/scripts/extensions/table_extensions_test.lua",
        ["tests.files.scripts.init.init__test"]                   = "tests/files/scripts/init/init__test.lua",
        ["tests.files.scripts.init.init_logger_test"]             = "tests/files/scripts/init/init_logger_test.lua",
        ["tests.files.scripts.init.init_package_loading_test"]    = "tests/files/scripts/init/init_package_loading_test.lua",
        ["tests.files.scripts.net.Server_test"]                   = "tests/files/scripts/net/Server_test.lua",
        ["tests.files.scripts.util.EntityUtils_test"]             = "tests/files/scripts/util/EntityUtils_test.lua",
        ["tests.files.scripts.util.GlobalsUtils_test"]            = "tests/files/scripts/util/GlobalsUtils_test.lua",
        ["tests.files.scripts.util.NetworkUtils_test"]            = "tests/files/scripts/util/NetworkUtils_test.lua",
        ["tests.files.scripts.util.NetworkVscUtils_test"]         = "tests/files/scripts/util/NetworkVscUtils_test.lua",
        ["tests.files.scripts.util.NuidUtils_test"]               = "tests/files/scripts/util/NuidUtils_test.lua",
        ["tests.files.scripts.util.file_util_test"]               = "tests/files/scripts/util/file_util_test.lua",
        ["tests.files.scripts.util.GuidUtils_test"]                    = "tests/files/scripts/util/GuidUtils_test.lua",
        ["tests.files.scripts.util.util_test"]                    = "tests/files/scripts/util/util_test.lua",
        ["tests.init_test"]                                       = "tests/init_test.lua",
        ["tests._initializeUnitTests"]                                  = "tests/_initializeUnitTests.lua"
    },
}
test            = {
    type   = "command",
    script = "tests/_initializeUnitTests.lua",
}
