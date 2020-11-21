#!/usr/bin/env fish

set VSCP ~/.config/Code\ -\ OSS/User/workspaceStorage
echo $VSCP
for dir in (ls $VSCP)
    echo (du -h -d 0 $VSCP/$dir) (jq '.folder // .configuration.external' $VSCP/$dir/workspace.json -r)
end | sort -hr

