TestBase64_ffi = {
    base64 = require("base64_ffi")
}

function TestBase64_ffi:testEncode()
    lu.assertEquals("SGVsbG8gV29ybGQh", self.base64.encode("Hello World!"))
end

function TestBase64_ffi:testDecode()
    lu.assertEquals("Hello World!", self.base64.decode("SGVsbG8gV29ybGQh"))
end
