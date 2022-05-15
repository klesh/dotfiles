#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"


makeinstallrepo https://gitee.com/klesh/st.git st

