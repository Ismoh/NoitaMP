
-- facebook zstandard ffi binding
-- Written by Soojin Nam. Public Domain.


local ffi = require "ffi"
local C = ffi.C
local ffi_new = ffi.new
local ffi_load = ffi.load
local ffi_str = ffi.string
local ffi_typeof = ffi.typeof
local assert = assert
local tonumber = tonumber
local fopen = io.open
local gsub = string.gsub
local tinsert = table.insert
local tconcat = table.concat


ffi.cdef[[
typedef struct ZSTD_CCtx_s ZSTD_CCtx;
ZSTD_CCtx* ZSTD_createCCtx(void);
size_t     ZSTD_freeCCtx(ZSTD_CCtx* cctx);

typedef struct ZSTD_DCtx_s ZSTD_DCtx;
ZSTD_DCtx* ZSTD_createDCtx(void);
size_t     ZSTD_freeDCtx(ZSTD_DCtx* dctx);

unsigned long long ZSTD_getFrameContentSize(const void *src, size_t srcSize);
size_t      ZSTD_compressBound(size_t srcSize);
int    ZSTD_maxCLevel(void);
unsigned    ZSTD_isError(size_t code);
const char* ZSTD_getErrorName(size_t code);

typedef struct ZSTD_inBuffer_s {
  const void* src;
  size_t size;
  size_t pos;
} ZSTD_inBuffer;

typedef struct ZSTD_outBuffer_s {
  void*  dst;
  size_t size;
  size_t pos;
} ZSTD_outBuffer;

typedef struct ZSTD_CStream_s ZSTD_CStream;
ZSTD_CStream* ZSTD_createCStream(void);
size_t ZSTD_freeCStream(ZSTD_CStream* zcs);
size_t ZSTD_initCStream(ZSTD_CStream* zcs, int compressionLevel);
size_t ZSTD_compressStream(ZSTD_CStream* zcs, 
                           ZSTD_outBuffer* output, ZSTD_inBuffer* input);
size_t ZSTD_endStream(ZSTD_CStream* zcs, ZSTD_outBuffer* output);
size_t ZSTD_CStreamInSize(void);
size_t ZSTD_CStreamOutSize(void);

typedef struct ZSTD_DStream_s ZSTD_DStream;
ZSTD_DStream* ZSTD_createDStream(void);
size_t ZSTD_freeDStream(ZSTD_DStream* zds);
size_t ZSTD_initDStream(ZSTD_DStream* zds);
size_t ZSTD_decompressStream(ZSTD_DStream* zds,
                             ZSTD_outBuffer* output, ZSTD_inBuffer* input);
size_t ZSTD_DStreamInSize(void);
size_t ZSTD_DStreamOutSize(void);

typedef struct ZSTD_CDict_s ZSTD_CDict;
ZSTD_CDict* ZSTD_createCDict(const void* dictBuffer, size_t dictSize,
                             int compressionLevel);
size_t      ZSTD_freeCDict(ZSTD_CDict* CDict);
size_t ZSTD_compress_usingCDict(ZSTD_CCtx* cctx,
                                void* dst, size_t dstCapacity,
                                const void* src, size_t srcSize,
                                const ZSTD_CDict* cdict);

typedef struct ZSTD_DDict_s ZSTD_DDict;
ZSTD_DDict* ZSTD_createDDict(const void* dictBuffer, size_t dictSize);
size_t      ZSTD_freeDDict(ZSTD_DDict* ddict);
size_t ZSTD_decompress_usingDDict(ZSTD_DCtx* dctx,
                                  void* dst, size_t dstCapacity,
                                  const void* src, size_t srcSize,
                                  const ZSTD_DDict* ddict);
unsigned ZSTD_getDictID_fromDDict(const ZSTD_DDict* ddict);
unsigned ZSTD_getDictID_fromFrame(const void* src, size_t srcSize);
]]


local arr_utint8_t = ffi_typeof "uint8_t[?]"
local ptr_zstd_inbuffer_t = ffi_typeof "ZSTD_inBuffer[1]"
local ptr_zstd_outbuffer_t = ffi_typeof "ZSTD_outBuffer[1]"


local zstd = ffi_load "zstd"


local _M = {
    version = '0.2.3'
}


local function init_cstream (cstream, cLevel)
   local res = zstd.ZSTD_initCStream(cstream, cLevel or 1);
   if zstd.ZSTD_isError(res) ~= 0 then
      return "ZSTD_initCStream() error: "..ffi_str(zstd.ZSTD_getErrorName(res))
   end
end


local function init_dstream (dstream)
   local res = zstd.ZSTD_initDStream(dstream)
   if zstd.ZSTD_isError(res) ~= 0 then
      return "ZSTD_initDStream() error: "..ffi_str(zstd.ZSTD_getErrorName(res))
   end
end


local function end_frame (cstream)
   local olen = zstd.ZSTD_CStreamOutSize();
   local obuf = ffi_new(arr_utint8_t, olen);
   local output = ffi_new(ptr_zstd_outbuffer_t)
   output[0] = { obuf, olen, 0 }
   if zstd.ZSTD_endStream(cstream, output) ~= 0 then
      return nil, "not fully flushed"
   end
   return ffi_str(obuf, output[0].pos)
end


function _M.new (self)
   local cstream = zstd.ZSTD_createCStream();
   if not cstream then
      return nil, "ZSTD_createCStream() error"
   end
   local dstream = zstd.ZSTD_createDStream();
   if not dstream then
      return nil, "ZSTD_createDStream() error"
   end
   return setmetatable({cstream = cstream, dstream = dstream}, {__index = _M})
end


function _M.free (self)
   zstd.ZSTD_freeCStream(self.cstream)
   zstd.ZSTD_freeDStream(self.dstream)
end


function _M.maxCLevel (self)
   return tonumber(zstd.ZSTD_maxCLevel())
end


local function compress_stream (cstream, inbuf, cLevel)
   local cLevel = cLevel or 1
   local insize = #inbuf
   local olen = zstd.ZSTD_CStreamOutSize();
   local obuf = ffi_new(arr_utint8_t, olen);
   local input = ffi_new(ptr_zstd_inbuffer_t)
   local output = ffi_new(ptr_zstd_outbuffer_t)
   local rlen = insize;
   local result = {}
   input[0] = { inbuf, rlen, 0 }
   while input[0].pos < input[0].size do
      output[0] = { obuf, olen, 0 }
      rlen = zstd.ZSTD_compressStream(cstream, output, input);
      if zstd.ZSTD_isError(rlen) ~= 0 then
         return nil, "ZSTD_compressStream() error: "
            .. ffi_str(zstd.ZSTD_getErrorName(rlen))
      end
      if rlen > insize then
         rlen = insize
      end
      tinsert(result, ffi_str(obuf, output[0].pos))
   end
   return tconcat(result)
end


local function decompress_stream (dstream, inbuf)
   local rlen = #inbuf
   local olen = zstd.ZSTD_DStreamOutSize()
   local obuf = ffi_new(arr_utint8_t, olen)
   local input = ffi_new(ptr_zstd_inbuffer_t)
   local output = ffi_new(ptr_zstd_outbuffer_t)
   local decompressed = {}
   input[0] = { inbuf, rlen, 0 }
   while input[0].pos < input[0].size do
      output[0] = { obuf, olen, 0 }
      rlen = zstd.ZSTD_decompressStream(dstream, output, input);
      if zstd.ZSTD_isError(rlen) ~= 0 then
         return nil, "ZSTD_decompressStream() error: "
            .. ffi_str(zstd.ZSTD_getErrorName(rlen))
      end
      tinsert(decompressed, ffi_str(obuf, output[0].pos))
   end
   return tconcat(decompressed)
end


function _M:compress (fBuff, cLevel)
   local cstream = self.cstream
   local err = init_cstream(cstream, cLevel)
   if err then
      return nil, err
   end
   return compress_stream(cstream, fBuff, cLevel) .. end_frame(cstream)
end


function _M:decompress (cBuff)
   local dstream = self.dstream
   local err = init_dstream(dstream)
   if err then
      return nil, err
   end
   return decompress_stream(dstream, cBuff)
end


function _M:compressFile (fname, cLevel)
   local cstream = self.cstream
   local fin = assert(fopen(fname, "rb"))
   local fout = assert(fopen(fname..".zst", "wb"))
   local err = init_cstream(cstream, cLevel)
   if err then
      return nil, err
   end
   local rlen = tonumber(zstd.ZSTD_CStreamInSize());
   local buff = fin:read(rlen)
   while buff do
      local obuff = compress_stream(cstream, buff, cLevel)
      fout:write(obuff)
      buff = fin:read(rlen)
   end
   fout:write(end_frame(cstream))
   fout:close()
   fin:close()
   return true
end


function _M:decompressFile (fname, oname)
   local dstream = self.dstream
   local fin = assert(fopen(fname, "rb"))
   local fout = assert(fopen(oname or gsub(fname, "%.zst", ""), "wb"))
   local err = init_dstream(dstream)
   if err then
      return nil, err
   end
   local rlen = tonumber(zstd.ZSTD_DStreamInSize())
   local buff = fin:read(rlen)
   while buff do
      local obuff = decompress_stream(dstream, buff)
      fout:write(obuff)
      buff = fin:read(rlen)
   end
   fout:close()
   fin:close()
   return true
end


local function create_dict (iscompress, fname, cLevel)
   local fd = assert(fopen(fname, "rb"))
   local current = fd:seek()
   local dictSize = fd:seek("end")
   fd:seek("set", current)
   local dictBuffer = ffi_new("char[?]", dictSize, fd:read("*a"))
   fd:close()
   return iscompress
      and zstd.ZSTD_createCDict(dictBuffer, dictSize, cLevel)
      or  zstd.ZSTD_createDDict(dictBuffer, dictSize)
end


function _M:compressFileUsingDictionary (fname, dname, cLevel)
   local cdict = create_dict(true, dname, cLevel or 1)

   local fin = assert(fopen(fname, "rb"))
   local current = fin:seek()
   local fSize = fin:seek("end")
   fin:seek("set", current)
   local fBuff = ffi_new("char[?]", fSize, fin:read("*a"))
   fin:close()

   local cBuffSize = zstd.ZSTD_compressBound(fSize)
   local cBuff = ffi_new("char[?]", cBuffSize)
   local cctx = zstd.ZSTD_createCCtx()
   local cSize = zstd.ZSTD_compress_usingCDict(cctx, cBuff, cBuffSize,
                                               fBuff, fSize, cdict)
   local fout = assert(fopen(fname..".zst", "wb"))
   fout:write(ffi_str(cBuff, cSize))
   fout:close()
   zstd.ZSTD_freeCCtx(cctx)
   return true
end


function _M:decompressFileUsingDictionary (fname, oname, dname)
   local ddict = create_dict(false, dname)

   local fin = assert(fopen(fname, "rb"))
   local current = fin:seek()
   local cSize = fin:seek("end")
   fin:seek("set", current)
   local cBuff = ffi_new("char[?]", cSize, fin:read("*a"))
   fin:close()

   local rSize = zstd.ZSTD_getFrameContentSize(cBuff, cSize)
   local rBuff = ffi_new("char[?]", rSize)
   local dctx = zstd.ZSTD_createDCtx()
   local dSize = zstd.ZSTD_decompress_usingDDict(dctx, rBuff, rSize,
                                                 cBuff, cSize, ddict)
   local fout = assert(fopen(oname or gsub(fname, "%.zst", ""), "wb"))
   fout:write(ffi_str(rBuff, rSize))
   fout:close()
   zstd.ZSTD_freeDCtx(dctx)
   return true
end


return _M
