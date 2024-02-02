--source and credits: https://discord.com/channels/561645196757041163/1170838298709733496/1170838298709733496

local ffi = require("ffi")
ffi.cdef [[
int __stdcall CryptBinaryToStringA(
    const char *pbBinary,
    int cbBinary,
    int dwFlags,
    char * pszString,
    int *pcchString
);

int __stdcall CryptStringToBinaryA(
  const char *pszString,
  int cchString,
  int dwFlags,
  char *pbBinary,
  int *pcbBinary,
  int *pdwSkip,
  int *pdwFlags
);
]]

local crypt = ffi.load(ffi.os == "Windows" and "crypt32")

local base64 = {
    buflen = ffi.new("int[1]")
}
-- TODO: 00:18]fathom_b: Depending on the nature of the calls, you could potentially avoid ffi.new()ing those variables each time. [00:18]fathom_b: And keep them around.

function base64.encode(str)
    --local buflen = ffi.new("int[1]")
    crypt.CryptBinaryToStringA(str, #str, 1, nil, base64.buflen)

    local buf = ffi.new("char[?]", base64.buflen[0])
    crypt.CryptBinaryToStringA(str, #str, 1, buf, base64.buflen)
    return ffi.string(buf, base64.buflen[0])
end

function base64.decode(str)
    --local buflen = ffi.new("int[1]")
    crypt.CryptStringToBinaryA(str, #str, 1, nil, base64.buflen, nil, nil)

    local buf = ffi.new("char[?]", base64.buflen[0])
    crypt.CryptStringToBinaryA(str, #str, 1, buf, base64.buflen, nil, nil)
    return ffi.string(buf, base64.buflen[0])
end

local test = base64.encode("Hello World!")
print("base64 quick'n'dirty test:")
assert(base64.encode("SGVsbG8gV29ybGQh") == test)
print(("%s == %s"):format(test, base64.decode(test)))

return base64
