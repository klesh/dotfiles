#!/bin/sh

grep -qv '^\sload-module module-echo-cancel' /etc/pulse/default.pa ||
    echo 'load-module module-echo-cancel source_name=noechosource sink_name=noechosink' > /etc/pulse/default.pa

pactl
