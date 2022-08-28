#!/usr/bin/env lua
--[[
requirement: sudo luarocks install http json-lua
A simple HTTP server
If a request is not a HEAD method, then reply with "Hello world!"
Usage: lua examples/server_hello.lua [<port>]
]]

local http_server = require "http.server"
local http_headers = require "http.headers"
local json = require "JSON"

local function NewHttpServer(host, port, handlers)
    local function reply(myserver, stream) -- luacheck: ignore 212
        -- Read in headers
        local req_headers = assert(stream:get_headers())
        local req_method = req_headers:get ":method"
        local req_path = req_headers:get ":path"

        -- Log request to stdout
        assert(io.stdout:write(string.format('[%s] "%s %s HTTP/%g"  "%s" "%s"\n',
            os.date("%d/%b/%Y:%H:%M:%S %z"),
            req_method or "",
            req_headers:get(":path") or "",
            stream.connection.version,
            req_headers:get("referer") or "-",
            req_headers:get("user-agent") or "-"
        )))

        --  Handle request
        local status = 404
        local res_body = { message = "Resource Not Found" }
        local handle_key = string.format("%s %s", req_method, req_path)
        local handler = handlers[handle_key]
        if handler then
            local req_body = nil
            if req_method == "POST" or req_method == "PUT" then
                req_body = json:decode(stream:get_body_as_string(0))
            end
            status, res_body = handler(req_body, req_headers)
            status = status or 200
        end

        -- Build response headers
        local res_headers = http_headers.new()
        res_headers:append(":status", tostring(status))
        res_headers:append("content-type", "application/json")
        res_headers:append("Access-Control-Allow-Origin", "*")
        -- Send headers to client; end the stream immediately if this was a HEAD request
        assert(stream:write_headers(res_headers, req_method == "HEAD"))
        if req_method ~= "HEAD" then
            -- Send body, ending the stream
            assert(stream:write_chunk(json:encode(res_body), true))
        end
    end

    local myserver = assert(http_server.listen {
        host = host or "localhost";
        port = port;
        onstream = reply;
        onerror = function(myserver, context, op, err, errno) -- luacheck: ignore 212
            local msg = op .. " on " .. tostring(context) .. " failed"
            if err then
                msg = msg .. ": " .. tostring(err)
            end
            assert(io.stderr:write(msg, "\n"))
        end;
    })
    assert(myserver:listen())
    do
        local bound_port = select(3, myserver:localname())
        assert(io.stderr:write(string.format("Now listening on port %d\n", bound_port)))
    end
    assert(myserver:loop())
    return myserver
end

-- NewHttpServer("127.0.0.1", 10200, {
--     ["POST /test"] = function(body, _)
--         return 200, { message = body }
--     end,
-- })
