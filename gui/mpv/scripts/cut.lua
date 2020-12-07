local utils = require "mp.utils"

function mark_begin()
    begin_pos = mp.get_property('time-pos')
    mp.osd_message('Begin Position Marked at ' .. begin_pos)
end

function mark_end()
    end_pos = mp.get_property('time-pos')
    mp.osd_message('End Position Marked at ' .. end_pos)
end

function output_marked()
    --if not begin_pos and not end_pos then
        --mp.osd_message('Please set Begin Position with Ctrl-b, End Position with Ctrl-e')
        --return
    --end
    ss = begin_pos or 0
    t = end_pos or mp.get_property('duration')
    path = mp.get_property('path')
    dir, file = utils.split_path(path)
    output_dir = utils.join_path(dir, 'clips')
    utils.subprocess({
        args={'mkdir', '-p', output_dir},
        cancellable=false
    })
    output_file = utils.join_path(output_dir, file)
    utils.subprocess({
        args={'ffmpeg', '-i', path, '-ss', tostring(ss), '-t', tostring(t), '-c', 'copy', output_file},
        cancellable=false
    })
    mp.osd_message('Clip save to ' .. output_file)
end


mp.add_key_binding("ctrl+b", "mark_begin", mark_begin);
mp.add_key_binding("ctrl+e", "mark_end", mark_end);
mp.add_key_binding("ctrl+o", "output_marked", output_marked);
