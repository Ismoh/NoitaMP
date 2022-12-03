local bit = require "bit"
local ffi = require "ffi"


local pairs = pairs
local tonumber = tonumber
local type = type
local band = bit.band
local rshift = bit.rshift
local io_type = io.type
local lib = ffi.C
local ffi_errno = ffi.errno
local ffi_new = ffi.new
local ffi_str = ffi.string
local concat = table.concat
local has_table_new, new_tab = pcall(require, "table.new")
if not has_table_new or type(new_tab) ~= "function" then
    new_tab = function () return {} end
end


local _M = {
    _VERSION = "0.3",
}

-- common utils/constants
local IS_64_BIT = ffi.abi('64bit')
local ERANGE = 'Result too large'

if not pcall(ffi.typeof, "ssize_t") then
    -- LuaJIT 2.0 doesn't have ssize_t as a builtin type, let's define it
    ffi.cdef("typedef intptr_t ssize_t")
end

ffi.cdef([[
    char* strerror(int errnum);
]])

local function errno()
    return ffi_str(lib.strerror(ffi_errno()))
end

local OS = ffi.os
if OS == "Windows" then
    error("Windows is not supported anymore. Use https://github.com/sonoro1234/luafilesystem instead.")
end

-- sys/syslimits.h
local MAXPATH
if OS == 'Linux' then
    MAXPATH = 4096
else
    MAXPATH = 1024
end

-- misc
ffi.cdef([[
    char *getcwd(char *buf, size_t size);
    int chdir(const char *path);
    int rmdir(const char *pathname);
    typedef unsigned int mode_t;
    int mkdir(const char *pathname, mode_t mode);
    typedef size_t time_t;
    struct utimebuf {
        time_t actime;
        time_t modtime;
    };
    int utime(const char *file, const struct utimebuf *times);
    int link(const char *oldpath, const char *newpath);
    int symlink(const char *oldpath, const char *newpath);
]])

function _M.chdir(path)
    if lib.chdir(path) == 0 then
        return true
    end
    return nil, errno()
end

function _M.currentdir()
    local size = MAXPATH
    while true do
        local buf = ffi_new("char[?]", size)
        if lib.getcwd(buf, size) ~= nil then
            return ffi_str(buf)
        end
        local err = errno()
        if err ~= ERANGE then
            return nil, err
        end
        size = size * 2
    end
end

function _M.mkdir(path, mode)
    if lib.mkdir(path, mode or 509) == 0 then
        return true
    end
    return nil, errno()
end

function _M.rmdir(path)
    if lib.rmdir(path) == 0 then
        return true
    end
    return nil, errno()
end

function _M.touch(path, actime, modtime)
    local buf

    if type(actime) == "number" then
        modtime = modtime or actime
        buf = ffi_new("struct utimebuf")
        buf.actime  = actime
        buf.modtime = modtime
    end

    local p = ffi_new("unsigned char[?]", #path + 1, path)
    if lib.utime(p, buf) == 0 then
        return true
    end
    return nil, errno()
end

function _M.setmode()
    return true, "binary"
end

function _M.link(old, new, symlink)
    local f = symlink and lib.symlink or lib.link
    if f(old, new) == 0 then
        return true
    end
    return nil, errno()
end

local dirent_def
if OS == 'OSX' or OS == 'BSD' then
    dirent_def = [[
        /* _DARWIN_FEATURE_64_BIT_INODE is NOT defined here? */
        struct dirent {
            uint32_t d_ino;
            uint16_t d_reclen;
            uint8_t  d_type;
            uint8_t  d_namlen;
            char d_name[256];
        };
    ]]
else
    dirent_def = [[
        struct dirent {
            int64_t           d_ino;
            size_t           d_off;
            unsigned short  d_reclen;
            unsigned char   d_type;
            char            d_name[256];
        };
    ]]
end

ffi.cdef(dirent_def .. [[
    typedef struct  __dirstream DIR;
    DIR *opendir(const char *name);
    struct dirent *readdir(DIR *dirp);
    int closedir(DIR *dirp);
]])

local function close(dir)
    if dir._dentry ~= nil then
        lib.closedir(dir._dentry)
        dir._dentry = nil
        dir.closed = true
    end
end

local function iterator(dir)
    if dir.closed ~= false then error("closed directory") end

    local entry = lib.readdir(dir._dentry)
    if entry ~= nil then
        return ffi_str(entry.d_name)
    else
        close(dir)
        return nil
    end
end

local dir_obj_type = ffi.metatype([[
    struct {
        DIR *_dentry;
        bool closed;
    }
]],
{__index = {
    next = iterator,
    close = close,
}, __gc = close
})

function _M.dir(path)
    local dentry = lib.opendir(path)
    if dentry == nil then
        error("cannot open "..path.." : "..errno())
    end
    local dir_obj = ffi_new(dir_obj_type)
    dir_obj._dentry = dentry
    dir_obj.closed = false;
    return iterator, dir_obj
end

local SEEK_SET = 0
local F_SETLK = (OS == 'Linux') and 6 or 8
local mode_ltype_map
local flock_def
if OS == 'Linux' then
    flock_def = [[
        struct flock {
            short int l_type;
            short int l_whence;
            int64_t l_start;
            int64_t l_len;
            int l_pid;
        };
    ]]
    mode_ltype_map = {
        r = 0, -- F_RDLCK
        w = 1, -- F_WRLCK
        u = 2, -- F_UNLCK
    }
else
    flock_def = [[
        struct flock {
            int64_t l_start;
            int64_t l_len;
            int32_t l_pid;
            short l_type;
            short l_whence;
        };
    ]]
    mode_ltype_map = {
        r = 1, -- F_RDLCK
        u = 2, -- F_UNLCK
        w = 3, -- F_WRLCK
    }
end

ffi.cdef(flock_def..[[
    int fileno(struct FILE *stream);
    int fcntl(int fd, int cmd, ... /* arg */ );
    int unlink(const char *path);
]])

local function lock(fd, mode, start, len)
    local flock = ffi_new('struct flock')
    flock.l_type = mode_ltype_map[mode]
    flock.l_whence = SEEK_SET
    flock.l_start = start or 0
    flock.l_len = len or 0
    if lib.fcntl(fd, F_SETLK, flock) == -1 then
        return nil, errno()
    end
    return true
end

function _M.lock(filehandle, mode, start, length)
    if mode ~= 'r' and mode ~= 'w' then
        error("lock: invalid mode")
    end
    if io_type(filehandle) ~= 'file' then
        error("lock: invalid file")
    end
    local fd = lib.fileno(filehandle)
    local ok, err = lock(fd, mode, start, length)
    if not ok then
        return nil, err
    end
    return true
end

function _M.unlock(filehandle, start, length)
    if io_type(filehandle) ~= 'file' then
        error("unlock: invalid file")
    end
    local fd = lib.fileno(filehandle)
    local ok, err = lock(fd, 'u', start, length)
    if not ok then
        return nil, err
    end
    return true
end

-- lock related
local dir_lock_struct = 'struct {char *lockname;}'
local function create_lockfile(dir_lock, path, lockname)
    dir_lock.lockname = ffi_new('char[?]', #lockname + 1, lockname)
    return lib.symlink(path, lockname) == 0
end

local function delete_lockfile(dir_lock)
    return lib.unlink(dir_lock.lockname)
end

local function unlock_dir(dir_lock)
    if dir_lock.lockname ~= nil then
        dir_lock:delete_lockfile()
        dir_lock.lockname = nil
    end
    return true
end

local dir_lock_type = ffi.metatype(dir_lock_struct,
    {__gc = unlock_dir,
    __index = {
        free = unlock_dir,
        create_lockfile = create_lockfile,
        delete_lockfile = delete_lockfile,
    }}
)

function _M.lock_dir(path, _)
    -- It's interesting that the lock_dir from vanilla lfs just ignores second parameter.
    -- So, I follow this behavior too :)
    local dir_lock = ffi_new(dir_lock_type)
    local lockname = path .. '/lockfile.lfs'
    if not dir_lock:create_lockfile(path, lockname) then
        return nil, errno()
    end
    return dir_lock
end

-- stat related
local stat_func
local lstat_func
if OS == 'Linux' then
    ffi.cdef([[
        long syscall(int number, ...);
    ]])
    local ARCH = ffi.arch
    -- Taken from justincormack/ljsyscall
    local stat_syscall_num
    local lstat_syscall_num
    if ARCH == 'x64' then
        ffi.cdef([[
            typedef struct {
                unsigned long   st_dev;
                unsigned long   st_ino;
                unsigned long   st_nlink;
                unsigned int    st_mode;
                unsigned int    st_uid;
                unsigned int    st_gid;
                unsigned int    __pad0;
                unsigned long   st_rdev;
                long            st_size;
                long            st_blksize;
                long            st_blocks;
                unsigned long   st_atime;
                unsigned long   st_atime_nsec;
                unsigned long   st_mtime;
                unsigned long   st_mtime_nsec;
                unsigned long   st_ctime;
                unsigned long   st_ctime_nsec;
                long            __unused[3];
            } stat;
        ]])
        stat_syscall_num = 4
        lstat_syscall_num = 6
    elseif ARCH == 'x86' then
        ffi.cdef([[
            typedef struct {
                unsigned long long      st_dev;
                unsigned char   __pad0[4];
                unsigned long   __st_ino;
                unsigned int    st_mode;
                unsigned int    st_nlink;
                unsigned long   st_uid;
                unsigned long   st_gid;
                unsigned long long      st_rdev;
                unsigned char   __pad3[4];
                long long       st_size;
                unsigned long   st_blksize;
                unsigned long long      st_blocks;
                unsigned long   st_atime;
                unsigned long   st_atime_nsec;
                unsigned long   st_mtime;
                unsigned int    st_mtime_nsec;
                unsigned long   st_ctime;
                unsigned long   st_ctime_nsec;
                unsigned long long      st_ino;
            } stat;
        ]])
        stat_syscall_num = IS_64_BIT and 106 or 195
        lstat_syscall_num = IS_64_BIT and 107 or 196
    elseif ARCH == 'arm' then
        if IS_64_BIT then
            ffi.cdef([[
                typedef struct {
                    unsigned long   st_dev;
                    unsigned long   st_ino;
                    unsigned int    st_mode;
                    unsigned int    st_nlink;
                    unsigned int    st_uid;
                    unsigned int    st_gid;
                    unsigned long   st_rdev;
                    unsigned long   __pad1;
                    long            st_size;
                    int             st_blksize;
                    int             __pad2;
                    long            st_blocks;
                    long            st_atime;
                    unsigned long   st_atime_nsec;
                    long            st_mtime;
                    unsigned long   st_mtime_nsec;
                    long            st_ctime;
                    unsigned long   st_ctime_nsec;
                    unsigned int    __unused4;
                    unsigned int    __unused5;
                } stat;
            ]])
            stat_syscall_num = 106
            lstat_syscall_num = 107
        else
            ffi.cdef([[
                typedef struct {
                    unsigned long long      st_dev;
                    unsigned char   __pad0[4];
                    unsigned long   __st_ino;
                    unsigned int    st_mode;
                    unsigned int    st_nlink;
                    unsigned long   st_uid;
                    unsigned long   st_gid;
                    unsigned long long      st_rdev;
                    unsigned char   __pad3[4];
                    long long       st_size;
                    unsigned long   st_blksize;
                    unsigned long long      st_blocks;
                    unsigned long   st_atime;
                    unsigned long   st_atime_nsec;
                    unsigned long   st_mtime;
                    unsigned int    st_mtime_nsec;
                    unsigned long   st_ctime;
                    unsigned long   st_ctime_nsec;
                    unsigned long long      st_ino;
                } stat;
            ]])
            stat_syscall_num = 195
            lstat_syscall_num = 196
        end
    elseif ARCH == 'ppc' or ARCH == 'ppcspe' then
        ffi.cdef([[
            typedef struct {
                unsigned long long st_dev;
                unsigned long long st_ino;
                unsigned int    st_mode;
                unsigned int    st_nlink;
                unsigned int    st_uid;
                unsigned int    st_gid;
                unsigned long long st_rdev;
                unsigned long long __pad1;
                long long       st_size;
                int             st_blksize;
                int             __pad2;
                long long       st_blocks;
                int             st_atime;
                unsigned int    st_atime_nsec;
                int             st_mtime;
                unsigned int    st_mtime_nsec;
                int             st_ctime;
                unsigned int    st_ctime_nsec;
                unsigned int    __unused4;
                unsigned int    __unused5;
            } stat;
        ]])
        stat_syscall_num = IS_64_BIT and 106 or 195
        lstat_syscall_num = IS_64_BIT and 107 or 196
    elseif ARCH == 'mips' or ARCH == 'mipsel' then
        ffi.cdef([[
            typedef struct {
                unsigned long   st_dev;
                unsigned long   __st_pad0[3];
                unsigned long long      st_ino;
                mode_t          st_mode;
                nlink_t         st_nlink;
                uid_t           st_uid;
                gid_t           st_gid;
                unsigned long   st_rdev;
                unsigned long   __st_pad1[3];
                long long       st_size;
                time_t          st_atime;
                unsigned long   st_atime_nsec;
                time_t          st_mtime;
                unsigned long   st_mtime_nsec;
                time_t          st_ctime;
                unsigned long   st_ctime_nsec;
                unsigned long   st_blksize;
                unsigned long   __st_pad2;
                long long       st_blocks;
                long __st_padding4[14];
            } stat;
        ]])
        stat_syscall_num = IS_64_BIT and 4106 or 4213
        lstat_syscall_num = IS_64_BIT and 4107 or 4214
    end

    if stat_syscall_num then
        stat_func = function(filepath, buf)
            return lib.syscall(stat_syscall_num, filepath, buf)
        end
        lstat_func = function(filepath, buf)
            return lib.syscall(lstat_syscall_num, filepath, buf)
        end
    else
        ffi.cdef('typedef struct {} stat;')
        stat_func = function() error("TODO support other Linux architectures") end
        lstat_func = stat_func
    end

elseif OS == 'OSX' then
    ffi.cdef([[
        struct timespec {
            time_t tv_sec;
            long tv_nsec;
        };
        typedef struct {
            uint32_t           st_dev;
            uint16_t          st_mode;
            uint16_t         st_nlink;
            uint64_t         st_ino;
            uint32_t           st_uid;
            uint32_t           st_gid;
            uint32_t           st_rdev;
            struct timespec st_atimespec;
            struct timespec st_mtimespec;
            struct timespec st_ctimespec;
            struct timespec st_birthtimespec;
            int64_t           st_size;
            int64_t        st_blocks;
            int32_t       st_blksize;
            uint32_t        st_flags;
            uint32_t        st_gen;
            int32_t         st_lspare;
            int64_t         st_qspare[2];
        } stat;
        int stat64(const char *path, stat *buf);
        int lstat64(const char *path, stat *buf);
    ]])
    stat_func = lib.stat64
    lstat_func = lib.lstat64
else
    ffi.cdef('typedef struct {} stat;')
    stat_func = function() error('TODO: support other posix system') end
    lstat_func = stat_func
end

local STAT = {
    FMT   = 0xF000,
    FSOCK = 0xC000,
    FLNK  = 0xA000,
    FREG  = 0x8000,
    FBLK  = 0x6000,
    FDIR  = 0x4000,
    FCHR  = 0x2000,
    FIFO  = 0x1000,
}

local ftype_name_map = {
    [STAT.FREG]  = 'file',
    [STAT.FDIR]  = 'directory',
    [STAT.FLNK]  = 'link',
    [STAT.FSOCK] = 'socket',
    [STAT.FCHR]  = 'char device',
    [STAT.FBLK]  = "block device",
    [STAT.FIFO]  = "named pipe",
}

local function mode_to_ftype(mode)
    local ftype = band(mode, STAT.FMT)
    return ftype_name_map[ftype] or 'other'
end

local function mode_to_perm(mode)
    local perm_bits = band(mode, tonumber(777, 8))
    local perm = new_tab(9, 0)
    local i = 9
    while i > 0 do
        local perm_bit = band(perm_bits, 7)
        perm[i] = (band(perm_bit, 1) > 0 and 'x' or '-')
        perm[i-1] = (band(perm_bit, 2) > 0 and 'w' or '-')
        perm[i-2] = (band(perm_bit, 4) > 0 and 'r' or '-')
        i = i - 3
        perm_bits = rshift(perm_bits, 3)
    end
    return concat(perm)
end

local function time_or_timespec(time, timespec)
    local t = tonumber(time)
    if not t and timespec then
        t = tonumber(timespec.tv_sec)
    end
    return t
end

local attr_handlers = {
    access = function(st) return time_or_timespec(st.st_atime, st.st_atimespec) end,
    blksize = function(st) return tonumber(st.st_blksize) end,
    blocks = function(st) return tonumber(st.st_blocks) end,
    change = function(st) return time_or_timespec(st.st_ctime, st.st_ctimespec) end,
    dev = function(st) return tonumber(st.st_dev) end,
    gid = function(st) return tonumber(st.st_gid) end,
    ino = function(st) return tonumber(st.st_ino) end,
    mode = function(st) return mode_to_ftype(st.st_mode) end,
    modification = function(st) return time_or_timespec(st.st_mtime, st.st_mtimespec) end,
    nlink = function(st) return tonumber(st.st_nlink) end,
    permissions = function(st) return mode_to_perm(st.st_mode) end,
    rdev = function(st) return tonumber(st.st_rdev) end,
    size = function(st) return tonumber(st.st_size) end,
    uid = function(st) return tonumber(st.st_uid) end,
}
local mt = {
    __index = function(self, attr_name)
        local func = attr_handlers[attr_name]
        return func and func(self)
    end
}
local stat_type = ffi.metatype('stat', mt)

-- Add target field for symlinkattributes, which is the absolute path of linked target
local get_link_target_path
if OS == 'Windows' then
    local ENOSYS = 40
    function get_link_target_path()
        return nil, "could not obtain link target: Function not implemented ",ENOSYS
    end
else
    ffi.cdef('ssize_t readlink(const char *path, char *buf, size_t bufsize);')
    function get_link_target_path(link_path, statbuf)
        local size = statbuf.st_size
        size = size == 0 and MAXPATH or size
        local buf = ffi.new('char[?]', size + 1)
        local read = lib.readlink(link_path, buf, size)
        if read == -1 then
            return nil, "could not obtain link target: "..errno(), ffi.errno()
        end
        if read > size then
            return nil, "not enought size for readlink: "..errno(), ffi.errno()
        end
        buf[size] = 0
        return ffi_str(buf)
    end
end

local stat_buf = ffi.new(stat_type)
local function attributes(filepath, attr, follow_symlink)
    local func = follow_symlink and stat_func or lstat_func
    if func(filepath, stat_buf) == -1 then
        return nil, string.format("cannot obtain information from file '%s' : %s",
                                  tostring(filepath),errno()), ffi.errno()
    end

    local atype = type(attr)
    if atype == 'string' then
        local value, err, errn
        if attr == 'target' and not follow_symlink then
            value, err, errn = get_link_target_path(filepath, stat_buf)
            return value, err, errn
        else
            value = stat_buf[attr]
        end
        if value == nil then
            error("invalid attribute name '" .. attr .. "'")
        end
        return value
    else
        local tab = (atype == 'table') and attr or {}
        for k, _ in pairs(attr_handlers) do
            tab[k] = stat_buf[k]
        end
        if not follow_symlink then
            tab.target = get_link_target_path(filepath, stat_buf)
        end
        return tab
    end
end

function _M.attributes(filepath, attr)
    return attributes(filepath, attr, true)
end

function _M.symlinkattributes(filepath, attr)
    return attributes(filepath, attr, false)
end

return _M
