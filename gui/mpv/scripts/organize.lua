local utils = require "mp.utils"

function get_path_info()
   local work_dir = mp.get_property_native("working-directory")
   local file_path = mp.get_property_native("path")
   local s = file_path:find(work_dir, 0, true)
   local final_path
   local final_name
   if s and s == 1 then
      final_path = file_path
      final_name = file_path:sub(work_dir:len() + 2)
   else
      final_path = utils.join_path(work_dir, file_path)
      final_name = file_path
   end
   if work_dir:lower() == 'c:\\windows\\system32' then
      work_dir, _ = utils.split_path(final_path)
   end
   mp.msg.info("final_path " .. final_path)
   mp.msg.info("final_name " .. final_name)
   mp.msg.info("work_dir " .. work_dir)
   return final_path, final_name, work_dir
end


function delete_file()
   mp.commandv('playlist-next', 'force')
   local path = get_path_info()
   if package.config:sub(1,1) == '\\' then
      utils.subprocess({ args={'cmd', '/c', 'del', path}, cancellable=false})
   else
      os.remove(path)
   end
end

function move_file(folder)
   return function()
      mp.commandv('playlist-next', 'force')
      local path, name, work_dir = get_path_info()
      local dest_dir = utils.join_path(work_dir, folder)
      local dest_path = utils.join_path(dest_dir, name)
      mp.msg.info("path " .. path)
      mp.msg.info("dest_dir " .. dest_dir)
      if not utils.file_info(dest_dir).is_dir then
         os.execute('mkdir "' .. dest_dir .. '"')
      end
      if package.config:sub(1,1) == '\\' then
         utils.subprocess({ args={'cmd', '/c', 'move', path, dest_dir}, cancellable=false})
      else
         os.rename(path, dest_path)
      end
   end
end


mp.add_key_binding("alt+d", "delete_file", delete_file)
mp.add_key_binding("alt+a", "move_a", move_file('a'))
mp.add_key_binding("alt+b", "move_b", move_file('b'))
mp.add_key_binding("alt+c", "move_c", move_file('c'))
mp.add_key_binding("alt+s", "move_s", move_file('s'))
mp.add_key_binding("alt+w", "move_w", move_file('w'))
