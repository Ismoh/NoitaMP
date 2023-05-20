function load_minhook(path)
    local minhook = {}
    local ffi = require("ffi")

    local dll_path = path .. "/luajit_minhook.dll"

    local lib = ffi.load(dll_path)
    minhook.lib = lib
    _G["__minhook_dont_unload"] = lib

    ffi.cdef([[
    bool mh_initialize();
    bool mh_uninitialize();
    void* mh_create_hook(void* function, void* detour);
    bool mh_remove_hook(void* function);
    bool mh_enable_hook(void* function);
    bool mh_disable_hook(void* function);

    void (*real_GameScreenshake)(struct CameraWorld*, struct vec2*);
    void GameScreenshake_hook_target(struct CameraWorld* camera, struct vec2* pos, float strength);
    void __thiscall GameScreenshake_xmm1_shim(struct CameraWorld* camera, struct vec2* pos);

    // std::string utility functions
    size_t std_string_size(const struct std_string* str);
    const char* std_string_c_str(const struct std_string* str);
    char* std_string_data(struct std_string* str);

    struct std_string* std_string_new(const char* cstr);
    struct std_string* std_string_new_n(const char* cstr, size_t n);
    void std_string_delete(struct std_string* str);

    void std_string_assign(struct std_string* str, const char* cstr);
    void std_string_assign_n(struct std_string* str, const char* cstr, size_t n);

    bool std_string_eq(const struct std_string* str, const char* cstr);
    int std_string_cmp(const struct std_string* str, const char* cstr);
    int std_string_cmp_n(const struct std_string* str, const char* cstr, size_t n);
    ]])

    minhook.initialize = lib.mh_initialize
    minhook.uninitialize = lib.mh_initialize
    minhook.remove = lib.mh_remove_hook
    minhook.enable = lib.mh_enable_hook
    minhook.disable = lib.mh_disable_hook

    function is_function_pointer(typ)
        return tostring(typ):find("(*)") ~= nil
    end

    -- Returns a function pointer type when the given type is a function or
    -- function pointer.
    function function_pointer_type(typ)
        if is_function_pointer(typ) then
            return typ
        end

        local new_type = ffi.typeof("$*", typ)
        if not is_function_pointer(new_type) then
            error("Given type is not a function or function pointer")
        end

        return new_type
    end

    function minhook.create_hook(func, hook)
        local func_type = function_pointer_type(ffi.typeof(func))
        local hook_func = ffi.cast(func_type, hook)
        local ret = lib.mh_create_hook(func, hook_func)

        if ret == nil then
            return nil
        end

        local original = ffi.cast(func_type, ret)
        return {
            func = func,
            hook_func = hook_func,
            original = original
        }
    end

    minhook.string_size = lib.std_string_size
    minhook.string_c_str = lib.std_string_c_str
    minhook.string_data = lib.std_string_data
    minhook.string_new = lib.std_string_new
    minhook.string_new_n = lib.std_string_new_n
    minhook.string_delete = lib.std_string_delete
    minhook.string_assign = lib.std_string_assign
    minhook.string_assign_n = lib.std_string_assign_n
    minhook.string_eq = lib.std_string_eq
    minhook.string_cmp = lib.std_string_cmp
    minhook.string_cmp_n = lib.std_string_cmp_n

    return minhook
end

return load_minhook
