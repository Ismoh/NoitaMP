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

function base64.encode(str)
    crypt.CryptBinaryToStringA(str, #str, 1, nil, base64.buflen)

    local buf = ffi.new("char[?]", base64.buflen[0])
    crypt.CryptBinaryToStringA(str, #str, 1, buf, base64.buflen)
    return ffi.string(buf, base64.buflen[0]):trim() -- there is a newline at the end?!
end

function base64.decode(str)
    crypt.CryptStringToBinaryA(str, #str, 1, nil, base64.buflen, nil, nil)

    local buf = ffi.new("char[?]", base64.buflen[0])
    crypt.CryptStringToBinaryA(str, #str, 1, buf, base64.buflen, nil, nil)
    return ffi.string(buf, base64.buflen[0])
end

return base64
