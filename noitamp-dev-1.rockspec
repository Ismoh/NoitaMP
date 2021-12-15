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
  "lua = 5.1",
  "ffi",
}

build = {
  type = "builtin",
  modules = {}
}
