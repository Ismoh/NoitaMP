cmake_minimum_required(VERSION 3.20)

project(lua_noitamp_native)

add_library(lua_noitamp_native SHARED
    lua_noitamp_native.c
    entity_map.cpp
    lua_export.cpp
    debug.cpp)


set(LUA_SHARED ${PROJECT_SOURCE_DIR}/luajit/bin/lua51.dll
    CACHE FILEPATH "Path to lua dll"
)

set(LUA_LIBRARIES ${PROJECT_SOURCE_DIR}/luajit/bin/lua51.lib
    CACHE FILEPATH "Path to lua lib"
)

set(LUA_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/luajit/include
    CACHE PATH "Path to lua include dir"
)

target_link_libraries(lua_noitamp_native
    PRIVATE ${LUA_LIBRARIES}
)

target_include_directories(lua_noitamp_native
    PRIVATE ${LUA_INCLUDE_DIR}
)

add_executable(perftest perftest.cpp)
target_link_libraries(perftest
    PRIVATE  ${LUA_LIBRARIES}
    PRIVATE  $<TARGET_OBJECTS:lua_noitamp_native>
)

add_custom_command(TARGET perftest POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${LUA_SHARED}
        $<TARGET_FILE_DIR:perftest>)
