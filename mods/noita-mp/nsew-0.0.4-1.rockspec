rockspec_format = "3.0"
package = "nsew"
version = "0.0.4-1"
source = {
    url = "git://github.com/dextercd/Noita-Synchronise-Expansive-Worlds",
    tag = "0.0.4"
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