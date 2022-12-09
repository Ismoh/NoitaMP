rockspec_format = "3.0"
package = "Noita-Synchronise-Expansive-Worlds"
version = "dev-1"
source = {
    url = "git://github.com/dextercd/Noita-Synchronise-Expansive-Worlds"
}
description = {
    homepage = "https://github.com/dextercd/Noita-Synchronise-Expansive-Worlds",
    license = "MIT"
}
dependencies = {
    "lua ~> 5.1",
}

build = {
    type = "cmake",
}