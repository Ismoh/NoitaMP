-- Used to provide silent reimplementations of os.execute and io.popen

if not jit or jit.os ~= "Windows" then
    return
end

if executedAlready then
    return
else
    executedAlready = true
end

local ffi = require("ffi")

local C   = ffi.C

ffi.cdef [[
typedef bool BOOL;
typedef uint16_t WORD;
typedef uint32_t DWORD;
typedef void *LPVOID;
typedef unsigned char *LPBYTE;
typedef char *LPSTR;
typedef const char *LPCSTR;
typedef void *HANDLE;
typedef HANDLE *PHANDLE;
typedef DWORD *LPDWORD;

// Renamed to _SECURITY_ATTRIBUTES_2 to avoid conflict with lfs_ffi
typedef struct _SECURITY_ATTRIBUTES_2 {
  DWORD  nLength;
  LPVOID lpSecurityDescriptor;
  BOOL   bInheritHandle;
} SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;
typedef struct _STARTUPINFOA {
  DWORD  cb;
  LPSTR  lpReserved;
  LPSTR  lpDesktop;
  LPSTR  lpTitle;
  DWORD  dwX;
  DWORD  dwY;
  DWORD  dwXSize;
  DWORD  dwYSize;
  DWORD  dwXCountChars;
  DWORD  dwYCountChars;
  DWORD  dwFillAttribute;
  DWORD  dwFlags;
  WORD   wShowWindow;
  WORD   cbReserved2;
  LPBYTE lpReserved2;
  HANDLE hStdInput;
  HANDLE hStdOutput;
  HANDLE hStdError;
} STARTUPINFOA, *LPSTARTUPINFOA;
typedef struct _PROCESS_INFORMATION {
  HANDLE hProcess;
  HANDLE hThread;
  DWORD  dwProcessId;
  DWORD  dwThreadId;
} PROCESS_INFORMATION, *PPROCESS_INFORMATION, *LPPROCESS_INFORMATION;
BOOL CreatePipe(
  PHANDLE,
  PHANDLE,
  LPSECURITY_ATTRIBUTES,
  DWORD
);
BOOL SetHandleInformation(
  HANDLE,
  DWORD,
  DWORD
);
HANDLE GetStdHandle(DWORD);
BOOL CreateProcessA(
  LPCSTR,
  LPCSTR,
  LPSECURITY_ATTRIBUTES,
  LPSECURITY_ATTRIBUTES,
  BOOL,
  DWORD,
  LPVOID,
  LPCSTR,
  LPSTARTUPINFOA,
  LPPROCESS_INFORMATION
);
DWORD WaitForSingleObject(
  HANDLE,
  DWORD
);
BOOL GetExitCodeProcess(
  HANDLE,
  LPDWORD
);
BOOL CloseHandle(HANDLE);
BOOL ReadFile(
  HANDLE,
  LPVOID,
  DWORD,
  LPDWORD,
  void*
);
DWORD GetLastError();
]]

local EXIT_FAILURE         = 1
local STARTF_USESHOWWINDOW = 1
local STARTF_USESTDHANDLES = 0x100
local SW_HIDE              = 0
local CREATE_NO_WINDOW     = 0x8000000
local INFINITE             = -1
local HANDLE_FLAG_INHERIT  = 1
local STD_INPUT_HANDLE     = -10
local STD_ERROR_HANDLE     = -12
local ERROR_BROKEN_PIPE    = 109

function os.execute(commandLine)
    local si       = ffi.new("STARTUPINFOA")
    si.cb          = ffi.sizeof(si)
    si.dwFlags     = STARTF_USESHOWWINDOW
    si.wShowWindow = SW_HIDE

    local pi       = ffi.new("PROCESS_INFORMATION")
    if not C.CreateProcessA(nil, "cmd /C " .. commandLine, nil, nil, 0, CREATE_NO_WINDOW, nil, nil, si, pi) then
        return EXIT_FAILURE
    end
    C.WaitForSingleObject(pi.hProcess, INFINITE)
    local exitcode = ffi.new("DWORD[1]")
    local ok       = C.GetExitCodeProcess(pi.hProcess, exitcode)
    C.CloseHandle(pi.hProcess)
    C.CloseHandle(pi.hThread)
    return ok and exitcode[0] or EXIT_FAILURE
end

local pfile    = {}
local pfile_mt = { __index = pfile }

local function checkclosed(pfile)
    if pfile.pi == nil then
        error("attempt to use a closed file", 3)
    end
end

function pfile:read(n)
    checkclosed(self)

    local function fetch(cond)
        while cond() do
            if C.ReadFile(self.pipe_outRd[0], self.byteBuf, self.size, self.bytesRead, nil) then
                local data = ffi.string(self.byteBuf, self.bytesRead[0])
                if self.buffer:sub(-1) == "\r" and data:sub(1, 1) == "\n" then
                    self.buffer = self.buffer:sub(1, -2)
                end
                self.buffer = self.buffer .. data:gsub("\r\n", "\n")
            else
                return C.GetLastError() == ERROR_BROKEN_PIPE
            end
        end
        return true
    end

    if type(n) == "number" then
        if not fetch(function()
            return #self.buffer < n
        end) then
            return nil
        end
        local out   = self.buffer:sub(1, n)
        self.buffer = self.buffer:sub(n + 1)
        if out == "" then
            out = nil
        end
        return out
    elseif n == "*a" then
        if not fetch(function()
            return true
        end) then
            return nil
        end
        local out   = self.buffer
        self.buffer = ""
        return out
    elseif n == "*l" then
        if not fetch(function()
            return not self.buffer:find("\n", nil, true)
        end) then
            return nil
        end
        local out
        local npos = self.buffer:find("\n", nil, true)
        if npos then
            out         = self.buffer:sub(1, npos - 1)
            self.buffer = self.buffer:sub(npos + 1)
        else
            out         = self.buffer
            self.buffer = ""
            if out == "" then
                out = nil
            end
        end
        return out
    else
        error("bad argument #1 to 'read' (invalid format)", 2)
    end
end

function pfile:lines()
    checkclosed(self)
    return function()
        return self:read("*l")
    end
end

function pfile:close()
    checkclosed(self)
    local pi = self.pi
    C.CloseHandle(self.pipe_outRd[0])
    C.WaitForSingleObject(pi.hProcess, INFINITE)
    local res = C.CloseHandle(pi.hProcess) and C.CloseHandle(pi.hThread)
    self.pi   = nil
    return res
end

function io.popen(commandLine)
    local sa                     = ffi.new("SECURITY_ATTRIBUTES", ffi.sizeof("SECURITY_ATTRIBUTES"), nil, true)

    local pipe_outRd, pipe_outWr = ffi.new("HANDLE[1]"), ffi.new("HANDLE[1]")
    if not C.CreatePipe(pipe_outRd, pipe_outWr, sa, 0) or not C.SetHandleInformation(pipe_outRd[0], HANDLE_FLAG_INHERIT,
                                                                                     0) then
        return
    end

    local si       = ffi.new("STARTUPINFOA")
    si.cb          = ffi.sizeof(si)
    si.dwFlags     = STARTF_USESHOWWINDOW + STARTF_USESTDHANDLES
    si.wShowWindow = SW_HIDE
    si.hStdInput   = C.GetStdHandle(STD_INPUT_HANDLE)
    si.hStdOutput  = pipe_outWr[0]
    si.hStdError   = C.GetStdHandle(STD_ERROR_HANDLE)

    local pi       = ffi.new("PROCESS_INFORMATION")
    if not C.CreateProcessA(nil, "cmd /C " .. commandLine, nil, nil, 1, CREATE_NO_WINDOW, nil, nil, si, pi) then
        return
    end
    C.CloseHandle(pipe_outWr[0])

    local size = 4096
    return setmetatable({
                            pi         = pi,
                            pipe_outRd = pipe_outRd,
                            size       = size,
                            byteBuf    = ffi.new("char[?]", size),
                            bytesRead  = ffi.new("DWORD[1]"),
                            buffer     = ""
                        }, pfile_mt)
end
