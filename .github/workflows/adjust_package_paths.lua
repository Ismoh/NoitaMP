print("adjust_package_paths.lua | Adjust luajits package.path to be able to run luarocks modules..")
package.path = package.path .. "/home/runner/work/NoitaMP/NoitaMP/luarocks/share/lua/5.1/?.lua"
package.path = package.path .. "/home/runner/work/NoitaMP/NoitaMP/luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. "/home/runner/work/NoitaMP/NoitaMP/luarocks/share/lua/5.1/?/?.lua"
package.cpath = package.cpath .. "/home/runner/work/NoitaMP/NoitaMP/luarocks/lib/lua/5.1/?.so"

print("adjust_package_paths.lua | package.path = " .. package.path)
print("adjust_package_paths.lua | package.cpath = " .. package.cpath)