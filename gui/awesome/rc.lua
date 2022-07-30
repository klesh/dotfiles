-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
-- pcall(require, "luarocks.loader")
require("luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local common = require("awful.widget.common")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
-- local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
local mpdarc_widget = require("awesome-wm-widgets.mpdarc-widget.mpdarc")
local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")

--awful.spawn.once("pipewire")
--awful.spawn.once("pipewire-pulse")
--awful.spawn.with_shell("killall pipewire-media-session; sleep 2 && pipewire-media-session")
--awful.spawn("wireplumber")
-- &

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- Rounded corner
local function rounded_rect(radius)
    return function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, radius)
    end
end

local rrect = rounded_rect(8)

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.useless_gap = 5
beautiful.border_width = 3
beautiful.border_focus = "#5b97f7"
beautiful.wallpaper = nil
beautiful.font_name = "agave Nerd Font Mono"
beautiful.font = "agave Nerd Font 12"
beautiful.notification_width = 400
beautiful.notification_shape = rrect
beautiful.notification_border_width = 0
beautiful.notification_border_color = "#2e3440"
beautiful.notification_bg = "#2e3440"
beautiful.notification_fg = "#e1e1e1"
beautiful.notification_margin = 10
beautiful.notification_font = "serif 11"
beautiful.master_width_factor = 0.6
beautiful.border_normal = "#000000"
beautiful.tasklist_bg_minimize = "#000000"
beautiful.tasklist_bg_focus = "#aaaaaa"
beautiful.tasklist_fg_focus = "#000000"

-- This is used later as the default terminal and editor to run.
terminal = "alacritty -e fish"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.floating,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.fair,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "open terminal", terminal }
}
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
    menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
local cw = calendar_widget({
    theme = 'nord',
    placement = 'top_right',
    start_sunday = true,
    radius = 8,
    -- with customized next/previous (see table above)
    previous_month_button = 1,
    next_month_button = 3,
})

local charkeynames = {}
charkeynames["-"] = "KP_Subtract"
local function get_keyname(char)
    local name = charkeynames[char]
    if name ~= nil then
        return name
    end
    return char
end

mytextclock:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        cw.toggle()
    elseif button == 3 then
        local dt = os.date('*t')
        local ds = string.format("%4d-%02d-%02d", dt.year, dt.month, dt.day)

        for i = 1, #ds do
            local char = get_keyname(ds:sub(i, i))
            root.fake_input('key_press', char)
            root.fake_input('key_release', char)
        end

        --awful.spawn.with_shell(string.format("printf '%s' | /bin/xclip -b", ds))
        --io.popen("xclip -selection clipboard", "w"):write(ds):close()
        --awful.spawn(string.format("notify-send '%s'", ds))
    end
end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

client.connect_signal("manage", function(c)
    c.shape = rrect
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
beautiful.tasklist_shape = rounded_rect(3)
beautiful.taglist_shape = rounded_rect(3)
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    --awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    awful.tag({ " ", " ", " ", " " }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        layout  = {
            spacing = 10,
            layout = wibox.layout.fixed.horizontal,
        }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen          = s,
        filter          = awful.widget.tasklist.filter.currenttags,
        buttons         = tasklist_buttons,
        --layout  = {
        --spacing = 10,
        --forced_width = 100,
        --layout = wibox.layout.fixed.horizontal,
        --},
        update_function = function(w, buttons, label, data, clients, args)
            s.mytasklist.clientlist = clients
            --for k, v in pairs(data) do
            --gears.debug.print_error(string.format("k: %s, v: %s", k, v))
            --end
            common.list_update(w, buttons, label, data, clients, args)
        end
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = 50,
        opacity = 0.8,
        bg = "#00000000"
    })

    -- Add widgets to the wibox
    s.mywibox:setup(
        { -- margin
            { -- rounded backround
                { -- padding

                    {
                        layout = wibox.layout.align.horizontal,
                        { -- Left widgets
                            layout = wibox.layout.fixed.horizontal,
                            spacing = beautiful.useless_gap,
                            s.mylayoutbox,
                            s.mytaglist,
                            s.mypromptbox,
                        },
                        s.mytasklist, -- Middle widget
                        { -- Right widgets
                            layout = wibox.layout.fixed.horizontal,
                            spacing = 10,
                            --mykeyboardlayout,
                            mpdarc_widget,
                            volume_widget {
                                device = "default",
                                widget_type = "horizontal_bar",
                                with_icon = true,
                                bg_color = "#ffffff33",
                                step = 3
                            },
                            --cpu_widget({
                            --width = 70,
                            --step_width = 2,
                            --step_spacing = 0,
                            --color = '#434c5e'
                            --}),
                            batteryarc_widget(),
                            wibox.widget.systray(),
                            mytextclock,
                            logout_menu_widget {
                                onlogout   = awful.quit,
                                onpoweroff = function() awful.spawn.with_shell("loginctl poweroff") end,
                                onreboot   = function() awful.spawn.with_shell("loginctl reboot") end,
                                onlock     = function() awful.spawn.with_shell("loginctl lock-session") end,
                                onsuspend  = function() awful.spawn.with_shell("loginctl suspend") end,
                            },
                        },
                    },
                    top = 5,
                    left = 20,
                    right = 20,
                    bottom = 5,
                    widget = wibox.container.margin,
                },
                widget = wibox.container.background,
                bg = "#000000",
                shape = rrect,
            },
            widget = wibox.container.margin,
            top = 10,
            left = 10,
            right = 10,
            bottom = 0,
        })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}


-- Cursor follow focus
local function move_mouse_onto_focused_client(c)
    if mouse.object_under_pointer() ~= c then
        local geometry = c:geometry()
        local x = geometry.x + geometry.width / 2
        local y = geometry.y + geometry.height / 2
        mouse.coords({ x = x, y = y }, true)
    end
end

--client.connect_signal("focus", move_mouse_onto_focused_client)


-- {{{ Key bindings
local globalkeys = gears.table.join(
    awful.key({}, 'XF86AudioRaiseVolume', volume_widget.inc,
        { description = 'volume up', group = 'hotkeys' }),
    awful.key({}, 'XF86AudioLowerVolume', volume_widget.dec,
        { description = 'volume down', group = 'hotkeys' }),
    awful.key({}, 'XF86AudioMute', volume_widget.toggle,
        { description = 'toggle mute', group = 'hotkeys' }),
    awful.key({}, 'XF86AudioPlay', function() awful.spawn.with_shell("mpc toggle") end,
        { description = 'toggle play', group = 'hotkeys' }),
    awful.key({}, 'XF86AudioNext', function() awful.spawn.with_shell("mpc next") end,
        { description = 'toggle play', group = 'hotkeys' }),
    awful.key({}, 'XF86AudioPrev', function() awful.spawn.with_shell("mpc prev") end,
        { description = 'toggle play', group = 'hotkeys' }),
    awful.key({}, 'XF86MonBrightnessUp', function() awful.spawn.with_shell("sudo light -A 5") end,
        { description = 'increase backlight', group = 'control' }),
    awful.key({}, 'XF86MonBrightnessDown', function() awful.spawn.with_shell("sudo light -U 5") end,
        { description = 'decrease backlight', group = 'control' }),
    awful.key({}, 'F1', function() awful.spawn.with_shell("flameshot gui") end,
        { description = 'toggle mute', group = 'hotkeys' }),
    awful.key({ modkey }, '=', volume_widget.inc,
        { description = 'volume up', group = 'hotkeys' }),
    awful.key({ modkey }, '-', volume_widget.dec,
        { description = 'volume down', group = 'hotkeys' }),
    awful.key({ modkey }, '\\', function() awful.spawn.with_shell("mpc toggle") end,
        { description = 'toggle play', group = 'hotkeys' }),
    awful.key({ modkey }, '9', function() awful.spawn.with_shell("sudo light -U 5") end,
        { description = 'decrease backlight', group = 'control' }),
    awful.key({ modkey }, '0', function() awful.spawn.with_shell("sudo light -A 5") end,
        { description = 'increase backlight', group = 'control' }),
    --awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
    --{description = "show help", group="awesome"}),
    awful.key({ modkey, }, "comma", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "period", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    -- awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    --           {description = "go back", group = "tag"}),

    awful.key({ modkey, }, "Escape",
        function()
            cw.toggle(false)
            volume_widget:toggle(false)
            logout_menu_widget:toggle(false)
        end,
        { description = "close all widget", group = "control" }
    ),

    awful.key({ modkey, }, "j",
        function()
            local c = awful.client.next(1)
            awful.client.focus.byidx(1)
            move_mouse_onto_focused_client(c)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "k",
        function()
            local c = awful.client.next(-1)
            awful.client.focus.byidx(-1)
            move_mouse_onto_focused_client(c)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key({ modkey, }, "/",
        function()
            if client.focus == awful.client.getmaster() then
                awful.client.swap.byidx(1)
                awful.client.focus.byidx(-1)
            else
                move_mouse_onto_focused_client(awful.client.getmaster())
                awful.client.setmaster(client.focus)
            end
        end,
        { description = "swap master", group = "client" }
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),

    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, }, "`", function() awful.spawn("st -c st-256color-float -e /usr/bin/fish") end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }),

    awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }),

    -- Prompt
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }),

    awful.key({ modkey }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }),
    -- Launcher
    --awful.key({ modkey }, "p", function() awful.spawn.with_shell("dmenu_launcher") end,
    --          {description = "dmenu launcher", group = "launcher"}),
    awful.key({ modkey }, "p", function() awful.spawn.with_shell("rofi -show combi") end,
        { description = "rofi", group = "launcher" }),

    -- Bookmark
    awful.key({ modkey }, "b", function() awful.spawn.with_shell('BOOKMARK_SEARCHER="rofi -dmenu -p bookmark" bm') end,
        { description = "bookmark", group = "launcher" }),

    -- Dict.sh
    awful.key({ modkey }, "t",
        function() awful.spawn.with_shell('D_SELECTOR="rofi -dmenu -p dict.sh" d "$(xsel -o)"') end,
        { description = "dict.sh", group = "launcher" }),
    awful.key({ modkey }, "o",
        function() awful.spawn.with_shell('find ~/Nextcloud/notes/ | rofi -dmenu -title notes | xargs xdg-open') end,
        { description = "open note", group = "launcher" })
)

clientkeys = gears.table.join(
--awful.key({ modkey,           }, "f",
--function (c)
--c.fullscreen = not c.fullscreen
--c:raise()
--end,
--{description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey }, "q", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    --awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    --{description = "move to screen", group = "client"}),
    --awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
    --{description = "toggle keep on top", group = "client"}),
    awful.key({ modkey, }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- focus window.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                --filter  = awful.widget.tasklist.filter.currenttags,
                local screen = awful.screen.focused()
                local c = screen.mytasklist.clientlist[i]
                if c == nil then
                    return
                end
                if c.minimized then
                    c.minimized = false
                end
                client.focus = c
            end,
            { description = "view tag #" .. i, group = "tag" })
    ---- View tag only.
    --awful.key({ modkey }, "#" .. i + 9,
    --function ()
    --local screen = awful.screen.focused()
    --local tag = screen.tags[i]
    --if tag then
    --tag:view_only()
    --end
    --end,
    --{description = "view tag #"..i, group = "tag"}),
    ---- Toggle tag display.
    --awful.key({ modkey, "Control" }, "#" .. i + 9,
    --function ()
    --local screen = awful.screen.focused()
    --local tag = screen.tags[i]
    --if tag then
    --awful.tag.viewtoggle(tag)
    --end
    --end,
    --{description = "toggle tag #" .. i, group = "tag"}),
    ---- Move client to tag.
    --awful.key({ modkey, "Shift" }, "#" .. i + 9,
    --function ()
    --if client.focus then
    --local tag = client.focus.screen.tags[i]
    --if tag then
    --client.focus:move_to_tag(tag)
    --end
    --end
    --end,
    --{description = "move focused client to tag #"..i, group = "tag"}),
    ---- Toggle tag on focused client.
    --awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
    --function ()
    --if client.focus then
    --local tag = client.focus.screen.tags[i]
    --if tag then
    --client.focus:toggle_tag(tag)
    --end
    --end
    --end,
    --{description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

--- Bind a,s,d,f to tag 1,2,3,4
for i, key in pairs({ "a", "s", "d", "f" }) do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, key,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, key,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, key,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, key,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

-- global mouse buttons
local clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end),
    awful.button({}, 6, function()
        mousegrabber.run(function()
            volume_widget.dec()
            return false
        end, "mouse")
    end),
    awful.button({}, 7, function()
        mousegrabber.run(function()
            volume_widget.inc()
            return false
        end, "mouse")
    end)
)



local shift_on = false
local function toggle_shift()
    local event = "key_press"
    if shift_on then
        event = "key_release"
    end
    gears.debug.print_error("sending " .. event .. "Shift_L")
    root.fake_input(event, "Shift_L")
    shift_on = not shift_on
end

local socket = require "socket"
local buttonmacros = {
    -- [button] = {
    --     [clicks] = macro
    -- }
    [9] = {
        [2] = "Control_L+Page_Up",
    },
    [8] = {
        [2] = "Control_L+Page_Down",
    },
    [11] = {
        [1] = toggle_shift,
        [2] = "F5",
    },
    [12] = {
        [1] = "button_2",
        [2] = "Control_L+w",
        [3] = "Control_L+Shift_L+t",
    },
}
local buttonstate = {
    -- [button] = { timestamp1, timestamp2, ... }
}
local button_tapping_term = 0.5
local replaying = 0

-- check timeout and fireout combinations
gears.timer.start_new(0.1, function()
    for button, timestamps in pairs(buttonstate) do
        -- accumulate dued clicks
        local count = 0
        if #timestamps > 0 then
            local j = 2
            while j <= #timestamps and timestamps[j] - timestamps[j - 1] < button_tapping_term do
                j = j + 1
            end
            local i = j - 1
            if socket.gettime() - timestamps[i] > button_tapping_term then
                count = i
                repeat
                    table.remove(timestamps, i)
                    i = i - 1
                until i == 0
            end
        end
        -- send out keystrokes
        if count > 0 then
            gears.debug.print_error("counted " .. tostring(count) .. " times for " .. tostring(button))
            local macro = nil
            local macros = buttonmacros[button]
            if macros then
                macro = macros[count]
            end
            -- send macro if defined
            if macro then
                gears.debug.print_error("macro for " .. tostring(button) .. " " .. tostring(macro))
                if type(macro) == "function" then
                    macro()
                else
                    local stack = {}
                    for key in macro:gmatch("[^+]+") do
                        local type = "key"
                        local btn = key:match("^button_(%d+)")
                        if btn then
                            type = "button"
                            key = btn
                        end
                        root.fake_input(type .. "_press", key)
                        table.insert(stack, { type, key })
                    end
                    while #stack > 0 do
                        local key = table.remove(stack)
                        root.fake_input(key[1] .. "_release", key[2])
                    end
                end
                -- or replay clicks
            else
                gears.debug.print_error("replay " .. tostring(count) .. " times for " .. tostring(button))
                replaying = count
                -- mousegrabber.run(function(_)
                while count > 0 do
                    count = count - 1
                    root.fake_input("button_press", tonumber(button))
                    root.fake_input("button_release", tonumber(button))
                end
                -- end, "mouse")
            end
        end
    end
    return true
end)
-- bind button click event
for button in pairs(buttonmacros) do
    buttonstate[button] = {}
    gears.debug.print_error("register " .. tostring(button))
    local function f(c)
        if replaying > 0 then
            replaying = replaying - 1
            return
        end
        gears.debug.print_error("button clicked " .. tostring(button))
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        mousegrabber.run(function(_)
            local timestamps = buttonstate[button]
            table.insert(timestamps, socket.gettime())
            return false
        end, "mouse")
    end

    clientbuttons = gears.table.join(clientbuttons,
        awful.button({ "Shift" }, button, f),
        awful.button({}, button, f)
    )
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = {},
        properties = { border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
            "DTA", -- Firefox addon DownThemAll.
            "copyq", -- Includes session name in class.
            "pinentry",
            "file-roller",
        },
        class = {
            "flameshot",
            "Thunar",
            "Arandr",
            "Blueman-manager",
            "Gpick",
            "Kruler",
            "MessageWin", -- kalarm.
            "Sxiv",
            "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
            "Wpa_gui",
            "veromix",
            "st-256color-float",
            "xtightvncviewer"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
            "Event Tester", -- xev.
            "Message Filters",
        },
        role = {
            "AlarmWindow", -- Thunderbird's calendar.
            "ConfigManager", -- Thunderbird's about:config.
            "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
            "EventDialog",
            "Msgcompose",
        }
    }, properties = { floating = true, placement = awful.placement.centered } },

    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "normal", "dialog" }
    }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
--c:emit_signal("request::activate", "mouse_enter", {raise = false})
--end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    --c.border_width = 3
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    --c.border_width = 0
end)

awful.spawn.with_shell("~/.config/awesome/autostart")
