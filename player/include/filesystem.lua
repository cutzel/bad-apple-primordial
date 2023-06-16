-- author: https://community.primordial.dev/members/onion.84/
-- message link: https://community.primordial.dev/threads/please-read-write-files.4201/post-28097

local filesystem = {} filesystem.__index = {}

filesystem.class = ffi.cast(ffi.typeof("void***"), memory.create_interface("filesystem_stdio.dll", "VBaseFileSystem011"))
filesystem.v_table = filesystem.class[0]

filesystem.casts = {
    read_file = ffi.cast("int (__thiscall*)(void*, void*, int, void*)", filesystem.v_table[0]),
    write_file = ffi.cast("int (__thiscall*)(void*, void const*, int, void*)", filesystem.v_table[1]),
    open_file = ffi.cast("void* (__thiscall*)(void*, const char*, const char*, const char*)", filesystem.v_table[2]),
    close_file = ffi.cast("void (__thiscall*)(void*, void*)", filesystem.v_table[3]),
    file_size = ffi.cast("unsigned int (__thiscall*)(void*, void*)", filesystem.v_table[7]),
    file_exists = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)", filesystem.v_table[10]),
}

filesystem.modes = {
    ["r"] = "r", ["w"] = "w", ["a"] = "a",
    ["r+"] = "r+", ["w+"] = "w+", ["a+"] = "a+",
    ["rb"] = "rb", ["wb"] = "wb", ["ab"] = "ab",
    ["rb+"] = "rb+", ["wb+"] = "wb+", ["ab+"] = "ab+",
}

filesystem.open = function(file, mode, id)
    if (not filesystem.modes[mode]) then error("Invalid Mode!") end

    local self = setmetatable({
        file = file,
        mode = mode,
        path_id = id,
        handle = filesystem.casts.open_file(filesystem.class, file, mode, id)
    }, filesystem)

    return self
end

filesystem.close = function(fs)
    filesystem.casts.close_file(filesystem.class, fs.handle)
end

filesystem.exists = function(file, id)
    return filesystem.casts.file_exists(filesystem.class, file, id)
end

filesystem.get_size = function(fs)
    return filesystem.casts.file_size(filesystem.class, fs.handle)
end

function filesystem.write(path, buffer)
    local fs = filesystem.open(path, "w", "MOD")
    filesystem.casts.write_file(filesystem.class, buffer, #buffer, fs.handle)
    filesystem.close(fs)
end

function filesystem.append(path, buffer)
    local fs = filesystem.open(path, "a", "MOD")
    filesystem.casts.write_file(filesystem.class, buffer, #buffer, fs.handle)
    filesystem.close(fs)
end

function filesystem.read(path)
    local fs = filesystem.open(path, "r", "MOD")
    local size = filesystem.get_size(fs)
    local output = ffi.new("char[?]", size + 1)
    filesystem.casts.read_file(filesystem.class, output, size, fs.handle)
    filesystem.close(fs)

    return ffi.string(output)
end

return filesystem
