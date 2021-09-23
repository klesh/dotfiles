var beginPos, endPos

function markBegin() {
    beginPos = mp.get_property('time-pos')
    mp.osd_message('Begin Position Marked at ' + beginPos)
}

function markEnd() {
    endPos = mp.get_property('time-pos')
    mp.osd_message('End Position Marked at ' + endPos)
}

function getMarked() {
    if (!beginPos && !endPos) {
        mp.osd_message('Please set Begin Position with Ctrl-b, End Position with Ctrl-e')
        return
    }
    var ss = beginPos || 0
    var t = endPos || mp.get_property('duration')
    var path = mp.get_property('path')
    var dir_file = mp.utils.split_path(path)
    return {
        dir: dir_file[0],
        file: dir_file[1],
        path: path,
        ss: ss,
        t: t
    }
}

function outputMarked() {
    var m = getMarked()
    var output_dir = mp.utils.join_path(m.dir, 'clips')
    mp.utils.subprocess({
        args: ['mkdir', '-p', output_dir],
        cancellable: false
    })
    output_file = mp.utils.join_path(output_dir, m.file)
    mp.utils.subprocess({
        args: ['ffmpeg', '-ss', ss, '-i', m.path, '-t', t, '-c', 'copy', output_file],
        cancellable: false
    })
    mp.osd_message('Clip save to ' + output_file)
}

function copyCutCmd() {
    var m = getMarked()
    var cmd = 'ffmpeg -ss ' + m.ss + ' -i ' + "'" + m.file + "' -t " + m.t + " -c copy '"+m.file + "-" + (Math.floor(m.ss/60)) +"'"
    mp.utils.subprocess({
        args: ['powershell', '-NoProfile', '-Command', 'Set-Clipboard "'+cmd+'"'],
        cancellable: false
    })
    mp.osd_message("command has been copied to your clipboard")
}



mp.add_key_binding("ctrl+b", "mark_begin", markBegin);
mp.add_key_binding("ctrl+e", "mark_end", markEnd);
mp.add_key_binding("ctrl+o", "output_marked", outputMarked);
mp.add_key_binding("ctrl+shift+o", "copy_cut_cmd", copyCutCmd);
