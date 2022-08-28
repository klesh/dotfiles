local httpserver = require "httpserver"
local CACHE_DIR = "~/Videos/virtcam"

local function run(cmd)
    print(cmd)
    local proc = io.popen(cmd .. " >/tmp/virtcam.log 2>&1")
    assert(proc)
    assert(proc:close())
end

run("sudo modprobe v4l2loopback -r -f")
run("sudo modprobe v4l2loopback video_nr=21 card_label=virtcam exclusive_caps=1")
run("mkdir -p " .. CACHE_DIR)

Ffmpeg = { cmd = "", proc = nil, name = "", started = false }

function Ffmpeg:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Ffmpeg:start()
    assert(self.proc == nil)
    self.proc = io.popen(self.cmd .. " >/tmp/virtcam.log 2>&1", "w")
    assert(self.proc)
    print(self.name .. " started")
    self.started = true
end

function Ffmpeg:stop()
    assert(self.proc)
    self.proc:write("q")
    self.proc:flush()
    assert(self.proc:close())
    self.proc = nil
    print(self.name .. " stopped")
    self.started = false
end

Actualcam = Ffmpeg:new {
    name = "actualcam",
    cmd = "ffmpeg -i /dev/video0 -vcodec copy -f v4l2 /dev/video21",
}


Recorder = Ffmpeg:new {
    name = "recorder",
    cmd = "ffmpeg -y -i /dev/video21 " .. CACHE_DIR .. "/seq.mp4",
}

Looper = Ffmpeg:new {
    name = "looper",
    cmd = "ffmpeg -re -stream_loop -1 -i " ..
        CACHE_DIR .. "/loop.mp4 -f v4l2 -vcodec rawvideo -pix_fmt yuyv422 -framerate 30 /dev/video21 ",
}


local all = { Actualcam, Recorder, Looper }

local function run_only(the_one)
    for _, fp in ipairs(all) do
        if fp ~= the_one and fp.started then
            fp:stop()
        end
    end
    if the_one and not the_one.started then
        print("try to start")
        the_one:start()
    end
end

local stage = "stopped"

httpserver.NewHttpServer("127.0.0.1", 10200, {
    ["POST /prepare"] = function(_, _)
        if stage == "stopped" then
            -- run("pactl set-source-mute @DEFAULT_SOURCE@ 1")
            run_only(Actualcam)
            stage = "actual"
        end
    end,
    ["POST /actual"] = function(_, _)
        if stage ~= "actual" then
            -- run("pactl set-source-mute @DEFAULT_SOURCE@ 0")
            run_only(Actualcam)
            stage = "actual"
        end
    end,
    ["POST /fake"] = function(_, _)
        if stage ~= "fake" then
            -- run("pactl set-source-mute @DEFAULT_SOURCE@ 1")
            run_only(Actualcam)
            Recorder:start()
            run("sleep 3")
            Recorder:stop()
            run("ffmpeg -y -i " .. CACHE_DIR .. "/seq.mp4 -vf reverse " .. CACHE_DIR .. "/reversed.mp4")
            run("ffmpeg -y -i " ..
                CACHE_DIR ..
                "/seq.mp4 -i " ..
                CACHE_DIR ..
                "/reversed.mp4 -filter_complex '[0:v] [1:v] concat=n=2:v=1 [v]' -map '[v]' " .. CACHE_DIR .. "/loop.mp4")
            run_only(Looper)
            stage = "fake"
        end
    end,
    ["POST /stop"] = function(_, _)
        if stage ~= "stopped" then
            run_only(nil)
            stage = "stopped"
        end
    end,
    ["POST /toggle-mute"] = function(_, _)
        run("pactl set-source-mute @DEFAULT_SOURCE@ toggle")
    end,
    ["POST /mute"] = function(_, _)
        run("pactl set-source-mute @DEFAULT_SOURCE@ 1")
    end,
})
