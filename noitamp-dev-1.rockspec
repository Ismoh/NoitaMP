package = "noitamp"
version = "dev-1"

source = {
  url = "git://github.com/Ismoh/NoitaMP.git",
}

description = {
  summary = "Needed for leafo/gh-actions-lua",
  homepage = "https://github.com/leafo/gh-actions-lua",
  license = "MIT"
}

dependencies = {
  "penlight >= 1.3.2",
  "lua-term >= 0.1",
  "dkjson >= 2.1.0",
  "lua_cliargs == 3.0",
  "luasystem >= 0.2.0",
  "say >= 1.3",
  "luafilesystem >= 1.5.0",
  "luassert >= 1.8.0",
  "mediator_lua >= 1.1.1",
}

build = {
  type = "builtin",
  modules = {}
}
