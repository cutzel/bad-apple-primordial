local filesystem = require("filesystem")

local MAX_FPS = 30

local screen = {}

for y = 1, 40 do
    for group_index = 1, 4 do
        menu.set_group_column("group" .. group_index, group_index)
        local text = menu.add_text("group" .. group_index, "t")
        local screen_part = {}
        for x = 1, 14 do
            table.insert(
                screen_part,
                text:add_color_picker("a", color_t(127, 0, 0))
            )
        end

        -- reverse it since we go from right to left
        for i = #screen_part, 1, -1 do
            table.insert(screen, screen_part[i])
        end
    end
end

function render(screen_string)
    print(#screen_string)
    for i = 1, #screen_string do
        local char = screen_string:sub(i,i)
        local byte = string.byte(char)
        local color_picker = screen[i]

        v = string.byte(char)

        color_picker:set(color_t(v, v, v))
    end
end

local cur_frame = 1
local last_frame_delay = 0
local last_frame_timestamp = globals.real_time()

callbacks.add(e_callbacks.PAINT, function()
    -- roughly is a number
    if last_frame_delay > 1/MAX_FPS then
        local filename = string.format("bad_apple_multicolor/frame%05d.bin", cur_frame)
        
        if filesystem.exists(filename) then
            local file = filesystem.open(filename, "r", "MOD")
            local size = filesystem.get_size(file)
            print("size: " .. size)
            local output = ffi.new("char[?]", size + 1)
            filesystem.casts.read_file(filesystem.class, output, size, file.handle)
            filesystem.close(file)
            
            render(ffi.string(output, size))
            last_frame_delay = last_frame_delay - 1/MAX_FPS
            cur_frame = cur_frame + 1
        end
        return
    end

    local time_delta = globals.real_time() - last_frame_timestamp
    last_frame_delay = last_frame_delay + time_delta
    last_frame_timestamp = globals.real_time()
end)
