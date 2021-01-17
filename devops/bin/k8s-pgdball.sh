#!/bin/sh

set -e

if [ "$#" -lt 3 ] ;then
    echo "Backup/Restore all postgres databases on k8s container with pg_dump and gzip"
    echo
    echo "  Usage $0 <backup|restore> <path/to/backup/directory> <pod-app-label> [container-name] [DBN]"
    exit 1
fi

DIR=$(dirname "$(readlink -f "$0")")
BKD=$2
APP=$3
CTN=$4

POD=$(kubectl get pod --selector "app=$APP" | tail +2 | awk '{print $1}')
if [ -z "$POD" ] ; then
    echo not pod found!
    exit 1
elif [ "$(echo "$POD" | wc -w)" -gt 1 ] ;then
    echo more than one pod!
    exit 1
fi

backup () {
    mkdir -p "$BKD"
    for DBN in $(
        kubectl exec "$POD" -c "$CTN" -- \
            psql postgres postgres -c "SELECT datname FROM pg_database" | \
        tail +3 | head -n -2
    ); do
        case $DBN in
            postgres|template0|template1)
                ;;
            *)
                echo "backing up $DBN to $BKD/$DBN.sql.gz"
                "$DIR/k8s-pgdb.sh" backup "$BKD/$DBN.sql.gz" "$APP" "$CTN" "$DBN"
                ;;
        esac
    done
}

restore () {
    for BACKUPGZ in "$BKD"/*.sql.gz ;do
        "$DIR/pgdb.sh" restore "$BACKUPGZ"
    done
}


case $1 in
    backup)
        backup
        ;;
    restore)
        restore
        ;;
esac
